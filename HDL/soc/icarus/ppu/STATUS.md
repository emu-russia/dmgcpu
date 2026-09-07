# PPU testbench status (issue #390)

Status snapshot; details in [waves.md](waves.md), [Readme.md](Readme.md)
and the wiki pages `wiki/soc/ppu1.md` / `wiki/soc/ppu2.md`.

## Tests

| Test | Status | Covers |
|------|--------|--------|
| `tb_ppu_regs` | ✅ ALL PASS | register write + CPU read-back (LCDC/SCY/SCX/BGP/LY), reset release, counters, mode rhythm |
| `tb_ppu_bg_scanline` | ✅ ALL PASS | BG fetch pipeline, pixel stream on LD0/LD1, 456-tick line |
| `tb_ppu_scroll` | ✅ ALL PASS | PPU2 V+SCY / H+SCX scroll adders on the VRAM bus |
| `tb_ppu_window` | ✅ ALL PASS | WIN layer, LCDC.6 window tile map $9C00 |
| `tb_ppu_frame` | ✅ ALL PASS (slow, ~5 min) | VBlank at LY>=144, V wrap 153->0, ppu_int_vbl, LYC==LY interrupt |
| `tb_ppu_sprites` | 🟡 dev | mode-2 OAM scan runs; sprite store/compare not claimed (see blockers) |
| `tb_ppu_oam_cpu` | 🟡 dev | CPU OAM write lands word-addressed; strobe timing needs SoC model |
| `tb_ppu_oam_read` | 🟡 dev | CPU OAM read return path needs SoC cycle timing |
| `tb_ppu_dma` | 🟡 dev | VRAM->OAM DMA needs the MMIO DMA controller/arbiter model |

Run everything: `run_all.sh` (or `run_all.bat` on Windows); `tb_ppu_frame` is
slow and included.

## Blockers (all documented in wiki/soc/ppu1.md & ppu2.md)

1. **Sprite store/compare/pixel path** - the per-slot in-use dffr
   (`PPU2 g611-g628`) never clock (`obj_prio_ck` from PPU1 never pulses), so
   no slot is claimed, `sp_bp_cys` never fires, LD stays BG-only.
2. The `oa` mux groups (scan `w518` vs port-B adder `w475`) overlap in time
   (contention `x`); dynamic two-phase bus timing is not reproducible
   statically.
3. The mode-2 store window (PPU2 `w852 = oam_rd_ck & w209 & w816` with
   `w816` = AND of the Y-test adder results incl. FF40_D2) never opens with
   undefined OAM data, so the banks are never enabled (they are NOT held in
   reset by the flags - corrected round 21). Everything funnels into the
   Y-test/OAM data path.

## Suspected netlist issues - reported to the author, NOT patched here

- `PPU2 g938-g943` (ppu2.v:2089-2094): scan-address register, no async reset
  (`nr1 = w149 = const1`).
- `PPU1 g325/g326` (ppu1.v:1510-1511): `w530` window dividers, no async
  reset (`nr1 = w47 = const1`).
- `PPU1 g652` (ppu1.v:1837): duplicate-looking LCDC.D7 latch (q `w149` read
  only by `g305`).
- `PPU2 g419/g421` (ppu2.v:1570/1572): `oa` mux groups can be enabled at the
  same time (scan vs port-B adder) - possible phase/enable issue.
- STAT read-back (round 15/16): at LY==LYC the LYC interrupt fires but
  `$FF41` reads `0xC2/0xC3` (bit2=0, bit7=1); netlist chain `g859/g906/
  g280/w546/w736` documented in wiki/soc/ppu1.md.

## What is needed to finish the sprite test

1. Author review/fix of the suspected items above (or confirmation that the
   no-reset FFs / oa phases are intentional - then the sim must be adjusted
   instead).
2. After that: re-run `tb_ppu_sprites` - expected flow: mode-2 Y-test ->
   store claim (10 slots) -> mode-3 `sprite_x_match` -> `obj_prio_ck`
   pulses -> sprite VRAM fetch (`sp_bp_cys`) -> OBJ pixels on LD0/LD1.
3. Promote `tb_ppu_sprites` to a regression test with asserts, add its wave
   images to `waves.md` and update the coverage matrix in `Readme.md`.
