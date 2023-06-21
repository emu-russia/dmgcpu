// Elements of standard schematics ("kinda cells") used in the sequencer. Moved separately.

// Module Definitions [It is possible to wrap here on your primitives]

`timescale 1ns/1ns

// This module is essentially used to generate the #MREQ signal. Very cleverly twisted combined logic.
module seq_mreq ( a, b, c, d, x );

	input a;
	input b;	
	input c;
	input d;
	output x;

	assign x = d ? ~((~a & c) | ~(a|b)) : 1'b1;

endmodule // seq_mreq

// Regular posedge DFF (dual rails)
module seq_dff_posedge_comp ( d, clk, cclk, q );

	input d;	
	input clk;
	input cclk;
	output q;

	reg val;
	initial val = 1'bx;

	// XXX: Initially, clk and cclk were mixed up when parsing the netlist. So read here cclk as clk. Not a very nice mix-up, but this is always the case with clk.
	always @(posedge cclk) begin
		val <= d;
	end

	assign q = val;

endmodule // seq_dff_posedge_comp

module seq_not ( a, x );

	input a;
	output x;

	assign x = ~a;

endmodule // seq_not

module seq_nor3 ( a, b, c, x );

	input a;
	input b;
	input c;
	output x;

	assign x = ~(a|b|c);

endmodule // seq_nor3

module seq_nor ( a, b, x );

	input a;
	input b;
	output x;

	assign x = ~(a|b);

endmodule // seq_nor

module seq_aoi_31 ( a0, a1, a2, b, x );

	input a0;
	input a1;
	input a2;
	input b;
	output x;

	assign x = ~( (a0&a1&a2) | b);

endmodule // seq_aoi_31

module seq_oai_21 ( a0, a1, b, x );

	input a0;	
	input a1;
	input b;	
	output x;

	assign x = ~( (a0|a1) & b );

endmodule // seq_oai_21

// This is essentially the same rs_latch, but with the inputs rearranged.
module seq_rs_latch2 ( nr, s, q );

	input nr;
	input s;
	output q;

	reg val;
	// Let's lower the difficulty level and use 0 here instead of `x`.
	initial val = 1'b0;

	// The module design is such that reset overrides set if both are set at the same time.
	always @(*) begin
		if (~nr)
			val = 1'b0;
		else if (s)
			val = 1'b1;
	end

	assign q = val;

endmodule // seq_rs_latch2

// rs_latch
module seq_rs_latch ( nr, s, q );

	input nr;
	input s;
	output q;

	reg val;
	// Let's lower the difficulty level and use 0 here instead of `x`.
	initial val = 1'b0;

	// The module design is such that reset overrides set if both are set at the same time.
	always @(*) begin
		if (~nr)
			val = 1'b0;
		else if (s)
			val = 1'b1;
	end

	assign q = val;

endmodule // seq_rs_latch

module seq_latchr_comp ( q, d, res, clk, cclk, ld, nld);

	output q;
	input d;
	input res;
	input clk;
	input cclk;
	input ld;
	input nld;

	reg val_in;
	/* verilator lint_off UNOPTFLAT */
	reg val_out;
	initial val_in = 1'bx;
	initial val_out = 1'bx;

	always @(*) begin
		if (clk && ld)
			val_in = d;
		if (res)
			val_in = 1'b0;
	end

	always @(negedge ld) begin
		val_out <= val_in;
	end

	assign q = val_out;

endmodule // seq_latchr_comp

module seq_nand ( a, b, x );
	
	input a;
	input b;
	output x;

	assign x = ~(a&b);

endmodule // seq_nand

module seq_nand3 ( a, b, c, x );

	input a;
	input b;
	input c;
	output x;

	assign x = ~(a&b&c);

endmodule // seq_nand3

module seq_nor4 ( a, b, c, d, x );

	input a;
	input b;
	input c;
	input d;
	output x;

	assign x = ~(a|b|c|d);

endmodule // seq_nor4

module seq_aoi_21 ( a0, a1, b, x );

	input a0;
	input a1;
	input b;
	output x;

	assign x = ~( (a0&a1) | b);

endmodule // seq_aoi_21

// Regular transparent latch (dual rails)
module seq_latch_comp ( d, clk, cclk, nq );

	input d;
	input clk;
	input cclk;
	output nq;

	reg val;
	initial val = 1'b0;

	always @(*) begin
		if (clk)
			val = d;
	end

	assign nq = ~val;

endmodule // seq_latch_comp

module seq_aoi_22_dyn ( clk, a0, a1, b0, b1, x );

	input clk;
	input a0;
	input a1;
	input b0;
	input b1;
	output x;

	assign x = clk ? ~( (a0&a1) | (b0&b1) ) : 1'b1;

endmodule // seq_aoi_22_dyn

module seq_aoi_221_dyn ( clk, a0, a1, b0, b1, c, x );

	input clk;
	input a0;
	input a1;
	input b0;
	input b1;
	input c;
	output x;

	assign x = clk ? ~( (a0&a1) | (b0&b1) | c) : ~c;

endmodule // seq_aoi_221_dyn
