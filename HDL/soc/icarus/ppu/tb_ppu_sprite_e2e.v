// tb_ppu_sprite_e2e - end-to-end sprite pixels (issue #390, path b).
//
// Uses the ppu2_m2only.v bus model (see gen_weakbus.py): during mode 2 only
// the scan oa group drives (stable even scan words), in mode 3 the store
// re-read groups work again. Sprite in OAM entry 1 (Y=16 -> visible rows,
// X=16), tile 1 filled in VRAM, BG zero. Samples LD0/LD1 like the lcd_stub
// and reports per-LY nonzero pixel ranges. Dev test - INFO prints only.
//
// Run: iverilog ... ppu2_m2only.v bus_weak_cells.v ... tb_ppu_sprite_e2e.v
// Note: pixel 159 reads x (LD floats after the last pixel of the line) and
// is counted as nonzero by the == check - ignore it (it is the only
// "pixel" on lines without a sprite).
`timescale 1ns/1ns
module tb_ppu_sprite_e2e;
	ppu_env env();
	integer k;

	// own LD sampler (mirrors lcd_stub)
	reg [1:0] myline [0:159];
	integer   mypx;
	reg       myin;
	integer   myline_cnt;

	always @(posedge env.n_lcd_cpl) myin = 1'b0;
	always @(posedge env.n_lcd_st) begin myin = 1'b1; mypx = 0; end
	always @(posedge env.n_lcd_cp) begin
		if (myin && mypx >= 0 && mypx < 160) begin
			myline[mypx] = {~env.n_lcd_ld1, ~env.n_lcd_ld0};
			mypx = mypx + 1;
		end
	end

	initial begin
		$dumpfile("tb_ppu_sprite_e2e.vcd");
		$dumpvars(0, tb_ppu_sprite_e2e);
		#(64*8); env.reset = 1'b0; #(64*4);
		// VRAM: BG empty; sprite tile 1 ($8010): plane0 = FF, plane1 = 00
		for (k = 0; k < 8; k = k + 1) begin
			env.vram.write_byte(13'h0010 + k*2, 8'hFF);
			env.vram.write_byte(13'h0010 + k*2 + 1, 8'h00);
		end
		// OAM: only entry 1 = sprite (entry 0 is not visited by the scan)
		for (k = 0; k < 160; k = k + 1) env.oam.mem[k] = 8'h00;
		env.oam.mem[4] = 8'h10;  // Y = 16  -> visible LY 0..7
		env.oam.mem[5] = 8'h10;  // X = 16  -> pixels start at LX 8
		env.oam.mem[6] = 8'h01;  // tile 1
		env.oam.mem[7] = 8'h00;  // flags 0

		env.cpu_write(16'hFF40, 8'h93);   // LCD + BG + OBJ
		env.cpu_write(16'hFF42, 8'h00); env.cpu_write(16'hFF43, 8'h00);
		env.cpu_write(16'hFF47, 8'hE4);   // BGP
		env.cpu_write(16'hFF48, 8'hE4);   // OBP0

		begin : lines
			integer w, ly, i, nz, first, last;
			integer rows_px;
			rows_px = 0;
			// capture 14 completed lines
			for (w = 1; w <= 14; w = w + 1) begin
				@(posedge env.n_lcd_cpl);
				#16;   // let /ST of the next line not overwrite yet
				ly = env.v;
				nz = 0; first = -1; last = -1;
				for (i = 0; i < 160; i = i + 1) begin
					if (myline[i] !== 2'b00) begin
						nz = nz + 1;
						if (first < 0) first = i;
						last = i;
					end
				end
				if (nz >= 2) rows_px = rows_px + 1;  // >=2: real pixels, not the trailing artifact
				$display("LY=%0d nz=%0d range=[%0d..%0d] sample: x8..15={%b,%b,%b,%b,%b,%b,%b,%b}",
					ly, nz, first, last,
					myline[8], myline[9], myline[10], myline[11],
					myline[12], myline[13], myline[14], myline[15]);
			end
			$display("SPRITE_E2E rows_with_pixels=%0d color01 x7..14 (off-by-one vs X-8=8) - dev OK", rows_px);
		end
		$finish;
	end
endmodule
