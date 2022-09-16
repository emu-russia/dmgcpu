# Notes on Topology

Topo Sources: https://drive.google.com/drive/u/2/folders/1deuhwmRb-PVv-K7pEllSLKQda2ft94Mk

(PhotoShop required)

- The main part of the ASIC is based on standard cells, CMOS, 2 layers of metal
- The embedded CPU core is "Hand-made" CMOS, using 1 layer of metal.

Here you can see how the 2-layer integration is transitioning into a 1-layer core implementation:

![core_m1_only](/imgstore/core_m1_only.png)

The processor uses hybrid technology:
- Part of the circuitry is based on dynamic logic
- Some of the circuitry is based on convenient CMOS

## VDD/GND

![power](/imgstore/power.jpg)

## Wells

P-Wells.

Here you can see the CMOS "pockets":

![pocket](/imgstore/pocket.png)

## Dynamic Logic

Dynamic logic is used for decoders and random logic:

![dynamic](/imgstore/dynamic.png)

- In the first half-cycle (CLK=0) a Precharge is made
- In the second half-cycle (CLK=1) a logical operation is performed

## CMOS Logic

The upper right corner is built almost entirely on CMOS cells.

Elsewhere, too, there is complementary logic in the form of individual circuit elements.

Example:

![thingy](/imgstore/thingy.jpg)

## Pignose Vias

![pignose](/imgstore/pignose.png)

For the interconnection, paired vias are used. Twice as much work.

## Capacitors

TBD.
