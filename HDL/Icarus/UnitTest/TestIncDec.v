`timescale 1ns/1ns

module TestIncDec();

	reg CLK;
	always #25 CLK = ~CLK;

	wire [15:0] AddrBus;
	wire [15:0] d;
	wire [15:0] q;

	Reg16 acc ( .clk(CLK), .d(d), .q(q) );

	// The value on the cbus/dbus contains a ~val of register (register `q` output inversion).
	// This value is stored on the BusKeeper. From the BusKeeper inverted value of ~val as `val` is fed to the IDU.
	// At the output of the IDU the value is fed to the adl/adh buses as `val`.
	// There is an inverter on the register input that loads ~val into the register.
	// In the register the value is stored as ~val (inverse hold)

	IncDec incdec ( 
		.CLK4(CLK),
		.TTB1(1'b0),
		.TTB2(1'b0),
		.TTB3(1'b1),		// +1
		.Maybe1(1'b0),
		.cbus(q[7:0]),
		.dbus(q[15:8]),
		.adl(d[7:0]),
		.adh(d[15:8]),
		.AddrBus(AddrBus) );

	initial begin

		$display("Test IncDec.");

		CLK <= 1'b0;

		$dumpfile("TestIncDec.vcd");
		$dumpvars(0, incdec);
		$dumpvars(1, acc);

		repeat (32) @ (posedge CLK);

		$finish;
	end

endmodule // TestIncDec

module Reg16 (clk, d, q);

	input clk;
	input [15:0] d;
	output [15:0] q;

	reg [15:0] val;
	initial val <= 16'h0;

	always @(negedge clk) begin
		val <= ~d;
	end

	assign q = val;

endmodule // Reg16

// Transparent latch used as a bus keeper.
module BusKeeper (d, q);

	input d;
	output q;

	reg val;
	initial val <= 1'b0;

	always @(*) begin
		if (d == 1'b1)
			val <= 1'b1;
		if (d == 1'b0)
			val <= 1'b0;
	end

	assign q = val;

endmodule // BusKeeper
