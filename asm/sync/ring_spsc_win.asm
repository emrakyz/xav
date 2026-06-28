%include "dav1d_x86inc.asm"

%ifndef CAP
%define CAP 128
%endif
%define MASK (CAP-1)

extern __imp_WaitOnAddress
extern __imp_WakeByAddressSingle

SECTION .text

INIT_XMM sse2

cglobal spsc_send, 2, 7
    push   rbx
    sub    rsp, 48
    mov    rbx, rcx
    mov    [rsp+32], rdx
.retry:
    mov    eax, [rbx+4]
    mov    edx, [rbx]
    mov    ecx, eax
    sub    ecx, edx
    cmp    ecx, CAP
    jb     .space
.block:
    mov    eax, 1
    xchg   [rbx+16], eax
    mov    eax, [rbx+4]
    mov    edx, [rbx]
    sub    eax, edx
    cmp    eax, CAP
    jb     .unblock
    mov    eax, [rbx+12]
    mov    [rsp+40], eax
    lea    rcx, [rbx+12]
    lea    rdx, [rsp+40]
    mov    r2d, 4
    mov    r3d, -1
    call   [rel __imp_WaitOnAddress]
    xor    eax, eax
    xchg   [rbx+16], eax
    jmp    .block
.unblock:
    xor    eax, eax
    xchg   [rbx+16], eax
    mov    eax, [rbx+4]
.space:
    lea    ecx, [rax+1]
    and    eax, MASK
    mov    rdx, [rsp+32]
    mov    [rbx+32+rax*8], rdx
    xchg   [rbx+4], ecx
    cmp    dword [rbx+20], 0
    jz     .done
    lock inc dword [rbx+8]
    lea    rcx, [rbx+8]
    call   [rel __imp_WakeByAddressSingle]
.done:
    add    rsp, 48
    pop    rbx
    RET

cglobal spsc_recv, 1, 7
    push   rbx
    sub    rsp, 48
    mov    rbx, rcx
.retry:
    mov    edx, [rbx+4]
    mov    eax, [rbx]
    cmp    eax, edx
    jne    .have
    cmp    dword [rbx+24], 0
    jnz    .eof
.park:
    mov    eax, 1
    xchg   [rbx+20], eax
    mov    edx, [rbx+4]
    mov    eax, [rbx]
    cmp    eax, edx
    jne    .unpark
    cmp    dword [rbx+24], 0
    jnz    .eof_unpark
    mov    eax, [rbx+8]
    mov    [rsp+32], eax
    lea    rcx, [rbx+8]
    lea    rdx, [rsp+32]
    mov    r2d, 4
    mov    r3d, -1
    call   [rel __imp_WaitOnAddress]
    xor    eax, eax
    xchg   [rbx+20], eax
    jmp    .park
.unpark:
    xor    eax, eax
    xchg   [rbx+20], eax
    mov    eax, [rbx]
.have:
    mov    ecx, eax
    and    ecx, MASK
    lea    edx, [rax+1]
    mov    rax, [rbx+32+rcx*8]
    xchg   [rbx], edx
    cmp    dword [rbx+16], 0
    jnz    .wake
    add    rsp, 48
    pop    rbx
    RET
.wake:
    mov    [rsp+40], rax
    lock inc dword [rbx+12]
    lea    rcx, [rbx+12]
    call   [rel __imp_WakeByAddressSingle]
    mov    rax, [rsp+40]
    add    rsp, 48
    pop    rbx
    RET
.eof_unpark:
    xor    eax, eax
    xchg   [rbx+20], eax
.eof:
    xor    eax, eax
    add    rsp, 48
    pop    rbx
    RET

cglobal spsc_close, 1, 7
    sub    rsp, 40
    mov    eax, 1
    xchg   [rcx+24], eax
    lock inc dword [rcx+8]
    lea    rcx, [rcx+8]
    call   [rel __imp_WakeByAddressSingle]
    add    rsp, 40
    RET
