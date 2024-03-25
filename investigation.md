# JP a16 and LD SP, a16

JP 0003 is writing 0xFFFC to PC instead of 0x0003, which is its inverse. The
flow of 0x0003 to PC is inverted a couple of times, and one of them may be
wrong.

The flow is the following:

pcq (FFFC) <- pc_bnq (0003) <- pcnd (0003) <- wzreg_to_pc ? zbus/wbus (FFFC) : IDU (N/A)

I guess the flow between the "mux" and "pcq" is shared between the "IDU to PC"
and this "ZREG to PC". And I guess that ZREG is shared with other instructions.
So I am not sure where the problem is. I may need to test with other
instructions first.

Testing with the instruction "LD SP, 0003", the same problem happens, 0xFFFC is
load into SP. This make thing that the problem is in zbus, as it is only used in
PC and SP, as far as I know.

~~Looking where zbus is first assigned, I found that all other bus are negations
of zbus or wbus. This make me think that zbus should naturally be inverted, and
the buses should directly connect to it.~~

Actually, all registers are inverted, so maybe zbus should be inverted in its
entired, as from my analysis below.

# LD (HL), A (after `LD A, $BC` `LD HL, $ff80`)

This should put A in the data bus, and HL in the address bus. But HL appear
inverted (since the previous `LD HL, $ff80`) in the address bus, and the databus
stays in high impedance.

## Data bus stays in high impedance

`DataLatch` is the only one connected to the external data bus `D`. Although it
is called a "latch" it does not hold any data, it just forwards data from other
data buses; that is `Res` (the result of the ALU) and `DL` (the internal
databus).

But `datalatch.md` states that it can only output values to `DL`, and load from
either `D` or `Res`. But this should not be the case, because we need to output
to the external bus, and `DataLatch` is the only one connected to it.

Also, it specifies `DL` bus as `inout`, but never assign `z` to it. In fact,
during the write (`WR` high) `DataBridge` also writes to `DL`, making `DL` go
to invalid state `x`. Actually, a lot of things tries to write to `DL`.

(Strangely, `DataBridge` only writes `0` or `z` bits to `DL`. Maybe `DL` has a
pull-up somewhere? Oh, maybe that is what `BusPrecharge` does, not sure if
verilog will simulate that. Oh, this is handle by the use of `BusKeeper`.)

The value of register `A` is stored in `ReqA`/`r1q`, inverted. This value can be
put in the `abus` or `bbus` (and `Aout`, but just affect ALU logic), but during
write neither of them are used, `\`s2_op_alu8` (`w[3]`) and
`\`s3_oe_areg_to_rbus` (`x[35]`) are both 0.

![opcode_77_ldhl](/imgstore/waves/opcode_77_ldhl.png)

## HL is inverted in the address bus

`H` and `L` are stored in `ReqH`/`r3q` and `ReqL`/`r2q`, respectively, inverted.
`H` can go to `abus`, `bbus` or `dbus`, and `L` can go to `abus`, `bbus` or
`cbus`. They go to the bus through an inverter, so they have they original
value.

In this instruction, `H` goes to `dbus` and `L` goes to `cbus`. `dbus` `cbus` go
through an `BusKeeper`, and them inverted again into the `AdressBus` (or `A`).

From the comments in `IDU.v`, the code expects that the internal register
actually holds the straight value of the ISA registers, but they are inverted in
the current form. This was also seen in the `JP` instruction, and I fix that
there by inverting the Zbus, but maybe we need to invert something more
fundamental, like the value read from the memory?

- H: `r3q` -> `dbus` -> `BusKeeper` -> `AddressBus` (inverted)
- L: `r2q` -> `cbus` -> `BusKeeper` -> `AddressBus` (inverted)

## Path from databus to register A

- `D` -> `DataLatch` -> `DL` -> `Z_in` (inverted) -> `zbus` -> `bbus`
  (straighted) -> `bbq` -> `DV` (inverted) -> `Res` -> `fbus` -> `RegA`

So `RegA`/`r1q` contains the inverted value of `A`.

![Path_Regs](/imgstore/Path_Regs.png)

## Path from databus to register HL

- H: `D` -> `DataLatch` -> `DL` -> `W_in` (inverted) -> `wbus` -> `fbus` -> `RegH`
- L: `D` -> `DataLatch` -> `DL` -> `Z_in` (inverted) -> `zbus` -> `ebus` -> `RegL`

So `HL` are also stored inverted in the registers.

![Path_Regs](/imgstore/Path_HL.png)

## Path from databus to register SP

- SP high: `D` -> `DataLatch` -> `DL` -> `W_in` (inverted) -> `wbus` -> `sph_nd` (inverted) -> `SPH` (inverted)
- SP low:  `D` -> `DataLatch` -> `DL` -> `Z_in` (inverted) -> `zbus` -> `spl_nd` (inverted) -> `SPL` (inverted)

So `SP` is also stored inverted in the registers.

![Path_Regs](/imgstore/Path_SP.png)

## Path from databus to PC


- PC high: `D` -> `DataLatch` -> `DL` -> `W_in` (inverted) -> `wbus` -> `pch_nd` (inverted) -> `PCH` (inverted)
- PC low:  `D` -> `DataLatch` -> `DL` -> `Z_in` (inverted) -> `zbus` -> `pcl_nd` (inverted) -> `PCL` (inverted)

So `PC` is also stored inverted in the registers.

![Path_Regs](/imgstore/Path_PC.png)
