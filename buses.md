# Internal Buses

## IR

The current value of the IR register. It is used to obtain decoder inputs, and in various places in the logic.

## a

Decoder input.

## d

Decoder1 outputs.

## w

Decoder2 outputs.

## x

Decoder3 outputs.

## DL

The bus between the lower part and the DataLatch. Most likely it is actually just an internal data bus (`DB`), but already named as `DL`.

## DV - ALU Operand2

The value from the bottom for the DataBridge/ALU.

## alu - ALU Operand1

The value from the bottom for the ALU.

## Res

ALU result to bottom.

## Internal bottom buses

|Bus|To Reg|From Reg|
|---|---|---|
|abus|alu\[7:0\] to top (no reg)|H, L, A, SPL, SPH, PCL|
|bbus|DV\[7:0\] to top (no reg)|B, C, D, E, H, L, A, Z, SPL, SPH|
|cbus|IDU Lo|C, E, L, Z, SPL, PCL|
|dbus|IDU Hi|B, D, H, W, SPH, PCH|
|ebus|C, E, L|Dedicated circuit|
|fbus|B, D, H, A|Dedicated circuit|
|zbus|SPL, PCL|Z|
|wbus|SPH, PCH|W|
|adl|SPL, PCL, Z|IDU Lo|
|adh|SPH, PCH, W|IDU Hi|

The names of some internal bottom buses are arbitrary (do not make sense).

## Bidirectional bus multiplexing

This section describes the approach used in SM83 to connect bidirectional buses to consumers.

![buses](/imgstore/buses.jpg)

A few words if the schematic doesn't look very clear.

- The value from the bus does not come directly to the consumer, but is stored on the transparent DLatch (on the FET gates). From the DLatch output, the value comes out as a complement, because DLatch by its nature is an ordinary inverter (not). Why is this done? This is "z-protection": protecting the other consumer circuits from the HighZ value on the bus (regular logic only likes to work with 1's and 0's)
- If you want to output a value from the producer to the bus, the design in the figure below is used:
	- The value is output via znand, with the OE signal used to "open" znand; for this reason, the producer output value is inverted
	- Bus is synchronous (clocked by CLK): when CLK=0 the bus is being precharged, when CLK=1 the value from the producers is updated if they have been "connected" by their OE signals.
	- Several producers can be connected to the bus by hanging additional znand in bunches

From the above, it will be clear why the SM83 uses "inverse hold" for registers.
