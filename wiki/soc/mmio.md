# Memory Mapped I/O

> [!CAUTION]
> The netlist and design only, everything is very raw and untested.

![locator_mmio](/imgstore/soc/locator_mmio.jpg)

![mmio](/imgstore/soc/mmio.jpg)

It also contains a piece of arbitration for `a[14:8]`. [^1] 

[^1]: The chip is topologically arranged so that the address bus arbitration is divided into three parts: in [arb](arb.md), in [mmio](mmio.md), and in [apu](apu.md), to equalize wire lengths.

## Signals

TBD.

## Netlist

![mmio_netlist](/imgstore/soc/mmio_netlist.png)

## Annotated Design

TBD.

![mmio](/HDL/soc/design/mmio.png)

## Map

|Row|Cells|
|---|---|
|1|not, not, nor, nand, nor, nand, nor, nand, bufif0, bufif0, bufif0, bufif0, latch, latch, latch, latch, latch, not, aon, not, aon, not, nand3, and3, not, not, not, nand, dffsr, not, not, not, not, dffsr, not, not2, nand3, nand, dffr, nand, not, not, nor, not, dffr, not, nor, nor_latch, not, and|
|2|nor, nand, not, not, nand, nor, not, bufif0, not, nor, dffr, not, nand3, or, mux, mux, dffr, mux, mux, not, mux, nor, not, not, or, latch, or, latch, nand3, nor3, latchnq_comp, nand3, and3, nand, dffr, dffr, dffr, dffr, nand, and, not2, nand, dffr, and|
|3|not, bufif0, nor, dffr, nor, cnt, latch, muxi, notif1, dffsr, or, dffr, notif1, latch, notif1, latch, notif1, latchnq_comp, or, latchnq_comp, dffr, dffr, not, dffr, nand6, dffr, latchnq_comp, nor, not|
|4|not, nand, nor, cnt, cnt, cnt, mux, nor, nor, nor, notif1, nand3, and3, muxi, or, notif1, dffr, notif1, notif1, not, latch, latchnq_comp, notif1, notif1, latchnq_comp, const, latchnq_comp, latch, mux, dffr, dffr, latchnq_comp, not, notif1, not, and|
|5|nor, nor, cnt, cnt, nor, cnt, notif1, muxi, cnt, or, notif1, muxi, muxi, notif1, notif1, not, bufif0, notif1, not, nor, nand, mux, not, notif1, not, notif1, notif1, notif1, notif1, notif1, notif1, notif1, notif1, notif1, notif1, notif1, notif1, notif1, and3, nand4, nand4|
|6|not, muxi, notif1, muxi, notif1, notif1, dffr, muxi, notif1, notif1, notif1, or, notif1, notif1, dffr, notif1, dffr, notif1, dffr, dffr, or, nor, notif1, dffr, dffr, nand4, dffr, notif1, and4, not, not, and3, and4, nor4, nor5|
|7|or3, nor_latch, not, dffr, dffr, dffr, and3, nand3, dffr, notif1, dffr, not3, nand4, not3, and4, nand4, and4, nor, and4, not, and4, not, and3, nand3, muxi, dffr, muxi, dffr, notif1, dffr, dffr, notif1, notif1, notif1|
|8|and, dffr, dffr, dffr, dffsr, nor, not, not, and, nand3, not, and, dffr, not, muxi, muxi, or, not, nor3, nand, nand, nor, nand4, and4, nand4, and4, not, muxi, dffsr, mux, dffr, not, not, dffr, dffr, not2, not, not, not, notif1|