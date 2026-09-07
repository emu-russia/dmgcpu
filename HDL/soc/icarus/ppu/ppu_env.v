// ppu_env
// Reusable test environment for the DMG-CPU PPU netlists (issue #390).
//
// The environment instantiates the "PPU half" of the SoC as it is wired in
// HDL/soc/dmgcpu.v, with the surrounding blocks replaced by models:
//
//   ClkGen  - the SoC clock generator (real netlist, HDL/soc/clkgen.v)
//   PPU1    - BG/WIN/pixel side (real netlist, HDL/soc/ppu1.v)
//   PPU2    - OAM/sprite/mode side (real netlist, HDL/soc/ppu2.v)
//   oam_env - behavioral model of the OAM RAM macro (the real OAM netlist
//             HDL/soc/oam.v is not yet extracted - empty stub)
//   vram_env- behavioral model of the external VRAM SRAM (DMG-CPU-06 PCB
//             has an LH5164 at the ma/md/n_mcs/n_mrd/n_mwr pins)
//   cpu_model - minimal "CPU+MMIO+Arb" stand-in that performs register
//             reads/writes and DMA-adjacent accesses with SoC semantics.
//
// The models are deliberately simple: they follow the bus conventions
// documented in wiki/soc/ppu1.md ("inverse hold", precharged buses driven by
// inverting tristates) and are cross-checked against the real PPU behavior
// in the waveform documentation (waves.md).

