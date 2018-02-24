UNAME := $(shell uname)

ifeq ($(UNAME),Darwin)
	TYPE = macho64
else
	TYPE = elf32
endif

OBJ=smc.o
INC=macroses
MACROSES=$(INC)/funcs.mac $(INC)/consts.mac $(INC)/linux_syscalls.mac $(INC)/darwin_syscalls.mac

all: smc.asm $(MACROSES)
	nasm -f $(TYPE) -o $(OBJ) smc.asm -I$(INC)/
	ld -melf_i386 -N $(OBJ) -o smc

list: smc.asm $(MACROSES)
	nasm -e smc.asm -I$(INC)/

clean:
	rm -rf *.o smc
