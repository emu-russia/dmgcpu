
module Thingy ( w, FromThingy, WR, TTB1, TTB2, TTB3, Thingy_to_bot, bot_to_Thingy );

	input [40:0] w;
	input FromThingy;			// From ALU actually.
	input WR;
	output TTB1;
	output TTB2;
	output TTB3;
	output Thingy_to_bot;
	input bot_to_Thingy;

endmodule // Thingy
