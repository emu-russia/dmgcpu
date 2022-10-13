# Clock Trees

The CPU receives 9 (!) CLK signals.

![clks](/imgstore/clks.png)

|CLK Signal|dmg-schematics Name|
|---|---|
|CLK1|ADR_CLK_N|
|CLK2|ADR_CLK_P|
|CLK3|DATA_CLK_N|
|CLK4|DATA_CLK_P|
|CLK5|INC_CLK_N|
|CLK6|INC_CLK_P|
|CLK7|LATCH_CLK|
|CLK8|MAIN_CLK_N|
|CLK9|MAIN_CLK_P|

All CLKs use an approach called `Dual Rails`, where a single CLK is split into two complementary signals (or "phases"). One phase has a value of `1` when CLK=0 (and is called `Clock Complement`) and the other phase has a value of `1` when CLK=1 (same as CLK).

:warning: To analyze the operation of an individual module, it is not particularly important in which polarity the CLK that is used there comes. It only becomes important when all the modules work together.

## External CLK Circuit

Based on: https://github.com/msinger/dmg-schematics

![CLKGen](/HDL/Design/CLKGen.png)

## Waves

![clk_waves](/imgstore/clk_waves.png)

TBD: The picture shows that some signals are wrongly named or the simulation/schematic is incorrect (mixed up names for: MAIN_CLK_P/MAIN_CLK_N, DATA_CLK_N/DATA_CLK_P). Check with @msinger.

It's always such a headache with clocks, it's normal.
