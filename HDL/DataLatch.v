
module DataLatch ( CLK, DL_Control1, DL_Control2, DataBus, DL, Res );

	input CLK;
	input DL_Control1;
	input DL_Control2;
	inout [7:0] DataBus;
	inout [7:0] DL;
	input [7:0] Res;

endmodule // DataLatch
