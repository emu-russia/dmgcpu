# Decoder 2

:warning: The section is in development.

![locator_decoder2](/imgstore/locator_decoder2.png)

Refines the decoded operation code and reduces the total number of outputs for random logic. Implemented as densely packed logic.

![decoder2](/imgstore/decoder2.jpg)

The outputs `d[106:0]` from [Decoder1](decoder1.md) are input.

The outputs of Decoder1 have three paths:
- Stay inside Decoder2 and form one of Decoder2's outputs with the rest of the signals
- Go outside
- Stay inside AND go outside

## Decoder2 Output Driver

TBD.

## Decoder2 Outputs

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
