;========= MACROSES =========
%include "linux_lib.mac"
;======= END MACROSES =======

global _start

%define AF_INET      2
%define LOCALHOST    0
%define SOCK_STREAM  1
%define IP_PROT      0
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

    .inner_loop:

      call _read

      call _echo

      mov rax, [N]
      cmp rax, 0
      jg .inner_loop

    call _close_client
    jmp .loop

  xor rdi, rdi
  call _exit

_read:
  sys_call sys_read, [client_fd], BUF, 256

  mov [N], eax

  ret

_echo:
  sys_call sys_write, [client_fd], BUF, [N]

  ret

_close_client:
  sys_call sys_close, [client_fd]

  ret

_socket:
  sys_call sys_socket, AF_INET, SOCK_STREAM, IP_PROT

  cmp rax, 0
  jl _socket_fail

  mov [server_fd], eax

  ret

_setsockopt:
  mov dword [optval], 1
  sys_call sys_setsockopt, [server_fd], SOL_SOCKET, SO_REUSEADDR, optval, 4

  cmp rax, 0
  jl _setsockopt_fail

  ret

_bind:
  sys_call sys_bind, [server_fd], pop_sa, pop_sa.len

  cmp rax, 0
  jl _bind_fail

  ret

_listen:
  sys_call sys_listen, [server_fd], 5

  cmp rax, 0
  jl _listen_fail

  ret

_accept:
  sys_call sys_accept, [server_fd], 0, 0

  cmp rax, 0
  jl _accept_fail

  mov [client_fd], eax

  call _new_connection

  ret

_new_connection:
  sys_call sys_write, stdout, _new_conn, _new_conn.len

  ret

_socket_fail:
  mov rsi, _socket_fail_msg
  mov rdx, _socket_fail_msg.len
  call _fail

_setsockopt_fail:
  mov rsi, _setsockopt_fail_msg
  mov rdx, _setsockopt_fail_msg.len
  call _fail

_bind_fail:
  mov rsi, _bind_fail_msg
  mov rdx, _bind_fail_msg.len
  call _fail

_listen_fail:
  mov rsi, _listen_fail_msg
  mov rdx, _listen_fail_msg.len
  call _fail

_accept_fail:
  mov rsi, _accept_fail_msg
  mov rdx, _accept_fail_msg.len
  call _fail

_fail:
  sys_call sys_write, stdout, rsi, rdx
  mov rdi, 1
  call _exit

_exit:
  sys_call sys_exit, rdi
