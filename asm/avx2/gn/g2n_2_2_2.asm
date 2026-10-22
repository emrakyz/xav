%include "g2nm.inc"
default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
M2s_a0
M2s_a1
align 8
xav_g2_2_2_2_pft: dq xav_g2_2_2_2.pf1, xav_g2_2_2_2.pf2, xav_g2_2_2_2.pf3, xav_g2_2_2_2.pf4, xav_g2_2_2_2.pf5, xav_g2_2_2_2.pf6, xav_g2_2_2_2.pf7, xav_g2_2_2_2.pf8, xav_g2_2_2_2.pf9, xav_g2_2_2_2.pf10, xav_g2_2_2_2.pf11, xav_g2_2_2_2.pf12, xav_g2_2_2_2.pf13, xav_g2_2_2_2.pf14, xav_g2_2_2_2.pf15, xav_g2_2_2_2.pf16, xav_g2_2_2_2.pf17, xav_g2_2_2_2.pf18, xav_g2_2_2_2.pf19, xav_g2_2_2_2.pf20, xav_g2_2_2_2.pf21, xav_g2_2_2_2.pf22, xav_g2_2_2_2.pf23, xav_g2_2_2_2.pf24, xav_g2_2_2_2.pf25, xav_g2_2_2_2.pf26, xav_g2_2_2_2.pf27, xav_g2_2_2_2.pf28, xav_g2_2_2_2.pf29, xav_g2_2_2_2.pf30, xav_g2_2_2_2.pf31, xav_g2_2_2_2.pf32
M2s_a2
M2s_a3
M2s_a4
section .text
global xav_g2_2_2_2
align 64
xav_g2_2_2_2:
M2s_a5
M2s_a6
    mov ecx, 32
    cmp rax, rcx
    cmova rax, rcx
    lea rcx, [xav_g2_2_2_2_pft]
M2s_a7
M2s_a9
M2s_ab
M2s_af
M2s_a14
M2s_a15
M2s_a937
    vpermps ymm0, ymm8, [r8 + 0]
M2s_a975
    vfmadd231ps ymm5, ymm0, ymm10
M2s_a977
M2s_a93a
M2s_a14b
M2s_a83b
M2s_a976
    vfmadd231ps ymm7, ymm0, ymm10
    vaddps ymm0, ymm4, ymm5
M2s_a93c
    vfmadd213ps ymm1, ymm14, ymm13
M2s_a93e
M2s_a944
    vmovaps [r9+416], ymm4
M2s_a941
M2s_a182
    vmovups ymm12, [c_eq]
M2s_a184
M2s_a946
M2s_a186
M2s_a94a
M2s_a194
M2s_a946
M2s_a196
M2s_a94f
M2s_a953
M2s_a95b
M2s_a95e
M2s_a963
M2s_a1b5
M2s_a966
M2s_a1ea
.ed:
M2s_a96a
M2s_a152
M2s_a1f7
M2s_a93d
M2s_a96b
M2s_a173
M2s_a175
M2s_a947
M2s_a203
M2s_a949
M2s_a20a
M2s_a206
M2s_a96c
M2s_a94d
M2s_a211
M2s_a20f
M2s_a96d
M2s_a1ac
M2s_a1ae
    vmovups ymm7, [rax+192]
M2s_a952
M2s_a956
M2s_a53a
M2s_a1bf
    vorps ymm6, ymm9, ymm3
M2s_a96e
    vandps ymm9, ymm10, [r9+64]
M2s_a95d
M2s_a960
M2s_a970
M2s_a1a2
M2s_a1db
    vandps ymm9, ymm10, [r9+160]
M2s_a964
M2s_a967
M2s_a972
M2s_a223
M2s_a973
M2s_a1ef
M2s_a230
M2s_a974
M2s_a23d
M2s_a243
M2s_a24b
M2s_a252
M2s_a25a
M2s_a263
M2s_a26c
M2s_a27b
M2s_a28f
M2s_a282
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
