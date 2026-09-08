// tb_timing - tiny trace of d/clk2/soc_rd around one write+read cycle.
`timescale 1ns/1ns
module tb_timing;
	apu_env e ();
	reg [7:0] rb;
	initial begin
		$dumpfile("tb_timing.vcd");
		$dumpvars(0, tb_timing);
		repeat (16) @(negedge e.ck1);
		e.reset = 1'b0;
		repeat (16) @(negedge e.ck1);
		e.cpu_write(16'hFF26, 8'h80);
		e.cpu_write(16'hFF12, 8'hF3);
		e.cpu_read(16'hFF12, rb);       // expect F3
		$display("FF12 read = %02x", rb);
		e.cpu_write(16'hFF13, 8'h00);   // freq lo (write-only?)
		e.cpu_read(16'hFF13, rb);
		$display("FF13 read = %02x", rb);
		repeat (8) @(negedge e.ck1);
		$finish;
	end
endmodule
