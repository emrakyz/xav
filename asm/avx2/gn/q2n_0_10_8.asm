%include "q2nm.inc"
default rel
%use smartalign
alignmode p6, 32
%include "gq2o.inc"
%include "gqimg.inc"
M2p_a0
M2p_a1
M2p_a2
M2p_a3
M2p_a4
M2p_a5
global xav_q2_0_10_8
align 64
xav_q2_0_10_8:
M2p_a6
    dec r14
    jnz .cv1
.cvt:
    vmovdqu ymm6, [rdi + G_ri]
M2p_a7
    vcvtdq2ps ymm0, ymm0
    vcvtdq2ps ymm1, ymm1
    vpermps ymm0, ymm6, ymm0
    vpermps ymm1, ymm6, ymm1
    vmovups [r10 + rax*4], ymm0
    vmovups [r11 + rax*4], ymm1
    vmovdqu ymm6, [c_7]
    vpermps ymm0, ymm6, ymm0
    vpermps ymm1, ymm6, ymm1
    vmovups [r10 + rax*4 + 32], ymm0
    vmovups [r11 + rax*4 + 32], ymm1
    vbroadcastss ymm0, [r10]
    vbroadcastss ymm1, [r11]
    vmovups [r10 - 32], ymm0
    vmovups [r11 - 32], ymm1
    vmovaps ymm6, [c_9]
    vmovaps ymm7, [c_16]
    xor eax, eax
.cv2:
    vmovups ymm0, [r10 + rax*4]
    vaddps ymm1, ymm0, [r10 + rax*4 + 4]
    vmovups ymm2, [r10 + rax*4 - 4]
    vaddps ymm2, ymm2, [r10 + rax*4 + 8]
M2p_a9
    vperm2f128 ymm5, ymm3, ymm4, 0x20
    vperm2f128 ymm3, ymm3, ymm4, 0x31
    vmovups [r12], ymm5
    vmovups [r12 + 32], ymm3
    vmovups ymm0, [r11 + rax*4]
    vaddps ymm1, ymm0, [r11 + rax*4 + 4]
    vmovups ymm2, [r11 + rax*4 - 4]
    vaddps ymm2, ymm2, [r11 + rax*4 + 8]
M2p_a9
    vperm2f128 ymm5, ymm3, ymm4, 0x20
    vperm2f128 ymm3, ymm3, ymm4, 0x31
    vmovups [r12 + r15], ymm5
    vmovups [r12 + r15 + 32], ymm3
    add r12, 64
    add eax, 8
    dec r13
    jnz .cv2
    inc qword [rbp + 5632]
    jmp .rg
.rgd:
    mov qword [rbp + 5640], 0
.str:
    mov rdi, [rbp + 5608]
    mov r15, [rbp + 5648]
    mov rax, [rbp + 5640]
    imul rax, [rdi + G_sp]
M2p_aa
M2p_ab
M2p_ac
M2p_a1f
M2p_a21
    vmovaps ymm4, ymm0
    vfmadd231ps ymm4, ymm2, ymm7
    vfmadd231ps ymm4, ymm2, ymm8
    vmovups [r8 + 192], ymm4
M2p_a19
    vfmadd231ps ymm3, ymm2, ymm10
    vsubps ymm4, ymm4, ymm3
    vmovups [r8 + 224], ymm4
    vfmadd231ps ymm0, ymm1, ymm13
M2p_a24
    add r8, 384
    dec r12d
    jnz .a0q
.a0qt:
    test r10d, 1
    jz .a0x
M2p_a11
M2p_a1b
    vmovups [r8 + 64], ymm0
    jmp .a0x
.a0e:
    test r12d, r12d
    jz .a0pt
align 32
.a0p:
M2p_a10
    mov eax, [rsi + Rc_co + 4]
    mov ecx, [rsi + Rc_co]
    mov r14d, [rsi + Rc_co + 8]
    mov ebx, [rsi + Rc_co + 12]
M2p_a1f
M2p_a21
M2p_a15
    vpslld ymm0, ymm0, 4
    vcvtdq2ps ymm0, ymm0
    mov eax, [rsi + RCS + Rc_co + 4]
M2p_a13
M2p_a23
    jnz .a0p
.a0pt:
M2p_a27
    vpslld ymm0, ymm0, 4
    vcvtdq2ps ymm0, ymm0
M2p_a28
M2p_a14
M2p_a1a
    vfmadd231ps ymm0, ymm1, ymm14
    vmovups [r8 + 64], ymm0
.a0x:
.bkn:
.bka:
    lea rax, [rdi - 1]
    cmp rax, [rbp + 5664]
    jae .bkb
    mov r8, [rbp + 5768]
    mov r12d, [r15 + Pc_nr]
align 32
.a1:
    vmovaps ymm15, [c_absm]
    vandps ymm0, ymm15, [r8 + 0]
    vandps ymm5, ymm15, [r8 + 32]
    vandps ymm10, ymm15, [r8 + 64]
    vmovaps ymm15, [c_flq]
    vpmaxsd ymm0, ymm0, ymm15
    vpsrld ymm1, ymm0, 20
    vpmaxsd ymm5, ymm5, ymm15
    vpsrld ymm6, ymm5, 20
    vpmaxsd ymm10, ymm10, ymm15
    vpsrld ymm11, ymm10, 20
    vmovaps ymm15, [c_rq]
    vpermps ymm3, ymm1, ymm15
    vpermps ymm8, ymm6, ymm15
    vpermps ymm13, ymm11, ymm15
    vmovaps ymm15, [c_mant]
M2p_a2d
M2p_a2e
M2p_a32
    vxorps ymm7, ymm7, ymm7
.be2:
    mov ecx, [r15 + Pc_n + 24]
    test ecx, ecx
    jz .bu3
.bl3:
M2p_a31
    add r8, 192
    dec ecx
    jnz .bl3
.bu3:
    mov eax, [r15 + Pc_n + 28]
    test eax, eax
    jnz .bs3
M2p_a36
M2p_a38
    test byte [r15 + Pc_co], 1
    jnz .bn3
M2p_a39
    vmovss xmm0, [rsi + rdx*4 + 32]
    vmovss [r10 + r11*4 + 65536], xmm0
    vmovss xmm0, [rsi + rdx*4 + 64]
    vmovss [r10 + r11*4 + 131072], xmm0
M2p_a49
    inc r11
    test r14d, r14d
    jnz .sj0a
    jmp .sv0a
.sw0a:
M2p_a3d
    lea rdx, [rdx*2 + 1]
    shl rdx, 16
    lea r12, [rdx + rax]
    mov rbx, r8
    shl rbx, 7
    add rbx, [rdi + G_cl]
    vmovdqu ymm0, [rdi + G_ms + 64]
    vmovdqu ymm1, [rdi + G_ms + 96]
M2p_a3f
    mov r13, rax
.sv1a:
    test r13, r13
    jz .sw1a
    tzcnt rcx, r13
    blsr r13, r13
    movzx r14d, byte [rdi + G_ms + 64 + rcx]
M2p_a43
    add ecx, r12d
.sj1a:
M2p_a45
M2p_a49
    inc r11
    test r14d, r14d
    jnz .sj1a
    jmp .sv1a
.sw1a:
    mov [rbp + 5816], r11
    mov r11, [rbp + 5824]
    add r10, 327680
    mov rax, r8
    shl rax, 2
    imul rax, r9
    mov rdx, [rbp + 5616]
    shl rdx, 16
    lea r12, [rdx + rax]
    mov rbx, [rdi + G_cc]
    vmovdqu ymm0, [rdi + G_ms + 128]
    vmovdqu ymm1, [rdi + G_ms + 160]
M2p_a3f
    mov r13, rax
.sv2a:
    test r13, r13
    jz .sw2a
    tzcnt rcx, r13
    blsr r13, r13
    movzx r14d, byte [rdi + G_ms + 128 + rcx]
M2p_a43
    add ecx, r12d
.sj2a:
M2p_a44
M2p_a54
M2p_a59
M2p_a5c
    vmovups ymm8, [rcx + 0]
    vmovups ymm9, [rcx + 32]
    vmovups ymm10, [rcx + 64]
    vmovups ymm11, [rcx + 96]
    vmovups ymm12, [rcx + 128]
    vmovups ymm13, [rcx + 160]
    vmovups ymm6, [rcx + 192]
    vmovups ymm7, [rcx + 224]
M2p_a5d
M2p_a5e
M2p_a5f
.hu:
M2p_a60
M2p_a79
M2p_a94
M2p_aa9
M2p_aba
M2p_ace
M2p_adc
M2p_aeb
M2p_af3
M2p_af7
M2p_aff
    vpermps ymm1, ymm3, [r9 + 224]
M2p_a106
M2p_a10a
M2p_a10d
M2p_a113
M2p_a117
M2p_a120
M2p_a124
M2p_a128
M2p_a12c
M2p_a135
M2p_a13a
M2p_a149
M2p_a14d
M2p_a151
M2p_a156
M2p_a15d
M2p_a161
M2p_a167
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 288]
    lea rax, [r9 + r14]
