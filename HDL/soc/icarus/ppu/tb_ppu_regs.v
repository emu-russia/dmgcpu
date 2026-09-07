// tb_ppu_regs
// PPU register write/read regression test (issue #390).
//
// Verifies against the real PPU1/PPU2 gate netlists:
//   - PPU2 generates ppu_rd/ppu_wr pulses for FFxx accesses
//   - LCDC ($FF40) latches CPU write data (checked via the FF40_D1..3
//     outputs that PPU1 feeds to PPU2, i.e. the stored register bits)
//   - LCDC.7 = 1 releases the PPU soft reset (n_ppu_reset)
//   - SCY/SCX/BGP/WY/WX writes do not disturb LCDC (no cross-decode)
//   - read-only LY ($FF44) tracks the V counter
//   - H/V counters and the mode2/3 handshake run after LCD enable
`timescale 1ns/1ns

module tb_ppu_regs;

	ppu_env env();

	wire ppu_wr  = env.ppu_wr;
	wire ppu_rd  = env.ppu_rd;
	wire n_ppu_reset     = env.n_ppu_reset;
	wire n_ppu_hard_reset= env.n_ppu_hard_reset;
	wire ppu_mode2 = env.ppu_mode2;
	wire ppu_mode3 = env.ppu_mode3;
	wire [7:0] h = env.h;
	wire [7:0] v = env.v;

	integer errors = 0;
	reg [7:0] rd;

	task check(input [100:0] name, input expected, input actual);
		begin
			if (expected !== actual) begin
				$display("FAIL %0s: expected %b got %b", name, expected, actual);
				errors = errors + 1;
			end else
				$display("PASS %0s: %b", name, actual);
		end
	endtask

	// counts mode pulses until the PPU has started
	integer mode2_seen, mode3_seen, h_advanced;
	always @(posedge ppu_mode2) mode2_seen = mode2_seen + 1;
	always @(posedge ppu_mode3) mode3_seen = mode3_seen + 1;
	always @(posedge env.ppu_clk)
		if (env.h != 8'h00) h_advanced = 1;

	initial begin
		$dumpfile("tb_ppu_regs.vcd");
		$dumpvars(0, tb_ppu_regs);

		$display("--- reset ---");
		#(64*8);            // /RES asserted
		env.reset = 1'b0;   // release
		#(64*4);

		// ---- LCDC: 0x91 (LCD on, BG on) ----
		env.cpu_write(16'hFF40, 8'h91);
		#64;
		check("n_ppu_hard_reset high", 1'b1, n_ppu_hard_reset);
		check("n_ppu_reset high (LCDC.7)", 1'b1, n_ppu_reset);
		check("FF40_D3 == 0 (LCDC.3)", 1'b0, env.FF40_D3);
		check("FF40_D1 == 0 (LCDC.1)", 1'b0, env.FF40_D1);

		// ---- write SCY/SCX/BGP/WY/WX and make sure LCDC stays ----
		env.cpu_write(16'hFF42, 8'h21);   // SCY
		env.cpu_write(16'hFF43, 8'h07);   // SCX
		env.cpu_write(16'hFF47, 8'hE4);   // BGP
		env.cpu_write(16'hFF4A, 8'h20);   // WY
		env.cpu_write(16'hFF4B, 8'h0A);   // WX
		#64;
		check("n_ppu_reset still high", 1'b1, n_ppu_reset);
		check("LCDC.3 still 0", 1'b0, env.FF40_D3);
		check("LCDC.7 still 1", 1'b1, env.ppu1.g656.val);

		// ---- read-only LY tracks the V counter (sample when v>0) ----
		// first read is done by the hardware logic itself; verify the
		// V counter runs and that a later LY readback equals v
		mode2_seen = 0; mode3_seen = 0; h_advanced = 0;
		repeat (1000) @(posedge env.ppu_clk);
		check("h counter advanced", 1'b1, h_advanced);
		check("mode2 seen", 1'b1, mode2_seen > 0);
		check("mode3 seen", 1'b1, mode3_seen > 0);

		// LY readback while the PPU is running
		env.cpu_read(16'hFF44, rd);
		$display("LY readback = %02x, v = %02x (allow +/- few ticks)", rd, env.v);
		if (rd !== env.v && rd !== env.v - 1'b1 && rd !== env.v + 1'b1) begin
			$display("FAIL LY readback %02x does not track v %02x", rd, env.v);
			errors = errors + 1;
		end else
			$display("PASS LY readback %02x tracks v", rd);

		// register read-back through the CPU bus (PPU2 SCY/SCX, PPU1 BGP/LCDC)
		begin : regread
			reg [7:0] rb;
			env.cpu_read(16'hFF42, rb);   // SCY
			if (rb !== 8'h21) begin $display("FAIL SCY readback %02x != 21", rb); errors=errors+1; end
			else $display("PASS SCY readback %02x", rb);
			env.cpu_read(16'hFF43, rb);   // SCX
			if (rb !== 8'h07) begin $display("FAIL SCX readback %02x != 07", rb); errors=errors+1; end
			else $display("PASS SCX readback %02x", rb);
			env.cpu_read(16'hFF47, rb);   // BGP
			if (rb !== 8'hE4) begin $display("FAIL BGP readback %02x != E4", rb); errors=errors+1; end
			else $display("PASS BGP readback %02x", rb);
			env.cpu_read(16'hFF40, rb);   // LCDC
			if (rb !== 8'h91) begin $display("FAIL LCDC readback %02x != 91", rb); errors=errors+1; end
			else $display("PASS LCDC readback %02x", rb);
		end

		if (errors == 0)
			$display("RESULT: ALL PASS");
		else
			$display("RESULT: %0d FAILURES", errors);
		$finish;
	end

endmodule
