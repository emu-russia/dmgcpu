# Top Left

:warning: The section is in development.

Status: More polishing is required. Very poorly visible Poly.

![locator_topleft](/imgstore/locator_topleft.png)

![topleft](/imgstore/topleft.jpg)

- The top part seems to contain the Data Latch
- In the middle part it is not yet clear what is
- It is very likely that the lower part is a BCD ALU, working with nibbles (4-bits).

## Top of 8 pieces + NOR-8

Piece (x8):

![module1](/imgstore/module1.jpg)

8-NOR:

![nor8_1](/imgstore/nor8_1.jpg)

## The middle part

Some obscure construction that looks like a Christmas tree.

TBD.

## Bottom part

Consists of two halves.

The top contains 8 comb logic modules (ANDs-to-NORs) whose outputs go up:

![comb1](/imgstore/comb1.jpg)

(Comb example)

The lower part contains many NAND trees, the inputs for which come from all sides.
