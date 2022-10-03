# DMG CPU Core

DMG-01 SM83 core research.

The core can be found here:

![cpu_location](/imgstore/cpu_location.jpg)

The `B` revision of the DMG ASIC is being studied.

## Basic Circuit Designs

The core consists of the following main components:
- The ALU (upper left corner), the flags setting logic and the flags register (most likely there too, but it's not certain)
- A decoder of three levels. Each level outputs a bunch of signals (`d`, `w`, `x`) with a smaller number at each successive level. The main driving force for all the other parts is the set of `x` signals. Decoders are made as NAND/NOR trees + domino logic.
- The sequencer occupies the right side and is built on "sort of" standard cells. Actually they are not cells in the usual sense, but "handmade" using standard modules and tweaking them a little bit in some places as required.
- At the bottom is the branch logic, the registers block, the SP and the PC. Also obviously there is a small circuit for interrupt control and a small but important circuit called the "Thingy".

![sm83](/HDL/Design/sm83.png)

## Latest Progress

At the moment, the entire topology of the top part and almost the entire topology of the bottom part have been obtained. The basic circuit principles are understood and the transistor circuits of most of the modules are obtained. The main emphasis was made on the sequencer circuit, as the most demanded one.

For decoders it is necessary to restore all NAND/NOR-trees (you can do it directly from the picture).

![DMG01B_Core_Fused_Topo](/imgstore/DMG01B_Core_Fused_Topo.jpg)

https://www.pastraiser.com/cpu/gameboy/gameboy_opcodes.html

## Why SM83?

I don't know, everyone calls the DMG CPU core the SM83 and so do we.
