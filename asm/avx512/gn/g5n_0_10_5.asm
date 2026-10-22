%include "g5nm.inc"
default rel
%include "g5o.inc"
%include "g5img.inc"
M5s_a0
M5s_a1
M5s_a2
c_i1023: dd 1023
c_m1: dd -1
c_pft: dq xav_g5_0_10_5.pf1, xav_g5_0_10_5.pf2, xav_g5_0_10_5.pf3, xav_g5_0_10_5.pf4, xav_g5_0_10_5.pf5, xav_g5_0_10_5.pf6, xav_g5_0_10_5.pf7, xav_g5_0_10_5.pf8, xav_g5_0_10_5.pf9, xav_g5_0_10_5.pf10, xav_g5_0_10_5.pf11, xav_g5_0_10_5.pf12, xav_g5_0_10_5.pf13, xav_g5_0_10_5.pf14, xav_g5_0_10_5.pf15, xav_g5_0_10_5.pf16, xav_g5_0_10_5.pf17, xav_g5_0_10_5.pf18, xav_g5_0_10_5.pf19, xav_g5_0_10_5.pf20, xav_g5_0_10_5.pf21, xav_g5_0_10_5.pf22, xav_g5_0_10_5.pf23, xav_g5_0_10_5.pf24, xav_g5_0_10_5.pf25, xav_g5_0_10_5.pf26, xav_g5_0_10_5.pf27, xav_g5_0_10_5.pf28, xav_g5_0_10_5.pf29, xav_g5_0_10_5.pf30, xav_g5_0_10_5.pf31, xav_g5_0_10_5.pf32
M5s_a3
M5s_a4
c_qtr: dd 0x3e800000
section .text
global xav_g5_0_10_5
align 64
xav_g5_0_10_5:
M5s_a5
M5s_a7
    valignd zmm3, zmm10, zmm8, 15
    vaddps zmm1, zmm1, zmm10
    vaddps zmm2, zmm2, zmm3
    vmulps zmm2, zmm2, zmm6
    vfmsub132ps zmm1, zmm2, zmm7
    vmovaps zmm3, zmm10
    vpermt2ps zmm3, zmm4, zmm1
    vmovaps zmm14, zmm10
    vpermt2ps zmm14, zmm5, zmm1
    vmovups [r12 + 0], zmm3
    vmovups [r12 + 128], zmm14
M5s_ab
    vmovaps zmm11, zmm13
    add r12, 256
    add eax, 16
    dec r14
    jnz .cv2
.cl2:
    mov ecx, r8d
    sub ecx, eax
    sub ecx, 16
M5s_a8
    kmovw k2, ebx
    vpmovzxwd zmm0{k2}{z}, [rsi + rax*2 + 32]
    vpaddd zmm0, zmm0, zmm15
    vcvtdq2ps zmm0, zmm0
    vpermps zmm12, zmm16, zmm0
    vmovaps zmm12{k2}, zmm0
    vpmovzxwd zmm0{k2}{z}, [rdx + rax*2 + 32]
    vpaddd zmm0, zmm0, zmm15
    vcvtdq2ps zmm0, zmm0
    vpermps zmm13, zmm16, zmm0
    vmovaps zmm13{k2}, zmm0
M5s_a9
M5s_ac
M5s_ad
    vmovaps zmm10, zmm12
    vmovaps zmm11, zmm13
    add r12, 256
.cl1:
    vpermps zmm12, zmm17, zmm10
    vpermps zmm13, zmm17, zmm11
M5s_a9
M5s_ac
    vmovups [r12 + 64], zmm3
    vmovups [r12 + 192], zmm14
    mov r15, [rsp + 64]
    inc qword [rsp + 32]
    jmp .rg
.rgd:
    xor eax, eax
    mov [rsp + 40], rax
.str:
    mov rdi, [rsp + 8]
    mov rax, [rsp + 40]
    cmp rax, [rdi + G_lq]
    je .stq
M5s_af
M5s_a11
    mov eax, [r15 + Pc_n]
    test eax, eax
    jz .r0e
    mov [rsp + 104], rax
    cmp dword [r15 + Pc_ci], 0
    jne .r0c
M5s_a13
M5s_a1d
M5s_a23
    add r9, rdx
M5s_a26
    vfmadd231ps zmm8, zmm3, [r14 + rdx*4]
    vfmadd231ps zmm9, zmm3, [r14 + rdx*4+64]
M5s_a2f
    vfmadd231ps zmm6, zmm8, [c_xbcb]{1to16}
M5s_a26
    vfmadd231ps zmm8, zmm3, [r14 + rdx*4]
    vfmadd231ps zmm9, zmm3, [r14 + rdx*4+64]
    add rdx, 32
    vrangeps zmm10, zmm4, zmm24, 0x03
    vrangeps zmm14, zmm5, zmm24, 0x03
    vrangeps zmm18, zmm6, zmm24, 0x03
M5s_a30
M5s_a43
M5s_a53
M5s_a5b
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
.r0s:
M5s_a5f
M5s_a6e
    vmovups [r8 + rdi*2], zmm20
    vmovups [r8 + rcx], zmm22
.r0smk:
    add r8, 64
M5s_a41
M5s_a50
    vmulps zmm19, zmm19, zmm21
    cmp rdx, r9
    jb .r0s
M5s_a5f
M5s_a6e
    vmovups [r8 + rdi*2], zmm20
    vmovups [r8 + rcx], zmm22
.r0sfk:
M5s_a72
M5s_a46
M5s_a56
    vmulps zmm15, zmm15, zmm17
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
M5s_a32
M5s_a5f
M5s_a6e
    vmovups [r8 + rdi*2], zmm20
    vmovups [r8 + rcx], zmm22
.r0sgk:
M5s_a72
M5s_a46
M5s_a56
    vmulps zmm15, zmm15, zmm17
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
M5s_a5f
M5s_a6e
    vmovups [r8 + rdi*2], zmm20
    vmovups [r8 + rcx], zmm22
.r0sek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
    jmp .r0n
.r0c:
M5s_a12
M5s_a34
M5s_a45
M5s_a55
M5s_a5e
.r0k:
M5s_a5f
M5s_a7d
    vaddps zmm22, zmm22, [rbp + rdx*8-576]
    vmovups [r8 + rcx], zmm22
.r0kmk:
M5s_a71
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
    cmp rdx, r9
    jb .r0k
M5s_a5f
M5s_a7d
    vaddps zmm22, zmm22, [rbp + rdx*8-576]
    vmovups [r8 + rcx], zmm22
.r0kfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_a82
    vmovups [r8 + rcx], zmm22
.r0kgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_a84
    vmovups [r8 + rcx], zmm22
.r0kek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
.r0n:
    dec qword [rsp + 104]
    jz .r0e
.r0:
M5s_a12
M5s_a34
M5s_a45
M5s_a55
M5s_a5e
.r0b:
M5s_a5f
M5s_a88
    vaddps zmm22, zmm22, [r8 + rcx]
    vmovups [r8 + rcx], zmm22
.r0bmk:
M5s_a71
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
    cmp rdx, r9
    jb .r0b
M5s_a5f
M5s_a88
    vaddps zmm22, zmm22, [r8 + rcx]
    vmovups [r8 + rcx], zmm22
.r0bfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_a89
    vmovups [r8 + rcx], zmm22
.r0bgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_a89
    vmovups [r8 + rcx], zmm22
.r0bek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
    dec qword [rsp + 104]
    jnz .r0
.r0e:
    cmp dword [r15 + Pc_n + 4], 0
    je .s01e
    cmp dword [r15 + Pc_n], 0
    jne .s01r
    cmp dword [r15 + Pc_ci], 0
    jne .s01c
M5s_a12
M5s_a34
M5s_a45
M5s_a55
M5s_a5e
.s01s:
M5s_a5f
M5s_a90
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
    vmovups [r8 + rbx], zmm22
.s01smk:
M5s_a71
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
    cmp rdx, r9
    jb .s01s
M5s_a5f
M5s_a90
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
    vmovups [r8 + rbx], zmm22
.s01sfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_a91
    vmovups [r8 + rbx], zmm22
.s01sgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_a91
    vmovups [r8 + rbx], zmm22
.s01sek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
    jmp .s01e
.s01c:
M5s_a12
M5s_a34
M5s_a45
M5s_a55
M5s_a5e
.s01k:
M5s_a5f
M5s_a9b
M5s_a9f
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
    vmovups [r8 + rbx], zmm22
.s01kmk:
M5s_a71
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
    cmp rdx, r9
    jb .s01k
M5s_a5f
M5s_a9b
M5s_a9f
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
    vmovups [r8 + rbx], zmm22
.s01kfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
    vpminsd zmm22, zmm22, [c_zero]{1to16}
    vmovups zmm10, [rbp + rdx*8-512]
M5s_a9c
    vmovups zmm14, [rbp + rdx*8-448]
M5s_a9d
    vmovups zmm18, [rbp + rdx*8-384]
M5s_a9e
    vmovups zmm11, [rbp + rdx*8-320]
M5s_aa1
.s01kgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
    vpminsd zmm22, zmm22, [c_zero]{1to16}
    vmovups zmm10, [rbp + rdx*8-256]
M5s_a9c
    vmovups zmm14, [rbp + rdx*8-192]
M5s_a9d
    vmovups zmm18, [rbp + rdx*8-128]
M5s_a9e
    vmovups zmm11, [rbp + rdx*8-64]
M5s_aa1
.s01kek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
    jmp .s01e
.s01r:
M5s_a12
M5s_a34
M5s_a45
M5s_a55
M5s_a5e
.s01b:
M5s_a5f
    vpmaxud zmm22, zmm22, zmm20
    vpminsd zmm22, zmm22, [c_zero]{1to16}
    vmovups zmm10, [r8]
M5s_a9c
    vmovups zmm14, [r8 + rdi]
M5s_a9d
    vmovups zmm18, [r8 + rdi*2]
M5s_a9e
    vmovups zmm11, [r8 + rcx]
M5s_aa1
.s01bmk:
M5s_a71
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
    cmp rdx, r9
    jb .s01b
M5s_a5f
M5s_ab1
    vmovups [r8 + rcx*2], zmm20
M5s_ab4
    vmovups [r8 + rbx], zmm22
.s01bfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_ab2
M5s_ab4
    vmovups [r8 + rbx], zmm22
.s01bgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_ab2
M5s_ab4
    vmovups [r8 + rbx], zmm22
.s01bek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
.s01e:
    mov eax, [r15 + Pc_n + 8]
    test eax, eax
    jz .r1e
    mov [rsp + 104], rax
    cmp dword [r15 + Pc_n + 4], 0
    jne .r1
M5s_a13
M5s_a1c
M5s_a21
M5s_a4c
M5s_a5c
    vmulps zmm19, zmm19, zmm21
.r1s:
M5s_a5f
M5s_abe
    vmovups [r8 + rcx*2], zmm20
    vmovups [r8 + rbx], zmm22
.r1smk:
M5s_a71
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
    cmp rdx, r9
    jb .r1s
M5s_a5f
M5s_abe
    vmovups [r8 + rcx*2], zmm20
    vmovups [r8 + rbx], zmm22
.r1sfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_abf
    vmovups [r8 + rbx], zmm22
.r1sgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_abf
    vmovups [r8 + rbx], zmm22
.r1sek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
    dec qword [rsp + 104]
    jz .r1e
.r1:
M5s_a13
M5s_a1c
M5s_a21
M5s_a4c
M5s_a5c
    vmulps zmm19, zmm19, zmm21
.r1b:
M5s_a5f
M5s_ac6
    vaddps zmm22, zmm22, [r8 + rbx]
    vmovups [r8 + rbx], zmm22
