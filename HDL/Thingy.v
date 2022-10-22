`timescale 1ns/1ns

module Thingy ( w, ALU_to_Thingy, WR, Temp_Z, TTB1, TTB2, TTB3, Thingy_to_bot, bot_to_Thingy );

	input [40:0] w;
	input ALU_to_Thingy;
	input WR;
	input Temp_Z;		// Flag Z from temp Z register (zbus[7])
	output TTB1;		// 1: Perform pairwise increment/decrement (simultaneously for two 8-bit IncDec halves)
	output TTB2;		// 1: Perform increment
	output TTB3;		// 1: Perform decrement
	input bot_to_Thingy;		// IE access detected (Address = 0xffff)
	output Thingy_to_bot;		// Load a value into the IE register from the DL bus.	

	wire t1;
	wire t2;

	assign t1 = ~(w[8] & ALU_to_Thingy & ~Temp_Z);
	assign t2 = ~(w[8] & ~ALU_to_Thingy & Temp_Z);
	assign TTB1 = ~(t1 & t2);
	assign TTB2 = ~(~w[35] & t2);
	assign TTB3 = ~(~w[31] & t1);
	assign Thingy_to_bot = bot_to_Thingy & WR;

endmodule // Thingy
