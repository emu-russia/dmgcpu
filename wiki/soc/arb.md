# Arbiter

> [!WARNING]  
> The section is under development and requires refinement, the schematics have not been verified in the simulator, but the study has gained "critical mass"

![locator_arb](/imgstore/soc/locator_arb.jpg)

|![arb](/imgstore/soc/arb.jpg)|![arb_netlist](/imgstore/soc/arb_netlist.png)|
|---|---|

The module is a classic bus arbiter, which can often be found in older chips. It is responsible for connecting external and internal buses to each other, in various combinations.
It also contains a piece of arbitration for `a[15]`. [^1] 

To familiarize yourself with the architecture, it's best to crawl through the annotated design, everything is quite obvious there. Sys Decode (address space decoder) parts, which are included in this module and output a number of signals for other parts of the chip, look a bit complicated. And the combo circuits for forming `/CS`, `/MCS`, `/MWR` and `/MRD` are of course also complicated (a lot of non-obvious signals form the combinatorial tree).

[^1]: The chip is topologically arranged so that the address bus arbitration is divided into three parts: in [arb](arb.md), in [mmio](mmio.md), and in [apu](apu.md), to equalize wire lengths.

### Signal Table

:warning: The signal table is derived from DeepSeek and likely requires human refinement.

| Signal Name          | Direction | From / Where To      | Description                                                                 |
|----------------------|-----------|----------------------|-----------------------------------------------------------------------------|
| `clk2`               | Input     |                      | Clock signal for the module (is used for Internal DB Precharge)            |
| `n_reset2`           | Input     |                      | Global Active-low reset signal.                                            |
| `cpu_mreq`           | Input     |                      | CPU memory request signal.                                                 |
| `ext_cs_en`          | Input     |                      | External chip select enable signal.                                         |
| `cpu_wr_sync`        | Input     |                      | Synchronized CPU write signal.                                              |
| `a`                  | Bidir     |                      | Address bus (16-bit). `a[15]` is bidirectional, `a[14:0]` are inputs.       |
| `d`                  | Bidir     |                      | Internal Data bus (8-bit).                                                  |
| `cpu_wr`             | Input     |                      | CPU write signal.                                                           |
| `mmio_sel`           | Output    |                      | Memory-mapped I/O select signal.                                            |
| `boot_sel`           | Output    |                      | Boot select signal.                                                         |
| `n_DRV_HIGH_a15`     | Output    |                      | Active-low drive high signal for `a[15]`.                                   |
| `n_INPUT_a15`        | Input     |                      | Active-low input signal for `a[15]`.                                        |
| `DRV_LOW_a15`        | Output    |                      | Drive low signal for `a[15]`.                                               |
| `n_cs_topad`         | Output    |                      | Active-low chip select to pad signal.                                       |
| `CONST0`             | Output    |                      | Constant 0 signal.                                                          |
| `n_DRV_HIGH_nmwr`    | Output    |                      | Active-low drive high signal for `n_mwr`.                                   |
| `n_mwr`              | Input     |                      | Active-low memory write signal.                                             |
| `DRV_LOW_nmwr`       | Output    |                      | Drive low signal for `n_mwr`.                                               |
| `n_DRV_HIGH_nmrd`    | Output    |                      | Active-low drive high signal for `n_mrd`.                                   |
| `n_mrd`              | Input     |                      | Active-low memory read signal.                                              |
| `DRV_LOW_nmrd`       | Output    |                      | Drive low signal for `n_mrd`.                                               |
| `n_DRV_HIGH_nmcs`    | Output    |                      | Active-low drive high signal for `n_mcs`.                                   |
| `n_mcs`              | Input     |                      | Active-low memory chip select signal.                                       |
| `DRV_LOW_nmcs`       | Output    |                      | Drive low signal for `n_mcs`.                                               |
| `n_DRV_HIGH_md`      | Output    |                      | Active-low drive high signal for `md` (8-bit).                              |
| `n_md_frompad`       | Input     |                      | Active-low `md` input from pad (8-bit).                                     |
| `DRV_LOW_md`         | Output    |                      | Drive low signal for `md` (8-bit).                                          |
| `n_md_ena_pu`        | Output    |                      | Active-low `md` enable pull-up signal.                                      |
| `n_DRV_HIGH_d`       | Output    |                      | Active-low drive high signal for `d` (8-bit).                               |
| `n_db_frompad`       | Input     |                      | Active-low data bus input from pad (8-bit).                                 |
| `DRV_LOW_d`          | Output    |                      | Drive low signal for `d` (8-bit).                                           |
| `n_ena_pu_db`        | Input     |                      | Active-low enable pull-up signal for data bus.                              |
| `soc_wr`             | Input     |                      | System-on-Chip write signal.                                                |
| `soc_rd`             | Input     |                      | System-on-Chip read signal.                                                 |
| `vram_to_oam`        | Input     |                      | VRAM to OAM transfer signal.                                                |
| `dma_a_15`           | Input     |                      | DMA address bit 15 signal.                                                  |
| `non_vram_mreq`      | Output    |                      | Non-VRAM memory request signal.                                             |
| `test_1`             | Input     |                      | Test signal 1.                                                              |
| `n_extdb_to_intdb`   | Input     |                      | Active-low external data bus to internal data bus signal.                   |
| `n_dblatch_to_intdb` | Input     |                      | Active-low data bus latch to internal data bus signal.                      |
| `n_intdb_to_extdb`   | Input     |                      | Active-low internal data bus to external data bus signal.                   |
| `ffxx`               | Output    |                      | Signal indicating access to memory range `FFxx`.                            |
| `n_ppu_hard_reset`   | Input     |                      | Active-low PPU hard reset signal.                                           |
| `ppu_mode3`          | Input     |                      | PPU mode 3 signal.                                                         |
| `md`                 | Bidir     |                      | Internal MD bus (8-bit).                                                    |
| `oam_din`            | Output    |                      | OAM data input (8-bit).                                                     |
| `oam_to_vram`        | Input     |                      | OAM to VRAM transfer signal.                                                |
| `dma_addr_ext`       | Input     |                      | DMA external address signal.                                                |
| `sp_bp_cys`          | Input     |                      | Sprite buffer page cycle signal.        (?)                                 |
| `tm_bp_cys`          | Input     |                      | Tile map buffer page cycle signal.      (?)                                 |
| `n_sp_bp_mrd`        | Input     |                      | Active-low sprite buffer page memory read signal. (?)                       |
| `n_tm_bp_cys`        | Input     |                      | Active-low tile map buffer page cycle signal.         (?)                   |
| `arb_fexx_ffxx`      | Output    |                      | Arbitration signal for memory ranges `FExx` and `FFxx`.                     |
| `cpu_vram_oam_rd`    | Input     |                      | CPU VRAM/OAM read signal.                                                   |

