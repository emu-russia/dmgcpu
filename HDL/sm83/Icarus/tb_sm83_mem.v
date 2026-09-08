// tb_sm83_mem - SM83 memory-addressing regression (issue #400).
//
// Runs a program on the REAL SM83 core netlist (HDL/sm83, Top.v SM83Core)
// exercising the memory addressing modes and stores/loads:
//   LD (BC),A / LD (DE),A / LD (HL),A / LD (HL),n / LD A,(BC) / LD A,(DE) /
//   LD A,(HL) / LD A,(nn) / LD (nn),A / LDH (n8),A / LDH A,(n8) /
//   LD A,(HLI)/(HLD) + auto-increment/decrement of HL.
// Results are left in dedicated memory cells and checked after the program
// halts (HALT).
`timescale 1ns/1ns

module tb_sm83_mem;

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

	// helper: LD A,n
	task lda(input [7:0] v); begin p(8'h3E); p(v); end endtask

	// helper: LD HL,nn
	task ldhl(input [15:0] v); begin p(8'h21); p(v[7:0]); p(v[15:8]); end endtask

	// helper: LD (nn),A  (EA nn)
	task lda_nn(input [15:0] nn); begin p(8'hEA); p(nn[7:0]); p(nn[15:8]); end endtask

	// helper: LD A,(nn)  (FA nn)
	task ld_a_nn(input [15:0] nn); begin p(8'hFA); p(nn[7:0]); p(nn[15:8]); end endtask

	initial begin
		$dumpfile("tb_sm83_mem.vcd");
		$dumpvars(0, tb_sm83_mem);
		// source cells (data the program reads)
		e.poke(16'h3400, 8'hAA);   // S0
		e.poke(16'h3401, 8'hBB);   // S1
		e.poke(16'h3402, 8'hCC);   // S2
		e.poke(16'h3403, 8'hDD);   // S3
		// result cells the program writes to
		// R0 3500..3507 (byte results), RHL 3508/3509 (HL after auto inc/dec)
		// All cleared by poke above? env mem zero-inits.

		paddr = 16'h0000;
		// --- (BC),A / (DE),A / (HL),A -----------------------------------
		p(8'h01); p(8'h00); p(8'h35);   // LD BC,3500
		lda(8'h11); p(8'h02);           // LD (BC),A
		p(8'h11); p(8'h01); p(8'h35);   // LD DE,3501
		lda(8'h22); p(8'h12);           // LD (DE),A
		ldhl(16'h3502); lda(8'h33); p(8'h77);  // LD (HL),A
		ldhl(16'h3503); p(8'h36); p(8'h44);    // LD (HL),44
		// --- A,(BC)/(DE)/(HL) -------------------------------------------
		p(8'h01); p(8'h00); p(8'h34);   // LD BC,3400
		p(8'h0A); lda_nn(16'h3504);     // LD A,(BC) -> AA ; store
		p(8'h11); p(8'h01); p(8'h34);   // LD DE,3401
		p(8'h1A); lda_nn(16'h3505);     // LD A,(DE) -> BB
		ldhl(16'h3402); p(8'h7E); lda_nn(16'h3506); // LD A,(HL) -> CC
		// --- A,(nn) / (nn),A --------------------------------------------
		ld_a_nn(16'h3403); lda_nn(16'h3507);  // LD A,(3403) -> DD
		lda(8'h55); lda_nn(16'h3508);         // LD (3508),A
		// --- LDH (n8),A / LDH A,(n8) (n8 -> $FF00+n8) -------------------
		lda(8'h66); p(8'hE0); p(8'h80);       // LDH (FF80),A
		p(8'hF0); p(8'h80); lda_nn(16'h3509); // LDH A,(FF80) -> 66
		// --- HLI / HLD (auto-inc/dec) -----------------------------------
		ldhl(16'h3400); p(8'h2A); lda_nn(16'h350A); // LD A,(HLI): A=AA, HL->3401
		p(8'h7D); lda_nn(16'h350B);               // LD A,L -> 01 (HL low)
		ldhl(16'h3403); p(8'h3A); lda_nn(16'h350C); // LD A,(HLD): A=DD, HL->3402
		p(8'h7D); lda_nn(16'h350D);               // LD A,L -> 02
		// LD (HLI),A / LD (HLD),A
		ldhl(16'h3410); lda(8'hEE); p(8'h22);    // LD (HLI),A: mem[3410]=EE, HL->3411
		p(8'h7D); lda_nn(16'h350E);              // LD A,L -> 11
		ldhl(16'h3412); lda(8'hFF); p(8'h32);    // LD (HLD),A: mem[3412]=FF, HL->3411
		p(8'h7D); lda_nn(16'h350F);              // LD A,L -> 11

		p(8'h76);   // HALT

		e.reset();
		e.wait_boot();
		e.run_to_halt(40000, ok);
		if (!ok) $display("FAIL: program did not halt (pc=%04x)", e.pc);

		// --- checks ------------------------------------------------------
		e.peek(16'h3500, rb); check("LD (BC),A", rb, 8'h11);
		e.peek(16'h3501, rb); check("LD (DE),A", rb, 8'h22);
		e.peek(16'h3502, rb); check("LD (HL),A", rb, 8'h33);
		e.peek(16'h3503, rb); check("LD (HL),44", rb, 8'h44);
		e.peek(16'h3504, rb); check("LD A,(BC) S0", rb, 8'hAA);
		e.peek(16'h3505, rb); check("LD A,(DE) S1", rb, 8'hBB);
		e.peek(16'h3506, rb); check("LD A,(HL) S2", rb, 8'hCC);
		e.peek(16'h3507, rb); check("LD A,(3403)", rb, 8'hDD);
		e.peek(16'h3508, rb); check("LD (3508),A", rb, 8'h55);
		e.peek(16'h3509, rb); check("LDH A,(FF80)", rb, 8'h66);
		e.peek(16'h350A, rb); check("LD A,(HLI)", rb, 8'hAA);
		e.peek(16'h350B, rb); check("HL after HLI low", rb, 8'h01);
		e.peek(16'h350C, rb); check("LD A,(HLD)", rb, 8'hDD);
		e.peek(16'h350D, rb); check("HL after HLD low", rb, 8'h02);
		e.peek(16'h3410, rb); check("LD (HLI),A data", rb, 8'hEE);
		e.peek(16'h350E, rb); check("HL after (HLI),A low", rb, 8'h11);
		e.peek(16'h3412, rb); check("LD (HLD),A data", rb, 8'hFF);
		e.peek(16'h350F, rb); check("HL after (HLD),A low", rb, 8'h11);

		if (errors == 0)
			$display("RESULT tb_sm83_mem %0d PASS", pcnt);
		else
			$display("RESULT tb_sm83_mem %0d FAIL (%0d errors)", pcnt, errors);
		$finish;
	end

endmodule // tb_sm83_mem
