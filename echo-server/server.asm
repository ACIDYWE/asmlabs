;========= MACROSES =========
%include "linux_lib.mac"
;======= END MACROSES =======

global _start

%define AF_INET      2
%define LOCALHOST    0
%define SOCK_STREAM  1
%define IP_PROT      2
%define SOL_SOCKET   1
%define SO_REUSEADDR 2


struc sockaddr_in
    .sin_family resw 1
    .sin_port resw 1
    .sin_addr resd 1
    .sin_zero resb 8
endstruc

section .bss
  server_fd resd 1
  client_fd resd 1
  optval    resd 1
  BUF       resb 256
  N         resd 1

section .data
_socket_fail_msg db "Could not create socket", 10
.len equ ($ - _socket_fail_msg)

_setsockopt_fail_msg db "Could not set REUSE_ADDR option", 10
.len equ ($ - _setsockopt_fail_msg)

_bind_fail_msg db "Could not bind socket", 10
.len equ ($ - _bind_fail_msg)

_listen_fail_msg db "Could not listen on socket", 10
.len equ ($ - _listen_fail_msg)

_accept_fail_msg db "Could not establish new connection", 10
.len equ ($ - _accept_fail_msg)

_new_conn db "Incoming connection!", 10
.len equ ($ - _new_conn)

pop_sa istruc sockaddr_in
    at sockaddr_in.sin_family, dw AF_INET
    at sockaddr_in.sin_port, dw 0x697a         ; port 31337
    at sockaddr_in.sin_addr, dd LOCALHOST
    at sockaddr_in.sin_zero, dq 0
iend

.len  equ $ - pop_sa


section .text

_start:
  call _socket

  call _setsockopt

  call _bind

  call _listen

  .loop:
    call _accept
    
    mov eax, 2
    xor ebx, ebx
    int 80h

    cmp eax, 0
    jz _handle_client


    jmp .loop

  xor edi, edi
  call _exit

_handle_client:
  .inner_loop:

    call _read

    call _echo

    mov eax, [N]
    cmp eax, 0
    jg .inner_loop

  call _close_client
  xor edi, edi
  call _exit


_read:
  mov eax, 3
  mov ebx, [client_fd]
  mov ecx, BUF
  mov edx, 256
  int 80h

  mov [N], eax

  ret

_echo:
  mov eax, 4
  mov ebx, [client_fd]
  mov ecx, BUF
  mov edx, [N]
  int 80h
  
  ret

_close_client:
  mov eax, 6
  mov ebx, [client_fd]

  ret

_socket:
  push ebp
  mov ebp, esp

  push 6
  push 1
  push 2

  mov  eax, 102                 ; sys_socketcall
  mov  ebx, 1                   ; invoke the socket function 
  mov  ecx, esp
  int  0x80
    
  cmp eax, 0
  jl _socket_fail

  mov [server_fd], eax

  leave
  ret

_setsockopt:
  push ebp
  mov ebp, esp

  push 4
  push optval
  push 2
  push 1
  push dword [server_fd]
  
  mov eax, 102
  mov ebx, 14
  mov ecx, esp
  int 80h

  cmp eax, 0
  jl _setsockopt_fail

  leave
  ret

_bind:
  push ebp
  mov ebp, esp
    
  push 16
  push dword pop_sa
  push dword [server_fd]

  mov eax, 102
  mov ebx, 2
  mov ecx, esp
  int 80h

  cmp eax, 0
  jl _bind_fail

  leave
  ret

_listen:
  push ebp
  mov ebp, esp

  push  byte 5
  push  dword [server_fd]

  mov  eax, 102                 ; sys_socketcall
  mov  ebx, 4                   ; listen()
  mov  ecx, esp                 ; arguments on the stack
  int  0x80

  cmp eax, 0
  jl _listen_fail
  
  leave
  ret

_accept:
  push ebp
  mov ebp, esp

  push  0
  push  0
  push  dword [server_fd]

; accept syscall
  mov  eax, 102                 ; sys_socketcall
  mov  ebx, 5                   ; accept()
  mov  ecx, esp                 ; arguments on the stack
  int  0x80

  cmp eax, 0
  jl _accept_fail

  mov [client_fd], eax

  call _new_connection

  leave
  ret

_new_connection:
  mov eax, 4
  mov ebx, stdout
  mov ecx, _new_conn
  mov edx, _new_conn.len
  int 80h

  ret

_socket_fail:
  mov esi, _socket_fail_msg
  mov edx, _socket_fail_msg.len
  call _fail

_setsockopt_fail:
  mov esi, _setsockopt_fail_msg
  mov edx, _setsockopt_fail_msg.len
  call _fail

_bind_fail:
  mov esi, _bind_fail_msg
  mov edx, _bind_fail_msg.len
  call _fail

_listen_fail:
  mov esi, _listen_fail_msg
  mov edx, _listen_fail_msg.len
  call _fail

_accept_fail:
  mov esi, _accept_fail_msg
  mov edx, _accept_fail_msg.len
  call _fail

_fail:
  mov eax, 4
  mov ebx, stdout
  mov ecx, esi
  int 80h
  
  mov edi, 1
  call _exit

_exit:
    mov eax, 1
    mov ebx, edi
    int 80h
