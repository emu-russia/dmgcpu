# PPU Icarus/GTKWave testbench (issue #390)

Regression testbench for the DMG-CPU PPU gate netlists (`HDL/soc/ppu1.v`,
`HDL/soc/ppu2.v`) run with Icarus Verilog + GTKWave.

## Files

| File | Purpose |
|------|---------|
| `ppu_env.v` | Reusable PPU test environment: real `ClkGen` + `PPU1` + `PPU2` netlists, behavioral VRAM + OAM models and a small "CPU+MMIO+Arb" stand-in with register read/write tasks. The pads between the CPU die and the VRAM die are modeled (MA inversion, /MCS//MRD//MWR, MD bus). |
| `oam_ram.v` | Behavioral OAM SRAM model (interface of the empty `HDL/soc/oam.v` stub): two 8-bit ports over 80 16-bit words (= 40 OAM entries). Inverse-hold pads (data = ~pad level), precharge pullup keepers + discharge-only read pads, hi-Z during writes (round 26). |
| `lcd_stub.v` | Consumer stub for the (output-only) LCD driver interface: samples LD0/LD1 on /CP into a 160-px line buffer, counts pixels/lines/frames. |
| `bus_weak_cells.v` | Bus-model cell `dmg_notif0_od` (open-drain discharge-only inverting tristate) used by the weak `oa` variants (bus modelling only - `ppu2.v` untouched). |
| `gen_weakbus.py` | Tool: generates `ppu2_weakbus.v` (round 27: all oa-chain groups open-drain + keepers) and `ppu2_m2only.v` (round 30: additionally the 18 non-scan oa-chain drivers are disabled while `ppu_mode2` is high). |
| `ppu2_weakbus.v`, `ppu2_m2only.v` | Generated bus-model variants of the PPU2 netlist (see `gen_weakbus.py`; used in the test compiles instead of `ppu2_merged.v` - regression suite uses `ppu2_weakbus.v`, the sprite e2e uses `ppu2_m2only.v`). |
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
| `tb_ppu_sprites.v` | (dev) mode-2 OAM scan / sprite store bring-up - see STATUS.md / waves.md. |
| `tb_ppu_sprite_e2e.v` | (dev, round 30) end-to-end sprite pixels on the `ppu2_m2only.v` bus model: claims, `obj_prio_ck`/`sp_bp_cys`/`sprite_x_match` and sprite colour pixels on LD0/LD1. |
| `tb_ppu_ring_init0.v` | (dev, round 22) no-reset FF boot probe (power-on state is 0, not x - not the sprite blocker). |
| `tb_ppu_oam_cpu.v` | (dev) CPU->OAM write path bring-up - see STATUS.md. |
| `tb_ppu_oam_read.v` | (dev) CPU->OAM read path bring-up - see STATUS.md. |
| `tb_ppu_dma.v` | (dev) VRAM->OAM DMA bring-up - see STATUS.md. |
| `STATUS.md` | Status snapshot, blockers and the author checklist. |
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
| OAM macro (interface of the empty `oam.v` stub) | `oam_ram.v` — behavioral model (2 ports/80 16-bit words; inverse-hold pads, precharge keepers + discharge-only pads, hi-Z during writes; round 26) |
| LCD driver interface (output-only) | `lcd_stub.v` — consumer stub (samples LD0/LD1 on /CP into a 160-px line buffer) |
| Y-test comparator (round 28) | ✅ verified by probes: with a valid Y byte on port B the AND6 `w816` asserts on LY 1..7 and fails on LY=8; store window opens (dev probes, temp/oamweak) |
| Mode-2 scan addressing | 🟡 blocked under the plain/weakbus models (`oa` x or odd words); the `ppu2_m2only.v` bus model gives stable even words {2,4,...,78} and unblocks the sprite path (rounds 29-30) |
| Sprite claim + store (round 30) | 🟡 dev on `ppu2_m2only.v`: Y-test passes, `w852` opens ~38x/line, in-use flag set |
| Sprite pixels to LD (round 30) | 🟡 `tb_ppu_sprite_e2e` on `ppu2_m2only.v`: `obj_prio_ck` ~10-11 pulses/line, `sp_bp_cys`/`sprite_x_match` pulse, sprite colour-01 pixels at LX ~7..14 |
| CPU OAM write & VRAM→OAM DMA data paths | `tb_ppu_oam_cpu`, `tb_ppu_dma` — dev (need SoC arbiter/MMIO timing) |
| No-reset FF "init-0" probe (round 22) | `tb_ppu_ring_init0` — dev (proves no-reset FFs boot at 0; forcing them to 0 leaves `obj_prio_ck` inert -> not a power-on-`x` issue; see waves.md) |

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
| 9 Sprite pixel path | 🟡 | sprite colour pixels reach LD0/LD1 under the `ppu2_m2only.v` bus model (`tb_ppu_sprite_e2e`, dev); blocked under plain/weakbus models - see Bus modelling |
| 10 Sprite selection ring / LAST_SPRITE | 🟡 | ring runs and `obj_prio_ck` pulses ~10-11x/line under `ppu2_m2only.v`; completion condition open |
| 11 Palettes + pixel mux | ✅ | bg: color pattern through BGP on LD0/LD1 |
| 12 LCD driver timing | ✅ | lcd_stub: /CP pulses, /ST//CPL per line |
| 13 OAM parse clocks (mode 2) | 🟡 | oam_addr_ck/oam_rd_ck run (default models); `obj_prio_ck` pulses only under the `ppu2_m2only.v` workaround |
| 14 Interrupt outputs (STAT/VBL) | ✅ | `tb_ppu_frame`: vbl at LY>=144, ppu_int_vbl pulses; regs: STAT mode bits read 2/3 in mode2/3, LYC int at LY==LYC |
| 15 Reset/clock generation | ✅ | regs: n_ppu_reset/hard-reset behaviour |
| 16 DMA interface | 🟡 | dev tb_ppu_dma (needs SoC arbiter timing) |

| PPU2 block (ppu2.md) | Status | Evidence |
|---|---|---|
| 1 SCY/SCX registers | ✅ | regs read-back; scroll test effects |
| 2 Scroll adders + nma drive | ✅ | scroll test: (V+SCY)>>3, (H+SCX)>>3 |
| 3 Port-B adder (Y test) | 🟡 | comparator verified correct (round 28: passes LY 1..7, fails LY=8 once port B carries a Y byte); data path gated by the scan addressing |
| 4 Mode-2 scan engine | 🟡 | mode2 80-tick; stop_oam_eval pulses; scan words stable and even {2,4,...,78} under `ppu2_m2only.v` |
| 5 OAM port/address muxes | 🟡 | overlapping oa-chain groups (`w518`/`w475`/`w403`/`w444`, g419/g421) corrupt the static-sim scan address; workaround `ppu2_m2only.v`; author phase review open |
| 6 Sprite-store capture stage | 🟡 | store window `w852` opens ~38x/line under `ppu2_m2only.v` (dev probes) |
| 7 10-slot sprite store | 🟡 | claims fire and an in-use flag is set under `ppu2_m2only.v` (dev); `obj_prio_ck` gates the flags |
| 8 Sprite compare (mode 3) | 🟡 | `sprite_x_match` pulses under `ppu2_m2only.v` (dev) |
| 9 Clock/reset generation | ✅ | ppu_clk=cclk, n_ppu_hard_reset, ppu_rd/wr passthrough |
| 10 DMA/CPU-OAM write | 🟡 | dev tb_ppu_oam_cpu / tb_ppu_dma |

Details, wave images (incl. `waves/tb_ppu_sprite_e2e.png`, round 30) and the
research handoff are in [waves.md](waves.md); the status snapshot and
author checklist are in [STATUS.md](STATUS.md).

> [!NOTE] Sprite-path status
> The 🟡 sprite rows (PPU1 9/10/13, PPU2 3-8) are verified only under the
> **workaround bus model** `ppu2_m2only.v` (see "Bus modelling"): the
> static simulation cannot reproduce the two-phase oa bus, so the
> overlapping oa mux groups (`w518` vs `w475`/`w403`/`w444`, g419/g421)
> corrupt the scan address. `ppu2_m2only.v` gates the non-scan groups off
> during mode 2 - sprites then run end to end in `tb_ppu_sprite_e2e` (dev).
> The netlists `ppu1.v`/`ppu2.v` are NOT modified; a phase-exclusive
> enable (author/schematic confirmation, see waves.md round 30) would let
> us drop the workaround and promote the test.

## Reproducing the waves

The VCD files and `.run` binaries are git-ignored - they are produced by the
tests. To regenerate everything from a clean clone:

```
# 0) (optional) regenerate the bus-model variants from the merged netlist
python3 gen_weakbus.py                 # ppu2_weakbus.v + ppu2_m2only.v
# 1) run the tests (each dumps <test>.vcd; the suite uses ppu2_weakbus.v)
./run_all.sh                           # fast suite; add tb_ppu_frame for the slow full-frame test
# 1b) sprite e2e (dev, uses ppu2_m2only.v): see the compile line in tb_ppu_sprite_e2e.v header
# 2) open the traces in GTKWave (v3.3.128 save files)
gtkwave tb_ppu_regs.gtkw               # etc. (files are committed, VCDs must exist)
# 3) re-render the wave PNGs (needs the vcd2png.py renderer)
python3 vcd2png.py tb_ppu_regs.vcd waves/tb_ppu_regs.png --cfg waves_cfg_regs.json ...
```

The `.gtkw` save files and the PNGs in `waves/` are committed, so a fresh
clone shows the documentation immediately; re-running the tests refreshes
the VCDs behind them.

## Related tooling

The adapted Icarus/GTKWave skill for future DMG-CPU testbenches (APU, MMIO,
...) lives in [`HDL/soc/icarus/gtkwave-skill.md`](../gtkwave-skill.md).

## Bus modelling (testbench)

The precharged inverse-hold buses of the PPU are simulated with dynamic-bus
semantics (issue #390, round 27):

- The six PPU2 oa-chain nodes (`w497/w146/w500/w554/w641/w49`) are modelled
  as **discharge-only + keepers**: the notif0 mux groups become open-drain
  (`dmg_notif0_od` in `bus_weak_cells.v`) and a `pullup` holds the precharge
  level, so overlapping enables no longer drive the node to x. Applied by
  `gen_weakbus.py` → generated `ppu2_weakbus.v` (used in all PPU test
  compiles instead of `ppu2_merged.v`). **This is a simulator bus model only -
  `HDL/soc/ppu2.v` is NOT modified.**
- `gen_weakbus.py` also generates **`ppu2_m2only.v`** (round 30): the 18
  non-scan oa-chain drivers are disabled while `ppu_mode2` is high, so the
  mode-2 scan address is stable/even and the sprite path runs end to end
  (`tb_ppu_sprite_e2e`, dev). Used by that test; the regression suite uses
  `ppu2_weakbus.v`.
- The OAM macro pads (`n_oama`/`n_oamb`) are inverse-hold: precharge
  keepers + discharge-only pads in `oam_ram.v` (round 26).

Residual x: `oa` is clean in mode 2 and idle on the `ppu2_m2only.v` model;
on plain `ppu2_weakbus.v` it can still read `x` in mode 3 (sprite compare /
store re-fetch phase, bus unused for the BG pixel stream).

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
