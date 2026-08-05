SECTION .text

global xav_thread
xav_thread:
    sub  rsi, 16
    mov  [rsi], rcx
    mov  [rsi+8], r8
    mov  r10, rdx
    mov  r8, r9
    mov  eax, 56
    syscall
    test eax, eax
    jz   .run
    ret
.run:
    pop  rax
    pop  rdi
    call rax
    mov  eax, 60
    xor  edi, edi
    syscall
