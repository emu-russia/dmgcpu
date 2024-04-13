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

OPTS=\
 -DROM=$(ROM)\
 --top-module SM83_Run\
 --cc\
 $(SOURCES)\
 ../Icarus/external_clk.v\
 ../Icarus/run.v\
 --timing\
 --trace-fst\
 --Wno-LATCH

run:
	cd ../Icarus && ../Verilator/obj_dir/VSM83_Run

build:
	verilator $(OPTS) --binary -j 0

check:
	verilator $(OPTS) --lint-only --report-unoptflat

clean:
	rm -rf obj_dir
