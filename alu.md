# ALU

![locator_alu](/imgstore/locator_alu.png)

![alu](/imgstore/alu.jpg)

![ALU](/HDL/Design/ALU.png)

The SM83 ALU is a regular 8-bit CLA adder.

See: https://www.youtube.com/watch?v=WItAXzrfPrE&list=PLBDB2c4Mp7hBLRcEpE19yyHB-zKzsyp_4&index=20

## ALU Inputs

|Signal|From|Description|
|---|---|---|
|CLK2|External| |
|CLK4|External|Used as LoadEnable for ALU_to_bot FF|
|CLK5|External| |
|CLK6|External| |
|CLK7|External| |
|DV\[7:0\]|Bottom|ALU Operand 2|
|AllZeros|NOR-8|1: The result (`Res`) is 0.|
|d42|Decoder1| |
|d58|Decoder1| |
|w (many)|Decoder2|Decoder2 outputs|
|x (many)|Decoder3|Decoder3 outputs|
|alu\[7:0\]|Bottom|ALU Operand 1|
|bq4|Bottom Left| |
|bq5|Bottom Left| |
|bq7|Bottom Left| |
|TempC|Bottom|Flag C from temp Z register (zbus\[4\])|
|TempH|Bottom|Flag H from temp Z register (zbus\[5\])|
|TempN|Bottom|Flag N from temp Z register (zbus\[6\])|
|TempZ|Bottom|Flag Z from temp Z register (zbus\[7\])|
|IR\[7:0\]|IR|Current opcode|
|nIR\[5:0\]|MightySix|Current opcode (complement)|

## ALU Outputs

|Signal|To|Description|
|---|---|---|
|Res\[7:0\]|Bottom|ALU Result|
|bc1|Bottom Left| |
|bc2|Bottom Left| |
|bc3|Bottom Left| |
|bc5|Bottom Left| |
|ALU_to_bot|Bottom|ALU Flag Z|
|ALU_to_Thingy|Thingy|CarryOut|
|ALU_Out1|Sequencer| |

## NOR-8

8-NOR:

![nor8_1](/imgstore/modules/nor8_1.jpg)

![nor8_1_tran](/imgstore/modules/nor8_1_tran.jpg)

The result of the nor8 operation is the `AllZeros` signal. This is often required to calculate the `Z` flag.

## Top Part

The paired construction that looks like a Christmas tree is actually two 4-bit Carry Lookahead Generators (module5).

In between is the small logic, and above the 8 "Sum" blocks (module6), which give the result of the ALU.

### module5 (4-bit CLA Generators, x2)

![module5](/imgstore/modules/module5.jpg)

![module5_tran](/imgstore/modules/module5_tran.jpg)

![module5_logisim](/logisim/module5_logisim.png)

### module6 (Sums)

8 identical modules.

![module6](/imgstore/modules/module6.jpg)

![module6_tran](/imgstore/modules/module6_tran.jpg)

## Middle Part (G/P Terms)

8 identical modules.

![module2](/imgstore/modules/module2.jpg)

![module2_tran](/imgstore/modules/module2_tran.jpg)

|Port|Dir|Description|
|---|---|---|
|a|input|comb1-3 outputs (`ca[7:0]`)|
|b|input|x19|
|c|input|x4|
|e|input|Large Comb results|
|f|output|To Large Comb NAND trees|
|g|input|x25|
|h|output|To CLA Generator (P-terms)|
|k|input|DV\[n\]|
|m|output|To CLA Generator (G-terms)|
|clk|input|CLK2|
|x|output|To ands near CLA|
|w|output|To Sums (module6)|

## Bottom Part

Presumably contains the flag setting logic and the flag register (F).

Contains 8 dynamic comb logic modules (ANDs-to-NORs + CLK2) whose outputs go up (`ca[7:0]`):

|Comb3 (bit 0)|Comb2 (bits 1-6)|Comb1 (bit 7)|
|---|---|---|
|![comb3](/imgstore/modules/comb3.jpg)|![comb2](/imgstore/modules/comb2.jpg)|![comb1](/imgstore/modules/comb1.jpg)|
|![comb3_tran](/imgstore/modules/comb3_tran.jpg)|![comb2_tran](/imgstore/modules/comb2_tran.jpg)|![comb1_tran](/imgstore/modules/comb1_tran.jpg)|

The lower part contains many NAND trees, the inputs for which come from all sides and also from `module2` instancies.

Large Comb 1 (_14 NAND trees_):

![LargeComb1](/imgstore/LargeComb1.jpg)

## LargeComb1 Nand Trees

