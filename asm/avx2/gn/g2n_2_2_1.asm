%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_2_2_1_pft: dq xav_g2_2_2_1.pf1, xav_g2_2_2_1.pf2, xav_g2_2_2_1.pf3, xav_g2_2_2_1.pf4, xav_g2_2_2_1.pf5, xav_g2_2_2_1.pf6, xav_g2_2_2_1.pf7, xav_g2_2_2_1.pf8, xav_g2_2_2_1.pf9, xav_g2_2_2_1.pf10, xav_g2_2_2_1.pf11, xav_g2_2_2_1.pf12, xav_g2_2_2_1.pf13, xav_g2_2_2_1.pf14, xav_g2_2_2_1.pf15, xav_g2_2_2_1.pf16, xav_g2_2_2_1.pf17, xav_g2_2_2_1.pf18, xav_g2_2_2_1.pf19, xav_g2_2_2_1.pf20, xav_g2_2_2_1.pf21, xav_g2_2_2_1.pf22, xav_g2_2_2_1.pf23, xav_g2_2_2_1.pf24, xav_g2_2_2_1.pf25, xav_g2_2_2_1.pf26, xav_g2_2_2_1.pf27, xav_g2_2_2_1.pf28, xav_g2_2_2_1.pf29, xav_g2_2_2_1.pf30, xav_g2_2_2_1.pf31, xav_g2_2_2_1.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_2_2_1
align 64
xav_g2_2_2_1:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_2_2_1_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a14
M2s_a15
M2s_a936
    vmovups ymm10, [rcx + 96]
M2s_a16
M2s_a17
M2s_a828
M2s_a938
M2s_a939
    vmovups [r10 + 0], ymm0
    vaddps ymm0, ymm6, ymm7
    vmovups [r11 + 0], ymm0
    vaddps ymm4, ymm4, ymm6
    vaddps ymm5, ymm5, ymm7
M2s_a146
M2s_a14b
    vmovaps ymm15, ymm4
    vpermps ymm0, ymm8, [r8 + 0]
M2s_a938
M2s_a939
    vmovups [r10 + 128], ymm0
    vaddps ymm0, ymm6, ymm7
    vmovups [r11 + 128], ymm0
    vaddps ymm4, ymm4, ymm6
    vaddps ymm5, ymm5, ymm7
M2s_a14a
M2s_a14f
M2s_a151
M2s_a153
M2s_a93d
M2s_a159
    vmovups ymm1, [rdx]
    vmovups ymm2, [rax+128]
    vmovups ymm3, [rdx+32]
M2s_a160
M2s_a165
    vmovaps [r9+32], ymm5
    vmovaps [r9+320], ymm4
    add rax, 256
    add rdx, 64
M2s_a16b
M2s_a15c
    vmovups ymm10, [c_ieq]
.i1l0s:
    vmovups ymm0, [rax]
    vmovups ymm1, [rdx]
M2s_a172
M2s_a174
    vmovaps [r9+32], ymm9
    add rax, 128
    add rdx, 32
M2s_a178
.i1l1:
    vmovups ymm0, [rax+32]
    vmovups ymm1, [rdx]
    vmovups ymm2, [rax+160]
M2s_a940
M2s_a17b
M2s_a452
M2s_a942
M2s_a183
M2s_a184
M2s_a946
M2s_a186
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+128], ymm9
M2s_a947
M2s_a187
    vmovups ymm1, [rdx]
    vmovups ymm2, [rax+192]
M2s_a940
M2s_a18a
    vfmadd213ps ymm4, ymm12, ymm11
    vmovaps [r9+224], ymm5
    vmovaps [r9+512], ymm4
M2s_a941
M2s_a193
    vmovups ymm12, [c_eq]
M2s_a194
M2s_a946
M2s_a196
    vfmadd213ps ymm9, ymm12, ymm11
    vmovaps [r9+224], ymm9
M2s_a947
    jnz .i1l2s
