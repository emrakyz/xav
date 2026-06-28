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

SECTION .text

INIT_XMM sse2

cglobal spmc_send, 2, 8
    mov    eax, [rdi+TAIL]
    mov    ecx, eax
    and    ecx, MASK
.wait:
    mov    edx, [rdi+rcx*4]
    cmp    edx, eax
    je     .write
    mov    [rsp-8], rsi
.pblock:
    mov    edx, 1
    xchg   [rdi+PW], edx
    mov    esi, [rdi+SPACE]
    mov    eax, [rdi+TAIL]
    mov    ecx, eax
    and    ecx, MASK
    mov    edx, [rdi+rcx*4]
    cmp    edx, eax
    je     .punblock
    mov    edx, esi
    lea    rdi, [rdi+SPACE]
    mov    eax, 202
    mov    esi, 128
    xor    r7d, r7d
    syscall
    lea    rdi, [rdi-SPACE]
    xor    edx, edx
    xchg   [rdi+PW], edx
    jmp    .pblock
.punblock:
    xor    edx, edx
    xchg   [rdi+PW], edx
    mov    rsi, [rsp-8]
.write:
    mov    [rdi+VALS+rcx*8], rsi
    lea    edx, [rax+1]
    xchg   [rdi+rcx*4], edx
    inc    eax
    mov    [rdi+TAIL], eax
    cmp    dword [rdi+CW], 0
    jz     .pdone
    lock inc dword [rdi+AVAIL]
    lea    rdi, [rdi+AVAIL]
    mov    eax, 202
    mov    esi, 129
    mov    edx, 1
    syscall
.pdone:
    RET

cglobal spmc_recv, 1, 8
.retry:
    mov    eax, [rdi+HEAD]
    mov    ecx, eax
    and    ecx, MASK
    mov    edx, [rdi+rcx*4]
    lea    esi, [rax+1]
    cmp    edx, esi
    je     .ready
    cmp    edx, eax
    jne    .retry
    cmp    dword [rdi+CLOSED], 0
    jnz    .eof
.park:
    lock inc dword [rdi+CW]
    mov    ecx, [rdi+AVAIL]
    mov    eax, [rdi+HEAD]
    mov    esi, eax
    and    esi, MASK
    mov    edx, [rdi+rsi*4]
    cmp    edx, eax
    jne    .unpark
    cmp    dword [rdi+CLOSED], 0
    jnz    .eof_unpark
    mov    edx, ecx
    lea    rdi, [rdi+AVAIL]
    mov    eax, 202
    mov    esi, 128
    xor    r7d, r7d
    syscall
    lea    rdi, [rdi-AVAIL]
.unpark:
    lock dec dword [rdi+CW]
    jmp    .retry
.ready:
    lock cmpxchg [rdi+HEAD], esi
    jne    .retry
    lea    edx, [rax+CAP]
    mov    rax, [rdi+VALS+rcx*8]
    xchg   [rdi+rcx*4], edx
    cmp    dword [rdi+PW], 0
    jnz    .wake
    RET
.wake:
    mov    [rsp-8], rax
    lock inc dword [rdi+SPACE]
    lea    rdi, [rdi+SPACE]
    mov    eax, 202
    mov    esi, 129
    mov    edx, 1
    syscall
    mov    rax, [rsp-8]
    RET
.eof_unpark:
    lock dec dword [rdi+CW]
.eof:
    xor    eax, eax
    RET

cglobal spmc_close, 1, 8
    mov    eax, 1
    xchg   [rdi+CLOSED], eax
    lock inc dword [rdi+AVAIL]
    lea    rdi, [rdi+AVAIL]
    mov    eax, 202
    mov    esi, 129
    mov    edx, 0x7fffffff
    syscall
    RET
