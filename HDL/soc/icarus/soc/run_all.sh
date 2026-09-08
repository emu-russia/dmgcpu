#!/bin/sh
# SoC small-domain suite (issue #396): compile + run the tests from scratch.
# Uses the WSL-native Icarus (the Windows iverilog.exe build mis-elaborates
# the merged inout bus netlists - see soc_env.v notes).
#   sudo apt install iverilog   (12.0 stable is fine)
cd "$(dirname "$0")"
SRC="../../dmglib.v ../../clkgen.v mmio_weakbus.v arb_merged.v ser_sharedq.v hram_model.v soc_env.v"
FAIL=0
for t in tb_clkgen tb_mmio tb_ser tb_arb tb_testmode tb_div tb_hram tb_soc_probe; do
  echo "=== $t ==="
  iverilog -D ICARUS -o $t.run $SRC $t.v || { echo "$t: COMPILE FAIL"; FAIL=1; continue; }
  vvp $t.run 2>&1 | grep -E "RESULT tb_" | tail -1
done
[ $FAIL -eq 0 ] && echo "SUITE OK" || echo "SUITE FAILURES"
