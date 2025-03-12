// Module Definitions [It is possible to wrap here on your primitives]

module dmg_not (  a, x);

	input wire a;
	output wire x;

endmodule // dmg_not

module dmg_not3 (  a, x);

	input wire a;
	output wire x;

endmodule // dmg_not3

module dmg_not2 (  a, x);

	input wire a;
	output wire x;

endmodule // dmg_not2

module dmg_not6 (  a, x);

	input wire a;
	output wire x;

endmodule // dmg_not6

module dmg_not10 (  a, x);

	input wire a;
	output wire x;

endmodule // dmg_not10

module dmg_or (  a, b, x);

	input wire a;
	input wire b;
	output wire x;

endmodule // dmg_or

module dmg_nand3 (  a, b, c, x);

	input wire a;
	input wire b;
	input wire c;
	output wire x;

endmodule // dmg_nand3

module dmg_nand4 (  a, b, c, d, x);

	input wire a;
	input wire b;
	input wire c;
	input wire d;
	output wire x;

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

endmodule // dmg_nand7

module dmg_nor3 (  a, b, c, x);

	input wire a;
	input wire b;
	input wire c;
	output wire x;

endmodule // dmg_nor3

module dmg_nor (  a, b, x);

	input wire a;
	input wire b;
	output wire x;

endmodule // dmg_nor

module dmg_and (  a, b, x);

	input wire a;
	input wire b;
	output wire x;

endmodule // dmg_and

module dmg_nand (  a, b, x);

	input wire a;
	input wire b;
	output wire x;

endmodule // dmg_nand

module dmg_oan (  a0, a1, b, x);

	input wire a0;
	input wire a1;
	input wire b;
	output wire x;

endmodule // dmg_oan

module dmg_nor_latch (  s, r, nq, q);

	input wire s;
	input wire r;
	output wire nq;
	output wire q;

endmodule // dmg_nor_latch

module dmg_dffrnq_comp (  nr1, d, ck, cck, nr2, nq, q);

	input wire nr1;
	input wire d;
	input wire ck;
	input wire cck;
	input wire nr2;
	output wire nq;
	output wire q;

endmodule // dmg_dffrnq_comp

module dmg_dffsr (  clk, nres, nset1, nset2, d, q, nq);

	input wire clk;
	input wire nres;
	input wire nset1;
	input wire nset2;
	input wire d;
	output wire q;
	output wire nq;

endmodule // dmg_dffsr

module dmg_notif1 (  ena, a, x);

	input wire ena;
	input wire a;
	output wire x;

endmodule // dmg_notif1

module dmg_dffr (  clk, nr1, nr2, d, q, nq);

	input wire clk;
	input wire nr1;
	input wire nr2;
	input wire d;
	output wire q;
	output wire nq;

endmodule // dmg_dffr

module dmg_muxi (  sel, d1, d0, q);

	input wire sel;
	input wire d1;
	input wire d0;
	output wire q;

endmodule // dmg_muxi

module dmgcpu_and3 (  a, b, c, x);

	input wire a;
	input wire b;
	input wire c;
	output wire x;

endmodule // dmgcpu_and3