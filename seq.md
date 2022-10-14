# Sequencer

Status: The circuit is fully restored as HDL.

![locator_seq](/imgstore/locator_seq.png)

![seq](/imgstore/seq.jpg)

![Seq](/HDL/Design/Seq.png)

## Sequencer Inputs

|Signal|From|Description|
|---|---|---|
|CLK1|External|To g84|
|CLK2|External|To g84|
|CLK4|External| |
|CLK6|External|See `huge1` module|
|CLK8|External| |
|CLK9|External| |
|SYNC_RESET|External|Port T12|
|RESET|External|Port T13|
|Clock_WTF (OSC_STABLE)|External|Port T15. To nand g59|
|Unbonded|External|Port T16|
|WAKE|External|Port B25|
|Maybe1 (DL_Control1)|External|Port R3 (_Maybe used to disable all bus..._)|
|MMIO_REQ|External|Port R4. See `shielded` module|
|IPL_REQ|External|Port R5. See `shielded` module|
|Maybe2|External|Port R6. See `shielded` module|
|Seq_Control1|Bottom|To g42|
|Seq_Control2|Bottom|To nand g79|
|d93|Decoder1|To g52, g78|
|d99|Decoder1|To g80, g91, g94|
|d100|Decoder1|To g46|
|d101|Decoder1|To nand g65|
|d102|Decoder1|See `huge1` module|
|w6|Decoder2|Goes to WR|
|w11|Decoder2|See `shielded` module|
|w18|Decoder2|To g26|
|w20|Decoder2|To not g22|
|w26 (LoadIR)|Decoder2|See `huge1` module. Also: g26, g39|
|w32|Decoder2|To not g18|
|w33|Decoder2|To not g20|
|w40|Decoder2|To g38|
|x41|Decoder3|To g87, g94|
|ALU_Out1|ALU|To nor g24|
|IR|IR|Used to form the inputs of Decoder1. IR3 and IR4 are also used in other places.|

## Sequencer Outputs

|Signal|To|Description|
|---|---|---|
|a\[25:0\]|Decoder1|Decoder1 inputs|
|LongDescr (CLK_ENA)|External|See g49|
|XCK_Ena (OSC_ENA)|External|Port T14|
|RD|External|Port R1|
|WR|External|Port R2|
|MREQ|External|Port R7|
|nCLK4| |~CLK4|
|SeqOut_1|Bottom| |
|SeqOut_2|Decoder2, Decoder3| |
|SeqOut_3|GND -> Not connected| |

## Map

LR->TD order.

|Row|Blocks|
|---|---|
|1|not (x18), not, nand, not, nand, not, nand, nor, nor, hmm1, not|
|2|nor3, not, aoi_1, not, not, huge1, not, module3, module3, module3, module3, hmm2, not, not|
|3|module3, iwantsleep, not, nor, module3, nor3, not, module4_2, nor3, not, aoi_2, not, module3, hmm3, nor|
|4|module3, module3, nand, nor, not, module4, module3, not, nand, not, module3, module4, not, nand3, module4, shielded, not, module3, not, nor, module4, nor, nand, nand, not, not, nor4, module3, module3, not, nor, not, module4, nand, comb4, module4, not, comb5, not|
|5|not, nor|

## module3 - dff_posedge_comp

DFF on a complementary CLK (Dual Rails).

Since the polarity of CLKs is now known (CLK9 = CLK, CLK8 = CCLK), we can say for sure that it is posedge DFF.

In fact, when using Dual Rails, you can easily turn a posedge DFF into a negedge by simply rearranging the CLK complement signals.

A distinctive feature of the circuits that do Edge Detection is the two serial MUX's that are opened complementary to the CLK. Using black magic and propagation delay - the edge of the signal is caught.

![module3](/imgstore/modules/module3.jpg)

![module3_tran](/imgstore/modules/module3_tran.jpg)

Note: If the DFF input goes to a MUX, which opens at CLK=0 by a P-type MOSFET, it is a posedge DFF.

![Modern_dff](/imgstore/Modern_dff.jpg)

## module4 - rs_latch

