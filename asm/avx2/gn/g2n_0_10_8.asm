%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_0_10_8_pft: dq xav_g2_0_10_8.pf1, xav_g2_0_10_8.pf2, xav_g2_0_10_8.pf3, xav_g2_0_10_8.pf4, xav_g2_0_10_8.pf5, xav_g2_0_10_8.pf6, xav_g2_0_10_8.pf7, xav_g2_0_10_8.pf8, xav_g2_0_10_8.pf9, xav_g2_0_10_8.pf10, xav_g2_0_10_8.pf11, xav_g2_0_10_8.pf12, xav_g2_0_10_8.pf13, xav_g2_0_10_8.pf14, xav_g2_0_10_8.pf15, xav_g2_0_10_8.pf16, xav_g2_0_10_8.pf17, xav_g2_0_10_8.pf18, xav_g2_0_10_8.pf19, xav_g2_0_10_8.pf20, xav_g2_0_10_8.pf21, xav_g2_0_10_8.pf22, xav_g2_0_10_8.pf23, xav_g2_0_10_8.pf24, xav_g2_0_10_8.pf25, xav_g2_0_10_8.pf26, xav_g2_0_10_8.pf27, xav_g2_0_10_8.pf28, xav_g2_0_10_8.pf29, xav_g2_0_10_8.pf30, xav_g2_0_10_8.pf31, xav_g2_0_10_8.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_0_10_8
align 64
xav_g2_0_10_8:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_0_10_8_pft]
    mov rax, [rcx + rax*8 - 8]
    mov [rbp + 328], rax
.per:
    mov [rbp + 48], r15
.rg:
    mov ecx, [r15 + Pc_ch]
    cmp [rbp + 32], rcx
    ja .rgd
    mov rcx, [rbp + 32]
    mov rdi, [rbp + 8]
    mov r8, [rdi + G_wc]
    mov rax, rcx
    imul rax, [rdi + G_cs]
    add rax, rax
    mov rsi, [rdi + G_sb]
    add rsi, rax
    mov rdx, [rdi + G_sr]
    add rdx, rax
    mov r9, [rdi + G_ct]
    lea r10, [r9 + 32]
    lea r11, [r9 + r8*4 + 160]
    and rcx, [rdi + G_km]
    imul rcx, [rdi + G_wp]
    shl rcx, 3
    add rcx, [rdi + G_cr]
    mov r12, rcx
    mov r13, [rdi + G_nbc]
    vmovdqu ymm7, [c_n512]
    xor eax, eax
    lea r14, [r13 - 1]
    test r14, r14
    jz .cvt
.cv1:
M2s_a8
    vcvtdq2ps ymm0, ymm0
    vcvtdq2ps ymm1, ymm1
    vmovups [r10 + rax*4], ymm0
    vmovups [r11 + rax*4], ymm1
    add eax, 8
    dec r14
    jnz .cv1
.cvt:
    vmovdqu ymm6, [rdi + G_ri]
M2s_a8
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
    vmovaps ymm6, [c_h0625]
    vmovaps ymm7, [c_h5625]
    xor eax, eax
.cv2:
    vmovups ymm0, [r10 + rax*4]
    vaddps ymm1, ymm0, [r10 + rax*4 + 4]
    vmovups ymm2, [r10 + rax*4 - 4]
    vaddps ymm2, ymm2, [r10 + rax*4 + 8]
M2s_aa
    vperm2f128 ymm5, ymm3, ymm4, 0x20
    vperm2f128 ymm3, ymm3, ymm4, 0x31
    vmovups [r12 + 0], ymm5
    vmovups [r12 + 64], ymm3
    vmovups ymm0, [r11 + rax*4]
    vaddps ymm1, ymm0, [r11 + rax*4 + 4]
    vmovups ymm2, [r11 + rax*4 - 4]
    vaddps ymm2, ymm2, [r11 + rax*4 + 8]
M2s_aa
    vperm2f128 ymm5, ymm3, ymm4, 0x20
    vperm2f128 ymm3, ymm3, ymm4, 0x31
    vmovups [r12 + 32], ymm5
    vmovups [r12 + 96], ymm3
    add r12, 128
    add eax, 8
    dec r13
    jnz .cv2
    mov r15, [rbp + 48]
    inc qword [rbp + 32]
    jmp .rg
.rgd:
    mov qword [rbp + 40], 0
.str:
    mov rdi, [rbp + 8]
    mov rax, [rbp + 40]
    imul rax, [rdi + G_sp]
    mov [rbp + 56], rax
    mov rcx, [rdi + G_wi]
    sub rcx, rax
    mov rdx, [rdi + G_sp]
    cmp rcx, rdx
    cmova rcx, rdx
    add rcx, 7
    shr rcx, 3
    mov [rbp + 64], rcx
    mov rax, [rdi + G_sb2]
    mov [rbp + 88], rax
    mov rcx, [rdi + G_spp]
    shl rcx, 2
    mov [rbp + 120], rcx
    lea rax, [rax + rcx*4]
    mov [rbp + 96], rax
    mov rax, [rbp + 56]
    shl rax, 2
    add rax, [rdi + G_nx]
    mov [rbp + 104], rax
    mov rax, [rdi + G_wp]
    shl rax, 2
    mov [rbp + 128], rax
    mov rax, [rdi + G_zr]
    mov [rbp + 112], rax
    mov r15, [rbp + 48]
    mov eax, [r15 + Pc_y0]
    mov [rbp + 72], rax
    mov eax, [r15 + Pc_n]
    add eax, [r15 + Pc_n + 4]
    add eax, [r15 + Pc_n + 8]
    add eax, [r15 + Pc_n + 12]
    add rax, [rbp + 72]
    dec rax
    mov [rbp + 352], rax
    mov qword [rbp + 344], -1
    mov eax, [r15 + Pc_n]
    test eax, eax
    jz .r0e
    mov [rbp + 80], rax
M2s_ac
    mov rax, [rbp + 112]
    mov [rbp + 152], rax
    mov qword [rbp + 160], 0
M2s_ad
    cmovne rcx, [rbp + 128]
    mov [rbp + 152], rax
    mov [rbp + 160], rcx
.r0:
    mov rax, [rbp + 152]
    cmp rax, [rbp + 112]
    jne .r0ca
    call .rowz
    jmp .r0cb
.r0ca:
    call .rowa
.r0cb:
    mov r15, [rbp + 48]
M2s_ac
M2s_ae
    inc qword [rbp + 72]
    dec qword [rbp + 80]
    jnz .r0
.r0e:
    cmp dword [r15 + Pc_n + 4], 0
    je .s1e
M2s_ac
M2s_ae
    mov eax, [r15 + Pc_w + 0]
    mov [rbp + 168], eax
    cmp dword [r15 + Pc_n], 0
    jne .s1b
M2s_ad
    cmovne rcx, [rbp + 128]
    mov [rbp + 152], rax
    mov [rbp + 160], rcx
.s1b:
    mov rax, [rbp + 96]
    mov [rbp + 176], rax
    mov rax, [rbp + 120]
M2s_a10
    mov eax, [r15 + Pc_w + 4]
    mov [rbp + 208], eax
    call .rows
    mov r15, [rbp + 48]
    inc qword [rbp + 72]
.s1e:
    mov eax, [r15 + Pc_n + 8]
    test eax, eax
    jz .r1e
    mov [rbp + 80], rax
M2s_a11
    mov rax, [rbp + 112]
    xor ecx, ecx
    cmp dword [r15 + Pc_n + 4], 0
M2s_a12
.r1:
    mov rax, [rbp + 152]
    cmp rax, [rbp + 112]
    jne .r1ca
    call .rowz
    jmp .r1cb
.r1ca:
    call .rowa
.r1cb:
    mov r15, [rbp + 48]
M2s_a11
    inc qword [rbp + 72]
    dec qword [rbp + 80]
    jnz .r1
.r1e:
    cmp dword [r15 + Pc_n + 12], 0
    je .s2e
M2s_a11
    mov eax, [r15 + Pc_w + 8]
    mov [rbp + 168], eax
    mov edx, [r15 + Pc_n + 4]
    or edx, [r15 + Pc_n + 8]
    mov rax, [rbp + 112]
    xor ecx, ecx
    test edx, edx
M2s_a12
    mov rax, [rbp + 104]
    mov [rbp + 176], rax
    mov rax, [rbp + 128]
M2s_a10
    mov eax, [r15 + Pc_w + 12]
    mov [rbp + 208], eax
M2s_a15
    vmovups ymm8, [rcx + 0]
    vmovups ymm9, [rcx + 32]
    vmovups ymm10, [rcx + 64]
    vmovups ymm11, [rcx + 96]
    vmovups ymm12, [rcx + 128]
    vmovups ymm13, [rcx + 160]
M2s_a16
M2s_a17
    mov rbx, [rdi + G_gp]
    shl rbx, 2
.hu:
M2s_a1b
M2s_a37
M2s_a58
M2s_a77
M2s_a8a
M2s_a9d
M2s_aa8
M2s_ab5
M2s_ad0
M2s_aee
M2s_a114
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 32]
    vpermps ymm1, ymm3, [r9 + 100]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 64]
    vpermps ymm1, ymm3, [r9 + 132]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmovdqu ymm3, [rdx + 96]
    vpermps ymm1, ymm3, [r9 + 164]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a137
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm6, ymm0, [rcx + 288]
    lea r13, [r9 + r14]
M2s_a87
M2s_a8c
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 224]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vmulps ymm7, ymm0, [rcx + 320]
M2s_a8f
M2s_a92
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 228]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 352]
M2s_a95
M2s_a98
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 232]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 384]
M2s_a9b
M2s_aa0
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 236]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 416]
M2s_aa3
M2s_aa5
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 240]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 448]
M2s_aa6
M2s_aa7
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 244]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 480]
M2s_aa9
M2s_aab
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 248]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 512]
M2s_aac
M2s_aae
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 252]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 544]
M2s_aaf
M2s_ab6
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 256]
    vblendvps ymm0, ymm0, ymm1, ymm3
    vfmadd231ps ymm7, ymm0, [rcx + 576]
