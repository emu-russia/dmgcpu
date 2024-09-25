# High RAM (HRAM)

![locator_hram](/imgstore/soc/locator_hram.jpg)

![hram](/imgstore/soc/hram.jpg)

![hram_netlist](/imgstore/soc/hram_netlist.png)

Features:
- 8 bit lanes
- 4 columns per bit lane
- 32 rows per column
- 1024 bit total

|Signal|Dir|From/Where To|Description|
|---|---|---|---|
| clk7| input|From ClkGen| (Aka BUKE)|
| soc_rd| input|From MMIO |SoC data bus read (Aka CPU_RD)|
| soc_wr| input|From MMIO |SoC data bus write (Aka CPU_WR)|
| \[7:0\] d| bidir| |SoC internal data bus |
| ffxx| input|From Arb | |
| \[7:0\] a| input|From Core |SoC internal address bus (lower 8 bits) |

## Bit lane

![sram_bit_lane_netlist](/imgstore/soc/sram_bit_lane_netlist.png)

Features:
- The output contains nor latch, the value from which is output to the data bus via a tri-state inverter
- Tri-state inverter has a complementary control signal `oe` + `/oe`
- At the very bottom is Column Mux, which also acts as a pass-gate (the bit value is bidirectional)
- Above the Column Mux is a small circuit similar to the Sense Amp, but for some reason it works in reverse (it amplifies the input value from the data bus, not the cell value from the Cell Array)
- The input value is demultiplexed by a small logic from the nand+not bundle and controlled by the `wr` signal
- Bit values from Cell Array in complementary logic BL + BL_bar (well this is common practice)
- The circuit contains additional "prechargers" for bit line (besides those in Cell Array), apparently for balancing purposes

## Cells Array

TBD.

## Row Decoder

TBD.

## External Logic

The auxiliary logic is used to control precharge, obtain address bit complements, etc. It is made on the basis of standard cells, apparently the developers considered it unnecessary to embed it as a custom design.

TBD.