A typical static latch, but made quite compact. The impressive gates on the FlipFlop, where the value is stored, are also a distinguishing feature.

Also: reset input in inverse polarity (`#RESET`).

![module4](/imgstore/modules/module4.jpg)

![module4_tran](/imgstore/modules/module4_tran.jpg)

## module4_2 - rs_latch2

Initially it was mistaken for module4, but after a detailed study it became clear that the lower part is different.

![module42](/imgstore/modules/module42.jpg)

![module42_tran](/imgstore/modules/module42_tran.jpg)

This is essentially the same rs_latch (see above), but with the inputs rearranged.

(I rechecked all the other modules4).

## aoi_1 - aoi_21

1 AND x2 to OR inverted.

![aoi_1](/imgstore/modules/aoi_1.jpg)

![aoi_1_tran](/imgstore/modules/aoi_1_tran.jpg)

## aoi_2 - aoi_21

1 AND x2 to OR inverted.

![aoi_2](/imgstore/modules/aoi_2.jpg)

![aoi_2_tran](/imgstore/modules/aoi_2_tran.jpg)

## huge1 - latchr_comp

Latch with Active-High reset and complementary set enable, complementary CLK.

A rather complicated circuit to master:
- In the middle is a FlipFlop made of not and nor (nor is used for resetting)
- Input value can be written to FlipFlop only if CLK=1 and LD=1
- When LD=0 the FlipFlop value is updated with the old value
- The output contains a DLatch with a gate memory that opens when LD=0 (so that the old value is returned during the write (LD=1))
- So the written value becomes relevant when LD 1->0 changes (when the output latch opens and is updated with the value from FlipFlop). The same applies to resetting if you do it at the same time as LD=1.
- The whole thing is complicated by the complementary layout of the LD and CLK signals.

By the way, there are 2 `not` in the circuit to form the complement, one of which takes `CLK6` signal as input and the second `not` takes `LoadIR` signal as input.

![huge1](/imgstore/modules/huge1.jpg)

![huge1_tran](/imgstore/modules/huge1_tran.jpg)

## hmm1 - oai_21

1 OR x2 to AND inverted.

![hmm1](/imgstore/modules/hmm1.jpg)

![hmm1_tran](/imgstore/modules/hmm1_tran.jpg)

## hmm2 - aoi_31

1 AND x3 to OR inverted.

![hmm2](/imgstore/modules/hmm2.jpg)

![hmm2_tran](/imgstore/modules/hmm2_tran.jpg)

## hmm3 - latch_comp

Latch, complementary CLK.

Latch means that the value is written on the CLK level, not on the edge of the signal, as in DFF.

Output in inverse polarity (`#Q`).

![hmm3](/imgstore/modules/hmm3.jpg)

![hmm3_tran](/imgstore/modules/hmm3_tran.jpg)

## iwantsleep - oai_21

1 OR x2 to AND inverted.

![iwantsleep](/imgstore/modules/iwantsleep.jpg)

![iwantsleep_tran](/imgstore/modules/iwantsleep_tran.jpg)

## shielded

Very cleverly twisted combined logic. Bravo, SHARP engineers!

This module is essentially used to generate the `#MREQ` signal. Below is `not` to invert it into a `MREQ` signal and output it to the outside.

![shielded](/imgstore/modules/shielded.jpg)

![shielded_tran](/imgstore/modules/shielded_tran.jpg)

## comb4 - aoi_221_dyn

2 AND x2 to OR-3 inverted, dynamic.

![comb4](/imgstore/modules/comb4.jpg)

![comb4_tran](/imgstore/modules/comb4_tran.jpg)

## comb5 - aoi_22_dyn

2 AND x2 to OR inverted, dynamic.

![comb5](/imgstore/modules/comb5.jpg)

![comb5_tran](/imgstore/modules/comb5_tran.jpg)

## Logic behind additional Decoder inputs

TBD.

|Extra Decoder1 Input|Meaning|
|---|---|
|a1|??? TBD. |
|a3|??? TBD. |
|a20|??? TBD. |
|a22|??? TBD. |
|a24|??? TBD. |
