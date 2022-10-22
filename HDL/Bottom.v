
module Bottom ( CLK2, CLK3, CLK4, CLK5, CLK6, CLK7, DL, DV, bc, bq4, bq5, bq7, Temp_C, Temp_H, Temp_N, Temp_Z, alu, Res, IR, d, w, x, 
	SYNC_RES, TTB1, TTB2, TTB3, Maybe1, Thingy_to_bot, bot_to_Thingy, SeqControl_1, SeqControl_2, SeqOut_1,
	A, CPU_IRQ_ACK, CPU_IRQ_TRIG, RD );

	input CLK2;
	input CLK3;
	input CLK4;
	input CLK5;
	input CLK6;
	input CLK7; 

	inout [7:0] DL;			// Internal databus
	output [7:0] DV;		// ALU Operand2
	input [5:0] bc;
	output bq4;
	output bq5;
	output bq7;
	output Temp_C;		// Flag C from temp Z register
	output Temp_H;		// Flag H from temp Z register
	output Temp_N;		// Flag N from temp Z register
	output Temp_Z;			// Flag Z from temp Z register
	output [7:0] alu; 		// ALU Operand1
	input [7:0] Res;		// ALU Result

	output [7:0] IR;		// Current opcode
	input [106:0] d;		// Decoder1 output
	input [40:0] w;			// Decoder2 output
	input [68:0] x;			// Decoder3 output

	input SYNC_RES;
	input TTB1;				// 1: Perform pairwise increment/decrement (simultaneously for two 8-bit IncDec halves)
	input TTB2;				// 1: Perform increment
	input TTB3;				// 1: Perform decrement
	input Maybe1;
	input Thingy_to_bot;		// Load a value into the IE register from the DL bus.	
	output bot_to_Thingy;		// IE access detected (Address = 0xffff)
	output SeqControl_1;
	output SeqControl_2;
	input SeqOut_1;

	output [15:0] A;		// External core address bus
	output [7:0] CPU_IRQ_ACK;
	input [7:0] CPU_IRQ_TRIG;
	input RD;

	// Internal bottom buses

	wire [7:0] abus;
	wire [7:0] bbus;
	wire [7:0] cbus;
	wire [7:0] dbus;
	wire [7:0] ebus;
	wire [7:0] fbus;
	wire [7:0] zbus;
	wire [7:0] wbus;
	wire [7:0] adl;
	wire [7:0] adh;
	wire [7:3] bro; 		// IRQ Logic interrupt address

	wire [7:0] Aout;	// Reg A out to bq Logic

	// Implementation

	BusPrecharge precharge (
		.CLK2(CLK2),
		.DL(DL),
		.abus(abus),
		.bbus(bbus),
		.cbus(cbus),
		.dbus(dbus) );

	BottomLeftLogic bottom_left (
		.CLK2(CLK2),
		.bc(bc),
		.bq4(bq4),
		.bq5(bq5),
		.bq7(bq7),
		.pq(Aout),
		.DV(DV) );

	RegsBuses regs (
		.CLK5(CLK5),
		.CLK6(CLK6),
		.w(w),
		.x(x),
		.DL(DL),
		.IR(IR),
		.abus(abus),
		.bbus(bbus),
		.cbus(cbus),
		.dbus(dbus),
		.ebus(ebus),
		.fbus(fbus),
		.Aout(Aout) );

	TempRegsBuses temp_regs (
		.CLK4(CLK4),
		.CLK5(CLK5),
		.CLK6(CLK6),
		.d60(d[60]),
		.w(w),
		.x(x),
		.DL(DL),
		.ebus(ebus),
		.fbus(fbus),
		.zbus(zbus),
		.wbus(wbus),
		.Res(Res),
		.adl(adl),
		.adh(adh) );

	SP sp (
		.CLK5(CLK5),
		.CLK6(CLK6),
		.CLK7(CLK7),
		.IR4(IR[4]),
		.IR5(IR[5]),
		.d60(d[60]),
		.d66(d[66]),
		.w(w),
		.x(x),
		.DL(DL),
		.abus(abus),
		.bbus(bbus),
		.cbus(cbus),
		.dbus(dbus),
		.zbus(zbus),
		.wbus(wbus),
		.adl(adl),
		.adh(adh) );

	PC pc (
		.CLK5(CLK5),
		.CLK6(CLK6),
		.CLK7(CLK7),
		.d92(d[92]),
		.w(w),
		.x(x),
		.DL(DL),
		.abus(abus),
		.cbus(cbus),
		.dbus(dbus),
		.zbus(zbus),
		.wbus(wbus),
		.adl(adl),
		.adh(adh),
		.IR(IR),
		.bro(bro) );

	IncDec incdec (
		.CLK4(CLK4),
		.TTB1(TTB1),
		.TTB2(TTB2),
		.TTB3(TTB3),
		.Maybe1(Maybe1),
		.cbus(cbus),
		.dbus(dbus),
		.adl(adl),
		.adh(adh),
		.AddrBus(A) );

	IRQ_Logic irq (
		.CLK3(CLK3),
		.CLK4(CLK4),
		.CLK5(CLK5),
		.CLK6(CLK6),
		.DL(DL),
		.RD(RD),
		.CPU_IRQ_ACK(CPU_IRQ_ACK),
		.CPU_IRQ_TRIG(CPU_IRQ_TRIG),
		.bro(bro),
		.bot_to_Thingy(bot_to_Thingy),
		.Thingy_to_bot(Thingy_to_bot),
		.SYNC_RES(SYNC_RES),
		.SeqControl_1(SeqControl_1),
		.SeqControl_2(SeqControl_2),
		.SeqOut_1(SeqOut_1),
		.d93(d[93]),
		.A(A) );

	assign alu = ~abus;

	assign Temp_C = zbus[4];
	assign Temp_H = zbus[5];
	assign Temp_N = zbus[6];
	assign Temp_Z = zbus[7];

