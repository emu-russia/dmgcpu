# Serial Link

![locator_ser](/imgstore/soc/locator_ser.jpg)

![ser](/imgstore/soc/ser.jpg)

|Signal|Dir|From/Where To|Description|
|---|---|---|---|
|sc_write| | | |
|n_reset2| | | |
|lfo_16384Hz| | | |
|sc_read| | | |
|sb_read| | | |
|n_sb_write| | | |
|d\[7:0\]| | | |
|n_sck| | | |
|sck_dir| | | |
|int_serial| | | |
|n_sin| | | |
|ser_out| | | |
|serial_tick| | | |

## ser_reg_bit

![ser_reg_bit_netlist](/imgstore/soc/ser_reg_bit_netlist.png)

|Port|Dir|Description|
|---|---|---|
|d|input|Used to load the previous value to form a shift register|
|q|output|Used to output the current value to form a shift register. The nq output inside the circuit is used to output the value to the databus|
|clk|input|Clock|
|oe|input|Output Enable|
|db|bidir|databus|
|ie + n_ie|input|Complementary Input Enable|
|nres|input|Global reset signal (n_reset2 is used)|

The circuit contains 8-bit shift register based on these elements.

Loading the value from the bus is done in the following way: we cannot use direct feeding, because the `d` input is used to form a chain from the previous bit. Therefore, using the complementary Input Enable and `/set` and `/res` inputs of DFFSR - the register is set to the desired value.

## Map

|Row|Cells|
|---|---|
|1|and, dffr, dffr, dffr, dffr, dffr, muxi, dffr, notif1, dffsr, notif1, oan, nand, not, not, and |
|2|not, dffsr, notif1, oan, nand, not, not2, dffsr, notif1, oan, nand, dffsr, notif1, oan, nand, dffsr, notif1, oan, nand, or |
|3|dffsr, notif1, oan, nand, dffsr, notif1, oan, nand, dffsr, notif1, oan, nand, not2, dffr, not, dffr, notif1 |
