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

cglobal mpsc_send, 2, 7
    push   rbx
    sub    rsp, 48
    mov    rbx, rcx
    mov    [rsp+32], rdx
.retry:
    mov    eax, [rbx+TAIL]
    mov    ecx, eax
    and    ecx, MASK
    cmp    [rbx+rcx*4], eax
    je     .claim
    jg     .retry
.pblock:
    lock inc dword [rbx+PW]
    mov    eax, [rbx+TAIL]
    mov    edx, eax
    and    edx, MASK
    mov    edx, [rbx+rdx*4]
    cmp    edx, eax
    jge    .punblock
    mov    eax, [rbx+SPACE]
    mov    [rsp+40], eax
    lea    rcx, [rbx+SPACE]
    lea    rdx, [rsp+40]
    mov    r2d, 4
    mov    r3d, -1
    call   [rel __imp_WaitOnAddress]
.punblock:
    lock dec dword [rbx+PW]
    jmp    .retry
.claim:
    lea    edx, [rax+1]
    lock cmpxchg [rbx+TAIL], edx
    jne    .retry
    mov    rax, [rsp+32]
    mov    [rbx+VALS+rcx*8], rax
    xchg   [rbx+rcx*4], edx
    cmp    dword [rbx+CW], 0
    jz     .pdone
    lock inc dword [rbx+AVAIL]
    lea    rcx, [rbx+AVAIL]
    call   [rel __imp_WakeByAddressSingle]
.pdone:
    add    rsp, 48
    pop    rbx
    RET

cglobal mpsc_recv, 1, 7
    push   rbx
    sub    rsp, 48
    mov    rbx, rcx
.retry:
    mov    eax, [rbx+HEAD]
    mov    ecx, eax
    and    ecx, MASK
    lea    r4d, [rax+1]
    cmp    [rbx+rcx*4], r4d
    je     .ready
    cmp    dword [rbx+CLOSED], 0
    jnz    .eof
.park:
    mov    edx, 1
    xchg   [rbx+CW], edx
    mov    eax, [rbx+HEAD]
    mov    ecx, eax
    and    ecx, MASK
    lea    r4d, [rax+1]
    cmp    [rbx+rcx*4], r4d
    je     .unpark
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
    mov    dword [rbx+CW], 0
    jmp    .retry
.ready:
    lea    edx, [rax+CAP]
    mov    [rbx+HEAD], r4d
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
    mov    dword [rbx+CW], 0
.eof:
    xor    eax, eax
    add    rsp, 48
    pop    rbx
    RET

cglobal mpsc_close, 1, 7
    sub    rsp, 40
    mov    eax, 1
    xchg   [rcx+CLOSED], eax
    lock inc dword [rcx+AVAIL]
    lea    rcx, [rcx+AVAIL]
    call   [rel __imp_WakeByAddressAll]
    add    rsp, 40
    RET
