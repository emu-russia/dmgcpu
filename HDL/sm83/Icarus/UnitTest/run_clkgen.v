
`timescale 1ns/1ns

module CLKGen_Run();

	reg CLK;
	reg ExternalRESET;
	
	wire OSC_STABLE;		// T15

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
		.CLK_ENA(1'b1),
		.OSC_ENA(1'b1),
		.OSC_STABLE(OSC_STABLE),
		.ASYNC_RESET(ASYNC_RESET),
		.SYNC_RESET(SYNC_RESET) );

	initial begin

		$display("Check that the CLKGen is moving.");

		ExternalRESET <= 1'b0;
		CLK <= 1'b0;

		$dumpfile("clk_waves.vcd");
		$dumpvars(0, clkgen);

		repeat (1000) @ (posedge CLK);
		$finish;
	end	

endmodule // CLKGen_Run
