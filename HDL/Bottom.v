
module Bottom ( CLK2, CLK3, CLK4, CLK5, CLK6, CLK7, DL, DV, bc, bq4, bq5, bq7, ALU_to_bot, ALU_L2, ALU_L1, ALU_L4, BTT, alu, Res, IR, d, w, x, 
	SYNC_RES, TTB1, TTB2, TTB3, Maybe1, Thingy_to_bot, bot_to_Thingy, SeqControl_1, SeqControl_2, SeqOut_1,
	A, CPU_IRQ_ACK, CPU_IRQ_TRIG, RD );

	input CLK2;
	input CLK3;
	input CLK4;
	input CLK5;
	input CLK6;
	input CLK7; 

	inout [7:0] DL;
	output [7:0] DV;
	inout [5:0] bc;
	output bq4;
	output bq5;
	output bq7;
	input ALU_to_bot;
	output ALU_L2;
	output ALU_L1;
	output ALU_L4;
	output BTT;
	output [7:0] alu;
	input [7:0] Res;

	output [7:0] IR;
	input [106:0] d;
	input [40:0] w;
	input [68:0] x;

	input SYNC_RES;
	input TTB1;
	input TTB2;
	input TTB3;
	input Maybe1;
	input Thingy_to_bot;
	output bot_to_Thingy;
	output SeqControl_1;
	output SeqControl_2;
	input SeqOut_1;

	output [15:0] A;
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
	wire [7:0] gbus;
	wire [7:0] kbus;
	wire [7:0] xbus;
	wire [7:0] wbus;
	wire [7:3] bro; 		// IRQ Logic

	wire [7:0] Aout;	// Reg A out to bc/bq Logic

	// Implementation

	BusPrecharge precharge (
		.CLK2(CLK2),
		.DL(DL),
		.abus(abus),
		.bbus(bbus),
		.cbus(cbus),
		.dbus(dbus) );

	BottomLeftLogic branch_hmm (
		.CLK2(CLK2),
		.ALU_to_bot(ALU_to_bot),
		.w(w),
		.IR4(IR[4]),
		.IR5(IR[5]),
		.bc(bc),
		.bq4(bq4),
		.bq5(bq5),
		.bq7(bq7),
		.pq(Aout) );

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
		.gbus(gbus),
		.kbus(kbus),
		.Res(Res),
		.ALU_L2(ALU_L2),
		.ALU_L1(ALU_L1),
		.ALU_L4(ALU_L4),
		.BTT(BTT) );

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
		.abus(abus),
		.bbus(bbus),
		.cbus(cbus),
		.dbus(dbus),
		.gbus(gbus),
		.kbus(kbus),
		.xbus(xbus),
		.wbus(wbus) );

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
		.gbus(gbus),
		.kbus(kbus),
		.xbus(xbus),
		.wbus(wbus),
		.IR(IR),
		.bro(bro) );

	AddressBus acnt (
		.CLK4(CLK4),
		.TTB1(TTB1),
		.TTB2(TTB2),
		.TTB3(TTB3),
		.Maybe1(Maybe1),
		.cbus(cbus),
		.dbus(dbus),
		.xbus(xbus),
		.wbus(wbus),
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
		.d93(d[93]) );

	assign alu = ~abus;
	assign DV = ~bbus;

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

module BottomLeftLogic ( CLK2, ALU_to_bot, w, IR4, IR5, bc, bq4, bq5, bq7, pq );

	input CLK2;
	input ALU_to_bot;
	input [40:0] w;
	input IR4;
	input IR5;
	inout [5:0] bc;
	output bq4;
	output bq5;
	output bq7;
	input [7:0] pq;

	// TBD

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
	output [7:0] Aout; 			// Reg A output for bc/bq logic

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

	// TBD

	assign Aout = r1q;

endmodule // RegsBuses

module TempRegsBuses ( CLK4, CLK5, CLK6, d60, w, x, DL, ebus, fbus, gbus, kbus, Res, ALU_L2, ALU_L1, ALU_L4, BTT );

	input CLK4;
	input CLK5;
	input CLK6;
	input d60;
	input [40:0] w;
	input [68:0] x;
	inout [7:0] DL;
	inout [7:0] ebus;
	inout [7:0] fbus;
	inout [7:0] gbus;
	inout [7:0] kbus;
	input [7:0] Res;
	output ALU_L2; 			// Flag C from temp
	output ALU_L1; 			// Flag H from temp
	output ALU_L4; 			// Flag N from temp
	output BTT; 			// Flag Z from temp

	wire [7:0] G_in;
	wire [7:0] K_in;

	regbit Reg_TempLo [7:0]( .clk(CLK6), .cclk(CLK5), .d(G_in), .ld(x[60]), .q(gbus) );	// G
	regbit Reg_TempHi [7:0]( .clk(CLK6), .cclk(CLK5), .d(K_in), .ld(x[59]), .q(kbus) );	// K

	// TBD

	assign ALU_L2 = gbus[4];
	assign ALU_L1 = gbus[5];
	assign ALU_L4 = gbus[6];
	assign BTT = gbus[7];