.r1bmk:
M5s_a71
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
    cmp rdx, r9
    jb .r1b
M5s_a5f
M5s_ac6
    vaddps zmm22, zmm22, [r8 + rbx]
    vmovups [r8 + rbx], zmm22
.r1bfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_ac7
    vmovups [r8 + rbx], zmm22
.r1bgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_ac7
    vmovups [r8 + rbx], zmm22
.r1bek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
    dec qword [rsp + 104]
    jnz .r1
.r1e:
    cmp dword [r15 + Pc_n + 12], 0
    je .s1ne
    mov eax, [r15 + Pc_n + 4]
    or eax, [r15 + Pc_n + 8]
    jnz .s1nr
M5s_a12
M5s_a34
M5s_a45
M5s_a55
M5s_a5e
.s1ns:
M5s_a5f
M5s_ad2
    vmulps zmm22, zmm22, [r15 + Pc_w + 12]{1to16}
    vmovups [rbp + rdx*8-576], zmm22
.s1nsmk:
M5s_a71
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
    cmp rdx, r9
    jb .s1ns
M5s_a5f
M5s_ad2
    vmulps zmm22, zmm22, [r15 + Pc_w + 12]{1to16}
    vmovups [rbp + rdx*8-576], zmm22
.s1nsfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_ad4
M5s_ada
M5s_adc
    vmovups [rbp + rdx*8-320], zmm22
.s1nsgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_ad4
M5s_adf
M5s_ae0
    vmovups [rbp + rdx*8-64], zmm22
.s1nsek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
    jmp .s1ne
.s1nr:
M5s_a12
M5s_a34
M5s_a45
M5s_a55
M5s_a5e
.s1nb:
M5s_a5f
M5s_ae4
M5s_aea
    vmulps zmm22, zmm22, [r15 + Pc_w + 12]{1to16}
    vmovups [rbp + rdx*8-576], zmm22
.s1nbmk:
M5s_a71
M5s_a4f
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
    cmp rdx, r9
    jb .s1nb
M5s_a5f
M5s_ae4
M5s_aea
    vmulps zmm22, zmm22, [r15 + Pc_w + 12]{1to16}
    vmovups [rbp + rdx*8-576], zmm22
.s1nbfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_ae6
    vmulps zmm12, zmm12, [r15 + Pc_w + 12]{1to16}
    vmovups [rbp + rdx*8-512], zmm12
M5s_ae8
    vmovups [rbp + rdx*8-448], zmm16
M5s_ae9
    vmovups [rbp + rdx*8-384], zmm20
M5s_aeb
    vmovups [rbp + rdx*8-320], zmm22
.s1nbgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_ae6
    vmulps zmm12, zmm12, [r15 + Pc_w + 12]{1to16}
    vmovups [rbp + rdx*8-256], zmm12
M5s_ae8
    vmovups [rbp + rdx*8-192], zmm16
M5s_ae9
    vmovups [rbp + rdx*8-128], zmm20
M5s_aeb
    vmovups [rbp + rdx*8-64], zmm22
.s1nbek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
.s1ne:
    jmp .std
.stq:
M5s_af
M5s_a11
    mov eax, [r15 + Pc_n]
    test eax, eax
    jz .r0eq
    mov [rsp + 104], rax
    cmp dword [r15 + Pc_ci], 0
    jne .r0cq
M5s_a13
M5s_a1d
M5s_a23
    add r9, rdx
    xor r10d, r10d
    kmovw k1, [rsp + 256 + r10*2]
    vpmovzxwd zmm7{k1}{z}, [rdx]
M5s_a27
    vfmadd231ps zmm9, zmm3, [r14 + rdx*4+64]
    inc r10
M5s_a2f
    vfmadd231ps zmm6, zmm8, [c_xbcb]{1to16}
M5s_afd
M5s_a102
M5s_a40
M5s_a38
M5s_afd
M5s_a102
M5s_a45
M5s_a55
M5s_a5e
.r0sq:
M5s_a5f
M5s_a6e
    vmovups [r8 + rdi*2], zmm20
    vmovups [r8 + rcx], zmm22
.r0sqmk:
M5s_a73
M5s_a38
M5s_afd
M5s_a102
M5s_a45
M5s_a55
M5s_a5e
    cmp rdx, r9
    jb .r0sq
M5s_a5f
M5s_a6e
    vmovups [r8 + rdi*2], zmm20
    vmovups [r8 + rcx], zmm22
.r0sqfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a75
    vmovups [r8 + rcx], zmm22
.r0sqgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a6a
    vmovups [r8 + rcx], zmm22
.r0sqek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
    jmp .r0nq
.r0cq:
M5s_a13
M5s_a1d
M5s_a23
M5s_afb
M5s_a4a
M5s_a5a
    vmulps zmm15, zmm15, zmm17
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
.r0kq:
M5s_a5f
M5s_a7d
    vaddps zmm22, zmm22, [rbp + rdx*8-576]
    vmovups [r8 + rcx], zmm22
.r0kqmk:
M5s_a73
M5s_a38
M5s_afd
M5s_a102
M5s_a45
M5s_a55
M5s_a5e
    cmp rdx, r9
    jb .r0kq
M5s_a5f
M5s_a7d
    vaddps zmm22, zmm22, [rbp + rdx*8-576]
    vmovups [r8 + rcx], zmm22
.r0kqfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_a82
    vmovups [r8 + rcx], zmm22
.r0kqgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_a84
    vmovups [r8 + rcx], zmm22
.r0kqek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
.r0nq:
    dec qword [rsp + 104]
    jz .r0eq
.r0q:
M5s_a13
M5s_a1d
M5s_a23
M5s_afb
M5s_a4a
M5s_a5a
    vmulps zmm15, zmm15, zmm17
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
.r0bq:
M5s_a5f
M5s_a88
    vaddps zmm22, zmm22, [r8 + rcx]
    vmovups [r8 + rcx], zmm22
.r0bqmk:
M5s_a73
M5s_a38
M5s_afd
M5s_a102
M5s_a45
M5s_a55
M5s_a5e
    cmp rdx, r9
    jb .r0bq
M5s_a5f
M5s_a88
    vaddps zmm22, zmm22, [r8 + rcx]
    vmovups [r8 + rcx], zmm22
.r0bqfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_a89
    vmovups [r8 + rcx], zmm22
.r0bqgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_a89
    vmovups [r8 + rcx], zmm22
.r0bqek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
    dec qword [rsp + 104]
    jnz .r0q
.r0eq:
    cmp dword [r15 + Pc_n + 4], 0
    je .s01eq
    cmp dword [r15 + Pc_n], 0
    jne .s01rq
    cmp dword [r15 + Pc_ci], 0
    jne .s01cq
M5s_a13
M5s_a1d
M5s_a23
M5s_afb
M5s_a4a
M5s_a5a
    vmulps zmm15, zmm15, zmm17
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
.s01sq:
M5s_a5f
M5s_a90
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
    vmovups [r8 + rbx], zmm22
.s01sqmk:
M5s_a73
M5s_a38
M5s_afd
M5s_a102
M5s_a45
M5s_a55
M5s_a5e
    cmp rdx, r9
    jb .s01sq
M5s_a5f
M5s_a90
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
    vmovups [r8 + rbx], zmm22
.s01sqfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_a91
    vmovups [r8 + rbx], zmm22
.s01sqgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_a91
    vmovups [r8 + rbx], zmm22
.s01sqek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
    jmp .s01eq
.s01cq:
M5s_a13
M5s_a1d
M5s_a23
M5s_afb
M5s_a4a
M5s_a5a
    vmulps zmm15, zmm15, zmm17
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
.s01kq:
M5s_a5f
M5s_a9b
M5s_a9f
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
    vmovups [r8 + rbx], zmm22
.s01kqmk:
M5s_a73
M5s_a38
M5s_afd
M5s_a102
M5s_a45
M5s_a55
M5s_a5e
    cmp rdx, r9
    jb .s01kq
M5s_a5f
M5s_a9b
M5s_a9f
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
    vmovups [r8 + rbx], zmm22
.s01kqfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_aa5
M5s_aaa
    vmovups [r8 + rbx], zmm22
.s01kqgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_aab
M5s_aaf
    vmovups [r8 + rbx], zmm22
.s01kqek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
    jmp .s01eq
.s01rq:
M5s_a13
M5s_a1d
M5s_a23
M5s_afb
M5s_a4a
M5s_a5a
    vmulps zmm15, zmm15, zmm17
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
.s01bq:
M5s_a5f
M5s_ab1
M5s_ab8
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
    vmovups [r8 + rbx], zmm22
.s01bqmk:
M5s_a73
M5s_a38
M5s_afd
M5s_a102
M5s_a45
M5s_a55
M5s_a5e
    cmp rdx, r9
    jb .s01bq
M5s_a5f
M5s_ab1
M5s_ab8
    vmulps zmm22, zmm22, [r15 + Pc_w + 4]{1to16}
    vmovups [r8 + rbx], zmm22
.s01bqfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_ab2
M5s_ab4
    vmovups [r8 + rbx], zmm22
.s01bqgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_ab2
M5s_ab4
    vmovups [r8 + rbx], zmm22
.s01bqek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
.s01eq:
    mov eax, [r15 + Pc_n + 8]
    test eax, eax
    jz .r1eq
    mov [rsp + 104], rax
    cmp dword [r15 + Pc_n + 4], 0
    jne .r1q
M5s_a13
M5s_a1c
M5s_a22
    shl r9, 5
M5s_afb
M5s_a4a
M5s_a5a
    vmulps zmm15, zmm15, zmm17
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
.r1sq:
M5s_a5f
M5s_abe
    vmovups [r8 + rcx*2], zmm20
    vmovups [r8 + rbx], zmm22
.r1sqmk:
M5s_a73
M5s_a38
M5s_afd
M5s_a102
M5s_a45
M5s_a55
M5s_a5e
    cmp rdx, r9
    jb .r1sq
M5s_a5f
M5s_abe
    vmovups [r8 + rcx*2], zmm20
    vmovups [r8 + rbx], zmm22
.r1sqfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_abf
    vmovups [r8 + rbx], zmm22
.r1sqgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_abf
    vmovups [r8 + rbx], zmm22
.r1sqek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
    dec qword [rsp + 104]
    jz .r1eq
.r1q:
M5s_a13
M5s_a1c
M5s_a22
M5s_a145
M5s_a49
M5s_a59
.r1bq:
M5s_a5f
M5s_ac6
    vaddps zmm22, zmm22, [r8 + rbx]
    vmovups [r8 + rbx], zmm22
.r1bqmk:
M5s_a73
M5s_a38
M5s_afd
M5s_a102
M5s_a45
M5s_a55
M5s_a5e
    cmp rdx, r9
    jb .r1bq
M5s_a5f
M5s_ac6
    vaddps zmm22, zmm22, [r8 + rbx]
    vmovups [r8 + rbx], zmm22
.r1bqfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_ac7
    vmovups [r8 + rbx], zmm22
.r1bqgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_ac7
    vmovups [r8 + rbx], zmm22
.r1bqek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
    dec qword [rsp + 104]
    jnz .r1q
.r1eq:
    cmp dword [r15 + Pc_n + 12], 0
    je .s1neq
    mov eax, [r15 + Pc_n + 4]
    or eax, [r15 + Pc_n + 8]
    jnz .s1nrq
M5s_a13
M5s_a1d
M5s_a23
M5s_afb
M5s_a4a
M5s_a5a
    vmulps zmm15, zmm15, zmm17
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
.s1nsq:
M5s_a5f
M5s_ad2
    vmulps zmm22, zmm22, [r15 + Pc_w + 12]{1to16}
    vmovups [rbp + rdx*8-576], zmm22
