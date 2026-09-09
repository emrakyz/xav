%include "dav1d_x86inc.asm"

SECTION_RODATA 64
ALIGN 64
c64:    times 32 dw 64
ones16: times 32 dw 1

SECTION .text
INIT_ZMM avx512
%if WIN64
WIN64_MMMAP 6, 16, 15
%endif
cglobal crop_frame_u16, 5, 15, 16, p, w, h, stride, best, hh, mask, magic, s3, cur, cnt, t, k, lim, step
    mov       hhq, hq
    lea       s3q, [strideq + strideq*2]
    lea       stepq, [strideq*8]
    vmovdqa64 zmm0, [rel c64]
    lea       tq, [hhq + hhq*2]
    sub       tq, wq
    jbe       .cols
    add       tq, 5
    imul      tq, tq, 43691
    shr       tq, 18
    inc       tq
    mov       kq, 8
    cmp       tq, kq
    cmovb     tq, kq
    cmp       tq, hhq
    cmova     tq, hhq
    mov       limq, tq
    mov       rax, 0x10000000000
    add       rax, wq
    dec       rax
    xor       edx, edx
    div       wq
    mov       magicq, rax
    mov       tq, wq
    and       tq, 31
    mov       kq, -1
    bzhi      kd, kd, td
    kmovd     k1, kd
    vmovdqa64 zmm1, [rel ones16]
    mov       curq, pq
    xor       cntq, cntq
.tl:
    lea       tq, [cntq + 8]
    cmp       tq, limq
    ja        .tp
    call      .rowgrp
    test      eax, eax
    jnz       .th
    add       curq, stepq
    add       cntq, 8
    jmp       .tl
.th:
    lzcnt     eax, eax
    lea       cntq, [cntq + rax - 24]
    jmp       .ht
.tp:
    cmp       cntq, limq
    jae       .none
    mov       curq, limq
    sub       curq, 8
    imul      curq, strideq
    add       curq, pq
    mov       tq, limq
    sub       tq, cntq
    mov       cntq, 1
    shlx      cntq, cntq, tq
    dec       cntq
    call      .rowgrp
    and       eax, cntd
    jz        .none
    lzcnt     eax, eax
    lea       cntq, [limq + rax - 32]
.ht:
    test      cntq, cntq
    jz        .cols
    vmovd     xmm30, cntd
    mov       curq, hhq
    sub       curq, 8
    imul      curq, strideq
    add       curq, pq
    xor       cntq, cntq
.bl:
    lea       tq, [cntq + 8]
    cmp       tq, limq
    ja        .bp
    call      .rowgrp
    test      eax, eax
    jnz       .bh
    sub       curq, stepq
    add       cntq, 8
    jmp       .bl
.bh:
    tzcnt     eax, eax
    add       cntq, rax
    jmp       .hb
.bp:
    cmp       cntq, limq
    jae       .none
    mov       curq, hhq
    sub       curq, limq
    imul      curq, strideq
    add       curq, pq
    mov       tq, 8
    add       tq, cntq
    sub       tq, limq
    mov       cntq, 255
    shlx      cntq, cntq, tq
    and       cntd, 255
    call      .rowgrp
    and       eax, cntd
    jz        .none
    tzcnt     eax, eax
    lea       cntq, [limq + rax - 8]
.hb:
    vmovd     xmm26, cntd
    vpunpckldq xmm26, xmm30, xmm26
    vpxor     xmm27, xmm27, xmm27
    vpunpcklqdq xmm26, xmm26, xmm27
    jmp       .store
.cols:
    lea       tq, [wq + wq*4]
    lea       kq, [hhq + hhq*2]
    add       kq, kq
    sub       tq, kq
    jbe       .zero
    add       tq, 9
    imul      tq, tq, 26215
    shr       tq, 18
    inc       tq
    mov       kq, 64
    cmp       tq, kq
    cmovb     tq, kq
    cmp       tq, wq
    cmova     tq, wq
    mov       limq, tq
    mov       curq, pq
    xor       cntq, cntq
