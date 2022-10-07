# ALU

:warning: The section is in development.

Status: Restoration and study is in progress.

![locator_alu](/imgstore/locator_alu.png)

![alu](/imgstore/alu.jpg)

## ALU Inputs

|Signal|From|Description|
|---|---|---|
|CLK2|External| |
|CLK5|External| |
|CLK6|External| |
|CLK7|External| |
|DV|Bottom| |
|AllZeros|NOR-8|1: The result (`Res`) is 0.|
|TTB3|Thingy| |
|d|Decoder1| |
|w|Decoder2| |
|x|Decoder3| |
|alu|Bottom| |
|bq4|Bottom Left| |
|bq5|Bottom Left| |
|bq7|Bottom Left| |
|ALU_L1|Bottom| |
|ALU_L2|Bottom| |
|ALU_L4|Bottom| |
|IR|IR| |
|nIR|MightySix| |

## ALU Outputs

|Signal|To|Description|
|---|---|---|
|Res|Bottom| |
|bc|Bottom Left| |
|ALU_to_bot|Bottom| |
|ALU_to_Thingy|Thingy| |
|ALU_Out1|Sequencer| |

## NOR-8

8-NOR:

![nor8_1](/imgstore/modules/nor8_1.jpg)

The result of the nor8 operation is the `AllZeros` signal. This is often required to calculate the `Z` flag.

## Top Part

Some obscure construction that looks like a Christmas tree. (x2).

The design consists of two symmetric halves (module5) with minor logic in between, above which there are 8 instances of module6.

### module5 (x2)

![module5](/imgstore/modules/module5.jpg)

![module5_tran](/imgstore/modules/module5_tran.jpg)

### module6 (x8)

![module6](/imgstore/modules/module6.jpg)

![module6_tran](/imgstore/modules/module6_tran.jpg)

## Middle Part (module2 Array)

8 identical modules.

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

Presumably contains the flag setting logic and the flag register (F).

Contains 8 dynamic comb logic modules (ANDs-to-NORs) whose outputs go up (`ca[7:0]`):

|Comb3 (bit 0)|Comb2 (bits 1-6)|Comb1 (bit 7)|
|---|---|---|
|![comb3](/imgstore/modules/comb3.jpg)|![comb2](/imgstore/modules/comb2.jpg)|![comb1](/imgstore/modules/comb1.jpg)|
|TBD: Logic|TBD: Logic|TBD: Logic|

The lower part contains many NAND trees, the inputs for which come from all sides and also from `module2` instancies.

Large Comb 1 (_14 NAND trees_):

![LargeComb1](/imgstore/LargeComb1.jpg)

## LargeComb1 Nand Trees