.s1nsqmk:
M5s_a73
M5s_a38
M5s_afd
M5s_a102
M5s_a45
M5s_a55
M5s_a5e
    cmp rdx, r9
    jb .s1nsq
M5s_a5f
M5s_ad2
    vmulps zmm22, zmm22, [r15 + Pc_w + 12]{1to16}
    vmovups [rbp + rdx*8-576], zmm22
.s1nsqfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_ad4
M5s_ada
M5s_adc
    vmovups [rbp + rdx*8-320], zmm22
.s1nsqgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_ad4
M5s_adf
M5s_ae0
    vmovups [rbp + rdx*8-64], zmm22
.s1nsqek:
    mov rdx, [rsp + 48]
    add [rsp + 120], rdx
    jmp .s1neq
.s1nrq:
M5s_a13
M5s_a1d
M5s_a23
M5s_afb
M5s_a4a
M5s_a5a
    vmulps zmm15, zmm15, zmm17
    vfmsub213ps zmm18, zmm20, [c_one]{1to16}
    vmulps zmm19, zmm19, zmm21
.s1nbq:
M5s_a5f
M5s_ae4
M5s_aea
    vmulps zmm22, zmm22, [r15 + Pc_w + 12]{1to16}
    vmovups [rbp + rdx*8-576], zmm22
.s1nbqmk:
M5s_a73
M5s_a38
M5s_afd
M5s_a102
M5s_a45
M5s_a55
M5s_a5e
    cmp rdx, r9
    jb .s1nbq
M5s_a5f
M5s_ae4
M5s_aea
    vmulps zmm22, zmm22, [r15 + Pc_w + 12]{1to16}
    vmovups [rbp + rdx*8-576], zmm22
.s1nbqfk:
M5s_a72
M5s_a46
M5s_a56
M5s_a76
M5s_a62
M5s_a69
M5s_ae6
M5s_af0
    vmovups [rbp + rdx*8-320], zmm22
.s1nbqgk:
M5s_a72
M5s_a46
M5s_a56
M5s_a7b
M5s_a69
M5s_ae6
M5s_af4
M5s_a165
    jmp .sl0a
.se0a:
M5s_a176
    vmovdqu16 zmm1, [rdi + G_ms + 192]
M5s_a169
.sl1a:
    test r13, r13
    jz .se1a
    tzcnt rcx, r13
    blsr r13, r13
    movzx r14d, word [rdi + G_ms + 128 + rcx*2]
M5s_a16c
M5s_a170
    jmp .sl1a
.se1a:
M5s_a17b
    vptestmw k2, zmm0, zmm0
    kmovd r13d, k2
.slca:
    test r13d, r13d
    jz .seca
    tzcnt ecx, r13d
    blsr r13d, r13d
    movzx r14d, word [rdi + G_ms + 256 + rcx*2]
M5s_a16b
    add rsi, rbx
    vmovups zmm0, [rsi + 0]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [r10 + r11*4 + 327680], zmm0
    vmovups zmm0, [rsi + 64]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [r10 + r11*4 + 344064], zmm0
    vmovups zmm0, [rsi + 128]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [r10 + r11*4 + 360448], zmm0
    vmovups zmm0, [rsi + 192]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [r10 + r11*4 + 376832], zmm0
M5s_a171
    vpcompressd zmm0{k1}{z}, zmm0
    vmovups [r10 + r11*4 + 393216], zmm0
    add r11, r14
    jmp .slca
.seca:
M5s_a186
.nfa:
    mov rdi, [rsp + 8]
M5s_a188
M5s_a18b
    vmovups zmm20, [rcx + 0]
    vmovups zmm21, [rcx + 64]
    vmovups zmm22, [rcx + 128]
    vmovups zmm23, [rcx + 192]
    vmovups zmm24, [rcx + 256]
    vmovups zmm25, [rcx + 320]
    vmovups zmm31, [rcx + 384]
M5s_a18c
M5s_a18f
M5s_a194
    vmovups zmm15, [r8 + 448]
    vmovups zmm18, [r8 + 512]
    vmovups zmm19, [r8 + 576]
M5s_a197
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vmulps zmm4, zmm0, zmm20
M5s_a1a2
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm4, zmm0, zmm21
M5s_a1a7
M5s_a1ae
M5s_a1d6
    vmovups zmm1, [rdx + 3072]
M5s_a1fa
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm4, zmm0, [rcx + 576]
M5s_a1ff
    vmovups zmm18, [r8 + r14 + 512]
    vmovups zmm19, [r8 + r14 + 576]
M5s_a197
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vmulps zmm5, zmm0, zmm20
M5s_a1a2
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, zmm21
M5s_a1a7
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, zmm22
M5s_a1af
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, zmm23
M5s_a1bc
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, zmm24
M5s_a1c6
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, zmm25
M5s_a1d5
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, zmm31
M5s_a1de
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 448]
M5s_a1e8
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 512]
M5s_a1f4
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm5, zmm0, [rcx + 576]
M5s_a210
    vmovups zmm18, [r9 + 512]
    vmovups zmm19, [r9 + 576]
M5s_a197
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vmulps zmm6, zmm0, zmm20
M5s_a1a2
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, zmm21
M5s_a1a7
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, zmm22
M5s_a1af
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, zmm23
M5s_a1bc
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, zmm24
M5s_a1c6
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, zmm25
M5s_a1d5
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, zmm31
M5s_a1de
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 448]
M5s_a1e8
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 512]
M5s_a1f4
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm6, zmm0, [rcx + 576]
M5s_a224
    vmovups zmm18, [r9 + r14 + 512]
    vmovups zmm19, [r9 + r14 + 576]
M5s_a197
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vmulps zmm7, zmm0, zmm20
M5s_a1a2
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, zmm21
M5s_a1a7
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, zmm22
M5s_a1af
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, zmm23
M5s_a1bc
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, zmm24
M5s_a1c6
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, zmm25
M5s_a1d5
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, zmm31
M5s_a1de
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 448]
M5s_a1e8
    vpermi2ps zmm1, zmm18, zmm19
    vmovaps zmm0{k3}, zmm1
    vfmadd231ps zmm7, zmm0, [rcx + 512]
M5s_a1f4
M5s_a237
M5s_a242
    vmovups [r11 + r12*2 + 0], zmm3
    vaddps zmm8, zmm0, zmm2
    vaddps zmm9, zmm4, zmm6
    cmp qword [rsp + 40], 0
    jne .hf
M5s_a247
    vmovaps zmm26, zmm9
    lea r8, [r8 + r14*2]
    lea r9, [r9 + r14*2]
M5s_a192
M5s_a1ae
M5s_a1d6
M5s_a1f9
M5s_a1aa
M5s_a205
M5s_a1d7
M5s_a1dc
M5s_a20a
M5s_a212
M5s_a1b1
M5s_a21b
M5s_a1e1
M5s_a1e7
M5s_a221
M5s_a1a1
M5s_a229
M5s_a1c0
M5s_a1c5
M5s_a230
M5s_a1ea
M5s_a1f2
M5s_a236
    vmovups zmm1, [rdx + 3136]
M5s_a237
M5s_a24f
M5s_a25d
    jz .hx
.hu:
M5s_a192
M5s_a1ae
M5s_a1d6
M5s_a1f9
M5s_a1aa
M5s_a205
M5s_a1d7
M5s_a1dc
M5s_a20a
M5s_a212
M5s_a1b1
M5s_a21b
M5s_a1e1
M5s_a1e7
M5s_a221
M5s_a1a1
M5s_a229
M5s_a1c0
M5s_a1c5
M5s_a230
M5s_a1ea
M5s_a1f2
M5s_a235
M5s_a24b
M5s_a1ad
M5s_a1d4
M5s_a1f7
M5s_a1a8
M5s_a1ac
    vmovups zmm1, [rdx + 896]
M5s_a205
M5s_a1d7
M5s_a1dc
M5s_a20a
M5s_a212
M5s_a1b1
M5s_a21b
M5s_a1e1
M5s_a1e7
M5s_a221
M5s_a1a1
M5s_a229
M5s_a1c0
M5s_a1c5
M5s_a230
M5s_a1ea
M5s_a1f2
M5s_a236
M5s_a24d
M5s_a257
M5s_a25b
M5s_a264
    vfmadd231ps zmm6, zmm5, zmm17
M5s_a26f
M5s_a274
    vmulps zmm27{k3}, zmm21, zmm26
    vmulps zmm12{k1}, zmm6, zmm11
    vfmadd132ps zmm27, zmm18, zmm16
    vfmadd132ps zmm12, zmm18, zmm16
    vmovaps [rsi + 640 + 64], zmm20
M5s_a278
    kmovw [rsi + 448], k1
    vmovups zmm15, [rax + r14 + 64]
    vmovups zmm0, [rax + 64]
M5s_a26a
    vfmadd231ps zmm21, zmm20, zmm24
    vfmadd231ps zmm6, zmm5, zmm24
M5s_a26f
M5s_a274
    vmulps zmm27{k3}, zmm21, zmm26
M5s_a27b
    kmovw [rsi + 450], k1
    vmovups zmm15, [rax + r14 + 128]
    vmovups zmm0, [rax + 128]
M5s_a26a
    vfmadd231ps zmm21, zmm20, zmm25
    vfmadd231ps zmm6, zmm5, zmm25
M5s_a26f
M5s_a274
M5s_a27e
    vmulps zmm25, zmm24, [rsi + 640 + 256]
    vmulps zmm10, zmm9, [rsi + 256]
    vmovups zmm15, [rax + r14 + 0]
M5s_a28f
    vmovaps [rsi + 64], zmm9
    vmovaps [rsi + 640 + 256], zmm25
    vmovaps [rsi + 256], zmm10
    add rax, 256
    add rsi, 1280
    dec r12
    jnz .e20
    mov rax, r9
    lea rsi, [rsp + 4096]
    mov r12, [rsp + 80]
.e21:
    vmovaps zmm20, [rsi + 640 + 128]
    vmovaps zmm5, [rsi + 128]
M5s_a284
M5s_a287
M5s_a288
M5s_a292
    vmovups zmm15, [rax + r14 + 64]
M5s_a293
    vmovaps [rsi + 128], zmm9
    vmovaps [rsi + 640 + 320], zmm25
    vmovaps [rsi + 320], zmm10
    add rax, 256
    add rsi, 1280
    dec r12
    jnz .e21
    mov rax, r9
    lea rsi, [rsp + 4096]
    mov r12, [rsp + 80]
.e22:
    vmovaps zmm20, [rsi + 640 + 192]
    vmovaps zmm5, [rsi + 192]
M5s_a284
M5s_a287
M5s_a288
    kmovw k3, [rsi + 640 + 452]
    kmovw k1, [rsi + 452]
    vmulps zmm25, zmm24, [rsi + 640 + 384]
    vmulps zmm10, zmm9, [rsi + 384]
    vmovups zmm15, [rax + r14 + 128]
M5s_a299
    vmovaps [rsi + 192], zmm9
    vmovaps [rsi + 640 + 384], zmm25
    vmovaps [rsi + 384], zmm10
    add rax, 256
    add rsi, 1280
    dec r12
    jnz .e22
.e2e:
    mov rdi, [rsp + 8]
    mov rax, [rdi + G_su]
    shl rax, 2
    imul rax, [rsp + 40]
    mov rcx, [rdi + G_wo]
    shr rcx, 1
