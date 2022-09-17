# Top Left

:warning: The section is in development.

Status: More polishing is required. Very poorly visible Poly.

![locator_topleft](/imgstore/locator_topleft.png)

![topleft](/imgstore/topleft.jpg)

- The top part seems to contain the Data Latch
- In the middle part it is not yet clear what is
- It is very likely that the lower part is a BCD ALU, working with nibbles (4-bits).

## Top of 8 pieces + NOR-8

module1 (x8):

![module1](/imgstore/modules/module1.jpg)

|Port|Dir|Description|
|---|---|---|
|a|input| |
|b|input| |
|c|input| |
|clk|input| |
|Data|inout|Connects to external data bus|
|x|output| |

8-NOR:

![nor8_1](/imgstore/modules/nor8_1.jpg)

## The middle part

Some obscure construction that looks like a Christmas tree. (x2)

Just below are 8 identical modules.

module2 (x8):

![module2](/imgstore/modules/module2.jpg)

|Port|Dir|Description|
|---|---|---|
|a|input|comb1-3 outputs|
|b|input|From Christmas Tree|
|c|input|From Christmas Tree|
|e|input|Large Comb results|
|f|output (TBD. Fix pic)|To Large Comb NAND trees|
|g|input|External|
|clk|input| |
|x|output|To Christmas Tree|
|w|output|To Christmas Tree|

TBD.

## Bottom part

Consists of two halves.

The top contains 8 comb logic modules (ANDs-to-NORs) whose outputs go up:

![comb1](/imgstore/modules/comb1.jpg)

(Comb example)

The lower part contains many NAND trees, the inputs for which come from all sides and also from `module2` instancies.

Large Comb 1 (_14 NAND trees_):

![LargeComb1](/imgstore/LargeComb1.jpg)

Large Comb 1 Result:

![LargeComb1_Res](/imgstore/LargeComb1_Res.jpg)
