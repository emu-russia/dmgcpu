# SHARP DMG CPU Cells Library

![dmg_cells](/imgstore/soc/dmg_cells.png)

![dmglib](/imgstore/soc/dmglib.png)

The cells shown are only part of the SHARP cell library (name?), other cell types will probably be found in other chips of this era.

## Symmetry group

- In general, the dihedral group 4 (D4) is used for cells
- By agreement among all researchers ident position of the cell (`e`) - when the ground is on the left
- As part of modules, cells are usually simply reflected relative to the vertical axis `e <-> b` (for ClkGen and Ser modules, cells are additionally rotated “sideways”)
- As part of macro cells (memory), cells can be arranged arbitrarily, as is more convenient 

![Dih4_cycle_graph](/imgstore/Dih4_cycle_graph.png)

## Dual-rail CLK

Sequential elements (latch, dff) are presented in two variants: with single-rail CLK and with dual-rail CLK (CLK + complement CLK). Where dual-rail CLK is used, the suffix `comp` is used in the cell name.

## Cells list

The following are all cell types, in alphabetical order. The names of cells by @msinger (http://iceboy.a-singer.de/doc/dmg_cells.html) are shown in parentheses (where the correspondence is not obvious)
The topology is not complete (m1 is missing in some places), but it is sufficient to understand the cell architecture for reimplementation.

## and

![and](/imgstore/modules/soc/and.jpg)

## and3

![and3](/imgstore/modules/soc/and3.jpg)

## and4

![and4](/imgstore/modules/soc/and4.jpg)

## aon (AO1)

![aon](/imgstore/modules/soc/aon.jpg)

## aon22 (AO2)

![aon22](/imgstore/modules/soc/aon22.jpg)

## aon222 (AO3)

![aon222](/imgstore/modules/soc/aon222.jpg)

## aon2222 (AO4)

![aon2222](/imgstore/modules/soc/aon2222.jpg)

## aon222222 (AO6)

![aon222222](/imgstore/modules/soc/aon222222.jpg)

## bufif0 (TRI_BUF_IF0)

![bufif0](/imgstore/modules/soc/bufif0.jpg)

## cnt (TFFD)

![cnt](/imgstore/modules/soc/cnt.jpg)

## const

![const](/imgstore/modules/soc/const.jpg)

## dffr - Posedge DFF With Single-rail CLK Synchronous Dual-rail Inverse Polarity Reset Q/NQ Output (DFFR_B2)

The #res input is fed separately to the Master and Slave MUX so that synchronous reset can be done. But usually #res1 and #res2 are connected externally, so the DFF becomes with asynchronous reset.
The dual-rail ck/cck signals are obtained locally by demultiplexing the CLK input signal.

![dffr](/imgstore/modules/soc/dffr.jpg)

![dffr_tran](/imgstore/modules/soc/dffr_tran.jpg)

## dffr_comp (DFFR_A)

![dffr_comp](/imgstore/modules/soc/dffr_comp.jpg)

## dffrnq_comp (DFFR_B1)

![dffrnq_comp](/imgstore/modules/soc/dffrnq_comp.jpg)

## dffsr - Posedge DFF With Single-rail CLK Synchronous Dual-rail Inverse Polarity Set Asynchronous Inverse Polarity Reset Q/NQ Output (DFFSR)

![dffsr](/imgstore/modules/soc/dffsr.jpg)

## fa

![fa](/imgstore/modules/soc/fa.jpg)

## ha

![ha](/imgstore/modules/soc/ha.jpg)

![ha_tran](/imgstore/modules/soc/ha_tran.jpg)

## latch (D_LATCH_B)

![latch](/imgstore/modules/soc/latch.jpg)

## latch_comp (D_LATCH_A2)

![latch_comp](/imgstore/modules/soc/latch_comp.jpg)

## latchnq_comp (D_LATCH_A)

![latchnq_comp](/imgstore/modules/soc/latchnq_comp.jpg)

## latchr_comp (DR_LATCH)

![latchr_comp](/imgstore/modules/soc/latchr_comp.jpg)

## mux

![mux](/imgstore/modules/soc/mux.jpg)

## muxi

![muxi](/imgstore/modules/soc/muxi.jpg)

## nand

![nand](/imgstore/modules/soc/nand.jpg)

## nand3

![nand3](/imgstore/modules/soc/nand3.jpg)

## nand4

![nand4](/imgstore/modules/soc/nand4.jpg)

## nand5

![nand5](/imgstore/modules/soc/nand5.jpg)

## nand6

![nand6](/imgstore/modules/soc/nand6.jpg)

## nand7

![nand7](/imgstore/modules/soc/nand7.jpg)

## nand_latch

![nand_latch](/imgstore/modules/soc/nand_latch.jpg)

## nor

![nor](/imgstore/modules/soc/nor.jpg)

## nor3

![nor3](/imgstore/modules/soc/nor3.jpg)

## nor4

![nor4](/imgstore/modules/soc/nor4.jpg)

## nor5

![nor5](/imgstore/modules/soc/nor5.jpg)

## nor6

![nor6](/imgstore/modules/soc/nor6.jpg)

## nor8

![nor8](/imgstore/modules/soc/nor8.jpg)

## nor_latch

![nor_latch](/imgstore/modules/soc/nor_latch.jpg)

## not

![not](/imgstore/modules/soc/not.jpg)

## not2

![not2](/imgstore/modules/soc/not2.jpg)

## not3

![not3](/imgstore/modules/soc/not3.jpg)

## not4

![not4](/imgstore/modules/soc/not4.jpg)

## not6

![not6](/imgstore/modules/soc/not6.jpg)

## notif0 (TRI_INV_IF0)

![notif0](/imgstore/modules/soc/notif0.jpg)

## notif1 (TRI_INV_IF1)

![notif1](/imgstore/modules/soc/notif1.jpg)

## oai

![oai](/imgstore/modules/soc/oai.jpg)

## oan (OA)

![oan](/imgstore/modules/soc/oan.jpg)

## or

![or](/imgstore/modules/soc/or.jpg)

## or3

![or3](/imgstore/modules/soc/or3.jpg)

## or4

![or4](/imgstore/modules/soc/or4.jpg)

## xnor

![xnor](/imgstore/modules/soc/xnor.jpg)

## xor

![xor](/imgstore/modules/soc/xor.jpg)
