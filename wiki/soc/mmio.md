# Memory Mapped I/O

> [!WARNING]  
> The section is under development and requires refinement, the schematics have not been verified in the simulator, but the study has gained "critical mass"

![locator_mmio](/imgstore/soc/locator_mmio.jpg)

![mmio](/imgstore/soc/mmio.jpg)

## Module Description (DeepSeek)

:warning: I gave him Verilog and asked him to tell me what he thought. It came out a little crooked, but it'll do.

The MMIO module is a Memory-Mapped Input/Output controller for the DMG-CPU (Game Boy CPU). It handles:

1. **Address and Data Bus Management**:
   - Controls bidirectional address (a\[14:8\] [^1]) and data (d\[7:0\]) buses
   - Manages bus drivers (DRV_HIGH/DRV_LOW signals)
   - Handles address latching (addr_latch)

2. **Interrupt Handling**:
   - Processes and generates CPU interrupts (cpu_irq_trig/cpu_irq_ack)
   - Handles interrupts from various sources (PPU, serial, joypad)

3. **DMA Control**:
   - Manages DMA operations (dma_a, dma_run, dma_addr_ext)
   - Controls OAM DMA (oam_dma_wr, vram_to_oam)

4. **Clock and Timing**:
   - Generates low-frequency oscillators (lfo_512Hz, lfo_16384Hz)
   - Works with multiple clock domains (clk2, clk4, clk6, clk9)

5. **Peripheral Control**:
   - Interfaces with PPU (ppu_rd, ppu_wr, ppu_int_*)
   - Obtains serial controller register control signals (sc_*, sb_*)
   - Manages global SOC read/write mode (soc_wr, soc_rd)

6. **System Control**:
   - Handles reset signals (reset, n_reset2)
   - Manages test modes (test_1, test_2, n_test_reset)
   - Controls data bus isolation (n_*db_* signals)

[^1]: The chip is topologically arranged so that the address bus arbitration is divided into three parts: in [arb](arb.md), in [mmio](mmio.md), and in [apu](apu.md), to equalize wire lengths.

## Signals

![mmio_ports](/imgstore/soc/mmio_ports.png)

| Signal Name            | Direction | From / Where To             | Description |
|------------------------|-----------|-----------------------------|-------------|
| FF60_D1                | Input     |                             |  |
| clk_ena                | Input     |                             | Clock enable |
| clk2                   | Input     | From ClkGen                 |  |
| clk4                   | Input     | From ClkGen                 |  |
| clk6                   | Input     | From ClkGen                 |  |
| clk6_delay             | Input     |                             | Delayed `clk6` clock signal |
| clk9                   | Input     | From ClkGen                 |  |
| \[4:0\] cpu_irq_ack    | Input     | From Core                   | SM83 Core interrupt acknowledgments |
| cpu_m1                 | Input     | From Core                   | SM83 Core M1 cycle indicator |
| cpu_rd                 | Input     | From Core                   | SM83 Core read signal |
| cpu_wr                 | Input     | From Core                   | SM83 Core write signal |
| cpu_wr_sync            | Input     |                             |  |
| ffxx                   | Input     |                             |  |
| ff46                   | Input     |                             |  |
| int_jp                 | Input     | From APU                    | Joypad interrupt |
| int_serial             | Input     |                             | Serial interrupt |
| \[14:8\] n_INPUT_a     | Input     | From Pads                   | External Address bus input |
| n_INPUT_nrd            | Input     |                             |  |
| n_INPUT_nwr            | Input     |                             |  |
| n_ppu_hard_reset       | Input     |                             |  |
| n_reset2               | Input     | From ClkGen                 | Global reset signal (SoC internal) |
| n_t1_frompad           | Input     |                             |  |
| n_t2_frompad           | Input     |                             |  |
| non_vram_mreq          | Input     |                             |  |
| osc_ena                | Input     |                             |  |
| ppu_clk                | Input     |                             |  |
| ppu_int_stat           | Input     | From PPU1                   | PPU status interrupt |
| ppu_int_vbl            | Input     | From PPU1                   | PPU VBLANK interrupt |
| ppu_rd                 | Input     |                             |  |
| ppu_wr                 | Input     |                             |  |
| reset                  | Input     | From Pad                    | System reset signal (external) |
| CONST0                 | Bidir     | Global                      | Constant 0 signal [^2] |
| \[14:8\] DRV_LOW_a     | Output    | To Pads                     | Drive low control for external address bus |
| DRV_LOW_nrd            | Output    |                             |  |
| DRV_LOW_nwr            | Output    |                             |  |
| \[14:0\] a             | Bidir     | Global                      | Internal Address bus. For bits 14...8 the arbitration is applied [^1]. Bits 7...0 are read only |
| addr_latch             | Output    |                             |  |
| \[4:0\] cpu_irq_trig   | Output    | To Core                     | SM83 Core interrupt triggers |
| cpu_vram_oam_rd        | Output    |                             |  |
| \[7:0\] d              | Bidir     | Global                      | Internal Data bus |
| \[12:0\] dma_a         | Output    |                             | DMA address bus |
| dma_a_15               | Output    |                             | DMA address bit 15 |
| dma_addr_ext           | Output    |                             |  |
| dma_run                | Output    |                             |  |
| lfo_512Hz              | Output    |                             |  |
| lfo_16384Hz            | Output    |                             |  |
| \[14:8\] n_DRV_HIGH_a  | Output    | To Pads                     | Drive high control for external address bus |
| n_DRV_HIGH_nrd         | Output    |                             |  |
| n_DRV_HIGH_nwr         | Output    |                             |  |
| n_cpu_m1               | Output    | To Pad                      | Inverted CPU M1 signal |
| n_dblatch_to_intdb     | Output    |                             |  |
| n_dma_phi              | Output    |                             |  |
| n_ena_pu_db            | Output    |                             |  |
| n_ext_addr_en          | Output    |                             |  |
| n_extdb_to_intdb       | Output    |                             |  |
| n_intdb_to_extdb       | Output    |                             |  |
| n_sb_write             | Output    |                             |  |
| n_test_reset           | Output    |                             |  |
| oam_dma_wr             | Output    |                             |  |
| osc_stable             | Output    |                             | Oscillator stable signal |
| sb_read                | Output    |                             |  |
| sc_read                | Output    |                             |  |
| sc_write               | Output    |                             |  |
| soc_rd                 | Output    |                             |  |
| soc_wr                 | Output    |                             |  |
| test_1                 | Output    |                             |  |
| test_2                 | Output    |                             |  |
| vram_to_oam            | Output    |                             |  |

