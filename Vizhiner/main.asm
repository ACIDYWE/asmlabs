;========= MACROSES =========
%include "macroses/libmacro.mac"
%include "macroses/darwin_syscalls.mac"
;======= END MACROSES =======


%include "vizhiner.asm"


section .text
global start

func exit
    sys_call sys_exit, 0
endfunc


start
    call_func helloworld

    call_func exit

    
section .data
str key, "Enter key: "
