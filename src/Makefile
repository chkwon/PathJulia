# -*- Makefile -*-

#.PHONY: all test

PATHDIR = ../../pathlib
PATHLIB = $(PATHDIR)/lib

XLIBS = -lgfortran

CC    = gcc
OSX_CFLAGS = -I$(PATHDIR)/include -m64 -dynamiclib -shared -fPIC -install_name @rpath/libpath47julia.dylib
LINUX64_CFLAGS = -I$(PATHDIR)/include -m64 -shared -fPIC -Wl,-rpath,'libpath47julia.so'
LINUX43_CFLAGS = -I$(PATHDIR)/include -m43 -shared -fPIC -Wl,-rpath,'libpath47julia.so'


osx: pathjulia.c Standalone_Path.c
	$(CC) $(OSX_CFLAGS) -o libpath47julia.dylib $^         -L$(PATHLIB)/osx -lpath47 -lm
	mkdir -p ../lib/osx/
	mv libpath47julia.dylib ../lib/osx/

linux64: pathjulia.c Standalone_Path.c
	$(CC) $(LINUX64_CFLAGS) -o libpath47julia.so $^         -L$(PATHLIB)/linux64 -lpath47 -lm
	mkdir -p ../lib/linux64
	cp libpath47julia.so ../lib/linux64/

linux32: pathjulia.c Standalone_Path.c
	$(CC) $(LINUX32_CFLAGS) -o libpath47julia.so $^         -L$(PATHLIB)/linux32 -lpath47 -lm
	mkdir -p ../lib/linux32
	cp libpath47julia.so ../lib/linu32/
