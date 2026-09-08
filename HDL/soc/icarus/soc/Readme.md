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
- `tb_soc_probe.v`: reset + MMIO register roundtrip bring-up.

Verified so far (tb_mmio all-PASS, WSL-native iverilog):
- reset: with `osc_stable=1`, `n_reset2`/`sync_reset` deassert; the clock
  tree and `cpu_wr_sync` pulse.
- MMIO register write path: the CPU write window is `cpu_wr_sync` (MMIO's
  `soc_wr` follows it); the register decode clocks (`w148` = $FF07/TAC,
  `w223` = $FF06/TMA) are low during the window and the dffs capture on
  the rising edge when the window closes (`cpu_wr_sync` falls, inside the
  `clk2=1` non-precharge phase). The CPU model holds data ~6 ns past that
  edge.
- register roundtrips: TIMA ($FF05) exact; TAC ($FF07) read-back =
  0xF8|TAC (matches the real Game Boy); TMA ($FF06) mostly exact
  (bus-settle x on one bit); TIMA/TMA/TAC write-decode clocks verified.
- IF flags: set by the interrupt source pulses (int_jp etc.), cleared by
  the CPU interrupt acknowledge (cpu_irq_ack) - *not* by an $FF0F write
  (a $FF0F write *sets* the flags instead); lfo_16384Hz = clk9 / 64
  (6 divider stages, real-chip 1.048 MHz / 64 = 16384 Hz).
- Ser (tb_ser PASS): SC bit0 selects the internal clock (`sck_dir`);
  SC bit7 starts an 8-`serial_tick` transfer; on completion `int_serial`
  sets IF bit3 (acked by the CPU) and the SC start bit self-clears; SB
  shifts out on `ser_out`.
- open questions: DIV read-back has bus-contention x on two bits (const-1
  keeper vs read-back driver - needs a weak-bus model variant like the PPU
  suite); TIMA's count-source taps and the timer IRQ path need the divider
  analysis (pending); SB read-back polarity/order (the loaded value is
  proven via the shift result); HRAM test next.

## Files

| File | Purpose |
|------|---------|
| `merge_bus_aliases.py` | Tool: rewrites `assign <bus>[i] = wNNN` bus-bit aliases into true net aliases (rename `wNNN` -> `<bus>[i]`, delete alias + orphaned wire). Handles multi-module files (ser.v). Buses per netlist: mmio `a`,`d`; arb `a`,`d`,`md`; ser `d`; hram `d`. |
| `mmio_merged.v`, `arb_merged.v`, `ser_merged.v`, `hram_merged.v` | Merged netlists (generated - regenerate with `merge_bus_aliases.py`, see the tool header). |
| `soc_env.v` | Reusable environment: real DUTs + CPU/pad/memory stand-ins, CPU write/read tasks phase-aligned to ClkGen's `cpu_wr_sync`. |
| `tb_soc_probe.v` | Bring-up probe test (dev). |
| `tb_mmio.v` | **MMIO register testbench** (PASS): resets, TIMA/TAC roundtrips, IF set/clear (int pulses + CPU irq ack + IF write), lfo_16384Hz = clk9/64, DIV write. |
| `tb_clkgen.v` | **ClkGen testbench** (PASS): reset release, clk_ena/osc_ena gating, cpu_wr_sync rate, ext_cs_en. |
| `clkgen_phases.py` | Tool: measured M-cycle + posedge phase table of the 9 clocks (feeds wiki/soc/clkgen.md). |
| `tb_ser.v` | **Serial-link testbench** (PASS): SB load + SC start (internal clock), 8 ticks, int_serial, IF flag, SC auto-clear. |
| `tb_arb.v` | **Arbiter testbench** (PASS): Sys Decode sweep, BANK $FF50 (boot disable, sticky). |
| `hram_model.v` | Behavioral HRAM model (the real macro's storage cells are TBD stubs in sram.v - same approach as `oam_ram.v` for OAM). |
| `tb_hram.v` | **HRAM roundtrip test** (PASS, compiled with `-DNO_SER`): $FF80-$FFFE window, $FFFF excluded, cell independence, rewrite. |
| `tb_testmode.v` | **TEST1/TEST2 pad decode test** (PASS): T1nT2 / nT1T2 decode, ext_cs_en forced in TEST1, n_ext_addr_en asserted. |
| `tb_*.gtkw`, `waves_cfg_*.json`, `waves/*.png` | GTKWave saves + wave images. |
| `waves.md` | Wave documentation (per-test images). |
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

- `soc_wr` (MMIO output) follows `cpu_wr_sync` (ClkGen's synchronized WR);
  MMIO register decode clocks (`w148`/`w223`/...) are low during the write
  window and capture dffs on the rising edge when the window closes
  (`cpu_wr_sync` falling, which sits inside the `clk2=1` non-precharge
  phase). Data must be held ~6 ns past that edge.
- decode map (so far): `w148` = $FF07 write (TAC), `w223` = $FF06 write
  (TMA), `w100` = $FF04-$FF07 window, `w146` = $FF00-$FF03 window;
  read enables: `w138` = $FF04 read (DIV), `w33` = $FF05 read (TIMA),
  `w89` = $FF06 read (TMA), `w127` = $FF07 read (TAC).
- d[7:0] is precharged high during `clk2=0` (MMIO precharge drivers);
  reads are sampled while `clk2=1`.
