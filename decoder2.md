# Decoder 2

:warning: The section is in development.

![locator_decoder2](/imgstore/locator_decoder2.png)

Refines the decoded operation code and reduces the total number of outputs for random logic. Implemented as densely packed logic.

![decoder2](/imgstore/decoder2.jpg)

The outputs `d[106:0]` from [Decoder1](decoder1.md) are input.

The outputs of Decoder1 have three paths:
- Stay inside Decoder2 and form one of Decoder2's outputs with the rest of the signals
- Go outside
- Stay inside AND go outside

## Decoder2 Output Driver

## Decoder2 Outputs

|Output|Name|CLK|To|Description|
|---|---|---|---|---|
| | | | |