M2s_ab7
M2s_abc
    vmovdqu ymm3, [rdx + 416]
    vpermps ymm1, ymm3, [r13 + 260]
    vblendvps ymm0, ymm0, ymm1, ymm3
M2s_a13e
    vaddps ymm0, ymm4, ymm5
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r10 + 0], ymm0
    vaddps ymm0, ymm6, ymm7
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r11 + 0], ymm0
M2s_a145
M2s_a146
M2s_a14b
    vmovaps ymm15, ymm4
M2s_a1b
M2s_a37
M2s_a58
M2s_a77
M2s_a8a
M2s_a9d
M2s_aa8
M2s_ab5
M2s_ad0
M2s_aee
M2s_a114
M2s_a136
M2s_a94
M2s_a13a
M2s_aa4
M2s_a13b
M2s_aad
M2s_a13c
M2s_ab9
M2s_a13e
    vaddps ymm0, ymm4, ymm5
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r10 + 128], ymm0
    vaddps ymm0, ymm6, ymm7
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r11 + 128], ymm0
M2s_a145
M2s_a14a
M2s_a14f
M2s_a151
M2s_a153
    vfmadd213ps ymm1, ymm0, ymm12
    vmovups [rdx + 192], ymm1
    add rax, 128
    add rdx, 224
M2s_a159
    vmovups ymm1, [rdx+192]
    vmovups ymm2, [rax+128]
M2s_a15f
M2s_a162
M2s_a167
    jae .i1l0
.i1l0r:
    test rcx, rcx
    jz .i1l0e
M2s_a15b
    vmovups ymm11, [rdi+(G_lom+0)]
    vmovups ymm10, [c_ieq]
.i1l0s:
M2s_a170
    add rdx, 224
    add r9, 288
    dec rcx
    jnz .i1l0s
.i1l0e:
M2s_a15a
    cmp rcx, 2
    jb .i1l1r
M2s_a179
    vmovups ymm11, [rdi+(G_lom+32)]
    vmovups ymm10, [c_ieq]
.i1l1:
    vmovups ymm0, [rax+32]
    vmovups ymm1, [rdx+192]
    vmovups ymm2, [rax+160]
M2s_a15f
    vrcpps ymm9, ymm6
    vcmpps ymm0, ymm7, ymm14, 30
    vrcpps ymm2, ymm7
    vmovaps [r9+160], ymm8
    vandnps ymm6, ymm8, ymm1
    vaddps ymm7, ymm4, ymm6
    vmovaps [r9+448], ymm0
    vandnps ymm4, ymm0, ymm3
    vmulps ymm6, ymm1, ymm9
    vaddps ymm1, ymm5, ymm4
    vmovaps [r9+96], ymm7
    vmulps ymm9, ymm3, ymm2
    vmovaps [r9+384], ymm1
M2s_a166
    vmovaps [r9+128], ymm5
    vmovaps [r9+416], ymm4
M2s_a16a
    cmp rcx, 2
    jae .i1l1
.i1l1r:
    test rcx, rcx
    jz .i1l1e
M2s_a179
M2s_a184
M2s_a171
M2s_a186
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+128], ymm9
M2s_a177
    jnz .i1l1s
.i1l1e:
M2s_a15a
    cmp rcx, 2
    jb .i1l2r
M2s_a188
    vmovups ymm11, [rdi+(G_lom+64)]
    vmovups ymm10, [c_ieq]
.i1l2:
    vmovups ymm0, [rax+64]
    vmovups ymm1, [rdx+192]
    vmovups ymm2, [rax+192]
M2s_a15f
    vrcpps ymm9, ymm6
    vcmpps ymm0, ymm7, ymm14, 30
    vrcpps ymm2, ymm7
    vmovaps [r9+256], ymm8
    vandnps ymm6, ymm8, ymm1
    vaddps ymm7, ymm4, ymm6
    vmovaps [r9+544], ymm0
    vandnps ymm4, ymm0, ymm3
    vmulps ymm6, ymm1, ymm9
    vaddps ymm1, ymm5, ymm4
    vmovaps [r9+192], ymm7
    vmulps ymm9, ymm3, ymm2
    vmovaps [r9+480], ymm1
M2s_a166
    vmovaps [r9+224], ymm5
    vmovaps [r9+512], ymm4
M2s_a16a
    cmp rcx, 2
    jae .i1l2
.i1l2r:
    test rcx, rcx
    jz .i1l2e
M2s_a188
M2s_a194
M2s_a171
M2s_a196
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+224], ymm9
M2s_a177
    jnz .i1l2s
.i1l2e:
M2s_a15a
M2s_a197
M2s_a1a9
M2s_a1af
    vandps ymm9, ymm10, [r9+256]
    vpsubd ymm6, ymm4, ymm0
    vmovaps [rdx+128], ymm9
M2s_a1b1
M2s_a16a
    cmp rcx, 2
    jae .i2l2
.i2l2r:
    test rcx, rcx
    jz .i2l2e
M2s_a198
    vmovups ymm11, [c_q8o1]
.i2l2s:
M2s_a19d
M2s_a1bc
M2s_a1c5
M2s_a177
    jnz .i2l2s
.i2l2e:
M2s_a15a
    cmp rcx, 2
    jb .i2l0r
M2s_a198
.i2l0:
    vmovups ymm0, [r9]
M2s_a19e
M2s_a1a3
    vmovups ymm9, [rax]
    vblendvps ymm2, ymm5, ymm6, ymm3
    vblendvps ymm5, ymm7, ymm8, ymm3
    vpsubd ymm6, ymm11, ymm0
    vmovups ymm7, [r9+288]
M2s_a1a6
M2s_a1ad
M2s_a1cc
    vpsubd ymm6, ymm4, ymm0
    vmovaps [rdx], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
    vfmadd213ps ymm5, ymm6, ymm14
    vmovaps [rdx+32], ymm11
M2s_a1b3
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+320]
    vandps ymm6, ymm3, [r9+352]
    vmovaps [rdx+224], ymm6
    vmovaps [rdx+256], ymm8
M2s_a16a
    cmp rcx, 2
    jae .i2l0
.i2l0r:
    test rcx, rcx
    jz .i2l0e
M2s_a198
    vmovups ymm11, [c_q8o1]
.i2l0s:
M2s_a1ca
M2s_a1bd
    vpslld ymm9, ymm2, 23
    vblendvps ymm2, ymm5, ymm6, ymm3
    vmovups ymm5, [rax]
M2s_a1be
M2s_a1c4
    vorps ymm6, ymm9, ymm3
    vmulps ymm4, ymm3, [r9+32]
    vandps ymm7, ymm6, [r9+64]
    vmovaps [rdx], ymm7
    vmovaps [rdx+32], ymm4
M2s_a177
    jnz .i2l0s
.i2l0e:
M2s_a15a
    cmp rcx, 2
    jb .i2l1r
M2s_a198
.i2l1:
    vmovups ymm0, [r9+96]
M2s_a19e
M2s_a1a3
    vmovups ymm9, [rax+32]
    vblendvps ymm2, ymm5, ymm6, ymm3
    vblendvps ymm5, ymm7, ymm8, ymm3
    vpsubd ymm6, ymm11, ymm0
    vmovups ymm7, [r9+384]
M2s_a1a6
M2s_a1ad
M2s_a1dc
    vpsubd ymm6, ymm4, ymm0
    vmovaps [rdx+64], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
    vfmadd213ps ymm5, ymm6, ymm14
    vmovaps [rdx+96], ymm11
M2s_a1b3
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+416]
    vandps ymm6, ymm3, [r9+448]
    vmovaps [rdx+288], ymm6
    vmovaps [rdx+320], ymm8
M2s_a16a
    cmp rcx, 2
    jae .i2l1
.i2l1r:
    test rcx, rcx
    jz .i2l1e
M2s_a198
    vmovups ymm11, [c_q8o1]
.i2l1s:
M2s_a1d9
M2s_a1bd
    vpslld ymm9, ymm2, 23
    vblendvps ymm2, ymm5, ymm6, ymm3
    vmovups ymm5, [rax+32]
M2s_a1be
M2s_a1c4
    vorps ymm6, ymm9, ymm3
    vmulps ymm4, ymm3, [r9+128]
    vandps ymm7, ymm6, [r9+160]
    vmovaps [rdx+64], ymm7
    vmovaps [rdx+96], ymm4
M2s_a177
M2s_a1e7
    vmovaps ymm14, [rdi + G_lmx + 32]
    vmovaps ymm15, [rdi + G_lmx + 64]
    vmovaps ymm12, [rdi + G_lsl]
    mov r8, [rdi + G_eb]
M2s_a1e8
M2s_a1ed
    vmulps ymm0, ymm15, [r8 + 128]
    vfmadd231ps ymm0, ymm13, [r8]
    vfmadd231ps ymm0, ymm14, [r8 + 64]
    vmovaps ymm1, ymm12
    vfmadd231ps ymm1, ymm15, [r8 + 160]
    vfmadd231ps ymm1, ymm13, [r8 + 32]
    vfmadd231ps ymm1, ymm14, [r8 + 96]
M2s_a1ee
    add r8, 224
    add r9, 16
    sub r10, 8
    inc r11
    dec rbx
    jnz .ed
    inc qword [rbp + 248]
    cmp qword [rbp + 248], 2
    jb .et
    mov rdi, [rbp + 8]
    mov rax, [rdi + G_su]
    shl rax, 2
    imul rax, [rbp + 40]
    mov [rbp + 232], rax
    mov rcx, [rdi + G_wo]
    shr rcx, 1
M2s_a150
    shr rdx, 1
    cmp rcx, rdx
    cmova rcx, rdx
    mov [rbp + 240], rcx
    mov rax, [rdi + G_cc]
