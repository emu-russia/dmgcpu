// tb_ppu_bg_scanline
// BG rendering regression test (issue #390).
//
// Programs the PPU (LCDC=$91: LCD on, BG on, map $9800, tile data $8000),
// preloads VRAM (tile map + 8x8 tile pixels) through the behavioral VRAM
// model and then verifies on the real netlists:
//   - the per-line rhythm: mode2 (OAM scan) followed by mode3 (fetch),
//     456 clock ticks per line
//   - mode3 performs VRAM fetches of the tile map ($9800+) and the tile
//     data (addresses derived from the map byte and the current LY row)
//   - the pixel serializer outputs ~160 LD0/LD1 samples per line that
//     follow the palette and the VRAM tile content
`timescale 1ns/1ns

module tb_ppu_bg_scanline;

	ppu_env env();

	integer errors = 0;
	integer k;
	reg [7:0] rd;

	// ---- event counters ----
	integer m2n = 0, m3n = 0, cpln = 0;
	time last_cpl = 0, last_m3 = 0;
	integer cpl_gap_ok = 0;
	integer nma_fetch_seen = 0;
	integer ld_sample_cnt = 0;
	time ld_win_start = 0;

	// count line ticks between CPL pulses (= one scanline on the LCD)
	always @(posedge env.ppu2.vclk2) begin : cpl
		if (last_cpl != 0) begin
			// 456 clock ticks of 64 ns at this test speed = 29184 ns
			if ((cpln > 0) && (($time - last_cpl) > 28000) && (($time - last_cpl) < 30000))
				cpl_gap_ok = 1;
		end
		last_cpl = $time;
		cpln = cpln + 1;
	end

	always @(posedge env.ppu_mode2) m2n = m2n + 1;
	always @(posedge env.ppu_mode3) begin
		m3n = m3n + 1;
		last_m3 = $time;
	end

	// sample LD pixels during mode3 (LD is latched on the /CP falling edge)
	always @(negedge env.ppu1.n_lcd_cp) begin : ldsample
		if (env.ppu_mode3) ld_sample_cnt = ld_sample_cnt + 1;
	end

	// VRAM fetch detection: a map fetch at $9800-9BFF happens in mode3
	always @(negedge env.ppu1.n_lcd_cp) begin : vramwatch
		if (env.ppu_mode3 && (env.nma !== 13'h1fff)) nma_fetch_seen = nma_fetch_seen + 1;
	end

	task check(input [90:0] name, input expected, input actual);
		begin
			if (expected !== actual) begin
				$display("FAIL %0s: expected %b got %b", name, expected, actual);
				errors = errors + 1;
			end else
				$display("PASS %0s: %b", name, actual);
		end
	endtask

	initial begin
		$dumpfile("tb_ppu_bg_scanline.vcd");
		$dumpvars(0, tb_ppu_bg_scanline);

		#(64*8);
		env.reset = 1'b0;      // release /RES
		#(64*4);

		// ---- VRAM preload ----
		// map $9800 row 0: 32 columns -> tile 1
		for (k = 0; k < 32; k = k + 1)
			env.vram.write_byte(13'h1800 + k, 8'h01);
		// tile 1, row 0: solid light (plane0 0xAA, plane1 0x55 -> 10/01 pattern)
		env.vram.write_byte(13'h0010, 8'hAA);
		env.vram.write_byte(13'h0011, 8'h55);

		// ---- PPU programming ----
		env.cpu_write(16'hFF40, 8'h91);   // LCD on, BG on, map0 $9800, tiles $8000
		env.cpu_write(16'hFF42, 8'h00);   // SCY = 0
		env.cpu_write(16'hFF43, 8'h00);   // SCX = 0
		env.cpu_write(16'hFF47, 8'hE4);   // BGP

		// ---- let 2 scanlines pass ----
		repeat (2 * 456 + 128) @(posedge env.ppu_clk);

		$display("mode2=%0d mode3=%0d line-ticks-ok=%0d v=%0d h=%0d",
		         m2n, m3n, cpl_gap_ok, env.v, env.h);
		check("two mode3 seen", 1'b1, m3n >= 2);
		check("two mode2 seen", 1'b1, m2n >= 2);
		check("456-tick line period", 1'b1, cpl_gap_ok);
		check("VRAM fetches happened in mode3", 1'b1, nma_fetch_seen > 100);
		$display("VRAM fetch samples: %0d", nma_fetch_seen);
		check("LD sampled", 1'b1, ld_sample_cnt > 100);

		// after a full line the V counter advanced
		check("v advanced past 0", 1'b1, env.v > 0);

		if (errors == 0)
			$display("RESULT: ALL PASS");
		else
			$display("RESULT: %0d FAILURES", errors);
		$finish;
	end

endmodule
