# Bottom

:warning: The section is in development.

Status: Obtaining the topology.

![locator_bottom](/imgstore/locator_bottom.png)

The SM83 processor uses a typical layout from the 70-80's: the "brain" is on top and the registers and ALUs are on the bottom.

The upper part outputs to the lower part a large number of control signals for connecting registers to buses, ALU operations, etc.

For the SM83 the layout is slightly different: the ALU is on the top-left and at the bottom purely registers and auxiliary logic for switching buses.

## Design

![bottom](/imgstore/bottom.jpg)

The bottom part consists of 8 lanes, according to the number of registers bits. The numbering of the bits is from 0 from top to bottom.

There are minor differences between the lanes, this will be discussed later.

## Register Bit

All registers use a common module.

![regbit](/imgstore/modules/regbit.jpg)

![regbit_tran](/imgstore/modules/regbit_tran.jpg)

DFF with complementary set enable, complementary CLK.

- In the middle is a FlipFlop made of not
- Input value can be written to FlipFlop only if CLK=1 and LD=1
- When LD=0 the FlipFlop value is updated with the old value
- The output contains a latch with a gate memory that opens when LD=0 (so that the old value is returned during the write (LD=1))
- So the written value becomes relevant when LD 1->0 changes (when the output latch opens and is updated with the value from FlipFlop).
- The whole thing is complicated by the complementary layout of the LD and CLK signals.

## Reg0 - IR

## Reg1 - ???

## Reg1 Comb

## Bottom Left (ALU bc/bq) Logic

## Reg2 - ???

## Reg3 - ???

## Reg 2/3 Comb

## Reg4 - ???

## Reg5 - ???

## Reg 4/5 Comb

## Reg6 - ???

## Reg7 - ???

## Reg 6/7 Comb

## Reg8 - ???

## Reg8 Comb

## w8+ALU Result Logic

## x59 Logic

## SP Logic

![x61](/imgstore/modules/x61.jpg)

## PC Logic

![x68](/imgstore/modules/x68.jpg)

## TTB Logic

## Bottom Right (IRQ) Logic

The IRQ logic consists of the following parts:
- IE
- IF
- Priority encoder
- "Breadcrumps"

### IE

![module7](/imgstore/modules/module7.jpg)

### IF

Apparently, access to the IF in the DMG CPU has been removed.

![module8](/imgstore/modules/module8.jpg)

### Breadcrumps

I never tire of repeating: dear chip designers - please do not spread the logic this way, because it is difficult to cut it into pieces and post pictures on the wiki. Therefore, I will not give pictures of the topology here - see the general big picture of the bottom part. Pieces of "Breadcrumped" circuits are marked with different colors.

- breadcrumped nor-9 (cyan): sc1 (Any interrupt)
- breadcrumped aoi (green): sc2 (Priority encoder)
- breadcrumped nand-9 (white): A0-A7 + AddrHi -> bot_to_Thingy (Addr = 0xffff)
- breadcrumped nand-8 (red): A8-A15 (AddrHi)
- breadcrumped nor-4 (**x3**): bro3, bro4, bro5 (Interrupt address?)
