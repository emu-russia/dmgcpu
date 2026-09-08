// tb_apu_regs - APU register-file regression test (issue #398).
//
// Encodes the measured $FF10-$FF2F read/write semantics of the real APU
// netlist (see wiki/soc/apu.md "Register file"):
//   * writes capture the d-bus value on the FFxx decode window close;
//   * reads drive d from the register value / live hardware state with
//     per-register bit masks (measured):
//       NR10  read = 0x80 | (v & 0x7F)     (sweep period echo)
//       NR11  read = 0x3F | (v & 0xC0)     (duty echo, length hard-1)
//       NR12  read = v                     (envelope 8-bit)
//       NR13  no read-back (0xFF)          (ch1 freq lo, write-only)
//       NR14  read = 0xBF | (v & 0x40)     (bit6 length-enable echo)
//       NR21/NR22/NR24/NR30/NR32/NR34/NR42/NR43/NR44/NR50/NR51 analogously
//   * NR52 ($FF26) read = 0x70 | (power<<7) | (ch-active status)
//     (0xF0 right after power-on; power-off clears the channels)
//   * $FF27-$FF2F unmapped; $FF30-$FF3F = wave RAM window.
//
// Bus conventions (from ../soc suite): reads sample the d-bus while clk2
// is high in the middle of the read window; writes hold data ~6ns past the
// synchronized write-window close (see apu_env.v).
`timescale 1ns/1ns

module tb_apu_regs;

	apu_env e ();

	integer errors = 0;
	reg [7:0] rb;

	task check(input [159:0] what, input [7:0] got, input [7:0] want);
		begin
			if (got !== want) begin
				$display("FAIL %0s: got %02x want %02x", what, got, want);
				errors = errors + 1;
			end else begin
				$display("PASS %0s: %02x", what, got);
			end
		end
	endtask

	initial begin
		$dumpfile("tb_apu_regs.vcd");
		$dumpvars(0, tb_apu_regs);

		repeat (16) @(negedge e.ck1);
		e.reset = 1'b0;
		repeat (16) @(negedge e.ck1);

		// ---- NR52 power on -------------------------------------------------
		e.cpu_read(16'hFF26, rb);
		check("NR52 read before power (powered off)", rb, 8'h70);
		e.cpu_write(16'hFF26, 8'h80);
		e.cpu_read(16'hFF26, rb);
		check("NR52 after power-on write 0x80", rb, 8'hF0);

		// ---- write/read-back semantics (powered) --------------------------
		e.cpu_write(16'hFF10, 8'h00);  e.cpu_read(16'hFF10, rb);
		check("NR10 rd after wr00", rb, 8'h80);
		e.cpu_write(16'hFF10, 8'h7F);  e.cpu_read(16'hFF10, rb);
		check("NR10 rd after wr7F", rb, 8'hFF);
		e.cpu_write(16'hFF10, 8'h23);  e.cpu_read(16'hFF10, rb);
		check("NR10 sweep echo 0x23|80", rb, 8'hA3);

		e.cpu_write(16'hFF11, 8'h00);  e.cpu_read(16'hFF11, rb);
		check("NR11 rd after wr00", rb, 8'h3F);
		e.cpu_write(16'hFF11, 8'h80);  e.cpu_read(16'hFF11, rb);
		check("NR11 duty 10 echo", rb, 8'hBF);
		e.cpu_write(16'hFF11, 8'hC0);  e.cpu_read(16'hFF11, rb);
		check("NR11 duty 11 echo", rb, 8'hFF);

		e.cpu_write(16'hFF12, 8'hF3);  e.cpu_read(16'hFF12, rb);
		check("NR12 envelope echo F3", rb, 8'hF3);
		e.cpu_write(16'hFF12, 8'h00);  e.cpu_read(16'hFF12, rb);
		check("NR12 envelope echo 00", rb, 8'h00);

		e.cpu_write(16'hFF13, 8'h5A);  e.cpu_read(16'hFF13, rb);
		check("NR13 no read-back (ff)", rb, 8'hFF);

		e.cpu_write(16'hFF14, 8'h00);  e.cpu_read(16'hFF14, rb);
		check("NR14 rd after wr00", rb, 8'hBF);
		e.cpu_write(16'hFF14, 8'h40);  e.cpu_read(16'hFF14, rb);
		check("NR14 bit6 echo", rb, 8'hFF);

		e.cpu_write(16'hFF16, 8'h00);  e.cpu_read(16'hFF16, rb);
		check("NR21 rd after wr00", rb, 8'h3F);
		e.cpu_write(16'hFF17, 8'hC7);  e.cpu_read(16'hFF17, rb);
		check("NR22 envelope echo C7", rb, 8'hC7);

		e.cpu_write(16'hFF1A, 8'h00);  e.cpu_read(16'hFF1A, rb);
		check("NR30 rd after wr00 (DAC off)", rb, 8'h7F);
		e.cpu_write(16'hFF1A, 8'h80);  e.cpu_read(16'hFF1A, rb);
		check("NR30 DAC on echo bit7", rb, 8'hFF);

		e.cpu_write(16'hFF1C, 8'h00);  e.cpu_read(16'hFF1C, rb);
		check("NR32 rd after wr00", rb, 8'h9F);
		e.cpu_write(16'hFF1C, 8'h20);  e.cpu_read(16'hFF1C, rb);
		check("NR32 vol bit5 echo", rb, 8'hBF);
		e.cpu_write(16'hFF1C, 8'h40);  e.cpu_read(16'hFF1C, rb);
		check("NR32 vol bit6 echo", rb, 8'hDF);

		e.cpu_write(16'hFF1E, 8'h00);  e.cpu_read(16'hFF1E, rb);
		check("NR34 rd after wr00", rb, 8'hBF);

		e.cpu_write(16'hFF21, 8'hC3);  e.cpu_read(16'hFF21, rb);
		check("NR42 envelope echo C3", rb, 8'hC3);
		e.cpu_write(16'hFF22, 8'h55);  e.cpu_read(16'hFF22, rb);
		check("NR43 poly echo 55", rb, 8'h55);
		e.cpu_write(16'hFF23, 8'h00);  e.cpu_read(16'hFF23, rb);
		check("NR44 rd after wr00", rb, 8'hBF);

		e.cpu_write(16'hFF24, 8'h77);  e.cpu_read(16'hFF24, rb);
		check("NR50 volume echo 77", rb, 8'h77);
		e.cpu_write(16'hFF25, 8'hBB);  e.cpu_read(16'hFF25, rb);
		check("NR51 mixer echo BB", rb, 8'hBB);

		e.cpu_write(16'hFF27, 8'hAA);  e.cpu_read(16'hFF27, rb);
		check("FF27 unmapped", rb, 8'hFF);
		e.cpu_write(16'hFF2F, 8'hAA);  e.cpu_read(16'hFF2F, rb);
		check("FF2F unmapped", rb, 8'hFF);

		// ---- wave RAM window: CPU write then read through the APU decode ----
		e.cpu_write(16'hFF30, 8'h12);
		e.cpu_write(16'hFF31, 8'h34);
		e.cpu_write(16'hFF3F, 8'hFE);
		e.cpu_read(16'hFF30, rb);  check("wave RAM[0] read", rb, 8'h12);
		e.cpu_read(16'hFF31, rb);  check("wave RAM[1] read", rb, 8'h34);
		e.cpu_read(16'hFF3F, rb);  check("wave RAM[15] read", rb, 8'hFE);
		e.waveram.peek(4'hF, rb);  check("wave RAM[15] model view", rb, 8'hFE);

		// ---- NR52 power-off resets the sound state --------------------------
		// (real-DMG semantics: writing 0 to NR52 clears the whole APU; the
		// channel registers hold the written value only while powered)
		e.cpu_write(16'hFF26, 8'h00);
		e.cpu_read(16'hFF26, rb);
		check("NR52 powered off read", rb, 8'h70);
		e.cpu_read(16'hFF12, rb);
		check("NR12 after power-off (reset)", rb, 8'h00);
		e.cpu_read(16'hFF11, rb);
		check("NR11 after power-off (reset)", rb, 8'h3F);

		$display("RESULT tb_apu_regs %s (%0d fails)", errors ? "FAIL" : "PASS", errors);
		$finish;
	end

endmodule
