// Amalgamated SM83 Core source suitable for use in LLM (DeepSeek).

`timescale 1ns/1ns

// If you somehow want to use the signal names from the Gekkio research (https://github.com/Gekkio/gb-research/tree/main/sm83-cpu-core)

// CLKs

`define CLK_N CLK1
`define CLK_P CLK2
`define PHI_P CLK3
`define PHI_N CLK4
`define WRITEBACK_N CLK5
`define WRITEBACK_P CLK6
`define WRITEBACK_EXT CLK7
`define MCLK_PULSE_N CLK8
`define MCLK_PULSE_P CLK9

// Decoder1

`define s1_op_ld_nn_a_s010 d[0]
`define s1_op_ld_a_nn_s010 d[1]
`define s1_op_ld_a_nn_s011 d[2]
`define s1_op_alu8 d[3]
`define s1_op_jp_cc_sx01 d[4]
`define s1_op_call_cc_sx01 d[5]
`define s1_op_ret_cc_sx00 d[6]
`define s1_op_jr_cc_sx00 d[7]
`define s1_op_ldh_a_x d[8]
`define s1_op_call_any_s000 d[9]
`define s1_op_call_any_s001 d[10]
`define s1_op_call_any_s010 d[11]
`define s1_op_call_any_s011 d[12]
`define s1_op_call_any_s100 d[13]
`define s1_op_ld_x_n d[14]
`define s1_op_ld_x_n_sx00 d[15]
`define s1_op_ld_r_n_sx01 d[16]
`define s1_op_s110 d[17]
`define s1_op_s111 d[18]
`define s1_op_jr_any_sx01 d[19]
`define s1_op_jr_any_sx00 d[20]
`define s1_op_add_sp_e_s010 d[21]
`define s1_op_ld_hl_sp_sx10 d[22]
`define s1_cb_res_r_sx00 d[23]
`define s1_cb_res_hl_sx01 d[24]
`define s1_op_rotate_a d[25]
`define s1_op_ld_a_rr_sx01 d[26]
`define s1_cb_bit d[27]
`define s1_op_ld_rr_a_sx00 d[28]
`define s1_op_ld_a_rr_sx00 d[29]
`define s1_op_ldh_c_a_sx00 d[30]
`define s1_op_ldh_n_a_sx00 d[31]
`define s1_op_ldh_n_a_sx01 d[32]
`define s1_op_ld_r_hl_sx00 d[33]
`define s1_op_alu_misc_s0xx d[34]
`define s1_op_add_hl_sxx0 d[35]
`define s1_op_dec_rr_sx00 d[36]
`define s1_op_inc_rr_sx00 d[37]
`define s1_op_push_sx01 d[38]
`define s1_op_push_sx00 d[39]
`define s1_op_ld_r_r_s0xx d[40]
`define s1_op_40_to_7f d[41]
`define s1_cb_00_to_3f d[42]
`define s1_op_jp_any_sx00 d[43]
`define s1_op_jp_any_sx01 d[44]
`define s1_op_jp_any_sx10 d[45]
`define s1_op_add_hl_sx01 d[46]
`define s1_op_ld_hl_n_sx01 d[47]
// [!] d48, 49 are skipped
`define s1_op_push_sx10 d[50]
`define s1_op_pop_sx00 d[51]
`define s1_op_pop_sx01 d[52]
`define s1_op_add_sp_s001 d[53]
`define s1_op_ld_hl_sp_sx01 d[54]
`define s1_cb_set_r_sx00 d[55]
`define s1_cb_set_hl_sx01 d[56]
`define s1_cb_set_res_hl_sx00 d[57]
`define s1_op_pop_sx10 d[58]
`define s1_op_ldh_a_n_sx01 d[59]
`define s1_op_ld_nn_sp_s010 d[60]
`define s1_op_ld_nn_sp_s000 d[61]
`define s1_op_ld_sp_hl_sx00 d[62]
`define s1_op_add_sp_e_s000 d[63]
`define s1_op_add_sp_e_s011 d[64]
`define s1_op_ld_hl_sp_sx00 d[65]
`define s1_op_ld_nn_sp_s011 d[66]
`define s1_op_ld_nn_sp_s001 d[67]
`define s1_op_ld_hl_r_sx00 d[68]
`define s1_op_incdec8_hl_sx00 d[69]
`define s1_op_incdec8_hl_sx01 d[70]
`define s1_op_ldh_a_c_sx00 d[71]
`define s1_op_ldh_a_n_sx00 d[72]
`define s1_op_rst_sx01 d[73]
`define s1_op_rst_sx00 d[74]
`define s1_int_s101 d[75]
`define s1_int_s100 d[76]
`define s1_int_s000 d[77]
`define s1_op_80_to_bf_reg_s0xx d[78]
`define s1_op_ret_reti_sx00 d[79]
`define s1_op_ret_cc_sx01 d[80]
`define s1_op_jp_hl_s0xx d[81]
`define s1_op_ret_any_reti_s010 d[82]
`define s1_op_ret_any_reti_s011 d[83]
`define s1_op_ld_hlinc_sx00 d[84]
`define s1_op_ld_hldec_sx00 d[85]
`define s1_op_ld_rr_sx00 d[86]
`define s1_op_ld_rr_sx01 d[87]
`define s1_op_ld_rr_sx10 d[88]
`define s1_op_incdec8_s0xx d[89]
`define s1_op_alu_hl_sx00 d[90]
`define s1_op_alu_n_sx00 d[91]
`define s1_op_rst_sx10 d[92]
`define s1_int_s110 d[93]
`define s1_cb_r_s0xx d[94]
`define s1_cb_hl_sx00 d[95]
`define s1_cb_bit_hl_sx01 d[96]
`define s1_cb_notbit_hl_sx01 d[97]
`define s1_op_incdec8 d[98]
`define s1_op_di_ei_s0xx d[99]
`define s1_op_halt_s0xx d[100]
`define s1_op_nop_stop_s0xx d[101]
`define s1_op_cb_s0xx d[102]
`define s1_op_jr_any_sx10 d[103]
`define s1_op_ea_fa_s000 d[104]
`define s1_op_ea_fa_s001 d[105]
// [!] d106 skipped

// Decoder2

`define s2_cc_check w[0]
`define s2_oe_wzreg_to_idu w[1]
`define s2_op_jr_any_sx10 w[2]
`define s2_op_alu8 w[3]
`define s2_op_ld_abs_a_data_cycle w[4]
`define s2_op_ld_a_abs_data_cycle w[5]
`define s2_wr w[6]
// 7 skipped
`define s2_op_jr_any_sx01 w[8]
`define s2_op_sp_e_sx10 w[9]
`define s2_alu_res w[10]
`define s2_addr_valid w[11]
`define s2_cb_bit w[12]
`define s2_op_ld_abs_rr_sx00 w[13]
`define s2_op_ldh_any_a_data_cycle w[14]
`define s2_op_add_hl_sxx0 w[15]
`define s2_op_incdec_rr w[16]
`define s2_op_ldh_imm_sx01 w[17]
// gekkio order: org w20 -> org w18 -> org w19
`define s2_state0_next w[20]
`define s2_data_fetch_cycle w[18]
`define s2_op_add_hl_sx01 w[19]
//
`define s2_op_push_sx10 w[21]
`define s2_addr_hl w[22]
`define s2_op_sp_e_s001 w[23]
`define s2_alu_set w[24]
`define s2_addr_pc w[25]
`define s2_m1 w[26]
`define s2_op_ld_nn_sp_s01x w[27]
`define s2_oe_pchreg_to_pbus w[28]
`define s2_op_ldh_c_sx00 w[29]
`define s2_stackop w[30]
`define s2_idu_inc w[31]
`define s2_state2_next w[32]
`define s2_state1_next w[33]
`define s2_oe_pclreg_to_pbus w[34]
`define s2_idu_dec w[35]
`define s2_oe_wzreg_to_pcreg w[36]
`define s2_op_incdec8 w[37]
`define s2_allow_r8_write w[38]
// 39,40 out of scope

// Decoder3

`define s3_alu_rotate_shift_left x[0]
`define s3_alu_rotate_shift_right x[1]
`define s3_alu_set_or x[2]
`define s3_alu_sum x[3]
`define s3_alu_logic_or x[4]
`define s3_alu_rlc x[5]
`define s3_alu_rl x[6]
`define s3_alu_rrc x[7]
`define s3_alu_rr x[8]
`define s3_alu_sra x[9]
`define s3_alu_sum_pos_hf_cf x[10]
`define s3_alu_sum_neg_cf x[11]
`define s3_alu_sum_neg_hf_nf x[12]
`define s3_regpair_wren x[13]
`define s3_alu_to_reg x[14]
`define s3_oe_rbus_to_pbus x[15]
`define s3_alu_swap x[16]
`define s3_cb_20_to_3f x[17]
`define s3_alu_xor x[18]
`define s3_alu_logic_and x[19]
`define s3_rotate x[20]
`define s3_alu_ccf_scf x[21]
`define s3_alu_daa x[22]
`define s3_alu_add_adc x[23]
`define s3_alu_sub_sbc x[24]
`define s3_alu_b_complement x[25]
`define s3_alu_cpl x[26]
`define s3_alu_cp x[27]
`define s3_wren_cf x[28]
`define s3_wren_hf_nf_zf x[29]
`define s3_op_add_sp_e_sx10 x[30]
`define s3_op_add_sp_e_s001 x[31]
`define s3_op_alu_misc_a x[32]
`define s3_op_dec8 x[33]
`define s3_alu_reg_to_rbus x[34]
`define s3_oe_areg_to_rbus x[35]
`define s3_cb_wren_r x[36]
`define s3_oe_alu_to_pbus x[37]
`define s3_wren_a x[38]
`define s3_wren_h x[39]
`define s3_wren_l x[40]
`define s3_op_reti_s011 x[41]
`define s3_oe_hlreg_to_idu x[42]
`define s3_oe_hreg_to_rbus x[43]
`define s3_oe_lreg_to_rbus x[44]
`define s3_oe_dereg_to_idu x[45]
`define s3_oe_dreg_to_rbus x[46]
`define s3_oe_ereg_to_rbus x[47]
`define s3_wren_d x[48]
`define s3_wren_b x[49]
`define s3_wren_e x[50]
`define s3_wren_c x[51]
`define s3_oe_bcreg_to_idu x[52]
`define s3_oe_breg_to_rbus x[53]
`define s3_oe_creg_to_rbus x[54]
`define s3_oe_idu_to_uhlbus x[55]
`define s3_oe_wzreg_to_uhlbus x[56]
`define s3_oe_ubus_to_uhlbus x[57]
`define s3_oe_zreg_to_rbus x[58]
`define s3_wren_w x[59]
`define s3_wren_z x[60]
`define s3_wren_sp x[61]
`define s3_oe_idu_to_spreg x[62]
`define s3_oe_wzreg_to_spreg x[63]
`define s3_op_ld_hl_sp_e_s010 x[64]
`define s3_oe_spreg_to_idu x[65]
`define s3_op_ld_hl_sp_e_s001 x[66]
`define s3_oe_idu_to_pcreg x[67]
`define s3_wren_pc x[68]

// Definition of the SM83 CPU top level.

module SM83Core (
	CLK1, CLK2, CLK3, CLK4, CLK5, CLK6, CLK7, CLK8, CLK9, 
	M1,
	OSC_STABLE, OSC_ENA, RESET, SYNC_RESET, CLK_ENA, NMI,
	WAKE, RD, WR, BUS_DISABLE, MMIO_REQ, IPL_REQ, IPL_DISABLE, MREQ,
	D, A, CPU_IRQ_TRIG, CPU_IRQ_ACK );

	// Obviously, such a large number of dual CLKs is due to the four-cycle "slot" execution of the core.

	input CLK1;
	input CLK2;
	input CLK3;
	input CLK4;
	input CLK5;
	input CLK6;
	input CLK7;
	input CLK8;
	input CLK9;

	output M1; 			// Analog to SYNC signal, which was typically used in old processors (right after the Fetch of the next opcode).

	input OSC_STABLE;	// Active-high crystal oscillator stablilized input?  [previously Clock_WTF]
	output OSC_ENA;		// Crystal oscillator enable. When CPU drives this low, the crystal oscillator gets disabled to save power. This happens during STOP mode. 	[previously XCK_Ena]
	input RESET;		// Active-high asynchronous reset input. Fed directly from RST input pad.
	input SYNC_RESET;	// Active-high synchronous reset input. Synchronized to CLK8/CLK9.
	output CLK_ENA;		// [previously LongDescr]
	input NMI;			// Directly connected to an input pad at the top of the die, which is not bonded.  [previously Unbonded]

	input WAKE;			// Wakes CPU from STOP mode.
	output RD;
	output WR;
	input BUS_DISABLE;		// 1: Disable all bus drivers in the CPU when test mode is active.   [previously Maybe1]
	input MMIO_REQ;		// High when address bus is 0xfexx or 0xffxx.
	input IPL_REQ;		// High when address bus is 0x00xx and boot ROM is still visible.
	input IPL_DISABLE;		// 1: IPL disable, mutes IPL_REQ   [previously Maybe2]
	output MREQ;

	inout [7:0] D;
	output [15:0] A;
	input [7:0] CPU_IRQ_TRIG;
	output [7:0] CPU_IRQ_ACK;

	// Internal wires

	wire [25:0] a; 			// Decoder1 in
	wire [106:0] d; 		// Decoder1 out
	wire [40:0] w; 			// Decoder2 out
	wire [68:0] x; 			// Decoder3 out

	wire [7:0] DL;			// Internal databus
	wire [7:0] DV;			// ALU Operand2
	wire [7:0] Res;			// ALU Result
	wire AllZeros; 			// Res == 0
	wire [5:0] bc;
	wire [7:0] alu; 		// ALU Operand1
	wire bq4;
	wire bq5;
	wire bq7;
	wire Temp_C;			// Temp C flag
	wire Temp_H; 			// Temp H flag
	wire Temp_N;			// Temp N flag
	wire Temp_Z;			// Temp Z flag  / zbus msb
	wire ALU_Out1;			// ALU random logic -> Sequencer; 1: Skip branch
	wire [7:0] IR;			// Current opcode
	wire [5:0] nIR;				// Inverse IR values are only used for the first 6 bits.
	wire [7:3] bro; 		// IRQ Logic interrupt address

	wire SeqOut_1; 		// IME? (to interrupt control)
	wire SeqOut_2;
	wire SeqOut_3; 		// N.C.
	wire SeqControl_1; 			// 1: Wake up after an interrupt. Used in HLT opcode processing.
	wire SeqControl_2;
	wire nCLK4;					// It is obtained by inverting CLK4 inside the sequencer.

	wire ALU_to_Thingy; 		// ALU CarryOut
	wire bot_to_Thingy;			// IE access detected (Address = 0xffff)
	wire TTB1;
	wire TTB2;
	wire TTB3;
	wire Thingy_to_bot;			// Load a value into the IE register from the DL bus.

	assign M1 = `s2_m1;
	assign nCLK4 = ~CLK4;
	assign WR = `s2_wr;

	// Debug wires:
	// (* keep *) wire [15:0] RegPC = bot.pc.PC;
	// (* keep *) wire [15:0] RegSP = bot.sp.SP;
	// (* keep *) wire [7:0] RegA = bot.regs.r1q;
	// (* keep *) wire [7:0] RegF = {alu_inst.bc[3], alu_inst.bc[2], alu_inst.bc[5], alu_inst.bc[1], 4'h0};
	// (* keep *) wire [7:0] RegB = bot.regs.r7q;
	// (* keep *) wire [7:0] RegC = bot.regs.r6q;
	// (* keep *) wire [7:0] RegD = bot.regs.r5q;
	// (* keep *) wire [7:0] RegE = bot.regs.r4q;
	// (* keep *) wire [7:0] RegH = bot.regs.r3q;
	// (* keep *) wire [7:0] RegL = bot.regs.r1q;

	// Instances

	nor z_eval (AllZeros, Res[0], Res[1], Res[2], Res[3], Res[4], Res[5], Res[6], Res[7]);

	GekkioNames gekkio_names (.d(d), .w(w), .x(x));

	DataMux data_mux (
		.CLK(CLK2), 
		.DL_Control1(BUS_DISABLE), 
		.DL_Control2(`s3_oe_alu_to_pbus), 
		.DataBus(D),
		.DL(DL), 
		.Res(Res),
		.DataOut(`s3_oe_rbus_to_pbus),
		.DV(DV),
		.RD_hack(RD),
		.WR_hack(WR) );

	Decoder1 dec1 (
		.CLK2(CLK2),
		.a(a),
		.d(d) );

	Decoder2 dec2 (
		.CLK2(CLK2),
		.d(d),
		.w(w),
		.SeqOut_2(SeqOut_2),
		.IR7(IR[7]) );

	Decoder3 dec3 (
		.CLK2(CLK2),
		.CLK4(CLK4),
		.CLK5(CLK5),
		.nCLK4(nCLK4),
		.a3(a[3]),
		.d(d),
		.w(w),
		.x(x),
		.IR(IR),
		.nIR(nIR),
		.SeqOut_2(SeqOut_2) );

	IRNots mighty_six (
		.IR(IR),
		.nIR(nIR) );

	ALU alu_inst (
		.CLK2(CLK2),
		.CLK4(CLK4),
		.CLK5(CLK5),
		.CLK6(CLK6),
		.CLK7(CLK7),
		.DV(DV),
		.Res(Res),
		.AllZeros(AllZeros),
		.d42(d[42]),
		.d58(d[58]),
		.w(w),
		.x(x),
		.bc(bc),
		.alu(alu),
		.bq4(bq4),
		.bq5(bq5),
		.bq7(bq7),
		.ALU_to_Thingy(ALU_to_Thingy),
		.Temp_C(Temp_C),
		.Temp_H(Temp_H),
		.Temp_N(Temp_N),
		.Temp_Z(Temp_Z),
		.ALU_Out1(ALU_Out1),
		.IR(IR),
		.nIR(nIR) );

	Sequencer seq (
		.CLK1(CLK1),
		.CLK2(CLK2),
		.CLK4(CLK4),
		.CLK6(CLK6),
		.CLK8(CLK8),
		.CLK9(CLK9),
		.nCLK4(nCLK4),
		.IR(IR),
		.a(a),
		.d(d),
		.w(w),
		.x(x),
		.ALU_Out1(ALU_Out1), 
		.NMI(NMI),
		.CLK_ENA(CLK_ENA),
		.OSC_ENA(OSC_ENA),
		.RESET(RESET),
		.SYNC_RESET(SYNC_RESET),
		.OSC_STABLE(OSC_STABLE),
		.WAKE(WAKE),
		.RD(RD),
		.BUS_DISABLE(BUS_DISABLE),
		.MMIO_REQ(MMIO_REQ),
		.IPL_REQ(IPL_REQ),
		.IPL_DISABLE(IPL_DISABLE),
		.MREQ(MREQ),
		.SeqControl_1(SeqControl_1),
		.SeqControl_2(SeqControl_2),
		.SeqOut_1(SeqOut_1),
		.SeqOut_2(SeqOut_2),
		.SeqOut_3(SeqOut_3) );

	Thingy thingy (
		.w8(`s2_op_jr_any_sx01),
		.w31(`s2_idu_inc),
		.w35(`s2_idu_dec),
		.ALU_to_Thingy(ALU_to_Thingy),
		.WR(WR),
		.Temp_Z(Temp_Z),
		.TTB1(TTB1),
		.TTB2(TTB2),
		.TTB3(TTB3),
		.Thingy_to_bot(Thingy_to_bot),
		.bot_to_Thingy(bot_to_Thingy) );

	Bottom bot (
		.CLK2(CLK2),
		.CLK4(CLK4),
		.CLK5(CLK5),
		.CLK6(CLK6),
		.CLK7(CLK7),
		.DL(DL),
		.DV(DV),
		.bc(bc),
		.bq4(bq4),
		.bq5(bq5),
		.bq7(bq7),
		.Temp_C(Temp_C),
		.Temp_H(Temp_H),
		.Temp_N(Temp_N),
		.Temp_Z(Temp_Z),
		.alu(alu),
		.Res(Res),
		.IR(IR),
		.d(d),
		.w(w),
		.x(x), 
		.SYNC_RES(SYNC_RESET),
		.TTB1(TTB1),
		.TTB2(TTB2),
		.TTB3(TTB3),
		.BUS_DISABLE(BUS_DISABLE),
		.bro(bro),
		.A(A) );

	IRQ_Logic irq (
		.CLK3(CLK3),
		.CLK4(CLK4),
		.CLK5(CLK5),
		.CLK6(CLK6),
		.DL(DL),
		.RD(RD),
		.CPU_IRQ_ACK(CPU_IRQ_ACK),
		.CPU_IRQ_TRIG(CPU_IRQ_TRIG),
		.bro(bro),
		.bot_to_Thingy(bot_to_Thingy),
		.Thingy_to_bot(Thingy_to_bot),
		.SYNC_RES(SYNC_RESET),
		.SeqControl_1(SeqControl_1),
		.SeqControl_2(SeqControl_2),
		.SeqOut_1(SeqOut_1),
		.d93(d[93]),
		.A(A) );

