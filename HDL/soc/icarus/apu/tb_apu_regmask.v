// tb_apu_regmask - per-bit read-back mask walk of the APU register file.
// For each $FF10..$FF26 (NR10..NR52): write each single bit, read back, and
// classify every bit as echo (written value is readable) / hard-1 (always
// reads 1) / hard-0 (always reads 0). Prints the per-register mask summary.
`timescale 1ns/1ns

module tb_apu_regmask;

	apu_env e ();

	integer i, b, errors = 0;
	reg [7:0] rb, r00;
	reg [7:0] mask_echo, mask_hard1;

	initial begin
		$dumpfile("tb_apu_regmask.vcd");
		$dumpvars(0, tb_apu_regmask);

		repeat (16) @(negedge e.ck1);
		e.reset = 1'b0;
		repeat (16) @(negedge e.ck1);

		e.cpu_write(16'hFF26, 8'h80);   // NR52 power on

		for (i = 16'h10; i <= 16'h26; i = i + 1) begin
			mask_echo = 8'h00; mask_hard1 = 8'h00;
			for (b = 0; b < 8; b = b + 1) begin
				e.cpu_write(16'hFF00 + i, 8'h01 << b);
				e.cpu_read(16'hFF00 + i, rb);
				if (rb & (8'h01 << b)) mask_echo |= (8'h01 << b);
			end
			e.cpu_write(16'hFF00 + i, 8'h00);
			e.cpu_read(16'hFF00 + i, r00);
			mask_hard1 = r00 & ~mask_echo;   // 1 when written 0
			$display("%02x: echo=%02x hard1=%02x", i, mask_echo, mask_hard1);
		end

		$display("RESULT tb_apu_regmask %s", errors ? "FAIL" : "DONE");
		$finish;
	end

endmodule
