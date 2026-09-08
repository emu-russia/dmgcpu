# SoC small-domain suite - status (issue #396)

Snapshot of `HDL/soc/icarus/soc`. Each test prints `RESULT ... PASS/FAIL`;
the suite currently reports SUITE OK (tb_clkgen, tb_mmio, tb_ser, tb_arb).

## Status per domain

### ClkGen - `tb_clkgen` PASS (6 checks) + `clkgen_phases.py`
- reset synchronizer release (`n_reset2`/`sync_reset`)
- M-cycle = 4 oscillator cycles; measured posedge phase table of the nine
  clocks (clk1/3/5/9 @T0, clk2/8 @+1osc, clk4 @+2, clk6/7 @+3)
- clk_ena gates only clk1..clk7; osc_ena stops the whole tree
- cpu_wr_sync = one pulse per M-cycle while WR high; ext_cs_en = active-
  low per-M-cycle pulse with cpu_mreq
- wiki/soc/clkgen.md updated (phase table + netlist structure)

### MMIO - `tb_mmio` PASS (9 checks)
- reset, TIMA/TAC write->read roundtrips (TAC reads 0xF8|value)
- IF flags: set by source pulses, cleared by CPU irq ack, $FF0F write
  *sets* flags
- lfo_16384Hz = clk9/64 (6 divider stages)
- DIV: any write resets the divider
- wiki/soc/mmio.md updated (write/read decode maps, IF, oscillators)

### Ser - `tb_ser` PASS (9 checks)
- SC bit0 = internal clock master (sck_dir), SC bit7 = start
- 8 serial_tick pulses per transfer, int_serial on completion, SC start
  bit self-clears, IF bit3 set/acked
- wiki/soc/ser.md updated

### Arbiter - `tb_arb` PASS (9 checks)
- Sys Decode sweep (boot_sel/ffxx/mmio_sel/non_vram_mreq/arb_fexx_ffxx)
- $FF50 BANK write-1 disables boot (sticky)
- non_vram_mreq excludes only the $8000-$9FFF VRAM window
- wiki/soc/arb.md updated

## Open research items (author checklist)

- [x] DIV read-back bus contention: solved by `mmio_weakbus.v` (drops the
  const-1 keepers `g234/g235` of the FF04-07 window) - `tb_div` PASS:
  read-back clean, reset-to-zero on $FF04 write, counts at the lfo rate,
  8-bit wrap.
- [x] TIMA count source + overflow -> IF2/TMA reload: measured select
  rates (sel 00 ~ 1 tick / 256 M-cycles ~ 4096 Hz) and overflow verified
  (`tb_mmio` PASS: 0xFE+sel00 -> reload from TMA + `cpu_irq_trig[2]`).
- [x] SB read-back polarity/order: root cause was the one-way
  `assign db = w2` alias inside `ser_reg_bit` (the cell set/reset logic
  never saw the CPU data); fixed in `ser_sharedq.v` - SB roundtrip exact
  (`tb_ser` PASS).
- [x] Ser d[6] bus modelling: fixed in `ser_sharedq.v` (cell alias + the
  `g3.q` shift-terminal moved off d[6]); HRAM runs with Ser present, no
  `-DNO_SER` needed (`tb_hram` PASS).
- [x] External /CS pad semantics: measured on real CPU read cycles
  (`tb_arb` PASS) - `/CS` (n_cs_topad, inverting OBUF) asserts per
  M-cycle for the a15&(a13|a14) & ~(a[15:10]=111111) windows
  ($A000 read: 2 pulses, $C000: 2; none for $8000 VRAM, $0100 ROM area
  or $FFxx).
- [x] TEST1/TEST2 decode PASS (`tb_testmode`). Full bus *driving* from
  the t1/t2 pads (pad-loopback) is intentionally left open: it needs the
  external pad/memory model (see the /CS note) and adds little beyond
  the decode semantics already verified.
- [x] waves.md polish + per-test PNG/GTKWave refresh (tb_div etc.).
- [x] lfo_512Hz (clk9/2048) measured; FF60_D1 fast-DIV probed (`tb_div`):
  DIV read ~0x0C with FF60_D1=1 (clk9-driven source taps under analysis).
- [x] HRAM interface test via `hram_model.v` (behavioral, PASS: $FF80-
  $FFFE window incl. $FFFF exclusion, cell independence). The real macro
  netlist remains unusable until `sram_array`/`sram_row_decode` are
  implemented in sram.v.
- [ ] **Ser bus modelling (d[6])**: ser cell g3's chain output aliases the
  d[6] bus node (g2.db = g3.q = d[6] in the extracted netlist), so the
  static model keeps d[6] permanently driven by that dffsr q. Tests that
  must write d[6]=1 cleanly compile with `-DNO_SER` (tb_hram); the other
  tests pass because their registers use d[6]=0. A bus-model variant
  (PPU-style) or re-checking the alias direction against the schematic is
  the open item.
- [ ] Wire waves for tb_soc_probe remnants, polish waves.md.

## PPU open-questions cross-check (issue #396 round)

The PPU suites' open questions (wiki/soc/ppu1.md "Open questions" /
ppu2.md "Open questions") were reviewed against the small-domain
findings:

- The **d-bus / oa-bus static x** items (DIV read-back, Ser d[6], PPU2
  oa idle, polarities "need waveform confirmation") are all instances of
  the same phenomenon: precharged bus nodes with *static* gate-level
  drivers that the die resolves with dynamic/phase-exclusive semantics.
  The small-domain fixes (mmio_weakbus.v, ser_sharedq.v) show the pattern:
  isolate/remove the interfering static drivers and let weak pull-ups
  hold the idle level. The PPU sprite blocker (oa during mode 2) is the
  same class - the existing `ppu2_m2only.v` phase-exclusive workaround is
  the PPU-side instance of this fix.
- The STAT read-back question (ppu1: "0xC2/0xC3, bit7=1, bit2=0") and
  the remaining PPU2 store/scan-schedule questions need the msinger
  schematics / the real OAM macro timing (the repo OAM netlist is an
  empty stub); the pandocs bit chart does not settle the bit7 read
  level, so no claim is made here.
- Items answerable from this session: none of the PPU1/PPU2 questions
  could be *closed* with the small-domain evidence; the bus-modelling
  cross-link above is the actionable takeaway.

## Tooling notes

- WSL-native `iverilog`/`vvp` required for the merged inout-bus netlists
  (the Windows 14.0 build leaves module-internal bus reads `z`).
- compile: `iverilog -D ICARUS -o <t>.run ../../dmglib.v ../../clkgen.v
  mmio_merged.v arb_merged.v ser_merged.v ../../sram.v hram_merged.v
  soc_env.v <t>.v` (no -g2012: HDL/soc/sram.v uses `bit` as a net name)
- regenerate merged netlists: `python3 merge_bus_aliases.py <../../x.v>`
