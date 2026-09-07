# PPU testbench waves (issue #390)

Regression testbench for the DMG-CPU PPU netlists `HDL/soc/ppu1.v` and
`HDL/soc/ppu2.v`, run with Icarus Verilog. Each test compiles the real
`ClkGen` + `PPU1` + `PPU2` netlists together with behavioral VRAM / OAM
models (see [Readme](Readme.md)) and dumps a VCD. The wave images below are
rendered from those VCDs; the matching `.gtkw` files open the same traces in
GTKWave (v3.3.128 save format).

Run a test with `Icarus` on the PATH:

```
tb_ppu_regs.bat
tb_ppu_bg_scanline.bat
```

or everything with `run_all.bat`. Each run prints `PASS`/`FAIL` checks and
ends with `RESULT: ALL PASS` (or a failure count). The VCD files are
git-ignored; the `.gtkw` files and the images in `waves/` are committed.

## Bus / netlist notes needed to read the waves

- The netlists alias their bidirectional bus bits with one-way Verilog
  `assign`s (`assign d[7] = w79;`). For simulation the aliases are merged
  into real net names by `merge_bus_aliases.py`, producing `ppu1_merged.v` /
  `ppu2_merged.v` (otherwise register writes can never reach the latches).
- The `dmg_notif0/1` (and `bufif0`) inverting tristates of `dmglib.v` were
  fixed for simulation: `x = ~a` while enabled and **`===`** enable compare
  (an uninitialized enable must not drive `x` onto the precharged buses).
- Buses `d`, `md`, `nma`, `n_oama`, `n_oamb` are precharged "inverse-hold"
  wires: a high (precharged, idle) level often means "no driver".
- The PPU CPU interface carries **true-value** data on `d`: register
  read-back drivers are `notif0` fed from the latch `nq`, register latches
  capture the wire value directly.

## Test 1 — `tb_ppu_regs` (register write/read + reset + counter/mode smoke)

Scenario: power-on reset, then through the CPU model write `LCDC=$91` (LCD +
BG on), `SCY=$21`, `SCX=$07`, `BGP=$E4`, `WY/WX`, and check that PPU2
produces `ppu_wr`/`ppu_rd`, that LCDC stores the value (checked via the
`FF40_D1..3` outputs), that `LCDC.7=1` releases the PPU soft reset, that the
other register writes do not disturb LCDC, that the read-only `LY` read-back
tracks the V counter, and that the H/V counters and the mode2/3 handshake run.

![tb_ppu_regs](/HDL/soc/icarus/ppu/waves/tb_ppu_regs.png)

What the wave shows (0–62 µs):

- `reset` release at ~0.5 µs (`/RES` active low), then `n_ppu_hard_reset`
  and `n_ppu_reset` rise only after the `LCDC.7` write (the CPU-bus activity
  on `cpu_a`/`d` shows the FF40…FF4B writes).
- `ppu_wr` pulses follow each `soc_wr` write; `FF40_D1/D2/D3` stay 0 (the
  written LCDC `$91` = `1001_0001` has bits 1–3 clear) while `n_ppu_reset`
  stays 1.
- After the registers are programmed the H counter starts counting lines,
  `mode2` (OAM scan) and `mode3` (fetch) alternate each 456-tick scanline,
  and the V counter increments at line end.

## Test 2 — `tb_ppu_bg_scanline` (BG rendering: modes, fetch, pixels)

Scenario: VRAM is preloaded (tile map `$9800` row 0 → tile `$01` for all 32
columns; tile 1, row 0 = `plane0 $AA` / `plane1 $55`), the PPU is programmed
(`LCDC=$91`: LCD on, BG on, map `$9800`, tiles `$8000`; `SCY=SCX=0`;
`BGP=$E4`) and two scanlines are observed. Checks: mode2 + mode3 per line,
456-tick line period, VRAM fetches during mode3, pixel samples on the LCD
bus.

![tb_ppu_bg_scanline](/HDL/soc/icarus/ppu/waves/tb_ppu_bg_scanline.png)

What the wave shows (2–65 µs):

- `mode2` is high for ~80 ticks then `mode3` takes over; `h_restart` pulses
  at the end of the line; `v` increments once per line.
- During mode3 the `nma` bus (VRAM address, inverse-hold: active low bits)
  carries the fetch sequence — tile-map reads (`(V+SCY)>>3` row × 32 +
  `(H+SCX)>>3` column driven by PPU2, cf. wiki/soc/ppu2.md block 2) and the
  tile-data reads at `tile*16 + (LY&7)*2`, with the `md` bus returning the
  VRAM bytes in between.
- The LCD interface: `n_lcd_cp` (pixel clock, active low pulses) runs during
  mode3 and `n_lcd_ld0`/`n_lcd_ld1` carry the serialized pixels — the solid
  tile row produces a stable `10`/`01` per-pixel pattern through the palette
  mux, ~160 samples per visible line.

## Test 3 — `tb_ppu_scroll` (SCY/SCX scroll adders)

Scenario: SCY=1, SCX=8 with a per-column/per-row unique tile map, then two
checks on the real VRAM addresses fetched by PPU2's scroll adders
(`wiki/soc/ppu2.md` block 2): with `SCY=1` the tile-map row fetched at
`LY=8` is `(LY+SCY)>>3 = 1`, and with `SCX=8` the first map column fetched
at the line start is `SCX>>3 = 1`.

![tb_ppu_scroll](/HDL/soc/icarus/ppu/waves/tb_ppu_scroll.png)

## Test 4 — `tb_ppu_window` (WIN layer: WY/WX + window tile map)

Scenario: LCDC = $F1 (LCD + BG + WIN on, window tile map $9C00 via LCDC.6),
WY=0, WX=7 so the window covers the whole visible area. The test verifies
that the PPU tile-map fetches come from the **$9C00 window map** (address
0x1C00..0x1DFF) with the window tile data, i.e. the PPU1 window logic
(in_window / WY/WX compare / map select) and the PPU2 `!in_window` gating of
the scroll adders behave together.

![tb_ppu_window](/HDL/soc/icarus/ppu/waves/tb_ppu_window.png)

## Work in progress

- `tb_ppu_sprites.v` (dev): brings up the mode-2 OAM scan with a real OAM
  model — scan addresses and the OAM read bus are now defined after the
  tristate `===` fix; sprite attribute capture (`obj_color`/`obj_prio`/
  `sprite_x_flip`) toggles during the scan. Remaining work: the precharge
  half-cycle handling and the mode-3 sprite-match / pixel output, then it
  will be promoted to a regression test with asserts.
