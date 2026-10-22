%include "p5nm.inc"
default rel
%include "gpo.inc"
%include "gpimg.inc"
M5p_a0
M5p_a1
M5p_a2
M5p_a3
M5p_a4
global xav_p5_0_10_5
align 64
xav_p5_0_10_5:
M5p_a5
M5p_a6
M5p_ab
    add r12, 128
    add eax, 16
    dec r14
    jnz .cv2
.cl2:
    mov ecx, r8d
    sub ecx, eax
    sub ecx, 16
M5p_a7
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
M5p_a8
M5p_aa
M5p_ab
    add r12, 128
.cl1:
    vpermps zmm12, zmm17, zmm10
    vpermps zmm13, zmm17, zmm11
M5p_a8
M5p_aa
M5p_ad
    vbroadcastss zmm18, [c_grh]
    vbroadcastss zmm19, [c_grl]
    vbroadcastss zmm20, [c_gbh]
    vbroadcastss zmm21, [c_gbl]
    vbroadcastss zmm22, [c_kbh]
    vbroadcastss zmm23, [c_kbl]
    vbroadcastss zmm24, [c_h0625]
    vbroadcastss zmm25, [c_h5625]
    vpbroadcastd zmm26, [c_n64]
    test byte [rsi + Rc_od], 1
    jnz .a0o
.a0e:
M5p_a10
    vmovups zmm1, [r9 + rax*4]
    vmovups zmm2, [r13 + rax*4]
M5p_a11
    add r8, 384
    dec r12d
    jz .a0x
.a0o:
M5p_a10
    mov ecx, [rsi + Rc_co]
    mov r14d, [rsi + Rc_co + 8]
    mov ebx, [rsi + Rc_co + 12]
    vmovups zmm1, [r9 + rax*4]
    vaddps zmm1, zmm1, [r9 + r14*4]
    vmovups zmm3, [r9 + rcx*4]
    vaddps zmm3, zmm3, [r9 + rbx*4]
    vmulps zmm3, zmm3, zmm24
    vfmsub132ps zmm1, zmm3, zmm25
    vmovups zmm2, [r13 + rax*4]
    vaddps zmm2, zmm2, [r13 + r14*4]
    vmovups zmm3, [r13 + rcx*4]
    vaddps zmm3, zmm3, [r13 + rbx*4]
    vmulps zmm3, zmm3, zmm24
    vfmsub132ps zmm2, zmm3, zmm25
M5p_a11
M5p_a15
M5p_a16
M5p_a17
.c1e:
    vpxord zmm8, zmm8, zmm8
    vpxord zmm9, zmm9, zmm9
    vpxord zmm10, zmm10, zmm10
    vpxord zmm11, zmm11, zmm11
    vpxord zmm12, zmm12, zmm12
    vpxord zmm13, zmm13, zmm13
    vpxord zmm14, zmm14, zmm14
    vpxord zmm15, zmm15, zmm15
    mov ecx, [r15 + Pc_n + 0]
    test ecx, ecx
    jz .r0e
.r0:
    vmovups zmm20, [r8 + 192]
M5p_a1a
    vpermi2ps zmm23, zmm27, zmm28
    vpermi2ps zmm21, zmm29, zmm30
    vmulps zmm22, zmm22, zmm23
    vgetmantps zmm16, zmm20, 4
    vfmsub213ps zmm16, zmm21, zmm31
    vmovaps zmm23, zmm24
    vfmadd213ps zmm23, zmm16, [c_q6 + 4]{1to16}
    vfmadd213ps zmm23, zmm16, [c_q6]{1to16}
    vmulps zmm16, zmm22, zmm16
    vfmadd213ps zmm16, zmm23, zmm22
    vmovups zmm20, [r8 + 0]
    vpternlogd zmm16, zmm20, [c_sign]{1to16}, 0xd8
    vmovups zmm20, [r8 + 256]
M5p_a1a
    vpermi2ps zmm23, zmm27, zmm28
    vpermi2ps zmm21, zmm29, zmm30
    vmulps zmm22, zmm22, zmm23
    vgetmantps zmm17, zmm20, 4
    vfmsub213ps zmm17, zmm21, zmm31
    vmovaps zmm23, zmm24
    vfmadd213ps zmm23, zmm17, [c_q6 + 4]{1to16}
    vfmadd213ps zmm23, zmm17, [c_q6]{1to16}
    vmulps zmm17, zmm22, zmm17
    vfmadd213ps zmm17, zmm23, zmm22
    vmovups zmm20, [r8 + 64]
    vpternlogd zmm17, zmm20, [c_sign]{1to16}, 0xd8
    vmovups zmm20, [r8 + 320]
M5p_a1a
    vpermi2ps zmm23, zmm27, zmm28
    vpermi2ps zmm21, zmm29, zmm30
    vmulps zmm22, zmm22, zmm23
M5p_a1f
M5p_a25
    vaddps zmm0, zmm0, zmm16
    vaddps zmm1, zmm1, zmm17
    vaddps zmm2, zmm2, zmm18
    vaddps zmm3, zmm3, zmm19
    add r8, 384
    dec ecx
    jnz .r0
.r0e:
    mov eax, [r15 + Pc_n + 4]
    test eax, eax
    jz .s0e
M5p_a19
M5p_a1d
M5p_a23
    vpmaxud zmm19, zmm19, zmm18
    vpminsd zmm19, zmm19, [c_zero]{1to16}
    vbroadcastss zmm20, [r15 + Pc_w + 0]
    vbroadcastss zmm21, [r15 + Pc_w + 0 + 4]
    vfmadd231ps zmm0, zmm16, zmm20
    vfmadd231ps zmm1, zmm17, zmm20
    vfmadd231ps zmm2, zmm18, zmm20
    vfmadd231ps zmm3, zmm19, zmm20
M5p_a27
    cmp eax, 1
    je .s0f
    vbroadcastss zmm22, [r15 + Pc_w + 0 + 8]
    vmulps zmm8, zmm16, zmm22
    vmulps zmm9, zmm17, zmm22
    vmulps zmm10, zmm18, zmm22
    vmulps zmm11, zmm19, zmm22
.s0f:
    add r8, 384
.s0e:
    test byte [r15 + Pc_ci], 4
    jz .p0e
    vmovups [rbx], zmm0
    vmovups [rbx + r10], zmm1
    vmovups [rbx + r10*2], zmm2
    vmovups [rbx + r11], zmm3
.p0e:
    mov ecx, [r15 + Pc_n + 8]
    test ecx, ecx
    jz .r1e
.r1:
M5p_a19
M5p_a1d
M5p_a23
    vpmaxud zmm19, zmm19, zmm18
    vpminsd zmm19, zmm19, [c_zero]{1to16}
    vaddps zmm4, zmm4, zmm16
    vaddps zmm5, zmm5, zmm17
    vaddps zmm6, zmm6, zmm18
    vaddps zmm7, zmm7, zmm19
    add r8, 384
    dec ecx
    jnz .r1
.r1e:
    mov eax, [r15 + Pc_n + 12]
    test eax, eax
    jz .s1e
