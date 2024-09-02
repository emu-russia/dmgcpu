// Optional entry point. sm83sim can be a static library.

#include "sm83.h"
#include <stdio.h>

// External clock generator (SoC)
void clkgen(dmg::sm83_state* st)
{
	// TBD.
}

int main (int argc, char **argv)
{
	printf ("Hello SM83 Sim!\n");

	dmg::sm83_state st{};
	int CLK = 0;

	for (int n = 0; n < 1000; n++) {

		clkgen(&st);
		dmg::sm83_sim(&st);

		CLK ^= 1;
	}

	return 0;
}