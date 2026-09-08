// tb_apu_probe - bring-up probe for the APU suite (issue #398).
// Not a regression test: prints the bus state around register writes/reads
// so the APU register-decode conventions can be pinned down first.
`timescale 1ns/1ns

module tb_apu_probe;

	// env under test
	apu_env e ();

	integer errors = 0;
	reg [7:0] rb;

	initial begin
		$dumpfile("tb_apu_probe.vcd");
		$dumpvars(0, tb_apu_probe);

		// reset pulse
		repeat (16) @(negedge e.ck1);
		e.reset = 1'b0;
		repeat (16) @(negedge e.ck1);

		$display("RESET done: n_reset2=%b soc_wr=%b soc_rd=%b lfo=%b", e.n_reset2, e.soc_wr, e.soc_rd, e.lfo_512Hz);

		// power on the APU ($FF26 = NR52)
		e.cpu_write(16'hFF26, 8'h80);
		$display("after NR52 write: NR52 read:", );
		e.cpu_read(16'hFF26, rb);
		$display("  read FF26 = %02x (expect 80)", rb);

		// write a ch1 register pair and read back
		e.cpu_write(16'hFF11, 8'hBF);   // NR11: duty+length
		e.cpu_write(16'hFF12, 8'hF3);   // NR12: env vol/sweep
		e.cpu_read(16'hFF11, rb);
		$display("  read FF11 = %02x (expect BF)", rb);
		e.cpu_read(16'hFF12, rb);
		$display("  read FF12 = %02x (expect F3)", rb);
		e.cpu_read(16'hFF13, rb);
		$display("  read FF13 = %02x", rb);

		// wave RAM: preload via model, then read back via CPU $FF30
		e.waveram.poke(4'h3, 8'hAB);
		e.cpu_read(16'hFF33, rb);
		$display("  read FF33 (wave) = %02x (expect AB)", rb);
		e.cpu_write(16'hFF30, 8'h12);
		e.waveram.peek(4'h0, rb);
		$display("  wave RAM[0] after FF30 write = %02x (expect 12)", rb);

		// check some clock/counters after the dust settles
		repeat (16) @(negedge e.ck1);

		$display("RESULT tb_apu_probe %s", errors ? "FAIL" : "DONE");
		$finish;
	end

endmodule
