# APU suite - status (issue #398)

Snapshot of `HDL/soc/icarus/apu`. The suite drives the *real* APU netlist
(`apu_merged.v`, HDL/soc/apu.v with the a/d bus aliases merged) inside the
SoC context: real ClkGen + MMIO (mmio_weakbus) + Arbiter + Ser + behavioral
WaveRAM, with a CPU bus master (same conventions as `../soc`, issue #396).

## Status per test

### tb_apu_regs - PASS (35 checks)
Register file map of the real APU (measured; wiki/soc/apu.md):

| Addr | Register | read-back semantics (measured) |
|---|---|---|
| $FF10 | NR10 | `0x80 \| (v & 0x7F)` (sweep period echo, bit7 hard-1) |
| $FF11 | NR11 | `0x3F \| (v & 0xC0)` (duty echo, length bits hard-1) |
| $FF12 | NR12 | `v` (8-bit envelope echo) |
| $FF13 | NR13 | no read-back (0xFF) - write-only (feeds the divider) |
| $FF14 | NR14 | `0xBF \| (v & 0x40)` (bit6 length-enable echo) |
| $FF16-$FF19 | NR21-NR24 | same pattern as NR11-NR14 (ch2) |
| $FF1A | NR30 | `0x7F \| (v & 0x80)` (DAC-enable echo, rest hard-1) |
| $FF1C | NR32 | `0x9F \| (v & 0x60)` (volume echo, rest hard-1) |
| $FF1E | NR34 | `0xBF \| (v & 0x40)` |
| $FF20-$FF23 | NR41-NR44 | NR41 no read-back; NR42/NR43 echo; NR44 `0xBF\|(v&0x40)` |
| $FF24 | NR50 | `v` (8-bit echo) |
| $FF25 | NR51 | `v` (8-bit echo) |
| $FF26 | NR52 | `0x70 \| (power<<7) \| (ch-active bits 3:0)`; 0xF0 after
power-on, 0x70 powered off. Power-off write resets the channel registers. |
| $FF27-$FF2F | - | unmapped (0xFF, no read driver) |
| $FF30-$FF3F | WaveRAM | CPU write/read window decoded by the APU itself
(`n_wave_wr`/`n_wave_rd` + `wave_a = a[3:0]` while not playing; data on d
re-driven from `wave_rd` by the notif1 stage g1255..g1262) |

Write decode map (verified): w695 = $FF30-$FF3F window; n_wave_wr =
~(soc_wr & w695); n_wave_rd = ~(ch3_active ? <sample clock> : (soc_rd &
w695)).

### tb_apu_ch1 + check_ch1.py - PASS
Channel 1 verified end-to-end on the real netlist:
- output period = `(2048 - X) * 32` oscillator cycles (measured exact at
  X=0x780 and X=0x700) - the DMG `131072/(2048-X)` relation (freq timer
  ticks at clk9 = osc/4, 8 duty steps per output period)
- duty fractions 12.5 / 25 / 50 / 75 % measured exact
- the high level equals the NR12 volume (4-bit)
- NR52 status bit0 set while running, cleared by power-off
- envelope / sweep / length counters need the frame-sequencer (lfo)
  analysis (see below)

## Open research items (author checklist)

- [ ] **ch2/ch3/ch4 output stage**: triggers set the NR52 status bits
  (f2/fc/f8...) and ch3's wave-RAM address counter advances, but ch2_out /
  ch4_out stay 0 and ch3_out is mostly 0 in the simulation windows used so
  far, while ch1_out runs cleanly at the expected rate. Working hypothesis:
  the channel *output gates* (e.g. ch2 gate = w354 = w1266|w611 with
  w1266 = w924&w925; w925 is clocked by w1207 off the ch2 divider chain
  g318/g442-444) require the frequency divider of those channels to tick,
  and their divider chains (cnt g416-418/g466 etc.) are frozen in the sim
  (no net of g1336/w1322/w1213/w1382/w607/w1352/w552/w1241 ever changes).
  Ch1's equivalent structure runs - the difference is under analysis
  (candidates: divider clock routing clk4/clk6/clk7 vs clk9, trigger
  preset decode per channel, envelope/length interaction).
- [ ] **frame-sequencer timing**: with the synthetic lfo (4 us period), the
  ch1 envelope step cadence measured ~8 lfo pulses (32 us) between
  amplitude changes and shows glitch dips on the ch1_out bus at the same
  cadence (the 4-bit output briefly shows the decrementing counter). Exact
  fs step mapping (length 256 Hz / sweep 128 Hz / env 64 Hz pattern),
  envelope period register (NR12 bits 2:0) divide behaviour and the DMG
  frame-sequencer phase offset need a dedicated measurement test with
  internal-net observation.
- [ ] length counter / sweep: not yet measured end-to-end (needs the fs
  cadence resolved first).
- [ ] joypad ($FF00) & serial pad pieces in the APU (n_p10..n_p13,
  DRV_LOW_p1x, n_sout_topad etc.): decode map started (w570 = FF00 write
  window capturing d0..d7 into the p10-p15/serial pad latches) - tests
  pending.
- [ ] TEST1-mode a[7:0] arbitration piece of the APU (n_INPUT_a -> a via
  bufif0 g1081..g1099, addr_latch + dma mux g1066..g1073, DRV_LOW/n_DRV_
  HIGH_a[7:0] pad drivers) - tests pending.
- [ ] wave RAM CPU read: works; exact capture edge (posedge n_wave_wr)
  confirmed; per-byte 4-bit sample ordering for playback to measure in the
  ch3 test.

## Tooling notes

- compile (WSL-native iverilog):
  `iverilog -D ICARUS -o <t>.run ../../dmglib.v ../../clkgen.v
  ../soc/mmio_weakbus.v ../soc/arb_merged.v ../soc/ser_sharedq.v
  apu_merged.v wave_ram_model.v apu_env.v <t>.v`
- `apu_merged.v` regenerated with `python3 ../soc/merge_bus_aliases.py
  ../../apu.v apu_merged.v --buses a d`
- synthetic LFO: `apu_env` has `lfo_override`/`lfo_ext` - the frame
  sequencer can be clocked fast so envelope/length/sweep measurements do
  not take half a second of sim time at the real 512 Hz.
- netlist decode/cone questions: `python3 apu_trace.py apu_merged.v <net>`
  or `--readmap` (lists every d-bus read driver group and its decode).
- check_ch1.py / check_ch2.py analyse the segment VCDs (waveform metrics:
  period formula, duty %, volume plateau).
