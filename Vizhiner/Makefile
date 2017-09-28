UNAME := $(shell uname)

ifeq ($(UNAME),Darwin)
	TYPE = macho64
else
	TYPE = elf64
endif

OBJ=main.o
DIR=macroses
MACROSES=$(DIR)/func.mac $(DIR)/consts.mac $(DIR)/linux_syscalls.mac $(DIR)/darwin_syscalls.mac

all: main.asm $(MACROSES)
	nasm -f $(TYPE) -o $(OBJ) main.asm
	ld $(OBJ) -o main

clean:
	rm -rf *.o main
