// hram_model
// Behavioral model of the DMG-CPU HRAM macro ($FF80-$FFFE, 128 x 8), used
// in the small-domain suite (issue #396) instead of the real macro
// netlist: the storage cells of HDL/soc/hram.v (sram_array /
// sram_row_decode in HDL/soc/sram.v) are still "TBD" stubs, so the real
// netlist cannot store data. Same approach as oam_ram.v for the OAM
// macro.
//
// The model mirrors the *interface* of the real netlist:
//   - enabled when ffxx & a[7] & (a[6:0] != 0x7F): the real decode
//     (HRAM.g33/g32 chain: w12 = ffxx & a7 & ~(a6..a0 == 1111111))
//     selects $FF80-$FFFE and excludes $FFFF (the IE register).
//   - write: captures the d bus at the end of the write strobe window
//     (soc_wr falling edge, like the MMIO register decode clocks) while
//     selected; the testbench CPU model keeps the data valid ~6 ns past
//     that edge (inside the clk2=1 non-precharge phase).
//   - read: drives d while soc_rd is high and the decode is selected
//     (sampled by the testbench outside the clk2=0 precharge phase).
//   - clk7 is accepted for interface parity (the real macro uses it for
//     the bit-line precharge/word-line phases that a plain storage model
//     does not need to reproduce for register roundtrips).
//
// Address mapping: byte index = a[6:0] (0 = $FF80 ... 126 = $FFFE).
`timescale 1ns/1ns

module HRAM (  clk7, soc_rd, soc_wr, d, ffxx, a);

	input wire clk7;
	input wire soc_rd;
	input wire soc_wr;
	inout wire [7:0] d;
	input wire ffxx;
	input wire [7:0] a;

	reg [7:0] mem [0:127];
	integer i;

	initial begin
		for (i = 0; i < 128; i = i + 1)
			mem[i] = 8'h00;
	end

	wire sel = ffxx && a[7] && (a[6:0] !== 7'h7F);   // $FF80-$FFFE

	// capture at the end of the write window (soc_wr falls) - same point
	// as the MMIO register decode clocks capture; the testbench CPU model
	// holds the data ~6 ns past that edge and it is inside the clk2=1
	// (non-precharge) phase
	always @(negedge soc_wr)
		if (sel)
			mem[a[6:0]] <= d;

	assign d = (soc_rd && sel) ? mem[a[6:0]] : 8'bz;

endmodule // HRAM
