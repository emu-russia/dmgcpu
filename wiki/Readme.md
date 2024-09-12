# DMG-CPU Wiki

## Topics

- [SoC Overview](/wiki/soc/Readme.md)
- [I/O Terminals & Bonding Pads](/wiki/soc/pads.md)
- [Cells Library](/wiki/soc/cells.md)
- [CLK Generator](/wiki/soc/clkgen.md)
- [Divider](/wiki/soc/div.md)
- [SM83 Core](/wiki/sm83/Readme.md)
- [Bus Arbiter](/wiki/soc/arb.md)
- [Memory-mapped I/O](/wiki/soc/mmio.md)
- [HRAM](/wiki/soc/hram.md)
- [PPU](/wiki/soc/ppu.md)
- [OAM](/wiki/soc/oam.md)
- [APU](/wiki/soc/apu.md)
- [Wave RAM](/wiki/soc/waveram.md)
- [Boot ROM](/wiki/soc/bootrom.md)
- [Sound Output DAC](/wiki/soc/dac.md)

## Latch vs DFF vs DLatch vs FF

On this site we use the following conventions for terminology:
- Latch is a static memory element that responds to signal level (0/1)
- DFF is a static memory element which reacts to level change (1->0 aka negedge, 0->1 aka posedge)
- At the same time "FF" (FlipFlop, no D) - we call 2 elements (usually `not` or `nor`) cyclically closed to each other and used as a static memory cell.
- DLatch is a dynamic memory element, which is stored on the FET gate. If it is not refreshed periodically, the value "fades away".

You may have heard other definitions on other sites/Wikipedia, but they are different everywhere (depending on the context), so we clearly define them.

- Static memory elements: they store their value always and "forever", regardless of whether the CLK changes or not
- Dynamic memory elements: they store their value on the FET gate, so they can get "corrupted" if not refreshed for a long time

## Signals Disclaimer

I understand that everyone wants the signals to be called by human-readable and proper names. The SM83 study was conducted at different times, so sometimes you can see strange signal names.

Do not expect that all of them are quickly renamed to proper names. Such a process runs the risk of turning the study into signal renaming and nothing more.

From experience - frequent renaming of signals also contributes to various errors and confusion.

Renaming a signal does not make it work differently :smiley:

## Reference

