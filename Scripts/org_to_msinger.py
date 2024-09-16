'''

	Script for mapping cell type names org <-> msinger.

	Used to verify the `Map` of DMG-CPU modules with the @msinger netlist (https://github.com/msinger/dmg-schematics/tree/master/netlist)

'''

# ChatGPT Prompt:
# Write a python script to find words in a source file and replace some words with others, e.g. "apple" with "pear". The input and output file names are passed through command line parameters

import sys

def replace_words(input_file, output_file, replacements):
	try:
		with open(input_file, 'r', encoding='utf-8') as infile:
			content = infile.read()

		for old_word, new_word in replacements.items():
			content = content.replace(old_word, new_word)
		
		with open(output_file, 'w', encoding='utf-8') as outfile:
			outfile.write(content)

		print(f"Words have been substituted and saved in {output_file}")

	except FileNotFoundError:
		print(f"The {input_file} file was not found.")
	except Exception as e:
		print(f"An error has occurred: {e}")

if __name__ == "__main__":
	if len(sys.argv) != 3:
		print("Use: python3 org_to_msinger.py input_file output_file")
	else:
		input_file = sys.argv[1]
		output_file = sys.argv[2]
		replacements = {

			# Here you should carefully use the order so that longer substrings are processed first (like LZ)

			"aon222222": "AO6",
			"aon2222": "AO4",
			"aon222": "AO3",
			"aon22": "AO2",
			"aon": "AO1",
			"bufif0": "TRI_BUF_IF0",
			"cnt": "TFFD",
			"const": "CONST",
			"dffrnq_comp": "DFFR_B1",
			"dffr_comp": "DFFR_A",
			"dffr": "DFFR_B2",
			"dffsr": "DFFSR",
			"fa": "FULL_ADD",
			"ha": "HALF_ADD",
			"muxi": "MUXI",
			"mux": "MUX",
			"nand_latch": "NAND_LATCH",
			"nand3": "NAND3",
			"nand4": "NAND4",
			"nand5": "NAND5",
			"nand6": "NAND6",
			"nand7": "NAND7",
			"nand": "NAND2",			
			"and3": "AND3",
			"and4": "AND4",			
			"and": "AND2",			
			"nor_latch": "NOR_LATCH",
			"nor3": "NOR3",
			"nor4": "NOR4",
			"nor5": "NOR5",
			"nor6": "NOR6",
			"nor8": "NOR8",
			"nor": "NOR2",			
			"not2": "INV_B",
			"not3": "INV_C",
			"not4": "INV_D",
			"not6": "INV_E",
			"not": "INV_A",
			"notif0": "TRI_INV_IF0",
			"notif1": "TRI_INV_IF1",
			"oai": "OAI",
			"oan": "OA",
			"or3": "OR3",
			"or4": "OR4",
			"or": "OR2",
			"xnor": "XNOR",
			"xor": "XOR",
			"latchr_comp": "DR_LATCH",
			"latchnq_comp": "D_LATCH_A",
			"latch_comp": "D_LATCH_A2",
			"latch": "D_LATCH_B",

		}
		replace_words(input_file, output_file, replacements)