M5p_a19
M5p_a1d
M5p_a23
    vpmaxud zmm19, zmm19, zmm18
    vpminsd zmm19, zmm19, [c_zero]{1to16}
    vbroadcastss zmm20, [r15 + Pc_w + 12]
    vbroadcastss zmm21, [r15 + Pc_w + 12 + 4]
    vfmadd231ps zmm4, zmm16, zmm20
    vfmadd231ps zmm5, zmm17, zmm20
    vfmadd231ps zmm6, zmm18, zmm20
    vfmadd231ps zmm7, zmm19, zmm20
    vfmadd231ps zmm8, zmm16, zmm21
    vfmadd231ps zmm9, zmm17, zmm21
    vfmadd231ps zmm10, zmm18, zmm21
    vfmadd231ps zmm11, zmm19, zmm21
    cmp eax, 1
    je .s1f
    vbroadcastss zmm22, [r15 + Pc_w + 12 + 8]
    vmulps zmm12, zmm16, zmm22
    vmulps zmm13, zmm17, zmm22
    vmulps zmm14, zmm18, zmm22
    vmulps zmm15, zmm19, zmm22
.s1f:
    add r8, 384
.s1e:
    vaddps zmm0, zmm0, zmm4
    vaddps zmm1, zmm1, zmm5
    vaddps zmm2, zmm2, zmm6
    vaddps zmm3, zmm3, zmm7
    vmovups [r9], zmm0
    vmovups [r9 + r14], zmm1
    vmovups [r9 + r14*2], zmm2
    vmovups [r9 + rdx], zmm3
M5p_a17
    mov ecx, [r15 + Pc_n + 16]
    test ecx, ecx
    jz .r2e
.r2:
M5p_a19
M5p_a1d
M5p_a23
    vpmaxud zmm19, zmm19, zmm18
    vpminsd zmm19, zmm19, [c_zero]{1to16}
    vaddps zmm8, zmm8, zmm16
    vaddps zmm9, zmm9, zmm17
    vaddps zmm10, zmm10, zmm18
    vaddps zmm11, zmm11, zmm19
    add r8, 384
    dec ecx
    jnz .r2
.r2e:
    mov eax, [r15 + Pc_n + 20]
    test eax, eax
    jz .s2e
M5p_a19
M5p_a1d
M5p_a23
    vpmaxud zmm19, zmm19, zmm18
    vpminsd zmm19, zmm19, [c_zero]{1to16}
    vbroadcastss zmm20, [r15 + Pc_w + 24]
    vbroadcastss zmm21, [r15 + Pc_w + 24 + 4]
    vfmadd231ps zmm8, zmm16, zmm20
    vfmadd231ps zmm9, zmm17, zmm20
    vfmadd231ps zmm10, zmm18, zmm20
    vfmadd231ps zmm11, zmm19, zmm20
    vfmadd231ps zmm12, zmm16, zmm21
    vfmadd231ps zmm13, zmm17, zmm21
    vfmadd231ps zmm14, zmm18, zmm21
    vfmadd231ps zmm15, zmm19, zmm21
    cmp eax, 1
    je .s2f
    vbroadcastss zmm22, [r15 + Pc_w + 24 + 8]
    vmulps zmm4, zmm16, zmm22
    vmulps zmm5, zmm17, zmm22
    vmulps zmm6, zmm18, zmm22
    vmulps zmm7, zmm19, zmm22
.s2f:
    add r8, 384
.s2e:
    vaddps zmm16, zmm8, [rbx]
    vaddps zmm17, zmm9, [rbx + r10]
    vaddps zmm18, zmm10, [rbx + r10*2]
    vaddps zmm19, zmm11, [rbx + r11]
    vaddps zmm16, zmm16, zmm0
    vaddps zmm17, zmm17, zmm1
    vaddps zmm18, zmm18, zmm2
    vaddps zmm19, zmm19, zmm3
    vmovups [rdi], zmm16
    vmovups [rdi + r14], zmm17
    vmovups [rdi + r14*2], zmm18
    vmovups [rdi + rdx], zmm19
    mov ecx, [r15 + Pc_n + 24]
    test ecx, ecx
    jz .r3e
.r3:
M5p_a19
M5p_a1d
M5p_a23
    vpmaxud zmm19, zmm19, zmm18
    vpminsd zmm19, zmm19, [c_zero]{1to16}
    vaddps zmm12, zmm12, zmm16
    vaddps zmm13, zmm13, zmm17
    vaddps zmm14, zmm14, zmm18
    vaddps zmm15, zmm15, zmm19
    add r8, 384
    dec ecx
    jnz .r3
.r3e:
    mov eax, [r15 + Pc_n + 28]
    test eax, eax
    jz .s3e
M5p_a19
M5p_a1d
M5p_a23
    vpmaxud zmm19, zmm19, zmm18
    vpminsd zmm19, zmm19, [c_zero]{1to16}
    vbroadcastss zmm20, [r15 + Pc_w + 36]
    vbroadcastss zmm21, [r15 + Pc_w + 36 + 4]
    vfmadd231ps zmm12, zmm16, zmm20
    vfmadd231ps zmm13, zmm17, zmm20
    vfmadd231ps zmm14, zmm18, zmm20
    vfmadd231ps zmm15, zmm19, zmm20
M5p_a27
    cmp eax, 1
    je .s3f
    vbroadcastss zmm22, [r15 + Pc_w + 36 + 8]
    vmulps zmm0, zmm16, zmm22
    vmulps zmm1, zmm17, zmm22
    vmulps zmm2, zmm18, zmm22
    vmulps zmm3, zmm19, zmm22
.s3f:
.s3e:
    vaddps zmm8, zmm8, zmm12
    vaddps zmm9, zmm9, zmm13
    vaddps zmm10, zmm10, zmm14
    vaddps zmm11, zmm11, zmm15
    vmovups [rsi], zmm8
    vmovups [rsi + r14], zmm9
    vmovups [rsi + r14*2], zmm10
    vmovups [rsi + rdx], zmm11
    vmovups [rbx], zmm12
    vmovups [rbx + r10], zmm13
    vmovups [rbx + r10*2], zmm14
    vmovups [rbx + r11], zmm15
    test byte [r15 + Pc_co], 1
    jz .n0e
    vmovups [r12], zmm4
    vmovups [r12 + r10], zmm5
    vmovups [r12 + r10*2], zmm6
    vmovups [r12 + r11], zmm7
.n0e:
    test byte [r15 + Pc_co], 2
    jz .n1e
    vmovups [r13], zmm0
    vmovups [r13 + r10], zmm1
    vmovups [r13 + r10*2], zmm2
    vmovups [r13 + r11], zmm3
.n1e:
.b2x:
.bkc:
    mov rax, [rsp + 128]
    mov rcx, [rsp + 120]
    mov [rsp + 128], rcx
    mov rcx, [rsp + 112]
    mov [rsp + 120], rcx
    mov [rsp + 112], rax
    inc rbp
    lea rax, [rbp - 2]
    cmp rax, [rsp + 64]
    jl .bk
M5p_a2f
    kortestw k1, k1
    jz .nfa
M5p_a32
    kunpckdq k2, k3, k2
    kmovq r13, k2
.sl0a:
    test r13, r13
    jz .se0a
M5p_a34
M5p_a38
    vpcompressd zmm0{k1}{z}, zmm0
    vmovups [r10 + r11*4 + 262144], zmm0
    add r11, r14
    jmp .sl0a
.se0a:
M5p_a3e
    vmovdqu16 zmm1, [rdi + G_ms + 192]
