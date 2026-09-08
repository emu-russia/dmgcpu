// soc_env
// Reusable test environment for the DMG-CPU "small domain" netlists
// (issue #396): ClkGen, Arbiter (Arb), MMIO and Ser, together with the
// real HRAM macro netlist.
//
// Mirrors how the blocks are wired in HDL/soc/dmgcpu.v, with the rest of
// the chip replaced by models:
//
//   ClkGen    - the SoC clock generator (real netlist, HDL/soc/clkgen.v)
//   MMIO      - DIV/TIMA/TMA/TAC, IF, DMA unit, LFOs, sys decode (real,
//               HDL/soc/mmio.v, bus aliases merged -> mmio_merged.v)
//   Arbiter   - external/internal bus arbiter, /CS//MCS//MRD//MWR pads
//               (real, HDL/soc/arb.v -> arb_merged.v)
//   Ser       - serial link core (real, HDL/soc/ser.v -> ser_merged.v)
//   HRAM      - the $FF80-$FFFE high RAM macro (real, HDL/soc/hram.v ->
//               hram_merged.v, sram_bit_lane cells from HDL/soc/sram.v)
//   cpu_model - behavioral stand-in for the SM83 core (bus master)
//
// Bus conventions (same as the PPU testbench, issue #390):
//   * the internal data bus d[7:0] is precharged high while clk2==0 (MMIO
//     and Arb contain the precharge drivers) and driven by the selected
//     device (or the CPU) otherwise; pull-ups model the remaining
//     precharge sources and pad pull-ups.
//   * register data on d is "true value" (read-back drivers are inverting
//     tristates fed from inverted register outputs).
//   * register writes capture the d bus value on the internal decode-clock
//     edges produced from cpu_wr_sync + the ffxx/address decode.
//
// The CPU model drives the shared internal a[15:0] net (the real SM83 core
// would be the only other driver in normal mode) and drives/reads d.

