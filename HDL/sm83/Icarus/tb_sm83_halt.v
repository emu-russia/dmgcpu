// tb_sm83_halt - SM83 HALT-mode law regression (issue #400).
//
// Runs programs on the REAL SM83 core netlist (HDL/sm83, Top.v SM83Core)
// and verifies the HALT wake rules.  Each scenario uses its own env
// instance (warm restart after a halted core is not reliable, see
// STATUS.md):
//
//   A. IME=0, IE=0, no IF:  HALT stops the core (PC stable at HALT+1,
//      nothing further is executed).
//   B. IME=0, IE=VBlank, IF asserted *after* the HALT: the core wakes and
//      continues with the instruction after HALT; no interrupt vector is
//      dispatched because IME=0 blocks it.
//   C. IME=0, IE=VBlank, IF asserted *before* the HALT executes (the
//      classic "halt bug" setup): the core does not stop (runs past the
//      HALT), yet still never dispatches to the vector (IME=0).  Only the
//      no-vector part is asserted; the byte-steal detail is a measured
//      note in STATUS.md.
//
// The $40 handler stores 0x5A to $3A00 only when an interrupt is truly
// dispatched - proving IME=0 prevents the vector.
`timescale 1ns/1ns

module tb_sm83_halt;

	sm83_env eA ();
	sm83_env eB ();
	sm83_env eC ();

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
	reg [15:0] paddr;

	// program (in env e): LD SP,3F00 ; [IE=VBlank] ;
	//   LD A,77 ; LD (3B00),A ; HALT ; LD A,88 ; LD (3B01),A ; JR -2
	// ie_on=0 -> HALT at 0008 (pc stable 0009); ie_on=1 -> HALT at 000D.
	task prog_A();
		begin
			eA.poke(16'h0000, 8'h31); eA.poke(16'h0001, 8'h00); eA.poke(16'h0002, 8'h3F);
			eA.poke(16'h0003, 8'h3E); eA.poke(16'h0004, 8'h77);
			eA.poke(16'h0005, 8'hEA); eA.poke(16'h0006, 8'h00); eA.poke(16'h0007, 8'h3B);
			eA.poke(16'h0008, 8'h76);            // HALT
			eA.poke(16'h0009, 8'h3E); eA.poke(16'h000A, 8'h88);
			eA.poke(16'h000B, 8'hEA); eA.poke(16'h000C, 8'h01); eA.poke(16'h000D, 8'h3B);
			eA.poke(16'h000E, 8'h18); eA.poke(16'h000F, 8'hFE);
			// $40 handler (must not run)
			eA.poke(16'h0040, 8'h3E); eA.poke(16'h0041, 8'h5A);
			eA.poke(16'h0042, 8'hEA); eA.poke(16'h0043, 8'h00); eA.poke(16'h0044, 8'h3A);
			eA.poke(16'h0045, 8'h76);
		end
	endtask

	initial begin
		$dumpfile("tb_sm83_halt.vcd");
		$dumpvars(0, tb_sm83_halt);
		// ================= scenario A ====================================
		prog_A();
		eA.reset();
		eA.wait_boot();
		eA.run_to_halt(20000, ok);
		if (!ok) $display("FAIL: A did not halt (pc=%04x)", eA.pc);
		eA.peek(16'h3B00, rb); check("A: pre-HALT marker written", rb, 8'h77);
		eA.peek(16'h3B01, rb); check("A: post-HALT marker untouched", rb, 8'h00);
		eA.peek(16'h3A00, rb); check("A: no vector", rb, 8'h00);
		check("A: PC stable at HALT+1 (0009)", eA.pc, 16'h0009);

		// ================= scenario B ====================================
		// LD SP,3F00 ; LD A,01 ; LD (FFFF),A (IE=VBlank) ; LD A,77 ;
		// LD (3B00),A ; HALT(000D) ; LD A,88 ; LD (3B01),A ; JR -2
		eB.poke(16'h0000, 8'h31); eB.poke(16'h0001, 8'h00); eB.poke(16'h0002, 8'h3F);
		eB.poke(16'h0003, 8'h3E); eB.poke(16'h0004, 8'h01);
		eB.poke(16'h0005, 8'hEA); eB.poke(16'h0006, 8'hFF); eB.poke(16'h0007, 8'hFF);
		eB.poke(16'h0008, 8'h3E); eB.poke(16'h0009, 8'h77);
		eB.poke(16'h000A, 8'hEA); eB.poke(16'h000B, 8'h00); eB.poke(16'h000C, 8'h3B);
		eB.poke(16'h000D, 8'h76);            // HALT
		eB.poke(16'h000E, 8'h3E); eB.poke(16'h000F, 8'h88);
		eB.poke(16'h0010, 8'hEA); eB.poke(16'h0011, 8'h01); eB.poke(16'h0012, 8'h3B);
		eB.poke(16'h0013, 8'h18); eB.poke(16'h0014, 8'hFE);
		eB.poke(16'h0040, 8'h3E); eB.poke(16'h0041, 8'h5A);
		eB.poke(16'h0042, 8'hEA); eB.poke(16'h0043, 8'h00); eB.poke(16'h0044, 8'h3A);
		eB.poke(16'h0045, 8'h76);
		eB.reset();
		eB.wait_boot();
		eB.run_to_halt(20000, ok);
		if (!ok) $display("FAIL: B did not reach HALT (pc=%04x)", eB.pc);
		eB.peek(16'h3B00, rb); check("B: pre-HALT marker written", rb, 8'h77);
		eB.irq_set(8'h01);                       // IF after the HALT
		eB.run_until_mem(16'h3B01, 8'h88, 30000, ok);
		if (!ok) $display("FAIL: B did not wake (pc=%04x)", eB.pc);
		eB.peek(16'h3B01, rb); check("B: woke and ran instr after HALT", rb, 8'h88);
		eB.peek(16'h3A00, rb); check("B: no vector (IME=0)", rb, 8'h00);

		// ================= scenario C (halt bug) =========================
		eC.poke(16'h0000, 8'h31); eC.poke(16'h0001, 8'h00); eC.poke(16'h0002, 8'h3F);
		eC.poke(16'h0003, 8'h3E); eC.poke(16'h0004, 8'h01);
		eC.poke(16'h0005, 8'hEA); eC.poke(16'h0006, 8'hFF); eC.poke(16'h0007, 8'hFF);
		eC.poke(16'h0008, 8'h3E); eC.poke(16'h0009, 8'h77);
		eC.poke(16'h000A, 8'hEA); eC.poke(16'h000B, 8'h00); eC.poke(16'h000C, 8'h3B);
		eC.poke(16'h000D, 8'h76);            // HALT
		eC.poke(16'h000E, 8'h3E); eC.poke(16'h000F, 8'h88);
		eC.poke(16'h0010, 8'hEA); eC.poke(16'h0011, 8'h01); eC.poke(16'h0012, 8'h3B);
		eC.poke(16'h0013, 8'h18); eC.poke(16'h0014, 8'hFE);
		eC.poke(16'h0040, 8'h3E); eC.poke(16'h0041, 8'h5A);
		eC.poke(16'h0042, 8'hEA); eC.poke(16'h0043, 8'h00); eC.poke(16'h0044, 8'h3A);
		eC.poke(16'h0045, 8'h76);
		eC.reset();
		eC.wait_boot();
		eC.irq_set(8'h01);                  // IF pending BEFORE HALT executes
		eC.run_cycles(5000);
		eC.peek(16'h3B00, rb); check("C: ran before HALT region", rb, 8'h77);
		eC.peek(16'h3A00, rb); check("C: no vector (IME=0)", rb, 8'h00);
		// the halt bug: the core does not stop; PC ends up in the JR spin
		check("C: PC ran past HALT", eC.pc > 16'h000F ? 32'h1 : 32'h0, 32'h1);

		if (errors == 0)
			$display("RESULT tb_sm83_halt %0d PASS", pcnt);
		else
			$display("RESULT tb_sm83_halt %0d FAIL (%0d errors)", pcnt, errors);
		$finish;
	end

endmodule // tb_sm83_halt
