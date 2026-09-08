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
    # collect every scope's variable for `name` and keep the one with the
    # most value changes (the net may be dumped under several scopes)
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

def seg_starts(log):
    segs = {}
    for ln in open(log):
        m = re.match(r'SEG (\d+) t=(\d+) freq=(\d+)', ln)
        if m:
            segs[int(m.group(1))] = (int(m.group(2)), int(m.group(3)))
    return segs

def analyse(sig, t0, t1):
    ev = [(t, v) for t, v in sig if t0 <= t < t1]
    starts, ends = [], []
    for i in range(len(ev) - 1):
        if ev[i][1] == 0 and ev[i + 1][1] != 0:
            starts.append(ev[i + 1][0])
        elif ev[i][1] != 0 and ev[i + 1][1] == 0:
            ends.append(ev[i + 1][0])
    if not starts or not ends:
        return None, None, 0
    ratios = []
    periods = []
    ei = 0
    for k in range(len(starts) - 1):
        while ei < len(ends) and ends[ei] <= starts[k]:
            ei += 1
        if ei < len(ends) and starts[k] < ends[ei] < starts[k + 1]:
            ratios.append((ends[ei] - starts[k]) / (starts[k + 1] - starts[k]))
            periods.append(starts[k + 1] - starts[k])
    if not ratios:
        return None, None, 0
    ratios.sort()
    duty = ratios[len(ratios) // 2] * 100.0
    periods.sort()
    vol = max(v for _, v in ev if v != 0) if any(v != 0 for _, v in ev) else 0
    return duty, periods[len(periods) // 2], vol

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
