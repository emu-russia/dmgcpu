# Decoder1

![locator_decoder1](/imgstore/sm83/locator_decoder1.png)

Decoder1 makes a preliminary decoding of the operation code, which will then be refined in Decoder2.

Topology features:

![decoder1](/imgstore/sm83/decoder1.jpg)

- Each decoder output is a branched NAND
- The output of a whole NAND tree can be `0` only when all inputs of _at least one_ "branch" are equal to `1`.
- During CLK = 0 a Precharge is made
- During CLK = 1 an operation (Eval) is committed
- Value is inverted by regular CMOS inverter

Dynamic logic is used.

## Decoder1 Inputs

|Input|From|Gekkio|Meaning|
|---|---|---|---|
|a0|Inplace| |~a1|
|a1|Sequencer|intr_dispatch|1: IRQ sequence in progress|
|a2|Inplace| |~a3|
|a3|Sequencer|cb_mode|1: CB Opcode prefix|
|a4|Inplace| |~a5|
|a5|IR| |IR\[7\]|
|a6|Inplace| |~a7|
|a7|IR| |IR\[6\]|
|a8|Inplace| |~a9|
|a9|IR| |IR\[5\]|
|a10|Inplace| |~a11|
|a11|IR| |IR\[4\]|
|a12|Inplace| |~a13|
|a13|IR| |IR\[3\]|
|a14|Inplace| |~a15|
|a15|IR| |IR\[2\]|
|a16|Inplace| |~a17|
|a17|IR| |IR\[1\]|
|a18|Inplace| |~a19|
|a19|IR| |IR\[0\]|
|a20|Sequencer|~state\[2\] (state3 msb, inverted)|0: state2 active|
|a21|Inplace| |~a20|
|a22|Sequencer|~state\[1\]|0: state1 active|
|a23|Inplace| |~a22|
|a24|Sequencer|~state\[0\] (state3 lsb, inverted)|0: state0 active|
|a25|Inplace| |~a24|

## Decoder1 Output Drivers

![decoder1_drv](/imgstore/modules/sm83/decoder1_drv.jpg)

The output drivers act as signal amplifiers and are also used as "domino" logic, to translate dynamic CMOS logic into conventional logic.

## Decoder1 Output Trees

:warning: Some inputs are twisted, be careful (e.g. a9 for the first three values).

