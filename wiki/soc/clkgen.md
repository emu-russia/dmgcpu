# Clock Generator

![locator_clkgen](/imgstore/soc/locator_clkgen.jpg)

![clkgen](/imgstore/soc/clkgen.jpg)

![clkgen_netlist](/imgstore/soc/clkgen_netlist.png)

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
|n_reset2|output|To Ser,MMIO,Arb,PPU,APU|Global reset signal |
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

## Map

|Row|Cells|
|---|---|
|1|not, not, not2(unused), not3, nand, nor, not2(unused), not3, nor, oan, not, not2, or, dffrnq_comp, nor_latch, nor, not, not, dffrnq_comp, not, dffrnq_comp, not, dffrnq_comp, not, dffrnq_comp, not, not2, nand, nand, not, not6 |
|2|not6, not6, or, not, not, nand3, not, not2(unused), not2(unused), not2(unused), not2(unused), not2(unused), not, not, nand4, not6, not, not, nor3, not4+not6, not4+not6, not2, nor3, not4+not6, not4+not6, not2, nor, not6, not6, and, not, not |
