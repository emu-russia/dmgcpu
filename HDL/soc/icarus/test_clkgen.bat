iverilog -D ICARUS -o test_clkgen.run ../dmglib.v ../clkgen.v test_clkgen.v
vvp test_clkgen.run