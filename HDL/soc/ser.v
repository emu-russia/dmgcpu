

module ser_reg_bit (  d, q, db, clk, ie, oe, n_ie, nres);

	input wire d;
	output wire q;
	inout wire db;
	input wire clk;
	input wire ie;
	input wire oe;
	input wire n_ie;
	input wire nres;

	// Wires

	wire w1;
	wire w2;
	wire w3;
	wire w4;
	wire w5;
	wire w6;
	wire w7;
	wire w8;
	wire w9;
	wire w10;
	wire w11;

	assign w11 = d;
	assign q = w9;
	assign db = w2;
	assign w4 = clk;
	assign w7 = ie;
	assign w3 = oe;
	assign w6 = n_ie;
	assign w10 = nres;

	// Instances

	dmg_dffsr g1 (.clk(w4), .nres(w8), .nset1(w1), .nset2(w1), .d(w11), .q(w9), .nq(w5) );
	dmg_notif1 g2 (.ena(w3), .a(w5), .x(w2) );
	dmg_oan g3 (.a0(w6), .a1(w2), .b(w10), .x(w8) );
	dmg_nand g4 (.a(w2), .b(w7), .x(w1) );
endmodule // ser_reg_bit
