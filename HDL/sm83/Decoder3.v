`timescale 1ns/1ns

// Here we do not use GekkioNames on purpose, so that we can make cross checks without engagement.

module Decoder3( CLK2, CLK4, CLK5, nCLK4, a3, d, w, x, IR, nIR, SeqOut_2 );

	input CLK2;
	input CLK4;
	input CLK5;		// Affects x55
	input nCLK4;		// Affects x57
	
	input a3;
	input [106:0] d;
	input [40:0] w;
	output [68:0] x;
	input [7:0] IR;
	input [5:0] nIR;
	input SeqOut_2;

	// Automagically generated by MakeNandTree py
	// Hand-corrected in places
 
	assign x[0] = ~(CLK2 ? ~((nIR[3]&x[20]) | (nIR[3]&nIR[4]&x[17])) : 1'b1);
	assign x[1] = ~(CLK2 ? ~((IR[3]&x[20]) | (IR[3]&x[17])) : 1'b1);
	assign x[2] = ~(CLK2 ? ~((w[24]) | (IR[5]&IR[4]&nIR[3]&w[3])) : 1'b1);
	assign x[3] = ~(CLK2 ? ~((x[10]) | (w[37]) | (x[11]) | (w[8]) | (w[9]) | (x[22]) | (w[23])) : 1'b1);
	assign x[4] = ~(CLK2 ? ~((w[5]) | (d[8]) | (d[41]) | (x[2]) | (d[14]) | (x[26])) : 1'b1);
	assign x[5] = ~(CLK2 ? ~((x[20]&nIR[3]&nIR[4])) : 1'b1);
	assign x[6] = ~(CLK2 ? ~((x[20]&nIR[3]&IR[4])) : 1'b1);
	assign x[7] = ~(CLK2 ? ~((x[20]&IR[3]&nIR[4])) : 1'b1);
	assign x[8] = ~(CLK2 ? ~((x[20]&IR[3]&IR[4])) : 1'b1);
	assign x[9] = ~(CLK2 ? ~((x[17]&IR[3]&nIR[4])) : 1'b1);
	assign x[10] = ~(CLK2 ? ~((w[23]) | (w[15]) | (w[19]) | (x[23])) : 1'b1);
	assign x[11] = ~(CLK2 ? ~((x[27]) | (x[24])) : 1'b1);
	assign x[12] = ~(CLK2 ? ~((x[24]) | (x[27]) | (IR[0]&w[37])) : 1'b1);
	assign x[13] = ~(CLK2 ? ~((d[58]) | (d[88]) | (w[16])) : 1'b1);
	assign x[14] = ~(CLK2 ? ~((d[41]) | (d[14]) | (w[37])) : 1'b1);

	// CLK4 [!]
	assign x[15] = ~(CLK4 ? ~((w[6]&d[41]) | (w[6]&w[4]) | (w[6]&d[14]) | (w[6]&d[38]) | (w[6]&w[14]) | (w[6]&w[21])) : 1'b1);

	assign x[16] = ~(CLK2 ? ~((x[17]&nIR[3]&IR[4])) : 1'b1);
	assign x[17] = ~(CLK2 ? ~((d[42]&IR[5])) : 1'b1);
	assign x[18] = ~(CLK2 ? ~((w[3]&IR[3]&nIR[4]&IR[5])) : 1'b1);
	assign x[19] = ~(CLK2 ? ~((w[10]) | (nIR[3]&nIR[4]&IR[5]&w[3])) : 1'b1);
	assign x[20] = ~(CLK2 ? ~((d[25]) | (d[42]&nIR[5])) : 1'b1);
	assign x[21] = ~(CLK2 ? ~((d[34]&IR[4]&IR[5])) : 1'b1);
	assign x[22] = ~(CLK2 ? ~((d[34]&nIR[3]&nIR[4]&IR[5])) : 1'b1);
	assign x[23] = ~(CLK2 ? ~((w[3]&nIR[4]&nIR[5])) : 1'b1);
	assign x[24] = ~(CLK2 ? ~((w[3]&IR[4]&nIR[5])) : 1'b1);
	assign x[25] = ~(CLK2 ? ~((w[12]) | (x[24]) | (x[26]) | (x[27])) : 1'b1);
	assign x[26] = ~(CLK2 ? ~((d[34]&IR[3]&nIR[4]&IR[5])) : 1'b1);
	assign x[27] = ~(CLK2 ? ~((w[3]&IR[3]&IR[4]&IR[5])) : 1'b1);

	// CLK4 [!]
	assign x[28] = ~(CLK4 ? ~((d[34]&w[38]) | (d[42]&w[38]) | (w[3]&w[38]) | (IR[4]&IR[5]&d[58]&w[38]) | (x[10]&w[38])) : 1'b1);
	assign x[29] = ~(CLK4 ? ~((w[12]&w[38]) | (x[28]&w[38]) | (w[37]&w[38])) : 1'b1);

	assign x[30] = ~(CLK2 ? ~((w[9]&nIR[4])) : 1'b1);
	assign x[31] = ~(CLK2 ? ~((w[23]&nIR[4])) : 1'b1);
	assign x[32] = ~(CLK2 ? ~((d[34]&nIR[4]) | (d[34]&nIR[5])) : 1'b1);
	assign x[33] = ~(CLK2 ? ~((IR[0]&w[37])) : 1'b1);
	assign x[34] = ~(CLK2 ? ~((w[3]) | (d[41]) | (a3)) : 1'b1);
	assign x[35] = ~(CLK2 ? ~((x[34]&IR[0]&IR[1]&IR[2]) | (w[14]) | (w[4]) | (w[37]&IR[3]&IR[4]&IR[5]) | (d[38]&IR[4]&IR[5]) | (x[32])) : 1'b1);
	assign x[36] = ~(CLK2 ? ~((d[42]) | (w[10]) | (w[24])) : 1'b1);

	// CLK4 [!]
	assign x[37] = ~(CLK4 ? ~((w[8]) | (w[6]&d[42]) | (w[6]&w[10]) | (w[6]&w[37]) | (w[6]&w[24]) | (x[30]) | (x[31])) : 1'b1);
	assign x[38] = ~(CLK4 ? ~((x[32]&w[38]) | (x[36]&IR[0]&IR[1]&IR[2]&w[38]) | (w[38]&d[8]) | (w[38]&w[5]) | (w[38]&x[14]&IR[3]&IR[4]&IR[5]) | (w[38]&d[58]&IR[4]&IR[5]) | (w[38]&w[3]&nIR[5]) | (w[38]&w[3]&nIR[4]) | (w[38]&w[3]&nIR[3])) : 1'b1);
	assign x[39] = ~(CLK4 ? ~((IR[5]&w[13]&w[38]) | (x[36]&nIR[0]&nIR[1]&IR[2]&w[38]) | (w[38]&x[64]) | (w[38]&w[19]) | (w[38]&x[14]&nIR[3]&nIR[4]&IR[5]) | (w[38]&x[13]&nIR[4]&IR[5])) : 1'b1);
	assign x[40] = ~(CLK4 ? ~((IR[5]&w[13]&w[38]) | (x[36]&IR[0]&nIR[1]&IR[2]&w[38]) | (w[38]&x[66]) | (w[38]&w[15]) | (w[38]&x[14]&IR[3]&nIR[4]&IR[5]) | (w[38]&x[13]&nIR[4]&IR[5])) : 1'b1);

	assign x[41] = ~(CLK2 ? ~((d[83]&IR[0]&IR[4])) : 1'b1);
	assign x[42] = ~(CLK2 ? ~((w[13]&IR[5]) | (w[16]&nIR[4]&IR[5]) | (w[22])) : 1'b1);
	assign x[43] = ~(CLK2 ? ~((x[34]&nIR[0]&nIR[1]&IR[2]) | (IR[5]&nIR[4]&d[38]) | (IR[5]&nIR[4]&w[19]) | (IR[5]&nIR[4]&nIR[3]&w[37])) : 1'b1);
	assign x[44] = ~(CLK2 ? ~((x[34]&IR[0]&nIR[1]&IR[2]) | (IR[5]&nIR[4]&w[21]) | (IR[5]&nIR[4]&w[15]) | (IR[5]&nIR[4]&IR[3]&w[37])) : 1'b1);
	assign x[45] = ~(CLK2 ? ~((IR[4]&nIR[5]&w[16]) | (IR[4]&nIR[5]&w[13])) : 1'b1);
	assign x[46] = ~(CLK2 ? ~((x[34]&nIR[0]&IR[1]&nIR[2]) | (nIR[5]&IR[4]&d[38]) | (nIR[5]&IR[4]&w[19]) | (nIR[5]&IR[4]&nIR[3]&w[37])) : 1'b1);
	assign x[47] = ~(CLK2 ? ~((x[34]&IR[0]&IR[1]&nIR[2]) | (nIR[5]&IR[4]&w[21]) | (nIR[5]&IR[4]&w[15]) | (nIR[5]&IR[4]&IR[3]&w[37])) : 1'b1);
	
	// CLK4 [!]
	assign x[48] = ~(CLK4 ? ~((x[36]&nIR[0]&IR[1]&nIR[2]&w[38]) | (IR[4]&nIR[5]&x[13]&w[38]) | (IR[4]&nIR[5]&x[14]&nIR[3]&w[38])) : 1'b1);
	assign x[49] = ~(CLK4 ? ~((x[36]&nIR[0]&nIR[1]&nIR[2]&w[38]) | (nIR[4]&nIR[5]&x[13]&w[38]) | (nIR[4]&nIR[5]&x[14]&nIR[3]&w[38])) : 1'b1);
	assign x[50] = ~(CLK4 ? ~((x[36]&IR[0]&IR[1]&nIR[2]&w[38]) | (IR[4]&nIR[5]&x[13]&w[38]) | (IR[4]&nIR[5]&x[14]&IR[3]&w[38])) : 1'b1);
	assign x[51] = ~(CLK4 ? ~((x[36]&IR[0]&nIR[1]&nIR[2]&w[38]) | (nIR[4]&nIR[5]&x[13]&w[38]) | (nIR[4]&nIR[5]&x[14]&IR[3]&w[38])) : 1'b1);

	assign x[52] = ~(CLK2 ? ~((w[29]) | (nIR[4]&nIR[5]&w[13]) | (nIR[4]&nIR[5]&w[16])) : 1'b1);
	assign x[53] = ~(CLK2 ? ~((x[34]&nIR[0]&nIR[1]&nIR[2]) | (nIR[4]&nIR[5]&d[38]) | (nIR[4]&nIR[5]&w[19]) | (nIR[4]&nIR[5]&nIR[3]&w[37])) : 1'b1);
	assign x[54] = ~(CLK2 ? ~((x[34]&IR[0]&nIR[1]&nIR[2]) | (nIR[4]&nIR[5]&w[21]) | (nIR[4]&nIR[5]&w[15]) | (nIR[4]&nIR[5]&IR[3]&w[37])) : 1'b1);

	// CLK4 for x56, x55 affected by CLK5, x57 affected by nCLK4 [!]
	assign x[55] = ~( (CLK2 ? ~((w[13]) | (w[16])) : 1'b1) | CLK5 );
	assign x[56] = ~(CLK4 ? ~((d[58]) | (d[88])) : 1'b1);
	assign x[57] = ~( (CLK2 ? ~((d[42]) | (x[64]) | (x[66]) | (w[5]) | (d[8]) | (w[15]) | (w[19]) | (x[14]) | (w[10]) | (w[24]) | (x[32]) | (w[3])) : 1'b1) | nCLK4 );

	assign x[58] = ~(CLK2 ? ~((w[8]) | (nIR[3]&IR[4]&IR[5]&w[37]) | (w[23]) | (d[8]) | (w[5]) | (d[14]) | (x[34]&nIR[0]&IR[1]&IR[2])) : 1'b1);
	assign x[59] = ~(CLK2 ? ~((x[30]) | (d[60]) | (w[18]&SeqOut_2) | (w[8])) : 1'b1);
	assign x[60] = ~(CLK2 ? ~((w[8]) | (w[17]) | (w[39]&w[18]) | (d[60]) | (x[31])) : 1'b1);
	assign x[61] = ~(CLK2 ? ~((x[62]) | (x[63])) : 1'b1);
	assign x[62] = ~(CLK2 ? ~((w[16]&IR[4]&IR[5]) | (w[30]) | (d[62])) : 1'b1);
	assign x[63] = ~(CLK2 ? ~((d[88]&IR[4]&IR[5]) | (d[64])) : 1'b1);
	assign x[64] = ~(CLK2 ? ~((w[9]&IR[4])) : 1'b1);
	assign x[65] = ~(CLK2 ? ~((w[30]) | (w[16]&IR[4]&IR[5])) : 1'b1);
	assign x[66] = ~(CLK2 ? ~((w[23]&IR[4])) : 1'b1);
	assign x[67] = ~(CLK2 ? ~((d[81]) | (w[25]) | (w[2])) : 1'b1);
	assign x[68] = ~(CLK2 ? ~((d[93]) | (d[92]) | (w[36]) | (x[67])) : 1'b1);

endmodule // Decoder3