# APU Icarus testbench (issue #398)

Bring-up + regression for the **real APU netlist** of the DMG-CPU
(`HDL/soc/apu.v`), mirroring the PPU (issue #390) and small-domain
(issue #396) suites.

The suite drives the APU in its SoC context: real ClkGen + MMIO
(mmio_weakbus) + Arbiter + Ser + a behavioral WaveRAM (`wave_ram_model.v`:
the repo macro HDL/soc/waveram.v is an empty stub), with a CPU bus master
using the SoC bus conventions of `../soc` (data on d while clk2=1,
capture as the FFxx write window closes).

## Tests (all PASS in run_all.sh)

| Test | Purpose |
|------|---------|
| `tb_apu_regs` | Register-file map of $FF10-$FF3F (read/write masks, NR52 power semantics, wave-RAM window decode) |
| `tb_apu_ch1` + `check_ch1.py` | CH1 square: period = (2048-X)*32 osc (131072/(2048-X) DMG formula), duty 12.5/25/50/75%, volume plateau, NR52 status |
| `tb_apu_ch2` + `check_ch2.py` | CH2 square: same set of checks |
| `tb_apu_ch3` + `check_ch3.py` | CH3 wave: sample period = (2048-X)*2 osc, amplitude = NR32-scaled wave sample (100/50/25%/mute), wave-a stepping |
| `tb_apu_ch4` + `check_ch4.py` | CH4 noise: LFSR output toggles at vol F; NR43 divider rate dependency |

Research probes kept for the record: `tb_apu_probe`/`tb_apu_readwin`/
`tb_apu_readsel`/`tb_apu_regmask` (register decode/read timing),
`tb_apu_fs` (frame-sequencer rate measurements with the synthetic LFO).

## Files

- `apu_merged.v` - the APU netlist with the a/d bus aliases merged
  (regenerate: `python3 ../soc/merge_bus_aliases.py ../../apu.v
  apu_merged.v --buses a d`)
- `apu_wc.v` - write-clean variant for Icarus (regenerate: `python3
  make_wc.py`): gates the w548 divider-state d-drivers (g869/g937/g939-941)
  off during CPU writes; without this the level-sensitive divider preset
  latches capture x from the write-bus contention (see STATUS.md)
- `apu_env.v` - reusable environment (real DUTs + CPU model + synthetic
  LFO override for frame-sequencer measurements)
- `wave_ram_model.v` - behavioral 16-byte WaveRAM
- `apu_trace.py` - netlist decode/cone tracer (research tooling)
- `check_ch*.py` - waveform metric analysers (period/duty/amplitude)
- `waves.md` - waveform documentation (per-test images)
- `STATUS.md` - research log & open questions

Compile line: `iverilog -D ICARUS -o <t>.run ../../dmglib.v ../../clkgen.v
../soc/mmio_weakbus.v ../soc/arb_merged.v ../soc/ser_sharedq.v apu_wc.v
wave_ram_model.v apu_env.v <t>.v` (WSL-native Icarus; see ../soc notes).


