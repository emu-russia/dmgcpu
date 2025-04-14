# I/O Terminals & Bonding Pads

Instead of `inout` it will be written `bidir`, since inout is easily confused with input (hello Verilog developers).

|Name|Netlist name|Direction|Pad Type|Description|
|---|---|---|---|---|
|CK1|ck1|input   |OSC| |
|CK2|ck2|output   |OSC| |
|PHI|phi|output   |OBUF_A| |
|/RES|n_res|input   |IBUF_A| |
|CPU RAM|||||
|A15-A0|\[15:0\]a|bidir   |IOBUF_A| |
|D7-D0|\[7:0\]d|bidir   |IOBUF_B| |
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
|T1|t1|input   |IBUF_A| |
|T2|t2|input   |IBUF_A| |
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

## IOBUF_A

See http://iceboy.a-singer.de/doc/dmg_cells.html#iobuf_a

## IOBUF_B

See http://iceboy.a-singer.de/doc/dmg_cells.html#iobuf_b

## IOBUF_C (SCK)

![pad_sck](/imgstore/soc/pad_sck.jpg)

![sck_tran](/logisim/soc/sck_tran.png)

Revision B has slight changes from Revision A due to the global addition of "combs" to some locations on the chip:

![pad_sck_rev_b](/imgstore/soc/pad_sck_rev_b.png)

## IBUF_A

See http://iceboy.a-singer.de/doc/dmg_cells.html#ibuf_a

## IBUF_B

See http://iceboy.a-singer.de/doc/dmg_cells.html#ibuf_b

## OBUF_A

See http://iceboy.a-singer.de/doc/dmg_cells.html#obuf_a

## OBUF_B

See http://iceboy.a-singer.de/doc/dmg_cells.html#obuf_b

## OSC

![pad_ck1_ck2](/imgstore/soc/pad_ck1_ck2.jpg)

![ck1_ck2_tran](/logisim/soc/ck1_ck2_tran.png)

## AIBUFFER

See http://iceboy.a-singer.de/doc/dmg_cells.html#aibuf

## AOBUFFER

See http://iceboy.a-singer.de/doc/dmg_cells.html#aobuf