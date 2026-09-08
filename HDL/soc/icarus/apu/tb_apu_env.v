// tb_apu_env - envelope/length/sweep vs the frame-sequencer (issue #398).
// Synthetic lfo (period 4000 ns); ch1_out sampled at 1 us.  Envelope
// steps (plateau drops) are measured as lfo-pulse counts.
`timescale 1ns/1ns
module tb_apu_env;
	apu_env e ();
	integer fh;
	reg [7:0] rb;
	integer lfo_edges;
	always #2000 e.lfo_ext = ~e.lfo_ext;
	always @(posedge e.lfo_ext) lfo_edges = lfo_edges + 1;

	integer segn = 0;
	integer t_us;
	reg [3:0] prev;
	integer prev_lfo;
	task start_env(input [7:0] nr12, input integer us);
		begin
			segn = segn + 1;
			prev = 4'hx; prev_lfo = 0;
			e.lfo_override = 1'b1;
			e.cpu_write(16'hFF26, 8'h00);
			e.cpu_write(16'hFF26, 8'h80);
			e.cpu_write(16'hFF10, 8'h00);
			e.cpu_write(16'hFF11, 8'h80);     // duty 50%
			e.cpu_write(16'hFF12, nr12);
			e.cpu_write(16'hFF13, 8'h80);
			e.cpu_write(16'hFF14, 8'h87);     // X=0x780
			$fdisplay(fh, "SEG %0d t=%0t nr12=%02x", segn, $time, nr12);
			// sample ch1_out plateaus every us, report level drops with
			// the lfo-edge count at each drop
			for (t_us = 0; t_us < us; t_us = t_us + 1) begin
				#1000;
				if (e.ch1_out !== prev && e.ch1_out !== 4'h0 &&
				    e.ch1_out !== 4'hx) begin
					$fdisplay(fh, "SEG %0d lvl=%h lfo=%0d", segn,
					          e.ch1_out, lfo_edges);
					prev = e.ch1_out;
				end
			end
		end
	endtask

	initial begin
		fh = $fopen("apu_env_segs.log");
		repeat (16) @(negedge e.ck1);
		e.reset = 1'b0;
		repeat (16) @(negedge e.ck1);
		lfo_edges = 0;
		start_env(8'hF0, 400);   // rate 0 decay
		start_env(8'hF1, 300);   // rate 1 decay
		start_env(8'hF2, 300);   // rate 2 decay
		start_env(8'hF3, 300);   // rate 3 decay
		start_env(8'hF7, 300);   // rate 7 decay
		start_env(8'h5F, 300);   // vol 5, dir=1 increase, rate 7
		$fclose(fh);
		$display("RESULT tb_apu_env DONE (analysed by check_env.py)");
		$finish;
	end
endmodule