.i1l2e:
    mov rax, rsi
    mov r9, r10
    mov rcx, [rbp + 240]
M2s_a197
M2s_a1a9
M2s_a1af
    vandps ymm9, ymm10, [r9+256]
    vpsubd ymm6, ymm4, ymm0
    vmovaps [r9+192], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
    vfmadd213ps ymm5, ymm6, ymm14
    vmovaps [r9+224], ymm11
M2s_a1b3
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+512]
M2s_a956
    add r9, 576
    sub rcx, 2
M2s_a1ba
M2s_a1c2
M2s_a959
    add r9, 288
    dec rcx
    jnz .i2l2s
.i2l2e:
M2s_a951
M2s_a1c6
M2s_a1aa
M2s_a1cc
    vpsubd ymm6, ymm4, ymm0
    vmovaps [r9], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
    vfmadd213ps ymm5, ymm6, ymm14
    vmovaps [r9+32], ymm11
M2s_a1b3
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+320]
    vandps ymm6, ymm3, [r9+352]
    vmovaps [r9+288], ymm6
    vmovaps [r9+320], ymm8
M2s_a958
M2s_a1d3
M2s_a1c3
M2s_a961
    dec rcx
    jnz .i2l0s
.i2l0e:
M2s_a951
M2s_a1d7
M2s_a1aa
M2s_a1dc
    vpsubd ymm6, ymm4, ymm0
    vmovaps [r9+96], ymm9
    vblendvps ymm10, ymm1, ymm3, ymm8
    vfmadd213ps ymm5, ymm6, ymm14
    vmovaps [r9+128], ymm11
M2s_a1b3
    vorps ymm3, ymm1, ymm4
    vmulps ymm8, ymm4, [r9+416]
    vandps ymm6, ymm3, [r9+448]
    vmovaps [r9+384], ymm6
    vmovaps [r9+416], ymm8
M2s_a958
M2s_a1e3
M2s_a1c3
M2s_a968
    dec rcx
M2s_a1e7
    vmovaps ymm14, [rdi + G_lmx + 32]
    vmovaps ymm15, [rdi + G_lmx + 64]
    vmovaps ymm12, [rdi + G_lsl]
    mov r8, [rdi + G_sg]
M2s_a1e8
M2s_a1ed
    vmulps ymm0, ymm15, [r8 + 192]
    vfmadd231ps ymm0, ymm13, [r8]
    vfmadd231ps ymm0, ymm14, [r8 + 96]
    vmovaps ymm1, ymm12
    vfmadd231ps ymm1, ymm15, [r8 + 224]
    vfmadd231ps ymm1, ymm13, [r8 + 32]
    vfmadd231ps ymm1, ymm14, [r8 + 128]
M2s_a1ee
    add r8, 288
M2s_a1f3
M2s_a1f7
M2s_a93d
    dec rcx
M2s_a1f8
M2s_a1fb
    vmovups ymm10, [c_ieq]
.i1c0:
    vmovups ymm0, [rax]
M2s_a93f
M2s_a1fe
M2s_a1fc
.i1c0s:
M2s_a945
    add rdx, 32
M2s_a202
.i1c1:
M2s_a948
M2s_a207
M2s_a205
    vmovups ymm10, [c_ieq]
.i1c1s:
    vmovups ymm0, [rax+32]
M2s_a946
M2s_a186
M2s_a94b
M2s_a20d
.i1c2:
    vmovups ymm0, [rax+64]
M2s_a94c
M2s_a211
M2s_a20f
.i1c2s:
    vmovups ymm0, [rax+64]
M2s_a946
M2s_a196
M2s_a950
M2s_a215
M2s_a951
M2s_a216
M2s_a1aa
M2s_a1b0
M2s_a954
M2s_a957
M2s_a455
M2s_a1c0
    vmulps ymm4, ymm3, [r9+224]
M2s_a959
    add r9, 288
    dec rcx
    jnz .i2c2s
