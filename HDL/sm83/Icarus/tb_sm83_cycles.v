// tb_sm83_cycles - SM83 instruction-timing (T-state) regression (issue #400).
//
// Runs a straight-line program on the REAL SM83 core netlist (HDL/sm83,
// Top.v SM83Core) and measures each executed instruction's duration: the
// oscillator-cycle (CLK) count between the M1 rising edges that bracket it
// (M1 = opcode-fetch pulse).  Expectations are the documented SM83 cycle
// counts.  This turns the real netlist into a timing oracle: measure any
// instruction's T-state count by bracketing it with M1 edges.
`timescale 1ns/1ns

module tb_sm83_cycles;

	sm83_env e ();

	integer errors = 0;
	integer pcnt = 0;

	task check(input [159:0] what, input [31:0] got, input [31:0] want);
		begin
			if (got !== want) begin
				$display("FAIL %0s: got %0d want %0d", what, got, want);
				errors = errors + 1;
			end
			pcnt = pcnt + 1;
		end
	endtask

	// ---- M1 interval recorder ------------------------------------------
	reg m1d = 1'b0;
	integer cnt = 0;
	integer edge_cnt = 0;
	integer inst_dur [0:63];
	reg ok;

	always @(posedge e.CLK) begin
		if (e.M1 && !m1d) begin
			if (cnt > 0)
				inst_dur[cnt-1] = edge_cnt;
			edge_cnt = 0;
			cnt = cnt + 1;
		end
		edge_cnt = edge_cnt + 1;
		m1d <= e.M1;
	end

	initial begin
		$dumpfile("tb_sm83_cycles.vcd");
		$dumpvars(0, tb_sm83_cycles);
		e.poke(16'h0000, 8'h00);
		e.poke(16'h0001, 8'h3E);
		e.poke(16'h0002, 8'h12);
		e.poke(16'h0003, 8'h47);
		e.poke(16'h0004, 8'h04);
		e.poke(16'h0005, 8'h05);
		e.poke(16'h0006, 8'hC6);
		e.poke(16'h0007, 8'h05);
		e.poke(16'h0008, 8'h01);
		e.poke(16'h0009, 8'h34);
		e.poke(16'h000A, 8'h12);
		e.poke(16'h000B, 8'h09);
		e.poke(16'h000C, 8'h21);
		e.poke(16'h000D, 8'h00);
		e.poke(16'h000E, 8'h20);
		e.poke(16'h000F, 8'h36);
		e.poke(16'h0010, 8'h34);
		e.poke(16'h0011, 8'h34);
		e.poke(16'h0012, 8'h35);
		e.poke(16'h0013, 8'h7E);
		e.poke(16'h0014, 8'h3E);
		e.poke(16'h0015, 8'h01);
		e.poke(16'h0016, 8'hB7);
		e.poke(16'h0017, 8'h20);
		e.poke(16'h0018, 8'h01);
		e.poke(16'h0019, 8'h00);
		e.poke(16'h001A, 8'h00);
		e.poke(16'h001B, 8'h28);
		e.poke(16'h001C, 8'h01);
		e.poke(16'h001D, 8'h00);
		e.poke(16'h001E, 8'hCD);
		e.poke(16'h001F, 8'h80);
		e.poke(16'h0020, 8'h00);
		e.poke(16'h0021, 8'h00);
		e.poke(16'h0022, 8'hC3);
		e.poke(16'h0023, 8'h00);
		e.poke(16'h0024, 8'h01);
		e.poke(16'h0080, 8'h00);
		e.poke(16'h0081, 8'hC9);
		e.poke(16'h0100, 8'h3E);
		e.poke(16'h0101, 8'h00);
		e.poke(16'h0102, 8'hB7);
		e.poke(16'h0103, 8'h28);
		e.poke(16'h0104, 8'h01);
		e.poke(16'h0105, 8'h00);
		e.poke(16'h0106, 8'h00);
		e.poke(16'h0107, 8'h3E);
		e.poke(16'h0108, 8'h01);
		e.poke(16'h0109, 8'hB7);
		e.poke(16'h010A, 8'h28);
		e.poke(16'h010B, 8'h01);
		e.poke(16'h010C, 8'h00);
		e.poke(16'h010D, 8'h76);

		e.reset();
		e.wait_boot();
		e.run_to_halt(40000, ok);
		if (!ok) $display("FAIL: did not halt (pc=%04x)", e.pc);

		begin : chk
			integer i;
			reg [7:0] exp [0:31];
			exp[0]=4;
			exp[1]=8;
			exp[2]=4;
			exp[3]=4;
			exp[4]=4;
			exp[5]=8;
			exp[6]=12;
			exp[7]=8;
			exp[8]=12;
			exp[9]=12;
			exp[10]=12;
			exp[11]=12;
			exp[12]=8;
			exp[13]=8;
			exp[14]=4;
			exp[15]=12;
			exp[16]=4;
			exp[17]=8;
			exp[18]=4;
			exp[19]=24;
			exp[20]=4;
			exp[21]=16;
			exp[22]=4;
			exp[23]=16;
			exp[24]=8;
			exp[25]=4;
			exp[26]=12;
			exp[27]=4;
			exp[28]=8;
			exp[29]=4;
			exp[30]=8;
			exp[31]=4;
			for (i = 0; i < 32; i = i + 1) begin
				if (i < cnt) begin
					if (inst_dur[i] !== exp[i]) begin
						$display("FAIL instr %0d (want %0d): got %0d", i, exp[i], inst_dur[i]);
						errors = errors + 1;
					end
				end else begin
					$display("FAIL instr %0d: no interval recorded", i);
					errors = errors + 1;
				end
				pcnt = pcnt + 1;
			end
		end

		if (errors == 0)
			$display("RESULT tb_sm83_cycles %0d PASS", pcnt);
		else
			$display("RESULT tb_sm83_cycles %0d FAIL (%0d errors)", pcnt, errors);
		$finish;
	end

	// executed flow reference:
		//  0: NOP = 4
		//  1: LD A,12 = 8
		//  2: LD B,A = 4
		//  3: INC B = 4
		//  4: DEC B = 4
		//  5: ADD A,5 = 8
		//  6: LD BC,1234 = 12
		//  7: ADD HL,BC = 8
		//  8: LD HL,2000 = 12
		//  9: LD (HL),34 = 12
		// 10: INC (HL) = 12
		// 11: DEC (HL) = 12
		// 12: LD A,(HL) = 8
		// 13: LD A,1 = 8
		// 14: OR A (Z=0) = 4
		// 15: JR NZ taken (skip 1) = 12
		// 16: NOP landed = 4
		// 17: JR Z not-taken = 8
		// 18: NOP = 4
		// 19: CALL 0080 = 24
		// 20: sub NOP = 4
		// 21: sub RET = 16
		// 22: NOP after CALL = 4
		// 23: JP 0100 = 16
		// 24: LD A,0 = 8
		// 25: OR A (Z=1) = 4
		// 26: JR Z taken (skip 1) = 12
		// 27: NOP landed = 4
		// 28: LD A,1 = 8
		// 29: OR A (Z=0) = 4
		// 30: JR Z not-taken = 8
		// 31: NOP = 4

endmodule // tb_sm83_cycles
