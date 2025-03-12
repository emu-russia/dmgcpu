# DMG-CPU

DMG-CPU SoC research.

![demo](/imgstore/soc/demo.png)

Originally, this repository was used to research the SM83 Core included in the SoC, but then the interests were expanded.

To get all the information visit the [Wiki](/wiki/Readme.md).

## Purpose of the Research

DMG-CPU is a fairly well researched chip. It is difficult to add something and not to repeat :-) That's why we will try to make the result of the research an addition to what is already known.

The main goal (as in our other projects) is to get a netlist on Verilog, preferably as close as possible to the real chip ("die-perfect"). For this purpose we use the [Deroute utility](https://github.com/emu-russia/Deroute), which allows us to export ready-to-use Verilog at once.

Then the reader has 2 options: either to "understand" the decompiled netlist (which in principle has already been done in @msinger's work), or to use it "without understanding" in other projects.

## Progress

|Case|Top-Level|Pads|Memory|DAC|ClkGen|Ser|MMIO|Arb|PPU|APU|SM83|
|---|---|---|---|---|---|---|---|---|---|---|---|
|Topology                         | | | | |✅|✅| | | | |✅|
|List of ports with description   | | | | |✅|✅| | | | |✅|
|Map of cells/modules             | | | | |✅|✅| | | | |✅|
|Netlist                          | | | | |✅|✅| | | | |✅|
|Verilog                          | | | | |✅|✅| | | | |✅|
|Design extracted from PlanAhead  | | | | |✅| | | | | |✅|
|Verification with @msinger       | | | | |✅| | | | | |-|

TBD: The SoC landing page and content is not yet fully populated, in process..

## Related

- DMG LCD Research: https://github.com/ogamespec/dmg-lcd
- MBC1 Mapper: https://github.com/emu-russia/mappers/tree/main/MBC1