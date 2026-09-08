#!/usr/bin/env python3
"""Analyze tb_clkgen VCD: M-cycle period and posedge phase offsets of every
clock output (issue #396). Prints a table suitable for the wiki.
Usage: python3 clkgen_phases.py <tb_clkgen.vcd> [--w0 ns] [--w1 ns]
"""
import re, bisect, sys

def main():
    args = [a for a in sys.argv[1:]]
    path = args[0]
    w0 = int(args[args.index('--w0') + 1]) if '--w0' in args else 6000
    w1 = int(args[args.index('--w1') + 1]) if '--w1' in args else 60000
    src = open(path, newline='').read().replace('\r\n', '\n')
    hdr, body = src.split('$enddefinitions $end', 1)
    i = body.find('$dumpvars'); j = body.find('$end', i); body = body[j + 4:]
    scopes = []; ids = {}
    for ln in hdr.splitlines():
        ln = ln.strip()
        if ln.startswith('$scope'): scopes.append(ln.split()[2])
        elif ln.startswith('$upscope'): scopes.pop()
        elif ln.startswith('$var'):
            p = ln.split(); ids[p[3]] = '.'.join(scopes + [p[4]])
    clks = {n: [] for n in ['n_clk_in', 'cclk', 'clk1', 'clk2', 'clk3',
                             'clk4', 'clk5', 'clk6', 'clk7', 'clk8', 'clk9']}
    state = {}; cur = 0
    for ln in body.splitlines():
        if ln.startswith('#'): cur = int(ln[1:]); continue
        t = ln.split()
        if not t: continue
        if t[0].startswith('b'): vid = t[1]; v = t[0][1:]
        else: vid = t[0][1:]; v = t[0][0]
        nm = ids.get(vid, '')
        base = nm.split('.')[-1]
        if base in clks:
            old = state.get(vid)
            if old == '0' and v == '1' and w0 <= cur <= w1:
                clks[base].append(cur)
            state[vid] = v
    t9 = clks['clk9']
    per = round(sum(t9[i + 1] - t9[i] for i in range(len(t9) - 1)) / (len(t9) - 1))
    print('clk9 (M-cycle) period: %d ns over %d cycles' % (per, len(t9) - 1))
    print('%6s %8s | %s' % ('clk', '#edges', 'posedge offsets in M-cycle (ns)'))
    for base in ['n_clk_in', 'cclk', 'clk1', 'clk2', 'clk3', 'clk4',
                 'clk5', 'clk6', 'clk7', 'clk8', 'clk9']:
        ts = clks[base]
        bins = {}
        for x in ts:
            k = bisect.bisect_right(t9, x) - 1
            if k >= 0:
                d = x - t9[k]
                if 0 <= d < per:
                    b = (d // 16) * 16
                    bins[b] = bins.get(b, 0) + 1
        occ = ' '.join('%dns:x%d' % (b, bins[b]) for b in sorted(bins))
        print('%6s %8d | %s' % (base, len(ts), occ))

if __name__ == '__main__':
    main()
