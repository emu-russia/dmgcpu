`timescale 1ns/1ns

module DataMux ( CLK, DL_Control1, DL_Control2, DataBus, DL, Res, DataOut, DV, RD_hack, WR_hack, bot_to_Thingy_hack);

	input CLK; 				// CLK2
	input DL_Control1;			// 1: Bus disable  (External Test1 aka BUS_DISABLE)
	input DL_Control2;			// x37. ALU Result -> DL; Gekkio: s3_oe_alu_to_pbus
	inout [7:0] DataBus;		// External databus
	/* verilator lint_off UNOPTFLAT */
	inout [7:0] DL;				// Internal databus
	input [7:0] Res;			// ALU Result  (always driven)
	input DataOut;			// x15. DV -> DL; Gekkio: s3_oe_rbus_to_pbus
	input [7:0] DV;			// ALU Operand2	

	// HACK: These signals are not present in the original circuit, but are
	// need when simulating it without resorting to driving strength.
	input RD_hack;
	input WR_hack;
	input bot_to_Thingy_hack;

	data_mux_bit dmux [7:0] (
		.clk({8{CLK}}), 
		.Test1({8{DL_Control1}}), 
		.Res_to_DL({8{DL_Control2}}), 
		.Res(Res), 
		.Int_bus(DL), 
		.Ext_bus(DataBus),
		.DataOut({8{DataOut}}),
		.dv_bit(DV),
		.RD_hack(RD_hack),
		.WR_hack(WR_hack),
		.bot_to_Thingy_hack(bot_to_Thingy_hack) );

endmodule // DataMux

// A combined schematic that combines the two bits of what used to be called DataLatch and DataBridge.
module data_mux_bit ( clk, Test1, Res_to_DL, Res, Int_bus, Ext_bus, DataOut, dv_bit, RD_hack, WR_hack, bot_to_Thingy_hack);
	
	input clk;  		// CLK2; All buses are precharged when clk=0.
	input Test1; 			// External (1: disconnect core databus)
	input Res_to_DL; 		// ALU result -> internal databus  (from decoder3); Gekkio: s3_oe_alu_to_pbus
	input Res; 				// ALU result
	inout Int_bus; 		// DL[n] (internal databus)
	inout Ext_bus; 		// D[n] (external databus)
	input dv_bit;
	input DataOut;	 		// Gekkio: s3_oe_rbus_to_pbus
	input RD_hack;
	input WR_hack;
	input bot_to_Thingy_hack;

	wire int_to_ext_q; 		// transparent latch to keep DL bus
	wire ext_to_int_q; 		// transparent latch to keep external databus
	wire res_q;			// transparent latch to keep ALU result; is not required at all, because the bus Res is always output, but let it be
	wire dv_q; 			// transparent latch to keep DV bus

	BusKeeper int_to_ext ( .d(Int_bus), .q(int_to_ext_q) );
	BusKeeper ext_to_int ( .d(Ext_bus), .q(ext_to_int_q) );
	BusKeeper res_latch ( .d(Res), .q(res_q) );
	BusKeeper dv_latch ( .d(dv_bit), .q(dv_q) );

	// ⚠️This implementation is an approximation of the real circuit, so it is
	// not a die-perfect approach.
	//
	// An analysis of the real circuit reveals that the buses may be driven by
	// multiple sources at the same time, causing conflicts. The mechanism
	// that resolves these conflicts in the real circuit is unclear, but
	// making all external buses have a stronger driving strength than
	// internal buses seems to work.
	// 
	// We also assume that the `clk` signal, which appears to pre-charge the
	// buses, has a stronger driving strength than the other signals
	// (otherwise there will also be internal conflicts).
	//
	// And to simulate the pre-charge effect, we have a weak pull-up on the
	// buses, that makes it resolve to 1 when no other signal is driving the
	// bus.

	// // DataLatch logic
	// assign Ext_bus = (clk || Test1) ? 1'bz : 1;
	// assign(pull0, pull1) Ext_bus = clk && ~(int_to_ext_q || Test1) ? 0 : 1'bz;
	//
	// assign Int_bus = clk ? 1'bz : 1;
	// assign(pull0, pull1) Int_bus = clk && ~(Test1 || ext_to_int_q) ? 0 : 1'bz;
	// assign(pull0, pull1) Int_bus = (Res_to_DL && ~Res) ? 0 : 1'bz;
	//
	// // DataBridge logic
	// assign(pull0, pull1) Int_bus = (~dv_q) ? (DataOut ? 0 : 1'bz) : 1'bz;
	//
	// // Drive DL and D buses up with weak strength to simulate the pre-charge.
	// assign (weak0, weak1) Ext_bus = 1;
	// assign (weak0, weak1) Int_bus = 1;

	// The logic above can also be expressed, in a higher level, as:

	assign Ext_bus = ~clk ? 1'b1
			: RD_hack && ~WR_hack ? 1'bz
			: ~RD_hack && WR_hack ? int_to_ext_q
			: 1'b1;

	// don't read from D if also reading from IE
	wire IntRD_hack = RD_hack && !bot_to_Thingy_hack;

	assign Int_bus = ~clk ? 1'b1
			: Res_to_DL ? res_q
			: IntRD_hack && ~WR_hack ? ext_to_int_q 
			: ~IntRD_hack && WR_hack && DataOut ? dv_q
			: ~IntRD_hack && WR_hack ? 1'bz
			: 1'b1;

endmodule // data_mux_bit
