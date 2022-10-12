iverilog -D ICARUS -o sm83.run ../*.v run.v external_clk.v
vvp sm83.run
