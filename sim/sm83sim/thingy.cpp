#include "sm83.h"
#include "../dmglib/dmglib.h"

namespace sm83
{
	void thingy_sim(state *st)
	{
		int Temp_Z = 0;// TBD.

		int t1 = dmglib::Nand3 (st->w[8], st->ALU_to_Thingy, dmglib::Not(Temp_Z));
		int t2 = dmglib::Nand3 (st->w[8], dmglib::Not(st->ALU_to_Thingy), Temp_Z);
		st->TTB1 = dmglib::Nand (t1, t2);
		st->TTB2 = dmglib::Nand (dmglib::Not(st->w[35]), t2);
		st->TTB3 = dmglib::Nand (dmglib::Not(st->w[31]), t1);
		st->Thingy_to_bot = dmglib::And (st->bot_to_Thingy, s2_wr);
	}
}