// Definition of the SM83 CPU top level.

module SM83Core (
	CLK1, CLK2, CLK3, CLK4, CLK5, CLK6, CLK7, CLK8, CLK9, 
	LoadIR,
	OSC_STABLE, OSC_ENA, RESET, SYNC_RESET, CLK_ENA, NMI,
	WAKE, RD, WR, Maybe1, MMIO_REQ, IPL_REQ, Maybe2, MREQ,
	D, A, CPU_IRQ_TRIG, CPU_IRQ_ACK );

	// Obviously, such a large number of dual CLKs is due to the four-cycle "slot" execution of the core.

	input CLK1;
	input CLK2;
	input CLK3;
	input CLK4;
	input CLK5;
	input CLK6;
	input CLK7;
	input CLK8;
	input CLK9;

	output LoadIR; 		// Analog to SYNC signal, which was typically used in old processors (right after the Fetch of the next opcode).

	input OSC_STABLE;	// Active-high crystal oscillator stablilized input?  [previously Clock_WTF]
	output OSC_ENA;		// Crystal oscillator enable. When CPU drives this low, the crystal oscillator gets disabled to save power. This happens during STOP mode. 	[previously XCK_Ena]
	input RESET;		// Active-high asynchronous reset input. Fed directly from RST input pad.
	input SYNC_RESET;	// Active-high synchronous reset input. Synchronized to CLK8/CLK9.
	output CLK_ENA;		// [previously LongDescr]
	input NMI;			// Directly connected to an input pad at the top of the die, which is not bonded.  [previously Unbonded]

	input WAKE;			// Wakes CPU from STOP mode.
	output RD;
	output WR;
	input Maybe1;		// 1: Disable all bus drivers in the CPU when test mode is active.
	input MMIO_REQ;		// High when address bus is 0xfexx or 0xffxx.
	input IPL_REQ;		// High when address bus is 0x00xx and boot ROM is still visible.
	input Maybe2;		// TBD: Maybe used to disable all bus drivers in the CPU when test mode is active.
	output MREQ;

	inout [7:0] D;
	output [15:0] A;
	input [7:0] CPU_IRQ_TRIG;
	output [7:0] CPU_IRQ_ACK;

	// Internal wires

	wire [25:0] a; 			// Decoder1 in
	wire [106:0] d; 		// Decoder1 out
	wire [40:0] w; 			// Decoder2 out
	wire [68:0] x; 			// Decoder3 out

	wire [7:0] DL;			// Current DataLatch value
	wire [7:0] DV;			// ALU Operand2
	wire [7:0] Res;			// ALU Result
	wire AllZeros; 			// Res == 0
	wire [5:0] bc;
	wire [7:0] alu; 		// ALU Operand1
	wire bq4;
	wire bq5;
	wire bq7;
	wire Temp_C;			// Temp C flag
	wire Temp_H; 			// Temp H flag
	wire Temp_N;			// Temp N flag
	wire Temp_Z;			// Temp Z flag
	wire ALU_Out1;
	wire [7:0] IR;			// Current opcode
	wire [5:0] nIR;				// Inverse IR values are only used for the first 6 bits.
	wire [7:3] bro; 		// IRQ Logic interrupt address

	wire SeqOut_1; 		// IME? (to interrupt control)
	wire SeqOut_2;
	wire SeqOut_3; 		// N.C.
	wire SeqControl_1;
	wire SeqControl_2;
	wire nCLK4;					// It is obtained by inverting CLK4 inside the sequencer.

	wire ALU_to_Thingy; 		// ALU CarryOut
	wire bot_to_Thingy;			// IE access detected (Address = 0xffff)
	wire TTB1;
	wire TTB2;
	wire TTB3;
	wire Thingy_to_bot;			// Load a value into the IE register from the DL bus.

	assign LoadIR = w[26];
	assign nCLK4 = ~CLK4;
	assign WR = w[6];

	// Instances

	nor z_eval (AllZeros, Res[0], Res[1], Res[2], Res[3], Res[4], Res[5], Res[6], Res[7]);

	DataLatch dl (
		.CLK(CLK2), 
		.DL_Control1(Maybe1), 
		.DL_Control2(x[37]), 
		.DataBus(D),
		.DL(DL), 
		.Res(Res) );

	DataBridge bridge (
		.DataOut(x[15]),
		.DV(DV),
		.DL(DL) );

	Decoder1 dec1 (
		.CLK2(CLK2),
		.a(a),
		.d(d) );

	Decoder2 dec2 (
		.CLK2(CLK2),
		.d(d),
		.w(w),
		.SeqOut_2(SeqOut_2),
		.IR7(IR[7]) );

	Decoder3 dec3 (
		.CLK2(CLK2),
		.CLK4(CLK4),
		.CLK5(CLK5),
		.nCLK4(nCLK4),
		.a3(a[3]),
		.d(d),
		.w(w),
		.x(x),
		.IR(IR),
		.nIR(nIR),
		.SeqOut_2(SeqOut_2) );

	IRNots mighty_six (
		.IR(IR),
		.nIR(nIR) );

	ALU alu_inst (
		.CLK2(CLK2),
		.CLK4(CLK4),
		.CLK5(CLK5),
		.CLK6(CLK6),
		.CLK7(CLK7),
		.DV(DV),
		.Res(Res),
		.AllZeros(AllZeros),
		.d42(d[42]),
		.d58(d[58]),
		.w(w),
		.x(x),
		.bc(bc),
		.alu(alu),
		.bq4(bq4),
		.bq5(bq5),
		.bq7(bq7),
		.ALU_to_Thingy(ALU_to_Thingy),
		.Temp_C(Temp_C),
		.Temp_H(Temp_H),
		.Temp_N(Temp_N),
		.Temp_Z(Temp_Z),
		.ALU_Out1(ALU_Out1),
		.IR(IR),
		.nIR(nIR) );

	Sequencer seq (
		.CLK1(CLK1),
		.CLK2(CLK2),
		.CLK4(CLK4),
		.CLK6(CLK6),
		.CLK8(CLK8),
		.CLK9(CLK9),
		.nCLK4(nCLK4),
		.IR(IR),
		.a(a),
		.d(d),
		.w(w),
		.x(x),
		.ALU_Out1(ALU_Out1), 
		.NMI(NMI),
		.CLK_ENA(CLK_ENA),
		.OSC_ENA(OSC_ENA),
		.RESET(RESET),
		.SYNC_RESET(SYNC_RESET),
		.OSC_STABLE(OSC_STABLE),
		.WAKE(WAKE),
		.RD(RD),
		.Maybe1(Maybe1),
		.MMIO_REQ(MMIO_REQ),
		.IPL_REQ(IPL_REQ),
		.Maybe2(Maybe2),
		.MREQ(MREQ),
		.SeqControl_1(SeqControl_1),
		.SeqControl_2(SeqControl_2),
		.SeqOut_1(SeqOut_1),
		.SeqOut_2(SeqOut_2),
		.SeqOut_3(SeqOut_3) );

	Thingy thingy (
		.w8(w[8]),
		.w31(w[31]),
		.w35(w[35]),
		.ALU_to_Thingy(ALU_to_Thingy),
		.WR(WR),
		.Temp_Z(Temp_Z),
		.TTB1(TTB1),
		.TTB2(TTB2),
		.TTB3(TTB3),
		.Thingy_to_bot(Thingy_to_bot),
		.bot_to_Thingy(bot_to_Thingy) );

	Bottom bot (
		.CLK2(CLK2),
		.CLK4(CLK4),
		.CLK5(CLK5),
		.CLK6(CLK6),
		.CLK7(CLK7),
		.DL(DL),
		.DV(DV),
		.bc(bc),
		.bq4(bq4),
		.bq5(bq5),
		.bq7(bq7),
		.Temp_C(Temp_C),
		.Temp_H(Temp_H),
		.Temp_N(Temp_N),
		.Temp_Z(Temp_Z),
		.alu(alu),
		.Res(Res),
		.IR(IR),
		.d(d),
		.w(w),
		.x(x), 
		.SYNC_RES(SYNC_RESET),
		.TTB1(TTB1),
		.TTB2(TTB2),
		.TTB3(TTB3),
		.Maybe1(Maybe1),
		.bro(bro),
		.A(A) );

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
		.SYNC_RES(SYNC_RESET),
		.SeqControl_1(SeqControl_1),
		.SeqControl_2(SeqControl_2),
		.SeqOut_1(SeqOut_1),
		.d93(d[93]),
		.A(A) );

endmodule // SM83Core

// Transparent latch used as a bus keeper.
module BusKeeper (d, q);

	input d;
	output q;

	reg val;
	// The BusKeeper value is stored on the FET gate. We assume that initially there is no charge there, i.e. the value is 0.
	initial val = 1'b0;

	always @(*) begin
		if (d == 1'b1)
			val = 1'b1;
		if (d == 1'b0)
			val = 1'b0;
	end

	assign q = val;

endmodule // BusKeeper
