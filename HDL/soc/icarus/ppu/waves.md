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

### Why `oa[7:1]` shows red (`x`) in the sprite waves

Red in the rendered waves is the `x` (unknown) state. `oa` is red during
most non-mode-2 stretches and in the "precharge" half of every 128 ns OAM
access inside mode 2. Direct probe of the `oa` drivers (e.g. at t=30016,
mode 2) shows the cause:

```
X t=30016 m2=1 oa=0000xxx w497=x  en518=0 en475=0 w476=1   <- x (contention)
X t=30020 m2=1 oa=0000100 w497=1  en518=0 en475=x w476=x   <- clean (scan only)
```

- `oa[i]` is buffered by inverters from notif-driven nodes (`oa[1]=not(w497)`, ...).
  The scan group (`n_ena w518 = !ppu_mode2`) drives the counter value; the
  port-B adder group (`n_ena w475 = !w476`) drives constants.
- Whenever the Y-test adder sum bit `w476` is 1 (port-B data defined), `w475`
  goes low **while the scan group is also low**, and the two notif0 cells
  drive the same node to opposite rails (`w69=0` -> 1 vs `w149=1` -> 0) -
  full-drive contention gives `x`.
- When the captured port-B byte is `x` (`w476=x`), `w475=x` and the port-B
  group is off (the `===` enable compare treats x as disabled), so the scan
  runs clean - but then the Y-test/store cannot work either.

So the red `oa` is a *driven* `x` from two oa mux groups overlapping in
time (scan group + Y-adder group), i.e. the dynamic two-phase (precharge /
evaluate) separation of the oa bus is not reproduced by the static
simulation. This is the same precharge-phase modelling issue that blocks the
sprite store; a discharge-only tristate model removes the contention but
changes the scan addressing polarity (documented in wiki/soc/ppu2.md open
questions). Resolving it needs the real two-phase bus timing (or the
author's netlist review of the `g938–g943`/`g325–g326` no-reset FFs and the
`oa` mux phases).

## Research handoff (sprite/OAM block)

Status of the OAM/sprite datapath investigation (rounds 1-10), for the
author or a later session:

**Verified / working (regression suite, 4/4 ALL PASS):** CPU register
write+read-back (LCDC/SCY/SCX/BGP/LY - PPU1 and PPU2 read paths), 456-tick
line / 80-tick mode-2 rhythm, BG fetch & pixel stream, SCY/SCX scroll
adders, WIN layer, OAM SRAM model (`oam_ram.v`), LCD stub (`lcd_stub.v`).

**Not yet reproducible:** the sprite store claim + mode-3 sprite fetch/pixel
path. With OBJ on, mode-3 length is now normal (fixed by the OAM model), but
`obj_prio_ck` never pulses, no sprite slot is claimed, `sp_bp_cys` never
fires. Two coupled root causes (see the open questions / suspected-issue
lists in wiki/soc/ppu1.md & ppu2.md):

1. dynamic-bus two-phase behaviour of the `oa`/`n_oama`/`n_oamb` muxes is
   not reproduced statically (the scan group and the port-B-adder group of
   the `oa` mux overlap in time -> contention `x`; a discharge-only tristate
   removes the contention but changes the scan addressing polarity);
2. several FF groups have no async reset (`PPU2 g938-g943` scan-address
   register, `PPU1 g325/g326` window dividers, plus `PPU1 g652` looks like a
   duplicate LCDC.D7 latch) - reported to the author, NOT patched here.

Round-12/21 observation: sampled over lines v=1..10, the ten 8-bit store
banks (g650/g668/g647/g637/g659/g642/g670/g664/g677/g635) all stay 0x00.
Correction (round 21): the banks are NOT held in reset by the in-use dffr -
their async reset `nres = ~(w27|flag)` is released during the line
(w27 = h_restart | !n_ppu_reset); they simply never receive an *enable*,
because the store window never opens:
  w852 = oam_rd_ck & w209(mode2) & w816,  w816 = w474&w475&w484&w483&w481&w480
