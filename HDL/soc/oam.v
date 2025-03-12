module OAM (  n_oamb, oam_bl_pch, oa, n_oam_rd, n_oamb_wr, n_oama_wr, n_oama );

	inout wire [7:0] n_oamb;
	input wire oam_bl_pch;
	input wire [7:1] oa;   		// ⚠️ lsb=1
	input wire n_oam_rd;
	input wire n_oamb_wr;
	input wire n_oama_wr;
	inout wire [7:0] n_oama;

endmodule // OAM