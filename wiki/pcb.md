# Reference DMG PCB

Used for design verification.

DMG-CPU-06 motherboard netlist has been reconstructed from @Gekkio's image:

![DMG-CPU-06](/imgstore/DMG-CPU-06.png)

Netlist:

![DMG-CPU-06_netlist](/imgstore/DMG-CPU-06_netlist.png)

Verilog model:

```verilog
// DMG-CPU-06 PCB netlist
// Original image by @Gekkio (https://github.com/Gekkio/gb-schematics/blob/main/DMG-CPU-06/schematic/DMG-CPU-06.pdf)

module dmg_pcb (  sin, sout, sck, n_res, p14);

	input wire sin;
	output wire sout;
	inout wire sck;
	input wire n_res;
	output wire p14;

	// Wires

	wire w1;
	wire w2;
	wire w3;
	wire w4;
	wire w5;
	wire w6;
	wire w7;
	wire w9;
	wire w11;
	wire w12;
	wire w13;
	wire [12:0] w14; 		// MA
	wire [7:0] w15; 		// MD
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
	wire [15:0] w28; 		// A
	wire [7:0] w29; 	// D
	wire w31;
	wire w32;
	wire w33;
	wire w34;
	wire w35;
	wire w36;
	wire w37;
	wire w38;

	assign w6 = sin;
	assign sout = w7;
	assign sck = w5;
	assign w9 = n_res;
	assign p14 = w25;

	// Instances

	pcb_dmg_cpu u1 (.d(w29), .md(w15), .sck(w5), .sin(w6), .sout(w7), .so1(w3), .so2(w4), .ck1(w1), .ck2(w2), .n_res(w9), .a(w28), .ma(w14), .n_rd(w35), .n_cs(w37), .n_wr(w36), .phi(w27),
		.t1(1'b0), .t2(1'b0), .cpg(w21), .cp(w20), .cpl(w18), .fr(w17), .ld0(w23), .ld1(w24), .s(w16), .st(w19), .p14(w25), .p15(w26), .p10(w31), .p11(w32), .p12(w33), .p13(w34), .n_mrd(w11), .n_mcs(w12), .n_mwr(w13), .vin(w38) );
	pcb_sys_clock x1 (.ck_out(w1), .ck_in(w2) );
	pcb_LH5164LN u2 (.a(w14), .n_ce1(w12), .ce2(1'b1), .n_we(w13), .n_oe(w11), .io(w15) );
	pcb_front_board p2 (.p10(w31), .p11(w32), .p13(w34), .p12(w33), .p14(w25), .p15(w26), .s(w16), .fr(w17), .cp(w20), .ld1(w24), .ld0(w23), .st(w19), .cpl(w18), .cpg(w21), .sp(w22) );
	pcb_cartridge_slot p1 (.n_res(w9), .phi(w27), .n_wr(w36), .n_rd(w35), .n_cs(w37), .a(w28), .d(w29), .cart_to_vin(w38) );
	pcb_aux p3 (.so_right(w3), .so_left(w4), .sp_out(w22) );
	pcb_LH5164LN u3 (.a(w28[12:0]), .n_ce1(w37), .ce2(w28[14]), .n_we(w36), .n_oe(w35), .io(w29) );
endmodule // dmg_pcb

// Module Definitions [It is possible to wrap here on your primitives]

module pcb_dmg_cpu (  d, md, sck, sin, sout, so1, so2, ck1, ck2, n_res, a, ma, n_rd, n_cs, n_wr, phi,
	t1, t2, cpg, cp, cpl, fr, ld0, ld1, s, st, p14, p15, p10, p11, p12, p13, n_mrd, n_mcs, n_mwr, vin, n_nmi, m1);

	inout wire [7:0] d;
	inout wire [7:0] md;
	inout wire sck;
	inout wire sin;
	output wire sout;
	output wire so1;
	output wire so2;
	input wire ck1;
	output wire ck2;
	input wire n_res;
	inout wire [15:0] a;
	output wire [12:0] ma;
	inout wire n_rd;
	output wire n_cs;
	inout wire n_wr;
	output wire phi;
	input wire t1;
	input wire t2;
	output wire cpg;
	output wire cp;
	output wire cpl;
	output wire fr;
	output wire ld0;
	output wire ld1;
	output wire s;
	output wire st;
	output wire p14;
	output wire p15;
	inout wire p10;
	inout wire p11;
	inout wire p12;
	inout wire p13;
	inout wire n_mrd;
	inout wire n_mcs;
	inout wire n_mwr;
	input wire vin;
	input wire n_nmi;
	output wire m1;

endmodule // pcb_dmg_cpu

module pcb_sys_clock (  ck_out, ck_in);

	output wire ck_out;
	input wire ck_in;

endmodule // pcb_sys_clock

module pcb_LH5164LN (  a, n_ce1, ce2, n_we, n_oe, io);

	input wire [12:0] a;
	input wire n_ce1;
	input wire ce2;
	input wire n_we;
	input wire n_oe;
	inout wire [7:0] io;

endmodule // pcb_LH5164LN

module pcb_front_board (  p10, p11, p13, p12, p14, p15, s, fr, cp, ld1, ld0, st, cpl, cpg, sp);

	inout wire p10;
	inout wire p11;
	inout wire p13;
	inout wire p12;
	input wire p14;
	input wire p15;
	input wire s; 			// Common display sync signal (VSync). Used as input value for the Y-Driver shift register
	input wire fr; 			// LCD alterating signal; FR is used to stop the LCD plating out (destroying the LCD material with DC), it inverts the drivers
	input wire cp;
	input wire ld1;
	input wire ld0;
	input wire st;
	input wire cpl; 		// Signal data latch signal. Used as CLK for Y-Driver chip
	input wire cpg;
	input wire sp;

endmodule // pcb_front_board

module pcb_cartridge_slot (  n_res, phi, n_wr, n_rd, n_cs, a, d, cart_to_vin);

	input wire n_res;
	input wire phi;
	input wire n_wr;
	input wire n_rd;
	input wire n_cs;
	input wire [15:0] a;
	inout wire [7:0] d;
	output wire cart_to_vin;

endmodule // pcb_cartridge_slot

module pcb_aux (  so_right, so_left, sp_out);

	input wire so_right;
	input wire so_left;
	output wire sp_out;

endmodule // pcb_aux
```