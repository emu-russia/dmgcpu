`timescale 1ns/1ns

`define STRINGIFY(x) `"x`"

module SM83_Run();

	reg CLK;
	/* verilator lint_off UNOPTFLAT */
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
		.BUS_DISABLE(1'b0),
		.MMIO_REQ(1'b0),
		.IPL_REQ(1'b0),
		.IPL_DISABLE(1'b0),
		.MREQ(MemReq),
		.D(dbus),
		.A(abus),
		.CPU_IRQ_TRIG({8{1'b0}}),
		.CPU_IRQ_ACK(irq_ack) );

	initial begin
		$display("Running '%s'", `STRINGIFY(`ROM));

		ExternalRESET = 1'b0;
		CLK = 1'b0;

		$dumpfile("dmg_waves.fst");
		$dumpvars(0, SM83_Run);

		ExternalRESET = 1'b1;
		repeat (8) @ (posedge CLK);
		ExternalRESET = 1'b0;

		repeat (256) @ (posedge CLK);

		$display(""); // breakline after any serial output
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

	reg [7:0] bootrom[0:255];
	initial $readmemh("roms/boot.mem", bootrom);

	reg [7:0] mem[0:65535];
	reg [7:0] value;

	reg in_boot = 1'b1;

	integer j;
	initial begin
		// Pre-fill the memory with some value so we don't run into `xx`
		for(j = 0; j < 65536; j = j+1) 
			mem[j] = 0;

		`define STRINGIFY(x) `"x`"
		`ifdef ROM
			$readmemh(`STRINGIFY(`ROM), mem);
		`else
			$readmemh("roms/bogus_hw.mem", mem);
		`endif
	end

	always @(posedge RD) begin
		// disable bootrom after entering ROM
		if (in_boot && addrbus >= 16'h0100) begin
			in_boot = 1'b0;
		end

		if (in_boot) value <= bootrom[addrbus[7:0]];
		else value <= mem[addrbus];
	end

	// the CPU changes the address bus and WR signal at the same time, which
	// causes issues due to order evaluation. To work around this, we extend
	// the address bus and data bus by one tick.
	wire [15:0] #1 ADR = addrbus;
	wire [7:0] #1 DAT = databus;

	always @(negedge WR) begin
		mem[ADR] <= DAT;
		if (ADR == 16'hFF02) begin
			$write("%c", mem[16'hFF01]);
		end
	end
	

	assign databus = (MREQ & RD) ? value : 8'hZZ;

endmodule // Bogus_HW
