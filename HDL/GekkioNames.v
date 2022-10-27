// If you somehow want to use the signal names from the Gekkio study (https://github.com/Gekkio/gb-research/tree/main/sm83-cpu-core)

// CLKs

// Decoder1

`define op_ld_nn_a_s010 d[0]
`define op_ld_a_nn_s010 d[1]
`define op_ld_a_nn_s011 d[2]
`define op_alu8 d[3]
`define op_jp_cc_sx01 d[4]
`define op_call_cc_sx01 d[5]
`define op_ret_cc_sx00 d[6]
`define op_jr_cc_sx00 d[7]
`define op_ldh_a_x d[8]
`define op_call_any_s000 d[9]
`define op_call_any_s001 d[10]
`define op_call_any_s010 d[11]
`define op_call_any_s011 d[12]
`define op_call_any_s100 d[13]
`define op_ld_x_n d[14]
`define op_ld_x_n_sx00 d[15]
`define op_ld_r_n_sx01 d[16]
`define op_s110 d[17]
`define op_s111 d[18]
`define op_jr_any_sx01 d[19]
`define op_jr_any_sx00 d[20]
`define op_add_sp_e_s010 d[21]
`define op_ld_hl_sp_sx10 d[22]
`define cb_res_r_sx00 d[23]
`define cb_res_hl_sx01 d[24]
`define op_rotate_a d[25]
`define op_ld_a_rr_sx01 d[26]
`define cb_bit d[27]
`define op_ld_rr_a_sx00 d[28]
`define op_ld_a_rr_sx00 d[29]
`define op_ldh_c_a_sx00 d[30]
`define op_ldh_n_a_sx00 d[31]
`define op_ldh_n_a_sx01 d[32]
`define op_ld_r_hl_sx00 d[33]
`define op_alu_misc_s0xx d[34]
`define op_add_hl_sxx0 d[35]
`define op_dec_rr_sx00 d[36]
`define op_inc_rr_sx00 d[37]
`define op_push_sx01 d[38]
`define op_push_sx00 d[39]
`define op_ld_r_r_s0xx d[40]
`define op_40_to_7f d[41]
`define cb_00_to_3f d[42]
`define op_jp_any_sx00 d[43]
`define op_jp_any_sx01 d[44]
`define op_jp_any_sx10 d[45]
`define op_add_hl_sx01 d[46]
`define op_ld_hl_n_sx01 d[47]
// [!] d48, 49 are skipped
`define op_push_sx10 d[50]
`define op_pop_sx00 d[51]
`define op_pop_sx01 d[52]
`define op_add_sp_s001 d[53]
`define op_ld_hl_sp_sx01 d[54]
`define cb_set_r_sx00 d[55]
`define cb_set_hl_sx01 d[56]
`define cb_set_res_hl_sx00 d[57]
`define op_pop_sx10 d[58]
`define op_ldh_a_n_sx01 d[59]
`define op_ld_nn_sp_s010 d[60]
`define op_ld_nn_sp_s000 d[61]
`define op_ld_sp_hl_sx00 d[62]
`define op_add_sp_e_s000 d[63]
`define op_add_sp_e_s011 d[64]
`define op_ld_hl_sp_sx00 d[65]
`define op_ld_nn_sp_s011 d[66]
`define op_ld_nn_sp_s001 d[67]
`define op_ld_hl_r_sx00 d[68]
`define op_incdec8_hl_sx00 d[69]
`define op_incdec8_hl_sx01 d[70]
`define op_ldh_a_c_sx00 d[71]
`define op_ldh_a_n_sx00 d[72]
`define op_rst_sx01 d[73]
`define op_rst_sx00 d[74]
`define int_s101 d[75]
`define int_s100 d[76]
`define int_s000 d[77]
`define op_80_to_bf_reg_s0xx d[78]
`define op_ret_reti_sx00 d[79]
`define op_ret_cc_sx01 d[80]
`define op_jp_hl_s0xx d[81]
`define op_ret_any_reti_s010 d[82]
`define op_ret_any_reti_s011 d[83]
`define op_ld_hlinc_sx00 d[84]
`define op_ld_hldec_sx00 d[85]
`define op_ld_rr_sx00 d[86]
`define op_ld_rr_sx01 d[87]
`define op_ld_rr_sx10 d[88]
`define op_incdec8_s0xx d[89]
`define op_alu_hl_sx00 d[90]
`define op_alu_n_sx00 d[91]
`define op_rst_sx10 d[92]
`define int_s110 d[93]
`define cb_r_s0xx d[94]
`define cb_hl_sx00 d[95]
`define cb_bit_hl_sx01 d[96]
`define cb_notbit_hl_sx01 d[97]
`define op_incdec8 d[98]
`define op_di_ei_s0xx d[99]
`define op_halt_s0xx d[100]
`define op_nop_stop_s0xx d[101]
`define op_cb_s0xx d[102]
`define op_jr_any_sx10 d[103]
`define op_ea_fa_s000 d[104]
`define op_ea_fa_s001 d[105]
// [!] d106 skipped

// Decoder2

