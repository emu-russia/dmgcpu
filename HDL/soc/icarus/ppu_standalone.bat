iverilog -D ICARUS -o ppu_standalone.run ../dmglib.v ../ppu1.v ../ppu2.v ../clkgen.v ppu_standalone.v
vvp ppu_standalone.run