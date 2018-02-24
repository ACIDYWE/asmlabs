UNAME := $(shell uname)

ifeq ($(UNAME),Darwin)
	TYPE = macho64
else
	TYPE = elf32
endif

OBJ=execve.o
INC=macroses
MACROSES=$(INC)/funcs.mac $(INC)/consts.mac $(INC)/linux_syscalls.mac $(INC)/darwin_syscalls.mac

all: execve.asm $(MACROSES)
	nasm -f $(TYPE) -o $(OBJ) execve.asm -I$(INC)/
	ld -melf_i386  $(OBJ) -o execve

list: execve.asm $(MACROSES)
	nasm -e execve.asm -I$(INC)/

clean:
	rm -rf *.o execve
