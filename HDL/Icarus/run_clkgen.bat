iverilog -D ICARUS -o clkgen.run runclk.v external_clk.v
vvp clkgen.run
