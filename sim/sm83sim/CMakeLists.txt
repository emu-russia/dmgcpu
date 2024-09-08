cmake_minimum_required (VERSION 3.0)
project (sm83sim CXX)

add_definitions (-D_LINUX)

# Main application

set(CMAKE_BUILD_TYPE Release)

add_executable (sm83sim 
	alu.cpp 
	bcd.cpp
	datamux.cpp
	decoder.cpp
	idu.cpp
	irq.cpp
	regs.cpp
	seq.cpp
	sm83.cpp
	thingy.cpp
	sm83sim.cpp
	../dmglib/waves.cpp
	../dmglib/dmglib.cpp
)