M5s_a266
    shr rdx, 2
    cmp rcx, rdx
    cmovg rcx, rdx
    mov [rsp + 168], rcx
    test rcx, rcx
    jle .cta
    mov rax, [rdi + G_cc]
    lea rsi, [rsp + 30976]
    lea r12, [rcx + 1]
    shr r12, 1
M5s_a267
    vbroadcastss zmm17, [rdi + G_crg + 0]
    vbroadcastss zmm24, [rdi + G_crg + 4]
    vbroadcastss zmm25, [rdi + G_crg + 8]
    vbroadcastss zmm18, [rdi + G_com + 0]
    vbroadcastss zmm28, [rdi + G_com + 4]
    vbroadcastss zmm29, [rdi + G_com + 8]
.ca1:
    vmovups zmm23, [rax + 256 + 192]
M5s_a268
    vsubps zmm5, zmm4, zmm8
    vrsqrt14ps zmm19, zmm20
    vrsqrt14ps zmm4, zmm5
    vbroadcastss zmm21, [rdi + G_csn]
    vbroadcastss zmm6, [rdi + G_csn]
    vfmadd213ps zmm19, zmm21, [rdi + G_can]{1to16}
    vfmadd213ps zmm4, zmm6, [rdi + G_can]{1to16}
    vfmadd213ps zmm19, zmm20, [rdi + G_cta]{1to16}
    vfmadd213ps zmm4, zmm5, [rdi + G_cta]{1to16}
    vmovups zmm15, [rax + 256 + 0]
M5s_a269
M5s_a275
M5s_a278
    kmovw [rsi + 448], k1
    vmovups zmm15, [rax + 256 + 64]
M5s_a279
M5s_a276
M5s_a27b
    kmovw [rsi + 450], k1
    vmovups zmm15, [rax + 256 + 128]
M5s_a27d
M5s_a276
M5s_a280
    kmovw [rsi + 452], k1
    add rax, 512
    add rsi, 1280
    dec r12
    jnz .ca1
    mov rdi, [rsp + 8]
    mov r9, [rdi + G_cc]
    mov r14, [rsp + 168]
    inc r14
    shr r14, 1
M5s_a282
    lea rsi, [rsp + 30976]
    mov r12, r14
.c20:
M5s_a283
    vmulps zmm25, zmm24, [rsi + 640 + 256]
    vmulps zmm10, zmm9, [rsi + 256]
    vmovups zmm15, [rax + 256 + 0]
M5s_a28f
    vmovaps [rsi + 64], zmm9
    vmovaps [rsi + 640 + 256], zmm25
    vmovaps [rsi + 256], zmm10
    add rax, 512
    add rsi, 1280
    dec r12
    jnz .c20
    mov rax, r9
    lea rsi, [rsp + 30976]
    mov r12, r14
.c21:
M5s_a290
    vmulps zmm25, zmm24, [rsi + 640 + 320]
    vmulps zmm10, zmm9, [rsi + 320]
    vmovups zmm15, [rax + 256 + 64]
M5s_a293
    vmovaps [rsi + 128], zmm9
    vmovaps [rsi + 640 + 320], zmm25
    vmovaps [rsi + 320], zmm10
    add rax, 512
    add rsi, 1280
    dec r12
    jnz .c21
    mov rax, r9
    lea rsi, [rsp + 30976]
    mov r12, r14
.c22:
M5s_a298
    vmulps zmm25, zmm24, [rsi + 640 + 384]
    vmulps zmm10, zmm9, [rsi + 384]
    vmovups zmm15, [rax + 256 + 128]
M5s_a299
    vmovaps [rsi + 192], zmm9
    vmovaps [rsi + 640 + 384], zmm25
    vmovaps [rsi + 384], zmm10
    add rax, 512
    add rsi, 1280
    dec r12
    jnz .c22
.cta:
M5s_a2a8
    add rsi, 1280
    add r10, 2
    add r11, 16
    dec r9
    jnz .ed
.edt:
    mov eax, ebx
    sub rax, r11
    mov ecx, 0
M5s_a6
    cmova rax, rcx
    mov ecx, 0xffff
    bzhi ecx, ecx, eax
    kmovw k7, ecx
M5s_a2ac
M5s_a2ad
M5s_a2ae
    vpmaxsd zmm21, zmm25, zmm8
    vpmaxsd zmm6, zmm10, zmm8
    vpmovdw [r8]{k7}, zmm6
    vpmovdw [r8 + r13]{k7}, zmm21
    kandw k1, k1, k7
    kandw k3, k3, k7
    kmovw [r10], k1
    kmovw [r10 + 128], k3
.ete:
    mov rdi, [rsp + 8]
    cmp qword [rsp + 168], 0
    jle .cie
    mov r11, [rdi + G_su]
    shl r11, 2
    imul r11, [rsp + 40]
    mov rbx, [rdi + G_wo]
    shr rbx, 1
    mov rax, [rsp + 16]
    imul rax, rbx
M5s_a2b5
    vfmsub231ps zmm5, zmm29, [rsi + 64]
    vmovaps zmm21, zmm14
    vmovaps zmm6, zmm14
    vfmadd231ps zmm21, zmm31, [rsi + 640 + 384]
    vfmadd231ps zmm6, zmm31, [rsi + 384]
    vfmadd231ps zmm21, zmm30, [rsi + 640 + 320]
    vfmadd231ps zmm6, zmm30, [rsi + 320]
    vfmadd231ps zmm21, zmm29, [rsi + 640 + 256]
    vfmadd231ps zmm6, zmm29, [rsi + 256]
M5s_a2bc
    vaddps zmm25, zmm25, zmm21
    vaddps zmm10, zmm10, zmm6
    vcmpps k4, zmm25, zmm2, 0x15
    vcmpps k2, zmm10, zmm2, 0x15
M5s_a2bd
M5s_a2c4
    korw k3, k3, k4
    korw k1, k1, k2
    vpmovdw [r8], zmm7
    vpmovdw [r14], zmm8
    vpmovdw [r8 + 32], zmm22
    vpmovdw [r14 + 32], zmm23
    kmovw [r10], k1
    kmovw [r10 + 2], k3
    add r8, 64
    add r14, 64
    add rsi, 1280
    add r10, 4
    add r11, 32
    sub r9, 2
    cmp r9, 2
    ja .ci
.cit:
    cmp r9, 2
    jb .c1
M5s_a2b1
    mov ecx, 0xffff
    bzhi ecx, ecx, eax
    kmovw k5, ecx
    mov eax, ebx
    sub rax, r11
    sub rax, 16
M5s_a2b2
    kmovw k6, ecx
M5s_a2b9
    korw k3, k3, k4
    korw k1, k1, k2
    vpmovdw [r8]{k5}, zmm7
    vpmovdw [r14]{k5}, zmm8
    vpmovdw [r8 + 32]{k6}, zmm22
    vpmovdw [r14 + 32]{k6}, zmm23
    kandw k1, k1, k5
    kandw k3, k3, k6
    kmovw [r10], k1
    kmovw [r10 + 2], k3
    jmp .cie
.c1:
M5s_a2b1
    mov ecx, 0xffff
    bzhi ecx, ecx, eax
    kmovw k5, ecx
    vmulps zmm4, zmm27, [rsi + 64]
    vfmadd231ps zmm4, zmm28, [rsi + 128]
    vmovaps zmm5, zmm4
    vfmsub231ps zmm5, zmm26, [rsi + 192]
    vmovaps zmm6, zmm13
    vfmadd231ps zmm6, zmm27, [rsi + 256]
    vfmadd231ps zmm6, zmm28, [rsi + 320]
    vfmadd231ps zmm6, zmm26, [rsi + 384]
    vreduceps zmm10, zmm5, 8
    vandps zmm10, zmm10, zmm1
    vaddps zmm10, zmm10, zmm6
    vcmpps k1, zmm10, zmm2, 0x15
    vcvtps2dq zmm10, zmm5, {rn-sae}
    vpaddd zmm10, zmm10, zmm3
    vpminsd zmm10, zmm10, zmm11
    vpmaxsd zmm7, zmm10, zmm12
    vmulps zmm4, zmm31, [rsi + 192]
    vfmadd231ps zmm4, zmm30, [rsi + 128]
    vmovaps zmm5, zmm4
    vfmsub231ps zmm5, zmm29, [rsi + 64]
    vmovaps zmm6, zmm14
    vfmadd231ps zmm6, zmm31, [rsi + 384]
    vfmadd231ps zmm6, zmm30, [rsi + 320]
    vfmadd231ps zmm6, zmm29, [rsi + 256]
    vreduceps zmm10, zmm5, 8
    vandps zmm10, zmm10, zmm1
    vaddps zmm10, zmm10, zmm6
    vcmpps k2, zmm10, zmm2, 0x15
    vcvtps2dq zmm10, zmm5, {rn-sae}
    vpaddd zmm10, zmm10, zmm3
    vpminsd zmm10, zmm10, zmm11
    vpmaxsd zmm8, zmm10, zmm12
    korw k1, k1, k2
    vpmovdw [r8]{k5}, zmm7
    vpmovdw [r14]{k5}, zmm8
    kandw k1, k1, k5
    kmovw [r10], k1
.cie:
    inc qword [rsp + 40]
    mov rax, [rsp + 40]
    mov rdi, [rsp + 8]
    cmp rax, [rdi + G_nst]
    jb .str
M5s_a167
    kortestw k1, k1
    jz .nfb
M5s_a168
    kunpckdq k2, k3, k2
    kmovq r13, k2
.sl0b:
    test r13, r13
    jz .se0b
M5s_a16a
M5s_a16f
    vpcompressd zmm0{k1}{z}, zmm0
    vmovups [r10 + r11*4 + 262144], zmm0
    add r11, r14
    jmp .sl0b
.se0b:
M5s_a176
M5s_a179
    kmovq r13, k2
.sl1b:
    test r13, r13
    jz .se1b
M5s_a17a
M5s_a16f
    vpcompressd zmm0{k1}{z}, zmm0
    vmovups [r10 + r11*4 + 262144], zmm0
    add r11, r14
    jmp .sl1b
.se1b:
M5s_a17b
    vptestmw k2, zmm0, zmm0
    kmovd r13d, k2
.slcb:
    test r13d, r13d
    jz .secb
M5s_a17d
M5s_a183
    vpcompressd zmm0{k1}{z}, zmm0
    vmovups [r10 + r11*4 + 393216], zmm0
    add r11, r14
    jmp .slcb
.secb:
M5s_a186
.nfb:
    mov rax, [rsp + 152]
    or rax, [rsp + 184]
    jz .nz
    mov rdi, [rsp + 8]
    xor r13d, r13d
    xor r15d, r15d
    mov rcx, [rsp + 152]
    test rcx, rcx
    jz .uxl
    mov rsi, [rdi + G_sg]
.ubl:
M5s_a2d4
    call .t1l
    vmovdqa64 [rsp + 384], zmm4
.ujl:
    mov r11d, [rsi + r9*4 + 262144]
    mov rax, [rsp + 384 + r9*8]
    test rax, rax
    js .ufl
    mov r12d, r11d
    shr r12d, 16
    movzx r11d, r11w
    imul r12, [rdi + G_wo]
    add r12, r11
    mov r14, [rdi + G_dy]
    mov [r14 + r12*2], ax
    jmp .ukl
.ufl:
    mov r14, [rdi + G_sg]
    mov [r14 + r13*4 + 409600], r11d
    inc r13
.ukl:
    inc r9
    cmp r9, r8
    jb .ujl
    add rsi, 32
    sub rcx, 8
    jg .ubl
.uxl:
    mov rcx, [rsp + 184]
    test rcx, rcx
    jz .uxc
    mov rsi, [rdi + G_sg]
    add rsi, 327680