.pl:
    lea       tq, [cntq + 64]
    cmp       tq, limq
    ja        .pp
    mov       stepq, wq
    sub       stepq, 64
    sub       stepq, cntq
    sub       stepq, cntq
    add       stepq, stepq
    call      .colpair
    tzcnt     rax, rax
    lzcnt     kq, kq
    cmp       rax, kq
    cmova     rax, kq
    cmp       rax, 64
    jb        .ph
    add       curq, 128
    add       cntq, 64
    jmp       .pl
.ph:
    add       cntq, rax
    jmp       .hp
.pp:
    cmp       cntq, limq
    jae       .none
    lea       curq, [pq + limq*2 - 128]
    mov       stepq, wq
    add       stepq, 64
    sub       stepq, limq
    sub       stepq, limq
    add       stepq, stepq
    lea       tq, [cntq + 64]
    sub       tq, limq
    mov       cntq, tq
    call      .colpair
    mov       tq, -1
    shlx      tq, tq, cntq
    and       rax, tq
    mov       tq, -1
    shrx      tq, tq, cntq
    and       kq, tq
    tzcnt     rax, rax
    lzcnt     kq, kq
    cmp       rax, kq
    cmova     rax, kq
    cmp       rax, 64
    jae       .none
    lea       cntq, [limq + rax - 64]
.hp:
    mov       td, 12
    kmovb     k7, td
    vpbroadcastd xmm26 {k7}{z}, cntd
    jmp       .store
.zero:
    vpxor     xmm26, xmm26, xmm26
.store:
    mov       td, 2
    vpbroadcastd xmm28, td
    vmovdqu   xmm27, [bestq]
    vpminud   xmm26, xmm26, xmm27
    vmovdqu   [bestq], xmm26
    vpcmpud   k1, xmm26, xmm28, 1
    kmovb     eax, k1
    cmp       al, 15
    sete      al
    movzx     eax, al
    RET
.none:
    xor       eax, eax
    RET

.rowgrp:
    vpxor     xmm2, xmm2, xmm2
    vpxor     xmm3, xmm3, xmm3
    vpxor     xmm4, xmm4, xmm4
    vpxor     xmm5, xmm5, xmm5
    vpxor     xmm6, xmm6, xmm6
    vpxor     xmm7, xmm7, xmm7
    vpxor     xmm8, xmm8, xmm8
    vpxor     xmm9, xmm9, xmm9
    vpxor     xmm10, xmm10, xmm10
    vpxor     xmm11, xmm11, xmm11
    vpxor     xmm12, xmm12, xmm12
    vpxor     xmm13, xmm13, xmm13
    vpxor     xmm14, xmm14, xmm14
    vpxor     xmm15, xmm15, xmm15
    vpxor     xmm26, xmm26, xmm26
    vpxor     xmm27, xmm27, xmm27
    mov       tq, curq
    lea       kq, [curq + strideq*4]
    mov       hd, wd
    shr       hq, 5
    jz        .rg_tail
