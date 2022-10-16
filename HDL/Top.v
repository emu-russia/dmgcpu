// Definition of the SM83 CPU top level.

module SM83Core (
	CLK1, CLK2, CLK3, CLK4, CLK5, CLK6, CLK7, CLK8, CLK9, 
	LoadIR,
	Clock_WTF, XCK_Ena, RESET, SYNC_RESET, LongDescr, Unbonded,
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

	input Clock_WTF;	// Active-high crystal oscillator stablilized input?
	output XCK_Ena;		// Crystal oscillator enable. When CPU drives this low, the crystal oscillator gets disabled to save power. This happens during STOP mode.
	input RESET;		// Active-high asynchronous reset input. Fed directly from RST input pad.
	input SYNC_RESET;	// Active-high synchronous reset input. Synchronized to CLK8/CLK9.
	output LongDescr;
	input Unbonded;		// Directly connected to an input pad at the top of the die, which is not bonded.

	input WAKE;			// Wakes CPU from STOP mode.
	output RD;
	output WR;
	input Maybe1;		// TBD: Maybe used to disable all bus drivers in the CPU when test mode is active.
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
	wire [7:0] DV;
	wire [7:0] Res;			// ALU Result
	wire AllZeros;
	wire ALU_to_bot;
	wire [5:0] bc;
	wire [7:0] alu;
	wire bq4;
	wire bq5;
	wire bq7;
	wire ALU_L2;			// Temp C flag
	wire ALU_L1; 			// Temp H flag
	wire ALU_L4;			// Temp N flag
	wire BTT;				// Temp Z flag
	wire ALU_Out1;
	wire DL_Control1;
	wire DL_Control2;
	wire [7:0] IR;			// Current opcode
	wire [5:0] nIR;				// Inverse IR values are only used for the first 6 bits.

	wire SeqOut_1;
	wire SeqOut_2;
	wire SeqOut_3; 		// N.C.
	wire SeqControl_1;
	wire SeqControl_2;
	wire nCLK4;					// It is obtained by inverting CLK4 inside the sequencer.

	wire ALU_to_Thingy;
	wire bot_to_Thingy;			// IE access detected (Address = 0xffff)
	wire TTB1;
	wire TTB2;
	wire TTB3;
	wire Thingy_to_bot;			// Load a value into the IE register from the DL bus.

	assign DL_Control1 = Maybe1;
	assign DL_Control2 = x[37];
	assign LoadIR = w[26];
	assign nCLK4 = ~CLK4;
	assign WR = w[6];

	// Instances

	nor z_eval (AllZeros, Res[0], Res[1], Res[2], Res[3], Res[4], Res[5], Res[6], Res[7]);

	DataLatch dl (
		.CLK(CLK2), 
		.DL_Control1(DL_Control1), 
		.DL_Control2(x[37]), 
		.DataBus(D),
		.DL(DL), 
		.Res(Res) );

	DataBridge bridge (
		.CLK2(CLK2),
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
		.ALU_to_bot(ALU_to_bot),
		.ALU_to_Thingy(ALU_to_Thingy),
		.Temp_C(ALU_L2),
		.Temp_H(ALU_L1),
		.Temp_N(ALU_L4),
		.Temp_Z(BTT),
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
		.Unbonded(Unbonded),
		.LongDescr(LongDescr),
		.XCK_Ena(XCK_Ena),
		.RESET(RESET),
		.SYNC_RESET(SYNC_RESET),
		.Clock_WTF(Clock_WTF),
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
		.w(w),
		.ALU_to_Thingy(ALU_to_Thingy),
		.WR(WR),
		.BTT(BTT),
		.TTB1(TTB1),
		.TTB2(TTB2),
		.TTB3(TTB3),
		.Thingy_to_bot(Thingy_to_bot),
		.bot_to_Thingy(bot_to_Thingy) );

	Bottom bot (
		.CLK2(CLK2),
		.CLK3(CLK3),
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
		.ALU_to_bot(ALU_to_bot),
		.ALU_L2(ALU_L2),
		.ALU_L1(ALU_L1),
		.ALU_L4(ALU_L4),
		.BTT(BTT),
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
		.Thingy_to_bot(Thingy_to_bot),
		.bot_to_Thingy(bot_to_Thingy),
		.SeqControl_1(SeqControl_1),
		.SeqControl_2(SeqControl_2),
		.SeqOut_1(SeqOut_1),
		.A(A),
		.CPU_IRQ_ACK(CPU_IRQ_ACK),
		.CPU_IRQ_TRIG(CPU_IRQ_TRIG),
		.RD(RD) );

endmodule // SM83Core
