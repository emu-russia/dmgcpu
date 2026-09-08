#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
vcd2png.py -- standalone VCD -> PNG waveform renderer
=====================================================

Renders Icarus Verilog VCD value-change dumps as a PNG image of signal
traces, using only the Python standard library plus Pillow (PIL).

Usage:
    python3 vcd2png.py <input.vcd> <output.png> \
        [--cfg <cfg.json>] [--t0 <ns>] [--t1 <ns>] \
        [--height <px>] [--ppx <pixels-per-ns>]

CLI semantics:
    --cfg   optional JSON config selecting signal groups (see below).
            Without --cfg every *leaf* signal with fewer than
            --max-changes value changes is drawn, grouped by its
            $scope path prefix.
    --t0/--t1   time window in ns (defaults: full dump range).
    --height    total image height in px (default: auto = sum of rows).
    --ppx       pixels per ns.  Default auto: the full window is fitted
                into about 2000 px of waveform column.

Config file format (--cfg):
    { "signals": [
        {"name": "Group title",
         "signals": ["scope.path.sig", "scope.path.bus[7:0]", ...],
         "bus": "hex" | "bits"},     # optional; matters for vector signals
        ...
      ]
    }

    * default / "hex": vectors drawn as a single thin blue line whose
      height is the numeric value between two horizontal rails, with the
      current value printed in hex above the line where a run is wide
      enough.
    * "bits": expands the vector into individual per-bit rows, MSB on
      top, named e.g. h[7] ... h[0].

Value-change records understood:
    scalar : 0/1/x/z immediately followed by the (possibly multi-char)
             identifier code (one whitespace separated token).
    vector : 'b' + bit string (MSB first, may contain 0/1/x/z and may
             drop leading zeros, e.g. "b0"), then a separate
             whitespace-separated identifier-code token.
    time   : '#<integer>' lines.

