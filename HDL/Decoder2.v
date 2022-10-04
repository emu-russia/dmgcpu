
module Decoder2( CLK2, a3, d, w, SeqOut_2, IR7 );

	input CLK2;
	input a3;
	input [106:0] d;
	output [40:0] w;
	input SeqOut_2;
	input IR7;

	assign w[7] = ~IR7;			// Not used

	assign w[39] = ~SeqOut_2;
	assign w[40] = w[18] & w[39];

endmodule // Decoder2