M5p_a33
.sl1a:
    test r13, r13
    jz .se1a
    tzcnt rcx, r13
    blsr r13, r13
    movzx r14d, word [rdi + G_ms + 128 + rcx*2]
M5p_a36
M5p_a39
    jmp .sl1a
.se1a:
M5p_a42
    vptestmw k2, zmm0, zmm0
    kmovd r13d, k2
.slca:
    test r13d, r13d
    jz .seca
    tzcnt ecx, r13d
    blsr r13d, r13d
    movzx r14d, word [rdi + G_ms + 256 + rcx*2]
M5p_a35
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
M5p_a3a
    vpcompressd zmm0{k1}{z}, zmm0
    vmovups [r10 + r11*4 + 393216], zmm0
    add r11, r14
    jmp .slca
.seca:
M5p_a4f
.nfa:
    mov rdi, [rsp + 8]
    vmovups zmm20, [c_ev]
    vmovups zmm21, [c_od]
M5p_a51
    mov r14, [rdi + G_gp]
    shl r14, 2
    mov rdx, [rdi + G_hx]
    mov rcx, [rdi + G_hv]
    mov rsi, [rdi + G_hk]
M5p_a52
M5p_a54
.hu:
M5p_a55
M5p_a6e
M5p_a89
    vpermi2ps zmm17, zmm28, zmm29
M5p_aab
    kmovw k3, [rsi + 98]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm0, zmm16, [rcx + 576]
M5p_ab0
    vmovups zmm30, [r8 + r14 + 512]
    vmovups zmm31, [r8 + r14 + 576]
M5p_a5c
    kmovw k3, [rsi + 8]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm1, zmm16, [rcx + 0]
M5p_a63
    kmovw k3, [rsi + 18]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 64]
M5p_a69
    kmovw k3, [rsi + 28]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 128]
M5p_a70
    kmovw k3, [rsi + 38]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 192]
M5p_a77
    kmovw k3, [rsi + 48]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 256]
M5p_a7e
    kmovw k3, [rsi + 58]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 320]
M5p_a87
    kmovw k3, [rsi + 68]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 384]
M5p_a93
    kmovw k3, [rsi + 78]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 448]
M5p_a9a
    kmovw k3, [rsi + 88]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 512]
M5p_aa5
    kmovw k3, [rsi + 98]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm1, zmm16, [rcx + 576]
M5p_abe
M5p_ac4
    vmovups zmm30, [r9 + 512]
    vmovups zmm31, [r9 + 576]
M5p_a5c
    kmovw k3, [rsi + 8]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm2, zmm16, [rcx + 0]
M5p_a63
    kmovw k3, [rsi + 18]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 64]
M5p_a69
    kmovw k3, [rsi + 28]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 128]
M5p_a70
    kmovw k3, [rsi + 38]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 192]
M5p_a77
    kmovw k3, [rsi + 48]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 256]
M5p_a7e
    kmovw k3, [rsi + 58]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 320]
M5p_a87
    kmovw k3, [rsi + 68]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 384]
M5p_a93
    kmovw k3, [rsi + 78]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 448]
M5p_a9a
    kmovw k3, [rsi + 88]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 512]
M5p_aa5
    kmovw k3, [rsi + 98]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm2, zmm16, [rcx + 576]
M5p_acd
    vmovups zmm30, [r9 + r14 + 512]
    vmovups zmm31, [r9 + r14 + 576]
M5p_a5c
    kmovw k3, [rsi + 8]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm3, zmm16, [rcx + 0]
M5p_a63
    kmovw k3, [rsi + 18]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 64]
M5p_a69
    kmovw k3, [rsi + 28]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 128]
M5p_a70
    kmovw k3, [rsi + 38]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 192]
M5p_a77
    kmovw k3, [rsi + 48]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 256]
M5p_a7e
    kmovw k3, [rsi + 58]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 320]
M5p_a87
    kmovw k3, [rsi + 68]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 384]
M5p_a93
    kmovw k3, [rsi + 78]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 448]
M5p_a9a
    kmovw k3, [rsi + 88]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 512]
M5p_aa5
    kmovw k3, [rsi + 98]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm3, zmm16, [rcx + 576]
M5p_ae0
M5p_ae5
    vmovups zmm30, [r15 + 512]
    vmovups zmm31, [r15 + 576]
M5p_a5c
    kmovw k3, [rsi + 8]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm4, zmm16, [rcx + 0]
M5p_a63
    kmovw k3, [rsi + 18]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 64]
M5p_a69
    kmovw k3, [rsi + 28]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 128]
M5p_a70
    kmovw k3, [rsi + 38]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 192]
M5p_a77
    kmovw k3, [rsi + 48]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 256]
M5p_a7e
    kmovw k3, [rsi + 58]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 320]
M5p_a87
    kmovw k3, [rsi + 68]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 384]
M5p_a93
    kmovw k3, [rsi + 78]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 448]
M5p_a9a
    kmovw k3, [rsi + 88]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 512]
M5p_aa5
    kmovw k3, [rsi + 98]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm4, zmm16, [rcx + 576]
M5p_af3
    vmovups zmm30, [r15 + r14 + 512]
    vmovups zmm31, [r15 + r14 + 576]
M5p_a5c
    kmovw k3, [rsi + 8]
    vmovaps zmm16{k3}, zmm17
    vmulps zmm5, zmm16, [rcx + 0]
M5p_a63
    kmovw k3, [rsi + 18]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 64]
M5p_a69
    kmovw k3, [rsi + 28]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 128]
M5p_a70
    kmovw k3, [rsi + 38]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 192]
M5p_a77
    kmovw k3, [rsi + 48]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 256]
M5p_a7e
    kmovw k3, [rsi + 58]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 320]
M5p_a87
    kmovw k3, [rsi + 68]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 384]
M5p_a93
    kmovw k3, [rsi + 78]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 448]
M5p_a9a
    kmovw k3, [rsi + 88]
    vmovaps zmm16{k3}, zmm17
    vfmadd231ps zmm5, zmm16, [rcx + 512]
M5p_aa5
M5p_a103
    vaddps zmm2, zmm2, zmm3
    vmovups [r10 + 0], zmm0
    vmovups [r12 + 0], zmm2
    cmp qword [rsp + 40], 0
    jne .hf
    cmp rbp, rbx
    jne .hf
    vbroadcastss zmm14, xmm4
.hf:
    valignd zmm6, zmm5, zmm14, 15
M5p_a10c
    lea r15, [r15 + r14*2]
M5p_a55
M5p_a6e
M5p_a89
M5p_aaa
M5p_a6a
M5p_ab5
M5p_a88
M5p_a90
M5p_aba
M5p_ac1
M5p_ac6
M5p_a88
M5p_a90
M5p_ac9
M5p_ad1
M5p_a71
M5p_ad8
M5p_a95
M5p_a99
M5p_add
M5p_a5f
M5p_ae7
M5p_a7a
M5p_a7d
M5p_aeb
M5p_a9d
M5p_aa4
M5p_aef
    vpermi2ps zmm17, zmm30, zmm31
M5p_af8
M5p_a80
M5p_a83
M5p_afd
M5p_aa6
M5p_aab
M5p_a103
    vaddps zmm2, zmm2, zmm3
    vmovups [r10 + 256], zmm0
    vmovups [r12 + 256], zmm2
    valignd zmm7, zmm5, zmm14, 15
    vaddps zmm7, zmm4, zmm7