|Tree|Gekkio|Paths|To|Description|
|---|---|---|---|---|
|d0|op_ld_nn_a_s010 |{0,2,5,7,9,10,13,14,17,18,20,23,24}| | |
|d1|op_ld_a_nn_s010 |{0,2,5,7,9,11,13,14,17,18,20,23,24}| | |
|d2|op_ld_a_nn_s011 |{0,2,5,7,9,11,13,14,17,18,20,23,25}| | |
|d3|op_alu8 |{0,2,({5,6},{5,7,15,17,18})}| |All ALU opcodes in range 0x80-0xbf + ALU opcodes 0xc6/0xce, 0xd6/0xde, 0xe6/0xee, 0xf6/0xfe ("bottom yellow")|
|d4|op_jp_cc_sx01 |{0,2,5,7,8,14,17,18,22,25}| | |
|d5|op_call_cc_sx01 |{0,2,5,7,8,15,16,18,22,25}| | |
|d6|op_ret_cc_sx00 |{0,2,5,7,8,14,16,18,22,24}| | |
|d7|op_jr_cc_sx00 |{0,2,4,6,9,14,16,18,22,24}| | |
|d8|op_ldh_a_x |{0,2,5,7,9,11,12,14,18}|Decoder3 (not used in Decoder2)| |
|d9|op_call_any_s000 |{0,2,5,7,8,({10,13,15,16},{15,16,18}),20,22,24}| | |
|d10|op_call_any_s001 |{0,2,5,7,8,({10,13,15,16},{15,16,18}),20,22,25}| | |
|d11|op_call_any_s010 |{0,2,5,7,8,({10,13,15,16},{15,16,18}),20,23,24}| | |
|d12|op_call_any_s011 |{0,2,5,7,8,({10,13,15,16},{15,16,18}),20,23,25}| | |
|d13|op_call_any_s100 |{0,2,5,7,8,({10,13,15,16},{15,16,18}),21,22,24}| | |
|d14|op_ld_x_n |{0,2,4,6,15,17,18}|Decoder3 (not used in Decoder2)|LD reg/(HL),d8|
|d15|op_ld_x_n_sx00 |{0,2,4,6,15,17,18,22,24}| | |
|d16|op_ld_r_n_sx01 |{0,2,4,6,({13},{10},{8}),15,17,18,22,25}| | |
|d17|op_s110 |{0,2,21,23,24}| | |
|d18|op_s111 |{2,21,23,25}| | |
|d19|op_jr_any_sx01 |{0,2,4,6,({9,14,16,18},{8,11,13,14,16,18}),22,25}| | |
|d20|op_jr_any_sx00 |{0,2,4,6,({9,14,16,18},{8,11,13,14,16,18}),22,24}| | |
|d21|op_add_sp_e_s010 |{0,2,5,7,9,10,13,14,16,18,20,23,24}| | |
|d22|op_ld_hl_sp_sx10 |{0,2,5,7,9,11,13,14,16,18,23,24}| | |
|d23|cb_res_r_sx00 |{0,3,5,6,({14},{16},{19}),22,24}| | |
|d24|cb_res_hl_sx01 |{0,3,5,6,15,17,18,22,25}| | |
|d25|op_rotate_a |{0,2,4,6,8,15,17,19}|Decoder3 (not used in Decoder2)|Rotate instructions (RLCA/RRCA/RLA/RRA)|
|d26|op_ld_a_rr_sx01 |{0,2,4,6,13,14,17,18,22,25}| | |
|d27|cb_bit |{0,3,4,7}| | |
|d28|op_ld_rr_a_sx00 |{0,2,4,6,12,14,17,18,22,24}| | |
|d29|op_ld_a_rr_sx00 |{0,2,4,6,13,14,17,18,22,24}| | |
|d30|op_ldh_c_a_sx00 |{0,2,5,7,9,10,12,14,17,18,22,24}| | |
|d31|op_ldh_n_a_sx00 |{0,2,5,7,9,10,12,14,16,18,22,24}| | |
|d32|op_ldh_n_a_sx01 |{0,2,5,7,9,10,12,14,16,18,22,25}| | |
|d33|op_ld_r_hl_sx00 |{0,2,4,({7,8},{7,10},{7,13}),15,17,18,22,24}| | |
|d34|op_alu_misc_s0xx |{0,2,4,6,15,17,19,20}|Decoder3 (also)|All rotate and flag opcodes (x7/xF) in range 0x00-0x3f|
|d35|op_add_hl_sxx0 |{0,2,4,6,13,14,16,19,24}| |All ADD HL,r16 opcodes (0x09,0x19,0x29,0x39)|
|d36|op_dec_rr_sx00 |{0,2,4,6,13,14,17,19,22,24}| | |
|d37|op_inc_rr_sx00 |{0,2,4,6,12,14,17,19,22,24}| | |
|d38|op_push_sx01 |{0,2,5,7,12,15,16,19,22,25}|Decoder3 (also)|Push opcodes (0xc5,0xd5,0xe5,0xf5)|
|d39|op_push_sx00 |{0,2,5,7,12,15,16,19,22,24}| | |
|d40|op_ld_r_r_s0xx |{0,2,4,7,({8},{10},{13}),({19},{16},{14}),20}| |All LD opcodes in range 0x40-0x7f, except using (HL) and HALT.|
|d41|op_40_to_7f |{0,2,4,7}|Decoder3 (not used in Decoder2)|All LD reg/(HL), (HL)/reg, including HALT (in range 0x40-0x7f)|
|d42|cb_00_to_3f |{0,3,4,6}|Decoder3, ALU, Bottom (not used in Decoder2)|Pop opcodes (0xc1, 0xd1, 0xe1, 0xf1)|
|d43|op_jp_any_sx00 |{0,2,5,7,8,({10,12,14,17},{14,17,18}),22,24}| | |
|d44|op_jp_any_sx01 |{0,2,5,7,8,({10,12,14,17},{14,17,18}),22,25}| | |
|d45|op_jp_any_sx10 |{0,2,5,7,8,({10,12,14,17},{14,17,18}),23,24}| | |
|d46|op_add_hl_sx01 |{0,2,4,6,13,14,16,19,22,25}| | |
|d47|op_ld_hl_n_sx01 |{0,2,4,6,9,11,12,15,17,18,22,25}| | |
|d48|_ignored_|{24,25}|:warning: Not used| |
|d49|_ignored_|{24,25}|:warning: Not used| |
|d50|op_push_sx10 |{0,2,5,7,12,15,16,19,23,24}| | |
|d51|op_pop_sx00 |{0,2,5,7,12,14,16,19,22,24}| | |
|d52|op_pop_sx01 |{0,2,5,7,12,14,16,19,22,25}| | |
|d53|op_add_sp_s001 |{0,2,5,7,9,10,13,14,16,18,20,22,25}| | |
|d54|op_ld_hl_sp_sx01 |{0,2,5,7,9,11,13,14,16,18,22,25}| | |
|d55|cb_set_r_sx00 |{0,3,5,7,({14},{16},{19}),22,24}| | |
|d56|cb_set_hl_sx01 |{0,3,5,7,15,17,18,22,25}| | |
|d57|cb_set_res_hl_sx00 |{0,3,5,15,17,18,22,24}| | |
|d58|op_pop_sx10 |{0,2,5,7,12,14,16,19,23,24}|ALU (also)| |
|d59|op_ldh_a_n_sx01 |{0,2,5,7,9,11,12,14,16,18,22,25}| | |
|d60|op_ld_nn_sp_s010 |{0,2,4,6,8,10,13,14,16,18,20,23,24}|Bottom (also)| |
|d61|op_ld_nn_sp_s000 |{0,2,4,6,8,10,13,14,16,18,20,22,24}| | |
|d62|op_ld_sp_hl_sx00 |{0,2,5,7,9,11,13,14,16,19,22,24}|Decoder3 (also)| |
|d63|op_add_sp_e_s000 |{0,2,5,7,9,10,13,14,16,18,20,22,24}| | |
|d64|op_add_sp_e_s011 |{0,2,5,7,9,10,13,14,16,18,20,23,25}|Decoder3 (also)| |
|d65|op_ld_hl_sp_sx00 |{0,2,5,7,9,11,13,14,16,18,22,24}| | |
|d66|op_ld_nn_sp_s011 |{0,2,4,6,8,10,13,14,16,18,20,23,25}| | |
|d67|op_ld_nn_sp_s001 |{0,2,4,6,8,10,13,14,16,18,20,22,25}| | |
|d68|op_ld_hl_r_sx00 |{0,2,4,7,9,11,12,({19},{16},{14}),22,24}| | |
|d69|op_incdec8_hl_sx00 |{0,2,4,6,9,11,12,15,16,22,24}| | |
|d70|op_incdec8_hl_sx01 |{0,2,4,6,9,11,12,15,16,22,25}| | |
|d71|op_ldh_a_c_sx00 |{0,2,5,7,9,11,12,14,17,18,22,24}| | |
|d72|op_ldh_a_n_sx00 |{0,2,5,7,9,11,12,14,16,18,22,24}| | |
|d73|op_rst_sx01 |{0,2,5,7,15,17,19,22,25}| | |
|d74|op_rst_sx00 |{0,2,5,7,15,17,19,22,24}| | |
|d75|int_s101 |{1,2,21,22,25}| | |
|d76|int_s100 |{1,2,21,22,24}| | |
|d77|int_s000 |{1,2,20,22,24}| | |
|d78|op_80_to_bf_reg_s0xx |{0,2,5,6,({16},{14},{19}),20}| | |
|d79|op_ret_reti_sx00 |{0,2,5,7,8,13,14,16,19,22,24}| | |
|d80|op_ret_cc_sx01 |{0,2,5,7,8,14,16,18,22,25}| | |
|d81|op_jp_hl_s0xx |{0,2,5,7,9,10,13,14,16,19,20}| | |
|d82|op_ret_any_reti_s010 |{0,2,5,7,8,({13,14,16},{14,16,18}),20,23,24}| | |
|d83|op_ret_any_reti_s011 |{0,2,5,7,8,({13,14,16},{14,16,18}),20,23,25}|Decoder3 (also)| |
|d84|op_ld_hlinc_sx00 |{0,2,4,6,9,10,14,17,18,22,24}| | |
|d85|op_ld_hldec_sx00 |{0,2,4,6,9,11,14,17,18,22,24}| | |
|d86|op_ld_rr_sx00 |{0,2,4,6,12,14,16,19,22,24}| | |
|d87|op_ld_rr_sx01 |{0,2,4,6,12,14,16,19,22,25}| | |
|d88|op_ld_rr_sx10 |{0,2,4,6,12,14,16,19,23,24}|Decoder3 (also). Long wire.| |
|d89|op_incdec8_s0xx |{0,2,4,6,({13},{10},{8}),15,16,20}| | |
|d90|op_alu_hl_sx00 |{0,2,5,6,15,17,18,22,24}| | |
|d91|op_alu_n_sx00 |{0,2,5,7,15,17,18,22,24}| | |
|d92|op_rst_sx10 |{0,2,5,7,15,17,19,23,24}|Bottom (also)| |
|d93|int_s110 |{1,2,21,23,24}|Decoder3, Bottom (also)| |
|d94|cb_r_s0xx |{0,3,({19},{14},{16}),20}| | |
|d95|cb_hl_sx00 |{0,3,15,17,18,22,24}| | |
|d96|cb_bit_hl_sx01 |{0,3,4,7,15,17,18,22,25}| | |
|d97|cb_notbit_hl_sx01 |{0,3,6,15,17,18,22,25}| | |
|d98|op_incdec8 |{0,2,4,6,15,16}| |INC/DEC reg/(HL)|
|d99|op_di_ei_s0xx |{0,2,5,7,9,11,14,17,19,20}|Sequencer (also)| |
|d100|op_halt_s0xx |{0,2,4,7,9,11,12,15,17,18,20}|Sequencer (also)| |
|d101|op_nop_stop_s0xx |{0,2,4,6,8,12,14,16,18,20}|Sequencer (also)|NOP/STOP|
|d102|op_cb_s0xx |{0,2,5,7,8,10,13,14,17,19,20}|Sequencer (also)| |
|d103|op_jr_any_sx10 |{0,2,4,6,({8,11,13,14,16,18},{9,14,16,18}),23,24}| | |
|d104|op_ea_fa_s000 |{0,2,5,7,9,13,14,17,18,20,22,24}| | |
|d105|op_ea_fa_s001 |{0,2,5,7,9,13,14,17,18,20,22,25}| | |
|d106|_ignored_|{24,25}|:warning: Not used| |

The numbers in the tree path mark the inputs `a[25:0]`.

The result should be as follows (using d3 as an example, the dynamical part of the logic is not shown):

![demo_d3](/imgstore/sm83/demo_d3.jpg)

The `To` outputs are marked only for those that go somewhere else besides Decoder2.

To convert trees into a schematic, you can use a script to generate an HDL.
