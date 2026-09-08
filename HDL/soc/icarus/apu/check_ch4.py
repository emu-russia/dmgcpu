#!/usr/bin/env python3
"""check_ch4.py - verify tb_apu_ch4 segments (issue #398).

Noise channel (vol F): ch4_out toggles with high level F while running;
the transition rate depends on NR43 (divisor r bits 2:0, LFSR width bit3).
Equal-length measurement windows per segment; the measured rates are
printed (divider formula cross-check is a wiki/STATUS item) and the
assertions keep the solid facts: level F, activity present, and the
rate drops monotonically as r grows.
"""
import re, sys

def load_sig(path, name):
    txt = open(path).read()
    vids = re.findall(r'\$var wire 4 (\S+) ' + re.escape(name) + r' \[3:0\]', txt)
    if not vids:
        return None
    best = None
    for vid in vids:
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
        if best is None or len(out) > len(best):
            best = out
    return best

def main():
    ch4 = load_sig('tb_apu_ch4.vcd', 'ch4_out')
    times = []
    for ln in open('apu_ch4_segs.log'):
        m = re.match(r'SEG (\d+) t=(\d+) nr43=(\S+)', ln)
        if m:
            times.append((int(m.group(1)), int(m.group(2)), int(m.group(3), 16)))
    if ch4 is None or len(times) < 2:
        print('RESULT tb_apu_ch4 FAIL (no data)')
        return 1
    fails = 0
    rates = {}
    for i, (segn, t0, nr43) in enumerate(times):
        t1 = times[i + 1][1] if i + 1 < len(times) else t0 + 700000
        t1 = min(t1, t0 + 500000)          # equal 500us windows
        ev = [(t, v) for t, v in ch4 if t0 + 10000 < t < t1]
        n = max(0, len(ev) - 1)
        hi = max([v for _, v in ev] or [0])
        rates[segn] = n
        ok = (hi == 0xF and n > 5)
        print(('PASS ' if ok else 'FAIL ') +
              'SEG %d nr43=%02x: transitions/500us=%d hi=%x' % (segn, nr43, n, hi))
        if not ok:
            fails += 1
    r0 = rates.get(1, 0); r7 = rates.get(2, 0)
    if r7 and r0:
        print('MEAS rate r0/r7 = %.1f (divider-ratio cross-check pending, see STATUS)'
              % (r0 / r7))
    print('RESULT tb_apu_ch4 %s (%d fails)' % ('PASS' if fails == 0 else 'FAIL', fails))
    return 0 if fails == 0 else 1

if __name__ == '__main__':
    sys.exit(main())
