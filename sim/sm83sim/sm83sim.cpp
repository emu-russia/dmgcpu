// Optional entry point. sm83sim can be a static library.

#include "sm83.h"
#include "../dmglib/dmglib.h"
#include "../dmglib/waves.h"
#include <stddef.h>
#include <stdio.h>
#include <string>

#ifdef _LINUX
#define _countof(a) (sizeof(a)/sizeof(*(a)))
#endif

static dmglib::signal_binding sm83_signals[] = {

	{ dmglib::group_separator, "Clocks", 0 },
	{ dmglib::single_bit, "CLK", offsetof(sm83::state, CLK) },
	{ dmglib::single_bit, "CLK1", offsetof(sm83::state, CLK1) },
	{ dmglib::single_bit, "CLK2", offsetof(sm83::state, CLK2) },
	{ dmglib::single_bit, "CLK3", offsetof(sm83::state, CLK3) },
	{ dmglib::single_bit, "CLK4", offsetof(sm83::state, CLK4) },
	{ dmglib::single_bit, "CLK5", offsetof(sm83::state, CLK5) },
	{ dmglib::single_bit, "CLK6", offsetof(sm83::state, CLK6) },
	{ dmglib::single_bit, "CLK7", offsetof(sm83::state, CLK7) },
	{ dmglib::single_bit, "CLK8", offsetof(sm83::state, CLK8) },
	{ dmglib::single_bit, "CLK9", offsetof(sm83::state, CLK9) },

};

// External clock generator (SoC)
void clkgen(int CLK, sm83::state* st)
{
	// TBD.
	st->CLK = CLK;
}

std::string vec2str(int* vec, int num_elem)
{
	std::string text = "";
	for (int i = num_elem-1; i >= 0; i--) {
		text += std::to_string(vec[i]);
	}
	return text;
}

void org_to_gekkio (int *d, int *w, int* x, int* stage1, int* stage2, int* stage3)
{
	int i;
	// @gekkio: lsb first

	// Also: org order: w[20] -> w[18] -> w[19]    (w20 is crooked in topo)
	// gekkio order: org w20 -> org w18 -> org w19

	for (i=0; i<=47; i=i+1) {
		stage1[103-i] = d[i];
	}
	for (i=50; i<106; i=i+1) {
		stage1[(103+2)-i] = d[i]; 	// +2 skipped
	}

	for (i=0; i<=6; i=i+1) {
		stage2[37-i] = w[i];
	}
	for (i=8; i<18; i=i+1) {
		stage2[(37+1)-i] = w[i]; 	// +1 skipped
	}
	// 18-20
	stage2[(37+1) - 18] = w[20];
	stage2[(37+1) - 19] = w[18];
	stage2[(37+1) - 20] = w[19];
	for (i=21; i<39; i=i+1) {
		stage2[(37+1)-i] = w[i]; 	// +1 skipped
	}

	for (i=0; i<=68; i=i+1) {
		stage3[68-i] = x[i];
	}
}

