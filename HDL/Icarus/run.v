
`timescale 1ns/1ns

module SM83_Run();

	reg CLK;
	wire [7:0] dbus;
	wire [15:0] abus;
	wire [7:0] irq_ack;
	reg ExternalRESET;

	wire M1; 		// T1
	wire OSC_STABLE;		// T15
	wire OSC_ENA;		// T14
	wire CLK_ENA;		// T11
	
	wire RD;
	wire WR;
	wire MemReq;

	always #25 CLK = ~CLK;

	wire ADR_CLK_N;
	wire ADR_CLK_P;
	wire DATA_CLK_N;
	wire DATA_CLK_P;
	wire INC_CLK_N;
	wire INC_CLK_P;
	wire LATCH_CLK;
	wire MAIN_CLK_N;
	wire MAIN_CLK_P;

	wire ASYNC_RESET;
	wire SYNC_RESET;

	Bogus_HW hw (
		.MREQ(MemReq),
		.RD(RD),
		.WR(WR),
		.databus(dbus),
		.addrbus(abus) );

	// The core requires a rather sophisticated CLK generation circuit.

	External_CLK clkgen (
		.CLK(CLK),
		.RESET(ExternalRESET),
		.ADR_CLK_N(ADR_CLK_N),
		.ADR_CLK_P(ADR_CLK_P),
		.DATA_CLK_N(DATA_CLK_N),
		.DATA_CLK_P(DATA_CLK_P),
		.INC_CLK_N(INC_CLK_N),
		.INC_CLK_P(INC_CLK_P),
		.LATCH_CLK(LATCH_CLK),
		.MAIN_CLK_N(MAIN_CLK_N),
		.MAIN_CLK_P(MAIN_CLK_P),
		.CLK_ENA(CLK_ENA),
		.OSC_ENA(OSC_ENA),
		.OSC_STABLE(OSC_STABLE),
		.ASYNC_RESET(ASYNC_RESET),
		.SYNC_RESET(SYNC_RESET) );

	SM83Core dmgcore (
		.CLK1(ADR_CLK_N),
		.CLK2(ADR_CLK_P),
		.CLK3(DATA_CLK_P),
		.CLK4(DATA_CLK_N),
		.CLK5(INC_CLK_N),
		.CLK6(INC_CLK_P),
		.CLK7(LATCH_CLK),
		.CLK8(MAIN_CLK_N),
		.CLK9(MAIN_CLK_P),
		.M1(M1),
		.OSC_STABLE(OSC_STABLE),
		.OSC_ENA(OSC_ENA),
		.RESET(ASYNC_RESET),
		.SYNC_RESET(SYNC_RESET),
		.CLK_ENA(CLK_ENA),
		.NMI(1'b0),
		.WAKE(1'b0),
		.RD(RD),
		.WR(WR),
		.Maybe1(1'b0),
		.MMIO_REQ(1'b0),
		.IPL_REQ(1'b0),
		.Maybe2(1'b0),
		.MREQ(MemReq),
		.D(dbus),
		.A(abus),
		.CPU_IRQ_TRIG({8{1'b0}}),
		.CPU_IRQ_ACK(irq_ack) );

	initial begin

		$display("Check that the DMG Core is moving.");

		ExternalRESET = 1'b0;
		CLK = 1'b0;

		$dumpfile("dmg_waves.vcd");
		$dumpvars(0, SM83_Run);

		ExternalRESET = 1'b1;
		repeat (8) @ (posedge CLK);
		ExternalRESET = 1'b0;

		repeat (256) @ (posedge CLK);
		$writememh ("out.mem", hw.mem);
		$finish;
	end	

endmodule // SM83_Run

module Bogus_HW ( MREQ, RD, WR, databus, addrbus );

	input MREQ;
	input RD;
	input WR;
	inout [7:0] databus;
	input [15:0] addrbus;

	reg [7:0] mem[0:65535];
	reg [7:0] value;

	// You need to pre-fill the memory with some value so you don't run into `xx'
	integer j;
	initial 
  	for(j = 0; j < 65536; j = j+1) 
    	mem[j] = 0;

	initial $readmemh("bogus_hw.mem", mem);

	always @(RD) value <= mem[addrbus];
	always @(WR) mem[addrbus] <= databus;

	assign databus = (MREQ & RD) ? value : 'bz;

endmodule // Bogus_HW
