# Wave RAM

![locator_waveram](/imgstore/soc/locator_waveram.jpg)

![waveram](/imgstore/soc/waveram.jpg)

## Signals

![waveram_ports](/imgstore/soc/waveram_ports.png)

| Signal Name          | Direction | From / Where To             | Description |
|----------------------|-----------|-----------------------------|-------------|
| \[3:0\] a            | Input     | From APU                    | Wave RAM address (16 bytes, `wave_a`) |
| active               | Input     | From APU                    | Wave channel (CH3) active enable (`ch3_active`) |
| bl_pch               | Input     | From APU                    | Bitline precharge (`wave_bl_pch`) |
| n_rd                 | Input     | From APU                    | Read enable (active low, `n_wave_rd`); output via `dout` |
| n_wr                 | Input     | From APU                    | Write enable (active low, `n_wave_wr`); input via `d` |
| \[7:0\] d            | Bidir     | Global                      | SoC internal data bus (CPU write/read access) |
| \[7:0\] dout         | Output    | To APU                      | Wave RAM data output for CH3 playback (`wave_rd`) |