`timescale 1ns/1ns

module soc_env;

	// ------------------------------------------------------------------
	// clock / reset inputs (the test drives these)
	// ------------------------------------------------------------------
	reg ck1;                 // oscillator input to the CK1_CK2 pad
	reg reset;               // internal reset (active high; ~/RES pad)
	reg osc_stable = 1'b1;   // oscillator-stable input to ClkGen (the real
	                         // SoC loops MMIO.osc_stable here; tests that
	                         // exercise that handshake drive it)

	// ------------------------------------------------------------------
	// ClkGen outputs
	// ------------------------------------------------------------------
	wire clk1, clk2, clk3, clk4, clk5, clk6, clk7, clk8, clk9, cclk;
	wire n_reset2, sync_reset, ext_cs_en, cpu_wr_sync;

	// ------------------------------------------------------------------
	// CPU model bus + control
	// ------------------------------------------------------------------
	reg  [15:0] cpu_a;       // internal address bus driver
	reg  [7:0]  cpu_d_out;
	reg         cpu_d_drv;   // enable cpu_d_out on d
	reg         cpu_mreq;
	reg         cpu_rd;
	reg         cpu_wr;
	reg         cpu_m1;
	reg         clk_ena = 1'b1;
	reg         osc_ena = 1'b1;
	reg  [4:0]  cpu_irq_ack = 5'b0;

	// ------------------------------------------------------------------
	// the shared internal buses
	// ------------------------------------------------------------------
	wire [15:0] a;           // a[15] also driven by Arb in TEST1 mode
	wire [7:0]  d;
	wire [7:0]  md;          // internal video-memory data bus (idle here)

	pullup (d[0]); pullup (d[1]); pullup (d[2]); pullup (d[3]);
	pullup (d[4]); pullup (d[5]); pullup (d[6]); pullup (d[7]);

	assign a = cpu_a;                // CPU holds the address bus
	assign d = cpu_d_drv ? cpu_d_out : 8'bz;

	// ------------------------------------------------------------------
	// MMIO outputs of interest
	// ------------------------------------------------------------------
	wire        mmio_osc_stable, n_test_reset, test_1, test_2;
	wire        soc_wr, soc_rd, addr_latch;
	wire        n_dma_phi, dma_run, dma_a_15, dma_addr_ext;
	wire        vram_to_oam, oam_dma_wr, cpu_vram_oam_rd;
	wire        n_ext_addr_en, n_cpu_m1, n_ena_pu_db;
	wire [12:0] dma_a;
	wire        lfo_512Hz, lfo_16384Hz;
	wire [4:0]  cpu_irq_trig;
	wire        sc_read, sb_read, sc_write, n_sb_write;
	wire [14:8] n_DRV_HIGH_a, DRV_LOW_a;
	wire        n_DRV_HIGH_nrd, DRV_LOW_nrd;
	wire        n_DRV_HIGH_nwr, DRV_LOW_nwr;
	wire        n_extdb_to_intdb, n_dblatch_to_intdb, n_intdb_to_extdb;

	// ------------------------------------------------------------------
	// Arbiter outputs
	// ------------------------------------------------------------------
	wire        mmio_sel, boot_sel, ffxx, non_vram_mreq, arb_fexx_ffxx;
	wire        n_DRV_HIGH_a15, DRV_LOW_a15, n_cs_topad;
	wire        n_DRV_HIGH_nmwr, DRV_LOW_nmwr;
	wire        n_DRV_HIGH_nmrd, DRV_LOW_nmrd;
	wire        n_DRV_HIGH_nmcs, DRV_LOW_nmcs;
	wire        n_md_ena_pu;
	wire [7:0]  n_DRV_HIGH_md, DRV_LOW_md;
	wire [7:0]  n_DRV_HIGH_d, DRV_LOW_d;
	wire [7:0]  oam_din;

	// ------------------------------------------------------------------
	// Ser outputs
	// ------------------------------------------------------------------
	wire        ser_out, serial_tick, sck_dir, int_serial;

	// ------------------------------------------------------------------
	// pad input lines (behavioral pads, idle = pad high => n_INPUT 0)
	// ------------------------------------------------------------------
	wire n_INPUT_a15 = 1'b0;
	wire [14:8] n_INPUT_a = 7'b0;
	wire n_INPUT_nrd = 1'b0;
	wire n_INPUT_nwr = 1'b0;
	wire n_mwr = 1'b1;               // /MWR pad idle high
	wire n_mrd = 1'b1;               // /MRD pad idle high
	wire n_mcs = 1'b1;               // /MCS pad idle high
	wire [7:0] n_md_frompad = 8'b0;  // MD pads idle high
	wire [7:0] n_db_frompad = 8'b0;  // D pads idle high
	wire n_t1_frompad = 1'b0;        // t1/t2 pads idle high (not in test mode)
	wire n_t2_frompad = 1'b0;

	wire CONST0;
	assign CONST0 = 1'b0;

	// VRAM md bus: idle (no external SRAM attached unless a test does)
	pullup (md[0]); pullup (md[1]); pullup (md[2]); pullup (md[3]);
	pullup (md[4]); pullup (md[5]); pullup (md[6]); pullup (md[7]);

	// ------------------------------------------------------------------
	// PPU / APU stand-ins (absent in the small-domain tests)
	// ------------------------------------------------------------------
	wire ppu_rd = 1'b0, ppu_wr = 1'b0;
	wire n_ppu_hard_reset = 1'b1;    // inactive
	wire ff46 = 1'b0;
	reg ppu_int_stat = 1'b0, ppu_int_vbl = 1'b0;
	reg int_jp = 1'b0;               // joypad interrupt (APU)
	reg ppu_mode3 = 1'b0;            // PPU idle (no mode-3 VRAM bursts)
	wire FF60_D1 = 1'b0;             // DIV fast mode off
	wire ppu_clk;
	assign ppu_clk = cclk;           // PPU clock ~ cclk passthrough

	// serial pads (behavioral): pad levels for the serial link
	reg n_sin;                 // ~serial input pad level (pad idles high)
	reg n_sck;                 // ~serial clock pad level (pad idles high)
	reg ext_sck_master;        // 1: external master drives the clock

	// clk6_delay (PPU2 output in the real chip): delayed clk6 model
	reg clk6_del;
	wire clk6_delay;
	always @(negedge cclk) clk6_del = clk6;
	assign clk6_delay = clk6_del;

	// ------------------------------------------------------------------
	// DUT instances
	// ------------------------------------------------------------------
	ClkGen clkgen (
		.clk8(clk8), .clk7(clk7), .clk6(clk6), .clk5(clk5),
		.clk4(clk4), .clk3(clk3), .clk2(clk2), .clk1(clk1),
		.cclk(cclk), .clk9(clk9), .n_reset2(n_reset2),
		.clk_ena(clk_ena), .osc_ena(osc_ena),
		.cpu_wr(cpu_wr), .test_1(test_1), .cpu_mreq(cpu_mreq),
		.reset(reset), .osc_stable(osc_stable),
		.n_test_reset(n_test_reset),
		.n_clk_in(~ck1),
		.sync_reset(sync_reset), .ext_cs_en(ext_cs_en),
		.cpu_wr_sync(cpu_wr_sync)
	);

	MMIO mmio (
		.reset(reset), .clk2(clk2), .clk4(clk4),
		.osc_stable(mmio_osc_stable), .clk_ena(clk_ena), .osc_ena(osc_ena),
		.clk6(clk6), .clk9(clk9), .n_reset2(n_reset2),
		.cpu_wr_sync(cpu_wr_sync), .cpu_m1(cpu_m1), .n_cpu_m1(n_cpu_m1),
		.a(a[14:0]), .d(d),
		.cpu_irq_trig(cpu_irq_trig), .cpu_irq_ack(cpu_irq_ack),
		.cpu_rd(cpu_rd), .cpu_wr(cpu_wr),
		.n_DRV_HIGH_a(n_DRV_HIGH_a), .n_INPUT_a(n_INPUT_a),
		.DRV_LOW_a(DRV_LOW_a),
		.n_DRV_HIGH_nrd(n_DRV_HIGH_nrd), .n_INPUT_nrd(n_INPUT_nrd),
		.DRV_LOW_nrd(DRV_LOW_nrd),
		.n_DRV_HIGH_nwr(n_DRV_HIGH_nwr), .n_INPUT_nwr(n_INPUT_nwr),
		.DRV_LOW_nwr(DRV_LOW_nwr),
		.n_t1_frompad(n_t1_frompad), .n_t2_frompad(n_t2_frompad),
		.CONST0(CONST0), .n_ena_pu_db(n_ena_pu_db), .n_dma_phi(n_dma_phi),
		.dma_a(dma_a), .dma_a_15(dma_a_15), .dma_run(dma_run),
		.soc_wr(soc_wr), .soc_rd(soc_rd), .lfo_512Hz(lfo_512Hz),
		.ppu_rd(ppu_rd), .ppu_wr(ppu_wr), .int_serial(int_serial),
		.sc_read(sc_read), .sb_read(sb_read), .sc_write(sc_write),
		.n_sb_write(n_sb_write), .lfo_16384Hz(lfo_16384Hz),
		.ppu_clk(ppu_clk), .vram_to_oam(vram_to_oam),
		.non_vram_mreq(non_vram_mreq), .test_1(test_1), .test_2(test_2),
		.n_extdb_to_intdb(n_extdb_to_intdb),
		.n_dblatch_to_intdb(n_dblatch_to_intdb),
		.n_intdb_to_extdb(n_intdb_to_extdb),
		.n_test_reset(n_test_reset), .n_ext_addr_en(n_ext_addr_en),
		.addr_latch(addr_latch), .int_jp(int_jp), .FF60_D1(FF60_D1),
		.ffxx(ffxx), .n_ppu_hard_reset(n_ppu_hard_reset),
		.ff46(ff46), .dma_addr_ext(dma_addr_ext),
		.cpu_vram_oam_rd(cpu_vram_oam_rd), .oam_dma_wr(oam_dma_wr),
		.ppu_int_stat(ppu_int_stat), .ppu_int_vbl(ppu_int_vbl),
		.clk6_delay(clk6_delay)
	);

	Arbiter arb (
		.clk2(clk2), .n_reset2(n_reset2), .cpu_mreq(cpu_mreq),
		.ext_cs_en(ext_cs_en), .cpu_wr_sync(cpu_wr_sync),
		.a(a), .d(d), .cpu_wr(cpu_wr),
		.mmio_sel(mmio_sel), .boot_sel(boot_sel),
		.n_DRV_HIGH_a15(n_DRV_HIGH_a15), .n_INPUT_a15(n_INPUT_a15),
		.DRV_LOW_a15(DRV_LOW_a15), .n_cs_topad(n_cs_topad),
		.CONST0(CONST0),
		.n_DRV_HIGH_nmwr(n_DRV_HIGH_nmwr), .n_mwr(n_mwr),
		.DRV_LOW_nmwr(DRV_LOW_nmwr),
		.n_DRV_HIGH_nmrd(n_DRV_HIGH_nmrd), .n_mrd(n_mrd),
		.DRV_LOW_nmrd(DRV_LOW_nmrd),
		.n_DRV_HIGH_nmcs(n_DRV_HIGH_nmcs), .n_mcs(n_mcs),
		.DRV_LOW_nmcs(DRV_LOW_nmcs),
		.n_DRV_HIGH_md(n_DRV_HIGH_md), .n_md_frompad(n_md_frompad),
		.DRV_LOW_md(DRV_LOW_md), .n_md_ena_pu(n_md_ena_pu),
		.n_DRV_HIGH_d(n_DRV_HIGH_d), .n_db_frompad(n_db_frompad),
		.DRV_LOW_d(DRV_LOW_d), .n_ena_pu_db(n_ena_pu_db),
		.soc_wr(soc_wr), .soc_rd(soc_rd), .vram_to_oam(vram_to_oam),
		.dma_a_15(dma_a_15), .non_vram_mreq(non_vram_mreq),
		.test_1(test_1), .n_extdb_to_intdb(n_extdb_to_intdb),
		.n_dblatch_to_intdb(n_dblatch_to_intdb),
		.n_intdb_to_extdb(n_intdb_to_extdb),
		.ffxx(ffxx), .n_ppu_hard_reset(n_ppu_hard_reset),
		.ppu_mode3(ppu_mode3), .md(md), .oam_din(oam_din),
		.n_vram_to_oam(~vram_to_oam), .dma_addr_ext(dma_addr_ext),
		.sp_bp_cys(1'b0), .tm_bp_cys(1'b0), .n_sp_bp_mrd(1'b1),
		.n_tm_bp_cys(1'b1), .arb_fexx_ffxx(arb_fexx_ffxx),
		.cpu_vram_oam_rd(cpu_vram_oam_rd)
	);

`ifndef NO_SER
	Ser ser (
		.d(d), .n_sb_write(n_sb_write), .ser_out(ser_out),
		.serial_tick(serial_tick), .n_sin(n_sin), .int_serial(int_serial),
		.n_sck(n_sck), .sck_dir(sck_dir), .sc_write(sc_write),
		.n_reset2(n_reset2), .lfo_16384Hz(lfo_16384Hz),
		.sc_read(sc_read), .sb_read(sb_read)
	);
