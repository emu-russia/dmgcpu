// tb_sm83_regs - SM83 register-file + immediate-load regression (issue #400).
//
// Runs a program on the REAL SM83 core netlist (HDL/sm83, Top.v SM83Core)
// and checks the observable final state: the register file (A B C D E H L),
// SP, the 16-bit pairs BC/DE/HL and a memory store, via hierarchical probes
// (dmgcore.bot.regs/pc/sp) + the env memory model. The program ends with
// HALT; the test waits until the core stops fetching (PC stable) and then
// compares every register.
`timescale 1ns/1ns

module tb_sm83_regs;

	sm83_env e ();

	integer errors = 0;
	integer pcnt = 0;

	task check(input [159:0] what, input [31:0] got, input [31:0] want);
		begin
			if (got !== want) begin
				$display("FAIL %0s: got %h want %h", what, got, want);
				errors = errors + 1;
			end else begin
				$display("PASS %0s: %h", what, got);
			end
			pcnt = pcnt + 1;
		end
	endtask

	// sequential program poke (code origin $0000)
	reg [15:0] paddr;
	task p(input [7:0] b);
		begin
			e.poke(paddr, b);
			paddr = paddr + 1;
		end
	endtask

	reg ok;
	reg [7:0] rb;

	initial begin
		$dumpfile("tb_sm83_regs.vcd");
		$dumpvars(0, tb_sm83_regs);
		// ---- program: 8-bit immediates, register moves, pair loads, SP ---
		paddr = 0;
		p(8'h3E); p(8'h12);   // LD A,12
		p(8'h06); p(8'h34);   // LD B,34
		p(8'h0E); p(8'h56);   // LD C,56
		p(8'h16); p(8'h78);   // LD D,78
		p(8'h1E); p(8'h9A);   // LD E,9A
		p(8'h26); p(8'hBC);   // LD H,BC
		p(8'h2E); p(8'hDE);   // LD L,DE
		p(8'h47);             // LD B,A     -> B = 12
		p(8'h4F);             // LD C,A     -> C = 12
		p(8'h3E); p(8'h99);   // LD A,99
		p(8'h57);             // LD D,A     -> D = 99
		p(8'h5F);             // LD E,A     -> E = 99
		p(8'h67);             // LD H,A     -> H = 99
		p(8'h6F);             // LD L,A     -> L = 99
		p(8'h01); p(8'h22); p(8'h11); // LD BC,1122
		p(8'h11); p(8'h44); p(8'h33); // LD DE,3344
		p(8'h21); p(8'h66); p(8'h55); // LD HL,5566
		p(8'h31); p(8'h00); p(8'h30); // LD SP,3000
		p(8'h3E); p(8'h7F);   // LD A,7F (final A)
		p(8'hEA); p(8'h00); p(8'h20); // LD (2000),A
		p(8'h76);             // HALT

		e.reset();
		e.wait_boot();
		e.run_to_halt(30000, ok);

		// ---- final state checks ------------------------------------------
		check("A (LD A,7F)",        e.regA, 8'h7F);
		check("B (moved from A12, then LD BC)", e.regB, 8'h11);
		check("C (LD BC,1122)",     e.regC, 8'h22);
		check("D (moved from A99, then LD DE)", e.regD, 8'h33);
		check("E (LD DE,3344)",     e.regE, 8'h44);
		check("H (moved from A99, then LD HL)", e.regH, 8'h55);
		check("L (LD HL,5566)",     e.regL, 8'h66);
		check("SP (LD SP,3000)",    e.sp,   16'h3000);
		check("BC pair",            e.bc,   16'h1122);
		check("DE pair",            e.de,   16'h3344);
		check("HL pair",            e.hl,   16'h5566);
		e.peek(16'h2000, rb);
		check("mem[2000] (LD (2000),A)", rb, 8'h7F);
		check("PC after HALT",      e.pc, 16'h0028);

		$display("halt ok=%0d pc=%04x", ok, e.pc);
		if (errors == 0)
			$display("RESULT tb_sm83_regs %0d PASS", pcnt);
		else
			$display("RESULT tb_sm83_regs %0d FAIL (%0d errors)", pcnt, errors);
		$finish;
	end

endmodule // tb_sm83_regs
