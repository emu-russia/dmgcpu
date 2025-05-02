# Serial Link

> [!NOTE]
> We need to verify this module somehow. After verification, there will be more confidence that everything is good here. But in general the section looks ok.

![locator_ser](/imgstore/soc/locator_ser.jpg)

![ser](/imgstore/soc/ser.jpg)

![ser_netlist](/imgstore/soc/ser_netlist.png)

## Signals

![ser_ports](/imgstore/soc/ser_ports.png)

|Signal        |Dir    |From/Where To|Description           |
|--------------|-------|-------------|----------------------|
|sc_write      |Input  |From MMIO    | Signal to enable serial control write operations |
|n_reset2      |Input  |From ClkGen  | Active-low Global reset signal|
|lfo_16384Hz   |Input  |From MMIO    | Low-frequency oscillator clock signal (16384 Hz) |
|sc_read       |Input  |From MMIO    | Signal to enable serial control read operations |
|sb_read       |Input  |From MMIO    | Signal to enable serial buffer read operations |
|n_sb_write    |Input  |From MMIO    | Active-low signal to enable writing to the serial buffer |
|\[7:0\] d     |Bidir  |Global       | Bidirectional data bus for communication with the CPU |
|n_sck         |Input  |             | Serial clock input for synchronization |
|sck_dir       |Output |             | Signal indicating the direction of the serial clock |
|int_serial    |Output |             | Interrupt signal for serial communication events |
|n_sin         |Input  |             | Serial input data line |
|ser_out       |Output |             | Serial output data line |
|serial_tick   |Output |             | Signal indicating a serial clock tick |

## DeepSeek Analysis

### Detailed Description of the Serial Link DMG-CPU Verilog Module

The provided Verilog module, named `Ser`, implements a **serial communication interface** for the DMG-CPU (Game Boy CPU). This module handles the transmission and reception of serial data, including clock synchronization, data buffering, and interrupt generation. Below is a detailed breakdown of its functionality and structure.

---

### **Module Overview**
The `Ser` module is responsible for:
1. **Serial Data Transmission and Reception**: It manages the bidirectional flow of serial data between the CPU and external devices.
2. **Clock Synchronization**: It uses an external clock (`n_sck`) and an internal low-frequency oscillator (`lfo_16384Hz`) to synchronize data transfer.
3. **Interrupt Generation**: It generates an interrupt signal (`int_serial`) to notify the CPU of data transfer completion or errors.
4. **Data Buffering**: It uses shift registers and flip-flops to buffer incoming and outgoing data.

---

### **Key Functionality**

#### **1. Data Buffering and Shifting**
- The module uses eight `ser_reg_bit` instances (`g1` to `g8`) to form an 8-bit shift register.
- Data is shifted in/out serially based on the clock signals (`w6`, `w8`).
- The bidirectional data bus (`d[7:0]`) is connected to the shift registers for reading/writing data.

#### **2. Clock Synchronization**
- The external clock (`n_sck`) and internal oscillator (`lfo_16384Hz`) are used to generate synchronized clock signals (`w5`, `w6`, `w7`, `w8`).
- The `serial_tick` signal is generated to indicate clock ticks for data transfer.

#### **3. Interrupt Generation**
- The `int_serial` signal is generated to notify the CPU of serial communication events.
- Flip-flops (`g23` to `g26`) are used to debounce and synchronize the interrupt signal.

#### **4. Direction Control**
- The `sck_dir` signal controls the direction of the serial clock.
- A multiplexer (`g29`) selects between the internal oscillator and external clock based on `sck_dir`.

---

### **Signal Flow**
1. **Data Input**:
   - Serial data is received on `n_sin` and buffered in the shift registers (`g1` to `g8`).
   - The data is then made available on the bidirectional data bus (`d[7:0]`) when `sb_read` is active.

2. **Data Output**:
   - Data from the CPU is written to the shift registers via `d[7:0]` when `n_sb_write` is active.
   - The data is shifted out serially on `ser_out`.

3. **Clock and Control**:
   - The clock signals (`w5`, `w6`, `w7`, `w8`) are generated from `n_sck` and `lfo_16384Hz`.
   - The `serial_tick` signal (`w17`) is used to synchronize data transfer.

4. **Interrupt Handling**:
   - The `int_serial` signal is generated based on data transfer completion or errors.
   - Flip-flops (`g23` to `g26`) ensure the interrupt signal is stable and synchronized.

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