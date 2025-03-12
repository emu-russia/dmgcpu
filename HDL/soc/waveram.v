module WaveRAM (  d, active, a, dout, n_wr, bl_pch, n_rd);

	inout wire [7:0] d;
	input wire active;
	input wire [15:0] a; 		// 3:0 are used only
	output wire [7:0] dout;
	input wire n_wr;
	input wire bl_pch;
	input wire n_rd;

endmodule // WaveRAM