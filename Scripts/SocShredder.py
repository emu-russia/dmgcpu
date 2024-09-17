
"""

	A script for slicing the `dmg_cpu_a` master picture into small pieces.

"""

# https://stackoverflow.com/questions/5953373/how-to-split-image-into-multiple-pieces-in-python

import os
import sys
from PIL import Image

def CropImage (src, dest, rect):
	im = Image.open(src + ".jpg")
	a = im.crop([rect[0], rect[1], rect[0]+rect[2], rect[1]+rect[3]])
	a.save("%s.jpg" % dest, quality=85)

if __name__ == '__main__':
	print ("SocShredder Start")
	FusedImg = "../imgstore/soc/dmg_cpu_a"
	CropImage (FusedImg, "../imgstore/soc/clkgen", [13493, 2684, 2651, 991] )
	CropImage (FusedImg, "../imgstore/soc/div", [13410, 3636, 2730, 1434] )
	CropImage (FusedImg, "../imgstore/soc/arb", [2035, 2651, 1540, 5616] )
	CropImage (FusedImg, "../imgstore/soc/mmio", [9963, 3019, 3236, 4759] )
	CropImage (FusedImg, "../imgstore/soc/apu", [16310, 3143, 4978, 15295] )
	CropImage (FusedImg, "../imgstore/soc/ppu1", [2123, 8996, 4626, 9813] )
	CropImage (FusedImg, "../imgstore/soc/ppu2", [7272, 9157, 4893, 9296] )
	# Macro Cells
	CropImage (FusedImg, "../imgstore/soc/waveram", [13399, 5081, 2780, 1752] )
	CropImage (FusedImg, "../imgstore/soc/bootrom", [13504, 6822, 2675, 1112] )
	CropImage (FusedImg, "../imgstore/soc/hram", [12320, 9028, 2674, 3553] )
	CropImage (FusedImg, "../imgstore/soc/oam", [12335, 12329, 2661, 5241] )
	CropImage (FusedImg, "../imgstore/soc/dac1", [15025, 9039, 1265, 9724] )
	CropImage (FusedImg, "../imgstore/soc/dac2", [12524, 17564, 2513, 1187] )
	# Pads
	CropImage (FusedImg, "../imgstore/soc/pad_ck1_ck2", [21721, 8274, 1547, 1762] )
	print ("SocShredder End")