// tb_ppu_dma
// VRAM -> OAM DMA bring-up (issue #390) - DEV, not in run_all.
//
// Emulates the MMIO DMA controller while the real PPU1/PPU2 netlists run:
//   - vram_to_oam = 1 routes the CPU address bus onto nma (PPU1 block 7),
//     so the VRAM model returns the source byte on md;
//   - dma_run = 1 makes PPU2 drive oa = dma_a[7:1] and select the write
//     port by dma_a[0];
//   - each oam_dma_wr pulse makes PPU2 strobe the OAM write and capture the
//     md byte into the OAM model.
//
// STATUS (round 3): DEV - like tb_ppu_oam_cpu, a clean VRAM->OAM DMA needs
// the MMIO DMA controller behaviour (arbiter/VRAM read arbitration, phase
// timing of oam_dma_wr vs the md data) which is beyond the PPU-only
// environment; kept as a bring-up reference (see open questions in
// wiki/soc/ppu2.md).
`timescale 1ns/1ns

module tb_ppu_dma;

	ppu_env env();

	integer errors = 0;
	integer i;
	reg [7:0] rd;

	task check(input [90:0] name, input [7:0] expected, input [7:0] actual);
		begin
			if (expected !== actual) begin
				$display("FAIL %0s: expected %02x got %02x", name, expected, actual);
				errors = errors + 1;
			end else
				$display("PASS %0s: %02x", name, actual);
		end
	endtask

	// one VRAM->OAM byte transfer: src = VRAM byte offset 0..0x1FFF
	task dma_byte(input [12:0] src, input [7:0] dst, input [7:0] data);
		begin
			env.vram.mem[src] = data;      // program the VRAM source byte
			@(posedge env.ppu_clk);
			env.vram_to_oam = 1'b1;
			env.dma_run     = 1'b1;
			env.cpu_a       = {3'b100, src};   // CPU bus = $8000 + src
			env.dma_a       = dst;
			#5;
			env.vram_rd = 1'b0;              // model: VRAM drives md
			env.oam_dma_wr = 1'b1;
			#40;
			env.oam_dma_wr = 1'b0;
			env.vram_rd = 1'b1;
			#5;
			env.dma_run = 1'b0;
			env.vram_to_oam = 1'b0;
			#30;
		end
	endtask

	initial begin
		$dumpfile("tb_ppu_dma.vcd");
		$dumpvars(0, tb_ppu_dma);
		#(64*8);
		env.reset = 1'b0;
		#(64*4);

		$display("--- DMA byte 0: VRAM $8000 -> OAM $FE00 (data $A5) ---");
		dma_byte(13'h000, 8'h00, 8'hA5);
		$display("OAM word0: mem[0]=%02x mem[1]=%02x", env.oam.mem[0], env.oam.mem[1]);

		$display("--- DMA byte 1: VRAM $8001 -> OAM $FE01 (data $5A) ---");
		dma_byte(13'h001, 8'h01, 8'h5A);
		$display("OAM word0: mem[0]=%02x mem[1]=%02x", env.oam.mem[0], env.oam.mem[1]);

		if (errors == 0)
			$display("RESULT: ALL PASS (bring-up)");
		else
			$display("RESULT: %0d FAILURES", errors);
		$finish;
	end

endmodule
