
module Sequencer ( CLK1, CLK2, CLK4, CLK6, CLK8, CLK9, nCLK4, IR, a, d, w, x, ALU_Out1, 
	Unbonded, LongDescr, XCK_Ena, RESET, SYNC_RESET, Clock_WTF, WAKE, RD, WR, Maybe1, MMIO_REQ, IPL_REQ, Maybe2, MREQ,
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
	input WR;
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

endmodule // Sequencer
