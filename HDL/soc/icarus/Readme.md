# HDL/soc/icarus - Icarus Verilog testbenches

Testbenches for the DMG-CPU SoC blocks (`HDL/soc/*.v` netlists), run with
Icarus Verilog + GTKWave (Windows binaries under C:\iverilog, called from
WSL at /mnt/c/iverilog/bin).

| Testbench | DUT / purpose |
|-----------|---------------|
| `test_clkgen.v` | ClkGen (research waves) |
| `oam_clocks.v` | PPU OAM clocks research |
| `ppu_standalone.v` | PPU1+PPU2 early bring-up |
| `apu_standalone.v` | APU bring-up |
| `ppu/` | **PPU regression testbench** (issue #390): tests, waves.md, STATUS.md |
| `soc/` | **SoC small-domain suite** (issue #396): ClkGen/Arbiter/MMIO/Ser/HRAM real netlists, CPU model env |
| `apu/` | **APU regression testbench** (issue #398): register file, channels 1-4, mixer - real netlist, waves.md, STATUS.md |

Tooling notes for future work (APU, MMIO, Arb, ...):
- [gtkwave-skill.md](gtkwave-skill.md) - the adapted Icarus/GTKWave skill
  (bus-alias merge, tristate conventions, .gtkw v3.3.128 format, VCD->PNG
  workflow, OAM/LCD model notes)
- The PPU testbench in `ppu/` is the reference layout to copy for new blocks.
