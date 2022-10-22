`timescale 1ns/1ns

module IRNots (IR, nIR);

	input [7:0] IR;
	output [5:0] nIR;

	assign nIR = ~IR;
	
endmodule // IRNots
