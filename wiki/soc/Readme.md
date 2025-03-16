# DMG-CPU LR35902 SoC

Top-level layout of the entire SoC:

![dmgcpu_sm](/HDL/soc/design/dmgcpu_sm.png)

## SoC Architecture Overview

After a long analysis, the impressions about the architectural solutions used in DMG-CPU can be expressed as follows:
- The topology has already been influenced by the [Mead-Conway revolution](https://en.wikipedia.org/wiki/Mead%E2%80%93Conway_VLSI_chip_design_revolution) - most of the elements are implemented as standard cells, but you can see that the developers have not forgotten the "manual method". Almost the whole SM83 core and macro-cells (embedded memory) and (naturally) DAC are made by "hand"
- Standard cells are arranged in domains, but they do not have a clear specialization (e.g. the APU contains logic for the serial port). In modern solutions, all standard cells are usually located in the giant "sea of cells". In this case we most likely have several small "pools". It is interesting that the [very first revision of DMG-CPU](https://siliconpr0n.org/map/nintendo/dmg-cpu/mcmaster_mz_mit20x/) has a slightly different domain organization
- The SoC has a rather "bushy" clock tree (it has not been fully explored yet). The SM83 core receives a pack of CLKs as input. Besides, CLK wiring uses both single-rail CLK and dual-rail CLK (CLK + its complement), so latch/dff have 2 variants
- As mentioned, both latch and dff are used for sequential logic. That is, the SoC uses asynchronous and synchronous approaches together. This makes the circuits rather "capricious" with respect to CLK frequency
- The internal buses are driven via tristate elements (notif/bufif) using old-school bus precharging technique for a specific CLK half-cycle. Modern solutions use special cells (Bus-keepers)
- The SM83 core is made with one layer of metal, the rest of the SoC uses two layers of metal. The SM83 core uses old-school domino logic on par with conventional CMOS logic
- Macro cells (memory) contain a small number of standard cells :-)
- These and other features make the DMG-CPU a rather curious "exhibit", but nonetheless interesting to study and dive into the history of a "previous, obviously more advanced civilization"