where w474/w475/w484/w483/w481 are the Y-test adder (g595-g602) results and
w480 = FF40_D2 | w479. With OAM data undefined (the `oa`/port-x issue) the
Y-test never satisfies the window, so no bank enable, no stored sprite, no
mode-3 compare -> obj_prio_ck stays idle. The whole sprite claim path is
therefore gated on the OAM Y-test data/window, i.e. the same root as the
`oa` phase issue (reported to the author).

Round-13: obj_prio_ck has ZERO rising edges over 4 full lines
(edge-detection probe), although h_restart pulses each line and the sprite
ring reset term w816 = ~(w530|w531|h_restart) does dip. obj_prio_ck =
~(w239|w240); w240 (nand3 over the sprite-process FFs g322/g314/g287) stays
high because w229/w241 never reach 1 together - the g287-g289 ring never
leaves its latched state (w226=1,w228=1) after boot, so the claimed
"restart each line" never produces process-clock pulses. The FSM boot state
depends on the no-reset FFs reported to the author. Sprite research is
paused here pending the author's netlist fixes.

To unblock: (a) author fixes/confirms the suspected netlist items, and/or
(b) schematic-level two-phase bus timing (msinger pages) is made available,
then the sprite test can be completed from the current bring-up state
(`tb_ppu_sprites.v` already runs the scan; OAM model and LCD stub are in
place).

## Test 5 — `tb_ppu_frame` (V counter / VBlank / wrap, full frame)

Full-frame simulation (~4.55 ms sim time, slow): with the LCD on, checks
that VBLANK (`vbl` from PPU1) asserts at LY>=144, the V counter wraps
153->0 at the frame end and `ppu_int_vbl` pulses (PPU1 blocks 4 and 14).

![tb_ppu_frame](/HDL/soc/icarus/ppu/waves/tb_ppu_frame.png)

## Test 6 — `tb_ppu_scene` (synthetic scene: LCD+BG+WIN+OBJ together)

Full synthetic scene with real content: BG map $9800 (tile 1 checker), WIN
map $9C00 (tile 2, WY=160 so the window is configured but below the
observed lines), one OBJ (Y=16, X=8, tile 1). Checks the combined mode
rhythm and the BG pixel stream; the sprite pixel output is not engaged yet
(open blocker - INFO line, see STATUS.md).

![tb_ppu_scene](/HDL/soc/icarus/ppu/waves/tb_ppu_scene.png)

## Test 7 — `tb_ppu_bg_win_matrix` (all BG/WIN layer combinations)

Sweeps the LCDC layer combinations (BG enable/bit0, BG map select/bit3,
WIN enable/bit5, WIN map select/bit6, LCD/bit7) with WY/WX, and verifies
which tile map ($9800/$9C00) the fetches come from for the active layers:

| # | LCDC | Layers / window | Result |
|---|---|---|---|
| C1/C9 | 0x80 | LCD only (no layers) | frame runs; fetcher still walks map0 (INFO, DMG layer bits gate the pixel mux, not the fetcher) |
| C2 | 0x91 | BG $9800 | PASS (map0 dominates) |
| C3 | 0x99 | BG $9C00 | PASS (map1 dominates) |
| C4 | 0xA0 | WIN $9800, WY=0 | PASS (map0 dominates) |
| C5 | 0xE0 | WIN $9C00, WY=0 | PASS (map1 dominates) |
| C6 | 0xE1 | BG $9800 + WIN $9C00, WY=0 (whole-screen window) | PASS (map1 dominates) |
| C7 | 0xE1 | same, WY=40 (window below LY<40) | PASS (BG map0 only) |
| C8 | 0xB9 | BG $9C00 + WIN $9800, WY=0 | PASS (map0/window dominates) |
| C10 | 0xE1 | BG $9800 + WIN $9C00, WY=0, WX=50 | PASS (both maps: mid-line BG->WIN switch, m0=13/m1=30) |
| C11 | 0xE1 | same, WX=3 (WX<7) | PASS (window covers the whole line - comparator WX-7 wraps negative) |

