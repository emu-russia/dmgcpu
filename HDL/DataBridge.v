`timescale 1ns/1ns

module DataBridge( DataOut, DV, DL );

	input DataOut;		// DV -> DL
	input [7:0] DV;		// ALU Operand2
	inout [7:0] DL;		// Internal databus

	bridge_comb bridge_bits [7:0] (
		.dl_bit(DL),
		.dv_bit(DV),
		.DataOut({8{DataOut}}) );

endmodule // DataBridge

module bridge_comb ( dl_bit, dv_bit, DataOut );

	inout dl_bit;
	input dv_bit;
	input DataOut;

	assign dl_bit = DataOut && ~dv_bit ? 1'b0 : 1'bz;

endmodule // bridge_comb