M2p_ab5
M2p_ac9
M2p_ad9
M2p_ae4
M2p_aee
M2p_af5
M2p_a16b
M2p_a176
M2p_a179
M2p_a17d
M2p_a180
M2p_a186
M2p_a18a
M2p_a193
M2p_a196
M2p_a19c
M2p_a1a0
M2p_a1ac
M2p_a1b1
M2p_a1b9
M2p_a1bd
M2p_a1c3
M2p_a1c7
M2p_a1cd
M2p_a1d3
M2p_a1d7
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm4, ymm0, [rcx + 288]
    lea rax, [r15 + r14]
M2p_ab5
M2p_ac9
M2p_ad9
M2p_ae4
M2p_aee
M2p_a1dc
    add r9, rbx
    add r15, rbx
    vmovaps ymm15, ymm4
M2p_a60
M2p_a79
M2p_a94
M2p_aa9
M2p_aba
M2p_ace
M2p_adc
M2p_aeb
M2p_af3
    vaddps ymm0, ymm4, ymm5
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r10 + 128], ymm0
M2p_af8
M2p_a114
M2p_a133
M2p_a158
M2p_aba
M2p_ace
M2p_adc
M2p_aeb
M2p_af3
    vaddps ymm0, ymm4, ymm5
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r11 + 128], ymm0
M2p_a16e
M2p_a187
M2p_a1aa
M2p_a1c9
M2p_aba
M2p_ace
M2p_adc
M2p_aeb
M2p_af3
    vpermpd ymm4, ymm4, 0xd8
    vpermpd ymm5, ymm5, 0xd8
M2p_a1e6
    add r8, rbx
    add r9, rbx
    add r15, rbx
    vshufps ymm0, ymm15, ymm4, 0x88
    vshufps ymm1, ymm15, ymm4, 0xdd
    vaddps ymm0, ymm0, ymm1
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r12], ymm0
    add r10, 256
    add r11, 256
    add r12, 128
    dec rsi
    jnz .hu
    mov rax, [rbp + 5680]
    shl rax, 5
    add rax, [rdi + G_oc]
    vmovups [rax], ymm14
    inc qword [rbp + 5680]
    cmp qword [rbp + 5680], 4
    jb .hc
    mov rdi, [rbp + 5608]
    mov r8, [rdi + G_cl]
    mov rcx, [rdi + G_su]
    add rcx, rcx
    mov r9, [rdi + G_sq]
    mov r11, rcx
    mov r10, r8
    vbroadcastss ymm15, [rdi + G_lta]
    vbroadcastss ymm14, [rdi + G_lan]
    vbroadcastss ymm13, [rdi + G_lrg]
    vbroadcastss ymm12, [rdi + G_lxl]
    vmovaps ymm11, [c_nieq]
    vbroadcastss ymm7, [rdi + G_lom]
    vbroadcastss ymm8, [rdi + G_lom + 4]
    vbroadcastss ymm9, [rdi + G_lom + 8]
align 32
.ial:
    vmovaps ymm10, ymm15
    vfnmadd231ps ymm10, ymm14, [r10 + 96]
    vmovups ymm0, [r10 + 0]
M2p_a1f6
    vpblendvb ymm5, ymm11, ymm5, ymm3
    vmovaps ymm6, ymm7
    vfnmadd231ps ymm6, ymm5, [c_eqp]
    vmovups [r9 + 32], ymm4
    vmovups [r9 + 64], ymm6
    vmovups ymm0, [r10 + 32]
M2p_a1f6
    vpblendvb ymm5, ymm11, ymm5, ymm3
    vmovaps ymm6, ymm8
    vfnmadd231ps ymm6, ymm5, [c_eqp]
    vmovups [r9 + 128], ymm4
    vmovups [r9 + 160], ymm6
    vmovups ymm0, [r10 + 64]
M2p_a1f6
    vpblendvb ymm5, ymm11, ymm5, ymm3
M2p_a1fe
    add r10, 128
    add r9, 288
    dec r11
    jnz .ial
    mov r9, [rdi + G_sq]
    mov r11, rcx
align 32
.ibl:
M2p_a1ff
    vandps ymm11, ymm10, ymm15
    vpsrld ymm12, ymm10, 20
    vbroadcastss ymm15, [rdi + G_lxl]
M2p_a200
    vmaxps ymm11, ymm11, ymm15
    vpsrld ymm13, ymm11, 23
    vmovups ymm15, [rdi + G_ltl]
M2p_a201
M2p_a20f
    jnz .ibl
    mov r9, [rdi + G_sq]
    mov r11, rcx
align 32
.icl:
M2p_a210
M2p_a215
    vfmadd213ps ymm9, ymm7, ymm15
    vfmadd213ps ymm14, ymm12, ymm15
    vbroadcastss ymm15, [rdi + G_lon]
M2p_a216
M2p_a21f
M2p_a223
    jnz .icl
    mov rdi, [rbp + 5608]
    mov rax, [rdi + G_su]
    shl rax, 3
    imul rax, [rbp + 5640]
    mov [rbp + 5696], rax
    mov rcx, [rdi + G_wo]
    sub rcx, rax
    mov rdx, [rdi + G_su]
M2p_a224
    mov [rbp + 5832], rcx
    mov qword [rbp + 5712], 0
.et:
    mov rdi, [rbp + 5608]
    vbroadcastss ymm13, [rdi + G_lmx]
    vbroadcastss ymm14, [rdi + G_lmx + 4]
    vbroadcastss ymm15, [rdi + G_lmx + 8]
    vmovaps ymm12, [c_sl]
    mov r8, [rdi + G_su]
    imul r8, [rbp + 5712]
    imul r8, r8, 288
    add r8, [rdi + G_sq]
    mov rax, [rbp + 5616]
    add rax, rax
    add rax, [rbp + 5712]
    imul rax, [rdi + G_wo]
    add rax, [rbp + 5696]
    add rax, rax
    add rax, [rdi + G_dy]
    mov r9, rax
    mov rax, [rbp + 5712]
    shl rax, 6
    lea r11, [rdi + G_ms + rax]
    mov rbx, [rbp + 5704]
    vmovdqu ymm8, [c_absm]
    vmovaps ymm9, [c_half]
    vmovdqu ymm10, [c_i64]
    vmovdqu ymm11, [c_i1023]
    test rbx, rbx
    jz .ep
align 32
.ed:
M2p_a229
    vpackusdw xmm3, xmm3, xmm4
    vmovdqu [r9], xmm3
    vmovmskps eax, ymm2
    mov [r11], al
    add r8, 288
    add r9, 16
    inc r11
    dec rbx
    jnz .ed
.ep:
    mov rcx, [rbp + 5832]
    test rcx, rcx
    jz .ee
M2p_a229
    vpackusdw xmm3, xmm3, xmm4
    vmovmskps eax, ymm2
    bzhi eax, eax, ecx
    mov [r11], al
    vmovdqu [rbp + 7136], xmm3
    mov r14, rsi
    lea rsi, [rbp + 7136]
    mov rdi, r9
    rep movsw
    mov rsi, r14
.ee:
    inc qword [rbp + 5712]
    cmp qword [rbp + 5712], 2
    jb .et
    mov rdi, [rbp + 5608]
    mov r8, [rdi + G_cc]
    mov rcx, [rdi + G_su]
    shr rcx, 1
    mov r9, [rdi + G_sq]
    mov r11, rcx
    mov r10, r8
    vbroadcastss ymm15, [rdi + G_cta]
    vbroadcastss ymm14, [rdi + G_can]
    vbroadcastss ymm13, [rdi + G_crg]
    vbroadcastss ymm12, [rdi + G_cxl]
    vmovaps ymm11, [c_nieq]
    vbroadcastss ymm7, [rdi + G_com]
    vbroadcastss ymm8, [rdi + G_com + 4]
    vbroadcastss ymm9, [rdi + G_com + 8]
align 32
.iac:
M2p_a1f5
M2p_a1f7
M2p_a1fe
    add r10, 128
    add r9, 288
    dec r11
    jnz .iac
    mov r9, [rdi + G_sq]
    mov r11, rcx
align 32
.ibc:
M2p_a1ff
    vandps ymm11, ymm10, ymm15
    vpsrld ymm12, ymm10, 20
    vbroadcastss ymm15, [rdi + G_cxl]
M2p_a200
    vmaxps ymm11, ymm11, ymm15
    vpsrld ymm13, ymm11, 23
    vmovups ymm15, [rdi + G_ctl]
M2p_a201
M2p_a20f
    jnz .ibc
    mov r9, [rdi + G_sq]
    mov r11, rcx
align 32
.icc:
M2p_a210
M2p_a215
    vfmadd213ps ymm9, ymm7, ymm15
    vfmadd213ps ymm14, ymm12, ymm15
    vbroadcastss ymm15, [rdi + G_con]
M2p_a216
M2p_a21f
M2p_a223
    jnz .icc
    mov rdi, [rbp + 5608]
    mov rax, [rdi + G_su]
    shl rax, 2
    imul rax, [rbp + 5640]
    mov [rbp + 5696], rax
    mov rcx, [rdi + G_wo]
    shr rcx, 1
    sub rcx, rax
    mov rdx, [rdi + G_su]
    shr rdx, 1
