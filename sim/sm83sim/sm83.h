#pragma once

#include <stdint.h>

namespace dmg
{
	struct sm83_state
	{
		int dummy;
	};

	void sm83_sim(sm83_state *st);
}