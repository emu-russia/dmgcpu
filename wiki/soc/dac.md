# Sound Output DAC

![locator_dac](/imgstore/soc/locator_dac.jpg)

![dac1](/imgstore/soc/dac1.jpg)

![dac2](/imgstore/soc/dac2.jpg)

## Signals

![dac_ports](/imgstore/soc/dac_ports.png)

| Signal Name            | Direction | From / Where To             | Description |
|------------------------|-----------|-----------------------------|-------------|
| \[3:0\] ch1_out        | Input     |                             |  |
| \[3:0\] ch2_out        | Input     |                             |  |
| \[3:0\] ch3_out        | Input     |                             |  |
| \[3:0\] ch4_out        | Input     |                             |  |
| l_vin_en               | Input     |                             |  |
| \[3:0\] lmixer         | Input     |                             |  |
| n_ch1_amp_en           | Input     |                             |  |
| n_ch2_amp_en           | Input     |                             |  |
| n_ch3_amp_en           | Input     |                             |  |
| n_ch4_amp_en           | Input     |                             |  |
| \[2:0\] n_lvolume      | Input     |                             |  |
| \[2:0\] n_rvolume      | Input     |                             |  |
| r_vin_en               | Input     |                             |  |
| \[3:0\] rmixer         | Input     |                             |  |
| vin_analog             | Input     |                             |  |
| so1_analog             | Output    |                             |  |
| so2_analog             | Output    |                             |  |