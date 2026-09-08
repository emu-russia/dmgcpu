// tb_soc_probe - bring-up probe for the small-domain environment (issue #396)
//
// Runs a reset + a few MMIO writes/reads and reports whether the clock
// tree runs and whether register decodes react. This test only produces
// diagnostics + the VCD used to work out the correct bus-cycle timing.
`timescale 1ns/1ns

module tb_soc_probe;

	soc_env env();

	// sample the write-decode internals while cpu_wr is up
	always @(env.cpu_wr)
		if (env.cpu_wr) begin
			#1;
			$display("WR@%0t a=%h d=%b ffxx=%b soc_wr=%b wr_sync=%b w100=%b w223=%b w148=%b w302=%b a0=%b a1=%b a2=%b d0=%b d1=%b d2=%b g201a=%b w110=%b",
				$time, env.a, env.d, env.ffxx, env.soc_wr, env.cpu_wr_sync,
				env.mmio.w100, env.mmio.w223, env.mmio.w148, env.mmio.w302,
				env.mmio.a[0], env.mmio.a[1], env.mmio.a[2],
				env.mmio.d[0], env.mmio.d[1], env.mmio.d[2],
				env.mmio.g201.a, env.mmio.w110);
		end

	task check_reset();
		begin
			$display("PROBE: osc_stable=%b test1=%b test2=%b n_reset2=%b sync_reset=%b clk9=%b clk2=%b",
				env.osc_stable, env.test_1, env.test_2, env.n_reset2,
				env.sync_reset, env.clk9, env.clk2);
		end
	endtask

	task rd(input [15:0] addr, input [40:0] tag);
		reg [7:0] v;
		begin
			env.cpu_read(addr, v);
			$display("READ %s (%h) = %b (%h)", tag, addr, v, v);
		end
	endtask

	initial begin
		$dumpfile("tb_soc_probe.vcd");
		$dumpvars(0, tb_soc_probe);

		// --- reset phase ---
		env.reset = 1'b1;
		repeat (16) @ (posedge env.ck1);
		env.reset = 1'b0;
		repeat (16) @ (posedge env.clk9);
		check_reset();

		rd(16'hFF0F, "IF@boot");

		// --- writes ---
		$display("--- write $FF07 = 0x03 (TAC) ---");
		env.cpu_write(16'hFF07, 8'h03);
		rd(16'hFF07, "TAC");

		$display("--- write $FF04 = 0x00 (DIV) ---");
		env.cpu_write(16'hFF04, 8'h00);
		rd(16'hFF04, "DIV");

		$display("--- write $FF01 = 0xAA (SB) ---");
		env.cpu_write(16'hFF01, 8'hAA);
		rd(16'hFF01, "SB");

		$display("--- write $FF02 = 0x81 (SC: int clk, transfer) ---");
		env.cpu_write(16'hFF02, 8'h81);
		rd(16'hFF02, "SC");

		// run some M-cycles so the serial transfer / timer can advance
		repeat (256) @ (posedge env.clk9);
		rd(16'hFF01, "SB-after");
		rd(16'hFF04, "DIV-after");
		rd(16'hFF0F, "IF-after");
		rd(16'hFF07, "TAC-after");
		$finish;
	end

	// ---- decode-event monitor ----
	always @(posedge env.mmio.w223) $display("W223-pos @%0t d=%b a=%h ffxx=%b soc_wr=%b", $time, env.d, env.a, env.ffxx, env.soc_wr);
	always @(negedge env.mmio.w223) $display("W223-neg @%0t d=%b a=%h soc_wr=%b", $time, env.d, env.a, env.soc_wr);
	always @(posedge env.mmio.w148) $display("W148-pos @%0t d=%b a=%h soc_wr=%b", $time, env.d, env.a, env.soc_wr);

endmodule
