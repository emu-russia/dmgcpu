// http://iceboy.a-singer.de/doc/dmg_cells.html#pad
// https://github.com/emu-russia/dmgcpu/blob/main/wiki/soc/pads.md

// TBD: Preliminary version, maybe we shouldn't do it so low-level

// PAD_BIDIR
module IOBUF_A (  PAD_IO, n_DRV_HIGH, DRV_LOW, n_INPUT);

	inout wire PAD_IO;
	input wire n_DRV_HIGH;
	input wire DRV_LOW;
	output wire n_INPUT;

	assign PAD_IO = DRV_LOW ? 1'b0 : (n_DRV_HIGH == 1'b0 ? 1'b1 : PAD_IO); 	// drive pad output
	wire from_pad;
	assign from_pad = PAD_IO == 1'bz ? 1'b1 : PAD_IO; 		// always pulled up
	not (n_INPUT, from_pad); 	// no need in latch

endmodule // IOBUF_A

// PAD_BIDIR_ENA_PU
module IOBUF_B (  DRV_LOW, n_INPUT, n_ENA_PU, n_DRV_HIGH, PAD_IO);

	input wire DRV_LOW;
	output wire n_INPUT;
	input wire n_ENA_PU;
	input wire n_DRV_HIGH;
	inout wire PAD_IO;

	assign PAD_IO = DRV_LOW ? 1'b0 : (n_DRV_HIGH == 1'b0 ? 1'b1 : PAD_IO); 		// drive pad output
	wire from_pad;
	assign from_pad = PAD_IO == 1'bz ? (n_ENA_PU == 1'b0 ? 1'b1 : 1'bz) : PAD_IO; 	// pullup pad input
	pad_transp_latch transp (.d(from_pad), .nq(n_INPUT));

endmodule // IOBUF_B

// PAD_BIDIR_SCK
module IOBUF_C (  n_DRV_HIGH, n_ENA_PU, DRV_LOW, n_INPUT, PAD_IO);

	input wire n_DRV_HIGH;
	input wire n_ENA_PU;
	input wire DRV_LOW;
	output wire n_INPUT;
	inout wire PAD_IO;

	assign PAD_IO = DRV_LOW ? 1'b0 : (n_DRV_HIGH == 1'b0 ? 1'b1 : PAD_IO); 		// drive pad output
	wire from_pad;
	assign from_pad = PAD_IO == 1'bz ? (n_ENA_PU == 1'b0 ? 1'b1 : 1'bz) : PAD_IO; 	// pullup pad input
	wire latch_q;
	dmg_nand_latch latch ( .nr(from_pad), .ns(~from_pad), .q(latch_q));
	not (n_INPUT, latch_q);

endmodule // IOBUF_C

// PAD_IN
module IBUF_A (  n_INPUT, PAD_IN);

	output wire n_INPUT;
	input wire PAD_IN;

	pad_transp_latch transp (.d(PAD_IN), .nq(n_INPUT));

endmodule // IBUF_A

// PAD_IN_PU
module IBUF_B (  PAD_IN, n_INPUT);

	input wire PAD_IN;
	output wire n_INPUT;

	not (n_INPUT, PAD_IN == 1'bz ? 1'b1 : PAD_IN);

endmodule // IBUF_B

// PAD_OUT
module OBUF_A (  n_OUTPUT, PAD_OUT);

	input wire n_OUTPUT;
	output wire PAD_OUT;

	not (PAD_OUT, n_OUTPUT);

endmodule // OBUF_A

// PAD_OUT_DIFF
module OBUF_B (  n_DRV_HIGH, DRV_LOW, PAD_OUT);

	input wire n_DRV_HIGH;
	input wire DRV_LOW;
	output wire PAD_OUT;

	assign PAD_OUT = DRV_LOW /*ground wins?*/ ? 1'b0 : (n_DRV_HIGH == 1'b0 ? 1'b1 : 1'bz);

endmodule // OBUF_B

module OSC (  ENA, n_CLK, CK_IN, CK_OUT);

	input wire ENA;
	output wire n_CLK;
	input wire CK_IN;
	output wire CK_OUT;

	wire clk;
	assign clk = ENA ? CK_IN : 1'b1;
	not (n_CLK, clk);
	not (CK_OUT, clk);

endmodule // OSC

module AOBUFFER (  VOUT, PAD_OUT);

	input wire VOUT;
	output wire PAD_OUT;

	// TBD.

endmodule // AOBUFFER

module AIBUFFER (  VIN, PAD_IN);

	output wire VIN;
	input wire PAD_IN;

	// TBD.

endmodule // AIBUFFER

// Transparent latch
// The role of Transparent latch in Pad circuits is played by a conventional inverter
module pad_transp_latch (d, nq);

	input d;
	output nq;

	reg val;
	// The transparent latch value is stored on the FET gate. We assume that initially there is no charge there, i.e. the value is 0.
	initial val = 1'b0;

	always @(*) begin
		case (d)
			1'b1: val <= 1'b1;
			1'b0: val <= 1'b0;
			1'bz: val <= val;
		endcase
	end

	assign nq = ~val;

endmodule // pad_transp_latch