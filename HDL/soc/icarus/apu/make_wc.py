#!/usr/bin/env python3
"""make_wc.py - generate apu_wc.v from apu_merged.v (bus-model fix).

The w548 decode (FF19/freq-hi access window) also enables five notif0
drivers (g869/g937/g939-941) that put the channel-2 divider state onto d.
In the static gate-level model these drivers are open during CPU *writes*
(soc_wr) and fight the write data (x), which the level-sensitive divider
preset latches capture -> the divider preset (and hence the whole channel)
goes x.  On the die the read-back drivers never contend with the write
path (phase-exclusive), so for Icarus we gate them off while soc_wr is
high (they are only needed for read-back accesses).

Usage: python3 make_wc.py   (reads apu_merged.v, writes apu_wc.v)
"""
import re

s = open('apu_merged.v').read()
insts = ['g869', 'g937', 'g939', 'g940', 'g941']
n = 0
for inst in insts:
    pat = re.compile(r'(dmg_notif0 ' + inst + r'\s+\(\.n_ena\()w548\)')
    s, cnt = pat.subn(r'\1w548_r)', s)
    n += cnt
assert n == 5, n
block = ('// w548_r: bus-model fix for Icarus (see STATUS.md / make_wc.py):\n'
         '\t// divider-state read drivers g869/g937/g939-941 enabled by the\n'
         '\t// w548 decode must not drive d during CPU writes (soc_wr) or the\n'
         '\t// level-sensitive preset latches capture x; gate them read-only.\n'
         '\twire w548_r;\n\tassign w548_r = w548 | soc_wr;\n\n\t')
s = s.replace('// Instances', block + '// Instances', 1)
open('apu_wc.v', 'w').write(s)
print('apu_wc.v written (%d drivers gated)' % n)
