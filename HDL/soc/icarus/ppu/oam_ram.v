// oam_ram
// Behavioral OAM SRAM macro model for the PPU testbench (issue #390).
//
// Interface is the stub interface of HDL/soc/oam.v:
//   oam_bl_pch  - bitline precharge (phase hint from PPU2)
//   oa[7:1]     - word address (bit 0 unused)
//   n_oam_rd    - read enable, active low
//   n_oama_wr   - port A write enable, active low
//   n_oamb_wr   - port B write enable, active low
//   n_oama/n_oamb - bidirectional data buses (inverse-hold: ~data)
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
//   * 6T cells, dynamic NMOS access: bitlines are precharged before each
//     access and the data pad is driven as D = ~bit during a read
//     ("inverse-hold"); writes sample the bus and store ~bus.
//   * Between accesses the bitlines hold their level (dynamic storage);
//     the model therefore keeps the last read value on the buses instead of
//     releasing them to z (which otherwise pollutes PPU2's capture latches).
//
// The model is used by ppu_env.v in place of the (empty) HDL/soc/oam.v stub.
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
	reg [7:0] oama_data;
	reg [7:0] oamb_data;
	reg [7:0] oama_hold;
	reg [7:0] oamb_hold;
	reg [6:0] last_oa;
	integer i;

	initial begin
		for (i = 0; i < 160; i = i + 1)
			mem[i] = 8'h00;
		oama_hold = 8'hFF;   // precharged level (logical 0 on the bus)
		oamb_hold = 8'hFF;
		last_oa   = 7'b0000000;
	end

	wire [6:0] word = oa;            // 0..79
	wire [6:0] hold = last_oa;       // word address of the last access

	// Drive the ports during a read; between accesses keep the last value
	// (bitline hold). On a write the macro samples the bus and the pads are
	// released (PPU2 drives them).
	assign n_oama = (n_oama_wr === 1'b0) ? 8'bz : ~oama_data;
	assign n_oamb = (n_oamb_wr === 1'b0) ? 8'bz : ~oamb_data;

	always @(*) begin
		if (n_oam_rd === 1'b0) begin
			oama_data = mem[{word, 1'b1}];
			oamb_data = mem[{word, 1'b0}];
		end else begin
			oama_data = oama_hold;
			oamb_data = oamb_hold;
		end
	end

	// latch the read data (and its address) at the end of each read window
	always @(posedge n_oam_rd) begin
		if (oama_data !== 8'bz) oama_hold = oama_data;
		if (oamb_data !== 8'bz) oamb_hold = oamb_data;
		last_oa = oa;
	end

	// write sampling (the bus carries ~data while the strobe is low)
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
