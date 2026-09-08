# SoC small-domain waves (issue #396)

Waveform documentation for the SoC small-domain testbench suite
(`HDL/soc/icarus/soc`): ClkGen, Arbiter, MMIO, Ser (+ HRAM). Generated
with the WSL-native Icarus + the `vcd2png.py` renderer (the GTKWave
v3.3.128 save files are committed next to each test).

## tb_mmio - MMIO register behaviour

Reset, TIMA/TAC/TMA write->read roundtrips, IF flag set/clear and the
lfo_16384Hz (= clk9/64) divider.

![tb_mmio](waves/tb_mmio.png)

What to look at in the wave:

- `reset` deassert -> `n_reset2`/`sync_reset` settle after a few clock
  edges (ClkGen reset synchronizer).
- CPU cycles: address on `cpu_a`, `d` carries the data; `cpu_wr_sync`
  pulses = MMIO `soc_wr` write windows; the decode clocks (`w148` =
  $FF07/TAC write, `w223` = $FF06/TMA write) are low inside the window
  and capture their dffs on the trailing edge.
- `cpu_irq_trig` bit4 pulses after the `int_jp` strobe (IF joypad flag)
  and clears after the CPU IRQ acknowledge.
- `lfo_16384Hz`: 64 toggles per 4096 `clk9` cycles (clk9 / 64).

## tb_ser - Serial link

SB load, SC start with the internal shift clock, 8-tick transfer,
`int_serial` on completion, SC start-bit auto-clear, IF serial flag.

![tb_ser](waves/tb_ser.png)

Verified behaviour:
- `sck_dir` = SC bit0 (internal clock master when 1).
- Writing SC bit7 = 1 starts an 8-tick transfer; `serial_tick` pulses 8
  times; SB shifts out on `ser_out` and in from `n_sin` (idle high -> all
  ones after the transfer).
- On completion `int_serial` rises, the MMIO IF serial flag
  (`cpu_irq_trig[3]`) is set, and the SC start bit self-clears.
- IF serial flag is cleared by the CPU IRQ acknowledge.
- SB read-back of an arbitrary loaded value shows only bus-bit0 (read-back
  polarity/order open question - the loaded value is proven through the
  shift result).

## Open / upcoming tests

- `tb_clkgen` - clock phases, reset sync, ext_cs_en/cpu_wr_sync
- `tb_arb` - bus arbitration, /CS//MRD//MWR pad drives, test modes
- HRAM and DIV read-back modelling

See [Readme.md](Readme.md) for status and [STATUS.md](STATUS.md) for the
research log.
