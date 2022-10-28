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