endmodule // TempRegsBuses

module SP ( CLK5, CLK6, CLK7, IR4, IR5, d60, d66, w, x, abus, bbus, cbus, dbus, gbus, kbus, xbus, wbus );

	input CLK5;
	input CLK6;
	input CLK7;
	input IR4;
	input IR5;
	input d60;
	input d66;
	input [40:0] w;
	input [68:0] x;
	inout [7:0] abus;
	inout [7:0] bbus;
	inout [7:0] cbus;
	inout [7:0] dbus;
	inout [7:0] gbus;
	inout [7:0] kbus;
	inout [7:0] xbus;
	inout [7:0] wbus;

	// TBD

endmodule // SP

module PC ( CLK5, CLK6, CLK7, d92, w, x, DL, abus, cbus, dbus, gbus, kbus, xbus, wbus, IR, bro );

	input CLK5;
	input CLK6;
	input CLK7;
	input d92;
	input [40:0] w;
	input [68:0] x;
	inout [7:0] DL;
	inout [7:0] abus;
	inout [7:0] cbus;
	inout [7:0] dbus;
	inout [7:0] gbus;
	inout [7:0] kbus;
	inout [7:0] xbus;
	inout [7:0] wbus;
	input [7:0] IR;
	input [7:3] bro;

	// TBD

endmodule // PC

module regbit ( clk, cclk, d, ld, q );

	input clk;
	input cclk;
	input d;
	input ld;
	output q;

	// TBD

endmodule // regbit

module regbit_res ( clk, cclk, d, ld, res, q );

	input clk;
	input cclk;
	input d;
	input ld;
	input res;
	output q;

	// TBD

endmodule // regbit_res

module AddressBus ( CLK4, TTB1, TTB2, TTB3, Maybe1, cbus, dbus, xbus, wbus, AddrBus );

	input CLK4;
	input TTB1;
	input TTB2;
	input TTB3;
	input Maybe1;
	input [7:0] cbus;
	input [7:0] dbus;
	input [7:0] xbus;
	input [7:0] wbus;
	output [15:0] AddrBus;

	// TBD

endmodule // AddressBus

module cntbit ();

	// TBD

endmodule // cntbit

module IRQ_Logic ( CLK3, CLK4, CLK5, CLK6, DL, RD, CPU_IRQ_ACK, CPU_IRQ_TRIG, bro, bot_to_Thingy, Thingy_to_bot, SYNC_RES,
	SeqControl_1, SeqControl_2, SeqOut_1, d93 );

	input CLK3;
	input CLK4;
	input CLK5;
	input CLK6;
	inout [7:0] DL;
	input RD;
	output [7:0] CPU_IRQ_ACK;
	input [7:0] CPU_IRQ_TRIG;
	output [7:3] bro;
	output bot_to_Thingy;
	input Thingy_to_bot;
	input SYNC_RES;
	output SeqControl_1;
	output SeqControl_2;
	input SeqOut_1;
	input d93;

	// Internal

	wire sc1;
	wire sc2;
	wire nso;
	wire [7:0] ieq;
	wire [7:0] ienq;
	wire [7:0] ifq;
	wire [7:0] ifnq;

	module7 IE [7:0] ( .clk(CLK6), .cclk(CLK5), .d(DL), .ld(Thingy_to_bot), .res(SYNC_RES), .q(ieq), .nq(ienq) );
	module8 IF [7:0] ( .clk(CLK3), .cclk(CLK4), .d(~(ienq&CPU_IRQ_TRIG)), .q(ifq), .nq(ifnq) );

	// TBD

	assign DL = ({8{RD}} & {8{bot_to_Thingy}} & ieq) ? 8'b0 : 8'bz; 	// znand3. 

endmodule // IRQ_Logic

module module7 ( clk, cclk, d, ld, res, q, nq );

	input clk;
	input cclk;
	input d;
	input ld;
	input res;
	output q;
	output nq; 

	// TBD

endmodule // module7

module module8 ( clk, cclk, d, q, nq );

	input clk;
	input cclk;
	input d;
	output q;
	output nq;

	// TBD

endmodule // module8