M2s_a152
    vmovaps ymm15, [c_epsf]
    vmovaps ymm14, [rdi + G_csn]
    vmovaps ymm13, [rdi + G_can]
    vmovaps ymm12, [rdi + G_cta]
.itc:
M2s_a158
    jnz .itc
M2s_a15a
    cmp rcx, 2
    jb .i1c0r
M2s_a1f9
    vmovups ymm11, [rdi+(G_com+0)]
    vmovups ymm10, [c_ieq]
.i1c0:
M2s_a15e
    add r9, 576
    sub rcx, 2
    cmp rcx, 2
    jae .i1c0
.i1c0r:
    test rcx, rcx
    jz .i1c0e
M2s_a1f9
    vmovups ymm11, [rdi+(G_com+0)]
    vmovups ymm10, [c_ieq]
.i1c0s:
M2s_a170
    add rdx, 224
    add r9, 288
    dec rcx
    jnz .i1c0s
.i1c0e:
M2s_a15a
    cmp rcx, 2
    jb .i1c1r
M2s_a204
    vmovups ymm11, [rdi+(G_com+32)]
    vmovups ymm10, [c_ieq]
.i1c1:
M2s_a17a
    add r9, 576
    sub rcx, 2
    cmp rcx, 2
    jae .i1c1
.i1c1r:
    test rcx, rcx
    jz .i1c1e
M2s_a204
    vmovups ymm11, [rdi+(G_com+32)]
    vmovups ymm10, [c_ieq]
.i1c1s:
M2s_a185
    add rdx, 224
    add r9, 288
    dec rcx
    jnz .i1c1s
.i1c1e:
M2s_a15a
    cmp rcx, 2
    jb .i1c2r
M2s_a20e
    vmovups ymm11, [rdi+(G_com+64)]
    vmovups ymm10, [c_ieq]
.i1c2:
M2s_a189
    add r9, 576
    sub rcx, 2
    cmp rcx, 2
    jae .i1c2
.i1c2r:
    test rcx, rcx
    jz .i1c2e
M2s_a20e
    vmovups ymm11, [rdi+(G_com+64)]
    vmovups ymm10, [c_ieq]
.i1c2s:
M2s_a195
    add rdx, 224
M2s_a215
M2s_a15a
    cmp rcx, 2
    jb .i2c2r
M2s_a198
.i2c2:
M2s_a19c
M2s_a16a
    cmp rcx, 2
    jae .i2c2
.i2c2r:
    test rcx, rcx
    jz .i2c2e
M2s_a198
    vmovups ymm11, [c_q8o1]
.i2c2s:
M2s_a19d
M2s_a1bc
M2s_a1c5
M2s_a177
    jnz .i2c2s
.i2c2e:
M2s_a15a
    cmp rcx, 2
    jb .i2c0r
M2s_a198
.i2c0:
M2s_a1c9
M2s_a16a
    cmp rcx, 2
    jae .i2c0
.i2c0r:
    test rcx, rcx
    jz .i2c0e
M2s_a198
    vmovups ymm11, [c_q8o1]
.i2c0s:
M2s_a1ca
M2s_a1bd
M2s_a1d4
M2s_a1d5
    jnz .i2c0s
.i2c0e:
M2s_a15a
    cmp rcx, 2
    jb .i2c1r
M2s_a198
.i2c1:
M2s_a1da
M2s_a16a
    cmp rcx, 2
    jae .i2c1
.i2c1r:
    test rcx, rcx
    jz .i2c1e
M2s_a198
    vmovups ymm11, [c_q8o1]
.i2c1s:
M2s_a1d9
M2s_a1bd
M2s_a1e4
M2s_a1e5
    jnz .i2c1s
.i2c1e:
    mov rdi, [rbp + 8]
    mov r8, [rdi + G_eb]
M2s_a222
M2s_a225
    vmulps ymm0, ymm5, [r8]
    vmovaps ymm6, [rdi + G_cmx + 64]
    vfmadd231ps ymm0, ymm6, [r8 + 64]
    vmovaps ymm8, [rdi + G_cmx + 0]
    vmovaps ymm7, ymm8
    vfmsub132ps ymm7, ymm0, [r8 + 128]
    vmovaps ymm1, [rdi + G_csb]
    vfmadd231ps ymm1, ymm5, [r8 + 32]
    vfmadd231ps ymm1, ymm6, [r8 + 96]
    vfmadd231ps ymm1, ymm8, [r8 + 160]
M2s_a22a
    vpmaxsd ymm9, ymm9, ymm15
    vmovaps ymm5, [rdi + G_cmx + 160]
    vmulps ymm0, ymm5, [r8 + 128]
    vmovaps ymm6, [rdi + G_cmx + 128]
    vfmadd231ps ymm0, ymm6, [r8 + 64]
M2s_a22b
    vfmadd231ps ymm1, ymm5, [r8 + 160]
    vfmadd231ps ymm1, ymm6, [r8 + 96]
    vfmadd231ps ymm1, ymm8, [r8 + 32]
    vroundps ymm12, ymm7, 8
    vsubps ymm12, ymm7, ymm12
    vandps ymm12, ymm12, ymm2
    vaddps ymm12, ymm12, ymm1
    vcmpps ymm12, ymm12, ymm3, 0x05
    vcvtps2dq ymm11, ymm7
    vpaddd ymm11, ymm11, ymm13
    vpminsd ymm11, ymm11, ymm14
    vpmaxsd ymm11, ymm11, ymm15
    vpor ymm10, ymm10, ymm12
    vextracti128 xmm4, ymm9, 1
    vpackssdw xmm9, xmm9, xmm4
    vextracti128 xmm4, ymm11, 1
    vpackssdw xmm11, xmm11, xmm4
    cmp r10, 8
    jb .cbp
    vmovdqu [r9], xmm9
    jmp .cbq
.cbp:
    vmovdqu [rbp + 384], xmm9
M2s_a1f0
.cbq:
    cmp r10, 8
    jb .crp
    vmovdqu [r12], xmm11
    jmp .crq
.crp:
    vmovdqu [rbp + 384], xmm11
M2s_a1ef
    mov rdi, r12
    rep movsw
    pop rdi
    pop rsi
.crq:
    vmovmskps eax, ymm10
M2s_a1f2
    mov [r11], al
    add r8, 224
M2s_a232
    mov rsi, [rdi + G_cl]
    mov r10, [rdi + G_su]
    mov rax, r10
    shl rax, 7
    add rsi, rax
    shl r10, 3
    imul r10, [rbp + 40]
    or r10d, 0x10000
    mov r8, [rdi + G_fs]
    mov r9, [rbp + 272]
    vpcmpeqb ymm1, ymm7, [rdi + G_ms + 64]
    vpcmpeqb ymm2, ymm7, [rdi + G_ms + 96]
M2s_a233
    xor rax, -1
    jz .fbe1
.fs1:
    tzcnt rcx, rax
    blsr rax, rax
    movzx ebx, byte [rdi + G_ms + 64 + rcx]
M2s_a234
M2s_a23b
    test rax, rax
    jnz .fs1
    mov [rbp + 272], r9
.fbe1:
    mov rsi, [rdi + G_cc]
    mov r10, [rdi + G_su]
    shl r10, 2
    imul r10, [rbp + 40]
    mov r8, [rdi + G_fs]
    add r8, 327680
    mov r9, [rbp + 280]
    vpcmpeqb ymm1, ymm7, [rdi + G_ms + 128]
    vpmovmskb eax, ymm1
    xor eax, -1
    jz .fbe2
.fs2:
    tzcnt rcx, rax
    blsr rax, rax
    movzx ebx, byte [rdi + G_ms + 128 + rcx]
M2s_a235
    vpermps ymm1, ymm0, [rdx]
    vmovups [r8 + r9*4], ymm1
    vpermps ymm1, ymm0, [rdx + 32]
    vmovups [r8 + r9*4 + 16384], ymm1
    vpermps ymm1, ymm0, [rdx + 64]
    vmovups [r8 + r9*4 + 32768], ymm1
    vpermps ymm1, ymm0, [rdx + 96]
    vmovups [r8 + r9*4 + 49152], ymm1
M2s_a23a
    vpermd ymm1, ymm0, ymm1
    vmovdqu [r8 + r9*4 + 65536], ymm1
    popcnt ebx, ebx
    add r9, rbx
    test rax, rax
    jnz .fs2
    mov [rbp + 280], r9
.fbe2:
    vpxor xmm0, xmm0, xmm0
    vmovdqu [rdi + G_ms + 0], ymm0
    vmovdqu [rdi + G_ms + 32], ymm0
    vmovdqu [rdi + G_ms + 64], ymm0
    vmovdqu [rdi + G_ms + 96], ymm0
    vmovdqu [rdi + G_ms + 128], ymm0
.nf:
    mov rdi, [rbp + 8]
    inc qword [rbp + 40]
    mov rax, [rbp + 40]
    cmp rax, [rdi + G_nst]
    jb .str
    cmp qword [rbp + 272], 0
    je .ble
    mov qword [rbp + 288], 0
.bl:
M2s_a246
    lea r12, [rbp + 448]
    call .t1l
    vpackssdw xmm4, xmm4, xmm4
    vmovq [rbp + 312], xmm4
    mov qword [rbp + 304], 0
.blj:
    mov rax, [rbp + 288]
    add rax, [rbp + 304]
    cmp rax, [rbp + 272]
    jae .bln
    mov rdi, [rbp + 8]
    mov rsi, [rdi + G_fs]
    mov ecx, [rsi + rax*4 + 262144]
    movzx edx, cx
    shr ecx, 16
    mov rax, [rbp + 16]
    lea rcx, [rcx + rax*2]
    mov r8, [rbp + 304]
    movzx eax, word [rbp + 312 + r8*2]
    mov rsi, rcx
    imul rsi, [rdi + G_wo]
    add rsi, rdx
    add rsi, rsi
    add rsi, [rdi + G_dy]
    mov [rsi], ax
    cmp ax, -1
    jne .blo
    lea r12, [rbp + 448]
    mov qword [r12 + 1216], 0
    mov [r12 + 1224], rcx
    mov [r12 + 1232], rdx
    call .fz
