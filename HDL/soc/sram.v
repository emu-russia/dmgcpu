// Common elements of DMG static memory (SRAM)

module sram_bit_lane (  oe, n_oe, n_pch, db, wr, col, n_BL, BL);

	input wire oe;
	input wire n_oe;
	input wire n_pch;
	inout wire db;
	input wire wr;
	input wire [3:0] col;
	inout wire [3:0] n_BL;
	inout wire [3:0] BL;

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
	wire w12;
	wire w13;
	wire w14;
	wire w15;
	wire w16;
	wire w17;
	wire w18;
	wire w19;
	wire w20;
	wire w21;
	wire w22;
	wire w23;
	wire w24;
	wire w25;
	wire w26;

	assign w3 = oe;
	assign w1 = n_oe;
	assign w26 = n_pch;
	assign db = w4;
	assign w8 = wr;
	assign w10 = col[0];
	assign w11 = col[1];
	assign w12 = col[2];
	assign w13 = col[3];
	assign n_BL[0] = w14;
	assign BL[0] = w15;
	assign BL[1] = w16;
	assign n_BL[1] = w17;
	assign n_BL[2] = w18;
	assign BL[2] = w19;
	assign BL[3] = w20;
	assign n_BL[3] = w21;

	// Instances

	col_bidir_mux g1 (.n_bit(w24), .bit(w25), .c[3](w13), .c[2](w12), .c[1](w11), .c[0](w10), .nb[0](w14), .b[0](w15), .b[1](w16), .nb[1](w17), .nb[2](w18), .b[2](w19), .b[3](w20), .nb[3](w21) );
	dmg_nand g2 (.a(w8), .b(w7), .x(w9) );
	dmg_not g3 (.x(w7), .a(w4) );
	dmg_nand g4 (.a(w4), .b(w8), .x(w6) );
	dmg_not g5 (.a(w6), .x(w23) );
	dmg_not g6 (.a(w9), .x(w22) );
	dmg_nor g7 (.a(w2), .b(w24), .x(w5) );
	dmg_nor g8 (.a(w25), .b(w5), .x(w2) );
	inv_tris_comp g9 (.in(w2), .q(w4), .ena(w3), .n_ena(w1) );
	sense_amp_kinda g10 (.n_bl(w24), .bl(w25), .d(w23), .nd(w22) );
	pch g11 (.n_en(w26), .q(w24) );
	pch g12 (.n_en(w26), .q(w25) );
endmodule // sram_bit_lane

// Module Definitions [It is possible to wrap here on your primitives]

module col_bidir_mux (  n_bit, bit, c[3], c[2], c[1], c[0], nb[0], b[0], b[1], nb[1], nb[2], b[2], b[3], nb[3]);

	inout wire n_bit;
	inout wire bit;
	input wire c[3];
	input wire c[2];
	input wire c[1];
	input wire c[0];
	inout wire nb[0];
	inout wire b[0];
	inout wire b[1];
	inout wire nb[1];
	inout wire nb[2];
	inout wire b[2];
	inout wire b[3];
	inout wire nb[3];

	// b/nb <=> bit/n_bit controlled by c.

	assign bit   = c[0] ? b[0] : 1'bz;
	assign n_bit = c[0] ? nb[0] : 1'bz;
	assign bit   = c[1] ? b[1] : 1'bz;
	assign n_bit = c[1] ? nb[1] : 1'bz;
	assign bit   = c[2] ? b[2] : 1'bz;
	assign n_bit = c[2] ? nb[2] : 1'bz;
	assign bit   = c[3] ? b[3] : 1'bz;
	assign n_bit = c[3] ? nb[3] : 1'bz;	

endmodule // col_bidir_mux

module inv_tris_comp (  in, q, ena, n_ena);

	input wire in;
	output wire q;
	input wire ena;
	input wire n_ena; 		// not used here

	assign q = ena ? ~in : 1'bz;

endmodule // inv_tris_comp

module sense_amp_kinda (  n_bl, bl, d, nd);

	output wire n_bl;
	output wire bl;
	input wire q;
	input wire nq;

	assign bl = ~nd;
	assign n_bl = ~d;

endmodule // sense_amp_kinda

module pch (  n_en, q);

	input wire n_en;
	output wire q;

	assign q = n_en ? 1'bz : 1'b1;

endmodule // pch



// ERROR: conflicting wire w24
// ERROR: conflicting wire w25


module sram_array (  n_pch, n_BL, BL, WL);

	input wire n_pch;
	inout wire [3:0]n_BL;
	inout wire [3:0]BL;
	input wire [31:0]WL;

	// TBD.

endmodule // sram_array

module sram_row_decode (  n_wl_pch, wl_ena, d, nd, x);

	input wire n_wl_pch;
	input wire wl_ena;
	input wire [4:0]d;
	input wire [4:0]nd;
	output wire [31:0]x;

	// TBD.

endmodule // sram_row_decode
