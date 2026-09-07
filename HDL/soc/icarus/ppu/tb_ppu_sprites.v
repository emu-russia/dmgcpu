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

		// probe the PPU1 obj_prio_ck / sprite-ring chain inside a mode2 window
		begin : probe
			integer q;
			// trace the PPU1 sprite-process FF chain through a mode3 window
			while (!env.ppu_mode3) @(posedge env.ppu_clk);
			for (q = 0; q < 1500; q = q + 1) begin
				if ((q % 50) == 0) begin
					$display("F t=%0t m3=%b w228=%b w229=%b w241=%b w240=%b w239=%b opc=%b w815=%b w230=%b w521=%b w227=%b",
					  $time, env.ppu_mode3, env.ppu1.w228, env.ppu1.w229, env.ppu1.w241,
					  env.ppu1.w240, env.ppu1.w239, env.ppu1.w291, env.ppu1.w815,
					  env.ppu1.w230, env.ppu1.w521, env.ppu1.w227);
				end
				if (env.ppu1.w291 === 1'b1) begin
					$display("P t=%0t m2=%b opc(w291)=%b w290=%b w239=%b w240=%b ring=%b%b%b%b,%b,%b,%b w509=%b w416=%b w405=%b w44=%b",
					  $time, env.ppu_mode2, env.ppu1.w291, env.ppu1.w290, env.ppu1.w239, env.ppu1.w240,
					  env.ppu1.g282.val, env.ppu1.g283.val, env.ppu1.g284.val, env.ppu1.g285.val,
					  env.ppu1.g316.val, env.ppu1.g317.val, env.ppu1.g319.val,
					  env.ppu1.w509, env.ppu1.w416, env.ppu1.w405, env.ppu1.w44);
				end
				#128;
			end
		end
		repeat (1000) @(posedge env.ppu_clk);
		$finish;
	end

endmodule
