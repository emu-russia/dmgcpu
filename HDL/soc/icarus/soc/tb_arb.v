// tb_arb - Arbiter testbench (issue #396)
//
// Address-decode sweep of the Arbiter outputs (mmio_sel/boot_sel/ffxx/
// non_vram_mreq/arb_fexx_ffxx), the $FF50 BANK register effect on
// boot_sel, and the external /CS//MRD//MWR pad-drive outputs during CPU
// bus cycles.
`timescale 1ns/1ns

module tb_arb;

	soc_env env();

	integer checks = 0;
	integer cs_lows = 0;
	reg watch_cs = 1'b0;
	always @(negedge env.n_cs_topad) if (watch_cs) cs_lows = cs_lows + 1;
	integer fails = 0;
	task chk(input [127:0] name, input ok);
		begin
			checks = checks + 1;
			if (ok) $display("RESULT %0s PASS", name);
			else begin
				fails = fails + 1;
				$display("RESULT %0s FAIL", name);
			end
		end
	endtask

	integer ncs = 0;
	reg watch_ncs = 1'b0;
	always @(posedge env.n_cs_topad) if (watch_ncs) ncs = ncs + 1;

	// CPU read with a /CS-pulse counter
	task r8cs(input [15:0] addr, output [7:0] v, output integer pulses);
		begin
			ncs = 0;
			watch_ncs = 1'b1;
			env.cpu_read(addr, v);
			watch_ncs = 1'b0;
			pulses = ncs;
		end
	endtask

	// sample the decode outputs for one address
	task probe_addr(input [15:0] addr, input [127:0] tag);
		begin
			env.cpu_a = addr;
			env.cpu_mreq = 1'b1;
			#10;
			$display("DEC %0s a=%04x: mmio_sel=%b boot_sel=%b ffxx=%b non_vram=%b arb_fexx=%b n_cs=%b", tag, addr,
				env.mmio_sel, env.boot_sel, env.ffxx, env.non_vram_mreq,
				env.arb_fexx_ffxx, env.n_cs_topad);
			env.cpu_mreq = 1'b0;
			#5;
		end
	endtask

	reg [7:0] rdv;

	initial begin
		$dumpfile("tb_arb.vcd");
		$dumpvars(0, tb_arb);

		// reset
		env.reset = 1'b1;
		repeat (16) @ (posedge env.ck1);
		env.reset = 1'b0;
		repeat (16) @ (posedge env.clk9);

		// ----- decode sweep (combinational, MREQ held) -----
		probe_addr(16'h0000, "boot0");
		probe_addr(16'h00FF, "bootFF");
		probe_addr(16'h0100, "rom");
		probe_addr(16'h3FFF, "rom3f");
		probe_addr(16'h8000, "vram");
		probe_addr(16'hFE00, "oam");
		probe_addr(16'hFF00, "io");
		probe_addr(16'hFF50, "bankreg");
		probe_addr(16'hFFFF, "hram");

		// boot area with MREQ -> boot_sel expected (re-probe 0000, the
		// sweep above ends with a different address on the bus)
		probe_addr(16'h0000, "boot-again");
		chk("boot-select-at-0000", env.boot_sel === 1'b1);
		probe_addr(16'hFF00, "io-again");
		chk("ffxx-at-ff00", env.ffxx === 1'b1);
		chk("mmio-sel-at-ff00", env.mmio_sel === 1'b1);

		// ----- external bus cycle probes ----
		// a cart read should pulse the /CS pad drive low and assert the
		// external address/data drives
		begin : extcyc
			integer cs_low;
			cs_low = 0;
			// sample /CS low pulses during a CPU read of the cart area
			env.cpu_read(16'h0100, rdv);   // cart ROM (boot region left)
			$display("EXT cart read: n_cs_topad=%b DRV_LOW_a15=%b n_DRV_HIGH_a15=%b d-drv-hi=%b",
				env.n_cs_topad, env.DRV_LOW_a15, env.n_DRV_HIGH_a15,
				env.n_DRV_HIGH_d[0]);
		end

		// ----- region map: non_vram_mreq covers everything but the
		// $8000-$9FFF VRAM window (checked with MREQ held) -----
		begin : regmap
			reg nv;
			env.cpu_a = 16'h8000; env.cpu_mreq = 1'b1; #10; nv = env.non_vram_mreq;
			chk("vram-8000-nonvram0", nv === 1'b0);
			env.cpu_a = 16'h9FFF; #10;
			chk("vram-9fff-nonvram0", env.non_vram_mreq === 1'b0);
			env.cpu_a = 16'hA000; #10;
			chk("cartram-a000-nonvram1", env.non_vram_mreq === 1'b1);
			env.cpu_a = 16'h3FFF; #10;
			chk("rom-3fff-nonvram1", env.non_vram_mreq === 1'b1);
			env.cpu_mreq = 1'b0; env.cpu_a = 16'h0000; #5;
		end

		// ----- $FF50 BANK: write 1 disables the internal boot ROM -----
		env.cpu_write(16'hFF50, 8'h01);
		repeat (8) @ (posedge env.clk9);
		probe_addr(16'h0000, "boot-after-bank");
		chk("bank-disables-boot", env.boot_sel === 1'b0);
		// the bank write is sticky (write 0 again must not re-enable)
		env.cpu_write(16'hFF50, 8'h00);
		repeat (8) @ (posedge env.clk9);
		probe_addr(16'h0000, "boot-after-bank0");
		chk("bank-write0-sticky", env.boot_sel === 1'b0);

		// ----- external /CS pad-drive -----
		// n_cs (-> /CS pad through an inverting OBUF) asserts for the
		// a15&(a13|a14) & ~(a[15:10]=111111) windows with ext_cs_en:
		// measured on real CPU read cycles here.
		begin : pads
			integer p;
			reg [7:0] vv;
			r8cs(16'hA000, vv, p);       // cart-RAM window: /CS asserted
			$display("CS: A000 read /CS pulses=%0d", p);
			chk("cs-cartram-a000", p > 0);
			r8cs(16'h8000, vv, p);       // VRAM window: no /CS
			chk("cs-no-vram-8000", p == 0);
			r8cs(16'h0100, vv, p);       // cart ROM area: no /CS (see Readme)
			$display("CS: 0100 read /CS pulses=%0d (ROM area not selected)", p);
			r8cs(16'hC000, vv, p);       // C000 window: /CS asserted
			$display("CS: C000 read /CS pulses=%0d", p);
			chk("cs-c000-window", p > 0);
			r8cs(16'hFF80, vv, p);       // FFxx (HRAM): no /CS (w139 gate)
			chk("cs-no-ffxx", p == 0);
		end

		$display("RESULT tb_arb %0d checks, %0d failures", checks, fails);
		if (fails) $display("RESULT tb_arb FAIL");
		else       $display("RESULT tb_arb PASS");
		$finish;
	end

endmodule
