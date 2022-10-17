# Decoder2

Status: A double check of the correctness of the restored trees is required.

![locator_decoder2](/imgstore/locator_decoder2.png)

Refines the decoded operation code and reduces the total number of outputs for Decoder3. Implemented as densely packed NOR trees.

![decoder2](/imgstore/decoder2.jpg)

## Decoder2 Inputs

The outputs `d[106:0]` from [Decoder1](decoder1.md) are input.

## Decoder2 Output Drivers

Some drivers are inverters and some are buffers.

![decoder2_drv](/imgstore/modules/decoder2_drv.jpg)

The output drivers act as signal amplifiers and are also used as "domino" logic, to translate dynamic CMOS logic into conventional logic.

## Decoder2 Outputs

The inputs from Decoder1 have three paths:
- Stay inside Decoder2 and form one of Decoder2's outputs with the rest of the signals
- Go outside
- Stay inside AND go outside

All Decoder2 outputs are clocked by the `CLK2` signal.

|Output|Name|To|Description|
|---|---|---|---|
|w0| | | |
|w1| |Bottom|TempLow/TempHigh to cbus/dbus|
|w2| |Bottom|TempLow/TempHigh to cbus/dbus|
|w3| |ALU, Bottom|A to abus|
|w4| | | |
|w5| | | |
|w6|WR|External, Thingy|To external WR port|
|w7|nIR7|Not connected|Not used|
|w8| |Bottom, Thingy|PCL/PCH to abus/dbus|
|w9| |ALU, Bottom|SPH to abus; Also bc/bq Logic|
|w10| |ALU| |
|w11| |Sequencer (only)| |
|w12| |ALU| |
|w13| | | |
|w14| | | |
|w15| |ALU, Bottom|SPL to bbus (only if IR4=IR5=1); Set abus to 0|
|w16| | | |
|w17| |Bottom|TempLow/0 to cbus/dbus|
|w18| |Sequencer| |
|w19| |ALU, Bottom|SPH to bbus (only if IR4=IR5=1); H to abus|
|w20| |Sequencer (only)| |
|w21| |Bottom|bc/bq Logic|
|w22| | | |
|w23| |Bottom|SPL to abus|
|w24| | | |
|w25| |Bottom|PCL/PCH to cbus/dbus|
|w26|LoadIR|Bottom, Sequencer, External|DL to IR|
|w27| | | |
|w28| |Bottom|PCH to DL|
|w29| |Bottom|Set dbus to 0|
|w30| | | |
|w31| |Thingy (only)| |
|w32| |Sequencer (only)| |
|w33| |Sequencer (only)| |
|w34| |Bottom (only)|PCL to DL|
|w35| |Thingy (only)| |
|w36| |Bottom|gbus/kbus to PCL/PCH|
|w37| |ALU| |
|w38| | | |
|w39| | | |
|w40| |Sequencer| |

(If `wx` signal goes to Decoder3 it is not indicated in the table).

## Nor Trees

|Tree|Paths|Output Driver|
|---|---|---|
|w0|{4,5,6,7}|not|
|w1|{0,1,w27}|not|
|w2|Does not use NOR tree|`d[103]`|
|w3|Does not use NOR tree|`d[3]`|
|w4|{0,28}|not|
|w5|{2,26}|not|
|w6|{0,12,13,24,28,30,32,38,47,50,56,60,66,68,70,73,75,92,93,97}|not|
|w7|Does not use NOR tree|`~IR[7]`. :warning: Not used (not connected).|
|w8|Does not use NOR tree|`d[19]`|
|w9|{21,22}|not|
|w10|{23,24}|not|
|w11|{32,59,0,1,2,9,10,12,13,15,16,17,18,20,22,23,24,26,28,29,30,31,33,34,38,40,43,44,46,47,50,51,52,55,56,57,58,60,61,63,64,65,66,67,68,69,70,71,72,73,75,78,79,80,81,82,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105}|not|
|w12|Does not use NOR tree|`d[27]`|
|w13|{28,29}|not|
|w14|{30,32}|not|
|w15|Does not use NOR tree|`d[35]`|
|w16|{36,37}|not|
|w17|{32,59}|not|
|w18|{1,9,10,15,20,29,31,33,43,44,51,52,57,59,61,63,65,67,69,71,72,79,80,82,86,87,90,91,95,104,105}|not|
|w19|Does not use NOR tree|`d[46]`|
|w20|{0,1,6,9,11,13,15,20,21,24,28,29,30,31,32,35,36,37,39,43,45,47,50,51,56,57,60,61,62,63,65,66,68,69,70,72,74,76,82,83,86,92,93,95,97,104}|not|
|w21|Does not use NOR tree|`d[50]`|
|w22|{24,33,47,56,57,62,68,69,70,81,90,95,97}|not|
|w23|{53,54}|not|
|w24|{55,56}|not|
|w25|{2,9,10,15,16,17,18,20,22,23,26,31,34,40,43,44,46,55,58,61,63,64,65,67,72,77,78,86,87,88,89,91,94,96,99,100,101,102,104,105}|not|
|w26|{2,16,17,18,22,23,26,34,40,46,55,58,64,78,81,88,89,94,96,99,100,101,102,103}|not|
|w27|{60,66}|not|
|w28|{12,73,75}|not|
|w29|{30,71}|not|
|w30|{11,12,13,38,39,50,51,52,73,74,75,76,79,80,82,92,93}|not|
|w31|{2,9,10,15,16,17,18,20,22,23,26,31,34,37,40,43,44,46,51,52,55,58,60,61,63,64,65,67,72,78,79,80,81,82,84,86,87,88,89,91,94,96,99,101,102,103,104,105}|not|
|w32|{0,12,13,24,28,30,32,33,36,37,45,47,50,56,59,62,66,68,70,71,75,76,77,83,90,91,92,93,97}|not|
|w33|{0,1,10,11,13,19,21,24,28,30,32,33,36,37,38,44,45,47,50,52,53,54,56,59,60,62,66,67,68,70,71,73,75,79,80,82,83,87,90,91,92,93,97,105}|not|
|w34|{13,92,93}|not|
|w35|{11,12,36,38,39,73,74,75,76,77,85}|not|
|w36|{13,45,83}|not|
|w37|Does not use NOR tree|`d[98]`|
|w38|{2,13,16,17,22,23,26,28,29,34,35,36,37,38,40,45,46,50,53,54,55,58,62,68,70,78,81,88,89,92,93,94,96,97,99,100,101}|not|
|w39|Does not use NOR tree|`~SeqOut_2`|
|w40|Does not use NOR tree|`w[18] & w[39]`|

The numbers in the path refer to Decoder1 outputs `d[106:0]`. Sometimes there are other inputs in the tree, and they are marked that way.

The result is a multi-input NOR (the dynamic part is not shown in the picture):

![demo_w1](/imgstore/demo_w1.jpg)

To convert trees into a schematic, you can use a script to generate an HDL.
