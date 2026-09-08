// tb_hram - HRAM ($FF80-$FFFE) roundtrip test (issue #396)
//
// Uses the behavioral hram_model.v (the real macro's storage cells are
// still TBD stubs in sram.v). Exercises the HRAM interface through the
// real MMIO+Arbiter decode: soc_wr/soc_rd/ffxx + a[7] select the window.
//
// Compile with -DNO_SER: Ser's bus hookup aliases a shift-chain node onto
// d[6] and permanently drives it under the static bus model (see
// STATUS.md "Ser bus modelling"), which would corrupt every d[6]=1 write.
`timescale 1ns/1ns

module tb_hram;

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

	reg [7:0] rdv;

	initial begin
		$dumpfile("tb_hram.vcd");
		$dumpvars(0, tb_hram);

		env.reset = 1'b1;
		repeat (16) @ (posedge env.ck1);
		env.reset = 1'b0;
		repeat (16) @ (posedge env.clk9);

		// write / read-back roundtrips across the HRAM window
		env.cpu_write(16'hFF80, 8'hAB);
		env.cpu_read(16'hFF80, rdv);
		$display("HRAM FF80 = %b", rdv);
		chk("hram-ff80", rdv == 8'hAB);

		env.cpu_write(16'hFFC0, 8'h5A);
		env.cpu_read(16'hFFC0, rdv);
		$display("HRAM FFC0 = %b", rdv);
		chk("hram-ffc0", rdv == 8'h5A);

		env.cpu_write(16'hFFFE, 8'hFF);
		env.cpu_read(16'hFFFE, rdv);
		$display("HRAM FFFE = %b", rdv);
		chk("hram-fffe", rdv == 8'hFF);

		// neighbouring cells stay independent
		env.cpu_read(16'hFFC0, rdv);
		chk("hram-ffc0-unmodified", rdv == 8'h5A);
		env.cpu_read(16'hFF81, rdv);
		$display("HRAM FF81 (untouched) = %b", rdv);
		chk("hram-ff81-init0", rdv == 8'h00);

		// rewrite a cell to 0
		env.cpu_write(16'hFF80, 8'h00);
		env.cpu_read(16'hFF80, rdv);
		$display("HRAM FF80 rewrite = %b", rdv);
		chk("hram-ff80-rewrite0", rdv == 8'h00);

		// $FFFF (IE) is outside the HRAM window (netlist decode excludes
		// a[6:0] = 0x7F); a write there must not touch the RAM
		env.cpu_write(16'hFFFF, 8'h55);
		env.cpu_read(16'hFFFE, rdv);
		chk("hram-ffff-write-ignored", rdv == 8'hFF);

		$display("RESULT tb_hram %0d checks, %0d failures", checks, fails);
		if (fails) $display("RESULT tb_hram FAIL");
		else       $display("RESULT tb_hram PASS");
		$finish;
	end

endmodule
