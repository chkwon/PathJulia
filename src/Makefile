# -*- Makefile -*-

#.PHONY: all test

PATHDIR = ../../pathlib
PATHLIB = $(PATHDIR)/lib

XLIBS = -lgfortran

CC    = gcc
# OSX_CFLAGS = -I$(PATHDIR)/include -m64 -dynamiclib -shared -fPIC -install_name @rpath/libpath47julia.dylib
OSX_CFLAGS = -I$(PATHDIR)/include -m64 -dynamiclib -shared -fPIC
LINUX64_CFLAGS = -I$(PATHDIR)/include -m64 -shared -fPIC -Wl,-soname,libpath47julia.so
LINUX32_CFLAGS = -I$(PATHDIR)/include -m32 -shared -fPIC -Wl,-soname,libpath47julia.so
WIN64_CFLAGS = -m64 -DFNAME_LCASE_NODECOR -I$(PATHDIR)/include -DUSE_OUTPUT_INTERFACE -shared 
WIN32_CFLAGS = -m32 -DFNAME_LCASE_NODECOR -I$(PATHDIR)/include -DUSE_OUTPUT_INTERFACE -shared 

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
	mv libpath47julia.so ../lib/linux32/

win64: pathjulia.c Standalone_Path.c
	$(CC) $(WIN64_CFLAGS) -o libpath47julia.dll $^ $(PATHLIB)/win64/path47.lib -lm
	powershell -Command "New-Item -ItemType Directory -Force -Path ..\lib\win64"
	powershell -Command "Copy-Item -Path libpath47julia.dll -Destination ..\lib\win64 -Force"

win32: pathjulia.c Standalone_Path.c
	$(CC) $(WIN32_CFLAGS) -o libpath47julia.dll $^ $(PATHLIB)/win32/path47.lib -lm
	powershell -Command "New-Item -ItemType Directory -Force -Path ..\lib\win32"
	powershell -Command "Copy-Item -Path libpath47julia.dll -Destination ..\lib\win32 -Force"
	
test: test_pathjulia.c
	$(CC) -I$(PATHDIR)/include -Wl,-rpath,../lib/linux64/ -m64 -o test_pathjulia $^ -L../lib/linux64/ -lpath47julia -lm

test_win64: test_pathjulia.c
	$(CC) -I$(PATHDIR)/include -DFNAME_LCASE_NODECOR -DUSE_OUTPUT_INTERFACE -m64 -o test_pathjulia_win64.exe $^ ../lib/win64/libpath47julia.dll -lm
	test_pathjulia_win64.exe
	
test_win32: test_pathjulia.c
	$(CC) -I$(PATHDIR)/include -DFNAME_LCASE_NODECOR -DUSE_OUTPUT_INTERFACE -m32 -o test_pathjulia_win32.exe $^ ../lib/win32/libpath47julia.dll -lm
	test_pathjulia_win32.exe	