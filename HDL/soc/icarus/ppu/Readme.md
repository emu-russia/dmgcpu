# PPU Icarus/GTKWave testbench (issue #390)

Regression testbench for the DMG-CPU PPU gate netlists (`HDL/soc/ppu1.v`,
`HDL/soc/ppu2.v`) run with Icarus Verilog + GTKWave.

## Files

| File | Purpose |
|------|---------|
| `ppu_env.v` | Reusable PPU test environment: real `ClkGen` + `PPU1` + `PPU2` netlists, behavioral VRAM + OAM models and a small "CPU+MMIO+Arb" stand-in with register read/write tasks. The pads between the CPU die and the VRAM die are modeled (MA inversion, /MCS//MRD//MWR, MD bus). |
| `oam_ram.v` | Behavioral OAM SRAM model (interface of the empty `HDL/soc/oam.v` stub): two 8-bit ports over 80 16-bit words (= 40 OAM entries), port B = even bytes, bitline hold, inverse-hold `~data` pads. |
| `lcd_stub.v` | Consumer stub for the (output-only) LCD driver interface: samples LD0/LD1 on /CP into a 160-px line buffer, counts pixels/lines/frames. |
| `ppu1_merged.v`, `ppu2_merged.v` | The PPU netlists with the bidirectional-bus alias `assign`s merged into real net aliases (see `merge_bus_aliases.py`). Without this Icarus cannot simulate register writes: the internal bus wires never see the CPU data. Regenerate with `python3 merge_bus_aliases.py ../../ppu1.v ppu1_merged.v` and `python3 merge_bus_aliases.py ../../ppu2.v ppu2_merged.v` from this directory. |
| `merge_bus_aliases.py` | Tool: rewrites `assign d[7] = w79;` style aliases (inout bus bits) into true net aliases by renaming `w79` → `d[7]` and deleting the alias + orphaned wire declarations. Only touches `d/md/nma/n_oama/n_oamb`. |
| `tb_ppu_regs.v` | Register write/read + reset + counter/mode smoke test. |
| `tb_ppu_bg_scanline.v` | BG rendering test: mode2/3 per-line rhythm, VRAM BG fetch, pixel serialization on LD0/LD1. |
| `tb_ppu_scroll.v` | SCY/SCX scroll test: PPU2 V+SCY / H+SCX adders change the fetched tile-map row/column. |
| `tb_ppu_window.v` | Window (WIN) test: with LCDC.6 the tile-map fetches switch to the $9C00 window map. |
| `tb_ppu_frame.v` | Full-frame test (slow, ~5 min): VBlank at LY=144, V wrap 153->0, `ppu_int_vbl` pulse. |
| `tb_ppu_scene.v` | Synthetic scene (LCD+BG+WIN+OBJ with content): combined mode rhythm + BG pixel stream. |
| `tb_ppu_bg_win_matrix.v` | BG/WIN layer combination matrix (map select bit3/bit6 x enable bit0/bit5 x WY/WX). |
| `tb_ppu_mode_fsm.gtkw` | GTKWave save for the mode state machine + LX/LY waves. |
| `tb_ppu_sprites.v` | (dev) mode-2 OAM scan / sprite store bring-up - see STATUS.md and waves.md. |
| `tb_ppu_oam_cpu.v` | (dev) CPU->OAM write path bring-up - see STATUS.md. |
| `tb_ppu_oam_read.v` | (dev) CPU->OAM read path bring-up - see STATUS.md. |
| `tb_ppu_dma.v` | (dev) VRAM->OAM DMA bring-up - see STATUS.md. |
| `STATUS.md` | Status snapshot, blockers and the author checklist. |
| `tb_ppu_sprites.v` | (dev) mode-2 OAM scan bring-up - see waves.md. |
| `tb_ppu_oam_cpu.v` | (dev) CPU->OAM write path bring-up - see waves.md. |
| `*.bat` | Windows compile & run wrappers. `run_all.bat` runs every test. |
| `waves/` | Waveform images, one per test. |
| `waves.md` | Documentation of the tests with embedded wave images. |

## Coverage

| Functional area | Test / status |
|-----------------|---------------|
| PPU CPU interface (register write/read, LCDC reset release, LY read-back) | `tb_ppu_regs` — ALL PASS |
| Line rhythm (456 ticks), mode 2 (80 ticks), mode 3 start | `tb_ppu_regs`, `tb_ppu_bg_scanline` — ALL PASS |
| BG rendering pipeline (fetch → serializer → LD0/LD1) | `tb_ppu_bg_scanline` — ALL PASS |
| SCY / SCX scroll adders (PPU2 V+SCY, H+SCX on nma) | `tb_ppu_scroll` — ALL PASS |
| WIN layer (WY/WX, LCDC.6 window map $9C00) | `tb_ppu_window` — ALL PASS |
| OAM macro (interface of the empty `oam.v` stub) | `oam_ram.v` — behavioral model (2 ports/80 words, bitline hold, port B = even bytes) |
| LCD driver interface (output-only) | `lcd_stub.v` — consumer stub (samples LD0/LD1 on /CP into a 160-px line buffer) |
| OAM mode-2 scan / sprite store / compare | `tb_ppu_sprites` — dev (scan + ports defined; `obj_prio_ck` inert -> store not claimed; see waves.md) |

### Functional-block coverage (per wiki/soc/ppu1.md and wiki/soc/ppu2.md)

Legend: ✅ verified by a passing test · 🟡 partially verified / dev · ⬜ open (blocked, see waves.md "Research handoff").

| PPU1 block (ppu1.md) | Status | Evidence |
|---|---|---|
| 1 Register decode | ✅ | regs: writes to $FF40-4B decoded; no cross-writes |
| 2 PPU registers | ✅ | regs: read-back SCY/SCX/BGP/LCDC/LY |
| 3 H counter (LX) | ✅ | regs/bg: h counts, 456-tick line |
| 4 V counter (LY) | ✅ | regs + `tb_ppu_frame`: LY read-back, VBlank at LY=144, wrap 153->0 |
| 5 Window logic | ✅ | window: $9C00 fetches with WY/WX; bg_win_matrix C4-C8 (map select x WY) |
| 6 BG/WIN fetch sequencer | ✅ | bg/scroll/window/scene/bg_win_matrix: mode2/3 rhythm + layer map selects |
| 7 VRAM address generation | ✅ | bg/scroll: map/data fetch addresses; SCY/SCX adders |
| 8 BG pixel shifter | ✅ | bg: LD stream matches tile data through BGP |
| 9 Sprite pixel path | ⬜ | tb_ppu_scene includes an OBJ; sprite fetch not engaged (blocked, STATUS.md) |
| 10 Sprite selection ring / LAST_SPRITE | 🟡 | ring toggles in mode 2; completion condition open |
| 11 Palettes + pixel mux | ✅ | bg: color pattern through BGP on LD0/LD1 |
| 12 LCD driver timing | ✅ | lcd_stub: /CP pulses, /ST//CPL per line |
| 13 OAM parse clocks (mode 2) | 🟡 | oam_addr_ck/oam_rd_ck run; obj_prio_ck inert (blocked) |
| 14 Interrupt outputs (STAT/VBL) | ✅ | `tb_ppu_frame`: vbl at LY>=144, ppu_int_vbl pulses; regs: STAT mode bits read 2/3 in mode2/3, LYC int at LY==LYC |
| 15 Reset/clock generation | ✅ | regs: n_ppu_reset/hard-reset behaviour |
| 16 DMA interface | 🟡 | dev tb_ppu_dma (needs SoC arbiter timing) |

| PPU2 block (ppu2.md) | Status | Evidence |
|---|---|---|
| 1 SCY/SCX registers | ✅ | regs read-back; scroll test effects |
| 2 Scroll adders + nma drive | ✅ | scroll test: (V+SCY)>>3, (H+SCX)>>3 |
| 3 Port-B adder (Y test) | 🟡 | Y-test adder values observed; store not claimed (blocked) |
| 4 Mode-2 scan engine | 🟡 | mode2 80-tick; oa word stepping; stop_oam_eval pulses |
| 5 OAM port/address muxes | 🟡 | CPU OAM write lands word-addressed; strobe x issue (dev) |
| 6 Sprite-store capture stage | ⬜ | attr stage x half-cycles (blocked) |
| 7 10-slot sprite store | ⬜ | no slot claimed (obj_prio_ck inert) |
| 8 Sprite compare (mode 3) | ⬜ | sprite_x_match never asserts |
| 9 Clock/reset generation | ✅ | ppu_clk=cclk, n_ppu_hard_reset, ppu_rd/wr passthrough |
| 10 DMA/CPU-OAM write | 🟡 | dev tb_ppu_oam_cpu / tb_ppu_dma |

Details, wave images and the research handoff are in [waves.md](waves.md);
the status snapshot and author checklist are in [STATUS.md](STATUS.md).
| CPU OAM write & VRAM→OAM DMA data paths | `tb_ppu_oam_cpu`, `tb_ppu_dma` — dev (need SoC arbiter/MMIO timing) |

## Reproducing the waves

The VCD files and `.run` binaries are git-ignored - they are produced by the
tests. To regenerate everything from a clean clone:

```
# 1) run the tests (each dumps <test>.vcd)
./run_all.sh                      # fast suite; add tb_ppu_frame for the slow full-frame test
# 2) open the traces in GTKWave (v3.3.128 save files)
gtkwave tb_ppu_regs.gtkw          # etc. (files are committed, VCDs must exist)
# 3) re-render the wave PNGs (needs the vcd2png.py renderer)
python3 vcd2png.py tb_ppu_regs.vcd waves/tb_ppu_regs.png --cfg waves_cfg_regs.json ...
```

The `.gtkw` save files and the PNGs in `waves/` are committed, so a fresh
clone shows the documentation immediately; re-running the tests refreshes
the VCDs behind them.

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
