iverilog -D ICARUS -o ppu_standalone.run ../dmglib.v ../ppu.v ../clkgen.v ppu_standalone.v
vvp ppu_standalone.run