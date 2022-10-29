`timescale 1ns/1ns

`define ALU_Ops_delay 0

module Bottom ( CLK2, CLK4, CLK5, CLK6, CLK7, DL, DV, bc, bq4, bq5, bq7, Temp_C, Temp_H, Temp_N, Temp_Z, alu, Res, IR, d, w, x, 
	SYNC_RES, TTB1, TTB2, TTB3, Maybe1, bro, A );

	input CLK2;
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
	input TTB2;				// 1: Perform decrement
	input TTB3;				// 1: Perform increment
	input Maybe1;			// 1: Bus disable
	input [7:3] bro; 		// IRQ Logic interrupt address
	output [15:0] A;		// External core address bus

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
		.Aout(Aout),
		.abus(abus),
		.bbus(bbus),
		.alu(alu),
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
		.bbus(bbus),
		.cbus(cbus),
		.dbus(dbus),
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
		.load_pc(x[68]),
		.idu_to_pc(x[67]),
		.zwbus_to_pc(w[36]),
		.pcl_to_databus(w[34]),
		.pch_to_databus(w[28]),
		.pc_to_cdbus(w[25]),
		.pc_to_adbus(w[8]),
		.zero_to_abus(x[33]),
		.DL(DL),
		.abus(abus),
		.cbus(cbus),
		.dbus(dbus),
		.zbus(zbus),
		.wbus(wbus),
		.adl(adl),
		.adh(adh),
		.IR(IR),
		.bro(bro),
		.SYNC_RES(SYNC_RES) );

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

	assign   DL = CLK2 ? 8'bzzzzzzzz : 8'b11111111;
	assign abus = CLK2 ? 8'bzzzzzzzz : 8'b11111111;
	assign bbus = CLK2 ? 8'bzzzzzzzz : 8'b11111111;
	assign cbus = CLK2 ? 8'bzzzzzzzz : 8'b11111111;
	assign dbus = CLK2 ? 8'bzzzzzzzz : 8'b11111111;

endmodule // BusPrecharge

// It is very difficult to put this circuit into any category. It belongs to both ALU and registers at the same time, and is generally at the bottom. So it's going to stay here untouched for now.
module BottomLeftLogic ( CLK2, bc, bq4, bq5, bq7, Aout, abus, bbus, alu, DV );

	input CLK2;
	input [5:0] bc;
	output bq4;
	output bq5;
	output bq7;
	input [7:0] Aout; 		// Current value of the `A` register.
	inout [7:0] abus;
	inout [7:0] bbus;
	output [7:0] alu;
	output [7:0] DV;

	wire [7:0] abq; 	// abus Bus keepers outputs
	wire [7:0] bbq; 	// bbus Bus keepers outputs

	assign bq4 = Aout[1] | Aout[2] | Aout[3];
	assign bq5 = Aout[5] | Aout[6] | Aout[7];
	assign bq7 = Aout[4] & Aout[7];
	
	// This requires transparent latches, since nobody could set up a abus/bbus. On the actual circuit, they are also present as a memory on the `not` gate.
	BusKeeper abus_keepers [7:0] ( .d(abus), .q(abq) );
	BusKeeper bbus_keepers [7:0] ( .d(bbus), .q(bbq) );

	assign #`ALU_Ops_delay DV[0] = ~(CLK2 ? (bbq[0] & ~bc[4]) : 1'b1);
	assign #`ALU_Ops_delay DV[1] = ~(CLK2 ? (bbq[1] & ~bc[4]) : 1'b1);
	assign #`ALU_Ops_delay DV[2] = ~(CLK2 ? (bbq[2] & ~bc[4]) : 1'b1);
	assign #`ALU_Ops_delay DV[3] = ~(CLK2 ? (bbq[3] & ~bc[4]) : 1'b1);
	assign #`ALU_Ops_delay DV[4] = ~(CLK2 ? (bbq[4] & ~(bc[4] | (bc[0] & bc[1])) ) : 1'b1);
	assign #`ALU_Ops_delay DV[5] = ~(CLK2 ? (bbq[5] & ~(bc[4] | (bc[0] & bc[5])) ) : 1'b1);
	assign #`ALU_Ops_delay DV[6] = ~(CLK2 ? (bbq[6] & ~(bc[4] | (bc[0] & bc[2])) ) : 1'b1);
	assign #`ALU_Ops_delay DV[7] = ~(CLK2 ? (bbq[7] & ~(bc[4] | (bc[0] & bc[3])) ) : 1'b1);

	assign #`ALU_Ops_delay alu = ~abq;

	// I decided to put the bc0/bc4 generation in the ALU, so that the bc signals would be made as output from the ALU (for beauty).

endmodule // BottomLeftLogic
