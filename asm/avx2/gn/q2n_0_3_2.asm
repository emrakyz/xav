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
global xav_q2_0_3_2
align 64
xav_q2_0_3_2:
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
    cmp dword [r15 + Pc_sg], 17076809
    jne .bg0
M2p_a252
M2p_a31
M2p_a923
    vaddps ymm6, ymm6, [r8 + 448]
    vaddps ymm7, ymm7, [r8 + 480]
    vbroadcastss ymm12, [r15 + Pc_w + 12]
    vbroadcastss ymm13, [r15 + Pc_w + 12 + 4]
    vmovups ymm15, [r8 + 576]
M2p_a944
    vmovups ymm15, [r8 + 608]
M2p_a945
    vmovups ymm15, [r8 + 640]
M2p_a946
    vmovups ymm15, [r8 + 672]
M2p_a947
    vaddps ymm8, ymm8, [r8 + 768]
    vaddps ymm9, ymm9, [r8 + 800]
    vaddps ymm10, ymm10, [r8 + 832]
    vaddps ymm11, ymm11, [r8 + 864]
    vbroadcastss ymm12, [r15 + Pc_w + 24]
    vbroadcastss ymm13, [r15 + Pc_w + 24 + 4]
    vmovups ymm15, [r8 + 960]
M2p_a260
    vmulps ymm0, ymm15, ymm13
    vmovups ymm15, [r8 + 992]
M2p_a262
    vmulps ymm1, ymm15, ymm13
    vmovups ymm15, [r8 + 1024]
M2p_a264
    vmulps ymm2, ymm15, ymm13
    vmovups ymm15, [r8 + 1056]
M2p_a267
M2p_a949
    vaddps ymm3, ymm3, [r8 + 1248]
M2p_a36
M2p_a38
    jmp .be3
.bg0:
    cmp dword [r15 + Pc_sg], 136614473
    jne .bg1
M2p_a922
M2p_a924
M2p_a943
    vaddps ymm4, ymm8, [rbx + 0]
    vaddps ymm4, ymm4, [r9]
    vmovups [r13], ymm4
M2p_a948
    vaddps ymm7, ymm7, [r9 + r11]
    vmovups [r13 + r11], ymm7
M2p_a949
    vaddps ymm3, ymm3, [r8 + 1248]
    vbroadcastss ymm12, [r15 + Pc_w + 36]
    vbroadcastss ymm13, [r15 + Pc_w + 36 + 4]
    vmovups ymm15, [r8 + 1344]
M2p_a26c
    vmulps ymm4, ymm15, ymm13
    vmovups [rbx + 128], ymm4
    vmovups ymm15, [r8 + 1376]
M2p_a26f
    vmulps ymm5, ymm15, ymm13
    vmovups [rbx + 160], ymm5
    vmovups ymm15, [r8 + 1408]
M2p_a274
    vmulps ymm6, ymm15, ymm13
    vmovups [rbx + 192], ymm6
    vmovups ymm15, [r8 + 1440]
M2p_a276
    vmulps ymm7, ymm15, ymm13
    vmovups [rbx + 224], ymm7
    jmp .be3
.bg1:
M2p_a30
M2p_a34
M2p_a3a
M2p_a48
M2p_a50
M2p_a927
M2p_a916
    vmovups ymm6, [rcx + 128]
    vmovups ymm7, [rcx + 160]
M2p_a5d
M2p_a5e
M2p_a5f
M2p_a92a
M2p_a94a
    vfmadd231ps ymm4, ymm0, ymm12
M2p_a92f
M2p_a94d
    vfmadd231ps ymm5, ymm0, ymm7
M2p_af5
    vpermpd ymm0, ymm0, 0xd8
    vmovups [r10 + 0], ymm0
M2p_a93e
    vpermps ymm0, ymm8, [r9 + 8]
    vpermps ymm1, ymm8, [r9 + 40]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm12
M2p_a934
M2p_a94d
M2p_a94f
    vaddps ymm0, ymm4, ymm5
M2p_a936
    vblendvps ymm0, ymm0, ymm1, ymm8
M2p_a957
    vfmadd231ps ymm4, ymm0, ymm12
M2p_a93b
M2p_a94d
M2p_a94f
M2p_a1e4
M2p_a92c
M2p_a94b
M2p_a94f
M2p_a91f
M2p_a931
    vpermps ymm1, ymm8, [r9 + 36]
    vblendvps ymm0, ymm0, ymm1, ymm8
    vfmadd231ps ymm4, ymm0, ymm11
M2p_a953
M2p_a94f
M2p_a920
M2p_a939
    vpermps ymm1, ymm8, [r15 + 36]
M2p_a956
M2p_a94e
M2p_a1df
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
