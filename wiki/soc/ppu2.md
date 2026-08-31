# PPU2

> [!WARNING]  
> The research has gained critical mass, the netlist is verified but not annotated. The signal table is filled based on the netlist, but the descriptions require human verification. Further research is required.

![ppu2](/imgstore/soc/ppu2.jpg)

## Signals

![ppu2_ports](/imgstore/soc/ppu2_ports.png)

| Signal Name         | Direction | From / Where To             | Description |
|---------------------|-----------|-----------------------------|-------------|
| FF40_D1             | Input     | From PPU1                   | LCDC register ($FF40) bit 1 (OBJ enable) |
| FF40_D2             | Input     | From PPU1                   | LCDC register ($FF40) bit 2 (OBJ size) |
| FF40_D3             | Input     | From PPU1                   | LCDC register ($FF40) bit 3 (BG tile map select) |
| \[7:0\] a           | Input     | From Core                   | Internal address bus (VRAM access, 8 bits) |
| bp_cy               | Input     | From PPU1                   | Buffer page cycle |
| bp_sel              | Input     | From PPU1                   | Buffer page select |
| cclk                | Input     | From ClkGen                 | Input clk complement (same as n_clk_in) (Aka AZOF) |
| clk6                | Input     | From ClkGen                 | Clock 6 (Aka INC_CLK_P) |
| cpu_vram_oam_rd     | Input     | From MMIO                   | CPU VRAM/OAM read strobe |
| \[12:0\] dma_a      | Input     | From MMIO                   | DMA address bus |
| dma_addr_ext        | Input     | From MMIO                   | DMA address (external memory) |
| dma_run             | Input     | From MMIO                   | DMA run control |
| fexx                | Input     | From PPU1                   | FExx register area indicator (VRAM/OAM) |
| ff42                | Input     | From PPU1                   | SCX register ($FF42) access indicator |
| ff43                | Input     | From PPU1                   | SCY register ($FF43) access indicator |
| \[7:0\] h           | Input     | From PPU1                   | H counter (LX) value |
| in_window           | Input     | From PPU1                   | In-window indicator |
| ma0                 | Input     | From PPU1                   | VRAM address bit 0 (MA0) |
| n_dma_phi           | Input     | From MMIO                   | DMA clock (inverted) |
| n_dma_phi2_latched  | Input     | From PPU1                   | Latched inverted DMA clock 2 |
| n_ppu_reset         | Input     | From PPU1                   | PPU reset (active low) |
| n_reset2            | Input     | From ClkGen                 | Global reset (active low) |
| oam_addr_ck         | Input     | From PPU1                   | OAM address clock |
| \[7:0\] oam_din     | Input     | From Arb                    | OAM data input bus |
| oam_dma_wr          | Input     | From MMIO                   | OAM DMA write strobe |
| oam_mode3_bl_pch    | Input     | From PPU1                   | OAM bitline precharge during MODE3 |
| oam_mode3_nrd       | Input     | From PPU1                   | OAM read during MODE3 (active low) |
| oam_rd_ck           | Input     | From PPU1                   | OAM read clock |
| oam_xattr_latch_cck | Input     | From PPU1                   | OAM X attribute latch clock |
| obj_prio_ck         | Input     | From PPU1                   | Object priority clock |
| ppu_mode3           | Input     | From PPU1                   | PPU Mode 3 (pixel transfer) indicator |
| soc_rd              | Input     | From MMIO                   | SoC read strobe |
| soc_wr              | Input     | From MMIO                   | SoC write strobe |
| sp_bp_cys           | Input     | From PPU1                   | Sprite buffer page cycle |
| tm_cy               | Input     | From PPU1                   | Tile map cycle |
| \[7:0\] v           | Input     | From PPU1                   | V counter (LY) value |
| vbl                 | Input     | From PPU1                   | VBLANK indicator |
| vclk2               | Input     | From PPU1                   | VRAM clock 2 |
| vram_to_oam         | Input     | From MMIO                   | VRAM to OAM transfer enable (DMA) |
| CONST0              | Bidir     | Global                      | Constant 0 signal [^2] |
| FF43_D0             | Output    | To PPU1                     | SCY register ($FF43) bit 0 |
| FF43_D1             | Output    | To PPU1                     | SCY register ($FF43) bit 1 |
| FF43_D2             | Output    | To PPU1                     | SCY register ($FF43) bit 2 |
| clk6_delay          | Output    | To MMIO                     | Delayed clock 6 |
| \[7:0\] d           | Bidir     | Global                      | Internal data bus |
| h_restart           | Output    | To PPU1                     | H counter restart |
| \[7:0\] md          | Bidir     | Global                      | Internal video memory data bus (VRAM) |
| n_oam_rd            | Output    | To OAM                      | OAM read enable (active low) |
| \[7:0\] n_oama      | Bidir     | To/From OAM                 | OAM port A data bus (inverse hold) |
| n_oama_wr           | Output    | To OAM                      | OAM port A write enable (active low) |
| \[7:0\] n_oamb      | Bidir     | To/From OAM                 | OAM port B data bus (inverse hold) |
| n_oamb_wr           | Output    | To OAM                      | OAM port B write enable (active low) |
| n_ppu_clk           | Output    | To PPU1                     | PPU clock (inverted) |
| n_ppu_hard_reset    | Output    | To MMIO, Arb, PPU1          | PPU hard reset (active low) |
| \[12:0\] nma        | Bidir     | Global                      | Internal video memory address bus between PPUs (inverse hold) |
| \[7:1\] oa          | Output    | To OAM                      | OAM address (bits 7:1; bit 0 is not used) |
| oam_bl_pch          | Output    | To OAM                      | OAM bitline precharge |
| n_vram_to_oam       | Output    | To Arb                      | VRAM to OAM transfer (inverted) |
| obj_color           | Output    | To PPU1                     | Object color |
| obj_prio            | Output    | To PPU1                     | Object priority |
| ppu_clk             | Output    | To MMIO, PPU1               | PPU clock |
| ppu_mode2           | Output    | To PPU1                     | PPU Mode 2 (OAM scan) indicator |
| ppu_rd              | Output    | To MMIO, PPU1               | PPU read strobe |
| ppu_wr              | Output    | To MMIO, PPU1               | PPU write strobe |
| sprite_x_flip       | Output    | To PPU1                     | Sprite X flip |
| sprite_x_match      | Output    | To PPU1                     | Sprite X match |
| stop_oam_eval       | Output    | To PPU1                     | Stop OAM evaluation |

