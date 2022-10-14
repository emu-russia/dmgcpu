"""

	Script for generating Verilog based on NOR tree description.

	Example tree: "{d4,d5,d6,d7}"

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
				text += " & ";
			text += "(" + t.replace(",", "|") + ")";
			first = False;

	# Decoder2 Haxo (dynamic + domino `not`)
	#text = "\tassign " + args.output_name + " = ~(CLK2 ? ~(" + text + ") : 1'b1);";

	text = "\tassign " + args.output_name + " = ~(" + text + ");";	

	print (text);

if __name__ == '__main__':
	parser = argparse.ArgumentParser(description='Specify the tree in the format {terms}{terms}{...}')
	parser.add_argument('--tree', dest='tree', default='{}', help='NOR tree in Wiki format.')
	parser.add_argument('--output_name', dest='output_name', default='x', help='Verilog output scalar name')
	Main(parser.parse_args())
