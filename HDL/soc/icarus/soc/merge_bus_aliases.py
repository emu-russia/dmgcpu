"""Merge bidirectional-bus alias assigns into real net aliases for Icarus
(SoC small-domain netlists, issue #396).

The Deroute-style netlists connect each bit of an inout bus through a
one-way `assign <bus>[<i>] = wNNN;`.  Physically the wire wNNN is the same
node as the bus bit (drivers and receivers attach to one metal wire), but
under Icarus the assign is a real one-way driver, so:

  * register/decoder inputs that read `wNNN` never see the CPU-driven value
    of <bus>[<i>] while the module's own tristate is off (they read x or
    their own drive), and
  * CPU write data never reaches the capturing latches.

Fix: rename `wNNN` -> `<bus>[<i>]` everywhere in the module and delete the
alias assign + the now-redundant wire declaration (same procedure as the PPU
tool, extended to the `a`/`d`/`md` buses of the small domains).

Which buses are merged is chosen per netlist by the --buses option (default:
all of `a`, `d`, `md`).

Usage: python3 merge_bus_aliases.py <in.v> <out.v> [--buses a d md]
"""
import re, sys

DEFAULT_BUSES = ('a', 'd', 'md')

def merge(path, out, buses):
    src = open(path, newline='').read()
    # normalize newlines to LF for the generated file
    src = src.replace('\r\n', '\n')
    bus_re = '|'.join(re.escape(b) for b in buses)
    # Only the first (top) module body is processed: netlists can contain
    # helper modules after it (e.g. ser.v -> ser_reg_bit) that reuse the
    # same wNNN names for *different* local wires, and the rename must not
    # leak into them.  Chunk on ^module / ^endmodule at column 0.
    chunk = src
    head_end = None
    rest = ''
    lines = src.splitlines(keepends=True)
    first = None
    for i, ln in enumerate(lines):
        if ln.startswith('module '):
            first = i
            break
    if first is not None:
        # find the endmodule that closes this module
        depth = 0
        for i in range(first, len(lines)):
            if lines[i].startswith('module '):
                depth += 1
            elif lines[i].startswith('endmodule'):
                depth -= 1
                if depth == 0:
                    break
        chunk = ''.join(lines[first:i + 1])
        rest = ''.join(lines[i + 1:])
    aliases = []
    # module drives the bus bit:  assign <bus>[<i>] = wNNN;
    pat = re.compile(r'^\s*assign\s+(' + bus_re + r')\s*\[\s*(\d+)\s*\]\s*=\s*(w\d+)\s*;', re.M)
    for m in pat.finditer(chunk):
        bus, i, w = m.group(1), m.group(2), m.group(3)
        aliases.append((w, '%s[%s]' % (bus, i)))
    if not aliases:
        print(path, ': nothing to merge')
        open(out, 'w').write(src)
        return
    # drop the alias assigns (only for the merged buses)
    chunk = re.sub(
        r'^\s*assign\s+(?:' + bus_re + r')\s*\[\s*\d+\s*\]\s*=\s*w\d+\s*;\s*\n',
        '', chunk, flags=re.M)
    # drop redundant wire declarations
    for w, _ in aliases:
        chunk = re.sub(r'^\s*wire\s+' + w + r'\s*;\s*\n', '', chunk, flags=re.M)
    # rename every remaining use inside the top module only
    for w, rep in aliases:
        chunk = re.sub(r'\b' + w + r'\b', rep, chunk)
    open(out, 'w').write(chunk + rest)
    print(path, '->', out, 'merged', len(aliases), 'aliases')

if __name__ == '__main__':
    args = sys.argv[1:]
    path, out = args[0], args[1]
    buses = DEFAULT_BUSES
    if '--buses' in args:
        i = args.index('--buses')
        buses = tuple(args[i + 1:])
    merge(path, out, buses)
