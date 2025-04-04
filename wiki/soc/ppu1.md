# PPU1

> [!CAUTION]
> The netlist and design only, everything is very raw and untested.

![ppu1](/imgstore/soc/ppu1.jpg)

## Signals

TBD.

## Netlist

![ppu1_netlist](/imgstore/soc/ppu1_netlist.png)

## Annotated Design

TBD.

![ppu1](/HDL/soc/design/ppu1.png)

## Map

|Row|Cells|
|---|---|
|1|nand, not, not, not, nand, not2, latch_comp, not2, not, not, nand, nand, not2, latch_comp, not, nand, nand, not, nand_latch, not2, and, not2, nand, not, nand, dffr, dffr, not, not, nand, dffr, not, not, not2, not, not2, not2, not2, not, not, not, notif0, latchnq_comp, notif0, notif0, notif0, latchnq_comp, notif0, latchnq_comp, notif0, latchnq_comp, notif0, notif0, notif0, latchnq_comp, latchnq_comp, notif0, not2, notif0, not2, not2, notif0, not2, dffr, dffr, dffr, dffr, dffr, not, nor, not, notif0, nand, notif0, notif0, notif0, not, nand, dffsr, notif0, not, nand, nand, not, dffr, not, dffr, not, not, not, nand, nand, not, nand, nand, dffsr, dffsr, not, not, not, not, nand, and3, not, not, and3, not, not, and3, and3|
|2|not, nand, nand, dffsr, latch_comp, dffsr, latch_comp, dffsr, latch_comp, dffsr, nand3, not, dffr, nor3, and, not, not, not, not, not, and, and, not2, not, latchnq_comp, latchnq_comp, not, not, notif0, notif0, not, notif0, latchr_comp, latchr_comp, xnor, not, latchr_comp, notif0, notif0, latchr_comp, not, latchr_comp, notif0, not, notif0, not, latchr_comp, dffr, dffr, notif0, dffr, dffr, dffr, latchnq_comp, latchnq_comp, latchnq_comp, latchnq_comp, latchnq_comp, nand, dffsr, nor, xor, latch_comp, latch_comp, nand, nand, or3, aon2222, not, aon2222, nand, dffsr, nand, nand, or3, nand, nand, or3, not, not, not3, not3|
|3|nand, not, nand, dffsr, latch_comp, dffsr, nand, not, nand, dffsr, nand, nand, not, latch_comp, latch_comp, dffr, not, nand3, not, nand, not, and, dffr, nor, nor3, not, dffr, dffr, not, and, dffr, latchr_comp, xnor, xnor, latchr_comp, xnor, not, not, nand5, xnor, latchr_comp, latchr_comp, xnor, latchr_comp, xnor, latchr_comp, nor8, not, and4, xnor, latchr_comp, latchr_comp, latchr_comp, xnor, not, latchr_comp, dffr, dffr, latchnq_comp, dffsr, not, aon2222, aon2222, dffsr, dffsr, and3, and3, not, not, and3, not, not, nor, dffsr, not2|
|4|dffsr, dffr_comp, dffr_comp, dffr_comp, dffr_comp, dffr_comp, dffr_comp, dffr_comp, mux, mux, mux, mux, mux, and, mux, mux, mux, nor_latch, dffr, nor_latch, and, nor, not, dffr, not2, not, dffr, nor, nand, nor, xnor, nand5, xnor, not, dffr, xnor, dffr, notif0, notif0, xnor, notif0, nor, xnor, nand5, nand5, xnor, xnor, notif0, notif0, notif0, or, not, not, notif0, notif0, notif0, not, not, dffr, nor3, notif0, latchnq_comp, nand, latchnq_comp, latch_comp, not, not, latch_comp, latch_comp, and3, nand, not3, dffsr, nand, nand, or3, or3, nand, dffsr, nand, dffsr, not2, not2, not2|
|5|not, notif0, notif0, notif0, notif0, not, nand, nand, notif1, nand, dffsr, nand, not, nand, nand, nand, dffsr, not, dffr_comp, notif0, not, nand, not, notif1, notif1, and, dffr, and, not, dffr, not, nor_latch, not, not3, dffr, nand4, dffr, nand3, nor3, dffr, xor, not, not, or, nor_latch, xor, notif0, notif0, xor, not, notif0, notif0, latchr_comp, or3, xor, xor, and, not, nand, not, and, not, not, latchr_comp, latchr_comp, latchr_comp, latchr_comp, nor_latch, dffr, and, latch_comp, notif0, latch_comp, not, notif0, not, latch_comp, latch_comp, latch_comp, dffr, nand, or, nand, not, dffsr, not, nand, nand, or3, dffsr, nand, nand, not, not3, not2, not2|
|6|and, dffsr, nand, nand, dffsr, nand, not, dffsr, dffsr, nand, nand, notif1, notif1, nand, not, nand, nand, dffr, not, dffr, nor, nand4, not, not2, not, not2, nor3, not4, or, or, not, dffr, xnor, xnor, xnor, dffr, and, xor, dffr, dffr, latchr_comp, latchr_comp, latchr_comp, latchr_comp, nand, nor4, xor, nor4, and, dffr, aon2222, nor, nor3, notif0, notif1, not, nor, latch_comp, latch_comp, not, latch_comp, not, latch_comp, not, not, not, latch_comp, latch_comp, not, dffr, not2, dffr, not, not, nand, nand, dffsr, dffr, and4, not, nand, dffsr|
|7|dffr, dffr, not, dffr, dffr, dffr, dffsr, not2, notif1, nand, not, dffsr, nand_latch, and4, not, not2, not, not, or3, and, and3, dffr, and, not, nand, and, nor, not, not, dffr, dffr, dffr, xor, and, nand3, dffr, dffr, dffr, not, xor, nand, nor3, xor, xor, xor, dffr, and, not, and, not, not, nand, nand, notif1, not4, not, or, not, nand, nand, and, nand, nand, or3, nand, nand, nand, not, not, nand, nand, not2, not, not2, not, nand, nand, dffr, dffr, not, nand, nand, dffr, dffr, not, not, nand7, nand4, nand7, not, not, nand7, nand|
|8|not3, not3, notif0, notif0, dffr, notif1, notif0, notif0, dffr, dffr, notif0, notif0, const, and, notif1, notif0, notif0, nor, notif1, nand5, not, not2, not2, not2, not2, nor, dffr, nor3, dffr, and, not, notif0, latchr_comp, notif0, and, not, notif0, not, not, not, not, not, and, and, notif0, notif0, notif0, or, notif0, notif0, not, latchr_comp, latchr_comp, latchr_comp, dffr, dffsr, dffsr, dffsr, nand, not, dffsr, nand, dffsr, or3, nand, dffsr, dffsr, nand, or3, not, dffsr, dffr, and3, and3, and3, not, nand7, not, not, and3, not, not, not|
|9|dffr, dffr, dffr, dffr, not, notif0, notif0, notif0, notif0, not2, nand3, not, not2, nand5, not, nand5, nand5, nand5, nand5, nand5, nand5, nand5, nand5, not, not, nand5, nand5, or, and, and, nor_latch, and, latchr_comp, notif0, latchr_comp, not, and, latchr_comp, and, and, not2, notif0, notif0, not2, and, not, not, not, notif0, not2, not2, notif0, notif0, notif0, nor_latch, notif0, and, not, dffr, nor, dffr, dffsr, nand, notif1, nand, nand, not, dffsr, or3, not, and, dffsr, not, dffsr, dffsr, nand, not, nand, dffsr, aon2222, aon2222, not, not, nand, not, dffsr, nand, not|
|10|dffr, not2, notif0, notif0, notif0, nor, not2, notif0, notif0, notif0, notif0, not, nand, notif0, not, notif0, and, notif0, notif0, nor3, not, notif0, notif0, not, and, not, not2, not2, not, not2, dffr, not2, dffr, not2, not, not, nor_latch, and, not, not, xor, not, nand3, not, notif0, latchr_comp, notif0, latchr_comp, latchr_comp, latchr_comp, not, nand5, and, not2, and, and, xor, dffr, not2, and, not, not, not, not, and, not, not, not, not2, not2, not, and, not, dffr, nand, not, not, latchr_comp, not2, not, nor, not, not, not, nand, nand, not2, and, and, not, not, nand, not, not, and, notif0, latchnq_comp, notif0, latchnq_comp, nand, notif0, latchnq_comp, notif0, latchnq_comp, notif0, latchnq_comp, not, nand, notif0, latchnq_comp, not, notif0, latchnq_comp, not, latchnq_comp, notif0, nand, not, nand, nand, dffsr, not, not|