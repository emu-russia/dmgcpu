// ppu_standalone
// Testing the PPU in a spherical vacuum (separate from the other components).
// We just create a PPU instance, add all the plugs it needs, and try to get it going.
`timescale 1ns/1ns

module ppu_standalone();

	reg reset; 	// from Pad
	reg ck1; 		// from Pad
	always #32 ck1 = ~ck1;

	wire n_reset2;
	wire cclk;
	wire clk6;

	wire ppu_rd;
	wire ppu_wr;
	wire [7:0] h;
	wire [7:0] v;
	wire FF40_D1;
	wire FF40_D2;
	wire FF40_D3;
	wire FF43_D0;
	wire FF43_D1;
	wire FF43_D2;
	wire stop_oam_eval;
	wire obj_color;
	wire n_ppu_reset;
	wire oam_rd_ck;
	wire oam_xattr_latch_cck;
	wire oam_addr_ck;
	wire ppu1_ma0;
	wire vclk2;
	wire h_restart;
	wire obj_prio_ck;
	wire obj_prio;
	wire in_window;
	wire fexx;
	wire ff43;
	wire ff42;
	wire [12:0] nma;
	wire n_ppu_clk;
	wire bp_cy;
	wire tm_cy;	
	wire oam_mode3_bl_pch;
	wire oam_mode3_nrd;
	wire sprite_x_flip;
	wire sprite_x_match;
	wire n_dma_phi2_latched;
	wire vbl;
	wire ppu_clk;
	wire bp_sel;
	wire n_ppu_hard_reset;
	wire ppu_mode2;
	wire ppu_mode3;
	wire sp_bp_cys;

	ClkGen clkgen ( 
		.clk_ena(1'b1),
		.osc_ena(1'b1),
		.cpu_wr(1'b0),
		.test_1(1'b0), 		// Test mode disabled
		.cpu_mreq(1'b0),
		.reset(reset),
		.osc_stable(1'b1),
		.n_test_reset(~reset),
		.n_clk_in(~ck1),
		.cclk(cclk),
		.clk6(clk6),
		.n_reset2(n_reset2) );

	PPU1 ppu1_inst (
		//a,
		//d,
		//n_ma,
		.n_dma_phi(1'b0),
		.ppu_rd(ppu_rd),
		.ppu_wr(ppu_wr),
		.ppu_clk(ppu_clk), 		// <=
		.vram_to_oam(1'b0),
		.ffxx(1'b0),
		.n_ppu_hard_reset(n_ppu_hard_reset),
		.nma(nma),
		.fexx(fexx),
		.ff43(ff43),
		.ff42(ff42),
		.sprite_x_flip(sprite_x_flip),
		.sprite_x_match(sprite_x_match),
		.bp_sel(bp_sel),
		.ppu_mode3(ppu_mode3), 
		//md,
		.v(v),
		.FF43_D0(FF43_D0), 		// <=
		.FF43_D1(FF43_D1),
		.FF43_D2(FF43_D2),
		.n_ppu_clk(n_ppu_clk),
		.h(h),
		.ppu_mode2(ppu_mode2),
		.vbl(vbl),
		.stop_oam_eval(stop_oam_eval),
		.obj_color(obj_color),
		.vclk2(vclk2),
		.h_restart(h_restart),
		.obj_prio_ck(obj_prio_ck),
		.obj_prio(obj_prio),
		.n_ppu_reset(n_ppu_reset),
		.n_dma_phi2_latched(n_dma_phi2_latched),
		.FF40_D1(FF40_D1), 		// =>
		.FF40_D2(FF40_D2),
		.FF40_D3(FF40_D3),
		.in_window(in_window), 
		.sp_bp_cys(sp_bp_cys),
		.arb_fexx_ffxx(1'b0),
		.oam_mode3_bl_pch(oam_mode3_bl_pch),
		.bp_cy(bp_cy),
		.tm_cy(tm_cy),
		.oam_mode3_nrd(oam_mode3_nrd),
		.ppu1_ma0(ppu1_ma0),
		.oam_rd_ck(oam_rd_ck),
		.oam_xattr_latch_cck(oam_xattr_latch_cck),
		.oam_addr_ck(oam_addr_ck) );

	PPU2 ppu2_inst (
		.cclk(cclk),
		.clk6(clk6),
		.n_reset2(n_reset2),
		//a,
		//d,
		//n_oamb,
		//oam_bl_pch,
		//oa,
		//n_oam_rd,
		//n_oamb_wr,
		//n_oama_wr,
		//n_oama,
		.n_dma_phi(1'b0),
		//dma_a,
		.dma_run(1'b0), 
		.soc_wr(1'b0),
		.soc_rd(1'b0),
		.ppu_rd(ppu_rd),
		.ppu_wr(ppu_wr),
		.ppu_clk(ppu_clk), 		// =>
		.vram_to_oam(1'b0),
		.n_ppu_hard_reset(n_ppu_hard_reset), 
		.nma(nma),
		.fexx(fexx),
		.ff43(ff43),
		.ff42(ff42),
		.sprite_x_flip(sprite_x_flip),
		.sprite_x_match(sprite_x_match),
		.bp_sel(bp_sel),
		.ppu_mode3(ppu_mode3), 
		//md,
		//oam_din,
		.v(v),
		.FF43_D0(FF43_D0), 		// =>
		.FF43_D1(FF43_D1),
		.FF43_D2(FF43_D2),
		.n_ppu_clk(n_ppu_clk),
		.h(h),
		.ppu_mode2(ppu_mode2),
		.vbl(vbl),
		.stop_oam_eval(stop_oam_eval),
		.obj_color(obj_color),
		.vclk2(vclk2),
		.h_restart(h_restart),
		.obj_prio_ck(obj_prio_ck),
		.obj_prio(obj_prio),
		.n_ppu_reset(n_ppu_reset),
		.n_dma_phi2_latched(n_dma_phi2_latched),
		.FF40_D1(FF40_D1), 		// <=
		.FF40_D2(FF40_D2),
		.FF40_D3(FF40_D3),
		.in_window(in_window), 
		.dma_addr_ext(1'b0),
		.sp_bp_cys(sp_bp_cys),
		.cpu_vram_oam_rd(1'b0),
		.oam_dma_wr(1'b0),
		.oam_mode3_bl_pch(oam_mode3_bl_pch),
		.bp_cy(bp_cy),
		.tm_cy(tm_cy),
		.oam_mode3_nrd(oam_mode3_nrd),
		.ma0(ppu1_ma0),
		.oam_rd_ck(oam_rd_ck),
		.oam_xattr_latch_cck(oam_xattr_latch_cck),
		.oam_addr_ck(oam_addr_ck) );

	initial begin
		$display("Running ppu_standalone");

		ck1 = 1'b0;

		$dumpfile("ppu_standalone.vcd");
		$dumpvars(0, ppu_standalone);

		reset = 1'b1;
		repeat (8) @ (posedge ck1);
		reset = 1'b0;

		ppu1_inst.g656.val = 1; 		// LCDC[7] LCD&PPU Enable=1

		repeat (4096) @ (posedge ck1);

		$finish;
	end

endmodule  // ppu_standalone

// PPU Mocks...