endmodule // Bottom

module BusPrecharge ( CLK2, DL, abus, bbus, cbus, dbus );

	input CLK2;
	inout [7:0] DL;
	inout [7:0] abus;
	inout [7:0] bbus;
	inout [7:0] cbus;
	inout [7:0] dbus;

	assign DL = CLK2 ? 8'bz : 8'b1;
	assign abus = CLK2 ? 8'bz : 8'b1;
	assign bbus = CLK2 ? 8'bz : 8'b1;
	assign cbus = CLK2 ? 8'bz : 8'b1;
	assign dbus = CLK2 ? 8'bz : 8'b1;

endmodule // BusPrecharge

module BottomLeftLogic ( CLK2, bc, bq4, bq5, bq7, pq, bbus, DV );

	input CLK2;
	input [5:0] bc;
	output bq4;
	output bq5;
	output bq7;
	input [7:0] pq;
	inout [7:0] bbus;
	output [7:0] DV;

	assign bq4 = pq[1] | pq[2] | pq[3];
	assign bq5 = pq[5] | pq[6] | pq[7];
	assign bq7 = pq[4] | pq[7];
	
	assign DV[0] = ~(CLK2 ? (bbus[0] & ~bc[4]) : 1'b1);
	assign DV[1] = ~(CLK2 ? (bbus[1] & ~bc[4]) : 1'b1);
	assign DV[2] = ~(CLK2 ? (bbus[2] & ~bc[4]) : 1'b1);
	assign DV[3] = ~(CLK2 ? (bbus[3] & ~bc[4]) : 1'b1);
	assign DV[4] = ~(CLK2 ? (bbus[4] & ~(bc[4] | (bc[0] & bc[1])) ) : 1'b1);
	assign DV[5] = ~(CLK2 ? (bbus[4] & ~(bc[4] | (bc[0] & bc[5])) ) : 1'b1);
	assign DV[6] = ~(CLK2 ? (bbus[4] & ~(bc[4] | (bc[0] & bc[2])) ) : 1'b1);
	assign DV[7] = ~(CLK2 ? (bbus[4] & ~(bc[4] | (bc[0] & bc[3])) ) : 1'b1);

	// I decided to put the bc0/bc4 generation in the ALU, so that the bc signals would be made as output from the ALU (for beauty).

endmodule // BottomLeftLogic

module RegsBuses ( CLK5, CLK6, w, x, DL, IR, abus, bbus, cbus, dbus, ebus, fbus, Aout );

	input CLK5;
	input CLK6;
	input [40:0] w;
	input [68:0] x;
	inout [7:0] DL;
	output [7:0] IR;
	inout [7:0] abus;
	inout [7:0] bbus;
	inout [7:0] cbus;
	inout [7:0] dbus;
	inout [7:0] ebus;
	inout [7:0] fbus;
	output [7:0] Aout; 			// Reg A output for bq logic

	// Regs output

	wire [7:0] r1q;		// A
	wire [7:0] r2q;		// L
	wire [7:0] r3q;		// H
	wire [7:0] r4q;		// E
	wire [7:0] r5q;		// D
	wire [7:0] r6q;		// C
	wire [7:0] r7q;		// B

	regbit RegIR [7:0] ( .clk(CLK6), .cclk(CLK5), .d(DL), .ld(w[26]), .q(IR) );

	regbit RegA [7:0]( .clk(CLK6), .cclk(CLK5), .d(fbus), .ld(x[38]), .q(r1q) );
	regbit RegL [7:0]( .clk(CLK6), .cclk(CLK5), .d(ebus), .ld(x[40]), .q(r2q) );
	regbit RegH [7:0]( .clk(CLK6), .cclk(CLK5), .d(fbus), .ld(x[39]), .q(r3q) );
	regbit RegE [7:0]( .clk(CLK6), .cclk(CLK5), .d(ebus), .ld(x[50]), .q(r4q) );
	regbit RegD [7:0]( .clk(CLK6), .cclk(CLK5), .d(fbus), .ld(x[48]), .q(r5q) );
	regbit RegC [7:0]( .clk(CLK6), .cclk(CLK5), .d(ebus), .ld(x[51]), .q(r6q) );
	regbit RegB [7:0]( .clk(CLK6), .cclk(CLK5), .d(fbus), .ld(x[49]), .q(r7q) );

	assign abus = w[3] ? r1q : 8'bzzzzzzzz;
	assign bbus = x[35] ? r1q : 8'bzzzzzzzz;
	assign cbus = x[42] ? r2q : 8'bzzzzzzzz;
	assign abus = w[15] ? r2q : 8'bzzzzzzzz;
	assign bbus = x[44] ? r2q : 8'bzzzzzzzz;
	assign abus = w[19] ? r3q : 8'bzzzzzzzz;
	assign bbus = x[43] ? r3q : 8'bzzzzzzzz;
	assign dbus = x[42] ? r3q : 8'bzzzzzzzz;
	assign cbus = x[45] ? r4q : 8'bzzzzzzzz;
	assign bbus = x[47] ? r4q : 8'bzzzzzzzz;
	assign bbus = x[46] ? r5q : 8'bzzzzzzzz;
	assign dbus = x[45] ? r5q : 8'bzzzzzzzz;
	assign dbus = w[29] ? 8'b00000000 : 8'bzzzzzzzz;
	assign dbus = w[17] ? 8'b00000000 : 8'bzzzzzzzz;
	assign cbus = x[52] ? r6q : 8'bzzzzzzzz;
	assign bbus = x[54] ? r6q : 8'bzzzzzzzz;
	assign bbus = x[53] ? r7q : 8'bzzzzzzzz;
	assign dbus = x[52] ? r7q : 8'bzzzzzzzz;

	assign Aout = r1q;

endmodule // RegsBuses

module TempRegsBuses ( CLK4, CLK5, CLK6, d60, w, x, DL, ebus, fbus, zbus, wbus, Res, adl, adh );

	input CLK4;
	input CLK5;
	input CLK6;
	input d60;
	input [40:0] w;
	input [68:0] x;
	inout [7:0] DL;
	inout [7:0] ebus;
	inout [7:0] fbus;
	inout [7:0] zbus;
	inout [7:0] wbus;
	input [7:0] Res;
	inout [7:0] adl;
	inout [7:0] adh;

	wire [7:0] Z_in;
	wire [7:0] W_in;
	wire d60w8;

	regbit Z [7:0]( .clk(CLK6), .cclk(CLK5), .d(Z_in), .ld(x[60]), .q(zbus) );
	regbit W [7:0]( .clk(CLK6), .cclk(CLK5), .d(W_in), .ld(x[59]), .q(wbus) );

	assign abus = w[17] ? zbus : 8'bzzzzzzzz;
	assign abus = w[1] ? zbus : 8'bzzzzzzzz;
	assign abus = w[2] ? zbus : 8'bzzzzzzzz;
	assign abus = x[58] ? zbus : 8'bzzzzzzzz;
	assign abus = w[2] ? wbus : 8'bzzzzzzzz;
	assign abus = w[1] ? wbus : 8'bzzzzzzzz;

	assign fbus = ~(CLK4 ? ~(({8{x[55]}}&adh) | ({8{x[56]}}&wbus) | ({8{x[57]}}&Res)) : 8'b11111111);
	assign ebus = ~(CLK4 ? ~(({8{x[55]}}&adl) | ({8{x[56]}}&zbus) | ({8{x[57]}}&Res)) : 8'b11111111);

	assign d60w8 = ~(d60 | w[8]);
	assign Z_in = ~(({8{d60}}&adl) | ({8{~d60}}&DL));
	assign W_in = ~(({8{~d60w8}}&adh) | ({8{d60w8}}&DL));

endmodule // TempRegsBuses

module SP ( CLK5, CLK6, CLK7, IR4, IR5, d60, d66, w, x, DL, abus, bbus, cbus, dbus, zbus, wbus, adl, adh );

	input CLK5;
	input CLK6;
	input CLK7;
	input IR4;
	input IR5;
	input d60;
	input d66;
	input [40:0] w;
	input [68:0] x;
	inout [7:0] DL;			// Internal databus
	inout [7:0] abus;
	inout [7:0] bbus;
	inout [7:0] cbus;
	inout [7:0] dbus;
	inout [7:0] zbus;
	inout [7:0] wbus;
	inout [7:0] adl;
	inout [7:0] adh;

	wire [7:0] spl_d;		// SPL input
	wire [7:0] spl_q;		// SPL output
	wire [7:0] spl_nq;		// SPL output (complement)
	wire [7:0] sph_d;		// SPH input
	wire [7:0] sph_q;		// SPH output 
	wire [7:0] sph_nq;		// SPH output (complement)

	regbit SPL [7:0] ( .clk(CLK6), .cclk(CLK5), .d(spl_d), .ld(x[61]), .q(spl_q), .nq(spl_nq) );
	regbit SPH [7:0] ( .clk(CLK6), .cclk(CLK5), .d(sph_d), .ld(x[61]), .q(sph_q), .nq(sph_nq) );

	// SP vs Buses

	assign spl_d = CLK6 ? (~((adl & {8{x[62]}}) | (zbus & {8{x[63]}}))) : (CLK7 ? 8'bzzzzzzzz : 8'b11111111);
	assign sph_d = CLK6 ? (~((adh & {8{x[62]}}) | (wbus & {8{x[63]}}))) : (CLK7 ? 8'bzzzzzzzz : 8'b11111111);

	assign DL = ({8{d60}} & spl_q) ? 8'b00000000 : 8'bzzzzzzzz;
	assign abus = ({8{w[23]}} & spl_nq) ? 8'b00000000 : 8'bzzzzzzzz;
	assign bbus = ({8{w[15]}} & {8{IR4}} & {8{IR5}} & spl_nq) ? 8'b00000000 : 8'bzzzzzzzz;
	assign cbus = ({8{x[65]}} & spl_nq) ? 8'b00000000 : 8'bzzzzzzzz;

	assign DL = ({8{d66}} & sph_q) ? 8'b00000000 : 8'bzzzzzzzz;
	assign abus = ({8{w[9]}} & sph_nq) ? 8'b00000000 : 8'bzzzzzzzz;
	assign bbus = ({8{w[19]}} & {8{IR4}} & {8{IR5}} & sph_nq) ? 8'b00000000 : 8'bzzzzzzzz;
	assign dbus = ({8{x[65]}} & sph_nq) ? 8'b00000000 : 8'bzzzzzzzz;

endmodule // SP

module PC ( CLK5, CLK6, CLK7, d92, w, x, DL, abus, cbus, dbus, zbus, wbus, adl, adh, IR, bro );

	input CLK5;
	input CLK6;
	input CLK7;
	input d92;
	input [40:0] w;
	input [68:0] x;
	inout [7:0] DL;			// Internal databus
	inout [7:0] abus;
	inout [7:0] cbus;
	inout [7:0] dbus;
	inout [7:0] zbus;
	inout [7:0] wbus;
	inout [7:0] adl;
	inout [7:0] adh;
	input [7:0] IR;			// Current opcode
	input [7:3] bro;		// Interrupt address

	wire [7:0] pcl_d;		// PCL input
	wire [7:0] pcl_q;		// PCL output
	wire [7:0] pcl_nq;		// PCL output (complement)
	wire [7:0] pch_d;		// PCH input
	wire [7:0] pch_q;		// PCH output
	wire [7:0] pch_nq;		// PCH output (complement)

	regbit PCL [7:0] ( .clk(CLK6), .cclk(CLK5), .d(pcl_d), .ld(x[68]), .q(pcl_q), .nq(pcl_nq) );
	regbit PCH [7:0] ( .clk(CLK6), .cclk(CLK5), .d(pch_d), .ld(x[68]), .q(pch_q), .nq(pch_nq) );

	// PC vs Buses

	assign pcl_d[2:0] = CLK6 ? (~((adl[2:0] & {3{x[67]}}) | (zbus[2:0] & {3{w[36]}}))) : (CLK7 ? 3'bzzz : 3'b111);
	assign pcl_d[5:3] = CLK6 ? (~((adl[5:3] & {3{x[67]}}) | (zbus[5:3] & {3{w[36]}}) | ({3{d92}} & IR[5:3]) | bro[5:3])) : (CLK7 ? 3'bzzz : 3'b111);
	assign pcl_d[7:6] = CLK6 ? (~((adl[7:6] & {2{x[67]}}) | (zbus[7:6] & {2{w[36]}}) | bro[7:6])) : (CLK7 ? 2'bzz : 2'b11);
	assign pch_d = CLK6 ? (~((adh & {8{x[67]}}) | (wbus & {8{w[36]}}))) : (CLK7 ? 8'bzzzzzzzz : 8'b11111111);

	assign DL = ({8{w[34]}} & pcl_q) ? 8'b00000000 : 8'bzzzzzzzz;
	assign cbus = ({8{w[25]}} & pcl_nq) ? 8'b00000000 : 8'bzzzzzzzz;
	assign abus = ({8{w[8]}} & pcl_nq) ? 8'b00000000 : 8'bzzzzzzzz;
	assign abus = x[33] ? 8'b00000000 : 8'bzzzzzzzz;

	assign DL = ({8{w[28]}} & pch_q) ? 8'b00000000 : 8'bzzzzzzzz;
	assign dbus = ({8{w[25]}} & pch_nq) ? 8'b00000000 : 8'bzzzzzzzz;
	assign dbus = ({8{w[8]}} & pch_nq) ? 8'b00000000 : 8'bzzzzzzzz;

endmodule // PC

module regbit ( clk, cclk, d, ld, q, nq );

	input clk;
	input cclk;
	input d;
	input ld;
	output q;
	output nq;

	// Latch with complementary set enable, complementary CLK.

	reg val_in;
	reg val_out;
	initial val_in <= 1'b0;
	initial val_out <= 1'b0;

	always @(*) begin
		if (clk && ld)
			val_in <= d;
	end

	always @(negedge ld) begin
		val_out <= val_in;
	end

	assign q = val_out;
	assign nq = ~q;

endmodule // regbit

module regbit_res ( clk, cclk, d, ld, res, q, nq );

	input clk;
	input cclk;
	input d;
	input ld;
	input res;
	output q;
	output nq;

	// Latch with complementary set enable, complementary CLK, active-high reset

	reg val_in;
	reg val_out;
	initial val_in <= 1'b0;
	initial val_out <= 1'b0;

	always @(*) begin
		if (clk && ld)
			val_in <= d;
		if (res)
			val_in <= 1'b0;
	end

	always @(negedge ld) begin
		val_out <= val_in;
	end

	assign q = val_out;
	assign nq = ~q;

endmodule // regbit_res

module IncDec ( CLK4, TTB1, TTB2, TTB3, Maybe1, cbus, dbus, adl, adh, AddrBus );

	input CLK4;
	input TTB1;				// 1: Perform pairwise increment/decrement (simultaneously for two 8-bit IncDec halves)
	input TTB2;				// 1: Perform increment
	input TTB3;				// 1: Perform decrement
	input Maybe1;
	inout [7:0] cbus;
	inout [7:0] dbus;
	inout [7:0] adl;
	inout [7:0] adh;
	output [15:0] AddrBus;

	wire [7:0] mq_lo;		// carry_out
	wire [7:0] mq_hi;
	wire [7:0] xa_lo;		// carry_in
	wire [7:0] xa_hi;

	cntbit cnt_lo [7:0] ( .n_val_in(cbus), .cin(xa_lo), .val_out(adl), .cout(mq_lo), .TTB2(TTB2), .TTB3(TTB3) );
	cntbit cnt_hi [7:0] ( .n_val_in(dbus), .cin(xa_hi), .val_out(adh), .cout(mq_hi), .TTB2(TTB2), .TTB3(TTB3) );
	cntbit_carry_chain carry_chain ( .CLK4(CLK4), .TTB1(TTB1), .TTB2(TTB2), .TTB3(TTB3), .mq({mq_hi,mq_lo}), .xa({xa_hi,xa_lo}) );

	assign AddrBus = ~Maybe1 ? {xa_hi,xa_lo} : 16'bz;

endmodule // IncDec

module cntbit ( n_val_in, cin, val_out, cout, TTB2, TTB3 );

	input n_val_in;
	input cin;
	output val_out;
	output cout;
	input TTB2;
	input TTB3;

	assign val_out = ~n_val_in ^ cin;
	assign cout = n_val_in ? TTB3 : TTB2;

endmodule // cntbit

module cntbit_carry_chain ( CLK4, TTB1, TTB2, TTB3, mq, xa );

	input CLK4;
	input TTB1;
	input TTB2;
	input TTB3;
	input [15:0] mq;
	output [15:0] xa;

	wire [15:0] nxa;
	wire ct;

	assign nxa[0] = ~(TTB2 | TTB3);

	assign nxa[1] = CLK4 ? (~(mq[0])) : 1'b1;
	assign nxa[2] = CLK4 ? (~(mq[0] & mq[1])) : 1'b1;
	assign nxa[3] = CLK4 ? (~(mq[0] & mq[1] & mq[2])) : 1'b1;
	assign nxa[4] = CLK4 ? (~(mq[0] & mq[1] & mq[2] & mq[3])) : 1'b1;
	assign nxa[5] = CLK4 ? (~(mq[0] & mq[1] & mq[2] & mq[3] & mq[4])) : 1'b1;
	assign nxa[6] = CLK4 ? (~(mq[0] & mq[1] & mq[2] & mq[3] & mq[4] & mq[5])) : 1'b1;
	assign nxa[7] = CLK4 ? (~(mq[0] & mq[1] & mq[2] & mq[3] & mq[4] & mq[5] & mq[6])) : 1'b1;

	assign ct = (mq[7] & xa[7]) | TTB1;
	assign nxa[8] = CLK4 ? (~(ct)) : 1'b1;
	assign nxa[9] = CLK4 ? (~(ct & mq[8])) : 1'b1;
	assign nxa[10] = CLK4 ? (~(ct & mq[8] & mq[9])) : 1'b1;
	assign nxa[11] = CLK4 ? (~(ct & mq[8] & mq[9] & mq[10])) : 1'b1;
	assign nxa[12] = CLK4 ? (~(ct & mq[8] & mq[9] & mq[10] & mq[11])) : 1'b1;
	assign nxa[13] = CLK4 ? (~(ct & mq[8] & mq[9] & mq[10] & mq[11] & mq[12])) : 1'b1;
	assign nxa[14] = CLK4 ? (~(ct & mq[8] & mq[9] & mq[10] & mq[11] & mq[12] & mq[13])) : 1'b1;
	assign nxa[15] = CLK4 ? (~(ct & mq[8] & mq[9] & mq[10] & mq[11] & mq[12] & mq[13] & mq[14])) : 1'b1;

	// The `xa` outputs are connected directly to AddrBus. If CLK4 is not updated long enough, the AddrBus value will be "corrupted".

	assign xa = ~nxa;

endmodule // cntbit_carry_chain

module IRQ_Logic ( CLK3, CLK4, CLK5, CLK6, DL, RD, CPU_IRQ_ACK, CPU_IRQ_TRIG, bro, bot_to_Thingy, Thingy_to_bot, SYNC_RES,
	SeqControl_1, SeqControl_2, SeqOut_1, d93, A );

	input CLK3;
	input CLK4;
	input CLK5;
	input CLK6;
	inout [7:0] DL;			// DataBus
	input RD;
	output [7:0] CPU_IRQ_ACK;
	input [7:0] CPU_IRQ_TRIG;
	output [7:3] bro;			// Int address  ("Bottom Right output")
	output bot_to_Thingy;			// 1: Access to IE detected
	input Thingy_to_bot;			// 1: Write Access to IE detected (Load IE from DataBus)
	input SYNC_RES;
	output SeqControl_1;
	output SeqControl_2;
	input SeqOut_1;			// IME?
	input d93; 			// 1: Enable IRQ processing by Decoder1, 0: disable
	input [15:0] A;			// To check the address for the value 0xffff (IE)

	// Internal

	wire sc1; 			// "Seq control 1"
	wire sc2; 			// "Seq control 2"
	wire nso;		// "~Seq Out (1)"
	wire [7:0] ieq; 		// IE output
	wire [7:0] ienq;		// IE output (complement)
	wire [7:0] ifq;		// IF output
	wire [7:0] ifnq; 	// IF output (complement)
	wire [7:0] ack; 	// Acknowledged

	// IE/IF
	module7 IE [7:0] ( .clk(CLK6), .cclk(CLK5), .d(DL), .ld(Thingy_to_bot), .res(SYNC_RES), .q(ieq), .nq(ienq) );
	module8 IF [7:0] ( .clk(CLK3), .cclk(CLK4), .d(~(ienq&CPU_IRQ_TRIG)), .q(ifq), .nq(ifnq) );
	assign DL = ({8{RD}} & {8{bot_to_Thingy}} & ieq) ? 8'b0 : 8'bz; 	// znand3.

	// Breadcrumps
	assign nso = ~SeqOut_1;
	assign sc1 = ~(ifnq[0]|ifnq[1]|ifnq[2]|ifnq[3]|ifnq[4]|ifnq[5]|ifnq[6]|ifnq[7]|~nso);
	assign sc2 = CLK6 ? ~(ack[0]|ack[1]|ack[2]|ack[3]|ack[4]|ack[5]|ack[6]|ack[7]) : 1'b1;
	assign bot_to_Thingy = (A[0]&A[1]&A[2]&A[3]&A[4]&A[5]&A[6]&A[7]&A[8]&A[9]&A[10]&A[11]&A[12]&A[13]&A[14]&A[15]); 	// Addr == 0xffff

	// Priority encoder
	assign ack[0] = CLK6 ? ~(ifnq[0]&nso) : 1'b1;
	assign ack[1] = CLK6 ? ~(ifnq[1]&ifq[0]&nso) : 1'b1;
	assign ack[2] = CLK6 ? ~(ifnq[2]&ifq[0]&ifq[1]&nso) : 1'b1;
	assign ack[3] = CLK6 ? ~(ifnq[3]&ifq[0]&ifq[1]&ifq[2]&nso) : 1'b1;
	assign ack[4] = CLK6 ? ~(ifnq[4]&ifq[0]&ifq[1]&ifq[2]&ifq[3]&nso) : 1'b1;
	assign ack[5] = CLK6 ? ~(ifnq[5]&ifq[0]&ifq[1]&ifq[2]&ifq[3]&ifq[4]&nso) : 1'b1;
	assign ack[6] = CLK6 ? ~(ifnq[6]&ifq[0]&ifq[1]&ifq[2]&ifq[3]&ifq[4]&ifq[5]&nso) : 1'b1;
	assign ack[7] = CLK6 ? ~(ifnq[7]&ifq[0]&ifq[1]&ifq[2]&ifq[3]&ifq[4]&ifq[5]&ifq[6]&nso) : 1'b1;

	// Interrupt address
	assign bro[3] = ~(CLK6 ? (~(CPU_IRQ_ACK[1]|CPU_IRQ_ACK[3]|CPU_IRQ_ACK[5]|CPU_IRQ_ACK[7])) : 1'b1);
	assign bro[4] = ~(CLK6 ? (~(CPU_IRQ_ACK[2]|CPU_IRQ_ACK[3]|CPU_IRQ_ACK[6]|CPU_IRQ_ACK[7])) : 1'b1);
	assign bro[5] = ~(CLK6 ? (~(CPU_IRQ_ACK[4]|CPU_IRQ_ACK[5]|CPU_IRQ_ACK[6]|CPU_IRQ_ACK[7])) : 1'b1);
	assign bro[6] = ~sc2 & d93;
	assign bro[7] = ~nso & d93;

	assign SeqControl_1 = ~sc1;
	assign SeqControl_2 = ~sc2;
	assign CPU_IRQ_ACK = ack & {8{d93}};

endmodule // IRQ_Logic

module module7 ( clk, cclk, d, ld, res, q, nq );

	input clk;
	input cclk;
	input d;
	input ld;
	input res;
	output q;
	output nq;

	// Latch (no CLK edge detection, yes ld edge detection) with reset.

	reg val_in;
	reg val_out;
	initial val_in <= 1'b0;
	initial val_out <= 1'b0;

	always @(*) begin
		if (clk && ld)
			val_in <= d;
		if (res)
			val_in <= 1'b0;
	end

	always @(negedge ld) begin
		val_out <= val_in;
	end

	assign q = val_out;
	assign nq = ~q;

endmodule // module7

module module8 ( clk, cclk, d, q, nq );

	input clk;
	input cclk;
	input d;
	output q;
	output nq;

	// Regular (transparent) latch (no edge detection), to store the interrupt flag.

	reg val;
	initial val <= 1'b0;

	always @(*) begin
		if (clk)
			val <= d;
	end

	assign q = val;
	assign nq = ~q;

endmodule // module8
