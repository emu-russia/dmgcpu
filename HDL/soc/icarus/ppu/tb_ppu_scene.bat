iverilog -D ICARUS -g2012 -o tb_ppu_scene.run ../../dmglib.v ../../clkgen.v ppu1_merged.v ppu2_merged.v ppu_env.v oam_ram.v lcd_stub.v tb_ppu_scene.v
vvp tb_ppu_scene.run
