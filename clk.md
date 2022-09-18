# Clock Trees

The CPU receives 9 (!) CLK signals.

![clks](/imgstore/clks.png)

|CLK Signal|Polarity relative to ASIC CLK|Where|
|---|---|---|
|CLK1| | |
|CLK2| | |
|CLK3| | |
|CLK4| | |
|CLK5| | |
|CLK6| | |
|CLK7| | |
|CLK8| | |
|CLK9| | |

All CLKs use an approach called `Dual Rails`: where a single CLK is split into two complementary signals (or "phases"). One phase has a value of `1` when CLK=0 (and is called `Clock Complement`) and the other phase has a value of `1` when CLK=1 (same as CLK).

:warning: To analyze the operation of an individual module, it is not particularly important in which polarity the CLK that is used there comes. It only becomes important when all the modules work together.
