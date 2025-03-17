module APU (  cclk, clk2, clk4, clk6, clk7, clk9, n_reset2, a, d, cpu_wakeup, n_DRV_HIGH_a, n_INPUT_a, DRV_LOW_a,  
	n_sout_topad, n_DRV_HIGH_sin, n_ENA_PU_sin, DRV_LOW_sin, n_DRV_HIGH_sck, sck_dir, DRV_LOW_sck, n_DRV_HIGH_p10, CONST0, n_p10, DRV_LOW_p10, n_DRV_HIGH_p11, n_p11, DRV_LOW_p11, n_DRV_HIGH_p12, n_p12, DRV_LOW_p12, n_DRV_HIGH_p13, n_p13, DRV_LOW_p13, n_DRV_HIGH_p14, DRV_LOW_p14, n_DRV_HIGH_p15, DRV_LOW_p15, 
	dma_a, soc_wr, soc_rd, lfo_512Hz, ser_out, serial_tick, test_1, test_2, n_ext_addr_en, ch3_active, 
	wave_a, wave_rd, n_wave_wr, wave_bl_pch, n_wave_rd, addr_latch, int_jp, FF60_D1, ffxx, n_ch1_amp_en, n_ch2_amp_en, n_ch3_amp_en, n_ch4_amp_en, 
	ch1_out, ch2_out, ch3_out, ch4_out, r_vin_en, rmixer, l_vin_en, lmixer, n_rvolume, n_lvolume, dma_addr_ext);

	input wire cclk;
	input wire clk2;
	input wire clk4;
	input wire clk6;
	input wire clk7;
	input wire clk9;
	input wire n_reset2;
	inout wire [7:0] a; 			// 7:0 are used only   ⚠️ bidir
	inout wire [7:0] d;
	output wire cpu_wakeup;
	output wire [7:0] n_DRV_HIGH_a;
	input wire [7:0] n_INPUT_a;
	output wire [7:0] DRV_LOW_a;
	output wire n_sout_topad;
	output wire n_DRV_HIGH_sin;
	output wire n_ENA_PU_sin;
	output wire DRV_LOW_sin;
	output wire n_DRV_HIGH_sck;
	input wire sck_dir;
	output wire DRV_LOW_sck;
	output wire n_DRV_HIGH_p10;
	input wire CONST0;
	input wire n_p10;
	output wire DRV_LOW_p10;
	output wire n_DRV_HIGH_p11;
	input wire n_p11;
	output wire DRV_LOW_p11;
	output wire n_DRV_HIGH_p12;
	input wire n_p12;
	output wire DRV_LOW_p12;
	output wire n_DRV_HIGH_p13;
	input wire n_p13;
	output wire DRV_LOW_p13;
	output wire n_DRV_HIGH_p14;
	output wire DRV_LOW_p14;
	output wire n_DRV_HIGH_p15;
	output wire DRV_LOW_p15;
	input wire [7:0] dma_a; 		// 7:0 are used only
	input wire soc_wr;
	input wire soc_rd;
	input wire lfo_512Hz;
	input wire ser_out;
	input wire serial_tick;
	input wire test_1;
	input wire test_2;
	input wire n_ext_addr_en;
	output wire ch3_active;
	output wire [3:0] wave_a;
	input wire [7:0] wave_rd;
	output wire n_wave_wr;
	output wire wave_bl_pch;
	output wire n_wave_rd;
	input wire addr_latch;
	output wire int_jp;
	output wire FF60_D1;
	input wire ffxx;
	output wire n_ch1_amp_en;
	output wire n_ch2_amp_en;
	output wire n_ch3_amp_en;
	output wire n_ch4_amp_en;
	output wire [3:0] ch1_out;
	output wire [3:0] ch2_out;
	output wire [3:0] ch3_out;
	output wire [3:0] ch4_out;
	output wire r_vin_en;
	output wire [3:0] rmixer;
	output wire l_vin_en;
	output wire [3:0] lmixer;
	output wire [2:0] n_rvolume;
	output wire [2:0] n_lvolume;
	input wire dma_addr_ext;

endmodule // APU