endmodule // SM83Core

// Transparent latch used as a bus keeper.
module BusKeeper (d, q);

	input d;
	output q;

	reg val;
	// The BusKeeper value is stored on the FET gate. We assume that initially there is no charge there, i.e. the value is 0.
	initial val = 1'b0;

	always @(*) begin
		case (d)
			1'b1: val <= 1'b1;
			1'b0: val <= 1'b0;
			1'bz: val <= val;
		endcase
	end

	assign q = val;

endmodule // BusKeeper

module GekkioNames(d, w, x);
	input [106:0] d;
	input [40:0] w;
	input [68:0] x;

	// wire CLK_N = CLK1;
	// wire CLK_P = CLK2;
	// wire PHI_P = CLK3;
	// wire PHI_N = CLK4;
	// wire WRITEBACK_N = CLK5;
	// wire WRITEBACK_P = CLK6;
	// wire WRITEBACK_EXT = CLK7;
	// wire MCLK_PULSE_N = CLK8;
	// wire MCLK_PULSE_P = CLK9;

	// Decoder1

	wire s1_op_ld_nn_a_s010 = d[0];
	wire s1_op_ld_a_nn_s010 = d[1];
	wire s1_op_ld_a_nn_s011 = d[2];
	wire s1_op_alu8 = d[3];
	wire s1_op_jp_cc_sx01 = d[4];
	wire s1_op_call_cc_sx01 = d[5];
	wire s1_op_ret_cc_sx00 = d[6];
	wire s1_op_jr_cc_sx00 = d[7];
	wire s1_op_ldh_a_x = d[8];
	wire s1_op_call_any_s000 = d[9];
	wire s1_op_call_any_s001 = d[10];
	wire s1_op_call_any_s010 = d[11];
	wire s1_op_call_any_s011 = d[12];
	wire s1_op_call_any_s100 = d[13];
	wire s1_op_ld_x_n = d[14];
	wire s1_op_ld_x_n_sx00 = d[15];
	wire s1_op_ld_r_n_sx01 = d[16];
	wire s1_op_s110 = d[17];
	wire s1_op_s111 = d[18];
	wire s1_op_jr_any_sx01 = d[19];
	wire s1_op_jr_any_sx00 = d[20];
	wire s1_op_add_sp_e_s010 = d[21];
	wire s1_op_ld_hl_sp_sx10 = d[22];
	wire s1_cb_res_r_sx00 = d[23];
	wire s1_cb_res_hl_sx01 = d[24];
	wire s1_op_rotate_a = d[25];
	wire s1_op_ld_a_rr_sx01 = d[26];
	wire s1_cb_bit = d[27];
	wire s1_op_ld_rr_a_sx00 = d[28];
	wire s1_op_ld_a_rr_sx00 = d[29];
	wire s1_op_ldh_c_a_sx00 = d[30];
	wire s1_op_ldh_n_a_sx00 = d[31];
	wire s1_op_ldh_n_a_sx01 = d[32];
	wire s1_op_ld_r_hl_sx00 = d[33];
	wire s1_op_alu_misc_s0xx = d[34];
	wire s1_op_add_hl_sxx0 = d[35];
	wire s1_op_dec_rr_sx00 = d[36];
	wire s1_op_inc_rr_sx00 = d[37];
	wire s1_op_push_sx01 = d[38];
	wire s1_op_push_sx00 = d[39];
	wire s1_op_ld_r_r_s0xx = d[40];
	wire s1_op_40_to_7f = d[41];
	wire s1_cb_00_to_3f = d[42];
	wire s1_op_jp_any_sx00 = d[43];
	wire s1_op_jp_any_sx01 = d[44];
	wire s1_op_jp_any_sx10 = d[45];
	wire s1_op_add_hl_sx01 = d[46];
	wire s1_op_ld_hl_n_sx01 = d[47];
	// [!] d48, 49 are skipped
	wire s1_op_push_sx10 = d[50];
	wire s1_op_pop_sx00 = d[51];
	wire s1_op_pop_sx01 = d[52];
	wire s1_op_add_sp_s001 = d[53];
	wire s1_op_ld_hl_sp_sx01 = d[54];
	wire s1_cb_set_r_sx00 = d[55];
	wire s1_cb_set_hl_sx01 = d[56];
	wire s1_cb_set_res_hl_sx00 = d[57];
	wire s1_op_pop_sx10 = d[58];
	wire s1_op_ldh_a_n_sx01 = d[59];
	wire s1_op_ld_nn_sp_s010 = d[60];
	wire s1_op_ld_nn_sp_s000 = d[61];
	wire s1_op_ld_sp_hl_sx00 = d[62];
	wire s1_op_add_sp_e_s000 = d[63];
	wire s1_op_add_sp_e_s011 = d[64];
	wire s1_op_ld_hl_sp_sx00 = d[65];
	wire s1_op_ld_nn_sp_s011 = d[66];
	wire s1_op_ld_nn_sp_s001 = d[67];
	wire s1_op_ld_hl_r_sx00 = d[68];
	wire s1_op_incdec8_hl_sx00 = d[69];
	wire s1_op_incdec8_hl_sx01 = d[70];
	wire s1_op_ldh_a_c_sx00 = d[71];
	wire s1_op_ldh_a_n_sx00 = d[72];
	wire s1_op_rst_sx01 = d[73];
	wire s1_op_rst_sx00 = d[74];
	wire s1_int_s101 = d[75];
	wire s1_int_s100 = d[76];
	wire s1_int_s000 = d[77];
	wire s1_op_80_to_bf_reg_s0xx = d[78];
	wire s1_op_ret_reti_sx00 = d[79];
	wire s1_op_ret_cc_sx01 = d[80];
	wire s1_op_jp_hl_s0xx = d[81];
	wire s1_op_ret_any_reti_s010 = d[82];
	wire s1_op_ret_any_reti_s011 = d[83];
	wire s1_op_ld_hlinc_sx00 = d[84];
	wire s1_op_ld_hldec_sx00 = d[85];
	wire s1_op_ld_rr_sx00 = d[86];
	wire s1_op_ld_rr_sx01 = d[87];
	wire s1_op_ld_rr_sx10 = d[88];
	wire s1_op_incdec8_s0xx = d[89];
	wire s1_op_alu_hl_sx00 = d[90];
	wire s1_op_alu_n_sx00 = d[91];
	wire s1_op_rst_sx10 = d[92];
	wire s1_int_s110 = d[93];
	wire s1_cb_r_s0xx = d[94];
	wire s1_cb_hl_sx00 = d[95];
	wire s1_cb_bit_hl_sx01 = d[96];
	wire s1_cb_notbit_hl_sx01 = d[97];
	wire s1_op_incdec8 = d[98];
	wire s1_op_di_ei_s0xx = d[99];
	wire s1_op_halt_s0xx = d[100];
	wire s1_op_nop_stop_s0xx = d[101];
	wire s1_op_cb_s0xx = d[102];
	wire s1_op_jr_any_sx10 = d[103];
	wire s1_op_ea_fa_s000 = d[104];
	wire s1_op_ea_fa_s001 = d[105];
	// [!] d106 skipped

	// Decoder2

	wire s2_cc_check = w[0];
	wire s2_oe_wzreg_to_idu = w[1];
	wire s2_op_jr_any_sx10 = w[2];
	wire s2_op_alu8 = w[3];
	wire s2_op_ld_abs_a_data_cycle = w[4];
	wire s2_op_ld_a_abs_data_cycle = w[5];
	wire s2_wr = w[6];
	// 7 skipped
	wire s2_op_jr_any_sx01 = w[8];
	wire s2_op_sp_e_sx10 = w[9];
	wire s2_alu_res = w[10];
	wire s2_addr_valid = w[11];
	wire s2_cb_bit = w[12];
	wire s2_op_ld_abs_rr_sx00 = w[13];
	wire s2_op_ldh_any_a_data_cycle = w[14];
	wire s2_op_add_hl_sxx0 = w[15];
	wire s2_op_incdec_rr = w[16];
	wire s2_op_ldh_imm_sx01 = w[17];
	// gekkio order: org w20 -> org w18 -> org w19
	wire s2_state0_next = w[20];
	wire s2_data_fetch_cycle = w[18];
	wire s2_op_add_hl_sx01 = w[19];
	//
	wire s2_op_push_sx10 = w[21];
	wire s2_addr_hl = w[22];
	wire s2_op_sp_e_s001 = w[23];
	wire s2_alu_set = w[24];
	wire s2_addr_pc = w[25];
	wire s2_m1 = w[26];
	wire s2_op_ld_nn_sp_s01x = w[27];
	wire s2_oe_pchreg_to_pbus = w[28];
	wire s2_op_ldh_c_sx00 = w[29];
	wire s2_stackop = w[30];
	wire s2_idu_inc = w[31];
	wire s2_state2_next = w[32];
	wire s2_state1_next = w[33];
	wire s2_oe_pclreg_to_pbus = w[34];
	wire s2_idu_dec = w[35];
	wire s2_oe_wzreg_to_pcreg = w[36];
	wire s2_op_incdec8 = w[37];
	wire s2_allow_r8_write = w[38];
	// 39,40 out of scope

	// Decoder3

	wire s3_alu_rotate_shift_left = x[0];
	wire s3_alu_rotate_shift_right = x[1];
	wire s3_alu_set_or = x[2];
	wire s3_alu_sum = x[3];
	wire s3_alu_logic_or = x[4];
	wire s3_alu_rlc = x[5];
	wire s3_alu_rl = x[6];
	wire s3_alu_rrc = x[7];
	wire s3_alu_rr = x[8];
	wire s3_alu_sra = x[9];
	wire s3_alu_sum_pos_hf_cf = x[10];
	wire s3_alu_sum_neg_cf = x[11];
	wire s3_alu_sum_neg_hf_nf = x[12];
	wire s3_regpair_wren = x[13];
	wire s3_alu_to_reg = x[14];
	wire s3_oe_rbus_to_pbus = x[15];
	wire s3_alu_swap = x[16];
	wire s3_cb_20_to_3f = x[17];
	wire s3_alu_xor = x[18];
	wire s3_alu_logic_and = x[19];
	wire s3_rotate = x[20];
	wire s3_alu_ccf_scf = x[21];
	wire s3_alu_daa = x[22];
	wire s3_alu_add_adc = x[23];
	wire s3_alu_sub_sbc = x[24];
	wire s3_alu_b_complement = x[25];
	wire s3_alu_cpl = x[26];
	wire s3_alu_cp = x[27];
	wire s3_wren_cf = x[28];
	wire s3_wren_hf_nf_zf = x[29];
	wire s3_op_add_sp_e_sx10 = x[30];
	wire s3_op_add_sp_e_s001 = x[31];
	wire s3_op_alu_misc_a = x[32];
	wire s3_op_dec8 = x[33];
	wire s3_alu_reg_to_rbus = x[34];
	wire s3_oe_areg_to_rbus = x[35];
	wire s3_cb_wren_r = x[36];
	wire s3_oe_alu_to_pbus = x[37];
	wire s3_wren_a = x[38];
	wire s3_wren_h = x[39];
	wire s3_wren_l = x[40];
	wire s3_op_reti_s011 = x[41];
	wire s3_oe_hlreg_to_idu = x[42];
	wire s3_oe_hreg_to_rbus = x[43];
	wire s3_oe_lreg_to_rbus = x[44];
	wire s3_oe_dereg_to_idu = x[45];
	wire s3_oe_dreg_to_rbus = x[46];
	wire s3_oe_ereg_to_rbus = x[47];
	wire s3_wren_d = x[48];
	wire s3_wren_b = x[49];
	wire s3_wren_e = x[50];
	wire s3_wren_c = x[51];
	wire s3_oe_bcreg_to_idu = x[52];
	wire s3_oe_breg_to_rbus = x[53];
	wire s3_oe_creg_to_rbus = x[54];
	wire s3_oe_idu_to_uhlbus = x[55];
	wire s3_oe_wzreg_to_uhlbus = x[56];
	wire s3_oe_ubus_to_uhlbus = x[57];
	wire s3_oe_zreg_to_rbus = x[58];
	wire s3_wren_w = x[59];
	wire s3_wren_z = x[60];
	wire s3_wren_sp = x[61];
	wire s3_oe_idu_to_spreg = x[62];
	wire s3_oe_wzreg_to_spreg = x[63];
	wire s3_op_ld_hl_sp_e_s010 = x[64];
	wire s3_oe_spreg_to_idu = x[65];
	wire s3_op_ld_hl_sp_e_s001 = x[66];
	wire s3_oe_idu_to_pcreg = x[67];
	wire s3_wren_pc = x[68];

endmodule

