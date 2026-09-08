// tb_sm83_alu - SM83 8-bit ALU + flag regression (issue #400).
//
// Runs a straight-line program on the REAL SM83 core netlist (HDL/sm83,
// Top.v SM83Core). For every (op, a, b, cin) case the emitted code is
//
//     [SCF | OR A]   ; ADC/SBC: set C = cin (SCF for 1, OR A clears for 0)
//     LD   A,a
//     <op> b         ; ADD/ADC/SUB/SBC/AND/OR/XOR/CP (immediate forms)
//     PUSH AF        ; captures result A and flags F in a per-case stack cell
//
// Then HALT. The testbench recomputes the SM83 Z/N/H/C flag law in
// software (F layout: bit7=Z bit6=N bit5=H bit4=C, low nibble 0) and
// compares A and F for every case. Cases: 8 operand pairs x 8 ops, ADC/SBC
// doubled for carry-in 0/1 => 80 cases, 160 checks.
`timescale 1ns/1ns

module tb_sm83_alu;

	sm83_env e ();

	integer errors = 0;
	integer pcnt = 0;

	task check(input [15:0] id, input [31:0] got, input [31:0] want);
		begin
			if (got !== want) begin
				$display("FAIL case %0d: got %02x want %02x", id, got, want);
				errors = errors + 1;
			end
			pcnt = pcnt + 1;
		end
	endtask

	reg [15:0] paddr;
	task p(input [7:0] b);
		begin e.poke(paddr, b); paddr = paddr + 1; end
	endtask

	// operand pairs (exercise carry / half-carry / zero edges)
	localparam NPAIR = 8;
	reg [7:0] ap [0:NPAIR-1];
	reg [7:0] bp [0:NPAIR-1];
	integer pa;
	reg [7:0] av, bv;

	// stack: PUSH AF with SP before push = X writes F at X-2, A at X-1.
	// We run one LD SP per case to keep cells independent and readable:
	// for case c, F lands at FCBASE-2*c-2, A at FCBASE-2*c-1.  Simplest:
	// point SP at the case cell top each time.
	localparam CELL_TOP = 16'h2FF0;   // case cells grow downward from here
	localparam NCELL = 160;           // 80 cases * 2 bytes

	reg ok;
	reg [7:0] gotA, gotF;
	reg [7:0] rA, rF;
	reg [8:0] wide;
	reg z, n, h, ccf;
	integer o, ci, c;
	reg [2:0] o3;
	reg [15:0] sp_case;

	// reference model for one op
	task ref_alu(input [2:0] oo, input [7:0] aa, input [7:0] bb, input cc,
	             output [7:0] oA, output [7:0] oF);
		reg [8:0] w;
		reg zz, nn, hh, cy;
		reg [7:0] res;
		begin
			case (oo)
				3'd0: begin res = aa + bb; zz=(res==0); nn=0;
					hh = ({1'b0,aa[3:0]} + {1'b0,bb[3:0]}) > 4'hF;
					w = {1'b0,aa}+{1'b0,bb}; cy = w[8]; end
				3'd1: begin res = aa + bb + cc; zz=(res==0); nn=0;
					hh = ({1'b0,aa[3:0]} + {1'b0,bb[3:0]} + cc) > 4'hF;
					w = {1'b0,aa}+{1'b0,bb}+cc; cy = w[8]; end
				3'd2: begin res = aa - bb; zz=(res==0); nn=1;
					hh = ({1'b0,aa[3:0]} < {1'b0,bb[3:0]});
					w = {1'b0,aa}-{1'b0,bb}; cy = w[8]; end
				3'd3: begin res = aa - bb - cc; zz=(res==0); nn=1;
					hh = ({1'b0,aa[3:0]} < ({1'b0,bb[3:0]} + cc));
					w = {1'b0,aa}-{1'b0,bb}-cc; cy = w[8]; end
				3'd4: begin res = aa & bb; zz=(res==0); nn=0; hh=1; cy=0; end
				3'd5: begin res = aa | bb; zz=(res==0); nn=0; hh=0; cy=0; end
				3'd6: begin res = aa ^ bb; zz=(res==0); nn=0; hh=0; cy=0; end
				default: begin // CP
					res = aa;
					zz = (aa==bb); nn=1;
					hh = ({1'b0,aa[3:0]} < {1'b0,bb[3:0]});
					cy = aa < bb;
				end
			endcase
			oA = res;
			oF = {zz, nn, hh, cy, 4'h0};
		end
	endtask

	initial begin
		$dumpfile("tb_sm83_alu.vcd");
		$dumpvars(0, tb_sm83_alu);
		ap[0]=8'h00; bp[0]=8'h00;
		ap[1]=8'h01; bp[1]=8'h01;
		ap[2]=8'h0F; bp[2]=8'h01;
		ap[3]=8'h10; bp[3]=8'h0F;
		ap[4]=8'hF0; bp[4]=8'h10;
		ap[5]=8'h7F; bp[5]=8'h01;
		ap[6]=8'h80; bp[6]=8'h80;
		ap[7]=8'hAB; bp[7]=8'hCD;

		// ---- emit the program ------------------------------------------
		paddr = 16'h0000;
		c = 0;
		for (pa = 0; pa < NPAIR; pa = pa + 1) begin
			for (o = 0; o < 8; o = o + 1) begin
				for (ci = 0; ci < ((o==1 || o==3) ? 2 : 1); ci = ci + 1) begin
					av = ap[pa]; bv = bp[pa];
					// each case: LD SP,cell ; [C setup] ; LD A,a ; op b ; PUSH AF
					sp_case = CELL_TOP - 2*c;
					p(8'h31); p(sp_case[7:0]); p(sp_case[15:8]);  // LD SP
					if (o==1 || o==3) begin
						if (ci) p(8'h37); else p(8'hB7);   // SCF / OR A
					end
					p(8'h3E); p(av);        // LD A,a
					o3 = o[2:0];
					case (o3)
						3'd0: p(8'hC6); 3'd1: p(8'hCE); 3'd2: p(8'hD6);
						3'd3: p(8'hDE); 3'd4: p(8'hE6); 3'd5: p(8'hF6);
						3'd6: p(8'hEE); default: p(8'hFE);
					endcase
					p(bv);                  // operand b
					p(8'hF5);               // PUSH AF
					c = c + 1;
				end
			end
		end
		p(8'h76);                           // HALT
		$display("program: %0d cases, %0d bytes", c, paddr);

		// ---- run ---------------------------------------------------------
		e.reset();
		e.wait_boot();
		e.run_to_halt(60000, ok);
		if (!ok) $display("FAIL: did not halt (pc=%04x)", e.pc);

		// ---- check -------------------------------------------------------
		c = 0;
		for (pa = 0; pa < NPAIR; pa = pa + 1) begin
			for (o = 0; o < 8; o = o + 1) begin
				for (ci = 0; ci < ((o==1 || o==3) ? 2 : 1); ci = ci + 1) begin
					av = ap[pa]; bv = bp[pa];
					ref_alu(o[2:0], av, bv, ci[0], rA, rF);
					e.peek(CELL_TOP - 2*c - 2, gotF);
					e.peek(CELL_TOP - 2*c - 1, gotA);
					check(2*c, gotA, rA);
					check(2*c+1, gotF, rF);
					c = c + 1;
				end
			end
		end

		if (errors == 0)
			$display("RESULT tb_sm83_alu %0d PASS", pcnt);
		else
			$display("RESULT tb_sm83_alu %0d FAIL (%0d errors)", pcnt, errors);
		$finish;
	end

endmodule // tb_sm83_alu
