iverilog -D ICARUS -o clkgen.run run_clkgen.v external_clk.v
vvp clkgen.run
