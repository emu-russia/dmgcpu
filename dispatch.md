# Sequencer

:warning: The section is in development.

![locator_dispatch](/imgstore/locator_dispatch.png)

![seq](/imgstore/seq.jpg)

TBD.

## Sequencer Inputs

|Signal|From|Description|
|---|---|---|
|CLK1|External| |
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
|unnamed|External|Port R4. See `shielded` module|
|unnamed|External|Port R5. See `shielded` module|
|unnamed|External|Port R6. See `shielded` module|
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
|SeqOut_2|Bottom| |
|SeqOut_3|Bottom| |

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

## aoi_1

![aoi_1](/imgstore/modules/aoi_1.jpg)

TBD.

## aoi_2

![aoi_2](/imgstore/modules/aoi_2.jpg)

TBD.

## huge1

![huge1](/imgstore/modules/huge1.jpg)

TBD.

## hmm1 - oai_21

1 OR x2 to AND inverted.

![hmm1](/imgstore/modules/hmm1.jpg)

![hmm1_tran](/imgstore/modules/hmm1_tran.jpg)

## hmm2

![hmm2](/imgstore/modules/hmm2.jpg)

TBD.

## hmm3

![hmm3](/imgstore/modules/hmm3.jpg)

TBD.

## iwantsleep - oai_21

1 OR x2 to AND inverted.

![iwantsleep](/imgstore/modules/iwantsleep.jpg)

![iwantsleep_tran](/imgstore/modules/iwantsleep_tran.jpg)

## shielded

Very cleverly twisted combined logic. Bravo, SHARP engineers!

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