M5p_a10d
    vmovaps zmm16, zmm6
    vpermt2ps zmm16, zmm20, zmm7
    vpermt2ps zmm6, zmm21, zmm7
    vaddps zmm6, zmm16, zmm6
    vmovups [r11], zmm6
    add r10, 512
    add r12, 512
    add r11, 256
    dec rbp
    jnz .hu
    mov r11, r13
    shl r11, 6
    add r11, [rdi + G_oc]
    vmovups [r11], zmm14
    inc r13
    cmp r13, 4
    jb .hc
    mov rdi, [rsp + 8]
    mov r8, [rdi + G_cl]
    mov [rsp + 80], r8
    mov rcx, [rdi + G_su]
    mov r9, [rdi + G_sq]
    mov r11, rcx
    vbroadcastss zmm22, [rdi + G_lta]
    vbroadcastss zmm23, [rdi + G_lan]
    vpbroadcastd zmm24, [c_absm]
    vbroadcastss zmm25, [rdi + G_lrg]
    vbroadcastss zmm26, [rdi + G_lxl]
    vbroadcastss zmm27, [c_nieq]
    vbroadcastss zmm28, [c_eqp]
    vbroadcastss zmm29, [rdi + G_lom]
    vbroadcastss zmm30, [rdi + G_lom + 4]
    vbroadcastss zmm31, [rdi + G_lom + 8]
.ial:
M5p_a111
M5p_a119
    jnz .ial
    mov r9, [rdi + G_sq]
    mov r11, rcx
    vmovups zmm24, [rdi + G_lt1]
    vmovups zmm25, [rdi + G_lt1 + 64]
M5p_a11e
    vbroadcastss zmm30, [c_one]
    vbroadcastss zmm31, [c_kq2]
    vbroadcastss zmm23, [rdi + G_lxl]
    vbroadcastss zmm20, [c_q1 + 4]
    vbroadcastss zmm21, [c_q1]
    vbroadcastss zmm22, [c_aq2]
.ibl:
M5p_a11f
M5p_a124
M5p_a128
    jnz .ibl
M5p_a129
.icl:
M5p_a12a
M5p_a137
    dec r11
    jnz .icl
    mov rdi, [rsp + 8]
    mov rax, [rdi + G_su]
    shl rax, 3
M5p_a138
    add r10, 2
    dec rcx
    jnz .ei0
.et0:
    test r13d, r13d
    jz .ee0
M5p_a13f
M5p_a140
M5p_a146
    kandnw k1, k1, k7
    kmovw [r10], k1
.ee0:
    mov rax, [rsp + 16]
    lea rax, [rax*2 + 1]
M5p_a13d
    mov r8, rax
    mov r9, [rdi + G_su]
    shr r9, 1
    imul r9, 576
    add r9, [rdi + G_sq]
    lea r10, [rdi + G_ms + 128]
    mov rcx, [rsp + 64]
    test rcx, rcx
    jz .et1
.ei1:
M5p_a13e
M5p_a141
    add r10, 2
    dec rcx
    jnz .ei1
.et1:
    test r13d, r13d
    jz .ee1
M5p_a13f
M5p_a140
M5p_a146
    kandnw k1, k1, k7
    kmovw [r10], k1
.ee1:
    mov rdi, [rsp + 8]
    mov r8, [rdi + G_cc]
    mov [rsp + 80], r8
    mov rcx, [rdi + G_su]
    shr rcx, 2
    mov r9, [rdi + G_sq]
    mov r11, rcx
    vbroadcastss zmm22, [rdi + G_cta]
    vbroadcastss zmm23, [rdi + G_can]
    vpbroadcastd zmm24, [c_absm]
    vbroadcastss zmm25, [rdi + G_crg]
    vbroadcastss zmm26, [rdi + G_cxl]
    vbroadcastss zmm27, [c_nieq]
    vbroadcastss zmm28, [c_eqp]
    vbroadcastss zmm29, [rdi + G_com]
    vbroadcastss zmm30, [rdi + G_com + 4]
    vbroadcastss zmm31, [rdi + G_com + 8]
.iac:
M5p_a111
M5p_a119
    jnz .iac
    mov r9, [rdi + G_sq]
    mov r11, rcx
    vmovups zmm24, [rdi + G_ct1]
    vmovups zmm25, [rdi + G_ct1 + 64]
M5p_a11e
    vbroadcastss zmm30, [c_one]
    vbroadcastss zmm31, [c_kq2]
    vbroadcastss zmm23, [rdi + G_cxl]
    vbroadcastss zmm20, [c_q1 + 4]
    vbroadcastss zmm21, [c_q1]
    vbroadcastss zmm22, [c_aq2]
.ibc:
M5p_a11f
M5p_a124
M5p_a128
    jnz .ibc
M5p_a129
.icc:
M5p_a12a
M5p_a137
    dec r11
    jnz .icc
    mov rdi, [rsp + 8]
    mov rax, [rdi + G_su]
    shl rax, 2
    imul rax, [rsp + 40]
    mov rbx, [rdi + G_wo]
    shr rbx, 1
    mov rcx, rbx
    sub rcx, rax
    mov r11, [rdi + G_su]
    shr r11, 2
    mov rdx, rcx
    shr rdx, 4
    xor r13d, r13d
    cmp rdx, r11
    jae .cq
    mov r13d, ecx
    and r13d, 15
    mov r11, rdx
.cq:
    mov edx, 0xffff
    bzhi edx, edx, r13d
    kmovw k5, edx
    imul rbx, [rsp + 16]
    add rax, rbx
    add rax, rax
    mov r8, [rdi + G_db]
    add r8, rax
    mov r14, [rdi + G_dr]
    add r14, rax
    mov r9, [rdi + G_sq]
    lea r10, [rdi + G_ms + 256]
M5p_a13c
    vpbroadcastd zmm28, [c_i512]
    vbroadcastss zmm29, [c_sl]
    vbroadcastss zmm16, [rdi + G_cmx + 0]
    vbroadcastss zmm17, [rdi + G_cmx + 4]
    vbroadcastss zmm18, [rdi + G_cmx + 8]
    vbroadcastss zmm19, [rdi + G_cmx + 12]
    vbroadcastss zmm20, [rdi + G_cmx + 16]
    vbroadcastss zmm21, [rdi + G_cmx + 20]
    test r11, r11
    jz .ct
.ci:
M5p_a14f
M5p_a158
    vpminsd zmm4, zmm4, zmm26
    vpmaxsd zmm5, zmm4, zmm27
    kandw k1, k1, k2
    vpmovdw [r8], zmm3
    vpmovdw [r14], zmm5
    knotw k1, k1
    kmovw [r10], k1
    add r8, 32
    add r14, 32
    add r9, 576
    add r10, 2
    dec r11
    jnz .ci
.ct:
    test r13d, r13d
    jz .cie
M5p_a14f
M5p_a158
    vpminsd zmm4, zmm4, zmm26
    vpmaxsd zmm5, zmm4, zmm27
    kandw k1, k1, k2
    vpmovdw [r8]{k5}, zmm3
    vpmovdw [r14]{k5}, zmm5
    kandnw k1, k1, k5
    kmovw [r10], k1
.cie:
    mov rdi, [rsp + 8]
    inc qword [rsp + 40]
    mov rax, [rsp + 40]
    cmp rax, [rdi + G_nst]
    jb .str
