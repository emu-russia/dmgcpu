`timescale 1ns/1ns

// Separated from Bottom.v to Top.v

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
	output SeqControl_1; 			// 1: Wake up after an interrupt. Used in HLT opcode processing.
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
	module7 IE [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(DL), .ld({8{Thingy_to_bot}}), .res({8{SYNC_RES}}), .q(ieq), .nq(ienq) );
	module8 IF [7:0] ( .clk({8{CLK3}}), .cclk({8{CLK4}}), .d(~(ieq&CPU_IRQ_TRIG)), .q(ifq), .nq(ifnq) );
	assign DL = (RD & bot_to_Thingy) ? ienq : 8'bzzzzzzzz; 	// znand3.

	// Breadcrumps
	assign nso = ~SeqOut_1;
	assign sc1 = ~(ifnq[0]|ifnq[1]|ifnq[2]|ifnq[3]|ifnq[4]|ifnq[5]|ifnq[6]|ifnq[7]|~nso);
	assign sc2 = CLK6 ? ~(ack[0]|ack[1]|ack[2]|ack[3]|ack[4]|ack[5]|ack[6]|ack[7]) : 1'b1;
	assign bot_to_Thingy = (A[0]&A[1]&A[2]&A[3]&A[4]&A[5]&A[6]&A[7]&A[8]&A[9]&A[10]&A[11]&A[12]&A[13]&A[14]&A[15]); 	// Addr == 0xffff

	// Priority encoder
	assign ack[0] = ~(CLK6 ? ~(ifnq[0]&nso) : 1'b1);
	assign ack[1] = ~(CLK6 ? ~(ifnq[1]&ifq[0]&nso) : 1'b1);
	assign ack[2] = ~(CLK6 ? ~(ifnq[2]&ifq[0]&ifq[1]&nso) : 1'b1);
	assign ack[3] = ~(CLK6 ? ~(ifnq[3]&ifq[0]&ifq[1]&ifq[2]&nso) : 1'b1);
	assign ack[4] = ~(CLK6 ? ~(ifnq[4]&ifq[0]&ifq[1]&ifq[2]&ifq[3]&nso) : 1'b1);
	assign ack[5] = ~(CLK6 ? ~(ifnq[5]&ifq[0]&ifq[1]&ifq[2]&ifq[3]&ifq[4]&nso) : 1'b1);
	assign ack[6] = ~(CLK6 ? ~(ifnq[6]&ifq[0]&ifq[1]&ifq[2]&ifq[3]&ifq[4]&ifq[5]&nso) : 1'b1);
	assign ack[7] = ~(CLK6 ? ~(ifnq[7]&ifq[0]&ifq[1]&ifq[2]&ifq[3]&ifq[4]&ifq[5]&ifq[6]&nso) : 1'b1);

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
	initial val_in = 1'b0;
	initial val_out = 1'b0;

	always @(*) begin
		if (clk && ld)
			val_in = d;
		if (res)
			val_in = 1'b0;
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
	initial val = 1'bx;

	always @(*) begin
		if (clk)
			val = d;
	end

	assign q = val;
	assign nq = ~q;

endmodule // module8