## Annotated Design

![arb_annotated](/HDL/soc/design/arb_annotated.png)

## Entites

- Int DB Precharge: controls the Int DB bus precharge
- Int DB -> Ext DB Driver: connects Int DB to Ext DB
- Ext DB -> Int DB Latch + tris: memorizes the Ext DB value on the latch (DB Latch)
- VRAM Test Mode Check: generates the VRAM Test Mode signal (when VRAM is controlled externally)
- Sys Decode (part): Sys Decode chunks
- Ext A15 -> Int A15 tris: piece of address bus arbitration
- Int A15 -> Ext A15 Driver: piece of address bus arbitration
- /CS Logic
- /MCS Logic
- /MRD Logic
- /MWR Logic
- Ext DB -> Int DB Latch + tris: connects Ext DB to Int DB
- Ext DB -> OAM DataIn DLatch: outputs a value from Ext DB for OAM DataIn
- MD Bus Setup: generates MD bus control signals
- Ext MD -> Int MD tris: connects Ext MD to Int MD
- Int MD -> Ext MD Driver: connects Int MD to Ext MD
- Int MD -> Int DB tris: connects Int MD to Int DB
- Int DB -> Int MD tris: connects Int DB to Int MD
- $FF50 BANK Reg: well-known register to disable mapping of the built-in BootROM (write 1 only)