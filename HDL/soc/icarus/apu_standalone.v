// apu_standalone
// Testing the APU in a spherical vacuum (separate from the other components).
// We just create a APU instance, add all the plugs it needs, and try to get it going.
`timescale 1ns/1ns

module apu_standalone();

	reg reset; 	// from Pad
	reg ck1; 		// from Pad
	always #32 ck1 = ~ck1;

	wire n_reset2;
	wire cclk;
	wire clk2;
	wire clk4;
	wire clk6;
	wire clk7;
	wire clk9;

	ClkGen clkgen (
		.clk2(clk2),
		.clk4(clk4),
		.clk6(clk6),
		.clk7(clk7),
		.clk9(clk9),
		.cclk(cclk),
		.n_reset2(n_reset2),
		.clk_ena(1'b1),
		.osc_ena(1'b1),
		.cpu_wr(1'b0),
		.test_1(1'b0),
		.cpu_mreq(1'b0),
		.reset(reset),
		.osc_stable(1'b1),
		.n_test_reset(~reset),
		.n_clk_in(~ck1) );

	APU apu ( 
		.cclk(cclk),
		.clk2(clk2),
		.clk4(clk4),
		.clk6(clk6),
		.clk7(clk7),
		.clk9(clk9),
		.n_reset2(n_reset2),
		//a,
		//d,
		.sck_dir(1'b0),
		.n_p10(1'b1),
		.n_p11(1'b1),
		.n_p12(1'b1),
		.n_p13(1'b1),
		//dma_a,
		.soc_wr(1'b0),
		.soc_rd(1'b0),
		.lfo_512Hz(1'b0),
		.ser_out(1'b0),
		.serial_tick(1'b0),
		.test_1(1'b0),
		.test_2(1'b0),
		.n_ext_addr_en(1'b1),
		//wave_rd,
		.addr_latch(1'b0),
		.ffxx(1'b0),
		.dma_addr_ext(1'b0) );

	initial begin
		$display("Running apu_standalone");

		ck1 = 1'b0;

		$dumpfile("apu_standalone.vcd");
		$dumpvars(0, apu_standalone);

		reset = 1'b1;
		repeat (8) @ (posedge ck1);
		reset = 1'b0;

		repeat (4096) @ (posedge ck1);

		$finish;
	end

endmodule // apu_standalone