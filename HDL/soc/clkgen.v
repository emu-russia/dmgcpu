module ClkGen (  clk8, clk7, clk6, clk5, clk4, clk3, clk2, clk1, cclk, clk9, n_reset2, clk_ena, osc_ena, cpu_wr, test_1, cpu_mreq, reset, osc_stable, n_test_reset, n_clk_in, sync_reset, ext_cs_en, cpu_wr_sync);

	output wire clk8;
	output wire clk7;
	output wire clk6;
	output wire clk5;
	output wire clk4;
	output wire clk3;
	output wire clk2;
	output wire clk1;
	output wire cclk;
	output wire clk9;
	output wire n_reset2;
	input wire clk_ena;
	input wire osc_ena;
	input wire cpu_wr;
	input wire test_1;
	input wire cpu_mreq;
	input wire reset;
	input wire osc_stable;
	input wire n_test_reset;
	input wire n_clk_in;
	output wire sync_reset;
	output wire ext_cs_en;
	output wire cpu_wr_sync;

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
	wire w27;
	wire w28;
	wire w29;
	wire w30;
	wire w31;
	wire w32;
	wire w33;
	wire w34;
	wire w35;
	wire w36;
	wire w37;
	wire w38;
	wire w39;
	wire w40;
	wire w41;
	wire w42;
	wire w43;
	wire w44;
	wire w45;
	wire w46;
	wire w47;
	wire w48;
	wire w49;
	wire w50;
	wire w51;
	wire w52;
	wire w53;
	wire w54;
	wire w55;
	wire w56;
	wire w57;
	wire w58;
	wire w59;
	wire w60;
	wire w61;
	wire w62;
	wire w63;
	wire w64;
	wire w65;
	wire w66;
	wire w67;
	wire w68;

	assign clk8 = w11;
	assign clk7 = w35;
	assign clk6 = w29;
	assign clk5 = w30;
	assign clk4 = w31;
	assign clk3 = w24;
	assign clk2 = w25;
	assign clk1 = w26;
	assign cclk = w61;
	assign clk9 = w10;
	assign n_reset2 = w15;
	assign w16 = clk_ena;
	assign w17 = osc_ena;
	assign w20 = cpu_wr;
	assign w55 = test_1;
	assign w67 = cpu_mreq;
	assign w45 = reset;
	assign w48 = osc_stable;
	assign w49 = n_test_reset;
	assign w2 = n_clk_in;
	assign sync_reset = w68;
	assign ext_cs_en = w54;
	assign cpu_wr_sync = w19;

	// Instances

	dmg_not g1 (.a(w16), .x(w43) );
	dmg_not g2 (.a(w17), .x(w52) );
	dmg_not3 g3 (.a(w18), .x(w19) );
	dmg_not3 g4 (.a(w53), .x(w54) );
	dmg_not g5 (.a(w22), .x(w66) );
	dmg_not2 g6 (.a(w14), .x(w15) );
	dmg_not g7 (.a(w48), .x(w47) );
	dmg_not g8 (.a(w7), .x(w8) );
	dmg_not g9 (.a(w58), .x(w57) );
	dmg_not g10 (.a(w50), .x(w51) );
	dmg_not g11 (.a(w59), .x(w22) );
	dmg_not g12 (.a(w5), .x(w6) );
	dmg_not2 g13 (.a(w1), .x(w5) );
	dmg_not g14 (.a(w2), .x(w3) );
	dmg_not6 g15 (.a(w5), .x(w61) );
	dmg_not g16 (.a(w43), .x(w27) );
	dmg_not g17 (.a(w28), .x(w44) );
	dmg_not6 g18 (.a(w25), .x(w26) );
	dmg_not6 g19 (.a(w44), .x(w25) );
	dmg_not2 g20 (.a(w23), .x(w32) );
	dmg_not10 g21 (.a(w31), .x(w24) );
	dmg_not10 g22 (.a(w32), .x(w31) );
	dmg_not2 g23 (.a(w33), .x(w34) );
	dmg_not10 g24 (.a(w29), .x(w30) );
	dmg_not10 g25 (.a(w34), .x(w29) );
	dmg_not g26 (.a(w51), .x(w65) );
	dmg_not g27 (.a(w63), .x(w64) );
	dmg_not6 g28 (.a(w64), .x(w35) );
	dmg_not g29 (.a(w36), .x(w37) );
	dmg_not g30 (.a(w37), .x(w38) );
	dmg_not g31 (.a(w38), .x(w39) );
	dmg_not g32 (.a(w40), .x(w41) );
	dmg_not g33 (.a(w42), .x(w12) );
	dmg_not6 g34 (.a(w12), .x(w10) );
	dmg_not6 g35 (.a(w10), .x(w11) );
	dmg_or g36 (.a(w41), .b(w52), .x(w42) );
	dmg_nand3 g37 (.a(w51), .b(w22), .c(w39), .x(w40) );
	dmg_nand4 g38 (.a(w30), .b(w30), .c(w24), .d(w24), .x(w36) );
	dmg_nor3 g39 (.a(w65), .b(w57), .c(w43), .x(w63) );
	dmg_nor3 g40 (.a(w43), .b(w57), .c(w22), .x(w33) );
	dmg_nor g41 (.a(w22), .b(w43), .x(w23) );
	dmg_and g42 (.a(w12), .b(w27), .x(w28) );
	dmg_nand g43 (.a(w4), .b(w3), .x(w1) );
	dmg_nand g44 (.a(w2), .b(w1), .x(w4) );
	dmg_nor g45 (.a(w45), .b(w47), .x(w46) );
	dmg_or g46 (.a(w68), .b(w13), .x(w14) );
	dmg_oan g47 (.a0(w57), .a1(w66), .b(w67), .x(w56) );
	dmg_nor g48 (.a(w55), .b(w56), .x(w53) );
	dmg_nor g49 (.a(w8), .b(w22), .x(w21) );
	dmg_nand g50 (.a(w21), .b(w20), .x(w18) );
	dmg_nor_latch g51 (.s(w46), .r(w45), .nq(w13) );
	dmg_dffrnq_comp g52 (.nr1(w49), .d(w13), .ck(w10), .cck(w11), .nr2(w49), .q(w68) );
	dmg_dffrnq_comp g53 (.nr1(w49), .d(w9), .ck(w6), .cck(w5), .nr2(w49), .nq(w62), .q(w7) );
	dmg_dffrnq_comp g54 (.nr1(w49), .d(w50), .ck(w5), .cck(w6), .nr2(w49), .nq(w58), .q(w9) );
	dmg_dffrnq_comp g55 (.nr1(w49), .d(w60), .ck(w6), .cck(w5), .nr2(w49), .q(w50) );
	dmg_dffrnq_comp g56 (.nr1(w49), .d(w62), .ck(w5), .cck(w6), .nr2(w49), .nq(w59), .q(w60) );
endmodule // ClkGen