M2p_a224
    mov [rbp + 5832], rcx
    mov r8, [rdi + G_sq]
    mov rax, [rdi + G_wo]
    shr rax, 1
    imul rax, [rbp + 5616]
    add rax, [rbp + 5696]
    add rax, rax
    mov r9, [rdi + G_db]
    add r9, rax
    mov r12, [rdi + G_dr]
    add r12, rax
    lea r11, [rdi + G_ms + 128]
    vmovdqu ymm13, [c_absm]
    vmovaps ymm14, [c_half]
    vmovdqu ymm15, [c_i512]
    vmovdqu ymm8, [c_i1023]
    vmovaps ymm2, [c_sl]
    test rbx, rbx
    jz .cp
align 32
.cd:
M2p_a234
M2p_a23b
    vpackusdw xmm11, xmm11, xmm4
    vmovdqu [r9], xmm9
    vmovdqu [r12], xmm11
    vmovmskps eax, ymm10
    mov [r11], al
    add r8, 288
    add r9, 16
    add r12, 16
    inc r11
    dec rbx
    jnz .cd
.cp:
    mov rcx, [rbp + 5832]
    test rcx, rcx
    jz .ce
M2p_a234
M2p_a23b
    vpackusdw xmm11, xmm11, xmm4
    vmovmskps eax, ymm10
    bzhi eax, eax, ecx
    mov [r11], al
    vmovdqu [rbp + 7136], xmm9
    lea rsi, [rbp + 7136]
    mov rdi, r9
    rep movsw
    mov rcx, [rbp + 5832]
    vmovdqu [rbp + 7136], xmm11
    lea rsi, [rbp + 7136]
    mov rdi, r12
    rep movsw
.ce:
    mov rdi, [rbp + 5608]
    inc qword [rbp + 5640]
    mov rax, [rbp + 5640]
    cmp rax, [rdi + G_nst]
    jb .str
M2p_a3b
    jz .nfb
M2p_a3c
M2p_a3f
    mov r13, rax
.sv0b:
    test r13, r13
    jz .sw0b
M2p_a42
.sj0b:
M2p_a45
M2p_a49
    inc r11
    test r14d, r14d
    jnz .sj0b
    jmp .sv0b
.sw0b:
M2p_a3d
M2p_a4a
    mov r13, rax
.sv1b:
    test r13, r13
    jz .sw1b
M2p_a4c
.sj1b:
M2p_a45
M2p_a49
    inc r11
    test r14d, r14d
    jnz .sj1b
    jmp .sv1b
.sw1b:
M2p_a4d
M2p_a40
    mov r13, rax
.sv2b:
    test r13, r13
    jz .sw2b
M2p_a52
.sj2b:
M2p_a44
M2p_a53
    inc r11
    test r14d, r14d
    jnz .sj2b
    jmp .sv2b
.sw2b:
M2p_a57
    vmovdqu [rdi + G_ms + 160], ymm0
.nfb:
    mov rax, [rbp + 5816]
    or rax, [rbp + 5824]
    jz .nz
    mov rdi, [rbp + 5608]
    xor r13d, r13d
    xor r15d, r15d
    vpxor xmm0, xmm0, xmm0
    vmovdqa [rbp + T_QF], ymm0
    mov rcx, [rbp + 5816]
    test rcx, rcx
    jz .uxl
    mov rsi, [rdi + G_sg]
.ubl:
M2p_a247
    mov [rbp + 5744], rcx
    call .t1l
    vmovdqa [rbp + 7136], xmm4
    mov rcx, [rbp + 5744]
.ujl:
    mov r11d, [rsi + r9*4 + 262144]
    mov eax, [rbp + 7136 + r9*4]
    test eax, eax
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
    add rsi, 16
    sub rcx, 4
    jg .ubl
.uxl:
    mov rcx, [rbp + 5824]
    test rcx, rcx
    jz .uxc
    mov rsi, [rdi + G_sg]
    add rsi, 327680
.ubc:
M2p_a247
    mov [rbp + 5744], rcx
    call .t1c
    vmovdqa [rbp + 7136], xmm4
    vmovdqa [rbp + 7152], xmm5
    mov rcx, [rbp + 5744]
.ujc:
M2p_a249
    mov rax, [rbp + 5720]
    cmp rax, [rbp + 5736]
    jae .u3c
    mov rdi, [rbp + 5608]
    mov rcx, [rdi + G_sg]
    mov edx, [rcx + rax*4 + 475136]
    mov qword [rbp + 5928], 1
M2p_a24d
    mov [rbp + 5944], rdx
    call .t2
    test eax, eax
    jns .tq2
    call .t3
    .tq2:
    mov rdi, [rbp + 5608]
    mov rdx, [rdi + G_wo]
    shr rdx, 1
    imul rdx, [rbp + 5936]
    add rdx, [rbp + 5944]
    mov rcx, [rdi + G_db]
    mov [rcx + rdx*2], ax
    shr eax, 16
    mov rcx, [rdi + G_dr]
    mov [rcx + rdx*2], ax
M2p_a251
    vfmadd231ps ymm2, ymm15, ymm12
    vfmadd231ps ymm6, ymm15, ymm13
    vxorps ymm10, ymm10, ymm10
    vmovups ymm15, [r8 + 96]
    vfmadd231ps ymm3, ymm15, ymm12
    vfmadd231ps ymm7, ymm15, ymm13
    vxorps ymm11, ymm11, ymm11
    add r8, 192
    jmp .be0
.bp0:
    vmovups [rbx + 0], ymm0
    vmovups [rbx + 32], ymm1
    vmovups [rbx + 64], ymm2
    vmovups [rbx + 96], ymm3
    jmp .bq0
.bs1:
    vbroadcastss ymm12, [r15 + Pc_w + 12]
    vbroadcastss ymm13, [r15 + Pc_w + 12 + 4]
    cmp eax, 1
    je .bt1
    vbroadcastss ymm14, [r15 + Pc_w + 12 + 8]
M2p_a257
    vfmadd231ps ymm8, ymm15, ymm13
    vmulps ymm0, ymm15, ymm14
M2p_a258
    vfmadd231ps ymm9, ymm15, ymm13
    vmulps ymm1, ymm15, ymm14
M2p_a259
    vfmadd231ps ymm10, ymm15, ymm13
    vmulps ymm2, ymm15, ymm14
M2p_a25c
    vfmadd231ps ymm11, ymm15, ymm13
    vmulps ymm3, ymm15, ymm14
    add r8, 192
    jmp .be1
.bt1:
M2p_a257
    vfmadd231ps ymm8, ymm15, ymm13
    vxorps ymm0, ymm0, ymm0
M2p_a258
    vfmadd231ps ymm9, ymm15, ymm13
    vxorps ymm1, ymm1, ymm1
M2p_a259
    vfmadd231ps ymm10, ymm15, ymm13
    vxorps ymm2, ymm2, ymm2
M2p_a25c
    vfmadd231ps ymm11, ymm15, ymm13
    vxorps ymm3, ymm3, ymm3
    add r8, 192
    jmp .be1
.bs2:
    vbroadcastss ymm12, [r15 + Pc_w + 24]
    vbroadcastss ymm13, [r15 + Pc_w + 24 + 4]
    cmp eax, 1
    je .bt2
    vbroadcastss ymm14, [r15 + Pc_w + 24 + 8]
M2p_a25f
    vmovups [r13], ymm4
    vfmadd231ps ymm0, ymm15, ymm13
    vmulps ymm4, ymm15, ymm14
M2p_a261
    vmovups [r13 + r10], ymm5
    vfmadd231ps ymm1, ymm15, ymm13
    vmulps ymm5, ymm15, ymm14
M2p_a263
    vmovups [r13 + r10*2], ymm6
    vfmadd231ps ymm2, ymm15, ymm13
    vmulps ymm6, ymm15, ymm14
M2p_a266
    vmovups [r13 + r11], ymm7
    vfmadd231ps ymm3, ymm15, ymm13
    vmulps ymm7, ymm15, ymm14
    add r8, 192
    jmp .be2
.bt2:
M2p_a25f
    vmovups [r13], ymm4
    vfmadd231ps ymm0, ymm15, ymm13
    vxorps ymm4, ymm4, ymm4
M2p_a261
    vmovups [r13 + r10], ymm5
    vfmadd231ps ymm1, ymm15, ymm13
    vxorps ymm5, ymm5, ymm5
M2p_a263
    vmovups [r13 + r10*2], ymm6
    vfmadd231ps ymm2, ymm15, ymm13
    vxorps ymm6, ymm6, ymm6
M2p_a266
    vmovups [r13 + r11], ymm7
    vfmadd231ps ymm3, ymm15, ymm13
    vxorps ymm7, ymm7, ymm7
    add r8, 192
    jmp .be2
.bn3:
    vmovups [rbx + 128], ymm4
    vmovups [rbx + 160], ymm5
    vmovups [rbx + 192], ymm6
    vmovups [rbx + 224], ymm7
    jmp .be3
.bs3:
    vbroadcastss ymm12, [r15 + Pc_w + 36]
    vbroadcastss ymm13, [r15 + Pc_w + 36 + 4]
    cmp eax, 1
    je .bt3
    vbroadcastss ymm14, [r15 + Pc_w + 36 + 8]
M2p_a26b
    vmovups [rbx + 0], ymm0
    vfmadd231ps ymm4, ymm15, ymm13
    vmovups [rbx + 128], ymm4
    vmulps ymm8, ymm15, ymm14
    vmovups [rbx + 256], ymm8
