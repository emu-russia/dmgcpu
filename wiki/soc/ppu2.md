# PPU2

> [!WARNING]  
> The research has gained critical mass, the netlist is verified but not annotated. Signal table is missing. Further research is required.

![ppu2](/imgstore/soc/ppu2.jpg)

## Signals

![ppu2_ports](/imgstore/soc/ppu2_ports.png)

| Signal Name         | Direction | From / Where To             | Description |
|---------------------|-----------|-----------------------------|-------------|
| FF40_D1             | Input     |                             |  |
| FF40_D2             | Input     |                             |  |
| FF40_D3             | Input     |                             |  |
| \[7:0\] a           | Input     |                             |  |
| bp_cy               | Input     |                             |  |
| bp_sel              | Input     |                             |  |
| cclk                | Input     |                             |  |
| clk6                | Input     |                             |  |
| cpu_vram_oam_rd     | Input     |                             |  |
| \[12:0\] dma_a      | Input     |                             |  |
| dma_addr_ext        | Input     |                             |  |
| dma_run             | Input     |                             |  |
| fexx                | Input     |                             |  |
| ff42                | Input     |                             |  |
| ff43                | Input     |                             |  |
| \[7:0\] h           | Input     |                             |  |
| in_window           | Input     |                             |  |
| ma0                 | Input     |                             |  |
| n_dma_phi           | Input     |                             |  |
| n_dma_phi2_latched  | Input     |                             |  |
| n_ppu_reset         | Input     |                             |  |
| n_reset2            | Input     |                             |  |
| oam_addr_ck         | Input     |                             |  |
| \[7:0\] oam_din     | Input     |                             |  |
| oam_dma_wr          | Input     |                             |  |
| oam_mode3_bl_pch    | Input     |                             |  |
| oam_mode3_nrd       | Input     |                             |  |
| oam_rd_ck           | Input     |                             |  |
| oam_xattr_latch_cck | Input     |                             |  |
| obj_prio_ck         | Input     |                             |  |
| ppu_mode3           | Input     |                             |  |
| soc_rd              | Input     |                             |  |
| soc_wr              | Input     |                             |  |
| sp_bp_cys           | Input     |                             |  |
| tm_cy               | Input     |                             |  |
| \[7:0\] v           | Input     |                             |  |
| vbl                 | Input     |                             |  |
| vclk2               | Input     |                             |  |
| vram_to_oam         | Input     |                             |  |
| CONST0              | Bidir     | Global                      | Constant 0 signal [^2] |
| FF43_D0             | Output    |                             |  |
| FF43_D1             | Output    |                             |  |
| FF43_D2             | Output    |                             |  |
| clk6_delay          | Output    |                             |  |
| \[7:0\] d           | Bidir     |                             |  |
| h_restart           | Output    |                             |  |
| \[7:0\] md          | Bidir     |                             |  |
| n_oam_rd            | Output    |                             |  |
| \[7:0\] n_oama      | Bidir     |                             |  |
| n_oama_wr           | Output    |                             |  |
| \[7:0\] n_oamb      | Bidir     |                             |  |
| n_oamb_wr           | Output    |                             |  |
| n_ppu_clk           | Output    |                             |  |
| n_ppu_hard_reset    | Output    |                             |  |
| \[12:0\] nma        | Bidir     |                             |  |
| \[7:1\] oa          | Output    |                             |  |
| oam_bl_pch          | Output    |                             |  |
| n_vram_to_oam       | Output    |                             |  |
| obj_color           | Output    |                             |  |
| obj_prio            | Output    |                             |  |
| ppu_clk             | Output    |                             |  |
| ppu_mode2           | Output    |                             |  |
| ppu_rd              | Output    |                             |  |
| ppu_wr              | Output    |                             |  |
| sprite_x_flip       | Output    |                             |  |
| sprite_x_match      | Output    |                             |  |
| stop_oam_eval       | Output    |                             |  |

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