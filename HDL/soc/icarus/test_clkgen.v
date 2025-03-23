// Imagine finding an old car in your grandmother's garage and trying to start its engine :-) That's exactly what we are trying to do here.
`timescale 1ns/1ns

module test_clkgen ();

	reg reset;
	reg ck1; 		// from Pad
	always #32 ck1 = ~ck1;

	ClkGen clkgen ( 
		.clk_ena(1'b1),
		.osc_ena(1'b1),
		.cpu_wr(1'b0),
		.test_1(1'b0), 		// Test mode disabled
		.cpu_mreq(1'b0),
		.reset(reset),
		.osc_stable(1'b1),
		.n_test_reset(~reset),
		.n_clk_in(~ck1) );

	initial begin
		$display("Running test_clkgen");

		ck1 = 1'b0;

		$dumpfile("test_clkgen.vcd");
		$dumpvars(0, test_clkgen);

		reset = 1'b1;
		repeat (8) @ (posedge ck1);
		reset = 1'b0;

		repeat (256) @ (posedge ck1);

		$finish;
	end

endmodule // test_clkgen