M2p_a26e
    vmovups [rbx + 32], ymm1
    vfmadd231ps ymm5, ymm15, ymm13
    vmovups [rbx + 160], ymm5
    vmulps ymm9, ymm15, ymm14
    vmovups [rbx + 288], ymm9
M2p_a273
    vmovups [rbx + 64], ymm2
    vfmadd231ps ymm6, ymm15, ymm13
    vmovups [rbx + 192], ymm6
    vmulps ymm10, ymm15, ymm14
    vmovups [rbx + 320], ymm10
M2p_a275
    vmovups [rbx + 96], ymm3
    vfmadd231ps ymm7, ymm15, ymm13
    vmovups [rbx + 224], ymm7
    vmulps ymm11, ymm15, ymm14
    vmovups [rbx + 352], ymm11
    jmp .be3
.bt3:
M2p_a26b
    vmovups [rbx + 0], ymm0
    vfmadd231ps ymm4, ymm15, ymm13
    vmovups [rbx + 128], ymm4
M2p_a26e
    vmovups [rbx + 32], ymm1
    vfmadd231ps ymm5, ymm15, ymm13
    vmovups [rbx + 160], ymm5
M2p_a273
    vmovups [rbx + 64], ymm2
    vfmadd231ps ymm6, ymm15, ymm13
    vmovups [rbx + 192], ymm6
M2p_a275
    vmovups [rbx + 96], ymm3
    vfmadd231ps ymm7, ymm15, ymm13
    vmovups [rbx + 224], ymm7
    jmp .be3
.bkm:
    mov rax, [rbp + 5672]
    vpmovsxbd xmm15, [rax + rdi*4]
M2p_ad
    mov r10d, r12d
    shr r12d, 1
    test byte [rsi + Rc_od], 1
    jnz .a0em
    test r12d, r12d
    jz .a0qtm
align 32
.a0qm:
    vpmaskmovd xmm0, xmm15, [rdx]
    vpmovzxwd ymm0, xmm0
M2p_a12
M2p_a1c
    vpmaskmovd xmm0, xmm15, [rdx + r11]
M2p_a27e
M2p_a1e
    add r8, 384
    dec r12d
    jnz .a0qm
.a0qtm:
    test r10d, 1
    jz .a0xm
M2p_a27c
M2p_a1a
    vfmadd231ps ymm0, ymm1, ymm14
    vmovups [r8 + 64], ymm0
    jmp .a0xm
.a0em:
    test r12d, r12d
    jz .a0ptm
align 32
.a0pm:
M2p_a27d
M2p_a2c
M2p_a22
M2p_a17
    vfmadd231ps ymm0, ymm1, ymm13
    vfmadd231ps ymm0, ymm1, ymm14
    vmovups [r8 + 64], ymm0
M2p_a27f
M2p_a2a
M2p_a24
    add r8, 384
    dec r12d
    jnz .a0pm
.a0ptm:
M2p_a284
M2p_a29
M2p_a16
M2p_a1b
    vmovups [r8 + 64], ymm0
.a0xm:
    jmp .bkn
.t1l:
    vcvtps2pd ymm0, [rsi + 196608]
    vbroadcastsd ymm1, [rdi + G_dan]
M2p_a28e
M2p_a28f
    call .ivq
    vmovapd [rbp + 7232], ymm0
    vmovapd [rbp + 7264], ymm1
    vcvtps2pd ymm0, [rsi + 65536]
M2p_a28f
    call .ivq
    vmovapd [rbp + 7296], ymm0
    vmovapd [rbp + 7328], ymm1
    vcvtps2pd ymm0, [rsi + 131072]
M2p_a28f
    call .ivq
    vmovapd [rbp + 7360], ymm0
    vmovapd [rbp + 7392], ymm1
    vbroadcastsd ymm0, [rdi + G_dlo]
    vbroadcastsd ymm2, [d_emc0]
    vfmadd231pd ymm0, ymm2, [rbp + 7232]
    vbroadcastsd ymm2, [d_emc1]
    vfmadd231pd ymm0, ymm2, [rbp + 7296]
    vbroadcastsd ymm2, [d_emc2]
    vfmadd231pd ymm0, ymm2, [rbp + 7360]
    vbroadcastsd ymm1, [rdi + G_dhi]
    vbroadcastsd ymm2, [d_emc0]
    vfmadd231pd ymm1, ymm2, [rbp + 7264]
    vbroadcastsd ymm2, [d_emc1]
    vfmadd231pd ymm1, ymm2, [rbp + 7328]
    vbroadcastsd ymm2, [d_emc2]
M2p_a292
M2p_a29a
    vblendvpd ymm2, ymm4, ymm2, ymm3
    vcvtpd2dq xmm2, ymm2
    vmovdqa xmm4, xmm2
    ret
.t1c:
    vcvtps2pd ymm0, [rsi + 49152]
    vbroadcastsd ymm1, [rdi + G_ean]
M2p_a28e
M2p_a29f
    call .ivq
    vmovapd [rbp + 7232], ymm0
    vmovapd [rbp + 7264], ymm1
    vcvtps2pd ymm0, [rsi + 16384]
M2p_a29f
    call .ivq
    vmovapd [rbp + 7296], ymm0
    vmovapd [rbp + 7328], ymm1
    vcvtps2pd ymm0, [rsi + 32768]
M2p_a29f
    call .ivq
    vmovapd [rbp + 7360], ymm0
    vmovapd [rbp + 7392], ymm1
    vbroadcastsd ymm0, [rdi + G_elo]
    vbroadcastsd ymm2, [d_emc5]
    vfnmadd231pd ymm0, ymm2, [rbp + 7328]
    vbroadcastsd ymm2, [d_emc4]
    vfnmadd231pd ymm0, ymm2, [rbp + 7264]
    vbroadcastsd ymm2, [d_emc3]
    vfmadd231pd ymm0, ymm2, [rbp + 7360]
    vbroadcastsd ymm1, [rdi + G_ehi]
    vbroadcastsd ymm2, [d_emc5]
    vfnmadd231pd ymm1, ymm2, [rbp + 7296]
    vbroadcastsd ymm2, [d_emc4]
    vfnmadd231pd ymm1, ymm2, [rbp + 7232]
    vbroadcastsd ymm2, [d_emc3]
M2p_a292
M2p_a29a
    vblendvpd ymm2, ymm4, ymm2, ymm3
    vcvtpd2dq xmm2, ymm2
    vmovdqa [rbp + 7424], xmm2
    vbroadcastsd ymm0, [rdi + G_elo]
    vbroadcastsd ymm2, [d_emc8]
    vfnmadd231pd ymm0, ymm2, [rbp + 7392]
    vbroadcastsd ymm2, [d_emc7]
    vfnmadd231pd ymm0, ymm2, [rbp + 7328]
    vbroadcastsd ymm2, [d_emc6]
    vfmadd231pd ymm0, ymm2, [rbp + 7232]
    vbroadcastsd ymm1, [rdi + G_ehi]
    vbroadcastsd ymm2, [d_emc8]
    vfnmadd231pd ymm1, ymm2, [rbp + 7360]
    vbroadcastsd ymm2, [d_emc7]
    vfnmadd231pd ymm1, ymm2, [rbp + 7296]
    vbroadcastsd ymm2, [d_emc6]
    vfmadd231pd ymm1, ymm2, [rbp + 7264]
M2p_a293
M2p_a29c
M2p_a2a6
M2p_a2ac
M2p_a2b2
M2p_a2ba
M2p_a2c9
M2p_a2d8
M2p_a2e2
    vmovsd xmm1, [d_emc4]
    vfnmadd231sd xmm0, xmm1, [rbp + 6336]
    vmovsd xmm1, [d_emc3]
    vfmadd231sd xmm0, xmm1, [rbp + 6304 + 16]
    vmovsd xmm2, [d_chi]
    vmovsd xmm1, [d_emc5]
    vfnmadd231sd xmm2, xmm1, [rbp + 6304 + 8]
    vmovsd xmm1, [d_emc4]
    vfnmadd231sd xmm2, xmm1, [rbp + 6304]
    vmovsd xmm1, [d_emc3]
M2p_a2e6
    mov r8d, eax
    vmovsd xmm0, [d_clo]
    vmovsd xmm1, [d_emc8]
    vfnmadd231sd xmm0, xmm1, [rbp + 6336 + 16]
    vmovsd xmm1, [d_emc7]
    vfnmadd231sd xmm0, xmm1, [rbp + 6336 + 8]
    vmovsd xmm1, [d_emc6]
    vfmadd231sd xmm0, xmm1, [rbp + 6304]
    vmovsd xmm2, [d_chi]
    vmovsd xmm1, [d_emc8]
    vfnmadd231sd xmm2, xmm1, [rbp + 6304 + 16]
    vmovsd xmm1, [d_emc7]
    vfnmadd231sd xmm2, xmm1, [rbp + 6304 + 8]
    vmovsd xmm1, [d_emc6]
    vfmadd231sd xmm2, xmm1, [rbp + 6336]
M2p_a2e7
M2p_a2e8
    cmp rax, rcx
    cmovne edx, esi
    mov eax, edx
    mov ecx, eax
    or ecx, r8d
    shl eax, 16
    or eax, r8d
    test ecx, ecx
    mov ecx, -1
