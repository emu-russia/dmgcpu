iverilog -D ICARUS -g2012 -o tb_ppu_regs.run ../../dmglib.v ../../clkgen.v ppu1_merged.v ppu2_weakbus.v bus_weak_cells.v ppu_env.v oam_ram.v lcd_stub.v tb_ppu_regs.v
vvp tb_ppu_regs.run
