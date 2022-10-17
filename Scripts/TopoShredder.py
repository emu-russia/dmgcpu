"""

	A script for slicing the main SM83 topology picture into small pieces.

	I'm tired of doing it by hand every time.

"""

# https://stackoverflow.com/questions/5953373/how-to-split-image-into-multiple-pieces-in-python

import os
import sys
from PIL import Image

def CropImage (src, dest, rect):
	im = Image.open(src + ".jpg")
	a = im.crop(rect)
	a.save("%s.jpg" % dest, quality=85)

if __name__ == '__main__':
	print ("TopoShredder Start")
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/alu", [1626, 841, 1626+1780, 841+2066] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/cross1", [3243, 384, 3243+581, 384+1601] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/cross2", [3291, 1869, 3291+572, 1869+893] )
