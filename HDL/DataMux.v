`timescale 1ns/1ns

module DataMux ( CLK, DL_Control1, DL_Control2, DataBus, DL, Res, DataOut, DV );

	input CLK; 				// CLK2
	input DL_Control1;			// 1: Bus disable  (External Test1 aka Maybe1)
	input DL_Control2;			// x37. ALU Result -> DL; Gekkio: s3_oe_alu_to_pbus
	inout [7:0] DataBus;		// External databus
	/* verilator lint_off UNOPTFLAT */
	inout [7:0] DL;				// Internal databus
	input [7:0] Res;			// ALU Result  (always driven)
	input DataOut;			// x15. DV -> DL; Gekkio: s3_oe_rbus_to_pbus
	input [7:0] DV;			// ALU Operand2	

	data_mux_bit dmux [7:0] (
		.clk({8{CLK}}), 
		.Test1({8{DL_Control1}}), 
		.Res_to_DL({8{DL_Control2}}), 
		.Res(Res), 
		.Int_bus(DL), 
		.Ext_bus(DataBus),
		.DataOut({8{DataOut}}),
		.dv_bit(DV) );

endmodule // DataMux

// A combined schematic that combines the schematics of the two bits of what used to be called DataLatch and DataBridge.
module data_mux_bit ( clk, Test1, Res_to_DL, Res, Int_bus, Ext_bus, DataOut, dv_bit );
	
	input clk;  		// CLK2; All buses are precharged when clk=0.
	input Test1; 			// External (1: disconnect core databus)
	input Res_to_DL; 		// ALU result -> internal databus  (from decoder3); Gekkio: s3_oe_alu_to_pbus
	input Res; 				// ALU result
	inout Int_bus; 		// DL[n] (internal databus)
	inout Ext_bus; 		// D[n] (external databus)
	input dv_bit;
	input DataOut;	 		// Gekkio: s3_oe_rbus_to_pbus

	wire int_to_ext_q; 		// transparent latch to keep DL bus
	wire ext_to_int_q; 		// transparent latch to keep external databus
	wire res_q;			// transparent latch to keep ALU result; is not required at all, because the bus Res is always output, but let it be
	wire dv_q; 			// transparent latch to keep DV bus

	BusKeeper int_to_ext ( .d(Int_bus), .q(int_to_ext_q) );
	BusKeeper ext_to_int ( .d(Ext_bus), .q(ext_to_int_q) );
	BusKeeper res_latch ( .d(Res), .q(res_q) );
	BusKeeper dv_latch ( .d(dv_bit), .q(dv_q) );

	// Although the actual schematic for outputting a value to the external bus looks like this:
	//assign Ext_bus = ~(Test1 | int_to_ext_q) ? 1'b0 : ((Test1 | clk) ? 1'bz : 1'b1);
	// We simplify it and do not use external data bus precharging during clk=0
	assign Ext_bus = (Test1 | clk) ? 1'bz : int_to_ext_q;

	assign Int_bus = ~( (~(Test1 | ext_to_int_q) & clk) | (~res_q & Res_to_DL) | (~dv_q & DataOut) );

endmodule // data_mux_bit
