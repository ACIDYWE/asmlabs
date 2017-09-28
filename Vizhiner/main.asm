;========= MACROSES =========
%include "macroses/func.mac"
%include "macroses/consts.mac"
%include "macroses/darwin_syscalls.mac"
;======= END MACROSES =======


%include "vizhiner.asm"


section .text
global start

func exit
    sys_call sys_exit, 0
endfunc


func start
    call helloworld

    call exit
endfunc
    
section .data
str key, "Enter key: "
