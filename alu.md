# ALU

:warning: The section is in development.

Status: Restoration and study is in progress.

![locator_alu](/imgstore/locator_alu.png)

![alu](/imgstore/alu.jpg)

- In the top part it is not yet clear what is (part of ALU)
- The lower part is 8-bit ALU

## ALU Inputs

|Signal|From|Description|
|---|---|---|
|CLK2| | |
|CLK5| | |
|CLK6| | |
|CLK7| | |
|DV| | |
|AllZeros| | |
|TTB3| | |
|d| | |
|w| | |
|x| | |
|alu| | |
|bq4| | |
|bq5| | |
|bq7| | |
|ALU_L1| | |
|ALU_L2| | |
|ALU_L4| | |
|IR| | |
|nIR| | |

## ALU Outputs

|Signal|To|Description|
|---|---|---|
|Res| | |
|bc| | |
|ALU_to_bot| | |
|FromThingy| | |
|ALU_Out1| | |

## NOR-8

8-NOR:

![nor8_1](/imgstore/modules/nor8_1.jpg)

The result of the nor8 operation is the `AllZeros` signal. This is often required to calculate the `Z` flag.

## Top Part

Some obscure construction that looks like a Christmas tree. (x2).

The design consists of two symmetric halves (module5) with minor logic in between, above which there are 8 instances of module6.

module6 (x8):

![module6](/imgstore/modules/module6.jpg)

![module6_tran](/imgstore/modules/module6_tran.jpg)

module5 (x2):

![module5](/imgstore/modules/module5.jpg)

Just below are 8 identical modules.

module2 (x8):

![module2](/imgstore/modules/module2.jpg)

![module2_tran](/imgstore/modules/module2_tran.jpg)

|Port|Dir|Description|
|---|---|---|
|a|input|comb1-3 outputs|
|b|input|From Christmas Tree|
|c|input|From Christmas Tree|
|e|input|Large Comb results|
|f|output|To Large Comb NAND trees|
|g|input|External|
|h|output|To Christmas Tree|
|k|input|DV\[n\]|
|m|output|To Christmas Tree|
|clk|input|CLK2|
|x|output|To Christmas Tree|
|w|output|To Christmas Tree|

## Bottom Part

Contains 8 dynamic comb logic modules (ANDs-to-NORs) whose outputs go up (`ca[7:0]`):

|Comb3 (bit 0)|Comb2 (bits 1-6)|Comb1 (bit 7)|
|---|---|---|
|![comb3](/imgstore/modules/comb3.jpg)|![comb2](/imgstore/modules/comb2.jpg)|![comb1](/imgstore/modules/comb1.jpg)|
|TBD: Logic|TBD: Logic|TBD: Logic|

The lower part contains many NAND trees, the inputs for which come from all sides and also from `module2` instancies.

Large Comb 1 (_14 NAND trees_):

![LargeComb1](/imgstore/LargeComb1.jpg)

## LargeComb1 Nand Trees

|Tree|Paths|
|---|---|
|alu_1|{alu0}<br/>{w24,nIR3,nIR4,nIR5}<br/>{w10,IR5}<br/>{w10,IR4}<br/>{w10,IR3}|
|alu_2| |
|alu_3| |
|alu_4| |
|alu_5| |
|alu_6| |
|alu_7| |
|alu_8| |
|alu_9| |
|alu_10| |
|alu_11| |
|alu_12| |
|alu_13| |
|alu_14| |

The result is an AND-to-NOR tree (using alu_1 as an example):

![demo_alu_1](/imgstore/nandtrees/demo_alu_1.jpg)

(the dynamic part is not shown in the picture)

To convert trees into a schematic, you can use a script to generate an HDL.

## Below LargeComb1

![LargeComb1_Res](/imgstore/LargeComb1_Res.jpg)

bc:

![bc](/imgstore/modules/bc.jpg)

ALU_to_bot:

![ALU_to_bot](/imgstore/modules/ALU_to_bot.jpg)
