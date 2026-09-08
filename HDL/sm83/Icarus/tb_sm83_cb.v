// tb_sm83_cb - SM83 rotate/shift/bit-op law regression (issue #400).
//
// Runs a program on the REAL SM83 core netlist (HDL/sm83, Top.v SM83Core)
// that for every (op, a, c_in) case emits:
//
//     LD   SP,cell      ; per-case stack cell (F -> cell-2, A -> cell-1)
//     LD   A,a
//     OR   A            ; normalize: Z=(a==0), N=0, H=0, C=0
//     [SCF]             ; optional carry-in=1 (RLA/RRA/RL/RR)
//     <op>
//     PUSH AF           ; capture A-result + flags
//
// Reference law (SM83; F = ZNHC0000):
//   A-only RLCA/RLA/RRCA/RRA: Z=0 (SM83 quirk - these clears Z, measured on
//     the netlist), N=0, H=0, C=shifted-out bit (RLA/RRA shift the carry-in
//     into A).
//   CB RLC/RRC/RL/RR/SLA/SRA/SWAP/SRL A: Z=(result==0), N=0, H=0,
//     C=shifted-out bit (RL/RR consume carry-in; SWAP forces C=0).
//   CB BIT b,A: Z=~A[b], N=0, H=1, C unchanged.
//   CB RES/SET b,A: flags unchanged.
`timescale 1ns/1ns

module tb_sm83_cb;

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

	localparam CELL_TOP = 16'h2E00;
	integer c;
	reg [15:0] cellv;

	// LD SP,CELL_TOP-2*c  (push cell for current case index c)
	task ldsp_case();
		begin
			cellv = CELL_TOP - 2*c;
			p(8'h31); p(cellv[7:0]); p(cellv[15:8]);
		end
	endtask
	// peek the current case cells into gotF/gotA
	task peek_case(output [7:0] fa, output [7:0] aa);
		begin
			e.peek(CELL_TOP - 2*c - 2, fa);
			e.peek(CELL_TOP - 2*c - 1, aa);
		end
	endtask

	reg [7:0] operands [0:3];
	integer op, av, b;
	reg [7:0] a, gotA, gotF, rA, rF;
	reg ok;

	// reference model for rotate/shift ops
	task ref_rot(input [3:0] oo, input [7:0] aa, input cin, input zin,
	             output [7:0] oA, output [7:0] oF);
		reg [7:0] res;
		reg z, n, h, ccy;
		begin
			n = 0; h = 0; res = aa;
			case (oo)
				4'd0: begin res = {aa[6:0], aa[7]}; ccy = aa[7]; z = 1'b0; end
				4'd1: begin res = {aa[6:0], cin};  ccy = aa[7]; z = 1'b0; end
				4'd2: begin res = {aa[0], aa[7:1]}; ccy = aa[0]; z = 1'b0; end
				4'd3: begin res = {cin, aa[7:1]};   ccy = aa[0]; z = 1'b0; end
				4'd4: begin res = {aa[6:0], aa[7]}; ccy = aa[7]; z = (res==0); end
				4'd5: begin res = {aa[0], aa[7:1]}; ccy = aa[0]; z = (res==0); end
				4'd6: begin res = {aa[6:0], cin};   ccy = aa[7]; z = (res==0); end
				4'd7: begin res = {cin, aa[7:1]};   ccy = aa[0]; z = (res==0); end
				4'd8: begin res = {aa[6:0],1'b0};   ccy = aa[7]; z = (res==0); end
				4'd9: begin res = {aa[7], aa[7:1]}; ccy = aa[0]; z = (res==0); end
				4'd10: begin res = {aa[3:0], aa[7:4]}; ccy = 0; z = (res==0); end
				default: begin res = {1'b0, aa[7:1]}; ccy = aa[0]; z = (res==0); end
			endcase
			oA = res;
			oF = {z, n, h, ccy, 4'h0};
		end
	endtask

	// emit the op bytes for rotate/shift id op
	task emit_rot(input [3:0] oo);
		begin
			case (oo)
				4'd0: p(8'h07);
				4'd1: p(8'h17);
				4'd2: p(8'h0F);
				4'd3: p(8'h1F);
				4'd4: begin p(8'hCB); p(8'h07); end
				4'd5: begin p(8'hCB); p(8'h0F); end
				4'd6: begin p(8'hCB); p(8'h17); end
				4'd7: begin p(8'hCB); p(8'h1F); end
				4'd8: begin p(8'hCB); p(8'h27); end
				4'd9: begin p(8'hCB); p(8'h2F); end
				4'd10: begin p(8'hCB); p(8'h37); end
				default: begin p(8'hCB); p(8'h3F); end
			endcase
		end
	endtask

	initial begin
		$dumpfile("tb_sm83_cb.vcd");
		$dumpvars(0, tb_sm83_cb);
		operands[0] = 8'h00;
		operands[1] = 8'h01;
		operands[2] = 8'h81;
		operands[3] = 8'hFF;

		paddr = 0;
		c = 0;

		// ---- rotate/shift program --------------------------------------
		for (op = 0; op < 12; op = op + 1) begin
			for (av = 0; av < 4; av = av + 1) begin
				for (b = 0; b < 2; b = b + 1) begin   // carry-in 0/1
					a = operands[av];
					ldsp_case();
					p(8'h3E); p(a);
					p(8'hB7);                    // OR A
					if (b) p(8'h37);             // SCF
					emit_rot(op[3:0]);
					p(8'hF5);                    // PUSH AF
					c = c + 1;
				end
			end
		end
		// ---- BIT b,A (A=00 and A=80) ----------------------------------
		for (b = 0; b < 8; b = b + 1) begin
			for (av = 0; av < 2; av = av + 1) begin
				a = (av == 0) ? 8'h00 : 8'h80;
				ldsp_case();
				p(8'h3E); p(a);
				p(8'hB7);
				p(8'hCB); p(8'h40 + 8*b + 7);
				p(8'hF5);
				c = c + 1;
			end
		end
		// ---- RES b,A (A=80: bit cleared, Z stays 0) --------------------
		for (b = 0; b < 8; b = b + 1) begin
			ldsp_case();
			p(8'h3E); p(8'h80);
			p(8'hB7);
			p(8'hCB); p(8'h80 + 8*b + 7);
			p(8'hF5);
			c = c + 1;
		end
		// ---- SET b,A (A=00: bit set, Z stays 1) ------------------------
		for (b = 0; b < 8; b = b + 1) begin
			ldsp_case();
			p(8'h3E); p(8'h00);
			p(8'hB7);
			p(8'hCB); p(8'hC0 + 8*b + 7);
			p(8'hF5);
			c = c + 1;
		end
		p(8'h76);                               // HALT
		$display("tb_sm83_cb: %0d cases, %0d bytes", c, paddr);

		e.reset();
		e.wait_boot();
		e.run_to_halt(50000, ok);
		if (!ok) $display("note: halt timeout pc=%04x", e.pc);

		// ---- check rotate/shift ----------------------------------------
		c = 0;
		for (op = 0; op < 12; op = op + 1) begin
			for (av = 0; av < 4; av = av + 1) begin
				for (b = 0; b < 2; b = b + 1) begin
					a = operands[av];
					ref_rot(op[3:0], a, b[0], (a == 0), rA, rF);
					peek_case(gotF, gotA);
					check(2*c, gotA, rA);
					check(2*c+1, gotF, rF);
					c = c + 1;
				end
			end
		end
		// ---- check BIT --------------------------------------------------
		for (b = 0; b < 8; b = b + 1) begin
			for (av = 0; av < 2; av = av + 1) begin
				a = (av == 0) ? 8'h00 : 8'h80;
				peek_case(gotF, gotA);
				check(2*c, gotA, a);
				check(2*c+1, gotF, {~a[b], 1'b0, 1'b1, 1'b0, 4'h0});
				c = c + 1;
			end
		end
		// ---- check RES --------------------------------------------------
		for (b = 0; b < 8; b = b + 1) begin
			peek_case(gotF, gotA);
			check(2*c, gotA, 8'h80 & ~(8'h01 << b));
			check(2*c+1, gotF, 8'h00);
			c = c + 1;
		end
		// ---- check SET --------------------------------------------------
		for (b = 0; b < 8; b = b + 1) begin
			peek_case(gotF, gotA);
			check(2*c, gotA, 8'h01 << b);
			check(2*c+1, gotF, 8'h80);
			c = c + 1;
		end

		if (errors == 0)
			$display("RESULT tb_sm83_cb %0d PASS", pcnt);
		else
			$display("RESULT tb_sm83_cb %0d FAIL (%0d errors)", pcnt, errors);
		$finish;
	end

endmodule // tb_sm83_cb
