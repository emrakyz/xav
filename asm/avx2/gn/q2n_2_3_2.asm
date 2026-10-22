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
global xav_q2_2_3_2
align 64
xav_q2_2_3_2:
M2p_a6
M2p_a8
M2p_aa
M2p_ab
M2p_ac
M2p_a20
M2p_a2c
M2p_a22
M2p_a18
M2p_a13
M2p_a23
M2p_a2b
M2p_a2d
M2p_a2f
    lea r13, [r9 + r10*8]
    cmp dword [r15 + Pc_sg], 153125384
M2p_a942
    vmovups ymm3, [rbx + 224]
    vbroadcastss ymm12, [r15 + Pc_w + 0]
    vbroadcastss ymm13, [r15 + Pc_w + 0 + 4]
    vmovups ymm15, [r8 + 0]
    vfmadd231ps ymm0, ymm15, ymm12
    vmulps ymm4, ymm15, ymm13
    vmovups ymm15, [r8 + 32]
    vfmadd231ps ymm1, ymm15, ymm12
    vmulps ymm5, ymm15, ymm13
    vmovups ymm15, [r8 + 64]
    vfmadd231ps ymm2, ymm15, ymm12
    vmulps ymm6, ymm15, ymm13
    vmovups ymm15, [r8 + 96]
    vfmadd231ps ymm3, ymm15, ymm12
M2p_aac6
M2p_a262
M2p_aac9
M2p_a267
    vmulps ymm3, ymm15, ymm13
    vbroadcastss ymm12, [r15 + Pc_w + 36]
    vbroadcastss ymm13, [r15 + Pc_w + 36 + 4]
    vmovups ymm15, [r8 + 576]
M2p_a26c
    vmulps ymm4, ymm15, ymm13
    vmovups [rbx + 128], ymm4
    vmovups ymm15, [r8 + 608]
M2p_a26f
    vmulps ymm5, ymm15, ymm13
    vmovups [rbx + 160], ymm5
    vmovups ymm15, [r8 + 640]
M2p_a274
    vmulps ymm6, ymm15, ymm13
    vmovups [rbx + 192], ymm6
    vmovups ymm15, [r8 + 672]
M2p_a276
    vmulps ymm7, ymm15, ymm13
    vmovups [rbx + 224], ymm7
    jmp .be3
.bg0:
    cmp dword [r15 + Pc_sg], 16810504
    jne .bg1
M2p_a252
M2p_aad2
M2p_a947
M2p_aac8
M2p_a37
    vmovups [r12 + r11], ymm11
    vmovups [rbx + 96], ymm3
    jmp .be3
.bg1:
    cmp dword [r15 + Pc_sg], 136348168
    jne .bg2
M2p_aac5
M2p_a947
M2p_aac7
    vaddps ymm6, ymm10, [rbx + 64]
    vaddps ymm6, ymm6, [r9 + r10*2]
    vmovups [r13 + r10*2], ymm6
M2p_aaca
    vaddps ymm7, ymm7, [r9 + r11]
    vmovups [r13 + r11], ymm7
M2p_aad3
.bg2:
M2p_a30
M2p_a34
M2p_a3a
M2p_a48
M2p_a50
M2p_a928
M2p_a58
M2p_a5b
M2p_aabb
    vmovups ymm12, [rcx + 96]
    vmovups ymm13, [rcx + 128]
    vmovups ymm6, [rcx + 160]
M2p_a5d
M2p_a5e
M2p_a5f
M2p_a92b
M2p_aacd
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm11
    vfmadd231ps ymm5, ymm0, ymm12
M2p_aad4
    vfmadd231ps ymm5, ymm0, ymm6
    vaddps ymm0, ymm4, ymm5
M2p_a952
M2p_aacf
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm11
    vfmadd231ps ymm5, ymm0, ymm12
    vpermps ymm0, ymm8, [r9 + 8]
    vpermps ymm1, ymm8, [r9 + 40]
M2p_aad5
M2p_a937
M2p_aad1
M2p_aad7
M2p_a1e5
M2p_a1e7
M2p_a9bf
M2p_aacc
M2p_aad4
    vfmadd231ps ymm5, ymm0, ymm6
    vaddps ymm0, ymm4, ymm5
M2p_a93d
M2p_aacf
M2p_aad6
    vaddps ymm0, ymm4, ymm5
M2p_a941
M2p_aad1
M2p_aad7
M2p_a1e6
M2p_a1f4
M2p_a1fd
M2p_a205
M2p_a214
M2p_a21e
M2p_a228
M2p_a22d
M2p_a231
M2p_a209
M2p_a20d
M2p_a471
M2p_a218
M2p_a221
M2p_a52d
M2p_a236
M2p_a23a
M2p_a574
M2p_a69e
M2p_a241
M2p_a245
M2p_a24a
M2p_a24f
M2p_a254
M2p_a25b
M2p_a268
M2p_a271
M2p_af
M2p_a27b
M2p_a281
M2p_a1b
M2p_a288
M2p_a75c
M2p_a29b
M2p_a297
M2p_a2a5
M2p_a2a9
M2p_a2af
M2p_a2b5
M2p_a2c2
M2p_a2cf
M2p_a2de
M2p_a2e5
M2p_a2ee
M2p_a2f5
M2p_a306
M2p_a2f8
M2p_a30d
M2p_a311
M2p_a319
M2p_a2fc
M2p_a307
M2p_a313
M2p_a31f
M2p_a2bf
M2p_a321
M2p_a323
M2p_a327
M2p_a32d
M2p_a331
M2p_a336
M2p_a33a
M2p_a33e
M2p_a342
M2p_a346
M2p_a34b
M2p_a34f
M2p_a361
M2p_a36c
M2p_a358
M2p_a362
M2p_a373
M2p_a375
M2p_a35b
M2p_a37b
M2p_a37d
M2p_a2c3
M2p_a381
M2p_a2d2
M2p_a475
M2p_a387
M2p_a38c
M2p_a391
M2p_a396
M2p_a39b
M2p_a3a0
M2p_a3a9
M2p_a3b0
M2p_a3b6
M2p_a3bd
M2p_a3c4
M2p_a3ca
M2p_a3d0
M2p_a3d7
M2p_a3dd
M2p_a3e3
M2p_a3e7
section .note.GNU-stack noalloc noexec nowrite progbits
