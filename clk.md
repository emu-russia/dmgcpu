# Clock Trees

The CPU receives 9 (!) CLK signals.

![clks](/imgstore/clks.png)

|CLK Signal|dmg-schematics Name|Gekkio|
|---|---|---|
|CLK1|ADR_CLK_N|~clk|
|CLK2|ADR_CLK_P|clk|
|CLK3|DATA_CLK_N :warning: Mixed up?|phi|
|CLK4|DATA_CLK_P :warning: Mixed up?|~phi|
|CLK5|INC_CLK_N|~writeback|
|CLK6|INC_CLK_P|writeback|
|CLK7|LATCH_CLK|writeback_ext|
|CLK8|MAIN_CLK_N|~mclk_pulse|
|CLK9|MAIN_CLK_P|mclk_pulse|

All CLKs use an approach called `Dual Rails`, where a single CLK is split into two complementary signals (or "phases"). One phase has a value of `1` when CLK=0 (and is called `Clock Complement`) and the other phase has a value of `1` when CLK=1 (same as CLK).

:warning: To analyze the operation of an individual module, it is not particularly important in which polarity the CLK that is used there comes. It only becomes important when all the modules work together.

## External CLK Circuit

Based on: https://github.com/msinger/dmg-schematics

![CLKGen](/HDL/Design/CLKGen.png)

## Waves

![clk_waves](/imgstore/clk_waves.png)

## Gekkio Waves

|CLK|Pattern|
|---|---|
|CLK1 / ADR_CLK_N / ~clk          | `10000000` |
|CLK2 / ADR_CLK_P / clk           | `01111111` |
|CLK3 / DATA_CLK_P(?) / phi       | `11110000` |
|CLK4 / DATA_CLK_N(?) / ~phi      | `00001111` |
|CLK5 / INC_CLK_N / ~writeback    | `11111100` |
|CLK6 / INC_CLK_P / writeback     | `00000011` |
|CLK7 / LATCH_CLK / writeback_ext | `10000011` |
|CLK8 / MAIN_CLK_N / ~mclk_pulse  | `01111111` |
|CLK9 / MAIN_CLK_P / mclk_pulse   | `10000000` |
