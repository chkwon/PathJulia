# -*- Makefile -*-

.PHONY: all test

PATHDIR = ../pathlib
PATHLIB = $(PATHDIR)/lib/osx

# additional libs - we expect them to be required only for static builds
XLIBS = -lgfortran

CC    = gcc
CFLAGS = -I$(PATHDIR)/include -m64

all: osx

osx: pathjulia.c Standalone_Path.c
	$(CC) $(CFLAGS) -dynamiclib -shared -fPIC -o libpath47julia.dylib $^         -L$(PATHLIB) -lpath47 -lm
	mv libpath47julia.dylib lib/osx/
