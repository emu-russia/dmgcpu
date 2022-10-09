
module Sequencer ( CLK1, CLK2, CLK4, CLK6, CLK8, CLK9, nCLK4, IR, a, d, w, x, ALU_Out1, 
	Unbonded, LongDescr, XCK_Ena, RESET, SYNC_RESET, Clock_WTF, WAKE, RD, Maybe1, MMIO_REQ, IPL_REQ, Maybe2, MREQ,
	SeqControl_1, SeqControl_2, SeqOut_1, SeqOut_2, SeqOut_3 );

	input CLK1;
	input CLK2;
	input CLK4;
	input CLK6;
	input CLK8;
	input CLK9;
	input nCLK4;

	input [7:0] IR;
	output [25:0] a;
	input [106:0] d;
	input [40:0] w;
	input [68:0] x;
	input ALU_Out1;

	input Unbonded;
	output LongDescr;
	output XCK_Ena;
	input RESET;
	input SYNC_RESET;
	input Clock_WTF;
	input WAKE;
	output RD;
	input Maybe1;
	input MMIO_REQ;
	input IPL_REQ;
	input Maybe2;
	output MREQ;

	input SeqControl_1;
	input SeqControl_2;
	output SeqOut_1;
	output SeqOut_2;
	output SeqOut_3;

	// Automagically generated from seq.xmlz by GetVerilog exe (https://github.com/emu-russia/Deroute/tree/main/UserScripts)

	assign w1 = d[102];
	assign w2 = w[26];
	assign w4 = x[41];
	assign w38 = Unbonded;
	assign w10 = Maybe1;
	assign w34 = MMIO_REQ;
	assign w35 = IPL_REQ;
	assign w36 = Maybe2;
	assign MREQ = w12;
	assign SeqOut_1 = w6;
	assign w7 = CLK8;
	assign SeqOut_2 = w8;
	assign RD = w9;
	assign w11 = w[11];
	assign SeqOut_3 = w13;
	assign w16 = SYNC_RESET;
	assign w20 = CLK4;
	assign w22 = w[18];
	assign w25 = WAKE;
	assign XCK_Ena = w31;
	assign a[0] = w47;
	assign a[1] = w46;
	assign a[2] = w48;
	assign a[3] = w49;
	assign a[4] = w51;
	assign a[5] = w37;
	assign a[6] = w52;
	assign a[7] = w40;
	assign a[8] = w53;
	assign a[9] = w41;
	assign a[10] = w54;
	assign a[11] = extra_IR4;
	assign a[12] = w55;
	assign a[13] = extra_IR3;
	assign a[14] = w56;
	assign a[15] = w43;
	assign a[16] = w57;
	assign a[17] = w44;
	assign a[18] = w58;
	assign a[19] = w45;
	assign a[20] = w59;
	assign a[21] = w60;
	assign a[22] = w61;
	assign a[23] = w62;
	assign a[24] = w63;
	assign a[25] = w64;
	assign w37 = IR[7];
	assign w40 = IR[6];
	assign w41 = IR[5];
	assign extra_IR4 = IR[4];
	assign extra_IR3 = IR[3];
	assign w43 = IR[2];
	assign w44 = IR[1];
	assign w45 = IR[0];
	assign LongDescr = nIR4_out;
	assign w71 = SeqControl_2;
	assign w111 = SeqControl_1;
	assign w78 = d[99];
	assign w90 = d[93];
	assign w3 = CLK9;
	assign w99 = w[32];
	assign w100 = w[33];
	assign w103 = w[20];
	assign w106 = d[100];
	assign w107 = RESET;
	assign w110 = CLK2;
	assign w109 = CLK1;
	assign w117 = Clock_WTF;
	assign w131 = d[101];
	assign w135 = w[40];
	assign w137 = CLK6;
	assign w139 = ALU_Out1;
	assign w21 = nCLK4;

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
	wire extra_IR4;
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
	wire extra_IR3;
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
	wire nIR4_out;
	wire w66;
	wire w67;
	wire w68;
	wire w69;
	wire w70;
	wire w71;
	wire w72;
	wire w73;
	wire w74;
	wire w75;
	wire w76;
	wire w77;
	wire w78;
	wire w79;
	wire w80;
	wire w81;
	wire w82;
	wire w83;
	wire w84;
	wire w85;
	wire w86;
	wire w87;
	wire w88;
	wire w89;
	wire w90;
	wire w91;
	wire w92;
	wire w93;
	wire w94;
	wire w95;
	wire w96;
	wire w97;
	wire w98;
	wire w99;
	wire w100;
	wire w101;
	wire w102;
	wire w103;
	wire w104;
	wire w105;
	wire w106;
	wire w107;
	wire w108;
	wire w109;
	wire w110;
	wire w111;
	wire w112;
	wire w113;
	wire w114;
	wire w115;
	wire w116;
	wire w117;
	wire w118;
	wire w119;
	wire w120;
	wire w121;
	wire w122;
	wire w123;
	wire w124;
	wire w125;
	wire w126;
	wire w127;
	wire w128;
	wire w129;
	wire w130;
	wire w131;
	wire w132;
	wire w133;
	wire w134;
	wire w135;
	wire w136;
	wire w137;
	wire w138;
	wire w139;

	// Instances

	seq_shielded g72 (.d(w11), .b(w35), .a(w34), .c(w36), .x(w33) );
	seq_module3 g38 (.q(w8), .clk(w7), .cclk(w3), .d(w135) );
	seq_not g66 (.a(w16), .x(w15) );
	seq_nor3 g50 (.a(extra_IR4), .b(w16), .c(1'b0), .x(w17) );
	seq_not g27 (.a(w24), .x(w9) );
	seq_not g73 (.a(w33), .x(w12) );
	seq_nor g97 (.a(w16), .b(w107), .x(w14) );
	seq_not g96 (.a(w14), .x(w26) );
	seq_hmm2 g39 (.a0(w19), .a1(w2), .x(w134), .b(w18), .a2(w20) );
	seq_not g51 (.a(w17), .x(w18) );
	seq_not g41 (.a(w1), .x(w19) );
	seq_not g40 (.a(w134), .x(w70) );
	seq_nor g25 (.b(w21), .a(w10), .x(w23) );
	seq_hmm1 g26 (.a1(w22), .b(w23), .x(w24), .a0(w2) );
	seq_nor g60 (.a(w25), .b(w26), .x(w29) );
	seq_iwantsleep g43 (.b(w14), .a1(w113), .a0(w112), .x(w27) );
	seq_module4_2 g49 (.q(extra_IR4), .s(w27), .nr(w121) );
	seq_module4 g62 (.nr(w29), .s(w108), .q(w30) );
	seq_not g61 (.a(w30), .x(w31) );
	seq_module3 g37 (.clk(w7), .cclk(w3), .d(w94), .q(w95) );
	seq_module3 g36 (.clk(w7), .cclk(w3), .d(w102), .q(w136) );
	seq_module3 g35 (.clk(w7), .cclk(w3), .q(w93), .d(w98) );
	seq_huge1 g33 (.q(w123), .d(w1), .res(extra_IR4), .clk(w137), .cclk(w138), .ld(w2), .nld(w122) );
	seq_module3 g42 (.cclk(w3), .clk(w7), .d(w111), .q(w112) );
	seq_module3 g46 (.clk(w7), .cclk(w3), .d(w106), .q(w119) );
	seq_module3 g54 (.clk(w7), .cclk(w3), .d(w39), .q(w89) );
	seq_module3 g57 (.clk(w7), .cclk(w3), .d(w116), .q(w114) );
	seq_module3 g58 (.clk(w7), .cclk(w3), .d(w118), .q(w116) );
	seq_module3 g63 (.clk(w7), .cclk(w3), .d(w133), .q(w108) );
	seq_module3 g67 (.clk(w7), .cclk(w3), .d(w5), .q(w6) );
	seq_module3 g74 (.clk(w7), .cclk(w3), .d(w130), .q(w125) );
	seq_module3 g84 (.clk(w110), .cclk(w109), .d(w73), .q(w82) );
	seq_module3 g85 (.clk(w7), .cclk(w3), .d(w74), .q(w67) );
	seq_not g0 (.a(w46), .x(w47) );
	seq_not g1 (.a(w105), .x(w46) );
	seq_not g2 (.a(w37), .x(w51) );
	seq_not g3 (.a(w40), .x(w52) );
	seq_not g4 (.a(w41), .x(w53) );
	seq_not g5 (.a(extra_IR4), .x(w54) );
	seq_not g6 (.a(extra_IR3), .x(w55) );
	seq_not g7 (.a(w43), .x(w56) );
	seq_not g8 (.a(w44), .x(w57) );
	seq_not g9 (.a(w45), .x(w58) );
	seq_not g10 (.a(w50), .x(w49) );
	seq_not g11 (.a(w49), .x(w48) );
	seq_not g12 (.a(w93), .x(w59) );
	seq_not g13 (.a(w59), .x(w60) );
	seq_not g14 (.a(w136), .x(w61) );
	seq_not g15 (.a(w61), .x(w62) );
	seq_not g16 (.a(w95), .x(w63) );
	seq_not g17 (.a(w63), .x(w64) );
	seq_not g18 (.a(w99), .x(w97) );
	seq_not g20 (.a(w100), .x(w101) );
	seq_not g22 (.a(w103), .x(w104) );
	seq_nand g23 (.b(w96), .a(w104), .x(w94) );
	seq_nand g21 (.b(w96), .a(w101), .x(w102) );
	seq_nand g19 (.a(w97), .b(w96), .x(w98) );
	seq_aoi_1 g30 (.b(1'b0), .a0(w124), .a1(w123), .x(w50) );
	seq_nor3 g28 (.a(w125), .b(w18), .x(w105), .c(1'b0) );
	seq_not g29 (.a(w60), .x(w124) );
	seq_not g31 (.a(extra_IR4), .x(nIR4_out) );
	seq_not g32 (.a(w137), .x(w138) );
	seq_not g34 (.a(w2), .x(w122) );
	seq_not g44 (.a(w114), .x(w115) );
	seq_not g48 (.a(w120), .x(w121) );
	seq_not g53 (.a(w38), .x(w39) );
	seq_not g93 (.a(w77), .x(w76) );
	seq_not g86 (.a(w5), .x(w81) );
	seq_not g81 (.a(w86), .x(w85) );
	seq_not g75 (.a(w129), .x(w130) );
	seq_not g69 (.a(w69), .x(w92) );
	seq_not g64 (.a(w132), .x(w133) );
	seq_nand g59 (.a(w15), .b(w117), .x(w118) );
	seq_nand g65 (.a(extra_IR4), .b(w131), .x(w132) );
	seq_nand3 g70 (.a(w70), .b(w67), .c(w68), .x(w69) );
	seq_nor g76 (.a(w5), .b(w128), .x(w129) );
	seq_nor g78 (.a(w90), .b(w16), .x(w127) );
	seq_nand g79 (.a(w70), .b(w71), .x(w84) );
	seq_nand g80 (.a(w66), .b(w78), .x(w86) );
	seq_not g82 (.a(w20), .x(w83) );
	seq_nor4 g83 (.a(w85), .b(w84), .c(w83), .d(w82), .x(w126) );
	seq_nor g87 (.b(w4), .a(w16), .x(w80) );
	seq_nand g90 (.a(w74), .b(w72), .x(w73) );
	seq_not g95 (.a(extra_IR3), .x(w66) );
	seq_not g88 (.a(w80), .x(w79) );
	seq_nor3 g47 (.a(w119), .b(w108), .c(w107), .x(w120) );
	seq_nor g45 (.a(w115), .b(w116), .x(w113) );
	seq_aoi_2 g52 (.a0(w6), .a1(w90), .b(w16), .x(w91) );
	seq_nor g24 (.x(w96), .a(w139), .b(w18) );
	seq_nor g56 (.a(w88), .b(w39), .x(w87) );
	seq_hmm3 g55 (.cclk(w3), .clk(w7), .d(w89), .nq(w88) );
	seq_module4 g71 (.q(w68), .nr(w91), .s(w87) );
	seq_module4 g77 (.nr(w127), .s(w126), .q(w128) );
	seq_module4 g89 (.nr(w81), .s(w79), .q(w74) );
	seq_module4 g92 (.nr(w75), .s(w76), .q(w72) );
	seq_comb5 g94 (.clk(w20), .a0(w67), .a1(w4), .b0(w78), .b1(extra_IR3), .x(w77) );
	seq_comb4 g91 (.clk(w20), .c(w16), .a0(w125), .a1(w67), .b0(w78), .b1(w66), .x(w75) );
	seq_module4 g68 (.q(w5), .nr(w91), .s(w92) );

endmodule // seq

// Module Definitions [It is possible to wrap here on your primitives]

module seq_shielded (  d, b, a, c, x);

	input wire d;
	input wire b;
	input wire a;
	input wire c;
	output wire x;

endmodule // seq_shielded

module seq_module3 (  q, clk, cclk, d);

	output wire q;
	input wire clk;
	input wire cclk;
	input wire d;

endmodule // seq_module3

module seq_not (  a, x);

	input wire a;
	output wire x;

endmodule // seq_not

module seq_nor3 (  a, b, c, x);

	input wire a;
	input wire b;
	input wire c;
	output wire x;

endmodule // seq_nor3

module seq_nor (  a, b, x);

	input wire a;
	input wire b;
	output wire x;

endmodule // seq_nor

module seq_hmm2 (  a0, a1, x, b, a2);

	input wire a0;
	input wire a1;
	output wire x;
	input wire b;
	input wire a2;

endmodule // seq_hmm2

module seq_hmm1 (  a1, b, x, a0);

	input wire a1;
	input wire b;
	output wire x;
	input wire a0;

endmodule // seq_hmm1

module seq_iwantsleep (  b, a1, a0, x);

	input wire b;
	input wire a1;
	input wire a0;
	output wire x;

endmodule // seq_iwantsleep

module seq_module4_2 (  q, s, nr);

	output wire q;
	input wire s;
	input wire nr;

endmodule // seq_module4_2

module seq_module4 (  nr, s, q);

	input wire nr;
	input wire s;
	output wire q;

endmodule // seq_module4

module seq_huge1 (  q, d, res, clk, cclk, ld, nld);

	output wire q;
	input wire d;
	input wire res;
	input wire clk;
	input wire cclk;
	input wire ld;
	input wire nld;

endmodule // seq_huge1

module seq_nand (  b, a, x);

	input wire b;
	input wire a;
	output wire x;

endmodule // seq_nand

module seq_aoi_1 (  b, a0, a1, x);

	input wire b;
	input wire a0;
	input wire a1;
	output wire x;

endmodule // seq_aoi_1

module seq_nand3 (  a, b, c, x);

	input wire a;
	input wire b;
	input wire c;
	output wire x;

endmodule // seq_nand3

module seq_nor4 (  a, b, c, d, x);

	input wire a;
	input wire b;
	input wire c;
	input wire d;
	output wire x;

endmodule // seq_nor4

module seq_aoi_2 (  a0, a1, b, x);

	input wire a0;
	input wire a1;
	input wire b;
	output wire x;

endmodule // seq_aoi_2

module seq_hmm3 (  cclk, clk, d, nq);

	input wire cclk;
	input wire clk;
	input wire d;
	output wire nq;

endmodule // seq_hmm3

module seq_comb5 (  clk, a0, a1, b0, b1, x);

	input wire clk;
	input wire a0;
	input wire a1;
	input wire b0;
	input wire b1;
	output wire x;

endmodule // seq_comb5

module seq_comb4 (  clk, c, a0, a1, b0, b1, x);

	input wire clk;
	input wire c;
	input wire a0;
	input wire a1;
	input wire b0;
	input wire b1;
	output wire x;

endmodule // seq_comb4
