# PPU Icarus/GTKWave testbench (issue #390)

Regression testbench for the DMG-CPU PPU gate netlists (`HDL/soc/ppu1.v`,
`HDL/soc/ppu2.v`) run with Icarus Verilog + GTKWave.

## Files

| File | Purpose |
|------|---------|
| `ppu_env.v` | Reusable PPU test environment: real `ClkGen` + `PPU1` + `PPU2` netlists, behavioral OAM RAM and VRAM models, and a small "CPU+MMIO+Arb" stand-in with register read/write tasks. The pads between the CPU die and the VRAM die are modeled (MA inversion, /MCS//MRD//MWR, MD bus). |
| `ppu1_merged.v`, `ppu2_merged.v` | The PPU netlists with the bidirectional-bus alias `assign`s merged into real net aliases (see `merge_bus_aliases.py`). Without this Icarus cannot simulate register writes: the internal bus wires never see the CPU data. Regenerate with `python3 merge_bus_aliases.py ../../ppu1.v ppu1_merged.v` and `python3 merge_bus_aliases.py ../../ppu2.v ppu2_merged.v` from this directory. |
| `merge_bus_aliases.py` | Tool: rewrites `assign d[7] = w79;` style aliases (inout bus bits) into true net aliases by renaming `w79` → `d[7]` and deleting the alias + orphaned wire declarations. Only touches `d/md/nma/n_oama/n_oamb`. |
| `tb_ppu_regs.v` | Register write/read + reset + counter/mode smoke test. |
| `tb_ppu_bg_scanline.v` | BG rendering test: mode2/3 per-line rhythm, VRAM BG fetch, pixel serialization on LD0/LD1. |
| `tb_ppu_scroll.v` | SCY/SCX scroll test: PPU2 V+SCY / H+SCX adders change the fetched tile-map row/column. |
| `tb_ppu_window.v` | Window (WIN) test: with LCDC.6 the tile-map fetches switch to the $9C00 window map. |
| `tb_ppu_sprites.v` | (dev) mode-2 OAM scan bring-up - see waves.md. |
| `tb_ppu_oam_cpu.v` | (dev) CPU->OAM write path bring-up - see waves.md. |
| `*.bat` | Windows compile & run wrappers. `run_all.bat` runs every test. |
| `waves/` | Waveform images, one per test. |
| `waves.md` | Documentation of the tests with embedded wave images. |

## Notes

- `HDL/soc/dmglib.v` needed one bug fix for simulation: `dmg_notif0/1`
  (inverting tristates on the precharged "inverse-hold" buses) were written as
  `x = ~x` (a self-referential combinational loop that never drives the bus);
  the correct inverting-tristate body is `x = ~a` while enabled.
- The PPU CPU interface uses **true-value** data on the `d` bus: read-back
  drivers are `notif0` fed from the register latches' `nq`, so the wire gets
  the register value; register latches capture the wire value directly.
- Write strobes: PPU2 decodes the CPU access (soc_wr + address + ffxx) and
  produces `ppu_rd`/`ppu_wr`, which gate PPU1's register latches. The CPU
  model keeps data valid ~8 ns after the strobe falls (real bus hold time),
  otherwise the level-sensitive register latches race the bus precharge.
