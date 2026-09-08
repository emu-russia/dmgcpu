// wave_ram_model - behavioral WaveRAM macro model for the APU suite
// (the repo HDL/soc/waveram.v is an empty stub - the real macro cells are
// not extracted, same situation as OAM, see the PPU suite oam_ram.v).
//
// Ports mirror the stub + the die wiring (HDL/soc/dmgcpu.v):
//   d     - inout, SoC internal data bus: CPU write data in, CPU read data
//           out (the APU re-drives it; here we only drive d during CPU
//           reads while the APU's n_wave_rd is caused by a read strobe -
//           the APU drives d itself from dout, so this model keeps d
//           tri-state and only produces dout)
//   active- ch3_active: power/enable for the APU sample-fetch read port
//   a     - address (4 bits: 16 bytes = 32 4-bit samples, byte access)
//   dout  - read data to the APU (sample fetch + CPU reads)
//   n_wr  - write strobe, active low (CPU $FF30-$FF3F writes, pulsed by
//           the APU decode)
//   bl_pch- bitline precharge (accepted, not modelled)
//   n_rd  - read strobe, active low (APU playback + CPU $FF30-$FF3F reads)
//
// The CPU write captures the d-bus value as the write window closes
// (posedge of n_wr); playback/read is combinational while n_rd is low.

`timescale 1ns/1ns

module wave_ram_model (
	input  wire [7:0]  d,
	input  wire        active,
	input  wire [3:0]  a,
	output wire [7:0]  dout,
	input  wire        n_wr,
	input  wire        bl_pch,
	input  wire        n_rd
);
	reg [7:0] mem [0:15];
	integer i;

	initial begin
		for (i = 0; i < 16; i = i + 1)
			mem[i] = 8'h00;
	end

	// read: combinational while the strobe is low (the APU latches the
	// samples on its own internal edges; CPU reads are re-driven onto d
	// by the APU itself)
	assign dout = (n_rd === 1'b0) ? mem[a] : 8'bz;

	// write: capture at the end of the CPU write window
	always @(posedge n_wr)
		mem[a] <= d;

	// test hook: preload
	task poke(input [3:0] addr, input [7:0] data);
		begin
			mem[addr] = data;
		end
	endtask
	task peek(input [3:0] addr, output [7:0] data);
		begin
			data = mem[addr];
		end
	endtask

endmodule
