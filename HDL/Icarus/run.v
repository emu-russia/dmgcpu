
`timescale 1ns/1ns

module SM83_Run();

	reg CLK;
	reg Reset;
	reg SyncReset;
	wire [7:0] dbus;
	wire [15:0] abus;
	reg [7:0] irq_trig;
	wire [7:0] irq_ack;

	wire LoadIR;
	reg Clock_WTF;
	wire XCK_Ena;
	wire LongDescr;
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

	SM83Core dmgcore (
		.CLK1(~CLK),
		.CLK2(CLK),
		.CLK3(~CLK),
		.CLK4(CLK),
		.CLK5(~CLK),
		.CLK6(CLK),
		.CLK7(~CLK),
		.CLK8(CLK),
		.CLK9(~CLK),
		.LoadIR(LoadIR),
		.Clock_WTF(Clock_WTF),
		.XCK_Ena(XCK_Ena),
		.RESET(Reset),
		.SYNC_RESET(SyncReset),
		.LongDescr(LongDescr),
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

		CLK <= 1'b0;
		Clock_WTF <= 1'b0;
		Reset <= 1'b0;
		SyncReset <= 1'b0;
		Unbonded <= 1'b0;
		WakeUp <= 1'b0;
		Maybe1 <= 1'b0;
		MmioReq <= 1'b0;
		IplReq <= 1'b0;
		Maybe2 <= 1'b0;

		$dumpfile("dmg_waves.vcd");
		$dumpvars(0, dmgcore);

		repeat (1000) @ (posedge CLK);
		$finish;
	end	

endmodule // SM83_Run