.i2c2e:
M2s_a951
M2s_a219
M2s_a1aa
M2s_a1cc
M2s_a95d
M2s_a960
    sub rcx, 2
M2s_a21a
M2s_a1c1
    vfmadd213ps ymm0, ymm1, [c_q8o0]
M2s_a961
    dec rcx
    jnz .i2c0s
.i2c0e:
M2s_a951
M2s_a21d
M2s_a1aa
M2s_a1dc
M2s_a964
M2s_a967
    sub rcx, 2
M2s_a21e
M2s_a1c1
    vfmadd213ps ymm0, ymm1, [c_q8o0]
M2s_a968
    dec rcx
    jnz .i2c1s
.i2c1e:
    mov rdi, [rbp + 8]
    mov r8, [rdi + G_sg]
M2s_a222
M2s_a225
    vmulps ymm0, ymm5, [r8]
    vmovaps ymm6, [rdi + G_cmx + 64]
    vfmadd231ps ymm0, ymm6, [r8 + 96]
    vmovaps ymm8, [rdi + G_cmx + 0]
    vmovaps ymm7, ymm8
    vfmsub132ps ymm7, ymm0, [r8 + 192]
    vmovaps ymm1, [rdi + G_csb]
    vfmadd231ps ymm1, ymm5, [r8 + 32]
    vfmadd231ps ymm1, ymm6, [r8 + 128]
    vfmadd231ps ymm1, ymm8, [r8 + 224]
M2s_a22a
    vpmaxsd ymm9, ymm9, ymm15
    vmovaps ymm5, [rdi + G_cmx + 160]
    vmulps ymm0, ymm5, [r8 + 192]
    vmovaps ymm6, [rdi + G_cmx + 128]
    vfmadd231ps ymm0, ymm6, [r8 + 96]
M2s_a22b
    vfmadd231ps ymm1, ymm5, [r8 + 224]
    vfmadd231ps ymm1, ymm6, [r8 + 128]
M2s_a22c
M2s_a22e
    cmovb rcx, r10
    bzhi eax, eax, ecx
    mov [r11], al
    add r8, 288
M2s_a232
M2s_a23e
M2s_a244
M2s_a24c
M2s_a253
M2s_a25c
M2s_a264
M2s_a26e
M2s_a27c
M2s_a290
M2s_a53f
M2s_a299
M2s_a2a9
M2s_a29d
M2s_a2b7
M2s_a2aa
M2s_a2b1
M2s_a45b
M2s_a2bb
M2s_a5b7
M2s_a2ce
M2s_a2d3
M2s_a2c3
M2s_a45f
M2s_a2dd
M2s_a2e1
M2s_a2e3
M2s_a287
M2s_a2e6
M2s_a2e9
M2s_a2eb
M2s_a2f1
M2s_a5c6
M2s_a5e9
M2s_a2f8
M2s_a2fb
M2s_a302
M2s_a307
M2s_a315
M2s_a319
M2s_a322
M2s_a329
M2s_a32f
M2s_a333
M2s_a30f
M2s_a323
M2s_a337
M2s_a33a
M2s_a343
M2s_a34e
M2s_a358
M2s_a314
M2s_a327
M2s_a35c
M2s_a462
M2s_a364
M2s_a36a
M2s_a36d
M2s_a347
M2s_a4f4
M2s_a352
M2s_a371
M2s_a377
M2s_a382
M2s_a389
M2s_a37b
M2s_a37e
M2s_a385
M2s_a38d
M2s_a391
M2s_a395
M2s_a399
M2s_a39d
M2s_a3a1
M2s_a3aa
M2s_a3bb
M2s_a3a6
M2s_a3af
M2s_a3c5
M2s_a3c0
M2s_a3cb
M2s_a3b3
M2s_a3cd
M2s_a3c0
M2s_a3d3
M2s_a3d7
M2s_a3db
M2s_a3df
M2s_a3e3
M2s_a3e7
M2s_a3ed
    ret
section .note.GNU-stack noalloc noexec nowrite progbits
