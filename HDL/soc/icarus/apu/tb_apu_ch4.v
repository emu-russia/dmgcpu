// tb_apu_ch4 - Channel 4 (noise/LFSR) regression data generator (#398).
// Logs ch4_out for several NR43 shift-clock settings; check_ch4.py
// verifies the noise toggles and that the divider scaling follows NR43.
`timescale 1ns/1ns
module tb_apu_ch4;
	apu_env e ();
	integer fh;
	reg [7:0] rb;

	integer segn = 0;
	task ch4_setup(input [7:0] nr43, input [10:0] dummy);
		begin
			segn = segn + 1;
			e.cpu_write(16'hFF26, 8'h00);
			e.cpu_write(16'hFF26, 8'h80);
			e.cpu_write(16'hFF20, 8'h3F);   // NR41 length max
			e.cpu_write(16'hFF21, 8'hF0);   // NR42 vol F
			e.cpu_write(16'hFF22, nr43);    // NR43
			e.cpu_write(16'hFF23, 8'h80);   // NR44 trigger
			$fdisplay(fh, "SEG %0d t=%0t nr43=%02x", segn, $time, nr43);
			$display("SEG %0d t=%0t nr43=%02x", segn, $time, nr43);
		end
	endtask

	initial begin
		$dumpfile("tb_apu_ch4.vcd");
		$dumpvars(0, tb_apu_ch4);
		fh = $fopen("apu_ch4_segs.log");
		repeat (16) @(negedge e.ck1);
		e.reset = 1'b0;
		repeat (16) @(negedge e.ck1);

		ch4_setup(8'h00, 0);    // divider 0, 15-bit LFSR
		#600000;
		ch4_setup(8'h07, 0);    // divider 7
		#600000;
		ch4_setup(8'h08, 0);    // 7-bit LFSR (bit3)
		#600000;
		ch4_setup(8'h0F, 0);    // divider 7 + 7-bit
		#600000;

		$fclose(fh);
		$display("RESULT tb_apu_ch4 DONE (analysed by check_ch4.py)");
		$finish;
	end
endmodule