.rg_loop:
    vpmaxuw   zmm29, zmm0, [tq]
    vpdpwssd  zmm2, zmm29, zmm1
    vpmaxuw   zmm10, zmm10, zmm29
    vpmaxuw   zmm29, zmm0, [tq + strideq]
    vpdpwssd  zmm3, zmm29, zmm1
    vpmaxuw   zmm11, zmm11, zmm29
    vpmaxuw   zmm29, zmm0, [tq + strideq*2]
    vpdpwssd  zmm4, zmm29, zmm1
    vpmaxuw   zmm12, zmm12, zmm29
    vpmaxuw   zmm29, zmm0, [tq + s3q]
    vpdpwssd  zmm5, zmm29, zmm1
    vpmaxuw   zmm13, zmm13, zmm29
    vpmaxuw   zmm29, zmm0, [kq]
    vpdpwssd  zmm6, zmm29, zmm1
    vpmaxuw   zmm14, zmm14, zmm29
    vpmaxuw   zmm29, zmm0, [kq + strideq]
    vpdpwssd  zmm7, zmm29, zmm1
    vpmaxuw   zmm15, zmm15, zmm29
    vpmaxuw   zmm29, zmm0, [kq + strideq*2]
    vpdpwssd  zmm8, zmm29, zmm1
    vpmaxuw   zmm26, zmm26, zmm29
    vpmaxuw   zmm29, zmm0, [kq + s3q]
    vpdpwssd  zmm9, zmm29, zmm1
    vpmaxuw   zmm27, zmm27, zmm29
    add       tq, 64
    add       kq, 64
    dec       hq
    jnz       .rg_loop
.rg_tail:
    kortestd  k1, k1
    jz        .rg_red
    vpmaxuw   zmm29{k1}{z}, zmm0, [tq]
    vpdpwssd  zmm2, zmm29, zmm1
    vpmaxuw   zmm10, zmm10, zmm29
    vpmaxuw   zmm29{k1}{z}, zmm0, [tq + strideq]
    vpdpwssd  zmm3, zmm29, zmm1
    vpmaxuw   zmm11, zmm11, zmm29
    vpmaxuw   zmm29{k1}{z}, zmm0, [tq + strideq*2]
    vpdpwssd  zmm4, zmm29, zmm1
    vpmaxuw   zmm12, zmm12, zmm29
    vpmaxuw   zmm29{k1}{z}, zmm0, [tq + s3q]
    vpdpwssd  zmm5, zmm29, zmm1
    vpmaxuw   zmm13, zmm13, zmm29
    vpmaxuw   zmm29{k1}{z}, zmm0, [kq]
    vpdpwssd  zmm6, zmm29, zmm1
    vpmaxuw   zmm14, zmm14, zmm29
    vpmaxuw   zmm29{k1}{z}, zmm0, [kq + strideq]
    vpdpwssd  zmm7, zmm29, zmm1
    vpmaxuw   zmm15, zmm15, zmm29
    vpmaxuw   zmm29{k1}{z}, zmm0, [kq + strideq*2]
    vpdpwssd  zmm8, zmm29, zmm1
    vpmaxuw   zmm26, zmm26, zmm29
    vpmaxuw   zmm29{k1}{z}, zmm0, [kq + s3q]
    vpdpwssd  zmm9, zmm29, zmm1
    vpmaxuw   zmm27, zmm27, zmm29