.blo:
    inc qword [rbp + 304]
    cmp qword [rbp + 304], 4
    jb .blj
.bln:
    add qword [rbp + 288], 4
    mov rax, [rbp + 288]
    cmp rax, [rbp + 272]
    jb .bl
.ble:
    cmp qword [rbp + 280], 0
    je .bce
    mov qword [rbp + 288], 0
.bc:
M2s_a246
    add rdi, 327680
    lea r12, [rbp + 448]
    call .t1c
    vpackssdw xmm4, xmm4, xmm4
    vmovq [rbp + 312], xmm4
    vpackssdw xmm5, xmm5, xmm5
    vmovq [rbp + 320], xmm5
    mov qword [rbp + 304], 0
.bcj:
    mov rax, [rbp + 288]
M2s_a24d
M2s_a254
M2s_a25e
    mov rax, [rbp + 72]
    cmp rax, [rbp + 344]
    je .rqa
    call .fr
.rqa:
    mov rdi, [rbp + 8]
M2s_a25b
    imul rax, rax, 12
    add rbx, rax
    mov r13, [rbp + 64]
M2s_a26b
    cmp rcx, [rbp + 352]
    jae .fu
    inc rcx
    mov [rbp + 344], rcx
    mov rax, rcx
    shl rax, 5
    add rax, [rdi + G_rd]
    vbroadcastss ymm0, [rax + Rc_k + 0]
    vmovaps [rbp + 1152], ymm0
    vbroadcastss ymm0, [rax + Rc_k + 4]
    vmovaps [rbp + 1184], ymm0
    vbroadcastss ymm0, [rax + Rc_k + 8]
    vmovaps [rbp + 1216], ymm0
    vbroadcastss ymm0, [rax + Rc_k + 12]
    vmovaps [rbp + 1248], ymm0
    mov r9d, [rax + Rc_co]
    mov r10d, [rax + Rc_co + 4]
    mov r11d, [rax + Rc_co + 8]
    mov r12d, [rax + Rc_co + 12]
    mov rdx, [rbp + 56]
    mov rsi, [rdi + G_cr]
    lea rsi, [rsi + rdx*8]
    lea r9, [rsi + r9*4]
    lea r10, [rsi + r10*4]
    lea r11, [rsi + r11*4]
    lea r12, [rsi + r12*4]
M2s_a259
    imul rax, [rdi + G_ys], 2
    add rax, rcx
    call [rbp + 328]
    mov eax, [rbp + 344]
M2s_a26f
M2s_a270
    jb .fq0r
M2s_a272
    vmovaps ymm3, ymm4
    vfmadd231ps ymm3, ymm2, ymm11
    vmovaps [rdi+rdx*4+32], ymm3
    vfmadd213ps ymm2, ymm10, ymm4
    vfmadd231ps ymm4, ymm0, ymm8
    vfmadd231ps ymm2, ymm0, ymm9
    vmovaps [r14+rdx*4+32], ymm4
    vmovups ymm1, [rbx+rdx*4+32]
    vmovaps [rsi+rdx*4+32], ymm2
    vandps ymm3, ymm1, ymm6
    vxorps ymm0, ymm1, ymm3
    vpmaxud ymm4, ymm3, ymm5
M2s_a28d
M2s_a291
    jbe .fq0
.fq0r:
    cmp rdx, r13
    jae .fq0e
M2s_a274
    vmovups ymm7, [c_n64]
    vmovups ymm6, [c_absm]
    vmovups ymm5, [c_xflr]
.fq0s:
M2s_a27a
M2s_a283
M2s_a292
.fp0r:
    cmp rdx, r13
    jae .fp0e
M2s_a29e
.fp0s:
M2s_a2a1
M2s_a2a3
    jb .fp0s
.fp0e:
.fw:
M2s_a2a4
    lea r14, [rbx + r12*2]
    mov rdi, [rbp + 136]
    mov rcx, [rbp + 152]
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .fp1r
    lea r15, [r13 - 16]
M2s_a29d
.fp1:
M2s_a2a6
    vmovups ymm4, [rsi+rdx*4+32]
M2s_a2a7
M2s_a2af
    vpsrld ymm3, ymm4, 20
    vmovups ymm1, [r8+288]
    vmulps ymm6, ymm10, ymm0
    vpsubd ymm10, ymm11, ymm5
    vmovaps [rbx+rdx*4], ymm2
    vaddps ymm0, ymm2, [rcx+rdx*4]
    vpmaddwd ymm11, ymm8, ymm13
    vmovups ymm5, [r8+320]
M2s_a2b3
    vmovaps [rdi+rdx*4], ymm0
    vmovups ymm3, [c_q8e2]
    vmovaps [r8+128], ymm6
M2s_a2b4
    vmovaps [r8+96], ymm7
M2s_a2b5
    vorps ymm2, ymm8, ymm9
    vfmadd231ps ymm3, ymm1, [c_q8e3]
    vmulps ymm0, ymm2, ymm10
    vmovaps [r8+384], ymm4
    vmovaps [r8+416], ymm0
    vfmadd213ps ymm3, ymm1, [c_q8e1]
    vfmadd213ps ymm3, ymm1, [c_q8e0]
    vfmadd231ps ymm5, ymm7, ymm3
    vmovaps [rbx+rdx*4+32], ymm5
M2s_a2b6
    cmp rdx, r15
    jbe .fp1
.fp1r:
    cmp rdx, r13
    jae .fp1e
M2s_a29d
    vmovups ymm11, [c_q8e3]
.fp1s:
    vmovups ymm0, [rsi+rdx*4]
    vmovups ymm1, [r8]
    vmovups ymm2, [r8+32]
M2s_a2b9
M2s_a2bf
    vpaddd ymm9, ymm0, ymm10
    vmovaps [r8+96], ymm6
    vorps ymm8, ymm9, ymm5
    vfmadd231ps ymm2, ymm7, ymm4
    vmulps ymm1, ymm8, ymm3
    vmovaps [r8+128], ymm1
    vaddps ymm0, ymm2, [rcx+rdx*4]
    vmovaps [rbx+rdx*4], ymm2
M2s_a2c0
    jb .fp1s
.fp1e:
M2s_a2c1
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .fp2r
M2s_a2a5
    vmovups ymm12, [c_mone]
.fp2:
M2s_a2c5
    vmovups ymm4, [r14+rdx*4+32]
M2s_a2a7
M2s_a2af
    vpsrld ymm3, ymm4, 20
    vmovups ymm1, [r8+384]
    vmulps ymm6, ymm10, ymm0
    vpsubd ymm10, ymm11, ymm5
    vmovaps [rsi+rdx*4], ymm2
    vaddps ymm0, ymm2, [rcx+rdx*4]
    vpmaddwd ymm11, ymm8, ymm13
    vmovups ymm5, [r8+416]
M2s_a2b3
    vmovaps [rdi+rdx*4], ymm0
    vmovups ymm3, [c_q8e2]
    vmovaps [r8+224], ymm6
M2s_a2b4
    vmovaps [r8+192], ymm7
M2s_a2b5
    vorps ymm2, ymm8, ymm9
    vfmadd231ps ymm3, ymm1, [c_q8e3]
    vmulps ymm0, ymm2, ymm10
    vmovaps [r8+480], ymm4
    vmovaps [r8+512], ymm0
    vfmadd213ps ymm3, ymm1, [c_q8e1]
    vfmadd213ps ymm3, ymm1, [c_q8e0]
    vfmadd231ps ymm5, ymm7, ymm3
    vmovaps [rsi+rdx*4+32], ymm5
M2s_a2b6
    cmp rdx, r15
    jbe .fp2
.fp2r:
    cmp rdx, r13
    jae .fp2e
M2s_a29d
    vmovups ymm11, [c_q8e3]
.fp2s:
    vmovups ymm0, [r14+rdx*4]
    vmovups ymm1, [r8+96]
    vmovups ymm2, [r8+128]
M2s_a2b9
M2s_a2bf
    vpaddd ymm9, ymm0, ymm10
    vmovaps [r8+192], ymm6
    vorps ymm8, ymm9, ymm5
    vfmadd231ps ymm2, ymm7, ymm4
    vmulps ymm1, ymm8, ymm3
    vmovaps [r8+224], ymm1
    vaddps ymm0, ymm2, [rcx+rdx*4]
    vmovaps [rsi+rdx*4], ymm2
M2s_a2c0
    jb .fp2s
.fp2e:
M2s_a2ca
    mov r11, [rbp + 136]
    mov r10, [rbp + 152]
    mov rax, [rbp + 144]
    imul rax, rax, 3
    add r11, rax
    mov rax, [rbp + 160]
    imul rax, rax, 3
    add r10, rax
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .fp3r
M2s_a2a5
M2s_a2a0
    vmovups ymm8, [c_q8e0]
    vmovups ymm7, [c_c8]
.fp3:
M2s_a2cb
M2s_a2cc
    vmovaps ymm0, ymm10
    vfmadd231ps ymm0, ymm3, ymm11
    vmovups ymm2, [rbx+rdx*4+32]
    vaddps ymm5, ymm1, [rcx+rdx*4]
    vmovaps [rdi+rdx*4], ymm5
    vminps ymm5, ymm1, [u_zero]
    vfmadd213ps ymm0, ymm3, ymm9
    vminps ymm1, ymm2, [rsi+rdx*4+32]
    vminps ymm2, ymm6, ymm5
    vmulps ymm6, ymm3, ymm4
    vaddps ymm5, ymm2, [r10+rdx*4]
    vfmadd213ps ymm0, ymm3, ymm8
    vmovaps [r11+rdx*4], ymm5
    vfmadd231ps ymm4, ymm6, ymm0
    vaddps ymm2, ymm4, [rcx+rdx*4+32]
    vminps ymm3, ymm4, [u_zero]
    vmovaps [rdi+rdx*4+32], ymm2
    vminps ymm5, ymm1, ymm3
    vaddps ymm6, ymm5, [r10+rdx*4+32]
    vmovaps [r11+rdx*4+32], ymm6
    add r8, 576
    add rdx, 16
    cmp rdx, r15
    jbe .fp3
