#!/bin/sh
# PPU regression suite (issue #390): compile + run every test from scratch.
# Needs Icarus Verilog (tested: /mnt/c/iverilog/bin under WSL).
cd "$(dirname "$0")"
SRC="../../dmglib.v ../../clkgen.v ppu1_merged.v ppu2_weakbus.v bus_weak_cells.v ppu_env.v oam_ram.v lcd_stub.v"
FAIL=0
# default = fast tests; add tb_ppu_frame below for the slow full-frame test
for t in tb_ppu_regs tb_ppu_bg_scanline tb_ppu_bg_win_matrix tb_ppu_scroll tb_ppu_window tb_ppu_scene tb_ppu_frame; do
  echo "=== $t ==="
  iverilog -D ICARUS -g2012 -o $t.run $SRC $t.v || { echo "$t: COMPILE FAIL"; FAIL=1; continue; }
  vvp $t.run 2>&1 | grep -E 'RESULT|FAIL' | tail -1 || FAIL=1
done
[ $FAIL -eq 0 ] && echo "SUITE OK" || echo "SUITE FAILURES"
