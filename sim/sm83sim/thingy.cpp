#include "sm83.h"

namespace dmg
{
	void sm83_thingy_sim(sm83_state *st)
	{
		int Temp_Z = 0;// TBD.

		int t1 = ~(st->w[8] & st->ALU_to_Thingy & ~Temp_Z);
		int t2 = ~(st->w[8] & ~st->ALU_to_Thingy & Temp_Z);
		st->TTB1 = ~(t1 & t2);
		st->TTB2 = ~(~st->w[35] & t2);
		st->TTB3 = ~(~st->w[31] & t1);
		st->Thingy_to_bot = st->bot_to_Thingy & s2_wr;
	}
}