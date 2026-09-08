// tb_div - DIV counter read-back probe with the mmio_weakbus variant
`timescale 1ns/1ns
module tb_div;

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

	task nox(input [7:0] v, output reg ok);
		begin ok = ((v[0] !== 1'bx) && (v[1] !== 1'bx) && (v[2] !== 1'bx) &&
		           (v[3] !== 1'bx) && (v[4] !== 1'bx) && (v[5] !== 1'bx) &&
		           (v[6] !== 1'bx) && (v[7] !== 1'bx)); end
	endtask

	reg [7:0] v1, v2, v3;
	reg clean;
	integer t;

	initial begin
		$dumpfile("tb_div.vcd");
		$dumpvars(0, tb_div);
		env.reset = 1'b1;
		repeat (16) @ (posedge env.ck1);
		env.reset = 1'b0;
		repeat (16) @ (posedge env.clk9);
		// reset divider, then sample it as it runs (mmio_weakbus.v)
		env.cpu_write(16'hFF04, 8'h00);
		repeat (8) @ (posedge env.clk9);
		env.cpu_read(16'hFF04, v1);
		$display("RESULT DIV t1 = %b", v1);
		nox(v1, clean);
		chk("div-read-clean-1", clean);
		chk("div-near-zero-after-reset", v1[7:1] === 7'b0);

		repeat (8192) @ (posedge env.clk9);   // ~128 lfo ticks
		env.cpu_read(16'hFF04, v2);
		$display("RESULT DIV t2 = %b", v2);
		nox(v2, clean);
		chk("div-read-clean-2", clean);
		chk("div-counted", v2 !== v1);

		repeat (8192) @ (posedge env.clk9);   // another ~128 ticks
		env.cpu_read(16'hFF04, v3);
		$display("RESULT DIV t3 = %b", v3);
		nox(v3, clean);
		chk("div-read-clean-3", clean);

		$display("RESULT tb_div %0d checks, %0d failures", checks, fails);
		if (fails) $display("RESULT tb_div FAIL");
		else       $display("RESULT tb_div PASS");
		$finish;
	end
endmodule
