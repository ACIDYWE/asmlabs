global _start
section .text

_start:
    mov eax, 11
    push 0x68732f
    push 0x6e69622f
    mov ebx, esp
    xor ecx, ecx
    xor edx, edx
    int 80h
    