`define cc_check w[0]
`define oe_wzreg_to_idu w[1]
`define op_jr_any_sx10 w[2]
`define op_alu8 w[3]
`define op_ld_abs_a_data_cycle w[4]
`define op_ld_a_abs_data_cycle w[5]
`define wr w[6]
// 7 skipped
`define op_jr_any_sx01 w[7]
`define op_sp_e_sx10 w[8]
`define alu_res w[9]
`define addr_valid w[10]
`define cb_bit w[11]
`define op_ld_abs_rr_sx00 w[12]
`define op_ldh_any_a_data_cycle w[13]
`define op_add_hl_sxx0 w[14]
`define op_incdec_rr w[15]
`define op_ldh_imm_sx01 w[16]
// gekkio order: org w20 -> org w18 -> org w19
`define state0_next w[20]
`define data_fetch_cycle w[18]
`define op_add_hl_sx01 w[19]
//
`define op_push_sx10 w[21]
`define addr_hl w[22]
`define op_sp_e_s001 w[23]
`define alu_set w[24]
`define addr_pc w[25]
`define m1 w[26]
`define op_ld_nn_sp_s01x w[27]
`define oe_pchreg_to_pbus w[28]
`define op_ldh_c_sx00 w[29]
`define stackop w[30]
`define idu_inc w[31]
`define state2_next w[32]
`define state1_next w[33]
`define oe_pclreg_to_pbus w[34]
`define idu_dec w[35]
`define oe_wzreg_to_pcreg w[36]
`define op_incdec8 w[37]
`define allow_r8_write w[38]
// 39,40 out of scope

// Decoder3

`define alu_rotate_shift_left x[0]
`define alu_rotate_shift_right x[1]
`define alu_set_or x[2]
`define alu_sum x[3]
`define alu_logic_or x[4]
`define alu_rlc x[5]
`define alu_rl x[6]
`define alu_rrc x[7]
`define alu_rr x[8]
`define alu_sra x[9]
`define alu_sum_pos_hf_cf x[10]
`define alu_sum_neg_cf x[11]
`define alu_sum_neg_hf_nf x[12]
`define regpair_wren x[13]
`define alu_to_reg x[14]
`define oe_rbus_to_pbus x[15]
`define alu_swap x[16]
`define cb_20_to_3f x[17]
`define alu_xor x[18]
`define alu_logic_and x[19]
`define rotate x[20]
`define alu_ccf_scf x[21]
`define alu_daa x[22]
`define alu_add_adc x[23]
`define alu_sub_sbc x[24]
`define alu_b_complement x[25]
`define alu_cpl x[26]
`define alu_cp x[27]
`define wren_cf x[28]
`define wren_hf_nf_zf x[29]
`define op_add_sp_e_sx10 x[30]
`define op_add_sp_e_s001 x[31]
`define op_alu_misc_a x[32]
`define op_dec8 x[33]
`define alu_reg_to_rbus x[34]
`define oe_areg_to_rbus x[35]
`define cb_wren_r x[36]
`define oe_alu_to_pbus x[37]
`define wren_a x[38]
`define wren_h x[39]
`define wren_l x[40]
`define op_reti_s011 x[41]
`define oe_hlreg_to_idu x[42]
`define oe_hreg_to_rbus x[43]
`define oe_lreg_to_rbus x[44]
`define oe_dereg_to_idu x[45]
`define oe_dreg_to_rbus x[46]
`define oe_ereg_to_rbus x[47]
`define wren_d x[48]
`define wren_b x[49]
`define wren_e x[50]
`define wren_c x[51]
`define oe_bcreg_to_idu x[52]
`define oe_breg_to_rbus x[53]
`define oe_creg_to_rbus x[54]
`define oe_idu_to_uhlbus x[55]
`define oe_wzreg_to_uhlbus x[56]
`define oe_ubus_to_uhlbus x[57]
`define oe_zreg_to_rbus x[58]
`define wren_w x[59]
`define wren_z x[60]
`define wren_sp x[61]
`define oe_idu_to_spreg x[62]
`define oe_wzreg_to_spreg x[63]
`define op_ld_hl_sp_e_s010 x[64]
`define oe_spreg_to_idu x[65]
`define op_ld_hl_sp_e_s001 x[66]
`define oe_idu_to_pcreg x[67]
`define wren_pc x[68]

module org_to_gekkio (d, w, x, stage1, stage2, stage3);

	input [106:0] d;
	input [40:0] w;
	input [68:0] x;
	genvar i;

	// @gekkio: lsb first
	output [103:0] stage1; 		// d[48,49,106] -- ignored
	output [37:0] stage2; 		// w[7,39,40] -- ignored
	output [68:0] stage3;		// 1=1

	// Also: org order: w[20] -> w[18] -> w[19]    (w20 is crooked in topo)
	// gekkio order: org w20 -> org w18 -> org w19

	for (i=0; i<=47; i=i+1) begin
		assign stage1[103-i] = d[i];
	end
	for (i=50; i<106; i=i+1) begin
		assign stage1[(103+2)-i] = d[i]; 	// +2 skipped
	end

	for (i=0; i<=6; i=i+1) begin
		assign stage2[37-i] = w[i];
	end
	for (i=8; i<18; i=i+1) begin
		assign stage2[(37+1)-i] = w[i]; 	// +1 skipped
	end
	// 18-20
	assign stage2[(37+1) - 18] = w[20];
	assign stage2[(37+1) - 19] = w[18];
	assign stage2[(37+1) - 20] = w[19];
	for (i=21; i<39; i=i+1) begin
		assign stage2[(37+1)-i] = w[i]; 	// +1 skipped
	end

	for (i=0; i<=68; i=i+1) begin
		assign stage3[68-i] = x[i];
	end

endmodule // org_to_gekkio
