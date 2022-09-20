# Sequencer

Status: All connections and the element base are ready. You can rebuild the circuit.

![locator_dispatch](/imgstore/locator_dispatch.png)

![seq](/imgstore/seq.jpg)

## Sequencer Inputs

|Signal|From|Description|
|---|---|---|
|CLK1|External| |
|CLK2|External| |
|CLK4|External| |
|CLK6|External|See `huge1` module|
|CLK8|External| |
|CLK9|External| |
|SYNC_RESET|External|Port T12|
|RESET|External|Port T13|
|Clock_WTF|External|Port T15|
|Unbonded|External|Port T16|
|WAKE|External|Port B25|
|Maybe1 (DL_Control1)|External|Port R3 (_Maybe used to disable all bus..._)|
|MMIO_REQ|External|Port R4. See `shielded` module|
|IPL_REQ|External|Port R5. See `shielded` module|
|Maybe2|External|Port R6. See `shielded` module|
|Seq_Control1|Bottom| |
|Seq_Control2|Bottom| |
|d93|Decoder1| |
|d99|Decoder1| |
|d100|Decoder1| |
|d101|Decoder1| |
|d102|Decoder1| |
|w11|Decoder2| |
|w18|Decoder2| |
|w20|Decoder2| |
|w26 (LoadIR)|Decoder2| |
|w32|Decoder2| |
|w33|Decoder2| |
|w40|Decoder2| |
|x41|Random Logic| |
|ALU_Out1|ALU| |
|IR|IR| |

## Sequencer Outputs

|Signal|To|Description|
|---|---|---|
|a\[25:0\]|Decoder1|Decoder1 inputs|
|LongDescr|External|Port T11 with long description|
|XCK_Ena|External|Port T14|
|RD|External|Port R1|
|WR|External|Port R2|
|MREQ|External|Port R7|
|nCLK4| |~CLK4|
|SeqOut_1|Bottom| |
|SeqOut_2|Decoder2, Random Logic| |
|SeqOut_3|Not connected| |

## Map

LR->TD order.

|Row|Blocks|
|---|---|
|1|not (x18), not, nand, not, nand, not, nand, nor, nor, hmm1, not|
|2|nor3, not, aoi_1, not, not, huge1, not, module3, module3, module3, module3, hmm2, not, not|
|3|module3, iwantsleep, not, nor, module3, nor3, not, module4, nor3, not, aoi_2, not, module3, hmm3, nor|
|4|module3, module3, nand, nor, not, module4, module3, not, nand, not, module3, module4, not, nand3, module4, shielded, not, module3, not, nor, module4, nor, nand, nand, not, not, nor4, module3, module3, not, nor, not, module4, nand, comb4, module4, not, comb5, not|
|5|not, nor|

## module3 - dff_comp

DFF on a complementary CLK (Dual Rails). Since we do not yet know the polarity of the CLK input signals, we can assume that this is a `negedge` DFF.

The picture uses CLK8 as the CLK, and CLK9 is used as the CLK complement (CCLK). I think I guessed it :smiley:

In fact, when using Dual Rails, you can easily turn a negedge DFF into a posedge by simply rearranging the CLK complement signals.

![module3](/imgstore/modules/module3.jpg)

![module3_tran](/imgstore/modules/module3_tran.jpg)

## module4 - rs_latch

A typical static latch, but made quite compact. The impressive gates on the FlipFlop, where the value is stored, are also a distinguishing feature.

Also: reset input in inverse polarity (`#RESET`).

![module4](/imgstore/modules/module4.jpg)

![module4_tran](/imgstore/modules/module4_tran.jpg)

## aoi_1 - aoi_21

1 AND x2 to OR inverted.

![aoi_1](/imgstore/modules/aoi_1.jpg)

![aoi_1_tran](/imgstore/modules/aoi_1_tran.jpg)

## aoi_2 - aoi_21

1 AND x2 to OR inverted.

![aoi_2](/imgstore/modules/aoi_2.jpg)

![aoi_2_tran](/imgstore/modules/aoi_2_tran.jpg)

## huge1 - dffre_comp

DFF with reset and complementary set enable, complementary CLK.

A rather complicated circuit to master:
- In the middle is a FlipFlop made of not and nor (nor is used for resetting)
- Input value can be written to FlipFlop only if CLK=1 and LD=1
- When LD=0 the FlipFlop value is updated with the old value
- The output contains a latch with a gate memory that opens when LD=0 (so that the old value is returned during the write (LD=1))
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

## hmm3 - slatch_comp

Static latch, complementary CLK.

Static means that the value is written on the CLK level, not on the edge of the signal, as in DFF.

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
