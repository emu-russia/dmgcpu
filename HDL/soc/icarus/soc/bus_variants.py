#!/usr/bin/env python3
"""Generate the d-bus simulation variants of the small-domain netlists
(issue #396, bus modelling).

The plain merged netlists reproduce the *static* drive conflicts of the
precharged internal data bus under Icarus (two strong notif drivers of
different levels -> x).  The variants below emulate the dynamic-bus
semantics that the die gets from precharge + discharge-only drivers:

* mmio_weakbus.v - MMIO without the const-1 "keeper" notif1 cells of the
  $FF04-$FF07 window (g234 -> d[4], g235 -> d[0], both `ena = w100`,
  `a = const0`).  Those keepers pull the two bits high during every
  FF04-07 access and fight the true read-back drivers when the read
  value bit is 0 (the DIV/TAC bit-0/4 x).  The environment's weak
  pull-ups keep the idle high level instead.
* ser_sharedq.v - Ser with the d[6] bus node un-linked from the shift
  chain terminal: in the extracted netlist `g2.db = g3.q = d[6]`, so the
  static model keeps d[6] permanently driven by cell g3's dffsr q.
  `g3.q` and the `ser_out` sampler `g21.d` are moved onto an internal
  `q6` node, leaving only the tristate `g2.db` on the bus (and the SC
  bit-0 read driver `g20`).

Regenerate:
    python3 bus_variants.py
"""
import re

def write_variant(src_path, out_path, subs, fixed_src=None):
    s = open(src_path).read() if fixed_src is None else fixed_src
    for old, new in subs:
        assert old in s, (src_path, old)
        s = s.replace(old, new)
    open(out_path, 'w').write(s)
    print(src_path, '->', out_path)

# --- mmio_weakbus.v: drop the FF04-07 window const keepers ---
src = open('mmio_merged.v').read()
lines = src.splitlines(keepends=True)
out = []
drop = 0
for ln in lines:
    if 'g234' in ln and '.x(d[4])' in ln and 'w100' in ln or \
       'g235' in ln and '.x(d[0])' in ln and 'w100' in ln:
        drop += 1
        continue
    out.append(ln)
assert drop == 2, drop
open('mmio_weakbus.v', 'w').write(''.join(out))
print('mmio_merged.v -> mmio_weakbus.v (dropped %d keeper cells)' % drop)

# --- ser_sharedq.v: fix the ser_reg_bit cell bus alias + un-link d[6]
# from the shift-chain terminal.
#
# 1) cell-level alias fix: inside ser_reg_bit the extracted netlist does
#    `assign db = w2;` where w2 is the cell's only bus node.  Under Icarus
#    that is a one-way driver: the cell's set/reset logic (which reads w2)
#    never sees the CPU-driven bus value -> SB writes latch x.  Rename the
#    internal w2 to the inout port db (delete the alias), so reads see the
#    bus and the tristate read driver drives the bus.
# 2) d[6] chain-terminal split: `g2.db = g3.q = d[6]` in the extraction;
#    the static model then keeps d[6] permanently driven by cell g3's dffsr
#    q.  g3.q and the ser_out sampler g21.d move onto internal node q6.
def fix_ser_cell(src):
    # operate only on the ser_reg_bit chunk (after 'module ser_reg_bit')
    head, _, tail = src.partition('module ser_reg_bit')
    chunk, _, rest = tail.partition('endmodule')
    assert 'module Ser ' in head
    chunk = chunk.replace('	assign db = w2;\n', '')
    # w2 in this scope = the bus node (db); drop its old declaration
    chunk = re.sub(r'^\s*wire\s+w2\s*;\s*\n', '', chunk, flags=re.M)
    chunk = re.sub(r'\bw2\b', 'db', chunk)
    return head + 'module ser_reg_bit' + chunk + 'endmodule' + rest

src = open('ser_merged.v').read()
src = fix_ser_cell(src)
write_variant('ser_merged.v', 'ser_sharedq.v', [
    # declare the internal terminal node near the other wires
    ("	wire w45;\n",
     "	wire w45;\n	wire q6;\n"),
    # cell g3: chain output goes to the internal node, not the bus
    ("	ser_reg_bit g3 (.d(w3), .q(d[6]), .clk(w6), .oe(w27), .n_ie(w15), .nres(w21), .ie(w20), .db(d[7]) );",
     "	ser_reg_bit g3 (.d(w3), .q(q6), .clk(w6), .oe(w27), .n_ie(w15), .nres(w21), .ie(w20), .db(d[7]) );"),
    # ser_out sampler: sample the chain terminal (was d[6] = g3.q)
    ("	dmg_dffr g21 (.clk(w5), .nr1(w21), .nr2(w21), .d(d[6]), .q(w18) );",
     "	dmg_dffr g21 (.clk(w5), .nr1(w21), .nr2(w21), .d(q6), .q(w18) );"),
], fixed_src=src)
