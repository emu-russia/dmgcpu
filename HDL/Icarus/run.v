
`timescale 1ns/1ns

module SM83_Run();

	reg CLK;
	wire [7:0] dbus;
	wire [15:0] abus;
	reg [7:0] irq_trig;
	wire [7:0] irq_ack;
	reg ExternalRESET;

	wire LoadIR; 		// T1

	wire OSC_STABLE;		// T15
	wire OSC_ENA;		// T14
	wire CLK_ENA;		// T11
	
	reg Unbonded;
	wire RD;
	wire WR;
	reg WakeUp;
	reg Maybe1;
	reg MmioReq;
	reg IplReq;
	reg Maybe2;
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
		.CLK3(DATA_CLK_N),
		.CLK4(DATA_CLK_P),
		.CLK5(INC_CLK_N),
		.CLK6(INC_CLK_P),
		.CLK7(LATCH_CLK),
		.CLK8(MAIN_CLK_N),
		.CLK9(MAIN_CLK_P),
		.LoadIR(LoadIR),
		.Clock_WTF(OSC_STABLE),
		.XCK_Ena(OSC_ENA),
		.RESET(ASYNC_RESET),
		.SYNC_RESET(SYNC_RESET),
		.LongDescr(CLK_ENA),
		.Unbonded(Unbonded),
		.WAKE(WakeUp),
		.RD(RD),
		.WR(WR),
		.Maybe1,
		.MMIO_REQ(MmioReq),
		.IPL_REQ(IplReq),
		.Maybe2(Maybe2),
		.MREQ(MemReq),
		.D(dbus),
		.A(abus),
		.CPU_IRQ_TRIG(irq_trig),
		.CPU_IRQ_ACK(irq_ack) );

	initial begin

		$display("Check that the DMG Core is moving.");

		ExternalRESET <= 1'b0;
		CLK <= 1'b0;
		Unbonded <= 1'b0;
		WakeUp <= 1'b0;
		Maybe1 <= 1'b0;
		MmioReq <= 1'b0;
		IplReq <= 1'b0;
		Maybe2 <= 1'b0;

		$dumpfile("dmg_waves.vcd");
		$dumpvars(0, dmgcore);

		ExternalRESET <= 1'b1;
		repeat (8) @ (posedge CLK);
		ExternalRESET <= 1'b0;

		repeat (32) @ (posedge CLK);
		$finish;
	end	

endmodule // SM83_Run
