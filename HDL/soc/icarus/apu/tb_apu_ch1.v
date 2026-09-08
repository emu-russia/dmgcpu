// tb_apu_ch1 - Channel 1 regression data generator (issue #398).
//
// Runs CH1 through a fixed set of (duty, volume, freq) configurations,
// dumping ch1_out; the segment boundaries are logged to apu_ch1_segs.log
// and analysed by check_ch1.py (duty fractions, output period formula,
// volume plateau, NR52 status bit).
`timescale 1ns/1ns

module tb_apu_ch1;

	apu_env e ();

	integer fh;
	reg [7:0] rb;

	// setup + trigger CH1 and stay for ~4 periods of (2048-freq)*32 osc
	task ch1_run(input [7:0] duty_len, input [7:0] vol, input [10:0] freq,
	             input integer segn);
		integer wait_ns;
		begin
			e.cpu_write(16'hFF26, 8'h00);     // stop previous segment
			e.cpu_write(16'hFF26, 8'h80);
			e.cpu_write(16'hFF10, 8'h00);     // no sweep
			e.cpu_write(16'hFF11, duty_len);
			e.cpu_write(16'hFF12, vol);
			e.cpu_write(16'hFF13, freq[7:0]);
			e.cpu_write(16'hFF14, 8'h80 | {5'b0, freq[10:8]});   // trigger
			wait_ns = (2048 - freq) * 32 * 64 * 4;    // ~4 periods
			$fdisplay(fh, "SEG %0d t=%0t freq=%0d", segn, $time, freq);
			$display("SEG %0d t=%0t freq=%0d", segn, $time, freq);
			#(wait_ns);
			e.cpu_read(16'hFF26, rb);
			$fdisplay(fh, "SEG %0d status=%02x t=%0t", segn, rb, $time);
		end
	endtask

	initial begin
		$dumpfile("tb_apu_ch1.vcd");
		$dumpvars(0, tb_apu_ch1);
		fh = $fopen("apu_ch1_segs.log");

		repeat (16) @(negedge e.ck1);
		e.reset = 1'b0;
		repeat (16) @(negedge e.ck1);

		ch1_run(8'h00, 8'hF0, 11'h780, 1);   // duty 12.5%, vol F, X=0x780
		ch1_run(8'h40, 8'hF0, 11'h780, 2);   // duty 25%
		ch1_run(8'h80, 8'hF0, 11'h780, 3);   // duty 50%
		ch1_run(8'hC0, 8'hF0, 11'h780, 4);   // duty 75%
		ch1_run(8'h80, 8'h50, 11'h780, 5);   // duty 50%, vol 5
		ch1_run(8'h80, 8'hA0, 11'h780, 6);   // duty 50%, vol A
		ch1_run(8'h80, 8'hF0, 11'h700, 7);   // duty 50%, X=0x700 (period x2)

		$fclose(fh);
		$display("RESULT tb_apu_ch1 DONE (analysed by check_ch1.py)");
		$finish;
	end

endmodule
