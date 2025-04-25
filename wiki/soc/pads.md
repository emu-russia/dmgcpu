# I/O Terminals & Bonding Pads

Instead of `inout` it will be written `bidir`, since inout is easily confused with input (hello Verilog developers).

|Name|Netlist name|Direction|Pad Type|Description|
|---|---|---|---|---|
|CK1|ck1|input   |OSC| Input CLK, 4194304 Hz (2^22). Corresponds to the T-cycles of SM83. The power 2 input frequency allowed the internal frequency dividers to be greatly simplified, using conventional shift registers instead of Jhonson counter. Aka `XI` |
|CK2|ck2|output   |OSC| Output inverted value of CK1 if OSC enabled or 0. Aka `XO` |
|PHI|phi|output   |OBUF_A| CK1 ÷ 4. Corresponds to M-cycles of CPU (1 M-cycle = 4 T-cycles) |
|/RES|n_res|input   |IBUF_A| System Reset |
|CPU RAM|||||
|A15-A0|\[15:0\]a|bidir   |IOBUF_A| External CPU address bus. Bidirectional because it can be switched to Input mode when TEST1 is active. |
|D7-D0|\[7:0\]d|bidir   |IOBUF_B| External CPU data bus |
|/RD|n_rd|bidir   |IOBUF_A| |
|/WR|n_wr|bidir   |IOBUF_A| |
|/CS|n_cs|output   |OBUF_A| |
|PPU VRAM|||||
|MA12-MA0|\[12:0\]ma|output   |OBUF_A| |
|MD7-MD0|\[7:0\]md|bidir   |IOBUF_B| |
|/MRD|n_mrd|bidir   |IOBUF_A| |
|/MWR|n_mwr|bidir   |IOBUF_A| |
|/MCS|n_mcs|bidir   |IOBUF_A| |
|Test Mode|||||
|T1|t1|input   |IBUF_A| The main purpose is to disable all internal CPU A/D bus drivers and use values from the outside. |
|T2|t2|input   |IBUF_A| The main purpose is to disable the internal Boot ROM. Also known as `ROMDIS`. |
|LCD Driver interface|||||
|CPG|cpg|output   |OBUF_A| |
|CPL|cpl|output   |OBUF_A|Signal data latch signal. Used as CLK for Y-Driver chip |
|FR|fr|output   |OBUF_A|LCD alterating signal; FR is used to stop the LCD plating out (destroying the LCD material with DC), it inverts the drivers |
|LD0|ld0|output   |OBUF_A|LCD Data0|
|LD1|ld1|output   |OBUF_A|LCD Data1|
|S|s|output   |OBUF_A| |
|ST|st|output   |OBUF_A| |
|Serial Link|||||
|SCK|sck|bidir   |IOBUF_C| |
|SIN|sin|bidir   |IOBUF_B| |
|SOUT|sout|output   |OBUF_A| |
|Audio|||||
|VIN|vin|input analog   |AIBUFFER| |
|SO1|so1|output analog   |AOBUFFER| |
|SO2|so2|output analog   |AOBUFFER| |
|Port P1|||||
|P13-P10|p13-p10|bidir   |IOBUF_B| |
|P14|p14|output   |OBUF_B| |
|P15|p15|output   |OBUF_B| |
|Unbonded pads|||||
|/NMI|n_nmi|input, not wired   |IBUF_B|Non-maskable interrupt |
|M1|m1|output, not wired   |OBUF_A|SM83 Core is in the M1 cycle |

Next is a description of the individual terminal schematics, the names correspond to @msinger's old names (he recently renamed, these names are given in parentheses)

## IOBUF_A (PAD_BIDIR)

See http://iceboy.a-singer.de/doc/dmg_cells.html#pad_bidir

## IOBUF_B (PAD_BIDIR_ENA_PU)

See http://iceboy.a-singer.de/doc/dmg_cells.html#pad_bidir_ena_pu

## IOBUF_C (PAD_BIDIR_SCK)

![pad_sck](/imgstore/soc/pad_sck.jpg)

![sck_tran](/logisim/soc/sck_tran.png)

Revision B has slight changes from Revision A due to the global addition of "combs" to some locations on the chip:

![pad_sck_rev_b](/imgstore/soc/pad_sck_rev_b.png)

## IBUF_A (PAD_IN)

Inverting input. The inverter can be considered as a transparent latch (dynamic latch with gate memory), but it hardly makes sense, because all input signals using this pad are always driven.

See http://iceboy.a-singer.de/doc/dmg_cells.html#pad_in

## IBUF_B (PAD_IN_PU)

Inverting input with pullup. Used only for /NMI that is not wired out, so the output from the circuit is always 0.

See http://iceboy.a-singer.de/doc/dmg_cells.html#pad_in_pu

## OBUF_A (PAD_OUT)

Inverting Output.

See http://iceboy.a-singer.de/doc/dmg_cells.html#pad_out

## OBUF_B (PAD_OUT_DIFF)

Inverting tri-state output. The value is therefore fed to the circuit as a complement (2 wires).

|NDRV|/PDRV|Pad Output|
|----|-----|-----|
|0|0|1|
|0|1|HighZ|
|1|x|0|

See http://iceboy.a-singer.de/doc/dmg_cells.html#pad_out_diff

## OSC

![pad_ck1_ck2](/imgstore/soc/pad_ck1_ck2.jpg)

![ck1_ck2_tran](/logisim/soc/ck1_ck2_tran.png)

## AIBUFFER

See http://iceboy.a-singer.de/doc/dmg_cells.html#aibuf

## AOBUFFER

See http://iceboy.a-singer.de/doc/dmg_cells.html#aobuf