.ubc:
M5s_a2d4
M5s_a2d5
    jmp .u2l
.u3l:
    mov qword [rsp + 128], 0
.u2c:
    mov rax, [rsp + 128]
    cmp rax, [rsp + 144]
    jae .u3c
    mov rdi, [rsp + 8]
    mov rcx, [rdi + G_sg]
    mov edx, [rcx + rax*4 + 475136]
    mov qword [rsp + 1216], 1
M5s_a2d6
    mov [rsp + 1232], rdx
    call .t2
    test eax, eax
    jns .tq2
    call .t3
.tq2:
    mov rdi, [rsp + 8]
    mov rdx, [rdi + G_wo]
    shr rdx, 1
    imul rdx, [rsp + 1224]
    add rdx, [rsp + 1232]
    mov rcx, [rdi + G_db]
    mov [rcx + rdx*2], ax
    shr eax, 16
    mov rcx, [rdi + G_dr]
    mov [rcx + rdx*2], ax
    inc qword [rsp + 128]
    jmp .u2c
.u3c:
.nz:
    mov r15, [rsp + 64]
    add r15, PCS
    inc qword [rsp + 16]
    mov rax, [rsp + 16]
    cmp rax, [rsp + 24]
    jb .per
    mov rsp, [rsp + 0]
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    vzeroupper
    ret
.pf32:
    prefetcht0 [r9 + 1984]
.pf31:
    prefetcht0 [r9 + 1920]
.pf30:
    prefetcht0 [r9 + 1856]
.pf29:
    prefetcht0 [r9 + 1792]
.pf28:
    prefetcht0 [r9 + 1728]
.pf27:
M5s_a2db
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm2, [rdi + G_drg + 0]{1to8}
M5s_a2e4
M5s_a2f7
    vmovapd zmm16{k3}, zmm9
    vmovapd zmm17{k3}, zmm12
    vcvtps2pd zmm0, [rsi + 65536]
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm2, [rdi + G_drg + 8]{1to8}
M5s_a2e5
M5s_a2ef
M5s_a2f3
M5s_a2f8
M5s_a2fd
    vmovapd zmm18{k3}, zmm9
    vmovapd zmm19{k3}, zmm12
    vcvtps2pd zmm0, [rsi + 131072]
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm2, [rdi + G_drg + 16]{1to8}
M5s_a2e5
M5s_a2ef
M5s_a2f3
M5s_a2fe
M5s_a302
    vmovapd zmm20{k3}, zmm9
    vmovapd zmm21{k3}, zmm12
    vbroadcastsd zmm0, [rdi + G_dlo]
    vfmadd231pd zmm0, zmm16, [rdi + G_dmx + 0]{1to8}
    vfmadd231pd zmm0, zmm18, [rdi + G_dmx + 8]{1to8}
    vfmadd231pd zmm0, zmm20, [rdi + G_dmx + 16]{1to8}
    vbroadcastsd zmm2, [rdi + G_dhi]
    vfmadd231pd zmm2, zmm17, [rdi + G_dmx + 0]{1to8}
    vfmadd231pd zmm2, zmm19, [rdi + G_dmx + 8]{1to8}
    vfmadd231pd zmm2, zmm21, [rdi + G_dmx + 16]{1to8}
M5s_a309
    vpmaxsq zmm0, zmm0, zmm3
    vpternlogq zmm4, zmm4, zmm4, 0xff
    vpminsq zmm4{k1}, zmm0, [t_q1023]{1to8}
    ret
.t1c:
    vcvtps2pd zmm15, [rsi + 49152]
    vbroadcastsd zmm14, [t_epsn]
    vsubpd zmm14, zmm14, zmm15
    vrsqrt14pd zmm13, zmm14
    vbroadcastsd zmm12, [rdi + G_esn]
    vfmadd213pd zmm13, zmm12, [rdi + G_ean]{1to8}
    vfmadd213pd zmm13, zmm14, [rdi + G_eta]{1to8}
M5s_a2df
    vfmadd231pd zmm3, zmm2, [rdi + G_erg + 0]{1to8}
M5s_a2e4
M5s_a2f7
    vmovapd zmm16{k3}, zmm9
    vmovapd zmm17{k3}, zmm12
    vcvtps2pd zmm0, [rsi + 16384]
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm2, [rdi + G_erg + 8]{1to8}
M5s_a2e5
M5s_a2ef
M5s_a2f3
M5s_a2f8
M5s_a2fd
    vmovapd zmm18{k3}, zmm9
    vmovapd zmm19{k3}, zmm12
    vcvtps2pd zmm0, [rsi + 32768]
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm2, [rdi + G_erg + 16]{1to8}
M5s_a2e5
M5s_a2ef
M5s_a2f3
M5s_a2fe
M5s_a302
    vmovapd zmm20{k3}, zmm9
    vmovapd zmm21{k3}, zmm12
    vbroadcastsd zmm0, [rdi + G_elo]
    vfnmadd231pd zmm0, zmm19, [rdi + G_emx + 16]{1to8}
    vfnmadd231pd zmm0, zmm17, [rdi + G_emx + 8]{1to8}
    vfmadd231pd zmm0, zmm20, [rdi + G_emx + 0]{1to8}
    vbroadcastsd zmm2, [rdi + G_ehi]
    vfnmadd231pd zmm2, zmm18, [rdi + G_emx + 16]{1to8}
    vfnmadd231pd zmm2, zmm16, [rdi + G_emx + 8]{1to8}
    vfmadd231pd zmm2, zmm21, [rdi + G_emx + 0]{1to8}
M5s_a309
    vpmaxsq zmm0, zmm0, zmm3
    vpternlogq zmm4, zmm4, zmm4, 0xff
    vpminsq zmm4{k1}, zmm0, [t_q1023]{1to8}
    vbroadcastsd zmm0, [rdi + G_elo + 8]
    vfnmadd231pd zmm0, zmm21, [rdi + G_emx + 40]{1to8}
    vfnmadd231pd zmm0, zmm19, [rdi + G_emx + 32]{1to8}
    vfmadd231pd zmm0, zmm16, [rdi + G_emx + 24]{1to8}
    vbroadcastsd zmm2, [rdi + G_ehi + 8]
    vfnmadd231pd zmm2, zmm20, [rdi + G_emx + 40]{1to8}
    vfnmadd231pd zmm2, zmm18, [rdi + G_emx + 32]{1to8}
    vfmadd231pd zmm2, zmm17, [rdi + G_emx + 24]{1to8}
M5s_a309
    vpmaxsq zmm0, zmm0, zmm3
    vpternlogq zmm5, zmm5, zmm5, 0xff
    vpminsq zmm5{k1}, zmm0, [t_q1023]{1to8}
    vpternlogq zmm7, zmm7, zmm7, 0xff
    vpcmpeqq k1, zmm5, zmm7
    vmovdqa64 zmm4{k1}, zmm7
    ret
.t2:
    lea r15, [rsp + 8 + 512]
    mov rdi, [rsp + 8 + 8]
    vpxorq zmm0, zmm0, zmm0
    vmovapd [r15 + 256], zmm0
    vmovapd [r15 + 320], zmm0
M5s_a310
    test rcx, rcx
    jnz .t2c
M5s_a314
    lea rsi, [rdx + 1]
    jmp .t2g
.t2c:
    lea r12, [rax*4 - 1]
    xor ebx, ebx
    test rax, rax
    jnz .t2d
M5s_a315
M5s_a322
    jb .t2x
    call .t2b
    mov qword [r15 + 688], 0
.t2x:
    inc r14
    jmp .t2j
.t2n:
    inc qword [r15 + 696]
    jmp .t2y
.t2f:
    cmp qword [r15 + 688], 0
    je .t2e
    call .t2b
.t2e:
    vcvtusi2sd xmm0, xmm0, qword [r15 + 680]
    vmovsd xmm1, [t_one]
    vdivsd xmm9, xmm1, xmm0
    vpxorq zmm0, zmm0, zmm0
    vmovapd [r15 + 384], zmm0
    vbroadcastsd zmm1, [t_tab]
    vmovapd [r15 + 448], zmm1
    vmovsd xmm2, [r15 + 320]
    vmulsd xmm2, xmm2, xmm9
    vmovsd [r15 + 384], xmm2
    vandpd xmm3, xmm2, [t_abs2]
    vxorpd xmm3, xmm3, [t_sgn2]
    vmovsd xmm4, [r15 + 256]
    vfmadd132sd xmm4, xmm3, xmm9
    vmovsd xmm5, [t_tab]
    vfmadd132sd xmm4, xmm5, [t_rg2]
    vmovsd [r15 + 448], xmm4
    vmovsd xmm2, [r15 + 328]
    vmulsd xmm2, xmm2, xmm9
    vmovsd [r15 + 392], xmm2
    vandpd xmm3, xmm2, [t_abs2]
    vxorpd xmm3, xmm3, [t_sgn2]
    vmovsd xmm4, [r15 + 264]
    vfmadd132sd xmm4, xmm3, xmm9
    vmovsd xmm5, [t_tab]
    vfmadd132sd xmm4, xmm5, [t_rg2]
    vmovsd [r15 + 456], xmm4
    vmovsd xmm2, [r15 + 336]
    vmulsd xmm2, xmm2, xmm9
    vmovsd [r15 + 400], xmm2
    vandpd xmm3, xmm2, [t_abs2]
    vxorpd xmm3, xmm3, [t_sgn2]
    vmovsd xmm4, [r15 + 272]
    vfmadd132sd xmm4, xmm3, xmm9
    vmovsd xmm5, [t_tab]
    vfmadd132sd xmm4, xmm5, [t_rg2]
    vmovsd [r15 + 464], xmm4
    vmovapd zmm0, [r15 + 384]
    vmovapd zmm15, [r15 + 448]
    vbroadcastsd zmm1, [t_rg2]
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm1, zmm2
M5s_a2e5
M5s_a2ef
M5s_a2f3
    vmulpd zmm7{k1}{z}, zmm3, zmm7
    vbroadcastsd zmm11, [t_omg]
    vfmadd132pd zmm7, zmm11, [t_eq0]{1to8}
    vmovapd zmm8, zmm6
    vfmadd231pd zmm8, zmm7, zmm6
    vpxorq zmm9, zmm8, [t_sign]{1to8}
    vmovapd zmm10, zmm6
    vfnmadd231pd zmm10{k1}{z}, zmm7, zmm6
    vcmppd k2, zmm4, [t_zero]{1to8}, 0x1a
    vmovapd zmm10{k2}, zmm9
    vpxorq zmm12, zmm10, [t_sign]{1to8}
    vpmovq2m k3, zmm0
    vmovapd zmm10{k3}, zmm9
    vmovapd zmm8{k3}, zmm12
    vmovapd [r15 + 512], zmm10
    vmovapd [r15 + 576], zmm8
    cmp qword [rsp + 8 + 1216], 0
    jne .t2h
    vmovsd xmm0, [t_ylo]
    vmovsd xmm1, [t_emc0]
    vfmadd231sd xmm0, xmm1, [r15 + 512]
    vmovsd xmm1, [t_emc1]
    vfmadd231sd xmm0, xmm1, [r15 + 512 + 8]
    vmovsd xmm1, [t_emc2]
    vfmadd231sd xmm0, xmm1, [r15 + 512 + 16]
    vmovsd xmm2, [t_yhi]
    vmovsd xmm1, [t_emc0]
    vfmadd231sd xmm2, xmm1, [r15 + 576]
    vmovsd xmm1, [t_emc1]
    vfmadd231sd xmm2, xmm1, [r15 + 576 + 8]
    vmovsd xmm1, [t_emc2]
