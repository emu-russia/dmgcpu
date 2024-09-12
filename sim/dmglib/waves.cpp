// Signal waveform tracer. Outputs waves in text format.
#include "waves.h"
#include <vector>
#include <string>
#include <string.h>

namespace dmglib
{
	static signal_binding* signals;
	static size_t signals_count = 0;

	static std::vector<uint8_t*> trace{};

	void waves_bind(signal_binding *siglist, size_t sigcount)
	{
		signals = siglist;
		signals_count = sigcount;
	}

	void waves_trace(void* st, size_t st_size)
	{
		uint8_t* saved_st = new uint8_t[st_size];
		memcpy(saved_st, st, st_size);
		trace.push_back(saved_st);
	}

	void waves_clear_trace()
	{
		while (!trace.empty()) {
			uint8_t* saved_st = trace.back();
			delete[] saved_st;
			trace.pop_back();
		}
	}

	void waves_dump_trace(char* buffer, size_t size)
	{
		std::string text = "";

		// Determine the maximum length of the signal/group name
		size_t maxlen = 0;
		for (size_t n = 0; n < signals_count; n++) {

			size_t len = strlen(signals[n].name);
			if (len > maxlen) {
				maxlen = len;
			}
		}

		// Output signal log
		for (size_t n = 0; n < signals_count; n++) {

			// Group/signal name
			size_t len = strlen(signals[n].name);
			text += signals[n].name;
			for (size_t spaces = len; spaces < maxlen; spaces++) {
				text += " ";
			}
			if (signals[n].type != group_separator) {
				text += ": ";
			}

			// Values
			bool prev_vector_saved = false;
			uint8_t prev_vector_value = 0;
			for (auto it = trace.begin(); it != trace.end(); ++it) {

				uint8_t * st = *it;

				switch (signals[n].type) {

					case single_bit: {
						int* ptr = (int*)(st + signals[n].offset);
						switch (*ptr) {
							case -1:
								text += "--";		// z
								break;
							case 0:
								text += "__";		// 0
								break;
							case 1:
								text += "‾‾";		// 1
								break;
							default:
								text += "xx";		// x
								break;
						}
						break;
					}

					case byte_vector_value: {
						uint8_t* vec_ptr = (uint8_t*)(st + signals[n].offset);

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