M5p_a2f
    kortestw k1, k1
    jz .nfb
M5p_a32
    kunpckdq k2, k3, k2
    kmovq r13, k2
.sl0b:
    test r13, r13
    jz .se0b
M5p_a34
M5p_a38
    vpcompressd zmm0{k1}{z}, zmm0
    vmovups [r10 + r11*4 + 262144], zmm0
    add r11, r14
    jmp .sl0b
.se0b:
M5p_a3e
M5p_a3f
    kmovq r13, k2
.sl1b:
    test r13, r13
    jz .se1b
M5p_a41
M5p_a38
    vpcompressd zmm0{k1}{z}, zmm0
    vmovups [r10 + r11*4 + 262144], zmm0
    add r11, r14
    jmp .sl1b
.se1b:
M5p_a42
    vptestmw k2, zmm0, zmm0
    kmovd r13d, k2
.slcb:
    test r13d, r13d
    jz .secb
M5p_a43
M5p_a48
    vpcompressd zmm0{k1}{z}, zmm0
    vmovups [r10 + r11*4 + 393216], zmm0
    add r11, r14
    jmp .slcb
.secb:
M5p_a4f
.nfb:
    mov rax, [rsp + 200]
    or rax, [rsp + 208]
    jz .nz
    mov rdi, [rsp + 8]
    xor r13d, r13d
    xor r15d, r15d
    mov rcx, [rsp + 200]
    test rcx, rcx
    jz .uxl
    mov rsi, [rdi + G_sg]
.ubl:
M5p_a166
    call .t1l
    vmovdqa64 [rsp + 256], zmm4
.ujl:
    mov r11d, [rsi + r9*4 + 262144]
    mov rax, [rsp + 256 + r9*8]
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
    mov rcx, [rsp + 208]
    test rcx, rcx
    jz .uxc
    mov rsi, [rdi + G_sg]
    add rsi, 327680
.ubc:
M5p_a166
M5p_a167
    jmp .u2l
.u3l:
    mov qword [rsp + 88], 0
.u2c:
    mov rax, [rsp + 88]
    cmp rax, [rsp + 104]
    jae .u3c
    mov rdi, [rsp + 8]
    mov rcx, [rdi + G_sg]
    mov edx, [rcx + rax*4 + 475136]
    mov qword [rsp + 1216], 1
M5p_a168
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
    inc qword [rsp + 88]
    jmp .u2c
.u3c:
.nz:
    mov r15, [rsp + 48]
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
.t1l:
    vcvtps2pd zmm16, [rsi + 196608]
    vbroadcastsd zmm17, [d_tab]
    vfnmadd231pd zmm17, zmm16, [rdi + G_dan]{1to8}
    vcvtps2pd zmm0, [rsi + 0]
M5p_a16d
    call .ivq
    vmovapd zmm18, zmm0
    vmovapd zmm19, zmm1
    vcvtps2pd zmm0, [rsi + 65536]
M5p_a16d
    call .ivq
    vmovapd zmm20, zmm0
    vmovapd zmm21, zmm1
    vcvtps2pd zmm0, [rsi + 131072]
M5p_a16d
    call .ivq
    vmovapd zmm22, zmm0
    vmovapd zmm23, zmm1
    vbroadcastsd zmm0, [rdi + G_dlo]
    vfmadd231pd zmm0, zmm18, [d_emc0]{1to8}
    vfmadd231pd zmm0, zmm20, [d_emc1]{1to8}
    vfmadd231pd zmm0, zmm22, [d_emc2]{1to8}
    vbroadcastsd zmm1, [rdi + G_dhi]
    vfmadd231pd zmm1, zmm19, [d_emc0]{1to8}
    vfmadd231pd zmm1, zmm21, [d_emc1]{1to8}
    vfmadd231pd zmm1, zmm23, [d_emc2]{1to8}
M5p_a175
    ret
.t1c:
    vcvtps2pd zmm16, [rsi + 49152]
    vbroadcastsd zmm17, [d_tab]
    vfnmadd231pd zmm17, zmm16, [rdi + G_ean]{1to8}
    vcvtps2pd zmm0, [rsi + 0]
    vmulpd zmm0, zmm0, [rdi + G_ekv]{1to8}
    vmovapd zmm1, zmm17
    vbroadcastsd zmm2, [rdi + G_erg]
M5p_a16f
    vcvtps2pd zmm0, [rsi + 16384]
M5p_a177
    call .ivq
    vmovapd zmm20, zmm0
    vmovapd zmm21, zmm1
    vcvtps2pd zmm0, [rsi + 32768]
M5p_a177
    call .ivq
    vmovapd zmm22, zmm0
    vmovapd zmm23, zmm1
    vbroadcastsd zmm0, [rdi + G_elo]
    vfnmadd231pd zmm0, zmm21, [d_emc5]{1to8}
    vfnmadd231pd zmm0, zmm19, [d_emc4]{1to8}
    vfmadd231pd zmm0, zmm22, [d_emc3]{1to8}
    vbroadcastsd zmm1, [rdi + G_ehi]
    vfnmadd231pd zmm1, zmm20, [d_emc5]{1to8}
    vfnmadd231pd zmm1, zmm18, [d_emc4]{1to8}
    vfmadd231pd zmm1, zmm23, [d_emc3]{1to8}
M5p_a175
    vbroadcastsd zmm0, [rdi + G_elo]
    vfnmadd231pd zmm0, zmm23, [d_emc8]{1to8}
    vfnmadd231pd zmm0, zmm21, [d_emc7]{1to8}
    vfmadd231pd zmm0, zmm18, [d_emc6]{1to8}
    vbroadcastsd zmm1, [rdi + G_ehi]
    vfnmadd231pd zmm1, zmm22, [d_emc8]{1to8}
    vfnmadd231pd zmm1, zmm20, [d_emc7]{1to8}
    vfmadd231pd zmm1, zmm19, [d_emc6]{1to8}
M5p_a174
    vpxorq xmm3, xmm3, xmm3
    vpmaxsq zmm2, zmm2, zmm3
    vpternlogq zmm5, zmm5, zmm5, 0xff
    vpminsq zmm5{k1}, zmm2, [d_q1023]{1to8}
    vpternlogq zmm7, zmm7, zmm7, 0xff
    vpcmpeqq k1, zmm5, zmm7
    vmovdqa64 zmm4{k1}, zmm7
    ret
.ivq:
    vrangepd zmm3, zmm0, zmm0, 8
    vfmadd213pd zmm2, zmm3, zmm1
    vsubpd zmm4, zmm3, zmm2
    vcmppd k1, zmm4, zmm2, 0x1e
    vaddpd zmm5, zmm3, zmm2
    vmovapd zmm5{k1}, zmm3
    vpsrlq zmm6, zmm5, 48
    vpsrlq zmm7, zmm5, 52
    vmovapd zmm8, [d_qa]
    vpermt2pd zmm8, zmm7, [d_qa + 64]
    vpsrlq zmm7, zmm5, 56
    vpermpd zmm7, zmm7, [d_qb]
    vmulpd zmm8, zmm8, zmm7
    vmovapd zmm7, [d_qw]
    vpermt2pd zmm7, zmm6, [d_qw + 64]
    vmulpd zmm8, zmm8, zmm7
    vgetmantpd zmm9, zmm5, 4
    vmovapd zmm7, [d_rx]
    vpermt2pd zmm7, zmm6, [d_rx + 64]
    vfmsub213pd zmm9, zmm7, [d_one]{1to8}
    vmulpd zmm10, zmm9, zmm9
    vbroadcastsd zmm11, [d_qp5]
    vfmadd213pd zmm11, zmm9, [d_qp4]{1to8}
    vbroadcastsd zmm12, [d_qp3]
    vfmadd213pd zmm12, zmm9, [d_qp2]{1to8}
    vbroadcastsd zmm13, [d_qp1]
    vfmadd213pd zmm13, zmm9, [d_qp0]{1to8}
    vfmadd213pd zmm11, zmm10, zmm12
    vfmadd213pd zmm11, zmm10, zmm13
