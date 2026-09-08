`timescale 1ns/1ns
module tb_mix;
	apu_env e ();
	integer errors = 0;
	reg [7:0] rb;
	task chk(input [127:0] what, input [7:0] got, input [7:0] want);
		begin
			if (got !== want) begin
				$display("FAIL %0s: got %b want %b", what, got, want);
				errors = errors + 1;
			end else $display("PASS %0s: %b", what, got);
		end
	endtask
	initial begin
		repeat (16) @(negedge e.ck1);
		e.reset = 1'b0;
		repeat (16) @(negedge e.ck1);
		e.cpu_write(16'hFF26, 8'h80);

		// NR51 mixer routing -> lmixer/rmixer
		e.cpu_write(16'hFF25, 8'h11);   // ch1 -> L and R
		chk("rmixer after NR51=11 (low nib)", {4'b0, e.rmixer}, 8'h01);
		chk("lmixer after NR51=11 (high nib)", {4'b0, e.lmixer}, 8'h01);
		e.cpu_write(16'hFF25, 8'hF0);   // low nibble -> right (SO1), high -> left (SO2)
		chk("rmixer after NR51=F0", {4'b0, e.rmixer}, 8'h00);
		chk("lmixer after NR51=F0", {4'b0, e.lmixer}, 8'h0F);
		e.cpu_write(16'hFF25, 8'hA5);   // ch4L+ch2L | ch3R+ch1R
		chk("rmixer after NR51=A5 (low nib)", {4'b0, e.rmixer}, 8'h05);
		chk("lmixer after NR51=A5 (high nib)", {4'b0, e.lmixer}, 8'h0A);

		// NR50 volumes -> n_lvolume/n_rvolume (active low), vin bits
		e.cpu_write(16'hFF24, 8'h77);
		chk("n_lvolume for vol7", {5'b0, e.n_lvolume}, 8'h00);
		chk("n_rvolume for vol7", {5'b0, e.n_rvolume}, 8'h00);
		e.cpu_write(16'hFF24, 8'h10);   // left vol 1, right vol 0
		chk("n_lvolume for vol1", {5'b0, e.n_lvolume}, 8'h06);
		chk("n_rvolume for vol0", {5'b0, e.n_rvolume}, 8'h07);
		e.cpu_write(16'hFF24, 8'h88);   // vin on both (bits7/3)
		chk("r_vin_en", {7'b0, e.r_vin_en}, 8'h01);
		chk("l_vin_en", {7'b0, e.l_vin_en}, 8'h01);
		e.cpu_write(16'hFF24, 8'h00);
		chk("r_vin_en off", {7'b0, e.r_vin_en}, 8'h00);
		chk("l_vin_en off", {7'b0, e.l_vin_en}, 8'h00);

		// channel DAC amp enables: follow the channel running state
		e.cpu_write(16'hFF10, 8'h00);
		e.cpu_write(16'hFF11, 8'h80);
		e.cpu_write(16'hFF12, 8'hF0);
		e.cpu_write(16'hFF13, 8'h80);
		e.cpu_write(16'hFF14, 8'h87);   // trigger ch1
		#20000;
		chk("n_ch1_amp_en running (en=0)", {7'b0, e.n_ch1_amp_en}, 8'h00);
		chk("n_ch2_amp_en idle (en=1)", {7'b0, e.n_ch2_amp_en}, 8'h01);
		e.cpu_write(16'hFF26, 8'h00);   // power off clears everything
		#20000;
		chk("n_ch1_amp_en after power-off", {7'b0, e.n_ch1_amp_en}, 8'h01);

		$display("RESULT tb_apu_mix %s (%0d fails)", errors ? "FAIL" : "PASS", errors);
		$finish;
	end
endmodule
