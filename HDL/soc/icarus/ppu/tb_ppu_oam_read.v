// tb_ppu_oam_read
// CPU -> OAM READ through PPU2 (issue #390) - DEV, not in run_all.
// With the LCD off (PPU idle) a CPU read of $FE00.. should make PPU2 drive
// the OAM read (n_oam_rd) and return the OAM word byte on the d bus.
//
// STATUS (round 17): the d bus stays precharged (0xFF) in the sample window;
// the CPU OAM read return path (capture latch -> bufif0 drive to d) needs the
// SoC-level cycle timing (like the CPU OAM write and DMA paths) - kept as a
// bring-up reference. See wiki/soc/ppu2.md open questions.
`timescale 1ns/1ns
module tb_ppu_oam_read;
	ppu_env env();
	integer errors = 0;
	reg [7:0] rd;
	initial begin
		$dumpfile("tb_ppu_oam_read.vcd");
		$dumpvars(0, tb_ppu_oam_read);
		#(64*8);
		env.reset = 1'b0;
		#(64*4);
		env.oam.mem[0] = 8'hA5;  // word 0, even byte (port B)
		env.oam.mem[1] = 8'h5A;  // word 0, odd byte  (port A)
		// prime the capture latches: LCD on, run a couple of lines
		env.cpu_write(16'hFF40, 8'h91);
		repeat (456 + 200) @(posedge env.ppu_clk);
		env.cpu_write(16'hFF40, 8'h00);   // LCD off
		repeat (64) @(posedge env.ppu_clk);
		// CPU reads $FE00 / $FE01
		env.cpu_read(16'hFE00, rd);
		$display("FE00 read = %02x (expect A5 or 5A depending on port)", rd);
		env.cpu_read(16'hFE01, rd);
		$display("FE01 read = %02x", rd);
		if (errors == 0) $display("RESULT: bring-up done");
		$finish;
	end
endmodule
