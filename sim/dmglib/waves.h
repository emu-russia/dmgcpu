// Signal waveform tracer. Outputs waves in text format.
#pragma once

#include <stddef.h>

namespace dmglib
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

	void waves_bind(signal_binding* siglist, size_t sigcount);
	void waves_trace(void* st, size_t st_size);
	void waves_clear_trace();
	void waves_dump_trace(char* buffer, size_t size);
}