[^2]: The constant 0 is globally scattered throughout the chip. Each large module with cells has a `const` cell whose output 0 is globally connected between all modules (so the input is marked as Bidir).

## Netlist

![ppu2_netlist](/imgstore/soc/ppu2_netlist.png)

## Annotated Design

TBD.

![ppu2](/HDL/soc/design/ppu2.png)

## Map

|Row|Cells|
|---|---|
|1|not, not2, not2, not2, not4, or3, not2, not, and, aon22, nor3, notif0, notif0, and, not, and, and, and, notif0, fa, not2, notif0, fa, notif0, notif0, notif0, and, notif0, notif0, notif0, notif0, not, notif0, not, dffr, notif0, notif0, and3, nand, nand, notif0, notif0, fa, notif0, notif0, and, not2, notif0, not2, not2, and, not2, and, not, and, not, and, ha, not2, not2, not2, or, not, not, not2, not2, not2, nor, not, not2, not2, not, or, notif0, notif0, not, notif0, not, notif0, not, notif0, notif0, latchnq_comp, notif0, notif0, latchnq_comp, not, notif0, latchnq_comp, latchnq_comp, latchnq_comp, latchnq_comp, not, notif0, notif0, latchnq_comp, latchnq_comp, latchnq_comp, latchnq_comp, notif0, notif0, latchnq_comp, latchnq_comp, latchnq_comp, latchnq_comp|
|2|not, notif0, notif0, notif0, notif0, not, nand3, notif0, not, notif0, latchr_comp, latchr_comp, not, not, notif0, notif0, notif0, notif0, notif0, notif0, fa, fa, not, and, fa, and, notif0, nor_latch, oan, latchnq_comp, nand3, not, notif0, notif0, notif0, xor, not, xor, notif0, not2, notif0, not, not, dffr, not, not, or3, xor, xor, fa, not, xor, xor, latchnq_comp, latchnq_comp, latchnq_comp, not, latchnq_comp, latchnq_comp, not, latchnq_comp, not, latchnq_comp, latchnq_comp, not, not, notif0, latchnq_comp, notif0, not, latchnq_comp, notif0, notif0, notif0, not, dffr, and, dffr, notif0, notif0, not, not, not, notif0, or, notif0, latchnq_comp, notif0, notif0, notif0, not, not, notif0, not|
|3|not, not2, notif0, not2, notif0, oai, notif0, latchr_comp, latchr_comp, notif0, notif0, notif0, latchr_comp, notif0, notif0, notif0, not4, notif0, latch, notif0, not, notif0, notif0, not2, notif0, notif0, notif0, dffr, dffr, not2, not2, and3, notif0, xor, latchnq_comp, latchnq_comp, notif0, notif0, latchnq_comp, latchnq_comp, nor4, not, xor, xor, xor, nor4, latchr_comp, latchr_comp, xor, nor4, not, latchr_comp, notif0, notif0, notif0, latchr_comp, dffr, not, notif0, latchnq_comp, notif0, latchnq_comp, latchnq_comp, latchnq_comp, notif0, latchnq_comp, latchnq_comp, notif0, nor4, xor, xor, not, or, not, not, dffr, not, not, not, or, nand4, or, or, nand4, latchnq_comp, notif0, or, latchnq_comp, nand4, notif0, or|
|4|not, not, notif0, notif0, not2, notif0, not2, notif0, latchr_comp, latchr_comp, bufif0, notif0, latchr_comp, fa, notif0, fa, notif0, notif0, notif0, notif0, latchnq_comp, notif0, latchnq_comp, latchnq_comp, latchnq_comp, notif0, latchnq_comp, not, not2, notif0, latchnq_comp, latchnq_comp, not, not, not, dffr, xor, xor, xor, not, nand3, xor, latchr_comp, nor4, xor, latchr_comp, latchr_comp, latchr_comp, latchr_comp, nand3, latchr_comp, not, latchr_comp, latchr_comp, dffr, not, not, or, not2, or, not2, not, xor, nor4, xor, nand3, xor, xor, xor, not, dffr, latchr_comp, latchr_comp, not, notif0, notif0, notif0, nand4, nand4, not, not, not, not, nand4, latchnq_comp, notif0, not, notif0, latchnq_comp|
|5|notif0, notif0, notif0, notif0, notif0, notif0, notif0, notif0, notif0, notif0, notif0, fa, fa, not, fa, fa, fa, notif0, notif0, latch, dffr, not, not, fa, notif0, fa, latchr_comp, latchr_comp, latchr_comp, latchr_comp, xor, xor, latchr_comp, xor, not, xor, nand3, xor, nor4, xor, xor, not, nor, or, nor, dffr, not, dffr, dffr, nand3, notif0, notif0, xor, latchr_comp, nor4, latchr_comp, latchr_comp, latchr_comp, latchr_comp, not, latchnq_comp, latchnq_comp, notif0, notif0, not, notif0, not, latchnq_comp, latchnq_comp, not, not, latchnq_comp|
|6|notif0, notif0, notif0, notif0, notif0, notif0, notif0, notif0, bufif0, latchr_comp, latchr_comp, latchr_comp, latchr_comp, latchr_comp, latchr_comp, notif0, notif0, notif0, not, dffr, and4, notif0, ha, notif0, dffr, notif0, not, notif0, notif0, notif0, not, not, fa, not, not, fa, not, notif0, notif0, latchr_comp, latchr_comp, latchr_comp, or, nand5, or, latchr_comp, nor4, latchr_comp, nand5, or, nor, latchr_comp, latchr_comp, or, not2, or, dffr, latchnq_comp, nor4, latchnq_comp, latchr_comp, xor, xor, xor, xor, latchr_comp, latchr_comp, latchr_comp, not, not, not2, not2, not, latchnq_comp, latchnq_comp, not, latchnq_comp, latchnq_comp, not, nand4, not, not, latchnq_comp|
|7|notif0, notif0, notif0, and3, notif0, not, notif0, latchr_comp, notif0, notif0, notif0, notif0, latchr_comp, notif0, notif0, notif0, notif0, notif0, notif0, not, not, notif0, not, notif0, fa, or, dffr, notif0, notif0, latchnq_comp, not, not, not, fa, notif0, fa, or, not, not2, not2, not2, not, or, not, aon22, or, not, or, dffr, nor, nor, nor, not, or, not, not, not, xor, nor, xor, or, xor, xor, nor, not, or, not2, nor, or, not, or, not, latchnq_comp, latchnq_comp, latchnq_comp, latchnq_comp, xor, xor, xor, latchr_comp, latchr_comp, xor, latchr_comp, not, latchr_comp, latchr_comp, or, not, not, latchnq_comp, latchnq_comp, latchnq_comp, latchnq_comp, latchnq_comp, not, notif0, nand4, nand4, notif0|
|8|notif0, notif0, notif0, aon, not2, not, and3, notif0, notif0, notif0, notif0, not2, notif0, notif0, notif0, const, notif0, latch, latch, not2, notif0, notif0, fa, notif0, notif0, dffr, notif0, notif0, latchnq_comp, not, nand6, notif0, notif0, notif0, notif0, notif0, latchnq_comp, notif0, notif0, not, notif0, notif0, not, notif0, notif0, not, not, not, xor, dffr, latchr_comp, not, not, not, latchr_comp, latchr_comp, or, not, or, not, or, not, not, dffr, not, or, notif0, notif0, not, dffr, or, notif0, notif0, not, notif0, latchr_comp, not, not, latchr_comp, not, xor, xor, latchr_comp, latchr_comp, notif0, notif0, not, notif0, notif0, notif0, not, notif0, notif0, notif0, latchnq_comp, not, nand4, not, not, or|
|9|notif0, bufif0, bufif0, bufif0, bufif0, bufif0, bufif0, bufif0, bufif0, latch, dffrnq_comp, dffrnq_comp, latchnq_comp, notif0, not, dffrnq_comp, dffrnq_comp, latch, latchnq_comp, not, latchnq_comp, latchnq_comp, notif0, latchnq_comp, latchnq_comp, latchnq_comp, not, latchnq_comp, latchnq_comp, latchnq_comp, latchnq_comp, latchnq_comp, latchr_comp, latchr_comp, latchr_comp, latchr_comp, xor, latchr_comp, xor, xor, nor, or, latchr_comp, latchr_comp, dffr, latchr_comp, latchr_comp, not, nand3, xor, not2, xor, xor, latchr_comp, latchr_comp, xor, nor4, not, latchr_comp, latchr_comp, latchr_comp, latchnq_comp, latchnq_comp, latchnq_comp, latchnq_comp, not, or, latchnq_comp, latchnq_comp, notif0|
|10|bufif0, bufif0, bufif0, and, and, bufif0, not, notif0, not, latch, latch, latch, latch, latch, latch, latchnq_comp, latchnq_comp, not, not, not, dffrnq_comp, dffr, not, not, latchnq_comp, not, not, latchnq_comp, latchnq_comp, not, notif0, not, notif0, notif0, latchnq_comp, xor, xor, nor4, nor4, nand3, xor, not, xor, xor, xor, nor4, xor, xor, notif0, nand3, nand3, notif0, nor4, xor, latchr_comp, latchr_comp, latchr_comp, latchr_comp, nor4, xor, latchr_comp, latchr_comp, nor4, latchr_comp, latchr_comp, latchr_comp, latchr_comp, nor4, nand3, xor, xor, latchr_comp, latchnq_comp, latchnq_comp, notif0, notif0, latchnq_comp, latchnq_comp, latchnq_comp, latchnq_comp, notif0, latchnq_comp, latchnq_comp|
|11|not, notif0, notif0, notif0, notif0, not4, not2, bufif0, notif0, bufif0, notif0, notif0, notif0, notif0, notif0, notif0, notif0, latch, latch, latch, not2, latch, not2, dffrnq_comp, notif0, not2, latchnq_comp, latchnq_comp, latchnq_comp, not, notif0, latchnq_comp, latchnq_comp, latchnq_comp, not, not, latchnq_comp, notif0, xor, xor, xor, xor, xor, xor, nor4, xor, xor, notif0, latchnq_comp, latchnq_comp, latchnq_comp, not, latchnq_comp, notif0, not, latchr_comp, latchr_comp, latchr_comp, latchr_comp, xor, xor, xor, xor, not, not, latchr_comp, xor, latchr_comp, xor, xor, xor, nor4, xor, xor, latchr_comp, xor, latchr_comp, notif0, notif0, notif0, notif0, notif0, latchnq_comp, notif0, notif0, notif0, notif0|