`timescale 1ns/1ns

module Decoder_Run();

	reg CLK;
	reg [7:0] counter;

	wire SeqOut_2;
	assign SeqOut_2 = 1'b0;		// ???

	always #25 CLK = ~CLK;

	wire [25:0] a; 			// Decoder1 in
	wire [106:0] d; 		// Decoder1 out
	wire [40:0] w; 			// Decoder2 out
	wire [68:0] x; 			// Decoder3 out

	Decoder1 decoder1 (.CLK2(1'b1), .a(a), .d(d));
	Decoder2 decoder2 (.CLK2(1'b1), .d(d), .w(w), .SeqOut_2(SeqOut_2), .IR7(counter[7]) );
	Decoder3 decoder3 (.CLK2(1'b1), .CLK4(1'b1), .CLK5(1'b0), .nCLK4(1'b0), .a3(a[3]), .d(d), .w(w), .x(x), .IR(counter), .nIR(~counter), .SeqOut_2(SeqOut_2) );

	Sequencer_Mock seq (.IR(counter), .a(a));

	always @(posedge CLK) begin
		$display ( "IR: 0x%x, d: %b, w: %b, x: %b",
			counter,
			decoder1.d,
			decoder2.w,
			decoder3.x );

		counter = counter + 1;
	end

	initial begin

		$display("Dump all Decoder outputs for each opcode (0x00-0xff)");

		CLK <= 1'b0;
		counter <= 0;

		$dumpfile("decoder_out.vcd");
		$dumpvars(0, decoder1);
		$dumpvars(0, decoder2);
		$dumpvars(0, decoder3);
		$dumpvars(1, seq);

		repeat (256) @ (posedge CLK);
		$finish;
	end

endmodule // Decoder_Run

module Sequencer_Mock (IR, a);

	input [7:0] IR;
	output [25:0] a; 			// Decoder1 in

	assign a[0] = ~a[1];
	assign a[1] = 1'b0; 		// TBD.
	assign a[2] = ~a[3];
	assign a[3] = 1'b0; 		// TBD.
	assign a[4] = ~a[5];
	assign a[5] = IR[7];
	assign a[6] = ~a[7];
	assign a[7] = IR[6];
	assign a[8] = ~a[9];
	assign a[9] = IR[5];
	assign a[10] = ~a[11];
	assign a[11] = IR[4];
	assign a[12] = ~a[13];
	assign a[13] = IR[3];
	assign a[14] = ~a[15];
	assign a[15] = IR[2];
	assign a[16] = ~a[17];
	assign a[17] = IR[1];
	assign a[18] = ~a[19];
	assign a[19] = IR[0];
	assign a[20] = 1'b0;		// TBD.
	assign a[21] = ~a[20];
	assign a[22] = 1'b0;		// TBD.
	assign a[23] = ~a[22];
	assign a[24] = 1'b0;		// TBD.
	assign a[25] = ~a[24];

endmodule // Sequencer_Mock
