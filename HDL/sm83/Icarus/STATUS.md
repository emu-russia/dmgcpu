# SM83 core suite - status (issue #400)

Snapshot of `HDL/sm83/Icarus` after the SM83-core regression bring-up.
The suite drives the **real SM83 core netlist** (HDL/sm83: `Top.v`
SM83Core + ALU/Bottom/DataMux/Decoder1-3/IDU/IRNots/IRQ/Regs/Seq/
SeqCells/Thingy + `_GekkioNames.v`) with `external_clk.v` (the CPU clock
generator, same as the ROM harness `run.v`) and a flat 64K memory model
(Bogus_HW bus conventions: reads on `MREQ & RD`, writes captured at the WR
trailing edge with the #1-delayed A/D copies).  Every test prints
`RESULT tb_xxx N PASS/FAIL`; `run_all.sh` reports SUITE OK.

## Why "Oracle"

The core netlist is the ground truth for the DMG-CPU: anything observable
through its pins (bus cycles, register file, flags, decoder outputs,
instruction durations, interrupt dispatch) can be measured on it and
compared against documentation or expectations - this suite is the set of
automated "questions" and recorded answers.

## Status per test (all PASS in run_all.sh)

| Test | Checks | Purpose |
|------|--------|---------|
| `tb_sm83_regs` | 13 | Register file + immediate/pair loads, SP, `LD (nn),A` store, PC at HALT |
| `tb_sm83_alu` | 160 | 8-bit ALU (ADD/ADC/SUB/SBC/AND/OR/XOR/CP) over 8 operand pairs - A result + Z/N/H/C flag law per case |
| `tb_sm83_mem` | 18 | Memory addressing: (BC)/(DE)/(HL),A + A,(nn) forms, LDH (n8), HLI/HLD auto-inc/dec |
| `tb_sm83_stack` | 15 | 16-bit moves, PUSH/POP incl. AF, ADD HL/SP, LD (nn),SP, CALL/RET, JP cc |
| `tb_sm83_jump` | 11 | JR NZ/Z/NC/C taken + not-taken paths, RST 08/18 (vector page + return push/pop) |
| `tb_sm83_irq` | 8 | IE/IME/IF dispatch: HALT wake, PC push, IF ack-clear, vectors $40/$48/$50, RETI |
| `tb_sm83_cycles` | 32 | Instruction T-state timing via M1-M1 intervals vs the documented SM83 table |

## Measured facts (issue-400 "oracle" answers)

- Register file and pair loads, stack and memory addressing all match the
  SM83 programming model byte-exactly (tb_sm83_regs/mem/stack).
- ALU flag law matches the reference Z/N/H/C computation for all tested
  (op, operand) pairs, including carry-in for ADC/SBC and CP leaving A
  unchanged (tb_sm83_alu).
- Relative-jump semantics: taken/not-taken paths are both exercised and
  only the right branch's marker is written (tb_sm83_jump).  JR taken =
  12 T-states, not-taken = 8 (tb_sm83_cycles).
- Interrupts: IE write at $FFFF is consumed by the core; asserting an IF
  bit with IE+IME enabled wakes the CPU from HALT, pushes the return
  address on the stack (SP-2), vectors to $40/$48/$50 by the request bit,
  and CPU_IRQ_ACK clears the IF bit; RETI pops and returns (tb_sm83_irq).
- Timing oracle table (measured = documented, tb_sm83_cycles):
  NOP/LD r,r/INC/DEC r = 4; LD r,n/ADD A,n/LD A,(HL) = 8;
  LD rr,nn/ADD HL,rr = 12/8; LD (HL),n/INC/DEC (HL) = 12;
  JR taken = 12, not taken = 8; JP = 16; CALL = 24; RET = 16.

## Research notes / open items

- The env reuses the `run.v` bus conventions so the same memory timing
  questions that the blargg ROM harness answers at the program level are
  here answered at the register/bus level (and much faster - sub-second
  tests instead of multi-minute ROM runs).
- Warm-reset behaviour: after the core halts (HALT), re-asserting RESET
  does not reliably restart it from PC=0 in this harness (the sync reset
  chain needs the internal clocks; halt gates them).  Tests therefore use
  one power-on reset per test and structure multi-phase scenarios (e.g.
  tb_sm83_irq) as a single boot.
- CB-prefixed instructions produce an extra M1 pulse (the CB byte fetch
  is an opcode fetch itself) - a timing-test note, not yet a dedicated
  CB-prefix regression (the blargg ROM suite covers the CB semantics;
  issue-400 follow-up could add CB rotate/bit timing cases).
- Register file / stack / jump and ALU semantics were also cross-verified
  against the known-good blargg cpu_instrs results through run.v; the two
  harnesses agree (register/flag outcomes of the same programs match).

## Files

- `sm83_env.v` - reusable environment: real SM83Core + External_CLK +
  flat memory + IF model + poke/peek/reset/wait/irq tasks + observable
  state probes (pc/sp/ir/regA-L/zbus flags/bc/de/hl/decoder d,w,x).
- `external_clk.v` - the CPU clock generator (shared with run.v).
- `tb_sm83_*.v` - regression tests (see the table above).
- `mk_gtkw.py`, `vcd2png.py` - GTKWave save-file / PNG renderer tooling
  (adapted from the soc icarus suites; see `waves_cfg_*.json`).
- `run_all.sh` - compile + run the whole suite (WSL-native Icarus).
- `waves/` - per-test PNG wave images; `waves.md` - this documentation.
