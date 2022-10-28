# Registers Block

![locator_regs](/imgstore/locator_regs.png)

## Register Bit

All registers use a common module.

![regbit](/imgstore/modules/regbit.jpg)

![regbit_tran](/imgstore/modules/regbit_tran.jpg)

Latch with complementary set enable, complementary CLK.

- In the middle is a FlipFlop made of not
- Input value can be written to FlipFlop only if CLK=1 and LD=1
- When LD=0 the FlipFlop value is updated with the old value
- The output contains a DLatch with a gate memory that opens when LD=0 (so that the old value is returned during the write (LD=1))
- So the written value becomes relevant when LD 1->0 changes aka negedge (when the output latch opens and is updated with the value from FlipFlop).
- The whole thing is complicated by the complementary layout of the LD and CLK signals.

![regbit_waves](/imgstore/modules/regbit_waves.jpg)

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

## Internal bottom buses

The names of some buses are arbitrary (do not make sense).

|Bus|To Reg|From Reg|Precharge|
|---|---|---|---|
|abus|alu\[7:0\] to top (no reg)|H, L, A, SPL, SPH, PCL|CLK2|
|bbus|DV\[7:0\] to top (no reg)|B, C, D, E, H, L, A, Z, SPL, SPH|CLK2|
|cbus|IDU Lo|C, E, L, Z, SPL, PCL|CLK2|
|dbus|IDU Hi|B, D, H, W, SPH, PCH|CLK2|
|ebus|C, E, L|Dedicated circuit| |
|fbus|B, D, H, A|Dedicated circuit| |
|zbus|SPL, PCL|Z| |
|wbus|SPH, PCH|W| |
|adl|SPL, PCL, Z|IDU Lo| |
|adh|SPH, PCH, W|IDU Hi| |

There are small pieces for Precharge scattered throughout the circuitry.

![bus_precharge](/imgstore/bus_precharge.jpg)

## Regs To Buses

Between the registers scattered small logic for issuing their values to the buses.

![regs_buses](/imgstore/modules/regs_buses.jpg)

![regs_buses_tran](/imgstore/modules/regs_buses_tran.jpg)

## Temp Registers vs Bus Logic

The value on the temp registers (Z/W) does not come directly from the buses, but using logic.

![gk](/imgstore/modules/gk.jpg)

![gk_tran](/imgstore/modules/gk_tran.jpg)

## SP Register

SP bits differ in that they have an additional complement output (`nq`).

![x61](/imgstore/modules/x61.jpg)

SP vs Buses:

![x61_tran](/imgstore/modules/x61_tran.jpg)

## PC Register

The PC bits differ in that they have an additional complement (`nq`) output and reset (`SYNC_RES`) input.

![x68](/imgstore/modules/x68.jpg)

PC Regbit:

![x68_reg_tran](/imgstore/modules/x68_reg_tran.jpg)

PC vs Buses:

![x68_tran](/imgstore/modules/x68_tran.jpg)
