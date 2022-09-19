# Decoder 2

:warning: The section is in development.

![locator_decoder2](/imgstore/locator_decoder2.png)

Refines the decoded operation code and reduces the total number of outputs for random logic. Implemented as densely packed NOR trees.

![decoder2](/imgstore/decoder2.jpg)

## Decoder2 Inputs

The outputs `d[106:0]` from [Decoder1](decoder1.md) are input.

## Decoder2 Output Driver

TBD.

## Decoder2 Outputs

The outputs of Decoder1 have three paths:
- Stay inside Decoder2 and form one of Decoder2's outputs with the rest of the signals
- Go outside
- Stay inside AND go outside

All outputs are clocked by the `CLK2` signal.

|Output|Name|To|Description|
|---|---|---|---|
|w0| | | |
|w1| | | |
|w2| |Bottom| |
|w3| |ALU, Bottom| |
|w4| | | |
|w5| | | |
|w6| | | |
|w7| | | |
|w8| |Bottom, Thingy| |
|w9| |ALU, Bottom| |
|w10| |ALU| |
|w11| |Sequencer (only)| |
|w12| |ALU| |
|w13| | | |
|w14| | | |
|w15| |ALU| |
|w16| | | |
|w17| |Bottom| |
|w18| |Bottom, Sequencer| |
|w19| |ALU, Bottom| |
|w20| |Sequencer (only)| |
|w21| |Bottom| |
|w22| | | |
|w23| |Bottom| |
|w24| | | |
|w25| | | |
|w26|LoadIR|Bottom, Sequencer, External| |
|w27| | | |
|w28| | | |
|w29| | | |
|w30| | | |
|w31| | | |
|w32| |Sequencer (only)| |
|w33| |Sequencer (only)| |
|w34| | | |
|w35| |Thingy (only)| |
|w36| | | |
|w37| | | |
|w38| | | |
|w39| | | |
|w40| |Sequencer| |

(If `wx` signal goes to Random Logic it is not indicated in the table).

## Nor Trees

|Tree|Image|Paths|
|---|---|---|
|w0|![w0](/imgstore/nortrees/w0.jpg)|{4,5,6,7}|
|w1|![w1](/imgstore/nortrees/w1.jpg)|{0,1,w27}|
|w2| | |
|w3| | |
|w4| | |
|w5| | |
|w6| | |
|w7| | |
|w8| | |
|w9| | |
|w10| | |
|w11| | |
|w12| | |
|w13| | |
|w14| | |
|w15| | |
|w16| | |
|w17| | |
|w18| | |
|w19| | |
|w20| | |
|w21| | |
|w22| | |
|w23| | |
|w24| | |
|w25| | |
|w26| | |
|w27| | |
|w28| | |
|w29| | |
|w30| | |
|w31| | |
|w32|![w32](/imgstore/nortrees/w32.jpg)|{0,12,13,24,28,30,32,33,36,37,45,47,50,56,59,62,66,68,70,71,75,76,77,83,90,91,92,93,97}|
|w33| | |
|w34| | |
|w35| | |
|w36| | |
|w37| | |
|w38| | |
|w39| | |
|w40| | |

The numbers in the path refer to Decoder1 outputs `d[106:0]`. Sometimes there are other inputs in the tree, and they are marked that way.

The result is a multi-input NOR (the dynamic part is not shown in the picture):

![demo_w1](/imgstore/nortrees/demo_w1.jpg)

To convert trees into a schematic, you can use a script to generate an HDL.
