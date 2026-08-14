%use smartalign
ALIGNMODE p6

SECTION .text

; xav_svt_drain_go stores S_HANDLE last; after S_OUT, S_ENCED, S_WRFN
; MUST NOT REORDER / IT WILL BREAK

extern svt_av1_enc_get_packet
extern svt_av1_enc_release_out_buffer
extern xav_sem_acq
extern xav_sem_release
extern pthread_create

%define S_TICK   0
%define S_GO     8
%define S_FIN    16
%define S_HANDLE 24
%define S_WRFN   32
%define S_ENCED  40
%define S_SZ     48
%define S_EOS    56
%define S_OUT    64
%define S_TID    80

%define S_SHIFT  7

%define EMPTY    0x80002033

%define B_BUFFER 8
%define B_FILLED 16
%define B_FLAGS  104

%macro PKTBODY 0
    mov    rbp, [rsp]
    mov    ecx, [rbp+B_FILLED]
    test   ecx, ecx
    jz     %%rel
    lea    edx, [rcx-2]
    add    r14, rdx
    mov    rsi, [rbp+B_BUFFER]
    add    rsi, 2
    mov    rdi, r13
    call   rbx
    inc    qword [r15]
%%rel:
    mov    ebp, [rbp+B_FLAGS]
    mov    rdi, rsp
    call   svt_av1_enc_release_out_buffer
    test   ebp, 1
%endmacro

global xav_svt_drain_go
xav_svt_drain_go:
    lea    r10, [rel states]
    shl    rdi, S_SHIFT
    add    r10, rdi
    mov    [r10+S_OUT], rdx
    mov    [r10+S_OUT+8], rcx
    mov    [r10+S_ENCED], r8
    mov    [r10+S_WRFN], r9
    mov    qword [r10+S_EOS], 0
    mov    [r10+S_HANDLE], rsi
    cmp    qword [r10+S_TID], 0
    jz     .spawn
.go:
    push   r10
    lea    rdi, [r10+S_GO]
    call   xav_sem_release
    pop    rax
    ret
.spawn:
    push   r10
    lea    rdi, [r10+S_TID]
    xor    esi, esi
    lea    rdx, [rel xav_svt_drain]
    mov    rcx, r10
    call   pthread_create
    pop    r10
    jmp    .go

global xav_svt_drain_wait
xav_svt_drain_wait:
    push   rbx
    lea    rbx, [rel states]
    shl    rdi, S_SHIFT
    add    rbx, rdi
    mov    qword [rbx+S_EOS], 1
    mov    rdi, rbx
    call   xav_sem_release
    lea    rdi, [rbx+S_FIN]
    call   xav_sem_acq
    mov    rax, [rbx+S_SZ]
    pop    rbx
    ret

global xav_svt_drain_tick
xav_svt_drain_tick:
    push   rbx
    push   r12
    sub    rsp, 8
    lea    rbx, [rel states]
    shl    rdi, S_SHIFT
    lea    r12, [rbx+rdi]
.slot:
    cmp    qword [rbx+S_HANDLE], 0
    jz     .next
    mov    rdi, rbx
    call   xav_sem_release
.next:
    add    rbx, 128
    cmp    rbx, r12
    jb     .slot
    add    rsp, 8
    pop    r12
    pop    rbx
    ret

global xav_svt_drain
xav_svt_drain:
    push   rbx
    push   rbp
    push   r12
    push   r13
    push   r14
    push   r15
    mov    rax, rsp
    sub    rsp, 96
    and    rsp, -64
    mov    [rsp+32], rax
    mov    [rsp+8], rdi

.job:
    mov    rdi, [rsp+8]
    add    rdi, S_GO
    call   xav_sem_acq
    mov    rax, [rsp+8]
    mov    r12, [rax+S_HANDLE]
    test   r12, r12
    jz     .stop
    mov    rbx, [rax+S_WRFN]
    mov    r15, [rax+S_ENCED]
    lea    r13, [rax+S_OUT]
    xor    r14d, r14d
    mov    qword [r15], 0
    jmp    .pkt

align 64
.pkt:
    mov    rdi, r12
    mov    rsi, rsp
    xor    edx, edx
    call   svt_av1_enc_get_packet
    cmp    eax, EMPTY
    jz     .idle
    PKTBODY
    jz     .pkt
    jmp    .done

.idle:
    mov    rbp, [rsp+8]
    cmp    qword [rbp+S_EOS], 0
    jnz    .flush
    mov    rdi, rbp
    call   xav_sem_acq
    mov    dword [rbp], 0
    jmp    .pkt

.flush:
    mov    rdi, r12
    mov    rsi, rsp
    mov    edx, 1
    call   svt_av1_enc_get_packet
    PKTBODY
    jz     .flush

.done:
    mov    rax, [rsp+8]
    mov    [rax+S_SZ], r14
    mov    qword [rax+S_HANDLE], 0
    lea    rdi, [rax+S_FIN]
    call   xav_sem_release
    jmp    .job

.stop:
    mov    rsp, [rsp+32]
    pop    r15
    pop    r14
    pop    r13
    pop    r12
    pop    rbp
    pop    rbx
    xor    eax, eax
    ret

SECTION .bss
    alignb 128
states:
    resb 128 * 512
