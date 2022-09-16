# Research Methods (ACID FREE)

## Thermal opening method

To get the circuits, you must first extract the ASIC chip.

The following tools are required for the subsequent operation:
- Gas torch
- Mask
- Pliers

![unpackage_tools](/imgstore/shop/unpackage_tools.jpg)

After that, you need to go outside, in a deserted place, clamp a piece of the chip casing with pliers and direct the jet from the gas torch.

:warning: It is very desirable not to inhale the smoke from the burnt plastic of the chip case. It can cause pulmonary edema and is harmful. If you have ever smelled burnt wires, you can imagine how the fried chip body will smell.

You have to fry it until it is ready.

You can tell if it's ready when instead of black plastic there is only gray ash, like this:

![package_fried](/imgstore/shop/package_fried.jpg)

Now all that's left to do is to use a pickaxe to carefully crush the fried case and the chip crystal will fall out of it.

![dig](/imgstore/shop/dig.jpg)

## Cleaning

For cleaning dirt and burnt plastic, pure acetone is excellent:

![acetone](/imgstore/shop/acetone.jpg)

:warning: Acetone is recognized as a carcinogen, so use it with caution!

## Imaging

Photographing is done with a cheap Chinese metallographic microscope (AmScope):

![micro](/imgstore/shop/micro.jpg)

The slides should be photographed evenly and with little overlap, so that it is easier to stitch them together automatically afterwards.

## Stitching with Fiji

Suppose we need to stitch such a dataset:

![dataset](/imgstore/shop/dataset.jpg)

Download 64-bit version: https://imagej.net/software/fiji/

![fiji](/imgstore/shop/fiji.jpg)

Plugins -> Stitching -> Grid/Collection stitching

Choose the order of the slides. Usually the slides are in a "snake" pattern:

|Snake from top to bottom|Snake from bottom to top|
|---|---|
|![order1](/imgstore/shop/order1.jpg)|![order2](/imgstore/shop/order2.jpg)|

Now we have to set it up:
- Number of slides by x (Grid size x)
- Number of rows (Grid size y)
- Tile overlap: are chosen experimentally 5-20% (I use 25 for most cases)
- First file index i: If the name of the slide does not begin with 1
- Directory: slide folder
- File names for tiles: A pattern for the name of the slides. In our case: `{iiii}.jpg` (Slide names begin with 0001.jpg and on)
- Then there are some more obscure options

![options](/imgstore/shop/options.jpg)

After clicking on `Run` the program begins to witchcraft:

![magic](/imgstore/shop/magic.jpg)

And it will give you a picture:

![fused](/imgstore/shop/fused.jpg)

You can save the resulting picture via File -> Save As.

## Lapping

After photographing the top layer, you need to take it off. Polishing is used for this purpose.

The following equipment is used for lapping:

Dremel:

![dremel](/imgstore/shop/dremel.jpg)

GOI paste:

![paste_goi](/imgstore/shop/paste_goi.jpg)

The chip is glued with "Moment" glue to the slide:

![glued_chip](/imgstore/shop/glued_chip.jpg)

Do a polishing session (5-10 seconds), take the chip under the microscope and see what happens.

With enough experience, you can learn how to carefully remove layers of 50-100 nm, which is enough to study old microchips.

:warning: The chromium oxides contained in the GOI paste are mutagens and generally poisonous substances!

## Topology reconstruction

To restore the basic elements, the layers are first drawn in PhotoShop:

![photoshop1](/imgstore/shop/photoshop1.jpg)

Under the picture of the top layer, "patches" from the different stages of polishing are placed:

![photoshop2](/imgstore/shop/photoshop2.jpg)

After getting beautiful pictures, we scratch our heads and reconstruct the schematic of the different pieces.

## Restoring the netlist

See [here](/netlist/Readme.md).

## Conclusions

This way you can safely study microchips, without the use of any acids.