[^2]: The constant 0 is globally scattered throughout the chip. Each large module with cells has a `const` cell whose output 0 is globally connected between all modules (so the input is marked as Bidir).

Old:

| Signal Name            | Direction | From / Where To                     | Description |
|------------------------|-----------|--------------------------------------|-------------|
| cpu_wr_sync            | Input     | CPU                                 | Synchronized CPU write |
| n_DRV_HIGH_nrd         | Output    | To read control                     | Read drive high control |
| n_INPUT_nrd            | Input     | From read control                   | Read input |
| DRV_LOW_nrd            | Output    | To read control                     | Read drive low control |
| n_DRV_HIGH_nwr         | Output    | To write control                    | Write drive high control |
| n_INPUT_nwr            | Input     | From write control                  | Write input |
| DRV_LOW_nwr            | Output    | To write control                    | Write drive low control |
| n_t1_frompad, n_t2_frompad | Input | From TEST pads                      | Test Pad input signals |
| n_ena_pu_db            | Output    | To pull-up control                  | Data bus pull-up enable |
| n_dma_phi              | Output    | To DMA                              | DMA phase control |
| dma_run                | Output    | To DMA                              | DMA run control |
| soc_wr, soc_rd         | Output    | To SOC                              | SOC write/read controls (@msinger: `CPU_WR`, `CPU_RD`) |
| lfo_512Hz              | Output    | To system                           | 512Hz low-frequency oscillator |
| ppu_rd, ppu_wr         | Input     | From PPU                            | PPU read/write signals |
| int_serial             | Input     | From serial interface               | Serial interrupt |
| sc_read, sb_read       | Output    | To serial controller                | Serial controller read signals |
| sc_write, n_sb_write   | Output    | To serial controller                | Serial controller write signals |
| lfo_16384Hz            | Output    | To system                           | 16.384Hz oscillator |
| ppu_clk                | Input     | From PPU                            | PPU clock |
| vram_to_oam            | Output    | To PPU                         	   | VRAM to OAM transfer control |
| non_vram_mreq          | Input     | From memory controller              | Non-VRAM memory request |
| test_1, test_2         | Output    | Global 		                       | Test signals  (@msinger: `T1_nT2`, `nT1_T2`) |
| n_extdb_to_intdb       | Output    | To data bus control                 | External to internal DB control |
| n_dblatch_to_intdb     | Output    | To data bus control                 | DB latch to internal DB control |
| n_intdb_to_extdb       | Output    | To data bus control                 | Internal to external DB control |
| n_test_reset           | Output    | To test system                      | Test reset signal |
| n_ext_addr_en          | Output    | To address control                  | External address enable |
| addr_latch             | Output    | To address control                  | Address latch signal |
| FF60_D1                | Input     | From register (0xFF60)              | Register bit input |
| ffxx                   | Input     | From FFxx registers                 | FFxx register area indicator |
| n_ppu_hard_reset       | Input     | From PPU                            | PPU hard reset |
| ff46                   | Input     | From register (0xFF46)              | DMA control register |
| dma_addr_ext           | Output    | To DMA                              | DMA external address control |
| cpu_vram_oam_rd        | Output    | To CPU/VRAM/OAM                     | CPU VRAM/OAM read control |
| oam_dma_wr             | Output    | To OAM DMA                          | OAM DMA write control |
| clk6_delay             | Input     | From delayed clock                  | Delayed `clk6` clock signal |

