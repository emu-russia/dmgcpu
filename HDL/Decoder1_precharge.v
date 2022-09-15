// Precharge used in Decoder1.

module pch_1 (a, clk);

	inout wire a;
	input wire clk;

	assign a = clk ? 1b'z : 1b'1;

endmodule // pch_1
