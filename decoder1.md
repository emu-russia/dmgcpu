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

## Decoder1 Outputs

Below is a table with the value of the bitmask for each decoder output.

:warning: Keep in mind that these fockers wrapped a9 input for the first three outputs with a slingshot.

TBD. Decode me.

|dx Output|NAND trees|To|Description|
|---|---|---|---|
|0|011001'0110011001'1010100101| | |
|1|011001'0110011010'1010100101| | |
|2|101001'0110011010'1010100101| | |
|3|000000'0000000000'0001100101<br/>000000'0110100000'0010100101| | |
|4| | | |
|5| | | |
|6| | | |
|7| | | |
|8| |Random Logic (not used in Decoder2)| |
|9| | | |
|10| | | |
|11| | | |
|12| | | |
|13| | | |
|14| |Random Logic (not used in Decoder2)| |
|15| | | |
|16| | | |
|17| | | |
|18| | | |
|19| | | |
|20| | | |
|21| | | |
|22| | | |
|23| | | |
|24| | | |
|25| |Random Logic (not used in Decoder2)| |
|26| | | |
|27| | | |
|28| | | |
|29| | | |
|30| | | |
|31| | | |
|32| | | |
|33| | | |
|34| |Random Logic (also)| |
|35| | | |
|36| | | |
|37| | | |
|38| |Random Logic (also)| |
|39| | | |
|40| | | |
|41| |Random Logic (not used in Decoder2)| |
|42| |Random Logic, ALU, Bottom (not used in Decoder2)| |
|43| | | |
|44| | | |
|45| | | |
|46| | | |
|47| | | |
|48| |:warning: Not used| |
|49| |:warning: Not used| |
|50| | | |
|51| | | |
|52| | | |
|53| | | |
|54| | | |
|55| | | |
|56| | | |
|57| | | |
|58| |ALU (also)| |
|59| | | |
|60| |Bottom (also)| |
|61| | | |
|62| |Random Logic (also)| |
|63| | | |
|64| |Random Logic (also)| |
|65| | | |
|66| | | |
|67| | | |
|68| | | |
|69| | | |
|70| | | |
|71| | | |
|72| | | |
|73| | | |
|74| | | |
|75| | | |
|76| | | |
|77| | | |
|78| | | |
|79| | | |
|80| | | |
|81| | | |
|82| | | |
|83| |Random Logic (also)| |
|84| | | |
|85| | | |
|86| | | |
|87| | | |
|88| |Random Logic (also). Long wire.| |
|89| | | |
|90| | | |
|91| | | |
|92| |Bottom (also)| |
|93| |Random Logic, Bottom (also)| |
|94| | | |
|95| | | |
|96| | | |
|97| | | |
|98| | | |
|99| |Sequencer (also)| |
|100| |Sequencer (also)| |
|101| |Sequencer (also)| |
|102| |Sequencer (also)| |
|103| | | |
|104| | | |
|105| | | |
|106| | |:warning: Not used|

(The `To` outputs are marked only for those that go somewhere else besides Decoder2).
