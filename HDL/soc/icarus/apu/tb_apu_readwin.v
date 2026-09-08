// tb_apu_readwin - measure the APU d-bus read-back window.
// Reads the same register repeatedly while stepping the post-strobe sample
// delay, to find where the register data is on d (research probe).
`timescale 1ns/1ns

module tb_apu_readwin;

	apu_env e ();

	integer i, errors = 0;
	reg [7:0] rb;
	integer sdelay;

	initial begin
		$dumpfile("tb_apu_readwin.vcd");
		$dumpvars(0, tb_apu_readwin);

		repeat (16) @(negedge e.ck1);
		e.reset = 1'b0;
		repeat (16) @(negedge e.ck1);

		e.cpu_write(16'hFF26, 8'h80);   // NR52 power on
		e.cpu_write(16'hFF12, 8'hF3);   // NR12 = F3
		e.cpu_write(16'hFF25, 8'h80);   // NR51 = 80
		e.waveram.poke(4'h3, 8'hAB);    // wave RAM[3]

		$display("sdelay  NR52  NR12  NR51  FF33");
		for (sdelay = 0; sdelay <= 300; sdelay = sdelay + 12) begin
			e.cpu_read_at(16'hFF26, sdelay, rb);   $write("%4d   %02x  ", sdelay, rb);
			e.cpu_read_at(16'hFF12, sdelay, rb);   $write("%02x  ", rb);
			e.cpu_read_at(16'hFF25, sdelay, rb);   $write("%02x  ", rb);
			e.cpu_read_at(16'hFF33, sdelay, rb);   $write("%02x", rb);
			$write("\n");
		end

		$display("RESULT tb_apu_readwin %s", errors ? "FAIL" : "DONE");
		$finish;
	end

endmodule
