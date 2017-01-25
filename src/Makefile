# -*- Makefile -*-

#.PHONY: all test

PATHDIR = ../../pathlib
PATHLIB = $(PATHDIR)/lib

XLIBS = -lgfortran

CC    = gcc
CCwin32 = gcc32

OSX_CFLAGS = -I$(PATHDIR)/include -m64 -dynamiclib -shared -fPIC
LINUX64_CFLAGS = -I$(PATHDIR)/include -m64 -shared -fPIC -Wl,-soname,libpath47julia.so
LINUX32_CFLAGS = -I$(PATHDIR)/include -m32 -shared -fPIC -Wl,-soname,libpath47julia.so
WIN64_CFLAGS = -m64 -DFNAME_LCASE_NODECOR -I$(PATHDIR)/include -DUSE_OUTPUT_INTERFACE -shared
WIN32_CFLAGS = -m32 -DFNAME_LCASE_NODECOR -I$(PATHDIR)/include -DUSE_OUTPUT_INTERFACE -shared

osx: pathjulia.c
	$(CC) $(OSX_CFLAGS) -o libpath47julia.dylib $^ $(PATHLIB)/osx/libpath47.a -lm
	mkdir -p ../lib/osx/
	cp libpath47julia.dylib ../lib/osx/
	julia test.jl

linux64: pathjulia.c
	$(CC) $(LINUX64_CFLAGS) -o libpath47julia.so $^ $(PATHLIB)/linux64/libpath47.a -lm
	mkdir -p ../lib/linux64
	cp libpath47julia.so ../lib/linux64/
	julia test.jl

linux32: pathjulia.c
	$(CC) $(LINUX32_CFLAGS) -o libpath47julia.so $^ $(PATHLIB)/linux32/libpath47.a -lm
	mkdir -p ../lib/linux32
	cp libpath47julia.so ../lib/linux32/
	julia test.jl

win: win64 win32

win64: pathjulia.c
	$(CC) $(WIN64_CFLAGS) -o libpath47julia.dll $^ $(PATHLIB)/win64/path47.lib -lm
	powershell -Command "New-Item -ItemType Directory -Force -Path ..\lib\win64"
	powershell -Command "Copy-Item -Path libpath47julia.dll -Destination ..\lib\win64 -Force"
	julia test.jl

win32: pathjulia.c
	$(CCwin32) $(WIN32_CFLAGS) -o libpath47julia.dll $^ $(PATHLIB)/win32/path47.lib -lm
	powershell -Command "New-Item -ItemType Directory -Force -Path ..\lib\win32"
	powershell -Command "Copy-Item -Path libpath47julia.dll -Destination ..\lib\win32 -Force"
	julia test.jl