M5p_a17b
M5p_a17f
M5p_a187
M5p_a196
M5p_a1a1
    vfmadd231sd xmm2, xmm1, [r15 + 576 + 8]
    vmovsd xmm1, [d_emc2]
M5p_a1a7
    ret
.h2:
    vmovsd xmm0, [d_clo]
    vmovsd xmm1, [d_emc5]
    vfnmadd231sd xmm0, xmm1, [r15 + 576 + 8]
    vmovsd xmm1, [d_emc4]
    vfnmadd231sd xmm0, xmm1, [r15 + 576]
    vmovsd xmm1, [d_emc3]
    vfmadd231sd xmm0, xmm1, [r15 + 512 + 16]
    vmovsd xmm2, [d_chi]
    vmovsd xmm1, [d_emc5]
    vfnmadd231sd xmm2, xmm1, [r15 + 512 + 8]
    vmovsd xmm1, [d_emc4]
    vfnmadd231sd xmm2, xmm1, [r15 + 512]
    vmovsd xmm1, [d_emc3]
M5p_a1a7
    mov r8d, eax
    vmovsd xmm0, [d_clo]
    vmovsd xmm1, [d_emc8]
    vfnmadd231sd xmm0, xmm1, [r15 + 576 + 16]
    vmovsd xmm1, [d_emc7]
    vfnmadd231sd xmm0, xmm1, [r15 + 576 + 8]
    vmovsd xmm1, [d_emc6]
    vfmadd231sd xmm0, xmm1, [r15 + 512]
    vmovsd xmm2, [d_chi]
    vmovsd xmm1, [d_emc8]
    vfnmadd231sd xmm2, xmm1, [r15 + 512 + 16]
    vmovsd xmm1, [d_emc7]
    vfnmadd231sd xmm2, xmm1, [r15 + 512 + 8]
    vmovsd xmm1, [d_emc6]
    vfmadd231sd xmm2, xmm1, [r15 + 576]
M5p_a1a8
M5p_a1ab
M5p_a1af
    vgetmantpd zmm6, zmm8, 4
    vmovapd zmm5, [d_rx]
M5p_a1ba
    vfmadd213pd zmm7, zmm6, [d_p1m2]{1to8}
    vfmadd213pd zmm7, zmm6, [d_p1m1]{1to8}
    vfmadd213pd zmm7, zmm6, [d_p1m0]{1to8}
    vrangepd zmm9, zmm20, [d_one]{1to8}, 11
M5p_a1c0
    vmovapd zmm5, zmm4
    vpternlogq zmm5, zmm20, [d_sgn]{1to8}, 0xd8
M5p_a1c1
M5p_a1c2
    vshufpd xmm11, xmm5, xmm5, 1
    vaddsd xmm5, xmm5, xmm11
    vaddsd xmm4, xmm4, [r15 + 256]
    vmovsd [r15 + 256], xmm4
    vaddsd xmm5, xmm5, [r15 + 320]
    vmovsd [r15 + 320], xmm5
    vrangepd zmm1, zmm21, [d_one]{1to8}, 10
M5p_a1b3
M5p_a1b7
    vfmadd213pd zmm7, zmm6, [d_p1m1]{1to8}
    vfmadd213pd zmm7, zmm6, [d_p1m0]{1to8}
    vrangepd zmm9, zmm21, [d_one]{1to8}, 11
M5p_a1c0
    vmovapd zmm5, zmm4
    vpternlogq zmm5, zmm21, [d_sgn]{1to8}, 0xd8
M5p_a1c1
M5p_a1c2
    vshufpd xmm11, xmm5, xmm5, 1
    vaddsd xmm5, xmm5, xmm11
    vaddsd xmm4, xmm4, [r15 + 264]
    vmovsd [r15 + 264], xmm4
    vaddsd xmm5, xmm5, [r15 + 328]
    vmovsd [r15 + 328], xmm5
    vrangepd zmm1, zmm22, [d_one]{1to8}, 10
M5p_a1b3
M5p_a1b7
    vfmadd213pd zmm7, zmm6, [d_p1m1]{1to8}
    vfmadd213pd zmm7, zmm6, [d_p1m0]{1to8}
    vrangepd zmm9, zmm22, [d_one]{1to8}, 11
M5p_a1c0
    vmovapd zmm5, zmm4
    vpternlogq zmm5, zmm22, [d_sgn]{1to8}, 0xd8
M5p_a1c1
M5p_a1c2
    vshufpd xmm11, xmm5, xmm5, 1
    vaddsd xmm5, xmm5, xmm11
    vaddsd xmm4, xmm4, [r15 + 272]
    vmovsd [r15 + 272], xmm4
    vaddsd xmm5, xmm5, [r15 + 336]
    vmovsd [r15 + 336], xmm5
    ret
T_SY equ 0
T_SB equ 64
T_SR equ 128
T_SW equ 192
T_V equ 256
T_X equ 640
T_ACC equ 1024
T_E equ 1152
T_XS equ 1344
T_ZS equ 1408
.t3:
    lea r10, [rsp + 8 + 2048]
    lea r15, [rsp + 8 + 512]
    lea rbp, [rsp + 8 + 3584]
    mov rdi, [rsp + 8 + 8]
    vpxorq zmm0, zmm0, zmm0
    vmovapd [r10 + T_ACC], zmm0
    vmovapd [r10 + T_ACC + 64], zmm0
M5p_a182
    test rcx, rcx
    jnz .g3c
M5p_a184
    lea rsi, [r14 + 2]
    xor ecx, ecx
    jmp .g3g
.g3c:
    lea r12, [rax*4 - 1]
    xor ebx, ebx
    test rax, rax
    jnz .g3d
    xor r12d, r12d
    mov ebx, 1
.g3d:
M5p_a185
    jnz .g3e
    xor r14d, r14d
    mov ecx, 1
.g3e:
    lea rsi, [rdx*4 + 3]
.g3g:
M5p_a186
.y3:
M5p_a189
    jae .f3
M5p_a18a
    cmp qword [r15 + 728], 0
    je .v3
M5p_a18d
    cmovs rbx, rcx
    add rdx, rbx
.v3:
M5p_a18e
M5p_a193
    xor edx, edx
    div r9
    mov r14, rax
.j3:
    mov rax, r14
    imul rax, r9
    cmp rax, [r15 + 648]
    jae .n3
M5p_a195
    sub rdx, rcx
    cmp qword [r15 + 672], 0
    je .w3
