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
|d1| | | |
|d2| | | |
|d3|{0,2,5,6}<br/>{5,7,15,17,18}| | |
|d4| | | |
|d5| | | |
|d6| | | |
|d7| | | |
|d8| |Random Logic (not used in Decoder2)| |
|d9| | | |
|d10| | | |
|d11| | | |
|d12| | | |
|d13| | | |
|d14| |Random Logic (not used in Decoder2)| |
|d15| | | |
|d16| | | |
|d17| | | |
|d18| | | |
|d19| | | |
|d20| | | |
|d21| | | |
|d22| | | |
|d23| | | |
|d24| | | |
|d25| |Random Logic (not used in Decoder2)| |
|d26| | | |
|d27| | | |
|d28| | | |
|d29| | | |
|d30| | | |
|d31| | | |
|d32| | | |
|d33| | | |
|d34| |Random Logic (also)| |
|d35| | | |
|d36| | | |
|d37| | | |
|d38| |Random Logic (also)| |
|d39| | | |
|d40| | | |
|d41| |Random Logic (not used in Decoder2)| |
|d42| |Random Logic, ALU, Bottom (not used in Decoder2)| |
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
|d62| |Random Logic (also)| |
|d63| | | |
|d64| |Random Logic (also)| |
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
|d83| |Random Logic (also)| |
|d84| | | |
|d85| | | |
|d86| | | |
|d87| | | |
|d88| |Random Logic (also). Long wire.| |
|d89| | | |
|d90| | | |
|d91| | | |
|d92| |Bottom (also)| |
|d93| |Random Logic, Bottom (also)| |
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
