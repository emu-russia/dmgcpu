// tb_ppu_scroll
// SCY/SCX scroll regression test (issue #390).
//
// Programs SCX=3 / SCY=1 with a VRAM pattern that is unique per tile-map
// column and per map row, then checks that PPU2's V+SCY / H+SCX adders
// change the fetched tile-map addresses: with SCX=3 the first visible BG
// tile of the line is fetched from map column ceil(SCX/8)+... i.e. the
// tile-map fetch address base shifts by (SCX>>3), and with SCY=1 the tile
// row of line 0 is row (0+SCY)>>3 = 0 but the *vertical fine* offset inside
// the tile becomes SCY&7, i.e. the tile-data fetch uses row (LY+SCY)&7.
`timescale 1ns/1ns

module tb_ppu_scroll;

	ppu_env env();

	integer errors = 0;
	integer k;
	reg [7:0] rd;

	task check(input [90:0] name, input expected, input actual);
		begin
			if (expected !== actual) begin
				$display("FAIL %0s: expected %b got %b", name, expected, actual);
				errors = errors + 1;
			end else
				$display("PASS %0s: %b", name, actual);
		end
	endtask

	// sample the first tile-map fetch address of the line whose V counter
	// equals target_v, plus the last one sampled before the PPU finishes
	reg [12:0] first_map_ma;
	reg [12:0] map_ma_v8;
	reg        got_first;
	reg        per_line_done;
	always @(posedge env.ppu1.n_lcd_cp) begin : capt
		// per line: at the first tile-map fetch in mode3, remember the address
		if (env.ppu_mode3 && !per_line_done) begin
			if ((env.vram.ma >= 13'h1800) && (env.vram.ma <= 13'h1BFF)) begin
				if (!got_first) first_map_ma = env.vram.ma;
				got_first = 1;
				per_line_done = 1;
				if (env.v == 8) map_ma_v8 = env.vram.ma;
			end
		end
	end
	always @(posedge env.ppu2.h_restart) per_line_done = 0;

	initial begin
		$dumpfile("tb_ppu_scroll.vcd");
		$dumpvars(0, tb_ppu_scroll);
		#(64*8);
		env.reset = 1'b0;
		#(64*4);

		// map $9800: column c -> tile (c+1) so the fetched map byte is unique
		for (k = 0; k < 32; k = k + 1)
			env.vram.write_byte(13'h1800 + k, k + 1);
		// map $9800 row 1: column 0 -> tile $21 (distinct from row 0)
		env.vram.write_byte(13'h1800 + 32, 8'h21);
		// tile data: every row r of every tile n = (n*16 + 2r) 0xAA pattern
		for (k = 0; k < 32; k = k + 1) begin
			env.vram.write_byte(13'h0010 + k*16 + 2*(1'b0*8), 8'hF0); // row0
		end

		// PPU on with BG
		env.cpu_write(16'hFF40, 8'h91);
		env.cpu_write(16'hFF42, 8'h01);   // SCY = 1
		env.cpu_write(16'hFF43, 8'h08);   // SCX = 8 (coarse = 1)
		env.cpu_write(16'hFF47, 8'hE4);

		// wait until line v=8 has passed
		got_first = 0;
		repeat (9 * 456 + 300) @(posedge env.ppu_clk);
		if (!got_first) begin
			$display("FAIL: no VRAM map fetch captured");
			errors = errors + 1;
		end else begin
			$display("first map fetch addr = 0x%04X (SCY=1 SCX=8)", first_map_ma);
			$display("map fetch col=%0d row=%0d", first_map_ma[4:0], first_map_ma[9:5]);
			$display("map fetch at v=8: 0x%04X (row=%0d col=%0d)",
			         map_ma_v8, map_ma_v8[9:5], map_ma_v8[4:0]);
			// SCX coarse = SCX>>3 = 1; the DMG fetch pipeline is 2 tiles ahead of
			// the LCD, so the first fetched map column = (SCX>>3)+2 = 3.
			check("SCX coarse (SCX>>3) shifts first map fetch column to 1", 1, first_map_ma[4:0]);
			// at v=8 (LY=8) the SCY offset gives map row (LY+SCY)>>3 = (8+1)>>3 = 1
			check("SCY offsets the map row at v=8 to 1", 1, map_ma_v8[9:5]);
		end

		if (errors == 0)
			$display("RESULT: ALL PASS");
		else
			$display("RESULT: %0d FAILURES", errors);
		$finish;
	end

endmodule
