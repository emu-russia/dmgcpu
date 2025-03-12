// This demo is needed to find out how the LCD Clock divider works (XUPY, XOCE, XYSO signals)

module lcd_clocks();

	reg n_ppu_reset;
	reg ppu_clk; 		// PPU 4MHz
	always #32 ppu_clk = ~ppu_clk;
	wire HCLK;

	wire g1_q;
	wire g1_nq;
	DFFR_B g1 ( .clk(~ppu_clk), .nres(n_ppu_reset), .d(g3_nq), .q(g1_q), .nq(g1_nq) ); 		// WOSU
	wire g2_nq;
	DFFR_B g2 ( .clk(g3_nq), .nres(n_ppu_reset), .d(g2_nq), .nq(g2_nq) ); 	// VENA
	wire g3_nq;
	DFFR_B g3 ( .clk(ppu_clk), .nres(n_ppu_reset), .d(g3_nq), .nq(g3_nq) ); 		// WUVU

	assign XUPY = ~g3_nq;
	assign XOCE = ~g1_q;
	assign XYSO = ~ ( ~(g1_nq | g3_nq));

	assign HCLK = ~g2_nq;

	initial begin
		$display("Running lcd_clocks");

		ppu_clk = 1'b0;

		$dumpfile("lcd_clocks.vcd");
		$dumpvars(0, lcd_clocks);

		n_ppu_reset = 1'b0;
		repeat (8) @ (posedge ppu_clk);
		n_ppu_reset = 1'b1;

		repeat (256) @ (posedge ppu_clk);

		$finish;
	end

endmodule // lcd_clocks

module DFFR_B (clk, nres, d, q, nq);

	input clk;
	input nres;
	input d;
	output q;
	output nq;

	reg val;
	initial val = 1'bx;

	always @(posedge clk) begin
		if (clk)
			val <= d;
	end

	always @(*) begin
		if (~nres)
			val <= 1'b0;
	end

	assign q = val;
	assign nq = ~val;

endmodule // DFFR_B