## Netlist

![mmio_netlist](/imgstore/soc/mmio_netlist.png)

## Annotated Design

![mmio_annotated](/HDL/soc/design/mmio_annotated.png)

## Schematics

- DMA LowAddr
- DMA HiAddr
- Ext Addr -> Int Addr
- Int Addr -> Ext Addr
- FF0F IF
- Int DB Precharge (2)
- DMA Unit
- SysDecode (parts)
- M1
- DIV
- FF06 TMA
- FF07 TAC
- FF05 TIMA
- OSC Stable
- Test Mode
- R/W Mode
- DB Control
- Address Latch Enable

## Map

|Row|Cells|
|---|---|
|1|not, not, nor, nand, nor, nand, nor, nand, bufif0, bufif0, bufif0, bufif0, latch, latch, latch, latch, latch, not, aon, not, aon, not, nand3, and3, not, not, not, nand, dffsr, not, not, not, not, dffsr, not, not2, nand3, nand, dffr, nand, not, not, nor, not, dffr, not, nor, nor_latch, not, and|
|2|nor, nand, not, not, nand, nor, not, bufif0, not, nor, dffr, not, nand3, or, mux, mux, dffr, mux, mux, not, mux, nor, not, not, or, latch, or, latch, nand3, nor3, latchnq_comp, nand3, and3, nand, dffr, dffr, dffr, dffr, nand, and, not2, nand, dffr, and|
|3|not, bufif0, nor, dffr, nor, cnt, latch, muxi, notif1, dffsr, or, dffr, notif1, latch, notif1, latch, notif1, latchnq_comp, or, latchnq_comp, dffr, dffr, not, dffr, nand6, dffr, latchnq_comp, nor, not|
|4|not, nand, nor, cnt, cnt, cnt, mux, nor, nor, nor, notif1, nand3, and3, muxi, or, notif1, dffr, notif1, notif1, not, latch, latchnq_comp, notif1, notif1, latchnq_comp, const, latchnq_comp, latch, mux, dffr, dffr, latchnq_comp, not, notif1, not, and|
|5|nor, nor, cnt, cnt, nor, cnt, notif1, muxi, cnt, or, notif1, muxi, muxi, notif1, notif1, not, bufif0, notif1, not, nor, nand, mux, not, notif1, not, notif1, notif1, notif1, notif1, notif1, notif1, notif1, notif1, notif1, notif1, notif1, notif1, notif1, and3, nand4, nand4|
|6|not, muxi, notif1, muxi, notif1, notif1, dffr, muxi, notif1, notif1, notif1, or, notif1, notif1, dffr, notif1, dffr, notif1, dffr, dffr, or, nor, notif1, dffr, dffr, nand4, dffr, notif1, and4, not, not, and3, and4, nor4, nor5|
|7|or3, nor_latch, not, dffr, dffr, dffr, and3, nand3, dffr, notif1, dffr, not3, nand4, not3, and4, nand4, and4, nor, and4, not, and4, not, and3, nand3, muxi, dffr, muxi, dffr, notif1, dffr, dffr, notif1, notif1, notif1|
|8|and, dffr, dffr, dffr, dffsr, nor, not, not, and, nand3, not, and, dffr, not, muxi, muxi, or, not, nor3, nand, nand, nor, nand4, and4, nand4, and4, not, muxi, dffsr, mux, dffr, not, not, dffr, dffr, not2, not, not, not, notif1|