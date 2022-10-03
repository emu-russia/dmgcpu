# Decoder 1

:warning: The section is in development.

Status: Restore all NAND trees, find out what are the 5 additional decoder inputs, except the IR value.

![locator_decoder1](/imgstore/locator_decoder1.png)

Decoder1 makes a preliminary decoding of the operation code, which will then be refined in Decoder2.

Topology features:

![decoder1](/imgstore/decoder1.jpg)

- Each decoder output is a branched NAND
- The output of a whole NAND tree can be `0` only when all inputs of _at least one_ "branch" are equal to `1`.
- During CLK = 0 a Precharge is made
- During CLK = 1 an operation (Eval) is committed
- Value is inverted by regular CMOS inverter

Dynamic logic is used.

## Decoder1 Inputs

|Input|From|Meaning|
|---|---|---
|a0|Inplace|~a1|
|a1|Sequencer| ??? TBD. |
|a2|Inplace|~a3|
|a3|Sequencer| ??? TBD. |
|a4|Inplace|~a5|
|a5|IR|IR\[7\]|
|a6|Inplace|~a7|
|a7|IR|IR\[6\]|
|a8|Inplace|~a9|
|a9|IR|IR\[5\]|
|a10|Inplace|~a11|
|a11|IR|IR\[4\]|
|a12|Inplace|~a13|
|a13|IR|IR\[3\]|
|a14|Inplace|~a15|
|a15|IR|IR\[2\]|
|a16|Inplace|~a17|
|a17|IR|IR\[1\]|
|a18|Inplace|~a19|
|a19|IR|IR\[0\]|
|a20|Sequencer| ??? TBD. |
|a21|Inplace|~a20|
|a22|Sequencer| ??? TBD. |
|a23|Inplace|~a22|
|a24|Sequencer| ??? TBD. |
|a25|Inplace|~a24|

## Decoder1 Output Trees

There is no need to draw the whole topology, because all the trees can be extracted from the picture.

:warning: Keep in mind that these fockers wrapped a9 input for the first three outputs with a slingshot.

|Tree|Paths|To|Description|
|---|---|---|---|
|d0|{0,2,5,7,9,10,13,14,17,18,20,23,24}| | |
|d1|{0,2,5,7,9,11,13,14,17,18,20,23,24}| | |
|d2|{0,2,5,7,9,11,13,14,17,18,20,23,25}| | |
|d3|{0,2,5,6}<br/>{0,2,5,7,15,17,18}| | |
|d4|{`0,2,5,7,8`,14,17,18,22,25}| | |
|d5|{`0,2,5,7,8`,15,16,18,22,25}| | |
|d6|{0,2,5,7,8,14,16,18,22,24}| | |
|d7|{0,2,4,6,9,14,16,18,22,24}| | |
|d8|{0,2,5,7,9,11,12,14,18}|Decoder3 (not used in Decoder2)| |
|d9|{0,2,5,7,8,10,13,15,16,`20,22,24`}<br/>{0,2,5,7,8,15,16,18,`20,22,24`}| | |
|d10|{0,2,5,7,8,10,13,15,16,`20,22,25`}<br/>{0,2,5,7,8,15,16,18,`20,22,25`}| | |
|d11|{0,2,5,7,8,10,13,15,16,`20,23,24`}<br/>{0,2,5,7,8,15,16,18,`20,23,24`}| | |
|d12|{0,2,5,7,8,10,13,15,16,`20,23,25`}<br/>{0,2,5,7,8,15,16,18,`20,23,25`}| | |
|d13|{0,2,5,7,8,10,13,15,16,`21,22,24`}<br/>{0,2,5,7,8,15,16,18,`21,22,24`}| | |
|d14|{0,2,4,6,15,17,18}|Decoder3 (not used in Decoder2)| |
|d15|{0,2,4,6,22,24}| | |
|d16|{0,2,4,6,`13`,15,17,18,22,25}<br/>{0,2,4,6,`10`,15,17,18,22,25}<br/>{0,2,4,6,`8`,15,17,18,22,25}| | |
|d17|{0,2,21,23,24}| | |
|d18|{2,21,23,25}| | |
|d19|{0,2,4,6,9,14,16,18,`22,25`}<br/>{0,2,4,6,8,11,13,14,16,18,`22,25`}| | |
|d20|{0,2,4,6,9,14,16,18,`22,24`}<br/>{0,2,4,6,8,11,13,14,16,18,`22,24`}| | |
|d21|{0,2,5,7,9,10,13,14,16,18,20,24,25}| | |
|d22|{0,2,5,7,9,11,13,14,16,18,23,24}| | |
|d23|{0,3,5,6,`14`,22,24}<br/>{0,3,5,6,`16`,22,24}<br/>{0,3,5,6,`19`,22,24}| | |
|d24|{0,3,5,6,15,17,18,22,25}| | |
|d25| |Decoder3 (not used in Decoder2)| |
|d26| | | |
|d27| | | |
|d28| | | |
|d29| | | |
|d30| | | |
|d31| | | |
|d32| | | |
|d33| | | |
|d34| |Decoder3 (also)| |
|d35| | | |
|d36| | | |
|d37| | | |
|d38| |Decoder3 (also)| |
|d39| | | |
|d40| | | |
|d41| |Decoder3 (not used in Decoder2)| |
|d42| |Decoder3, ALU, Bottom (not used in Decoder2)| |
|d43| | | |
|d44| | | |
|d45| | | |
|d46| | | |
|d47| | | |
|d48| |:warning: Not used| |
|d49| |:warning: Not used| |
|d50| | | |
|d51| | | |
|d52| | | |
|d53| | | |
|d54| | | |
|d55| | | |
|d56| | | |
|d57| | | |
|d58| |ALU (also)| |
|d59| | | |
|d60| |Bottom (also)| |
|d61| | | |
|d62| |Decoder3 (also)| |
|d63| | | |
|d64| |Decoder3 (also)| |
|d65| | | |
|d66| | | |
|d67| | | |
|d68| | | |
|d69| | | |
|d70| | | |
|d71| | | |
|d72| | | |
|d73| | | |
|d74| | | |
|d75| | | |
|d76| | | |
|d77| | | |
|d78| | | |
|d79| | | |
|d80| | | |
|d81| | | |
|d82| | | |
|d83| |Decoder3 (also)| |
|d84| | | |
|d85| | | |
|d86| | | |
|d87| | | |
|d88| |Decoder3 (also). Long wire.| |
|d89| | | |
|d90| | | |
|d91| | | |
|d92| |Bottom (also)| |
|d93| |Decoder3, Bottom (also)| |
|d94| | | |
|d95| | | |
|d96| | | |
|d97| | | |
|d98| | | |
|d99| |Sequencer (also)| |
|d100| |Sequencer (also)| |
|d101| |Sequencer (also)| |
|d102| |Sequencer (also)| |
|d103| | | |
|d104| | | |
|d105| | | |
|d106| | |:warning: Not used|

The numbers in the tree path mark the inputs `a[25:0]`.

The result should be as follows (using d3 as an example, the dynamical part of the logic is not shown):

![demo_d3](/imgstore/nandtrees/demo_d3.jpg)

The `To` outputs are marked only for those that go somewhere else besides Decoder2.

To convert trees into a schematic, you can use a script to generate an HDL.
