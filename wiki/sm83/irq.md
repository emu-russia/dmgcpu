# Bottom Right (IRQ) Logic

![locator_irq](/imgstore/sm83/locator_irq.png)

The IRQ logic consists of the following parts:
- IE
- IF
- Priority encoder
- "Breadcrumps"

## IE

![module7](/imgstore/sm83/modules/module7.jpg)

![module7_tran](/imgstore/sm83/modules/module7_tran.jpg)

Latch (no CLK edge detection, yes ld edge detection) with reset.

## IF

Program access ($FFFE) to the IF in the DMG CPU has been removed.

![module8](/imgstore/sm83/modules/module8.jpg)

![module8_tran](/imgstore/sm83/modules/module8_tran.jpg)

It is a regular (transparent) latch (no edge detection), to store the interrupt flag.

## Breadcrumps

I never tire of repeating: dear chip designers - please do not spread the logic this way, because it is difficult to cut it into pieces and post pictures on the wiki. Therefore, I will not give pictures of the topology here - see the general big picture of the bottom part. Pieces of "Breadcrumped" circuits are marked with different colors.

- breadcrumped nor-9 (cyan): sc1 (Any interrupt)
- breadcrumped aoi (green): sc2 (Priority encoder)
- breadcrumped nand-9 (white): A0-A7 + AddrHi -> bot_to_Thingy (Addr = 0xffff)
- breadcrumped nand-8 (red): A8-A15 (AddrHi)
- breadcrumped nor-4 (**x3**): bro3, bro4, bro5 (Interrupt address)

Logic:

![irq_logic_tran](/imgstore/sm83/modules/irq_logic_tran.jpg)

Priority encoder:

![irq_prio_tran](/imgstore/sm83/modules/irq_prio_tran.jpg)

Interrupt address:

![irq_address_tran](/imgstore/sm83/modules/irq_address_tran.jpg)
