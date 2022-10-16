
module ALU ( CLK2, CLK4, CLK5, CLK6, CLK7, DV, Res, AllZeros, d42, d58, w, x, bc, alu, bq4, bq5, bq7, ALU_to_bot, ALU_to_Thingy,
	Temp_C, Temp_H, Temp_N, Temp_Z, ALU_Out1, IR, nIR );

	input CLK2;
	input CLK4;			// Used as LoadEnable for ALU_to_bot FF.
	input CLK5;
	input CLK6;
	input CLK7;

	input [7:0] DV; 		// ALU Operand2
	output [7:0] Res; 		// ALU Result
	input AllZeros;			// Res == 0
	input d42;
	input d58;
	input [40:0] w;		// Decoder2 outputs
	input [68:0] x;		// Decoder3 outputs
	inout [5:0] bc;
	input [7:0] alu;		// ALU Operand1
	input bq4;
	input bq5;
	input bq7;
	output ALU_to_bot;
	output ALU_to_Thingy; 		// Carry Out
	input Temp_C;		// Flag C from temp
	input Temp_H;		// Flag H from temp
	input Temp_N;		// Flag N from temp
	input Temp_Z;			// Flag Z from temp
	output ALU_Out1;
	input [7:0] IR;
	input [5:0] nIR;

	// Internal wires

	wire [7:0] e;		// module2 e in
	wire [7:0] f;		// module2 f out
	wire [7:0] ca; 		// comb1-3 out
	wire [7:0] bx;		// module2 x out
	wire [7:0] bm;		// module2 m out
	wire [7:0] bh;		// module2 h out
	wire [7:0] bw;		// module2 w out
	wire [7:0] ao; 		// G/P ands outputs to module6
	wire [7:0] na; 		// CLA nots outputs to module6
	wire [7:0] q; 		// CLA outputs (0-3: left, 4-7: right)
	wire [5:0] nbc; 	// #bc
	wire [13:0] azo;	// LargeComb1 results
	wire ALU_to_top; 		// Carry In
	wire ALU_L0;
	wire ALU_L3;
	wire ALU_L5;

	// Top part (CLA + Sum)

	module6 Sums [7:0] (
		.a({na[7:1],ALU_to_top}),
		.b(ao),
		.c({8{x[18]}}),
		.d({8{x[3]}}),
		.e(bw),
		.x(Res) );

	assign ALU_L0 = ~ALU_to_Thingy;
	assign ALU_L3 = ~na[4];
	assign ALU_L5 = na[4];
	assign {ALU_to_Thingy, na[7:1]} = ~q;
	assign ao = bh & bx; 		// ands

	module5 cla_low ( .m(bm[3:0]), .h(bh[3:0]), .c(ALU_to_top), .q(q[3:0]) );
	module5 cla_high ( .m(bm[7:4]), .h(bh[7:4]), .c(na[4]), .q(q[7:4]) );

	// Middle part

	module2 GP_Terms [7:0] (
		.a(ca), 
		.b({8{x[19]}}), 
		.c({8{x[4]}}), 
		.e(e), 
		.f(f), 
		.g({8{x[25]}}), 
		.h(bh), 
		.k(DV), 
		.m(bm), 
		.x(bx), 
		.w(bw) );

	Comb3 bit_lsb ( .clk(CLK2), .x(ca[0]), .a({x[5],DV[7]}), .b({x[1],DV[1]}), .c({x[16],DV[4]}), .d({x[6],bc[1]}) );
	Comb2 bits_mid [6:1] ( .clk(CLK2), .x(ca[6:1]), 
		.a({{x[0],DV[5]},{x[0],DV[4]},{x[0],DV[3]},{x[0],DV[2]},{x[0],DV[1]},{x[0],DV[0]}}), 
		.b({{x[1],DV[7]},{x[1],DV[6]},{x[1],DV[5]},{x[1],DV[4]},{x[1],DV[3]},{x[1],DV[2]}}), 
		.c({{x[16],DV[2]},{x[16],DV[1]},{x[16],DV[0]},{x[16],DV[7]},{x[16],DV[6]},{x[16],DV[5]}}) );
	Comb1 bit_msb ( .clk(CLK2), .x(ca[7]), .a({x[0],DV[6]}), .b({x[8],bc[1]}), .c({x[9],DV[7]}), .d({x[7],DV[0]}), .e({x[16],DV[3]}) );

	// Large spaghetti at the bottom

	LargeComb1 large_comb1 (
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

	// Part of the circuit below spaghetti (some FF and domino inverters)

	assign e = ~{azo[10],azo[9],azo[8],azo[6],azo[5],azo[4],azo[3],azo[0]};
	assign ALU_to_top = ~azo[13];
	assign ALU_Out1 = ~azo[11];

	bc bc5 ( .nd(azo[1]), .CLK(CLK6), .CCLK(CLK5), .Load(x[29]), .q(bc[5]), .nq(nbc[5]) );
	bc bc1 ( .nd(azo[2]), .CLK(CLK6), .CCLK(CLK5), .Load(x[28]), .q(bc[1]), .nq(nbc[1]) );
	bc bc2 ( .nd(azo[7]), .CLK(CLK6), .CCLK(CLK5), .Load(x[29]), .q(bc[2]), .nq(nbc[2]) );
	bc bc3 ( .nd(azo[12]), .CLK(CLK6), .CCLK(CLK5), .Load(x[29]), .q(bc[3]), .nq(nbc[3]) );
	ALU_to_bot_FF flag_z ( .d(Temp_Z), .CLK(CLK6), .CCLK(CLK5), .Load(CLK4), .q(ALU_to_bot) );

endmodule // ALU

// Carry lookahead generator
module module5 ( m, h, c, q );

	input [3:0] m; 		// G
	input [3:0] h;		// P
	input c;			// CarryIn
	output [3:0] q; 	// C1...C4  (inverted)

	assign q[0] = ~(m[0] | (h[0] & c)); 		// ~Carry1 out
	assign q[1] = ~(m[1] | (h[1] & q[0]));		// ~Carry2 out
	assign q[2] = ~(m[2] | (h[2] & q[1]));		// ~Carry3 out
	assign q[3] = ~(m[3] | (h[3] & q[2]));		// ~Carry4 out

endmodule // module5

// Sums block
module module6 ( a, b, c, d, e, x );

	input a;
	input b;
	input c;
	input d;
	input e;
	output x;

	assign x = ( (b & c) | ((a ^ b) & d) | (e) );

endmodule // module6

// G/P Terms Product
module module2 ( a, b, c, e, f, g, h, k, m, x, w );

	input a;
	input b;
	input c;
	input e;
	output f;
	input g;
	output h;
	input k;
	output m;
	output x;
	output w;

	assign f = g ^ k;
	assign h = e | f;
	assign x = ~(e & f);
	assign m = ~x;
	assign w = ~(a & (~(b&m)) & (~(c&h)));

endmodule // module2

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

module Comb2 ( clk, x, a, b, c );

	input clk;
	output x;
	input [1:0] a;
	input [1:0] b;
	input [1:0] c;

	assign x = clk ? ~((a[0]&a[1]) | (b[0]&b[1]) | (c[0]&c[1]) ) : 1'b1;

endmodule // Comb2

module Comb3 ( clk, x, a, b, c, d );

	input clk;
	output x;
	input [1:0] a;
	input [1:0] b;
	input [1:0] c;
	input [1:0] d;

	assign x = clk ? ~((a[0]&a[1]) | (b[0]&b[1]) | (c[0]&c[1]) | (d[0]&d[1]) ) : 1'b1;

endmodule // Comb3

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
	output [13:0] azo;

	wire [13:0] az;		// LargeComb1 results (non-dynamic)

	// Automagically generated by MakeNandTree py 
 
	assign az[0] = ~((alu[0]) | (w[24]&nIR[3]&nIR[4]&nIR[5]) | (w[10]&IR[5]) | (w[10]&IR[4]) | (w[10]&IR[3]));
	assign az[1] = ~((nIR[0]&w[37]&ALU_L5) | (x[10]&ALU_L5) | (ALU_L3&x[12]) | (w[12]) | (x[26]) | (x[19]) | (Temp_H&d58));
	assign az[2] = ~((f[0]&x[1]) | (Temp_C&d58) | (nbc[1]&IR[3]&x[21]) | (x[21]&nIR[3]) | (x[10]&ALU_to_Thingy) | (nbc[2]&ALU_to_Thingy&x[22]) | (bc[1]&x[22]) | (bc[1]&x[26]) | (x[0]&f[7]) | (ALU_L0&x[11]));
	assign az[3] = ~((alu[1]) | (w[24]&IR[3]&nIR[4]&nIR[5]) | (w[10]&IR[5]) | (w[10]&IR[4]) | (w[10]&nIR[3]) | (x[22]&bc[5]) | (x[22]&nbc[2]&bq4));
	assign az[4] = ~((alu[2]) | (x[22]&bq4&nbc[2]) | (x[22]&bc[5]&nbc[2]) | (w[24]&nIR[3]&IR[4]&nIR[5]) | (w[10]&IR[5]) | (w[10]&nIR[4]) | (w[10]&IR[3]));
	assign az[5] = ~((alu[3]) | (w[24]&IR[3]&IR[4]&nIR[5]) | (w[10]&nIR[3]) | (w[10]&nIR[4]) | (w[10]&IR[5]) | (x[22]&bc[5]&bc[2]));
	assign az[6] = ~((alu[4]) | (x[22]&bc[5]&bc[2]) | (w[24]&nIR[3]&nIR[4]&IR[5]) | (w[10]&IR[3]) | (w[10]&IR[4]) | (w[10]&nIR[5]));
	assign az[7] = ~((bc[2]&x[22]) | (x[12]) | (x[26]) | (d58&Temp_N));
	assign az[8] = ~((alu[5]) | (w[24]&IR[3]&nIR[4]&IR[5]) | (w[10]&nIR[3]) | (w[10]&IR[4]) | (w[10]&nIR[5]) | (x[22]&nbc[5]&bc[1]&bc[2]) | (x[22]&bc[5]&nbc[1]&bc[2]) | (x[22]&bq5&nbc[2]) | (x[22]&bc[1]&nbc[2]) | (x[22]&bq7&bq4&nbc[2]));
	assign az[9] = ~((alu[6]) | (w[24]&nIR[3]&IR[4]&IR[5]) | (w[10]&IR[3]) | (w[10]&nIR[4]) | (w[10]&nIR[5]) | (x[22]&bc[5]&nbc[1]&bc[2]) | (x[22]&bq7&bq4&nbc[2]) | (x[22]&bc[1]&nbc[2]) | (x[22]&bq5&nbc[2]));
	assign az[10] = ~((alu[7]) | (w[24]&IR[3]&IR[4]&IR[5]) | (w[10]&nIR[3]) | (w[10]&nIR[4]) | (w[10]&nIR[5]) | (x[22]&bc[5]&bc[2]) | (x[22]&bc[1]&bc[2]));
	assign az[11] = ~((w[0]&nIR[3]&IR[4]&bc[1]) | (w[0]&IR[3]&IR[4]&nbc[1]) | (w[0]&IR[3]&nIR[4]&nbc[3]) | (w[0]&nIR[3]&nIR[4]&bc[3]));
	assign az[12] = ~((f[0]&w[12]&nIR[3]&nIR[4]&nIR[5]) | (f[1]&w[12]&IR[3]&nIR[4]&nIR[5]) | (f[2]&w[12]&nIR[3]&IR[4]&nIR[5]) | (f[3]&w[12]&IR[3]&IR[4]&nIR[5]) | (f[4]&w[12]&nIR[3]&nIR[4]&IR[5]) | (f[5]&w[12]&IR[3]&nIR[4]&IR[5]) | (f[6]&w[12]&nIR[3]&IR[4]&IR[5]) | (f[7]&w[12]&IR[3]&IR[4]&IR[5]) | (d42&AllZeros) | (w[3]&AllZeros) | (w[37]&AllZeros) | (x[22]&AllZeros) | (Temp_Z&d58) | (bc[3]&w[19]) | (bc[3]&x[21]) | (bc[3]&w[15]) | (bc[3]&x[26]));
	assign az[13] = ~((w[37]&nIR[0]) | (x[27]) | (w[9]&bc[1]) | (nbc[1]&x[24]) | (nIR[3]&x[24]) | (bc[1]&w[19]) | (IR[3]&x[23]));

	// Dynamic part

	assign azo[0] = CLK2 ? az[0] : 1'b1;
	assign azo[1] = CLK7 ? 1'b1 : (CLK6 ? az[1] : 1'b1);		// -> bc5
	assign azo[2] = CLK7 ? 1'b1 : (CLK6 ? az[2] : 1'b1);		// -> bc1
	assign azo[3] = CLK2 ? az[3] : 1'b1;
	assign azo[4] = CLK2 ? az[4] : 1'b1;
	assign azo[5] = CLK2 ? az[5] : 1'b1;
	assign azo[6] = CLK2 ? az[6] : 1'b1;
	assign azo[7] = CLK7 ? 1'b1 : (CLK6 ? az[7] : 1'b1);		// -> bc2
	assign azo[8] = CLK2 ? az[7] : 1'b1;
	assign azo[9] = CLK2 ? az[8] : 1'b1;
	assign azo[10] = CLK2 ? az[10] : 1'b1;
	assign azo[11] = CLK7 ? 1'b1 : (CLK6 ? az[11] : 1'b1); 		// -> ALU_Out1
	assign azo[12] = CLK7 ? 1'b1 : (CLK6 ? az[12] : 1'b1);		// -> bc3
	assign azo[13] = CLK2 ? az[13] : 1'b1;		// -> ALU_to_top aka CarryIn

endmodule // LargeComb1

module bc ( nd, CLK, CCLK, Load, q, nq );

	input nd; 
	input CLK; 
	input CCLK; 
	input Load; 
	output q;
	output nq;

	reg reg_val;
	initial reg_val <= 1'b0;

	always @(*) begin
		if (Load && CLK)
			reg_val <= ~nd;
	end

	assign q = reg_val;
	assign nq = ~q;

endmodule // bc

module ALU_to_bot_FF ( d, CLK, CCLK, Load, q );

	input d; 
	input CLK; 
	input CCLK; 
	input Load; 
	output q;

	reg reg_val;
	initial reg_val <= 1'b0;

	always @(*) begin
		if (Load && CLK)
			reg_val <= d;
	end

	assign q = reg_val;

endmodule // ALU_to_bot_FF
