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

module dmg_aon22 (  a0, a1, b0, b1, x);

	input wire a0;
	input wire a1;
	input wire b0;
	input wire b1;
	output wire x;

	assign x = (a0 & a1) | (b0 & b1);

endmodule // dmg_aon22

module dmg_aon222 (  a0, a1, b0, b1, c0, c1, x);

	input wire a0;
	input wire a1;
	input wire b0;
	input wire b1;
	input wire c0;
	input wire c1;
	output wire x;

	assign x = (a0 & a1) | (b0 & b1) | (c0 & c1);

endmodule // dmg_aon222

module dmg_aon2222 (  a0, a1, b0, b1, c0, c1, d0, d1, x);

	input wire a0;
	input wire a1;
	input wire b0;
	input wire b1;
	input wire c0;
	input wire c1;
	input wire d0;
	input wire d1;
	output wire x;

	assign x = (a0 & a1) | (b0 & b1) | (c0 & c1) | (d0 & d1);

endmodule // dmg_aon2222

module dmg_aon222222 (  a0, a1, b0, b1, c0, c1, d0, d1, e0, e1, f0, f1, x);

	input wire a0;
	input wire a1;
	input wire b0;
	input wire b1;
	input wire c0;
	input wire c1;
	input wire d0;
	input wire d1;
	input wire e0;
	input wire e1;
	input wire f0;
	input wire f1;
	output wire x;

	assign x = (a0 & a1) | (b0 & b1) | (c0 & c1) | (d0 & d1) | (e0 & e1) | (f0 & f1);

endmodule // dmg_aon222222

module dmg_bufif0 (  a0, n_ena, a1, x);

	input wire a0;
	input wire n_ena;
	input wire a1;  			// not used
	output wire x;

	assign x = n_ena == 1'b0 ? a0 : 1'bz;

endmodule // dmg_bufif0

// TFFD
module dmg_cnt (  q, d, load, nq, clk);

	output wire q;
	input wire d;
	input wire load;
	output wire nq;
	input wire clk;

	reg val;
	initial val = 1'b0;

	always @(negedge clk or posedge load) begin
		if (load)
			val <= d;
		else
			val <= ~val;
	end

	assign q = val;
	assign nq = ~val;

endmodule // dmg_cnt

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
	initial val = 1'b0;

	always @(posedge clk or negedge nr1) begin
		if (~nr1)
			val <= 1'b0;
		else
			val <= d;
	end

	assign q = val;
	assign nq = ~val;

endmodule // dmg_dffr

// DFFR_A
module dmg_dffr_comp (  nr1, nr2, d, ck, cck, q);

	input wire nr1;
	input wire nr2;		// not used
	input wire d;
	input wire ck;
	input wire cck;		// not used
	output wire q;

	reg val;
	initial val = 1'b0;

	always @(posedge ck or negedge nr1) begin
		if (~nr1)
			val <= 1'b0;
		else
			val <= d;
	end

	assign q = val;

endmodule // dmg_dffr_comp

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
	initial val = 1'b0;

	always @(posedge ck or negedge nr1) begin
		if (~nr1)
			val <= 1'b0;
		else
			val <= d;
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
	initial val = 1'b0;

	always @(posedge clk or negedge nres or negedge nset1) begin
		if (~nres)
			val <= 1'b0;
		else if (~nset1)
			val <= 1'b1;		
		else
			val <= d;
	end

	assign q = val;
	assign nq = ~val;
endmodule // dmg_dffsr

module dmg_fa (  cin, s, cout, a, b);

	input wire cin;
	output wire s;
	output wire cout;
	input wire a;
	input wire b;

	assign {cout, s} = a + b + cin;

endmodule // dmg_fa

module dmg_ha (  a, b, cout, s);

	input wire a;
	input wire b;
	output wire cout;
	output wire s;

	and (cout, a, b);
	xor (s, a, b);

endmodule // dmg_ha

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

// D_LATCH_A2
module dmg_latch_comp (  n_ena, d, ena, q, nq);

	input wire n_ena;  	// not used
	input wire d;
	input wire ena;
	output wire q;
	output wire nq;

	reg val;
	initial val = 1'b0;

	always @(*) begin
		if (ena)
			val = d;
	end

	assign q = val;

endmodule // dmg_latch_comp

// D_LATCH_A
module dmg_latchnq_comp (  n_ena, d, ena, q, nq);

	input wire n_ena;  	// not used
	input wire d;
	input wire ena;
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

endmodule // dmg_latchnq_comp

// DR_LATCH
module dmg_latchr_comp (  n_ena, d, ena, nres, q, nq);

	input wire n_ena;  	// not used
	input wire d;
	input wire ena;
	input wire nres;
	output wire q;
	output wire nq;

	reg val;
	initial val = 1'b0;

	always @(*) begin
		if (ena)
			val = d;
		if (~nres)
			val = 1'b0;
	end

	assign q = val;
	assign nq = ~val;

endmodule // dmg_latchr_comp

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

module dmg_nand5 (  a, b, c, d, e, x);

	input wire a;
	input wire b;
	input wire c;
	input wire d;
	input wire e;
	output wire x;

	nand (x, a, b, c, d, e);

endmodule // dmg_nand5

module dmg_nand6 (  a, b, c, d, e, f, x);

	input wire a;
	input wire b;
	input wire c;
	input wire d;
	input wire e;
	input wire f;
	output wire x;

	nand (x, a, b, c, d, e, f);

endmodule // dmg_nand6

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

module dmg_nand_latch (  nr, ns, nq, q);

	input wire nr;
	input wire ns;
	output wire nq;
	output wire q;

	reg val;
	initial val = 1'b0;

	always @(*) begin
		if (~nr)
			val = 1'b0;
		else if (~ns)
			val = 1'b1;
	end

	assign q = val;
	assign nq = ~val;

endmodule // dmg_nand_latch

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

module dmg_nor5 (  a, b, c, d, e, x);

	input wire a;
	input wire b;
	input wire c;
	input wire d;
	input wire e;
	output wire x;

	nor (x, a, b, c, d, e);

endmodule // dmg_nor5

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

module dmg_not4 (  a, x);

	input wire a;
	output wire x;

	not (x, a);

endmodule // dmg_not4

module dmg_not6 (  a, x);

	input wire a;
	output wire x;

	not (x, a);

endmodule // dmg_not6

// not4+not6
// Used as compound cell in the clkgen module
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

	assign x = ena == 1'b1 ? ~x : 1'bz;

endmodule // dmg_notif1

module dmg_oai (  a0, a1, b, x);

	input wire a0;
	input wire a1;
	input wire b;
	output wire x;

	assign x = ~((a0 | a1) & b);

endmodule // dmg_oai

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

module dmg_or4 (  a, b, c, d, x);

	input wire a;
	input wire b;
	input wire c;
	input wire d;
	output wire x;

	or (x, a, b, c, d);

endmodule // dmg_or4

module dmg_xnor (  x, a, b);

	output wire x;
	input wire a;
	input wire b;

	xnor (x, a, b);

endmodule // dmg_xnor

module dmg_xor (  a, b, x);

	input wire a;
	input wire b;
	output wire x;

	xor (x, a, b);

endmodule // dmg_xor