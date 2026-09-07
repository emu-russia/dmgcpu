// tb_ppu_win_mid
// Mid-line BG -> WIN switch wave source (issue #390): BG $9800 (tile 1) +
// WIN $9C00 (tile 2), WY=0, WX=50 -> the window becomes active at LX =
// WX-7 = 43 inside the scanline (matrix config C10), full dump for waves.
`timescale 1ns/1ns
module tb_ppu_win_mid;
	ppu_env env();
	integer k;
	initial begin
		$dumpfile("tb_ppu_win_mid.vcd");
		$dumpvars(0, tb_ppu_win_mid);
		#(64*8);
		env.reset = 1'b0;
		#(64*4);
		for (k = 0; k < 32; k = k + 1) begin
			env.vram.write_byte(13'h1800 + k, 8'h01);
			env.vram.write_byte(13'h1C00 + k, 8'h02);
		end
		env.vram.write_byte(13'h0010, 8'hAA); env.vram.write_byte(13'h0011, 8'h55);
		env.vram.write_byte(13'h0020, 8'h0F); env.vram.write_byte(13'h0021, 8'hF0);
		env.cpu_write(16'hFF40, 8'hE1);
		env.cpu_write(16'hFF42, 8'h00);
		env.cpu_write(16'hFF43, 8'h00);
		env.cpu_write(16'hFF47, 8'hE4);
		env.cpu_write(16'hFF4A, 8'h00);
		env.cpu_write(16'hFF4B, 8'h32);   // WX = 50 -> switch at LX 43
		repeat (2 * 456 + 128) @(posedge env.ppu_clk);
		$finish;
	end
endmodule
