
module IRNots (IR, nIR);

	input wire [7:0] IR;
	output wire [5:0] nIR;

	assign nIR = ~IR;
	
endmodule // IRNots
