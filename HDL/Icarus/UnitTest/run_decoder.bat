iverilog -D ICARUS -o decoder.run ../../GekkioNames.v ../../Decoder1.v ../../Decoder2.v ../../Decoder3.v run_decoder.v
vvp decoder.run
