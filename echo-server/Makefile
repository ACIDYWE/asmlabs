UNAME := $(shell uname)

ifeq ($(UNAME),Darwin)
	TYPE = macho64
else
	TYPE = elf64
endif

OBJ=server.o
INC=macroses
MACROSES=$(INC)/funcs.mac $(INC)/consts.mac $(INC)/linux_syscalls.mac $(INC)/darwin_syscalls.mac

all: server.asm $(MACROSES)
	nasm -f $(TYPE) -o $(OBJ) server.asm -I$(INC)/
	ld $(OBJ) -o server

list: server.asm $(MACROSES)
	nasm -e server.asm -I$(INC)/

clean:
	rm -rf *.o server
