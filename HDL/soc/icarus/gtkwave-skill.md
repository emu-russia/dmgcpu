# GTKWave / Icarus Verilog skill (adapted for emu-russia/dmgcpu)

Adapted and extended for this repository while bringing up the PPU
regression testbench (issue #390). Keep this file updated when working on
new testbenches (APU, MMIO, Arb, Ser, ...) under `HDL/soc/icarus`.

> Origin: [emu-russia/skills](https://github.com/emu-russia/skills)
> `hdl-sim-icarus-gtkwave.md`, extended with DMG-CPU SoC netlist notes
> (bus aliasing, tristate conventions, the `oam_ram.v`/`lcd_stub.v`
> models and the wave tooling used here).

---
# Icarus Verilog + GTKWave tooling

Hard facts learned while completing the NES PPU Verilog model (emu-russia/breaks). Version-specific; verify with `-V` if anything changes.

## Environment (Windows tools run from WSL)

- Icarus Verilog **14.0 (devel)**. Binaries: `C:\iverilog\bin\iverilog.exe`, `vvp.exe`. From WSL: `/mnt/c/iverilog/bin/iverilog.exe`, `/mnt/c/iverilog/bin/vvp.exe`.
- GTKWave **3.3.128** (w 1999-2026 BSI). Binary: `/mnt/c/iverilog/bin/gtkwave.exe`.
- These are Windows `.exe` run via WSL interop (`/mnt/c/...` invocation works; no `which` entry, call the full path).

### CRITICAL: Windows CWD must not be a UNC path

`iverilog.exe` runs under `cmd.exe`, which rejects a UNC current directory (`\\wsl.localhost\...`). Symptom: `CMD.EXE ... UNC paths are not supported` / `No such file or directory` / `Preprocessor failed`. Fix: `cd` into a `/mnt/c/...` (drive-mapped) directory before running, or use `workdir` = a `/mnt/c/...` path. Do not compile from `/tmp` or a bare WSL path.

## Icarus Verilog compile/simulate

```bash
cd /mnt/c/.../HDL/Framework/Icarus/ppu   # a /mnt/c path
/mnt/c/iverilog/bin/iverilog.exe -g2012 -D RP2C02 -D ICARUS -o ppu.run ../../../Common/*.v ../../../PPU/*.v ppu.v
/mnt/c/iverilog/bin/vvp.exe ppu.run      # -> ppu_ntsc.vcd
```

- The repo's `HDL/Common/*.v` primitive library (`dlatch`, `rsff`, `rsff_2_3`, `rsff_2_4`, `sdff`, `sdffr`, `sdffr2e`, `sdffe`, `sdffre`, `bustris`, `pnor`, `aoi`, `aoi211`, `oai`) requires **`-D ICARUS`**. Without it, the `sdff*` structural `else` branches reference `oldval` before declaration and elaboration fails with `Unable to bind ... oldval`.
- Revision macro: `RP2C02` (NTSC) or `RP2C07` (PAL). Both should compile; test both when touching revision-gated code (`ifdef RP2C07` in `video_out.v`, `fsm.v`, `ppu_top.v`).
- `-g2012` avoids strict-Verilog-2001 lint on `always @(*)` and multi-dimensional arrays.
- **VCD vector values strip leading zeros**: a 5-bit bus at 0 dumps as `b0`, not `b00000` (verified: `b0` for a `[4:0]` wire = `00000`). Don't misread `b0` as a 1-bit value.

## GTKWave `.gtkw` save-file format (the big gotcha)

Two incompatible formats exist: **v3.3.100** (old) vs **v3.3.128** (current). Old save files open but silently stop loading the trace list (or hang) in 3.3.128.

| Element | v3.3.100 (broken in 3.3.128) | v3.3.128 (correct) |
|---|---|---|
| scalar | `@28` | `@28` (unchanged) |
| bus / vector | `@c00024`, `@c00022` | `@22` (plain color; vector-ness comes from the signal name `[N:0]`, NOT a flag) |
| group header | `@200` | `@201` + `-Name` |
| group end | `@1401200` + `-group_end` | omit entirely (groups just run until the next header) |
| header line | `GTKWave Analyzer v3.3.100` | `GTKWave Analyzer v3.3.128` |
| marker line | `*-14.000000 37110 -1 ...` | `*0.000000 -1 -1 ...` (26 × `-1`) |
| footer | — | `[pattern_trace] 1` then `[pattern_trace] 0` |

- `@c00024` specifically makes 3.3.128 hang or drop the signal; `@c00022`/`@c00020` drop the bus; `@1401200`+`-group_end` stops the whole list. Never hand-copy these from old files.
- The `@XXXX` value is a raw `TraceFlagsType` bitmask (not just a color). Scalar colors are `0x20..0x2f`; the vector bit moved (old `0xc00000` → new `0x02000000`), so best avoid flags entirely and use `@22`/`@28`.

### Generating a correct .gtkw

Parse the actual VCD scope tree (never guess instance names):

```python
# parse $scope/$var/$enddefinitions; build path -> [(name, width)]
# signal name for a bus includes the [msb:lsb] suffix from the $var line
# filter auto-generated wires (^w\d+$, ^bus\d+_\d+$)
# emit: @201 + -Category  (header), @22 + path (bus), @28 + path (scalar)
```

### Verifying a .gtkw actually loads

GTKWave Tcl (run via `-S`, script must live on a Windows path like `C:\...`, NOT `/tmp`):

```tcl
gtkwave file.gtkw -S C:/path/check.tcl
# check.tcl:
#   gtkwave::getTotalNumTraces   -> total traces (signals + comments)
#   gtkwave::getTraceNameFromIndex $i
#   gtkwave::getTraceFlagsFromIndex $i   (scalar=40/0x28, comment=513/0x201)
```

- Tcl list args must brace-wrap names containing brackets: `gtkwave::addSignalsFromList {PPU_Run.cpu_db[7:0]}` — plain quotes make Tcl try command substitution on `[7:0]`.
- `gtkwave::getNumFacs` = total VCD signals; `getTotalNumTraces` = currently loaded traces.
- There is no `gtkwave::setSaveFileName`; `gtkwave::/File/Write_Save_File_As <path>` does work to export a save file headlessly (use it to dump GTKWave's own current format for a reference).

## Waveform images

- No `rsvg-convert`/`convert`/`inkscape` in the WSL image, and `matplotlib` is not installed — do not assume them.
- Reliable path for wiki PNGs is the GTKWave GUI (screenshot). A Python VCD→SVG renderer (hand-rolled, no deps) is a workable fallback for browser-viewable waveforms.
- The repo `.gitignore` already ignores `*.vcd` and `*.run` (`HDL/Framework/Icarus/.gitignore`), so generated artifacts won't pollute `git status`.

## Repo test benches

- `HDL/Framework/Icarus/ppu/`: `ppu.v` (whole PPU), `fsm_test.v` ("PPU zero": PCLK + H/V counters + decoders + FSM), `vidout_test.v` (video generator), `ppu_render.v` (full PPU: resets, enables rendering via `$2001=0x1E`, loads 64 OAM sprites, runs `repeat(2048*3)` frames). `*.bat` wrappers exist; they compile from the `ppu/` dir with relative `../../../Common/*.v ../../../PPU/*.v`.
- `HDL/Framework/Icarus/mos6502/` and `HDL/Framework/Icarus/apu/` follow the same pattern for the 6502 and APU.

## Checking signals for z/x (floating-net debugging)

When a signal should be driven but the waveform shows `z`/`x`, parse the VCD and scan each signal's value-change records. Vector changes are `b<bits> <id>` (two tokens); scalar changes are `<0/1/x/z><id>` (one token). Group by the signal's declared width from the `$var` line; a bit is `z`/`x` if any dumped value starts with `z`/`x`.

```python
# tokens on a value-change line: 'b0' is a vector value whose id is the NEXT token
# '0k' is a scalar (value '0', id 'k')
```

- Only `z`/`x` *after* time 0 matter; the `$dumpvars` initial block may legitimately show `x`.
- A stuck-at-zero counter is a separate concern from z: check whether its clock/step/load inputs are toggling, not just that it's driven.


## DMG-CPU SoC netlists (emu-russia/dmgcpu) - extra notes

Worked out while bringing up the PPU regression testbench (`HDL/soc/icarus/ppu`, issue emu-russia/dmgcpu#390).

- **Bidirectional-bus aliases must be merged for Icarus.** The Deroute-style
  netlists (`ppu1.v`/`ppu2.v`, module lib `dmglib.v`) alias bus bits with
  one-way statements: `assign d[7] = w79;` etc. Under Icarus this is a real
  driver, so CPU write data never reaches the register latches (they read
  `w79`). Preprocess: rename `w79` → `d[7]` everywhere, delete the alias and
  the orphaned `wire w79;`. Tool in the repo: `merge_bus_aliases.py`
  (only touches `d/md/nma/n_oama/n_oamb`), generates `ppu1_merged.v`/
  `ppu2_merged.v`.
- **`notif0/1` inverting tristates (precharged "inverse hold" buses):**
  the committed `x = ~x` body is a self-referential loop that never drives;
  the working body is `x = ~a` while enabled **with `===` enable compares**
  (`(n_ena === 1'b0)`, `(ena === 1'b1)`) so an uninitialized enable does not
  put `x` on the bus. Note: const-0 cells (e.g. `notif0` with `a = const0`)
  act as *active precharge* drivers (they pull the wire high) - do not
  switch to discharge-only semantics without also adding pull-ups on every
  notif-driven net, or scan counters/addresses will read back `x` from
  floating nodes.
- **Level-sensitive register latches race the bus precharge.** After a CPU
  write strobe falls, keep the data valid ~8 ns (`assign d = (stb|hold) ?
  data : z`) or the latches capture the precharged `1`s.
- **OAM macro bring-up.** The repo `oam.v` is an empty stub. For the mode-2
  scan a behavioral model with *bitline hold* (drive the last word between
  reads; release only for writes) is closer to reality than tri-state z;
  the byte↔port layout and precharge/capture phase timing are still open
  research (see wiki/soc/ppu2.md) - cross-check against @msinger's
  schematics/dmg-sim before trusting sprite waveforms.
- **Wave tooling:** a dependency-free VCD→PNG renderer (`vcd2png.py`,
  stdlib + Pillow, Windows fonts for labels) and a v3.3.128 `.gtkw` save
  generator (`mk_gtkw.py`) live in `HDL/soc/icarus/ppu/`; see `waves.md`.
  Icarus dumps vector values with leading zeros stripped (`b0` for a 5-bit
  zero), parse widths from the `$var` declarations.
