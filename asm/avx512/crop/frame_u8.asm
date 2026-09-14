%include "dav1d_x86inc.asm"

SECTION_RODATA 64
ALIGN 64
c16:   times 64 db 16
ones8: times 64 db 1
idx_a: dd 0, 1, 2, 3, 4, 5, 6, 7, 16, 17, 18, 19, 20, 21, 22, 23
idx_b: dd 8, 9, 10, 11, 12, 13, 14, 15, 24, 25, 26, 27, 28, 29, 30, 31

SECTION .text
INIT_ZMM avx512
%if WIN64
WIN64_MMMAP 6, 16, 15
%endif
cglobal crop_frame_u8, 5, 15, 16, p, w, h, stride, best, hh, mask, magic, s3, cur, cnt, t, k, lim, step
    mov       hhq, hq
    lea       s3q, [strideq + strideq*2]
    lea       stepq, [strideq*8]
    vmovdqa64 zmm0, [rel c16]
    mov       td, [bestq]
    test      tq, tq
    jz        .cols
    mov       kq, 8
    cmp       tq, kq
    cmovb     tq, kq
    cmp       tq, hhq
    cmova     tq, hhq
    mov       limq, tq
%if WIN64
    mov       kq, wq
    mov       rax, 0x10000000000
    add       rax, kq
    dec       rax
    xor       edx, edx
    div       kq
    mov       wq, kq
%else
    mov       rax, 0x10000000000
    add       rax, wq
    dec       rax
    xor       edx, edx
    div       wq
%endif
    mov       magicq, rax
    mov       tq, wq
    and       tq, 63
    mov       kq, -1
    bzhi      kq, kq, tq
    kmovq     k1, kq
    vmovdqa64 zmm1, [rel ones8]
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
    jae       .topnone
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
    jz        .topnone
    lzcnt     eax, eax
    lea       cntq, [limq + rax - 32]
.ht:
    test      cntq, cntq
    jnz       .htnz
    mov       [bestq], cntd
    jmp       .cols
.htnz:
    mov       td, [bestq]
    cmp       td, cntd
    cmova     td, cntd
    mov       [bestq], td
    mov       kq, 8
    cmp       tq, kq
    cmovb     tq, kq
    cmp       tq, hhq
    cmova     tq, hhq
    mov       limq, tq
.dobot:

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
    jae       .cols
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
    jz        .cols
    tzcnt     eax, eax
    lea       cntq, [limq + rax - 8]
.hb:
    mov       td, [bestq]
    cmp       td, cntd
    cmova     td, cntd
    mov       [bestq], td
.cols:
    mov       td, [bestq + 4]
    test      tq, tq
    jz        .collapse
    mov       kq, 64
    cmp       tq, kq
    cmovb     tq, kq
    cmp       tq, wq
    cmova     tq, wq
    mov       limq, tq
    vpxor     xmm1, xmm1, xmm1
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
    call      .colpair
    tzcnt     rax, rax
    lzcnt     kq, kq
    cmp       rax, kq
    cmova     rax, kq
    cmp       rax, 64
    jb        .ph
    add       curq, 64
    add       cntq, 64
    jmp       .pl
.ph:
    add       cntq, rax
    jmp       .hp
.pp:
    cmp       cntq, limq
    jae       .collapse
    lea       curq, [pq + limq - 64]
    mov       stepq, wq
    add       stepq, 64
    sub       stepq, limq
    sub       stepq, limq
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
    jae       .collapse
    lea       cntq, [limq + rax - 64]
.hp:
    mov       td, [bestq + 4]
    cmp       td, cntd
    cmova     td, cntd
    mov       [bestq + 4], td
    jmp       .collapse
.collapse:
    mov       td, [bestq]
    mov       kd, [bestq + 4]
    cmp       tq, kq
    cmovb     tq, kq
    cmp       tq, 2
    setb      al
    movzx     eax, al
    RET
