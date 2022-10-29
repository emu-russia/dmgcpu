iverilog -Wall -v -D ICARUS -s SM83_Run -o sm83.run ../*.v run.v external_clk.v
vvp -v sm83.run