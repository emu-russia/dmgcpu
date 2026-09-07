@echo off
rem PPU regression tests (issue #390): default = fast tests.
rem The slow full-frame test is optional: call tb_ppu_frame.bat
call tb_ppu_regs.bat
call tb_ppu_bg_scanline.bat
call tb_ppu_scroll.bat
call tb_ppu_window.bat
call tb_ppu_bg_win_matrix.bat
call tb_ppu_scene.bat
rem optional slow: call tb_ppu_frame.bat
