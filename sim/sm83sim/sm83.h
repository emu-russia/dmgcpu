#pragma once

#include <stdint.h>
#include <stddef.h>

#include "decoder.h"

namespace sm83
{
	struct state
	{
		int CLK;
		int CLK1, CLK2, CLK3, CLK4, CLK5, CLK6, CLK7, CLK8, CLK9;
		int nCLK4;

		int a[26];
		int d[107];
		int w[41];
		int x[69];

		int SeqOut_2;

		int ALU_to_Thingy;
		int bot_to_Thingy;
		int TTB1;
		int TTB2;
		int TTB3;
		int Thingy_to_bot;

		int IR[8];
		int nIR[6];
	};

	void decoder1(state* st);
	void decoder2(state* st);
	void decoder3(state* st);
	void thingy_sim(state* st);

	void sim(state *st_old, state* st_now);
}