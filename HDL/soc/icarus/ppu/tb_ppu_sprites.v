// tb_ppu_sprites - bring-up observation of the OAM scan / sprite path.
`timescale 1ns/1ns

module tb_ppu_sprites;

	ppu_env env();

	integer k;

	initial begin
		$dumpfile("tb_ppu_sprites.vcd");
		$dumpvars(0, tb_ppu_sprites);
		#(64*8);
		env.reset = 1'b0;
		#(64*4);

		// VRAM: map $9800 empty (tile 0) + tile 1 data for BG = nothing
		// OAM entry 0: sprite at Y=16, X=16, tile $01, flags $00
		env.oam.mem[0] = 8'h10;   // Y = 16 (LY+16 in OAM encoding)
		env.oam.mem[1] = 8'h10;   // X = 16
		env.oam.mem[2] = 8'h01;   // tile $01
		env.oam.mem[3] = 8'h00;   // flags: palette 0, no flip, no prio
		// OAM entry 1: off-screen Y=0 (Y=0 means... just in case)
		env.oam.mem[4] = 8'h00;
		env.oam.mem[5] = 8'h40;
		env.oam.mem[6] = 8'h01;
		env.oam.mem[7] = 8'h00;
		// sprite tile 1 (8x8, $8000 tiles, rows 0..7), row encoding
		// interleaved byte pairs: plane0 row r = byte 2r of the tile
		for (k = 0; k < 8; k = k + 1) begin
			env.vram.write_byte(13'h0010 + k*2, 8'hFF);      // plane0
			env.vram.write_byte(13'h0010 + k*2 + 1, 8'h00);  // plane1
		end

		// PPU: LCD on, BG on, OBJ on, 8x8 sprites
		env.cpu_write(16'hFF40, 8'h93);   // bit7+bit1(OBJ)+bit0(BG)
		env.cpu_write(16'hFF42, 8'h00);
		env.cpu_write(16'hFF43, 8'h00);
		env.cpu_write(16'hFF47, 8'hE4);
		env.cpu_write(16'hFF48, 8'hE4);   // OBP0

		// run 2 lines
		// wait for the 3rd mode2 window and sample oa bits every 512 ns
		while (!env.ppu_mode2) @(posedge env.ppu_clk);
		begin : oasamp
			integer q;
			for (q = 0; q < 8; q = q + 1) begin
				$display("t=%0t mode2=%b oa=%b w497=%b w146=%b w500=%b en(w48)=%b en(w518)=%b en(w475)=%b en(w403)=%b en(w444)=%b",
				  $time, env.ppu_mode2, env.oa, env.ppu2.w497, env.ppu2.w146, env.ppu2.w500,
				  env.ppu2.w48, env.ppu2.w518, env.ppu2.w475, env.ppu2.w403, env.ppu2.w444);
				#512;
			end
		end
		repeat (1000) @(posedge env.ppu_clk);
		$finish;
	end

endmodule
