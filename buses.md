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

## DV

The value from the bottom for the DataBridge/ALU.

## alu

The value from the bottom for the ALU.

## Res

ALU result to bottom.

## Internal bottom buses

|Bus|To Reg|From Reg|
|---|---|---|
|abus|alu\[7:0\] to top (no reg)|H, L, A, SPL, SPH, PCL|
|bbus|DV\[7:0\] to top (no reg)|B, C, D, E, H, L, A, SPL, SPH|
|cbus|ABL|C, E, L, G, SPL, PCL|
|dbus|ABH|B, D, H, K, SPH, PCH|
|ebus|C, E, L|Dedicated circuit|
|fbus|B, D, H, A|Dedicated circuit|
|gbus|SPL, PCL|G|
|kbus|SPH, PCH|K|
|xbus|SPL, PCL, G|ABL|
|wbus|SPH, PCH, K|ABH|

The names of internal bottom buses are arbitrary (do not make sense).
