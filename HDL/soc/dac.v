module DAC (  vin_analog, so2_analog, so1_analog, n_ch1_amp_en, n_ch2_amp_en, n_ch3_amp_en, n_ch4_amp_en, 
	ch1_out, ch2_out, ch3_out, ch4_out, 
	r_vin_en, rmixer, l_vin_en, lmixer, n_rvolume, n_lvolume );

	input wire vin_analog;
	output wire so2_analog;
	output wire so1_analog;
	input wire n_ch1_amp_en;
	input wire n_ch2_amp_en;
	input wire n_ch3_amp_en;
	input wire n_ch4_amp_en;
	input wire [3:0] ch1_out;
	input wire [3:0] ch2_out;
	input wire [3:0] ch3_out;
	input wire [3:0] ch4_out;
	input wire r_vin_en;
	input wire [3:0] rmixer;
	input wire l_vin_en;
	input wire [3:0] lmixer;
	input wire [2:0] n_rvolume;
	input wire [2:0] n_lvolume;

endmodule // DAC