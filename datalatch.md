# Data Latch

![locator_datalatch](/imgstore/locator_datalatch.png)

![datalatch](/imgstore/datalatch.jpg)

![DataLatch](/HDL/Design/DataLatch.png)

DataLatch is used for the following operations:
- If the external data bus (D\[n\]) is not floating, load a value from it to the DataLatch
- Output the current DataLatch value (DL\[n\]) for the bottom
- Load the result from the ALU (Res\[n\]) to the DataLatch (x37 = 1)

## DL Bit

DataLatch consists of 8 such chunks:

![module1](/imgstore/modules/module1.jpg)

![module1_tran](/imgstore/modules/module1_tran.jpg)

|Port|Dir|Description|
|---|---|---|
|a|input|DL_Control1|
|b|input|DL_Control2 (x37)|
|c|input|Result from ALU (Res\[n\])|
|clk|input|CLK2|
|Data|inout|Connects to external data bus (D\[n\])|
|x|inout|Current value (DL\[n\])|

It looks like a mixture of dynamic CMOS logic, NMOS and regular CMOS.

A gate capacitance is used as memory.

After analyzing this circuit it became clear that the external port `Maybe1` (signal `DL_Control1`) is in fact most likely `#CPU_ChipSelect`. When #CPU_CS = 1 - the core is completely disconnected from the ASIC data bus.
