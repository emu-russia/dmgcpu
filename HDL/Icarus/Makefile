SOURCES =\
 ../_GekkioNames.v\
 ../ALU.v\
 ../Bottom.v\
 ../DataMux.v\
 ../Decoder1.v\
 ../Decoder2.v\
 ../Decoder3.v\
 ../IDU.v\
 ../IRNots.v\
 ../IRQ.v\
 ../Regs.v\
 ../SeqCells.v\
 ../Seq.v\
 ../Thingy.v\
 ../Top.v

ROM=roms/bogus_hw.mem

run:
	iverilog -Wall -D ICARUS -s SM83_Run -o sm83.run $(SOURCES) run.v external_clk.v -DROM=$(ROM)
	vvp sm83.run -fst

verbose:
	iverilog -v -Wall -D ICARUS -s SM83_Run -o sm83.run $(SOURCES) run.v external_clk.v -DROM=$(ROM)
	vvp -v sm83.run -fst
