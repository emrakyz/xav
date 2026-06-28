%include "dav1d_x86inc.asm"

SECTION .text

INIT_XMM sse2
cglobal sem_acq, 1, 8
.spin:
    mov    eax, [r0]
    test   eax, eax
    jz     .slow
    lea    edx, [rax-1]
    lock cmpxchg [r0], edx
    jnz    .spin
    RET
.slow:
    lock inc dword [r0+4]
    mov    eax, [r0]
    test   eax, eax
    jnz    .unwait
    mov    eax, 202
    mov    esi, 128
    xor    edx, edx
    xor    r7d, r7d
    syscall
.unwait:
    lock dec dword [r0+4]
    jmp    .spin

cglobal sem_release, 1, 1
    lock inc dword [r0]
    mov    eax, [r0+4]
    test   eax, eax
    jz     .done
    mov    eax, 202
    mov    esi, 129
    mov    edx, 1
    syscall
.done:
    RET