|Tree|CLK|Paths|
|---|---|---|
|alu_0|CLK2|{alu0}<br/>{w24,nIR3,nIR4,nIR5}<br/>{w10,IR5}<br/>{w10,IR4}<br/>{w10,IR3}|
|alu_1|CLK6|{nIR0,w37,ALU_L5}<br/>{x10,ALU_L5}<br/>{ALU_L3,x12}<br/>{w12}<br/>{x26}<br/>{x19}<br/>{ALU_L1,d58}|
|alu_2|CLK6|{f0,x1}<br/>{ALU_L2,d58}<br/>{nbc1,IR3,x21}<br/>{x21,nIR3}<br/>{x10,ALU_to_Thingy}<br/>{nbc2,ALU_to_Thingy,x22}<br/>{bc1,x22}<br/>{bc1,x26}<br/>{x0,f7}</br>{ALU_L0,x11}|
|alu_3|CLK2|{alu1}<br/>{w24,IR3,nIR4,nIR5}<br/>{w10,IR5}<br/>{w10,IR4}<br/>{w10,nIR3}<br/>{x22,bc5}<br/>{x22,nbc2,bq4}|
|alu_4|CLK2|{alu2}<br/>{x22,bq4,nbc2}<br/>{x22,bc5,nbc2}<br/>{w24,nIR3,IR4,nIR5}<br/>{w10,IR5}<br/>{w10,nIR4}<br/>{w10,IR3}|
|alu_5|CLK2|{alu3}<br/>{w24,IR3,IR4,nIR5}<br/>{w10,nIR3}<br/>{w10,nIR4}<br/>{w10,IR5}<br/>{x22,bc5,bc2}|
|alu_6|CLK2|{alu4}<br/>{x22,bc5,bc2}<br/>{w24,nIR3,nIR4,IR5}<br/>{w10,IR3}<br/>{w10,IR4}<br/>{w10,nIR5}|
|alu_7|CLK6|{bc2,x22}<br/>{x12}<br/>{x26}<br/>{d58,ALU_L4}|
|alu_8|CLK2|{alu5}<br/>{w24,IR3,nIR4,IR5}<br/>{w10,nIR3}<br/>{w10,IR4}<br/>{w10,nIR5}<br/>{x22,nbc5,bc1,bc2}<br/>{x22,bc5,nbc1,bc2}<br/>{x22,bq5,nbc2}<br/>{x22,bc1,nbc2}<br/>{x22,bq7,bq4,nbc2}|
|alu_9|CLK2|{alu6}<br/>{w24,nIR3,IR4,IR5}<br/>{w10,IR3}<br/>{w10,nIR4}<br/>{w10,nIR5}<br/>{x22,bc5,nbc1,bc2}<br/>{x22,bq7,bq4,nbc2}<br/>{x22,bc1,nbc2}<br/>{x22,bq5,nbc2}|
|alu_10|CLK2|{alu7}<br/>{w24,IR3,IR4,IR5}<br/>{w10,nIR3}<br/>{w10,nIR4}<br/>{w10,nIR5}<br/>{x22,bc5,bc2}<br/>{x22,bc1,bc2}|
|alu_11|CLK6|{w0,nIR3,IR4,bc1}<br/>{w0,IR3,IR4,nbc1}<br/>{w0,IR3,nIR4,nbc3}<br/>{w0,nIR3,nIR4,bc3}|
|alu_12|CLK6|{f0,w12,nIR3,nIR4,nIR5}<br/>{f1,w12,IR3,nIR4,nIR5}<br/>{f2,w12,nIR3,IR4,nIR5}<br/>{f3,w12,IR3,IR4,nIR5}<br/>{f4,w12,nIR3,nIR4,IR5}<br/>{f5,w12,IR3,nIR4,IR5}<br/>{f6,w12,nIR3,IR4,IR5}<br/>{f7,w12,IR3,IR4,IR5}<br/>{d42,AllZeros}<br/>{w3,AllZeros}<br/>{w37,AllZeros}<br/>{x22,AllZeros}<br/>{TTB3,d58}<br/>{bc3,w19}<br/>{bc3,x21}<br/>{bc3,w15}<br/>{bc3,x26}|
|alu_13|CLK2|{w37,nIR0}<br/>{x27}<br/>{w9,bc1}<br/>{nbc1,x24}<br/>{nIR3,x24}<br/>{bc1,w19}<br/>{IR3,x23}|

The result is an AND-to-NOR tree (using alu_0 as an example):

![demo_alu_0](/imgstore/nandtrees/demo_alu_0.jpg)

(the dynamic part is not shown in the picture)

To convert trees into a schematic, you can use a script to generate an HDL.

## Below LargeComb1

![LargeComb1_Res](/imgstore/LargeComb1_Res.jpg)

### bc

![bc](/imgstore/modules/bc.jpg)

![bc_tran](/imgstore/modules/bc_tran.jpg)

Regular memory cell with write enable (x28/x29). It also contains a Precharge FET for the dynamic logic which is above (input `d`). By the way the input `d` in the drawing is marked in inverse polarity, because the current hypothesis is that the signal `bc` is in direct polarity, and the operation which forms the signal `d` (AOI) gives the result in inverse polarity.

### ALU_to_bot

![ALU_to_bot](/imgstore/modules/ALU_to_bot.jpg)
