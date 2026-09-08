#!/usr/bin/env python3
"""check_ch1.py - verify tb_apu_ch2 wave segments (issue #398).

Reads apu_ch1_segs.log (segment start times) + tb_apu_ch2.vcd (ch2_out
transitions) and checks per segment:
  * output period = (2048 - X) * 32 * 64 ns   (X = 11-bit freq)
  * duty fraction (12.5/25/50/75%)
  * volume plateau value
Prints RESULT tb_apu_ch2 PASS/FAIL for the run_all.sh suite.
"""
import re, sys

VCD, LOG = 'tb_apu_ch2.vcd', 'apu_ch1_segs.log'

def load_vcd_sig(path, name):
    txt = open(path).read()
    m = re.search(r'\$var wire 4 (\S+) ' + re.escape(name) + r' \[3:0\]', txt)
    if not m:
        return None
    vid = m.group(1)
    out = []
    t = 0
    prev = None
    for ln in txt[txt.index('$enddefinitions'):].splitlines():
        tm = re.match(r'#(\d+)', ln)
        if tm:
            t = int(tm.group(1))
        for vm in re.finditer(r'b([01xz]+)\s*' + re.escape(vid), ln):
            v = vm.group(1)
            if v != prev:
                out.append((t, int(v, 2)))
                prev = v
    return out

def seg_starts(log):
    segs = {}
    for ln in open(log):
        m = re.match(r'SEG (\d+) t=(\d+) freq=(\d+)', ln)
        if m:
            segs[int(m.group(1))] = (int(m.group(2)), int(m.group(3)))
    return segs

def analyse(sig, t0, t1):
    """Return (duty_pct, period_ns, vol_max) from transitions in [t0,t1)."""
    ev = [(t, v) for t, v in sig if t0 <= t < t1]
    starts, ends = [], []
    for i in range(len(ev) - 1):
        if ev[i][1] == 0 and ev[i + 1][1] != 0:
            starts.append(ev[i + 1][0])
        elif ev[i][1] != 0 and ev[i + 1][1] == 0:
            ends.append(ev[i + 1][0])
    if not starts or not ends:
        return None, None, 0
    pairs = []
    si = 0
    for e in ends:
        while si < len(starts) and starts[si] < e:
            if si > 0:
                pairs.append((starts[si - 1], starts[si], e))
            si += 1
    if not pairs:
        return None, None, 0
    hs = sum(e - s for s0, s, e in pairs)
    ps = sum(s - s0 for s0, s, e in pairs)
    duty = hs / ps * 100.0 if ps else None
    vol = max(v for _, v in ev if v != 0) if any(v != 0 for _, v in ev) else 0
    return duty, ps / len(pairs), vol

def main():
    sig = load_vcd_sig(VCD, 'ch2_out')
    if sig is None:
        print('RESULT tb_apu_ch2 FAIL (ch2_out not in vcd)')
        return 1
    segs = seg_starts(LOG)
    duty_want = {1: 12.5, 2: 25, 3: 50, 4: 75, 5: 50, 6: 50, 7: 50}
    vol_want = {5: 5, 6: 0xA}
    order = sorted(segs)
    fails = 0
    for i, segn in enumerate(order):
        t0, freq = segs[segn]
        t1 = t0 + (2048 - freq) * 32 * 64 * 4
        if i + 1 < len(order):
            t1 = min(t1, segs[order[i + 1]][0])
        duty, period, vol = analyse(sig, t0, t1)
        want_period = (2048 - freq) * 32 * 64
        ok = True
        msg = 'SEG %d freq=%d period=%s (want %d)' % (
            segn, freq, ('%.0f' % period) if period else 'NA', want_period)
        if period is None or abs(period - want_period) > want_period * 0.01:
            ok = False
        if duty is not None:
            msg += ' duty=%.1f%% (want %s%%)' % (duty, duty_want[segn])
            if abs(duty - duty_want[segn]) > 7:
                ok = False
        else:
            msg += ' duty=NA'
            ok = False
        if segn in vol_want:
            msg += ' vol_max=%d (want %d)' % (vol, vol_want[segn])
            if vol != vol_want[segn]:
                ok = False
        print(('PASS ' if ok else 'FAIL ') + msg)
        if not ok:
            fails += 1
    print('RESULT tb_apu_ch2 %s (%d fails)' % ('PASS' if fails == 0 else 'FAIL', fails))
    return 0 if fails == 0 else 1

if __name__ == '__main__':
    sys.exit(main())