.fp3r:
    cmp rdx, r13
    jae .fp3e
M2s_a29e
    vmovups ymm7, [c_c8]
    vmovups ymm6, [c_p8]
    vmovups ymm5, [c_w8e]
.fp3s:
M2s_a2d1
    vmulps ymm2, ymm0, ymm1
    vfmadd231ps ymm1, ymm2, ymm3
    vaddps ymm0, ymm1, [rcx+rdx*4]
    vminps ymm2, ymm1, [u_zero]
    vmovaps [rdi+rdx*4], ymm0
    vminps ymm3, ymm4, ymm2
    vaddps ymm1, ymm3, [r10+rdx*4]
    vmovaps [r11+rdx*4], ymm1
    add r8, 288
    add rdx, 8
    cmp rdx, r13
    jb .fp3s
.fp3e:
    ret
.rows:
    mov rax, [rbp + 72]
    cmp rax, [rbp + 344]
    je .rqs
    call .fr
.rqs:
    vmovdqu ymm15, [c_absm]
    vmovdqu ymm14, [c_xflr]
    vmovdqu ymm13, [c_k5]
    vmovaps ymm12, [c_mone]
    vmovaps ymm11, [c_q8e3]
    vmovaps ymm10, [c_q8e2]
    vmovaps ymm9, [c_q8e1]
    vmovaps ymm8, [c_q8e0]
    mov rdi, [rbp + 8]
    mov rbx, [rdi + G_xb]
    mov r12, [rdi + G_sp]
    shl r12, 2
    mov r13, [rbp + 64]
    shl r13, 3
    mov eax, [rbp + 72]
    and eax, 1
    imul rax, r12
    lea rax, [rax + rax*2]
    add rbx, rax
    vbroadcastss ymm6, [rbp + 168]
    vbroadcastss ymm7, [rbp + 208]
    mov rsi, rbx
    mov rdi, [rbp + 136]
    mov rcx, [rbp + 152]
    mov r8, [rbp + 176]
    mov r9, [rbp + 192]
    xor edx, edx
.ls0:
M2s_a2d6
    add rdx, 8
    cmp rdx, r13
    jb .ls0
    lea rsi, [rbx + r12]
M2s_a2c1
    mov r8, [rbp + 176]
    mov r9, [rbp + 192]
    mov rax, [rbp + 184]
    imul rax, rax, 1
    add r8, rax
    mov rax, [rbp + 200]
    imul rax, rax, 1
    add r9, rax
    xor edx, edx
.ls1:
M2s_a2d6
    add rdx, 8
    cmp rdx, r13
    jb .ls1
    lea rsi, [rbx + r12*2]
M2s_a2ca
    mov r8, [rbp + 176]
    mov r9, [rbp + 192]
    mov rax, [rbp + 184]
    imul rax, rax, 2
    add r8, rax
    mov rax, [rbp + 200]
    imul rax, rax, 2
    add r9, rax
    mov r10, [rbp + 136]
    mov r11, [rbp + 152]
    mov rax, [rbp + 144]
    imul rax, rax, 3
    add r10, rax
    mov rax, [rbp + 160]
    imul rax, rax, 3
    add r11, rax
    mov r14, [rbp + 176]
    mov r15, [rbp + 192]
    mov rax, [rbp + 184]
    imul rax, rax, 3
    add r14, rax
    mov rax, [rbp + 200]
    imul rax, rax, 3
    add r15, rax
    lea rax, [rbx + r12]
    xor edx, edx
.ls2:
M2s_a2d7
M2s_a2d8
    vorps ymm5, ymm5, ymm0
M2s_a2d9
    vfmadd231ps ymm0, ymm5, ymm7
    vmovups [r8 + rdx*4], ymm0
    vmovups ymm1, [rbx + rdx*4]
    vminps ymm1, ymm1, [rax + rdx*4]
    vxorps ymm2, ymm2, ymm2
    vminps ymm2, ymm5, ymm2
    vminps ymm1, ymm1, ymm2
    vmovups ymm0, [r11 + rdx*4]
    vfmadd231ps ymm0, ymm1, ymm6
    vmovups [r10 + rdx*4], ymm0
    vmovups ymm0, [r15 + rdx*4]
    vfmadd231ps ymm0, ymm1, ymm7
    vmovups [r14 + rdx*4], ymm0
    add rdx, 8
    cmp rdx, r13
    jb .ls2
    ret
.rowz:
    mov rax, [rbp + 72]
    cmp rax, [rbp + 344]
    je .rqz
    call .fr
.rqz:
M2s_a268
M2s_a26b
    cmp rcx, [rbp + 352]
    jae .zu
M2s_a26d
M2s_a26f
M2s_a270
    jb .zq0r
M2s_a271
M2s_a277
.zq0:
M2s_a279
M2s_a28e
    add r8, 576
    add rdx, 16
    cmp rdx, r15
    jbe .zq0
.zq0r:
    cmp rdx, r13
    jae .zq0e
M2s_a274
    vmovups ymm7, [c_n64]
    vmovups ymm6, [c_absm]
    vmovups ymm5, [c_xflr]
.zq0s:
M2s_a27a
M2s_a283
M2s_a293
    add r8, 288
    add rdx, 8
    cmp rdx, r13
    jb .zq0s
.zq0e:
    jmp .zw
.zu:
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .zp0r
    lea r15, [r13 - 16]
    vmovups ymm15, [c_absm]
.zp0:
M2s_a296
M2s_a297
M2s_a298
    cmp rdx, r15
    jbe .zp0
.zp0r:
    cmp rdx, r13
    jae .zp0e
M2s_a29e
.zp0s:
M2s_a2a1
M2s_a2a3
    jb .zp0s
.zp0e:
.zw:
M2s_a2a4
    lea r14, [rbx + r12*2]
    mov rdi, [rbp + 136]
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .zp1r
M2s_a2a5
    vmovups ymm12, [c_mone]
    vmovups ymm11, [c_q8e3]
.zp1:
    vmovups ymm0, [rsi+rdx*4]
M2s_a2a2
M2s_a2ed
    vpermps ymm9, ymm5, [c_rxe]
    vmovups ymm10, [r8]
    vmovups ymm0, [r8+32]
M2s_a2ee
    vpsubd ymm4, ymm9, ymm7
    vfmadd213ps ymm3, ymm4, ymm12
    vmovups ymm1, [rsi+rdx*4+32]
M2s_a2f0
    vorps ymm5, ymm9, ymm2
    vmovaps [r8+96], ymm3
    vmulps ymm6, ymm5, ymm8
    vfmadd213ps ymm7, ymm10, [c_q8e1]
    vandps ymm9, ymm1, ymm15
    vmovaps [r8+128], ymm6
M2s_a2f2
    vfmadd213ps ymm7, ymm10, [c_q8e0]
    vmovups ymm8, [r8+288]
    vpsubd ymm10, ymm5, ymm1
    vmovups ymm5, [r8+320]
M2s_a2f3
    vmovaps [rbx+rdx*4], ymm0
    vmovaps [rdi+rdx*4], ymm0
    vpaddd ymm4, ymm7, ymm6
    vorps ymm1, ymm4, ymm2
    vmovaps [r8+384], ymm3
    vmulps ymm0, ymm8, ymm5
    vmulps ymm7, ymm1, ymm9
    vfmadd213ps ymm10, ymm8, [c_q8e1]
    vmovaps [r8+416], ymm7
    vfmadd213ps ymm10, ymm8, [c_q8e0]
    vfmadd231ps ymm5, ymm0, ymm10
    vmovaps [rbx+rdx*4+32], ymm5
M2s_a2f5
    jbe .zp1
.zp1r:
    cmp rdx, r13
    jae .zp1e
M2s_a29d
.zp1s:
M2s_a2a6
    vandps ymm4, ymm0, ymm15
    vxorps ymm5, ymm0, ymm4
    vpmaxud ymm6, ymm4, ymm14
    vfmadd231ps ymm3, ymm1, [c_q8e3]
M2s_a2ba
M2s_a2f8
M2s_a2fb
    vorps ymm11, ymm4, ymm5
    vmovaps [r8+96], ymm6
    vmulps ymm8, ymm11, ymm0
    vfmadd231ps ymm2, ymm7, ymm3
    vmovaps [r8+128], ymm8
    vmovaps [rbx+rdx*4], ymm2
M2s_a2fd
    jb .zp1s
.zp1e:
    mov rdi, [rbp + 136]
    mov rax, [rbp + 144]
    imul rax, rax, 1
    add rdi, rax
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .zp2r
M2s_a2a5
    vmovups ymm12, [c_mone]
    vmovups ymm11, [c_q8e3]
.zp2:
    vmovups ymm0, [r14+rdx*4]
M2s_a2a2
M2s_a2ed
    vpermps ymm9, ymm5, [c_rxe]
    vmovups ymm10, [r8+96]
    vmovups ymm0, [r8+128]
M2s_a2ee
    vpsubd ymm4, ymm9, ymm7
    vfmadd213ps ymm3, ymm4, ymm12
    vmovups ymm1, [r14+rdx*4+32]
M2s_a2f0
    vorps ymm5, ymm9, ymm2
    vmovaps [r8+192], ymm3
    vmulps ymm6, ymm5, ymm8
    vfmadd213ps ymm7, ymm10, [c_q8e1]
    vandps ymm9, ymm1, ymm15
    vmovaps [r8+224], ymm6
