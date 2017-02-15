# -*- Makefile -*-

#.PHONY: all test

PATHLIB_V = 4.7.03
PATHLIB_ZIP = https://github.com/ampl/pathlib/archive/$(PATHLIB_V).zip
PATHLIB_TAR = https://github.com/ampl/pathlib/archive/$(PATHLIB_V).tar.gz
PATHDIR = ./pathlib-$(PATHLIB_V)
PATHLIB = $(PATHDIR)/lib

XLIBS = -lgfortran

CC    = gcc
CCwin32 = i686-w64-mingw32-gcc
JULIA32 = C:/julia32/bin/julia

OSX_CFLAGS = -I$(PATHDIR)/include -m64 -dynamiclib -shared -fPIC
LINUX64_CFLAGS = -I$(PATHDIR)/include -m64 -shared -fPIC -Wl,-soname,libpath47julia.so
LINUX32_CFLAGS = -I$(PATHDIR)/include -m32 -shared -fPIC -Wl,-soname,libpath47julia.so
WIN64_CFLAGS = -m64 -DFNAME_LCASE_NODECOR -I$(PATHDIR)/include -DUSE_OUTPUT_INTERFACE -shared
WIN32_CFLAGS = -m32 -DFNAME_LCASE_NODECOR -I$(PATHDIR)/include -DUSE_OUTPUT_INTERFACE -shared

osx: pathjulia.c
	if [ ! -d pathlib-$(PATHLIB_V) ]; \
	then \
		wget $(PATHLIB_ZIP); \
		unzip -o $(PATHLIB_V).zip; \
		rm -rf $(PATHLIB_V).zip*; \
	fi;
	$(CC) $(OSX_CFLAGS) -o libpath47julia.dylib $^ $(PATHLIB)/osx/libpath47.a -lm
	mkdir -p ../lib/osx/
	cp libpath47julia.dylib ../lib/osx/
	julia test.jl

linux64: pathjulia.c
	if [ ! -d pathlib-$(PATHLIB_V) ]; \
	then \
		wget $(PATHLIB_TAR); \
		tar -zxvf $(PATHLIB_V).tar.gz; \
		rm -rf $(PATHLIB_V).tar.gz*; \
	fi;
	$(CC) $(LINUX64_CFLAGS) -o libpath47julia.so $^ $(PATHLIB)/linux64/libpath47.a -lm
	mkdir -p ../lib/linux64
	cp libpath47julia.so ../lib/linux64/
	julia test.jl

linux32: pathjulia.c
	if [ ! -d pathlib-$(PATHLIB_V) ]; \
	then \
		wget $(PATHLIB_TAR); \
		tar -zxvf $(PATHLIB_V).tar.gz; \
		rm -rf $(PATHLIB_V).tar.gz*; \
	fi;
	$(CC) $(LINUX32_CFLAGS) -o libpath47julia.so $^ $(PATHLIB)/linux32/libpath47.a -lm
	mkdir -p ../lib/linux32
	cp libpath47julia.so ../lib/linux32/
	# julia test.jl

win: win64 win32

win64: pathjulia.c
	$(CC) $(WIN64_CFLAGS) -o libpath47julia.dll $^ $(PATHLIB)/win64/path47.lib -lm
	powershell -Command "New-Item -ItemType Directory -Force -Path ..\lib\win64"
	powershell -Command "Copy-Item -Path libpath47julia.dll -Destination ..\lib\win64 -Force"
	powershell -Command "Copy-Item -Path $(PATHLIB)/win64/path47.dll -Destination . -Force"
	# julia test.jl

win32: pathjulia.c
	$(CCwin32) $(WIN32_CFLAGS) -o libpath47julia.dll $^ $(PATHLIB)/win32/path47.lib -lm
	powershell -Command "New-Item -ItemType Directory -Force -Path ..\lib\win32"
	powershell -Command "Copy-Item -Path libpath47julia.dll -Destination ..\lib\win32 -Force"
	powershell -Command "Copy-Item -Path $(PATHLIB)/win32/path47.dll -Destination . -Force"
	# $(JULIA32) test.jl



test: test.jl
	julia test.jl

test32: test.jl
	$(JULIA32) test.jl




test_osx: test_pathjulia.c
	$(CC) -I$(PATHDIR)/include -Wl,-rpath,../lib/linux64/ -m64 -o test_pathjulia $^ -L../lib/linux64/ -lpath47julia -lm

test_win64: test_pathjulia.c
	$(CC) -I$(PATHDIR)/include -DFNAME_LCASE_NODECOR -DUSE_OUTPUT_INTERFACE -m64 -o test_pathjulia_win64.exe $^ ../lib/win64/libpath47julia.dll -lm
	test_pathjulia_win64.exe

test_win32: test_pathjulia.c
	$(CCwin32) -I$(PATHDIR)/include -DFNAME_LCASE_NODECOR -DUSE_OUTPUT_INTERFACE -m32 -o test_pathjulia_win32.exe $^ ../lib/win32/libpath47julia.dll -lm
	test_pathjulia_win32.exe
