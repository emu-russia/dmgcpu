// tb_ppu_window
// Window (WIN) regression test (issue #390).
//
// WY=0, WX=7 makes the window occupy the whole of line 0 (LY>=WY and
// LX>=WX-7 from the very first pixel). With LCDC.6 = 1 the window layer
// uses the tile map at $9C00, while the BG layer uses $9800 (LCDC.3 = 0).
// The test checks that on line 0 the PPU tile-map fetches come from the
// $9C00 window map (address 0x1C00..0x1DFF), i.e. the window path in PPU1
// (in_window, WY/WX compare, map select) and the PPU2 !in_window gating of
// the scroll adders behave together.
`timescale 1ns/1ns

module tb_ppu_window;

	ppu_env env();

	integer errors = 0;
	integer k;
	integer    map1_fetches = 0, map0_fetches = 0;
	reg        first_is_map1 = 0;
	reg        seen_any_map = 0;

	// count map1 ($9C00) vs map0 ($9800) fetches during the whole run
	// (sampled mid-cycle on the falling edge of the LCD pixel clock)
	always @(negedge env.ppu1.n_lcd_cp) begin : cnt
		if (env.ppu_mode3) begin
			if ((env.vram.ma >= 13'h1C00) && (env.vram.ma <= 13'h1DFF))
				map1_fetches = map1_fetches + 1;
			else if ((env.vram.ma >= 13'h1800) && (env.vram.ma <= 13'h19FF))
				map0_fetches = map0_fetches + 1;
		end
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
		$dumpfile("tb_ppu_window.vcd");
		$dumpvars(0, tb_ppu_window);
		#(64*8);
		env.reset = 1'b0;
		#(64*4);

		// map0 $9800 row 0: tile $01 ; map1 $9C00 row 0: tile $02
		for (k = 0; k < 32; k = k + 1) begin
			env.vram.write_byte(13'h1800 + k, 8'h01);
			env.vram.write_byte(13'h1C00 + k, 8'h02);
		end

		// PPU: LCD + BG + WIN on, window map $9C00
		env.cpu_write(16'hFF40, 8'hF1);   // 1111_0001: LCD,BG,WIN,WIN-map1
		env.cpu_write(16'hFF42, 8'h00);   // SCY
		env.cpu_write(16'hFF43, 8'h00);   // SCX
		env.cpu_write(16'hFF47, 8'hE4);   // BGP
		env.cpu_write(16'hFF4A, 8'h00);   // WY = 0
		env.cpu_write(16'hFF4B, 8'h07);   // WX = 7 -> window starts at x=0

		// watch lines 0..2 (WY=0 => whole frame is window)
		repeat (3 * 456 + 200) @(posedge env.ppu_clk);

		$display("map1($9C00) fetches=%0d map0($9800) fetches=%0d",
		         map1_fetches, map0_fetches);

		// WY=0 WX=7: the window covers the entire visible area, so the
		// tile-map fetches must come from the $9C00 window map (LCDC.6=1)
		// and dominate the few BG fetches of the line-start prefetch.
		check("window $9C00 map fetches happened", 1'b1, map1_fetches > 20);
		check("window fetches dominate the line-start BG prefetch", 1'b1,
		      map1_fetches > 10 * map0_fetches);

		if (errors == 0)
			$display("RESULT: ALL PASS");
		else
			$display("RESULT: %0d FAILURES", errors);
		$finish;
	end

endmodule
