// tb_apu_ch3 - Channel 3 (wave) regression data generator (issue #398).
// Drives CH3 with a known wave RAM image and logs ch3_out / wave_a /
// ch3_active; check_ch3.py verifies amplitude = NR32-scaled sample and the
// sample-fetch cadence.
`timescale 1ns/1ns
module tb_apu_ch3;
	apu_env e ();
	integer fh;
	reg [7:0] rb;
	integer i;

	integer segn = 0;
	task ch3_setup(input [7:0] nr32, input [10:0] freq);
		begin
			segn = segn + 1;
			e.cpu_write(16'hFF26, 8'h00);   // reset channels between runs
			e.cpu_write(16'hFF26, 8'h80);
			e.cpu_write(16'hFF1A, 8'h80);   // NR30 DAC on
			e.cpu_write(16'hFF1B, 8'h3F);   // NR31 length 0x3F
			e.cpu_write(16'hFF1C, nr32);    // NR32 volume code
			e.cpu_write(16'hFF1D, freq[7:0]);
			e.cpu_write(16'hFF1E, 8'h80 | {5'b0, freq[10:8]});
			$fdisplay(fh, "SEG %0d t=%0t nr32=%02x freq=%0d", segn, $time, nr32, freq);
			$display("SEG %0d t=%0t nr32=%02x freq=%0d", segn, $time, nr32, freq);
		end
	endtask

	initial begin
		$dumpfile("tb_apu_ch3.vcd");
		$dumpvars(0, tb_apu_ch3);
		fh = $fopen("apu_ch3_segs.log");
		repeat (16) @(negedge e.ck1);
		e.reset = 1'b0;
		repeat (16) @(negedge e.ck1);

		// wave RAM image: byte i = 0xF0 + i (sample stream repeats F)
		for (i = 0; i < 16; i = i + 1)
			e.waveram.poke(i[3:0], 8'hF0 | i[3:0]);

		// 1) vol code 01 (100%): output should be sample value F steady
		ch3_setup(8'h20, 11'h7F0);
		#400000;
		// 2) vol code 10 (50%): F>>1 = 7
		ch3_setup(8'h40, 11'h7F0);
		#400000;
		// 3) vol code 11 (25%): F>>2 = 3
		ch3_setup(8'h60, 11'h7F0);
		#400000;
		// 4) vol code 00 (mute): 0
		ch3_setup(8'h00, 11'h7F0);
		#400000;
		// 5) sample cadence: X = 0x7F0, wave_a counting rate
		ch3_setup(8'h20, 11'h7F0);
		#1000000;
		// 6) slower X = 0x780: (2048-X)=128 -> cadence x8
		ch3_setup(8'h20, 11'h780);
		#1000000;

		$fclose(fh);
		$display("RESULT tb_apu_ch3 DONE (analysed by check_ch3.py)");
		$finish;
	end
endmodule