M5s_a335
    ret
.t2h:
    vmovsd xmm0, [t_clo]
    vmovsd xmm1, [t_emc5]
    vfnmadd231sd xmm0, xmm1, [r15 + 576 + 8]
    vmovsd xmm1, [t_emc4]
    vfnmadd231sd xmm0, xmm1, [r15 + 576]
    vmovsd xmm1, [t_emc3]
    vfmadd231sd xmm0, xmm1, [r15 + 512 + 16]
    vmovsd xmm2, [t_chi]
    vmovsd xmm1, [t_emc5]
    vfnmadd231sd xmm2, xmm1, [r15 + 512 + 8]
    vmovsd xmm1, [t_emc4]
    vfnmadd231sd xmm2, xmm1, [r15 + 512]
    vmovsd xmm1, [t_emc3]
M5s_a335
    mov r8d, eax
    vmovsd xmm0, [t_clo]
    vmovsd xmm1, [t_emc8]
    vfnmadd231sd xmm0, xmm1, [r15 + 576 + 16]
    vmovsd xmm1, [t_emc7]
    vfnmadd231sd xmm0, xmm1, [r15 + 576 + 8]
    vmovsd xmm1, [t_emc6]
    vfmadd231sd xmm0, xmm1, [r15 + 512]
    vmovsd xmm2, [t_chi]
    vmovsd xmm1, [t_emc8]
    vfnmadd231sd xmm2, xmm1, [r15 + 512 + 16]
    vmovsd xmm1, [t_emc7]
    vfnmadd231sd xmm2, xmm1, [r15 + 512 + 8]
    vmovsd xmm1, [t_emc6]
    vfmadd231sd xmm2, xmm1, [r15 + 576]
M5s_a336
M5s_a33b
    cmp rax, rcx
    cmovne edx, esi
    mov eax, edx
    mov ecx, eax
    or ecx, r8d
    shl eax, 16
    or eax, r8d
    test ecx, ecx
    mov ecx, -1
    cmovs eax, ecx
    ret
.t2b:
M5s_a340
    kmovb k4, eax
    vmovapd zmm0{k4}{z}, [r15 + 0]
    vmovapd zmm1{k4}{z}, [r15 + 64]
    vmovapd zmm2{k4}{z}, [r15 + 128]
    vbroadcastsd zmm3, [t_lzm5]
    vfmadd231pd zmm3, zmm0, [t_lzm0]{1to8}
    vmovapd zmm4, zmm3
    vfmadd231pd zmm4, zmm2, [t_lzm1]{1to8}
    vmovapd zmm5, zmm3
    vfmadd231pd zmm5, zmm2, [t_lzm2]{1to8}
    vfmadd231pd zmm5, zmm1, [t_lzm3]{1to8}
    vmovapd zmm6, zmm3
    vfmadd231pd zmm6, zmm1, [t_lzm4]{1to8}
    vmovapd zmm14{k4}{z}, [r15 + 192]
    vrangepd zmm7, zmm4, [t_xflr]{1to8}, 0x0b
M5s_a341
M5s_a346
    vmovdqa64 zmm9, zmm7
    vpternlogq zmm9, zmm4, [t_sign]{1to8}, 0xd8
M5s_a347
M5s_a34b
    vaddsd xmm9, xmm9, xmm11
    vaddsd xmm10, xmm8, [r15 + 256]
    vmovsd [r15 + 256], xmm10
    vaddsd xmm11, xmm9, [r15 + 320]
    vmovsd [r15 + 320], xmm11
    vrangepd zmm7, zmm5, [t_xflr]{1to8}, 0x0b
M5s_a341
M5s_a346
    vmovdqa64 zmm9, zmm7
    vpternlogq zmm9, zmm5, [t_sign]{1to8}, 0xd8
M5s_a347
M5s_a34b
    vaddsd xmm9, xmm9, xmm11
    vaddsd xmm10, xmm8, [r15 + 264]
    vmovsd [r15 + 264], xmm10
    vaddsd xmm11, xmm9, [r15 + 328]
    vmovsd [r15 + 328], xmm11
    vrangepd zmm7, zmm6, [t_xflr]{1to8}, 0x0b
M5s_a341
M5s_a346
    vmovdqa64 zmm9, zmm7
    vpternlogq zmm9, zmm6, [t_sign]{1to8}, 0xd8
M5s_a347
M5s_a34b
    vaddsd xmm9, xmm9, xmm11
    vaddsd xmm10, xmm8, [r15 + 272]
    vmovsd [r15 + 272], xmm10
    vaddsd xmm11, xmm9, [r15 + 336]
    vmovsd [r15 + 336], xmm11
    ret
T_LN equ 0
T_SY equ 192
T_SB equ 256
T_SR equ 320
T_SW equ 384
T_V equ 448
T_X equ 832
T_ACC equ 1216
T_E equ 1344
.t3:
    lea r10, [rsp + 8 + 2048]
    lea r15, [rsp + 8 + 512]
    mov rdi, [rsp + 8 + 8]
    vpxorq zmm0, zmm0, zmm0
    vmovapd [r10 + T_ACC], zmm0
    vmovapd [r10 + T_ACC + 64], zmm0
M5s_a310
    test rcx, rcx
    jnz .t3c
M5s_a314
    lea rsi, [rdx + 1]
    jmp .t3g
.t3c:
    lea r12, [rax*4 - 1]
    xor ebx, ebx
    test rax, rax
    jnz .t3d
    xor r12d, r12d
    mov ebx, 1
.t3d:
    lea r13, [rax*4 + 3]
    lea r14, [rdx + rdx]
    lea rsi, [r14 + 2]
.t3g:
M5s_a319
    mov [r15 + 672], rbx
M5s_a31a
    mov [r15 + 696], rax
    lea r10, [rsp + 8 + 2048]
.t3y:
M5s_a31b
    jae .t3f
M5s_a31c
M5s_a31d
    vmovups xmm15, [rbx + Rc_k]
    vmovups [r15 + 784], xmm15
M5s_a31e
    mov r14, rax
.t3j:
    mov rax, r14
    imul rax, r9
    cmp rax, [r15 + 648]
    jae .t3n
M5s_a321
    sub rdx, rcx
    cmp qword [r15 + 672], 0
    je .t3w
M5s_a326
.t3w:
    imul rdx, [r15 + 736]
    mov rsi, [r15 + 688]
    vcvtusi2sd xmm0, xmm0, rdx
    vmovsd [r10 + T_SW + rsi*8], xmm0
    mov rcx, [r15 + 776]
    movzx eax, word [rcx + r14*2]
    vcvtsi2sd xmm0, xmm0, eax
    vmovsd [r10 + T_SY + rsi*8], xmm0
M5s_a327
    and ecx, 15
    lea rax, [rax + rcx*4]
    add rax, [rdi + G_cr]
    vmovups xmm15, [r15 + 784]
M5s_a328
M5s_a329
    vmovsd [r10 + T_SB + rsi*8], xmm0
M5s_a32a
M5s_a32c
M5s_a353
M5s_a359
M5s_a363
.t3h:
M5s_a355
M5s_a35e
M5s_a35f
M5s_a369
M5s_a36d
    vaddsd xmm13, xmm8, xmm9
    vsubsd xmm3, xmm13, xmm8
    vsubsd xmm3, xmm9, xmm3
    vaddsd xmm9, xmm3, xmm15
    vaddsd xmm15, xmm13, xmm9
    vcmpsd xmm6, xmm15, [t_half], 0x1e
    vandpd xmm6, xmm6, [t_one2]
    vcmpsd xmm11, xmm15, [t_mhalf], 0x11
    vandpd xmm11, xmm11, [t_one2]
    vaddsd xmm7, xmm7, xmm6
    vsubsd xmm7, xmm7, xmm11
    vcvttsd2si eax, xmm7
M5s_a364
    cmp eax, ecx
    cmovg eax, ecx
    mov [r10 + T_E + 144], eax
    vmovsd xmm0, [r10 + T_E + 128]
    vmovsd xmm1, [r10 + T_E + 136]
    vroundsd xmm2, xmm0, xmm0, 8
    vsubsd xmm3, xmm0, xmm2
    vxorpd xmm4, xmm4, xmm4
    vaddsd xmm5, xmm3, xmm1
    vsubsd xmm6, xmm5, xmm3
    vsubsd xmm7, xmm5, xmm6
    vsubsd xmm7, xmm3, xmm7
    vsubsd xmm6, xmm1, xmm6
    vaddsd xmm7, xmm7, xmm6
    vaddsd xmm6, xmm4, xmm4
    vsubsd xmm8, xmm6, xmm4
    vsubsd xmm9, xmm6, xmm8
    vsubsd xmm9, xmm4, xmm9
    vsubsd xmm8, xmm4, xmm8
    vaddsd xmm9, xmm9, xmm8
    vaddsd xmm8, xmm7, xmm6
    vaddsd xmm6, xmm5, xmm8
    vsubsd xmm7, xmm6, xmm5
    vsubsd xmm7, xmm8, xmm7
    vaddsd xmm8, xmm7, xmm9
    vaddsd xmm9, xmm6, xmm8
    vcmpsd xmm4, xmm9, [t_half], 0x1e
    vandpd xmm4, xmm4, [t_one2]
    vcmpsd xmm3, xmm9, [t_mhalf], 0x11
    vandpd xmm3, xmm3, [t_one2]
    vaddsd xmm2, xmm2, xmm4
    vsubsd xmm2, xmm2, xmm3
    vcvttsd2si eax, xmm2
M5s_a364
    cmp eax, ecx
    cmovg eax, ecx
    shl eax, 16
    or eax, [r10 + T_E + 144]
    ret
.t3b:
M5s_a340
    kmovb k5, eax
M5s_a375
M5s_a379
M5s_a37d
M5s_a382
M5s_a391
M5s_a39c
    vmovsd xmm2, [r10 + T_X + 48]
    vmovsd xmm1, [r10 + T_X + 112]
M5s_a3ab
M5s_a3ad
M5s_a3ae
    vaddsd xmm0, xmm7, xmm2
    vsubsd xmm1, xmm0, xmm7
    vsubsd xmm1, xmm2, xmm1
    vmovsd xmm9, [r10 + T_X + 56]
    vmovsd xmm3, [r10 + T_X + 120]
    vmovsd xmm4, [r10 + T_SW + 56]
    vxorpd xmm5, xmm5, xmm5
    vmulsd xmm2, xmm9, xmm4
    vmovapd xmm7, xmm2
    vfmsub231sd xmm7, xmm9, xmm4
    vmulsd xmm8, xmm3, xmm4
    vfmadd231sd xmm8, xmm9, xmm5
    vaddsd xmm7, xmm7, xmm8
    vaddsd xmm8, xmm2, xmm7
    vsubsd xmm6, xmm8, xmm2
    vsubsd xmm6, xmm7, xmm6
M5s_a386
    vsubsd xmm4, xmm8, xmm4
M5s_a3b0
M5s_a3b1
    vaddsd xmm7, xmm4, xmm9
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm9, xmm3
    vmovsd [r10 + T_ACC + 0], xmm7
    vmovsd [r10 + T_ACC + 64], xmm3
    vmovsd xmm0, [r10 + T_ACC + 8]
    vmovsd xmm1, [r10 + T_ACC + 72]
    vmovsd xmm2, [r10 + T_X + 128]
    vmovsd xmm3, [r10 + T_X + 192]
M5s_a381
M5s_a387
M5s_a388
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm2, xmm3
    vmovsd xmm9, [r10 + T_X + 136]
    vmovsd xmm8, [r10 + T_X + 200]
