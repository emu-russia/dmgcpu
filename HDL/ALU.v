
module ALU ( CLK2, CLK5, CLK6, CLK7, DV, Res, AllZeros, TTB3, d, w, x, bc, alu, bq4, bq5, bq7, ALU_to_bot, FromThingy, ALU_L1, ALU_L2, ALU_L4, ALU_Out1, IR, nIR );

	input CLK2;
	input CLK5;
	input CLK6;
	input CLK7;

	input [7:0] DV;
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
	output FromThingy;
	input ALU_L1;
	input ALU_L2;
	input ALU_L4;
	output ALU_Out1;
	input [7:0] IR;
	input [5:0] nIR;

	// Internal wires

	wire [7:0] e;		// module2 e in
	wire [7:0] f;		// module2 f out
	wire [7:0] ca; 		// comb1-3 out
	wire [7:0] bx;		// module2 x out
	wire [7:0] bm;		// module2 m out
	wire [7:0] bh;		// module2 h out
	wire [7:0] bw;		// module2 w out
	wire [7:0] ao; 		// Christmas tree ands outputs to module6
	wire [7:0] na; 		// Christmas tree nots outputs to module6
	wire [7:0] q; 		// Christmas trees outputs (0-3: left, 4-7: right)
	wire [5:0] nbc; 	// #bc

	wire ALU_L0;
	wire ALU_L3;
	wire ALU_L5;

	//assign ALU_L0 = ~FromThingy;

	assign ao = bh & bx; 		// ands

endmodule // ALU
