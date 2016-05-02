# -*- Makefile -*-

#.PHONY: all test

PATHDIR = ../../pathlib
PATHLIB = $(PATHDIR)/lib

XLIBS = -lgfortran

CC    = gcc
# OSX_CFLAGS = -I$(PATHDIR)/include -m64 -dynamiclib -shared -fPIC -install_name @rpath/libpath47julia.dylib
OSX_CFLAGS = -I$(PATHDIR)/include -m64 -dynamiclib -shared -fPIC
LINUX64_CFLAGS = -I$(PATHDIR)/include -m64 -shared -fPIC
LINUX43_CFLAGS = -I$(PATHDIR)/include -m32 -shared -fPIC


osx: pathjulia.c Standalone_Path.c
	$(CC) $(OSX_CFLAGS) -o libpath47julia.dylib $^ $(PATHLIB)/osx/libpath47.a -lm
	mkdir -p ../lib/osx/
	mv libpath47julia.dylib ../lib/osx/

linux64: pathjulia.c Standalone_Path.c
	$(CC) $(LINUX64_CFLAGS) -o libpath47julia.so $^ $(PATHLIB)/linux64/libpath47.a -lm
	mkdir -p ../lib/linux64
	mv libpath47julia.so ../lib/linux64/

linux32: pathjulia.c Standalone_Path.c
	$(CC) $(LINUX32_CFLAGS) -o libpath47julia.so $^ $(PATHLIB)/linux32/libpath47.a -lm
	mkdir -p ../lib/linux32
	mv libpath47julia.so ../lib/linu32/

win64: pathjulia.c Standalone_Path.c
	$(CC) $(LINUX64_CFLAGS) -o libpath47julia.dll $^ $(PATHLIB)/win64/path47_static.lib $(PATHLIB)/win64/path47.dll -lm
	if not exist "../lib/win64" md "../lib/win64"
	move /Y libpath47julia.dll ../lib/win64/
