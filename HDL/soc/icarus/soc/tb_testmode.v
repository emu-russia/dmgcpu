// tb_testmode - TEST1/TEST2 pad decode test (issue #396)
//
// The DMG test pins: TEST1 = T2 low + T1 high, TEST2 = T1 low + T2 high
// (normal operation = both pads high, so n_t1_frompad = n_t2_frompad = 0).
// Checks the MMIO decode outputs (test_1/test_2) and the ClkGen/Arb
// consequences that follow (ext_cs_en forced high in TEST1 etc.).
`timescale 1ns/1ns

module tb_testmode;

	soc_env env();

	integer checks = 0;
	integer fails = 0;
	task chk(input [127:0] name, input ok);
		begin
			checks = checks + 1;
			if (ok) $display("RESULT %0s PASS", name);
			else begin
				fails = fails + 1;
				$display("RESULT %0s FAIL", name);
			end
		end
	endtask

	initial begin
		$dumpfile("tb_testmode.vcd");
		$dumpvars(0, tb_testmode);

		env.reset = 1'b1;
		repeat (16) @ (posedge env.ck1);
		env.reset = 1'b0;
		repeat (16) @ (posedge env.clk9);

		// normal mode
		env.n_t1_frompad = 1'b0;
		env.n_t2_frompad = 1'b0;
		repeat (4) @ (posedge env.clk9);
		chk("normal-not-test1", env.test_1 === 1'b0);
		chk("normal-not-test2", env.test_2 === 1'b0);

		// TEST1: T2 pad low (n_t2_frompad=1), T1 pad high
		env.n_t1_frompad = 1'b0;
		env.n_t2_frompad = 1'b1;
		repeat (4) @ (posedge env.clk9);
		chk("test1-asserted", env.test_1 === 1'b1);
		chk("test1-test2-off", env.test_2 === 1'b0);
		// in TEST1 the external address/data drivers of the CPU are
		// disabled; MMIO drives the internal a bus from the pads and the
		// ext_cs_en decode is forced high (arbitration bypassed)
		chk("test1-ext-cs-en-forced", env.ext_cs_en === 1'b1);
		chk("test1-ext-addr-en-low", env.n_ext_addr_en === 1'b0);

		// TEST2: T1 pad low, T2 pad high
		env.n_t1_frompad = 1'b1;
		env.n_t2_frompad = 1'b0;
		repeat (4) @ (posedge env.clk9);
		chk("test2-asserted", env.test_2 === 1'b1);
		chk("test2-test1-off", env.test_1 === 1'b0);

		// back to normal
		env.n_t1_frompad = 1'b0;
		env.n_t2_frompad = 1'b0;
		repeat (4) @ (posedge env.clk9);
		chk("back-to-normal", env.test_1 === 1'b0 && env.test_2 === 1'b0);

		$display("RESULT tb_testmode %0d checks, %0d failures", checks, fails);
		if (fails) $display("RESULT tb_testmode FAIL");
		else       $display("RESULT tb_testmode PASS");
		$finish;
	end

endmodule