M5p_a198
.w3:
    imul rdx, [r15 + 736]
    mov rsi, [r15 + 688]
    vcvtusi2sd xmm0, xmm0, rdx
    vmovsd [r10 + T_SW + rsi*8], xmm0
    mov rcx, [r15 + 776]
    movzx eax, word [rcx + r14*2]
    vcvtsi2sd xmm0, xmm0, eax
    vmovsd [r10 + T_SY + rsi*8], xmm0
M5p_a19c
    mov rcx, [r15 + 752]
    cmp qword [r15 + 784], 0
    jne .o3
    vmovss xmm0, [rax + rcx*4]
    vmovss xmm1, [rbx + rcx*4]
    jmp .q3
.o3:
M5p_a19d
M5p_a19e
    vmulss xmm3, xmm3, [c_h0625]
    vfmsub132ss xmm0, xmm2, [c_h5625]
    vfmsub132ss xmm1, xmm3, [c_h5625]
.q3:
M5p_a19f
M5p_a1d1
M5p_a1d4
M5p_a1d7
M5p_a1db
M5p_a1de
    mov eax, [r10 + T_X + 8]
    and eax, [r10 + T_X + 12]
    test al, 1
    jnz .t3m
    call .xr
    test byte [r10 + T_X + 8], 1
    jnz .t3k0
    mov rax, [r10 + T_XS + 16]
M5p_a1e3
    test rdx, rdx
    jns .rp2
    add rdx, rcx
    dec rax
.rp2:
    add rdx, rdx
    cmp rdx, rcx
    jb .rq2
    ja .rr2
    test al, 1
    jz .rq2
.rr2:
    inc rax
.rq2:
M5p_a1d9
    cmp rax, rcx
    cmovg rax, rcx
    mov dword [r10 + T_X + 0], eax
.t3k0:
    test byte [r10 + T_X + 12], 1
    jnz .t3k1
    mov rax, [r10 + T_XS + 24]
M5p_a1e3
    test rdx, rdx
    jns .rp3
    add rdx, rcx
    dec rax
.rp3:
    add rdx, rdx
    cmp rdx, rcx
    jb .rq3
    ja .rr3
    test al, 1
    jz .rq3
.rr3:
    inc rax
.rq3:
M5p_a1d9
    cmp rax, rcx
    cmovg rax, rcx
    mov dword [r10 + T_X + 4], eax
.t3k1:
M5p_a1e4
M5p_a1e7
M5p_a1ea
M5p_a1ed
M5p_a1fa
M5p_a206
    vsubsd xmm6, xmm0, xmm7
    vsubsd xmm5, xmm0, xmm6
    vsubsd xmm5, xmm7, xmm5
    vsubsd xmm6, xmm2, xmm6
    vaddsd xmm5, xmm5, xmm6
    vaddsd xmm6, xmm4, xmm0
M5p_a213
    vaddsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm5, xmm0
    vsubsd xmm4, xmm6, xmm4
    vmovsd xmm2, [r10 + T_X + 48]
    vmovsd xmm1, [r10 + T_X + 112]
M5p_a216
M5p_a217
M5p_a218
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
M5p_a1f1
    vsubsd xmm4, xmm8, xmm4
M5p_a21b
M5p_a21e
    vaddsd xmm7, xmm4, xmm9
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm9, xmm3
    vmovsd [r10 + T_ACC + 0], xmm7
    vmovsd [r10 + T_ACC + 64], xmm3
    vmovsd xmm0, [r10 + T_ACC + 8]
    vmovsd xmm1, [r10 + T_ACC + 72]
    vmovsd xmm2, [r10 + T_X + 128]
    vmovsd xmm3, [r10 + T_X + 192]
M5p_a1f0
M5p_a1f2
M5p_a1f3
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm2, xmm3
    vmovsd xmm9, [r10 + T_X + 136]
    vmovsd xmm8, [r10 + T_X + 200]
M5p_a1f4
M5p_a1f8
M5p_a1fd
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [r10 + T_X + 144]
    vmovsd xmm5, [r10 + T_X + 208]
M5p_a201
M5p_a202
M5p_a203
    vaddsd xmm1, xmm3, xmm6
    vsubsd xmm5, xmm1, xmm3
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [r10 + T_X + 152]
    vmovsd xmm0, [r10 + T_X + 216]
M5p_a204
M5p_a205
M5p_a209
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm0, xmm3, xmm8
    vsubsd xmm0, xmm2, xmm0
    vmovsd xmm9, [r10 + T_X + 160]
    vmovsd xmm7, [r10 + T_X + 224]
M5p_a20b
M5p_a20c
M5p_a20d
    vaddsd xmm8, xmm5, xmm9
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm7, xmm9, xmm7
    vmovsd xmm6, [r10 + T_X + 168]
    vmovsd xmm4, [r10 + T_X + 232]
M5p_a20e
M5p_a20f
M5p_a213
    vaddsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm5, xmm0
    vsubsd xmm4, xmm6, xmm4
    vmovsd xmm2, [r10 + T_X + 176]
    vmovsd xmm1, [r10 + T_X + 240]
M5p_a216
M5p_a217
M5p_a218
    vaddsd xmm0, xmm7, xmm2
    vsubsd xmm1, xmm0, xmm7
    vsubsd xmm1, xmm2, xmm1
    vmovsd xmm9, [r10 + T_X + 184]
    vmovsd xmm3, [r10 + T_X + 248]
M5p_a219
M5p_a21b
M5p_a21e
    vaddsd xmm7, xmm4, xmm9
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm9, xmm3
    vmovsd [r10 + T_ACC + 8], xmm7
    vmovsd [r10 + T_ACC + 72], xmm3
    vmovsd xmm0, [r10 + T_ACC + 16]
    vmovsd xmm1, [r10 + T_ACC + 80]
    vmovsd xmm2, [r10 + T_X + 256]
    vmovsd xmm3, [r10 + T_X + 320]
M5p_a1f0
M5p_a1f2
M5p_a1f3
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm2, xmm3
    vmovsd xmm9, [r10 + T_X + 264]
    vmovsd xmm8, [r10 + T_X + 328]
M5p_a1f4
M5p_a1f8
M5p_a1fd
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [r10 + T_X + 272]
    vmovsd xmm5, [r10 + T_X + 336]
M5p_a201
M5p_a202
M5p_a203
    vaddsd xmm1, xmm3, xmm6
    vsubsd xmm5, xmm1, xmm3
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [r10 + T_X + 280]
    vmovsd xmm0, [r10 + T_X + 344]
M5p_a204
M5p_a205
M5p_a209
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm0, xmm3, xmm8
    vsubsd xmm0, xmm2, xmm0
    vmovsd xmm9, [r10 + T_X + 288]
    vmovsd xmm7, [r10 + T_X + 352]
M5p_a20b
M5p_a20c
M5p_a20d
    vaddsd xmm8, xmm5, xmm9
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm7, xmm9, xmm7
    vmovsd xmm6, [r10 + T_X + 296]
    vmovsd xmm4, [r10 + T_X + 360]
M5p_a20e
M5p_a20f
M5p_a213
    vaddsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm5, xmm0
    vsubsd xmm4, xmm6, xmm4
    vmovsd xmm2, [r10 + T_X + 304]
    vmovsd xmm1, [r10 + T_X + 368]
M5p_a216
M5p_a217
M5p_a218
    vaddsd xmm0, xmm7, xmm2
    vsubsd xmm1, xmm0, xmm7
    vsubsd xmm1, xmm2, xmm1
    vmovsd xmm9, [r10 + T_X + 312]
    vmovsd xmm3, [r10 + T_X + 376]