M2p_a2ef
M2p_a2f9
    vaddsd xmm11, xmm11, xmm10
    vpermilpd xmm10, xmm9, 1
    vaddsd xmm9, xmm9, xmm10
    vaddsd xmm11, xmm11, xmm9
    vaddsd xmm11, xmm11, [rbp + 6208]
    vmovsd [rbp + 6208], xmm11
    vmovapd ymm0, [rbp + 6368]
M2p_a2f2
M2p_a303
M2p_a311
    vpermilpd xmm10, xmm9, 1
    vaddsd xmm9, xmm9, xmm10
    vaddsd xmm6, xmm6, xmm9
    vaddsd xmm6, xmm6, [rbp + 6184]
    vmovsd [rbp + 6184], xmm6
M2p_a315
    vaddsd xmm9, xmm9, xmm10
    vaddsd xmm11, xmm11, xmm9
    vaddsd xmm11, xmm11, [rbp + 6216]
    vmovsd [rbp + 6216], xmm11
    vmovapd ymm0, [rbp + 6400]
M2p_a2f2
M2p_a303
M2p_a311
    vpermilpd xmm10, xmm9, 1
    vaddsd xmm9, xmm9, xmm10
    vaddsd xmm6, xmm6, xmm9
    vaddsd xmm6, xmm6, [rbp + 6192]
    vmovsd [rbp + 6192], xmm6
M2p_a315
    vaddsd xmm9, xmm9, xmm10
    vaddsd xmm11, xmm11, xmm9
    vaddsd xmm11, xmm11, [rbp + 6224]
    vmovsd [rbp + 6224], xmm11
    ret
.t3:
    mov rdi, [rbp + 5608]
    vxorpd xmm0, xmm0, xmm0
    vmovapd [rbp + 6752], ymm0
    vmovapd [rbp + 6784], ymm0
M2p_a2b6
    test rcx, rcx
    jnz .g3c
M2p_a2b7
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
M2p_a2bb
    jnz .g3e
    xor r14d, r14d
    mov ecx, 1
.g3e:
    lea rsi, [rdx*4 + 3]
.g3g:
M2p_a2bc
.y3:
M2p_a2c3
    jae .f3
M2p_a2c4
    cmp qword [rbp + 5896], 0
    je .v3
M2p_a2c5
    cmovs rbx, rcx
    add rdx, rbx
.v3:
M2p_a2c6
M2p_a2ca
    xor edx, edx
    div r9
    mov r14, rax
.j3:
    mov rax, r14
    imul rax, r9
    cmp rax, [rbp + 5864]
    jae .n3
M2p_a2cb
    sub rdx, rcx
    cmp qword [rbp + 5888], 0
    je .w3
M2p_a2d0
.w3:
M2p_a2d3
    jne .o3
    vmovss xmm0, [rax + rcx*4]
    vmovss xmm1, [rbx + rcx*4]
    jmp .q3
.o3:
M2p_a2d5
M2p_a2d9
    vmulss xmm3, xmm3, [c_h0625]
    vfmsub132ss xmm0, xmm2, [c_h5625]
    vfmsub132ss xmm1, xmm3, [c_h5625]
.q3:
M2p_a2da
    mov [rbp + 5912], rsi
    cmp rsi, 4
    jb .x3
    call .t3b
    mov qword [rbp + 5912], 0
.x3:
    inc r14
    jmp .j3
.n3:
    inc qword [rbp + 5920]
    jmp .y3
.f3:
    mov rsi, [rbp + 5912]
    test rsi, rsi
    jz .e3
    vxorpd xmm0, xmm0, xmm0
.z3:
M2p_a2df
    inc rsi
    cmp rsi, 4
    jb .z3
    call .t3b
.e3:
    mov rdi, [rbp + 5608]
    cmp qword [rbp + 5928], 0
    jne .t3q
    vbroadcastsd ymm2, [rdi + G_dnl]
    vbroadcastsd ymm3, [rdi + G_dnl + 8]
    jmp .t3r
.t3q:
    vbroadcastsd ymm2, [rdi + G_dnc]
    vbroadcastsd ymm3, [rdi + G_dnc + 8]
.t3r:
    vmovapd ymm4, [rbp + 6752]
    vmovapd ymm5, [rbp + 6784]
M2p_a329
    vsubpd ymm9, ymm7, ymm9
    vmovapd ymm0, ymm8
    vmovapd ymm1, ymm9
    call .xoe
    vmovapd [rbp + 6816], ymm0
    vmovapd [rbp + 6848], ymm1
    vbroadcastsd ymm2, [rbp + 6816]
    vbroadcastsd ymm3, [rbp + 6848]
    vbroadcastsd ymm4, [d_kr]
    vbroadcastsd ymm5, [d_kr + 8]
M2p_a329
    vsubpd ymm9, ymm7, ymm9
    vbroadcastsd ymm3, [rbp + 6824]
    vbroadcastsd ymm2, [rbp + 6856]
    vbroadcastsd ymm5, [d_kg]
    vbroadcastsd ymm4, [d_kg + 8]
    vmulpd ymm7, ymm5, ymm3
M2p_a32b
M2p_a32f
M2p_a334
M2p_a338
    mov dword [rbp + 7048], eax
    vmovapd ymm0, [rbp + 6624]
    vmovapd ymm1, [rbp + 6656]
    call .rn2
    mov dword [rbp + 7044], edx
    mov dword [rbp + 7052], eax
    mov eax, dword [rbp + 7048]
    and eax, dword [rbp + 7052]
    test al, 1
    jnz .t3m
    call .xr
    test byte [rbp + 7048], 1
    jnz .t3k0
    mov rax, [rbp + 6928]
M2p_a340
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
M2p_a333
    cmp rax, rcx
    cmovg rax, rcx
    mov dword [rbp + 7040], eax
.t3k0:
    test byte [rbp + 7052], 1
    jnz .t3k1
    mov rax, [rbp + 6936]
M2p_a340
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
M2p_a333
    cmp rax, rcx
    cmovg rax, rcx
    mov dword [rbp + 7044], eax
.t3k1:
.t3m:
    mov eax, dword [rbp + 7040]
    mov ecx, dword [rbp + 7044]
    shl ecx, 16
    or eax, ecx
    ret
.t3b:
    vxorpd xmm0, xmm0, xmm0
    vmovapd ymm1, [rbp + 6048]
    vmovapd ymm2, [rbp + 6080]
    vmovapd ymm3, [rbp + 6112]
    vbroadcastsd ymm4, [d_ysc]
    vbroadcastsd ymm5, [d_ysc + 8]
    vmulpd ymm6, ymm1, ymm4
    vmovapd ymm7, ymm6
    vfmsub231pd ymm7, ymm1, ymm4
    vmulpd ymm8, ymm0, ymm4
    vfmadd231pd ymm8, ymm1, ymm5
M2p_a32a
    vbroadcastsd ymm1, [d_yof]
    vbroadcastsd ymm5, [d_yof + 8]
    vaddpd ymm4, ymm8, ymm1
    vsubpd ymm7, ymm4, ymm8
    vsubpd ymm6, ymm4, ymm7
    vsubpd ymm6, ymm8, ymm6
    vsubpd ymm7, ymm1, ymm7
    vaddpd ymm6, ymm6, ymm7
    vaddpd ymm7, ymm9, ymm5
    vsubpd ymm10, ymm7, ymm9
    vsubpd ymm11, ymm7, ymm10
    vsubpd ymm11, ymm9, ymm11
    vsubpd ymm10, ymm5, ymm10
    vaddpd ymm11, ymm11, ymm10
    vaddpd ymm10, ymm6, ymm7
    vaddpd ymm7, ymm4, ymm10
    vsubpd ymm6, ymm7, ymm4
    vsubpd ymm6, ymm10, ymm6
    vaddpd ymm10, ymm6, ymm11
    vaddpd ymm11, ymm7, ymm10
    vsubpd ymm6, ymm11, ymm7
    vsubpd ymm6, ymm10, ymm6
    vbroadcastsd ymm5, [d_rcr]
    vbroadcastsd ymm1, [d_rcr + 8]
    vmulpd ymm9, ymm3, ymm5
    vmovapd ymm8, ymm9
    vfmsub231pd ymm8, ymm3, ymm5
    vmulpd ymm10, ymm0, ymm5
    vfmadd231pd ymm10, ymm3, ymm1
    vaddpd ymm8, ymm8, ymm10
    vaddpd ymm10, ymm9, ymm8
    vsubpd ymm7, ymm10, ymm9
    vsubpd ymm7, ymm8, ymm7
    vaddpd ymm1, ymm11, ymm10
    vsubpd ymm5, ymm1, ymm11
    vsubpd ymm8, ymm1, ymm5
    vsubpd ymm8, ymm11, ymm8
M2p_a344
M2p_a349
M2p_a34d
M2p_a35d
    vaddsd xmm2, xmm0, xmm8
M2p_a36b
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm0, xmm3, xmm8
    vsubsd xmm0, xmm2, xmm0
    vmovsd [rbp + 6752], xmm3
    vmovsd [rbp + 6784], xmm0
    vmovsd xmm0, [rbp + 6760]
    vmovsd xmm1, [rbp + 6792]
    vmovsd xmm2, [rbp + 6624]
    vmovsd xmm3, [rbp + 6656]
