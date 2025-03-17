module Arbiter (  clk2, n_reset2, cpu_mreq, ext_cs_en, cpu_wr_sync, a, d, cpu_wr, mmio_sel, boot_sel, 
	n_DRV_HIGH_a, n_INPUT_a, DRV_LOW_a, n_cs_topad, CONST0, n_DRV_HIGH_nmwr, n_mwr, DRV_LOW_nmwr, n_DRV_HIGH_nmrd, n_mrd, DRV_LOW_nmrd, n_DRV_HIGH_nmcs, n_mcs, DRV_LOW_nmcs, 
	n_DRV_HIGH_md, n_md_frompad, DRV_LOW_md, n_md_ena_pu, 
	n_DRV_HIGH_d, n_db_frompad, DRV_LOW_d, n_ena_pu_db,
	soc_wr, soc_rd, vram_to_oam, dma_a_15, non_vram_mreq, test_1, n_extdb_to_intdb, n_dblatch_to_intdb, n_intdb_to_extdb, ffxx, n_ppu_hard_reset, ppu_mode3, md, oam_din, oam_to_vram, dma_addr_ext, sp_bp_cys, tm_bp_cys, n_sp_bp_mrd, n_tm_bp_cys, arb_fexx_ffxx, cpu_vram_oam_rd);

	input wire clk2;
	input wire n_reset2;
	input wire cpu_mreq;
	input wire ext_cs_en;
	input wire cpu_wr_sync;
	inout wire [15:0] a; 			// ⚠️ bidir
	inout wire [7:0] d;
	input wire cpu_wr;
	output wire mmio_sel;
	output wire boot_sel;
	output wire [15:0] n_DRV_HIGH_a;
	input wire [15:0] n_INPUT_a;
	output wire [15:0] DRV_LOW_a;
	output wire n_cs_topad;
	output wire CONST0;
	output wire n_DRV_HIGH_nmwr;
	input wire n_mwr;
	output wire DRV_LOW_nmwr;
	output wire n_DRV_HIGH_nmrd;
	input wire n_mrd;
	output wire DRV_LOW_nmrd;
	output wire n_DRV_HIGH_nmcs;
	input wire n_mcs;
	output wire DRV_LOW_nmcs;
	output wire [7:0] n_DRV_HIGH_md;
	input wire [7:0] n_md_frompad;
	output wire [7:0] DRV_LOW_md;
	output wire n_md_ena_pu;
	output wire [7:0] n_DRV_HIGH_d;
	input wire [7:0] n_db_frompad;
	output wire [7:0] DRV_LOW_d;
	input wire n_ena_pu_db;
	input wire soc_wr;
	input wire soc_rd;
	input wire vram_to_oam;
	input wire dma_a_15;
	output wire non_vram_mreq;
	input wire test_1;
	input wire n_extdb_to_intdb;
	input wire n_dblatch_to_intdb;
	input wire n_intdb_to_extdb;
	output wire ffxx;
	input wire n_ppu_hard_reset;
	input wire ppu_mode3;
	inout wire [7:0] md;
	output wire [7:0] oam_din;
	input wire oam_to_vram;
	input wire dma_addr_ext;
	input wire sp_bp_cys;
	input wire tm_bp_cys;
	input wire n_tm_bp_cys;
	output wire arb_fexx_ffxx;
	input wire cpu_vram_oam_rd;
	input wire n_sp_bp_mrd;

endmodule // Arbiter