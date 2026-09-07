iverilog -D ICARUS -g2012 -o tb_ppu_window.run ../../dmglib.v ../../clkgen.v ppu1_merged.v ppu2_merged.v ppu_env.v tb_ppu_window.v
vvp tb_ppu_window.run
