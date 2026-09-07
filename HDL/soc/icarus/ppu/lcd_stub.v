// lcd_stub
// Behavioral stub for the LCD driver / front-plane side of the LCD
// interface (issue #390).
//
// The PPU LCD interface (PPU1 outputs toward the LCD driver of the front
// PCB) is strictly unidirectional - PPU1 drives:
//   n_lcd_ld0 / n_lcd_ld1 - the two serial pixel data lines
//   n_lcd_cp  - pixel/clock pulse (one per LCD dot)
//   n_lcd_cpg - clock-pulse generation (gated)
//   n_lcd_cpl - line pulse (one per scanline)
//   n_lcd_st  - start (line start)
//   n_lcd_s   - sample (start of frame)
//   n_lcd_fr  - frame inversion
// All signals are active-low outputs of the PPU, so the testbench only
// needs a consumer stub that (a) terminates the nets and (b) samples the
// serial pixel stream into a line buffer for verification and rendering.
//
// Sampling rule used here (matches the netlist behaviour seen in the
// BG-rendering test): the pixel data is sampled on the falling edge of
// /CP; CPL pulses once per scanline; /S pulses at the start of the frame.
`timescale 1ns/1ns

module lcd_stub (
	input wire n_lcd_ld0,
	input wire n_lcd_ld1,
	input wire n_lcd_cp,
	input wire n_lcd_cpg,
	input wire n_lcd_cpl,
	input wire n_lcd_st,
	input wire n_lcd_s,
	input wire n_lcd_fr
);
	// 160 pixels of the current line (2bpp value: {ld1, ld0})
	reg [1:0] line [0:159];
	integer   px;          // pixel index within the line
	integer   line_cnt;    // lines since frame start
	integer   pix_cnt;     // pixels since frame start
	integer   frame_cnt;   // frames
	integer   cp_cnt;      // total /CP pulses
	reg       in_line;     // between /ST pulses

	initial begin
		px = 0; line_cnt = 0; pix_cnt = 0; frame_cnt = 0; cp_cnt = 0; in_line = 0;
	end

	always @(posedge n_lcd_cp) begin
		cp_cnt = cp_cnt + 1;
		if (in_line && px >= 0 && px < 160) begin
			line[px] = {~n_lcd_ld1, ~n_lcd_ld0};
			px = px + 1;
			pix_cnt = pix_cnt + 1;
		end
	end

	always @(posedge n_lcd_cpl) begin
		line_cnt = line_cnt + 1;
		in_line = 1'b0;
	end

	always @(posedge n_lcd_st) begin
		in_line = 1'b1;
		px = 0;
	end

	always @(posedge n_lcd_s) begin
		frame_cnt = frame_cnt + 1;
		line_cnt = 0;
		pix_cnt = 0;
	end

	// debug readout for the testbenches
	task get_line(input integer i, output [1:0] v);
		begin v = line[i]; end
	endtask
	task get_counts(output integer lc, output integer pc, output integer fc);
		begin lc = line_cnt; pc = pix_cnt; fc = frame_cnt; end
	endtask
endmodule
