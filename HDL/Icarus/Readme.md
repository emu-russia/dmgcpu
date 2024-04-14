# SM83 Icarus TestBench

Projects for Icarus Verilog (http://iverilog.icarus.com/).

## How to use

- Download Icarus Verilog.
- Run the simulation, using `make`:

```bash
make run ROM=roms/cpu_instrs.mem # or any other .mem file in `roms`
```

- Open `dmg_waves.fst` in GTKWave
- Additionally, you can load prepared signal sets (debugging_instructions.gtkw) into GTKWave, File -> Read Save File
- Think, scratch your head, fix bugs, redo everything

![dmg_waves](/imgstore/dmg_waves.png)

# Verilator

The same simulation can be run in
[verilator](https://www.veripool.org/verilator/) instead, which is much faster.

To run the simulation, use `make`:

```bash
make build run ROM=roms/cpu_instrs.mem # or any other .mem file in `roms`
```

`build` will compile the verilog files to C++ and then to native, and `run` will
run the compiled simulation.

This will generate a `dmg_waves.fst` file, which can be opened in GTKWave.