.topnone:
    cmp       limq, hhq
    jb        .dobot
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
    shr       hq, 6
    jz        .rg_tail
.rg_loop:
    vpmaxub   zmm29, zmm0, [tq]
    vpdpbusd  zmm2, zmm29, zmm1
    vpmaxub   zmm10, zmm10, zmm29
    vpmaxub   zmm29, zmm0, [tq + strideq]
    vpdpbusd  zmm3, zmm29, zmm1
    vpmaxub   zmm11, zmm11, zmm29
    vpmaxub   zmm29, zmm0, [tq + strideq*2]
    vpdpbusd  zmm4, zmm29, zmm1
    vpmaxub   zmm12, zmm12, zmm29
    vpmaxub   zmm29, zmm0, [tq + s3q]
    vpdpbusd  zmm5, zmm29, zmm1
    vpmaxub   zmm13, zmm13, zmm29
    vpmaxub   zmm29, zmm0, [kq]
    vpdpbusd  zmm6, zmm29, zmm1
    vpmaxub   zmm14, zmm14, zmm29
    vpmaxub   zmm29, zmm0, [kq + strideq]
    vpdpbusd  zmm7, zmm29, zmm1
    vpmaxub   zmm15, zmm15, zmm29
    vpmaxub   zmm29, zmm0, [kq + strideq*2]
    vpdpbusd  zmm8, zmm29, zmm1
    vpmaxub   zmm26, zmm26, zmm29
    vpmaxub   zmm29, zmm0, [kq + s3q]
    vpdpbusd  zmm9, zmm29, zmm1
    vpmaxub   zmm27, zmm27, zmm29
    add       tq, 64
    add       kq, 64
    dec       hq
    jnz       .rg_loop
.rg_tail:
    kortestq  k1, k1
    jz        .rg_red
    vpmaxub   zmm29{k1}{z}, zmm0, [tq]
    vpdpbusd  zmm2, zmm29, zmm1
    vpmaxub   zmm10, zmm10, zmm29
    vpmaxub   zmm29{k1}{z}, zmm0, [tq + strideq]
    vpdpbusd  zmm3, zmm29, zmm1
    vpmaxub   zmm11, zmm11, zmm29
    vpmaxub   zmm29{k1}{z}, zmm0, [tq + strideq*2]
    vpdpbusd  zmm4, zmm29, zmm1
    vpmaxub   zmm12, zmm12, zmm29
    vpmaxub   zmm29{k1}{z}, zmm0, [tq + s3q]
    vpdpbusd  zmm5, zmm29, zmm1
    vpmaxub   zmm13, zmm13, zmm29
    vpmaxub   zmm29{k1}{z}, zmm0, [kq]
    vpdpbusd  zmm6, zmm29, zmm1
    vpmaxub   zmm14, zmm14, zmm29
    vpmaxub   zmm29{k1}{z}, zmm0, [kq + strideq]
    vpdpbusd  zmm7, zmm29, zmm1
    vpmaxub   zmm15, zmm15, zmm29
    vpmaxub   zmm29{k1}{z}, zmm0, [kq + strideq*2]
    vpdpbusd  zmm8, zmm29, zmm1
    vpmaxub   zmm26, zmm26, zmm29
    vpmaxub   zmm29{k1}{z}, zmm0, [kq + s3q]
    vpdpbusd  zmm9, zmm29, zmm1
    vpmaxub   zmm27, zmm27, zmm29
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
    lea           kd, [tq + 16]
    vpbroadcastb  zmm28, kd
    vpcmpub       k2, zmm10, zmm28, 6
    cmp           td, 32
    setae         tb
    kortestq      k2, k2
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
    lea           kd, [tq + 16]
    vpbroadcastb  zmm28, kd
    vpcmpub       k2, zmm11, zmm28, 6
    cmp           td, 32
    setae         tb
    kortestq      k2, k2
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
    lea           kd, [tq + 16]
    vpbroadcastb  zmm28, kd
    vpcmpub       k2, zmm12, zmm28, 6
    cmp           td, 32
    setae         tb
    kortestq      k2, k2
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
    lea           kd, [tq + 16]
    vpbroadcastb  zmm28, kd
    vpcmpub       k2, zmm13, zmm28, 6
    cmp           td, 32
    setae         tb
    kortestq      k2, k2
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
    lea           kd, [tq + 16]
    vpbroadcastb  zmm28, kd
    vpcmpub       k2, zmm14, zmm28, 6
    cmp           td, 32
    setae         tb
    kortestq      k2, k2
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
    lea           kd, [tq + 16]
    vpbroadcastb  zmm28, kd
    vpcmpub       k2, zmm15, zmm28, 6
    cmp           td, 32
    setae         tb
    kortestq      k2, k2
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
    lea           kd, [tq + 16]
    vpbroadcastb  zmm28, kd
    vpcmpub       k2, zmm26, zmm28, 6
    cmp           td, 32
    setae         tb
    kortestq      k2, k2
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
    lea           kd, [tq + 16]
    vpbroadcastb  zmm28, kd
    vpcmpub       k2, zmm27, zmm28, 6
    cmp           td, 32
    setae         tb
    kortestq      k2, k2
    setne         kb
    or            tb, kb
    movzx         tq, tb
    lea           eax, [rax + rax]
    or            eax, td
    ret

