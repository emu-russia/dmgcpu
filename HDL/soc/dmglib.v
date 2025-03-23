// SHARP DMG CPU Cells Library (with unknown name)
// http://iceboy.a-singer.de/doc/dmg_cells.html
// https://github.com/emu-russia/dmgcpu/blob/main/wiki/soc/cells.md

module dmg_and (  a, b, x);

	input wire a;
	input wire b;
	output wire x;

	and (x, a, b);

endmodule // dmg_and

module dmg_and3 (  a, b, c, x);

	input wire a;
	input wire b;
	input wire c;
	output wire x;

	and (x, a, b, c);

endmodule // dmg_and3

module dmg_and4 (  a, b, c, d, x);

	input wire a;
	input wire b;
	input wire c;
	input wire d;
	output wire x;

	and (x, a, b, c, d);

endmodule // dmg_and4

module dmg_aon (  a0, a1, b, x);

	input wire a0;
	input wire a1;
	input wire b;
	output wire x;

	assign x = (a0 & a1) | b;

endmodule // dmg_aon

module dmg_bufif0 (  a0, n_ena, a1, x);

	input wire a0;
	input wire n_ena;
	input wire a1;  			// not used
	output wire x;

	assign x = n_ena == 1'b0 ? a0 : 1'bz;

endmodule // dmg_bufif0

module dmg_const (  q0, q1);

	output wire q0;
	output wire q1;

	assign q0 = 1'b0;
	assign q1 = 1'b1;

endmodule // dmg_const

// DFFR_B2
module dmg_dffr (  clk, nr1, nr2, d, q, nq);

	input wire clk;
	input wire nr1;
	input wire nr2;		// not used
	input wire d;
	output wire q;
	output wire nq;

	reg val;
	initial val = 1'bx;

	always @(posedge clk) begin
		if (clk)
			val <= d;
	end

	always @(*) begin
		if (~nr1)
			val <= 1'b0;
	end

	assign q = val;
	assign nq = ~val;

endmodule // dmg_dffr

// DFFR_B1
module dmg_dffrnq_comp (  nr1, d, ck, cck, nr2, nq, q);

	input wire nr1;
	input wire d;
	input wire ck;
	input wire cck; 	// not used
	input wire nr2;		// not used
	output wire nq;
	output wire q;

	reg val;
	initial val = 1'bx;

	always @(posedge ck) begin
		if (ck)
			val <= d;
	end

	always @(*) begin
		if (~nr1)
			val <= 1'b0;
	end

	assign q = val;
	assign nq = ~val;

endmodule // dmg_dffrnq_comp

// DFFSR
module dmg_dffsr (  clk, nres, nset1, nset2, d, q, nq);

	input wire clk;
	input wire nres;
	input wire nset1;
	input wire nset2;	// not used
	input wire d;
	output wire q;
	output wire nq;

	reg val;
	initial val = 1'bx;

	always @(posedge clk) begin
		if (clk)
			val <= d;
	end

	always @(*) begin
		if (~nres)
			val <= 1'b0;
		else if (~nset1)
			val <= 1'b1;
	end

	assign q = val;
	assign nq = ~val;
endmodule // dmg_dffsr

// D_LATCH_B
module dmg_latch (  ena, d, q, nq);

	input wire ena;
	input wire d;
	output wire q;
	output wire nq;

	reg val;
	initial val = 1'b0;

	always @(*) begin
		if (ena)
			val = d;
	end

	assign q = val;
	assign nq = ~val;

endmodule // dmg_latch

module dmg_mux (  sel, d1, d0, q);

	input wire sel;
	input wire d1;
	input wire d0;
	output wire q;

	assign q = sel ? d1 : d0;

endmodule // dmg_mux

module dmg_muxi (  sel, d1, d0, q);

	input wire sel;
	input wire d1;
	input wire d0;
	output wire q;

	assign q = sel ? ~d1 : ~d0;

endmodule // dmg_muxi

module dmg_nand (  a, b, x);

	input wire a;
	input wire b;
	output wire x;

	nand (x, a, b);

