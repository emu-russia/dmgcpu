// apu_env
// Reusable test environment for the DMG-CPU APU netlist (issue #398).
//
// Mirrors how the blocks are wired in HDL/soc/dmgcpu.v, with the SM83 core
// replaced by a behavioral bus master and the WaveRAM macro by a behavioral
// model (the repo HDL/soc/waveram.v is an empty stub - same approach as
// oam_ram.v for OAM in the PPU suite):
//
//   ClkGen    - the SoC clock generator (real netlist, HDL/soc/clkgen.v)
//   MMIO      - DIV/TIMA/IF, the FFxx decode, soc_wr/soc_rd, addr_latch,
//               test modes and lfo_512Hz (real, mmio_merged.v from ../soc)
//   Arbiter   - bus arbiter, ffxx etc. (real, arb_merged.v from ../soc)
//   Ser       - serial link core (real, ser_sharedq.v from ../soc); feeds
//               the serial pieces that live in the APU (sck_dir, ser_out,
//               serial_tick)
//   APU       - the sound generator + joypad/serial pad & a[7:0]
//               arbitration pieces (real, apu_merged.v, bus aliases merged)
//   WaveRAM   - behavioral 16-byte wave RAM model (see wave_ram_model.v)
//   cpu_model - behavioral stand-in for the SM83 core (bus master)
//
// Bus conventions: identical to the small-domain suite (../soc, issue #396):
// * the internal data bus d[7:0] is precharged high while clk2==0 (MMIO/Arb
//   contain the precharge drivers) and driven by the selected device (or
//   the CPU) otherwise; reads are sampled while clk2==1.
// * register writes capture the d-bus value on the internal decode-clock
//   edges produced from soc_wr + the address decode (the decode clocks are
//   low during the write window; the latches/dffs capture as the window
//   closes).  The CPU model holds the data ~6 ns past that edge.
//
// The APU additionally decodes the $FF30-$FF3F (wave RAM) window itself:
// CPU writes pulse n_wave_wr, CPU reads pulse n_wave_rd and re-drive the
// WaveRAM dout onto d (notif1 stage g1255..g1262).

