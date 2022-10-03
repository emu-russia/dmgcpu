
module DataBridge( CLK2, DataOut, DV, DL );

	input CLK2;
	input DataOut;
	input [7:0] DV;
	inout [7:0] DL;

	bridge_comb bridge_bits [7:0] (
		.clk(CLK2), 
		.dl_bit(DL),
		.dv_bit(DV),
		.DataOut(DataOut) );

endmodule // DataBridge

module bridge_comb ( clk, dl_bit, dv_bit, DataOut );

	input clk;
	output dl_bit;
	input dv_bit;
	input DataOut;

	assign dl_bit = clk ? ~(~dv_bit & DataOut) : 1'b1;

endmodule // bridge_comb
