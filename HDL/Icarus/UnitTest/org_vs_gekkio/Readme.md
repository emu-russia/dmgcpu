# Decoder match results.

Decoder 1/2 match.

In decoder 3 I found strangeness when opcodes around 0x40-0x7f. They are related to output decoder1 `d41`. That said, I can't explain the differences (I don't see myself making any errors).

`|d41|{0,2,4,7}|Decoder3 (not used in Decoder2)|All LD reg/(HL), (HL)/reg, including HALT (in range 0x40-0x7f)|`

0xc2/0xca/0xd2/0xda (JP cc, a16) are associated with the `writeback` = `~CLK5` signal.
