# Data Latch

![locator_datalatch](/imgstore/locator_datalatch.png)

![datalatch](/imgstore/datalatch.jpg)

![DataLatch](/HDL/Design/DataLatch.png)

DataLatch is used for the following operations:
- If the external databus (D\[n\]) is not floating, load a value from it to the DataLatch
- Output the current DataLatch value to internal databus (DL\[n\])
- Load the result from the ALU (Res\[n\]) to the DataLatch (x37 = 1)

## DL Bit

DataLatch consists of 8 such chunks:

![module1](/imgstore/modules/module1.jpg)

![module1_tran](/imgstore/modules/module1_tran.jpg)

![DataLatch](/logisim/DataLatch.png)

|Port|Dir|Description|
|---|---|---|
|a|input|DL_Control1. 1: Bus disable|
|b|input|DL_Control2 (x37). ALU Result -> DL|
|c|input|Result from ALU (Res\[n\])|
|clk|input|CLK2|
|Data|inout|External databus (D\[n\])|
|x|inout|Internal databus (DL\[n\])|

It looks like a mixture of dynamic CMOS logic, NMOS and regular CMOS.

A gate capacitance is used as memory.
