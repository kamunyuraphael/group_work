# Makefile for Task 1 Assembly Compilation
ASM=nasm
ASM_FLAGS=-f elf64
LD=ld

TARGETS=hello data_size

all: $(TARGETS)

hello: hello.o
	$(LD) hello.o -o hello

hello.o: hello.asm
	$(ASM) $(ASM_FLAGS) hello.asm -o hello.o

data_size: data_size.o
	$(LD) data_size.o -o data_size

data_size.o: data_size.asm
	$(ASM) $(ASM_FLAGS) data_size.asm -o data_size.o

clean:
	rm -f *.o $(TARGETS)
