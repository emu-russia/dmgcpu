# Clock Generator

![locator_clkgen](/imgstore/soc/locator_clkgen.jpg)

![clkgen](/imgstore/soc/clkgen.jpg)

The names of signals of the CLK group have many synonyms used by different authors at different times.

|Signal|Dir|From/Where To|Description|
|---|---|---|---|
|clk_ena|input|From Core| |
|osc_ena|input|From Core| |
|cpu_wr_sync|output|To MMIO,Arb| |
|cpu_wr|input|From Core| |
|ext_cs_en|output|To Arb| |
|test_1|input|From MMIO| |
|cpu_mreq|input|From Core| |
|sync_reset|output|To Core| |
|reset|input|From /RESET Pad| |
|osc_stable|input|From MMIO| |
|n_test_reset|input|From MMIO| |
|n_clk_in|input|From CK1_CK2 Pad| |
|n_reset2|output|To MMIO,Arb,PPU,APU| |
|clk1|output|To Core| (Aka BOWA,ADR_CLK_N)|
|clk2|output|To Core,MMIO,Arb,APU| (Aka DATA_VALID,ADR_CLK_P)|
|clk3|output|To Core | (Aka CPU_PHI,DATA_CLK_P)|
|clk4|output|To Core,MMIO,APU,PHI Pad| (Aka #CPU_PHI,DATA_CLK_N)|
|clk5|output|To Core| (Aka INC_CLK_N)|
|clk6|output|To Core,MMIO,PPU,APU| (Aka INC_CLK_P)|
|clk7|output|To Core,HRAM,APU| (Aka BUKE,LATCH_CLK)|
|clk8|output|To Core| (Aka BOMA_1MHZ,MAIN_CLK_N)|
|clk9|output|To Core,MMIO,APU| (Aka BOGA_1MHZ,MAIN_CLK_P)|
|cclk|output|To APU,PPU| (Aka AZOF)|
