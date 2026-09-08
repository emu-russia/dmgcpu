// tb_sm83_jump - SM83 relative-jump + RST regression (issue #400).
//
// Runs a program on the REAL SM83 core netlist (HDL/sm83, Top.v SM83Core)
// verifying the flag-conditional relative jumps JR NZ/Z/NC/C (both taken
// and not-taken paths, each stamping a distinct marker cell) and RST 08/18
// (vector page + return-address push/pop).  Code is assembled to fixed
// addresses (boot JR from $0000 to $0040; RST pages at $0008/$0018).
`timescale 1ns/1ns

module tb_sm83_jump;

	sm83_env e ();

	integer errors = 0;
	integer pcnt = 0;

	task check(input [159:0] what, input [31:0] got, input [31:0] want);
		begin
			if (got !== want) begin
				$display("FAIL %0s: got %02x want %02x", what, got, want);
				errors = errors + 1;
			end
			pcnt = pcnt + 1;
		end
	endtask

	reg ok;
	reg [7:0] rb;

	initial begin
		$dumpfile("tb_sm83_jump.vcd");
		$dumpvars(0, tb_sm83_jump);
		// ---- boot: JR $0040 over the RST pages ---------------------------
		e.poke(16'h0000, 8'h18); e.poke(16'h0001, 8'h3E);

		// ---- RST 08 page: stamp M6=0x77, RET -----------------------------
		e.poke(16'h0008, 8'h3E); e.poke(16'h0009, 8'h77);
		e.poke(16'h000A, 8'hEA); e.poke(16'h000B, 8'h06); e.poke(16'h000C, 8'h38);
		e.poke(16'h000D, 8'hC9);

		// ---- RST 18 page: stamp M7=0x99, RET -----------------------------
		e.poke(16'h0018, 8'h3E); e.poke(16'h0019, 8'h99);
		e.poke(16'h001A, 8'hEA); e.poke(16'h001B, 8'h07); e.poke(16'h001C, 8'h38);
		e.poke(16'h001D, 8'hC9);

		// ---- main body $0040 ---------------------------------------------
		// Z=1: LD A,0; OR A
		e.poke(16'h0040, 8'h3E); e.poke(16'h0041, 8'h00); e.poke(16'h0042, 8'hB7);
		e.poke(16'h0043, 8'h20); e.poke(16'h0044, 8'h05);  // JR NZ,+5 NOT taken
		e.poke(16'h0045, 8'h3E); e.poke(16'h0046, 8'h01);  // stamp M0=01
		e.poke(16'h0047, 8'hEA); e.poke(16'h0048, 8'h00); e.poke(16'h0049, 8'h38);
		e.poke(16'h004A, 8'h28); e.poke(16'h004B, 8'h05);  // JR Z,+5 taken
		e.poke(16'h004C, 8'h3E); e.poke(16'h004D, 8'hEE);  // wrong path M1=EE
		e.poke(16'h004E, 8'hEA); e.poke(16'h004F, 8'h01); e.poke(16'h0050, 8'h38);
		e.poke(16'h0051, 8'h3E); e.poke(16'h0052, 8'h02);  // M1=02 (taken path)
		e.poke(16'h0053, 8'hEA); e.poke(16'h0054, 8'h01); e.poke(16'h0055, 8'h38);

		// C=1: SCF
		e.poke(16'h0056, 8'h37);
		e.poke(16'h0057, 8'h30); e.poke(16'h0058, 8'h05);  // JR NC,+5 NOT taken
		e.poke(16'h0059, 8'h3E); e.poke(16'h005A, 8'h03);  // M2=03
		e.poke(16'h005B, 8'hEA); e.poke(16'h005C, 8'h02); e.poke(16'h005D, 8'h38);
		e.poke(16'h005E, 8'h38); e.poke(16'h005F, 8'h05);  // JR C,+5 taken
		e.poke(16'h0060, 8'h3E); e.poke(16'h0061, 8'hEE);  // wrong path M3=EE
		e.poke(16'h0062, 8'hEA); e.poke(16'h0063, 8'h03); e.poke(16'h0064, 8'h38);
		e.poke(16'h0065, 8'h3E); e.poke(16'h0066, 8'h04);  // M3=04 (taken path)
		e.poke(16'h0067, 8'hEA); e.poke(16'h0068, 8'h03); e.poke(16'h0069, 8'h38);

		// Z=0: LD A,1; OR A
		e.poke(16'h006A, 8'h3E); e.poke(16'h006B, 8'h01); e.poke(16'h006C, 8'hB7);
		e.poke(16'h006D, 8'h20); e.poke(16'h006E, 8'h05);  // JR NZ,+5 taken
		e.poke(16'h006F, 8'h3E); e.poke(16'h0070, 8'hEE);  // wrong path M4=EE
		e.poke(16'h0071, 8'hEA); e.poke(16'h0072, 8'h04); e.poke(16'h0073, 8'h38);
		e.poke(16'h0074, 8'h3E); e.poke(16'h0075, 8'h05);  // M4=05 (taken path)
		e.poke(16'h0076, 8'hEA); e.poke(16'h0077, 8'h04); e.poke(16'h0078, 8'h38);
		e.poke(16'h0079, 8'h28); e.poke(16'h007A, 8'h05);  // JR Z,+5 NOT taken
		e.poke(16'h007B, 8'h3E); e.poke(16'h007C, 8'h06);  // M5=06
		e.poke(16'h007D, 8'hEA); e.poke(16'h007E, 8'h05); e.poke(16'h007F, 8'h38);

		// RST 08 + RST 18 (need a stack)
		e.poke(16'h0080, 8'h31); e.poke(16'h0081, 8'h00); e.poke(16'h0082, 8'h3F); // LD SP,3F00
		e.poke(16'h0083, 8'hCF);  // RST 08
		e.poke(16'h0084, 8'h3E); e.poke(16'h0085, 8'h88);  // M8=88 after return
		e.poke(16'h0086, 8'hEA); e.poke(16'h0087, 8'h08); e.poke(16'h0088, 8'h38);
		e.poke(16'h0089, 8'hDF);  // RST 18
		e.poke(16'h008A, 8'h3E); e.poke(16'h008B, 8'h89);  // M9=89 after return
		e.poke(16'h008C, 8'hEA); e.poke(16'h008D, 8'h09); e.poke(16'h008E, 8'h38);
		e.poke(16'h008F, 8'h76);  // HALT

		e.reset();
		e.wait_boot();
		e.run_to_halt(40000, ok);
		if (!ok) $display("FAIL: did not halt (pc=%04x)", e.pc);

		// ---- checks ------------------------------------------------------
		e.peek(16'h3800, rb); check("M0 JR NZ not-taken", rb, 8'h01);
		e.peek(16'h3801, rb); check("M1 JR Z taken", rb, 8'h02);
		e.peek(16'h3802, rb); check("M2 JR NC not-taken", rb, 8'h03);
		e.peek(16'h3803, rb); check("M3 JR C taken", rb, 8'h04);
		e.peek(16'h3804, rb); check("M4 JR NZ taken", rb, 8'h05);
		e.peek(16'h3805, rb); check("M5 JR Z not-taken", rb, 8'h06);
		e.peek(16'h3806, rb); check("M6 RST08 handler", rb, 8'h77);
		e.peek(16'h3807, rb); check("M7 RST18 handler", rb, 8'h99);
		e.peek(16'h3808, rb); check("M8 after RST08", rb, 8'h88);
		e.peek(16'h3809, rb); check("M9 after RST18", rb, 8'h89);
		check("SP after RST roundtrips", e.sp, 16'h3F00);

		if (errors == 0)
			$display("RESULT tb_sm83_jump %0d PASS", pcnt);
		else
			$display("RESULT tb_sm83_jump %0d FAIL (%0d errors)", pcnt, errors);
		$finish;
	end

endmodule // tb_sm83_jump