M2p_a351
M2p_a352
M2p_a353
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm2, xmm3
    vmovsd xmm9, [rbp + 6632]
    vmovsd xmm8, [rbp + 6664]
M2p_a354
M2p_a355
M2p_a35c
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [rbp + 6640]
    vmovsd xmm5, [rbp + 6672]
M2p_a364
M2p_a365
M2p_a366
    vaddsd xmm1, xmm3, xmm6
    vsubsd xmm5, xmm1, xmm3
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [rbp + 6648]
    vmovsd xmm0, [rbp + 6680]
M2p_a367
M2p_a368
M2p_a36b
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm0, xmm3, xmm8
    vsubsd xmm0, xmm2, xmm0
    vmovsd [rbp + 6760], xmm3
    vmovsd [rbp + 6792], xmm0
    vmovsd xmm0, [rbp + 6768]
    vmovsd xmm1, [rbp + 6800]
    vmovsd xmm2, [rbp + 6688]
    vmovsd xmm3, [rbp + 6720]
M2p_a351
M2p_a352
M2p_a353
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm2, xmm3
    vmovsd xmm9, [rbp + 6696]
    vmovsd xmm8, [rbp + 6728]
M2p_a354
M2p_a355
M2p_a35c
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [rbp + 6704]
    vmovsd xmm5, [rbp + 6736]
M2p_a364
M2p_a365
M2p_a366
    vaddsd xmm1, xmm3, xmm6
    vsubsd xmm5, xmm1, xmm3
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [rbp + 6712]
    vmovsd xmm0, [rbp + 6744]
M2p_a367
M2p_a368
M2p_a36b
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm0, xmm3, xmm8
    vsubsd xmm0, xmm2, xmm0
    vmovsd [rbp + 6768], xmm3
    vmovsd [rbp + 6800], xmm0
    ret
.xr:
    mov rdi, [rbp + 5608]
    vpxor xmm0, xmm0, xmm0
    vmovdqu [rbp + 6912], ymm0
    vmovdqu [rbp + 6976], ymm0
    vmovdqu [rbp + 6944], ymm0
    vmovdqu [rbp + 7008], ymm0
M2p_a2b6
    test rcx, rcx
    jnz .g4c
M2p_a2b7
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
M2p_a2bb
    jnz .g4e
    xor r14d, r14d
    mov ecx, 1
.g4e:
    lea rsi, [rdx*4 + 3]
.g4g:
M2p_a2bc
.y4:
M2p_a2c3
    jae .f4
M2p_a2c4
    cmp qword [rbp + 5896], 0
    je .v4
M2p_a2c5
    cmovs rbx, rcx
    add rdx, rbx
.v4:
M2p_a2c6
M2p_a2ca
    xor edx, edx
    div r9
    mov r14, rax
.j4:
    mov rax, r14
    imul rax, r9
    cmp rax, [rbp + 5864]
    jae .n4
M2p_a2cb
    sub rdx, rcx
    cmp qword [rbp + 5888], 0
    je .w4
M2p_a2d0
.w4:
    imul rdx, [rbp + 5952]
    add [rbp + 6912], rdx
    mov [rbp + 7024], rdx
    mov rcx, [rbp + 6016]
    movzx eax, word [rcx + r14*2]
    mov [rbp + 7032], rax
    imul rax, rdx
    add [rbp + 6920], rax
M2p_a2d4
    mov rcx, [rbp + 5992]
    cmp qword [rbp + 6024], 0
    jne .o4
    vmovss xmm0, [rax + rcx*4]
    vmovss xmm1, [rbx + rcx*4]
    jmp .q4
.o4:
M2p_a2d5
M2p_a2d9
    vmulss xmm3, xmm3, [c_h0625]
    vfmsub132ss xmm0, xmm2, [c_h5625]
    vfmsub132ss xmm1, xmm3, [c_h5625]
.q4:
M2p_a2db
    vmulsd xmm0, xmm0, [d_2p20]
    vcvttsd2si r12, xmm0
    vmulsd xmm1, xmm1, [d_2p20]
    vcvttsd2si r13, xmm1
    lea rax, [r12 + 0x20000000]
    imul rax, [rbp + 7024]
    add [rbp + 6928], rax
    lea rax, [r13 + 0x20000000]
    imul rax, [rbp + 7024]
    add [rbp + 6936], rax
    mov rbx, [rbp + 7032]
    imul r12, [d_xys]
    imul r13, [d_xys]
    sub rbx, [d_xyb]
    imul rbx, [d_xec]
    imul rax, r13, 14746
M2p_a385
    movsx rcx, cl
    add [rbp + 6976], rcx
    imul rax, r12, 18814
M2p_a385
    movsx rcx, cl
    add [rbp + 6992], rcx
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
    add [rbp + 6984], rcx
    inc qword [rbp + 7000]
    inc r14
    jmp .j4
.n4:
    inc qword [rbp + 5920]
    jmp .y4
.f4:
    mov rax, [rbp + 6976]
M2p_a389
    jne .xud
    mov rax, [rbp + 6984]
M2p_a389
    jne .xud
    mov rax, [rbp + 6992]
M2p_a389
M2p_a38d
M2p_a392
    vpcmpgtq ymm1, ymm2, ymm1
    vblendvpd ymm0, ymm3, ymm13, ymm1
    ret
.dexp:
    vbroadcastsd ymm2, [d_ln2]
    vdivpd ymm3, ymm0, ymm2
    vbroadcastsd ymm2, [d_sgn]
    vbroadcastsd ymm4, [d_hm]
    vandpd ymm2, ymm2, ymm3
    vorpd ymm2, ymm2, ymm4
    vaddpd ymm2, ymm2, ymm3
    vroundpd ymm2, ymm2, 11
    vxorpd xmm4, xmm4, xmm4
    vbroadcastsd ymm3, [d_ln2]
    vbroadcastsd ymm5, [d_ln2 + 8]
    vmulpd ymm6, ymm3, ymm2
    vmovapd ymm7, ymm6
    vfmsub231pd ymm7, ymm3, ymm2
    vmulpd ymm8, ymm5, ymm2
    vfmadd231pd ymm8, ymm3, ymm4
M2p_a32a
    vbroadcastsd ymm5, [d_sgn]
    vxorpd ymm5, ymm5, ymm8
    vbroadcastsd ymm3, [d_sgn]
    vxorpd ymm3, ymm3, ymm9
    vaddpd ymm9, ymm0, ymm5
    vsubpd ymm8, ymm9, ymm0
    vsubpd ymm7, ymm9, ymm8
    vsubpd ymm7, ymm0, ymm7
    vsubpd ymm8, ymm5, ymm8
    vaddpd ymm7, ymm7, ymm8
    vaddpd ymm8, ymm1, ymm3
    vsubpd ymm6, ymm8, ymm1
    vsubpd ymm10, ymm8, ymm6
    vsubpd ymm10, ymm1, ymm10
    vsubpd ymm6, ymm3, ymm6
    vaddpd ymm10, ymm10, ymm6
    vaddpd ymm6, ymm7, ymm8
    vaddpd ymm8, ymm9, ymm6
    vsubpd ymm7, ymm8, ymm9
    vsubpd ymm7, ymm6, ymm7
    vaddpd ymm6, ymm7, ymm10
    vaddpd ymm10, ymm8, ymm6
    vsubpd ymm7, ymm10, ymm8
    vsubpd ymm7, ymm6, ymm7
    vbroadcastsd ymm3, [d_i1024]
    vmulpd ymm5, ymm10, ymm3
M2p_a398
    vaddpd ymm5, ymm5, ymm4
    vaddpd ymm4, ymm3, ymm5
    vsubpd ymm9, ymm4, ymm3
    vsubpd ymm9, ymm5, ymm9
    vmovapd ymm0, ymm4
    vmovapd ymm1, ymm9
    dec eax
    jnz .dexq
    vmulpd ymm0, ymm0, [rbp + T_EXK]
    vmulpd ymm1, ymm1, [rbp + T_EXK]
    ret
.dln:
    vmovapd [rbp + T_LN], ymm0
    vmovapd [rbp + T_LN + 32], ymm1
    call .lgv
    vmovapd [rbp + T_LN + 64], ymm0
    vbroadcastsd ymm1, [d_sgn]
    vxorpd ymm0, ymm0, ymm1
    vxorpd xmm1, xmm1, xmm1
    call .dexp
    vmovapd ymm2, [rbp + T_LN]
    vmovapd ymm3, [rbp + T_LN + 32]
M2p_a3a2
    vsubpd ymm7, ymm5, ymm7
    vbroadcastsd ymm3, [d_mone]
    vbroadcastsd ymm2, [d_mzero]
    vaddpd ymm5, ymm6, ymm3
    vsubpd ymm4, ymm5, ymm6
    vsubpd ymm8, ymm5, ymm4
    vsubpd ymm8, ymm6, ymm8
    vsubpd ymm4, ymm3, ymm4
    vaddpd ymm8, ymm8, ymm4
    vaddpd ymm4, ymm7, ymm2
    vsubpd ymm9, ymm4, ymm7
    vsubpd ymm10, ymm4, ymm9
    vsubpd ymm10, ymm7, ymm10
    vsubpd ymm9, ymm2, ymm9
    vaddpd ymm10, ymm10, ymm9
