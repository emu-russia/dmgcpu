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

- [ ] DIV read-back bus-contention `x` (2 bits): const-1 keeper cells
  `g234/g235` vs read-back drivers -> add a weak-bus model variant like
  the PPU `ppu2_weakbus.v`/`gen_weakbus.py` approach, or model the d-bus
  keepers as weak pull-ups in the environment.
- [ ] TIMA count-source taps + overflow -> IF bit2 / TMA reload path
  (write/read paths verified; the counter clock muxing needs the divider
  analysis; observed timer does not overflow in the current window).
- [ ] SB read-back polarity/order (loaded value proven via shift result).
- [ ] External /CS pad semantics: full pad + external-memory model
  (n_cs targets $A000-BFFF / $C000-FBFF windows per netlist analysis).
- [ ] TEST1/TEST2 mode bus driving (t1/t2 pads, ext address driving,
  a15 arbitration in Arb, boot ROM disable by test_2).
- [ ] lfo_512Hz + FF60_D1 "fast DIV" mode measurement.
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

## Tooling notes

- WSL-native `iverilog`/`vvp` required for the merged inout-bus netlists
  (the Windows 14.0 build leaves module-internal bus reads `z`).
- compile: `iverilog -D ICARUS -o <t>.run ../../dmglib.v ../../clkgen.v
  mmio_merged.v arb_merged.v ser_merged.v ../../sram.v hram_merged.v
  soc_env.v <t>.v` (no -g2012: HDL/soc/sram.v uses `bit` as a net name)
- regenerate merged netlists: `python3 merge_bus_aliases.py <../../x.v>`
