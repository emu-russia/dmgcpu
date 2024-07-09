// Basic functional test of the SM83's CLA  (#229)

// Perform cyclic addition of a and b. (values run 0..255)

`timescale 1ns/1ns

module test_alu ();

	reg CLK;
	always #25 CLK = ~CLK;

	reg ExternalRESET;

	wire M1; 		// T1
	wire OSC_STABLE;		// T15
	reg OSC_ENA;		// T14
	reg CLK_ENA;		// T11
	
	wire RD;
	wire WR;
	wire MemReq;

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

	wire [106:0] d; 	// Decoder1
	wire [40:0] w;		// Decoder2
	wire [68:0] x;		// Decoder3

	wire [7:0] Res;
	wire AllZeros;
	wire ALU_Out1;
	wire ALU_to_Thingy;
	reg bq4;
	reg bq5;
	reg bq7;
	wire [5:0] bc;

	reg [7:0] IR;

	reg Temp_C;
	reg Temp_H;
	reg Temp_N;
	reg Temp_Z;

	reg [7:0] DV;
	reg [7:0] alu;

	ALU alu_inst ( 
		.CLK2(ADR_CLK_P), 
		.CLK4(DATA_CLK_N), 
		.CLK5(INC_CLK_N), 
		.CLK6(INC_CLK_P), 
		.CLK7(LATCH_CLK), 
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
		.ALU_to_Thingy(ALU_to_Thingy),
		.Temp_C(Temp_C), 
		.Temp_H(Temp_H), 
		.Temp_N(Temp_N), 
		.Temp_Z(Temp_Z), 
		.ALU_Out1(ALU_Out1), 
		.IR(IR), 
		.nIR(~IR[5:0]) );

	// clkgen is needed only if we want to test ALU more thoroughly, with the logic of setting flags, for example.
	// EDIT: In the process of test development it turned out that operations on ALU are synchronous and require at least CLK2 (see modified Operand1 alu0-7, outputs e0-e7 from flag logic)

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

	// The mock decoder is needed to return the d/w/x signals to the ALU, which will make it work as an adder.

	MockDecoder decoder (.d(d), .w(w), .x(x) );

	initial begin

		$display("Test ALU.");

		CLK <= 1'b0;
		// It's not very true, but it'll do..
		CLK_ENA <= 1'b1;
		OSC_ENA <= 1'b1;
		IR <= 0;
		Temp_C <= 0;
		Temp_H <= 0;
		Temp_N <= 0;
		Temp_Z <= 0;
		bq4 <= 0;
		bq5 <= 0;
		bq7 <= 0;

		DV <= 77;
		alu <= 35;
		// Make sure that Res = DV + alu in GTKWave during CLK2=1

		$dumpfile("test_alu.vcd");
		$dumpvars(0, test_alu);

		ExternalRESET = 1'b1;
		repeat (8) @ (posedge CLK);
		ExternalRESET = 1'b0;

		repeat (256) @ (posedge CLK);
		$finish;
	end

endmodule // test_alu

module MockDecoder (d, w, x);

	output [106:0] d; 		// Decoder1 outputs
	output [40:0] w;		// Decoder2 outputs
	output [68:0] x;		// Decoder3 outputs

	assign d = 0;
	assign w = 'b0_0000000000_0000000000_0000000000_0000000000;
	assign x = 'b0_00000000_0000000000_0000000000_0000000000_0000000000_0000000000_0000001000; 		// x3 = 1 (s3_alu_sum)

endmodule // MockDecoder

// Transparent latch used as a bus keeper.
module BusKeeper (d, q);

	input d;
	output q;

	reg val;
	// The BusKeeper value is stored on the FET gate. We assume that initially there is no charge there, i.e. the value is 0.
	initial val = 1'b0;

	always @(*) begin
		if (d == 1'b1)
			val = 1'b1;
		if (d == 1'b0)
			val = 1'b0;
	end

	assign q = val;

endmodule // BusKeeper