M2s_a2f2
    vfmadd213ps ymm7, ymm10, [c_q8e0]
    vmovups ymm8, [r8+384]
    vpsubd ymm10, ymm5, ymm1
    vmovups ymm5, [r8+416]
M2s_a2f3
    vmovaps [rsi+rdx*4], ymm0
    vmovaps [rdi+rdx*4], ymm0
    vpaddd ymm4, ymm7, ymm6
    vorps ymm1, ymm4, ymm2
    vmovaps [r8+480], ymm3
    vmulps ymm0, ymm8, ymm5
    vmulps ymm7, ymm1, ymm9
    vfmadd213ps ymm10, ymm8, [c_q8e1]
    vmovaps [r8+512], ymm7
    vfmadd213ps ymm10, ymm8, [c_q8e0]
    vfmadd231ps ymm5, ymm0, ymm10
    vmovaps [rsi+rdx*4+32], ymm5
M2s_a2f5
    jbe .zp2
.zp2r:
    cmp rdx, r13
    jae .zp2e
M2s_a29d
.zp2s:
M2s_a2c5
M2s_a2f6
M2s_a2fb
    vorps ymm11, ymm4, ymm5
    vmovaps [r8+192], ymm6
    vmulps ymm8, ymm11, ymm0
    vfmadd231ps ymm2, ymm7, ymm3
    vmovaps [r8+224], ymm8
    vmovaps [rsi+rdx*4], ymm2
M2s_a2fd
    jb .zp2s
.zp2e:
    mov rdi, [rbp + 136]
    mov rax, [rbp + 144]
    imul rax, rax, 2
    add rdi, rax
    mov r11, [rbp + 136]
    mov rax, [rbp + 144]
    imul rax, rax, 3
    add r11, rax
    xor edx, edx
    mov r8, [rbp + 336]
    cmp r13, 16
    jb .zp3r
M2s_a2a5
M2s_a2a0
    vmovups ymm8, [c_q8e0]
    vmovups ymm7, [c_c8]
.zp3:
M2s_a2cb
M2s_a2cc
    vmovaps ymm0, ymm10
    vfmadd231ps ymm0, ymm3, ymm11
    vmovups ymm2, [rbx+rdx*4+32]
    vmovaps [rdi+rdx*4], ymm1
    vminps ymm5, ymm1, [u_zero]
    vfmadd213ps ymm0, ymm3, ymm9
    vminps ymm1, ymm6, ymm5
    vmulps ymm6, ymm3, ymm4
    vminps ymm5, ymm2, [rsi+rdx*4+32]
    vmovaps [r11+rdx*4], ymm1
    vfmadd213ps ymm0, ymm3, ymm8
    vfmadd231ps ymm4, ymm6, ymm0
    vmovaps [rdi+rdx*4+32], ymm4
    vminps ymm2, ymm4, [u_zero]
    vminps ymm1, ymm5, ymm2
    vmovaps [r11+rdx*4+32], ymm1
    add r8, 576
    add rdx, 16
    cmp rdx, r15
    jbe .zp3
.zp3r:
    cmp rdx, r13
    jae .zp3e
M2s_a29e
    vmovups ymm7, [c_c8]
    vmovups ymm6, [c_p8]
    vmovups ymm5, [c_w8e]
.zp3s:
M2s_a2d1
    vmulps ymm2, ymm0, ymm1
    vfmadd231ps ymm1, ymm2, ymm3
    vmovaps [rdi+rdx*4], ymm1
    vminps ymm0, ymm1, [u_zero]
    vminps ymm2, ymm4, ymm0
    vmovaps [r11+rdx*4], ymm2
    add r8, 288
    add rdx, 8
    cmp rdx, r13
    jb .zp3s
.zp3e:
    ret
.t1l:
    vcvtps2pd ymm0, [rdi + 196608]
M2s_a30b
    vdivpd ymm2, ymm3, ymm2
    vmovapd ymm15, [r15 + G_dsn]
    vfmadd213pd ymm15, ymm2, [r15 + G_dan]
    vfmadd213pd ymm15, ymm1, [r15 + G_dta]
    vmovapd ymm13, [r15 + G_dlo]
    vmovapd ymm14, [r15 + G_dhi]
M2s_a30c
    vfmadd231pd ymm2, ymm1, [r15 + G_drg + 0]
M2s_a30d
M2s_a31e
M2s_a326
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vfmadd231pd ymm13, ymm9, [r15 + G_dmx + 0]
    vfmadd231pd ymm14, ymm8, [r15 + G_dmx + 0]
    vcvtps2pd ymm0, [rdi + 65536]
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_drg + 32]
M2s_a30d
M2s_a31e
M2s_a326
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vfmadd231pd ymm13, ymm9, [r15 + G_dmx + 32]
    vfmadd231pd ymm14, ymm8, [r15 + G_dmx + 32]
    vcvtps2pd ymm0, [rdi + 131072]
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_drg + 64]
M2s_a30d
M2s_a31e
M2s_a326
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vfmadd231pd ymm13, ymm9, [r15 + G_dmx + 64]
    vfmadd231pd ymm14, ymm8, [r15 + G_dmx + 64]
M2s_a32d
    ret
.t1c:
    vcvtps2pd ymm0, [rdi + 49152]
M2s_a30b
    vdivpd ymm2, ymm3, ymm2
    vmovapd ymm15, [r15 + G_esn]
    vfmadd213pd ymm15, ymm2, [r15 + G_ean]
    vfmadd213pd ymm15, ymm1, [r15 + G_eta]
M2s_a30c
    vfmadd231pd ymm2, ymm1, [r15 + G_erg + 0]
M2s_a30d
M2s_a31e
M2s_a326
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vmovapd [r12 + 704], ymm9
    vmovapd [r12 + 736], ymm8
    vcvtps2pd ymm0, [rdi + 16384]
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_erg + 32]
M2s_a30d
M2s_a31e
M2s_a326
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vmovapd [r12 + 768], ymm9
    vmovapd [r12 + 800], ymm8
    vcvtps2pd ymm0, [rdi + 32768]
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [r15 + G_erg + 64]
M2s_a30d
M2s_a31e
M2s_a326
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vmovapd [r12 + 832], ymm9
    vmovapd [r12 + 864], ymm8
    vmovapd ymm13, [r15 + G_elo]
    vmovapd ymm2, [r12 + 800]
    vfnmadd231pd ymm13, ymm2, [r15 + G_emx + 64]
    vmovapd ymm2, [r12 + 736]
    vfnmadd231pd ymm13, ymm2, [r15 + G_emx + 32]
    vmovapd ymm2, [r12 + 832]
    vfmadd231pd ymm13, ymm2, [r15 + G_emx + 0]
    vmovapd ymm14, [r15 + G_ehi]
    vmovapd ymm2, [r12 + 768]
    vfnmadd231pd ymm14, ymm2, [r15 + G_emx + 64]
    vmovapd ymm2, [r12 + 704]
    vfnmadd231pd ymm14, ymm2, [r15 + G_emx + 32]
    vmovapd ymm2, [r12 + 864]
    vfmadd231pd ymm14, ymm2, [r15 + G_emx + 0]
M2s_a32d
    vmovapd ymm13, [r15 + G_elo + 32]
    vmovapd ymm2, [r12 + 864]
    vfnmadd231pd ymm13, ymm2, [r15 + G_emx + 160]
    vmovapd ymm2, [r12 + 800]
    vfnmadd231pd ymm13, ymm2, [r15 + G_emx + 128]
    vmovapd ymm2, [r12 + 704]
    vfmadd231pd ymm13, ymm2, [r15 + G_emx + 96]
    vmovapd ymm14, [r15 + G_ehi + 32]
    vmovapd ymm2, [r12 + 832]
    vfnmadd231pd ymm14, ymm2, [r15 + G_emx + 160]
    vmovapd ymm2, [r12 + 768]
    vfnmadd231pd ymm14, ymm2, [r15 + G_emx + 128]
    vmovapd ymm2, [r12 + 736]
    vfmadd231pd ymm14, ymm2, [r15 + G_emx + 96]
M2s_a32c
    vminpd ymm13, ymm13, [u_1023]
    vmovapd ymm1, [u_mone]
    vblendvpd ymm1, ymm1, ymm13, ymm0
    vcvtpd2dq xmm5, ymm1
    vpcmpeqd xmm3, xmm3, xmm3
    vpcmpeqd xmm3, xmm3, xmm5
    vpor xmm4, xmm4, xmm3
    ret
.fz:
    call .t2
    test eax, eax
    jns .fzs
    call .t3
.fzs:
    mov rdi, [rbp + 8]
    mov rcx, [r12 + 1224]
    mov rdx, [r12 + 1232]
    cmp qword [r12 + 1216], 0
    jne .fzc
    imul rcx, [rdi + G_wo]
M2s_a339
M2s_a342
.t2w:
M2s_a34d
M2s_a350
M2s_a355
    cmp rsi, 4
    jb .t2x
    push r14
    call .t2b
    pop r14
    mov qword [r12 + 1288], 0
M2s_a33c
    mov r11, [rdi + G_ho]
.t2x:
    inc r14
    jmp .t2j
.t2n:
    inc qword [r12 + 1296]
    jmp .t2y
.t2f:
    mov rsi, [r12 + 1288]
    test rsi, rsi
    jz .t2e
    vxorpd xmm0, xmm0, xmm0
.t2z:
M2s_a35a
    inc rsi
    cmp rsi, 4
    jb .t2z
    call .t2b
