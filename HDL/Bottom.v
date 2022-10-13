
module Bottom ( CLK2, CLK3, CLK4, CLK5, CLK6, CLK7, DL, DV, bc, bq4, bq5, bq7, ALU_to_bot, ALU_L1, ALU_L2, ALU_L4, BTT, alu, Res, IR, d, w, x, 
	SYNC_RES, TTB1, TTB2, TTB3, Maybe1, Thingy_to_bot, bot_to_Thingy, SeqControl_1, SeqControl_2, SeqOut_1,
	A, CPU_IRQ_ACK, CPU_IRQ_TRIG );

	input CLK2;
	input CLK3;
	input CLK4;
	input CLK5;
	input CLK6;
	input CLK7; 

	inout [7:0] DL;
	output [7:0] DV;
	input [5:0] bc;
	output bq4;
	output bq5;
	output bq7;
	input ALU_to_bot;
	output ALU_L1;
	output ALU_L2;
	output ALU_L4;
	output BTT;
	output [7:0] alu;
	input [7:0] Res;

	output [7:0] IR;
	input [106:0] d;
	input [40:0] w;
	input [68:0] x;

	input SYNC_RES;
	input TTB1;
	input TTB2;
	input TTB3;
	input Maybe1;
	input Thingy_to_bot;
	output bot_to_Thingy;
	output SeqControl_1;
	output SeqControl_2;
	input SeqOut_1;

	output [15:0] A;
	output [7:0] CPU_IRQ_ACK;
	input [7:0] CPU_IRQ_TRIG;

	// Internal bottom buses

	wire [7:0] abus;
	wire [7:0] bbus;
	wire [7:0] cbus;
	wire [7:0] dbus;
	wire [7:0] ebus;
	wire [7:0] fbus;
	wire [7:0] gbus;
	wire [7:0] kbus;
	wire [7:0] xbus;
	wire [7:0] wbus;

endmodule // Bottom
