
module ALU ( CLK2, CLK5, CLK6, CLK7, Res, AllZeros, TTB3, d, w, x, bc, alu, bq4, bq5, bq7, ALU_to_bot, FromThingy, ALU_L1, ALU_L2, ALU_L4, ALU_Out1, IR, nIR );

	input CLK2;
	input CLK5;
	input CLK6;
	input CLK7;

	output [7:0] Res;
	input AllZeros;
	input TTB3;
	input [106:0] d;
	input [40:0] w;
	input [68:0] x;
	output [5:0] bc;
	input [7:0] alu;
	input bq4;
	input bq5;
	input bq7;
	output ALU_to_bot;
	input FromThingy;
	input ALU_L1;
	input ALU_L2;
	input ALU_L4;
	output ALU_Out1;
	input [7:0] IR;
	input [5:0] nIR;

	// Internal

	wire ALU_L0;
	wire ALU_L3;
	wire ALU_L5;

endmodule // ALU
