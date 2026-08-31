# Serial Link

> [!NOTE]
> We need to verify this module somehow. After verification, there will be more confidence that everything is good here. But in general the section looks ok.

Serial Link is split between Ser and APU: a large chunk is located in the APU, because it is closer to the pads (the APU also houses the debug register TEST_PAD, $FF60). Ser contains the core logic of the interface itself.

What Ser does:
- Transfers serial data in both directions via the 8-bit shift register formed by `ser_reg_bit` cells
- Synchronizes the transfer with the external clock (`n_sck`) or the internal low-frequency oscillator (`lfo_16384Hz`)
- Generates the `int_serial` interrupt on transfer completion

![locator_ser](/imgstore/soc/locator_ser.jpg)

![ser](/imgstore/soc/ser.jpg)

![ser_netlist](/imgstore/soc/ser_netlist.png)

## Signals

![ser_ports](/imgstore/soc/ser_ports.png)

|Signal        |Dir    |From/Where To|Description           |
|--------------|-------|-------------|----------------------|
|sc_write      |Input  |From MMIO    | Signal to enable serial control write operations |
|n_reset2      |Input  |From ClkGen  | Active-low Global reset signal|
|lfo_16384Hz   |Input  |From MMIO    | Low-frequency oscillator clock signal (16384 Hz); Can be switched to fast mode (1 MHz) by debugging register TEST_PAD |
|sc_read       |Input  |From MMIO    | Signal to enable serial control read operations |
|sb_read       |Input  |From MMIO    | Signal to enable serial buffer read operations |
|n_sb_write    |Input  |From MMIO    | Active-low signal to enable writing to the serial buffer |
|\[7:0\] d     |Bidir  |Global       | Bidirectional internal data bus |
|n_sck         |Input  |From Pad     | Serial clock input for synchronization |
|sck_dir       |Output |To APU       | Signal indicating the direction of the serial clock |
|int_serial    |Output |To MMIO      | Interrupt signal for serial communication events |
|n_sin         |Input  |From Pad     | Serial input data line |
|ser_out       |Output |To APU       | Serial output data line |
|serial_tick   |Output |To APU       | Signal indicating a serial clock tick |

## Key Functionality

- Shift register: eight `ser_reg_bit` instances (`g1`..`g8`) form the 8-bit shift register. Data is shifted in/out on `w6`/`w8`; the shift register connects to the data bus `d[7:0]` for reading/writing.
- Clock: `w5`..`w8` are derived from `n_sck` and `lfo_16384Hz`; `serial_tick` marks the clock ticks of the transfer.
- Interrupt: `int_serial` is generated through flip-flops `g23`..`g26`.
- Direction: `sck_dir` controls the direction of the serial clock; a mux (`g29`) selects between the internal oscillator and the external clock.

## Signal Flow

- Input: `n_sin` -> shift register (`g1`..`g8`); the value appears on `d[7:0]` when `sb_read` is active.
- Output: on `n_sb_write` the shift register is loaded from `d[7:0]` and shifts the data out on `ser_out`.
- Clock: `w5`..`w8` are generated from `n_sck`/`lfo_16384Hz`; `serial_tick` (`w17`) synchronizes the transfer.
- Interrupt: transfer completion raises `int_serial`, stabilized by flip-flops `g23`..`g26`.

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

Implements a single-bit serial register with buffering and control logic. The circuit contains 8-bit shift register based on these elements.

Loading the value from the bus is done in the following way: we cannot use direct feeding, because the `d` input is used to form a chain from the previous bit. Therefore, using the complementary Input Enable and `/set` and `/res` inputs of DFFSR - the register is set to the desired value.

## Map

|Row|Cells|
|---|---|
|1|and, dffr, dffr, dffr, dffr, dffr, muxi, dffr, notif1, {dffsr, notif1, oan, nand}(ser_reg_bit), not, not, and|
|2|not, {dffsr, notif1, oan, nand}(ser_reg_bit), not, not2, {dffsr, notif1, oan, nand}(ser_reg_bit), {dffsr, notif1, oan, nand}(ser_reg_bit), {dffsr, notif1, oan, nand}(ser_reg_bit), or|
|3|{dffsr, notif1, oan, nand}(ser_reg_bit), {dffsr, notif1, oan, nand}(ser_reg_bit), {dffsr, notif1, oan, nand}(ser_reg_bit), not2, dffr, not, dffr, notif1|