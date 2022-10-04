
module Decoder3( CLK2, CLK4, CLK5, nCLK4, d, w, x, IR, nIR, SeqOut_2 );

	input CLK2;
	input CLK4;
	input CLK5;
	input nCLK4;

	input [106:0] d;
	input [40:0] w;
	output [68:0] x;
	input [7:0] IR;
	input [5:0] nIR;
	input SeqOut_2;

endmodule // Decoder3
