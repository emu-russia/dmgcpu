`timescale 1ns/1ns
module tb_env2;
	apu_env e ();
	integer lfo_edges = 0;
	always #2000 e.lfo_ext = ~e.lfo_ext;
	always @(posedge e.lfo_ext) lfo_edges = lfo_edges + 1;
	reg [7:0] rb;
	integer segn = 0;
	task run_env(input [7:0] nr12);
		integer t0_edges, wait_us;
		begin
			segn = segn + 1;
			e.lfo_override = 1'b1;
			e.cpu_write(16'hFF26, 8'h00);
			e.cpu_write(16'hFF26, 8'h80);
			e.cpu_write(16'hFF10, 8'h00);
			e.cpu_write(16'hFF11, 8'h80);
			e.cpu_write(16'hFF12, nr12);
			e.cpu_write(16'hFF13, 8'h80);
			e.cpu_write(16'hFF14, 8'h87);
			#2000;
			t0_edges = lfo_edges;
			// wait until NR52 ch1 status clears (envelope reached 0)
			wait_us = 0;
			begin : loop
				repeat (30000) begin
					#1000; wait_us = wait_us + 1;
					if ((wait_us % 2000) == 0) begin
						e.cpu_read(16'hFF26, rb);
						if (!(rb & 8'h01)) disable loop;
					end
				end
			end
			e.cpu_read(16'hFF26, rb);
			$display("SEG %d nr12=%02x off_after_lfo=%0d (15 steps => %.1f lfo/step) st=%02x",
				segn, nr12, lfo_edges - t0_edges,
				(lfo_edges - t0_edges) / 15.0, rb);
		end
	endtask
	initial begin
		repeat (16) @(negedge e.ck1);
		e.reset = 1'b0;
		repeat (16) @(negedge e.ck1);
		run_env(8'hF1);
		run_env(8'hF2);
		run_env(8'hF3);
		run_env(8'hF7);
		$finish;
	end
endmodule