.t2e:
    vcvtsi2sd xmm0, xmm0, qword [r12 + 1280]
    vmovsd xmm1, [u_one]
    vdivsd xmm9, xmm1, xmm0
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r12 + 576], ymm0
    vbroadcastsd ymm1, [u_tab]
    vmovapd [r12 + 608], ymm1
    vmovsd xmm2, [r12 + 544]
    vmulsd xmm2, xmm2, xmm9
    vmovsd [r12 + 576], xmm2
    vandpd xmm3, xmm2, [u_absm]
    vxorpd xmm3, xmm3, [u_mzero]
    vmovsd xmm4, [r12 + 512]
    vfmadd132sd xmm4, xmm3, xmm9
    vmovsd xmm5, [u_tab]
    vfmadd132sd xmm4, xmm5, [u_rg2]
    vmovsd [r12 + 608], xmm4
    vmovsd xmm2, [r12 + 552]
    vmulsd xmm2, xmm2, xmm9
    vmovsd [r12 + 584], xmm2
    vandpd xmm3, xmm2, [u_absm]
    vxorpd xmm3, xmm3, [u_mzero]
    vmovsd xmm4, [r12 + 520]
    vfmadd132sd xmm4, xmm3, xmm9
    vmovsd xmm5, [u_tab]
    vfmadd132sd xmm4, xmm5, [u_rg2]
    vmovsd [r12 + 616], xmm4
    vmovsd xmm2, [r12 + 560]
    vmulsd xmm2, xmm2, xmm9
    vmovsd [r12 + 592], xmm2
    vandpd xmm3, xmm2, [u_absm]
    vxorpd xmm3, xmm3, [u_mzero]
    vmovsd xmm4, [r12 + 528]
    vfmadd132sd xmm4, xmm3, xmm9
    vmovsd xmm5, [u_tab]
    vfmadd132sd xmm4, xmm5, [u_rg2]
    vmovsd [r12 + 624], xmm4
    vmovapd ymm0, [r12 + 576]
    vmovapd ymm15, [r12 + 608]
    lea rax, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [u_rg2]
M2s_a30d
M2s_a31e
M2s_a326
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vmovapd [r12 + 640], ymm9
    vmovapd [r12 + 672], ymm8
    cmp qword [r12 + 1216], 0
    jne .t2h
    vmovsd xmm0, [u_ylo]
    vmovsd xmm1, [u_emc0]
    vfmadd231sd xmm0, xmm1, [r12 + 640]
    vmovsd xmm1, [u_emc1]
    vfmadd231sd xmm0, xmm1, [r12 + 640 + 8]
    vmovsd xmm1, [u_emc2]
    vfmadd231sd xmm0, xmm1, [r12 + 640 + 16]
    vmovsd xmm2, [u_yhi]
    vmovsd xmm1, [u_emc0]
    vfmadd231sd xmm2, xmm1, [r12 + 672]
    vmovsd xmm1, [u_emc1]
    vfmadd231sd xmm2, xmm1, [r12 + 672 + 8]
    vmovsd xmm1, [u_emc2]
M2s_a35e
    ret
.t2h:
    vmovsd xmm0, [u_clo]
    vmovsd xmm1, [u_emc5]
    vfnmadd231sd xmm0, xmm1, [r12 + 672 + 8]
    vmovsd xmm1, [u_emc4]
    vfnmadd231sd xmm0, xmm1, [r12 + 672]
    vmovsd xmm1, [u_emc3]
    vfmadd231sd xmm0, xmm1, [r12 + 640 + 16]
    vmovsd xmm2, [u_chi]
    vmovsd xmm1, [u_emc5]
    vfnmadd231sd xmm2, xmm1, [r12 + 640 + 8]
    vmovsd xmm1, [u_emc4]
    vfnmadd231sd xmm2, xmm1, [r12 + 640]
    vmovsd xmm1, [u_emc3]
M2s_a35e
    mov r8d, eax
    vmovsd xmm0, [u_clo]
    vmovsd xmm1, [u_emc8]
    vfnmadd231sd xmm0, xmm1, [r12 + 672 + 16]
    vmovsd xmm1, [u_emc7]
    vfnmadd231sd xmm0, xmm1, [r12 + 672 + 8]
    vmovsd xmm1, [u_emc6]
    vfmadd231sd xmm0, xmm1, [r12 + 640]
    vmovsd xmm2, [u_chi]
    vmovsd xmm1, [u_emc8]
    vfnmadd231sd xmm2, xmm1, [r12 + 640 + 16]
    vmovsd xmm1, [u_emc7]
    vfnmadd231sd xmm2, xmm1, [r12 + 640 + 8]
    vmovsd xmm1, [u_emc6]
    vfmadd231sd xmm2, xmm1, [r12 + 672]
M2s_a35f
M2s_a360
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
    lea rax, [u_rx]
    vmovapd ymm0, [r12 + 384]
    vmovapd ymm1, [r12 + 416]
    vmovapd ymm2, [r12 + 448]
    vmovapd ymm3, [u_lzm5]
    vfmadd231pd ymm3, ymm0, [u_lzm0]
    vmovapd ymm4, ymm3
    vfmadd231pd ymm4, ymm2, [u_lzm1]
    vmovapd ymm5, ymm3
    vfmadd231pd ymm5, ymm2, [u_lzm2]
    vfmadd231pd ymm5, ymm1, [u_lzm3]
    vfmadd231pd ymm3, ymm1, [u_lzm4]
    vmovapd ymm13, [r12 + 480]
    vandpd ymm6, ymm4, [u_absm]
M2s_a362
M2s_a366
    vmulpd ymm12, ymm10, ymm9
    vmulpd ymm12, ymm12, ymm13
    vandpd ymm14, ymm4, [u_mzero]
M2s_a367
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r12 + 512]
    vmovsd [r12 + 512], xmm12
M2s_a368
    vaddsd xmm14, xmm14, [r12 + 544]
    vmovsd [r12 + 544], xmm14
    vandpd ymm6, ymm5, [u_absm]
M2s_a362
M2s_a366
    vmulpd ymm12, ymm10, ymm9
    vmulpd ymm12, ymm12, ymm13
    vandpd ymm14, ymm5, [u_mzero]
M2s_a367
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r12 + 520]
    vmovsd [r12 + 520], xmm12
M2s_a368
    vaddsd xmm14, xmm14, [r12 + 552]
    vmovsd [r12 + 552], xmm14
    vandpd ymm6, ymm3, [u_absm]
M2s_a362
M2s_a366
    vmulpd ymm12, ymm10, ymm9
    vmulpd ymm12, ymm12, ymm13
    vandpd ymm14, ymm3, [u_mzero]
M2s_a367
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r12 + 528]
    vmovsd [r12 + 528], xmm12
M2s_a368
    vaddsd xmm14, xmm14, [r12 + 560]
    vmovsd [r12 + 560], xmm14
    ret
.t3:
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r12 + 1088], ymm0
    vmovapd [r12 + 1120], ymm0
M2s_a33d
    mov rax, [r12 + 1232]
    xor ebx, ebx
    test rcx, rcx
    jnz .t3c
M2s_a33e
    jmp .t3g
.t3c:
    lea r13, [rax*4 - 1]
    test rax, rax
    jnz .t3d
    xor r13d, r13d
    mov ebx, 1
.t3d:
    lea r14, [rax*4 + 3]
    lea r15, [rdx + rdx]
    lea rsi, [r15 + 2]
.t3g:
M2s_a33f
M2s_a340
    xor edx, edx
    div r11
    mov [r12 + 1296], rax
.t3y:
M2s_a341
    jae .t3f
M2s_a345
M2s_a349
.t3j:
    mov rax, r14
    imul rax, r9
    cmp rax, [r12 + 1248]
    jae .t3n
M2s_a34a
    sub rdx, rcx
    cmp qword [r12 + 1272], 0
    je .t3w
M2s_a34b
.t3w:
M2s_a34d
M2s_a350
M2s_a355
    cmp rsi, 4
    jb .t3x
    push r14
    call .t3b
M2s_a356
    mov r9, [rdi + G_wo]
    add r9, r9
    mov r11, [rdi + G_ho]
.t3x:
    inc r14
    jmp .t3j
.t3n:
    inc qword [r12 + 1296]
    jmp .t3y
.t3f:
    mov rsi, [r12 + 1288]
    test rsi, rsi
    jz .t3e
    vxorpd xmm0, xmm0, xmm0
.t3z:
M2s_a35a
    inc rsi
    cmp rsi, 4
    jb .t3z
    call .t3b
.t3e:
    mov rdi, [rbp + 8]
    cmp qword [r12 + 1216], 0
    jne .t3q
    vbroadcastsd ymm2, [rdi + G_dnl]
    vbroadcastsd ymm3, [rdi + G_dnl + 8]
    jmp .t3r
.t3q:
    vbroadcastsd ymm2, [rdi + G_dnc]
    vbroadcastsd ymm3, [rdi + G_dnc + 8]
.t3r:
    vmovapd ymm0, [r12 + 1088]
    vmovapd ymm1, [r12 + 1120]
    vmulpd ymm4, ymm0, ymm2
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm0, ymm2
    vmulpd ymm6, ymm1, ymm2
    vfmadd231pd ymm6, ymm0, ymm3
M2s_a372
    vmovapd ymm14, ymm6
    vmovapd ymm15, ymm7
    call .xoe
    vmovapd [r12 + 1152], ymm14
    vmovapd [r12 + 1184], ymm15
    cmp qword [r12 + 1216], 0
    jne .t3h
