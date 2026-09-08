// research: synchronous sampling of ch1_out during envelope decay
`timescale 1ns/1ns
module tb_envtrace;
	apu_env e ();
	integer fh;
	reg [7:0] rb;
	reg [3:0] samp;
	integer t_us;
	initial begin
		fh = $fopen("env_trace.txt");
		repeat (16) @(negedge e.ck1);
		e.reset = 1'b0;
		repeat (16) @(negedge e.ck1);
		e.cpu_write(16'hFF26, 8'h80);
		e.lfo_override = 1'b1;
		e.cpu_write(16'hFF10, 8'h00);
		e.cpu_write(16'hFF11, 8'h80);
		e.cpu_write(16'hFF12, 8'hF1);
		e.cpu_write(16'hFF13, 8'h80);
		e.cpu_write(16'hFF14, 8'h87);
		for (t_us = 0; t_us < 500; t_us = t_us + 1) begin
			#1000;   // sample every 1 us
			$fdisplay(fh, "%0d %h", t_us*1000, e.ch1_out);
		end
		$fclose(fh);
		$display("done");
		$finish;
	end
endmodule
