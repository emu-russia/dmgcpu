`timescale 1ns/1ns

module DataLatch ( CLK, DL_Control1, DL_Control2, DataBus, DL, Res );

	input CLK;
	input DL_Control1;			// 1: Bus disable
	input DL_Control2;			// x37. ALU Result -> DL.
	inout [7:0] DataBus;		// External databus
	inout [7:0] DL;				// Internal databus
	input [7:0] Res;			// ALU Result

	module1 DL_Bits [7:0] (
		.clk({8{CLK}}), 
		.Test1({8{DL_Control1}}), 
		.Res_to_DL({8{DL_Control2}}), 
		.Res(Res), 
		.Int_bus(DL), 
		.Ext_bus(DataBus) );

endmodule // DataLatch

module module1 ( clk, Test1, Res_to_DL, Res, Int_bus, Ext_bus );
	
	input clk; 
	input Test1;
	input Res_to_DL;
	input Res;
	inout Int_bus; 	// DL[n] (internal databus)
	inout Ext_bus; 	// D[n] (external databus)

	wire int_to_ext_q;
	wire ext_to_int_q;

	BusKeeper int_to_ext ( .d(Int_bus), .q(int_to_ext_q) );
	BusKeeper ext_to_int ( .d(Ext_bus), .q(ext_to_int_q) );

	assign Ext_bus = ~(Test1 | ext_to_int_q) ? 1'b0 : ((Test1 | clk) ? 1'bz : 1'b1);
	assign Int_bus = clk ? (~((~(Test1 | ext_to_int_q)) | (~Res & Res_to_DL))) : ~(~Res & Res_to_DL);

endmodule // module1
