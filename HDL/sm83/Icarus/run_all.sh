#!/bin/sh
# SM83 core suite (issue #400): compile + run the regression tests.
# WSL-native Icarus Verilog. Each test prints its own RESULT line.
cd "$(dirname "$0")"
SRC="../_GekkioNames.v ../ALU.v ../Bottom.v ../DataMux.v ../Decoder1.v \
 ../Decoder2.v ../Decoder3.v ../IDU.v ../IRNots.v ../IRQ.v ../Regs.v \
 ../SeqCells.v ../Seq.v ../Thingy.v ../Top.v external_clk.v sm83_env.v"
FAIL=0
for t in tb_sm83_regs tb_sm83_alu tb_sm83_mem tb_sm83_stack tb_sm83_jump \
         tb_sm83_irq tb_sm83_cycles tb_sm83_cb tb_sm83_halt; do
  echo "=== $t ==="
  iverilog -D ICARUS -o $t.run $SRC $t.v 2>/tmp/sm83_compile.err || \
    { echo "$t: COMPILE FAIL"; head -5 /tmp/sm83_compile.err; FAIL=1; continue; }
  vvp $t.run 2>&1 | grep -E "RESULT tb_|FAIL" | tail -2 || FAIL=1
done
[ $FAIL -eq 0 ] && echo "SUITE OK" || echo "SUITE FAILURES"
