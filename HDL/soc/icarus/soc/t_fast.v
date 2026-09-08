`timescale 1ns/1ns
module t_fast;
  soc_env env();
  initial begin
    env.reset = 1'b1;
    repeat (16) @ (posedge env.ck1);
    env.reset = 1'b0;
    repeat (16) @ (posedge env.clk9);
    env.FF60_D1 = 1'b1;
    env.cpu_write(16'hFF04, 8'h00);
    // count transitions of DIV-ish internal nets for ~256 M
    repeat (256) @ (posedge env.clk9);
    $display("FAST: w103=%b w104=%b w105=%b w112=%b w113=%b w217=%b w87=%b",
       env.mmio.w103, env.mmio.w104, env.mmio.w105, env.mmio.w112,
       env.mmio.w113, env.mmio.w217, env.mmio.w87);
    $finish;
  end
endmodule
