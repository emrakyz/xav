SECTION .tpad exec

extern _start
extern __executable_start
extern __xav_tlen

global xav_start
xav_start:
    mov  r8, rdx
    mov  edi, __executable_start
    mov  esi, __xav_tlen
    mov  edx, 25
    mov  eax, 28
    syscall
    mov  rdx, r8
    jmp  _start
