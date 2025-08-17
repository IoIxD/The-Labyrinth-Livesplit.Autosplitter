CC := gcc

all:
	@echo "specify either linux or windows"

linux:
	gcc -c -fPIC -I${JAVA_HOME}/include -I${JAVA_HOME}/include/linux mod.c
	gcc -nostdlib -lgcc mod.o -shared -o libLabyrinthModNative.so

windows:
	x86_64-w64-mingw32-gcc -c -fPIC -I${JAVA_HOME}/include -I${JAVA_HOME}/include/linux mod.c
	x86_64-w64-mingw32-gcc mod.o -shared -o LabyrinthModNative.dll