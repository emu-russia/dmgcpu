module PPU1 (  a, d, n_ma, n_lcd_ld1, n_lcd_ld0, n_lcd_cpg, n_lcd_cp, n_lcd_st, n_lcd_cpl, n_lcd_fr, n_lcd_s, CONST0, n_dma_phi, ppu_rd, ppu_wr, ppu_clk, vram_to_oam, ffxx, n_ppu_hard_reset, ff46, 
	nma, fexx, ff43, ff42, sprite_x_flip, sprite_x_match, bp_sel, ppu_mode3, 
	md, v, FF43_D1, FF43_D0, n_ppu_clk, FF43_D2, h, ppu_mode2, vbl, stop_oam_eval, obj_color, vclk2, h_restart, obj_prio_ck, obj_prio, n_ppu_reset, n_dma_phi2_latched, FF40_D3, FF40_D2, in_window, 
	FF40_D1, sp_bp_cys, tm_bp_cys, n_sp_bp_mrd, n_tm_bp_cys, arb_fexx_ffxx, ppu_int_stat, ppu_int_vbl, oam_mode3_bl_pch, bp_cy, tm_cy, oam_mode3_nrd, ppu1_ma0, oam_rd_ck, oam_xattr_latch_cck, oam_addr_ck);

	input wire [12:0] a;
	inout wire [7:0] d;
	output wire [12:0] n_ma;
	output wire n_lcd_ld1;
	output wire n_lcd_ld0;
	output wire n_lcd_cpg;
	output wire n_lcd_cp;
	output wire n_lcd_st;
	output wire n_lcd_cpl;
	output wire n_lcd_fr;
	output wire n_lcd_s;
	input wire CONST0;
	input wire n_dma_phi;
	input wire ppu_rd;
	input wire ppu_wr;
	input wire ppu_clk;
	input wire vram_to_oam;
	input wire ffxx;
	input wire n_ppu_hard_reset;
	output wire ff46;
	inout wire [12:0] nma;
	output wire fexx;
	output wire ff43;
	output wire ff42;
	input wire sprite_x_flip;
	input wire sprite_x_match;
	output wire bp_sel;
	output wire ppu_mode3;
	inout wire [7:0] md;
	input wire FF43_D1;
	input wire FF43_D0;
	input wire n_ppu_clk;
	input wire FF43_D2;
	input wire ppu_mode2;
	output wire vbl;
	input wire stop_oam_eval;
	input wire obj_color;
	output wire vclk2;
	input wire obj_prio;
	output wire n_ppu_reset;
	output wire FF40_D3;
	output wire FF40_D2;
	output wire in_window;
	output wire FF40_D1;
	output wire sp_bp_cys;
	output wire tm_bp_cys;
	output wire n_tm_bp_cys;
	input wire arb_fexx_ffxx;
	output wire ppu_int_stat;
	output wire ppu_int_vbl;
	output wire bp_cy;
	output wire tm_cy;
	input wire h_restart;
	output wire obj_prio_ck;
	output wire n_dma_phi2_latched;
	output wire ppu1_ma0;
	output wire n_sp_bp_mrd; 		// to arb

	output wire oam_mode3_nrd;  		// is low when OAM is read during MODE3 (pixel transfer stage)
	output wire oam_mode3_bl_pch;
	// @msinger: I guess you already noticed yourself that XUJY(oam_mode3_bl_pch) is the same as XUJA(oam_mode3_nrd), but it is low for a little bit longer.
	// I don't know why it is longer, but it seems to be used to control the OAM bitline precharging during MODE3. It disables the precharging temporarily so that the read access can be performed.   (#328)

	// OAM Clocks
	output wire oam_rd_ck;
	output wire oam_xattr_latch_cck;
	output wire oam_addr_ck;

	// H/V

	output wire [7:0] h;
	output wire [7:0] v;

endmodule // PPU1

module PPU2 (  cclk, clk6, n_reset2, a, d, n_oamb, oam_bl_pch, oa, n_oam_rd, n_oamb_wr, n_oama_wr, n_oama, CONST0, n_dma_phi, 
	dma_a, dma_run, 
	soc_wr, soc_rd, ppu_rd, ppu_wr, ppu_clk, vram_to_oam, n_ppu_hard_reset, 
	nma, fexx, ff43, ff42, sprite_x_flip, sprite_x_match, bp_sel, ppu_mode3, 
	md, oam_din, v, FF43_D1, FF43_D0, n_ppu_clk, FF43_D2, h, ppu_mode2, vbl, stop_oam_eval, obj_color, vclk2, h_restart, obj_prio_ck, obj_prio, n_ppu_reset, 
	oam_to_vram, n_dma_phi2_latched, FF40_D3, FF40_D2, in_window, 
	FF40_D1, dma_addr_ext, sp_bp_cys, cpu_vram_oam_rd, oam_dma_wr, clk6_delay, oam_mode3_bl_pch, bp_cy, tm_cy, oam_mode3_nrd, ma0, oam_rd_ck, oam_xattr_latch_cck, oam_addr_ck);

	input wire cclk;
	input wire clk6;
	input wire n_reset2;
	input wire [7:0] a;
	inout wire [7:0] d;
	inout wire [7:0] n_oamb;
	output wire oam_bl_pch;
	output wire [7:1] oa; 		// ⚠️ lsb=1
	output wire n_oam_rd;
	output wire n_oamb_wr;
	output wire n_oama_wr;
	inout wire [7:0] n_oama;
	input wire CONST0;
	input wire n_dma_phi;
	input wire [12:0] dma_a;
	input wire dma_run;
	input wire soc_wr;
	input wire soc_rd;
	output wire ppu_rd;
	output wire ppu_wr;
	output wire ppu_clk;
	input wire vram_to_oam;
	output wire n_ppu_hard_reset;
	inout wire [12:0] nma;
	input wire fexx;
	input wire ff43;
	input wire ff42;
	output wire sprite_x_flip;
	output wire sprite_x_match;
	input wire bp_sel;
	input wire ppu_mode3;
	inout wire [7:0] md;
	output wire FF43_D1;
	output wire FF43_D0;
	output wire n_ppu_clk;
	output wire FF43_D2;
	output wire ppu_mode2;
	input wire vbl;
	output wire stop_oam_eval;
	output wire obj_color;
	input wire vclk2;
	output wire obj_prio;
	input wire n_ppu_reset;
	input wire FF40_D3;
	input wire FF40_D2;
	input wire in_window;
	input wire FF40_D1;
	input wire sp_bp_cys;
	input wire cpu_vram_oam_rd;
	output wire clk6_delay;
	input wire bp_cy;
	input wire tm_cy;
	input wire [7:0] oam_din;
	input wire dma_addr_ext;
	input wire oam_dma_wr;
	input wire obj_prio_ck;
	input wire n_dma_phi2_latched;
	input wire ma0;
	output wire h_restart;
	output wire oam_to_vram;
	input wire oam_mode3_nrd;
	input wire oam_mode3_bl_pch;
	input wire oam_rd_ck;
	input wire oam_xattr_latch_cck;
	input wire oam_addr_ck;

	// H/V
	input wire [7:0] h;
	input wire [7:0] v;

endmodule // PPU2