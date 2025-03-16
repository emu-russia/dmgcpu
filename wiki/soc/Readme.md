# DMG-CPU LR35902 SoC

Top-level layout of the entire SoC:

![dmgcpu_sm](/HDL/soc/design/dmgcpu_sm.png)

## SoC Architecture Overview

After a long analysis, the impressions about the architectural solutions used in DMG-CPU can be expressed as follows:
- The topology has already been influenced by the [Mead-Conway revolution](https://en.wikipedia.org/wiki/Mead%E2%80%93Conway_VLSI_chip_design_revolution) - most of the elements are implemented as standard cells, but you can see that the developers have not forgotten the "manual method". Almost the whole SM83 core and macro-cells (embedded memory) and (naturally) DAC are made by "hand"
- Standard cells are arranged in domains, but they do not have a clear specialization (e.g. the APU contains logic for the serial port). In modern solutions, all standard cells are usually located in the giant "sea of cells". In this case we most likely have several small "pools". It is interesting that the [very first revision of DMG-CPU](https://siliconpr0n.org/map/nintendo/dmg-cpu/mcmaster_mz_mit20x/) has a slightly different domain organization
- The SoC has a rather "bushy" clock tree (it has not been fully explored yet). The SM83 core receives a pack of CLKs as input. Besides, CLK wiring uses both single-rail CLK and dual-rail CLK (CLK + its complement), so latch/dff have 2 variants
- As mentioned, both latch and dff are used for sequential logic. That is, the SoC uses asynchronous and synchronous approaches together. This makes the circuits rather "capricious" with respect to CLK frequency
- The internal buses are driven via tristate elements (notif/bufif) using old-school bus precharging technique for a specific CLK half-cycle. Modern solutions use special cells (Bus-keepers)
- The SM83 core is made with one layer of metal, the rest of the SoC uses two layers of metal. The SM83 core uses old-school domino logic on par with conventional CMOS logic
- Macro cells (memory) contain a small number of standard cells :-)
- These and other features make the DMG-CPU a rather curious "exhibit", but nonetheless interesting to study and dive into the history of a "previous, obviously more advanced civilization"

## Signals

:warning: Generated in DeepSeek and requires refinement. Prompt:

Analyze the Verilog source that I will give you and make clear tables of signals, dividing signals into groups (buses, signals working with registers ffxx and similar, separate groups of signals like n_lcd_xxx). Column “signal direction” should be made by analyzing the second part of the text, where I describe the modules partially. The table should contain columns: Name, From, Where to, Description (signal name, from which module, to which module, description). The table should be made in English and in Markdown format. For the name of a group of signals you can use a whole line of the table, and the name of the group should be bolded. If the signal is a bus (inout), then all consumers should be specified in the From and Where To columns.
Follows by: `dmgcpu.v` + other .v modules.

---

### **Address and Data Buses**
| Name       | From        | Where To     | Description                          |
|------------|-------------|--------------|--------------------------------------|
| `a`        | PPU1, PPU2, HRAM, BootROM, MMIO, SM83Core, Arbiter, APU | PPU1, PPU2, HRAM, BootROM, MMIO, SM83Core, Arbiter, APU | Address bus (shared across modules) |
| `d`        | PPU1, PPU2, HRAM, BootROM, MMIO, SM83Core, Arbiter, APU, Ser, WaveRAM | PPU1, PPU2, HRAM, BootROM, MMIO, SM83Core, Arbiter, APU, Ser, WaveRAM | Data bus (shared across modules) |
| `n_ma`     | PPU1        | PPU1         | Inverted memory address bus          |
| `nma`      | PPU1, PPU2  | PPU1, PPU2   | Inverted memory address bus          |
| `md`       | PPU1, PPU2, Arbiter | PPU1, PPU2, Arbiter | Memory data bus                     |
| `oam_din`  | PPU2, Arbiter | PPU2, Arbiter | OAM data input bus                  |
| `wave_rd`  | WaveRAM     | APU          | Wave RAM data output bus             |

---

### **Control Signals**
| Name               | From        | Where To     | Description                          |
|--------------------|-------------|--------------|--------------------------------------|
| `n_reset2`         | ClkGen      | PPU1, PPU2, OAM, HRAM, Ser, MMIO, SM83Core, Arbiter, APU | Inverted reset signal               |
| `ppu_rd`           | PPU1, PPU2  | PPU1, PPU2   | PPU read signal                      |
| `ppu_wr`           | PPU1, PPU2  | PPU1, PPU2   | PPU write signal                     |
| `ppu_clk`          | PPU1, PPU2  | PPU1, PPU2   | PPU clock signal                     |
| `n_ppu_hard_reset` | PPU1, PPU2  | PPU1, PPU2   | Inverted hard reset signal for PPU   |
| `n_dma_phi`        | PPU1, PPU2  | PPU1, PPU2   | Inverted DMA phase signal            |
| `dma_run`          | PPU2        | PPU2         | DMA run signal                       |
| `soc_wr`           | PPU2, MMIO  | PPU2, MMIO   | SOC write signal                     |
| `soc_rd`           | PPU2, MMIO  | PPU2, MMIO   | SOC read signal                      |
| `n_oam_rd`         | OAM         | OAM          | Inverted OAM read signal             |
| `n_oamb_wr`        | OAM         | OAM          | Inverted OAM write signal            |
| `n_oama_wr`        | OAM         | OAM          | Inverted OAM address write signal    |
| `n_wave_wr`        | APU         | WaveRAM      | Inverted Wave RAM write signal       |
| `n_wave_rd`        | APU         | WaveRAM      | Inverted Wave RAM read signal        |

---

### **LCD Signals**
| Name           | From        | Where To     | Description                          |
|----------------|-------------|--------------|--------------------------------------|
| `n_lcd_ld1`    | PPU1        | PPU1         | Inverted LCD load signal 1           |
| `n_lcd_ld0`    | PPU1        | PPU1         | Inverted LCD load signal 0           |
| `n_lcd_cpg`    | PPU1        | PPU1         | Inverted LCD CPG signal              |
| `n_lcd_cp`     | PPU1        | PPU1         | Inverted LCD CP signal               |
| `n_lcd_st`     | PPU1        | PPU1         | Inverted LCD ST signal               |
| `n_lcd_cpl`    | PPU1        | PPU1         | Inverted LCD CPL signal              |
| `n_lcd_fr`     | PPU1        | PPU1         | Inverted LCD FR signal               |
| `n_lcd_s`      | PPU1        | PPU1         | Inverted LCD S signal                |

---

### **Register Signals (ffxx)**
| Name       | From        | Where To     | Description                          |
|------------|-------------|--------------|--------------------------------------|
| `ffxx`     | PPU1, PPU2, HRAM, MMIO | PPU1, PPU2, HRAM, MMIO | Register signal ffxx                |
| `ff43`     | PPU1        | PPU1         | Register signal ff43                |
| `ff42`     | PPU1        | PPU1         | Register signal ff42                |
| `ff46`     | PPU1        | PPU1         | Register signal ff46                |
| `FF40_D1`  | PPU1        | PPU1         | Register signal FF40 (bit 1)        |
| `FF40_D2`  | PPU1        | PPU1         | Register signal FF40 (bit 2)        |
| `FF40_D3`  | PPU1        | PPU1         | Register signal FF40 (bit 3)        |
| `FF43_D1`  | PPU1        | PPU1         | Register signal FF43 (bit 1)        |
| `FF43_D0`  | PPU1        | PPU1         | Register signal FF43 (bit 0)        |
| `FF43_D2`  | PPU1        | PPU1         | Register signal FF43 (bit 2)        |

---

### **OAM Signals**
| Name               | From        | Where To     | Description                          |
|--------------------|-------------|--------------|--------------------------------------|
| `n_oamb`           | OAM         | OAM          | Inverted OAM data bus                |
| `n_oama`           | OAM         | OAM          | Inverted OAM address bus             |
| `oam_bl_pch`       | OAM         | OAM          | OAM bitline precharge signal         |
| `oam_rd_ck`        | PPU1        | PPU1         | OAM read clock signal                |
| `oam_xattr_latch_cck` | PPU1    | PPU1         | OAM attribute latch clock signal     |
| `oam_addr_ck`      | PPU1        | PPU1         | OAM address clock signal             |

---

### **DMA Signals**
| Name               | From        | Where To     | Description                          |
|--------------------|-------------|--------------|--------------------------------------|
| `dma_a`            | PPU2        | PPU2         | DMA address bus                      |
| `dma_run`          | PPU2        | PPU2         | DMA run signal                       |
| `n_dma_phi`        | PPU1, PPU2  | PPU1, PPU2   | Inverted DMA phase signal            |
| `n_dma_phi2_latched` | PPU1    | PPU1         | Latched inverted DMA phase signal    |

---

### **Wave RAM Signals**
| Name       | From        | Where To     | Description                          |
|------------|-------------|--------------|--------------------------------------|
| `wave_a`   | APU         | WaveRAM      | Wave RAM address bus                 |
| `wave_rd`  | WaveRAM     | APU          | Wave RAM data output bus             |
| `n_wave_wr`| APU         | WaveRAM      | Inverted Wave RAM write signal       |
| `n_wave_rd`| APU         | WaveRAM      | Inverted Wave RAM read signal        |

---

### **PPU Signals**
| Name               | From        | Where To     | Description                          |
|--------------------|-------------|--------------|--------------------------------------|
| `ppu_mode3`        | PPU1        | PPU1         | PPU mode 3 signal                    |
| `ppu_mode2`        | PPU1        | PPU1         | PPU mode 2 signal                    |
| `vbl`              | PPU1        | PPU1         | Vertical blanking signal             |
| `stop_oam_eval`    | PPU1        | PPU1         | Stop OAM evaluation signal           |
| `obj_color`        | PPU1        | PPU1         | Object color signal                  |
| `vclk2`            | PPU1        | PPU1         | PPU clock signal                     |
| `obj_prio_ck`      | PPU1        | PPU1         | Object priority clock signal         |
| `obj_prio`         | PPU1        | PPU1         | Object priority signal               |

---

### **APU Signals**
| Name               | From        | Where To     | Description                          |
|--------------------|-------------|--------------|--------------------------------------|
| `ch1_out`          | APU         | DAC          | Channel 1 output signal              |
| `ch2_out`          | APU         | DAC          | Channel 2 output signal              |
| `ch3_out`          | APU         | DAC          | Channel 3 output signal              |
| `ch4_out`          | APU         | DAC          | Channel 4 output signal              |
| `r_vin_en`         | APU         | DAC          | Right channel enable signal          |
| `l_vin_en`         | APU         | DAC          | Left channel enable signal           |
