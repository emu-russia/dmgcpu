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
	FusedTopo = "../imgstore/sm83/DMG01B_Core_Fused_Topo"
	# Parts
	CropImage (FusedTopo, "../imgstore/sm83/alu", [1626, 841, 1780, 2066] )
	CropImage (FusedTopo, "../imgstore/sm83/cross1", [3243, 384, 581, 1601] )
	CropImage (FusedTopo, "../imgstore/sm83/cross2", [3291, 1869, 572, 893] )
	CropImage (FusedTopo, "../imgstore/sm83/bottom", [1562, 3498, 5366, 2765] )
	CropImage (FusedTopo, "../imgstore/sm83/databridge", [1176, 2227, 415, 675] )
	CropImage (FusedTopo, "../imgstore/sm83/datalatch", [1443, 586, 1955, 304] )
	CropImage (FusedTopo, "../imgstore/sm83/decoder1", [3703, 483, 2834, 687] )
	CropImage (FusedTopo, "../imgstore/sm83/decoder2", [3659, 1104, 2878, 587] )
	CropImage (FusedTopo, "../imgstore/sm83/decoder3", [3750, 1836, 3188, 1067] )
	CropImage (FusedTopo, "../imgstore/sm83/LargeComb1", [1641, 2068, 1748, 662] )
	CropImage (FusedTopo, "../imgstore/sm83/LargeComb1_Res", [1670, 2674, 1713, 223] )
	CropImage (FusedTopo, "../imgstore/sm83/rails1", [3618, 1537, 3324, 402] )
	CropImage (FusedTopo, "../imgstore/sm83/rails2", [1657, 2817, 5385, 864] )
	CropImage (FusedTopo, "../imgstore/sm83/seq", [6461, 341, 1029, 3076] )
	CropImage (FusedTopo, "../imgstore/sm83/thingy", [6395, 3275, 386, 333] )
	CropImage (FusedTopo, "../imgstore/sm83/clks", [1064, 261, 1441, 372] )
	# Modules
	CropImage (FusedTopo, "../imgstore/modules/sm83/ALU_to_bot", [2830, 2670, 184, 219] )
	CropImage (FusedTopo, "../imgstore/modules/sm83/bc", [2445, 2671, 226, 218] )
	CropImage (FusedTopo, "../imgstore/modules/sm83/cntbit", [5750, 3522, 387, 305] )	# IncDec_Bit
	CropImage (FusedTopo, "../imgstore/modules/sm83/gk", [3671, 3541, 725, 434] )		# ZW_To_Buses
	CropImage (FusedTopo, "../imgstore/modules/sm83/module1", [2630, 633, 236, 268] )	# DL_Bit
	CropImage (FusedTopo, "../imgstore/modules/sm83/module2", [3104, 1576, 222, 282] )	# GP_Term
	CropImage (FusedTopo, "../imgstore/modules/sm83/module6", [3110, 1060, 264, 170] )	# ALU_Sums
	CropImage (FusedTopo, "../imgstore/modules/sm83/module7", [6131, 3557, 228, 423] )	# IE_Bit
	CropImage (FusedTopo, "../imgstore/modules/sm83/module8", [6346, 3769, 143, 172] )	# IF_Bit
	CropImage (FusedTopo, "../imgstore/modules/sm83/shielded", [7141, 1744, 308, 108] )	# ~MREQ
	CropImage (FusedTopo, "../imgstore/modules/sm83/x61", [4441, 3573, 662, 399] )		# SP
	CropImage (FusedTopo, "../imgstore/modules/sm83/x68", [5071, 3561, 691, 411] )		# PC
	CropImage (FusedTopo, "../imgstore/modules/sm83/module42", [6907, 1033, 192, 75] )	# module4_2 (special rs)
	CropImage (FusedTopo, "../imgstore/modules/sm83/comb1", [3099, 1823, 196, 265] )		# Shifter msb
	CropImage (FusedTopo, "../imgstore/modules/sm83/comb2", [2928, 1816, 130, 263] )		# Shifter bits [6:1]
	CropImage (FusedTopo, "../imgstore/modules/sm83/comb3", [1741, 1814, 109, 274] )		# Shifter lsb
	print ("TopoShredder End")
