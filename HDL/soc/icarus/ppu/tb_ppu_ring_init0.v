// tb_ppu_ring_init0 - probe: no-reset FF power-on state + obj_prio_ck activity.
//
// Experiment (issue #390, obj_prio_ck not ticking):
//   * the flip-flops that have NO async reset in the netlist
//     (PPU1 g286/g325/g326, PPU1 g882..g889, PPU2 g938..g943 scan-address
//     register, nr1 = nr2 = const-1) are requested to start at 0, not x.
//   * dmglib dffr-family cells already declare `initial val = 1'b0`, so this
//     testbench *verifies* the boot state (registers are 0, never x) and then
//     measures the obj_prio_ck / sprite-ring activity per line.
// Dev test: prints a report, no PASS/FAIL asserts.
`timescale 1ns/1ns

module tb_ppu_ring_init0;

	ppu_env env();

	integer k, q;

	initial begin
		$dumpfile("tb_ppu_ring_init0.vcd");
		$dumpvars(0, tb_ppu_ring_init0);
		#(64*8);
		env.reset = 1'b0;
		#(64*4);

		// OAM entry 0: sprite at Y=16, X=16, tile 1 (off-screen checks skipped)
		env.oam.mem[0] = 8'h10;
		env.oam.mem[1] = 8'h10;
		env.oam.mem[2] = 8'h01;
		env.oam.mem[3] = 8'h00;

		// PPU: LCD on, BG on, OBJ on, 8x8 sprites
		env.cpu_write(16'hFF40, 8'h93);   // bit7 + bit1(OBJ) + bit0(BG)
		env.cpu_write(16'hFF42, 8'h00);
		env.cpu_write(16'hFF43, 8'h00);
		env.cpu_write(16'hFF47, 8'hE4);
		env.cpu_write(16'hFF48, 8'hE4);   // OBP0

		// ---- boot-state report of the no-reset FFs (sampled just after the
		// PPU is enabled; the cells power up from their `initial val = 0`) ----
		$display("BOOT t=%0t", $time);
		$display("  PPU1 g286 (nr=w47=1): val=%0b -> nq w239=%0b  g325: val(w185)=%0b  g326: nq(w184)=%0b  w530=%0b",
			env.ppu1.g286.val, env.ppu1.w239, env.ppu1.w185, env.ppu1.w184, env.ppu1.w530);
		$display("  PPU1 ring: g287(w228)=%0b g288(w522)=%0b g289(w226)=%0b  w227=%0b w964=%0b w965=%0b  w815=%0b  w816=%0b",
			env.ppu1.g287.val, env.ppu1.g288.val, env.ppu1.g289.val,
			env.ppu1.w227, env.ppu1.w964, env.ppu1.w965, env.ppu1.w815, env.ppu1.w816);
		$display("  PPU1 g882..g889 (dffr_comp, nr=w47): %b %b %b %b %b %b %b %b",
			env.ppu1.g882.val, env.ppu1.g883.val, env.ppu1.g884.val, env.ppu1.g885.val,
			env.ppu1.g886.val, env.ppu1.g887.val, env.ppu1.g888.val, env.ppu1.g889.val);
		$display("  PPU2 scan-addr g938..g943 (dffrnq_comp, nr=w149): val=%b%b%b%b%b%b nq=%b %b %b %b %b %b",
			env.ppu2.g938.val, env.ppu2.g939.val, env.ppu2.g940.val, env.ppu2.g941.val,
			env.ppu2.g942.val, env.ppu2.g943.val,
			env.ppu2.w212, env.ppu2.w531, env.ppu2.w652, env.ppu2.w490, env.ppu2.w840, env.ppu2.w649);

		// ---- per-line activity over 5 lines ----
		begin : probe
			integer ln;
			reg  prev_opc, prev_ord, prev_oadd, prev_w852;
			integer opc_edges, oam_rd_edges, oam_addr_edges, w852_edges;
			reg   w239_low, w240_low, cond_hi, w816_low, w530_hi;
			reg   p2_w816_hi, p2_w852_hi, p2_w209_hi;
			integer t0, t1;
			prev_opc = 1'b0;
			prev_ord = 1'b0;
			prev_oadd = 1'b0;
			prev_w852 = 1'b0;
			for (ln = 1; ln <= 5; ln = ln + 1) begin
				@(posedge env.ppu_mode2);     // line start (mode 2)
				t0 = $time;
				opc_edges = 0; oam_rd_edges = 0; oam_addr_edges = 0; w852_edges = 0;
				w239_low = 1'b0; w240_low = 1'b0; cond_hi = 1'b0;
				w816_low = 1'b0; w530_hi = 1'b0;
				p2_w816_hi = 1'b0; p2_w852_hi = 1'b0; p2_w209_hi = 1'b0;
				prev_opc = env.obj_prio_ck;
				prev_ord = env.oam_rd_ck;
				prev_oadd = env.oam_addr_ck;
				prev_w852 = env.ppu2.w852;
				// sample the whole line: 29184 ns / 8 ns = 3648 samples + slack
				for (q = 0; q < 4200; q = q + 1) begin
					if (env.obj_prio_ck === 1'b1 && prev_opc === 1'b0) opc_edges = opc_edges + 1;
					if (env.oam_rd_ck === 1'b1 && prev_ord === 1'b0) oam_rd_edges = oam_rd_edges + 1;
					if (env.oam_addr_ck === 1'b1 && prev_oadd === 1'b0) oam_addr_edges = oam_addr_edges + 1;
					if (env.ppu2.w852 === 1'b1 && prev_w852 === 1'b0) w852_edges = w852_edges + 1;
					prev_opc = env.obj_prio_ck;
					prev_ord = env.oam_rd_ck;
					prev_oadd = env.oam_addr_ck;
					prev_w852 = env.ppu2.w852;
					if (env.ppu1.w239 === 1'b0) w239_low = 1'b1;
					if (env.ppu1.w240 === 1'b0) w240_low = 1'b1;
					if (env.ppu1.w228 === 1'b1 && env.ppu1.w229 === 1'b1 &&
					    env.ppu1.w241 === 1'b1) cond_hi = 1'b1;
					if (env.ppu1.w816 === 1'b0) w816_low = 1'b1;
					if (env.ppu1.w530 === 1'b1) w530_hi = 1'b1;
					if (env.ppu2.w816 === 1'b1) p2_w816_hi = 1'b1;  // Y-test AND6 group
					if (env.ppu2.w852 === 1'b1) p2_w852_hi = 1'b1;  // store/claim window
					if (env.ppu2.w209 === 1'b1) p2_w209_hi = 1'b1;
					#8;
				end
				t1 = $time;
				$display("LINE %0d t=%0d..%0d", ln, t0, t1);
				$display("  PPU1: obj_prio_ck_edges=%0d w239_low=%0b w240_low=%0b (w228&w229&w241)_hi=%0b w816_dip=%0b w530_hi=%0b ring: w228=%0b w522=%0b w226=%0b w239=%0b",
					opc_edges, w239_low, w240_low, cond_hi, w816_low, w530_hi,
					env.ppu1.w228, env.ppu1.w522, env.ppu1.w226, env.ppu1.w239);
				$display("  PPU2: oam_rd_ck_edges=%0d oam_addr_ck_edges=%0d scan(g938..943)val=%b%b%b%b%b%b Ytest_w816_hi=%0b w209_hi=%0b store_w852_edges=%0d/%0b",
					oam_rd_edges, oam_addr_edges,
					env.ppu2.g938.val, env.ppu2.g939.val, env.ppu2.g940.val,
					env.ppu2.g941.val, env.ppu2.g942.val, env.ppu2.g943.val,
					p2_w816_hi, p2_w209_hi, w852_edges, p2_w852_hi);
			end
		end
		$display("PROBE DONE");
		$finish;
	end

endmodule
