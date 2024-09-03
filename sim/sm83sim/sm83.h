#pragma once

#include <stdint.h>
#include <stddef.h>

#include "decoder.h"
#include "logic.h"

namespace dmg
{
	struct sm83_state
	{
		int CLK;
		int CLK1, CLK2, CLK3, CLK4, CLK5, CLK6, CLK7, CLK8, CLK9;

		int a[26];
		int d[107];
		int w[41];
		int x[69];

		int ALU_to_Thingy;
		int bot_to_Thingy;
		int TTB1;
		int TTB2;
		int TTB3;
		int Thingy_to_bot;

		int IR[8];
		int nIR[6];
	};

	void sm83_decoder1(sm83_state* st);
	void sm83_decoder2(sm83_state* st);
	void sm83_decoder3(sm83_state* st);
	void sm83_thingy_sim(sm83_state* st);

	void sm83_trace(sm83_state* st);
	void sm83_clear_trace();
	void sm83_dump_trace(char* buffer, size_t size);

	void sm83_sim(sm83_state *st_old, sm83_state* st_now);
}