`timescale 1ns/1ns

// ---------------------------------------------------------------------------
// Behavioral OAM RAM macro (stub interface of HDL/soc/oam.v)
// ---------------------------------------------------------------------------
module oam_env (
	input  wire        oam_bl_pch,
	input  wire [7:1]  oa,          // address, bit 0 not used
	input  wire        n_oam_rd,    // read enable, active low
	input  wire        n_oama_wr,   // port A write, active low
	input  wire        n_oamb_wr,   // port B write, active low
	inout  wire [7:0]  n_oama,      // port A data bus (inverse hold)
	inout  wire [7:0]  n_oamb       // port B data bus (inverse hold)
);
	// OAM is 160 bytes; the macro is modeled as 256 bytes (the 7-bit word
	// address with lsb ignored maps to byte pairs). Port A and Port B are
	// two independent byte ports on the same array.
	reg [7:0] mem [0:255];
	reg [7:0] oama_data;
	reg [7:0] oamb_data;
	integer i;
	initial begin
		for (i = 0; i < 256; i = i + 1)
			mem[i] = 8'h00;
	end

	// Data buses are precharged (pulled to 1) when not written.
	// During a read the macro drives the inverse-hold value.
	always @(*) begin
		oama_data = mem[{oa, 1'b0}];
		oamb_data = mem[{oa, 1'b1}];
	end
	assign n_oama = (!n_oam_rd || !n_oama_wr) ? ~oama_data : 8'bz;
	assign n_oamb = (!n_oam_rd || !n_oamb_wr) ? ~oamb_data : 8'bz;

	always @(negedge n_oama_wr)
		mem[{oa, 1'b0}] <= ~n_oama;
	always @(negedge n_oamb_wr)
		mem[{oa, 1'b1}] <= ~n_oamb;
endmodule

// ---------------------------------------------------------------------------
// Behavioral VRAM (external LH5164-like 8Kx8 SRAM, DMG-CPU-06 PCB)
// ---------------------------------------------------------------------------
module vram_env (
	input  wire        clk,       // free-running CPU clock (for write timing)
	input  wire [12:0] ma,        // address (from the MA pads / n_ma)
	input  wire        n_mcs,     // chip select, active low
	input  wire        n_mrd,     // read, active low
	input  wire        n_mwr,     // write, active low
	inout  wire [7:0]  md
);
	reg [7:0] mem [0:8191];
	integer i;
	initial begin
		for (i = 0; i < 8192; i = i + 1)
			mem[i] = 8'h00;
	end

	wire rden = !n_mcs && !n_mrd && n_mwr;
	wire wren = !n_mcs && !n_mwr;

	assign md = rden ? mem[ma] : 8'bz;

	always @(negedge clk)
		if (wren)
			mem[ma] <= md;

	task write_byte(input [12:0] addr, input [7:0] data);
		begin
			mem[addr] = data;
		end
	endtask
	task read_byte(input [12:0] addr, output [7:0] data);
		begin
			data = mem[addr];
		end
	endtask
endmodule

// ---------------------------------------------------------------------------
// PPU environment: PPU1 + PPU2 + OAM + VRAM + ClkGen + simple CPU
// ---------------------------------------------------------------------------
module ppu_env;

	// ---- external pads (test drives these) ----
	reg reset;      // /RES pad, active low
	reg ck1;        // oscillator input (n_clk_in side)

	// CPU bus (test drives register accesses)
	reg  [15:0] cpu_a;
	reg  [7:0]  cpu_d_out;
	reg         cpu_wr_stb;   // drive high for the write phase
	reg         cpu_rd_stb;   // drive high for the read phase
	reg         cpu_d_hold;   // keep data valid briefly after the strobe
	wire [7:0]  cpu_d_in;

	reg         ffxx;         // "FFxx area" from the Arbiter
	reg         arb_fexx_ffxx;// FExx vs FFxx arbitration from the Arbiter
	reg         vram_to_oam;  // VRAM->OAM DMA in progress (from MMIO)
	reg         dma_run;      // DMA run (from MMIO)
	reg  [12:0] dma_a;        // DMA address (from MMIO)
	reg         dma_addr_ext; // DMA external address (from MMIO)
	reg         oam_dma_wr;   // OAM DMA write (from MMIO)
	reg         cpu_vram_oam_rd; // CPU VRAM/OAM read strobe (from MMIO)
	reg         dbg_bus;         // debug: log bus during writes

	// ---- ClkGen outputs ----
	wire n_reset2;
	wire cclk;
	wire clk6;
	wire clk2;
	wire clk7;

	// ---- PPU2 -> PPU1 / MMIO ----
	wire ppu_rd, ppu_wr, ppu_clk, n_ppu_clk, n_ppu_hard_reset;
	wire ppu_mode2, ppu_mode3;
	wire [7:0] h, v;
	wire FF40_D1, FF40_D2, FF40_D3;
	wire FF43_D0, FF43_D1, FF43_D2;
	wire sprite_x_flip, sprite_x_match;
	wire stop_oam_eval;
	wire obj_color, obj_prio;
	wire h_restart, vclk2;
	wire in_window, vbl;
	wire bp_cy, tm_cy, sp_bp_cys, bp_sel;
	wire oam_rd_ck, oam_xattr_latch_cck, oam_addr_ck, obj_prio_ck;
	wire oam_mode3_nrd, oam_mode3_bl_pch;
	wire ff42, ff43, fexx;
	wire n_dma_phi2_latched;
	wire ppu1_ma0;
	wire n_ppu_reset;

	// ---- LCD driver outputs (to the front PCB) ----
	wire n_lcd_ld0, n_lcd_ld1, n_lcd_cp, n_lcd_cpg, n_lcd_cpl;
	wire n_lcd_st, n_lcd_s, n_lcd_fr;

	// ---- buses ----
	wire [12:0] nma;    // VRAM address bus (inverse hold), PPU1 <-> PPU2
	wire [7:0]  d;      // data bus
	wire [7:0]  md;     // VRAM data bus
	wire [7:0]  n_oama, n_oamb;
	wire        n_oam_rd, n_oama_wr, n_oamb_wr, oam_bl_pch;
	wire [7:1]  oa;
	wire [12:0] n_ma;   // PPU1 -> pads -> VRAM address (MA inverted form)
	wire        n_mcs, n_mrd, n_mwr;

	wire CONST0;
	assign CONST0 = 1'b0;

	// weak precharge keepers on the precharged buses (no driver => 1)
	pullup (nma[0]); pullup (nma[1]); pullup (nma[2]); pullup (nma[3]);
	pullup (nma[4]); pullup (nma[5]); pullup (nma[6]); pullup (nma[7]);
	pullup (nma[8]); pullup (nma[9]); pullup (nma[10]); pullup (nma[11]);
	pullup (nma[12]);
	pullup (d[0]); pullup (d[1]); pullup (d[2]); pullup (d[3]);
	pullup (d[4]); pullup (d[5]); pullup (d[6]); pullup (d[7]);

	ClkGen clkgen (
		.clk_ena(1'b1),
		.osc_ena(1'b1),
		.cpu_wr(1'b0),
		.test_1(1'b0),
		.cpu_mreq(1'b0),
		.reset(reset),
		.osc_stable(1'b1),
		.n_test_reset(~reset),
		.n_clk_in(~ck1),
		.cclk(cclk),
		.clk6(clk6),
		.clk2(clk2),
		.clk7(clk7),
		.n_reset2(n_reset2)
	);

	// ---- data bus driver (CPU model) ----
	// the bus must keep the data valid for a short hold after the write
	// strobe falls (real CPU write-cycle timing), otherwise the PPU's
	// level-sensitive register latches race against the bus precharge
	assign d = (cpu_wr_stb | cpu_d_hold) ? cpu_d_out : 8'bz;

	PPU1 ppu1 (
		.a({cpu_a[12], cpu_a[11], cpu_a[10], cpu_a[9], cpu_a[8],
		    cpu_a[7], cpu_a[6], cpu_a[5], cpu_a[4], cpu_a[3],
		    cpu_a[2], cpu_a[1], cpu_a[0]}),
		.d(d),
		.n_ma(n_ma),
		.n_lcd_ld1(n_lcd_ld1),
		.n_lcd_ld0(n_lcd_ld0),
		.n_lcd_cpg(n_lcd_cpg),
		.n_lcd_cp(n_lcd_cp),
		.n_lcd_st(n_lcd_st),
		.n_lcd_cpl(n_lcd_cpl),
		.n_lcd_fr(n_lcd_fr),
		.n_lcd_s(n_lcd_s),
		.CONST0(CONST0),
		.n_dma_phi(1'b1),
		.ppu_rd(ppu_rd),
		.ppu_wr(ppu_wr),
		.ppu_clk(ppu_clk),
		.vram_to_oam(vram_to_oam),
		.ffxx(ffxx),
		.n_ppu_hard_reset(n_ppu_hard_reset),
		.ff46(),
		.nma(nma),
		.fexx(fexx),
		.ff43(ff43),
		.ff42(ff42),
		.sprite_x_flip(sprite_x_flip),
		.sprite_x_match(sprite_x_match),
		.bp_sel(bp_sel),
		.ppu_mode3(ppu_mode3),
		.md(md),
		.v(v),
		.FF43_D1(FF43_D1),
		.FF43_D0(FF43_D0),
		.n_ppu_clk(n_ppu_clk),
		.FF43_D2(FF43_D2),
		.h(h),
		.ppu_mode2(ppu_mode2),
		.vbl(vbl),
		.stop_oam_eval(stop_oam_eval),
		.obj_color(obj_color),
		.vclk2(vclk2),
		.h_restart(h_restart),
		.obj_prio_ck(obj_prio_ck),
		.obj_prio(obj_prio),
		.n_ppu_reset(n_ppu_reset),
		.n_dma_phi2_latched(n_dma_phi2_latched),
		.FF40_D1(FF40_D1),
		.FF40_D2(FF40_D2),
		.FF40_D3(FF40_D3),
		.in_window(in_window),
		.sp_bp_cys(sp_bp_cys),
		.tm_bp_cys(),
		.n_sp_bp_mrd(),
		.n_tm_bp_cys(),
		.arb_fexx_ffxx(arb_fexx_ffxx),
		.ppu_int_stat(),
		.ppu_int_vbl(),
		.oam_mode3_bl_pch(oam_mode3_bl_pch),
		.bp_cy(bp_cy),
		.tm_cy(tm_cy),
		.oam_mode3_nrd(oam_mode3_nrd),
		.ppu1_ma0(ppu1_ma0),
		.oam_rd_ck(oam_rd_ck),
		.oam_xattr_latch_cck(oam_xattr_latch_cck),
		.oam_addr_ck(oam_addr_ck)
	);

	PPU2 ppu2 (
		.cclk(cclk),
		.clk6(clk6),
		.n_reset2(n_reset2),
		.a(cpu_a[7:0]),
		.d(d),
		.n_oamb(n_oamb),
		.oam_bl_pch(oam_bl_pch),
		.oa(oa),
		.n_oam_rd(n_oam_rd),
		.n_oamb_wr(n_oamb_wr),
		.n_oama_wr(n_oama_wr),
		.n_oama(n_oama),
		.CONST0(CONST0),
		.n_dma_phi(1'b1),
		.dma_a(dma_a),
		.dma_run(dma_run),
		.soc_wr(cpu_wr_stb),
		.soc_rd(cpu_rd_stb),
		.ppu_rd(ppu_rd),
		.ppu_wr(ppu_wr),
		.ppu_clk(ppu_clk),
		.vram_to_oam(vram_to_oam),
		.n_ppu_hard_reset(n_ppu_hard_reset),
		.nma(nma),
		.fexx(fexx),
		.ff43(ff43),
		.ff42(ff42),
		.sprite_x_flip(sprite_x_flip),
		.sprite_x_match(sprite_x_match),
		.bp_sel(bp_sel),
		.ppu_mode3(ppu_mode3),
		.md(md),
		.oam_din(8'b0),
		.v(v),
		.FF43_D1(FF43_D1),
		.FF43_D0(FF43_D0),
		.n_ppu_clk(n_ppu_clk),
		.FF43_D2(FF43_D2),
		.h(h),
		.ppu_mode2(ppu_mode2),
		.vbl(vbl),
		.stop_oam_eval(stop_oam_eval),
		.obj_color(obj_color),
		.vclk2(vclk2),
		.h_restart(h_restart),
		.obj_prio_ck(obj_prio_ck),
		.obj_prio(obj_prio),
		.n_ppu_reset(n_ppu_reset),
		.n_vram_to_oam(),
		.n_dma_phi2_latched(n_dma_phi2_latched),
		.FF40_D1(FF40_D1),
		.FF40_D2(FF40_D2),
		.FF40_D3(FF40_D3),
		.in_window(in_window),
		.dma_addr_ext(dma_addr_ext),
		.sp_bp_cys(sp_bp_cys),
		.cpu_vram_oam_rd(cpu_vram_oam_rd),
		.oam_dma_wr(oam_dma_wr),
		.clk6_delay(),
		.oam_mode3_bl_pch(oam_mode3_bl_pch),
		.bp_cy(bp_cy),
		.tm_cy(tm_cy),
		.oam_mode3_nrd(oam_mode3_nrd),
		.ma0(ppu1_ma0),
		.oam_rd_ck(oam_rd_ck),
		.oam_xattr_latch_cck(oam_xattr_latch_cck),
		.oam_addr_ck(oam_addr_ck)
	);

	oam_env oam (
		.oam_bl_pch(oam_bl_pch),
		.oa(oa),
		.n_oam_rd(n_oam_rd),
		.n_oama_wr(n_oama_wr),
		.n_oamb_wr(n_oamb_wr),
		.n_oama(n_oama),
		.n_oamb(n_oamb)
	);

	// the MA pads (OBUF_A) invert the die-internal n_ma bus,
	// so the VRAM SRAM sees the true address
	vram_env vram (
		.clk(~ck1),
		.ma(~n_ma),
		.n_mcs(n_mcs),
		.n_mrd(n_mrd),
		.n_mwr(n_mwr),
		.md(md)
	);

	// pads between the CPU die and the VRAM die
	// (OBUF_A/IOBUF_A behavior: MA out, /MCS//MRD//MWR out, MD bidir)
	reg vram_rd;
	reg vram_wr;
	assign n_mcs = 1'b0;         // VRAM always selected in the PPU tests
	assign n_mrd = vram_rd;      // read strobe (generated below)
	assign n_mwr = vram_wr ? 1'b0 : 1'b1; // write strobe (active low)

	// ------------------------------------------------------------------
	// Test interface: CPU bus tasks
	// ------------------------------------------------------------------
	// Note: the exact bus polarity ("inverse hold") is one of the things the
	// PPU testbench verifies. These tasks use TRUE value on the bus by
	// default; ppu tests may override WR_DATA_INV/RD_DATA_INV once the
	// convention is established by observation.

	task cpu_write(input [15:0] addr, input [7:0] data);
		begin
			@(posedge ppu_clk);
			// phase 1: place the address, let the decode settle
			cpu_a = addr;
			ffxx = (addr[15:8] == 8'hFF);
			arb_fexx_ffxx = ~ffxx;   // rough decode: FFxx vs others
			cpu_d_out = data;
			#5;                       // decode settle (address only)
			// phase 2: assert the write strobe with stable data
			cpu_wr_stb = 1'b1;
			#1;
			if (dbg_bus)
				$display("BUSWR a=%h data=%b d=%b cpu_d_out=%b", cpu_a, data, d, cpu_d_out);
			@(negedge ppu_clk);
			cpu_wr_stb = 1'b0;
			cpu_d_hold = 1'b1;   // data hold after the strobe
			#8;
			cpu_d_hold = 1'b0;
			#10;
		end
	endtask

	task cpu_read(input [15:0] addr, output [7:0] data);
		begin
			@(posedge ppu_clk);
			cpu_a = addr;
			ffxx = (addr[15:8] == 8'hFF);
			arb_fexx_ffxx = ~ffxx;
			#5;
			cpu_rd_stb = 1'b1;
			@(negedge ppu_clk);
			data = d;
			cpu_rd_stb = 1'b0;
			#10;
		end
	endtask



	// VRAM read/write pulses for the CPU side (simplified MA/MD bus)
	// executed via the PPU pass-through address path.
	reg [12:0] vram_ma;
	task vram_write(input [15:0] addr, input [7:0] data);
		begin
			cpu_write(addr, data);   // address+data on the bus
			// (the real write happens through the Arbiter; for the model
			// we store directly - this task is only used to preload VRAM)
		end
	endtask

	// ------------------------------------------------------------------
	initial begin
		reset = 1'b1;    // /RES asserted (active low)
		ck1 = 1'b0;
		cpu_a = 16'h0000;
		cpu_d_out = 8'h00;
		cpu_wr_stb = 1'b0;
		cpu_rd_stb = 1'b0;
		cpu_d_hold = 1'b0;
		ffxx = 1'b0;
		arb_fexx_ffxx = 1'b0;
		vram_to_oam = 1'b0;
		dma_run = 1'b0;
		dma_a = 13'b0;
		dma_addr_ext = 1'b0;
		oam_dma_wr = 1'b0;
		cpu_vram_oam_rd = 1'b0;
		vram_rd = 1'b1;
		vram_wr = 1'b0;
	end
	always #32 ck1 = ~ck1;

	// VRAM read strobe emulation: when the PPU is fetching (mode 3) or the
	// CPU is reading VRAM, keep /MRD low so the model drives md.
	always @(*) begin
		if (ppu_mode3)
			vram_rd = 1'b0;
		else if (cpu_rd_stb && cpu_a[15:13] == 3'b100)
			vram_rd = 1'b0;
		else
			vram_rd = 1'b1;
	end

endmodule
