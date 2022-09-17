# Decoder 1

:warning: The section is in development.

![locator_decoder1](/imgstore/locator_decoder1.png)

Decoder1 makes a preliminary decoding of the operation code, which will then be refined in Decoder2.

Topology features:

![decoder1_topo](/imgstore/decoder1_topo.png)

(The left part is shown).

- Each decoder output is a branched NAND
- The output of a whole NAND tree can be `0` only when all inputs of _at least one_ "branch" are equal to `1`.
- During CLK = 0 a Precharge is made
- During CLK = 1 an operation (Eval) is committed
- Value is inverted by regular CMOS inverter

Dynamic logic is used.

Whole:

![decoder1_all](/imgstore/decoder1_all.jpg)

TBD: Decode me.

Inputs:

|Input|From|Meaning|
|---|---|---
|a0|Inplace|~a1|
|a1|Sequencer| ??? |
|a2|Inplace|~a3|
|a3|Sequencer| ??? |
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
|a20|Sequencer| ??? |
|a21|Inplace|~a20|
|a22|Sequencer| ??? |
|a23|Inplace|~a22|
|a24|Sequencer| ??? |
|a25|Inplace|~a24|

## Decoded Decoder1

Below is a table with the value of the bitmask for each decoder output.

|dx|NAND tree|Description
|---|---|---|
|0|011001'0110011001'1010100101| |
|1|011001'0110011010'1010100101| |
|2|101001'0110011010'1010100101| |
|3|000000'0000000000'0001100101| |
|3 alt|000000'0110100000'0010100101| |

:warning: Keep in mind that these fockers wrapped a9 input for the first three outputs with a slingshot.

TBD. Decode me.
