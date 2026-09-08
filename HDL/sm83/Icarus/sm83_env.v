// sm83_env - reusable Icarus environment for the real SM83 core netlist
// (issue #400).
//
// Drives the actual SM83 core (HDL/sm83/Top.v SM83Core + module files) with
// the same external circuitry as the ROM harness run.v uses:
//   * External_CLK (external_clk.v) - the CPU clock generator
//   * a flat 64K memory (Bogus_HW conventions from run.v: reads on
//     (MREQ & RD), writes captured on the WR trailing edge using the
//     #1-delayed ADR/DAT copies so there is no bus race when the CPU
//     changes A and WR at the same time)
//   * an IF ($FF0F) model: interrupt sources are asserted by the test
//     (irq_set), the env clears the acknowledged bits on the CPU IRQ
//     acknowledge (CPU_IRQ_ACK) and feeds CPU_IRQ_TRIG to the core, the
//     same law Bogus_HW implements.
//
// IE ($FFFF) lives inside the core (IRQ_Logic module7/Thingy path): a
// program write to $FFFF loads it, and reads of $FFFF are answered by the
// core itself - so no external IE model is needed.
//
// Programs are poked into memory starting at $0000: after SYNC_RESET the
// core starts fetching from PC=0, exactly as the DMG starts at the boot
// ROM address 0 - tests just map their own code there.
//
// Observable core state (PC/SP/IR/register file/bus/decoder/flags) is
// exposed on nets so tests can assert on it and $dumpvars it for waves.
`timescale 1ns/1ns

module sm83_env;

	// ---- oscillator / reset ----------------------------------------------
	reg CLK = 1'b0;            // ~4.19 MHz osc (half period 120 ns like run.v)
	reg ExternalRESET = 1'b0;  // active-high pad RESET
	always #120 CLK = ~CLK;

	// ---- external clock generator ----------------------------------------
	wire OSC_STABLE, OSC_ENA, CLK_ENA;
	wire ADR_CLK_N, ADR_CLK_P, DATA_CLK_N, DATA_CLK_P;
	wire INC_CLK_N, INC_CLK_P, LATCH_CLK, MAIN_CLK_N, MAIN_CLK_P;
	wire ASYNC_RESET, SYNC_RESET;

	External_CLK clkgen (
		.CLK(CLK), .RESET(ExternalRESET),
		.ADR_CLK_N(ADR_CLK_N), .ADR_CLK_P(ADR_CLK_P),
		.DATA_CLK_N(DATA_CLK_N), .DATA_CLK_P(DATA_CLK_P),
		.INC_CLK_N(INC_CLK_N), .INC_CLK_P(INC_CLK_P),
		.LATCH_CLK(LATCH_CLK),
		.MAIN_CLK_N(MAIN_CLK_N), .MAIN_CLK_P(MAIN_CLK_P),
		.CLK_ENA(CLK_ENA), .OSC_ENA(OSC_ENA), .OSC_STABLE(OSC_STABLE),
		.ASYNC_RESET(ASYNC_RESET), .SYNC_RESET(SYNC_RESET) );

	// ---- the core ---------------------------------------------------------
	wire M1, RD, WR, MREQ;
	wire [15:0] A;              // address bus
	wire [7:0]  D;              // data bus (inout)
	wire [7:0]  irq_ack;

	SM83Core dmgcore (
		.CLK1(ADR_CLK_N), .CLK2(ADR_CLK_P), .CLK3(DATA_CLK_P), .CLK4(DATA_CLK_N),
		.CLK5(INC_CLK_N), .CLK6(INC_CLK_P), .CLK7(LATCH_CLK),
		.CLK8(MAIN_CLK_N), .CLK9(MAIN_CLK_P),
		.M1(M1), .OSC_STABLE(OSC_STABLE), .OSC_ENA(OSC_ENA),
		.RESET(ASYNC_RESET), .SYNC_RESET(SYNC_RESET), .CLK_ENA(CLK_ENA),
		.NMI(1'b0), .WAKE(1'b0),
		.RD(RD), .WR(WR), .BUS_DISABLE(1'b0),
		.MMIO_REQ(1'b0), .IPL_REQ(1'b0), .IPL_DISABLE(1'b0),
		.MREQ(MREQ), .D(D), .A(A),
		.CPU_IRQ_TRIG(CPU_IRQ_TRIG), .CPU_IRQ_ACK(irq_ack) );

	// ---- flat memory (Bogus_HW conventions) -------------------------------
	reg [7:0] mem [0:65535];
	wire [15:0] ADR;            // #1-delayed bus copies (run.v workaround)
	wire [7:0] DAT;

	integer mj;
	initial begin
		for (mj = 0; mj < 65536; mj = mj + 1)
			mem[mj] = 8'h00;
	end

	assign #1 ADR = A;
	assign #1 DAT = D;
	assign D = (MREQ & RD) ? mem[ADR] : 8'hZZ;
	always @(negedge WR) mem[ADR] <= DAT;

	// ---- IF ($FF0F) model -------------------------------------------------
	// Sources (timer/serial/joypad/...) are represented by irq_set; the CPU
	// acknowledge clears the bits, mirroring Bogus_HW `IF <= IF & ~ACK`.
	reg [7:0] IF = 8'h00;
	wire [7:0] CPU_IRQ_TRIG = IF;

	always @(irq_ack) begin
		if (irq_ack !== 8'h00)
			IF <= IF & ~irq_ack;
	end

	// ---- observable core state -------------------------------------------
	wire [15:0] pc   = dmgcore.bot.pc.PC;
	wire [15:0] sp   = dmgcore.bot.sp.SP;
	wire [7:0]  ir   = dmgcore.bot.IR;
	wire [7:0]  regA = dmgcore.bot.regs.A;
	wire [7:0]  regB = dmgcore.bot.regs.B;
	wire [7:0]  regC = dmgcore.bot.regs.C;
	wire [7:0]  regD = dmgcore.bot.regs.D;
	wire [7:0]  regE = dmgcore.bot.regs.E;
	wire [7:0]  regH = dmgcore.bot.regs.H;
	wire [7:0]  regL = dmgcore.bot.regs.L;
	wire [7:0]  zbus = dmgcore.bot.zbus;      // temp-Z (F flags high nibble)
	wire        fZ = dmgcore.bot.Temp_Z;      // zbus[7]
	wire        fN = dmgcore.bot.Temp_N;      // zbus[6]
	wire        fH = dmgcore.bot.Temp_H;      // zbus[5]
	wire        fC = dmgcore.bot.Temp_C;      // zbus[4]
	wire [15:0] bc = {regB, regC};
	wire [15:0] de = {regD, regE};
	wire [15:0] hl = {regH, regL};
	wire [106:0] dec_d = dmgcore.dec1.d;      // Decoder1 outputs
	wire [40:0]  dec_w = dmgcore.dec2.w;      // Decoder2 outputs
	wire [68:0]  dec_x = dmgcore.dec3.x;      // Decoder3 outputs
	wire clk_ena_out = CLK_ENA;
	wire osc_ena_out = OSC_ENA;

	// ---- tasks ------------------------------------------------------------

	task poke(input [15:0] addr, input [7:0] val);
		begin
			mem[addr] = val;
		end
	endtask

	task peek(input [15:0] addr, output [7:0] val);
		begin
			val = mem[addr];
		end
	endtask

	// assert pad RESET, hold it, release
	task reset();
		begin
			ExternalRESET = 1'b1;
			repeat (16) @(posedge CLK);
			ExternalRESET = 1'b0;
		end
	endtask

	// wait until the synchronizer releases (core fetches from PC=0 onwards)
	task wait_boot();
		begin
			while (SYNC_RESET === 1'b1) @(posedge CLK);
		end
	endtask

	// run n oscillator cycles (posedge CLK)
	task run_cycles(input integer n);
		integer i;
		begin
			for (i = 0; i < n; i = i + 1) @(posedge CLK);
		end
	endtask

	// assert interrupt-source bits (like MMIO IF being set by a source)
	task irq_set(input [7:0] mask);
		begin
			IF = IF | mask;
		end
	endtask

	// Run until the core stops fetching (PC stable -> HALT or a loop the
	// program never leaves) or until max_cycles. Returns 1 when the core
	// halted (PC unchanged for 64 osc cycles), 0 on timeout.
	reg halt_seen = 1'b0;
	integer pc_stable_cnt = 0;
	reg [15:0] last_pc = 16'h0000;

	always @(posedge CLK) begin
		if (SYNC_RESET === 1'b1) begin
			pc_stable_cnt <= 0;
			halt_seen <= 1'b0;
		end else if (pc !== last_pc) begin
			pc_stable_cnt <= 0;
			halt_seen <= 1'b0;
			last_pc <= pc;
		end else begin
			if (pc_stable_cnt >= 63)
				halt_seen <= 1'b1;
			else
				pc_stable_cnt <= pc_stable_cnt + 1;
		end
	end

	task run_to_halt(input integer max_cycles, output reg ok);
		integer i;
		begin
			ok = 1'b0;
			for (i = 0; i < max_cycles; i = i + 1) begin
				@(posedge CLK);
				if (halt_seen) begin
					ok = 1'b1;
					i = max_cycles;  // break
				end
			end
		end
	endtask

	// run until mem[addr] == val or max_cycles (used for IRQ tests where the
	// CPU must wake from HALT only after we assert an interrupt source)
	task run_until_mem(input [15:0] addr, input [7:0] val,
	                   input integer max_cycles, output reg ok);
		integer i;
		begin
			ok = 1'b0;
			for (i = 0; i < max_cycles; i = i + 1) begin
				@(posedge CLK);
				if (mem[addr] == val) begin
					ok = 1'b1;
					i = max_cycles;  // break
				end
			end
		end
	endtask

endmodule // sm83_env
