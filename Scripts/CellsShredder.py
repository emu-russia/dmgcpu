"""

	A script for slicing the `dmg_cells` picture into small pieces.

	I'm tired of doing it by hand every time.

"""

# https://stackoverflow.com/questions/5953373/how-to-split-image-into-multiple-pieces-in-python

import os
import sys
from PIL import Image

def CropImage (src, dest, rect):
	im = Image.open(src + ".png")
	a = im.crop([rect[0], rect[1], rect[0]+rect[2], rect[1]+rect[3]])
	a.save("%s.jpg" % dest, quality=85)

if __name__ == '__main__':
	print ("CellsShredder Start")
	FusedImg = "../imgstore/soc/dmg_cells"
	CropImage (FusedImg, "../imgstore/modules/soc/not", [17, 18, 205, 50] )
	CropImage (FusedImg, "../imgstore/modules/soc/not2", [22, 69, 200, 58] )
	CropImage (FusedImg, "../imgstore/modules/soc/not3", [21, 131, 204, 73] )
	CropImage (FusedImg, "../imgstore/modules/soc/not4", [21, 206, 204, 90] )
	CropImage (FusedImg, "../imgstore/modules/soc/not6", [18, 374, 204, 122] )

	CropImage (FusedImg, "../imgstore/modules/soc/nand", [243, 17, 204, 61] )
	CropImage (FusedImg, "../imgstore/modules/soc/nand3", [243, 80, 202, 72] )
	CropImage (FusedImg, "../imgstore/modules/soc/nand4", [240, 158, 205, 87] )
	CropImage (FusedImg, "../imgstore/modules/soc/nand5", [242, 268, 204, 102] )
	CropImage (FusedImg, "../imgstore/modules/soc/nand6", [244, 374, 202, 117] )
	CropImage (FusedImg, "../imgstore/modules/soc/nand7", [240, 494, 205, 138] )

	CropImage (FusedImg, "../imgstore/modules/soc/nor", [468, 19, 200, 59] )
	CropImage (FusedImg, "../imgstore/modules/soc/nor3", [467, 81, 204, 74] )
	CropImage (FusedImg, "../imgstore/modules/soc/nor4", [467, 165, 204, 88] )
	CropImage (FusedImg, "../imgstore/modules/soc/nor5", [469, 266, 205, 104] )
	CropImage (FusedImg, "../imgstore/modules/soc/nor6", [469, 379, 203, 120] )
	CropImage (FusedImg, "../imgstore/modules/soc/nor8", [474, 625, 200, 153] )

	CropImage (FusedImg, "../imgstore/modules/soc/and", [707, 15, 203, 73] )
	CropImage (FusedImg, "../imgstore/modules/soc/and3", [705, 87, 202, 89] )
	CropImage (FusedImg, "../imgstore/modules/soc/and4", [705, 179, 203, 105] )

	CropImage (FusedImg, "../imgstore/modules/soc/or", [960, 15, 200, 69] )
	CropImage (FusedImg, "../imgstore/modules/soc/or3", [961, 83, 203, 88] )
	CropImage (FusedImg, "../imgstore/modules/soc/or4", [960, 173, 202, 105] )

	CropImage (FusedImg, "../imgstore/modules/soc/xnor", [1252, 17, 203, 107] )
	CropImage (FusedImg, "../imgstore/modules/soc/xor", [1253, 128, 204, 104] )

	CropImage (FusedImg, "../imgstore/modules/soc/mux", [1486, 13, 207, 109] )
	CropImage (FusedImg, "../imgstore/modules/soc/muxi", [1490, 122, 205, 94] )

	CropImage (FusedImg, "../imgstore/modules/soc/oai", [261, 883, 196, 78] )
	CropImage (FusedImg, "../imgstore/modules/soc/oan", [256, 969, 204, 89] )
	CropImage (FusedImg, "../imgstore/modules/soc/aon", [604, 798, 206, 93] )
	CropImage (FusedImg, "../imgstore/modules/soc/aon22", [604, 901, 203, 135] )
	CropImage (FusedImg, "../imgstore/modules/soc/aon222", [824, 852, 206, 192] )
	CropImage (FusedImg, "../imgstore/modules/soc/aon2222", [1057, 805, 203, 235] )
	CropImage (FusedImg, "../imgstore/modules/soc/aon222222", [829, 494, 202, 327] )

	CropImage (FusedImg, "../imgstore/modules/soc/fa", [1300, 713, 208, 330] )
	CropImage (FusedImg, "../imgstore/modules/soc/ha", [1507, 866, 207, 175] )
	CropImage (FusedImg, "../imgstore/modules/soc/cnt", [2217, 724, 207, 333] )

	CropImage (FusedImg, "../imgstore/modules/soc/notif0", [1251, 271, 206, 109] )
	CropImage (FusedImg, "../imgstore/modules/soc/notif1", [1252, 401, 206, 109] )
	CropImage (FusedImg, "../imgstore/modules/soc/bufif0", [1248, 515, 209, 163] )

	CropImage (FusedImg, "../imgstore/modules/soc/nor_latch", [1742, 891, 205, 114] )
	CropImage (FusedImg, "../imgstore/modules/soc/nand_latch", [1956, 889, 208, 115] )

	CropImage (FusedImg, "../imgstore/modules/soc/latch_comp", [1736, 208, 196, 137] )
	CropImage (FusedImg, "../imgstore/modules/soc/latchnq_comp", [1733, 363, 197, 146] )
	CropImage (FusedImg, "../imgstore/modules/soc/latchr_comp", [1735, 530, 198, 164] )
	CropImage (FusedImg, "../imgstore/modules/soc/latch", [1738, 704, 192, 174] )

	CropImage (FusedImg, "../imgstore/modules/soc/dffr_comp", [1980, 318, 199, 234] )
	CropImage (FusedImg, "../imgstore/modules/soc/dffrnq_comp", [1979, 548, 204, 239] )
	CropImage (FusedImg, "../imgstore/modules/soc/dffr", [2215, 70, 212, 281] )
	CropImage (FusedImg, "../imgstore/modules/soc/dffsr", [2218, 362, 204, 352] )

	CropImage (FusedImg, "../imgstore/modules/soc/const", [25, 917, 181, 45] )

	print ("CellsShredder End")