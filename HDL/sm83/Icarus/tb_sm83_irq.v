// tb_sm83_irq - SM83 interrupt dispatch regression (issue #400).
//
// Runs a program on the REAL SM83 core netlist (HDL/sm83, Top.v SM83Core)
// that exercises three successive interrupt dispatches by HALT-wake:
//
//   phase 1: IE = VBlank ($40); EI; HALT  -> test asserts IF bit0;
//            core wakes, pushes PC, clears IF, vectors to $40; the $40
//            handler stores 0x5A to $3A00 and RETIs back into the flow.
//   phase 2: IE = LCDSTAT ($48) ... IF bit1 -> $48 handler stores 0x6B.
//   phase 3: IE = Timer ($50)    ... IF bit2 -> $50 handler stores 0x7C.
//
// IE lives inside the core (IRQ_Logic, written through $FFFF); IF is the
// env model (source bit asserted by the test, cleared by CPU_IRQ_ACK) -
// the same split as the real SoC (IF in MMIO, IE in the core).
`timescale 1ns/1ns

module tb_sm83_irq;

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
		$dumpfile("tb_sm83_irq.vcd");
		$dumpvars(0, tb_sm83_irq);
		// ---- main flow (see header; all pokes fixed-address) -------------
		e.poke(16'h0000, 8'h31); e.poke(16'h0001, 8'h00); e.poke(16'h0002, 8'h3F); // LD SP,3F00
		// phase 1 setup: IE=VBlank
		e.poke(16'h0003, 8'h3E); e.poke(16'h0004, 8'h01);
		e.poke(16'h0005, 8'hEA); e.poke(16'h0006, 8'hFF); e.poke(16'h0007, 8'hFF); // LD (FFFF),A
		e.poke(16'h0008, 8'hFB);  // EI
		e.poke(16'h0009, 8'h00);  // NOP (IME latched after EI)
		e.poke(16'h000A, 8'h76);  // HALT
		// phase 2 setup: IE=LCDSTAT
		e.poke(16'h000B, 8'h3E); e.poke(16'h000C, 8'h02);
		e.poke(16'h000D, 8'hEA); e.poke(16'h000E, 8'hFF); e.poke(16'h000F, 8'hFF);
		e.poke(16'h0010, 8'hFB);  // EI
		e.poke(16'h0011, 8'h00);  // NOP
		e.poke(16'h0012, 8'h76);  // HALT
		// phase 3 setup: IE=Timer
		e.poke(16'h0013, 8'h3E); e.poke(16'h0014, 8'h04);
		e.poke(16'h0015, 8'hEA); e.poke(16'h0016, 8'hFF); e.poke(16'h0017, 8'hFF);
		e.poke(16'h0018, 8'hFB);  // EI
		e.poke(16'h0019, 8'h00);  // NOP
		e.poke(16'h001A, 8'h76);  // HALT
		// after phase 3 returns: IE=0 and stop
		e.poke(16'h001B, 8'h3E); e.poke(16'h001C, 8'h00);
		e.poke(16'h001D, 8'hEA); e.poke(16'h001E, 8'hFF); e.poke(16'h001F, 8'hFF);
		e.poke(16'h0020, 8'h76);  // HALT (end)

		// ---- handlers (RETI) ----------------------------------------------
		// $40 (VBlank): LD A,5A ; LD (3A00),A ; RETI
		e.poke(16'h0040, 8'h3E); e.poke(16'h0041, 8'h5A);
		e.poke(16'h0042, 8'hEA); e.poke(16'h0043, 8'h00); e.poke(16'h0044, 8'h3A);
		e.poke(16'h0045, 8'hD9);
		// $48 (LCDSTAT): LD A,6B ; LD (3A01),A ; RETI
		e.poke(16'h0048, 8'h3E); e.poke(16'h0049, 8'h6B);
		e.poke(16'h004A, 8'hEA); e.poke(16'h004B, 8'h01); e.poke(16'h004C, 8'h3A);
		e.poke(16'h004D, 8'hD9);
		// $50 (Timer): LD A,7C ; LD (3A02),A ; RETI
		e.poke(16'h0050, 8'h3E); e.poke(16'h0051, 8'h7C);
		e.poke(16'h0052, 8'hEA); e.poke(16'h0053, 8'h02); e.poke(16'h0054, 8'h3A);
		e.poke(16'h0055, 8'hD9);

		e.reset();
		e.wait_boot();

		// ---- phase 1: VBlank --------------------------------------------
		e.run_to_halt(20000, ok);          // CPU halts at $000A
		if (!ok) $display("FAIL: phase1 no HALT (pc=%04x)", e.pc);
		e.irq_set(8'h01);
		e.run_until_mem(16'h3A00, 8'h5A, 30000, ok);
		if (!ok) $display("FAIL: phase1 no dispatch (pc=%04x if=%02x)", e.pc, e.IF);
		e.peek(16'h3A00, rb); check("$40 handler stored 5A", rb, 8'h5A);
		check("IF bit0 cleared by ACK", e.IF, 8'h00);
		e.run_cycles(40);   // let the handler finish RETI (pop 2)
		check("SP restored after RETI", e.sp, 16'h3F00);

		// ---- phase 2: LCDSTAT -------------------------------------------
		e.run_to_halt(20000, ok);
		if (!ok) $display("FAIL: phase2 no HALT (pc=%04x)", e.pc);
		e.irq_set(8'h02);
		e.run_until_mem(16'h3A01, 8'h6B, 30000, ok);
		if (!ok) $display("FAIL: phase2 no dispatch (pc=%04x if=%02x)", e.pc, e.IF);
		e.peek(16'h3A01, rb); check("$48 handler stored 6B", rb, 8'h6B);
		check("IF bit1 cleared by ACK", e.IF, 8'h00);

		// ---- phase 3: Timer ---------------------------------------------
		e.run_to_halt(20000, ok);
		if (!ok) $display("FAIL: phase3 no HALT (pc=%04x)", e.pc);
		e.irq_set(8'h04);
		e.run_until_mem(16'h3A02, 8'h7C, 30000, ok);
		if (!ok) $display("FAIL: phase3 no dispatch (pc=%04x if=%02x)", e.pc, e.IF);
		e.peek(16'h3A02, rb); check("$50 handler stored 7C", rb, 8'h7C);
		check("IF bit2 cleared by ACK", e.IF, 8'h00);

		// end: program disabled IE and halted at $0020
		e.run_to_halt(20000, ok);
		check("PC at final HALT", e.pc, 16'h0021);

		if (errors == 0)
			$display("RESULT tb_sm83_irq %0d PASS", pcnt);
		else
			$display("RESULT tb_sm83_irq %0d FAIL (%0d errors)", pcnt, errors);
		$finish;
	end

endmodule // tb_sm83_irq
