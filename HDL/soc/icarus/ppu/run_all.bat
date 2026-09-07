@echo off
rem PPU regression tests (issue #390): run every tb_ppu_*.bat
call tb_ppu_regs.bat
call tb_ppu_bg_scanline.bat
call tb_ppu_scroll.bat
