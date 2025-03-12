module dmgcpu_IOBUF_B (  DRV_LOW, n_INPUT, n_ENA_PU, n_DRV_HIGH, PAD_IO);

	input wire DRV_LOW;
	output wire n_INPUT;
	input wire n_ENA_PU;
	input wire n_DRV_HIGH;
	inout wire PAD_IO;

endmodule // dmgcpu_IOBUF_B

module dmgcpu_IOBUF_C (  n_DRV_HIGH, n_ENA_PU, DRV_LOW, n_INPUT, PAD_IO);

	input wire n_DRV_HIGH;
	input wire n_ENA_PU;
	input wire DRV_LOW;
	output wire n_INPUT;
	inout wire PAD_IO;

endmodule // dmgcpu_IOBUF_C

module dmgcpu_IBUF_A (  n_INPUT, PAD_IN);

	output wire n_INPUT;
	input wire PAD_IN;

endmodule // dmgcpu_IBUF_A

module dmgcpu_IOBUF_A (  PAD_IO, n_DRV_HIGH, DRV_LOW, n_INPUT);

	inout wire PAD_IO;
	input wire n_DRV_HIGH;
	input wire DRV_LOW;
	output wire n_INPUT;

endmodule // dmgcpu_IOBUF_A

module dmgcpu_OBUF_A (  n_OUTPUT, PAD_OUT);

	input wire n_OUTPUT;
	output wire PAD_OUT;

endmodule // dmgcpu_OBUF_A

module dmgcpu_AOBUFFER (  VOUT, PAD_OUT);

	input wire VOUT;
	output wire PAD_OUT;

endmodule // dmgcpu_AOBUFFER

module dmgcpu_OBUF_B (  n_DRV_HIGH, DRV_LOW, PAD_OUT);

	input wire n_DRV_HIGH;
	input wire DRV_LOW;
	output wire PAD_OUT;

endmodule // dmgcpu_OBUF_B

module dmgcpu_IBUF_B (  PAD_IN, n_INPUT);

	input wire PAD_IN;
	output wire n_INPUT;

endmodule // dmgcpu_IBUF_B

module dmgcpu_OSC (  ENA, n_CLK, CK_IN, CK_OUT);

	input wire ENA;
	output wire n_CLK;
	input wire CK_IN;
	output wire CK_OUT;

endmodule // dmgcpu_OSC

module dmgcpu_AIBUFFER (  VIN, PAD_IN);

	output wire VIN;
	input wire PAD_IN;

endmodule // dmgcpu_AIBUFFER