// Optional entry point. sm83sim can be a static library.

#include "sm83.h"
#include <stdio.h>

// External clock generator (SoC)
void clkgen(int CLK, dmg::sm83_state* st)
{
	// TBD.
	st->CLK = CLK;
}

int main (int argc, char **argv)
{
	printf ("Hello SM83 Sim!\n");

	dmg::sm83_state st1{}, st2{};
	dmg::sm83_state* current_state, * prev_state;
	int CLK = 0;

	prev_state = &st1;
	current_state = &st2;

	size_t num_cycles = 32;

	for (int n = 0; n < num_cycles*2; n++) {

		clkgen(CLK, current_state);
		dmg::sm83_sim(prev_state, current_state);

		dmg::sm83_trace(current_state);

		dmg::sm83_state* tmp = current_state;
		current_state = prev_state;
		prev_state = tmp;
		CLK ^= 1;
	}

	size_t text_size = 1024 * 1024;
	char* text = new char[text_size];
	dmg::sm83_dump_trace(text, text_size);
	//printf(text);
	FILE* f = fopen("trace.log", "wt");
	fprintf(f, text);
	fclose(f);
	delete[] text;

	return 0;
}