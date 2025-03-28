// ppu_standalone
// Testing the PPU in a spherical vacuum (separate from the other components).
// We just create a PPU instance, add all the plugs it needs, and try to get it going.
`timescale 1ns/1ns

module ppu_standalone();

	reg n_ppu_reset;
	reg ppu_clk; 		// PPU 4MHz	
	always #32 ppu_clk = ~ppu_clk;

	PPU1 ppu1_inst (
		//.a(0),
		//.d(0),
 		.n_dma_phi(1'b0),
 		.ppu_rd(1'b0),
 		.ppu_wr(1'b0),
 		.ppu_clk(ppu_clk),
 		.vram_to_oam(1'b0),
 		.ffxx(1'b0),
 		.n_ppu_hard_reset(n_ppu_reset),
		//.nma(0), 
		.sprite_x_flip(1'b0), 
		.sprite_x_match(1'b0), 
		//.md(0), 
		.FF43_D0(1'b0),
		.FF43_D1(1'b0),
		.FF43_D2(1'b0),
		.n_ppu_clk(~ppu_clk),
		.ppu_mode2(1'b0),
		.stop_oam_eval(1'b0),
		.obj_color(1'b0), 
		.h_restart(1'b0),
		.obj_prio(1'b0),
		.arb_fexx_ffxx(1'b0) );

	initial begin
		$display("Running ppu_standalone");

		ppu_clk = 1'b0;

		$dumpfile("ppu_standalone.vcd");
		$dumpvars(0, ppu_standalone);

		n_ppu_reset = 1'b0;
		repeat (8) @ (posedge ppu_clk);
		n_ppu_reset = 1'b1;

		repeat (4096) @ (posedge ppu_clk);

		$finish;
	end

endmodule  // ppu_standalone

// PPU Mocks...