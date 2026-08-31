# OAM

![locator_oam](/imgstore/soc/locator_oam.jpg)

![oam](/imgstore/soc/oam.jpg)

## Signals

![oam_ports](/imgstore/soc/oam_ports.png)

| Signal Name            | Direction | From / Where To             | Description |
|------------------------|-----------|-----------------------------|-------------|
| n_oam_rd               | Input     | From PPU2                   | OAM read enable (active low) |
| n_oama_wr              | Input     | From PPU2                   | OAM port A write enable (active low) |
| n_oamb_wr              | Input     | From PPU2                   | OAM port B write enable (active low) |
| \[7:1\] oa             | Input     | From PPU2                   | OAM address bus (bit 0 is not used, lsb=1) |
| oam_bl_pch             | Input     | From PPU2                   | OAM bitline precharge |
| \[7:0\] n_oama         | Bidir     | To/From PPU2                | OAM port A data bus (inverse hold) |
| \[7:0\] n_oamb         | Bidir     | To/From PPU2                | OAM port B data bus (inverse hold) |

OAM is a dual-port SRAM. Port A and port B are both controlled by PPU2; it is assumed that port A serves the CPU/DMA side (write access via `oam_din`/`oam_dma_wr`) and port B serves the PPU renderer itself, but this needs verification. See also the [Buses table](Readme.md).