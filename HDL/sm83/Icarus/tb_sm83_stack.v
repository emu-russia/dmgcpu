// tb_sm83_stack - SM83 16-bit + stack + control-flow regression (issue #400).
//
// Runs a program on the REAL SM83 core netlist (HDL/sm83, Top.v SM83Core)
// exercising 16-bit register moves, PUSH/POP rr (incl. the SP motion),
// 16-bit INC/DEC rr, ADD HL,rr, ADD SP,e, LD HL,SP+e, LD (nn),SP, and the
// CALL/RET / JP cc control flow.  Subroutines sit at fixed addresses
// (0x0150/0x0200), reached only through absolute CALL/JP targets.
// Verification = live register probes at HALT + result cells + PC.
`timescale 1ns/1ns

module tb_sm83_stack;

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

	reg [15:0] paddr;
	task p(input [7:0] b);
		begin e.poke(paddr, b); paddr = paddr + 1; end
	endtask

	reg ok;
	reg [7:0] rb;
	reg [15:0] halt_after;   // PC value when the CPU sits halted

	// helpers
	task lda(input [7:0] v);   begin p(8'h3E); p(v); end endtask
	task ld_bc(input [15:0] v);begin p(8'h01); p(v[7:0]); p(v[15:8]); end endtask
	task ld_de(input [15:0] v);begin p(8'h11); p(v[7:0]); p(v[15:8]); end endtask
	task ld_hl(input [15:0] v);begin p(8'h21); p(v[7:0]); p(v[15:8]); end endtask
	task ld_sp(input [15:0] v);begin p(8'h31); p(v[7:0]); p(v[15:8]); end endtask
	// LD (nn),SP
	task ld_nn_sp(input [15:0] nn); begin p(8'h08); p(nn[7:0]); p(nn[15:8]); end endtask
	// LD A,(nn)
	task ld_a_nn(input [15:0] nn); begin p(8'hFA); p(nn[7:0]); p(nn[15:8]); end endtask

	initial begin
		$dumpfile("tb_sm83_stack.vcd");
		$dumpvars(0, tb_sm83_stack);
		paddr = 16'h0000;

		// ---- main flow (stays below 0x0100) -----------------------------
		ld_sp(16'h3F00);
		ld_nn_sp(16'h3600);        // mem[3600..1] = SP (3F00)

		// 16-bit arithmetic
		ld_hl(16'h0010);
		ld_de(16'h0100);
		p(8'h19);                  // ADD HL,DE = 0110
		p(8'h23);                  // INC HL   = 0111
		p(8'h1B);                  // DEC DE   = 00FF
		ld_hl(16'h0111);
		p(8'h29);                  // ADD HL,HL = 0222
		ld_sp(16'h0100);
		p(8'h33);                  // INC SP
		p(8'h3B);                  // DEC SP
		p(8'hF8); p(8'h10);        // LD HL,SP+16 = 0110
		p(8'hE8); p(8'hFC);        // ADD SP,-4   (SP = 0100-4 = 00FC)
		ld_nn_sp(16'h3604);        // mem[3604..5] = SP (00FC)
		p(8'hF8); p(8'h00);        // LD HL,SP+0 = 00FC
		// save HL for later check
		ld_sp(16'h3F00);

		// conditional JP: Z=1 -> JP NZ not taken; falls through
		lda(8'h00); p(8'hB7);      // OR A -> Z=1
		p(8'hC2); p(8'h50); p(8'h01); // JP NZ,0150 (NOT taken)
		lda(8'h55); p(8'hEA); p(8'h00); p(8'h37); // LD (3700),A  marker A

		// conditional JP: Z=0 -> JP Z not taken
		lda(8'h01); p(8'hB7);      // OR A -> Z=0
		p(8'hCA); p(8'h50); p(8'h01); // JP Z,0150 (NOT taken)
		lda(8'h66); p(8'hEA); p(8'h01); p(8'h37); // LD (3701),A  marker B

		// CALL / RET
		p(8'hCD); p(8'h00); p(8'h02); // CALL 0200
		// after RET:
		lda(8'h88); p(8'hEA); p(8'h02); p(8'h37); // LD (3702),A  marker C

		// ---- PUSH/POP roundtrip at the very end (BC/DE/HL checks) ----
		ld_bc(16'h1234);
		ld_de(16'h5678);
		ld_hl(16'h9ABC);
		p(8'hC5);                  // PUSH BC
		p(8'hD5);                  // PUSH DE
		p(8'hE5);                  // PUSH HL
		p(8'hE1);                  // POP HL  -> 9ABC
		p(8'hD1);                  // POP DE  -> 5678
		p(8'hC1);                  // POP BC  -> 1234
		ld_nn_sp(16'h3602);        // mem[3602..3] = SP (3F00 back)
		halt_after = paddr + 1;
		p(8'h76);                  // HALT

		// ---- subroutine 0x0150 (wrong branch target) ---------------------
		e.poke(16'h0150, 8'h3E);       // LD A,EE
		e.poke(16'h0151, 8'hEE);
		e.poke(16'h0152, 8'hEA); e.poke(16'h0153, 8'h10); e.poke(16'h0154, 8'h37);
		e.poke(16'h0155, 8'h76);       // HALT

		// ---- subroutine 0x0200 (CALL target) ------------------------------
		e.poke(16'h0200, 8'h3E);       // LD A,77
		e.poke(16'h0201, 8'h77);
		e.poke(16'h0202, 8'hEA); e.poke(16'h0203, 8'h0A); e.poke(16'h0204, 8'h37);
		e.poke(16'h0205, 8'hC9);       // RET

		e.reset();
		e.wait_boot();
		e.run_to_halt(50000, ok);
		if (!ok) $display("FAIL: did not halt (pc=%04x)", e.pc);

		// ---- checks -------------------------------------------------------
		e.peek(16'h3600, rb); check("LD (3600),SP lo", rb, 8'h00);
		e.peek(16'h3601, rb); check("LD (3601),SP hi", rb, 8'h3F);
		e.peek(16'h3602, rb); check("SP lo after push/pop", rb, 8'h00);
		e.peek(16'h3603, rb); check("SP hi after push/pop", rb, 8'h3F);
		// 16-bit math results: ADD SP,-4 left SP=00FC (stored by LD (nn),SP)
		e.peek(16'h3604, rb); check("ADD SP,-4 lo", rb, 8'hFC);
		e.peek(16'h3605, rb); check("ADD SP,-4 hi", rb, 8'h00);
		// registers after the PUSH/POP roundtrip
		check("BC roundtrip", e.bc, 16'h1234);
		check("DE roundtrip", e.de, 16'h5678);
		// conditional-jump markers
		e.peek(16'h3700, rb); check("JP NZ not taken", rb, 8'h55);
		e.peek(16'h3701, rb); check("JP Z not taken", rb, 8'h66);
		e.peek(16'h3702, rb); check("CALL/RET returned", rb, 8'h88);
		e.peek(16'h370A, rb); check("sub 0200 wrote 77", rb, 8'h77);
		e.peek(16'h3710, rb); check("wrong-branch marker stays 00", rb, 8'h00);
		check("SP after CALL/RET + roundtrip", e.sp, 16'h3F00);
		check("PC at HALT", e.pc, halt_after);

		if (errors == 0)
			$display("RESULT tb_sm83_stack %0d PASS", pcnt);
		else
			$display("RESULT tb_sm83_stack %0d FAIL (%0d errors)", pcnt, errors);
		$finish;
	end

endmodule // tb_sm83_stack
