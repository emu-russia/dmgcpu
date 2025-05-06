# DMG-CPU LR35902 SoC

## Block Diagram

![cpu_block](/imgstore/soc/cpu_block.png) [^1]

[^1]: GAMEBOY Programming Manual: https://archive.org/details/GameBoyProgManVer1.1

Top-level layout of the entire SoC:

![dmgcpu_sm](/HDL/soc/design/dmgcpu_sm.png)

## Architecture Overview

After a long analysis, the impressions about the architectural solutions used in DMG-CPU can be expressed as follows:
- The topology has already been influenced by the [Mead-Conway revolution](https://en.wikipedia.org/wiki/Mead%E2%80%93Conway_VLSI_chip_design_revolution) - most of the elements are implemented as standard cells, but you can see that the developers have not forgotten the "manual method". Almost the whole SM83 core and macro-cells (embedded memory) and (naturally) DAC are made by "hand"
- Standard cells are arranged in domains, but they do not have a clear specialization (e.g. the APU contains logic for the serial port). In modern solutions, all standard cells are usually located in the giant "sea of cells". In this case we most likely have several small "pools". It is interesting that the [very first revision of DMG-CPU](https://siliconpr0n.org/map/nintendo/dmg-cpu/mcmaster_mz_mit20x/) has a slightly different domain organization
- The SoC has a rather "bushy" clock tree (it has not been fully explored yet). The SM83 core receives a pack of CLKs as input. Besides, CLK wiring uses both single-rail CLK and dual-rail CLK (CLK + its complement), so latch/dff have 2 variants
- As mentioned, both latch and dff are used for sequential logic. That is, the SoC uses asynchronous and synchronous approaches together. This makes the circuits rather "capricious" with respect to CLK frequency
- The internal buses are driven via tristate elements (notif/bufif) using old-school bus precharging technique for a specific CLK half-cycle. Modern solutions use special cells (Bus-keepers)
- The SM83 core is made with one layer of metal, the rest of the SoC uses two layers of metal. The SM83 core uses old-school domino logic on par with conventional CMOS logic
- Macro cells (memory) contain a small number of standard cells :-)
- These and other features make the DMG-CPU a rather curious "exhibit", but nonetheless interesting to study and dive into the history of a "previous, obviously more advanced civilization"

## Design Overview

TBD.

## Buses

This section contains a list of all internal buses. Tables of the other signals can be found in the corresponding sections.

| Name       | From        | Where To     | Description                          |
|------------|-------------|--------------|--------------------------------------|
| `a` [^2]   | PPU1, PPU2, HRAM, BootROM, MMIO, SM83Core, Arbiter, APU | PPU1, PPU2, HRAM, BootROM, MMIO, SM83Core, Arbiter, APU | Internal address bus (shared across modules) |
| `d`        | PPU1, PPU2, HRAM, BootROM, MMIO, SM83Core, Arbiter, APU, Ser, WaveRAM | PPU1, PPU2, HRAM, BootROM, MMIO, SM83Core, Arbiter, APU, Ser, WaveRAM | Internal data bus (shared across modules) |
| `n_ma`     | PPU1        | Pads         | External video memory address bus (inverse hold)          |
| `nma`      | PPU1, PPU2  | PPU1, PPU2   | Internal video memory address bus between PPUs (inverse hold)          |
| `md`       | PPU1, PPU2, Arbiter | PPU1, PPU2, Arbiter | Internal video memory data bus             |
| `oam_din`  | PPU2, Arbiter | PPU2, Arbiter | OAM data input bus                  |
| `wave_a`   | APU         | WaveRAM      | Wave RAM address bus                 |
| `wave_rd`  | WaveRAM     | APU          | Wave RAM data output bus             |
| `n_oamb`   | OAM         | OAM          | OAM A data bus (inverse hold)        |
| `n_oama`   | OAM         | OAM          | OAM B data bus (inverse hold)        |
| `dma_a`    | PPU2        | PPU2         | DMA address bus                      |

What does the letter `M` in the name of the PPU and VRAM buses stand for? I don't know... maybe Mario or Metroid? :smiley:

[^2]: The chip is topologically arranged so that the address bus arbitration is divided into three parts: in [arb](arb.md), in [mmio](mmio.md), and in [apu](apu.md), to equalize wire lengths.

## Revisions

TBD.