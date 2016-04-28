# -*- Makefile -*-

.PHONY: all test

PATHDIR = ../../pathlib
PATHLIB = $(PATHDIR)/lib

# additional libs - we expect them to be required only for static builds
XLIBS = -lgfortran

CC    = gcc
OSX_CFLAGS = -I$(PATHDIR)/include -m64 -dynamiclib -shared -fPIC -install_name @rpath/libpath47julia.dylib
LINUX64_CFLAGS = -I$(PATHDIR)/include -m64 -dynamiclib -shared -fPIC -Wl,-rpath,'$$ORIGIN'


osx: pathjulia.c Standalone_Path.c
	$(CC) $(OSX_CFLAGS) -o libpath47julia.dylib $^         -L$(PATHLIB)/osx -lpath47 -lm
	mv libpath47julia.dylib ../lib/osx/

linux64: pathjulia.c Standalone_Path.c
	$(CC) $(LINUX64_CFLAGS) -o libpath47julia.so $^         -L$(PATHLIB)/linux64 -lpath47 -lm
	mv libpath47julia.so ../lib/linux64/