.colpair:
    vpxor      xmm2, xmm2, xmm2
    vpxor      xmm3, xmm3, xmm3
    vpxor      xmm4, xmm4, xmm4
    vpxor      xmm5, xmm5, xmm5
    vpxor      xmm6, xmm6, xmm6
    vpxor      xmm7, xmm7, xmm7
    vpxor      xmm8, xmm8, xmm8
    vpxor      xmm9, xmm9, xmm9
    vpxor      xmm10, xmm10, xmm10
    vpxor      xmm11, xmm11, xmm11
    vpxor      xmm12, xmm12, xmm12
    vpxor      xmm13, xmm13, xmm13
    vpxor      xmm14, xmm14, xmm14
    vpxor      xmm15, xmm15, xmm15
    mov        tq, curq
    add        stepq, curq
    mov        hq, hhq
.cp_outer:
    mov        kq, 256
    cmp        hq, kq
    cmovb      kq, hq
    sub        hq, kq
    mov        magicq, kq
    shr        magicq, 2
    jz         .cp_tail
.cp_blk4:
    vpmaxub    zmm26, zmm0, [tq]
    vpmaxub    zmm8, zmm8, zmm26
    vpunpcklbw zmm27, zmm26, zmm1
    vpaddw     zmm2, zmm2, zmm27
    vpunpckhbw zmm27, zmm26, zmm1
    vpaddw     zmm3, zmm3, zmm27
    vpmaxub    zmm26, zmm0, [stepq]
    vpmaxub    zmm15, zmm15, zmm26
    vpunpcklbw zmm27, zmm26, zmm1
    vpaddw     zmm9, zmm9, zmm27
    vpunpckhbw zmm27, zmm26, zmm1
    vpaddw     zmm10, zmm10, zmm27
    vpmaxub    zmm26, zmm0, [tq + strideq]
    vpmaxub    zmm8, zmm8, zmm26
    vpunpcklbw zmm27, zmm26, zmm1
    vpaddw     zmm2, zmm2, zmm27
    vpunpckhbw zmm27, zmm26, zmm1
    vpaddw     zmm3, zmm3, zmm27
    vpmaxub    zmm26, zmm0, [stepq + strideq]
    vpmaxub    zmm15, zmm15, zmm26
    vpunpcklbw zmm27, zmm26, zmm1
    vpaddw     zmm9, zmm9, zmm27
    vpunpckhbw zmm27, zmm26, zmm1
    vpaddw     zmm10, zmm10, zmm27
    vpmaxub    zmm26, zmm0, [tq + strideq*2]
    vpmaxub    zmm8, zmm8, zmm26
    vpunpcklbw zmm27, zmm26, zmm1
    vpaddw     zmm2, zmm2, zmm27
    vpunpckhbw zmm27, zmm26, zmm1
    vpaddw     zmm3, zmm3, zmm27
    vpmaxub    zmm26, zmm0, [stepq + strideq*2]
    vpmaxub    zmm15, zmm15, zmm26
    vpunpcklbw zmm27, zmm26, zmm1
    vpaddw     zmm9, zmm9, zmm27
    vpunpckhbw zmm27, zmm26, zmm1
    vpaddw     zmm10, zmm10, zmm27
    vpmaxub    zmm26, zmm0, [tq + s3q]
    vpmaxub    zmm8, zmm8, zmm26
    vpunpcklbw zmm27, zmm26, zmm1
    vpaddw     zmm2, zmm2, zmm27
    vpunpckhbw zmm27, zmm26, zmm1
    vpaddw     zmm3, zmm3, zmm27
    vpmaxub    zmm26, zmm0, [stepq + s3q]
    vpmaxub    zmm15, zmm15, zmm26
    vpunpcklbw zmm27, zmm26, zmm1
    vpaddw     zmm9, zmm9, zmm27
    vpunpckhbw zmm27, zmm26, zmm1
    vpaddw     zmm10, zmm10, zmm27
    lea        tq, [tq + strideq*4]
    lea        stepq, [stepq + strideq*4]
    dec        magicq
    jnz        .cp_blk4