`endif

	HRAM hram (
		.clk7(clk7), .soc_rd(soc_rd), .soc_wr(soc_wr),
		.d(d), .ffxx(ffxx), .a(a[7:0])
	);

	// ------------------------------------------------------------------
	// serial pads (behavioral): pad levels for the serial link
	// ------------------------------------------------------------------

	// ------------------------------------------------------------------
	// clock driver
	// ------------------------------------------------------------------
	always #32 ck1 = ~ck1;

	// ------------------------------------------------------------------
	// Test interface: CPU bus tasks
	// ------------------------------------------------------------------
	// These produce M-cycle shaped accesses: the address is placed on the
	// bus with MREQ, the strobe is asserted, and (for writes) the data is
	// held a short time after the strobe falls (the internal register
	// latches capture on decode-clock edges near the end of the
	// synchronized write window).

	task cpu_write(input [15:0] addr, input [7:0] data);
		begin
			// previous bus cycle fully finished (no strobes pending)
			while (cpu_wr_sync !== 1'b0 || soc_rd !== 1'b0)
				@(negedge clk9);
			cpu_a = addr;
			cpu_d_out = data;
			cpu_mreq = 1'b1;
			#6;                          // address/decode settle
			cpu_d_drv = 1'b1;
			cpu_wr = 1'b1;               // WR up -> cpu_wr_sync window
			// the MMIO decode clock captures on the edge produced when the
			// synchronized write window closes; keep the data valid until
			// just after cpu_wr_sync falls again
			@(posedge cpu_wr_sync);
			@(negedge cpu_wr_sync);
			#6;                          // data hold after the capture edge
			cpu_wr = 1'b0;
			cpu_d_drv = 1'b0;
			#6;
			cpu_mreq = 1'b0;
			cpu_a = 16'h0000;
		end
	endtask

	task cpu_read(input [15:0] addr, output [7:0] data);
		begin
			while (cpu_wr_sync !== 1'b0 || soc_rd !== 1'b0)
				@(negedge clk9);
			cpu_a = addr;
			cpu_mreq = 1'b1;
			#6;
			cpu_rd = 1'b1;               // soc_rd follows cpu_rd
			// wait two M-cycles, then sample when the data bus is not in
			// the precharge phase (clk2 high)
			repeat (2) @(posedge clk9);
			@(posedge clk2);
			#2;
			data = d;
			cpu_rd = 1'b0;
			#6;
			cpu_mreq = 1'b0;
			cpu_a = 16'h0000;
		end
	endtask

	// cpu_read variant with a configurable post-strobe sample delay (ns)
	task cpu_read_at(input [15:0] addr, input integer sdelay, output [7:0] data);
		begin
			while (cpu_wr_sync !== 1'b0 || soc_rd !== 1'b0)
				@(negedge clk9);
			cpu_a = addr;
			cpu_mreq = 1'b1;
			#6;
			cpu_rd = 1'b1;
			#(sdelay);
			data = d;
			cpu_rd = 1'b0;
			#6;
			cpu_mreq = 1'b0;
			cpu_a = 16'h0000;
		end
	endtask

	// ------------------------------------------------------------------
	initial begin
		ck1 = 1'b0;
		reset = 1'b1;               // assert internal reset
		cpu_a = 16'h0000;
		cpu_d_out = 8'h00;
		cpu_d_drv = 1'b0;
		cpu_mreq = 1'b0;
		cpu_rd = 1'b0;
		cpu_wr = 1'b0;
		cpu_m1 = 1'b0;
		n_sin = 1'b0;               // serial pad idles high
		n_sck = 1'b0;
		ext_sck_master = 1'b0;
	end

endmodule
