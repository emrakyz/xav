%include "dav1d_x86inc.asm"

%ifndef CAP
%define CAP 128
%endif
%define MASK (CAP-1)
%define VALS (CAP*4)
%define TAIL (CAP*12)
%define HEAD (TAIL+4)
%define CW (TAIL+8)
%define PW (TAIL+12)
%define AVAIL (TAIL+16)
%define SPACE (TAIL+20)
%define CLOSED (TAIL+24)

extern __imp_WaitOnAddress
extern __imp_WakeByAddressSingle
extern __imp_WakeByAddressAll

SECTION .text

INIT_XMM sse2

cglobal spmc_send, 2, 7
    push   rbx
    sub    rsp, 48
    mov    rbx, rcx
    mov    [rsp+32], rdx
    mov    eax, [rbx+TAIL]
    mov    ecx, eax
    and    ecx, MASK
.wait:
    mov    edx, [rbx+rcx*4]
    cmp    edx, eax
    je     .write
.pblock:
    mov    edx, 1
    xchg   [rbx+PW], edx
    mov    eax, [rbx+TAIL]
    mov    ecx, eax
    and    ecx, MASK
    mov    edx, [rbx+rcx*4]
    cmp    edx, eax
    je     .punblock
    mov    eax, [rbx+SPACE]
    mov    [rsp+40], eax
    lea    rcx, [rbx+SPACE]
    lea    rdx, [rsp+40]
    mov    r2d, 4
    mov    r3d, -1
    call   [rel __imp_WaitOnAddress]
    xor    edx, edx
    xchg   [rbx+PW], edx
    jmp    .pblock
.punblock:
    xor    edx, edx
    xchg   [rbx+PW], edx
.write:
    mov    rdx, [rsp+32]
    mov    [rbx+VALS+rcx*8], rdx
    lea    edx, [rax+1]
    xchg   [rbx+rcx*4], edx
    inc    eax
    mov    [rbx+TAIL], eax
    cmp    dword [rbx+CW], 0
    jz     .pdone
    lock inc dword [rbx+AVAIL]
    lea    rcx, [rbx+AVAIL]
    call   [rel __imp_WakeByAddressSingle]
.pdone:
    add    rsp, 48
    pop    rbx
    RET

cglobal spmc_recv, 1, 7
    push   rbx
    sub    rsp, 48
    mov    rbx, rcx
.retry:
    mov    eax, [rbx+HEAD]
    mov    ecx, eax
    and    ecx, MASK
    mov    edx, [rbx+rcx*4]
    lea    r4d, [rax+1]
    cmp    edx, r4d
    je     .ready
    cmp    edx, eax
    jne    .retry
    cmp    dword [rbx+CLOSED], 0
    jnz    .eof
.park:
    lock inc dword [rbx+CW]
    mov    eax, [rbx+HEAD]
    mov    ecx, eax
    and    ecx, MASK
    mov    edx, [rbx+rcx*4]
    cmp    edx, eax
    jne    .unpark
    cmp    dword [rbx+CLOSED], 0
    jnz    .eof_unpark
    mov    eax, [rbx+AVAIL]
    mov    [rsp+32], eax
    lea    rcx, [rbx+AVAIL]
    lea    rdx, [rsp+32]
    mov    r2d, 4
    mov    r3d, -1
    call   [rel __imp_WaitOnAddress]
.unpark:
    lock dec dword [rbx+CW]
    jmp    .retry
.ready:
    lock cmpxchg [rbx+HEAD], r4d
    jne    .retry
    lea    edx, [rax+CAP]
    mov    rax, [rbx+VALS+rcx*8]
    xchg   [rbx+rcx*4], edx
    cmp    dword [rbx+PW], 0
    jnz    .wake
    add    rsp, 48
    pop    rbx
    RET
.wake:
    mov    [rsp+40], rax
    lock inc dword [rbx+SPACE]
    lea    rcx, [rbx+SPACE]
    call   [rel __imp_WakeByAddressSingle]
    mov    rax, [rsp+40]
    add    rsp, 48
    pop    rbx
    RET
.eof_unpark:
    lock dec dword [rbx+CW]
.eof:
    xor    eax, eax
    add    rsp, 48
    pop    rbx
    RET

cglobal spmc_close, 1, 7
    sub    rsp, 40
    mov    eax, 1
    xchg   [rcx+CLOSED], eax
    lock inc dword [rcx+AVAIL]
    lea    rcx, [rcx+AVAIL]
    call   [rel __imp_WakeByAddressAll]
    add    rsp, 40
    RET
