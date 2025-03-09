# I/O Terminals & Bonding Pads

Instead of `inout` it will be written `bidir`, since inout is easily confused with input (hello Verilog developers).

|Name|Netlist name|Direction|Pad Type|Description|
|---|---|---|---|---|
|D7-D0|\[7:0\]d|bidir   |IOBUF_B| |
|MD7-MD0|\[7:0\]md|bidir   |IOBUF_B| |
|SCK|sck|bidir   |IOBUF_C| |
|SIN|sin|bidir   |IOBUF_B| |
|SOUT|sout|output   |OBUF_A| |
|SO1|so1|output analog   |AOBUFFER| |
|SO2|so2|output analog   |AOBUFFER| |
|VIN|vin|input analog   |AIBUFFER| |
|CK1|ck1|input   |OSC| |
|CK2|ck2|output   |OSC| |
|/RES|n_res|input   |IBUF_A| |
|A15-A0|\[15:0\]a|bidir   |IOBUF_A| |
|MA12-MA0|\[12:0\]ma|output   |OBUF_A| |
|/RD|n_rd|bidir   |IOBUF_A| |
|/CS|n_cs|output   |OBUF_A| |
|/WR|n_wr|bidir   |IOBUF_A| |
|/MRD|n_mrd|bidir   |IOBUF_A| |
|/MCS|n_mcs|bidir   |IOBUF_A| |
|/MWR|n_mwr|bidir   |IOBUF_A| |
|PHI|phi|output   |OBUF_A| |
|T1|t1|input   |IBUF_A| |
|T2|t2|input   |IBUF_A| |
|CPG|cpg|output   |OBUF_A| |
|CPL|cpl|output   |OBUF_A| |
|FR|fr|output   |OBUF_A| |
|LD0|ld0|output   |OBUF_A| |
|LD1|ld1|output   |OBUF_A| |
|S|s|output   |OBUF_A| |
|ST|st|output   |OBUF_A| |
|P13-P10|p13-p10|bidir   |IOBUF_B| |
|P14|p14|output   |OBUF_B| |
|P15|p15|output   |OBUF_B| |
|/NMI|n_nmi|not wired   |IBUF_B| |
|M1|m1|not wired   |OBUF_A| |

## OSC

![pad_ck1_ck2](/imgstore/soc/pad_ck1_ck2.jpg)

![ck1_ck2_tran](/logisim/soc/ck1_ck2_tran.png)

## SCK (IOBUF_C)

![pad_sck](/imgstore/soc/pad_sck.jpg)

![sck_tran](/logisim/soc/sck_tran.png)

Revision B has slight changes from Revision A due to the global addition of "combs" to some locations on the chip:

![pad_sck_rev_b](/imgstore/soc/pad_sck_rev_b.png)