endmodule // dmg_nand

module dmg_nand3 (  a, b, c, x);

	input wire a;
	input wire b;
	input wire c;
	output wire x;

	nand (x, a, b, c);

endmodule // dmg_nand3

module dmg_nand4 (  a, b, c, d, x);

	input wire a;
	input wire b;
	input wire c;
	input wire d;
	output wire x;

	nand (x, a, b, c, d);

endmodule // dmg_nand4

module dmg_nand7 (  g, f, e, d, c, b, a, x);

	input wire g;
	input wire f;
	input wire e;
	input wire d;
	input wire c;
	input wire b;
	input wire a;
	output wire x;

	nand (x, a, b, c, d, e, f, g);

endmodule // dmg_nand7

module dmg_nor (  a, b, x);

	input wire a;
	input wire b;
	output wire x;

	nor (x, a, b);

endmodule // dmg_nor

module dmg_nor3 (  a, b, c, x);

	input wire a;
	input wire b;
	input wire c;
	output wire x;

	nor (x, a, b, c);

endmodule // dmg_nor3

module dmg_nor4 (  a, b, c, d, x);

	input wire a;
	input wire b;
	input wire c;
	input wire d;
	output wire x;

	nor (x, a, b, c, d);

endmodule // dmg_nor4

module dmg_nor6 (  a, b, c, d, e, f, x);

	input wire a;
	input wire b;
	input wire c;
	input wire d;
	input wire e;
	input wire f;
	output wire x;

	nor (x, a, b, c, d, e, f);

endmodule // dmg_nor6

module dmg_nor8 (  a, b, c, d, e, f, g, h, x);

	input wire a;
	input wire b;
	input wire c;
	input wire d;
	input wire e;
	input wire f;
	input wire g;
	input wire h;
	output wire x;

	nor (x, a, b, c, d, e, f, g, h);

endmodule // dmg_nor8

module dmg_nor_latch (  s, r, nq, q);

	input wire s;
	input wire r;
	output wire nq;
	output wire q;

	reg val;
	// Let's lower the difficulty level and use 0 here instead of `x`.
	initial val = 1'b0;

	// The module design is such that reset overrides set if both are set at the same time.
	always @(*) begin
		if (r)
			val = 1'b0;
		else if (s)
			val = 1'b1;
	end

	assign q = val;
	assign nq = ~val;

endmodule // dmg_nor_latch

module dmg_not (  a, x);

	input wire a;
	output wire x;

	not (x, a);

endmodule // dmg_not

module dmg_not2 (  a, x);

	input wire a;
	output wire x;

	not (x, a);

endmodule // dmg_not2

module dmg_not3 (  a, x);

	input wire a;
	output wire x;

	not (x, a);

endmodule // dmg_not3

module dmg_not6 (  a, x);

	input wire a;
	output wire x;

	not (x, a);

endmodule // dmg_not6

// not4+not6
module dmg_not10 (  a, x);

	input wire a;
	output wire x;

	not (x, a);

endmodule // dmg_not10

module dmg_notif0 (  n_ena, a, x);

	input wire n_ena;
	input wire a;
	output wire x;

	assign x = n_ena == 1'b0 ? ~x : 1'bz;

endmodule // dmg_notif0

module dmg_notif1 (  ena, a, x);

	input wire ena;
	input wire a;
	output wire x;

	assign x = n_ena == 1'b1 ? ~x : 1'bz;

endmodule // dmg_notif1

module dmg_oan (  a0, a1, b, x);

	input wire a0;
	input wire a1;
	input wire b;
	output wire x;

	assign x = (a0 | a1) & b;

endmodule // dmg_oan

module dmg_or (  a, b, x);

	input wire a;
	input wire b;
	output wire x;

	or (x, a, b);

endmodule // dmg_or

module dmg_or3 (  a, b, c, x);

	input wire a;
	input wire b;
	input wire c;
	output wire x;

	or (x, a, b, c);

endmodule // dmg_or3