M2s_a373
M2s_a37c
M2s_a383
    vaddsd xmm6, xmm13, xmm11
    vsubsd xmm10, xmm6, xmm13
    vsubsd xmm10, xmm11, xmm10
    vxorpd xmm5, xmm5, xmm5
    vmovsd xmm4, [u_876]
    vmulsd xmm3, xmm4, xmm6
    vmovapd xmm2, xmm3
    vfmsub231sd xmm2, xmm4, xmm6
    vmulsd xmm1, xmm5, xmm6
    vfmadd231sd xmm1, xmm4, xmm10
    vaddsd xmm2, xmm2, xmm1
    vaddsd xmm1, xmm3, xmm2
    vsubsd xmm0, xmm1, xmm3
    vsubsd xmm0, xmm2, xmm0
    vmovsd xmm10, [u_64]
    vaddsd xmm6, xmm1, xmm10
    vsubsd xmm4, xmm6, xmm1
    vsubsd xmm2, xmm6, xmm4
    vsubsd xmm2, xmm1, xmm2
    vsubsd xmm4, xmm10, xmm4
    vaddsd xmm2, xmm2, xmm4
    vaddsd xmm4, xmm0, xmm5
    vsubsd xmm3, xmm4, xmm0
    vsubsd xmm7, xmm4, xmm3
    vsubsd xmm7, xmm0, xmm7
    vsubsd xmm3, xmm5, xmm3
    vaddsd xmm7, xmm7, xmm3
    vaddsd xmm3, xmm2, xmm4
    vaddsd xmm4, xmm6, xmm3
    vsubsd xmm2, xmm4, xmm6
    vsubsd xmm2, xmm3, xmm2
    vaddsd xmm3, xmm2, xmm7
    vaddsd xmm7, xmm4, xmm3
    vsubsd xmm2, xmm7, xmm4
    vsubsd xmm2, xmm3, xmm2
    vroundsd xmm0, xmm7, xmm7, 8
    vsubsd xmm1, xmm7, xmm0
    vxorpd xmm5, xmm5, xmm5
    vaddsd xmm10, xmm1, xmm2
    vsubsd xmm3, xmm10, xmm1
    vsubsd xmm4, xmm10, xmm3
    vsubsd xmm4, xmm1, xmm4
    vsubsd xmm3, xmm2, xmm3
    vaddsd xmm4, xmm4, xmm3
    vaddsd xmm3, xmm5, xmm5
    vsubsd xmm6, xmm3, xmm5
    vsubsd xmm9, xmm3, xmm6
    vsubsd xmm9, xmm5, xmm9
    vsubsd xmm6, xmm5, xmm6
    vaddsd xmm9, xmm9, xmm6
    vaddsd xmm6, xmm4, xmm3
    vaddsd xmm3, xmm10, xmm6
    vsubsd xmm4, xmm3, xmm10
    vsubsd xmm4, xmm6, xmm4
    vaddsd xmm6, xmm4, xmm9
    vaddsd xmm9, xmm3, xmm6
    vcmpsd xmm5, xmm9, [u_half], 0x1e
    vandpd xmm5, xmm5, [u_one]
    vcmpsd xmm1, xmm9, [u_mhalf], 0x11
    vandpd xmm1, xmm1, [u_one]
    vaddsd xmm0, xmm0, xmm5
    vsubsd xmm0, xmm0, xmm1
    vcvttsd2si eax, xmm0
M2s_a38a
    cmp eax, ecx
    cmovg eax, ecx
    ret
.t3h:
M2s_a373
M2s_a37c
M2s_a383
M2s_a38b
M2s_a38f
    vaddsd xmm13, xmm8, xmm9
    vsubsd xmm3, xmm13, xmm8
    vsubsd xmm3, xmm9, xmm3
    vaddsd xmm9, xmm3, xmm15
    vaddsd xmm15, xmm13, xmm9
    vcmpsd xmm6, xmm15, [u_half], 0x1e
    vandpd xmm6, xmm6, [u_one]
    vcmpsd xmm11, xmm15, [u_mhalf], 0x11
    vandpd xmm11, xmm11, [u_one]
    vaddsd xmm7, xmm7, xmm6
    vsubsd xmm7, xmm7, xmm11
    vcvttsd2si eax, xmm7
M2s_a38a
    cmp eax, ecx
    cmovg eax, ecx
    mov [r12 + 1296], eax
    vmovsd xmm0, [r12 + 1280]
    vmovsd xmm1, [r12 + 1288]
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
    vcmpsd xmm4, xmm9, [u_half], 0x1e
    vandpd xmm4, xmm4, [u_one]
    vcmpsd xmm3, xmm9, [u_mhalf], 0x11
    vandpd xmm3, xmm3, [u_one]
    vaddsd xmm2, xmm2, xmm4
    vsubsd xmm2, xmm2, xmm3
    vcvttsd2si eax, xmm2
M2s_a38a
    cmp eax, ecx
    cmovg eax, ecx
    shl eax, 16
    or eax, [r12 + 1296]
    ret
.t3b:
    vxorpd ymm0, ymm0, ymm0
    vmovapd ymm1, [r12 + 384]
    vmovapd ymm2, [r12 + 416]
    vmovapd ymm3, [r12 + 448]
    vbroadcastsd ymm4, [u_ysc]
M2s_a397
M2s_a39b
M2s_a39f
M2s_a3a8
    vsubsd xmm2, xmm0, xmm9
    vsubsd xmm2, xmm1, xmm2
    vaddsd xmm7, xmm4, xmm0
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm5, xmm7, xmm3
    vsubsd xmm5, xmm4, xmm5
    vsubsd xmm3, xmm0, xmm3
M2s_a3bd
M2s_a3be
    vaddsd xmm1, xmm3, xmm6
    vsubsd xmm5, xmm1, xmm3
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [r12 + 920]
    vmovsd xmm0, [r12 + 952]
M2s_a3c1
M2s_a3c2
M2s_a3c3
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm0, xmm3, xmm8
    vsubsd xmm0, xmm2, xmm0
    vmovsd [r12 + 1088], xmm3
    vmovsd [r12 + 1120], xmm0
    vmovsd xmm0, [r12 + 1096]
    vmovsd xmm1, [r12 + 1128]
    vmovsd xmm2, [r12 + 960]
    vmovsd xmm3, [r12 + 992]
M2s_a3a3
M2s_a3ac
M2s_a3b2
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm2, xmm3
    vmovsd xmm9, [r12 + 968]
    vmovsd xmm8, [r12 + 1000]
M2s_a3b5
M2s_a3b6
M2s_a3b7
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [r12 + 976]
    vmovsd xmm5, [r12 + 1008]
M2s_a3b8
M2s_a3bd
M2s_a3be
    vaddsd xmm1, xmm3, xmm6
    vsubsd xmm5, xmm1, xmm3
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [r12 + 984]
    vmovsd xmm0, [r12 + 1016]
M2s_a3c1
M2s_a3c2
M2s_a3c3
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm0, xmm3, xmm8
    vsubsd xmm0, xmm2, xmm0
    vmovsd [r12 + 1096], xmm3
    vmovsd [r12 + 1128], xmm0
    vmovsd xmm0, [r12 + 1104]
    vmovsd xmm1, [r12 + 1136]
    vmovsd xmm2, [r12 + 1024]
    vmovsd xmm3, [r12 + 1056]
M2s_a3a3
M2s_a3ac
M2s_a3b2
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm3, xmm7, xmm4
    vsubsd xmm3, xmm2, xmm3
    vmovsd xmm9, [r12 + 1032]
    vmovsd xmm8, [r12 + 1064]
M2s_a3b5
M2s_a3b6
M2s_a3b7
    vaddsd xmm4, xmm1, xmm9
    vsubsd xmm8, xmm4, xmm1
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm6, [r12 + 1040]
    vmovsd xmm5, [r12 + 1072]
M2s_a3b8
M2s_a3bd
M2s_a3be
    vaddsd xmm1, xmm3, xmm6
    vsubsd xmm5, xmm1, xmm3
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm2, [r12 + 1048]
    vmovsd xmm0, [r12 + 1080]
M2s_a3c1
M2s_a3c2
M2s_a3c3
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm0, xmm3, xmm8
    vsubsd xmm0, xmm2, xmm0
    vmovsd [r12 + 1104], xmm3
    vmovsd [r12 + 1136], xmm0
    ret
    .dexp:
    vxorpd ymm0, ymm0, ymm0
    vdivpd ymm1, ymm14, [u_ln2]
    vroundpd ymm2, ymm1, 8
    vbroadcastsd ymm1, [u_ln2d]
    vbroadcastsd ymm3, [u_ln2d + 8]
    vmulpd ymm4, ymm1, ymm2
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm1, ymm2
    vmulpd ymm6, ymm3, ymm2
    vfmadd231pd ymm6, ymm1, ymm0
M2s_a372
    vmovapd [r12 + 96], ymm2
    vxorpd ymm2, ymm6, [u_mzero]
    vxorpd ymm3, ymm7, [u_mzero]
    vaddpd ymm7, ymm14, ymm2
    vsubpd ymm6, ymm7, ymm14
    vsubpd ymm1, ymm7, ymm6
    vsubpd ymm1, ymm14, ymm1
    vsubpd ymm6, ymm2, ymm6
    vaddpd ymm1, ymm1, ymm6
    vaddpd ymm6, ymm15, ymm3
M2s_a3d4
M2s_a3d8
M2s_a3dc
M2s_a3e0
    vsubpd ymm2, ymm8, ymm2
    vaddpd ymm8, ymm2, ymm3
    vaddpd ymm3, ymm1, ymm8
    vsubpd ymm2, ymm3, ymm1
    vsubpd ymm2, ymm8, ymm2
    vmovapd ymm14, ymm3
    vmovapd ymm15, ymm2
    ret
    .xeo:
M2s_a3e8
    vblendvpd ymm14, ymm14, ymm11, ymm12
    vandnpd ymm15, ymm12, ymm15
    call .dln
    vbroadcastsd ymm0, [u_e125]
    vbroadcastsd ymm1, [u_e125 + 8]
M2s_a3e9
    vxorpd ymm15, ymm15, [r12 + 320]
    ret
    .xoe:
M2s_a3e8
    vblendvpd ymm14, ymm14, ymm11, ymm12
    vandnpd ymm15, ymm12, ymm15
    call .dln
    vbroadcastsd ymm0, [u_e512]
    vbroadcastsd ymm1, [u_e512 + 8]
M2s_a3e9
M2s_a3ee