M2p_a348
    vaddpd ymm9, ymm8, ymm10
    vaddpd ymm10, ymm4, ymm9
    vsubpd ymm8, ymm10, ymm4
    vsubpd ymm8, ymm9, ymm8
    vxorpd xmm7, xmm7, xmm7
    vmovapd ymm6, [rbp + T_LN + 64]
    vaddpd ymm2, ymm6, ymm10
    vsubpd ymm3, ymm2, ymm6
    vsubpd ymm9, ymm2, ymm3
    vsubpd ymm9, ymm6, ymm9
    vsubpd ymm3, ymm10, ymm3
    vaddpd ymm9, ymm9, ymm3
    vaddpd ymm3, ymm7, ymm8
    vsubpd ymm4, ymm3, ymm7
    vsubpd ymm5, ymm3, ymm4
    vsubpd ymm5, ymm7, ymm5
    vsubpd ymm4, ymm8, ymm4
    vaddpd ymm5, ymm5, ymm4
    vaddpd ymm4, ymm9, ymm3
    vaddpd ymm3, ymm2, ymm4
    vsubpd ymm9, ymm3, ymm2
    vsubpd ymm9, ymm4, ymm9
    vaddpd ymm4, ymm9, ymm5
    vaddpd ymm5, ymm3, ymm4
    vsubpd ymm9, ymm5, ymm3
    vsubpd ymm9, ymm4, ymm9
    vmovapd ymm0, ymm5
    vmovapd ymm1, ymm9
    ret
.xeo:
M2p_a3ab
    vmovapd [rbp + T_XO + 32], ymm6
    vcmppd ymm6, ymm4, ymm2, 0x1e
    vblendvpd ymm7, ymm4, ymm2, ymm6
    vblendvpd ymm8, ymm5, ymm3, ymm6
    vbroadcastsd ymm6, [d_sgn]
    vxorpd ymm6, ymm6, ymm7
    vbroadcastsd ymm2, [d_sgn]
    vxorpd ymm2, ymm2, ymm8
    vaddpd ymm9, ymm4, ymm6
    vsubpd ymm10, ymm9, ymm4
    vsubpd ymm11, ymm9, ymm10
    vsubpd ymm11, ymm4, ymm11
    vsubpd ymm10, ymm6, ymm10
    vaddpd ymm11, ymm11, ymm10
    vaddpd ymm10, ymm5, ymm2
    vsubpd ymm12, ymm10, ymm5
    vsubpd ymm13, ymm10, ymm12
    vsubpd ymm13, ymm5, ymm13
    vsubpd ymm12, ymm2, ymm12
    vaddpd ymm13, ymm13, ymm12
    vaddpd ymm12, ymm11, ymm10
    vaddpd ymm10, ymm9, ymm12
    vsubpd ymm11, ymm10, ymm9
    vsubpd ymm11, ymm12, ymm11
    vaddpd ymm12, ymm11, ymm13
    vaddpd ymm13, ymm10, ymm12
    vsubpd ymm11, ymm13, ymm10
    vsubpd ymm11, ymm12, ymm11
    vmovapd [rbp + T_XO + 64], ymm13
    vmovapd [rbp + T_XO + 96], ymm11
    vmovapd ymm0, ymm7
    vmovapd ymm1, ymm8
    call .dln
    vbroadcastsd ymm2, [d_im2]
    vbroadcastsd ymm3, [d_im2 + 8]
M2p_a3a2
M2p_a3ac
    vbroadcastsd ymm2, [d_mc1]
M2p_a3ae
M2p_a3b4
    vsubpd ymm14, ymm4, ymm14
    vsubpd ymm5, ymm9, ymm5
    vaddpd ymm14, ymm14, ymm5
    vaddpd ymm5, ymm15, ymm3
    vsubpd ymm11, ymm5, ymm15
    vsubpd ymm13, ymm5, ymm11
    vsubpd ymm13, ymm15, ymm13
    vsubpd ymm11, ymm3, ymm11
    vaddpd ymm13, ymm13, ymm11
    vaddpd ymm11, ymm14, ymm5
    vaddpd ymm5, ymm6, ymm11
    vsubpd ymm14, ymm5, ymm6
    vsubpd ymm14, ymm11, ymm14
    vaddpd ymm11, ymm14, ymm13
    vaddpd ymm13, ymm5, ymm11
    vsubpd ymm14, ymm13, ymm5
M2p_a3bf
    vbroadcastsd ymm2, [d_im1]
    vbroadcastsd ymm3, [d_im1 + 8]
M2p_a3a2
M2p_a3ac
    vandpd ymm0, ymm0, [rbp + T_XO + 128]
    vandpd ymm1, ymm1, [rbp + T_XO + 128]
    vbroadcastsd ymm2, [d_k12]
    vbroadcastsd ymm3, [d_k12 + 8]
    vmovapd ymm4, [rbp + T_XO + 64]
    vmovapd ymm5, [rbp + T_XO + 96]
    vmulpd ymm6, ymm2, ymm4
    vmovapd ymm7, ymm6
    vfmsub231pd ymm7, ymm2, ymm4
    vmulpd ymm8, ymm3, ymm4
    vfmadd231pd ymm8, ymm2, ymm5
M2p_a32a
    vaddpd ymm5, ymm0, ymm8
    vsubpd ymm4, ymm5, ymm0
    vsubpd ymm3, ymm5, ymm4
    vsubpd ymm3, ymm0, ymm3
    vsubpd ymm4, ymm8, ymm4
    vaddpd ymm3, ymm3, ymm4
    vaddpd ymm4, ymm1, ymm9
    vsubpd ymm2, ymm4, ymm1
    vsubpd ymm7, ymm4, ymm2
    vsubpd ymm7, ymm1, ymm7
    vsubpd ymm2, ymm9, ymm2
    vaddpd ymm7, ymm7, ymm2
    vaddpd ymm2, ymm3, ymm4
    vaddpd ymm4, ymm5, ymm2
    vsubpd ymm3, ymm4, ymm5
    vsubpd ymm3, ymm2, ymm3
    vaddpd ymm2, ymm3, ymm7
    vaddpd ymm7, ymm4, ymm2
    vsubpd ymm3, ymm7, ymm4
    vsubpd ymm3, ymm2, ymm3
    vmovapd ymm9, [rbp + T_XO + 32]
    vandnpd ymm7, ymm9, ymm7
    vandnpd ymm3, ymm9, ymm3
    vmulpd ymm0, ymm7, [rbp + T_XO]
    vmulpd ymm1, ymm3, [rbp + T_XO]
    ret
.xoe:
M2p_a3ab
    vmovapd [rbp + T_XO + 32], ymm6
    vcmppd ymm6, ymm4, ymm2, 0x1e
    vmovapd [rbp + T_XO + 64], ymm6
    vmovapd [rbp + T_XO + 160], ymm4
    vmovapd [rbp + T_XO + 192], ymm5
    vbroadcastsd ymm6, [d_mone]
    vbroadcastsd ymm7, [d_mzero]
    vaddpd ymm8, ymm4, ymm6
    vsubpd ymm9, ymm8, ymm4
    vsubpd ymm10, ymm8, ymm9
    vsubpd ymm10, ymm4, ymm10
    vsubpd ymm9, ymm6, ymm9
    vaddpd ymm10, ymm10, ymm9
    vaddpd ymm9, ymm5, ymm7
    vsubpd ymm11, ymm9, ymm5
    vsubpd ymm12, ymm9, ymm11
    vsubpd ymm12, ymm5, ymm12
    vsubpd ymm11, ymm7, ymm11
    vaddpd ymm12, ymm12, ymm11
    vaddpd ymm11, ymm10, ymm9
    vaddpd ymm9, ymm8, ymm11
    vsubpd ymm10, ymm9, ymm8
    vsubpd ymm10, ymm11, ymm10
    vaddpd ymm11, ymm10, ymm12
    vaddpd ymm12, ymm9, ymm11
    vsubpd ymm10, ymm12, ymm9
    vsubpd ymm10, ymm11, ymm10
    vbroadcastsd ymm5, [d_m12d]
    vbroadcastsd ymm4, [d_m12d + 8]
    vmulpd ymm7, ymm12, ymm5
    vmovapd ymm6, ymm7
    vfmsub231pd ymm6, ymm12, ymm5
    vmulpd ymm11, ymm10, ymm5
    vfmadd231pd ymm11, ymm12, ymm4
    vaddpd ymm6, ymm6, ymm11
    vaddpd ymm11, ymm7, ymm6
    vsubpd ymm9, ymm11, ymm7
    vsubpd ymm9, ymm6, ymm9
    vbroadcastsd ymm2, [d_120]
    vdivpd ymm10, ymm11, ymm2
    vbroadcastsd ymm12, [d_sgn]
    vxorpd ymm12, ymm12, ymm10
    vmulpd ymm4, ymm2, ymm12
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm2, ymm12
    vmulpd ymm6, ymm3, ymm12
    vfmadd231pd ymm6, ymm2, ymm3
