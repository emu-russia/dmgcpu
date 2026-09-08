`timescale 1ns/1ns
module t_dbg;
  soc_env env();
  reg [7:0] v;
  initial begin
    env.reset = 1'b1;
    repeat (16) @ (posedge env.ck1);
    env.reset = 1'b0;
    repeat (16) @ (posedge env.clk9);
    env.cpu_write(16'hFF07, 8'h03);
    env.cpu_read(16'hFF07, v);
    $display("TAC read = %b", v);
    $finish;
  end
endmodule