M5s_a389
M5s_a38a
M5s_a38d
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [r10 + T_X + 144]
    vmovsd xmm5, [r10 + T_X + 208]
M5s_a390
M5s_a395
M5s_a396
    vaddsd xmm1, xmm3, xmm6
    vsubsd xmm5, xmm1, xmm3
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [r10 + T_X + 152]
    vmovsd xmm0, [r10 + T_X + 216]
M5s_a397
M5s_a398
M5s_a399
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm0, xmm3, xmm8
    vsubsd xmm0, xmm2, xmm0
    vmovsd xmm9, [r10 + T_X + 160]
    vmovsd xmm7, [r10 + T_X + 224]
M5s_a39d
M5s_a3a1
M5s_a3a2
    vaddsd xmm8, xmm5, xmm9
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm7, xmm9, xmm7
    vmovsd xmm6, [r10 + T_X + 168]
    vmovsd xmm4, [r10 + T_X + 232]
M5s_a3a3
M5s_a3a4
M5s_a3a5
    vaddsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm5, xmm0
    vsubsd xmm4, xmm6, xmm4
    vmovsd xmm2, [r10 + T_X + 176]
    vmovsd xmm1, [r10 + T_X + 240]
M5s_a3ab
M5s_a3ad
M5s_a3ae
    vaddsd xmm0, xmm7, xmm2
    vsubsd xmm1, xmm0, xmm7
    vsubsd xmm1, xmm2, xmm1
    vmovsd xmm9, [r10 + T_X + 184]
    vmovsd xmm3, [r10 + T_X + 248]
M5s_a3af
M5s_a3b0
M5s_a3b1
    vaddsd xmm7, xmm4, xmm9
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm9, xmm3
    vmovsd [r10 + T_ACC + 8], xmm7
    vmovsd [r10 + T_ACC + 72], xmm3
    vmovsd xmm0, [r10 + T_ACC + 16]
    vmovsd xmm1, [r10 + T_ACC + 80]
    vmovsd xmm2, [r10 + T_X + 256]
    vmovsd xmm3, [r10 + T_X + 320]
M5s_a381
M5s_a387
M5s_a388
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm2, xmm3
    vmovsd xmm9, [r10 + T_X + 264]
    vmovsd xmm8, [r10 + T_X + 328]
M5s_a389
M5s_a38a
M5s_a38d
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [r10 + T_X + 272]
    vmovsd xmm5, [r10 + T_X + 336]
M5s_a390
M5s_a395
M5s_a396
    vaddsd xmm1, xmm3, xmm6
    vsubsd xmm5, xmm1, xmm3
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [r10 + T_X + 280]
    vmovsd xmm0, [r10 + T_X + 344]
M5s_a397
M5s_a398
M5s_a399
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm0, xmm3, xmm8
    vsubsd xmm0, xmm2, xmm0
    vmovsd xmm9, [r10 + T_X + 288]
    vmovsd xmm7, [r10 + T_X + 352]
M5s_a39d
M5s_a3a1
M5s_a3a2
    vaddsd xmm8, xmm5, xmm9
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm7, xmm9, xmm7
    vmovsd xmm6, [r10 + T_X + 296]
    vmovsd xmm4, [r10 + T_X + 360]
M5s_a3a3
M5s_a3a4
M5s_a3a5
    vaddsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm5, xmm0
    vsubsd xmm4, xmm6, xmm4
    vmovsd xmm2, [r10 + T_X + 304]
    vmovsd xmm1, [r10 + T_X + 368]
M5s_a3ab
M5s_a3ad
M5s_a3ae
    vaddsd xmm0, xmm7, xmm2
    vsubsd xmm1, xmm0, xmm7
    vsubsd xmm1, xmm2, xmm1
    vmovsd xmm9, [r10 + T_X + 312]
    vmovsd xmm3, [r10 + T_X + 376]
M5s_a3af
M5s_a3b0
M5s_a3b1
    vaddsd xmm7, xmm4, xmm9
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm9, xmm3
    vmovsd [r10 + T_ACC + 16], xmm7
    vmovsd [r10 + T_ACC + 80], xmm3
    ret
.dexp:
    vpxorq zmm0, zmm0, zmm0
    vbroadcastsd zmm1, [t_ln2]
    vdivpd zmm2, zmm16, zmm1
    vrndscalepd zmm1, zmm2, 0
    vbroadcastsd zmm2, [t_ln2d]
    vbroadcastsd zmm3, [t_ln2d + 8]
    vmulpd zmm4, zmm2, zmm1
    vmovapd zmm5, zmm4
    vfmsub231pd zmm5, zmm2, zmm1
    vmulpd zmm6, zmm3, zmm1
    vfmadd231pd zmm6, zmm2, zmm0
M5s_a354
    vpxorq zmm3, zmm6, [t_sign]{1to8}
    vpxorq zmm2, zmm7, [t_sign]{1to8}
    vaddpd zmm7, zmm16, zmm3
    vsubpd zmm6, zmm7, zmm16
    vsubpd zmm5, zmm7, zmm6
    vsubpd zmm5, zmm16, zmm5
    vsubpd zmm6, zmm3, zmm6
    vaddpd zmm5, zmm5, zmm6
    vaddpd zmm6, zmm17, zmm2
    vsubpd zmm4, zmm6, zmm17
    vsubpd zmm8, zmm6, zmm4
    vsubpd zmm8, zmm17, zmm8
    vsubpd zmm4, zmm2, zmm4
    vaddpd zmm8, zmm8, zmm4
    vaddpd zmm4, zmm5, zmm6
    vaddpd zmm6, zmm7, zmm4
    vsubpd zmm5, zmm6, zmm7
    vsubpd zmm5, zmm4, zmm5
    vaddpd zmm4, zmm5, zmm8
    vaddpd zmm8, zmm6, zmm4
    vsubpd zmm5, zmm8, zmm6
    vsubpd zmm5, zmm4, zmm5
    vbroadcastsd zmm2, [t_i1024]
    vmulpd zmm3, zmm8, zmm2
    vmovapd zmm4, zmm3
    vfmsub231pd zmm4, zmm8, zmm2
    vmulpd zmm6, zmm5, zmm2
    vfmadd231pd zmm6, zmm8, zmm0
    vaddpd zmm4, zmm4, zmm6
    vaddpd zmm6, zmm3, zmm4
    vsubpd zmm7, zmm6, zmm3
    vsubpd zmm7, zmm4, zmm7
    vbroadcastsd zmm5, [t_one]
    vmovapd zmm8, zmm0
    vbroadcastsd zmm2, [t_one]
    vmovapd zmm4, zmm0
    vmulpd zmm3, zmm2, zmm6
    vmovapd zmm9, zmm3
    vfmsub231pd zmm9, zmm2, zmm6
    vmulpd zmm10, zmm4, zmm6
    vfmadd231pd zmm10, zmm2, zmm7
    vaddpd zmm9, zmm9, zmm10
M5s_a3d8
M5s_a3dc
M5s_a3e2
M5s_a3e6
M5s_a3eb
M5s_a3ef
M5s_a3f4
M5s_a3f9
M5s_a3fd
M5s_a402
M5s_a406
M5s_a40b
M5s_a40f
M5s_a413
    vsubpd zmm3, zmm19, zmm3
    vaddpd zmm5, zmm5, zmm3
M5s_a3e1
M5s_a419
    vsubpd zmm21, zmm11, zmm2
    vsubpd zmm21, zmm8, zmm21
    vsubpd zmm2, zmm12, zmm2
    vaddpd zmm21, zmm21, zmm2
    vaddpd zmm2, zmm20, zmm11
    vaddpd zmm11, zmm13, zmm2
    vsubpd zmm20, zmm11, zmm13
    vsubpd zmm20, zmm2, zmm20
    vaddpd zmm2, zmm20, zmm21
    vaddpd zmm21, zmm11, zmm2
    vdivpd zmm8, zmm21, zmm19
    vaddpd zmm21, zmm15, zmm14
    vsubpd zmm18, zmm21, zmm15
    vsubpd zmm18, zmm14, zmm18
    vaddpd zmm14, zmm21, zmm8
    vsubpd zmm15, zmm14, zmm21
    vsubpd zmm12, zmm14, zmm15
    vsubpd zmm12, zmm21, zmm12
    vsubpd zmm15, zmm8, zmm15
    vaddpd zmm12, zmm12, zmm15
    vaddpd zmm15, zmm18, zmm0
    vsubpd zmm9, zmm15, zmm18
    vsubpd zmm2, zmm15, zmm9
    vsubpd zmm2, zmm18, zmm2
    vsubpd zmm9, zmm0, zmm9
    vaddpd zmm2, zmm2, zmm9
    vaddpd zmm9, zmm12, zmm15
    vaddpd zmm15, zmm14, zmm9
    vsubpd zmm12, zmm15, zmm14
    vsubpd zmm12, zmm9, zmm12
    vaddpd zmm9, zmm12, zmm2
    vaddpd zmm2, zmm15, zmm9
    vsubpd zmm12, zmm2, zmm15
    vsubpd zmm12, zmm9, zmm12
    vaddpd zmm10, zmm5, zmm2
    vsubpd zmm3, zmm10, zmm5
    vsubpd zmm19, zmm10, zmm3
    vsubpd zmm19, zmm5, zmm19
    vsubpd zmm3, zmm2, zmm3
    vaddpd zmm19, zmm19, zmm3
    vaddpd zmm3, zmm4, zmm12
    vsubpd zmm8, zmm3, zmm4
    vsubpd zmm18, zmm3, zmm8
    vsubpd zmm18, zmm4, zmm18
    vsubpd zmm8, zmm12, zmm8
    vaddpd zmm18, zmm18, zmm8
M5s_a3ea
    vaddpd zmm8, zmm19, zmm18
    vaddpd zmm18, zmm3, zmm8
    vsubpd zmm19, zmm18, zmm3
    vsubpd zmm19, zmm8, zmm19
    vmulpd zmm4, zmm2, zmm6
    vmovapd zmm5, zmm4
    vfmsub231pd zmm5, zmm2, zmm6
    vmulpd zmm8, zmm12, zmm6
M5s_a41e
    vaddpd zmm20, zmm15, zmm13
    vaddpd zmm13, zmm10, zmm20
    vdivpd zmm4, zmm13, zmm12
    vaddpd zmm13, zmm2, zmm9
    vsubpd zmm14, zmm13, zmm2
    vsubpd zmm14, zmm9, zmm14
    vaddpd zmm9, zmm13, zmm4
    vsubpd zmm2, zmm9, zmm13
    vsubpd zmm11, zmm9, zmm2
    vsubpd zmm11, zmm13, zmm11
    vsubpd zmm2, zmm4, zmm2
    vaddpd zmm11, zmm11, zmm2
    vaddpd zmm2, zmm14, zmm0
    vsubpd zmm5, zmm2, zmm14
    vsubpd zmm20, zmm2, zmm5
    vsubpd zmm20, zmm14, zmm20
    vsubpd zmm5, zmm0, zmm5
    vaddpd zmm20, zmm20, zmm5
    vaddpd zmm5, zmm11, zmm2
    vaddpd zmm2, zmm9, zmm5
    vsubpd zmm11, zmm2, zmm9
    vsubpd zmm11, zmm5, zmm11
    vaddpd zmm5, zmm11, zmm20
    vaddpd zmm20, zmm2, zmm5
    vsubpd zmm11, zmm20, zmm2
    vsubpd zmm11, zmm5, zmm11
    vaddpd zmm3, zmm18, zmm20
    vsubpd zmm8, zmm3, zmm18
    vsubpd zmm12, zmm3, zmm8
    vsubpd zmm12, zmm18, zmm12
    vsubpd zmm8, zmm20, zmm8
    vaddpd zmm12, zmm12, zmm8
    vaddpd zmm8, zmm19, zmm11
    vsubpd zmm4, zmm8, zmm19
    vsubpd zmm14, zmm8, zmm4
    vsubpd zmm14, zmm19, zmm14
    vsubpd zmm4, zmm11, zmm4
    vaddpd zmm14, zmm14, zmm4
