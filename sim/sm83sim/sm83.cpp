#include "sm83.h"

namespace sm83
{
	void sim(state* st_old, state* st_now)
	{
		decoder1(st_now);
		decoder2(st_now);
		decoder3(st_now);

		thingy_sim(st_now);
	}
}