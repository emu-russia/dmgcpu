`timescale 1ns/1ns
module tb_env3;
	apu_env e ();
	integer lfo_edges = 0;
	always #2000 e.lfo_ext = ~e.lfo_ext;
	always @(posedge e.lfo_ext) lfo_edges = lfo_edges + 1;
	integer fh;
	reg [7:0] rb;
	integer segn = 0;
	reg [3:0] lastlvl = 4'hf;
	integer t_us;
	task run_env(input [7:0] nr12, input integer rate_field);
		integer t0;
		begin
			segn = segn + 1;
			e.lfo_override = 1'b1;
			e.cpu_write(16'hFF26, 8'h00);
			e.cpu_write(16'hFF26, 8'h80);
			e.cpu_write(16'hFF10, 8'h00);
			e.cpu_write(16'hFF11, 8'h80);      // duty 50%
			e.cpu_write(16'hFF12, nr12);
			e.cpu_write(16'hFF13, 8'hF0);
			e.cpu_write(16'hFF14, 8'h8F);      // X = 0x7F0 (short period)
			#4000;
			t0 = lfo_edges;
			lastlvl = 4'hf;
			$fdisplay(fh, "SEG %0d rate=%0d t0_lfo=%0d", segn, rate_field, t0);
			// record every level drop as (level, lfo offset)
			for (t_us = 0; t_us < 3000; t_us = t_us + 1) begin
				#1000;
				if (e.ch1_out !== 4'h0 && e.ch1_out !== 4'hx &&
				    e.ch1_out !== lastlvl) begin
					if (e.ch1_out < lastlvl)   // only downward (decay)
						$fdisplay(fh, "SEG %0d lvl=%h lfo=%0d", segn,
						          e.ch1_out, lfo_edges - t0);
					lastlvl = e.ch1_out;
				end
			end
		end
	endtask
	initial begin
		fh = $fopen("apu_env3_segs.log");
		repeat (16) @(negedge e.ck1);
		e.reset = 1'b0;
		repeat (16) @(negedge e.ck1);
		run_env(8'hF1, 1);
		run_env(8'hF2, 2);
		run_env(8'hF3, 3);
		run_env(8'hF4, 4);
		run_env(8'hF7, 7);
		$fclose(fh);
		$finish;
	end
endmodule
