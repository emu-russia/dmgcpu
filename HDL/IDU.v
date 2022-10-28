// Separated from Bottom.v to make it easier to scroll through the source.

// The value on the cbus/dbus contains a ~val of register (register `q` output inversion).
// This value is stored on the BusKeeper. From the BusKeeper inverted value of ~val as `val` is fed to the IDU.
// At the output of the IDU the value is fed to the adl/adh buses as `val`.
// There is an inverter on the register input that loads ~val into the register.
// In the register the value is stored as ~val (inverse hold)

module IncDec ( CLK4, TTB1, TTB2, TTB3, Maybe1, cbus, dbus, adl, adh, AddrBus );

	input CLK4;
	input TTB1;				// 1: Perform pairwise increment/decrement (simultaneously for two 8-bit IncDec halves)
	input TTB2;				// 1: Perform decrement
	input TTB3;				// 1: Perform increment
	input Maybe1;
	inout [7:0] cbus;		// ~val_lo
	inout [7:0] dbus;		// ~val_hi
	inout [7:0] adl;		// res_lo
	inout [7:0] adh;		// res_hi
	output [15:0] AddrBus;

	wire [7:0] cbq; 	// cbus Bus keepers outputs
	wire [7:0] dbq; 	// dbus Bus keepers outputs

	wire [7:0] mq_lo;		// carry_out
	wire [7:0] mq_hi;
	wire [7:0] xa_lo;		// carry_in
	wire [7:0] xa_hi;

	// This requires transparent latches, since nobody could set up a cbus/dbus. On the actual circuit, they are also present as a memory on the `not` gate.
	BusKeeper cbus_keepers [7:0] ( .d(cbus), .q(cbq) );
	BusKeeper dbus_keepers [7:0] ( .d(dbus), .q(dbq) );

	cntbit cnt_lo [7:0] ( .val_in(~cbq), .cin(xa_lo), .val_out(adl), .cout(mq_lo), .TTB2({8{TTB2}}), .TTB3({8{TTB3}}) );
	cntbit cnt_hi [7:0] ( .val_in(~dbq), .cin(xa_hi), .val_out(adh), .cout(mq_hi), .TTB2({8{TTB2}}), .TTB3({8{TTB3}}) );
	cntbit_carry_chain carry_chain ( .CLK4(CLK4), .TTB1(TTB1), .TTB2(TTB2), .TTB3(TTB3), .mq({mq_hi,mq_lo}), .xa({xa_hi,xa_lo}) );

	// The AddrBus value is formed on the basis of the bus keeper values of the cbus/dbus.

	assign AddrBus = ~Maybe1 ? {~dbq,~cbq} : 16'bz;

endmodule // IncDec

module cntbit ( val_in, cin, val_out, cout, TTB2, TTB3 );

	input val_in;
	input cin;
	output val_out;
	output cout;
	input TTB2;
	input TTB3;

	assign val_out = val_in ^ cin;
	assign cout = ~val_in ? TTB2 : TTB3;

endmodule // cntbit

module cntbit_carry_chain ( CLK4, TTB1, TTB2, TTB3, mq, xa );

	input CLK4;
	input TTB1;
	input TTB2;
	input TTB3;
	input [15:0] mq;
	output [15:0] xa;

	wire [15:0] nxa;
	wire ct;

	assign nxa[0] = ~(TTB2 | TTB3);

	assign nxa[1] = CLK4 ? (~(mq[0])) : 1'b1;
	assign nxa[2] = CLK4 ? (~(mq[0] & mq[1])) : 1'b1;
	assign nxa[3] = CLK4 ? (~(mq[0] & mq[1] & mq[2])) : 1'b1;
	assign nxa[4] = CLK4 ? (~(mq[0] & mq[1] & mq[2] & mq[3])) : 1'b1;
	assign nxa[5] = CLK4 ? (~(mq[0] & mq[1] & mq[2] & mq[3] & mq[4])) : 1'b1;
	assign nxa[6] = CLK4 ? (~(mq[0] & mq[1] & mq[2] & mq[3] & mq[4] & mq[5])) : 1'b1;
	assign nxa[7] = CLK4 ? (~(mq[0] & mq[1] & mq[2] & mq[3] & mq[4] & mq[5] & mq[6])) : 1'b1;

	assign ct = (mq[7] & xa[7]) | TTB1;
	assign nxa[8] = CLK4 ? (~(ct)) : 1'b1;
	assign nxa[9] = CLK4 ? (~(ct & mq[8])) : 1'b1;
	assign nxa[10] = CLK4 ? (~(ct & mq[8] & mq[9])) : 1'b1;
	assign nxa[11] = CLK4 ? (~(ct & mq[8] & mq[9] & mq[10])) : 1'b1;
	assign nxa[12] = CLK4 ? (~(ct & mq[8] & mq[9] & mq[10] & mq[11])) : 1'b1;
	assign nxa[13] = CLK4 ? (~(ct & mq[8] & mq[9] & mq[10] & mq[11] & mq[12])) : 1'b1;
	assign nxa[14] = CLK4 ? (~(ct & mq[8] & mq[9] & mq[10] & mq[11] & mq[12] & mq[13])) : 1'b1;
	assign nxa[15] = CLK4 ? (~(ct & mq[8] & mq[9] & mq[10] & mq[11] & mq[12] & mq[13] & mq[14])) : 1'b1;

	assign xa = ~nxa;

endmodule // cntbit_carry_chain
