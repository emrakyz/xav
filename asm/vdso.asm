SECTION .rodata align=8
auxv_path: db "/proc/self/auxv",0
sym_name:  db "__vdso_clock_gettime",0
SYM_LEN    equ 20

SECTION .data align=8
xav_vdso_cgt: dq xav_cgt_sys

SECTION .bss align=8
xav_vdso_done: resb 1

SECTION .text align=64

global xav_vdso_cgt
global xav_vdso_done
global xav_vdso_init

xav_cgt_sys:
    mov          eax, 228
    syscall
    ret


xav_vdso_init:
    mov          byte [rel xav_vdso_done], 1
    push         rbx
    push         rbp
    push         r12
    push         r13
    push         r14
    push         r15
    sub          rsp, 4104
    mov          eax, 2
    lea          rdi, [rel auxv_path]
    xor          esi, esi
    xor          edx, edx
    syscall
    test         eax, eax
    js           .out
    mov          r12d, eax
    xor          eax, eax
    mov          edi, r12d
    mov          rsi, rsp
    mov          edx, 4096
    syscall
    mov          r13, rax
    mov          eax, 3
    mov          edi, r12d
    syscall
    cmp          r13, 16
    jl           .out
    mov          rbx, rsp
    lea          r14, [rsp+r13-15]
.scan:
    cmp          rbx, r14
    jae          .out
    mov          rax, [rbx]
    test         rax, rax
    jz           .out
    cmp          rax, 33
    je           .base
    add          rbx, 16
    jmp          .scan
.base:
    mov          rbp, [rbx+8]
    test         rbp, rbp
    jz           .out
    cmp          dword [rbp], 0x464c457f
    jne          .out
    mov          r8, [rbp+0x20]
    movzx        r9d, word [rbp+0x36]
    movzx        r10d, word [rbp+0x38]
    test         r10d, r10d
    jz           .out
    add          r8, rbp
    xor          r14, r14
    xor          r15, r15
    mov          r11, -1
.ph:
    mov          eax, [r8]
    cmp          eax, 1
    jne          .ph_dyn
    cmp          qword [r8+8], 0
    jne          .ph_next
    mov          r11, [r8+16]
    jmp          .ph_next
.ph_dyn:
    cmp          eax, 2
    jne          .ph_next
    mov          r15, [r8+16]
.ph_next:
    add          r8, r9
    dec          r10d
    jnz          .ph
    cmp          r11, -1
    je           .out
    test         r15, r15
    jz           .out
    mov          r14, rbp
    sub          r14, r11
    add          r15, r14
    xor          r8, r8
    xor          r9, r9
    xor          r10, r10
.dyn:
    mov          rax, [r15]
    test         rax, rax
    jz           .dyn_end
    mov          rcx, [r15+8]
    cmp          rax, 4
    jne          .dyn_str
    mov          r8, rcx
    jmp          .dyn_next
.dyn_str:
    cmp          rax, 5
    jne          .dyn_sym
    mov          r9, rcx
    jmp          .dyn_next
.dyn_sym:
    cmp          rax, 6
    jne          .dyn_next
    mov          r10, rcx
.dyn_next:
    add          r15, 16
    jmp          .dyn
.dyn_end:
    test         r8, r8
    jz           .out
    test         r9, r9
    jz           .out
    test         r10, r10
    jz           .out
    cmp          r8, rbp
    jae          .h_ok
    add          r8, r14
.h_ok:
    cmp          r9, rbp
    jae          .s_ok
    add          r9, r14
.s_ok:
    cmp          r10, rbp
    jae          .y_ok
    add          r10, r14
.y_ok:
    mov          r12d, [r8+4]
    test         r12d, r12d
    jz           .out
.sym:
    mov          eax, [r10]
    test         eax, eax
    jz           .sym_next
    lea          rsi, [r9+rax]
    lea          rdi, [rel sym_name]
    mov          ecx, SYM_LEN+1
.cmp:
    mov          al, [rsi]
    cmp          al, [rdi]
    jne          .sym_next
    test         al, al
    jz           .hit
    inc          rsi
    inc          rdi
    dec          ecx
    jnz          .cmp
.sym_next:
    add          r10, 24
    dec          r12d
    jnz          .sym
    jmp          .out
.hit:
    mov          rax, [r10+8]
    test         rax, rax
    jz           .out
    add          rax, r14
    mov          [rel xav_vdso_cgt], rax
.out:
    add          rsp, 4104
    pop          r15
    pop          r14
    pop          r13
    pop          r12
    pop          rbp
    pop          rbx
    ret