`timescale 1ns/1ns

module apu_env;

	// ------------------------------------------------------------------
	// clock / reset inputs (the test drives these)
	// ------------------------------------------------------------------
	reg ck1;                  // oscillator input to the CK1_CK2 pad
	reg reset;                // internal reset (active high; ~/RES pad)
	reg osc_stable = 1'b1;    // oscillator-stable (see soc_env notes)

	// ------------------------------------------------------------------
	// ClkGen outputs
	// ------------------------------------------------------------------
	wire clk1, clk2, clk3, clk4, clk5, clk6, clk7, clk8, clk9, cclk;
	wire n_reset2, sync_reset, ext_cs_en, cpu_wr_sync;

	// ------------------------------------------------------------------
	// CPU model bus + control
	// ------------------------------------------------------------------
	reg  [15:0] cpu_a;
	reg  [7:0]  cpu_d_out;
	reg         cpu_d_drv;
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
	wire [15:0] a;            // a[7:0] carries the APU arbitration piece
	wire [7:0]  d;
	wire [7:0]  md;           // internal video-memory data bus (idle here)

	pullup (d[0]); pullup (d[1]); pullup (d[2]); pullup (d[3]);
	pullup (d[4]); pullup (d[5]); pullup (d[6]); pullup (d[7]);

	assign a = cpu_a;         // CPU holds the address bus
	// The CPU drives the data bus only in the non-precharge phase (clk2=1,
	// same convention as the rest of the SoC; the bus is precharged high by
	// the modules while clk2==0).  Driving through the precharge phase
	// fights the precharge drivers and produces x on the bus, which the
	// APU's level-sensitive register latches would capture.
	assign d = (cpu_d_drv & clk2) ? cpu_d_out : 8'bz;

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
	// APU outputs (audio + pads) and external pad stand-ins
	// ------------------------------------------------------------------
	wire        n_sout_topad, n_ENA_PU_sin;
	wire        n_DRV_HIGH_sck, DRV_LOW_sck, n_DRV_HIGH_sin, DRV_LOW_sin;
	wire [7:0]  n_DRV_HIGH_p, DRV_LOW_p;         // p10..p15 + p1x grouping
	wire [3:0]  ch1_out, ch2_out, ch3_out, ch4_out;
	wire        ch3_active;
	wire [3:0]  lmixer, rmixer;
	wire [2:0]  n_lvolume, n_rvolume;
	wire        l_vin_en, r_vin_en;
	wire        n_ch1_amp_en, n_ch2_amp_en, n_ch3_amp_en, n_ch4_amp_en;
	wire        cpu_wakeup, int_jp, FF60_D1;
	wire [3:0]  wave_a;
	wire [7:0]  wave_rd;
	wire        n_wave_wr, n_wave_rd, wave_bl_pch;

	// pad input lines (behavioral pads)
	wire n_INPUT_a15 = 1'b0;
	wire [14:8] n_INPUT_a_hi = 7'b0;
	reg  [7:0]  n_INPUT_a = 8'b0;   // a[7:0] pad inputs (TEST1 only)
	wire n_INPUT_nrd = 1'b0;
	wire n_INPUT_nwr = 1'b0;
	reg  n_t1_frompad = 1'b0;       // ~t1 / ~t2 pad levels
	reg  n_t2_frompad = 1'b0;

	reg n_p10 = 1'b0;   // ~pad levels of the joypad matrix (idle = 0)
	reg n_p11 = 1'b0;
	reg n_p12 = 1'b0;
	reg n_p13 = 1'b0;

	// serial pads (behavioral): pad levels for the serial link
	reg n_sin = 1'b0;
	reg n_sck = 1'b0;

	wire CONST0;
	assign CONST0 = 1'b0;

	// PPU stand-ins (absent in the APU tests)
	wire ppu_rd = 1'b0, ppu_wr = 1'b0;
	wire n_ppu_hard_reset = 1'b1;
	wire ff46 = 1'b0;
	reg ppu_int_stat = 1'b0, ppu_int_vbl = 1'b0;
	reg ppu_mode3 = 1'b0;
	wire ppu_clk;
	assign ppu_clk = cclk;

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
		.n_DRV_HIGH_a(n_DRV_HIGH_a), .n_INPUT_a(n_INPUT_a_hi),
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
		.n_DRV_HIGH_nmwr(n_DRV_HIGH_nmwr), .n_mwr(1'b1),
		.DRV_LOW_nmwr(DRV_LOW_nmwr),
		.n_DRV_HIGH_nmrd(n_DRV_HIGH_nmrd), .n_mrd(1'b1),
		.DRV_LOW_nmrd(DRV_LOW_nmrd),
		.n_DRV_HIGH_nmcs(n_DRV_HIGH_nmcs), .n_mcs(1'b1),
		.DRV_LOW_nmcs(DRV_LOW_nmcs),
		.n_DRV_HIGH_md(n_DRV_HIGH_md), .n_md_frompad(8'b0),
		.DRV_LOW_md(DRV_LOW_md), .n_md_ena_pu(n_md_ena_pu),
		.n_DRV_HIGH_d(n_DRV_HIGH_d), .n_db_frompad(8'b0),
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

	Ser ser (
		.d(d), .n_sb_write(n_sb_write), .ser_out(ser_out),
		.serial_tick(serial_tick), .n_sin(n_sin), .int_serial(int_serial),
		.n_sck(n_sck), .sck_dir(sck_dir), .sc_write(sc_write),
		.n_reset2(n_reset2), .lfo_16384Hz(lfo_16384Hz),
		.sc_read(sc_read), .sb_read(sb_read)
	);

	APU apu (
		.cclk(cclk), .clk2(clk2), .clk4(clk4), .clk6(clk6),
		.clk7(clk7), .clk9(clk9), .n_reset2(n_reset2),
		.a(a[7:0]), .d(d),
		.cpu_wakeup(cpu_wakeup),
		.n_DRV_HIGH_a(), .n_INPUT_a(n_INPUT_a), .DRV_LOW_a(),
		.n_sout_topad(n_sout_topad),
		.n_DRV_HIGH_sin(n_DRV_HIGH_sin), .n_ENA_PU_sin(n_ENA_PU_sin),
		.DRV_LOW_sin(DRV_LOW_sin),
		.n_DRV_HIGH_sck(n_DRV_HIGH_sck), .sck_dir(sck_dir),
		.DRV_LOW_sck(DRV_LOW_sck),
		.n_DRV_HIGH_p10(n_DRV_HIGH_p[0]), .n_p10(n_p10),
		.DRV_LOW_p10(DRV_LOW_p[0]),
		.n_DRV_HIGH_p11(n_DRV_HIGH_p[1]), .n_p11(n_p11),
		.DRV_LOW_p11(DRV_LOW_p[1]),
		.n_DRV_HIGH_p12(n_DRV_HIGH_p[2]), .n_p12(n_p12),
		.DRV_LOW_p12(DRV_LOW_p[2]),
		.n_DRV_HIGH_p13(n_DRV_HIGH_p[3]), .n_p13(n_p13),
		.DRV_LOW_p13(DRV_LOW_p[3]),
		.n_DRV_HIGH_p14(n_DRV_HIGH_p[4]), .DRV_LOW_p14(DRV_LOW_p[4]),
		.n_DRV_HIGH_p15(n_DRV_HIGH_p[5]), .DRV_LOW_p15(DRV_LOW_p[5]),
		.CONST0(CONST0),
		.dma_a(dma_a[7:0]), .soc_wr(soc_wr), .soc_rd(soc_rd),
		.lfo_512Hz(apu_lfo), .ser_out(ser_out),
		.serial_tick(serial_tick), .test_1(test_1), .test_2(test_2),
		.n_ext_addr_en(n_ext_addr_en), .ch3_active(ch3_active),
		.wave_a(wave_a), .wave_rd(wave_rd), .n_wave_wr(n_wave_wr),
		.wave_bl_pch(wave_bl_pch), .n_wave_rd(n_wave_rd),
		.addr_latch(addr_latch), .int_jp(int_jp), .FF60_D1(FF60_D1),
		.ffxx(ffxx),
		.n_ch1_amp_en(n_ch1_amp_en), .n_ch2_amp_en(n_ch2_amp_en),
		.n_ch3_amp_en(n_ch3_amp_en), .n_ch4_amp_en(n_ch4_amp_en),
		.ch1_out(ch1_out), .ch2_out(ch2_out), .ch3_out(ch3_out),
		.ch4_out(ch4_out),
		.r_vin_en(r_vin_en), .rmixer(rmixer), .l_vin_en(l_vin_en),
		.lmixer(lmixer), .n_rvolume(n_rvolume), .n_lvolume(n_lvolume),
		.dma_addr_ext(dma_addr_ext)
	);

	wave_ram_model waveram (
		.d(d), .active(ch3_active), .a(wave_a), .dout(wave_rd),
		.n_wr(n_wave_wr), .bl_pch(wave_bl_pch), .n_rd(n_wave_rd)
	);

	// ------------------------------------------------------------------
	// clock driver
	// ------------------------------------------------------------------
	always #32 ck1 = ~ck1;

	// LFO override: tests that measure the frame-sequencer rates may drive
	// lfo_512Hz synthetically (the real MMIO lfo is 512 Hz = clk9/2048 and
	// would make a full envelope/sweep measurement ~0.5 s of sim time).
	reg lfo_override = 1'b0;    // 0: real MMIO lfo_512Hz, 1: lfo_ext
	reg lfo_ext = 1'b0;         // synthetic 512 Hz source
	wire apu_lfo = lfo_override ? lfo_ext : lfo_512Hz;

	// ------------------------------------------------------------------
	// Test interface: CPU bus tasks (same conventions as ../soc/soc_env.v)
	// ------------------------------------------------------------------
	task cpu_write(input [15:0] addr, input [7:0] data);
		begin
			while (cpu_wr_sync !== 1'b0 || soc_rd !== 1'b0)
				@(negedge clk9);
			cpu_a = addr;
			cpu_d_out = data;
			cpu_mreq = 1'b1;
			#6;
			cpu_d_drv = 1'b1;
			cpu_wr = 1'b1;
			@(posedge cpu_wr_sync);
			@(negedge cpu_wr_sync);
			#6;
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
			cpu_rd = 1'b1;
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

	// ---- research: decoded read-enable nets sampled during a read ----
	wire r_w225  = apu.w225;
	wire r_w310  = apu.w310;
	wire r_w116  = apu.w116;
	wire r_w812  = apu.w812;
	wire r_w28   = apu.w28;
	wire r_w177  = apu.w177;
	wire r_w174  = apu.w174;
	wire r_w46   = apu.w46;
	wire r_w47   = apu.w47;
	wire r_w474  = apu.w474;
	wire r_w483  = apu.w483;
	wire r_w432  = apu.w432;
	wire r_w212  = apu.w212;
	wire r_w359  = apu.w359;
	wire r_w399  = apu.w399;
	wire r_w411  = apu.w411;
	wire r_w413  = apu.w413;
	wire r_w505  = apu.w505;
	wire r_w526  = apu.w526;
	wire r_w548  = apu.w548;
	wire r_w555  = apu.w555;
	wire r_w582  = apu.w582;
	wire r_w609  = apu.w609;
	wire r_w632  = apu.w632;
	wire r_w643  = apu.w643;
	wire r_w68   = apu.w68;
	wire r_w828  = apu.w828;
	wire r_w907  = apu.w907;
	wire r_w909  = apu.w909;
	wire r_w993  = apu.w993;
	wire r_w1052 = apu.w1052;
	wire r_w1101 = apu.w1101;
	wire r_w1113 = apu.w1113;
	wire r_w1177 = apu.w1177;
	wire r_w1254 = apu.w1254;
	wire r_w15   = apu.w15;
	wire r_w499  = apu.w499;

	task cpu_read_sel(input [15:0] addr, input integer sdelay,
	                 output [7:0] data, output [36:0] sel);
		begin
			while (cpu_wr_sync !== 1'b0 || soc_rd !== 1'b0)
				@(negedge clk9);
			cpu_a = addr;
			cpu_mreq = 1'b1;
			#6;
			cpu_rd = 1'b1;
			#(sdelay);
			sel = {r_w225, r_w310, r_w116, r_w812, r_w28, r_w177,
			       r_w174, r_w46, r_w47, r_w474, r_w483, r_w432,
			       r_w212, r_w359, r_w399, r_w411, r_w413, r_w505,
			       r_w526, r_w548, r_w555, r_w582, r_w609, r_w632,
			       r_w643, r_w68, r_w828, r_w907, r_w909, r_w993,
			       r_w1052, r_w1101, r_w1113, r_w1177, r_w1254,
			       r_w15, r_w499};
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
		n_p10 = 1'b0; n_p11 = 1'b0; n_p12 = 1'b0; n_p13 = 1'b0;
		n_sin = 1'b0;               // serial pad idles high
		n_sck = 1'b0;
	end

endmodule