.cp_tail:
    and        kq, 3
    jz         .cp_flush
.cp_blk1:
    vpmaxub    zmm26, zmm0, [tq]
    vpmaxub    zmm8, zmm8, zmm26
    vpunpcklbw zmm27, zmm26, zmm1
    vpaddw     zmm2, zmm2, zmm27
    vpunpckhbw zmm27, zmm26, zmm1
    vpaddw     zmm3, zmm3, zmm27
    vpmaxub    zmm26, zmm0, [stepq]
    vpmaxub    zmm15, zmm15, zmm26
    vpunpcklbw zmm27, zmm26, zmm1
    vpaddw     zmm9, zmm9, zmm27
    vpunpckhbw zmm27, zmm26, zmm1
    vpaddw     zmm10, zmm10, zmm27
    add        tq, strideq
    add        stepq, strideq
    dec        kq
    jnz        .cp_blk1
.cp_flush:
    vpmovzxwd  zmm26, ymm2
    vpaddd     zmm4, zmm4, zmm26
    vextracti64x4 ymm27, zmm2, 1
    vpmovzxwd  zmm26, ymm27
    vpaddd     zmm5, zmm5, zmm26
    vpmovzxwd  zmm26, ymm3
    vpaddd     zmm6, zmm6, zmm26
    vextracti64x4 ymm27, zmm3, 1
    vpmovzxwd  zmm26, ymm27
    vpaddd     zmm7, zmm7, zmm26
    vpxor      xmm2, xmm2, xmm2
    vpxor      xmm3, xmm3, xmm3
    vpmovzxwd  zmm26, ymm9
    vpaddd     zmm11, zmm11, zmm26
    vextracti64x4 ymm27, zmm9, 1
    vpmovzxwd  zmm26, ymm27
    vpaddd     zmm12, zmm12, zmm26
    vpmovzxwd  zmm26, ymm10
    vpaddd     zmm13, zmm13, zmm26
    vextracti64x4 ymm27, zmm10, 1
    vpmovzxwd  zmm26, ymm27
    vpaddd     zmm14, zmm14, zmm26
    vpxor      xmm9, xmm9, xmm9
    vpxor      xmm10, xmm10, xmm10
    test       hq, hq
    jnz        .cp_outer
    vmovdqa64  zmm28, [rel idx_a]
    vmovdqa64  zmm29, [rel idx_b]
    vpbroadcastd zmm30, hhd
    mov        td, hhd
    shl        td, 5
    vpbroadcastd zmm31, td
    vmovdqa64  zmm26, zmm4
    vpermt2d   zmm4, zmm28, zmm6
    vpermt2d   zmm26, zmm29, zmm6
    vmovdqa64  zmm27, zmm5
    vpermt2d   zmm5, zmm28, zmm7
    vpermt2d   zmm27, zmm29, zmm7
    vpsubusb   zmm8, zmm8, zmm0
    vmovdqa64  xmm9, xmm8
    vpmovzxbd  zmm9, xmm9
    vpmulld    zmm9, zmm9, zmm30
    vpcmpud    k2, zmm4, zmm9, 1
    vpcmpud    k7, zmm4, zmm31, 5
    korw       k2, k2, k7
    vextracti32x4 xmm9, zmm8, 1
    vpmovzxbd  zmm9, xmm9
    vpmulld    zmm9, zmm9, zmm30
    vpcmpud    k3, zmm26, zmm9, 1
    vpcmpud    k7, zmm26, zmm31, 5
    korw       k3, k3, k7
    vextracti32x4 xmm9, zmm8, 2
    vpmovzxbd  zmm9, xmm9
    vpmulld    zmm9, zmm9, zmm30
    vpcmpud    k4, zmm5, zmm9, 1
    vpcmpud    k7, zmm5, zmm31, 5
    korw       k4, k4, k7
    vextracti32x4 xmm9, zmm8, 3
    vpmovzxbd  zmm9, xmm9
    vpmulld    zmm9, zmm9, zmm30
    vpcmpud    k5, zmm27, zmm9, 1
    vpcmpud    k7, zmm27, zmm31, 5
    korw       k5, k5, k7
    kunpckwd   k2, k3, k2
    kunpckwd   k4, k5, k4
    kunpckdq   k2, k4, k2
    kmovq      rax, k2
    vmovdqa64  zmm2, zmm11
    vpermt2d   zmm11, zmm28, zmm13
    vpermt2d   zmm2, zmm29, zmm13
    vmovdqa64  zmm3, zmm12
    vpermt2d   zmm12, zmm28, zmm14
    vpermt2d   zmm3, zmm29, zmm14
    vpsubusb   zmm15, zmm15, zmm0
    vmovdqa64  xmm10, xmm15
    vpmovzxbd  zmm10, xmm10
    vpmulld    zmm10, zmm10, zmm30
    vpcmpud    k2, zmm11, zmm10, 1
    vpcmpud    k7, zmm11, zmm31, 5
    korw       k2, k2, k7
    vextracti32x4 xmm10, zmm15, 1
    vpmovzxbd  zmm10, xmm10
    vpmulld    zmm10, zmm10, zmm30
    vpcmpud    k3, zmm2, zmm10, 1
    vpcmpud    k7, zmm2, zmm31, 5
    korw       k3, k3, k7
    vextracti32x4 xmm10, zmm15, 2
    vpmovzxbd  zmm10, xmm10
    vpmulld    zmm10, zmm10, zmm30
    vpcmpud    k4, zmm12, zmm10, 1
    vpcmpud    k7, zmm12, zmm31, 5
    korw       k4, k4, k7
    vextracti32x4 xmm10, zmm15, 3
    vpmovzxbd  zmm10, xmm10
    vpmulld    zmm10, zmm10, zmm30
    vpcmpud    k5, zmm3, zmm10, 1
    vpcmpud    k7, zmm3, zmm31, 5
    korw       k5, k5, k7
    kunpckwd   k2, k3, k2
    kunpckwd   k4, k5, k4
    kunpckdq   k2, k4, k2
    kmovq      kq, k2
    ret

