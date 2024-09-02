#pragma once

#include <stdint.h>

#include "decoder.h"

namespace dmg
{
	struct sm83_state
	{
		int CLK1, CLK2, CLK3, CLK4, CLK5, CLK6, CLK7, CLK8, CLK9;

		int d[107];
		int w[41];
		int x[69];

		int ALU_to_Thingy;
		int bot_to_Thingy;
		int TTB1;
		int TTB2;
		int TTB3;
		int Thingy_to_bot;
	};

	void sm83_thingy_sim(sm83_state* st);

	void sm83_sim(sm83_state *st);
}