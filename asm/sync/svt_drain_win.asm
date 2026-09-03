%use smartalign
ALIGNMODE p6

SECTION .text

; xav_svt_drain_go stores S_HANDLE last; after S_OUT, S_ENCED, S_WRFN
; MUST NOT REORDER / IT WILL BREAK

extern svt_av1_enc_get_packet
extern svt_av1_enc_release_out_buffer
extern xav_sem_acq
extern xav_sem_release
extern __imp_CreateThread

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

%define F_PKT    32
%define F_ST     40
%define F_RSP    48

%macro PKTBODY 0
    mov    rbp, [rsp+F_PKT]
    mov    eax, [rbp+B_FILLED]
    test   eax, eax
    jz     %%rel
    lea    r8d, [rax-2]
    add    r14, r8
    mov    rdx, [rbp+B_BUFFER]
    add    rdx, 2
    mov    rcx, r13
    call   rbx
    inc    qword [r15]
%%rel:
    mov    ebp, [rbp+B_FLAGS]
    lea    rcx, [rsp+F_PKT]
    call   svt_av1_enc_release_out_buffer
    test   ebp, 1
%endmacro

global xav_svt_drain_go
xav_svt_drain_go:
    lea    r10, [rel states]
    shl    rcx, S_SHIFT
    add    r10, rcx
    mov    [r10+S_OUT], r8
    mov    [r10+S_OUT+8], r9
    mov    rax, [rsp+40]
    mov    [r10+S_ENCED], rax
    mov    rax, [rsp+48]
    mov    [r10+S_WRFN], rax
    mov    qword [r10+S_EOS], 0
    mov    [r10+S_HANDLE], rdx
    cmp    qword [r10+S_TID], 0
    jz     .spawn
.go:
    push   r10
    sub    rsp, 32
    lea    rcx, [r10+S_GO]
    call   xav_sem_release
    add    rsp, 32
    pop    rax
    ret
.spawn:
    push   r10
    sub    rsp, 48
    xor    ecx, ecx
    xor    edx, edx
    lea    r8, [rel xav_svt_drain]
    mov    r9, r10
    mov    qword [rsp+32], 0
    mov    qword [rsp+40], 0
    call   [rel __imp_CreateThread]
    add    rsp, 48
    pop    r10
    mov    [r10+S_TID], rax
    jmp    .go

global xav_svt_drain_wait
xav_svt_drain_wait:
    push   rbx
    sub    rsp, 32
    lea    rbx, [rel states]
    shl    rcx, S_SHIFT
    add    rbx, rcx
    mov    qword [rbx+S_EOS], 1
    mov    rcx, rbx
    call   xav_sem_release
    lea    rcx, [rbx+S_FIN]
    call   xav_sem_acq
    mov    rax, [rbx+S_SZ]
    add    rsp, 32
    pop    rbx
    ret

global xav_svt_drain_tick
xav_svt_drain_tick:
    push   rbx
    push   r12
    sub    rsp, 40
    lea    rbx, [rel states]
    shl    rcx, S_SHIFT
    lea    r12, [rbx+rcx]
.slot:
    cmp    qword [rbx+S_HANDLE], 0
    jz     .next
    mov    rcx, rbx
    call   xav_sem_release
.next:
    add    rbx, 128
    cmp    rbx, r12
    jb     .slot
    add    rsp, 40
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
    mov    [rsp+F_RSP], rax
    mov    [rsp+F_ST], rcx

.job:
    mov    rcx, [rsp+F_ST]
    add    rcx, S_GO
    call   xav_sem_acq
    mov    rax, [rsp+F_ST]
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
    mov    rcx, r12
    lea    rdx, [rsp+F_PKT]
    xor    r8d, r8d
    call   svt_av1_enc_get_packet
    cmp    eax, EMPTY
    jz     .idle
    PKTBODY
    jz     .pkt
    jmp    .done

.idle:
    mov    rbp, [rsp+F_ST]
    cmp    qword [rbp+S_EOS], 0
    jnz    .flush
    mov    rcx, rbp
    call   xav_sem_acq
    mov    dword [rbp], 0
    jmp    .pkt

.flush:
    mov    rcx, r12
    lea    rdx, [rsp+F_PKT]
    mov    r8d, 1
    call   svt_av1_enc_get_packet
    PKTBODY
    jz     .flush

.done:
    mov    rax, [rsp+F_ST]
    mov    [rax+S_SZ], r14
    mov    qword [rax+S_HANDLE], 0
    lea    rcx, [rax+S_FIN]
    call   xav_sem_release
    jmp    .job

.stop:
    mov    rsp, [rsp+F_RSP]
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
