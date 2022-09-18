# Random Logic

:warning: The section is in development.

![locator_random_logic](/imgstore/locator_random_logic.png)

Usually this is the kind of logic that only the person who made it understands.

The task of this logic is to generate the control signals for the bottom part.

![rnd](/imgstore/rnd.jpg)

## Random Logic Inputs

TBD.

## IR Nots

![ir_nots](/imgstore/ir_nots.jpg)

## Output Drivers

![rnd_drv](/imgstore/modules/rnd_drv.jpg)

## Random Logic Outputs

|Output|Name|CLK|To|Description|
|---|---|---|---|---|
|x0| |CLK2|ALU Bot| |
|x1| |CLK2|ALU Bot| |
|x2| |CLK2 |internal| |
|x3| |CLK2 |ALU Top| |
|x4| |CLK2 |ALU module2| |
|x5| |CLK2 |ALU AND combs| |
|x6| |CLK2 |ALU AND combs| |
|x7| |CLK2 |ALU AND combs| |
|x8| |CLK2 |ALU AND combs| |
|x9| |CLK2 |ALU AND combs| |
|x10| |CLK2 |ALU Bot| |
|x11| |CLK2 |ALU Bot| |
|x12| |CLK2 |ALU Bot| |
|x13| |CLK2 |internal| |
|x14| |CLK2 |internal| |
|x15|DataOut|:warning: CLK4 |Data Bridge| |
|x16| |CLK2 |ALU AND combs| |
|x17| |CLK2 |internal| |
|x18| |CLK2 |ALU Top| |
|x19| |CLK2 |ALU Bot, ALU module2| |
|x20| |CLK2 |internal| |
|x21| |CLK2 |ALU Bot| |
|x22| |CLK2 |ALU Bot| |
|x23| |CLK2 |internal| |
|x24| |CLK2 |ALU Bot| |
|x25| |CLK2 |ALU module2| |
|x26| |CLK2 |ALU Bot| |
|x27| |CLK2 |ALU Bot| |
|x28| |:warning: CLK4|ALU Bot Res| |
|x29| |:warning: CLK4|ALU Bot Res| |
|x30| |CLK2 |internal| |
|x31| |CLK2 |internal| |
|x32| |CLK2 |internal| |
|x33| |CLK2 |Bottom| |
|x34| |CLK2 |internal| |
|x35| |CLK2 |Bottom| |
|x36| |CLK2 |internal| |
|x37|DL_Control2|CLK2 |Data Latch| |
|x38| |CLK2 |Bottom| |
|x39| |CLK2 |Bottom| |
|x40| |CLK2 |Bottom| |
|x41| |CLK2 |Sequencer| |
|x42| |CLK2 |Bottom| |
|x43| |CLK2 |Bottom| |
|x44| |CLK2 |Bottom| |
|x45| |CLK2 |Bottom| |
|x46| |CLK2 |Bottom| |
|x47| |CLK2 |Bottom| |
|x48| |:warning: CLK4|Bottom| |
|x49| |:warning: CLK4|Bottom| |
|x50| |:warning: CLK4|Bottom| |
|x51| |:warning: CLK4|Bottom| |
|x52| |CLK2 |Bottom| |
|x53| |CLK2 |Bottom| |
|x54| |CLK2 |Bottom| |
|x55| |CLK2 |Bottom| |
|x56| |:warning: CLK4|Bottom| |
|x57| |CLK2 |Bottom| |
|x58| |CLK2 |Bottom| |
|x59| |CLK2 |Bottom| |
|x60| |CLK2 |Bottom| |
|x61| |CLK2 |Bottom (twice)| |
|x62| |CLK2 |Bottom| |
|x63| |CLK2 |Bottom| |
|x64| |CLK2 |internal| |
|x65| |CLK2 |Bottom| |
|x66| |CLK2 |internal| |
|x67| |CLK2 |Bottom| |
|x68| |CLK2 |Bottom (twice)| |

(Outputs not marked as `internal` can still be used internally, I just did not mark it unnecessarily).
