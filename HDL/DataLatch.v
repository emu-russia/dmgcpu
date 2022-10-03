
module DataLatch ( CLK, DL_Control1, DL_Control2, DataBus, DL, Res );

	input CLK;
	input DL_Control1;			// Most likely #CPU_CS. When #CPU_CS = 1 - the core is completely disconnected from the ASIC data bus
	input DL_Control2;			// x37. ALU Result -> DL.
	inout [7:0] DataBus;		// ASIC databus
	inout [7:0] DL;				// Current DataLatch value
	input [7:0] Res;			// ALU Result

	module1 DL_Bits [7:0] (
		.clk(CLK), 
		.a(DL_Control1), 
		.b(DL_Control2), 
		.c(Res), 
		.x(DL), 
		.Dat(DataBus) );

endmodule // DataLatch

module module1 ( clk, a, b, c, x, Dat );
	
	input clk; 
	input a; 
	input b; 
	input c; 
	inout x;
	inout Dat;

	reg x_val;
	reg Dat_val;

	initial x_val <= 1'b0;
	initial Dat_val <= 1'b0;

	assign Dat = ~(a | x_val) ? 1'b0 : (a | clk ? 1'bz : 1'b1);
	assign x = (clk ? ~(clk & ~(a | Dat_val)) : 1'b1) & ~(b & ~c);

	always @(*) begin
		x_val <= x;
		Dat_val <= Dat;
	end

endmodule // module1
