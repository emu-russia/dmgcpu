#!/bin/sh
# APU suite (issue #398): compile + run the regression tests from scratch.
# Uses the WSL-native Icarus. Analysers (check_ch1.py etc.) print the
# RESULT lines for the measurement-based tests.
cd "$(dirname "$0")"
SRC="../../dmglib.v ../../clkgen.v ../soc/mmio_weakbus.v ../soc/arb_merged.v ../soc/ser_sharedq.v apu_merged.v wave_ram_model.v apu_env.v"
FAIL=0

run_test() {
  t=$1; shift
  echo "=== $t ==="
  iverilog -D ICARUS -o $t.run $SRC $t.v || { echo "$t: COMPILE FAIL"; FAIL=1; return; }
  if [ $# -gt 0 ]; then
    vvp $t.run > /tmp/$t.log 2>&1 || true
    grep -E "RESULT tb_" /tmp/$t.log | tail -1
    python3 "$1" || FAIL=1
  else
    vvp $t.run 2>&1 | grep -E "RESULT tb_" | tail -1
  fi
}

run_test tb_apu_regs
run_test tb_apu_ch1 check_ch1.py

# research-only for now (see STATUS.md): channel 2-4 output-stage question
# run_test tb_apu_ch2 check_ch2.py

[ $FAIL -eq 0 ] && echo "SUITE OK" || echo "SUITE FAILURES"