module Sequencer ( CLK1, CLK2, CLK4, CLK6, CLK8, CLK9, nCLK4, IR, a, d, w, x, ALU_Out1, 
	NMI, CLK_ENA, OSC_ENA, RESET, SYNC_RESET, OSC_STABLE, WAKE, RD, BUS_DISABLE, MMIO_REQ, IPL_REQ, IPL_DISABLE, MREQ,
	SeqControl_1, SeqControl_2, SeqOut_1, SeqOut_2, SeqOut_3 );

	input CLK1;
	input CLK2;
	input CLK4;
	input CLK6;
	input CLK8;
	input CLK9;
	input nCLK4;

	(* keep *) input [7:0] IR;
	output [25:0] a;
	input [106:0] d;
	input [40:0] w;
	input [68:0] x;
	input ALU_Out1; // high when condition check fails. See `az[11]` for logic.

	input NMI;				// [previously Unbonded]
	output CLK_ENA;			// [previously LongDescr]
	output OSC_ENA;			// [previously XCK_Ena]
	input RESET;			// From Reset pad
	input SYNC_RESET;
	input OSC_STABLE;		// [previously Clock_WTF]
	input WAKE;
	output RD;
	input BUS_DISABLE;			// 1: Bus disable
	input MMIO_REQ;
	input IPL_REQ;
	input IPL_DISABLE; 			// 1: IPL disable, mutes IPL_REQ; See seq_mreq module.
	output MREQ;

	input SeqControl_1; 		// 1: Wake up after an interrupt. Used in HLT opcode processing.
	input SeqControl_2;
	output SeqOut_1;
	output SeqOut_2;
	output SeqOut_3;			// GND

	// Automagically generated from seq.xmlz by GetVerilog exe (https://github.com/emu-russia/Deroute/tree/main/UserScripts)

	// Wires

	wire w1;
	wire w2;
	wire w3;
	wire w4;
	wire w5;
	wire w6;
	wire w7;
	wire w8;
	wire w9;
	wire w10;
	wire w11;
	wire w12;
	wire w14;
	wire w15;
	wire w16;
	wire w17;
	wire w18;
	wire w19;
	wire w20;
	wire w21;
	wire w22;
	wire w23;
	wire w24;
	wire w25;
	wire w26;
	wire w27;
	wire w28;
	wire w29;
	wire w30;
	wire w31;
	wire w32;
	wire w33;
	wire w34;
	wire w35;
	wire w36;
	wire w37;
	wire w38;
	wire w39;
	wire w40;
	wire w41;
	wire extra_IR4;
	wire extra_IR3;
	wire w44;
	wire w45;
	wire w46;
	wire w47;
	wire w48;
	wire w49;
	wire w50;
	wire w51;
	wire w52;
	wire w53;
	wire w54;
	wire w55;
	wire w56;
	wire w57;
	wire w58;
	wire w59;
	wire w60;
	wire w61;
	wire w62;
	wire w63;
	wire w64;
	wire w65;
	wire w66;
	wire w67;
	wire w68;
	wire w69;
	wire w70;
	wire w71;
	wire w72;
	wire w73;
	wire w74;
	wire w75;
	wire w76;
	wire w77;
	wire w78;
	wire w79;
	wire w80;
	wire w81;
	wire w82;
	wire w83;
	wire w84;
	wire w85;
	wire w86;
	wire w87;
	wire w88;
	wire w89;
	wire w90;
	wire w91;
	wire w92;
	wire w93;
	wire w94;
	wire w95;
	wire w96;
	wire w97;
	wire w98;
	wire w99;
	wire w100;
	wire w101;
	wire w102;
	wire w103;
	wire w104;
	wire w105;
	wire w106;
	wire w107;
	wire w108;
	wire w109;
	wire w110;
	wire w111;
	wire w112;
	wire w113;
	wire w114;
	wire w115;
	wire w116;
	wire w117;
	wire w118;
	wire w119;
	wire w120;
	wire w121;
	wire w122;
	wire w123;
	wire w124;
	wire w125;
	wire w126;
	wire w127;
	wire w128;
	wire w129;
	wire w130;
	wire w131;
	wire w132;
	wire w133;
	wire w134;
	wire w135;
	wire w136;
	wire w137;
	wire w138;
	wire w139;
	wire w140;

	// Assigns  (Issue #134)

	assign w1 = `s1_op_cb_s0xx;
	assign w2 = `s2_m1;
	assign w4 = `s3_op_reti_s011;
	assign w38 = NMI;
	assign w10 = BUS_DISABLE;
	assign w34 = MMIO_REQ;
	assign w35 = IPL_REQ;
	assign w36 = IPL_DISABLE;
	assign MREQ = w12;
	assign SeqOut_1 = w6;
	assign w7 = CLK8;
	assign SeqOut_2 = w8;
	assign RD = w9;
	assign w11 = `s2_addr_valid;
	assign SeqOut_3 = 1'b0;
	assign w16 = SYNC_RESET;
	assign w20 = CLK4;
	assign w22 = `s2_data_fetch_cycle;
	assign w25 = WAKE;
	assign OSC_ENA = w31;
	assign a[0] = w48;
	assign a[1] = w47;
	assign a[2] = w49;
	assign a[3] = w50;
	assign a[4] = w52;
	assign a[5] = w37;
	assign a[6] = w53;
	assign a[7] = w40;
	assign a[8] = w54;
	assign a[9] = w41;
	assign a[10] = w55;
	assign a[11] = extra_IR4;
	assign a[12] = w56;
	assign a[13] = extra_IR3;
	assign a[14] = w57;
	assign a[15] = w44;
	assign a[16] = w58;
	assign a[17] = w45;
	assign a[18] = w59;
	assign a[19] = w46;
	assign a[20] = w60;
	assign a[21] = w61;
	assign a[22] = w62;
	assign a[23] = w63;
	assign a[24] = w64;
	assign a[25] = w65;
	assign w37 = IR[7];
	assign w40 = IR[6];
	assign w41 = IR[5];
	assign extra_IR4 = IR[4];
	assign extra_IR3 = IR[3];
	assign w44 = IR[2];
	assign w45 = IR[1];
	assign w46 = IR[0];
	assign CLK_ENA = w66;
	assign w72 = SeqControl_2;
	assign w112 = SeqControl_1;
	assign w79 = `s1_op_di_ei_s0xx;
	assign w91 = `s1_int_s110;
	assign w3 = CLK9;
	assign w100 = `s2_state2_next;
	assign w101 = `s2_state1_next;
	assign w104 = `s2_state0_next;
	assign w107 = `s1_op_halt_s0xx;
	assign w108 = RESET;
	assign w111 = CLK2;
	assign w110 = CLK1;
	assign w118 = OSC_STABLE;
	assign w132 = `s1_op_nop_stop_s0xx;
	assign w136 = w[40];
	assign w138 = CLK6;
	assign w140 = ALU_Out1;
	assign w21 = nCLK4;

	// Instances

	seq_mreq g72 (.d(w11), .b(w35), .a(w34), .c(w36), .x(w33) );
	seq_dff_posedge_comp g38 (.q(w8), .cclk(w7), .clk(w3), .d(w136) );
	seq_not g66 (.a(w16), .x(w15) );
	seq_nor3 g50 (.a(w28), .b(w16), .c(1'b0), .x(w17) );
	seq_not g27 (.a(w24), .x(w9) );
	seq_not g73 (.a(w33), .x(w12) );
	seq_nor g97 (.a(w16), .b(w108), .x(w14) );
	seq_not g96 (.a(w14), .x(w26) );
	seq_aoi_31 g39 (.a0(w19), .a1(w2), .x(w135), .b(w18), .a2(w20) );
	seq_not g51 (.a(w17), .x(w18) );
	seq_not g41 (.a(w1), .x(w19) );
	seq_not g40 (.a(w135), .x(w71) );
	seq_nor g25 (.b(w21), .a(w10), .x(w23) );
	seq_oai_21 g26 (.a1(w22), .b(w23), .x(w24), .a0(w2) );
	seq_nor g60 (.a(w25), .b(w26), .x(w29) );
	seq_oai_21 g43 (.b(w14), .a1(w114), .a0(w113), .x(w27) );
	seq_rs_latch2 g49 (.q(w28), .nr(w27), .s(w122) );
	seq_rs_latch g62 (.nr(w29), .s(w109), .q(w30) );
	seq_not g61 (.a(w30), .x(w31) );
	seq_dff_posedge_comp g37 (.cclk(w7), .clk(w3), .d(w95), .q(w96) );
	seq_dff_posedge_comp g36 (.cclk(w7), .clk(w3), .d(w103), .q(w137) );
	seq_dff_posedge_comp g35 (.cclk(w7), .clk(w3), .q(w94), .d(w99) );
	seq_latchr_comp g33 (.q(w124), .d(w1), .res(w28), .clk(w138), .cclk(w139), .ld(w2), .nld(w123) );
	seq_dff_posedge_comp g42 (.clk(w3), .cclk(w7), .d(w112), .q(w113) );
	seq_dff_posedge_comp g46 (.cclk(w7), .clk(w3), .d(w107), .q(w120) );
	seq_dff_posedge_comp g54 (.cclk(w7), .clk(w3), .d(w39), .q(w90) );
	seq_dff_posedge_comp g57 (.cclk(w7), .clk(w3), .d(w117), .q(w115) );
	seq_dff_posedge_comp g58 (.cclk(w7), .clk(w3), .d(w119), .q(w117) );
	seq_dff_posedge_comp g63 (.cclk(w7), .clk(w3), .d(w134), .q(w109) );
	seq_dff_posedge_comp g67 (.cclk(w7), .clk(w3), .d(w5), .q(w6) );
	seq_dff_posedge_comp g74 (.cclk(w7), .clk(w3), .d(w131), .q(w126) );
	seq_dff_posedge_comp g84 (.cclk(w111), .clk(w110), .d(w74), .q(w83) );
	seq_dff_posedge_comp g85 (.cclk(w7), .clk(w3), .d(w75), .q(w68) );
	seq_not g0 (.a(w47), .x(w48) );
	seq_not g1 (.a(w106), .x(w47) );
	seq_not g2 (.a(w37), .x(w52) );
	seq_not g3 (.a(w40), .x(w53) );
	seq_not g4 (.a(w41), .x(w54) );
	seq_not g5 (.a(extra_IR4), .x(w55) );
	seq_not g6 (.a(extra_IR3), .x(w56) );
	seq_not g7 (.a(w44), .x(w57) );
	seq_not g8 (.a(w45), .x(w58) );
	seq_not g9 (.a(w46), .x(w59) );
	seq_not g10 (.a(w51), .x(w50) );
	seq_not g11 (.a(w50), .x(w49) );
	seq_not g12 (.a(w94), .x(w60) );
	seq_not g13 (.a(w60), .x(w61) );
	seq_not g14 (.a(w137), .x(w62) );
	seq_not g15 (.a(w62), .x(w63) );
	seq_not g16 (.a(w96), .x(w64) );
	seq_not g17 (.a(w64), .x(w65) );
	seq_not g18 (.a(w100), .x(w98) );
	seq_not g20 (.a(w101), .x(w102) );
	seq_not g22 (.a(w104), .x(w105) );
	seq_nand g23 (.b(w97), .a(w105), .x(w95) );
	seq_nand g21 (.b(w97), .a(w102), .x(w103) );
	seq_nand g19 (.a(w98), .b(w97), .x(w99) );
	seq_aoi_21 g30 (.b(1'b0), .a0(w125), .a1(w124), .x(w51) );
	seq_nor3 g28 (.a(w126), .b(w18), .x(w106), .c(1'b0) );
	seq_not g29 (.a(w61), .x(w125) );
	seq_not g31 (.a(w28), .x(w66) );
	seq_not g32 (.a(w138), .x(w139) );
	seq_not g34 (.a(w2), .x(w123) );
	seq_not g44 (.a(w115), .x(w116) );
	seq_not g48 (.a(w121), .x(w122) );
	seq_not g53 (.a(w38), .x(w39) );
	seq_not g93 (.a(w78), .x(w77) );
	seq_not g86 (.a(w5), .x(w82) );
	seq_not g81 (.a(w87), .x(w86) );
	seq_not g75 (.a(w130), .x(w131) );
	seq_not g69 (.a(w70), .x(w93) );
	seq_not g64 (.a(w133), .x(w134) );
	seq_nand g59 (.a(w15), .b(w118), .x(w119) );
	seq_nand g65 (.a(extra_IR4), .b(w132), .x(w133) );
	seq_nand3 g70 (.a(w71), .b(w68), .c(w69), .x(w70) );
	seq_nor g76 (.a(w5), .b(w129), .x(w130) );
	seq_nor g78 (.a(w91), .b(w16), .x(w128) );
	seq_nand g79 (.a(w71), .b(w72), .x(w85) );
	seq_nand g80 (.a(w67), .b(w79), .x(w87) );
	seq_not g82 (.a(w20), .x(w84) );
	seq_nor4 g83 (.a(w86), .b(w85), .c(w84), .d(w83), .x(w127) );
	seq_nor g87 (.b(w4), .a(w16), .x(w81) );
	seq_nand g90 (.a(w75), .b(w73), .x(w74) );
	seq_not g95 (.a(extra_IR3), .x(w67) );
	seq_not g88 (.a(w81), .x(w80) );
	seq_nor3 g47 (.a(w120), .b(w109), .c(w108), .x(w121) );
	seq_nor g45 (.a(w116), .b(w117), .x(w114) );
	seq_aoi_21 g52 (.a0(w6), .a1(w91), .b(w16), .x(w92) );
	seq_nor g24 (.x(w97), .a(w140), .b(w18) );
	seq_nor g56 (.a(w89), .b(w39), .x(w88) );
	seq_latch_comp g55 (.cclk(w3), .clk(w7), .d(w90), .nq(w89) );
	seq_rs_latch g71 (.q(w69), .nr(w92), .s(w88) );
	seq_rs_latch g77 (.nr(w128), .s(w127), .q(w129) );
	seq_rs_latch g89 (.nr(w82), .s(w80), .q(w75) );
	seq_rs_latch g92 (.nr(w76), .s(w77), .q(w73) );
	seq_aoi_22_dyn g94 (.clk(w20), .a0(w68), .a1(w4), .b0(w79), .b1(extra_IR3), .x(w78) );
	seq_aoi_221_dyn g91 (.clk(w20), .c(w16), .a0(w126), .a1(w68), .b0(w79), .b1(w67), .x(w76) );
	seq_rs_latch g68 (.q(w5), .nr(w92), .s(w93) );

endmodule // seq


// Elements of standard schematics ("kinda cells") used in the sequencer. Moved separately.

// This module is essentially used to generate the #MREQ signal. Very cleverly twisted combined logic.
module seq_mreq ( a, b, c, d, x );

	input a;
	input b;	
	input c;
	input d;
	output x;

	assign x = d ? ~((~a & c) | ~(a|b)) : 1'b1;

endmodule // seq_mreq

// Regular posedge DFF (dual rails)
module seq_dff_posedge_comp ( d, clk, cclk, q );

	input d;	
	input clk;
	input cclk;
	output q;

	reg val;
	initial val = 1'bx;

	always @(posedge clk) begin
		val <= d;
	end

	assign q = val;

endmodule // seq_dff_posedge_comp

module seq_not ( a, x );

	input a;
	output x;

	assign x = ~a;

endmodule // seq_not

module seq_nor3 ( a, b, c, x );

	input a;
	input b;
	input c;
	output x;

	assign x = ~(a|b|c);

endmodule // seq_nor3

module seq_nor ( a, b, x );

	input a;
	input b;
	output x;

	assign x = ~(a|b);

endmodule // seq_nor

module seq_aoi_31 ( a0, a1, a2, b, x );

	input a0;
	input a1;
	input a2;
	input b;
	output x;

	assign x = ~( (a0&a1&a2) | b);

endmodule // seq_aoi_31

module seq_oai_21 ( a0, a1, b, x );

	input a0;	
	input a1;
	input b;	
	output x;

	assign x = ~( (a0|a1) & b );

endmodule // seq_oai_21

// This is essentially the same rs_latch, but with the inputs rearranged.
module seq_rs_latch2 ( nr, s, q );

	input nr;
	input s;
	output q;

	reg val;
	// Let's lower the difficulty level and use 0 here instead of `x`.
	initial val = 1'b0;

	// The module design is such that reset overrides set if both are set at the same time.
	always @(*) begin
		if (~nr)
			val = 1'b0;
		else if (s)
			val = 1'b1;
	end

	assign q = val;

endmodule // seq_rs_latch2

// rs_latch
module seq_rs_latch ( nr, s, q );

	input nr;
	input s;
	output q;

	reg val;
	// Let's lower the difficulty level and use 0 here instead of `x`.
	initial val = 1'b0;

	// The module design is such that reset overrides set if both are set at the same time.
	always @(*) begin
		if (~nr)
			val = 1'b0;
		else if (s)
			val = 1'b1;
	end

	assign q = val;

endmodule // seq_rs_latch

module seq_latchr_comp ( q, d, res, clk, cclk, ld, nld);

	output q;
	input d;
	input res;
	input clk;
	input cclk;
	input ld;
	input nld;

	reg val_in;
	reg val_out;
	initial val_in = 1'bx;
	initial val_out = 1'bx;

	always @(*) begin
		if (clk && ld)
			val_in = d;
		if (res)
			val_in = 1'b0;
	end

	always @(negedge ld) begin
		val_out <= val_in;
	end

	assign q = val_out;

endmodule // seq_latchr_comp

module seq_nand ( a, b, x );
	
	input a;
	input b;
	output x;

	assign x = ~(a&b);

endmodule // seq_nand

module seq_nand3 ( a, b, c, x );

	input a;
	input b;
	input c;
	output x;

	assign x = ~(a&b&c);

endmodule // seq_nand3

module seq_nor4 ( a, b, c, d, x );

	input a;
	input b;
	input c;
	input d;
	output x;

	assign x = ~(a|b|c|d);

endmodule // seq_nor4

module seq_aoi_21 ( a0, a1, b, x );

	input a0;
	input a1;
	input b;
	output x;

	assign x = ~( (a0&a1) | b);

endmodule // seq_aoi_21

// Regular transparent latch (dual rails)
module seq_latch_comp ( d, clk, cclk, nq );

	input d;
	input clk;
	input cclk;
	output nq;

	reg val;
	initial val = 1'b0;

	always @(*) begin
		if (clk)
			val = d;
	end

	assign nq = ~val;

endmodule // seq_latch_comp

module seq_aoi_22_dyn ( clk, a0, a1, b0, b1, x );

	input clk;
	input a0;
	input a1;
	input b0;
	input b1;
	output x;

	assign x = clk ? ~( (a0&a1) | (b0&b1) ) : 1'b1;

endmodule // seq_aoi_22_dyn

module seq_aoi_221_dyn ( clk, a0, a1, b0, b1, c, x );

	input clk;
	input a0;
	input a1;
	input b0;
	input b1;
	input c;
	output x;

	assign x = clk ? ~( (a0&a1) | (b0&b1) | c) : ~c;

endmodule // seq_aoi_221_dyn

// Here we do not use GekkioNames on purpose, so that we can make cross checks without engagement.

module Decoder1 (CLK2, a, d);

	input CLK2;
	input [25:0] a;
	output [106:0] d;

	assign d[0] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[10]&a[13]&a[14]&a[17]&a[18]&a[20]&a[23]&a[24]) : 1'b1);
	assign d[1] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[11]&a[13]&a[14]&a[17]&a[18]&a[20]&a[23]&a[24]) : 1'b1);
	assign d[2] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[11]&a[13]&a[14]&a[17]&a[18]&a[20]&a[23]&a[25]) : 1'b1);
	assign d[3] = ~(CLK2 ? ~(a[0]&a[2]&((a[5]&a[6])|(a[5]&a[7]&a[15]&a[17]&a[18]))) : 1'b1);
	assign d[4] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&a[14]&a[17]&a[18]&a[22]&a[25]) : 1'b1);
	assign d[5] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&a[15]&a[16]&a[18]&a[22]&a[25]) : 1'b1);
	assign d[6] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&a[14]&a[16]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[7] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[9]&a[14]&a[16]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[8] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[11]&a[12]&a[14]&a[18]) : 1'b1);
	assign d[9] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&((a[10]&a[13]&a[15]&a[16])|(a[15]&a[16]&a[18]))&a[20]&a[22]&a[24]) : 1'b1);
	assign d[10] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&((a[10]&a[13]&a[15]&a[16])|(a[15]&a[16]&a[18]))&a[20]&a[22]&a[25]) : 1'b1);
	assign d[11] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&((a[10]&a[13]&a[15]&a[16])|(a[15]&a[16]&a[18]))&a[20]&a[23]&a[24]) : 1'b1);
	assign d[12] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&((a[10]&a[13]&a[15]&a[16])|(a[15]&a[16]&a[18]))&a[20]&a[23]&a[25]) : 1'b1);
	assign d[13] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&((a[10]&a[13]&a[15]&a[16])|(a[15]&a[16]&a[18]))&a[21]&a[22]&a[24]) : 1'b1);
	assign d[14] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[15]&a[17]&a[18]) : 1'b1);
	assign d[15] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[15]&a[17]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[16] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&((a[13])|(a[10])|(a[8]))&a[15]&a[17]&a[18]&a[22]&a[25]) : 1'b1);
	assign d[17] = ~(CLK2 ? ~(a[0]&a[2]&a[21]&a[23]&a[24]) : 1'b1);
	assign d[18] = ~(CLK2 ? ~(a[2]&a[21]&a[23]&a[25]) : 1'b1);
	assign d[19] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&((a[9]&a[14]&a[16]&a[18])|(a[8]&a[11]&a[13]&a[14]&a[16]&a[18]))&a[22]&a[25]) : 1'b1);
	assign d[20] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&((a[9]&a[14]&a[16]&a[18])|(a[8]&a[11]&a[13]&a[14]&a[16]&a[18]))&a[22]&a[24]) : 1'b1);
	assign d[21] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[10]&a[13]&a[14]&a[16]&a[18]&a[20]&a[23]&a[24]) : 1'b1);
	assign d[22] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[11]&a[13]&a[14]&a[16]&a[18]&a[23]&a[24]) : 1'b1);
	assign d[23] = ~(CLK2 ? ~(a[0]&a[3]&a[5]&a[6]&((a[14])|(a[16])|(a[19]))&a[22]&a[24]) : 1'b1);
	assign d[24] = ~(CLK2 ? ~(a[0]&a[3]&a[5]&a[6]&a[15]&a[17]&a[18]&a[22]&a[25]) : 1'b1);
	assign d[25] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[8]&a[15]&a[17]&a[19]) : 1'b1);
	assign d[26] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[13]&a[14]&a[17]&a[18]&a[22]&a[25]) : 1'b1);
	assign d[27] = ~(CLK2 ? ~(a[0]&a[3]&a[4]&a[7]) : 1'b1);
	assign d[28] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[12]&a[14]&a[17]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[29] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[13]&a[14]&a[17]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[30] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[10]&a[12]&a[14]&a[17]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[31] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[10]&a[12]&a[14]&a[16]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[32] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[10]&a[12]&a[14]&a[16]&a[18]&a[22]&a[25]) : 1'b1);
	assign d[33] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&((a[7]&a[8])|(a[7]&a[10])|(a[7]&a[13]))&a[15]&a[17]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[34] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[15]&a[17]&a[19]&a[20]) : 1'b1);
	assign d[35] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[13]&a[14]&a[16]&a[19]&a[24]) : 1'b1);
	assign d[36] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[13]&a[14]&a[17]&a[19]&a[22]&a[24]) : 1'b1);
	assign d[37] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[12]&a[14]&a[17]&a[19]&a[22]&a[24]) : 1'b1);
	assign d[38] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[12]&a[15]&a[16]&a[19]&a[22]&a[25]) : 1'b1);
	assign d[39] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[12]&a[15]&a[16]&a[19]&a[22]&a[24]) : 1'b1);
	assign d[40] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[7]&((a[8])|(a[10])|(a[13]))&((a[19])|(a[16])|(a[14]))&a[20]) : 1'b1);
	assign d[41] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[7]) : 1'b1);
	assign d[42] = ~(CLK2 ? ~(a[0]&a[3]&a[4]&a[6]) : 1'b1);
	assign d[43] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&((a[10]&a[12]&a[14]&a[17])|(a[14]&a[17]&a[18]))&a[22]&a[24]) : 1'b1);
	assign d[44] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&((a[10]&a[12]&a[14]&a[17])|(a[14]&a[17]&a[18]))&a[22]&a[25]) : 1'b1);
	assign d[45] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&((a[10]&a[12]&a[14]&a[17])|(a[14]&a[17]&a[18]))&a[23]&a[24]) : 1'b1);
	assign d[46] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[13]&a[14]&a[16]&a[19]&a[22]&a[25]) : 1'b1);
	assign d[47] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[9]&a[11]&a[12]&a[15]&a[17]&a[18]&a[22]&a[25]) : 1'b1);
	assign d[48] = ~(CLK2 ? ~(a[24]&a[25]) : 1'b1);
	assign d[49] = ~(CLK2 ? ~(a[24]&a[25]) : 1'b1);
	assign d[50] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[12]&a[15]&a[16]&a[19]&a[23]&a[24]) : 1'b1);
	assign d[51] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[12]&a[14]&a[16]&a[19]&a[22]&a[24]) : 1'b1);
	assign d[52] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[12]&a[14]&a[16]&a[19]&a[22]&a[25]) : 1'b1);
	assign d[53] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[10]&a[13]&a[14]&a[16]&a[18]&a[20]&a[22]&a[25]) : 1'b1);
	assign d[54] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[11]&a[13]&a[14]&a[16]&a[18]&a[22]&a[25]) : 1'b1);
	assign d[55] = ~(CLK2 ? ~(a[0]&a[3]&a[5]&a[7]&((a[14])|(a[16])|(a[19]))&a[22]&a[24]) : 1'b1);
	assign d[56] = ~(CLK2 ? ~(a[0]&a[3]&a[5]&a[7]&a[15]&a[17]&a[18]&a[22]&a[25]) : 1'b1);
	assign d[57] = ~(CLK2 ? ~(a[0]&a[3]&a[5]&a[15]&a[17]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[58] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[12]&a[14]&a[16]&a[19]&a[23]&a[24]) : 1'b1);
	assign d[59] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[11]&a[12]&a[14]&a[16]&a[18]&a[22]&a[25]) : 1'b1);
	assign d[60] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[8]&a[10]&a[13]&a[14]&a[16]&a[18]&a[20]&a[23]&a[24]) : 1'b1);
	assign d[61] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[8]&a[10]&a[13]&a[14]&a[16]&a[18]&a[20]&a[22]&a[24]) : 1'b1);
	assign d[62] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[11]&a[13]&a[14]&a[16]&a[19]&a[22]&a[24]) : 1'b1);
	assign d[63] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[10]&a[13]&a[14]&a[16]&a[18]&a[20]&a[22]&a[24]) : 1'b1);
	assign d[64] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[10]&a[13]&a[14]&a[16]&a[18]&a[20]&a[23]&a[25]) : 1'b1);
	assign d[65] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[11]&a[13]&a[14]&a[16]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[66] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[8]&a[10]&a[13]&a[14]&a[16]&a[18]&a[20]&a[23]&a[25]) : 1'b1);
	assign d[67] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[8]&a[10]&a[13]&a[14]&a[16]&a[18]&a[20]&a[22]&a[25]) : 1'b1);
	assign d[68] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[7]&a[9]&a[11]&a[12]&((a[19])|(a[16])|(a[14]))&a[22]&a[24]) : 1'b1);
	assign d[69] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[9]&a[11]&a[12]&a[15]&a[16]&a[22]&a[24]) : 1'b1);
	assign d[70] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[9]&a[11]&a[12]&a[15]&a[16]&a[22]&a[25]) : 1'b1);
	assign d[71] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[11]&a[12]&a[14]&a[17]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[72] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[11]&a[12]&a[14]&a[16]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[73] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[15]&a[17]&a[19]&a[22]&a[25]) : 1'b1);
	assign d[74] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[15]&a[17]&a[19]&a[22]&a[24]) : 1'b1);
	assign d[75] = ~(CLK2 ? ~(a[1]&a[2]&a[21]&a[22]&a[25]) : 1'b1);
	assign d[76] = ~(CLK2 ? ~(a[1]&a[2]&a[21]&a[22]&a[24]) : 1'b1);
	assign d[77] = ~(CLK2 ? ~(a[1]&a[2]&a[20]&a[22]&a[24]) : 1'b1);
	assign d[78] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[6]&((a[16])|(a[14])|(a[19]))&a[20]) : 1'b1);
	assign d[79] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&a[13]&a[14]&a[16]&a[19]&a[22]&a[24]) : 1'b1);
	assign d[80] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&a[14]&a[16]&a[18]&a[22]&a[25]) : 1'b1);
	assign d[81] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[10]&a[13]&a[14]&a[16]&a[19]&a[20]) : 1'b1);
	assign d[82] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&((a[13]&a[14]&a[16])|(a[14]&a[16]&a[18]))&a[20]&a[23]&a[24]) : 1'b1);
	assign d[83] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&((a[13]&a[14]&a[16])|(a[14]&a[16]&a[18]))&a[20]&a[23]&a[25]) : 1'b1);
	assign d[84] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[9]&a[10]&a[14]&a[17]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[85] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[9]&a[11]&a[14]&a[17]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[86] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[12]&a[14]&a[16]&a[19]&a[22]&a[24]) : 1'b1);
	assign d[87] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[12]&a[14]&a[16]&a[19]&a[22]&a[25]) : 1'b1);
	assign d[88] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[12]&a[14]&a[16]&a[19]&a[23]&a[24]) : 1'b1);
	assign d[89] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&((a[13])|(a[10])|(a[8]))&a[15]&a[16]&a[20]) : 1'b1);
	assign d[90] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[6]&a[15]&a[17]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[91] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[15]&a[17]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[92] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[15]&a[17]&a[19]&a[23]&a[24]) : 1'b1);
	assign d[93] = ~(CLK2 ? ~(a[1]&a[2]&a[21]&a[23]&a[24]) : 1'b1);
	assign d[94] = ~(CLK2 ? ~(a[0]&a[3]&((a[19])|(a[14])|(a[16]))&a[20]) : 1'b1);
	assign d[95] = ~(CLK2 ? ~(a[0]&a[3]&a[15]&a[17]&a[18]&a[22]&a[24]) : 1'b1);
	assign d[96] = ~(CLK2 ? ~(a[0]&a[3]&a[4]&a[7]&a[15]&a[17]&a[18]&a[22]&a[25]) : 1'b1);
	assign d[97] = ~(CLK2 ? ~(a[0]&a[3]&a[6]&a[15]&a[17]&a[18]&a[22]&a[25]) : 1'b1);
	assign d[98] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[15]&a[16]) : 1'b1);
	assign d[99] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[11]&a[14]&a[17]&a[19]&a[20]) : 1'b1);
	assign d[100] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[7]&a[9]&a[11]&a[12]&a[15]&a[17]&a[18]&a[20]) : 1'b1);
	assign d[101] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&a[8]&a[12]&a[14]&a[16]&a[18]&a[20]) : 1'b1);
	assign d[102] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[8]&a[10]&a[13]&a[14]&a[17]&a[19]&a[20]) : 1'b1);
	assign d[103] = ~(CLK2 ? ~(a[0]&a[2]&a[4]&a[6]&((a[8]&a[11]&a[13]&a[14]&a[16]&a[18])|(a[9]&a[14]&a[16]&a[18]))&a[23]&a[24]) : 1'b1);
	assign d[104] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[13]&a[14]&a[17]&a[18]&a[20]&a[22]&a[24]) : 1'b1);
	assign d[105] = ~(CLK2 ? ~(a[0]&a[2]&a[5]&a[7]&a[9]&a[13]&a[14]&a[17]&a[18]&a[20]&a[22]&a[25]) : 1'b1);
	assign d[106] = ~(CLK2 ? ~(a[24]&a[25]) : 1'b1);

endmodule // Decoder1

// Here we do not use GekkioNames on purpose, so that we can make cross checks without engagement.

module Decoder2( CLK2, d, w, SeqOut_2, IR7 );

	input CLK2;
	input [106:0] d;
	output [40:0] w;
	input SeqOut_2;
	input IR7;

	// Automagically generated by MakeNorTree py 
 
	assign w[0] = ~(CLK2 ? ~((d[4]|d[5]|d[6]|d[7])) : 1'b1);
	assign w[1] = ~(CLK2 ? ~((d[0]|d[1]|w[27])) : 1'b1);
	assign w[4] = ~(CLK2 ? ~((d[0]|d[28])) : 1'b1);
	assign w[5] = ~(CLK2 ? ~((d[2]|d[26])) : 1'b1);
	assign w[6] = ~(CLK2 ? ~((d[0]|d[12]|d[13]|d[24]|d[28]|d[30]|d[32]|d[38]|d[47]|d[50]|d[56]|d[60]|d[66]|d[68]|d[70]|d[73]|d[75]|d[92]|d[93]|d[97])) : 1'b1);
	assign w[9] = ~(CLK2 ? ~((d[21]|d[22])) : 1'b1);
	assign w[10] = ~(CLK2 ? ~((d[23]|d[24])) : 1'b1);
	assign w[11] = ~(CLK2 ? ~((d[32]|d[59]|d[0]|d[1]|d[2]|d[9]|d[10]|d[12]|d[13]|d[15]|d[16]|d[17]|d[18]|d[20]|d[22]|d[23]|d[24]|d[26]|d[28]|d[29]|d[30]|d[31]|d[33]|d[34]|d[38]|d[40]|d[43]|d[44]|d[46]|d[47]|d[50]|d[51]|d[52]|d[55]|d[56]|d[57]|d[58]|d[60]|d[61]|d[63]|d[64]|d[65]|d[66]|d[67]|d[68]|d[69]|d[70]|d[71]|d[72]|d[73]|d[75]|d[78]|d[79]|d[80]|d[81]|d[82]|d[86]|d[87]|d[88]|d[89]|d[90]|d[91]|d[92]|d[93]|d[94]|d[95]|d[96]|d[97]|d[99]|d[100]|d[101]|d[102]|d[103]|d[104]|d[105])) : 1'b1);
	assign w[13] = ~(CLK2 ? ~((d[28]|d[29])) : 1'b1);
	assign w[14] = ~(CLK2 ? ~((d[30]|d[32])) : 1'b1);
	assign w[16] = ~(CLK2 ? ~((d[36]|d[37])) : 1'b1);
	assign w[17] = ~(CLK2 ? ~((d[32]|d[59])) : 1'b1);
	assign w[18] = ~(CLK2 ? ~((d[1]|d[9]|d[10]|d[15]|d[20]|d[29]|d[31]|d[33]|d[43]|d[44]|d[51]|d[52]|d[57]|d[59]|d[61]|d[63]|d[65]|d[67]|d[69]|d[71]|d[72]|d[79]|d[80]|d[82]|d[86]|d[87]|d[90]|d[91]|d[95]|d[104]|d[105])) : 1'b1);
	assign w[20] = ~(CLK2 ? ~((d[0]|d[1]|d[6]|d[9]|d[11]|d[13]|d[15]|d[20]|d[21]|d[24]|d[28]|d[29]|d[30]|d[31]|d[32]|d[35]|d[36]|d[37]|d[39]|d[43]|d[45]|d[47]|d[50]|d[51]|d[56]|d[57]|d[60]|d[61]|d[62]|d[63]|d[65]|d[66]|d[68]|d[69]|d[70]|d[72]|d[74]|d[76]|d[82]|d[83]|d[86]|d[92]|d[93]|d[95]|d[97]|d[104])) : 1'b1);
	assign w[22] = ~(CLK2 ? ~((d[24]|d[33]|d[47]|d[56]|d[57]|d[62]|d[68]|d[69]|d[70]|d[81]|d[90]|d[95]|d[97])) : 1'b1);
	assign w[23] = ~(CLK2 ? ~((d[53]|d[54])) : 1'b1);
	assign w[24] = ~(CLK2 ? ~((d[55]|d[56])) : 1'b1);
	assign w[25] = ~(CLK2 ? ~((d[2]|d[9]|d[10]|d[15]|d[16]|d[17]|d[18]|d[20]|d[22]|d[23]|d[26]|d[31]|d[34]|d[40]|d[43]|d[44]|d[46]|d[55]|d[58]|d[61]|d[63]|d[64]|d[65]|d[67]|d[72]|d[77]|d[78]|d[86]|d[87]|d[88]|d[89]|d[91]|d[94]|d[96]|d[99]|d[100]|d[101]|d[102]|d[104]|d[105])) : 1'b1);
	assign w[26] = ~(CLK2 ? ~((d[2]|d[16]|d[17]|d[18]|d[22]|d[23]|d[26]|d[34]|d[40]|d[46]|d[55]|d[58]|d[64]|d[78]|d[81]|d[88]|d[89]|d[94]|d[96]|d[99]|d[100]|d[101]|d[102]|d[103])) : 1'b1);
	assign w[27] = ~(CLK2 ? ~((d[60]|d[66])) : 1'b1);
	assign w[28] = ~(CLK2 ? ~((d[12]|d[73]|d[75])) : 1'b1);
	assign w[29] = ~(CLK2 ? ~((d[30]|d[71])) : 1'b1);
	assign w[30] = ~(CLK2 ? ~((d[11]|d[12]|d[13]|d[38]|d[39]|d[50]|d[51]|d[52]|d[73]|d[74]|d[75]|d[76]|d[79]|d[80]|d[82]|d[92]|d[93])) : 1'b1);
	assign w[31] = ~(CLK2 ? ~((d[2]|d[9]|d[10]|d[15]|d[16]|d[17]|d[18]|d[20]|d[22]|d[23]|d[26]|d[31]|d[34]|d[37]|d[40]|d[43]|d[44]|d[46]|d[51]|d[52]|d[55]|d[58]|d[60]|d[61]|d[63]|d[64]|d[65]|d[67]|d[72]|d[78]|d[79]|d[80]|d[81]|d[82]|d[84]|d[86]|d[87]|d[88]|d[89]|d[91]|d[94]|d[96]|d[99]|d[101]|d[102]|d[103]|d[104]|d[105])) : 1'b1);
	assign w[32] = ~(CLK2 ? ~((d[0]|d[12]|d[13]|d[24]|d[28]|d[30]|d[32]|d[33]|d[36]|d[37]|d[45]|d[47]|d[50]|d[56]|d[59]|d[62]|d[66]|d[68]|d[70]|d[71]|d[75]|d[76]|d[77]|d[83]|d[90]|d[91]|d[92]|d[93]|d[97])) : 1'b1);
	assign w[33] = ~(CLK2 ? ~((d[0]|d[1]|d[10]|d[11]|d[13]|d[19]|d[21]|d[24]|d[28]|d[30]|d[32]|d[33]|d[36]|d[37]|d[38]|d[44]|d[45]|d[47]|d[50]|d[52]|d[53]|d[54]|d[56]|d[59]|d[60]|d[62]|d[66]|d[67]|d[68]|d[70]|d[71]|d[73]|d[75]|d[79]|d[80]|d[82]|d[83]|d[87]|d[90]|d[91]|d[92]|d[93]|d[97]|d[105])) : 1'b1);
	assign w[34] = ~(CLK2 ? ~((d[13]|d[92]|d[93])) : 1'b1);
	assign w[35] = ~(CLK2 ? ~((d[11]|d[12]|d[36]|d[38]|d[39]|d[73]|d[74]|d[75]|d[76]|d[77]|d[85])) : 1'b1);
	assign w[36] = ~(CLK2 ? ~((d[13]|d[45]|d[83])) : 1'b1);
	assign w[38] = ~(CLK2 ? ~((d[2]|d[13]|d[16]|d[17]|d[22]|d[23]|d[26]|d[28]|d[29]|d[34]|d[35]|d[36]|d[37]|d[38]|d[40]|d[45]|d[46]|d[50]|d[53]|d[54]|d[55]|d[58]|d[62]|d[68]|d[70]|d[78]|d[81]|d[88]|d[89]|d[92]|d[93]|d[94]|d[96]|d[97]|d[99]|d[100]|d[101])) : 1'b1);

	// Does not use NOR tree

	assign w[2] = d[103];
	assign w[3] = d[3];
	assign w[7] = ~IR7;			// Not used
	assign w[8] = d[19];
	assign w[12] = d[27];
	assign w[15] = d[35];
	assign w[19] = d[46];
	assign w[21] = d[50];
	assign w[37] = d[98];
	assign w[39] = ~SeqOut_2;
	assign w[40] = w[18] & w[39];

endmodule // Decoder2

// Here we do not use GekkioNames on purpose, so that we can make cross checks without engagement.

module Decoder3( CLK2, CLK4, CLK5, nCLK4, a3, d, w, x, IR, nIR, SeqOut_2 );

	input CLK2;
	input CLK4;
	input CLK5;		// Affects x55
	input nCLK4;		// Affects x57
	
	input a3;
	input [106:0] d;
	input [40:0] w;
	output [68:0] x;
	input [7:0] IR;
	input [5:0] nIR;
	input SeqOut_2;

	// Automagically generated by MakeNandTree py
	// Hand-corrected in places
 
	assign x[0] = ~(CLK2 ? ~((nIR[3]&x[20]) | (nIR[3]&nIR[4]&x[17])) : 1'b1);
	assign x[1] = ~(CLK2 ? ~((IR[3]&x[20]) | (IR[3]&x[17])) : 1'b1);
	assign x[2] = ~(CLK2 ? ~((w[24]) | (IR[5]&IR[4]&nIR[3]&w[3])) : 1'b1);
	assign x[3] = ~(CLK2 ? ~((x[10]) | (w[37]) | (x[11]) | (w[8]) | (w[9]) | (x[22]) | (w[23])) : 1'b1);
	assign x[4] = ~(CLK2 ? ~((w[5]) | (d[8]) | (d[41]) | (x[2]) | (d[14]) | (x[26])) : 1'b1);
	assign x[5] = ~(CLK2 ? ~((x[20]&nIR[3]&nIR[4])) : 1'b1);
	assign x[6] = ~(CLK2 ? ~((x[20]&nIR[3]&IR[4])) : 1'b1);
	assign x[7] = ~(CLK2 ? ~((x[20]&IR[3]&nIR[4])) : 1'b1);
	assign x[8] = ~(CLK2 ? ~((x[20]&IR[3]&IR[4])) : 1'b1);
	assign x[9] = ~(CLK2 ? ~((x[17]&IR[3]&nIR[4])) : 1'b1);
	assign x[10] = ~(CLK2 ? ~((w[23]) | (w[15]) | (w[19]) | (x[23])) : 1'b1);
	assign x[11] = ~(CLK2 ? ~((x[27]) | (x[24])) : 1'b1);
	assign x[12] = ~(CLK2 ? ~((x[24]) | (x[27]) | (IR[0]&w[37])) : 1'b1);
	assign x[13] = ~(CLK2 ? ~((d[58]) | (d[88]) | (w[16])) : 1'b1);
	assign x[14] = ~(CLK2 ? ~((d[41]) | (d[14]) | (w[37])) : 1'b1);

	// CLK4 [!]
	assign x[15] = ~(CLK4 ? ~((w[6]&d[41]) | (w[6]&w[4]) | (w[6]&d[14]) | (w[6]&d[38]) | (w[6]&w[14]) | (w[6]&w[21])) : 1'b1);

	assign x[16] = ~(CLK2 ? ~((x[17]&nIR[3]&IR[4])) : 1'b1);
	assign x[17] = ~(CLK2 ? ~((d[42]&IR[5])) : 1'b1);
	assign x[18] = ~(CLK2 ? ~((w[3]&IR[3]&nIR[4]&IR[5])) : 1'b1);
	assign x[19] = ~(CLK2 ? ~((w[10]) | (nIR[3]&nIR[4]&IR[5]&w[3])) : 1'b1);
	assign x[20] = ~(CLK2 ? ~((d[25]) | (d[42]&nIR[5])) : 1'b1);
	assign x[21] = ~(CLK2 ? ~((d[34]&IR[4]&IR[5])) : 1'b1);
	assign x[22] = ~(CLK2 ? ~((d[34]&nIR[3]&nIR[4]&IR[5])) : 1'b1);
	assign x[23] = ~(CLK2 ? ~((w[3]&nIR[4]&nIR[5])) : 1'b1);
	assign x[24] = ~(CLK2 ? ~((w[3]&IR[4]&nIR[5])) : 1'b1);
	assign x[25] = ~(CLK2 ? ~((w[12]) | (x[24]) | (x[26]) | (x[27])) : 1'b1);
	assign x[26] = ~(CLK2 ? ~((d[34]&IR[3]&nIR[4]&IR[5])) : 1'b1);
	assign x[27] = ~(CLK2 ? ~((w[3]&IR[3]&IR[4]&IR[5])) : 1'b1);

	// CLK4 [!]
	assign x[28] = ~(CLK4 ? ~((d[34]&w[38]) | (d[42]&w[38]) | (w[3]&w[38]) | (IR[4]&IR[5]&d[58]&w[38]) | (x[10]&w[38])) : 1'b1);
	assign x[29] = ~(CLK4 ? ~((w[12]&w[38]) | (x[28]&w[38]) | (w[37]&w[38])) : 1'b1);

	assign x[30] = ~(CLK2 ? ~((w[9]&nIR[4])) : 1'b1);
	assign x[31] = ~(CLK2 ? ~((w[23]&nIR[4])) : 1'b1);
	assign x[32] = ~(CLK2 ? ~((d[34]&nIR[4]) | (d[34]&nIR[5])) : 1'b1);
	assign x[33] = ~(CLK2 ? ~((IR[0]&w[37])) : 1'b1);
	assign x[34] = ~(CLK2 ? ~((w[3]) | (d[41]) | (a3)) : 1'b1);
	assign x[35] = ~(CLK2 ? ~((x[34]&IR[0]&IR[1]&IR[2]) | (w[14]) | (w[4]) | (w[37]&IR[3]&IR[4]&IR[5]) | (d[38]&IR[4]&IR[5]) | (x[32])) : 1'b1);
	assign x[36] = ~(CLK2 ? ~((d[42]) | (w[10]) | (w[24])) : 1'b1);

	// CLK4 [!]
	assign x[37] = ~(CLK4 ? ~((w[8]) | (w[6]&d[42]) | (w[6]&w[10]) | (w[6]&w[37]) | (w[6]&w[24]) | (x[30]) | (x[31])) : 1'b1);
	assign x[38] = ~(CLK4 ? ~((x[32]&w[38]) | (x[36]&IR[0]&IR[1]&IR[2]&w[38]) | (w[38]&d[8]) | (w[38]&w[5]) | (w[38]&x[14]&IR[3]&IR[4]&IR[5]) | (w[38]&d[58]&IR[4]&IR[5]) | (w[38]&w[3]&nIR[5]) | (w[38]&w[3]&nIR[4]) | (w[38]&w[3]&nIR[3])) : 1'b1);
	assign x[39] = ~(CLK4 ? ~((IR[5]&w[13]&w[38]) | (x[36]&nIR[0]&nIR[1]&IR[2]&w[38]) | (w[38]&x[64]) | (w[38]&w[19]) | (w[38]&x[14]&nIR[3]&nIR[4]&IR[5]) | (w[38]&x[13]&nIR[4]&IR[5])) : 1'b1);
	assign x[40] = ~(CLK4 ? ~((IR[5]&w[13]&w[38]) | (x[36]&IR[0]&nIR[1]&IR[2]&w[38]) | (w[38]&x[66]) | (w[38]&w[15]) | (w[38]&x[14]&IR[3]&nIR[4]&IR[5]) | (w[38]&x[13]&nIR[4]&IR[5])) : 1'b1);

	assign x[41] = ~(CLK2 ? ~((d[83]&IR[0]&IR[4])) : 1'b1);
	assign x[42] = ~(CLK2 ? ~((w[13]&IR[5]) | (w[16]&nIR[4]&IR[5]) | (w[22])) : 1'b1);
	assign x[43] = ~(CLK2 ? ~((x[34]&nIR[0]&nIR[1]&IR[2]) | (IR[5]&nIR[4]&d[38]) | (IR[5]&nIR[4]&w[19]) | (IR[5]&nIR[4]&nIR[3]&w[37])) : 1'b1);
	assign x[44] = ~(CLK2 ? ~((x[34]&IR[0]&nIR[1]&IR[2]) | (IR[5]&nIR[4]&w[21]) | (IR[5]&nIR[4]&w[15]) | (IR[5]&nIR[4]&IR[3]&w[37])) : 1'b1);
	assign x[45] = ~(CLK2 ? ~((IR[4]&nIR[5]&w[16]) | (IR[4]&nIR[5]&w[13])) : 1'b1);
	assign x[46] = ~(CLK2 ? ~((x[34]&nIR[0]&IR[1]&nIR[2]) | (nIR[5]&IR[4]&d[38]) | (nIR[5]&IR[4]&w[19]) | (nIR[5]&IR[4]&nIR[3]&w[37])) : 1'b1);
	assign x[47] = ~(CLK2 ? ~((x[34]&IR[0]&IR[1]&nIR[2]) | (nIR[5]&IR[4]&w[21]) | (nIR[5]&IR[4]&w[15]) | (nIR[5]&IR[4]&IR[3]&w[37])) : 1'b1);
	
	// CLK4 [!]
	assign x[48] = ~(CLK4 ? ~((x[36]&nIR[0]&IR[1]&nIR[2]&w[38]) | (IR[4]&nIR[5]&x[13]&w[38]) | (IR[4]&nIR[5]&x[14]&nIR[3]&w[38])) : 1'b1);
	assign x[49] = ~(CLK4 ? ~((x[36]&nIR[0]&nIR[1]&nIR[2]&w[38]) | (nIR[4]&nIR[5]&x[13]&w[38]) | (nIR[4]&nIR[5]&x[14]&nIR[3]&w[38])) : 1'b1);
	assign x[50] = ~(CLK4 ? ~((x[36]&IR[0]&IR[1]&nIR[2]&w[38]) | (IR[4]&nIR[5]&x[13]&w[38]) | (IR[4]&nIR[5]&x[14]&IR[3]&w[38])) : 1'b1);
	assign x[51] = ~(CLK4 ? ~((x[36]&IR[0]&nIR[1]&nIR[2]&w[38]) | (nIR[4]&nIR[5]&x[13]&w[38]) | (nIR[4]&nIR[5]&x[14]&IR[3]&w[38])) : 1'b1);

	assign x[52] = ~(CLK2 ? ~((w[29]) | (nIR[4]&nIR[5]&w[13]) | (nIR[4]&nIR[5]&w[16])) : 1'b1);
	assign x[53] = ~(CLK2 ? ~((x[34]&nIR[0]&nIR[1]&nIR[2]) | (nIR[4]&nIR[5]&d[38]) | (nIR[4]&nIR[5]&w[19]) | (nIR[4]&nIR[5]&nIR[3]&w[37])) : 1'b1);
	assign x[54] = ~(CLK2 ? ~((x[34]&IR[0]&nIR[1]&nIR[2]) | (nIR[4]&nIR[5]&w[21]) | (nIR[4]&nIR[5]&w[15]) | (nIR[4]&nIR[5]&IR[3]&w[37])) : 1'b1);

	// CLK4 for x56, x55 affected by CLK5, x57 affected by nCLK4 [!]
	assign x[55] = ~( (CLK2 ? ~((w[13]) | (w[16])) : 1'b1) | CLK5 );
	assign x[56] = ~(CLK4 ? ~((d[58]) | (d[88])) : 1'b1);
	assign x[57] = ~( (CLK2 ? ~((d[42]) | (x[64]) | (x[66]) | (w[5]) | (d[8]) | (w[15]) | (w[19]) | (x[14]) | (w[10]) | (w[24]) | (x[32]) | (w[3])) : 1'b1) | nCLK4 );

	assign x[58] = ~(CLK2 ? ~((w[8]) | (nIR[3]&IR[4]&IR[5]&w[37]) | (w[23]) | (d[8]) | (w[5]) | (d[14]) | (x[34]&nIR[0]&IR[1]&IR[2])) : 1'b1);
	assign x[59] = ~(CLK2 ? ~((x[30]) | (d[60]) | (w[18]&SeqOut_2) | (w[8])) : 1'b1);
	assign x[60] = ~(CLK2 ? ~((w[8]) | (w[17]) | (w[39]&w[18]) | (d[60]) | (x[31])) : 1'b1);
	assign x[61] = ~(CLK2 ? ~((x[62]) | (x[63])) : 1'b1);
	assign x[62] = ~(CLK2 ? ~((w[16]&IR[4]&IR[5]) | (w[30]) | (d[62])) : 1'b1);
	assign x[63] = ~(CLK2 ? ~((d[88]&IR[4]&IR[5]) | (d[64])) : 1'b1);
	assign x[64] = ~(CLK2 ? ~((w[9]&IR[4])) : 1'b1);
	assign x[65] = ~(CLK2 ? ~((w[30]) | (w[16]&IR[4]&IR[5])) : 1'b1);
	assign x[66] = ~(CLK2 ? ~((w[23]&IR[4])) : 1'b1);
	assign x[67] = ~(CLK2 ? ~((d[81]) | (w[25]) | (w[2])) : 1'b1);
	assign x[68] = ~(CLK2 ? ~((d[93]) | (d[92]) | (w[36]) | (x[67])) : 1'b1);

endmodule // Decoder3

module IRNots (IR, nIR);

	input [7:0] IR;
	output [5:0] nIR;

	assign nIR = ~IR[5:0];
	
endmodule // IRNots

// This circuit combines two functions - generating control signals for the IDU and generating an IE load command for the IRQ logic.
// We will not distribute the functionality among the modules in order to be authentic to the SM83 topology. We will leave the architectural solution as an appendix to the developers of the SM83.

module Thingy ( w8, w31, w35, ALU_to_Thingy, WR, Temp_Z, TTB1, TTB2, TTB3, Thingy_to_bot, bot_to_Thingy );

	input w8; 			// Gekkio: s2_op_jr_any_sx01
	input w31; 			// Gekkio: s2_idu_inc
	input w35; 				// Gekkio: s2_idu_dec
	input ALU_to_Thingy;
	input WR;
	input Temp_Z;		// Flag Z from temp Z register (zbus[7])
	output TTB1;		// 1: Perform pairwise increment/decrement (simultaneously for two 8-bit IncDec halves)
	output TTB2;		// 1: Perform decrement
	output TTB3;		// 1: Perform increment
	input bot_to_Thingy;		// IE access detected (Address = 0xffff)
	output Thingy_to_bot;		// Load a value into the IE register from the DL bus.	

	wire t1;
	wire t2;

	assign t1 = ~(w8 & ALU_to_Thingy & ~Temp_Z);
	assign t2 = ~(w8 & ~ALU_to_Thingy & Temp_Z);
	assign TTB1 = ~(t1 & t2);
	assign TTB2 = ~(~w35 & t2);
	assign TTB3 = ~(~w31 & t1);
	assign Thingy_to_bot = bot_to_Thingy & WR;

endmodule // Thingy

module DataMux ( CLK, DL_Control1, DL_Control2, DataBus, DL, Res, DataOut, DV, RD_hack, WR_hack);

	input CLK; 				// CLK2
	input DL_Control1;			// 1: Bus disable  (External Test1 aka BUS_DISABLE)
	input DL_Control2;			// x37. ALU Result -> DL; Gekkio: s3_oe_alu_to_pbus
	inout [7:0] DataBus;		// External databus
	/* verilator lint_off UNOPTFLAT */
	inout [7:0] DL;				// Internal databus
	input [7:0] Res;			// ALU Result  (always driven)
	input DataOut;			// x15. DV -> DL; Gekkio: s3_oe_rbus_to_pbus
	input [7:0] DV;			// ALU Operand2	

	// HACK: These signals are not present in the original circuit, but are
	// need when simulating it without resorting to driving strength.
	input RD_hack;
	input WR_hack;

	data_mux_bit dmux [7:0] (
		.clk({8{CLK}}), 
		.Test1({8{DL_Control1}}), 
		.Res_to_DL({8{DL_Control2}}), 
		.Res(Res), 
		.Int_bus(DL), 
		.Ext_bus(DataBus),
		.DataOut({8{DataOut}}),
		.dv_bit(DV),
		.RD_hack(RD_hack),
		.WR_hack(WR_hack) );

endmodule // DataMux

// A combined schematic that combines the two bits of what used to be called DataLatch and DataBridge.
module data_mux_bit ( clk, Test1, Res_to_DL, Res, Int_bus, Ext_bus, DataOut, dv_bit, RD_hack, WR_hack);
	
	input clk;  		// CLK2; All buses are precharged when clk=0.
	input Test1; 			// External (1: disconnect core databus)
	input Res_to_DL; 		// ALU result -> internal databus  (from decoder3); Gekkio: s3_oe_alu_to_pbus
	input Res; 				// ALU result
	inout Int_bus; 		// DL[n] (internal databus)
	inout Ext_bus; 		// D[n] (external databus)
	input dv_bit;
	input DataOut;	 		// Gekkio: s3_oe_rbus_to_pbus
	input RD_hack;
	input WR_hack;

	wire int_to_ext_q; 		// transparent latch to keep DL bus
	wire ext_to_int_q; 		// transparent latch to keep external databus
	wire res_q;			// transparent latch to keep ALU result; is not required at all, because the bus Res is always output, but let it be
	wire dv_q; 			// transparent latch to keep DV bus

	BusKeeper int_to_ext ( .d(Int_bus), .q(int_to_ext_q) );
	BusKeeper ext_to_int ( .d(Ext_bus), .q(ext_to_int_q) );
	BusKeeper res_latch ( .d(Res), .q(res_q) );
	BusKeeper dv_latch ( .d(dv_bit), .q(dv_q) );

	// ⚠️This implementation is an approximation of the real circuit, so it is
	// not a die-perfect approach.
	//
	// An analysis of the real circuit reveals that the buses may be driven by
	// multiple sources at the same time, causing conflicts. The mechanism
	// that resolves these conflicts in the real circuit is unclear, but
	// making all external buses have a stronger driving strength than
	// internal buses seems to work.
	// 
	// We also assume that the `clk` signal, which appears to pre-charge the
	// buses, has a stronger driving strength than the other signals
	// (otherwise there will also be internal conflicts).
	//
	// And to simulate the pre-charge effect, we have a weak pull-up on the
	// buses, that makes it resolve to 1 when no other signal is driving the
	// bus.

	// // DataLatch logic
	// assign Ext_bus = (clk || Test1) ? 1'bz : 1;
	// assign(pull0, pull1) Ext_bus = clk && ~(int_to_ext_q || Test1) ? 0 : 1'bz;
	//
	// assign Int_bus = clk ? 1'bz : 1;
	// assign(pull0, pull1) Int_bus = clk && ~(Test1 || ext_to_int_q) ? 0 : 1'bz;
	// assign(pull0, pull1) Int_bus = (Res_to_DL && ~Res) ? 0 : 1'bz;
	//
	// // DataBridge logic
	// assign(pull0, pull1) Int_bus = (~dv_q) ? (DataOut ? 0 : 1'bz) : 1'bz;
	//
	// // Drive DL and D buses up with weak strength to simulate the pre-charge.
	// assign (weak0, weak1) Ext_bus = 1;
	// assign (weak0, weak1) Int_bus = 1;

	// The logic above can also be expressed, in a higher level, as:

	assign Ext_bus = ~clk ? 1'b1
			: RD_hack && ~WR_hack ? 1'bz
			: ~RD_hack && WR_hack ? int_to_ext_q
			: 1'b1;

	assign Int_bus = ~clk ? 1'b1
			: Res_to_DL ? res_q
			: RD_hack && ~WR_hack ? ext_to_int_q
			: ~RD_hack && WR_hack && DataOut ? dv_q
			: ~RD_hack && WR_hack ? 1'bz
			: 1'b1;

endmodule // data_mux_bit

module ALU ( CLK2, CLK4, CLK5, CLK6, CLK7, DV, Res, AllZeros, d42, d58, w, x, bc, alu, bq4, bq5, bq7, ALU_to_Thingy,
	Temp_C, Temp_H, Temp_N, Temp_Z, ALU_Out1, IR, nIR );

	input CLK2;
	input CLK4;			// Used as LoadEnable for ALU_to_bot latch.
	input CLK5;
	input CLK6;
	input CLK7;

	input [7:0] DV; 		// ALU Operand2
	output [7:0] Res; 		// ALU Result
	input AllZeros;			// Res == 0
	input d42; 			// Gekkio: s1_cb_00_to_3f
	input d58; 			// Gekkio: s1_op_pop_sx10
	input [40:0] w;		// Decoder2 outputs
	input [68:0] x;		// Decoder3 outputs
	output [5:0] bc;
	input [7:0] alu;		// ALU Operand1
	input bq4;
	input bq5;
	input bq7;
	output ALU_to_Thingy; 		// ALU Carry Out
	input Temp_C;		// Flag C from temp Z register  (zbus[4])
	input Temp_H;		// Flag H from temp Z register  (zbus[5])
	input Temp_N;		// Flag N from temp Z register    (zbus[6])
	input Temp_Z;			// Flag Z from temp Z register / zbus msb  (zbus[7])
	output ALU_Out1;
	input [7:0] IR;
	input [5:0] nIR;

	// Internal wires

	wire [7:0] e;		// Operand1 processing results for SET/RES opcodes; module2 e in
	wire [7:0] f;		// module2 f out; Optionaly complemented Operand2
	wire [7:0] ca; 		// Shifter (comb1-3) out  (active-low)
	wire [7:0] bx;		// module2 x out
	wire [7:0] bm;		// module2 m out (G-terms)
	wire [7:0] bh;		// module2 h out (P-terms)
	wire [7:0] logic_op;		// module2 w out; The result of the logical operation AND/OR/permutation of Operand2 bits.
	wire [7:0] ao; 		// G/P ands outputs to module6  (logic xor)
	wire [7:1] na; 		// CLA Carry outputs; CLA nots outputs to module6
	wire [7:0] q; 		// CLA carry complement outputs (bits 0-3: topologicaly left, bits 4-7: topologicaly right)
	wire [5:0] nbc; 	// #bc
	wire [13:0] azo;	// Random logic results
	wire ALU_to_top; 		// Carry In
	wire ALU_L0; 		// ~Carry7
	wire ALU_L3; 		// ~Carry4
	wire ALU_L5; 		// Carry4
	wire ALU_to_bot;		// Derived from zbus[7] .  As a result of the optimization and transposition of the `bc` derivation circuit, the signal became internal.

	// For debugging
	(* keep *) wire [7:0] F = {bc[3], bc[2], bc[5], bc[1], 4'h0};

	// Top part (CLA + Sum)

	module6 Sums [7:0] (
		.a({na[7:1],ALU_to_top}),
		.b(ao),
		.c({8{`s3_alu_xor}}),
		.d({8{`s3_alu_sum}}),
		.e(logic_op),
		.x(Res) );

	assign ALU_L0 = ~ALU_to_Thingy;  		// ~cout
	assign ALU_L3 = ~na[4]; 			// ~half cout
	assign ALU_L5 = na[4]; 				// half cout
	assign {ALU_to_Thingy, na[7:1]} = ~q;
	assign ao = bh & bx; 		// ands

	module5 cla_low ( .m(bm[3:0]), .h(bh[3:0]), .c(ALU_to_top), .q(q[3:0]) );
	module5 cla_high ( .m(bm[7:4]), .h(bh[7:4]), .c(na[4]), .q(q[7:4]) );

	// Middle part

	module2 GP_Terms [7:0] (
		.a(ca), 
		.b({8{`s3_alu_logic_and}}), 
		.c({8{`s3_alu_logic_or}}), 
		.e(e), 
		.f(f), 
		.g({8{`s3_alu_b_complement}}), 
		.h(bh), 
		.k(DV), 
		.m(bm), 
		.x(bx), 
		.w(logic_op) );

	// Shifter

	Comb3 bit_lsb ( .clk(CLK2), .x(ca[0]), .a({`s3_alu_rlc,DV[7]}), .b({`s3_alu_rotate_shift_right,DV[1]}), .c({`s3_alu_swap,DV[4]}), .d({`s3_alu_rl,bc[1]}) );
	Comb2 bits_mid [6:1] ( .clk({6{CLK2}}), .x(ca[6:1]), 
		.a({{`s3_alu_rotate_shift_left,DV[5]},{`s3_alu_rotate_shift_left,DV[4]},{`s3_alu_rotate_shift_left,DV[3]},{`s3_alu_rotate_shift_left,DV[2]},{`s3_alu_rotate_shift_left,DV[1]},{`s3_alu_rotate_shift_left,DV[0]}}), 
		.b({{`s3_alu_rotate_shift_right,DV[7]},{`s3_alu_rotate_shift_right,DV[6]},{`s3_alu_rotate_shift_right,DV[5]},{`s3_alu_rotate_shift_right,DV[4]},{`s3_alu_rotate_shift_right,DV[3]},{`s3_alu_rotate_shift_right,DV[2]}}), 
		.c({{`s3_alu_swap,DV[2]},{`s3_alu_swap,DV[1]},{`s3_alu_swap,DV[0]},{`s3_alu_swap,DV[7]},{`s3_alu_swap,DV[6]},{`s3_alu_swap,DV[5]}}) );
	Comb1 bit_msb ( .clk(CLK2), .x(ca[7]), .a({`s3_alu_rotate_shift_left,DV[6]}), .b({`s3_alu_rr,bc[1]}), .c({`s3_alu_sra,DV[7]}), .d({`s3_alu_rrc,DV[0]}), .e({`s3_alu_swap,DV[3]}) );

	// Random logic (large spaghetti at the bottom)

	LargeComb1 rand_logic (
		.CLK2(CLK2),
		.CLK6(CLK6),
		.CLK7(CLK7),
		.Temp_Z(Temp_Z),
		.AllZeros(AllZeros),
		.d42(d42),
		.d58(d58),
		.w(w),
		.x(x),
		.alu(alu),
		.IR(IR),
		.nIR(nIR),
		.f(f),
		.bc(bc),
		.nbc(nbc),
		.ALU_to_Thingy(ALU_to_Thingy),
		.ALU_L0(ALU_L0),
		.Temp_H(Temp_H),
		.Temp_C(Temp_C),
		.ALU_L3(ALU_L3),
		.Temp_N(Temp_N),
		.ALU_L5(ALU_L5),
		.bq4(bq4),
		.bq5(bq5),
		.bq7(bq7),
		.azo(azo) );

	// Flags (part of the circuit below spaghetti, some FF and domino inverters)

	assign e = ~{azo[10],azo[9],azo[8],azo[6],azo[5],azo[4],azo[3],azo[0]};
	assign ALU_to_top = ~azo[13];
	assign ALU_Out1 = ~azo[11];

	bc bc5 ( .nd(azo[1]), .CLK(CLK6), .CCLK(CLK5), .Load(`s3_wren_hf_nf_zf), .q(bc[5]), .nq(nbc[5]) ); 			// Flag H
	bc bc1 ( .nd(azo[2]), .CLK(CLK6), .CCLK(CLK5), .Load(`s3_wren_cf), .q(bc[1]), .nq(nbc[1]) ); 			// Flag C
	bc bc2 ( .nd(azo[7]), .CLK(CLK6), .CCLK(CLK5), .Load(`s3_wren_hf_nf_zf), .q(bc[2]), .nq(nbc[2]) );  		// Flag N
	bc bc3 ( .nd(azo[12]), .CLK(CLK6), .CCLK(CLK5), .Load(`s3_wren_hf_nf_zf), .q(bc[3]), .nq(nbc[3]) ); 	// Flag Z
	ALU_to_bot_latch zbus_msb ( .d( Temp_Z /* =zbus[7] */ ), .CLK(CLK6), .CCLK(CLK5), .Load(CLK4), .q(ALU_to_bot) ); 			// zbus msb latch

	// Regarding "bc". I tend to think that even though bc0/bc4 is at the bottom, it is still part of the ALU.
	// Moved this circuit in my HDL inside the ALU instead of at the bottom. Then wire [5:0] bc; will become output.

	assign bc[0] = (IR[4] & IR[5] & `s2_op_push_sx10);
	assign bc[4] = ALU_to_bot & `s2_op_sp_e_sx10;
	assign nbc[0] = ~bc[0];
	assign nbc[4] = ~bc[4];

endmodule // ALU

// Carry lookahead generator
module module5 ( m, h, c, q );

	input [3:0] m; 		// G
	input [3:0] h;		// P
	input c;			// CarryIn
	/* verilator lint_off UNOPTFLAT */
	output [3:0] q; 	// C1...C4  (inverted)

	assign q[0] = ~(m[0] | (h[0] & c)); 		// ~Carry1 out
	assign q[1] = ~(m[1] | (h[1] & ~q[0]));		// ~Carry2 out
	assign q[2] = ~(m[2] | (h[2] & ~q[1]));		// ~Carry3 out
	assign q[3] = ~(m[3] | (h[3] & ~q[2]));		// ~Carry4 out

endmodule // module5

// Sums block
module module6 ( a, b, c, d, e, x );

	input a;
	input b;
	input c; 			// x18 (s3_alu_xor)
	input d; 			// x3 (s3_alu_sum)
	input e; 			// The result of the logical operation AND/OR/permutation of Operand2 bits.
	output x;

	assign x = ( (b & c) | ((a ^ b) & d) | (e) );

endmodule // module6

// G/P Terms Product.
// The module "hybridizes" the computation of G/P terms by reusing them for logical AND/OR operations. It also contains a Shifter result bypass.
module module2 ( a, b, c, e, f, g, h, k, m, x, w );

	input a; 		// Result of permutation(shift/rotate/swap) of Operand2 bits; [!] active low input
	input b;  			// x19 (s3_alu_logic_and)
	input c; 			// x4 (s3_alu_logic_or)
	input e; 		// Large Comb results; Result of executing SET/RES opcodes for operand1
	output f; 		// To Large Comb NAND trees; Operand2 optionally complemented
	input g; 		// x25 (s3_alu_b_complement)
	output h; 		// To CLA Generator (P-terms)
	input k; 		// Operand2: DV[n]
	output m; 		// To CLA Generator (G-terms)
	output x; 		// To ands near CLA
	output w; 		// To Sums; The result of the logical operation AND/OR/permutation of Operand2 bits.

	// Missing transparent DLatch that stores the result of the shifter (permutation result). This DLatch is critically needed, for example, when shifting DV to the left, in this case the following will happen (get ready, it's complicated):
	// The dynamic comb of shifter during CLK2 pre-charges the output to 1 - this will be the complement of the result of the shifter bit (i.e. - 0). At the same time, the s3_alu_rotate_shift_left command does not multiplex the output of the dynamic comb for lsb in any way;
	// Therefore, the output for lsb will be 0 (or rather the complementary value of 1 pre-charge, which is what is stored on the DLatch).
	wire shift_res_q;  		// <-- active low
	BusKeeper perm_ff (.d(a), .q(shift_res_q) );

	assign f = k ^ g;
	assign h = e | f;
	assign x = ~(e & f);
	assign m = ~x;
	assign w = ~(shift_res_q & (~(b&m)) & (~(c&h))); 		// or simply 3-OR, if you demorganize the operation.

endmodule // module2

// AOI-22222 dynamic (5 ANDs to OR Inverted)
module Comb1 ( clk, x, a, b, c, d, e );

	input clk;
	output x;
	input [1:0] a;
	input [1:0] b;
	input [1:0] c;
	input [1:0] d;
	input [1:0] e;

	assign x = clk ? ~((a[0]&a[1]) | (b[0]&b[1]) | (c[0]&c[1]) | (d[0]&d[1]) | (e[0]&e[1])) : 1'b1;

endmodule // Comb1

// AOI-222 dynamic (3 ANDs to OR Inverted)
module Comb2 ( clk, x, a, b, c );

	input clk;
	output x;
	input [1:0] a;
	input [1:0] b;
	input [1:0] c;

	assign x = clk ? ~((a[0]&a[1]) | (b[0]&b[1]) | (c[0]&c[1]) ) : 1'b1;

endmodule // Comb2

// AOI-2222 dynamic (4 ANDs to OR Inverted)
module Comb3 ( clk, x, a, b, c, d );

	input clk;
	output x;
	input [1:0] a;
	input [1:0] b;
	input [1:0] c;
	input [1:0] d;

	assign x = clk ? ~((a[0]&a[1]) | (b[0]&b[1]) | (c[0]&c[1]) | (d[0]&d[1]) ) : 1'b1;

endmodule // Comb3

// Random logic
module LargeComb1 ( CLK2, CLK6, CLK7, Temp_Z, AllZeros, d42, d58, w, x, alu, IR, nIR, f, bc, nbc, ALU_to_Thingy, ALU_L0, Temp_H, Temp_C, ALU_L3, Temp_N, ALU_L5, bq4, bq5, bq7, azo );

	input CLK2;
	input CLK6;
	input CLK7;
	input Temp_Z;
	input AllZeros;
	input d42;
	input d58;
	input [40:0] w;
	input [68:0] x;
	input [7:0] alu;
	input [7:0] IR;
	input [5:0] nIR;
	input [7:0] f;
	input [5:0] bc;
	input [5:0] nbc;
	input ALU_to_Thingy;
	input ALU_L0;
	input Temp_H;
	input Temp_C;
	input ALU_L3;
	input Temp_N;
	input ALU_L5;
	input bq4;
	input bq5;
	input bq7;
	output [13:0] azo; 		// "azo" means absolutely nothing, just the name of the random logic results

	wire [13:0] azo_latched; 		// Inputs to DLatch from dynamic logic
	wire [13:0] az;		// random logic results (non-dynamic)

	// ALU Trees (by hand); Tree numbering is topological (how they are arranged on the chip)
	// Random logic in SM83 is organized in such a way that all related calculations are performed in one place (topologically). On the one hand it is very convenient (the logic is isolated), on the other hand it turns out to be a very confusing doshirak.

	// ALU trees 0,3-6,8-10 are responsible for preprocessing operand 1 for SET/RES opcodes (CB table) as well as DAA (decimal correction)
	// Because of the topological numbering of the trees, they don't go in order, which is a bit ugly.
	// ALU tree 11 deals with code checking for conditional instructions (NZ/Z/NC/C)

	assign az[0] = ~( alu[0] | (`s2_alu_set&nIR[3]&nIR[4]&nIR[5]) | (`s2_alu_res&(IR[3]|IR[4]|IR[5])) );
	assign az[1] = ~( (ALU_L5&((nIR[0]&`s2_op_incdec8)|`s3_alu_sum_pos_hf_cf)) | (ALU_L3&`s3_alu_sum_neg_hf_nf) | `s3_alu_cpl | `s2_cb_bit | `s3_alu_logic_and | (Temp_H&d58) );
	assign az[2] = ~( (f[0]&`s3_alu_rotate_shift_right) | (Temp_C&d58) | (nbc[1]&IR[3]&`s3_alu_ccf_scf) | (`s3_alu_ccf_scf&nIR[3]) | (`s3_alu_sum_pos_hf_cf&ALU_to_Thingy) | (`s3_alu_daa&(bc[1]|(nbc[2]&ALU_to_Thingy))) | (bc[1]&`s3_alu_cpl) | (f[7]&`s3_alu_rotate_shift_left) | (ALU_L0&`s3_alu_sum_neg_cf) );
	assign az[3] = ~( alu[1] | (`s2_alu_set&IR[3]&nIR[4]&nIR[5]) | (`s2_alu_res&(nIR[3]|IR[4]|IR[5])) | (`s3_alu_daa&(bc[5]|(nbc[2]&bq4))) );
	assign az[4] = ~( alu[2] | (`s2_alu_set&nIR[3]&IR[4]&nIR[5]) | (`s2_alu_res&(IR[3]|nIR[4]|IR[5])) | (`s3_alu_daa&nbc[2]&(bq4|bc[5])) );
	assign az[5] = ~( alu[3] | (`s2_alu_set&IR[3]&IR[4]&nIR[5]) | (`s2_alu_res&(nIR[3]|nIR[4]|IR[5])) | (`s3_alu_daa&bc[2]&bc[5]) );
	assign az[6] = ~( alu[4] | (`s2_alu_set&nIR[3]&nIR[4]&IR[5]) | (`s2_alu_res&(IR[3]|IR[4]|nIR[5])) | (`s3_alu_daa&bc[2]&bc[5]) );
	assign az[7] = ~( (bc[2]&`s3_alu_daa) | `s3_alu_sum_neg_hf_nf | `s3_alu_cpl | (Temp_N&d58) );
	assign az[8] = ~( alu[5] | (`s2_alu_set&IR[3]&nIR[4]&IR[5]) | (`s2_alu_res&(nIR[3]|IR[4]|nIR[5])) | (bc[2]&`s3_alu_daa&((bc[1]&nbc[5])|(nbc[1]&bc[5]))) | (nbc[2]&`s3_alu_daa&((bq5)|(bc[1])|(bq4&bq7))) );
	assign az[9] = ~( alu[6] | (`s2_alu_set&nIR[3]&IR[4]&IR[5]) | (`s2_alu_res&(IR[3]|nIR[4]|nIR[5])) | (bc[2]&`s3_alu_daa&(nbc[1]&bc[5])) | (nbc[2]&`s3_alu_daa&((bq4&bq7)|(bc[1])|(bq5))) );
	assign az[10] = ~( alu[7] | (`s2_alu_set&IR[3]&IR[4]&IR[5]) | (`s2_alu_res&(nIR[3]|nIR[4]|nIR[5])) | (bc[2]&`s3_alu_daa&(bc[1]|bc[5])) );
	assign az[11] = ~( 
		`s2_cc_check & (              // inverted condition check
			(nIR[3]&nIR[4] & bc[3]) | // 00 | Z
			( IR[3]&nIR[4] &nbc[3]) | // 10 | NZ
			(nIR[3]& IR[4] & bc[1]) | // 01 | C
			( IR[3]& IR[4] &nbc[1])   // 11 | NC
		));
	assign az[12] = ~(
		(f[0]&`s2_cb_bit&nIR[3]&nIR[4]&nIR[5]) |
		(f[1]&`s2_cb_bit&IR[3]&nIR[4]&nIR[5]) |
		(f[2]&`s2_cb_bit&nIR[3]&IR[4]&nIR[5]) |
		(f[3]&`s2_cb_bit&IR[3]&IR[4]&nIR[5]) |
		(f[4]&`s2_cb_bit&nIR[3]&nIR[4]&IR[5]) |
		(f[5]&`s2_cb_bit&IR[3]&nIR[4]&IR[5]) |
		(f[6]&`s2_cb_bit&nIR[3]&IR[4]&IR[5]) |
		(f[7]&`s2_cb_bit&IR[3]&IR[4]&IR[5]) |
		(AllZeros&(d42|`s2_op_alu8|`s2_op_incdec8|`s3_alu_daa)) | (d58&Temp_Z) | (bc[3]&(`s3_alu_cpl|`s2_op_add_hl_sxx0|`s3_alu_ccf_scf|`s2_op_add_hl_sx01)) );
	assign az[13] = ~( `s3_alu_cp | (`s2_op_incdec8&nIR[0]) | (`s2_op_sp_e_sx10&bc[1]) | (`s3_alu_sub_sbc&(nIR[3]|nbc[1])) | (`s2_op_add_hl_sx01&bc[1]) | (`s3_alu_add_adc&IR[3]&bc[1]) );

	// Dynamic part

	assign azo_latched[0] = CLK2 ? az[0] : 1'bz;
	assign azo_latched[1] = CLK7 ? (CLK6 ? az[1] : 1'bz) : 1'bz;		// -> bc5   -- Flag H
	assign azo_latched[2] = CLK7 ? (CLK6 ? az[2] : 1'bz) : 1'bz;		// -> bc1   -- Flag C
	assign azo_latched[3] = CLK2 ? az[3] : 1'bz;
	assign azo_latched[4] = CLK2 ? az[4] : 1'bz;
	assign azo_latched[5] = CLK2 ? az[5] : 1'bz;
	assign azo_latched[6] = CLK2 ? az[6] : 1'bz;
	assign azo_latched[7] = CLK7 ? (CLK6 ? az[7] : 1'bz) : 1'bz;		// -> bc2   -- Flag N
	assign azo_latched[8] = CLK2 ? az[8] : 1'bz;
	assign azo_latched[9] = CLK2 ? az[9] : 1'bz;
	assign azo_latched[10] = CLK2 ? az[10] : 1'bz;
	assign azo_latched[11] = CLK7 ? (CLK6 ? az[11] : 1'bz) : 1'bz; 		// -> ALU_Out1  -- Skip branch
	assign azo_latched[12] = CLK7 ? (CLK6 ? az[12] : 1'bz) : 1'bz;		// -> bc3   -- Flag Z
	assign azo_latched[13] = CLK2 ? az[13] : 1'bz;		// -> ALU_to_top aka CarryIn

	// Transparent DLatch is required at least for asymmetric dynamic logic (which uses CLK7/CLK6, i.e. for flags and cc_check);
	// The others don't require DLatch, but are made for unification.
	// The use of asymmetric CLK is obviously related to the peculiarities of overlapped instruction execution in SM83  (CLK6 = writeback; CLK7 = writeback_ext)
	BusKeeper latched_results [13:0] ( .d(azo_latched), .q(azo) );

endmodule // LargeComb1

// This latch is used to hold flags (bc3=Z / bc2=N / bc5=H / bc1=C); The silly name `bc` is just from the early stages of research
module bc ( nd, CLK, CCLK, Load, q, nq );

	input nd; 
	input CLK; 
	input CCLK; 
	input Load; 
	output q;
	output nq;

	reg val_in;
	reg val_out;
	initial val_in = 1'b0;
	initial val_out = 1'b0;

	always @(*) begin
		if (CLK && Load)
			val_in = ~nd;
	end

	always @(negedge Load) begin
		val_out <= val_in;
	end

	assign q = val_out;
	assign nq = ~q;

endmodule // bc

// This latch exists in a single instance and is used to hold the zbus msb (ie - sign)
module ALU_to_bot_latch ( d, CLK, CCLK, Load, q );

	input d; 
	input CLK; 
	input CCLK; 
	input Load; 
	output q;

	reg val_in;
	reg val_out;
	initial val_in = 1'b0;
	initial val_out = 1'b0;

	always @(*) begin
		if (CLK && Load)
			val_in = d;
	end

	always @(negedge Load) begin
		val_out <= val_in;
	end

	assign q = val_out;

endmodule // ALU_to_bot_latch

module Bottom ( CLK2, CLK4, CLK5, CLK6, CLK7, DL, DV, bc, bq4, bq5, bq7, Temp_C, Temp_H, Temp_N, Temp_Z, alu, Res, IR, d, w, x, 
	SYNC_RES, TTB1, TTB2, TTB3, BUS_DISABLE, bro, A );

	input CLK2;
	input CLK4;
	input CLK5;
	input CLK6;
	input CLK7; 

	inout [7:0] DL;			// Internal databus
	output [7:0] DV;		// ALU Operand2
	input [5:0] bc;
	output bq4;
	output bq5;
	output bq7;
	output Temp_C;		// Flag C from temp Z register
	output Temp_H;		// Flag H from temp Z register
	output Temp_N;		// Flag N from temp Z register
	output Temp_Z;			// Flag Z from temp Z register  / zbus msb
	output [7:0] alu; 		// ALU Operand1
	input [7:0] Res;		// ALU Result

	output [7:0] IR;		// Current opcode
	input [106:0] d;		// Decoder1 output
	input [40:0] w;			// Decoder2 output
	input [68:0] x;			// Decoder3 output

	input SYNC_RES;
	input TTB1;				// 1: Perform pairwise increment/decrement (simultaneously for two 8-bit IncDec halves)
	input TTB2;				// 1: Perform decrement
	input TTB3;				// 1: Perform increment
	input BUS_DISABLE;			// 1: Bus disable
	input [7:3] bro; 		// IRQ Logic interrupt address
	output [15:0] A;		// External core address bus

	// Internal bottom buses

	wire [7:0] abus;
	wire [7:0] bbus;
	wire [7:0] cbus;
	wire [7:0] dbus;
	wire [7:0] ebus;
	wire [7:0] fbus;
	wire [7:0] zbus;
	wire [7:0] wbus;
	wire [7:0] adl;
	wire [7:0] adh;

	wire [7:0] Aout;	// Reg A out to bq Logic

	// Implementation

	BusPrecharge precharge (
		.CLK2(CLK2),
		.DL(DL),
		.abus(abus),
		.bbus(bbus),
		.cbus(cbus),
		.dbus(dbus) );

	BottomLeftLogic bottom_left (
		.CLK2(CLK2),
		.bc(bc),
		.bq4(bq4),
		.bq5(bq5),
		.bq7(bq7),
		.Aout(Aout),
		.abus(abus),
		.bbus(bbus),
		.alu(alu),
		.DV(DV) );

	RegsBuses regs (
		.CLK5(CLK5),
		.CLK6(CLK6),
		.w(w),
		.x(x),
		.DL(DL),
		.IR(IR),
		.abus(abus),
		.bbus(bbus),
		.cbus(cbus),
		.dbus(dbus),
		.ebus(ebus),
		.fbus(fbus),
		.Aout(Aout) );

	TempRegsBuses temp_regs (
		.CLK4(CLK4),
		.CLK5(CLK5),
		.CLK6(CLK6),
		.d60(`s1_op_ld_nn_sp_s010),
		.w(w),
		.x(x),
		.DL(DL),
		.bbus(bbus),
		.cbus(cbus),
		.dbus(dbus),
		.ebus(ebus),
		.fbus(fbus),
		.zbus(zbus),
		.wbus(wbus),
		.Res(Res),
		.adl(adl),
		.adh(adh) );

	SP sp (
		.CLK5(CLK5),
		.CLK6(CLK6),
		.CLK7(CLK7),
		.IR4(IR[4]),
		.IR5(IR[5]),
		.d60(`s1_op_ld_nn_sp_s010),
		.d66(`s1_op_ld_nn_sp_s011),
		.w(w),
		.x(x),
		.DL(DL),
		.abus(abus),
		.bbus(bbus),
		.cbus(cbus),
		.dbus(dbus),
		.zbus(zbus),
		.wbus(wbus),
		.adl(adl),
		.adh(adh) );

	PC pc (
		.CLK5(CLK5),
		.CLK6(CLK6),
		.CLK7(CLK7),
		.d92(`s1_op_rst_sx10),
		.w(w),
		.x(x),
		.DL(DL),
		.abus(abus),
		.cbus(cbus),
		.dbus(dbus),
		.zbus(zbus),
		.wbus(wbus),
		.adl(adl),
		.adh(adh),
		.IR(IR),
		.bro(bro),
		.SYNC_RES(SYNC_RES) );

	IncDec incdec (
		.CLK4(CLK4),
		.TTB1(TTB1),
		.TTB2(TTB2),
		.TTB3(TTB3),
		.BUS_DISABLE(BUS_DISABLE),
		.cbus(cbus),
		.dbus(dbus),
		.adl(adl),
		.adh(adh),
		.AddrBus(A) );

	assign Temp_C = zbus[4];
	assign Temp_H = zbus[5];
	assign Temp_N = zbus[6];
	assign Temp_Z = zbus[7];

endmodule // Bottom

module BusPrecharge ( CLK2, DL, abus, bbus, cbus, dbus );

	input CLK2;
	output [7:0] DL;
	output [7:0] abus;
	output [7:0] bbus;
	output [7:0] cbus;
	output [7:0] dbus;

	assign   DL = CLK2 ? 8'bzzzzzzzz : 8'b11111111;
	assign abus = CLK2 ? 8'bzzzzzzzz : 8'b11111111;
	assign bbus = CLK2 ? 8'bzzzzzzzz : 8'b11111111;
	assign cbus = CLK2 ? 8'bzzzzzzzz : 8'b11111111;
	assign dbus = CLK2 ? 8'bzzzzzzzz : 8'b11111111;

endmodule // BusPrecharge

// It is very difficult to put this circuit into any category. It belongs to both ALU and registers at the same time, and is generally at the bottom. So it's going to stay here untouched for now.
module BottomLeftLogic ( CLK2, bc, bq4, bq5, bq7, Aout, abus, bbus, alu, DV );

	input CLK2;
	input [5:0] bc;
	output bq4;
	output bq5;
	output bq7;
	input [7:0] Aout; 		// Current value of the `A` register  (directly from the register bits output)
	input [7:0] abus; 		// ⚠️ inverse hold (active low)
	input [7:0] bbus; 		// ⚠️ inverse hold (active low)
	output [7:0] alu; 		// abus -> ALU Operand 1
	output [7:0] DV; 		// bbus -> ALU Operand 2

	wire [7:0] abq; 	// abus Bus keepers outputs
	wire [7:0] bbq; 	// bbus Bus keepers outputs

	// Logic bits for DAA
	assign bq4 = (Aout[1] | Aout[2]) & Aout[3]; // is the lower nibble greater than 9?
	assign bq5 = (Aout[5] | Aout[6]) & Aout[7]; // is the upper nibble greater than 9?
	assign bq7 = Aout[4] & Aout[7];             // are both nibbles greater than or equal to 8?
	
	// This requires transparent latches, since nobody could set up a abus/bbus. On the actual circuit, they are also present as a memory on the `not` gate.
	BusKeeper abus_keepers [7:0] ( .d(abus), .q(abq) );
	BusKeeper bbus_keepers [7:0] ( .d(bbus), .q(bbq) );

	// TODO: wtf is this at all?

	assign DV[0] = ~(CLK2 ? (bbq[0] & ~bc[4]) : 1'b1);
	assign DV[1] = ~(CLK2 ? (bbq[1] & ~bc[4]) : 1'b1);
	assign DV[2] = ~(CLK2 ? (bbq[2] & ~bc[4]) : 1'b1);
	assign DV[3] = ~(CLK2 ? (bbq[3] & ~bc[4]) : 1'b1);
	assign DV[4] = ~(CLK2 ? (bbq[4] & ~(bc[4] | (bc[0] & bc[1])) ) : 1'b1);
	assign DV[5] = ~(CLK2 ? (bbq[5] & ~(bc[4] | (bc[0] & bc[5])) ) : 1'b1);
	assign DV[6] = ~(CLK2 ? (bbq[6] & ~(bc[4] | (bc[0] & bc[2])) ) : 1'b1);
	assign DV[7] = ~(CLK2 ? (bbq[7] & ~(bc[4] | (bc[0] & bc[3])) ) : 1'b1);

	assign alu = ~abq;

	// I decided to put the bc0/bc4 generation in the ALU, so that the bc signals would be made as output from the ALU (for beauty).

endmodule // BottomLeftLogic

// Separated from Bottom.v to make it easier to scroll through the source.

// Important note: SHARP engineers did give slack and use inverse polarity in some places (buses a,b,c,d, inputs for Z/W/PC/SP registers).
// If you will be doing your own implementation of SM83 "inspired by", keep in mind that you do not have to repeat the inverse polarity for the above entities at all.
// Inverse polarity is used there just for convenience (e.g. bus precharging).

module RegsBuses ( CLK5, CLK6, w, x, DL, IR, abus, bbus, cbus, dbus, ebus, fbus, Aout );

	input CLK5;
	input CLK6;
	input [40:0] w;
	input [68:0] x;
	input [7:0] DL;
	output [7:0] IR;
	output [7:0] abus; 		// ⚠️ inverse hold (active low)
	output [7:0] bbus; 		// ⚠️ inverse hold (active low)
	output [7:0] cbus; 		// ⚠️ inverse hold (active low)
	output [7:0] dbus; 		// ⚠️ inverse hold (active low)
	input [7:0] ebus;
	input [7:0] fbus;
	output [7:0] Aout; 			// Reg A output for bq logic

	// Regs output

	wire [7:0] r1q;		// A
	wire [7:0] r2q;		// L
	wire [7:0] r3q;		// H
	wire [7:0] r4q;		// E
	wire [7:0] r5q;		// D
	wire [7:0] r6q;		// C
	wire [7:0] r7q;		// B

	// For debugging
	(* keep *) wire [7:0] A = r1q;
	(* keep *) wire [7:0] L = r2q;
	(* keep *) wire [7:0] H = r3q;
	(* keep *) wire [7:0] E = r4q;
	(* keep *) wire [7:0] D = r5q;
	(* keep *) wire [7:0] C = r6q;
	(* keep *) wire [7:0] B = r7q;


	regbit RegIR [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(DL), .ld({8{`s2_m1}}), .q(IR) );

	regbit RegA [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(fbus), .ld({8{`s3_wren_a}}), .q(r1q) );
	regbit RegL [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(ebus), .ld({8{`s3_wren_l}}), .q(r2q) );
	regbit RegH [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(fbus), .ld({8{`s3_wren_h}}), .q(r3q) );
	regbit RegE [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(ebus), .ld({8{`s3_wren_e}}), .q(r4q) );
	regbit RegD [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(fbus), .ld({8{`s3_wren_d}}), .q(r5q) );
	regbit RegC [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(ebus), .ld({8{`s3_wren_c}}), .q(r6q) );
	regbit RegB [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(fbus), .ld({8{`s3_wren_b}}), .q(r7q) );

	assign abus = `s2_op_alu8 ? ~r1q : 8'bzzzzzzzz;
	assign bbus = `s3_oe_areg_to_rbus ? ~r1q : 8'bzzzzzzzz;
	assign cbus = `s3_oe_hlreg_to_idu ? ~r2q : 8'bzzzzzzzz;
	assign abus = `s2_op_add_hl_sxx0 ? ~r2q : 8'bzzzzzzzz;
	assign bbus = `s3_oe_lreg_to_rbus ? ~r2q : 8'bzzzzzzzz;
	assign abus = `s2_op_add_hl_sx01 ? ~r3q : 8'bzzzzzzzz;
	assign bbus = `s3_oe_hreg_to_rbus ? ~r3q : 8'bzzzzzzzz;
	assign dbus = `s3_oe_hlreg_to_idu ? ~r3q : 8'bzzzzzzzz;
	assign cbus = `s3_oe_dereg_to_idu ? ~r4q : 8'bzzzzzzzz;
	assign bbus = `s3_oe_ereg_to_rbus ? ~r4q : 8'bzzzzzzzz;
	assign bbus = `s3_oe_dreg_to_rbus ? ~r5q : 8'bzzzzzzzz;
	assign dbus = `s3_oe_dereg_to_idu ? ~r5q : 8'bzzzzzzzz;
	assign dbus = `s2_op_ldh_c_sx00 ? 8'b00000000 : 8'bzzzzzzzz;
	assign dbus = `s2_op_ldh_imm_sx01 ? 8'b00000000 : 8'bzzzzzzzz;
	assign cbus = `s3_oe_bcreg_to_idu ? ~r6q : 8'bzzzzzzzz;
	assign bbus = `s3_oe_creg_to_rbus ? ~r6q : 8'bzzzzzzzz;
	assign bbus = `s3_oe_breg_to_rbus ? ~r7q : 8'bzzzzzzzz;
	assign dbus = (~`s2_op_ldh_c_sx00 & `s3_oe_bcreg_to_idu) ? ~r7q : 8'bzzzzzzzz;

	// The instruction LDH A, (C) enables both s2_op_ldh_c_sx00 and
	// s3_oe_bcreg_to_idu at the same time, causing a conflict. Because of the
	// use of dynamic logic by the circut, the result favors 0. So the
	// conflict will resolve to `s2_op_ldh_c_sx00. We simulate that in the
	// verilog using aditional logic.

	assign Aout = r1q;

endmodule // RegsBuses

module TempRegsBuses ( CLK4, CLK5, CLK6, d60, w, x, DL, bbus, cbus, dbus, ebus, fbus, zbus, wbus, Res, adl, adh );

	input CLK4;
	input CLK5;
	input CLK6;
	input d60; 				// Gekkio: s1_op_ld_nn_sp_s010
	input [40:0] w;
	input [68:0] x;
	input [7:0] DL;
	output [7:0] bbus;		// ⚠️ inverse hold (active low)
	output [7:0] cbus;		// ⚠️ inverse hold (active low)
	output [7:0] dbus; 		// ⚠️ inverse hold (active low)
	output [7:0] ebus;
	output [7:0] fbus;
	output [7:0] zbus;
	output [7:0] wbus;
	input [7:0] Res;
	input [7:0] adl;
	input [7:0] adh;

	wire [7:0] Z_in; 		// active low
	wire [7:0] W_in; 		// active low
	wire d60w8;

	// ⚠️ The Z/W registers have an input in inverse polarity, and the output in the regular
	regbit_nd Z [7:0]( .clk({8{CLK6}}), .cclk({8{CLK5}}), .nd(Z_in), .ld({8{`s3_wren_z}}), .q(zbus) );
	regbit_nd W [7:0]( .clk({8{CLK6}}), .cclk({8{CLK5}}), .nd(W_in), .ld({8{`s3_wren_w}}), .q(wbus) );

	assign cbus = `s2_op_ldh_imm_sx01 ? ~zbus : 8'bzzzzzzzz;
	assign cbus = `s2_oe_wzreg_to_idu ? ~zbus : 8'bzzzzzzzz;
	assign cbus = `s2_op_jr_any_sx10 ? ~zbus : 8'bzzzzzzzz;
	assign bbus = `s3_oe_zreg_to_rbus ? ~zbus : 8'bzzzzzzzz;
	assign dbus = `s2_op_jr_any_sx10 ? ~wbus : 8'bzzzzzzzz;
	assign dbus = `s2_oe_wzreg_to_idu ? ~wbus : 8'bzzzzzzzz;

	assign fbus = ~(CLK4 ? ~(({8{`s3_oe_idu_to_uhlbus}}&adh) | ({8{`s3_oe_wzreg_to_uhlbus}}&wbus) | ({8{`s3_oe_ubus_to_uhlbus}}&Res)) : 8'b11111111);
	assign ebus = ~(CLK4 ? ~(({8{`s3_oe_idu_to_uhlbus}}&adl) | ({8{`s3_oe_wzreg_to_uhlbus}}&zbus) | ({8{`s3_oe_ubus_to_uhlbus}}&Res)) : 8'b11111111);

	assign d60w8 = ~(d60 | `s2_op_jr_any_sx01);
	assign Z_in = ~(({8{d60}}&adl) | ({8{~d60}}&DL));
	assign W_in = ~(({8{~d60w8}}&adh) | ({8{d60w8}}&DL));

endmodule // TempRegsBuses

module SP ( CLK5, CLK6, CLK7, IR4, IR5, d60, d66, w, x, DL, abus, bbus, cbus, dbus, zbus, wbus, adl, adh );

	input CLK5;
	input CLK6;
	input CLK7;
	input IR4;
	input IR5;
	input d60;
	input d66;
	input [40:0] w;
	input [68:0] x;
	output [7:0] DL;			// Internal databus
	output [7:0] abus;
	output [7:0] bbus;
	output [7:0] cbus;
	output [7:0] dbus;
	input [7:0] zbus;
	input [7:0] wbus;
	input [7:0] adl;
	input [7:0] adh;

	wire [7:0] spl_nd;		// SPL input (inverse)
	wire [7:0] spl_q;		// SPL output
	wire [7:0] spl_nq;		// SPL output (complement)
	wire [7:0] sph_nd;		// SPH input (inverse)
	wire [7:0] sph_q;		// SPH output 
	wire [7:0] sph_nq;		// SPH output (complement)

	wire [7:0] spl_bnq;		// SPL input buskeeper output  (active low)
	wire [7:0] sph_bnq;		// SPH input buskeeper output  (active low)

	// For debugging
	(* keep *) wire [15:0] SP = {sph_q, spl_q};

	sp_regbit SPL [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .nd(spl_bnq), .ld({8{`s3_wren_sp}}), .q(spl_q), .nq(spl_nq) );
	sp_regbit SPH [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .nd(sph_bnq), .ld({8{`s3_wren_sp}}), .q(sph_q), .nq(sph_nq) );

	// Another bus keeper - which stores the input value for the SPL/SPH registers.
	// It is "recharged" during CLK7=0 and updated during CLK6=1. Between these two cutoffs - the input is in a floating state.
	BusKeeper SPL_KeepInput [7:0] ( .d(spl_nd), .q(spl_bnq) );
	BusKeeper SPH_KeepInput [7:0] ( .d(sph_nd), .q(sph_bnq) );

	// SP vs Buses

	assign spl_nd = CLK6 ? (~((adl & {8{`s3_oe_idu_to_spreg}}) | (zbus & {8{`s3_oe_wzreg_to_spreg}}))) : (CLK7 ? 8'bzzzzzzzz : 8'b11111111);
	assign sph_nd = CLK6 ? (~((adh & {8{`s3_oe_idu_to_spreg}}) | (wbus & {8{`s3_oe_wzreg_to_spreg}}))) : (CLK7 ? 8'bzzzzzzzz : 8'b11111111);

	assign DL = d60 ? ~spl_nq : 8'bzzzzzzzz;
	assign abus = `s2_op_sp_e_s001 ? ~spl_q : 8'bzzzzzzzz;
	assign bbus = (`s2_op_add_hl_sxx0 & IR4 & IR5) ? ~spl_q : 8'bzzzzzzzz;
	assign cbus = `s3_oe_spreg_to_idu ? ~spl_q : 8'bzzzzzzzz;

	assign DL = d66 ? ~sph_nq : 8'bzzzzzzzz;
	assign abus = `s2_op_sp_e_sx10 ? ~sph_q : 8'bzzzzzzzz;
	assign bbus = (`s2_op_add_hl_sx01 & IR4 & IR5) ? ~sph_q : 8'bzzzzzzzz;
	assign dbus = `s3_oe_spreg_to_idu ? ~sph_q : 8'bzzzzzzzz;

endmodule // SP

module PC ( CLK5, CLK6, CLK7, d92, w, x, DL, abus, cbus, dbus, zbus, wbus, adl, adh, IR, bro, SYNC_RES );

	input CLK5;
	input CLK6;
	input CLK7;
	input d92;
	input [40:0] w;
	input [68:0] x;	
	output [7:0] DL;			// Internal databus
	output [7:0] abus;
	output [7:0] cbus;
	output [7:0] dbus;
	input [7:0] zbus;
	input [7:0] wbus;
	input [7:0] adl;
	input [7:0] adh;
	input [7:0] IR;			// Current opcode
	input [7:3] bro;		// Interrupt address
	input SYNC_RES;

	wire [7:0] pcl_nd;		// PCL input (inverse)
	wire [7:0] pcl_q;		// PCL output
	wire [7:0] pcl_nq;		// PCL output (complement)
	wire [7:0] pch_nd;		// PCH input (inverse)
	wire [7:0] pch_q;		// PCH output
	wire [7:0] pch_nq;		// PCH output (complement)

	wire [7:0] pcl_bnq;		// PCL input buskeeper output  (active low)
	wire [7:0] pch_bnq;		// PCH input buskeeper output  (active low)

	// For debugging
	(* keep *) wire [15:0] PC = {pch_q, pcl_q};

	pc_regbit PCL [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .nres({8{~SYNC_RES}}), .nd(pcl_bnq), .ld({8{`s3_wren_pc}}), .q(pcl_q), .nq(pcl_nq) );
	pc_regbit PCH [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .nres({8{~SYNC_RES}}), .nd(pch_bnq), .ld({8{`s3_wren_pc}}), .q(pch_q), .nq(pch_nq) );

	// Another bus keeper - which stores the input value for the PCL/PCH registers.
	// It is "recharged" during CLK7=0 and updated during CLK6=1. Between these two cutoffs - the input is in a floating state.
	BusKeeper PCL_KeepInput [7:0] ( .d(pcl_nd), .q(pcl_bnq) );
	BusKeeper PCH_KeepInput [7:0] ( .d(pch_nd), .q(pch_bnq) );

	// PC vs Buses

	assign pcl_nd[2:0] = CLK6 ? (~((adl[2:0] & {3{`s3_oe_idu_to_pcreg}}) | (zbus[2:0] & {3{`s2_oe_wzreg_to_pcreg}}))) : (CLK7 ? 3'bzzz : 3'b111);
	assign pcl_nd[5:3] = CLK6 ? (~((adl[5:3] & {3{`s3_oe_idu_to_pcreg}}) | (zbus[5:3] & {3{`s2_oe_wzreg_to_pcreg}}) | ({3{d92}} & IR[5:3]) | bro[5:3])) : (CLK7 ? 3'bzzz : 3'b111);
	assign pcl_nd[7:6] = CLK6 ? (~((adl[7:6] & {2{`s3_oe_idu_to_pcreg}}) | (zbus[7:6] & {2{`s2_oe_wzreg_to_pcreg}}) | bro[7:6])) : (CLK7 ? 2'bzz : 2'b11);
	assign pch_nd = CLK6 ? (~((adh & {8{`s3_oe_idu_to_pcreg}}) | (wbus & {8{`s2_oe_wzreg_to_pcreg}}))) : (CLK7 ? 8'bzzzzzzzz : 8'b11111111);

	assign DL = `s2_oe_pclreg_to_pbus ? ~pcl_nq : 8'bzzzzzzzz;
	assign cbus = `s2_addr_pc ? ~pcl_q : 8'bzzzzzzzz;
	assign abus = `s2_op_jr_any_sx01 ? ~pcl_q : 8'bzzzzzzzz;
	assign abus = `s3_op_dec8 ? 8'b00000000 : 8'bzzzzzzzz;

	assign DL = `s2_oe_pchreg_to_pbus ? ~pch_nq : 8'bzzzzzzzz;
	assign dbus = `s2_addr_pc ? ~pch_q : 8'bzzzzzzzz;
	assign dbus = `s2_op_jr_any_sx01 ? ~pch_q : 8'bzzzzzzzz;

endmodule // PC

module regbit ( clk, cclk, d, ld, q );

	input clk;
	input cclk;
	input d;
	input ld;
	output q;

	// Latch with complementary set enable, complementary CLK.

	reg val_in;
	reg val_out;
	initial val_in = 1'b0;
	initial val_out = 1'b0;

	always @(*) begin
		if (clk && ld)
			val_in = d;
	end

	always @(negedge ld) begin
		val_out <= val_in;
	end

	assign q = val_out;

endmodule // regbit

// Used for Z/W registers
module regbit_nd ( clk, cclk, nd, ld, q );

	input clk;
	input cclk;
	input nd;
	input ld;
	output q;

	// Latch with complementary set enable, complementary CLK.
	// Inverse hold.

	reg val_in;
	reg val_out;
	initial val_in = 1'b1;
	initial val_out = 1'b1;

	always @(*) begin
		if (clk && ld)
			val_in = nd;
	end

	always @(negedge ld) begin
		val_out <= val_in;
	end

	assign q = ~val_out;

endmodule // regbit_nd

module sp_regbit ( clk, cclk, nd, ld, q, nq );

	input clk;
	input cclk;
	input nd;
	input ld;
	output q;
	output nq;

	// Latch with complementary set enable, complementary CLK.
	// Inverse hold.

	reg val_in;
	reg val_out;
	initial val_in = 1'b1;
	initial val_out = 1'b1;

	always @(*) begin
		if (clk && ld)
			val_in = nd;
	end

	always @(negedge ld) begin
		val_out <= val_in;
	end

	assign q = ~val_out;
	assign nq = ~q;

endmodule // sp_regbit

module pc_regbit ( clk, cclk, nd, ld, nres, q, nq );

	input clk;
	input cclk;
	input nd;
	input ld;
	input nres;
	output q;
	output nq;

	// Latch with complementary set enable, complementary CLK, active-low reset
	// Inverse hold.

	reg val_in;
	reg val_out;
	initial val_in = 1'b1;
	initial val_out = 1'b1;

	always @(*) begin
		if (clk && ld)
			val_in = nd;
		if (~nres)
			val_in = 1'b1;
	end

	always @(negedge ld) begin
		val_out <= val_in;
	end

	assign q = ~val_out;
	assign nq = ~q;

endmodule // pc_regbit

// Separated from Bottom.v to make it easier to scroll through the source.

// The value on the cbus/dbus contains a ~val of register (register `q` output inversion).
// This value is stored on the BusKeeper. From the BusKeeper inverted value of ~val as `val` is fed to the IDU.
// At the output of the IDU the value is fed to the adl/adh buses as `val`.
// There is an inverter on the register input that loads ~val into the register.
// In the register the value is stored as ~val (inverse hold)

module IncDec ( CLK4, TTB1, TTB2, TTB3, BUS_DISABLE, cbus, dbus, adl, adh, AddrBus );

	input CLK4;
	input TTB1;				// 1: Perform pairwise increment/decrement (simultaneously for two 8-bit IncDec halves)
	input TTB2;				// 1: Perform decrement
	input TTB3;				// 1: Perform increment
	input BUS_DISABLE;
	input [7:0] cbus;		// ~val_lo
	input [7:0] dbus;		// ~val_hi
	output [7:0] adl;		// res_lo
	output [7:0] adh;		// res_hi
	output [15:0] AddrBus;

	wire [7:0] cbq; 	// cbus Bus keepers outputs
	wire [7:0] dbq; 	// dbus Bus keepers outputs

	wire [7:0] mq_lo;		// carry_out
	wire [7:0] mq_hi;
	wire [7:0] xa_lo;		// carry_in
	wire [7:0] xa_hi;

	// This requires transparent latches, since nobody could set up a cbus/dbus. On the actual circuit, they are also present as a memory on the `not` gate.
	BusKeeper cbus_keepers [7:0] ( .d(cbus), .q(cbq) );
	BusKeeper dbus_keepers [7:0] ( .d(dbus), .q(dbq) );

	cntbit cnt_lo [7:0] ( .val_in(~cbq), .cin(xa_lo), .val_out(adl), .cout(mq_lo), .TTB2({8{TTB2}}), .TTB3({8{TTB3}}) );
	cntbit cnt_hi [7:0] ( .val_in(~dbq), .cin(xa_hi), .val_out(adh), .cout(mq_hi), .TTB2({8{TTB2}}), .TTB3({8{TTB3}}) );
	cntbit_carry_chain carry_chain ( .CLK4(CLK4), .TTB1(TTB1), .TTB2(TTB2), .TTB3(TTB3), .mq({mq_hi,mq_lo}), .xa({xa_hi,xa_lo}) );

	// The AddrBus value is formed on the basis of the bus keeper values of the cbus/dbus.

	assign AddrBus = ~BUS_DISABLE ? {~dbq,~cbq} : 16'hzz;

endmodule // IncDec

module cntbit ( val_in, cin, val_out, cout, TTB2, TTB3 );

	input val_in;
	input cin;
	output val_out;
	output cout;
	input TTB2;
	input TTB3;

	assign val_out = val_in ^ cin;
	assign cout = ~val_in ? TTB2 : TTB3;

endmodule // cntbit

module cntbit_carry_chain ( CLK4, TTB1, TTB2, TTB3, mq, xa );

	input CLK4;
	input TTB1;
	input TTB2;
	input TTB3;
	input [15:0] mq;
	output [15:0] xa;

	wire [15:0] nxa;
	wire ct;

	assign nxa[0] = ~(TTB2 | TTB3);

	assign nxa[1] = CLK4 ? (~(mq[0])) : 1'b1;
	assign nxa[2] = CLK4 ? (~(mq[0] & mq[1])) : 1'b1;
	assign nxa[3] = CLK4 ? (~(mq[0] & mq[1] & mq[2])) : 1'b1;
	assign nxa[4] = CLK4 ? (~(mq[0] & mq[1] & mq[2] & mq[3])) : 1'b1;
	assign nxa[5] = CLK4 ? (~(mq[0] & mq[1] & mq[2] & mq[3] & mq[4])) : 1'b1;
	assign nxa[6] = CLK4 ? (~(mq[0] & mq[1] & mq[2] & mq[3] & mq[4] & mq[5])) : 1'b1;
	wire nxa7 = CLK4 ? (~(mq[0] & mq[1] & mq[2] & mq[3] & mq[4] & mq[5] & mq[6])) : 1'b1;
	assign nxa[7] = nxa7; // workaround for circular logic in verilator

	assign ct = (mq[7] & ~nxa7) | TTB1;
	assign nxa[8] = CLK4 ? (~(ct)) : 1'b1;
	assign nxa[9] = CLK4 ? (~(ct & mq[8])) : 1'b1;
	assign nxa[10] = CLK4 ? (~(ct & mq[8] & mq[9])) : 1'b1;
	assign nxa[11] = CLK4 ? (~(ct & mq[8] & mq[9] & mq[10])) : 1'b1;
	assign nxa[12] = CLK4 ? (~(ct & mq[8] & mq[9] & mq[10] & mq[11])) : 1'b1;
	assign nxa[13] = CLK4 ? (~(ct & mq[8] & mq[9] & mq[10] & mq[11] & mq[12])) : 1'b1;
	assign nxa[14] = CLK4 ? (~(ct & mq[8] & mq[9] & mq[10] & mq[11] & mq[12] & mq[13])) : 1'b1;
	assign nxa[15] = CLK4 ? (~(ct & mq[8] & mq[9] & mq[10] & mq[11] & mq[12] & mq[13] & mq[14])) : 1'b1;

	assign xa = ~nxa;

endmodule // cntbit_carry_chain

// Separated from Bottom.v to Top.v

module IRQ_Logic ( CLK3, CLK4, CLK5, CLK6, DL, RD, CPU_IRQ_ACK, CPU_IRQ_TRIG, bro, bot_to_Thingy, Thingy_to_bot, SYNC_RES,
	SeqControl_1, SeqControl_2, SeqOut_1, d93, A );

	input CLK3;
	input CLK4;
	input CLK5;
	input CLK6;
	inout [7:0] DL;			// DataBus
	input RD;
	output [7:0] CPU_IRQ_ACK;
	input [7:0] CPU_IRQ_TRIG;
	output [7:3] bro;			// Int address  ("Bottom Right output")
	output bot_to_Thingy;			// 1: Access to IE detected
	input Thingy_to_bot;			// 1: Write Access to IE detected (Load IE from DataBus)
	input SYNC_RES;
	output SeqControl_1; 			// 1: Wake up after an interrupt. Used in HLT opcode processing.
	output SeqControl_2;
	input SeqOut_1;			// IME?
	input d93; 			// 1: Enable IRQ processing by Decoder1, 0: disable
	input [15:0] A;			// To check the address for the value 0xffff (IE)

	// Internal

	wire sc1; 			// "Seq control 1"
	wire sc2; 			// "Seq control 2"
	wire nso;		// "~Seq Out (1)"
	wire [7:0] ieq; 		// IE output
	wire [7:0] ienq;		// IE output (complement)
	wire [7:0] ifq;		// IF output
	wire [7:0] ifnq; 	// IF output (complement)
	wire [7:0] ack; 	// Acknowledged

	// IE/IF
	module7 IE [7:0] ( .clk({8{CLK6}}), .cclk({8{CLK5}}), .d(DL), .ld({8{Thingy_to_bot}}), .res({8{SYNC_RES}}), .q(ieq), .nq(ienq) );
	module8 IF [7:0] ( .clk({8{CLK3}}), .cclk({8{CLK4}}), .d(~(ieq&CPU_IRQ_TRIG)), .q(ifq), .nq(ifnq) );
	assign DL = (RD & bot_to_Thingy) ? ienq : 8'bzzzzzzzz; 	// znand3.

	// Breadcrumps
	assign nso = ~SeqOut_1;
	assign sc1 = ~(ifnq[0]|ifnq[1]|ifnq[2]|ifnq[3]|ifnq[4]|ifnq[5]|ifnq[6]|ifnq[7]|~nso);
	assign sc2 = CLK6 ? ~(ack[0]|ack[1]|ack[2]|ack[3]|ack[4]|ack[5]|ack[6]|ack[7]) : 1'b1;
	assign bot_to_Thingy = (A[0]&A[1]&A[2]&A[3]&A[4]&A[5]&A[6]&A[7]&A[8]&A[9]&A[10]&A[11]&A[12]&A[13]&A[14]&A[15]); 	// Addr == 0xffff

	// Priority encoder
	assign ack[0] = ~(CLK6 ? ~(ifnq[0]&nso) : 1'b1);
	assign ack[1] = ~(CLK6 ? ~(ifnq[1]&ifq[0]&nso) : 1'b1);
	assign ack[2] = ~(CLK6 ? ~(ifnq[2]&ifq[0]&ifq[1]&nso) : 1'b1);
	assign ack[3] = ~(CLK6 ? ~(ifnq[3]&ifq[0]&ifq[1]&ifq[2]&nso) : 1'b1);
	assign ack[4] = ~(CLK6 ? ~(ifnq[4]&ifq[0]&ifq[1]&ifq[2]&ifq[3]&nso) : 1'b1);
	assign ack[5] = ~(CLK6 ? ~(ifnq[5]&ifq[0]&ifq[1]&ifq[2]&ifq[3]&ifq[4]&nso) : 1'b1);
	assign ack[6] = ~(CLK6 ? ~(ifnq[6]&ifq[0]&ifq[1]&ifq[2]&ifq[3]&ifq[4]&ifq[5]&nso) : 1'b1);
	assign ack[7] = ~(CLK6 ? ~(ifnq[7]&ifq[0]&ifq[1]&ifq[2]&ifq[3]&ifq[4]&ifq[5]&ifq[6]&nso) : 1'b1);

	// Interrupt address
	assign bro[3] = ~(CLK6 ? (~(CPU_IRQ_ACK[1]|CPU_IRQ_ACK[3]|CPU_IRQ_ACK[5]|CPU_IRQ_ACK[7])) : 1'b1);
	assign bro[4] = ~(CLK6 ? (~(CPU_IRQ_ACK[2]|CPU_IRQ_ACK[3]|CPU_IRQ_ACK[6]|CPU_IRQ_ACK[7])) : 1'b1);
	assign bro[5] = ~(CLK6 ? (~(CPU_IRQ_ACK[4]|CPU_IRQ_ACK[5]|CPU_IRQ_ACK[6]|CPU_IRQ_ACK[7])) : 1'b1);
	assign bro[6] = ~sc2 & d93;
	assign bro[7] = ~nso & d93;

	assign SeqControl_1 = ~sc1;
	assign SeqControl_2 = ~sc2;
	assign CPU_IRQ_ACK = ack & {8{d93}};

endmodule // IRQ_Logic

module module7 ( clk, cclk, d, ld, res, q, nq );

	input clk;
	input cclk;
	input d;
	input ld;
	input res;
	output q;
	output nq;

	// Latch (no CLK edge detection, yes ld edge detection) with reset.

	reg val_in;
	reg val_out;
	initial val_in = 1'b0;
	initial val_out = 1'b0;

	always @(*) begin
		if (clk && ld)
			val_in = d;
		if (res)
			val_in = 1'b0;
	end

	always @(negedge ld) begin
		val_out <= val_in;
	end

	assign q = val_out;
	assign nq = ~q;

endmodule // module7

module module8 ( clk, cclk, d, q, nq );

	input clk;
	input cclk;
	input d;
	output q;
	output nq;

	// Regular (transparent) latch (no edge detection), to store the interrupt flag.

	reg val;
	initial val = 1'bx;

	always @(*) begin
		if (clk)
			val = d;
	end

	assign q = val;
	assign nq = ~q;

endmodule // module8