.rg_red:
    xor       eax, eax
    vextracti64x4 ymm28, zmm2, 1
    vpaddd        ymm2, ymm2, ymm28
    vextracti128  xmm28, ymm2, 1
    vpaddd        xmm2, xmm2, xmm28
    vpshufd       xmm28, xmm2, 0xee
    vpaddd        xmm2, xmm2, xmm28
    vpshufd       xmm28, xmm2, 0x55
    vpaddd        xmm2, xmm2, xmm28
    vmovd         td, xmm2
    imul          tq, magicq
    shr           tq, 40
    lea           kd, [tq + 64]
    vpbroadcastw  zmm28, kd
    vpcmpuw       k2, zmm10, zmm28, 6
    cmp           td, 128
    setae         tb
    kortestd      k2, k2
    setne         kb
    or            tb, kb
    movzx         tq, tb
    lea           eax, [rax + rax]
    or            eax, td
    vextracti64x4 ymm28, zmm3, 1
    vpaddd        ymm3, ymm3, ymm28
    vextracti128  xmm28, ymm3, 1
    vpaddd        xmm3, xmm3, xmm28
    vpshufd       xmm28, xmm3, 0xee
    vpaddd        xmm3, xmm3, xmm28
    vpshufd       xmm28, xmm3, 0x55
    vpaddd        xmm3, xmm3, xmm28
    vmovd         td, xmm3
    imul          tq, magicq
    shr           tq, 40
    lea           kd, [tq + 64]
    vpbroadcastw  zmm28, kd
    vpcmpuw       k2, zmm11, zmm28, 6
    cmp           td, 128
    setae         tb
    kortestd      k2, k2
    setne         kb
    or            tb, kb
    movzx         tq, tb
    lea           eax, [rax + rax]
    or            eax, td
    vextracti64x4 ymm28, zmm4, 1
    vpaddd        ymm4, ymm4, ymm28
    vextracti128  xmm28, ymm4, 1
    vpaddd        xmm4, xmm4, xmm28
    vpshufd       xmm28, xmm4, 0xee
    vpaddd        xmm4, xmm4, xmm28
    vpshufd       xmm28, xmm4, 0x55
    vpaddd        xmm4, xmm4, xmm28
    vmovd         td, xmm4
    imul          tq, magicq
    shr           tq, 40
    lea           kd, [tq + 64]
    vpbroadcastw  zmm28, kd
    vpcmpuw       k2, zmm12, zmm28, 6
    cmp           td, 128
    setae         tb
    kortestd      k2, k2
    setne         kb
    or            tb, kb
    movzx         tq, tb
    lea           eax, [rax + rax]
    or            eax, td
    vextracti64x4 ymm28, zmm5, 1
    vpaddd        ymm5, ymm5, ymm28
    vextracti128  xmm28, ymm5, 1
    vpaddd        xmm5, xmm5, xmm28
    vpshufd       xmm28, xmm5, 0xee
    vpaddd        xmm5, xmm5, xmm28
    vpshufd       xmm28, xmm5, 0x55
    vpaddd        xmm5, xmm5, xmm28
    vmovd         td, xmm5
    imul          tq, magicq
    shr           tq, 40
    lea           kd, [tq + 64]
    vpbroadcastw  zmm28, kd
    vpcmpuw       k2, zmm13, zmm28, 6
    cmp           td, 128
    setae         tb
    kortestd      k2, k2
    setne         kb
    or            tb, kb
    movzx         tq, tb
    lea           eax, [rax + rax]
    or            eax, td
    vextracti64x4 ymm28, zmm6, 1
    vpaddd        ymm6, ymm6, ymm28
    vextracti128  xmm28, ymm6, 1
    vpaddd        xmm6, xmm6, xmm28
    vpshufd       xmm28, xmm6, 0xee
    vpaddd        xmm6, xmm6, xmm28
    vpshufd       xmm28, xmm6, 0x55
    vpaddd        xmm6, xmm6, xmm28
    vmovd         td, xmm6
    imul          tq, magicq
    shr           tq, 40
    lea           kd, [tq + 64]
    vpbroadcastw  zmm28, kd
    vpcmpuw       k2, zmm14, zmm28, 6
    cmp           td, 128
    setae         tb
    kortestd      k2, k2
    setne         kb
    or            tb, kb
    movzx         tq, tb
    lea           eax, [rax + rax]
    or            eax, td
    vextracti64x4 ymm28, zmm7, 1
    vpaddd        ymm7, ymm7, ymm28
    vextracti128  xmm28, ymm7, 1
    vpaddd        xmm7, xmm7, xmm28
    vpshufd       xmm28, xmm7, 0xee
    vpaddd        xmm7, xmm7, xmm28
    vpshufd       xmm28, xmm7, 0x55
    vpaddd        xmm7, xmm7, xmm28
    vmovd         td, xmm7
    imul          tq, magicq
    shr           tq, 40
    lea           kd, [tq + 64]
    vpbroadcastw  zmm28, kd
    vpcmpuw       k2, zmm15, zmm28, 6
    cmp           td, 128
    setae         tb
    kortestd      k2, k2
    setne         kb
    or            tb, kb
    movzx         tq, tb
    lea           eax, [rax + rax]
    or            eax, td
    vextracti64x4 ymm28, zmm8, 1
    vpaddd        ymm8, ymm8, ymm28
    vextracti128  xmm28, ymm8, 1
    vpaddd        xmm8, xmm8, xmm28
    vpshufd       xmm28, xmm8, 0xee
    vpaddd        xmm8, xmm8, xmm28
    vpshufd       xmm28, xmm8, 0x55
    vpaddd        xmm8, xmm8, xmm28
    vmovd         td, xmm8
    imul          tq, magicq
    shr           tq, 40
    lea           kd, [tq + 64]
    vpbroadcastw  zmm28, kd
    vpcmpuw       k2, zmm26, zmm28, 6
    cmp           td, 128
    setae         tb
    kortestd      k2, k2
    setne         kb
    or            tb, kb
    movzx         tq, tb
    lea           eax, [rax + rax]
    or            eax, td
    vextracti64x4 ymm28, zmm9, 1
    vpaddd        ymm9, ymm9, ymm28
    vextracti128  xmm28, ymm9, 1
    vpaddd        xmm9, xmm9, xmm28
    vpshufd       xmm28, xmm9, 0xee
    vpaddd        xmm9, xmm9, xmm28
    vpshufd       xmm28, xmm9, 0x55
    vpaddd        xmm9, xmm9, xmm28
    vmovd         td, xmm9
    imul          tq, magicq
    shr           tq, 40
    lea           kd, [tq + 64]
    vpbroadcastw  zmm28, kd
    vpcmpuw       k2, zmm27, zmm28, 6
    cmp           td, 128
    setae         tb
    kortestd      k2, k2
    setne         kb
    or            tb, kb
    movzx         tq, tb
    lea           eax, [rax + rax]
    or            eax, td
    ret

