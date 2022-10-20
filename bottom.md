# Bottom

:warning: The section is in development.

Status: All topology obtained, circuit research in progress.

![locator_bottom](/imgstore/locator_bottom.png)

The SM83 processor uses a typical layout from the 70-80's: the "brain" is on top and the registers and ALUs are on the bottom.

The upper part outputs to the lower part a large number of control signals for connecting registers to buses, ALU operations, etc.

For the SM83 the layout is slightly different: the ALU is on the top-left and at the bottom purely registers and auxiliary logic for switching buses.

## Design

![bottom](/imgstore/bottom.jpg)

![Bottom](/HDL/Design/Bottom.png)

The bottom part consists of 8 lanes, according to the number of registers bits. The numbering of the bits is from 0 from top to bottom.

There are minor differences between the lanes, such places are marked with a :warning: sign.

## Internal bottom buses

The names of some buses are arbitrary (do not make sense).

|Bus|To Reg|From Reg|Precharge|
|---|---|---|---|
|abus|alu\[7:0\] to top (no reg)|H, L, A, SPL, SPH, PCL|CLK2|
|bbus|DV\[7:0\] to top (no reg)|B, C, D, E, H, L, A, Z, SPL, SPH|CLK2|
|cbus|ABL|C, E, L, Z, SPL, PCL|CLK2|
|dbus|ABH|B, D, H, W, SPH, PCH|CLK2|
|ebus|C, E, L|Dedicated circuit| |
|fbus|B, D, H, A|Dedicated circuit| |
|zbus|SPL, PCL|Z| |
|wbus|SPH, PCH|W| |
|adl|SPL, PCL, Z|ABL| |
|adh|SPH, PCH, W|ABH| |

There are small pieces for Precharge scattered throughout the circuitry.

![bus_precharge](/imgstore/bus_precharge.jpg)

## Register Bit

All registers use a common module.

![regbit](/imgstore/modules/regbit.jpg)

![regbit_tran](/imgstore/modules/regbit_tran.jpg)

Latch with complementary set enable, complementary CLK.

- In the middle is a FlipFlop made of not
- Input value can be written to FlipFlop only if CLK=1 and LD=1
- When LD=0 the FlipFlop value is updated with the old value
- The output contains a DLatch with a gate memory that opens when LD=0 (so that the old value is returned during the write (LD=1))
- So the written value becomes relevant when LD 1->0 changes (when the output latch opens and is updated with the value from FlipFlop).
- The whole thing is complicated by the complementary layout of the LD and CLK signals.

## Bottom Left (ALU bc/bq) Logic

The circuit is on the left side in a spread out layout. The picture shows the parts of the circuit for the individual parts.

![bcbq](/imgstore/modules/bcbq.jpg)

![bcbq_tran](/imgstore/modules/bcbq_tran.jpg)

## Registers

|Reg|Name|Input|Output|Load signal|
|---|---|---|---|---|
|0|IR|DL|IR\[7:0\]|w26|
|1|A|fbus|abus, bbus|x38|
|2|L|ebus|abus, bbus, cbus|x40|
|3|H|fbus|abus, bbus, dbus|x39|
|4|E|ebus|bbus, cbus|x50|
|5|D|fbus|bbus, dbus|x48|
|6|C|ebus|bbus, cbus|x51|
|7|B|fbus|bbus, dbus|x49|
|8|Z ("Temp Low")|Circuit (see below)|zbus, bbus, cbus|x60|
|9|W ("Temp High")|Circuit (see below)|wbus, dbus|x59|

## Regs To Buses

Between the registers scattered small logic for issuing their values to the buses.

![regs_buses](/imgstore/modules/regs_buses.jpg)

## Temp Registers vs Bus Logic

The value on the temp registers (Z/W) does not come directly from the buses, but using logic.

![gk](/imgstore/modules/gk.jpg)

## SP Register

SP bits differ in that they have an additional complement output (`nq`).

![x61](/imgstore/modules/x61.jpg)

SP vs Buses:

![x61_tran](/imgstore/modules/x61_tran.jpg)

## PC Register

The PC bits differ in that they have an additional complement (`nq`) and reset (`SYNC_RES`) output.

![x68](/imgstore/modules/x68.jpg)

PC vs Buses:

![x68_tran](/imgstore/modules/x68_tran.jpg)

## Incrementer/Decrementer

![cntbit](/imgstore/modules/cntbit.jpg)

Counter bits:

![cntbit_tran](/imgstore/modules/cntbit_tran.jpg)

The bit designs are repeated between the lower part (A0-A7) and the upper part (A8-A15), the only difference being that the lower part is connected to cbus/adl and the upper part to dbus/adh.

Counter carry chain:

![cntbit_carry_chain](/imgstore/modules/cntbit_carry_chain.jpg)

The carry chain is done as a "breadcrumped" layout.

## Bottom Right (IRQ) Logic

The IRQ logic consists of the following parts:
- IE
- IF
- Priority encoder
- "Breadcrumps"

### IE

![module7](/imgstore/modules/module7.jpg)

![module7_tran](/imgstore/modules/module7_tran.jpg)

Latch (no edge detection) with reset.

### IF

Program access ($FFFE) to the IF in the DMG CPU has been removed.

![module8](/imgstore/modules/module8.jpg)

![module8_tran](/imgstore/modules/module8_tran.jpg)

It is a regular (transparent) latch (no edge detection), to store the interrupt flag.

### Breadcrumps

I never tire of repeating: dear chip designers - please do not spread the logic this way, because it is difficult to cut it into pieces and post pictures on the wiki. Therefore, I will not give pictures of the topology here - see the general big picture of the bottom part. Pieces of "Breadcrumped" circuits are marked with different colors.

- breadcrumped nor-9 (cyan): sc1 (Any interrupt)
- breadcrumped aoi (green): sc2 (Priority encoder)
- breadcrumped nand-9 (white): A0-A7 + AddrHi -> bot_to_Thingy (Addr = 0xffff)
- breadcrumped nand-8 (red): A8-A15 (AddrHi)
- breadcrumped nor-4 (**x3**): bro3, bro4, bro5 (Interrupt address)

Logic:

![irq_logic_tran](/imgstore/modules/irq_logic_tran.jpg)

Priority encoder:

![irq_prio_tran](/imgstore/modules/irq_prio_tran.jpg)

Interrupt address:

![irq_address_tran](/imgstore/modules/irq_address_tran.jpg)
