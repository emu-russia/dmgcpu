// tb_apu_readsel - decode sweep: which read-enable groups fire per address.
// Research probe for the register map (reads FF10..FF2F with NR52 powered).
`timescale 1ns/1ns

module tb_apu_readsel;

	apu_env e ();

	integer i, errors = 0;
	reg [7:0] rb;
	reg [36:0] sel;

	initial begin
		$dumpfile("tb_apu_readsel.vcd");
		$dumpvars(0, tb_apu_readsel);

		repeat (16) @(negedge e.ck1);
		e.reset = 1'b0;
		repeat (16) @(negedge e.ck1);

		e.cpu_write(16'hFF26, 8'h80);   // NR52 power on

		$display("addr  data  sel(w225 w310 w116 w812 w28 w177 w174 w46 w47 w474 w483 w432 w212 w359 w399 w411 w413 w505 w526 w548 w555 w582 w609 w632 w643 w68 w828 w907 w909 w993 w1052 w1101 w1113 w1177 w1254 w15 w499)");
		for (i = 16'h00; i <= 16'h3F; i = i + 1) begin
			e.cpu_read_sel(16'hFF00 + i, 64, rb, sel);
			$display("%02x   %02x   %037b", i, rb, sel);
		end

		$display("RESULT tb_apu_readsel %s", errors ? "FAIL" : "DONE");
		$finish;
	end

endmodule
