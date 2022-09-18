# ALU

:warning: The section is in development.

Status: Most of the topology is obtained. Restoration and study is in progress.

![locator_alu](/imgstore/locator_alu.png)

![topleft](/imgstore/topleft.jpg)

- The top part contain the Data Latch
- In the middle part it is not yet clear what is (part of ALU)
- The lower part is 8-bit ALU

## Data Latch + NOR-8

DL_Bit (x8):

![module1](/imgstore/modules/module1.jpg)

|Port|Dir|Description|
|---|---|---|
|a|input| |
|b|input| |
|c|input| |
|clk|input| |
|Data|inout|Connects to external data bus|
|x|output|Current value|

8-NOR:

![nor8_1](/imgstore/modules/nor8_1.jpg)

The result of the nor8 operation is the `AllZeros` signal. This is often required to calculate the `Z` flag.

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
|f|output|To Large Comb NAND trees|
|g|input|External|
|clk|input| |
|x|output|To Christmas Tree|
|w|output|To Christmas Tree|

TBD.

## Bottom part

Consists of two halves.

The top contains 8 comb logic modules (ANDs-to-NORs) whose outputs go up:

|Comb3 (bit 0)|Comb2 (bits 1-6)|Comb1 (bit 7)|
|---|---|---|
|![comb3](/imgstore/modules/comb3.jpg)|![comb2](/imgstore/modules/comb2.jpg)|![comb1](/imgstore/modules/comb1.jpg)|

The lower part contains many NAND trees, the inputs for which come from all sides and also from `module2` instancies.

Large Comb 1 (_14 NAND trees_):

![LargeComb1](/imgstore/LargeComb1.jpg)

Large Comb 1 Result:

![LargeComb1_Res](/imgstore/LargeComb1_Res.jpg)
