# SM83 Core Icarus TestBench

Projects for Icarus Verilog (http://iverilog.icarus.com/).

## How to Use

- Download Icarus Verilog.
- Run the simulation using `make` (`ROM` can be any `.mem` file under `roms/`, `CYCLES` is the number of cycles to simulate):

```bash
make run ROM=roms/cpu_instrs.mem CYCLES=1000000
```

- Open `dmg_waves.fst` in [GTKWave](https://gtkwave.sourceforge.net/) or [Surfer](https://surfer-project.org/).
- Additionally, you can load prepared signal sets (`debugging_instructions.gtkw`) into GTKWave: File -> Read Save File.
- Think, scratch your head, fix bugs, redo everything.

![dmg_waves](/imgstore/sm83/dmg_waves.png)

## Verilator

The simulation can be run in [Verilator](https://www.veripool.org/verilator/), which is ~35x faster than Icarus Verilog, but it requires a bit more setup.

First, you need a custom build of a fork of [Yosys](https://yosyshq.net/yosys/), found [on this branch](https://github.com/Rodrigodd/yosys/tree/dmgcpu-changes-2) (or [this commit, to be precise](https://github.com/Rodrigodd/yosys/commit/3ba9b002e5189a83ecfa4da7780d77eb4d2dfb70)). Yosys will be used to convert the current design, which uses high-impedance signals to simulate dynamic logic (unsuitable for simulation in Verilator), into a design that only uses `0` and `1` values and can be simulated with Verilator. For more details, see [this PR](https://github.com/emu-russia/dmgcpu/pull/292).

Set the path to the Yosys binary using the `DMG_YOSYS` environment variable, and run Yosys with the `make` target `yosys`:

```bash
make yosys
```

This will create a `sm83.yosys.v` file that can be used with Verilator (or any other simulator).

Then, run the simulation with `make`:

```bash
make verilator ROM=roms/cpu_instrs.mem CYCLES=1000000
```

This will create a `dmg_waves3.fst` file that can be opened in [GTKWave](https://gtkwave.sourceforge.net/) or [Surfer](https://surfer-project.org/).

Note that `sm83.yosys.v` flattens the entire design, so the hierarchy is lost, and many signals are removed. If you need a particular signal, add a `(* keep *)` attribute to it.
