UNAME := $(shell uname)

ifeq ($(UNAME),Darwin)
	TYPE = macho64
else
	TYPE = elf64
endif

OBJ=main.o
INC=macroses
MACROSES=$(INC)/funcs.mac $(INC)/consts.mac $(INC)/linux_syscalls.mac $(INC)/darwin_syscalls.mac

all: main.asm $(MACROSES)
	nasm -f $(TYPE) -o $(OBJ) main.asm -I$(INC)/
	ld $(OBJ) -o main

list: main.asm $(MACROSES)
	nasm -e main.asm -I$(INC)/

clean:
	rm -rf *.o main
