
module SM83Core (
	CLK1, CLK2, CLK3, CLK4, CLK5, CLK6, CLK7, CLK8, CLK9, 
	LoadIR,
	Clock_WTF, XCK_Ena, RESET, SYNC_RESET, LongDescr, Unbonded,
	WAKE, RD, WR, Maybe1, MMIO_REQ, IPL_REQ, Maybe2, MREQ,
	D, A, CPU_IRQ_TRIG, CPU_IRQ_ACK );

	input wire CLK1;
	input wire CLK2;
	input wire CLK3;
	input wire CLK4;
	input wire CLK5;
	input wire CLK6;
	input wire CLK7;
	input wire CLK8;
	input wire CLK9;

	output wire LoadIR;

	input wire Clock_WTF;
	output wire XCK_Ena;
	input wire RESET;
	input wire SYNC_RESET;
	output wire LongDescr;
	input wire Unbonded;

	input wire WAKE;
	output wire RD;
	output wire WR;
	input wire Maybe1;
	input wire MMIO_REQ;
	input wire IPL_REQ;
	input wire Maybe2;
	output wire MREQ;

	inout wire [7:0] D;
	output wire [15:0] A;
	input wire [7:0] CPU_IRQ_TRIG;
	output wire [7:0] CPU_IRQ_ACK;

	// Internal wires

	wire [25:0] a; 			// Decoder1 in
	wire [106:0] d; 		// Decoder1 out
	wire [40:0] w; 			// Decoder2 out
	wire [68:0] x; 			// Random Logic out

	wire [7:0] DL;
	wire [7:0] DV;
	wire [7:0] Res;
	wire AllZeros;
	wire ALU_to_bot;
	wire [5:0] bc;
	wire [7:0] alu;
	wire bq4;
	wire bq5;
	wire bq7;
	wire ALU_L0;
	wire ALU_L1;
	wire ALU_L2;
	wire ALU_L3;
	wire ALU_L4;
	wire ALU_L5;
	wire ALU_Out1;
	wire DL_Control1;
	wire DL_Control2;
	wire [7:0] IR;
	wire [5:0] nIR;

	wire SeqOut_1;
	wire SeqOut_2;
	wire SeqOut_3;
	wire SeqControl_1;
	wire SeqControl_2;
	wire nCLK4;

	wire FromThingy;
	wire bot_to_Thingy;
	wire TTB1;
	wire TTB2;
	wire TTB3;
	wire Thingy_to_bot;

	assign DL_Control1 = Maybe1;
	assign DL_Control2 = x[37];
	assign LoadIR = w[26];
	assign nCLK4 = ~CLK4;

	// Instances

	DataLatch dl ();

	Decoder1 dec1 ();

	Decoder2 dec2 ();

	RandomLogic rnd ();

	IRNots mighty_six (
		.IR(IR),
		.nIR(nIR) );

	ALU alu_inst ();

	Thingy thingy ();

	Bottom bot ();

endmodule // SM83Core
