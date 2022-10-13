
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
	output LongDescr;		// CLK_ENA
	output XCK_Ena;			// OSC_ENA
	input RESET;			// From Reset pad
	input SYNC_RESET;
	input Clock_WTF;		// OSC_STABLE
	input WAKE;
	output RD;
	input Maybe1;			// aka DL_Control1
	input MMIO_REQ;
	input IPL_REQ;
	input Maybe2; 			// See shielded module.
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
	assign SeqOut_3 = 1'b0;
	assign w16 = SYNC_RESET;
	assign w20 = CLK4;
	assign w22 = w[18];
	assign w25 = WAKE;
	assign XCK_Ena = w31;
	assign a[0] = w48;
	assign a[1] = w47;
	assign a[2] = w49;
	assign a[3] = w50;
	assign a[4] = w52;
	assign a[5] = w37;
	assign a[6] = w53;
	assign a[7] = w40;
	assign a[8] = w54;
	assign a[9] = w41;
	assign a[10] = w55;
	assign a[11] = extra_IR4;
	assign a[12] = w56;
	assign a[13] = extra_IR3;
	assign a[14] = w57;
	assign a[15] = w44;
	assign a[16] = w58;
	assign a[17] = w45;
	assign a[18] = w59;
	assign a[19] = w46;
	assign a[20] = w60;
	assign a[21] = w61;
	assign a[22] = w62;
	assign a[23] = w63;
	assign a[24] = w64;
	assign a[25] = w65;
	assign w37 = IR[7];
	assign w40 = IR[6];
	assign w41 = IR[5];
	assign extra_IR4 = IR[4];
	assign extra_IR3 = IR[3];
	assign w44 = IR[2];
	assign w45 = IR[1];
	assign w46 = IR[0];
	assign LongDescr = w66;
	assign w72 = SeqControl_2;
	assign w112 = SeqControl_1;
	assign w79 = d[99];
	assign w91 = d[93];
	assign w3 = CLK9;
	assign w100 = w[32];
	assign w101 = w[33];
	assign w104 = w[20];
	assign w107 = d[100];
	assign w108 = RESET;
	assign w111 = CLK2;
	assign w110 = CLK1;
	assign w118 = Clock_WTF;
	assign w132 = d[101];
	assign w136 = w[40];
	assign w138 = CLK6;
	assign w140 = ALU_Out1;
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
	wire extra_IR4;
	wire extra_IR3;
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
	wire w140;

	// Instances

	seq_shielded g72 (.d(w11), .b(w35), .a(w34), .c(w36), .x(w33) );
	seq_module3 g38 (.q(w8), .clk(w7), .cclk(w3), .d(w136) );
	seq_not g66 (.a(w16), .x(w15) );
	seq_nor3 g50 (.a(w28), .b(w16), .c(1'b0), .x(w17) );
	seq_not g27 (.a(w24), .x(w9) );
	seq_not g73 (.a(w33), .x(w12) );
	seq_nor g97 (.a(w16), .b(w108), .x(w14) );
	seq_not g96 (.a(w14), .x(w26) );
	seq_hmm2 g39 (.a0(w19), .a1(w2), .x(w135), .b(w18), .a2(w20) );
	seq_not g51 (.a(w17), .x(w18) );
	seq_not g41 (.a(w1), .x(w19) );
	seq_not g40 (.a(w135), .x(w71) );
	seq_nor g25 (.b(w21), .a(w10), .x(w23) );
	seq_hmm1 g26 (.a1(w22), .b(w23), .x(w24), .a0(w2) );
	seq_nor g60 (.a(w25), .b(w26), .x(w29) );
	seq_iwantsleep g43 (.b(w14), .a1(w114), .a0(w113), .x(w27) );
	seq_module4_2 g49 (.q(w28), .s(w27), .nr(w122) );
	seq_module4 g62 (.nr(w29), .s(w109), .q(w30) );
	seq_not g61 (.a(w30), .x(w31) );
	seq_module3 g37 (.clk(w7), .cclk(w3), .d(w95), .q(w96) );
	seq_module3 g36 (.clk(w7), .cclk(w3), .d(w103), .q(w137) );
	seq_module3 g35 (.clk(w7), .cclk(w3), .q(w94), .d(w99) );
	seq_huge1 g33 (.q(w124), .d(w1), .res(w28), .clk(w138), .cclk(w139), .ld(w2), .nld(w123) );
	seq_module3 g42 (.cclk(w3), .clk(w7), .d(w112), .q(w113) );
	seq_module3 g46 (.clk(w7), .cclk(w3), .d(w107), .q(w120) );
	seq_module3 g54 (.clk(w7), .cclk(w3), .d(w39), .q(w90) );
	seq_module3 g57 (.clk(w7), .cclk(w3), .d(w117), .q(w115) );
	seq_module3 g58 (.clk(w7), .cclk(w3), .d(w119), .q(w117) );
	seq_module3 g63 (.clk(w7), .cclk(w3), .d(w134), .q(w109) );
	seq_module3 g67 (.clk(w7), .cclk(w3), .d(w5), .q(w6) );
	seq_module3 g74 (.clk(w7), .cclk(w3), .d(w131), .q(w126) );
	seq_module3 g84 (.clk(w111), .cclk(w110), .d(w74), .q(w83) );
	seq_module3 g85 (.clk(w7), .cclk(w3), .d(w75), .q(w68) );
	seq_not g0 (.a(w47), .x(w48) );
	seq_not g1 (.a(w106), .x(w47) );
	seq_not g2 (.a(w37), .x(w52) );
	seq_not g3 (.a(w40), .x(w53) );
	seq_not g4 (.a(w41), .x(w54) );
	seq_not g5 (.a(extra_IR4), .x(w55) );
	seq_not g6 (.a(extra_IR3), .x(w56) );
	seq_not g7 (.a(w44), .x(w57) );
	seq_not g8 (.a(w45), .x(w58) );
	seq_not g9 (.a(w46), .x(w59) );
	seq_not g10 (.a(w51), .x(w50) );
	seq_not g11 (.a(w50), .x(w49) );
	seq_not g12 (.a(w94), .x(w60) );
	seq_not g13 (.a(w60), .x(w61) );
	seq_not g14 (.a(w137), .x(w62) );
	seq_not g15 (.a(w62), .x(w63) );
	seq_not g16 (.a(w96), .x(w64) );
	seq_not g17 (.a(w64), .x(w65) );
	seq_not g18 (.a(w100), .x(w98) );
	seq_not g20 (.a(w101), .x(w102) );
	seq_not g22 (.a(w104), .x(w105) );
	seq_nand g23 (.b(w97), .a(w105), .x(w95) );
	seq_nand g21 (.b(w97), .a(w102), .x(w103) );
	seq_nand g19 (.a(w98), .b(w97), .x(w99) );
	seq_aoi_1 g30 (.b(1'b0), .a0(w125), .a1(w124), .x(w51) );
	seq_nor3 g28 (.a(w126), .b(w18), .x(w106), .c(1'b0) );
	seq_not g29 (.a(w61), .x(w125) );
	seq_not g31 (.a(w28), .x(w66) );
	seq_not g32 (.a(w138), .x(w139) );
	seq_not g34 (.a(w2), .x(w123) );
	seq_not g44 (.a(w115), .x(w116) );
	seq_not g48 (.a(w121), .x(w122) );
	seq_not g53 (.a(w38), .x(w39) );
	seq_not g93 (.a(w78), .x(w77) );
	seq_not g86 (.a(w5), .x(w82) );
	seq_not g81 (.a(w87), .x(w86) );
	seq_not g75 (.a(w130), .x(w131) );
	seq_not g69 (.a(w70), .x(w93) );
	seq_not g64 (.a(w133), .x(w134) );
	seq_nand g59 (.a(w15), .b(w118), .x(w119) );
	seq_nand g65 (.a(extra_IR4), .b(w132), .x(w133) );
	seq_nand3 g70 (.a(w71), .b(w68), .c(w69), .x(w70) );
	seq_nor g76 (.a(w5), .b(w129), .x(w130) );
	seq_nor g78 (.a(w91), .b(w16), .x(w128) );
	seq_nand g79 (.a(w71), .b(w72), .x(w85) );
	seq_nand g80 (.a(w67), .b(w79), .x(w87) );
	seq_not g82 (.a(w20), .x(w84) );
	seq_nor4 g83 (.a(w86), .b(w85), .c(w84), .d(w83), .x(w127) );
	seq_nor g87 (.b(w4), .a(w16), .x(w81) );
	seq_nand g90 (.a(w75), .b(w73), .x(w74) );
	seq_not g95 (.a(extra_IR3), .x(w67) );
	seq_not g88 (.a(w81), .x(w80) );
	seq_nor3 g47 (.a(w120), .b(w109), .c(w108), .x(w121) );
	seq_nor g45 (.a(w116), .b(w117), .x(w114) );
	seq_aoi_2 g52 (.a0(w6), .a1(w91), .b(w16), .x(w92) );
	seq_nor g24 (.x(w97), .a(w140), .b(w18) );
	seq_nor g56 (.a(w89), .b(w39), .x(w88) );
	seq_hmm3 g55 (.cclk(w3), .clk(w7), .d(w90), .nq(w89) );
	seq_module4 g71 (.q(w69), .nr(w92), .s(w88) );
	seq_module4 g77 (.nr(w128), .s(w127), .q(w129) );
	seq_module4 g89 (.nr(w82), .s(w80), .q(w75) );
	seq_module4 g92 (.nr(w76), .s(w77), .q(w73) );
	seq_comb5 g94 (.clk(w20), .a0(w68), .a1(w4), .b0(w79), .b1(extra_IR3), .x(w78) );
	seq_comb4 g91 (.clk(w20), .c(w16), .a0(w126), .a1(w68), .b0(w79), .b1(w67), .x(w76) );
	seq_module4 g68 (.q(w5), .nr(w92), .s(w93) );

endmodule // seq

// Module Definitions [It is possible to wrap here on your primitives]

module seq_shielded ( a, b, c, d, x );

	input wire a;
	input wire b;	
	input wire c;
	input wire d;
	output wire x;

	assign x = d ? ~((~a & c) | ~(a|b)) : 1'b1;

endmodule // seq_shielded

module seq_module3 ( d, clk, cclk, q );

	input wire d;	
	input wire clk;
	input wire cclk;
	output wire q;

	reg val;
	initial val <= 1'b0;

	always @(posedge clk) begin
		val <= d;
	end

	assign q = val;

endmodule // seq_module3

module seq_not ( a, x );

	input wire a;
	output wire x;

	assign x = ~a;

endmodule // seq_not

module seq_nor3 ( a, b, c, x );

	input wire a;
	input wire b;
	input wire c;
	output wire x;

	assign x = ~(a|b|c);

endmodule // seq_nor3

module seq_nor ( a, b, x );

	input wire a;
	input wire b;
	output wire x;

	assign x = ~(a|b);

endmodule // seq_nor

module seq_hmm2 ( a0, a1, a2, b, x );

	input wire a0;
	input wire a1;
	input wire a2;
	input wire b;
	output wire x;

	assign x = ~( (a0&a1&a2) | b);

endmodule // seq_hmm2

module seq_hmm1 ( a0, a1, b, x );

	input wire a0;
	input wire a1;
	input wire b;
	output wire x;

	assign x = ~( (a0|a1) & b );

endmodule // seq_hmm1

module seq_iwantsleep ( a0, a1, b, x );

	input wire a0;	
	input wire a1;
	input wire b;	
	output wire x;

	assign x = ~( (a0|a1) & b );

endmodule // seq_iwantsleep

module seq_module4_2 ( nr, s, q );

	input wire nr;
	input wire s;
	output wire q;

	reg val;
	initial val <= 1'b0;

	always @(*) begin
		if (~nr)
			val <= 1'b0;
		if (s)
			val <= 1'b1;
	end

	assign q = val;

endmodule // seq_module4_2

module seq_module4 ( nr, s, q );

	input wire nr;
	input wire s;
	output wire q;

	reg val;
	initial val <= 1'b0;

	always @(*) begin
		if (~nr)
			val <= 1'b0;
		if (s)
			val <= 1'b1;
	end

	assign q = val;

endmodule // seq_module4

module seq_huge1 ( q, d, res, clk, cclk, ld, nld);

	output wire q;
	input wire d;
	input wire res;
	input wire clk;
	input wire cclk;
	input wire ld;
	input wire nld;

	reg val;
	initial val <= 1'b0;

	always @(*) begin
		if (clk & ld)
			val <= d;
		if (res)
			val <= 1'b0;
	end

	assign q = val;

endmodule // seq_huge1

module seq_nand ( a, b, x );
	
	input wire a;
	input wire b;
	output wire x;

	assign x = ~(a&b);

endmodule // seq_nand

module seq_aoi_1 ( a0, a1, b, x );

	input wire a0;
	input wire a1;
	input wire b;
	output wire x;

	assign x = ~( (a0&a1) | b);

endmodule // seq_aoi_1

module seq_nand3 ( a, b, c, x );

	input wire a;
	input wire b;
	input wire c;
	output wire x;

	assign x = ~(a&b&c);

endmodule // seq_nand3

module seq_nor4 ( a, b, c, d, x );

	input wire a;
	input wire b;
	input wire c;
	input wire d;
	output wire x;

	assign x = ~(a|b|c|d);

endmodule // seq_nor4

module seq_aoi_2 ( a0, a1, b, x );

	input wire a0;
	input wire a1;
	input wire b;
	output wire x;

	assign x = ~( (a0&a1) | b);

endmodule // seq_aoi_2

module seq_hmm3 ( d, clk, cclk, nq );

	input wire d;
	input wire clk;
	input wire cclk;
	output wire nq;

	reg val;
	initial val <= 1'b0;

	always @(*) begin
		if (clk)
			val <= d;
	end

	assign nq = ~val;

endmodule // seq_hmm3

module seq_comb5 ( clk, a0, a1, b0, b1, x );

	input wire clk;
	input wire a0;
	input wire a1;
	input wire b0;
	input wire b1;
	output wire x;

	assign x = clk ? ~( (a0&a1) | (b0&b1) ) : 1'b1;

endmodule // seq_comb5

module seq_comb4 ( clk, a0, a1, b0, b1, c, x );

	input wire clk;
	input wire a0;
	input wire a1;
	input wire b0;
	input wire b1;
	input wire c;
	output wire x;

	assign x = clk ? ~( (a0&a1) | (b0&b1) | c) : ~c;

endmodule // seq_comb4
