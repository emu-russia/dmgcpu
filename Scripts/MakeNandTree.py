"""

	Script for generating Verilog based on NAND tree description.

	Example tree: "{alu0}{w24,nIR3,nIR4,nIR5}{w10,IR5}{w10,IR4}{w10,IR3}"

"""

import os
import sys
import argparse
import re

def Main(args):
	terms = re.split (r'[{}]', args.tree);
	first = True;
	text = "";
	for t in terms:
		if t != "":
			numbers = re.compile(r'(\d+)')
			t = numbers.sub(r'[\1]', t)
			if not first:
				text += " | ";
			text += "(" + t.replace(",", "&") + ")";
			first = False;

	# Decoder1/3 Haxo (dynamic + domino `not`)
	#text = "\tassign " + args.output_name + " = ~(CLK2 ? ~(" + text + ") : 1'b1);";

	text = "\tassign " + args.output_name + " = ~(" + text + ");";	

	print (text);

if __name__ == '__main__':
	parser = argparse.ArgumentParser(description='Specify the tree in the format {terms}{terms}{...}')
	parser.add_argument('--tree', dest='tree', default='{}', help='NAND tree in Wiki format.')
	parser.add_argument('--output_name', dest='output_name', default='x', help='Verilog output scalar name')
	Main(parser.parse_args())
