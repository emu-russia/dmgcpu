module PPU1 (  a, d, n_ma, lcd_ld1, lcd_ld0, lcd_cpg, lcd_cp, lcd_st, lcd_cpl, lcd_fr, lcd_s, CONST0, n_dma_phi, ppu_rd, ppu_wr, ppu_clk, vram_to_oam, ffxx, n_ppu_hard_reset, ff46, 
	nma, fexx, ff43, ff42, sprite_x_flip, sprite_x_match, bp_sel, ppu_mode3, 
	md, v, FF43_D1, FF43_D0, n_ppu_clk, FF43_D2, h, ppu_mode2, vbl, stop_oam_eval, obj_color, vclk2, h_restart, obj_prio_ck, obj_prio, n_ppu_reset, n_dma_phi2_latched, FF40_D3, FF40_D2, in_window, 
	FF40_D1, sp_bp_cys, tm_bp_cys, ppu1_RAWA, n_tm_bp_cys, arb_fexx_ffxx, ppu_int_stat, ppu_int_vbl, ppu1_XUJY, bp_cy, tm_cy, ppu1_XUJA, ppu1_ma0, ppu1_XOCE, ppu1_XYSO, ppu1_XUPY);

	input wire [15:0] a;
	inout wire [7:0] d;
	output wire [12:0] n_ma;
	output wire lcd_ld1;
	output wire lcd_ld0;
	output wire lcd_cpg;
	output wire lcd_cp;
	output wire lcd_st;
	output wire lcd_cpl;
	output wire lcd_fr;
	output wire lcd_s;
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

	// H/V

	output wire [7:0] h;
	output wire [7:0] v;

	// Unknowns

	output wire ppu1_RAWA; 		// to arb
	output wire ppu1_XUJA;
	output wire ppu1_XOCE;
	output wire ppu1_XYSO;
	output wire ppu1_XUPY;
	output wire ppu1_XUJY;

endmodule // PPU1

module PPU2 (  cclk, clk6, n_reset2, a, d, n_oamb, oam_bl_pch, oa, n_oam_rd, n_oamb_wr, n_oama_wr, n_oama, CONST0, n_dma_phi, 
	dma_a, dma_run, 
	soc_wr, soc_rd, ppu_rd, ppu_wr, ppu_clk, vram_to_oam, n_ppu_hard_reset, 
	nma, fexx, ff43, ff42, sprite_x_flip, sprite_x_match, bp_sel, ppu_mode3, 
	md, oam_din, v, FF43_D1, FF43_D0, n_ppu_clk, FF43_D2, h, ppu_mode2, vbl, stop_oam_eval, obj_color, vclk2, h_restart, obj_prio_ck, obj_prio, n_ppu_reset, 
	oam_to_vram, n_dma_phi2_latched, FF40_D3, FF40_D2, in_window, 
	FF40_D1, dma_addr_ext, sp_bp_cys, cpu_vram_oam_rd, oam_dma_wr, clk6_delay, from_ppu1_XUJY, bp_cy, tm_cy, from_ppu1_XUJA, ma0, from_ppu1_XOCE, from_ppu1_XYSO, from_ppu1_XUPY);

	input wire cclk;
	input wire clk6;
	input wire n_reset2;
	input wire [15:0] a;
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
	input wire [15:0] dma_a; 	// 15, 12:0 are used only
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

	// H/V
	input wire [7:0] h;
	input wire [7:0] v;

	// Unknowns

	input wire from_ppu1_XUJA;
	input wire from_ppu1_XOCE;
	input wire from_ppu1_XYSO;
	input wire from_ppu1_XUPY;
	input wire from_ppu1_XUJY;

endmodule // PPU2