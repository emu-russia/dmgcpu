# Small Thingy

![locator_thingy](/imgstore/sm83/locator_thingy.png)

![thingy](/imgstore/sm83/thingy.jpg)

The circuit deals with the following things:
- Controls the Inc/Dec circuit at the bottom
- Generates the `Thingy_to_bot` signal ("write to the IE register")

|Signal|Type|From/To|Description|
|---|---|---|---|
|w8|input|Decoder2|PCL/PCH to abus/dbus|
|w31|input|Decoder2| |
|w35|input|Decoder2| |
|w6|input|Decoder2|WR|
|ALU_to_Thingy|input|ALU|ALU CarryOut|
|TempZ|input|Bottom|Flag Z from temp Z register (zbus\[7\])|
|TTB1|output|Bottom|1: Perform pairwise increment/decrement (simultaneously for two 8-bit IncDec halves)|
|TTB2|output|Bottom|1: Perform decrement|
|TTB3|output|Bottom|1: Perform increment|
|bot_to_Thingy|input|Bottom|IE access detected (Address = 0xffff)|
|Thingy_to_bot|output|Bottom|Load a value into the IE register from the DL bus.|

![thingy_tran](/imgstore/sm83/thingy_tran.jpg)

![Thingy](/HDL/sm83/Design/Thingy.png)
