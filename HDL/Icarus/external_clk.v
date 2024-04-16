// Based on https://github.com/msinger/dmg-schematics

`timescale 1ns/1ns

module External_CLK ( CLK, RESET, ADR_CLK_N, ADR_CLK_P, DATA_CLK_N, DATA_CLK_P, INC_CLK_N, INC_CLK_P, LATCH_CLK, MAIN_CLK_N, MAIN_CLK_P, CLK_ENA, OSC_ENA, OSC_STABLE, ASYNC_RESET, SYNC_RESET );

	input CLK;
	input RESET;
	output ADR_CLK_N;	// #DATA_VALID
	output ADR_CLK_P; 	// DATA_VALID
	output DATA_CLK_N;	// #CPU_PHI
	output DATA_CLK_P;	// CPU_PHI
	output INC_CLK_N;	// #CPU_T4
	output INC_CLK_P;	// CPU_T4
	output LATCH_CLK;	// BUKE
	output MAIN_CLK_N; 	// BOMA_1mhz
	output MAIN_CLK_P;	// BOGA_1mhz
	input CLK_ENA;
	input OSC_ENA;
	output OSC_STABLE;
	output ASYNC_RESET;
	output SYNC_RESET;

	// T1/T2, RESET Pads

	wire nT1;
	wire nT2;
	wire T1T2;
	wire T1_nT2;
	wire nT1_T2;

	assign nT1 = 1'b1;
	assign nT2 = 1'b1;
	assign T1T2 = ~(~nT1 & ~nT2 & RESET);
	assign T1_nT2 = (~nT1 & nT2);
	assign nT1_T2 = (nT1 & ~nT2);
	assign ASYNC_RESET = RESET;

	// Phase Splitter

	wire ck; 	// CK1/2 Pad out
	assign ck = OSC_ENA ? CLK : 1'b0;

	/* verilator lint_off UNOPTFLAT */
	wire phase_splitter_out;
	assign phase_splitter_out = ~(~(ck & phase_splitter_out) & ~ck);
	wire ATAL_4mhz;
	assign ATAL_4mhz = ~phase_splitter_out;

	// Divider

	wire [3:0] drq;
	wire [3:0] drnq;

	DR_LATCH div [3:0] (
		.ena({ATAL_4mhz,~ATAL_4mhz,ATAL_4mhz,~ATAL_4mhz}),
		.nres({4{T1T2}}),
		.d({drq[2],drq[1],drnq[0],drq[3]}),
		.q(drq),
		.nq(drnq));

	// Clocks

	assign LATCH_CLK = ~(drq[2] | ~drnq[3] | ~CLK_ENA);

	assign INC_CLK_P = ~(~(~(~CLK_ENA | ~drnq[3] | ~drnq[1])));
	assign INC_CLK_N = ~INC_CLK_P;
	assign DATA_CLK_N = ~(~(~(~CLK_ENA | ~drnq[1])));
	assign DATA_CLK_P = ~DATA_CLK_N;

	wire BALY_out;
	assign BALY_out = ~((INC_CLK_N & DATA_CLK_P & ~drnq[1] & ~drq[2]) | ~OSC_ENA);

	wire DATA_VALID;
	assign DATA_VALID = (BALY_out & CLK_ENA);
	// The ADR has 2 additional inverters, which increases the propagation delay, relative to the MAIN.
	assign ADR_CLK_P = DATA_VALID;
	assign ADR_CLK_N = ~DATA_VALID;

	assign MAIN_CLK_P = ~BALY_out;
	assign MAIN_CLK_N = ~MAIN_CLK_P;

	// Sync Reset to CPU

	wire TUBO_q;
	wire TUBO_nq;
	wire ASOL_q;
	wire ASOL_nq;
	reg SixteenHz;
	wire AFER_nq;

	// @Rodrigodd recommended to do it so that it looks like real behavior. But I'm still not interested in what it's for :-)    (#219)
	// Some kind of internal DIV kitchen
	initial SixteenHz = 1'b0;
	always begin
		// wait 4 cycles after RESET
		repeat (12) @(posedge CLK);
		SixteenHz <= ~SixteenHz;
	end

	NOR_LATCH TUBO (.set(CLK_ENA), .res(RESET | ~OSC_ENA), .q(TUBO_q), .nq(TUBO_nq));
	assign OSC_STABLE = (T1_nT2 | nT1_T2 | (TUBO_nq & SixteenHz));
	NOR_LATCH ASOL (.set(~(~OSC_STABLE | RESET)), .res(RESET), .q(ASOL_q), .nq(ASOL_nq));
	DFFR_B AFER (.clk(MAIN_CLK_P), .nres(T1T2), .d(ASOL_nq), .q(SYNC_RESET), .nq(AFER_nq) );

endmodule // External_CLK

module NOR_LATCH (set, res, q, nq);

	input set;
	input res;
	output q;
	output nq;

	reg val;
	initial val = 1'bx;

	// res above set.
	always @(*) begin
		if (res)
			val = 1'b0;
		else if (set)
			val = 1'b1;
	end

	assign q = val;
	assign nq = ~val;

endmodule // NOR_LATCH

module DFFR_B (clk, nres, d, q, nq);

	input clk;
	input nres;
	input d;
	output q;
	output nq;

	reg val;
	initial val = 1'bx;

	always @(posedge clk) begin
		if (clk)
			val <= d;
	end

	always @(*) begin
		if (~nres)
			val <= 1'b0;
	end

	assign q = val;
	assign nq = ~val;

endmodule // DFFR_B

module DR_LATCH (ena, nres, d, q, nq);

	input ena;
	input nres;
	input d;
	output q;
	output nq;

	reg val;
	initial val = 1'b0;

	always @(*) begin
		if (ena)
			val = d;
		if (~nres)
			val = 1'b0;
	end

	assign q = val;
	assign nq = ~val;

endmodule // DR_LATCH
