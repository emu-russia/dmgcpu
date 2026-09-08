#!/usr/bin/env python3
"""apu_trace.py - decode/cone tracer for the APU netlist (issue #398).

Parses apu_merged.v (or apu.v) into a gate graph and answers netlist
questions in terms of human-readable boolean expressions over the port
signals (a[7:0], d[7:0], soc_wr, soc_rd, ffxx, clk2, ...).

Usage:
  python3 apu_trace.py <netlist.v> <target-net> [--depth N] [--reverse]
  python3 apu_trace.py <netlist.v> --readmap      # all d-bus read drivers
  python3 apu_trace.py <netlist.v> --regfile      # state cells w/ decode
"""
import re, sys

INV = {'dmg_not': '~', 'dmg_not2': '~', 'dmg_not3': '~', 'dmg_not4': '~',
       'dmg_not6': '~', 'dmg_not10': '~'}
BIN = {'dmg_and': '&', 'dmg_and3': '&', 'dmg_and4': '&', 'dmg_nand': '~(&)',
       'dmg_nand3': '~(&)', 'dmg_nand4': '~(&)', 'dmg_nand5': '~(&)',
       'dmg_nor': '~(|)', 'dmg_nor3': '~(|)', 'dmg_nor4': '~(|)',
       'dmg_nor5': '~(|)', 'dmg_nor6': '~(|)', 'dmg_or': '|', 'dmg_or3': '|',
       'dmg_or4': '|', 'dmg_xor': '^', 'dmg_xnor': '~^'}

def parse(path):
    gates = []  # (inst, cell, out, {pin: net})
    assigns = []  # (out_net, expr_net)
    port_dirs = {}
    cur = None
    for ln in open(path, encoding='utf-8', errors='replace'):
        ln = ln.strip()
        m = re.match(r'(input|output|inout)\s+(?:wire\s+)?(?:\[[^\]]*\]\s+)?([a-zA-Z_][a-zA-Z0-9_]*)', ln)
        if m:
            port_dirs[m.group(2)] = m.group(1)
            continue
        m = re.match(r'(\w+)\s+(\w+)\s*\((.*)\)\s*;', ln)
        if m:
            cell, inst, plist = m.group(1), m.group(2), m.group(3)
            if cell.startswith('dmg_') and plist:
                pins = {}
                out = None
                for pm in re.finditer(r'\.(\w+)\(([^)]*)\)', plist):
                    if pm.group(1) in ('q', 'x', 'nq', 'cout'):
                        out = pm.group(2)
                    if pm.group(1) in ('q', 'x', 'nq', 'cout'):
                        out = pm.group(2)
                    pins[pm.group(1)] = pm.group(2)
                gates.append((inst, cell, out, pins))
            continue
        m = re.match(r'assign\s+(\w+)\s*=\s*(\w+)\s*;', ln)
        if m:
            assigns.append((m.group(1), m.group(2)))
    return gates, assigns, port_dirs

