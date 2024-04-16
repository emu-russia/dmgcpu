'''
	A script to convert a binary file into Verilog mem format.

'''

import os
import sys

def Main (file_bin, file_mem):
	f = open(file_bin, 'rb')
	binarycontent = f.read(-1)
	f.close()

	text = ""
	i = 0
	for b in binarycontent:
		text += ("%02x" % b)
		i += 1
		if i % 16 == 0:
			text += "\n"
		else:
			text += " "

	text_file = open(file_mem, "w")
	text_file.write(text)
	text_file.close()

if __name__ == '__main__':
	if (len(sys.argv) < 2):
		print ("Use: python3 bin2mem.py <file.bin> <file.mem>")
	else:
		Main(sys.argv[1], sys.argv[2])
