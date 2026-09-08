// tb_apu_fs - frame-sequencer / LFO rate measurements (issue #398).
//
// The APU receives lfo_512Hz (frame-sequencer clock). This test drives a
// synthetic lfo (period T_lfo = 4us) and measures how many lfo periods the
// envelope / length / sweep updates take, i.e. the fs sub-division factors
// of the real netlist (expected per Game Boy literature: envelope = lfo/8,
// length = lfo/2, sweep = lfo/4; the exact phase pattern is measured here).
`timescale 1ns/1ns

module tb_apu_fs;

	apu_env e ();

	integer errors = 0;
	reg [7:0] rb;
	reg [3:0] hi_val;            // high-plateau amplitude of ch1_out
	integer env_prev_time, env_steps;
	integer len_prev_time, ch1_off_time;
	integer lfo_period_ns = 4000;   // synthetic lfo period (ns)

	// ch1_out high-plateau tracker
	always @(e.ch1_out) begin
		if (e.ch1_out === 4'hf || (e.ch1_out > hi_val && e.ch1_out !== 4'h0))
			hi_val = e.ch1_out;
	end

	// count lfo edges (env/length clock derived from the fs)
	integer lfo_edges = 0;
	always @(posedge e.lfo_ext) lfo_edges = lfo_edges + 1;
	always #2000 e.lfo_ext = ~e.lfo_ext;   // synthetic 512Hz source

	// envelope amplitude drop tracker (non-zero ch1_out plateau changes)
	integer amp_log_t [0:127];
	reg  [3:0] amp_log_v [0:127];
	integer amp_log_n = 0;
	reg  [3:0] last_nz = 4'h0;
	always @(e.ch1_out) begin
		if (e.ch1_out !== 4'h0 && e.ch1_out !== 4'hx &&
		    e.ch1_out !== last_nz) begin
			if (amp_log_n < 128) begin
				amp_log_t[amp_log_n] = $time;
				amp_log_v[amp_log_n] = e.ch1_out;
				amp_log_n = amp_log_n + 1;
			end
			last_nz = e.ch1_out;
		end
	end

	task check(input [159:0] what, input integer got, input integer want);
		begin
			if (got !== want) begin
				$display("FAIL %0s: got %0d want %0d", what, got, want);
				errors = errors + 1;
			end else begin
				$display("PASS %0s: %0d", what, got);
			end
		end
	endtask

	// drive the synthetic 512Hz source
	task lfo_on;
		begin
			e.lfo_override = 1'b1;
		end
	endtask

	initial begin
		$dumpfile("tb_apu_fs.vcd");
		$dumpvars(0, tb_apu_fs);
		hi_val = 4'h0;

		repeat (16) @(negedge e.ck1);
		e.reset = 1'b0;
		repeat (16) @(negedge e.ck1);

		e.cpu_write(16'hFF26, 8'h80);   // power on
		e.cpu_read(16'hFF26, rb);
		check("NR52 powered read", rb, 8'hF0);

		// =================================================================
		// 1) envelope rate: NR12 = F1 (vol 15, decay, step 1)
		// =================================================================
		e.lfo_override = 1'b1;
		e.cpu_write(16'hFF10, 8'h00);   // no sweep
		e.cpu_write(16'hFF11, 8'h80);   // duty 50%
		e.cpu_write(16'hFF12, 8'hF1);   // env F decay step 1
		e.cpu_write(16'hFF13, 8'h80);
		e.cpu_write(16'hFF14, 8'h87);   // trigger, X = 0x780
		amp_log_n = 0; last_nz = 4'h0;
		lfo_edges = 0;
		#1000000;                        // 1 ms: watch the envelope decay
		$display("MEAS envelope: lfo period %0d ns, lfo edges in window = %0d",
		         lfo_period_ns, lfo_edges);
		begin : dump_amp
			integer k;
			for (k = 0; k < amp_log_n; k = k + 1)
				$display("  amp@t=%0d -> %h", amp_log_t[k], amp_log_v[k]);
			if (amp_log_n >= 2) begin
				$display("  env step interval ns = %0d  (lfo/8 = %0d, lfo/4 = %0d)",
				         amp_log_t[1] - amp_log_t[0],
				         lfo_period_ns * 8, lfo_period_ns * 4);
			end
		end

		// envelope steps observed at amplitude drops (F->E->D...); find them
		// by sampling the amplitude sequence
		// (measured hi_val is only the max over the window; count steps via
		//  the value-change log below instead)
		$display("MEAS ch1 amp max in window = %h", hi_val);

		// stop ch1
		e.cpu_write(16'hFF26, 8'h00);   // power off clears everything
		e.cpu_write(16'hFF26, 8'h80);

		$display("RESULT tb_apu_fs %s (%0d fails)", errors ? "FAIL" : "PASS", errors);
		$finish;
	end

endmodule
