module WaveRAM (  d[7], d[6], d[5], d[4], d[3], d[2], d[1], d[0], active, a[2], a[3], a[0], a[1], dout[0], dout[1], dout[2], dout[3], dout[4], dout[5], dout[6], dout[7], n_wr, bl_pch, n_rd);

	inout wire d[7];
	inout wire d[6];
	inout wire d[5];
	inout wire d[4];
	inout wire d[3];
	inout wire d[2];
	inout wire d[1];
	inout wire d[0];
	input wire active;
	input wire a[2];
	input wire a[3];
	input wire a[0];
	input wire a[1];
	output wire dout[0];
	output wire dout[1];
	output wire dout[2];
	output wire dout[3];
	output wire dout[4];
	output wire dout[5];
	output wire dout[6];
	output wire dout[7];
	input wire n_wr;
	input wire bl_pch;
	input wire n_rd;

endmodule // WaveRAM