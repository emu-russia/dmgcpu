iverilog -D ICARUS -o test_alu.run ../../_GekkioNames.v ../../ALU.v test_alu.v ../external_clk.v
vvp test_alu.run