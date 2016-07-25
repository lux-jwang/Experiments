# Makefile for SEAL examples
LIB_DIR=./bin
INCLUDE_DIR=./SEAL
CXXFLAGS=-Wall -Wno-unused-function -std=c++11 -O3 -I$(INCLUDE_DIR)
SRCS=main.cpp spp.cpp topn.cpp nbmutils.cpp
OBJS=$(SRCS:.cpp=.o)
SEALRUN=$.tdsc.exe

.PHONY: all clean

all: $(SEALRUN)

$(SEALRUN): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) -L$(LIB_DIR) -lseal -o $(SEALRUN)

clean:
	-rm -f $(OBJS) $(SEALRUN)