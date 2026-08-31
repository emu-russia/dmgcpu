# PPU1

> [!WARNING]  
> The research has gained critical mass, the netlist is verified but not annotated. The signal table is filled based on the netlist, but the descriptions require human verification. Further research is required.

![ppu1](/imgstore/soc/ppu1.jpg)

## Signals

![ppu1_ports](/imgstore/soc/ppu1_ports.png)

| Signal Name            | Direction | From / Where To             | Description |
|------------------------|-----------|-----------------------------|-------------|
| CONST0                 | Bidir     | Global                      | Constant 0 signal [^2] |
| FF43_D0                | Input     | From PPU2                   | SCY register ($FF43) bit 0 (window vertical scroll) |
| FF43_D1                | Input     | From PPU2                   | SCY register ($FF43) bit 1 |
| FF43_D2                | Input     | From PPU2                   | SCY register ($FF43) bit 2 |
| \[12:0\] a             | Input     | From Core                   | Internal address bus (VRAM access, 13 bits) |
| arb_fexx_ffxx          | Input     | From Arb                    | Arbitration of FExx (VRAM/OAM) vs FFxx (registers) accesses |
| \[7:0\] d              | Bidir     | Global                      | Internal data bus |
| ffxx                   | Input     | From Arb                    | FFxx register area indicator |
| h_restart              | Input     | From PPU2                   | H counter restart |
| \[7:0\] md             | Bidir     | Global                      | Internal video memory data bus (VRAM) |
| n_dma_phi              | Input     | From MMIO                   | DMA clock (inverted) |
| n_ppu_clk              | Input     | From PPU2                   | PPU clock (inverted) |
| n_ppu_hard_reset       | Input     | From PPU2                   | PPU hard reset (active low) |
| \[12:0\] nma           | Bidir     | Global                      | Internal video memory address bus between PPUs (inverse hold) |
| obj_color              | Input     | From PPU2                   | Object color |
| obj_prio               | Input     | From PPU2                   | Object priority |
| ppu_clk                | Input     | From PPU2                   | PPU clock |
| ppu_mode2              | Input     | From PPU2                   | PPU Mode 2 (OAM scan) indicator |
| ppu_rd                 | Input     | From PPU2                   | PPU read strobe |
| ppu_wr                 | Input     | From PPU2                   | PPU write strobe |
| sprite_x_flip          | Input     | From PPU2                   | Sprite X flip |
| sprite_x_match         | Input     | From PPU2                   | Sprite X match |
| stop_oam_eval          | Input     | From PPU2                   | Stop OAM evaluation |
| vram_to_oam            | Input     | From MMIO                   | VRAM to OAM transfer enable (DMA) |
| FF40_D1                | Output    | To PPU2                     | LCDC register ($FF40) bit 1 (OBJ enable) |
| FF40_D2                | Output    | To PPU2                     | LCDC register ($FF40) bit 2 (OBJ size) |
| FF40_D3                | Output    | To PPU2                     | LCDC register ($FF40) bit 3 (BG tile map select) |
| bp_cy                  | Output    | To PPU2                     | Buffer page cycle |
| bp_sel                 | Output    | To PPU2                     | Buffer page select |
| fexx                   | Output    | To PPU2                     | FExx register area indicator (VRAM/OAM) |
| ff42                   | Output    | To PPU2                     | SCX register ($FF42) access indicator |
| ff43                   | Output    | To PPU2                     | SCY register ($FF43) access indicator |
| ff46                   | Output    | To MMIO                     | DMA register ($FF46) access indicator |
| \[7:0\] h              | Output    | To PPU2                     | H counter (LX) value |
| in_window              | Output    | To PPU2                     | In-window indicator |
| n_dma_phi2_latched     | Output    | To PPU2                     | Latched inverted DMA clock 2 |
| n_lcd_cp               | Output    | To CP Pad                   | LCD driver signal CP (inverted) |
| n_lcd_cpg              | Output    | To CPG Pad                  | LCD driver signal CPG (inverted) |
| n_lcd_cpl              | Output    | To CPL Pad                  | LCD driver signal CPL (inverted) |
| n_lcd_fr               | Output    | To FR Pad                   | LCD driver signal FR (inverted) |
| n_lcd_ld0              | Output    | To LD0 Pad                  | LCD driver data LD0 (inverted) |
| n_lcd_ld1              | Output    | To LD1 Pad                  | LCD driver data LD1 (inverted) |
| n_lcd_s                | Output    | To S Pad                    | LCD driver signal S (inverted) |
| n_lcd_st               | Output    | To ST Pad                   | LCD driver signal ST (inverted) |
| \[12:0\] n_ma          | Output    | To Pads                     | External video memory address bus (inverse hold) |
| n_ppu_reset            | Output    | To PPU2                     | PPU reset (active low) |
| n_sp_bp_mrd            | Output    | To Arb                      | Sprite buffer page memory read (active low) |
| n_tm_bp_cys            | Output    | To Arb                      | Tile map buffer page cycle (active low) |
| oam_addr_ck            | Output    | To PPU2                     | OAM address clock |
| oam_mode3_bl_pch       | Output    | To PPU2                     | OAM bitline precharge during MODE3 |
| oam_mode3_nrd          | Output    | To PPU2                     | OAM read during MODE3 (active low) |
| oam_rd_ck              | Output    | To PPU2                     | OAM read clock |
| oam_xattr_latch_cck    | Output    | To PPU2                     | OAM X attribute latch clock |
| obj_prio_ck            | Output    | To PPU2                     | Object priority clock |
| ppu_int_stat           | Output    | To MMIO                     | PPU STAT interrupt request |
| ppu_int_vbl            | Output    | To MMIO                     | PPU VBLANK interrupt request |
| ppu_mode3              | Output    | To PPU2, Arb                | PPU Mode 3 (pixel transfer) indicator |
| ppu1_ma0               | Output    | To PPU2                     | VRAM address bit 0 (MA0) |
| sp_bp_cys              | Output    | To PPU2, Arb                | Sprite buffer page cycle |
| tm_bp_cys              | Output    | To Arb                      | Tile map buffer page cycle |
| tm_cy                  | Output    | To PPU2                     | Tile map cycle |
| \[7:0\] v              | Output    | To PPU2                     | V counter (LY) value |
| vbl                    | Output    | To PPU2                     | VBLANK indicator |
| vclk2                  | Output    | To PPU2                     | VRAM clock 2 |

