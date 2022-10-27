`timescale 1ns/1ns

// Used to cross-check with @gekkio (https://github.com/Gekkio/gb-research/tree/main/sm83-cpu-core)

module Decoder_Run();

	reg CLK;
	reg [14:0] counter;
	integer f;

	always #25 CLK = ~CLK;

	wire [25:0] a; 			// Decoder1 in
	wire [106:0] d; 		// Decoder1 out
	wire [40:0] w; 			// Decoder2 out
	wire [68:0] x; 			// Decoder3 out

	wire [103:0] stage1;
	wire [37:0] stage2;
	wire [68:0] stage3;

	Decoder1 decoder1 (.CLK2(1'b1), .a(a), .d(d));
	Decoder2 decoder2 (.CLK2(1'b1), .d(d), .w(w), .SeqOut_2(~counter[1]), .IR7(counter[12]) );
	Decoder3 decoder3 (.CLK2(1'b1), .CLK4(1'b1), .CLK5(counter[0]), .nCLK4(1'b0), .a3(a[3]), .d(d), .w(w), .x(x), .IR(counter[12:5]), .nIR(~counter[10:5]), .SeqOut_2(~counter[1]) );

	org_to_gekkio otg ( .d(decoder1.d), .w(decoder2.w), .x(decoder3.x), .stage1(stage1), .stage2(stage2), .stage3(stage3) );

	Sequencer_Mock seq (.counter(counter), .a(a));

	always @(posedge CLK) begin
		$fwrite (f, "%b,%b,0x%x,%b,%b,%b,%b,%b,%b\n",
			counter[14],	// intr_dispatch
			counter[13],	// cb_mode
			counter[12:5],	// IR
			counter[4:2],	// {state2,state1,state0}
			counter[0],		// writeback = CLK5
			counter[1],		// data_lsb
			stage1,
			stage2,
			stage3 );

		counter = counter + 1;
	end

	initial begin

		$display("Dump all Decoder outputs for each opcode (0x00-0xff)");

		f = $fopen("decoder_org.csv","w");
		//$fwrite(f, "a1(intr_dispatch),a3(cb_mode),ir_reg,{state2,state1,state0},CLK5?(writeback),~SeqOut_2(data_lsb),decoder1_out,decoder2_out,decoder3_out,not_used\n" );
		$fwrite(f, "intr_dispatch,cb_mode,ir_reg,state,writeback,data_lsb,stage1,stage2,stage3,outputs\n");

		CLK <= 1'b0;
		counter <= 0;

		// Disabled the fun pictures dump.
		//$dumpfile("decoder_out.vcd");
		//$dumpvars(0, decoder1);
		//$dumpvars(0, decoder2);
		//$dumpvars(0, decoder3);
		//$dumpvars(1, seq);

		repeat (32768) @ (posedge CLK);
		$fclose (f);
		$finish;
	end

endmodule // Decoder_Run

module Sequencer_Mock (counter, a);

	input [14:0] counter;
	output [25:0] a; 			// Decoder1 in

	assign a[0] = ~a[1];			// @gekkio: ~intr_dispatch
	assign a[1] = counter[14]; 	// @gekkio: intr_dispatch
	assign a[2] = ~a[3];			// @gekkio: ~cb_mode
	assign a[3] = counter[13]; 	// @gekkio: cb_mode
	assign a[4] = ~a[5];
	assign a[5] = counter[12];		// IR7
	assign a[6] = ~a[7];
	assign a[7] = counter[11];		// IR6
	assign a[8] = ~a[9];
	assign a[9] = counter[10];		// IR5
	assign a[10] = ~a[11];
	assign a[11] = counter[9];		// IR4
	assign a[12] = ~a[13];
	assign a[13] = counter[8];		// IR3
	assign a[14] = ~a[15];
	assign a[15] = counter[7];		// IR2
	assign a[16] = ~a[17];
	assign a[17] = counter[6];		// IR1
	assign a[18] = ~a[19];
	assign a[19] = counter[5];		// IR0
	assign a[20] = ~counter[4];		// @gekkio: ~state[2]
	assign a[21] = ~a[20];		// @gekkio: state[2]
	assign a[22] = ~counter[3];		// @gekkio: ~state[1]
	assign a[23] = ~a[22];		// @gekkio: state[1]
	assign a[24] = ~counter[2];		// @gekkio: ~state[0]
	assign a[25] = ~a[24];		// @gekkio: state[0]

endmodule // Sequencer_Mock
