%include "dav1d_x86inc.asm"

extern __imp_WaitOnAddress
extern __imp_WakeByAddressSingle

SECTION .text

INIT_XMM sse2

cglobal sem_acq, 1, 7
    push   rbx
    sub    rsp, 48
    mov    rbx, rcx
.spin:
    mov    eax, [rbx]
    test   eax, eax
    jz     .slow
    lea    edx, [rax-1]
    lock cmpxchg [rbx], edx
    jnz    .spin
    add    rsp, 48
    pop    rbx
    RET
.slow:
    lock inc dword [rbx+4]
    mov    eax, [rbx]
    test   eax, eax
    jnz    .unwait
    mov    dword [rsp+32], 0
    mov    rcx, rbx
    lea    rdx, [rsp+32]
    mov    r2d, 4
    mov    r3d, -1
    call   [rel __imp_WaitOnAddress]
.unwait:
    lock dec dword [rbx+4]
    jmp    .spin

cglobal sem_release, 1, 7
    sub    rsp, 40
    lock inc dword [rcx]
    mov    eax, [rcx+4]
    test   eax, eax
    jz     .done
    call   [rel __imp_WakeByAddressSingle]
.done:
    add    rsp, 40
    RET
