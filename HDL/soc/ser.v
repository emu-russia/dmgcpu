module Ser (  d, n_sb_write, ser_out, serial_tick, n_sin, int_serial, n_sck, sck_dir, sc_write, n_reset2, lfo_16384Hz, sc_read, sb_read);

	inout wire [7:0] d;
	input wire n_sb_write;
	output wire ser_out;
	output wire serial_tick;
	input wire n_sin;
	output wire int_serial;
	input wire n_sck;
	output wire sck_dir;
	input wire sc_write;
	input wire n_reset2;
	input wire lfo_16384Hz;
	input wire sc_read;
	input wire sb_read;

	// Wires

	wire w1;
	wire w2;
	wire w3;
	wire w4;
	wire w5;
	wire w6;
	wire w7;
	wire w8;
	wire w9;
	wire w10;
	wire w11;
	wire w12;
	wire w13;
	wire w14;
	wire w15;
	wire w16;
	wire w17;
	wire w18;
	wire w19;
	wire w20;
	wire w21;
	wire w22;
	wire w23;
	wire w24;
	wire w25;
	wire w26;
	wire w27;
	wire w28;
	wire w29;
	wire w30;
	wire w31;
	wire w32;
	wire w33;
	wire w34;
	wire w35;
	wire w36;
	wire w37;
	wire w38;
	wire w39;
	wire w40;
	wire w41;
	wire w42;
	wire w43;
	wire w44;
	wire w45;

	assign d[0] = w35;
	assign d[1] = w34;
	assign d[2] = w33;
	assign d[3] = w32;
	assign d[4] = w31;
	assign d[5] = w30;
	assign d[6] = w4;
	assign d[7] = w29;
	assign w15 = n_sb_write;
	assign ser_out = w18;
	assign serial_tick = w17;
	assign w9 = n_sin;
	assign int_serial = w26;
	assign w39 = n_sck;
	assign sck_dir = w36;
	assign w22 = sc_write;
	assign w21 = n_reset2;
	assign w41 = lfo_16384Hz;
	assign w28 = sc_read;
	assign w27 = sb_read;

	// Instances

	ser_reg_bit g1 (.d(w14), .q(w1), .clk(w6), .oe(w27), .n_ie(w15), .nres(w21), .ie(w20), .db(w31) );
	ser_reg_bit g2 (.d(w2), .q(w3), .clk(w6), .oe(w27), .n_ie(w15), .nres(w21), .ie(w20), .db(w4) );
	ser_reg_bit g3 (.d(w3), .q(w4), .clk(w6), .oe(w27), .n_ie(w15), .nres(w21), .ie(w20), .db(w29) );
	ser_reg_bit g4 (.d(w1), .q(w2), .clk(w6), .oe(w27), .n_ie(w15), .nres(w21), .ie(w20), .db(w30) );
	ser_reg_bit g5 (.d(w13), .q(w14), .clk(w8), .oe(w27), .n_ie(w15), .nres(w21), .ie(w20), .db(w32) );
	ser_reg_bit g6 (.d(w12), .q(w13), .clk(w8), .oe(w27), .n_ie(w15), .nres(w21), .ie(w20), .db(w33) );
	ser_reg_bit g7 (.d(w11), .q(w12), .clk(w8), .oe(w27), .n_ie(w15), .nres(w21), .ie(w20), .db(w34) );
	ser_reg_bit g8 (.d(w10), .q(w11), .clk(w8), .oe(w27), .n_ie(w15), .nres(w21), .ie(w20), .db(w35) );
	dmg_not2 g9 (.a(w5), .x(w6) );
	dmg_not g10 (.a(w17), .x(w5) );
	dmg_not g11 (.a(w6), .x(w7) );
	dmg_not2 g12 (.a(w7), .x(w8) );
	dmg_not g13 (.a(w15), .x(w20) );
	dmg_not g14 (.a(w9), .x(w10) );
	dmg_not g15 (.a(w26), .x(w25) );
	dmg_and g16 (.a(w25), .b(w21), .x(w24) );
	dmg_and g17 (.a(w22), .b(w21), .x(w23) );
	dmg_or g18 (.a(w19), .b(w16), .x(w17) );
	dmg_notif1 g19 (.ena(w28), .a(w16), .x(w29) );
	dmg_notif1 g20 (.ena(w28), .a(w37), .x(w35) );
	dmg_dffr g21 (.clk(w5), .nr1(w21), .nr2(w21), .d(w4), .q(w18) );
	dmg_dffr g22 (.clk(w22), .nr1(w24), .nr2(w24), .d(w29), .nq(w16) );
	dmg_dffr g23 (.clk(w44), .nr1(w23), .nr2(w23), .d(w45), .q(w26), .nq(w45) );
	dmg_dffr g24 (.clk(w43), .nr1(w23), .nr2(w23), .d(w44), .nq(w44) );
	dmg_dffr g25 (.clk(w42), .nr1(w23), .nr2(w23), .d(w43), .nq(w43) );
	dmg_dffr g26 (.clk(w17), .nr1(w23), .nr2(w23), .d(w42), .nq(w42) );
	dmg_dffr g27 (.clk(w41), .nr1(w22), .nr2(w22), .d(w40), .q(w38), .nq(w40) );
	dmg_dffr g28 (.clk(w22), .nr1(w21), .nr2(w21), .d(w35), .q(w36), .nq(w37) );
	dmg_muxi g29 (.sel(w36), .d1(w38), .d0(w39), .q(w19) );
endmodule // Ser

module ser_reg_bit (  d, q, db, clk, ie, oe, n_ie, nres);

	input wire d;
	output wire q;
	inout wire db;
	input wire clk;
	input wire ie;
	input wire oe;
	input wire n_ie;
	input wire nres;

	// Wires

	wire w1;
	wire w2;
	wire w3;
	wire w4;
	wire w5;
	wire w6;
	wire w7;
	wire w8;
	wire w9;
	wire w10;
	wire w11;

	assign w11 = d;
	assign q = w9;
	assign db = w2;
	assign w4 = clk;
	assign w7 = ie;
	assign w3 = oe;
	assign w6 = n_ie;
	assign w10 = nres;

	// Instances

	dmg_dffsr g1 (.clk(w4), .nres(w8), .nset1(w1), .nset2(w1), .d(w11), .q(w9), .nq(w5) );
	dmg_notif1 g2 (.ena(w3), .a(w5), .x(w2) );
	dmg_oan g3 (.a0(w6), .a1(w2), .b(w10), .x(w8) );
	dmg_nand g4 (.a(w2), .b(w7), .x(w1) );
endmodule // ser_reg_bit