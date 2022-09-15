// One of the two types of inverters on the output of Decoder1.

module not_1 (a, x);

	input wire a;
	output wire x;

	assign x = ~a;

endmodule // not_1