M5s_a3f3
    vaddpd zmm4, zmm12, zmm14
    vaddpd zmm14, zmm8, zmm4
    vsubpd zmm12, zmm14, zmm8
    vsubpd zmm12, zmm4, zmm12
    vmulpd zmm19, zmm20, zmm6
    vmovapd zmm18, zmm19
    vfmsub231pd zmm18, zmm20, zmm6
    vmulpd zmm4, zmm11, zmm6
    vfmadd231pd zmm4, zmm20, zmm7
    vaddpd zmm18, zmm18, zmm4
    vaddpd zmm4, zmm19, zmm18
    vsubpd zmm8, zmm4, zmm19
    vsubpd zmm8, zmm18, zmm8
    vbroadcastsd zmm11, [t_c11]
    vdivpd zmm20, zmm4, zmm11
    vpxorq zmm18, zmm20, [t_sign]{1to8}
    vmulpd zmm19, zmm11, zmm18
    vmovapd zmm3, zmm19
    vfmsub231pd zmm3, zmm11, zmm18
    vmulpd zmm13, zmm0, zmm18
    vfmadd231pd zmm13, zmm11, zmm0
    vaddpd zmm3, zmm3, zmm13
M5s_a426
    vsubpd zmm15, zmm20, zmm18
    vsubpd zmm15, zmm9, zmm15
    vsubpd zmm18, zmm0, zmm18
    vaddpd zmm15, zmm15, zmm18
    vaddpd zmm18, zmm10, zmm20
    vaddpd zmm20, zmm5, zmm18
    vsubpd zmm10, zmm20, zmm5
    vsubpd zmm10, zmm18, zmm10
    vaddpd zmm18, zmm10, zmm15
    vaddpd zmm15, zmm20, zmm18
    vsubpd zmm10, zmm15, zmm20
    vsubpd zmm10, zmm18, zmm10
    vaddpd zmm8, zmm14, zmm15
    vsubpd zmm4, zmm8, zmm14
    vsubpd zmm11, zmm8, zmm4
    vsubpd zmm11, zmm14, zmm11
    vsubpd zmm4, zmm15, zmm4
    vaddpd zmm11, zmm11, zmm4
    vaddpd zmm4, zmm12, zmm10
    vsubpd zmm19, zmm4, zmm12
    vsubpd zmm9, zmm4, zmm19
    vsubpd zmm9, zmm12, zmm9
    vsubpd zmm19, zmm10, zmm19
    vaddpd zmm9, zmm9, zmm19
M5s_a3f8
    vaddpd zmm19, zmm11, zmm9
    vaddpd zmm9, zmm4, zmm19
    vsubpd zmm11, zmm9, zmm4
    vsubpd zmm11, zmm19, zmm11
    vmulpd zmm12, zmm15, zmm6
    vmovapd zmm14, zmm12
    vfmsub231pd zmm14, zmm15, zmm6
    vmulpd zmm19, zmm10, zmm6
    vfmadd231pd zmm19, zmm15, zmm7
    vaddpd zmm14, zmm14, zmm19
    vaddpd zmm19, zmm12, zmm14
    vsubpd zmm4, zmm19, zmm12
    vsubpd zmm4, zmm14, zmm4
    vbroadcastsd zmm10, [t_c12]
    vdivpd zmm15, zmm19, zmm10
    vpxorq zmm14, zmm15, [t_sign]{1to8}
    vmulpd zmm12, zmm10, zmm14
    vmovapd zmm8, zmm12
    vfmsub231pd zmm8, zmm10, zmm14
    vmulpd zmm21, zmm0, zmm14
    vfmadd231pd zmm21, zmm10, zmm0
    vaddpd zmm8, zmm8, zmm21
    vaddpd zmm21, zmm12, zmm8
    vsubpd zmm18, zmm21, zmm12
    vsubpd zmm18, zmm8, zmm18
    vaddpd zmm14, zmm19, zmm21
    vsubpd zmm8, zmm14, zmm19
    vsubpd zmm12, zmm14, zmm8
    vsubpd zmm12, zmm19, zmm12
    vsubpd zmm8, zmm21, zmm8
    vaddpd zmm12, zmm12, zmm8
    vaddpd zmm8, zmm4, zmm18
    vsubpd zmm20, zmm8, zmm4
    vsubpd zmm5, zmm8, zmm20
    vsubpd zmm5, zmm4, zmm5
    vsubpd zmm20, zmm18, zmm20
M5s_a42e
    vsubpd zmm10, zmm4, zmm19
    vsubpd zmm10, zmm9, zmm10
    vsubpd zmm19, zmm2, zmm19
    vaddpd zmm10, zmm10, zmm19
    vaddpd zmm19, zmm11, zmm3
    vsubpd zmm12, zmm19, zmm11
    vsubpd zmm5, zmm19, zmm12
    vsubpd zmm5, zmm11, zmm5
    vsubpd zmm12, zmm3, zmm12
    vaddpd zmm5, zmm5, zmm12
M5s_a401
    vaddpd zmm12, zmm10, zmm5
    vaddpd zmm5, zmm19, zmm12
    vsubpd zmm10, zmm5, zmm19
    vsubpd zmm10, zmm12, zmm10
    vmulpd zmm11, zmm2, zmm6
    vmovapd zmm9, zmm11
    vfmsub231pd zmm9, zmm2, zmm6
    vmulpd zmm12, zmm3, zmm6
    vfmadd231pd zmm12, zmm2, zmm7
    vaddpd zmm9, zmm9, zmm12
    vaddpd zmm12, zmm11, zmm9
    vsubpd zmm19, zmm12, zmm11
    vsubpd zmm19, zmm9, zmm19
    vbroadcastsd zmm3, [t_c13]
    vdivpd zmm2, zmm12, zmm3
    vpxorq zmm9, zmm2, [t_sign]{1to8}
    vmulpd zmm11, zmm3, zmm9
    vmovapd zmm4, zmm11
    vfmsub231pd zmm4, zmm3, zmm9
    vmulpd zmm13, zmm0, zmm9
    vfmadd231pd zmm13, zmm3, zmm0
    vaddpd zmm4, zmm4, zmm13
    vaddpd zmm13, zmm11, zmm4
    vsubpd zmm14, zmm13, zmm11
    vsubpd zmm14, zmm4, zmm14
    vaddpd zmm9, zmm12, zmm13
    vsubpd zmm4, zmm9, zmm12
    vsubpd zmm11, zmm9, zmm4
    vsubpd zmm11, zmm12, zmm11
    vsubpd zmm4, zmm13, zmm4
    vaddpd zmm11, zmm11, zmm4
    vaddpd zmm4, zmm19, zmm14
    vsubpd zmm15, zmm4, zmm19
    vsubpd zmm18, zmm4, zmm15
    vsubpd zmm18, zmm19, zmm18
    vsubpd zmm15, zmm14, zmm15
    vaddpd zmm18, zmm18, zmm15
    vaddpd zmm15, zmm11, zmm4
    vaddpd zmm4, zmm9, zmm15
    vsubpd zmm11, zmm4, zmm9
    vsubpd zmm11, zmm15, zmm11
    vaddpd zmm15, zmm11, zmm18
    vaddpd zmm18, zmm4, zmm15
    vsubpd zmm11, zmm18, zmm4
    vsubpd zmm11, zmm15, zmm11
    vdivpd zmm14, zmm18, zmm3
    vpxorq zmm13, zmm14, [t_sign]{1to8}
    vmulpd zmm15, zmm3, zmm13
    vmovapd zmm4, zmm15
    vfmsub231pd zmm4, zmm3, zmm13
    vmulpd zmm9, zmm0, zmm13
    vfmadd231pd zmm9, zmm3, zmm0
    vaddpd zmm4, zmm4, zmm9
    vaddpd zmm9, zmm15, zmm4
    vsubpd zmm8, zmm9, zmm15
    vsubpd zmm8, zmm4, zmm8
    vaddpd zmm13, zmm18, zmm9
    vsubpd zmm4, zmm13, zmm18
    vsubpd zmm15, zmm13, zmm4
    vsubpd zmm15, zmm18, zmm15
    vsubpd zmm4, zmm9, zmm4
    vaddpd zmm15, zmm15, zmm4
    vaddpd zmm4, zmm11, zmm8
    vsubpd zmm20, zmm4, zmm11
    vsubpd zmm21, zmm4, zmm20
    vsubpd zmm21, zmm11, zmm21
    vsubpd zmm20, zmm8, zmm20
    vaddpd zmm21, zmm21, zmm20
    vaddpd zmm20, zmm15, zmm4
    vaddpd zmm4, zmm13, zmm20
    vsubpd zmm15, zmm4, zmm13
    vsubpd zmm15, zmm20, zmm15
    vaddpd zmm20, zmm15, zmm21
    vaddpd zmm21, zmm4, zmm20
    vdivpd zmm11, zmm21, zmm3
    vaddpd zmm21, zmm2, zmm14
    vsubpd zmm18, zmm21, zmm2
    vsubpd zmm18, zmm14, zmm18
    vaddpd zmm14, zmm21, zmm11
    vsubpd zmm2, zmm14, zmm21
    vsubpd zmm8, zmm14, zmm2
    vsubpd zmm8, zmm21, zmm8
    vsubpd zmm2, zmm11, zmm2
    vaddpd zmm8, zmm8, zmm2
M5s_a3e0
    vsubpd zmm9, zmm0, zmm9
    vaddpd zmm20, zmm20, zmm9
    vaddpd zmm9, zmm8, zmm2
    vaddpd zmm2, zmm14, zmm9
    vsubpd zmm8, zmm2, zmm14
    vsubpd zmm8, zmm9, zmm8
    vaddpd zmm9, zmm8, zmm20
    vaddpd zmm20, zmm2, zmm9
    vsubpd zmm8, zmm20, zmm2
    vsubpd zmm8, zmm9, zmm8
    vaddpd zmm19, zmm5, zmm20
    vsubpd zmm12, zmm19, zmm5
    vsubpd zmm3, zmm19, zmm12
    vsubpd zmm3, zmm5, zmm3
    vsubpd zmm12, zmm20, zmm12
    vaddpd zmm3, zmm3, zmm12
    vaddpd zmm12, zmm10, zmm8
    vsubpd zmm11, zmm12, zmm10
    vsubpd zmm18, zmm12, zmm11
    vsubpd zmm18, zmm10, zmm18
    vsubpd zmm11, zmm8, zmm11
    vaddpd zmm18, zmm18, zmm11
M5s_a40a
    vaddpd zmm11, zmm3, zmm18
    vaddpd zmm18, zmm12, zmm11
M5s_a43c
M5s_a442
    vfmadd231pd zmm18, zmm5, zmm10
    vaddpd zmm11, zmm11, zmm18
M5s_a43b
M5s_a448
M5s_a44c
M5s_a453
    vpxorq zmm17{k6}, zmm17, zmm20
    ret
.xoe:
M5s_a44f
    call .dln
    vbroadcastsd zmm0, [t_e512]
    vbroadcastsd zmm1, [t_e512 + 8]
M5s_a450
M5s_a458
