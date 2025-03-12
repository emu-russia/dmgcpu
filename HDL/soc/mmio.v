module MMIO (  reset, clk2, clk4, osc_stable, clk_ena, osc_ena, clk6, clk9, n_reset2, cpu_wr_sync, cpu_m1, n_cpu_m1, 
	a, d, 
	cpu_irq_trig, cpu_irq_ack, cpu_rd, cpu_wr, 
	n_DRV_HIGH_a, n_INPUT_a, DRV_LOW_a, 
	n_DRV_HIGH_nrd, n_INPUT_nrd, DRV_LOW_nrd, n_DRV_HIGH_nwr, n_INPUT_nwr, DRV_LOW_nwr, n_t1_frompad, n_t2_frompad, CONST0, n_ena_pu_db, n_dma_phi, 
	dma_a, dma_run, soc_wr, soc_rd, lfo_512Hz, ppu_rd, ppu_wr, int_serial, sc_read, sb_read, sc_write, n_sb_write, lfo_16384Hz, ppu_clk, vram_to_oam, non_vram_mreq, 
	test_1, test_2, n_extdb_to_intdb, n_dblatch_to_intdb, n_intdb_to_extdb, n_test_reset, n_ext_addr_en, addr_latch, int_jp, FF60_D1, ffxx, n_ppu_hard_reset, ff46, dma_addr_ext, cpu_vram_oam_rd, oam_dma_wr, ppu_int_stat, ppu_int_vbl, clk6_delay);

	input wire reset;
	input wire clk2;
	input wire clk4;
	output wire osc_stable;
	input wire clk_ena;
	input wire osc_ena;
	input wire clk6;
	input wire clk9;
	input wire n_reset2;
	input wire cpu_wr_sync;
	input wire cpu_m1;
	output wire n_cpu_m1;
	input wire [15:0] a;
	inout wire [7:0] d;
	output wire [7:0] cpu_irq_trig;
	input wire [7:0] cpu_irq_ack;
	input wire cpu_rd;
	input wire cpu_wr;
	output wire [15:0] n_DRV_HIGH_a;
	input wire [15:0] n_INPUT_a;
	output wire [15:0] DRV_LOW_a;
	output wire n_DRV_HIGH_nrd;
	input wire n_INPUT_nrd;
	output wire DRV_LOW_nrd;
	output wire n_DRV_HIGH_nwr;
	input wire n_INPUT_nwr;
	output wire DRV_LOW_nwr;
	input wire n_t1_frompad;
	input wire n_t2_frompad;
	input wire CONST0;
	output wire n_ena_pu_db;
	output wire n_dma_phi;
	output wire [15:0] dma_a; 		// 15, 12:0 are used only
	output wire dma_run;
	output wire soc_wr;
	output wire soc_rd;
	output wire lfo_512Hz;
	input wire ppu_rd;
	input wire ppu_wr;
	input wire int_serial;
	output wire sc_read;
	output wire sb_read;
	output wire sc_write;
	output wire n_sb_write;
	output wire lfo_16384Hz;
	input wire ppu_clk;
	output wire vram_to_oam;
	input wire non_vram_mreq;
	output wire test_1;
	output wire test_2;
	output wire n_extdb_to_intdb;
	output wire n_dblatch_to_intdb;
	output wire n_intdb_to_extdb;
	output wire n_test_reset;
	output wire n_ext_addr_en;
	output wire addr_latch;
	input wire int_jp;
	input wire FF60_D1;
	input wire ffxx;
	input wire n_ppu_hard_reset;
	input wire ff46;
	output wire dma_addr_ext;
	output wire cpu_vram_oam_rd;
	output wire oam_dma_wr;
	input wire ppu_int_stat;
	input wire ppu_int_vbl;
	input wire clk6_delay;

endmodule // MMIO