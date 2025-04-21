CPU =\
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

SOURCES =\
 $(CPU)\
 external_clk.v\
 run.v

ROM=roms/bogus_hw.mem
WAVE_FILE=dmg_waves.fst
CYCLES=1024

# Currently dmgcpu relies on a patched version of yosys.
# Must be builded from source, from this branch: https://github.com/Rodrigodd/yosys/tree/dmgcpu-changes

run:
	iverilog -Wall -D ICARUS -s SM83_Run -o sm83.run $(SOURCES)
	vvp sm83.run -fst "+ROM=$(ROM)" "+WAVE_FILE=$(WAVE_FILE)" "+CYCLES=$(CYCLES)"

low:
	/bin/iverilog -Wall -D ICARUS -s SM83_Run -o sm83.run $(SOURCES)
	/bin/vvp sm83.run -fst "+ROM=$(ROM)" "+WAVE_FILE=$(WAVE_FILE)" "+CYCLES=$(CYCLES)"

verbose:
	iverilog -v -Wall -D ICARUS -s SM83_Run -o sm83.run $(SOURCES)
	vvp -v sm83.run -fst "+ROM=$(ROM)" "+WAVE_FILE=$(WAVE_FILE)" "+CYCLES=$(CYCLES)"

VERILATOR_OPTS=\
 --top-module SM83_Run\
 --cc\
 sm83.yosys.v\
 external_clk.v\
 run.v\
 --timing\
 --trace-fst\
 --no-trace-top\
 --Wno-fatal\
 --Wno-LATCH\
 --timescale "1ns/1ns"\
 --x-initial unique\

verilator:
	verilator $(VERILATOR_OPTS) --binary -j 0 --Mdir verilator_build
	verilator_build/VSM83_Run +verilator+rand+reset+1 "+ROM=$(ROM)" "+WAVE_FILE=$(WAVE_FILE)" "+CYCLES=$(CYCLES)"

verilator-pgo:
	verilator $(VERILATOR_OPTS) --binary -j 0 -CFLAGS -fprofile-generate -LDFLAGS -fprofile-generate --Mdir verilator_pgo_build
	verilator_pgo_build/VSM83_Run "+ROM=$(ROM)" "+WAVE_FILE=$(WAVE_FILE)" "+CYCLES=10240"
	verilator $(VERILATOR_OPTS) --binary -j 0 -CFLAGS "-fprofile-use -fprofile-correction" --Mdir verilator_pgo_build
	verilator_pgo_build/VSM83_Run +verilator+rand+reset+1 "+ROM=$(ROM)" "+WAVE_FILE=$(WAVE_FILE)" "+CYCLES=$(CYCLES)"

run_verilator:
	# The Sequencer need that at least w83 to be initialized as 1, so we pass +rand+reset+1
	verilator_build/VSM83_Run +verilator+rand+reset+1 "+ROM=$(ROM)" "+WAVE_FILE=$(WAVE_FILE)" "+CYCLES=$(CYCLES)"

run_verilator_pgo:
	# The Sequencer need that at least w83 to be initialized as 1, so we pass +rand+reset+1
	verilator_pgo_build/VSM83_Run +verilator+rand+reset+1 "+ROM=$(ROM)" "+WAVE_FILE=$(WAVE_FILE)" "+CYCLES=$(CYCLES)"

check:
	verilator $(VERILATOR_OPTS) --lint-only --report-unoptflat

clean:
	rm -f sm83.run
	rm -rf obj_dir
	rm -rf *.rtlil
	rm -f sm831.yosys.v
	rm -f sm83.yosys.run
	rm -f dmg_waves.fst
	rm -f dmg_waves2.fst

# DMG_YOSYS = /path/to/yosys-fork
# Use yosys to optmize the code, and write back as verilog
yosys: yosys.ys
ifndef DMG_YOSYS
	error DMG_YOSYS is not set
endif
	$(DMG_YOSYS) -s yosys.ys

run_yosys:
	echo "+timescale+1ns/1ns" > command_file.txt
	iverilog -f command_file.txt -g2012 -Wall -D ICARUS -s SM83_Run -o sm83.yosys.run sm83.yosys.v external_clk.v run.v
	vvp sm83.yosys.run -fst "+ROM=$(ROM)" "+WAVE_FILE=$(WAVE_FILE)" "+CYCLES=$(CYCLES)"
