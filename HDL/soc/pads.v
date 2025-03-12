module IOBUF_B (  DRV_LOW, n_INPUT, n_ENA_PU, n_DRV_HIGH, PAD_IO);

	input wire DRV_LOW;
	output wire n_INPUT;
	input wire n_ENA_PU;
	input wire n_DRV_HIGH;
	inout wire PAD_IO;

endmodule // IOBUF_B

module IOBUF_C (  n_DRV_HIGH, n_ENA_PU, DRV_LOW, n_INPUT, PAD_IO);

	input wire n_DRV_HIGH;
	input wire n_ENA_PU;
	input wire DRV_LOW;
	output wire n_INPUT;
	inout wire PAD_IO;

endmodule // IOBUF_C

module IBUF_A (  n_INPUT, PAD_IN);

	output wire n_INPUT;
	input wire PAD_IN;

endmodule // IBUF_A

module IOBUF_A (  PAD_IO, n_DRV_HIGH, DRV_LOW, n_INPUT);

	inout wire PAD_IO;
	input wire n_DRV_HIGH;
	input wire DRV_LOW;
	output wire n_INPUT;

endmodule // IOBUF_A

module OBUF_A (  n_OUTPUT, PAD_OUT);

	input wire n_OUTPUT;
	output wire PAD_OUT;

endmodule // OBUF_A

module AOBUFFER (  VOUT, PAD_OUT);

	input wire VOUT;
	output wire PAD_OUT;

endmodule // AOBUFFER

module OBUF_B (  n_DRV_HIGH, DRV_LOW, PAD_OUT);

	input wire n_DRV_HIGH;
	input wire DRV_LOW;
	output wire PAD_OUT;

endmodule // OBUF_B

module IBUF_B (  PAD_IN, n_INPUT);

	input wire PAD_IN;
	output wire n_INPUT;

endmodule // IBUF_B

module OSC (  ENA, n_CLK, CK_IN, CK_OUT);

	input wire ENA;
	output wire n_CLK;
	input wire CK_IN;
	output wire CK_OUT;

endmodule // OSC

module AIBUFFER (  VIN, PAD_IN);

	output wire VIN;
	input wire PAD_IN;

endmodule // AIBUFFER