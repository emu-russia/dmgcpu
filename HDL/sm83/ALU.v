`timescale 1ns/1ns

module ALU ( CLK2, CLK4, CLK5, CLK6, CLK7, DV, Res, AllZeros, d42, d58, w, x, bc, alu, bq4, bq5, bq7, ALU_to_Thingy,
	Temp_C, Temp_H, Temp_N, Temp_Z, ALU_Out1, IR, nIR );

	input CLK2;
	input CLK4;			// Used as LoadEnable for ALU_to_bot latch.
	input CLK5;
	input CLK6;
	input CLK7;

	input [7:0] DV; 		// ALU Operand2
	output [7:0] Res; 		// ALU Result
	input AllZeros;			// Res == 0
	input d42; 			// Gekkio: s1_cb_00_to_3f
	input d58; 			// Gekkio: s1_op_pop_sx10
	input [40:0] w;		// Decoder2 outputs
	input [68:0] x;		// Decoder3 outputs
	output [5:0] bc;
	input [7:0] alu;		// ALU Operand1
	input bq4;
	input bq5;
	input bq7;
	output ALU_to_Thingy; 		// ALU Carry Out
	input Temp_C;		// Flag C from temp Z register  (zbus[4])
	input Temp_H;		// Flag H from temp Z register  (zbus[5])
	input Temp_N;		// Flag N from temp Z register    (zbus[6])
	input Temp_Z;			// Flag Z from temp Z register / zbus msb  (zbus[7])
	output ALU_Out1;
	input [7:0] IR;
	input [5:0] nIR;

	// Internal wires

	wire [7:0] e;		// Operand1 processing results for SET/RES opcodes; module2 e in
	wire [7:0] f;		// module2 f out; Optionaly complemented Operand2
	wire [7:0] ca; 		// Shifter (comb1-3) out  (active-low)
	wire [7:0] bx;		// module2 x out
	wire [7:0] bm;		// module2 m out (G-terms)
	wire [7:0] bh;		// module2 h out (P-terms)
	wire [7:0] logic_op;		// module2 w out; The result of the logical operation AND/OR/permutation of Operand2 bits.
	wire [7:0] ao; 		// G/P ands outputs to module6  (logic xor)
	wire [7:1] na; 		// CLA Carry outputs; CLA nots outputs to module6
	wire [7:0] q; 		// CLA carry complement outputs (bits 0-3: topologicaly left, bits 4-7: topologicaly right)
	wire [5:0] nbc; 	// #bc
	wire [13:0] azo;	// Random logic results
	wire ALU_to_top; 		// Carry In
	wire ALU_L0; 		// ~Carry7
	wire ALU_L3; 		// ~Carry4
	wire ALU_L5; 		// Carry4
	wire ALU_to_bot;		// Derived from zbus[7] .  As a result of the optimization and transposition of the `bc` derivation circuit, the signal became internal.

	// Top part (CLA + Sum)

	module6 Sums [7:0] (
		.a({na[7:1],ALU_to_top}),
		.b(ao),
		.c({8{`s3_alu_xor}}),
		.d({8{`s3_alu_sum}}),
		.e(logic_op),
		.x(Res) );

	assign ALU_L0 = ~ALU_to_Thingy;  		// ~cout
	assign ALU_L3 = ~na[4]; 			// ~half cout
	assign ALU_L5 = na[4]; 				// half cout
	assign {ALU_to_Thingy, na[7:1]} = ~q;
	assign ao = bh & bx; 		// ands

	module5 cla_low ( .m(bm[3:0]), .h(bh[3:0]), .c(ALU_to_top), .q(q[3:0]) );
	module5 cla_high ( .m(bm[7:4]), .h(bh[7:4]), .c(na[4]), .q(q[7:4]) );

	// Middle part

	module2 GP_Terms [7:0] (
		.a(ca), 
		.b({8{`s3_alu_logic_and}}), 
		.c({8{`s3_alu_logic_or}}), 
		.e(e), 
		.f(f), 
		.g({8{`s3_alu_b_complement}}), 
		.h(bh), 
		.k(DV), 
		.m(bm), 
		.x(bx), 
		.w(logic_op) );

	// Shifter

	Comb3 bit_lsb ( .clk(CLK2), .x(ca[0]), .a({`s3_alu_rlc,DV[7]}), .b({`s3_alu_rotate_shift_right,DV[1]}), .c({`s3_alu_swap,DV[4]}), .d({`s3_alu_rl,bc[1]}) );
	Comb2 bits_mid [6:1] ( .clk({6{CLK2}}), .x(ca[6:1]), 
		.a({{`s3_alu_rotate_shift_left,DV[5]},{`s3_alu_rotate_shift_left,DV[4]},{`s3_alu_rotate_shift_left,DV[3]},{`s3_alu_rotate_shift_left,DV[2]},{`s3_alu_rotate_shift_left,DV[1]},{`s3_alu_rotate_shift_left,DV[0]}}), 
		.b({{`s3_alu_rotate_shift_right,DV[7]},{`s3_alu_rotate_shift_right,DV[6]},{`s3_alu_rotate_shift_right,DV[5]},{`s3_alu_rotate_shift_right,DV[4]},{`s3_alu_rotate_shift_right,DV[3]},{`s3_alu_rotate_shift_right,DV[2]}}), 
		.c({{`s3_alu_swap,DV[2]},{`s3_alu_swap,DV[1]},{`s3_alu_swap,DV[0]},{`s3_alu_swap,DV[7]},{`s3_alu_swap,DV[6]},{`s3_alu_swap,DV[5]}}) );
	Comb1 bit_msb ( .clk(CLK2), .x(ca[7]), .a({`s3_alu_rotate_shift_left,DV[6]}), .b({`s3_alu_rr,bc[1]}), .c({`s3_alu_sra,DV[7]}), .d({`s3_alu_rrc,DV[0]}), .e({`s3_alu_swap,DV[3]}) );

	// Random logic (large spaghetti at the bottom)

	LargeComb1 rand_logic (
		.CLK2(CLK2),
		.CLK6(CLK6),
		.CLK7(CLK7),
		.Temp_Z(Temp_Z),
		.AllZeros(AllZeros),
		.d42(d42),
		.d58(d58),
		.w(w),
		.x(x),
		.alu(alu),
		.IR(IR),
		.nIR(nIR),
		.f(f),
		.bc(bc),
		.nbc(nbc),
		.ALU_to_Thingy(ALU_to_Thingy),
		.ALU_L0(ALU_L0),
		.Temp_H(Temp_H),
		.Temp_C(Temp_C),
		.ALU_L3(ALU_L3),
		.Temp_N(Temp_N),
		.ALU_L5(ALU_L5),
		.bq4(bq4),
		.bq5(bq5),
		.bq7(bq7),
		.azo(azo) );

	// Flags (part of the circuit below spaghetti, some FF and domino inverters)

	assign e = ~{azo[10],azo[9],azo[8],azo[6],azo[5],azo[4],azo[3],azo[0]};
	assign ALU_to_top = ~azo[13];
	assign ALU_Out1 = ~azo[11];

	bc bc5 ( .nd(azo[1]), .CLK(CLK6), .CCLK(CLK5), .Load(`s3_wren_hf_nf_zf), .q(bc[5]), .nq(nbc[5]) ); 			// Flag H
	bc bc1 ( .nd(azo[2]), .CLK(CLK6), .CCLK(CLK5), .Load(`s3_wren_cf), .q(bc[1]), .nq(nbc[1]) ); 			// Flag C
	bc bc2 ( .nd(azo[7]), .CLK(CLK6), .CCLK(CLK5), .Load(`s3_wren_hf_nf_zf), .q(bc[2]), .nq(nbc[2]) );  		// Flag N
	bc bc3 ( .nd(azo[12]), .CLK(CLK6), .CCLK(CLK5), .Load(`s3_wren_hf_nf_zf), .q(bc[3]), .nq(nbc[3]) ); 	// Flag Z
	ALU_to_bot_latch zbus_msb ( .d( Temp_Z /* =zbus[7] */ ), .CLK(CLK6), .CCLK(CLK5), .Load(CLK4), .q(ALU_to_bot) ); 			// zbus msb latch

	// Regarding "bc". I tend to think that even though bc0/bc4 is at the bottom, it is still part of the ALU.
	// Moved this circuit in my HDL inside the ALU instead of at the bottom. Then wire [5:0] bc; will become output.

	assign bc[0] = (IR[4] & IR[5] & `s2_op_push_sx10);
	assign bc[4] = ALU_to_bot & `s2_op_sp_e_sx10;
	assign nbc[0] = ~bc[0];
	assign nbc[4] = ~bc[4];

endmodule // ALU

// Carry lookahead generator
module module5 ( m, h, c, q );

	input [3:0] m; 		// G
	input [3:0] h;		// P
	input c;			// CarryIn
	/* verilator lint_off UNOPTFLAT */
	output [3:0] q; 	// C1...C4  (inverted)

	assign q[0] = ~(m[0] | (h[0] & c)); 		// ~Carry1 out
	assign q[1] = ~(m[1] | (h[1] & ~q[0]));		// ~Carry2 out
	assign q[2] = ~(m[2] | (h[2] & ~q[1]));		// ~Carry3 out
	assign q[3] = ~(m[3] | (h[3] & ~q[2]));		// ~Carry4 out

endmodule // module5

// Sums block
module module6 ( a, b, c, d, e, x );

	input a;
	input b;
	input c; 			// x18 (s3_alu_xor)
	input d; 			// x3 (s3_alu_sum)
	input e; 			// The result of the logical operation AND/OR/permutation of Operand2 bits.
	output x;

	assign x = ( (b & c) | ((a ^ b) & d) | (e) );

endmodule // module6

// G/P Terms Product.
// The module "hybridizes" the computation of G/P terms by reusing them for logical AND/OR operations. It also contains a Shifter result bypass.
module module2 ( a, b, c, e, f, g, h, k, m, x, w );

	input a; 		// Result of permutation(shift/rotate/swap) of Operand2 bits; [!] active low input
	input b;  			// x19 (s3_alu_logic_and)
	input c; 			// x4 (s3_alu_logic_or)
	input e; 		// Large Comb results; Result of executing SET/RES opcodes for operand1
	output f; 		// To Large Comb NAND trees; Operand2 optionally complemented
	input g; 		// x25 (s3_alu_b_complement)
	output h; 		// To CLA Generator (P-terms)
	input k; 		// Operand2: DV[n]
	output m; 		// To CLA Generator (G-terms)
	output x; 		// To ands near CLA
	output w; 		// To Sums; The result of the logical operation AND/OR/permutation of Operand2 bits.

	// Missing transparent DLatch that stores the result of the shifter (permutation result). This DLatch is critically needed, for example, when shifting DV to the left, in this case the following will happen (get ready, it's complicated):
	// The dynamic comb of shifter during CLK2 pre-charges the output to 1 - this will be the complement of the result of the shifter bit (i.e. - 0). At the same time, the s3_alu_rotate_shift_left command does not multiplex the output of the dynamic comb for lsb in any way;
	// Therefore, the output for lsb will be 0 (or rather the complementary value of 1 pre-charge, which is what is stored on the DLatch).
	wire shift_res_q;  		// <-- active low
	BusKeeper perm_ff (.d(a), .q(shift_res_q) );

	assign f = k ^ g;
	assign h = e | f;
	assign x = ~(e & f);
	assign m = ~x;
	assign w = ~(shift_res_q & (~(b&m)) & (~(c&h))); 		// or simply 3-OR, if you demorganize the operation.

endmodule // module2

// AOI-22222 dynamic (5 ANDs to OR Inverted)
module Comb1 ( clk, x, a, b, c, d, e );

	input clk;
	output x;
	input [1:0] a;
	input [1:0] b;
	input [1:0] c;
	input [1:0] d;
	input [1:0] e;

	assign x = clk ? ~((a[0]&a[1]) | (b[0]&b[1]) | (c[0]&c[1]) | (d[0]&d[1]) | (e[0]&e[1])) : 1'b1;

endmodule // Comb1

// AOI-222 dynamic (3 ANDs to OR Inverted)
module Comb2 ( clk, x, a, b, c );

	input clk;
	output x;
	input [1:0] a;
	input [1:0] b;
	input [1:0] c;

	assign x = clk ? ~((a[0]&a[1]) | (b[0]&b[1]) | (c[0]&c[1]) ) : 1'b1;

endmodule // Comb2

// AOI-2222 dynamic (4 ANDs to OR Inverted)
module Comb3 ( clk, x, a, b, c, d );

	input clk;
	output x;
	input [1:0] a;
	input [1:0] b;
	input [1:0] c;
	input [1:0] d;

	assign x = clk ? ~((a[0]&a[1]) | (b[0]&b[1]) | (c[0]&c[1]) | (d[0]&d[1]) ) : 1'b1;

endmodule // Comb3

// Random logic
module LargeComb1 ( CLK2, CLK6, CLK7, Temp_Z, AllZeros, d42, d58, w, x, alu, IR, nIR, f, bc, nbc, ALU_to_Thingy, ALU_L0, Temp_H, Temp_C, ALU_L3, Temp_N, ALU_L5, bq4, bq5, bq7, azo );

	input CLK2;
	input CLK6;
	input CLK7;
	input Temp_Z;
	input AllZeros;
	input d42;
	input d58;
	input [40:0] w;
	input [68:0] x;
	input [7:0] alu;
	input [7:0] IR;
	input [5:0] nIR;
	input [7:0] f;
	input [5:0] bc;
	input [5:0] nbc;
	input ALU_to_Thingy;
	input ALU_L0;
	input Temp_H;
	input Temp_C;
	input ALU_L3;
	input Temp_N;
	input ALU_L5;
	input bq4;
	input bq5;
	input bq7;
	output [13:0] azo; 		// "azo" means absolutely nothing, just the name of the random logic results

	wire [13:0] azo_latched; 		// Inputs to DLatch from dynamic logic
	wire [13:0] az;		// random logic results (non-dynamic)

	// ALU Trees (by hand); Tree numbering is topological (how they are arranged on the chip)
	// Random logic in SM83 is organized in such a way that all related calculations are performed in one place (topologically). On the one hand it is very convenient (the logic is isolated), on the other hand it turns out to be a very confusing doshirak.

	// ALU trees 0,3-6,8-10 are responsible for preprocessing operand 1 for SET/RES opcodes (CB table) as well as DAA (decimal correction)
	// Because of the topological numbering of the trees, they don't go in order, which is a bit ugly.
	// ALU tree 11 deals with code checking for conditional instructions (NZ/Z/NC/C)

	assign az[0] = ~( alu[0] | (`s2_alu_set&nIR[3]&nIR[4]&nIR[5]) | (`s2_alu_res&(IR[3]|IR[4]|IR[5])) );
	assign az[1] = ~( (ALU_L5&((nIR[0]&`s2_op_incdec8)|`s3_alu_sum_pos_hf_cf)) | (ALU_L3&`s3_alu_sum_neg_hf_nf) | `s3_alu_cpl | `s2_cb_bit | `s3_alu_logic_and | (Temp_H&d58) );
	assign az[2] = ~( (f[0]&`s3_alu_rotate_shift_right) | (Temp_C&d58) | (nbc[1]&IR[3]&`s3_alu_ccf_scf) | (`s3_alu_ccf_scf&nIR[3]) | (`s3_alu_sum_pos_hf_cf&ALU_to_Thingy) | (`s3_alu_daa&(bc[1]|(nbc[2]&ALU_to_Thingy))) | (bc[1]&`s3_alu_cpl) | (f[7]&`s3_alu_rotate_shift_left) | (ALU_L0&`s3_alu_sum_neg_cf) );
	assign az[3] = ~( alu[1] | (`s2_alu_set&IR[3]&nIR[4]&nIR[5]) | (`s2_alu_res&(nIR[3]|IR[4]|IR[5])) | (`s3_alu_daa&(bc[5]|(nbc[2]&bq4))) );
	assign az[4] = ~( alu[2] | (`s2_alu_set&nIR[3]&IR[4]&nIR[5]) | (`s2_alu_res&(IR[3]|nIR[4]|IR[5])) | (`s3_alu_daa&nbc[2]&(bq4|bc[5])) );
	assign az[5] = ~( alu[3] | (`s2_alu_set&IR[3]&IR[4]&nIR[5]) | (`s2_alu_res&(nIR[3]|nIR[4]|IR[5])) | (`s3_alu_daa&bc[2]&bc[5]) );
	assign az[6] = ~( alu[4] | (`s2_alu_set&nIR[3]&nIR[4]&IR[5]) | (`s2_alu_res&(IR[3]|IR[4]|nIR[5])) | (`s3_alu_daa&bc[2]&bc[5]) );
	assign az[7] = ~( (bc[2]&`s3_alu_daa) | `s3_alu_sum_neg_hf_nf | `s3_alu_cpl | (Temp_N&d58) );
	assign az[8] = ~( alu[5] | (`s2_alu_set&IR[3]&nIR[4]&IR[5]) | (`s2_alu_res&(nIR[3]|IR[4]|nIR[5])) | (bc[2]&`s3_alu_daa&((bc[1]&nbc[5])|(nbc[1]&bc[5]))) | (nbc[2]&`s3_alu_daa&((bq5)|(bc[1])|(bq4&bq7))) );
	assign az[9] = ~( alu[6] | (`s2_alu_set&nIR[3]&IR[4]&IR[5]) | (`s2_alu_res&(IR[3]|nIR[4]|nIR[5])) | (bc[2]&`s3_alu_daa&(nbc[1]&bc[5])) | (nbc[2]&`s3_alu_daa&((bq4&bq7)|(bc[1])|(bq5))) );
	assign az[10] = ~( alu[7] | (`s2_alu_set&IR[3]&IR[4]&IR[5]) | (`s2_alu_res&(nIR[3]|nIR[4]|nIR[5])) | (bc[2]&`s3_alu_daa&(bc[1]|bc[5])) );
	assign az[11] = ~( 
		`s2_cc_check & (              // inverted condition check
			(nIR[3]&nIR[4] & bc[3]) | // 00 | Z
			( IR[3]&nIR[4] &nbc[3]) | // 10 | NZ
			(nIR[3]& IR[4] & bc[1]) | // 01 | C
			( IR[3]& IR[4] &nbc[1])   // 11 | NC
		));
	assign az[12] = ~(
		(f[0]&`s2_cb_bit&nIR[3]&nIR[4]&nIR[5]) |
		(f[1]&`s2_cb_bit&IR[3]&nIR[4]&nIR[5]) |
		(f[2]&`s2_cb_bit&nIR[3]&IR[4]&nIR[5]) |
		(f[3]&`s2_cb_bit&IR[3]&IR[4]&nIR[5]) |
		(f[4]&`s2_cb_bit&nIR[3]&nIR[4]&IR[5]) |
		(f[5]&`s2_cb_bit&IR[3]&nIR[4]&IR[5]) |
		(f[6]&`s2_cb_bit&nIR[3]&IR[4]&IR[5]) |
		(f[7]&`s2_cb_bit&IR[3]&IR[4]&IR[5]) |
		(AllZeros&(d42|`s2_op_alu8|`s2_op_incdec8|`s3_alu_daa)) | (d58&Temp_Z) | (bc[3]&(`s3_alu_cpl|`s2_op_add_hl_sxx0|`s3_alu_ccf_scf|`s2_op_add_hl_sx01)) );
	assign az[13] = ~( `s3_alu_cp | (`s2_op_incdec8&nIR[0]) | (`s2_op_sp_e_sx10&bc[1]) | (`s3_alu_sub_sbc&(nIR[3]|nbc[1])) | (`s2_op_add_hl_sx01&bc[1]) | (`s3_alu_add_adc&IR[3]) );

	// Dynamic part

	assign azo_latched[0] = CLK2 ? az[0] : 1'bz;
	assign azo_latched[1] = CLK7 ? (CLK6 ? az[1] : 1'bz) : 1'bz;		// -> bc5   -- Flag H
	assign azo_latched[2] = CLK7 ? (CLK6 ? az[2] : 1'bz) : 1'bz;		// -> bc1   -- Flag C
	assign azo_latched[3] = CLK2 ? az[3] : 1'bz;
	assign azo_latched[4] = CLK2 ? az[4] : 1'bz;
	assign azo_latched[5] = CLK2 ? az[5] : 1'bz;
	assign azo_latched[6] = CLK2 ? az[6] : 1'bz;
	assign azo_latched[7] = CLK7 ? (CLK6 ? az[7] : 1'bz) : 1'bz;		// -> bc2   -- Flag N
	assign azo_latched[8] = CLK2 ? az[8] : 1'bz;
	assign azo_latched[9] = CLK2 ? az[9] : 1'bz;
	assign azo_latched[10] = CLK2 ? az[10] : 1'bz;
	assign azo_latched[11] = CLK7 ? (CLK6 ? az[11] : 1'bz) : 1'bz; 		// -> ALU_Out1  -- Skip branch
	assign azo_latched[12] = CLK7 ? (CLK6 ? az[12] : 1'bz) : 1'bz;		// -> bc3   -- Flag Z
	assign azo_latched[13] = CLK2 ? az[13] : 1'bz;		// -> ALU_to_top aka CarryIn

	// Transparent DLatch is required at least for asymmetric dynamic logic (which uses CLK7/CLK6, i.e. for flags and cc_check);
	// The others don't require DLatch, but are made for unification.
	// The use of asymmetric CLK is obviously related to the peculiarities of overlapped instruction execution in SM83  (CLK6 = writeback; CLK7 = writeback_ext)
	BusKeeper latched_results [13:0] ( .d(azo_latched), .q(azo) );

endmodule // LargeComb1

// This latch is used to hold flags (bc3=Z / bc2=N / bc5=H / bc1=C); The silly name `bc` is just from the early stages of research
module bc ( nd, CLK, CCLK, Load, q, nq );

	input nd; 
	input CLK; 
	input CCLK; 
	input Load; 
	output q;
	output nq;

	reg val_in;
	reg val_out;
	initial val_in = 1'b0;
	initial val_out = 1'b0;

	always @(*) begin
		if (CLK && Load)
			val_in = ~nd;
	end

	always @(negedge Load) begin
		val_out <= val_in;
	end

	assign q = val_out;
	assign nq = ~q;

endmodule // bc

// This latch exists in a single instance and is used to hold the zbus msb (ie - sign)
module ALU_to_bot_latch ( d, CLK, CCLK, Load, q );

	input d; 
	input CLK; 
	input CCLK; 
	input Load; 
	output q;

	reg val_in;
	reg val_out;
	initial val_in = 1'b0;
	initial val_out = 1'b0;

	always @(*) begin
		if (CLK && Load)
			val_in = d;
	end

	always @(negedge Load) begin
		val_out <= val_in;
	end

	assign q = val_out;

endmodule // ALU_to_bot_latch
