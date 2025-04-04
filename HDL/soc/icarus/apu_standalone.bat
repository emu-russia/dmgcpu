iverilog -D ICARUS -o apu_standalone.run ../dmglib.v ../apu.v ../clkgen.v apu_standalone.v
vvp apu_standalone.run