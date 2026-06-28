%include "dav1d_x86inc.asm"

%ifndef CAP
%define CAP 128
%endif
%define MASK (CAP-1)

SECTION .text

INIT_XMM sse2

cglobal spsc_send, 2, 8
.retry:
    mov    eax, [rdi+4]
    mov    edx, [rdi]
    mov    ecx, eax
    sub    ecx, edx
    cmp    ecx, CAP
    jb     .space
    mov    [rsp-8], rsi
.block:
    mov    eax, 1
    xchg   [rdi+16], eax
    mov    ecx, [rdi+12]
    mov    eax, [rdi+4]
    mov    edx, [rdi]
    sub    eax, edx
    cmp    eax, CAP
    jb     .unblock
    mov    edx, ecx
    lea    rdi, [rdi+12]
    mov    eax, 202
    mov    esi, 128
    xor    r7d, r7d
    syscall
    lea    rdi, [rdi-12]
    xor    eax, eax
    xchg   [rdi+16], eax
    jmp    .block
.unblock:
    xor    eax, eax
    xchg   [rdi+16], eax
    mov    rsi, [rsp-8]
    mov    eax, [rdi+4]
.space:
    lea    ecx, [rax+1]
    and    eax, MASK
    mov    [rdi+32+rax*8], rsi
    xchg   [rdi+4], ecx
    cmp    dword [rdi+20], 0
    jz     .done
    lock inc dword [rdi+8]
    lea    rdi, [rdi+8]
    mov    eax, 202
    mov    esi, 129
    mov    edx, 1
    syscall
.done:
    RET

cglobal spsc_recv, 1, 8
.retry:
    mov    edx, [rdi+4]
    mov    eax, [rdi]
    cmp    eax, edx
    jne    .have
    cmp    dword [rdi+24], 0
    jnz    .eof
.park:
    mov    eax, 1
    xchg   [rdi+20], eax
    mov    ecx, [rdi+8]
    mov    edx, [rdi+4]
    mov    eax, [rdi]
    cmp    eax, edx
    jne    .unpark
    cmp    dword [rdi+24], 0
    jnz    .eof_unpark
    mov    edx, ecx
    lea    rdi, [rdi+8]
    mov    eax, 202
    mov    esi, 128
    xor    r7d, r7d
    syscall
    lea    rdi, [rdi-8]
    xor    eax, eax
    xchg   [rdi+20], eax
    jmp    .park
.unpark:
    xor    eax, eax
    xchg   [rdi+20], eax
    mov    eax, [rdi]
.have:
    mov    ecx, eax
    and    ecx, MASK
    lea    edx, [rax+1]
    mov    rax, [rdi+32+rcx*8]
    xchg   [rdi], edx
    cmp    dword [rdi+16], 0
    jnz    .wake
    RET
.wake:
    mov    [rsp-8], rax
    lock inc dword [rdi+12]
    lea    rdi, [rdi+12]
    mov    eax, 202
    mov    esi, 129
    mov    edx, 1
    syscall
    mov    rax, [rsp-8]
    RET
.eof_unpark:
    xor    eax, eax
    xchg   [rdi+20], eax
.eof:
    xor    eax, eax
    RET

cglobal spsc_close, 1, 8
    mov    eax, 1
    xchg   [rdi+24], eax
    lock inc dword [rdi+8]
    lea    rdi, [rdi+8]
    mov    eax, 202
    mov    esi, 129
    mov    edx, 1
    syscall
    RET