[^2]: The constant 0 is globally scattered throughout the chip. Each large module with cells has a `const` cell whose output 0 is globally connected between all modules (so the input is marked as Bidir).

## Netlist

![ppu1_netlist](/imgstore/soc/ppu1_netlist.png)

## Annotated Design

TBD.

![ppu1](/HDL/soc/design/ppu1.png)

## Map

|Row|Cells|
|---|---|
|1|nand, not, not, not, nand, not2, latch_comp, not2, not, not, nand, nand, not2, latch_comp, not, nand, nand, not, nand_latch, not2, and, not2, nand, not, nand, dffr, dffr, not, not, nand, dffr, not, not, not2, not, not2, not2, not2, not, not, not, notif0, latchnq_comp, notif0, notif0, notif0, latchnq_comp, notif0, latchnq_comp, notif0, latchnq_comp, notif0, notif0, notif0, latchnq_comp, latchnq_comp, notif0, not2, notif0, not2, not2, notif0, not2, dffr, dffr, dffr, dffr, dffr, not, nor, not, notif0, nand, notif0, notif0, notif0, not, nand, dffsr, notif0, not, nand, nand, not, dffr, not, dffr, not, not, not, nand, nand, not, nand, nand, dffsr, dffsr, not, not, not, not, nand, and3, not, not, and3, not, not, and3, and3|
|2|not, nand, nand, dffsr, latch_comp, dffsr, latch_comp, dffsr, latch_comp, dffsr, nand3, not, dffr, nor3, and, not, not, not, not, not, and, and, not2, not, latchnq_comp, latchnq_comp, not, not, notif0, notif0, not, notif0, latchr_comp, latchr_comp, xnor, not, latchr_comp, notif0, notif0, latchr_comp, not, latchr_comp, notif0, not, notif0, not, latchr_comp, dffr, dffr, notif0, dffr, dffr, dffr, latchnq_comp, latchnq_comp, latchnq_comp, latchnq_comp, latchnq_comp, nand, dffsr, nor, xor, latch_comp, latch_comp, nand, nand, or3, aon2222, not, aon2222, nand, dffsr, nand, nand, or3, nand, nand, or3, not, not, not3, not3|
|3|nand, not, nand, dffsr, latch_comp, dffsr, nand, not, nand, dffsr, nand, nand, not, latch_comp, latch_comp, dffr, not, nand3, not, nand, not, and, dffr, nor, nor3, not, dffr, dffr, not, and, dffr, latchr_comp, xnor, xnor, latchr_comp, xnor, not, not, nand5, xnor, latchr_comp, latchr_comp, xnor, latchr_comp, xnor, latchr_comp, nor8, not, and4, xnor, latchr_comp, latchr_comp, latchr_comp, xnor, not, latchr_comp, dffr, dffr, latchnq_comp, dffsr, not, aon2222, aon2222, dffsr, dffsr, and3, and3, not, not, and3, not, not, nor, dffsr, not2|
|4|dffsr, dffr_comp, dffr_comp, dffr_comp, dffr_comp, dffr_comp, dffr_comp, dffr_comp, mux, mux, mux, mux, mux, and, mux, mux, mux, nor_latch, dffr, nor_latch, and, nor, not, dffr, not2, not, dffr, nor, nand, nor, xnor, nand5, xnor, not, dffr, xnor, dffr, notif0, notif0, xnor, notif0, nor, xnor, nand5, nand5, xnor, xnor, notif0, notif0, notif0, or, not, not, notif0, notif0, notif0, not, not, dffr, nor3, notif0, latchnq_comp, nand, latchnq_comp, latch_comp, not, not, latch_comp, latch_comp, and3, nand, not3, dffsr, nand, nand, or3, or3, nand, dffsr, nand, dffsr, not2, not2, not2|
|5|not, notif0, notif0, notif0, notif0, not, nand, nand, notif1, nand, dffsr, nand, not, nand, nand, nand, dffsr, not, dffr_comp, notif0, not, nand, not, notif1, notif1, and, dffr, and, not, dffr, not, nor_latch, not, not3, dffr, nand4, dffr, nand3, nor3, dffr, xor, not, not, or, nor_latch, xor, notif0, notif0, xor, not, notif0, notif0, latchr_comp, or3, xor, xor, and, not, nand, not, and, not, not, latchr_comp, latchr_comp, latchr_comp, latchr_comp, nor_latch, dffr, and, latch_comp, notif0, latch_comp, not, notif0, not, latch_comp, latch_comp, latch_comp, dffr, nand, or, nand, not, dffsr, not, nand, nand, or3, dffsr, nand, nand, not, not3, not2, not2|
|6|and, dffsr, nand, nand, dffsr, nand, not, dffsr, dffsr, nand, nand, notif1, notif1, nand, not, nand, nand, dffr, not, dffr, nor, nand4, not, not2, not, not2, nor3, not4, or, or, not, dffr, xnor, xnor, xnor, dffr, and, xor, dffr, dffr, latchr_comp, latchr_comp, latchr_comp, latchr_comp, nand, nor4, xor, nor4, and, dffr, aon2222, nor, nor3, notif0, notif1, not, nor, latch_comp, latch_comp, not, latch_comp, not, latch_comp, not, not, not, latch_comp, latch_comp, not, dffr, not2, dffr, not, not, nand, nand, dffsr, dffr, and4, not, nand, dffsr|
|7|dffr, dffr, not, dffr, dffr, dffr, dffsr, not2, notif1, nand, not, dffsr, nand_latch, and4, not, not2, not, not, or3, and, and3, dffr, and, not, nand, and, nor, not, not, dffr, dffr, dffr, xor, and, nand3, dffr, dffr, dffr, not, xor, nand, nor3, xor, xor, xor, dffr, and, not, and, not, not, nand, nand, notif1, not4, not, or, not, nand, nand, and, nand, nand, or3, nand, nand, nand, not, not, nand, nand, not2, not, not2, not, nand, nand, dffr, dffr, not, nand, nand, dffr, dffr, not, not, nand7, nand4, nand7, not, not, nand7, nand|
|8|not3, not3, notif0, notif0, dffr, notif1, notif0, notif0, dffr, dffr, notif0, notif0, const, and, notif1, notif0, notif0, nor, notif1, nand5, not, not2, not2, not2, not2, nor, dffr, nor3, dffr, and, not, notif0, latchr_comp, notif0, and, not, notif0, not, not, not, not, not, and, and, notif0, notif0, notif0, or, notif0, notif0, not, latchr_comp, latchr_comp, latchr_comp, dffr, dffsr, dffsr, dffsr, nand, not, dffsr, nand, dffsr, or3, nand, dffsr, dffsr, nand, or3, not, dffsr, dffr, and3, and3, and3, not, nand7, not, not, and3, not, not, not|
|9|dffr, dffr, dffr, dffr, not, notif0, notif0, notif0, notif0, not2, nand3, not, not2, nand5, not, nand5, nand5, nand5, nand5, nand5, nand5, nand5, nand5, not, not, nand5, nand5, or, and, and, nor_latch, and, latchr_comp, notif0, latchr_comp, not, and, latchr_comp, and, and, not2, notif0, notif0, not2, and, not, not, not, notif0, not2, not2, notif0, notif0, notif0, nor_latch, notif0, and, not, dffr, nor, dffr, dffsr, nand, notif1, nand, nand, not, dffsr, or3, not, and, dffsr, not, dffsr, dffsr, nand, not, nand, dffsr, aon2222, aon2222, not, not, nand, not, dffsr, nand, not|
|10|dffr, not2, notif0, notif0, notif0, nor, not2, notif0, notif0, notif0, notif0, not, nand, notif0, not, notif0, and, notif0, notif0, nor3, not, notif0, notif0, not, and, not, not2, not2, not, not2, dffr, not2, dffr, not2, not, not, nor_latch, and, not, not, xor, not, nand3, not, notif0, latchr_comp, notif0, latchr_comp, latchr_comp, latchr_comp, not, nand5, and, not2, and, and, xor, dffr, not2, and, not, not, not, not, and, not, not, not, not2, not2, not, and, not, dffr, nand, not, not, latchr_comp, not2, not, nor, not, not, not, nand, nand, not2, and, and, not, not, nand, not, not, and, notif0, latchnq_comp, notif0, latchnq_comp, nand, notif0, latchnq_comp, notif0, latchnq_comp, notif0, latchnq_comp, not, nand, notif0, latchnq_comp, not, notif0, latchnq_comp, not, latchnq_comp, notif0, nand, not, nand, nand, dffsr, not, not|