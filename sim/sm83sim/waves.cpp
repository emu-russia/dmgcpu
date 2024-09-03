// Signal waveform tracer. Outputs waves in text format.
#include "sm83.h"
#include <stddef.h>
#include <vector>
#include <string>

namespace dmg
{
	enum signal_type
	{
		single_bit,			// int *
		byte_vector_value,		// uint8_t *
		group_separator,
	};

	struct signal_binding
	{
		signal_type type;
		const char* name;
		size_t offset;
	};

	static signal_binding sm83_signals[] = {

		{ group_separator, "Clocks", 0 },
		{ single_bit, "CLK", offsetof(sm83_state, CLK) },
		{ single_bit, "CLK1", offsetof(sm83_state, CLK1) },
		{ single_bit, "CLK2", offsetof(sm83_state, CLK2) },
		{ single_bit, "CLK3", offsetof(sm83_state, CLK3) },
		{ single_bit, "CLK4", offsetof(sm83_state, CLK4) },
		{ single_bit, "CLK5", offsetof(sm83_state, CLK5) },
		{ single_bit, "CLK6", offsetof(sm83_state, CLK6) },
		{ single_bit, "CLK7", offsetof(sm83_state, CLK7) },
		{ single_bit, "CLK8", offsetof(sm83_state, CLK8) },
		{ single_bit, "CLK9", offsetof(sm83_state, CLK9) },

	};
	static size_t sm83_signals_count = sizeof(sm83_signals) / sizeof(signal_binding);

	static std::vector<sm83_state> trace{};

	void sm83_trace(sm83_state* st)
	{
		trace.push_back(*st);
	}

	void sm83_clear_trace()
	{
		trace.clear();
	}

	void sm83_dump_trace(char* buffer, size_t size)
	{
		std::string text = "";

		// Determine the maximum length of the signal/group name
		size_t maxlen = 0;
		for (size_t n = 0; n < sm83_signals_count; n++) {

			size_t len = strlen(sm83_signals[n].name);
			if (len > maxlen) {
				maxlen = len;
			}
		}

		// Output signal log
		for (size_t n = 0; n < sm83_signals_count; n++) {

			// Group/signal name
			size_t len = strlen(sm83_signals[n].name);
			text += sm83_signals[n].name;
			for (size_t spaces = len; spaces < maxlen; spaces++) {
				text += " ";
			}
			if (sm83_signals[n].type != group_separator) {
				text += ": ";
			}

			// Values
			bool prev_vector_saved = false;
			uint8_t prev_vector_value = 0;
			for (auto it = trace.begin(); it != trace.end(); ++it) {

				sm83_state st = *it;

				switch (sm83_signals[n].type) {

					case single_bit: {
						int* ptr = (int*)((uint8_t*)&st + sm83_signals[n].offset);
						if (*ptr) {
							text += "‾‾";
						}
						else {
							text += "__";
						}
						break;
					}

					case byte_vector_value: {
						uint8_t* vec_ptr = (uint8_t*)((uint8_t*)&st + sm83_signals[n].offset);

						if (prev_vector_value != *vec_ptr || !prev_vector_saved) {

							char tmp[0x10];
							sprintf(tmp, "%02x", *vec_ptr);
							text += tmp;
						}
						else {
							text += "--";
						}

						prev_vector_value = *vec_ptr;
						if (!prev_vector_saved) {
							prev_vector_saved = true;
						}
						break;
					}
				}
			}

			text += "\r\n";
		}

		memset(buffer, 0, size);
		strncpy(buffer, text.c_str(), size);
	}
}