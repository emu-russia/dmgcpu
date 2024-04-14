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
 ../Top.v\
 external_clk.v\
 run.v

ROM=roms/bogus_hw.mem

run:
	iverilog -Wall -D ICARUS -s SM83_Run -o sm83.run $(SOURCES) -DROM=$(ROM)
	vvp sm83.run -fst

verbose:
	iverilog -v -Wall -D ICARUS -s SM83_Run -o sm83.run $(SOURCES) -DROM=$(ROM)
	vvp -v sm83.run -fst

VERILATOR_OPTS=\
 -DROM=$(ROM)\
 --top-module SM83_Run\
 --cc\
 $(SOURCES)\
 --timing\
 --trace-fst\
 --no-trace-top\
 --Wno-fatal\
 --Wno-LATCH

verilator:
	verilator $(VERILATOR_OPTS) --binary -j 0
	obj_dir/VSM83_Run

check:
	verilator $(VERILATOR_OPTS) --lint-only --report-unoptflat

clean:
	rm -f sm83.run
	rm -rf obj_dir
