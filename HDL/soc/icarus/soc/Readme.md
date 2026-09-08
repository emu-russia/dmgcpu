# SoC small-domain Icarus testbench (issue #396)

Icarus/GTKWave bring-up for the DMG-CPU "small domains" - the real netlists
for **ClkGen**, **Arbiter**, **MMIO** and **Ser** (+ the real **HRAM**
macro), mirroring the PPU regression testbench of issue #390.

## Status

Round 1 (bring-up):
- bus-alias merging for the `a`/`d`/`md` inout buses of the small-domain
  netlists (`merge_bus_aliases.py` -> `*_merged.v`); required because the
  Deroute-style netlists attach each bus bit through a one-way `assign`
  which never shows the CPU-driven value to the decoder inputs under Icarus.
- `soc_env.v`: real ClkGen+Arbiter+MMIO+Ser+HRAM with a behavioral CPU bus
  master and pad stand-ins (same bus conventions as the PPU env).
- `tb_soc_probe.v`: reset + MMIO write/read bring-up. The write path is
  verified: writing $FF07 (TAC) clocks the internal write-decode clock
  `w148` and latches the data into the TAC dffs. Read-back and the
  remaining register blocks are under investigation.

## Files

| File | Purpose |
|------|---------|
| `merge_bus_aliases.py` | Tool: rewrites `assign <bus>[i] = wNNN` bus-bit aliases into true net aliases (rename `wNNN` -> `<bus>[i]`, delete alias + orphaned wire). Handles multi-module files (ser.v). Buses per netlist: mmio `a`,`d`; arb `a`,`d`,`md`; ser `d`; hram `d`. |
| `mmio_merged.v`, `arb_merged.v`, `ser_merged.v`, `hram_merged.v` | Merged netlists (generated - regenerate with `merge_bus_aliases.py`, see the tool header). |
| `soc_env.v` | Reusable environment: real DUTs + CPU/pad/memory stand-ins, CPU write/read tasks phase-aligned to ClkGen's `cpu_wr_sync`. |
| `tb_soc_probe.v` | Bring-up probe test. |
| `run_all.sh` | Compile + run the suite. |

## Tooling notes

- Use the WSL-native `iverilog`/`vvp` (12.0 stable is enough; `iverilog`
  on PATH). The Windows `iverilog.exe` (14.0 devel) mis-elaborates the
  merged inout-bus netlists: module-internal reads of the bus stay `z`
  (verified with an isolated microtest) - do not use it for this suite.
- Compile line (no `-g2012` - `HDL/soc/sram.v` uses `bit` as a net name):
  `iverilog -D ICARUS -o <t>.run ../../dmglib.v ../../clkgen.v
  mmio_merged.v arb_merged.v ser_merged.v ../../sram.v hram_merged.v
  soc_env.v <t>.v`
- ClkGen `osc_stable` is an *input* in this env (reg, default 1). The real
  chip loops MMIO.osc_stable back into ClkGen; the MMIO output is observed
  as `mmio_osc_stable`. (MMIO's own osc_stable chain currently stays 0 in
  simulation - see the clkgen/mmio research notes.)

## Bus conventions (worked out so far)

- `soc_wr` (MMIO output) = the internal write strobe; it follows
  `cpu_wr_sync` (ClkGen's synchronized WR) - active while the CPU writes.
- MMIO register decode clocks (`w148`/`w223`/...) are low *during* the
  write window and capture their dffs on the rising edge produced when the
  write window closes (`cpu_wr_sync` falling). The CPU model therefore
  holds data ~6 ns after `cpu_wr_sync` falls.
- TAC ($FF07) is written via the `w148` decode; TMA ($FF06) via `w223`;
  TIMA/DIV/IF use their own strobes (being worked out).
- Read-backs need the register-specific read enables (`soc_rd` based) -
  under investigation.
