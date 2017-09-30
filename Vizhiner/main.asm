;========= MACROSES =========
%include "linux_lib.mac"
;======= END MACROSES =======


%include "vizhiner.asm"


section .text
global _start

func exit, code
    
	mov [ code ], dword 5
	sys_call sys_exit, [ code ]

endfunc

_start:
    call_func helloworld

    call_func exit, 0

	ret ;debug ret for radare2
    
section .data
str key, "Enter key: "
