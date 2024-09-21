# Serial Link

![locator_ser](/imgstore/soc/locator_ser.jpg)

![ser](/imgstore/soc/ser.jpg)

![ser_netlist](/imgstore/soc/ser_netlist.png)

|Signal|Dir|From/Where To|Description|
|---|---|---|---|
|sc_write|input|From MMIO| |
|n_reset2|input|From ClkGen|Global reset signal|
|lfo_16384Hz|input|From MMIO| |
|sc_read|input|From MMIO| |
|sb_read|input|From MMIO| |
|n_sb_write|input|From MMIO| |
|d\[7:0\]|bidir| | |
|n_sck|input| | |
|sck_dir|output| | |
|int_serial|output| | |
|n_sin|input| | |
|ser_out|output| | |
|serial_tick|output| | |

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
|1|and, dffr, dffr, dffr, dffr, dffr, muxi, dffr, notif1, {dffsr, notif1, oan, nand}(ser_reg_bit), not, not, and |
|2|not, {dffsr, notif1, oan, nand}(ser_reg_bit), not, not2, {dffsr, notif1, oan, nand}(ser_reg_bit), {dffsr, notif1, oan, nand}(ser_reg_bit), {dffsr, notif1, oan, nand}(ser_reg_bit), or |
|3|{dffsr, notif1, oan, nand}(ser_reg_bit), {dffsr, notif1, oan, nand}(ser_reg_bit), {dffsr, notif1, oan, nand}(ser_reg_bit), not2, dffr, not, dffr, notif1 |
