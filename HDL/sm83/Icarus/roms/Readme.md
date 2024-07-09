# roms

This folder contains small programs for testing the execution of instructions.

HW for the test tool contains just flat 64 KByte memory, these images are loaded at address 0 (see `Bogus_HW` module)

## cpu_insts

Taken from here: https://github.com/retrio/gb-test-roms/tree/master/cpu_instrs

Converted by:
```
python ../../../Scripts/bin2mem.py cpu_instrs.gb cpu_instrs.mem
```