|Tree|CLK|Issued as|Tree|
|---|---|---|---|
|alu_0|CLK2|e0|alu0 \| (w24&nIR3&nIR4&nIR5) \| (w10&(IR3\|IR4\|IR5))|
|alu_1|CLK6|bc5|(ALU_L5&((nIR0&w37)\|x10)) \| (ALU_L3&x12) \| x26 \| w12 \| x19 \| (TempH&d58)|
|alu_2|CLK6|bc1|(f0&x1) \| (TempC&d58) \| (~bc1&IR3&x21) \| (x21&nIR3) \| (x10&ALU_to_Thingy) \| (x22&(bc1\|(~bc2&ALU_to_Thingy))) \| (bc1&x26) \| (f7&x0) \| (ALU_L0&x11)|
|alu_3|CLK2|e1|alu1 \| (w24&IR3&nIR4&nIR5) \| (w10&(nIR3\|IR4\|IR5)) \| (x22&(bc5\|(~bc2&bq4)))|
|alu_4|CLK2|e2|alu2 \| (w24&nIR3&IR4&nIR5) \| (w10&(IR3\|nIR4\|IR5)) \| (x22&~bc2&(bq4\|bc5))|
|alu_5|CLK2|e3|alu3 \| (w24&IR3&IR4&nIR5) \| (w10&(nIR3\|nIR4\|IR5)) \| (x22&bc2&bc5)|
|alu_6|CLK2|e4|alu4 \| (w24&nIR3&nIR4&IR5) \| (w10&(IR3\|IR4\|nIR5)) \| (x22&bc2&bc5)|
|alu_7|CLK6|bc2|(bc2&x22) \| x12 \| x26 \| (TempN&d58)|
|alu_8|CLK2|e5|alu5 \| (w24&IR3&nIR4&IR5) \| (w10&(nIR3\|IR4\|nIR5)) \| (bc2&x22&((bc1&~bc5)\|(~bc1&bc5))) \| (~bc2&x22&((bq5)\|(bc1)\|(bq4&bq7)))|
|alu_9|CLK2|e6|alu6 \| (w24&nIR3&IR4&IR5) \| (w10&(IR3\|nIR4\|nIR5)) \| (bc2&x22&(~bc1&bc5)) \| (~bc2&x22&((bq4&bq7)\|(bc1)\|(bq5)))|
|alu_10|CLK2|e7|alu7 \| (w24&IR3&IR4&IR5) \| (w10&(nIR3\|nIR4\|nIR5)) \| (bc2&x22&(bc1\|bc5))|
|alu_11|CLK6|ALU_Out1|w0 & ((nIR3&IR4&bc1) \| (IR3&IR4&~bc1) \| (IR3&nIR4&~bc3) \| (nIR3&nIR4&bc3))|
|alu_12|CLK6|bc3|(f0&w12&nIR3&nIR4&nIR5) \| (f1&w12&IR3&nIR4&nIR5) \| (f2&w12&nIR3&IR4&nIR5) \| (f3&w12&IR3&IR4&nIR5) \| (f4&w12&nIR3&nIR4&IR5) \| (f5&w12&IR3&nIR4&IR5) \| (f6&w12&nIR3&IR4&IR5) \| (f7&w12&IR3&IR4&IR5) \| (AllZeros&(d42\|w3\|w37\|x22)) \| (d58&TempZ) \| (bc3&(x26\|w15\|x21\|w19))|
|alu_13|CLK2|ALU_to_top ("Carry In")|x27 \| (w37&nIR0) \| (w9&bc1) \| (x24&(nIR3\|~bc1)) \| (w19&bc1) \| (x23&IR3)|

The result is an AND-to-NOR tree (using alu_0 as an example):

![demo_alu_0](/imgstore/demo_alu_0.jpg)

(the dynamic part is not shown in the picture)

![ALU_LargeComb1](/HDL/Design/ALU_LargeComb1.png)

## Below LargeComb1

![LargeComb1_Res](/imgstore/LargeComb1_Res.jpg)

### bc

![bc](/imgstore/modules/bc.jpg)

![bc_tran](/imgstore/modules/bc_tran.jpg)

Regular memory cell (latch) with write enable (x28/x29). It also contains a Precharge FET for the dynamic logic which is above (input `d`). By the way the input `d` in the drawing is marked in inverse polarity, because the current hypothesis is that the signal `bc` is in direct polarity, and the operation which forms the signal `d` (AOI) gives the result in inverse polarity.

### ALU_to_bot

![ALU_to_bot](/imgstore/modules/ALU_to_bot.jpg)

![ALU_to_bot_tran](/imgstore/modules/ALU_to_bot_tran.jpg)

A regular memory cell (latch), for storing the `TempZ` signal. The signal CLK4 acts as WriteEnable.