Output is deterministic for identical inputs.
"""

import argparse
import json
import math
import os
import re
import sys

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError as exc:  # pragma: no cover
    sys.stderr.write("vcd2png: Pillow (PIL) is required: %s\n" % exc)
    sys.exit(2)

# --------------------------------------------------------------------------
# constants
# --------------------------------------------------------------------------

AUTO_MAX_CHANGES = 200       # default (no --cfg) leaf-signal change filter
CFG_HARD_CAP = 50000         # per-signal safety cap for --cfg selected signals
DATA_WIDTH_GOAL = 2000       # default ppx fits the window in ~this many px

NAME_FONT_PX = 12
HDR_FONT_PX = 13
LBL_FONT_PX = 10
AX_FONT_PX = 10

ROW_H_SCALAR = 16
ROW_H_HEADER = 19
ROW_H_BUS = 26
GROUP_GAP = 4
AXIS_H = 20
MARGIN_TOP = 4
MARGIN_BOT = 2
MARGIN_L = 6
MARGIN_R = 6
NAME_GAP = 8                  # extra space after the name column

COL_HI = (0, 192, 0)          # value 1 rail      (#00c000)
COL_LO = (0, 0, 0)            # value 0 rail      (black)
COL_X_FILL = (255, 212, 212)  # x zone fill       (light red)
COL_X_HATCH = (216, 40, 40)   # x cross hatch     (red)
COL_Z_FILL = (228, 228, 228)  # z zone fill       (light gray)
COL_Z_HATCH = (190, 190, 190)
COL_BUS = (16, 56, 200)       # bus value polyline (blue)
COL_BUS_LABEL = (12, 40, 150)
COL_GUIDE = (206, 206, 206)   # bus rail guides
COL_GRID = (240, 240, 240)
COL_HDR_BG = (236, 241, 247)
COL_HDR_TEXT = (14, 34, 70)
COL_TEXT = (0, 0, 0)
COL_AXIS = (64, 64, 64)
COL_ROW_EDGE = (233, 233, 233)

SYNTH_NAME_RE = re.compile(r"^(w\d+|bus\d+_\d+|\d+)$")
SYNTH_SCOPE_RE = re.compile(r"^g\d+$")

_FONT_CACHE = {}


def eprint(*a):
    print(*a, file=sys.stderr)


# --------------------------------------------------------------------------
# font helpers
# --------------------------------------------------------------------------

_FONT_FILES = [
    # (regular, bold)
    ("/mnt/c/Windows/Fonts/consola.ttf", "/mnt/c/Windows/Fonts/consolab.ttf"),
    ("/mnt/c/Windows/Fonts/cour.ttf", "/mnt/c/Windows/Fonts/courbd.ttf"),
    ("/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf",
     "/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf"),
    ("/usr/share/fonts/truetype/liberation/LiberationMono-Regular.ttf",
     "/usr/share/fonts/truetype/liberation/LiberationMono-Bold.ttf"),
]


def load_font(size, bold=False):
    """Load a monospace font at 'size' px; fall back to the default font."""
    key = (size, bold)
    if key in _FONT_CACHE:
        return _FONT_CACHE[key]
    font = None
    for reg, bld in _FONT_FILES:
        path = bld if bold else reg
        if path and os.path.isfile(path):
            try:
                font = ImageFont.truetype(path, size)
                break
            except Exception:
                font = None
    if font is None:
        font = ImageFont.load_default()
    _FONT_CACHE[key] = font
    return font


def text_w(draw, text, font):
    """Text width in px using the (possibly default) font."""
    try:
        return int(math.ceil(draw.textlength(text, font=font)))
    except Exception:
        return int(math.ceil(len(text) * 6.0))


def text_h(font):
    try:
        bb = font.getbbox("Agjpy")
        return bb[3] - bb[1]
    except Exception:
        return 12


# --------------------------------------------------------------------------
# VCD parsing
# --------------------------------------------------------------------------

class Signal(object):
    __slots__ = ("vid", "path", "name", "base", "width", "range_str",
                 "msb", "lsb", "vartype", "synthetic", "unsupported")

    def __init__(self):
        self.vid = None
        self.path = ""          # dotted scope path, no trailing '.'
        self.name = ""          # display name incl. range, e.g. h[7:0]
        self.base = ""          # name without the range
        self.width = 1
        self.range_str = None
        self.msb = None
        self.lsb = None
        self.vartype = "wire"
        self.synthetic = False
        self.unsupported = False

    def fullpath(self):
        return (self.path + "." + self.name) if self.path else self.name


def _parse_timescale_unit(text):
    """'1ns' -> ns per time unit (float).  Unparseable -> 1.0"""
    m = re.fullmatch(r"\s*([0-9]+)\s*(ps|ns|us|ms|s)\s*", text)
    if not m:
        return 1.0
    n = int(m.group(1))
    unit = m.group(2)
    return n * {"ps": 1e-3, "ns": 1.0, "us": 1e3, "ms": 1e6, "s": 1e9}[unit]


class VCDReader(object):
    """Parse $scope/$var declarations; then stream value changes."""

    def __init__(self, path):
        self.path = path
        self.ns_per_unit = 1.0
        self.by_path = {}      # full dotted path -> Signal
        self.by_id = {}        # id code -> Signal (first declaration wins)
        self.decl_order = []   # full paths in declaration order
        self.t_min = 0.0
        self.t_max = 0.0
        self._parse_declarations()

    # -- declaration pass --------------------------------------------------
    def _parse_declarations(self):
        hier = []
        with open(self.path, "r", errors="replace") as f:
            for line in f:
                s = line.strip()
                if not s:
                    continue
                if s.startswith("$var"):
                    toks = s.split()
                    if len(toks) >= 6 and toks[-1] == "$end":
                        vartype = toks[1]
                        try:
                            width = int(toks[2])
                        except ValueError:
                            width = 1
                        vid = toks[3]
                        base = toks[4]
                        rng = None
                        for t in toks[5:-1]:
                            if re.fullmatch(r"\[[0-9]+:[0-9]+\]", t):
                                rng = t
                        sig = Signal()
                        sig.vid = vid
                        sig.path = ".".join(hier)
                        sig.base = base
                        sig.vartype = vartype
                        sig.range_str = rng
                        if vartype == "real":
                            sig.unsupported = True
                        if rng:
                            mm = re.fullmatch(r"\[([0-9]+):([0-9]+)\]", rng)
                            sig.msb = int(mm.group(1))
                            sig.lsb = int(mm.group(2))
                            sig.width = abs(sig.msb - sig.lsb) + 1
                            sig.name = base + rng
                        else:
                            sig.width = max(1, width)
                            sig.msb = width - 1
                            sig.lsb = 0
                            sig.name = base
                        sig.synthetic = bool(SYNTH_NAME_RE.match(base))
                        fp = sig.fullpath()
                        self.by_path[fp] = sig
                        self.decl_order.append(fp)
                        if vid not in self.by_id:
                            self.by_id[vid] = sig
                elif s.startswith("$scope"):
                    m = re.match(r"\$scope\s+\S+\s+(\S+)", s)
                    if m:
                        hier.append(m.group(1))
                elif s.startswith("$upscope"):
                    if hier:
                        hier.pop()
                elif s.startswith("$enddefinitions"):
                    break
        # timescale
        with open(self.path, "r", errors="replace") as f:
            for line in f:
                if line.strip() == "$timescale":
                    nxt = f.readline()
                    if nxt:
                        self.ns_per_unit = _parse_timescale_unit(nxt)
                    break

    # -- resolve user requested names --------------------------------------
    def resolve(self, wanted_names):
        """Map cfg signal names to Signal objects.  Exact full-path match
        first, then dotted-suffix match.  Warns on missing/ambiguous."""
        out = []
        for w in wanted_names:
            w = (w or "").strip()
            if not w:
                continue
            sig = self.by_path.get(w)
            if sig is not None:
                out.append(sig)
                continue
            matches = [fp for fp in self.decl_order if fp.endswith(w)]
            if not matches and "[" not in w:
                # requested a vector by its base name only
                matches = [fp for fp in self.decl_order
                           if self.by_path[fp].base == w and
                           self.by_path[fp].path.endswith(
                               w.rsplit(".", 1)[0])]
            if len(matches) == 1:
                out.append(self.by_path[matches[0]])
            elif len(matches) > 1:
                eprint("vcd2png: warning: signal %r ambiguous (%d matches: "
                       "%s); skipped" % (w, len(matches),
                                         ", ".join(matches[:5])))
            else:
                eprint("vcd2png: warning: configured signal %r not found in "
                       "VCD; skipped" % w)
        return out

    # -- value-change pass ---------------------------------------------------
    def stream_values(self, want_ids, auto_mode, auto_max=AUTO_MAX_CHANGES):
        """Stream the value section.

        want_ids : set of id codes whose full data must be kept.
        auto_mode: keep data for every declared id until it exceeds
                   'auto_max' changes, then drop it.

        Returns (changes, counts, tmax, tmin, dropped):
          changes : dict id -> list[(time_ns, payload)]
                    payload is a scalar char ('0','1','x','z') for
                    width-1 vars, else a bit string of length == width
                    (MSB first, lower-cased, leading zeros preserved).
          counts  : dict id -> total number of changes
          dropped : dict id -> data discarded due to a cap
        """
        changes = {}
        counts = {}
        dropped = {}
        cur_t = 0.0
        factor = self.ns_per_unit
        tmax = 0.0
        tmin = None

        def add_change(vid, payload, t):
            if vid not in self.by_id:
                return
            n = counts.get(vid, 0) + 1
            counts[vid] = n
            if vid in dropped:
                return
            if auto_mode and vid not in want_ids:
                return
            cap = auto_max if auto_mode else CFG_HARD_CAP
            if n > cap:
                if not auto_mode:
                    eprint("vcd2png: warning: signal %s exceeds %d changes; "
                           "data dropped" % (self.by_id[vid].fullpath(), cap))
                dropped[vid] = True
                changes.pop(vid, None)
                return
            lst = changes.get(vid)
            if lst is None:
                lst = changes[vid] = []
            lst.append((t, payload))

        with open(self.path, "r", errors="replace") as f:
            in_values = False
            for line in f:
                s = line.strip()
                if not s:
                    continue
                if s.startswith("$"):
                    if s.startswith("$enddefinitions"):
                        in_values = True
                    continue
                if not in_values:
                    continue
                if s.startswith("#"):
                    try:
                        cur_t = int(s[1:]) * factor
                    except ValueError:
                        continue
                    if cur_t > tmax:
                        tmax = cur_t
                    if tmin is None or cur_t < tmin:
                        tmin = cur_t
                    continue
                # value-change records (possibly several per line)
                toks = s.split()
                i = 0
                while i < len(toks):
                    t = toks[i]
                    if t.startswith("b") and len(t) > 1:
                        bits = t[1:]
                        if i + 1 >= len(toks):
                            break
                        vid = toks[i + 1]
                        i += 2
                        sig = self.by_id.get(vid)
                        if sig is not None and not sig.unsupported:
                            add_change(vid, self._pad_bits(bits, sig.width),
                                       cur_t)
                    elif t == "b":
                        # defensive: value in the next token
                        if i + 2 < len(toks):
                            bits = toks[i + 1]
                            vid = toks[i + 2]
                            i += 3
                            sig = self.by_id.get(vid)
                            if sig is not None and not sig.unsupported:
                                add_change(vid,
                                           self._pad_bits(bits, sig.width),
                                           cur_t)
                    else:
                        if len(t) < 2:
                            i += 1
                            continue
                        vid = t[1:]
                        sig = self.by_id.get(vid)
                        if sig is not None and not sig.unsupported:
                            add_change(vid, _norm_state(t[0]), cur_t)
                        i += 1
        if tmin is None:
            tmin = 0.0
        return changes, counts, tmax, tmin, dropped

    @staticmethod
    def _pad_bits(bits, width):
        bits = bits.lower()
        if len(bits) > width:
            bits = bits[:width]
        if len(bits) < width:
            bits = "0" * (width - len(bits)) + bits
        return bits


def _norm_state(ch):
    """normalize a scalar value char to 0/1/x/z."""
    c = ch.lower()
    if c in ("0", "l", "n"):
        return "0"
    if c in ("1", "h", "p"):
        return "1"
    if c in ("x", "u", "w"):
        return "x"
    if c == "z":
        return "z"
    return "x"


# --------------------------------------------------------------------------
# trace interpretation
# --------------------------------------------------------------------------

def trace_states(sig, changes_list):
    """Per-change row states for a signal.

    Returns (states, width): width-1 vars -> '0'/'1'/'x'/'z' chars;
    wider vars -> int values, or 'x'/'z' when any bit is unknown/tri."""
    if sig.width == 1:
        st = []
        for (_t, p) in changes_list:
            if isinstance(p, str) and len(p) >= 1:
                st.append(p[0])
            else:
                st.append("x")
        return st, 1
    st = []
    for (_t, p) in changes_list:
        if not isinstance(p, str):
            st.append(p)
        elif "x" in p:
            st.append("x")
        elif "z" in p:
            st.append("z")
        else:
            try:
                st.append(int(p, 2))
            except ValueError:
                st.append("x")
    return st, sig.width


def bit_index_sequence(sig):
    """Ordered bit indices from MSB to LSB per the declared range."""
    if sig.range_str is None:
        return list(range(sig.width - 1, -1, -1))
    if sig.msb >= sig.lsb:
        return list(range(sig.msb, sig.lsb - 1, -1))
    return list(range(sig.msb, sig.lsb + 1))


def bit_char(payload, bit_idx, sig):
    """Character of bit 'bit_idx' from an MSB-first bit-string payload."""
    if not isinstance(payload, str):
        return "x"
    if sig.range_str is None:
        pos = sig.width - 1 - bit_idx
    elif sig.msb >= sig.lsb:
        pos = sig.msb - bit_idx
    else:
        pos = bit_idx - sig.msb
    if 0 <= pos < len(payload):
        return payload[pos]
    return "x"


def hex_digits(width):
    return max(1, (width + 3) // 4)


def fmt_hex(v, ndig):
    return hex(int(v))[2:].upper().zfill(ndig)


# --------------------------------------------------------------------------
# row model and layout
# --------------------------------------------------------------------------

class Row(object):
    __slots__ = ("kind", "label", "sig", "times", "states", "h", "hexdigits")

    def __init__(self, kind, label, sig=None, times=None, states=None,
                 hexdigits=0):
        self.kind = kind        # 'header' | 'scalar' | 'bus' | 'bit'
        self.label = label
        self.sig = sig
        self.times = times or []
        self.states = states or []
        self.hexdigits = hexdigits
        self.h = ROW_H_SCALAR


def group_key_for_scope(scope):
    """Collapse a scope path to a header label: strip synthetic (gNN)
    primitive scopes at the tail, and drop the leading top module."""
    parts = scope.split(".")
    while parts and SYNTH_SCOPE_RE.match(parts[-1]):
        parts.pop()
    return ".".join(parts)


def build_rows_auto(vcd, changes, counts, dropped, auto_max=AUTO_MAX_CHANGES):
    """Default mode: leaf signals with < auto_max changes grouped
    by their scope prefix; synthetic wires / real-valued vars skipped.

    Icarus VCDs frequently declare the same underlying net under several
    scopes (top-level port wires aliasing instance nets) all sharing one
    id code.  Those rows would be byte-identical, so each net id is shown
    once, preferring its most specific (deepest) declared path."""
    best = {}       # vid -> (decl_index, Signal, best_depth)
    for idx, fp in enumerate(vcd.decl_order):
        sig = vcd.by_path[fp]
        if sig.unsupported or sig.synthetic:
            continue
        if counts.get(sig.vid, 0) >= auto_max:
            continue
        if sig.vid in dropped:
            continue
        if sig.vid not in changes:
            continue            # no recorded changes at all
        cur = best.get(sig.vid)
        depth = sig.path.count(".") if sig.path else 0
        if cur is None or depth > cur[2]:
            best[sig.vid] = (idx, sig, depth)
    # group by (stripped) scope prefix of the representative path
    ordered = sorted(best.values(), key=lambda t: t[0])
    groups = []          # (header, [Signal,...]) in first-appearance order
    gidx = {}
    for (_idx, sig, _depth) in ordered:
        header = group_key_for_scope(sig.path)
        if header not in gidx:
            gidx[header] = len(groups)
            groups.append((header, []))
        groups[gidx[header]][1].append(sig)
    rows = []
    top_name = vcd.decl_order[0].split(".")[0] if vcd.decl_order else ""
    for (header, sigs) in groups:
        rows.append(Row("header", header if header else top_name))
        for sig in sigs:
            cl = changes[sig.vid]
            times = [c[0] for c in cl]
            states, _w = trace_states(sig, cl)
            if sig.width > 1:
                rows.append(Row("bus", sig.fullpath(), sig, times, states,
                                hexdigits=hex_digits(sig.width)))
            else:
                rows.append(Row("scalar", sig.fullpath(), sig, times, states))
    return rows


def build_rows_cfg(vcd, changes, cfg_groups, dropped):
    """Rows from cfg groups (each group carries '_resolved' signals)."""
    rows = []
    for grp in cfg_groups:
        title = grp.get("name", "")
        mode = grp.get("bus", "hex")
        rows.append(Row("header", title if title else "signals"))
        for sig in grp.get("_resolved", []):
            if sig.vid in dropped:
                eprint("vcd2png: warning: signal %s dropped (too many "
                       "changes)" % sig.fullpath())
                continue
            cl = changes.get(sig.vid)
            if cl is None:
                cl = []
            times = [c[0] for c in cl]
            is_vec = sig.width > 1
            if is_vec and mode == "bits":
                for bit_idx in bit_index_sequence(sig):
                    states = [bit_char(p, bit_idx, sig) for (_t, p) in cl]
                    rows.append(Row("bit", "%s[%d]" % (sig.base, bit_idx),
                                    sig, times, states))
            elif is_vec:
                states, _w = trace_states(sig, cl)
                rows.append(Row("bus", sig.fullpath(), sig, times, states,
                                hexdigits=hex_digits(sig.width)))
            else:
                states, _w = trace_states(sig, cl)
                rows.append(Row("scalar", sig.fullpath(), sig, times, states))
    return rows


# --------------------------------------------------------------------------
# rendering
# --------------------------------------------------------------------------

def collect_events(lay, times, states):
    """Pixel-column events for a trace inside the layout window.

    Returns list [(col, state), ...] covering [data_x0, data_x1]; states
    equal in consecutive events may repeat (runs are built later), columns
    are coalesced (later change wins for equal pixels)."""
    X0 = lay.data_x0
    X1 = lay.data_x1
    x0f = float(X0)
    x1f = float(X1)
    t0 = lay.t0
    t1 = lay.t1
    n = len(times)
    if n == 0:
        return []

    def col(t):
        x = x0f + (t - t0) * lay.ppx
        if x < x0f:
            x = x0f
        elif x > x1f:
            x = x1f
        return int(round(x))

    # index of the first change at/after window start
    i = 0
    while i < n and times[i] < t0 - 1e-9:
        i += 1
    if i >= n:
        # everything happened before the window: flat line with last value
        c0 = col(t0)
        c1 = col(t1)
        return [(c0, states[-1]), (c1, states[-1])]
    prev = states[i - 1] if i > 0 else states[i]
    events = [(col(t0), prev)]
    for j in range(i, n):
        t = times[j]
        if t > t1 + 1e-9:
            break
        c = col(t)
        if c == events[-1][0]:
            events[-1] = (c, states[j])
        else:
            events.append((c, states[j]))
    if events[-1][0] < col(t1):
        events.append((col(t1), events[-1][1]))
    return events


def runs_from_events(events):
    """Convert pixel events [(col, state)...] into maximal same-state runs
    [x0, x1, state] where x1 is the boundary (first column) of the next run,
    i.e. the run covers pixel columns x0 .. x1-1."""
    runs = []
    for (c, st) in events:
        if runs:
            if runs[-1][2] == st:
                runs[-1][1] = c
                continue
            runs[-1][1] = c      # close the previous run at this boundary
        runs.append([c, c, st])
    return runs


def fill_zone(draw, x0, x1, rowY, rowH, state):
    if x1 <= x0:
        return
    if state == "x":
        fill, hatch = COL_X_FILL, COL_X_HATCH
    elif state == "z":
        fill, hatch = COL_Z_FILL, COL_Z_HATCH
    else:
        return
    draw.rectangle([x0, rowY + 1, x1 - 1, rowY + rowH - 2], fill=fill)
    # light diagonal cross-hatch
    step = 5
    yy = rowY + 1
    while yy < rowY + rowH - 3:
        draw.line([x0, yy, x1 - 1, min(yy + step, rowY + rowH - 2)],
                  fill=hatch, width=1)
        yy += step * 2


def draw_digital_row(draw, lay, rowY, rowH, times, states):
    """0/1 rails, x/z zones, crisp transitions."""
    y_hi = rowY + 1
    y_lo = rowY + rowH - 2
    events = collect_events(lay, times, states)
    if not events:
        return
    runs = runs_from_events(events)

    def y_of(st):
        if st == "1":
            return y_hi
        if st == "0":
            return y_lo
        return None

    # x/z zones first
    for (x0, x1, st) in runs:
        if st in ("x", "z"):
            fill_zone(draw, x0, x1, rowY, rowH, st)
    # defined-value horizontals
    for (x0, x1, st) in runs:
        yv = y_of(st)
        if yv is None or x1 <= x0:
            continue
        draw.line([x0, yv, x1 - 1, yv], fill=(COL_HI if st == "1"
                                              else COL_LO), width=1)
    # vertical transitions (0 <-> 1 only)
    for k in range(len(runs) - 1):
        xb = runs[k + 1][0]
        stA = runs[k][2]
        stB = runs[k + 1][2]
        if stA == stB or xb < lay.data_x0 or xb > lay.data_x1:
            continue
        ya = y_of(stA)
        yb = y_of(stB)
        if ya is None or yb is None:
            continue
        if ya == yb:
            continue
        draw.line([xb, ya, xb, yb], fill=(COL_HI if stB == "1" else COL_LO),
                  width=1)


def draw_bus_row(draw, lay, rowY, rowH, times, states, hexdigits, lbl_font):
    """Analog bus row: numeric value mapped between two rails (blue);
    x/z zones as hatched red/gray bands; hex value printed above the rail
    when the run is wide enough."""
    yt = rowY + 16
    yb = rowY + rowH - 2
    X0 = lay.data_x0
    X1 = lay.data_x1
    vmax = (1 << (hexdigits * 4)) - 1   # declared width full scale

    events = collect_events(lay, times, states)
    if not events:
        return
    # guide rails
    draw.line([X0, yt, X1, yt], fill=COL_GUIDE, width=1)
    draw.line([X0, yb, X1, yb], fill=COL_GUIDE, width=1)

    def y_of(st):
        if isinstance(st, int):
            return int(round(yb - (st / vmax) * (yb - yt)))
        return None

    runs = runs_from_events(events)
    # x/z zones
    for (x0, x1, st) in runs:
        if not isinstance(st, int):
            fill_zone(draw, x0, x1, rowY, rowH, st)
    # numeric horizontals + labels
    for (x0, x1, st) in runs:
        yv = y_of(st)
        if yv is None:
            continue
        if x1 > x0:
            draw.line([x0, yv, x1 - 1, yv], fill=COL_BUS, width=1)
        lab = fmt_hex(st, hexdigits)
        lw = text_w(draw, lab, lbl_font)
        if (x1 - x0) >= (lw + 8):
            cx = (x0 + x1) / 2.0
            lx = int(round(cx - lw / 2.0))
            if lx >= X0 and lx + lw <= X1:
                draw.text((lx, rowY + 1), lab, font=lbl_font,
                          fill=COL_BUS_LABEL)
    # vertical value transitions
    for k in range(len(runs) - 1):
        xb = runs[k + 1][0]
        stA = runs[k][2]
        stB = runs[k + 1][2]
        if xb < lay.data_x0 or xb > lay.data_x1:
            continue
        ya = y_of(stA)
        yb2 = y_of(stB)
        if ya is None or yb2 is None:
            continue
        if ya == yb2:
            continue
        draw.line([xb, ya, xb, yb2], fill=COL_BUS, width=1)


def nice_step(raw):
    if raw <= 0:
        raw = 1.0
    exp = math.floor(math.log10(raw))
    base = raw / (10.0 ** exp)
    for m in (1, 2, 5, 10):
        if base <= m:
            return m * (10.0 ** exp)
    return 10.0 * (10.0 ** exp)


def fmt_time(t):
    if abs(t - round(t)) < 1e-6:
        return str(int(round(t)))
    return ("%.3f" % t).rstrip("0").rstrip(".")


def nice_ticks(t0, t1, ppx, draw, ax_font):
    span = t1 - t0
    if span <= 0:
        return 1.0, [t0]
    step = nice_step(70.0 / ppx if ppx > 0 else span)
    for _ in range(12):
        sample = []
        t = math.ceil(t0 / step) * step
        while t <= t1 + 1e-9:
            sample.append(t)
            t += step
        widest = max((text_w(draw, fmt_time(x), ax_font) for x in sample),
                     default=10)
        if step * ppx >= widest + 8:
            break
        step = nice_step(step * 1.4 + 0.001)
    ticks = []
    t = math.ceil(t0 / step) * step
    while t <= t1 + 1e-9:
        ticks.append(t)
        t += step
    return step, ticks


def build_canvas(rows, name_font, draw, t0, t1, ppx_given, height_given):
    # name column width from the longest label
    widths = []
    for r in rows:
        if r.kind != "header":
            widths.append(text_w(draw, r.label, name_font))
        else:
            widths.append(text_w(draw, r.label, load_font(HDR_FONT_PX,
                                                          bold=True)))
    name_w = (max(widths) if widths else 0) + NAME_GAP + 6
    tspan = max(t1 - t0, 1.0)
    if ppx_given and ppx_given > 0:
        ppx = float(ppx_given)
    else:
        ppx = DATA_WIDTH_GOAL / tspan
    data_w = max(1, int(math.ceil(tspan * ppx)))
    img_w = MARGIN_L + name_w + data_w + MARGIN_R
    data_x0 = MARGIN_L + name_w
    data_x1 = data_x0 + data_w

    # vertical layout
    y = MARGIN_TOP
    placed = []
    for r in rows:
        if r.kind == "header":
            r.h = ROW_H_HEADER
        elif r.kind == "bus":
            r.h = ROW_H_BUS
        else:
            r.h = ROW_H_SCALAR
        placed.append((r, y))
        y += r.h
        if r.kind == "header":
            y += 2          # breathing room after a group title
    rows_end = y
    natural = rows_end + 3 + AXIS_H + MARGIN_BOT
    if height_given:
        total_h = max(int(height_given), AXIS_H + 8)
        if total_h < natural:
            eprint("vcd2png: warning: --height %d smaller than natural %d px;"
                   " rows will be clipped" % (total_h, natural))
        axis_y = total_h - AXIS_H - MARGIN_BOT
    else:
        total_h = natural
        axis_y = rows_end + 3
    return dict(img_w=img_w, total_h=total_h, name_w=name_w,
                data_x0=data_x0, data_x1=data_x1, ppx=ppx, t0=t0, t1=t1,
                placed=placed, axis_y=axis_y, data_y1=rows_end)


def render(vcd, rows, t0, t1, ppx_given, height_given, out_path):
    name_font = load_font(NAME_FONT_PX)
    hdr_font = load_font(HDR_FONT_PX, bold=True)
    ax_font = load_font(AX_FONT_PX)
    lbl_font = load_font(LBL_FONT_PX)

    if t0 is None:
        t0 = 0.0
    if t1 is None:
        t1 = vcd.t_max
    if t1 < t0:
        t0, t1 = 0.0, vcd.t_max

    probe = Image.new("RGB", (8, 8))
    pdraw = ImageDraw.Draw(probe)
    g = build_canvas(rows, name_font, pdraw, t0, t1, ppx_given, height_given)
    img_w = int(g["img_w"])
    img_h = int(g["total_h"])
    img = Image.new("RGB", (img_w, img_h), "white")
    draw = ImageDraw.Draw(img)
    data_x0 = g["data_x0"]
    data_x1 = g["data_x1"]
    lay_t0 = g["t0"]
    lay_t1 = g["t1"]
    ppx = g["ppx"]

    class _Lay(object):
        pass
    lay = _Lay()
    lay.data_x0 = data_x0
    lay.data_x1 = data_x1
    lay.t0 = lay_t0
    lay.t1 = lay_t1
    lay.ppx = ppx

    # ticks
    step, ticks = nice_ticks(lay_t0, lay_t1, ppx, draw, ax_font)
    tick_px = [int(round(data_x0 + (tk - lay_t0) * ppx)) for tk in ticks]

    ndata_rows = sum(1 for (r, _y) in g["placed"] if r.kind != "header")
    draw_grid = ndata_rows <= 400

    # rows
    for (r, rowY) in g["placed"]:
        if r.kind == "header":
            draw.rectangle([0, rowY, img_w - 1, rowY + r.h - 1],
                           fill=COL_HDR_BG)
            hh = text_h(hdr_font)
            ty = int(round(rowY + (r.h - hh) / 2.0))
            draw.text((MARGIN_L + 2, ty), r.label, font=hdr_font,
                      fill=COL_HDR_TEXT)
            draw.line([MARGIN_L, rowY + r.h - 1, img_w - MARGIN_R,
                       rowY + r.h - 1], fill=(178, 190, 206))
            continue
        row_bot = rowY + r.h
        if row_bot > g["axis_y"]:
            row_bot = g["axis_y"]
        if rowY >= row_bot:
            continue
        # light time grid per row
        if draw_grid:
            for gx in tick_px:
                if data_x0 < gx < data_x1:
                    draw.line([gx, rowY, gx, row_bot - 1], fill=COL_GRID)
        # waveform
        if r.kind == "bus":
            draw_bus_row(draw, lay, rowY, r.h, r.times, r.states,
                         r.hexdigits, lbl_font)
        else:
            draw_digital_row(draw, lay, rowY, r.h, r.times, r.states)
        # name
        hh = text_h(name_font)
        ty = int(round(rowY + (r.h - hh) / 2.0))
        draw.text((MARGIN_L + 2, ty), r.label, font=name_font, fill=COL_TEXT)
        # faint bottom edge
        if rowY + r.h <= g["axis_y"]:
            draw.line([data_x0, rowY + r.h - 1, data_x1, rowY + r.h - 1],
                      fill=COL_ROW_EDGE)

    # axis
    axis_y = g["axis_y"]
    draw.line([data_x0, axis_y, data_x1, axis_y], fill=(120, 120, 120))
    for gx, tk in zip(tick_px, ticks):
        if gx < data_x0 or gx > data_x1:
            continue
        draw.line([gx, axis_y, gx, axis_y + 5], fill=COL_AXIS)
        lab = fmt_time(tk)
        lw = text_w(draw, lab, ax_font)
        lx = gx - lw // 2
        if lx < 2:
            lx = 2
        if lx + lw > img_w - 2:
            lx = img_w - 2 - lw
        if lx >= 2:
            draw.text((lx, axis_y + 6), lab, font=ax_font, fill=COL_AXIS)
    nsw = text_w(draw, "ns", ax_font)
    draw.text((data_x1 - nsw, axis_y + 6), "ns", font=ax_font,
              fill=(150, 150, 150))

    img.save(out_path, "PNG")
    return img.size


# --------------------------------------------------------------------------
# main
# --------------------------------------------------------------------------

def main(argv=None):
    ap = argparse.ArgumentParser(
        prog="vcd2png",
        description="Render an Icarus Verilog VCD file to a PNG waveform "
                    "image (Python stdlib + Pillow only).")
    ap.add_argument("input", help="input .vcd file")
    ap.add_argument("output", help="output .png file")
    ap.add_argument("--cfg", default=None,
                    help="optional JSON config with signal groups")
    ap.add_argument("--t0", type=float, default=None,
                    help="window start in ns (default: dump start)")
    ap.add_argument("--t1", type=float, default=None,
                    help="window end in ns (default: dump end)")
    ap.add_argument("--height", type=int, default=None,
                    help="total image height in px (default: auto)")
    ap.add_argument("--ppx", type=float, default=None,
                    help="pixels per ns (default: fit window in ~2000 px)")
    ap.add_argument("--max-changes", type=int, default=200,
                    help="default-mode leaf-signal change cap (default 200)")
    args = ap.parse_args(argv)
    max_changes = max(1, args.max_changes)

    if not os.path.isfile(args.input):
        eprint("vcd2png: input file not found: %s" % args.input)
        return 1
    out_dir = os.path.dirname(os.path.abspath(args.output))
    if out_dir and not os.path.isdir(out_dir):
        eprint("vcd2png: output directory does not exist: %s" % out_dir)
        return 1

    cfg_groups = None
    if args.cfg:
        try:
            with open(args.cfg, "r") as f:
                cfg = json.load(f)
        except (OSError, ValueError) as exc:
            eprint("vcd2png: cannot read config %s: %s" % (args.cfg, exc))
            return 1
        if not isinstance(cfg, dict) or not isinstance(cfg.get("signals"),
                                                       list):
            eprint("vcd2png: config must be a JSON object with a 'signals' "
                   "list")
            return 1
        cfg_groups = []
        for g in cfg["signals"]:
            if isinstance(g, dict) and isinstance(g.get("signals"), list):
                cfg_groups.append(g)
            else:
                eprint("vcd2png: warning: ignoring malformed group %r" % (g,))
        if not cfg_groups:
            eprint("vcd2png: no usable signal groups in %s" % args.cfg)
            return 1

    vcd = VCDReader(args.input)
    eprint("vcd2png: %d signal declarations; timescale factor %g ns/unit"
           % (len(vcd.decl_order), vcd.ns_per_unit))

    if cfg_groups is None:
        want = set(vcd.by_id.keys())
        changes, counts, tmax, tmin, dropped = vcd.stream_values(
            want, auto_mode=True, auto_max=max_changes)
        rows = build_rows_auto(vcd, changes, counts, dropped,
                               auto_max=max_changes)
        n_data = sum(1 for r in rows if r.kind != "header")
        eprint("vcd2png: default mode: %d data rows (leaf signals with < %d "
               "changes)" % (n_data, max_changes))
    else:
        for g in cfg_groups:
            g["_resolved"] = vcd.resolve(g.get("signals", []))
        want = set()
        for g in cfg_groups:
            want.update(s.vid for s in g["_resolved"])
        if not want:
            eprint("vcd2png: no configured signal matched the VCD; nothing "
                   "to render")
            return 1
        changes, counts, tmax, tmin, dropped = vcd.stream_values(
            want, auto_mode=False)
        rows = build_rows_cfg(vcd, changes, cfg_groups, dropped)
        n_data = sum(1 for r in rows if r.kind != "header")
        eprint("vcd2png: cfg mode: %d data rows" % n_data)

    t0 = args.t0 if args.t0 is not None else 0.0
    t1 = args.t1 if args.t1 is not None else tmax
    if t1 <= t0 or t1 <= 0:
        t0, t1 = 0.0, max(tmax, 1.0)
    size = render(vcd, rows, t0, t1, args.ppx, args.height, args.output)
    eprint("vcd2png: wrote %s (%dx%d px, window %s..%s ns)"
           % (args.output, size[0], size[1], fmt_time(t0), fmt_time(t1)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
