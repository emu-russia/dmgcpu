# Verilator

The same simulation in `Icarus/run.v` but using
[verilator](https://www.veripool.org/verilator/) instead, which is much faster.

To run the simulation, use `make`:

```bash
make build run ROM=roms/cpu_instrs.mem # or any other .mem file in `roms`
```

`build` will compile the verilog files to C++ and then to native, and `run` will
run the compiled simulation.

This will generate a `dmg_waves.fst` file, which can be opened in GTKWave.