`RESULT: ALL PASS`.

## Test 8 — Mode state machine and LX/LY waves

Waves of the PPU mode handshake (mode 2 / mode 3 / stop_oam_eval /
h_restart / vclk2, the mode-2 OAM clocks oam_addr_ck/oam_rd_ck/obj_prio_ck),
the LX (h) and LY (v) counters and the LCD line timing (/CPL, /CP), from the
`tb_ppu_bg_scanline` run. Two scanlines (left) and one line zoom (right):

![mode_fsm](/HDL/soc/icarus/ppu/waves/tb_ppu_mode_fsm.png)

![mode_fsm_line](/HDL/soc/icarus/ppu/waves/tb_ppu_mode_fsm_line.png)

## Work in progress

- `tb_ppu_sprites.v` (dev): brings up the mode-2 OAM scan with the
  dedicated OAM SRAM model (`oam_ram.v`).

  State after the OAM model rework (round 6):
  * with OBJ enabled the **mode-3 window no longer overruns** (normal
    ~11 µs / 173 ticks per line — the earlier ~35 µs stall is gone);
  * the mode-2 scan runs on the word bus `oa` and both OAM ports present
    defined data (bitline-hold model);
  * the sprite pixel path is still **inert**: `obj_prio_ck` (PPU1 → PPU2,
    clocks the ten per-slot in-use dffr `g611–g628`) never pulses, so no
    slot is ever claimed, `sp_bp_cys` never fires and the LD stream stays
    BG-only. `obj_prio_ck = ~(w239|w240)` (ppu1 `g494`/`g832`); `w240`
    (nand3 `g751` on the sprite-process FFs `g322/g287/g314`) and `w239`
    (`g286` nq) never dip low in the simulated lines.
  * next step: map PPU1's sprite-clock domain (the mode-3 fetch/prio FFs
    clocked off `w596/ppu_clk`, `w815`, ring `g282–g285/g316/g317/g319`)
    and its handshake with PPU2's `stop_oam_eval`/store before the sprite
    can be claimed and rendered.

  Round-6 trace of that domain: the process FFs `g287–g289` form a
  self-timed ring (`w227=!w228`, clocks `w815=~(ppu_clk & w226&w228)` and
  `w964`), whose async reset `w816 = ~(w530|w531|w844)` is released only
  when `w530 = w184&w185` is low (`w184/w185` = free-running dividers
  `g326/g325` on `ppu_clk`, themselves **without reset**: `nr1=w47=const1`)
  and `w531 = !n_ppu_reset` is low. In the simulation the ring sits in the
  latched rest state (w226=1, w228=1) and never starts: `w239`/`w240`
  (→ `obj_prio_ck = ~(w239|w240)`) never pulse, so PPU2 never claims a
  sprite slot. Whether `w530`'s dot window / `w844` and the store handshake
  are supposed to kick the ring out of this state is the open question
  (likely needs PPU2's `sprite_x_match`/store feedback).

  Round-7: `w844 = h_restart` (ppu1 assign) - so the ring IS reset at the
  end of every scanline (`w816 = ~(w530|w531|h_restart)`), yet it re-latches
  to its terminal state (w226=1/w228=1) within the next few clocks and
  `obj_prio_ck` still never pulses in any sampled mode-2 or mode-3 window.
  Also note PPU2's per-slot in-use dffr `g611–g628` have d-terms built from
  the *mode-3* compare flags (`w332 = FF40_D1 & ppu_mode3` gated) while the
  store banks capture during mode 2 - the exact mode-2/mode-3 interleaving
  of "claim" vs "capture" is not yet reproducible and needs schematic-level
  sprite scheduling data.

  ![tb_ppu_sprites_scan](/HDL/soc/icarus/ppu/waves/tb_ppu_sprites_scan.png)

  Not promoted to a regression test yet.
