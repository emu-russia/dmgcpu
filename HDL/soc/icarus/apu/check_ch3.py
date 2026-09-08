#!/usr/bin/env python3
"""check_ch3.py - verify tb_apu_ch3 segments (issue #398).

Checks that ch3_out equals the NR32-scaled wave sample (image: 0xF0+i)
and measures the sample-fetch cadence (wave_a changes per second at the
given X; sample period = (2048-X) * 8 oscillator cycles measured).
"""
import re, sys

def load_vcd_sig(path, name):
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
    ch3 = load_vcd_sig('tb_apu_ch3.vcd', 'ch3_out')
    if ch3 is None:
        print('RESULT tb_apu_ch3 FAIL (no ch3_out)')
        return 1
    segs = {}
    for ln in open('apu_ch3_segs.log'):
        m = re.match(r'SEG (\d+) t=(\d+) nr32=(\S+) freq=(\S+)', ln)
        if m:
            segs[int(m.group(1))] = (int(m.group(3)), int(m.group(4)), int(m.group(2)))
    # volume expectations per segment (image all-F samples)
    expect = {1: 0xF, 2: 0x7, 3: 0x3, 4: 0x0, 5: 0xF, 6: 0xF}
    fails = 0
    for segn in sorted(segs):
        volcode, freq, t0 = segs[segn]
        win = [(t, v) for t, v in ch3 if t0 + 50000 < t < t0 + 350000]
        vals = [v for _, v in win if v != 0]
        dom = max(set(vals), key=vals.count) if vals else 0
        nz = len(vals) / max(len(win), 1)
        ok = True
        msg = 'SEG %d vol_code=%d: dominant amp=%d (want %d), nonzero-frac=%.2f' % (
            segn, volcode >> 5, dom, expect[segn], nz)
        if dom != expect[segn]:
            ok = False
        if segn in (5, 6) and nz < 0.05:
            ok = False
        if segn == 4 and nz > 0.02:
            ok = False
        # cadence on seg 5 (X=0x7F0) & seg 6 (X=0x780)
        if segn in (5, 6):
            wa = load_vcd_sig('tb_apu_ch3.vcd', 'wave_a') if False else load_vcd_sig('tb_apu_ch3.vcd', 'wave_a')
            t1, t2 = t0 + 200000, t0 + 900000
            eva = [(t, v) for t, v in wa if t1 < t < t2]
            steps = len(eva)
            span = (t2 - t1) / 1000.0
            msg += ' wave_a steps=%d in %.1f us' % (steps, span)
        print(('PASS ' if ok else 'FAIL ') + msg)
        if not ok:
            fails += 1
    print('RESULT tb_apu_ch3 %s (%d fails)' % ('PASS' if fails == 0 else 'FAIL', fails))
    return 0 if fails == 0 else 1

if __name__ == '__main__':
    sys.exit(main())
