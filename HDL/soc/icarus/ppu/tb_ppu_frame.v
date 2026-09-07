// tb_ppu_frame
// Full-frame PPU test (issue #390): V counter behaviour over a whole frame.
//
// Runs the PPU (BG on) for more than 154 scanlines and verifies:
//   - VBLANK (vbl from PPU1) asserts when LY >= 144 and stays until the wrap
//   - the V counter wraps 153 -> 0 and the next frame starts (mode2/3 run)
//   - ppu_int_vbl (PPU1 output) pulses at the VBlank boundary
//
// VCD is dumped with $dumpvars(1) (test-level nets only) to keep the
// full-frame (~70k ticks) dump small; the test checks are in-sim.
`timescale 1ns/1ns

module tb_ppu_frame;

	ppu_env env();

	wire ppu_mode2 = env.ppu_mode2;
	wire ppu_mode3 = env.ppu_mode3;
	wire vbl = env.vbl;
	wire [7:0] v = env.v;
	wire [7:0] h = env.h;

	integer errors = 0;
	reg was_153 = 0;
	integer vblank_seen = 0;
	integer wrap_seen = 0;
	integer vbl_irq_seen = 0;
	reg [7:0] prev_v = 8'hFF;

	// watch V: VBlank window and the 153 -> 0 wrap
	always @(posedge env.ppu_clk) begin : vwatch
		if (env.v >= 144 && env.vbl) vblank_seen = 1;
		if (was_153 && env.v == 8'h00) begin
			wrap_seen = 1;
			was_153 = 0;
		end else if (env.v == 8'h99) begin
			was_153 = 1;
		end
	end
	always @(posedge env.ppu1.ppu_int_vbl) vbl_irq_seen = 1;


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
		$dumpfile("tb_ppu_frame.vcd");
		$dumpvars(1, tb_ppu_frame);

		#(64*8);
		env.reset = 1'b0;
		#(64*4);

		env.cpu_write(16'hFF40, 8'h91);   // LCD + BG on
		env.cpu_write(16'hFF42, 8'h00);
		env.cpu_write(16'hFF43, 8'h00);
		env.cpu_write(16'hFF47, 8'hE4);

		// 1) wait until VBlank (LY >= 144)
		while (env.v < 144) @(posedge env.ppu_clk);
		#1000;
		check("VBLANK asserted at LY>=144", 1'b1, env.vbl);
		$display("at LY=%0d vbl=%b mode=%b", env.v, env.vbl, ppu_mode3);

		// 2) keep running through LY 153 and the wrap to 0
		repeat (12 * 456) @(posedge env.ppu_clk);
		check("V counter wrapped 153 -> 0", 1'b1, wrap_seen);
		$display("after wrap: v=%0d vbl=%b", env.v, env.vbl);
		check("vbl cleared after wrap", 1'b0, env.vbl);
		check("ppu_int_vbl pulsed", 1'b1, vbl_irq_seen);

		$display("final v=%0d h=%0d mode2=%b mode3=%b", v, h, ppu_mode2, ppu_mode3);

		if (errors == 0)
			$display("RESULT: ALL PASS");
		else
			$display("RESULT: %0d FAILURES", errors);
		$finish;
	end

endmodule
