
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
	print ("SocShredder End")