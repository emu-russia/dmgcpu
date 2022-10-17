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
	a = im.crop([rect[0], rect[1], rect[0]+rect[2], rect[1]+rect[3]])
	a.save("%s.jpg" % dest, quality=85)

if __name__ == '__main__':
	print ("TopoShredder Start")
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/alu", [1626, 841, 1780, 2066] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/cross1", [3243, 384, 581, 1601] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/cross2", [3291, 1869, 572, 893] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/bottom", [1562, 3498, 5366, 2765] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/databridge", [1176, 2227, 415, 675] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/datalatch", [1443, 586, 1955, 304] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/decoder1", [3703, 483, 2834, 687] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/decoder2", [3659, 1104, 2878, 587] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/decoder3", [3750, 1836, 3188, 1067] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/LargeComb1", [1641, 2068, 1748, 662] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/LargeComb1_Res", [1670, 2674, 1713, 223] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/rails1", [3618, 1537, 3324, 402] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/rails2", [1657, 2817, 5385, 864] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/seq", [6461, 341, 1029, 3076] )
	CropImage ("../imgstore/DMG01B_Core_Fused_Topo", "../imgstore/thingy", [6395, 3275, 386, 333] )
	print ("TopoShredder End")