.colpair:
    vpxor     xmm1, xmm1, xmm1
    vpxor     xmm2, xmm2, xmm2
    vpxor     xmm3, xmm3, xmm3
    vpxor     xmm4, xmm4, xmm4
    vpxor     xmm5, xmm5, xmm5
    vpxor     xmm6, xmm6, xmm6
    vpxor     xmm7, xmm7, xmm7
    vpxor     xmm8, xmm8, xmm8
    vpxor     xmm9, xmm9, xmm9
    vpxor     xmm10, xmm10, xmm10
    vpxor     xmm11, xmm11, xmm11
    vpxor     xmm12, xmm12, xmm12
    vpxor     xmm13, xmm13, xmm13
    vpxor     xmm14, xmm14, xmm14
    vpxor     xmm15, xmm15, xmm15
    vpxor     xmm26, xmm26, xmm26
    mov       tq, curq
    add       stepq, curq
    mov       hq, hhq
.cp_outer:
    mov       kq, 64
    cmp       hq, kq
    cmovb     kq, hq
    sub       hq, kq
    mov       magicq, kq
    shr       magicq, 2
    jz        .cp_tail
.cp_blk4:
    vpmaxuw   zmm27, zmm0, [tq]
    vpmaxuw   zmm7, zmm7, zmm27
    vpaddw    zmm1, zmm1, zmm27
    vpmaxuw   zmm28, zmm0, [tq + 64]
    vpmaxuw   zmm8, zmm8, zmm28
    vpaddw    zmm2, zmm2, zmm28
    vpmaxuw   zmm27, zmm0, [stepq]
    vpmaxuw   zmm15, zmm15, zmm27
    vpaddw    zmm9, zmm9, zmm27
    vpmaxuw   zmm28, zmm0, [stepq + 64]
    vpmaxuw   zmm26, zmm26, zmm28
    vpaddw    zmm10, zmm10, zmm28
    vpmaxuw   zmm27, zmm0, [tq + strideq]
    vpmaxuw   zmm7, zmm7, zmm27
    vpaddw    zmm1, zmm1, zmm27
    vpmaxuw   zmm28, zmm0, [tq + strideq + 64]
    vpmaxuw   zmm8, zmm8, zmm28
    vpaddw    zmm2, zmm2, zmm28
    vpmaxuw   zmm27, zmm0, [stepq + strideq]
    vpmaxuw   zmm15, zmm15, zmm27
    vpaddw    zmm9, zmm9, zmm27
    vpmaxuw   zmm28, zmm0, [stepq + strideq + 64]
    vpmaxuw   zmm26, zmm26, zmm28
    vpaddw    zmm10, zmm10, zmm28
    vpmaxuw   zmm27, zmm0, [tq + strideq*2]
    vpmaxuw   zmm7, zmm7, zmm27
    vpaddw    zmm1, zmm1, zmm27
    vpmaxuw   zmm28, zmm0, [tq + strideq*2 + 64]
    vpmaxuw   zmm8, zmm8, zmm28
    vpaddw    zmm2, zmm2, zmm28
    vpmaxuw   zmm27, zmm0, [stepq + strideq*2]
    vpmaxuw   zmm15, zmm15, zmm27
    vpaddw    zmm9, zmm9, zmm27
    vpmaxuw   zmm28, zmm0, [stepq + strideq*2 + 64]
    vpmaxuw   zmm26, zmm26, zmm28
    vpaddw    zmm10, zmm10, zmm28
    vpmaxuw   zmm27, zmm0, [tq + s3q]
    vpmaxuw   zmm7, zmm7, zmm27
    vpaddw    zmm1, zmm1, zmm27
    vpmaxuw   zmm28, zmm0, [tq + s3q + 64]
    vpmaxuw   zmm8, zmm8, zmm28
    vpaddw    zmm2, zmm2, zmm28
    vpmaxuw   zmm27, zmm0, [stepq + s3q]
    vpmaxuw   zmm15, zmm15, zmm27
    vpaddw    zmm9, zmm9, zmm27
    vpmaxuw   zmm28, zmm0, [stepq + s3q + 64]
    vpmaxuw   zmm26, zmm26, zmm28
    vpaddw    zmm10, zmm10, zmm28
    lea       tq, [tq + strideq*4]
    lea       stepq, [stepq + strideq*4]
    dec       magicq
    jnz       .cp_blk4