void sm83_verify_decoder()
{
	sm83::state st{};
	int stage1[104]{};
	int stage2[38]{};
	int stage3[69]{};

	FILE* f = fopen("decoder_sim.csv", "w");
	fprintf(f, "intr_dispatch,cb_mode,ir_reg,state,writeback,data_lsb,stage1,stage2,stage3,outputs\n");

	for (int c = 0; c < 32768; c++) {

		#define counter_bit(n) ((c >> (n)) & 1)

		st.CLK2 = 1;
		st.CLK4 = 1;
		st.nCLK4 = 0;
		st.CLK5 = dmglib::Not(counter_bit(0));

		for (int i = 0; i < 8; i++) {
			st.IR[i] = counter_bit(i + 5);
			if (i < 6) {
				st.nIR[i] = dmglib::Not(counter_bit(i + 5));
			}
		}
		st.SeqOut_2 = dmglib::Not(counter_bit(1));

		st.a[1] = counter_bit(14); 	// @gekkio: intr_dispatch
		st.a[0] = dmglib::Not(st.a[1]);			// @gekkio: ~intr_dispatch
		st.a[3] = counter_bit(13); 	// @gekkio: cb_mode
		st.a[2] = dmglib::Not(st.a[3]);			// @gekkio: ~cb_mode
		st.a[5] = counter_bit(12);		// IR7
		st.a[4] = dmglib::Not(st.a[5]);
		st.a[7] = counter_bit(11);		// IR6
		st.a[6] = dmglib::Not(st.a[7]);
		st.a[9] = counter_bit(10);		// IR5
		st.a[8] = dmglib::Not(st.a[9]);
		st.a[11] = counter_bit(9);		// IR4
		st.a[10] = dmglib::Not(st.a[11]);
		st.a[13] = counter_bit(8);		// IR3
		st.a[12] = dmglib::Not(st.a[13]);
		st.a[15] = counter_bit(7);		// IR2
		st.a[14] = dmglib::Not(st.a[15]);
		st.a[17] = counter_bit(6);		// IR1
		st.a[16] = dmglib::Not(st.a[17]);
		st.a[19] = counter_bit(5);		// IR0
		st.a[18] = dmglib::Not(st.a[19]);
		st.a[20] = dmglib::Not(counter_bit(4));		// @gekkio: ~state[2]
		st.a[21] = dmglib::Not(st.a[20]);		// @gekkio: state[2]
		st.a[22] = dmglib::Not(counter_bit(3));		// @gekkio: ~state[1]
		st.a[23] = dmglib::Not(st.a[22]);		// @gekkio: state[1]
		st.a[24] = dmglib::Not(counter_bit(2));		// @gekkio: ~state[0]
		st.a[25] = dmglib::Not(st.a[24]);		// @gekkio: state[0]

		sm83::decoder1(&st);
		sm83::decoder2(&st);
		sm83::decoder3(&st);

		int ir = (c >> 5) & 0xff;
		int state[3] = { counter_bit(2), counter_bit (3), counter_bit(4) };

		org_to_gekkio(st.d, st.w, st.x, stage1, stage2, stage3);

		fprintf(f, "%d,%d,0x%02x,%s,%d,%d,%s,%s,%s\n",
			counter_bit(14),	// intr_dispatch
			counter_bit(13),	// cb_mode
			ir,	// IR
			vec2str(state, _countof(state)).c_str(),	// {state2,state1,state0}
			counter_bit(0),		// writeback = ~CLK5
			counter_bit(1),		// data_lsb
			vec2str(stage1, _countof(stage1)).c_str(),
			vec2str(stage2, _countof(stage2)).c_str(),
			vec2str(stage3, _countof(stage3)).c_str() );
	}

	fclose(f);
}

int main (int argc, char **argv)
{
	printf ("Hello SM83 Sim!\n");

	sm83_verify_decoder();

	sm83::state st1{}, st2{};
	sm83::state* current_state, * prev_state;
	int CLK = 0;

	prev_state = &st1;
	current_state = &st2;

	size_t num_cycles = 32;

	dmglib::waves_bind(sm83_signals, _countof(sm83_signals));

	for (int n = 0; n < num_cycles*2; n++) {

		clkgen(CLK, current_state);
		sm83::sim(prev_state, current_state);

		dmglib::waves_trace(current_state, sizeof(sm83::state));

		sm83::state* tmp = current_state;
		current_state = prev_state;
		prev_state = tmp;
		CLK = dmglib::Not(CLK);
	}

	size_t text_size = 1024 * 1024;
	char* text = new char[text_size];
	dmglib::waves_dump_trace(text, text_size);
	//printf(text);
	FILE* f = fopen("trace.log", "wt");
	fprintf(f, text);
	fclose(f);
	delete[] text;
	dmglib::waves_clear_trace();

	return 0;
}