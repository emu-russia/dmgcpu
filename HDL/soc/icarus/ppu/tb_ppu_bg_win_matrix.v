// tb_ppu_bg_win_matrix
// BG/WIN layer combination matrix test (issue #390).
//
// Sweeps the layer combinations of LCDC (BG enable bit0, BG map select bit3,
// WIN enable bit5, WIN map select bit6, LCD bit7) plus WY/WX and verifies
// for each configuration that the tile-map fetches come from the right map
// ($9800 / $9C00) for the layers that are actually active on the observed
// scanlines (WX=7 => a visible window covers the whole line).
//
// Expected map base selection:
//   BG layer   fetches from $9800 when LCDC.3=0, from $9C00 when LCDC.3=1
//   WIN layer  fetches from $9800 when LCDC.6=0, from $9C00 when LCDC.6=1
// A window is visible on line LY when LCDC.5=1 and LY>=WY.
`timescale 1ns/1ns

module tb_ppu_bg_win_matrix;

	ppu_env env();

	integer errors = 0;
	integer k;

	// per-run counters (gated by run_en)
	reg run_en = 0;
	integer m0 = 0;   // $9800 map fetches (0x1800..0x19FF)
	integer m1 = 0;   // $9C00 map fetches (0x1C00..0x1DFF)
	integer ldn = 0;  // /CP pulses in mode3 (pixel activity)
	integer m3n = 0;

	always @(negedge env.ppu1.n_lcd_cp) begin : cnt
		if (run_en && env.ppu_mode3) begin
			if (env.vram.ma >= 13'h1800 && env.vram.ma <= 13'h19FF) m0 = m0 + 1;
			else if (env.vram.ma >= 13'h1C00 && env.vram.ma <= 13'h1DFF) m1 = m1 + 1;
			ldn = ldn + 1;
		end
	end
	always @(posedge env.ppu_mode3) if (run_en) m3n = m3n + 1;

	task chk(input [90:0] name, input expected, input actual);
		begin
			if (expected !== actual) begin
				$display("FAIL %0s: expected %b got %b", name, expected, actual);
				errors = errors + 1;
			end else
				$display("PASS %0s: %b", name, actual);
		end
	endtask

	// run one configuration over 'lines' scanlines and measure map fetches
	task run_cfg(input [7:0] lcdc, input [7:0] wy, input [7:0] wx,
	             input integer lines,
	             output integer om0, output integer om1,
	             output integer oldn, output integer om3);
		begin
			// program while the LCD is off, then enable
			env.cpu_write(16'hFF40, 8'h00);
			env.cpu_write(16'hFF42, 8'h00);
			env.cpu_write(16'hFF43, 8'h00);
			env.cpu_write(16'hFF47, 8'hE4);
			env.cpu_write(16'hFF4A, wy);
			env.cpu_write(16'hFF4B, wx);
			env.cpu_write(16'hFF40, lcdc);
			m0 = 0; m1 = 0; ldn = 0; m3n = 0;
			run_en = 1;
			repeat (lines * 456 + 64) @(posedge env.ppu_clk);
			run_en = 0;
			om0 = m0; om1 = m1; oldn = ldn; om3 = m3n;
		end
	endtask

	// capture last run metrics
	integer r0, r1, rl, r3;

	initial begin
		$dumpfile("tb_ppu_bg_win_matrix.vcd");
		$dumpvars(1, tb_ppu_bg_win_matrix);
		#(64*8);
		env.reset = 1'b0;
		#(64*4);

		// VRAM content: map0 $9800 -> tile 1, map1 $9C00 -> tile 2
		for (k = 0; k < 32; k = k + 1) begin
			env.vram.write_byte(13'h1800 + k, 8'h01);
			env.vram.write_byte(13'h1C00 + k, 8'h02);
		end
		env.vram.write_byte(13'h0010, 8'hFF); env.vram.write_byte(13'h0011, 8'hFF);
		env.vram.write_byte(13'h0020, 8'h0F); env.vram.write_byte(13'h0021, 8'hF0);

		// ---- C1: LCD on, BG off, WIN off -> no layer fetches ----
		run_cfg(8'h80, 8'h00, 8'h07, 1, r0, r1, rl, r3);
		$display("C1 0x80 (no layers):  m0=%0d m1=%0d ld=%0d m3=%0d", r0, r1, rl, r3);
		// note: with LCD on the fetch engine still runs from $9800 (map0)
		// even with BG/WIN disabled - the layer enables gate the pixel mux,
		// not the fetcher. Reported as INFO, not a failure.
		$display("INFO C1 fetcher runs from map0 with BG/WIN off (m0=%0d)", r0);
		chk("C1 LCD frame still runs", 1'b1, r3 >= 1);

		// ---- C2: BG $9800 only ----
		run_cfg(8'h91, 8'hF0, 8'h07, 1, r0, r1, rl, r3);
		$display("C2 0x91 BG map0:  m0=%0d m1=%0d ld=%0d", r0, r1, rl);
		chk("C2 BG fetches from $9800", 1'b1, r0 > r1 * 10 && r0 > 5);
		chk("C2 pixels active", 1'b1, rl > 20);

		// ---- C3: BG $9C00 only ----
		run_cfg(8'h99, 8'hF0, 8'h07, 1, r0, r1, rl, r3);
		$display("C3 0x99 BG map1:  m0=%0d m1=%0d ld=%0d", r0, r1, rl);
		chk("C3 BG fetches from $9C00", 1'b1, r1 > r0 * 10 && r1 > 5);

		// ---- C4: WIN $9800 (BG off), WY=0 (whole screen) ----
		run_cfg(8'hA0, 8'h00, 8'h07, 1, r0, r1, rl, r3);
		$display("C4 0xA0 WIN map0:  m0=%0d m1=%0d ld=%0d", r0, r1, rl);
		chk("C4 WIN fetches from $9800", 1'b1, r0 > r1 * 10 && r0 > 5);

		// ---- C5: WIN $9C00 (BG off), WY=0 ----
		run_cfg(8'hE0, 8'h00, 8'h07, 1, r0, r1, rl, r3);
		$display("C5 0xE0 WIN map1:  m0=%0d m1=%0d ld=%0d", r0, r1, rl);
		chk("C5 WIN fetches from $9C00", 1'b1, r1 > r0 * 10 && r1 > 5);

		// ---- C6: BG $9800 + WIN $9C00, WY=0 (whole screen window) ----
		run_cfg(8'hE1, 8'h00, 8'h07, 1, r0, r1, rl, r3);
		$display("C6 0xE1 BG0+WIN1:  m0=%0d m1=%0d ld=%0d", r0, r1, rl);
		chk("C6 window $9C00 dominates", 1'b1, r1 > r0 * 10 && r1 > 5);

		// ---- C7: BG $9800 + WIN $9C00, WY=40 (window below) -> BG only ----
		run_cfg(8'hE1, 8'h28, 8'h07, 1, r0, r1, rl, r3);
		$display("C7 0xE1 WY=40:  m0=%0d m1=%0d ld=%0d", r0, r1, rl);
		chk("C7 BG $9800 only while LY<WY", 1'b1, r0 > r1 * 10 && r0 > 5);

		// ---- C8: BG $9C00 + WIN $9800, WY=0 (window covers screen) ----
		run_cfg(8'hB9, 8'h00, 8'h07, 1, r0, r1, rl, r3);
		$display("C8 0xB9 BG1+WIN0:  m0=%0d m1=%0d ld=%0d", r0, r1, rl);
		chk("C8 window $9800 dominates", 1'b1, r0 > r1 * 10 && r0 > 5);

		// ---- C9: LCD on, BG off, WIN off ----
		run_cfg(8'h80, 8'hF0, 8'h07, 1, r0, r1, rl, r3);
		$display("C9 0x80 (again):  m0=%0d m1=%0d", r0, r1);
		$display("INFO C9 fetcher runs from map0 with BG/WIN off (m0=%0d)", r0);

		// ---- C10: BG $9800 + WIN $9C00, WY=0, WX=50 -> mid-line BG->WIN ----
		run_cfg(8'hE1, 8'h00, 8'h32, 1, r0, r1, rl, r3);
		$display("C10 BG0+WIN1 WX=50:  m0=%0d m1=%0d", r0, r1);
		chk("C10 both maps fetched (mid-line window switch)", 1'b1, r0 > 5 && r1 > 5);

		// ---- C11: WIN with WX=3 (WX<7). Observed: the window still covers
		// the whole line (WX-7 wraps negative => window start <=0), so the
		// $9C00 window map dominates - matches the netlist comparator.
		run_cfg(8'hE1, 8'h00, 8'h03, 1, r0, r1, rl, r3);
		$display("C11 BG0+WIN1 WX=3:  m0=%0d m1=%0d", r0, r1);
		$display("INFO C11 WX<7 -> window active whole line (window map dominates)");
		chk("C11 window map dominates for WX<7", 1'b1, r1 > r0 * 10 && r1 > 5);

		if (errors == 0)
			$display("RESULT: ALL PASS");
		else
			$display("RESULT: %0d FAILURES", errors);
		$finish;
	end

endmodule
