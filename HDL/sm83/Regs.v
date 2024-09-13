`timescale 1ns/1ns

// Separated from Bottom.v to make it easier to scroll through the source.

// Important note: SHARP engineers did give slack and use inverse polarity in some places (buses a,b,c,d, inputs for Z/W/PC/SP registers).
// If you will be doing your own implementation of SM83 "inspired by", keep in mind that you do not have to repeat the inverse polarity for the above entities at all.
// Inverse polarity is used there just for convenience (e.g. bus precharging).

module RegsBuses ( CLK5, CLK6, w, x, DL, IR, abus, bbus, cbus, dbus, ebus, fbus, Aout );

	input CLK5;
	input CLK6;
	input [40:0] w;
	input [68:0] x;
	input [7:0] DL;
	output [7:0] IR;
	output [7:0] abus; 		// ⚠️ inverse hold (active low)
	output [7:0] bbus; 		// ⚠️ inverse hold (active low)
	output [7:0] cbus; 		// ⚠️ inverse hold (active low)
	output [7:0] dbus; 		// ⚠️ inverse hold (active low)
	input [7:0] ebus;
	input [7:0] fbus;
	output [7:0] Aout; 			// Reg A output for bq logic

	// Regs output

	wire [7:0] r1q;		// A
	wire [7:0] r2q;		// L
	wire [7:0] r3q;		// H
	wire [7:0] r4q;		// E
	wire [7:0] r5q;		// D
	wire [7:0] r6q;		// C
	wire [7:0] r7q;		// B

	regbit RegIR [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(DL), .ld({8{`s2_m1}}), .q(IR) );

	regbit RegA [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(fbus), .ld({8{`s3_wren_a}}), .q(r1q) );
	regbit RegL [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(ebus), .ld({8{`s3_wren_l}}), .q(r2q) );
	regbit RegH [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(fbus), .ld({8{`s3_wren_h}}), .q(r3q) );
	regbit RegE [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(ebus), .ld({8{`s3_wren_e}}), .q(r4q) );
	regbit RegD [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(fbus), .ld({8{`s3_wren_d}}), .q(r5q) );
	regbit RegC [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(ebus), .ld({8{`s3_wren_c}}), .q(r6q) );
	regbit RegB [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(fbus), .ld({8{`s3_wren_b}}), .q(r7q) );

	assign abus = `s2_op_alu8 ? ~r1q : 8'bzzzzzzzz;
	assign bbus = `s3_oe_areg_to_rbus ? ~r1q : 8'bzzzzzzzz;
	assign cbus = `s3_oe_hlreg_to_idu ? ~r2q : 8'bzzzzzzzz;
	assign abus = `s2_op_add_hl_sxx0 ? ~r2q : 8'bzzzzzzzz;
	assign bbus = `s3_oe_lreg_to_rbus ? ~r2q : 8'bzzzzzzzz;
	assign abus = `s2_op_add_hl_sx01 ? ~r3q : 8'bzzzzzzzz;
	assign bbus = `s3_oe_hreg_to_rbus ? ~r3q : 8'bzzzzzzzz;
	assign dbus = `s3_oe_hlreg_to_idu ? ~r3q : 8'bzzzzzzzz;
	assign cbus = `s3_oe_dereg_to_idu ? ~r4q : 8'bzzzzzzzz;
	assign bbus = `s3_oe_ereg_to_rbus ? ~r4q : 8'bzzzzzzzz;
	assign bbus = `s3_oe_dreg_to_rbus ? ~r5q : 8'bzzzzzzzz;
	assign dbus = `s3_oe_dereg_to_idu ? ~r5q : 8'bzzzzzzzz;
	assign dbus = `s2_op_ldh_c_sx00 ? 8'b00000000 : 8'bzzzzzzzz;
	assign dbus = `s2_op_ldh_imm_sx01 ? 8'b00000000 : 8'bzzzzzzzz;
	assign cbus = `s3_oe_bcreg_to_idu ? ~r6q : 8'bzzzzzzzz;
	assign bbus = `s3_oe_creg_to_rbus ? ~r6q : 8'bzzzzzzzz;
	assign bbus = `s3_oe_breg_to_rbus ? ~r7q : 8'bzzzzzzzz;
	assign dbus = `s3_oe_bcreg_to_idu ? ~r7q : 8'bzzzzzzzz;

	assign Aout = r1q;

endmodule // RegsBuses

module TempRegsBuses ( CLK4, CLK5, CLK6, d60, w, x, DL, bbus, cbus, dbus, ebus, fbus, zbus, wbus, Res, adl, adh );

	input CLK4;
	input CLK5;
	input CLK6;
	input d60; 				// Gekkio: s1_op_ld_nn_sp_s010
	input [40:0] w;
	input [68:0] x;
	input [7:0] DL;
	output [7:0] bbus;		// ⚠️ inverse hold (active low)
	output [7:0] cbus;		// ⚠️ inverse hold (active low)
	output [7:0] dbus; 		// ⚠️ inverse hold (active low)
	output [7:0] ebus;
	output [7:0] fbus;
	output [7:0] zbus;
	output [7:0] wbus;
	input [7:0] Res;
	input [7:0] adl;
	input [7:0] adh;

	wire [7:0] Z_in; 		// active low
	wire [7:0] W_in; 		// active low
	wire d60w8;

	// ⚠️ The Z/W registers have an input in inverse polarity, and the output in the regular
	regbit_nd Z [7:0]( .clk({8{CLK6}}), .cclk({8{CLK5}}), .nd(Z_in), .ld({8{`s3_wren_z}}), .q(zbus) );
	regbit_nd W [7:0]( .clk({8{CLK6}}), .cclk({8{CLK5}}), .nd(W_in), .ld({8{`s3_wren_w}}), .q(wbus) );

	assign cbus = `s2_op_ldh_imm_sx01 ? ~zbus : 8'bzzzzzzzz;
	assign cbus = `s2_oe_wzreg_to_idu ? ~zbus : 8'bzzzzzzzz;
	assign cbus = `s2_op_jr_any_sx10 ? ~zbus : 8'bzzzzzzzz;
	assign bbus = `s3_oe_zreg_to_rbus ? ~zbus : 8'bzzzzzzzz;
	assign dbus = `s2_op_jr_any_sx10 ? ~wbus : 8'bzzzzzzzz;
	assign dbus = `s2_oe_wzreg_to_idu ? ~wbus : 8'bzzzzzzzz;

	assign fbus = ~(CLK4 ? ~(({8{`s3_oe_idu_to_uhlbus}}&adh) | ({8{`s3_oe_wzreg_to_uhlbus}}&wbus) | ({8{`s3_oe_ubus_to_uhlbus}}&Res)) : 8'b11111111);
	assign ebus = ~(CLK4 ? ~(({8{`s3_oe_idu_to_uhlbus}}&adl) | ({8{`s3_oe_wzreg_to_uhlbus}}&zbus) | ({8{`s3_oe_ubus_to_uhlbus}}&Res)) : 8'b11111111);

	assign d60w8 = ~(d60 | `s2_op_jr_any_sx01);
	assign Z_in = ~(({8{d60}}&adl) | ({8{~d60}}&DL));
	assign W_in = ~(({8{~d60w8}}&adh) | ({8{d60w8}}&DL));

endmodule // TempRegsBuses

module SP ( CLK5, CLK6, CLK7, IR4, IR5, d60, d66, w, x, DL, abus, bbus, cbus, dbus, zbus, wbus, adl, adh );

	input CLK5;
	input CLK6;
	input CLK7;
	input IR4;
	input IR5;
	input d60;
	input d66;
	input [40:0] w;
	input [68:0] x;
	output [7:0] DL;			// Internal databus
	output [7:0] abus;
	output [7:0] bbus;
	output [7:0] cbus;
	output [7:0] dbus;
	input [7:0] zbus;
	input [7:0] wbus;
	input [7:0] adl;
	input [7:0] adh;

	wire [7:0] spl_nd;		// SPL input (inverse)
	wire [7:0] spl_q;		// SPL output
	wire [7:0] spl_nq;		// SPL output (complement)
	wire [7:0] sph_nd;		// SPH input (inverse)
	wire [7:0] sph_q;		// SPH output 
	wire [7:0] sph_nq;		// SPH output (complement)

	wire [7:0] spl_bnq;		// SPL input buskeeper output  (active low)
	wire [7:0] sph_bnq;		// SPH input buskeeper output  (active low)

	// For debugging purposes
	wire [15:0] SP;
	assign SP = {sph_q, spl_q};

	sp_regbit SPL [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .nd(spl_bnq), .ld({8{`s3_wren_sp}}), .q(spl_q), .nq(spl_nq) );
	sp_regbit SPH [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .nd(sph_bnq), .ld({8{`s3_wren_sp}}), .q(sph_q), .nq(sph_nq) );

	// Another bus keeper - which stores the input value for the SPL/SPH registers.
	// It is "recharged" during CLK7=0 and updated during CLK6=1. Between these two cutoffs - the input is in a floating state.
	BusKeeper SPL_KeepInput [7:0] ( .d(spl_nd), .q(spl_bnq) );
	BusKeeper SPH_KeepInput [7:0] ( .d(sph_nd), .q(sph_bnq) );

	// SP vs Buses

	assign spl_nd = CLK6 ? (~((adl & {8{`s3_oe_idu_to_spreg}}) | (zbus & {8{`s3_oe_wzreg_to_spreg}}))) : (CLK7 ? 8'bzzzzzzzz : 8'b11111111);
	assign sph_nd = CLK6 ? (~((adh & {8{`s3_oe_idu_to_spreg}}) | (wbus & {8{`s3_oe_wzreg_to_spreg}}))) : (CLK7 ? 8'bzzzzzzzz : 8'b11111111);

	assign DL = d60 ? ~spl_nq : 8'bzzzzzzzz;
	assign abus = `s2_op_sp_e_s001 ? ~spl_q : 8'bzzzzzzzz;
	assign bbus = (`s2_op_add_hl_sxx0 & IR4 & IR5) ? ~spl_q : 8'bzzzzzzzz;
	assign cbus = `s3_oe_spreg_to_idu ? ~spl_q : 8'bzzzzzzzz;

	assign DL = d66 ? ~sph_nq : 8'bzzzzzzzz;
	assign abus = `s2_op_sp_e_sx10 ? ~sph_q : 8'bzzzzzzzz;
	assign bbus = (`s2_op_add_hl_sx01 & IR4 & IR5) ? ~sph_q : 8'bzzzzzzzz;
	assign dbus = `s3_oe_spreg_to_idu ? ~sph_q : 8'bzzzzzzzz;

endmodule // SP

module PC ( CLK5, CLK6, CLK7, d92, w, x, DL, abus, cbus, dbus, zbus, wbus, adl, adh, IR, bro, SYNC_RES );

	input CLK5;
	input CLK6;
	input CLK7;
	input d92;
	input [40:0] w;
	input [68:0] x;	
	output [7:0] DL;			// Internal databus
	output [7:0] abus;
	output [7:0] cbus;
	output [7:0] dbus;
	input [7:0] zbus;
	input [7:0] wbus;
	input [7:0] adl;
	input [7:0] adh;
	input [7:0] IR;			// Current opcode
	input [7:3] bro;		// Interrupt address
	input SYNC_RES;

	wire [7:0] pcl_nd;		// PCL input (inverse)
	wire [7:0] pcl_q;		// PCL output
	wire [7:0] pcl_nq;		// PCL output (complement)
	wire [7:0] pch_nd;		// PCH input (inverse)
	wire [7:0] pch_q;		// PCH output
	wire [7:0] pch_nq;		// PCH output (complement)

	wire [7:0] pcl_bnq;		// PCL input buskeeper output  (active low)
	wire [7:0] pch_bnq;		// PCH input buskeeper output  (active low)

	// For debugging purposes
	wire [15:0] PC;
	assign PC = {pch_q, pcl_q};

	pc_regbit PCL [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .nres({8{~SYNC_RES}}), .nd(pcl_bnq), .ld({8{`s3_wren_pc}}), .q(pcl_q), .nq(pcl_nq) );
	pc_regbit PCH [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .nres({8{~SYNC_RES}}), .nd(pch_bnq), .ld({8{`s3_wren_pc}}), .q(pch_q), .nq(pch_nq) );

	// Another bus keeper - which stores the input value for the PCL/PCH registers.
	// It is "recharged" during CLK7=0 and updated during CLK6=1. Between these two cutoffs - the input is in a floating state.
	BusKeeper PCL_KeepInput [7:0] ( .d(pcl_nd), .q(pcl_bnq) );
	BusKeeper PCH_KeepInput [7:0] ( .d(pch_nd), .q(pch_bnq) );

	// PC vs Buses

	assign pcl_nd[2:0] = CLK6 ? (~((adl[2:0] & {3{`s3_oe_idu_to_pcreg}}) | (zbus[2:0] & {3{`s2_oe_wzreg_to_pcreg}}))) : (CLK7 ? 3'bzzz : 3'b111);
	assign pcl_nd[5:3] = CLK6 ? (~((adl[5:3] & {3{`s3_oe_idu_to_pcreg}}) | (zbus[5:3] & {3{`s2_oe_wzreg_to_pcreg}}) | ({3{d92}} & IR[5:3]) | bro[5:3])) : (CLK7 ? 3'bzzz : 3'b111);
	assign pcl_nd[7:6] = CLK6 ? (~((adl[7:6] & {2{`s3_oe_idu_to_pcreg}}) | (zbus[7:6] & {2{`s2_oe_wzreg_to_pcreg}}) | bro[7:6])) : (CLK7 ? 2'bzz : 2'b11);
	assign pch_nd = CLK6 ? (~((adh & {8{`s3_oe_idu_to_pcreg}}) | (wbus & {8{`s2_oe_wzreg_to_pcreg}}))) : (CLK7 ? 8'bzzzzzzzz : 8'b11111111);

	assign DL = `s2_oe_pclreg_to_pbus ? ~pcl_nq : 8'bzzzzzzzz;
	assign cbus = `s2_addr_pc ? ~pcl_q : 8'bzzzzzzzz;
	assign abus = `s2_op_jr_any_sx01 ? ~pcl_q : 8'bzzzzzzzz;
	assign abus = `s3_op_dec8 ? 8'b00000000 : 8'bzzzzzzzz;

	assign DL = `s2_oe_pchreg_to_pbus ? ~pch_nq : 8'bzzzzzzzz;
	assign dbus = `s2_addr_pc ? ~pch_q : 8'bzzzzzzzz;
	assign dbus = `s2_op_jr_any_sx01 ? ~pch_q : 8'bzzzzzzzz;

endmodule // PC

module regbit ( clk, cclk, d, ld, q );

	input clk;
	input cclk;
	input d;
	input ld;
	output q;

	// Latch with complementary set enable, complementary CLK.

	reg val_in;
	reg val_out;
	initial val_in = 1'b0;
	initial val_out = 1'b0;

	always @(*) begin
		if (clk && ld)
			val_in = d;
	end

	always @(negedge ld) begin
		val_out <= val_in;
	end

	assign q = val_out;

endmodule // regbit

// Used for Z/W registers
module regbit_nd ( clk, cclk, nd, ld, q );

	input clk;
	input cclk;
	input nd;
	input ld;
	output q;

	// Latch with complementary set enable, complementary CLK.
	// Inverse hold.

	reg val_in;
	reg val_out;
	initial val_in = 1'b1;
	initial val_out = 1'b1;

	always @(*) begin
		if (clk && ld)
			val_in = nd;
	end

	always @(negedge ld) begin
		val_out <= val_in;
	end

	assign q = ~val_out;

endmodule // regbit_nd

module sp_regbit ( clk, cclk, nd, ld, q, nq );

	input clk;
	input cclk;
	input nd;
	input ld;
	output q;
	output nq;

	// Latch with complementary set enable, complementary CLK.
	// Inverse hold.

	reg val_in;
	reg val_out;
	initial val_in = 1'b1;
	initial val_out = 1'b1;

	always @(*) begin
		if (clk && ld)
			val_in = nd;
	end

	always @(negedge ld) begin
		val_out <= val_in;
	end

	assign q = ~val_out;
	assign nq = ~q;

endmodule // sp_regbit

module pc_regbit ( clk, cclk, nd, ld, nres, q, nq );

	input clk;
	input cclk;
	input nd;
	input ld;
	input nres;
	output q;
	output nq;

	// Latch with complementary set enable, complementary CLK, active-low reset
	// Inverse hold.

	reg val_in;
	reg val_out;
	initial val_in = 1'b1;
	initial val_out = 1'b1;

	always @(*) begin
		if (clk && ld)
			val_in = nd;
		if (~nres)
			val_in = 1'b1;
	end

	always @(negedge ld) begin
		val_out <= val_in;
	end

	assign q = ~val_out;
	assign nq = ~q;

endmodule // pc_regbit
