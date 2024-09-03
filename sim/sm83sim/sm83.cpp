#include "sm83.h"

namespace dmg
{
	void sm83_sim(sm83_state* st_old, sm83_state* st_now)
	{
		sm83_decoder1(st_now);
		sm83_decoder2(st_now);
		sm83_decoder3(st_now);

		sm83_thingy_sim(st_now);
	}
}