M5p_a219
M5p_a21b
M5p_a21e
    vaddsd xmm7, xmm4, xmm9
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm9, xmm3
    vmovsd [r10 + T_ACC + 16], xmm7
    vmovsd [r10 + T_ACC + 80], xmm3
    ret
.xr:
    lea r10, [rsp + 16 + 2048]
    lea r15, [rsp + 16 + 512]
    mov rdi, [rsp + 16 + 8]
    vpxorq xmm0, xmm0, xmm0
    vmovdqa64 [r10 + T_XS], zmm0
    vmovdqa64 [r10 + T_ZS], zmm0
M5p_a182
    test rcx, rcx
    jnz .g4c
M5p_a184
    lea rsi, [r14 + 2]
    xor ecx, ecx
    jmp .g4g
.g4c:
    lea r12, [rax*4 - 1]
    xor ebx, ebx
    test rax, rax
    jnz .g4d
    xor r12d, r12d
    mov ebx, 1
.g4d:
M5p_a185
    jnz .g4e
    xor r14d, r14d
    mov ecx, 1
.g4e:
    lea rsi, [rdx*4 + 3]
.g4g:
M5p_a186
.y4:
M5p_a189
    jae .f4
M5p_a18a
    cmp qword [r15 + 728], 0
    je .v4
M5p_a18d
    cmovs rbx, rcx
    add rdx, rbx
.v4:
M5p_a18e
M5p_a193
    xor edx, edx
    div r9
    mov r14, rax
.j4:
    mov rax, r14
    imul rax, r9
    cmp rax, [r15 + 648]
    jae .n4
M5p_a195
    sub rdx, rcx
    cmp qword [r15 + 672], 0
    je .w4
M5p_a198
.w4:
    imul rdx, [r15 + 736]
    add [r10 + T_XS], rdx
    mov [r10 + T_ZS + 48], rdx
    mov rcx, [r15 + 776]
    movzx eax, word [rcx + r14*2]
    mov [r10 + T_ZS + 56], rax
    imul rax, rdx
    add [r10 + T_XS + 8], rax
M5p_a19c
    mov rcx, [r15 + 752]
    cmp qword [r15 + 784], 0
    jne .o4
    vmovss xmm0, [rax + rcx*4]
    vmovss xmm1, [rbx + rcx*4]
    jmp .q4
.o4:
M5p_a19d
M5p_a19e
    vmulss xmm3, xmm3, [c_h0625]
    vfmsub132ss xmm0, xmm2, [c_h5625]
    vfmsub132ss xmm1, xmm3, [c_h5625]
.q4:
M5p_a19f
    vmulsd xmm0, xmm0, [d_2p20]
    vcvttsd2si r12, xmm0
    vmulsd xmm1, xmm1, [d_2p20]
    vcvttsd2si r13, xmm1
    lea rax, [r12 + 0x20000000]
    imul rax, [r10 + T_ZS + 48]
    add [r10 + T_XS + 16], rax
    lea rax, [r13 + 0x20000000]
    imul rax, [r10 + T_ZS + 48]
    add [r10 + T_XS + 24], rax
    mov rbx, [r10 + T_ZS + 56]
    imul r12, [d_xys]
    imul r13, [d_xys]
    sub rbx, [d_xyb]
    imul rbx, [d_xec]
    imul rax, r13, 14746
M5p_a23d
    movsx rcx, cl
    add [r10 + T_ZS + 0], rcx
    imul rax, r12, 18814
M5p_a23d
    movsx rcx, cl
    add [r10 + T_ZS + 16], rcx
    mov rax, rbx
    mov rcx, 6780
    imul rcx
    mov rbx, rax
    mov rsi, rdx
    mov rax, r13
    mov rcx, 38737742
    imul rcx
    sub rbx, rax
    sbb rsi, rdx
    mov rax, r12
    mov rcx, 11156702
    imul rcx
    sub rbx, rax
    sbb rsi, rdx
    mov rax, [d_xdg]
    mov rdx, [d_xdg + 8]
    mov r12, rbx
    mov r13, rsi
    sub r12, rax
    sbb r13, rdx
    setns cl
    add rbx, rax
    adc rsi, rdx
    sets dl
    or rbx, rsi
    setz al
    or dl, al
    sub cl, dl
    movsx rcx, cl
    add [r10 + T_ZS + 8], rcx
    inc qword [r10 + T_ZS + 24]
    inc r14
    jmp .j4
.n4:
    inc qword [r15 + 696]
    jmp .y4
.f4:
    mov rax, [r10 + T_ZS + 0]
M5p_a240
    jne .xud
    mov rax, [r10 + T_ZS + 8]
M5p_a240
    jne .xud
    mov rax, [r10 + T_ZS + 16]
M5p_a240
M5p_a243
M5p_a246
M5p_a249
M5p_a24c
M5p_a24f
M5p_a253
M5p_a256
M5p_a259
    vsubpd zmm21, zmm3, zmm2
    vsubpd zmm21, zmm16, zmm21
    vsubpd zmm2, zmm25, zmm2
    vaddpd zmm21, zmm21, zmm2
    vaddpd zmm2, zmm17, zmm20
    vsubpd zmm29, zmm2, zmm17
    vsubpd zmm28, zmm2, zmm29
    vsubpd zmm28, zmm17, zmm28
    vsubpd zmm29, zmm20, zmm29
    vaddpd zmm28, zmm28, zmm29
    vaddpd zmm29, zmm21, zmm2
    vaddpd zmm2, zmm3, zmm29
    vsubpd zmm21, zmm2, zmm3
    vsubpd zmm21, zmm29, zmm21
    vaddpd zmm29, zmm21, zmm28
    vaddpd zmm28, zmm2, zmm29
    vsubpd zmm21, zmm28, zmm2
    vsubpd zmm21, zmm29, zmm21
    vmovapd zmm28{k5}, zmm0
    vmovapd zmm21{k5}, zmm0
    vmulpd zmm16, zmm28, zmm1
    vmulpd zmm17, zmm21, zmm1
    ret
.xoe:
M5p_a250
    vcmppd k6, zmm19, zmm18, 0x1e
    vbroadcastsd zmm21, [d_mone]
    vbroadcastsd zmm22, [d_mzero]
    vaddpd zmm23, zmm19, zmm21
    vsubpd zmm24, zmm23, zmm19
    vsubpd zmm25, zmm23, zmm24
    vsubpd zmm25, zmm19, zmm25
    vsubpd zmm24, zmm21, zmm24
    vaddpd zmm25, zmm25, zmm24
    vaddpd zmm24, zmm20, zmm22
    vsubpd zmm26, zmm24, zmm20
    vsubpd zmm27, zmm24, zmm26
    vsubpd zmm27, zmm20, zmm27
    vsubpd zmm26, zmm22, zmm26
    vaddpd zmm27, zmm27, zmm26
    vaddpd zmm26, zmm25, zmm24
    vaddpd zmm24, zmm23, zmm26
    vsubpd zmm25, zmm24, zmm23
M5p_a25d
M5p_a260
M5p_a263
M5p_a266
M5p_a269
M5p_a26c
M5p_a26f
    ret
section .note.GNU-stack noalloc noexec nowrite progbits
