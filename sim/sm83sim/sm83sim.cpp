// Optional entry point. sm83sim can be a static library.

#include "sm83.h"
#include <stdio.h>
#include <string>

// External clock generator (SoC)
void clkgen(int CLK, dmg::sm83_state* st)
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
	dmg::sm83_state st{};
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
		st.CLK5 = Not(counter_bit(0));

		for (int i = 0; i < 8; i++) {
			st.IR[i] = counter_bit(i + 5);
			if (i < 6) {
				st.nIR[i] = Not(counter_bit(i + 5));
			}
		}
		st.SeqOut_2 = Not(counter_bit(1));

		st.a[1] = counter_bit(14); 	// @gekkio: intr_dispatch
		st.a[0] = Not(st.a[1]);			// @gekkio: ~intr_dispatch
		st.a[3] = counter_bit(13); 	// @gekkio: cb_mode
		st.a[2] = Not(st.a[3]);			// @gekkio: ~cb_mode
		st.a[5] = counter_bit(12);		// IR7
		st.a[4] = Not(st.a[5]);
		st.a[7] = counter_bit(11);		// IR6
		st.a[6] = Not(st.a[7]);
		st.a[9] = counter_bit(10);		// IR5
		st.a[8] = Not(st.a[9]);
		st.a[11] = counter_bit(9);		// IR4
		st.a[10] = Not(st.a[11]);
		st.a[13] = counter_bit(8);		// IR3
		st.a[12] = Not(st.a[13]);
		st.a[15] = counter_bit(7);		// IR2
		st.a[14] = Not(st.a[15]);
		st.a[17] = counter_bit(6);		// IR1
		st.a[16] = Not(st.a[17]);
		st.a[19] = counter_bit(5);		// IR0
		st.a[18] = Not(st.a[19]);
		st.a[20] = Not(counter_bit(4));		// @gekkio: ~state[2]
		st.a[21] = Not(st.a[20]);		// @gekkio: state[2]
		st.a[22] = Not(counter_bit(3));		// @gekkio: ~state[1]
		st.a[23] = Not(st.a[22]);		// @gekkio: state[1]
		st.a[24] = Not(counter_bit(2));		// @gekkio: ~state[0]
		st.a[25] = Not(st.a[24]);		// @gekkio: state[0]

		dmg::sm83_decoder1(&st);
		dmg::sm83_decoder2(&st);
		dmg::sm83_decoder3(&st);

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

	dmg::sm83_state st1{}, st2{};
	dmg::sm83_state* current_state, * prev_state;
	int CLK = 0;

	prev_state = &st1;
	current_state = &st2;

	size_t num_cycles = 32;

	for (int n = 0; n < num_cycles*2; n++) {

		clkgen(CLK, current_state);
		dmg::sm83_sim(prev_state, current_state);

		dmg::sm83_trace(current_state);

		dmg::sm83_state* tmp = current_state;
		current_state = prev_state;
		prev_state = tmp;
		CLK = Not(CLK);
	}

	size_t text_size = 1024 * 1024;
	char* text = new char[text_size];
	dmg::sm83_dump_trace(text, text_size);
	//printf(text);
	FILE* f = fopen("trace.log", "wt");
	fprintf(f, text);
	fclose(f);
	delete[] text;

	return 0;
}