M2p_a3a4
M2p_a3cb
    vsubpd ymm5, ymm3, ymm5
    vaddpd ymm8, ymm8, ymm5
    vaddpd ymm5, ymm13, ymm10
    vaddpd ymm10, ymm9, ymm5
    vsubpd ymm13, ymm10, ymm9
    vsubpd ymm13, ymm5, ymm13
    vaddpd ymm5, ymm13, ymm8
    vaddpd ymm8, ymm10, ymm5
    vsubpd ymm13, ymm8, ymm10
    vsubpd ymm13, ymm5, ymm13
    vbroadcastsd ymm2, [d_one]
    vaddpd ymm4, ymm2, ymm8
    vsubpd ymm14, ymm4, ymm2
    vsubpd ymm7, ymm4, ymm14
    vsubpd ymm7, ymm2, ymm7
    vsubpd ymm14, ymm8, ymm14
    vaddpd ymm7, ymm7, ymm14
    vaddpd ymm14, ymm3, ymm13
    vsubpd ymm5, ymm14, ymm3
    vsubpd ymm10, ymm14, ymm5
    vsubpd ymm10, ymm3, ymm10
    vsubpd ymm5, ymm13, ymm5
    vaddpd ymm10, ymm10, ymm5
    vaddpd ymm5, ymm7, ymm14
    vaddpd ymm14, ymm4, ymm5
    vsubpd ymm7, ymm14, ymm4
    vsubpd ymm7, ymm5, ymm7
    vaddpd ymm5, ymm7, ymm10
    vaddpd ymm10, ymm14, ymm5
    vsubpd ymm7, ymm10, ymm14
    vsubpd ymm7, ymm5, ymm7
    vmovapd [rbp + T_XO + 96], ymm10
    vmovapd [rbp + T_XO + 128], ymm7
    vmovapd ymm0, [rbp + T_XO + 160]
    vmovapd ymm1, [rbp + T_XO + 192]
    call .dln
    vbroadcastsd ymm2, [d_m1]
    vbroadcastsd ymm3, [d_zero]
M2p_a3a2
M2p_a3ac
    vmovapd ymm2, [rbp + T_XO + 32]
    vandnpd ymm0, ymm2, ymm0
    vandnpd ymm1, ymm2, ymm1
    vxorpd xmm2, xmm2, xmm2
    vbroadcastsd ymm3, [d_c2]
    vmulpd ymm4, ymm3, ymm0
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm3, ymm0
    vmulpd ymm6, ymm2, ymm0
    vfmadd231pd ymm6, ymm3, ymm1
M2p_a3a4
    vbroadcastsd ymm3, [d_c1]
    vaddpd ymm5, ymm3, ymm6
    vsubpd ymm4, ymm5, ymm3
    vsubpd ymm8, ymm5, ymm4
    vsubpd ymm8, ymm3, ymm8
    vsubpd ymm4, ymm6, ymm4
    vaddpd ymm8, ymm8, ymm4
    vaddpd ymm4, ymm2, ymm7
    vsubpd ymm9, ymm4, ymm2
    vsubpd ymm10, ymm4, ymm9
    vsubpd ymm10, ymm2, ymm10
    vsubpd ymm9, ymm7, ymm9
M2p_a3a5
    vsubpd ymm8, ymm9, ymm8
    vbroadcastsd ymm7, [d_c3]
    vmulpd ymm6, ymm7, ymm0
    vmovapd ymm3, ymm6
    vfmsub231pd ymm3, ymm7, ymm0
    vmulpd ymm9, ymm2, ymm0
    vfmadd231pd ymm9, ymm7, ymm1
    vaddpd ymm3, ymm3, ymm9
    vaddpd ymm9, ymm6, ymm3
    vsubpd ymm4, ymm9, ymm6
    vsubpd ymm4, ymm3, ymm4
    vbroadcastsd ymm7, [d_one]
    vaddpd ymm3, ymm7, ymm9
    vsubpd ymm6, ymm3, ymm7
    vsubpd ymm5, ymm3, ymm6
    vsubpd ymm5, ymm7, ymm5
    vsubpd ymm6, ymm9, ymm6
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm2, ymm4
    vsubpd ymm11, ymm6, ymm2
    vsubpd ymm12, ymm6, ymm11
    vsubpd ymm12, ymm2, ymm12
    vsubpd ymm11, ymm4, ymm11
    vaddpd ymm12, ymm12, ymm11
    vaddpd ymm11, ymm5, ymm6
    vaddpd ymm6, ymm3, ymm11
    vsubpd ymm5, ymm6, ymm3
    vsubpd ymm5, ymm11, ymm5
    vaddpd ymm11, ymm5, ymm12
    vaddpd ymm12, ymm6, ymm11
    vsubpd ymm5, ymm12, ymm6
    vsubpd ymm5, ymm11, ymm5
    vdivpd ymm7, ymm10, ymm12
    vbroadcastsd ymm4, [d_sgn]
    vxorpd ymm4, ymm4, ymm7
    vmulpd ymm9, ymm12, ymm4
    vmovapd ymm11, ymm9
    vfmsub231pd ymm11, ymm12, ymm4
    vmulpd ymm6, ymm5, ymm4
    vfmadd231pd ymm6, ymm12, ymm2
    vaddpd ymm11, ymm11, ymm6
    vaddpd ymm6, ymm9, ymm11
    vsubpd ymm3, ymm6, ymm9
    vsubpd ymm3, ymm11, ymm3
    vaddpd ymm4, ymm10, ymm6
    vsubpd ymm11, ymm4, ymm10
    vsubpd ymm9, ymm4, ymm11
    vsubpd ymm9, ymm10, ymm9
    vsubpd ymm11, ymm6, ymm11
    vaddpd ymm9, ymm9, ymm11
    vaddpd ymm11, ymm8, ymm3
    vsubpd ymm13, ymm11, ymm8
    vsubpd ymm14, ymm11, ymm13
    vsubpd ymm14, ymm8, ymm14
    vsubpd ymm13, ymm3, ymm13
    vaddpd ymm14, ymm14, ymm13
    vaddpd ymm13, ymm9, ymm11
    vaddpd ymm11, ymm4, ymm13
    vsubpd ymm9, ymm11, ymm4
M2p_a3b8
    vsubpd ymm9, ymm13, ymm9
    vdivpd ymm8, ymm14, ymm12
    vbroadcastsd ymm10, [d_sgn]
    vxorpd ymm10, ymm10, ymm8
    vmulpd ymm3, ymm12, ymm10
    vmovapd ymm6, ymm3
    vfmsub231pd ymm6, ymm12, ymm10
    vmulpd ymm13, ymm5, ymm10
    vfmadd231pd ymm13, ymm12, ymm2
    vaddpd ymm6, ymm6, ymm13
    vaddpd ymm13, ymm3, ymm6
    vsubpd ymm11, ymm13, ymm3
    vsubpd ymm11, ymm6, ymm11
    vaddpd ymm10, ymm14, ymm13
    vsubpd ymm6, ymm10, ymm14
    vsubpd ymm3, ymm10, ymm6
    vsubpd ymm3, ymm14, ymm3
    vsubpd ymm6, ymm13, ymm6
    vaddpd ymm3, ymm3, ymm6
    vaddpd ymm6, ymm9, ymm11
    vsubpd ymm4, ymm6, ymm9
    vsubpd ymm15, ymm6, ymm4
    vsubpd ymm15, ymm9, ymm15
    vsubpd ymm4, ymm11, ymm4
    vaddpd ymm15, ymm15, ymm4
    vaddpd ymm4, ymm3, ymm6
    vaddpd ymm6, ymm10, ymm4
    vsubpd ymm3, ymm6, ymm10
    vsubpd ymm3, ymm4, ymm3
    vaddpd ymm4, ymm3, ymm15
    vaddpd ymm15, ymm6, ymm4
    vdivpd ymm9, ymm15, ymm12
    vaddpd ymm3, ymm7, ymm8
    vsubpd ymm15, ymm3, ymm7
    vsubpd ymm15, ymm8, ymm15
    vaddpd ymm8, ymm3, ymm9
    vsubpd ymm7, ymm8, ymm3
    vsubpd ymm14, ymm8, ymm7
    vsubpd ymm14, ymm3, ymm14
    vsubpd ymm7, ymm9, ymm7
    vaddpd ymm14, ymm14, ymm7
    vaddpd ymm7, ymm15, ymm2
    vsubpd ymm11, ymm7, ymm15
    vsubpd ymm13, ymm7, ymm11
    vsubpd ymm13, ymm15, ymm13
    vsubpd ymm11, ymm2, ymm11
    vaddpd ymm13, ymm13, ymm11
    vaddpd ymm11, ymm14, ymm7
    vaddpd ymm7, ymm8, ymm11
    vsubpd ymm14, ymm7, ymm8
    vsubpd ymm14, ymm11, ymm14
    vaddpd ymm11, ymm14, ymm13
    vaddpd ymm13, ymm7, ymm11
    vsubpd ymm14, ymm13, ymm7
M2p_a3bf
    vbroadcastsd ymm2, [d_m2]
M2p_a3d2
    vsubpd ymm7, ymm6, ymm4
M2p_a3ac
M2p_a3e7
section .note.GNU-stack noalloc noexec nowrite progbits
