// tb_ser - serial link (Ser) exploratory test (issue #396)
//
// SB ($FF01) load, SC ($FF02) write with internal clock, shift behaviour,
// int_serial on completion. Prints observations; assertions tightened as
// the Ser netlist is characterized.
`timescale 1ns/1ns

module tb_ser;

	soc_env env();

	integer ticks = 0;
	reg tick_en = 1'b0;
	always @(posedge env.serial_tick) if (tick_en) ticks = ticks + 1;

	reg [7:0] rdv;
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

	task rd(input [15:0] addr);
		begin
			env.cpu_read(addr, rdv);
			$display("READ %h = %b", addr, rdv);
		end
	endtask

	initial begin
		$dumpfile("tb_ser.vcd");
		$dumpvars(0, tb_ser);

		// reset
		env.reset = 1'b1;
		repeat (16) @ (posedge env.ck1);
		env.reset = 1'b0;
		repeat (16) @ (posedge env.clk9);

		chk("ser-idle-no-irq", env.int_serial === 1'b0);

		// SB load, read back immediately (works exactly with the
		// ser_sharedq.v bus variant - d[6] is no longer force-driven by
		// the shift-chain terminal)
		env.cpu_write(16'hFF01, 8'hA5);
		rd(16'hFF01);
		chk("sb-roundtrip-0xA5", rdv == 8'hA5);

		// SC: start + internal clock (bit7 + bit0)
		env.cpu_write(16'hFF02, 8'h81);
		chk("sck-dir-internal", env.sck_dir === 1'b1);

		// observe the transfer: 8 serial ticks, then int_serial
		tick_en = 1'b1;
		repeat (4096) @ (posedge env.clk9);
		tick_en = 1'b0;
		$display("--- after 4096 clk9 ---");
		$display("ticks=%0d int_serial=%b sck_dir=%b", ticks, env.int_serial, env.sck_dir);
		chk("ser-8-ticks", ticks == 8);
		chk("ser-int-on-complete", env.int_serial === 1'b1);
		rd(16'hFF01);   // SB after transfer: 8x 1 shifted in -> 0xFF
		chk("sb-shifted-all-ones", rdv == 8'hFF);
		rd(16'hFF02);   // SC: start bit auto-cleared
		chk("sc-start-bit-cleared", rdv[7] === 1'b0);

		// serial IRQ reaches the MMIO IF flag (bit3)
		chk("if-serial-flag", env.cpu_irq_trig[3] === 1'b1);
		env.cpu_irq_ack = 5'b01000;
		repeat (2) @ (posedge env.clk9);
		env.cpu_irq_ack = 5'b00000;
		repeat (4) @ (posedge env.clk9);
		chk("if-serial-ack-clears", env.cpu_irq_trig[3] === 1'b0);

		$display("RESULT tb_ser %0d checks, %0d failures", checks, fails);
		if (fails) $display("RESULT tb_ser FAIL");
		else       $display("RESULT tb_ser PASS");
		$finish;
	end

endmodule
