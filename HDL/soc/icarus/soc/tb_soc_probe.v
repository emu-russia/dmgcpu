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

	// read with three different in-window sample offsets
	task rd3(input [15:0] addr, input [40:0] tag);
		reg [7:0] v1, v2, v3;
		begin
			env.cpu_read(addr, v1);          // clk2-aligned sample
			env.cpu_read_at(addr, 40, v2);
			env.cpu_read_at(addr, 120, v3);
			$display("READ3 %s (%h): align=%b d@40=%b d@120=%b", tag, addr, v1, v2, v3);
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

		rd3(16'hFF0F, "IF@boot");
		rd3(16'hFF07, "TAC@boot");
		rd3(16'hFF04, "DIV@boot");

		$display("--- writes ---");
		env.cpu_write(16'hFF05, 8'h37);   // TIMA
		rd3(16'hFF05, "TIMA");
		env.cpu_write(16'hFF06, 8'h59);   // TMA
		rd3(16'hFF06, "TMA");
		env.cpu_write(16'hFF07, 8'h03);   // TAC
		rd3(16'hFF07, "TAC");
		env.cpu_write(16'hFF04, 8'h00);   // DIV reset
		rd3(16'hFF04, "DIV");
		env.cpu_write(16'hFF01, 8'hAA);   // SB
		rd3(16'hFF01, "SB");
		env.cpu_write(16'hFF02, 8'h81);   // SC (int clk, transfer)
		rd3(16'hFF02, "SC");

		// let the serial transfer and the divider advance
		repeat (512) @ (posedge env.clk9);
		rd3(16'hFF01, "SB-after");
		rd3(16'hFF04, "DIV-after");
		rd3(16'hFF0F, "IF-after");
		rd3(16'hFF02, "SC-after");
		$finish;
	end

	// ---- decode-event monitor ----
	always @(posedge env.cpu_rd) begin
		#40;
		if (env.cpu_a[7:0] == 8'h04 && env.cpu_a[15:8] == 8'hFF)
			$display("DIVRD @%0t d=%b w138=%b load=%b w105=%b w77=%b w139=%b w137=%b w116=%b w112=%b q14=%b q92=%b q73=%b q25=%b clk6=%b",
				$time, env.d, env.mmio.w138, env.mmio.w16, env.mmio.w105, env.mmio.w77,
				env.mmio.w139, env.mmio.w137, env.mmio.w116, env.mmio.w112,
				env.mmio.w14, env.mmio.w92, env.mmio.w73, env.mmio.w25, env.clk6);
	end
	always @(posedge env.mmio.w223) $display("W223-pos @%0t d=%b a=%h ffxx=%b soc_wr=%b", $time, env.d, env.a, env.ffxx, env.soc_wr);
	always @(negedge env.mmio.w223) $display("W223-neg @%0t d=%b a=%h soc_wr=%b", $time, env.d, env.a, env.soc_wr);
	always @(posedge env.mmio.w148) $display("W148-pos @%0t d=%b a=%h soc_wr=%b", $time, env.d, env.a, env.soc_wr);

endmodule
