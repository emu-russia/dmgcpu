// oam_ram
// Behavioral OAM SRAM macro model for the PPU testbench (issue #390).
//
// Interface is the stub interface of HDL/soc/oam.v:
//   oam_bl_pch  - bitline precharge (phase hint from PPU2)
//   oa[7:1]     - word address (bit 0 unused)
//   n_oam_rd    - read enable, active low
//   n_oama_wr   - port A write enable, active low
//   n_oamb_wr   - port B write enable, active low
//   n_oama/n_oamb - bidirectional data buses
//
// Ground truth used (msinger "DMG-CPU cells", dmg_cells.html#sram,
// Variant A is used in OAM):
//   * OAM is physically TWO SRAM macros (2x OAM on the die) - one per port.
//   * Each macro = 40 word lines (rows) with byte columns; the 160 OAM
//     bytes of 40 entries x 4 bytes map to 80 16-bit words, two per entry:
//       word w (0..79): even byte = 2w  on port B, odd byte = 2w+1 on A.
//     Port B therefore carries Y/tile bytes and port A the X/flags bytes
//     (matches the netlist: the Y test reads port B; obj_color/obj_prio/
//     sprite_x_flip are port-A attribute bits 4/7/5).
//   * 6T cells, dynamic NMOS access.
//
// Bus convention - INVERSE HOLD (same as `d`, `md`, `nma`, `oa`):
//   the pads carry the INVERSE of the data value (data = ~pad).  The idle /
//   precharged level is HIGH (= data 0); a logic-1 data bit is signalled by
//   pulling the pad LOW (discharge).  PPU2's scan-capture stage stores the
//   pad level directly (dmg_latch g733-g748, no inversion), i.e. it works on
//   the inverse level - the model keeps this convention end to end:
//   read:  pad = ~mem[word]   (bit 1 -> pad low, bit 0 -> pad high/precharge)
//   write: mem[word] = ~pad    (sampled at the write strobe edge)
//
// Model style (round 26, after the "red x" reports): the macro pads are
// open-drain (discharge-only) against always-on pullup keepers instead of a
// strong continuous `~data` tristate.  This reproduces the SRAM precharge:
//   * idle / between accesses the bus sits at its precharged level (1);
//   * during a read the macro only pulls down the pads whose stored bit is 1;
//   * during a write the macro releases the pads (PPU2 drives them);
// and it removes the strong-drive collisions with PPU2's own pad drivers
// (which produced x) without changing the single-driver polarity.
// The old model drove ~data strongly and idled at bus level 0 - wrong for an
// inverse-hold bus.  Regression suite (6 fast tests) passes with this model.
`timescale 1ns/1ns

module oam_ram (
	input  wire        oam_bl_pch,
	input  wire [7:1]  oa,        // word address (0..79); lsb unused
	input  wire        n_oam_rd,  // read, active low
	input  wire        n_oama_wr, // port A write, active low
	input  wire        n_oamb_wr, // port B write, active low
	inout  wire [7:0]  n_oama,    // port A data (inverse hold: ~data)
	inout  wire [7:0]  n_oamb     // port B data (inverse hold: ~data)
);
	// 160 OAM bytes. Byte address = 2*word + {0 for port B, 1 for port A}.
	reg [7:0] mem [0:159];
	reg [7:0] hold_a, hold_b;   // last read data, kept between reads
	integer i;

	// precharge keepers (the SRAM bitline precharge, static approximation)
	pullup (n_oama[0]); pullup (n_oama[1]); pullup (n_oama[2]); pullup (n_oama[3]);
	pullup (n_oama[4]); pullup (n_oama[5]); pullup (n_oama[6]); pullup (n_oama[7]);
	pullup (n_oamb[0]); pullup (n_oamb[1]); pullup (n_oamb[2]); pullup (n_oamb[3]);
	pullup (n_oamb[4]); pullup (n_oamb[5]); pullup (n_oamb[6]); pullup (n_oamb[7]);

	initial begin
		for (i = 0; i < 160; i = i + 1)
			mem[i] = 8'h00;
		hold_a = 8'h00;   // idle: no discharges -> pads stay at precharge 1
		hold_b = 8'h00;
	end

	wire [6:0] word = oa;

	// data value presented: mem during the read, the last read between reads
	wire [7:0] da = (n_oam_rd === 1'b0) ? mem[{word, 1'b1}] : hold_a;
	wire [7:0] db = (n_oam_rd === 1'b0) ? mem[{word, 1'b0}] : hold_b;

	// discharge-only pad drive: bit stored 1 -> pull the pad low (bus 0 =
	// data 1); otherwise hi-Z (the keeper holds the precharge 1 = data 0).
	// hi-Z during writes (PPU2 drives the pads).
	assign n_oama[0] = (n_oama_wr === 1'b0 || da[0] !== 1'b1) ? 1'bz : 1'b0;
	assign n_oama[1] = (n_oama_wr === 1'b0 || da[1] !== 1'b1) ? 1'bz : 1'b0;
	assign n_oama[2] = (n_oama_wr === 1'b0 || da[2] !== 1'b1) ? 1'bz : 1'b0;
	assign n_oama[3] = (n_oama_wr === 1'b0 || da[3] !== 1'b1) ? 1'bz : 1'b0;
	assign n_oama[4] = (n_oama_wr === 1'b0 || da[4] !== 1'b1) ? 1'bz : 1'b0;
	assign n_oama[5] = (n_oama_wr === 1'b0 || da[5] !== 1'b1) ? 1'bz : 1'b0;
	assign n_oama[6] = (n_oama_wr === 1'b0 || da[6] !== 1'b1) ? 1'bz : 1'b0;
	assign n_oama[7] = (n_oama_wr === 1'b0 || da[7] !== 1'b1) ? 1'bz : 1'b0;
	assign n_oamb[0] = (n_oamb_wr === 1'b0 || db[0] !== 1'b1) ? 1'bz : 1'b0;
	assign n_oamb[1] = (n_oamb_wr === 1'b0 || db[1] !== 1'b1) ? 1'bz : 1'b0;
	assign n_oamb[2] = (n_oamb_wr === 1'b0 || db[2] !== 1'b1) ? 1'bz : 1'b0;
	assign n_oamb[3] = (n_oamb_wr === 1'b0 || db[3] !== 1'b1) ? 1'bz : 1'b0;
	assign n_oamb[4] = (n_oamb_wr === 1'b0 || db[4] !== 1'b1) ? 1'bz : 1'b0;
	assign n_oamb[5] = (n_oamb_wr === 1'b0 || db[5] !== 1'b1) ? 1'bz : 1'b0;
	assign n_oamb[6] = (n_oamb_wr === 1'b0 || db[6] !== 1'b1) ? 1'bz : 1'b0;
	assign n_oamb[7] = (n_oamb_wr === 1'b0 || db[7] !== 1'b1) ? 1'bz : 1'b0;

	// hold the read data at the end of each read window (before oa changes)
	always @(posedge n_oam_rd) begin
		hold_a <= mem[{word, 1'b1}];
		hold_b <= mem[{word, 1'b0}];
	end

	// write sampling (the pads carry ~data while the strobe is low)
	always @(negedge n_oama_wr)
		mem[{word, 1'b1}] <= ~n_oama;
	always @(negedge n_oamb_wr)
		mem[{word, 1'b0}] <= ~n_oamb;

	// debug readout used by the testbenches
	task read_byte(input [7:0] a, output [7:0] d);
		begin d = mem[a]; end
	endtask
	task write_byte(input [7:0] a, input [7:0] d);
		begin mem[a] = d; end
	endtask
endmodule
