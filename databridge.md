# Data Bus Bridge

![locator_databridge](/imgstore/locator_databridge.png)

![databridge](/imgstore/databridge.jpg)

![DataBridge](/HDL/Design/DataBridge.png)

The purpose of this circuit is load DV bus value into DataLatch (DL bus).

The DV value also goes "through" the DataBridge and is fed to the ALU input.

It is quite possible that this is just part of the DataLatch, but the developers separated the two circuits to reduce the length of the wires.

![bridge_comb](/imgstore/modules/bridge_comb.jpg)

![bridge_comb_tran](/imgstore/modules/bridge_comb_tran.jpg)
