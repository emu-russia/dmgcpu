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