def expand(net, gates, assigns, mem):
    """Return a canonical string for the fanin cone of `net` (depth-capped)."""
    if net in mem:
        return mem[net]
    # resolve assign aliases first
    for o, e in assigns:
        if o == net:
            r = expand(e, gates, assigns, mem)
            mem[net] = r
            return r
    # find gate driving it
    drv = [g for g in gates if g[2] == net]
    if not drv:
        mem[net] = net
        return net
    inst, cell, out, pins = drv[0]
    if cell in INV:
        a = pins.get('a', pins.get('nq', pins.get('q')))
        r = '~(%s)' % expand(a, gates, assigns, mem)
    elif cell in BIN and cell not in ('dmg_nand', 'dmg_nand3', 'dmg_nand4', 'dmg_nand5', 'dmg_nor', 'dmg_nor3', 'dmg_nor4', 'dmg_nor5', 'dmg_nor6', 'dmg_xnor'):
        op = BIN[cell]
        ins = [expand(pins[k], gates, assigns, mem) for k in sorted(pins)
               if k in ('a', 'b', 'c', 'd', 'e', 'f')]
        r = (' %s ' % op).join('(%s)' % x for x in ins)
    elif cell.startswith('dmg_nand') or cell.startswith('dmg_nor'):
        op = '&' if cell.startswith('dmg_nand') else '|'
        ins = [expand(pins[k], gates, assigns, mem) for k in sorted(pins)
               if k in ('a', 'b', 'c', 'd', 'e', 'f')]
        inner = (' %s ' % op).join('(%s)' % x for x in ins)
        r = '~(%s)' % inner
    elif cell == 'dmg_xnor':
        a, b = expand(pins['a'], gates, assigns, mem), expand(pins['b'], gates, assigns, mem)
        r = '~((%s)^(%s))' % (a, b)
    elif cell == 'dmg_mux':
        r = 'mux(%s, %s, %s)' % (expand(pins['sel'], gates, assigns, mem),
                                 expand(pins['d1'], gates, assigns, mem),
                                 expand(pins['d0'], gates, assigns, mem))
    elif cell == 'dmg_bufif0':
        # tristate buffer: pass the input through (bus arbitration role)
        r = expand(pins.get('a0', pins.get('a1')), gates, assigns, mem)
    elif cell in ('dmg_dffr', 'dmg_dffsr', 'dmg_latchr_comp', 'dmg_latch', 'dmg_cnt',
                  'dmg_nor_latch', 'dmg_nand_latch', 'dmg_dffr_comp',
                  'dmg_dffrnq_comp', 'dmg_notif0', 'dmg_notif1',
                  'dmg_const', 'dmg_fa', 'dmg_aon22', 'dmg_aon222', 'dmg_aon2222',
                  'dmg_aon222222', 'dmg_muxi'):
        # stateful / tri-state / compound: report opaque with cell name
        r = '[%s %s %s]' % (cell, inst, net)
    else:
        r = '[%s %s %s]' % (cell, inst, net)
    mem[net] = r
    return r

def main():
    path = sys.argv[1]
    gates, assigns, port_dirs = parse(path)
    print('parsed %d gates, %d assigns' % (len(gates), len(assigns)))
    if '--readmap' in sys.argv:
        print('\n== d-bus read drivers (notif driving d[i]) ==')
        by_ena = {}
        for inst, cell, out, pins in gates:
            if cell in ('dmg_notif0', 'dmg_notif1') and re.fullmatch(r'd\[\d\]', out or ''):
                ena = pins.get('n_ena', pins.get('ena'))
                a = pins.get('a', '?')
                kind = 'notif0' if cell == 'dmg_notif0' else 'notif1'
                by_ena.setdefault(ena, []).append((kind, out, a))
        for ena, rows in sorted(by_ena.items()):
            mem = {}
            e = expand(ena, gates, assigns, mem)
            rows_sorted = sorted(rows)
            kinds = set(k for k, _, _ in rows)
            print('EN %-8s [%s] %d drivers' % (ena, ','.join(sorted(kinds)), len(rows)))
            print('    enable  = %s' % e)
            for kind, out, a in rows_sorted:
                mem2 = {}
                print('    %-4s %s <- %s' % (out, kind, expand(a, gates, assigns, mem2)))
        return
    if '--regfile' in sys.argv:
        print('\n== state cells whose clock/enable derives from soc_wr/soc_rd ==')
        for inst, cell, out, pins in gates:
            if cell in ('dmg_dffr', 'dmg_dffsr', 'dmg_latchr_comp', 'dmg_latch', 'dmg_cnt'):
                ck = pins.get('clk', pins.get('ena', pins.get('ck')))
                print('%-10s %-16s clk/ena=%s' % (out, cell + ' ' + inst, ck))
        return
    target = sys.argv[2]
    mem = {}
    print(expand(target, gates, assigns, mem))

if __name__ == '__main__':
    main()
