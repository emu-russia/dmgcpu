module Arbiter (  clk2, n_reset2, cpu_mreq, ext_cs_en, cpu_wr_sync, a, d, cpu_wr, mmio_sel, boot_sel, 
	n_DRV_HIGH_a, n_INPUT_a, DRV_LOW_a, n_cs_topad, CONST0, n_DRV_HIGH_nmwr, n_mwr, DRV_LOW_nmwr, n_DRV_HIGH_nmrd, n_mrd, DRV_LOW_nmrd, n_DRV_HIGH_nmcs, n_mcs, DRV_LOW_nmcs, 
	n_DRV_HIGH_md, n_md_frompad, DRV_LOW_md, n_md_ena_pu, 
	n_DRV_HIGH_d, n_db_frompad, DRV_LOW_d, n_ena_pu_db, , 
	soc_wr, soc_rd, vram_to_oam, dma_a, non_vram_mreq, test_1, n_extdb_to_intdb, n_dblatch_to_intdb, n_intdb_to_extdb, ffxx, n_ppu_hard_reset, ppu_mode3, md, arb_unk1, arb_unk2, arb_unk3, from_ppu2_unk2, arb_unk4, arb_unk5, from_mmio_unk1, arb_SUGY, arb_SYZO, sp_bp_cys, tm_bp_cys, from_ppu1_RAWA, n_tm_bp_cys, arb_RYCU, cpu_vram_oam_rd, arb_SERA);

	input wire clk2;
	input wire n_reset2;
	input wire cpu_mreq;
	input wire ext_cs_en;
	input wire cpu_wr_sync;
	input wire [15:0] a;
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
	input wire [15:0] dma_a;  		// 15, 12:0 are used only
	output wire non_vram_mreq;
	input wire test_1;
	input wire n_extdb_to_intdb;
	input wire n_dblatch_to_intdb;
	input wire n_intdb_to_extdb;
	output wire ffxx;
	input wire n_ppu_hard_reset;
	input wire ppu_mode3;
	inout wire [7:0] md;
	output wire arb_unk1;
	output wire arb_unk2;
	output wire arb_unk3;
	input wire from_ppu2_unk2;
	output wire arb_unk4;
	output wire arb_unk5;
	input wire from_mmio_unk1;
	output wire arb_SUGY;
	output wire arb_SYZO;
	input wire sp_bp_cys;
	input wire tm_bp_cys;
	input wire from_ppu1_RAWA;
	input wire n_tm_bp_cys;
	output wire arb_RYCU;
	input wire cpu_vram_oam_rd;
	output wire arb_SERA;

endmodule // Arbiter