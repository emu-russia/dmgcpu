# Increment/Decrement Unit (IDU)

![locator_idu](/imgstore/locator_idu.png)

![IncDec](/logisim/IncDec.png)

![cntbit](/imgstore/modules/cntbit.jpg)

## Counter bits

![cntbit_tran](/imgstore/modules/cntbit_tran.jpg)

![IncDec_cntbit](/logisim/IncDec_cntbit.png)

The bit designs are repeated between the lower part (A0-A7) and the upper part (A8-A15), the only difference being that the lower part is connected to cbus/adl and the upper part to dbus/adh.

## Counter carry chain

![cntbit_carry_chain](/imgstore/modules/cntbit_carry_chain.jpg)

![IncDec_carry_chain](/logisim/IncDec_carry_chain.png)

The carry chain is done as a "breadcrumped" layout.

## IDU Path

To make the movements between registers and IDU clearer, here is a short description (the process is quite confusing with inverters).

- The value on the cbus/dbus contains a `~val` of register (register `q` output inversion).
- This value is stored on the BusKeeper (transparent DLatch). From the BusKeeper inverted value of `~val` as `val` is fed to the IDU.
- At the output of the IDU the value is fed to the adl/adh buses as `val`.
- There is an inverter on the register input that loads `~val` into the register.
- The register input has the feature that it is in a floating state between CLK6 and CLK7 (the register input is a transparent DLatch)
- In the register the value is stored as `~val` (inverse hold)

![Path_IDU](/imgstore/Path_IDU.png)
