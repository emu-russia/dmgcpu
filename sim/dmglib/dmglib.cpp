#include "dmglib.h"

namespace dmglib
{
	int Not(int a)
	{
		return ~a & 1;
	}

	int Nor(int a, int b)
	{
		return ~(a | b) & 1;
	}

	int Nand(int a, int b)
	{
		return ~(a & b) & 1;
	}

	int And(int a, int b)
	{
		return (a & b) & 1;
	}

	int Nand3(int a0, int a1, int a2)
	{
		return ~(a0 & a1 & a2) & 1;
	}
}