`timescale 1ns/1ns
module t_tima;
  soc_env env();
  reg [7:0] v;
  integer sel;
  initial begin
    env.reset = 1'b1;
    repeat (16) @ (posedge env.ck1);
    env.reset = 1'b0;
    repeat (16) @ (posedge env.clk9);
    for (sel = 0; sel < 4; sel = sel + 1) begin
      env.cpu_write(16'hFF07, 8'h00);       // timer off
      env.cpu_write(16'hFF05, 8'h00);       // TIMA = 0
      env.cpu_write(16'hFF07, 8'h04 | sel[1:0]);  // on + select
      repeat (16384) @ (posedge env.clk9);  // 16384 M-cycles
      env.cpu_read(16'hFF05, v);
      $display("TIMA sel=%0d after 16384M = %b (%0d)", sel, v, v);
      env.cpu_write(16'hFF07, 8'h00);
    end
    $finish;
  end
endmodule
