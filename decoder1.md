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
|a0| | |
|a1| | |
|a2| | |
|a3| | |
|a4| | |
|a5| | |
|a6| | |
|a7| | |
|a8| | |
|a9| | |
|a10| | |
|a11| | |
|a12| | |
|a13| | |
|a14| | |
|a15| | |
|a16| | |
|a17| | |
|a18| | |
|a19| | |
|a20| | |
|a21| | |
|a22| | |
|a23| | |
|a24| | |
|a25| | |

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