.cp_tail:
    and       kq, 3
    jz        .cp_flush
.cp_blk1:
    vpmaxuw   zmm27, zmm0, [tq]
    vpmaxuw   zmm7, zmm7, zmm27
    vpaddw    zmm1, zmm1, zmm27
    vpmaxuw   zmm28, zmm0, [tq + 64]
    vpmaxuw   zmm8, zmm8, zmm28
    vpaddw    zmm2, zmm2, zmm28
    vpmaxuw   zmm27, zmm0, [stepq]
    vpmaxuw   zmm15, zmm15, zmm27
    vpaddw    zmm9, zmm9, zmm27
    vpmaxuw   zmm28, zmm0, [stepq + 64]
    vpmaxuw   zmm26, zmm26, zmm28
    vpaddw    zmm10, zmm10, zmm28
    add       tq, strideq
    add       stepq, strideq
    dec       kq
    jnz       .cp_blk1
.cp_flush:
    vpmovzxwd zmm27, ymm1
    vpaddd    zmm3, zmm3, zmm27
    vextracti64x4 ymm28, zmm1, 1
    vpmovzxwd zmm27, ymm28
    vpaddd    zmm4, zmm4, zmm27
    vpmovzxwd zmm27, ymm2
    vpaddd    zmm5, zmm5, zmm27
    vextracti64x4 ymm28, zmm2, 1
    vpmovzxwd zmm27, ymm28
    vpaddd    zmm6, zmm6, zmm27
    vpxor     xmm1, xmm1, xmm1
    vpxor     xmm2, xmm2, xmm2
    vpmovzxwd zmm27, ymm9
    vpaddd    zmm11, zmm11, zmm27
    vextracti64x4 ymm28, zmm9, 1
    vpmovzxwd zmm27, ymm28
    vpaddd    zmm12, zmm12, zmm27
    vpmovzxwd zmm27, ymm10
    vpaddd    zmm13, zmm13, zmm27
    vextracti64x4 ymm28, zmm10, 1
    vpmovzxwd zmm27, ymm28
    vpaddd    zmm14, zmm14, zmm27
    vpxor     xmm9, xmm9, xmm9
    vpxor     xmm10, xmm10, xmm10
    test      hq, hq
    jnz       .cp_outer
    vpbroadcastd zmm30, hhd
    mov       td, hhd
    shl       td, 7
    vpbroadcastd zmm31, td
    vpsubusw  zmm7, zmm7, zmm0
    vpsubusw  zmm8, zmm8, zmm0
    vmovdqa64 ymm28, ymm7
    vpmovzxwd zmm28, ymm28
    vpmulld   zmm28, zmm28, zmm30
    vpcmpud   k2, zmm3, zmm28, 1
    vpcmpud   k7, zmm3, zmm31, 5
    korw      k2, k2, k7
    vextracti64x4 ymm28, zmm7, 1
    vpmovzxwd zmm28, ymm28
    vpmulld   zmm28, zmm28, zmm30
    vpcmpud   k3, zmm4, zmm28, 1
    vpcmpud   k7, zmm4, zmm31, 5
    korw      k3, k3, k7
    vmovdqa64 ymm28, ymm8
    vpmovzxwd zmm28, ymm28
    vpmulld   zmm28, zmm28, zmm30
    vpcmpud   k4, zmm5, zmm28, 1
    vpcmpud   k7, zmm5, zmm31, 5
    korw      k4, k4, k7
    vextracti64x4 ymm28, zmm8, 1
    vpmovzxwd zmm28, ymm28
    vpmulld   zmm28, zmm28, zmm30
    vpcmpud   k5, zmm6, zmm28, 1
    vpcmpud   k7, zmm6, zmm31, 5
    korw      k5, k5, k7
    kunpckwd  k2, k3, k2
    kunpckwd  k4, k5, k4
    kunpckdq  k2, k4, k2
    kmovq     rax, k2
    vpsubusw  zmm15, zmm15, zmm0
    vpsubusw  zmm26, zmm26, zmm0
    vmovdqa64 ymm28, ymm15
    vpmovzxwd zmm28, ymm28
    vpmulld   zmm28, zmm28, zmm30
    vpcmpud   k2, zmm11, zmm28, 1
    vpcmpud   k7, zmm11, zmm31, 5
    korw      k2, k2, k7
    vextracti64x4 ymm28, zmm15, 1
    vpmovzxwd zmm28, ymm28
    vpmulld   zmm28, zmm28, zmm30
    vpcmpud   k3, zmm12, zmm28, 1
    vpcmpud   k7, zmm12, zmm31, 5
    korw      k3, k3, k7
    vmovdqa64 ymm28, ymm26
    vpmovzxwd zmm28, ymm28
    vpmulld   zmm28, zmm28, zmm30
    vpcmpud   k4, zmm13, zmm28, 1
    vpcmpud   k7, zmm13, zmm31, 5
    korw      k4, k4, k7
    vextracti64x4 ymm28, zmm26, 1
    vpmovzxwd zmm28, ymm28
    vpmulld   zmm28, zmm28, zmm30
    vpcmpud   k5, zmm14, zmm28, 1
    vpcmpud   k7, zmm14, zmm31, 5
    korw      k5, k5, k7
    kunpckwd  k2, k3, k2
    kunpckwd  k4, k5, k4
    kunpckdq  k2, k4, k2
    kmovq     kq, k2
    ret
