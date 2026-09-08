`timescale 1ns/1ns
module t_sbdbg;
  soc_env env();
  reg [7:0] v;
  integer i;
  always @(negedge env.n_sb_write) begin
    #2;
    $display("SBWR: n_sb_write=%b d=%b q=%b%b%b%b%b%b%b%b | g6 db=%b ie=%b n_ie=%b nset=%b nres=%b nq=%b clk=%b", env.n_sb_write,
      env.d, env.ser.g1.q, env.ser.g2.q, env.ser.g3.q, env.ser.g4.q,
      env.ser.g5.q, env.ser.g6.q, env.ser.g7.q, env.ser.g8.q, env.ser.g6.db,
      env.ser.g6.ie, env.ser.g6.n_ie, env.ser.g6.g1.nset1, env.ser.g6.g1.nres,
      env.ser.g6.g1.nq, env.ser.g6.g1.clk);
  end
  initial begin
    env.reset = 1'b1;
    repeat (16) @ (posedge env.ck1);
    env.reset = 1'b0;
    repeat (16) @ (posedge env.clk9);
    env.cpu_write(16'hFF01, 8'hA5);
    repeat (4) @ (posedge env.clk9);
    $display("cells after write: g1=%b g2=%b g3=%b g4=%b g5=%b g6=%b g7=%b g8=%b",
       env.ser.g1.q, env.ser.g2.q, env.ser.g3.q, env.ser.g4.q,
       env.ser.g5.q, env.ser.g6.q, env.ser.g7.q, env.ser.g8.q);
    // sample during the write window (n_sb_write low)
    repeat (4) @ (posedge env.clk9);
    $display("after settle: n_sb_write=%b d=%b g6.q=%b g8.q=%b g6db=%b", env.n_sb_write,
       env.d, env.ser.g6.q, env.ser.g8.q, env.ser.g6.db);
    env.cpu_read(16'hFF01, v);
    $display("SB read back = %b", v);
    $finish;
  end
endmodule
