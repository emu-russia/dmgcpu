#!/bin/sh
# SoC small-domain suite (issue #396): compile + run the tests from scratch.
# Uses the WSL-native Icarus (the Windows iverilog.exe build mis-elaborates
# the merged inout bus netlists: bus reads stay z - see soc_env.v notes).
#   sudo apt install iverilog   (12.0 stable is fine)
cd "$(dirname "$0")"
SRC="../../dmglib.v ../../clkgen.v mmio_merged.v arb_merged.v ser_merged.v ../../sram.v hram_merged.v soc_env.v"
FAIL=0
for t in tb_mmio tb_ser tb_soc_probe; do
  echo "=== $t ==="
  iverilog -D ICARUS -o $t.run $SRC $t.v || { echo "$t: COMPILE FAIL"; FAIL=1; continue; }
  vvp $t.run 2>&1 | tail -3
done
[ $FAIL -eq 0 ] && echo "SUITE OK" || echo "SUITE FAILURES"
