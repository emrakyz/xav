%include "dav1d_x86inc.asm"

W equ 64*M
HMX equ 4320
CST equ W + 64
CPL0 equ (18*M+4)*CST
CB0 equ 72*W*M + 64
CRD equ CPL0 + 65536*(((HMX/2+4)*CST-CPL0+65535)/65536)
CB equ CB0 + 65536*((2*W*HMX+64-CB0+65535)/65536)
MG equ (0x100000000+M-1)/M
SPBC equ 512*(M+1)
SLT equ 7168 + 256
FRAME equ SLT + 8*SPBC + 256
S_DST equ 7112
S_SRC equ 7120

SECTION .text align=64
INIT_YMM avx2

cextern ro
cextern dp

%define c_to ro
%define c_w8e (ro + 128)
%define c_w8o (ro + 160)
%define c_r8o (ro + 192)
%define c_r8x (ro + 224)
%define c_c8e (ro + 256)
%define c_p8e (ro + 288)
%define c_pd8 (ro + 320)
%define c_s2 (ro + 352)
%define c_ones (ro + 384)
%define c_onesw (ro + 416)
%define c_n64w (ro + 448)
%define c_q8e0 (ro + 480)
%define c_q8e1 (ro + 512)
%define c_q8e2 (ro + 544)
%define c_q8e3 (ro + 576)
%define c_q8o0 (ro + 608)
%define c_q8o1 (ro + 640)
%define c_q8o2 (ro + 672)
%define c_q8o3 (ro + 704)
%define c_eq (ro + 736)
%define c_ieq (ro + 768)
%define c_snegl (ro + 800)
%define c_snegh (ro + 832)
%define c_k5e (ro + 864)
%define c_xflr (ro + 896)
%define c_xlo (ro + 928)
%define c_epsf (ro + 960)
%define c_xrcr (ro + 992)
%define c_xgcr (ro + 1024)
%define c_xgcb (ro + 1056)
%define c_xbcb (ro + 1088)
%define c_kh0 (ro + 1120)
%define c_kh1 (ro + 1152)
%define c_kh2 (ro + 1184)
%define c_kh3 (ro + 1216)
%define c_kh4 (ro + 1248)
%define c_kh5 (ro + 1280)
%define c_h0625 (ro + 1312)
%define c_h5625 (ro + 1344)
%define c_one (ro + 1376)
%define c_half (ro + 1408)
%define c_rgl0 (ro + 1440)
%define c_rgl1 (ro + 1472)
%define c_rgl2 (ro + 1504)
%define c_oml0 (ro + 1536)
%define c_oml1 (ro + 1568)
%define c_oml2 (ro + 1600)
%define c_anegl (ro + 1632)
%define c_tabsl (ro + 1664)
%define c_mtl0 (ro + 1696)
%define c_mtl1 (ro + 1728)
%define c_mtl2 (ro + 1760)
%define c_slkl (ro + 1792)
%define c_rgh0 (ro + 1824)
%define c_rgh1 (ro + 1856)
%define c_rgh2 (ro + 1888)
%define c_omh0 (ro + 1920)
%define c_omh1 (ro + 1952)
%define c_omh2 (ro + 1984)
%define c_anegh (ro + 2016)
%define c_tabsh (ro + 2048)
%define c_mth0 (ro + 2080)
%define c_mth1 (ro + 2112)
%define c_mth2 (ro + 2144)
%define c_mth3 (ro + 2176)
%define c_mth4 (ro + 2208)
%define c_mth5 (ro + 2240)
%define c_slkh0 (ro + 2272)
%define c_slkh1 (ro + 2304)
%define c_sign (ro + 2336)
%define c_i64 (ro + 2368)
%define c_i512 (ro + 2400)
%define c_i1023 (ro + 2432)
%define c_zero (ro + 2464)
%define u_rx (ro + 2496)
%define u_oa (ro + 2624)
%define u_ob (ro + 2752)
%define u_ow (ro + 2816)
%define u_tsl (ro + 2944)
%define u_wsx (ro + 3072)
%define u_prm (ro + 3200)
%define u_iota (ro + 3232)
%define u_k75 (ro + 3264)
%define u_k25 (ro + 3280)
%define u_k50 (ro + 3296)
%define u_cs (ro + 3328)
%define u_epsn (ro + 3456)
%define u_one (ro + 3488)
%define u_eq0 (ro + 3520)
%define u_omg (ro + 3552)
%define u_zero (ro + 3584)
%define u_1023 (ro + 3616)
%define u_mone (ro + 3648)
%define u_op0 (ro + 3680)
%define u_op1 (ro + 3712)
%define u_op2 (ro + 3744)
%define u_op3 (ro + 3776)
%define u_op4 (ro + 3808)
%define u_lzm0 (ro + 3840)
%define u_lzm1 (ro + 3872)
%define u_lzm2 (ro + 3904)
%define u_lzm3 (ro + 3936)
%define u_lzm4 (ro + 3968)
%define u_lzm5 (ro + 4000)
%define u_emc0 (ro + 4032)
%define u_emc1 (ro + 4064)
%define u_emc2 (ro + 4096)
%define u_emc3 (ro + 4128)
%define u_emc4 (ro + 4160)
%define u_emc5 (ro + 4192)
%define u_emc6 (ro + 4224)
%define u_emc7 (ro + 4256)
%define u_emc8 (ro + 4288)
%define u_psx0 (ro + 4320)
%define u_psx1 (ro + 4352)
%define u_psx2 (ro + 4384)
%define u_psx3 (ro + 4416)
%define u_tsk (ro + 4448)
%define u_xflr (ro + 4480)
%define u_rg2 (ro + 4512)
%define u_tab (ro + 4544)
%define u_quart (ro + 4576)
%define u_six (ro + 4608)
%define u_ylo (ro + 4640)
%define u_yhi (ro + 4672)
%define u_clo (ro + 4704)
%define u_chi (ro + 4736)
%define u_512 (ro + 4768)
%define u_ln2 (ro + 4800)
%define u_i1024 (ro + 4832)
%define u_876 (ro + 4864)
%define u_64 (ro + 4896)
%define u_half (ro + 4928)
%define u_mhalf (ro + 4960)
%define u_magic (ro + 4992)
%define u_anegl (ro + 5024)
%define u_snegl (ro + 5056)
%define u_tabsl (ro + 5088)
%define u_rgl0 (ro + 5120)
%define u_rgl1 (ro + 5152)
%define u_rgl2 (ro + 5184)
%define u_mtl0 (ro + 5216)
%define u_mtl1 (ro + 5248)
%define u_mtl2 (ro + 5280)
%define u_slol0 (ro + 5312)
%define u_shil0 (ro + 5344)
%define u_anegh (ro + 5376)
%define u_snegh (ro + 5408)
%define u_tabsh (ro + 5440)
%define u_rgh0 (ro + 5472)
%define u_rgh1 (ro + 5504)
%define u_rgh2 (ro + 5536)
%define u_mth0 (ro + 5568)
%define u_mth1 (ro + 5600)
%define u_mth2 (ro + 5632)
%define u_mth3 (ro + 5664)
%define u_mth4 (ro + 5696)
%define u_mth5 (ro + 5728)
%define u_sloh0 (ro + 5760)
%define u_sloh1 (ro + 5792)
%define u_shih0 (ro + 5824)
%define u_shih1 (ro + 5856)
%define u_absm (ro + 5888)
%define u_mzero (ro + 5920)
%define u_mant (ro + 5952)
%define u_oneb (ro + 5984)
%define u_i15 (ro + 6016)
%define u_i7 (ro + 6048)
%define u_i16 (ro + 6080)
%define u_ln2d (ro + 6112)
%define u_e125 (ro + 6128)
%define u_e512 (ro + 6144)
%define u_kr (ro + 6160)
%define u_kg (ro + 6176)
%define u_kb (ro + 6192)
%define u_ysc (ro + 6208)
%define u_yof (ro + 6224)
%define u_rcr (ro + 6240)
%define u_gcr (ro + 6256)
%define u_gcb (ro + 6272)
%define u_bcb (ro + 6288)
%define u_cbs (ro + 6304)
%define u_crs (ro + 6320)

%if WIN64
%define D_CSZ 80
%define CRS
%macro CRST 2+
    add %1, [dp + D_CSZ]
    %2
    sub %1, [dp + D_CSZ]
%endmacro
%else
%define CRS gs:
%macro CRST 2+
    %2
%endmacro
%endif

cglobal ds2_ %+ M
    push r9
    push r10
    push r13
    push r14
    push r11
    push r12
%if WIN64
    push r7
    push r8
    sub rsp, 160
    vmovdqu [rsp], xmm6
    vmovdqu [rsp + 16], xmm7
    vmovdqu [rsp + 32], xmm8
    vmovdqu [rsp + 48], xmm9
    vmovdqu [rsp + 64], xmm10
    vmovdqu [rsp + 80], xmm11
    vmovdqu [rsp + 96], xmm12
    vmovdqu [rsp + 112], xmm13
    vmovdqu [rsp + 128], xmm14
    vmovdqu [rsp + 144], xmm15
    lea r3, [rsp - FRAME - TSZ - 256]
    mov r6, rsp
.stk:
    sub r6, 4096
    mov r2d, [r6]
    cmp r6, r3
    ja .stk
%endif
    mov r6, rsp
    sub rsp, FRAME
    and rsp, -64
    mov [rsp + 7104], r6
    mov [rsp + 7112], r1
    mov [rsp + 7120], r0
    lea r2, [r0 + CB]
    lea r4, [rsp + SLT + 2*SPBC]
    mov r5d, 4
.cpr:
    movzx r6d, word [r2 + W - 2]
    mov [r2 + W], r6w
    mov [r2 + W + 2], r6w
    movzx r6d, word [r2 + CRD + W - 2]
    mov [r2 + CRD + W], r6w
    mov [r2 + CRD + W + 2], r6w
    mov r3, -W
.cpe:
    vpmovzxwd ymm0, [r3 + r2 + W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vmovaps [r4 + r3*8 + 8*W], ymm0
    vpmovzxwd ymm1, [r3 + r2 + W + CRD]
    vpsubd ymm1, ymm1, [c_i512]
    vcvtdq2ps ymm1, ymm1
    vmovaps [r4 + r3*8 + 8*W + 32], ymm1
    add r3, 16
    jnz .cpe
    vpmovzxwd ymm0, [r2 + W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vmovaps [r4 + 8*W], ymm0
    vbroadcastss ymm0, [r4]
    vmovaps [r4 - 128], ymm0
    vpmovzxwd ymm1, [r2 + W + CRD]
    vpsubd ymm1, ymm1, [c_i512]
    vcvtdq2ps ymm1, ymm1
    vmovaps [r4 + 8*W + 32], ymm1
    vbroadcastss ymm1, [r4 + 32]
    vmovaps [r4 - 96], ymm1
    mov r3, -8*W
.cpo:
    vmovaps ymm0, [r4 + r3 + 8*W]
    vmovaps ymm1, [r4 + r3 + 8*W + 128]
    vperm2f128 ymm2, ymm0, [r4 + r3 + 8*W - 128], 3
    vpalignr ymm2, ymm0, ymm2, 12
    vperm2f128 ymm3, ymm0, ymm1, 0x21
    vpalignr ymm4, ymm3, ymm0, 4
    vpalignr ymm3, ymm3, ymm0, 8
    vaddps ymm4, ymm4, ymm0
    vaddps ymm2, ymm2, ymm3
    vmulps ymm2, ymm2, [c_h0625]
    vfmsub132ps ymm4, ymm2, [c_h5625]
    vmovaps [r4 + r3 + 8*W + 64], ymm4
    vmovaps ymm0, [r4 + r3 + 8*W + 32]
    vmovaps ymm1, [r4 + r3 + 8*W + 160]
    vperm2f128 ymm2, ymm0, [r4 + r3 + 8*W - 96], 3
    vpalignr ymm2, ymm0, ymm2, 12
    vperm2f128 ymm3, ymm0, ymm1, 0x21
    vpalignr ymm4, ymm3, ymm0, 4
    vpalignr ymm3, ymm3, ymm0, 8
    vaddps ymm4, ymm4, ymm0
    vaddps ymm2, ymm2, ymm3
    vmulps ymm2, ymm2, [c_h0625]
    vfmsub132ps ymm4, ymm2, [c_h5625]
    vmovaps [r4 + r3 + 8*W + 96], ymm4
    add r3, strict dword 128
    jnz .cpo
    add r2, CST
    add r4, SPBC
    dec r5d
    jnz .cpr
    lea r4, [rsp + SLT]
    mov r3, -8*W
.cpc:
    vmovaps ymm0, [r4 + r3 + 8*W + 2*SPBC]
    vmovaps [r4 + r3 + 8*W], ymm0
    vmovaps [r4 + r3 + 8*W + SPBC], ymm0
    vmovaps ymm1, [r4 + r3 + 8*W + 2*SPBC + 64]
    vmovaps [r4 + r3 + 8*W + 64], ymm1
    vmovaps [r4 + r3 + 8*W + SPBC + 64], ymm1
    vmovaps ymm2, [r4 + r3 + 8*W + 2*SPBC + 128]
    vmovaps [r4 + r3 + 8*W + 128], ymm2
    vmovaps [r4 + r3 + 8*W + SPBC + 128], ymm2
    vmovaps ymm3, [r4 + r3 + 8*W + 2*SPBC + 192]
    vmovaps [r4 + r3 + 8*W + 192], ymm3
    vmovaps [r4 + r3 + 8*W + SPBC + 192], ymm3
    vmovaps ymm0, [r4 + r3 + 8*W + 2*SPBC + 32]
    vmovaps [r4 + r3 + 8*W + 32], ymm0
    vmovaps [r4 + r3 + 8*W + SPBC + 32], ymm0
    vmovaps ymm1, [r4 + r3 + 8*W + 2*SPBC + 96]
    vmovaps [r4 + r3 + 8*W + 96], ymm1
    vmovaps [r4 + r3 + 8*W + SPBC + 96], ymm1
    vmovaps ymm2, [r4 + r3 + 8*W + 2*SPBC + 160]
    vmovaps [r4 + r3 + 8*W + 160], ymm2
    vmovaps [r4 + r3 + 8*W + SPBC + 160], ymm2
    vmovaps ymm3, [r4 + r3 + 8*W + 2*SPBC + 224]
    vmovaps [r4 + r3 + 8*W + 224], ymm3
    vmovaps [r4 + r3 + 8*W + SPBC + 224], ymm3
    add r3, 256
    jnz .cpc
    mov r2, [dp + 8]
    add r2, r0
    mov r3, -W
.cpb:
    vmovdqu ymm0, [r3 + r2 - CST]
    vmovdqu [r2 + r3], ymm0
    vmovdqu [r3 + r2 + CST], ymm0
    vmovdqu ymm0, [r3 + r2 + CRD - CST]
    vmovdqu [r2 + r3 + CRD], ymm0
    vmovdqu [r3 + r2 + CRD + CST], ymm0
    add r3, 32
    jnz .cpb
    vxorps ymm0, ymm0, ymm0
    vmovaps [rsp + 6336], ymm0
    vmovaps [rsp + 6368], ymm0
    vmovaps [rsp + 6400], ymm0
    vmovaps [rsp + 6432], ymm0
    vmovaps [rsp + 6464], ymm0
    vmovaps [rsp + 6496], ymm0
    vmovaps [rsp + 6528], ymm0
    vmovaps [rsp + 6560], ymm0
    vmovaps [rsp + 6592], ymm0
    vmovaps [rsp + 6624], ymm0
    vmovaps [rsp + 6656], ymm0
    vmovaps [rsp + 6688], ymm0
    vmovaps [rsp + 6720], ymm0
    vmovaps [rsp + 6752], ymm0
    vmovaps [rsp + 6784], ymm0
    vmovaps [rsp + 6816], ymm0
    vmovaps [rsp + 6848], ymm0
    vmovaps [rsp + 6880], ymm0
    vmovaps [rsp + 6912], ymm0
    vmovaps [rsp + 6944], ymm0
    mov r12d, [dp]
    mov r9, r1
    lea r10, [r1 + r12*2]
    mov r11, r9
    mov r6, r10
    lea r1, [r0 + 2*W]
    lea r0, [r0 + CB + 4*CST + W]
    lea r4, [rsp + SLT]
    lea r5, [rsp + SLT + 2*SPBC]
    lea r7, [rsp + SLT + 4*SPBC]
    lea r8, [rsp + SLT + 6*SPBC]
    lea r13, [rsp + 5696]
    lea r14, [rsp + 6336]
%if FORMAT_ELF
SECTION .note.GNU-stack
%else
SECTION .dry info
%endif
..@s0:
    movzx r2d, word [r0 - 2]
    mov [r0], r2w
    mov [r0 + 2], r2w
    movzx r2d, word [r0 + CRD - 2]
    mov [r0 + CRD], r2w
    mov [r0 + CRD + 2], r2w
    movzx r2d, word [r0 + CST - 2]
    mov [r0 + CST], r2w
    mov [r0 + CST + 2], r2w
    movzx r2d, word [r0 + CST + CRD - 2]
    mov [r0 + CST + CRD], r2w
    mov [r0 + CST + CRD + 2], r2w
    vpmovzxwd ymm0, [r0 - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8], ymm0
    vmovaps [r8 - 128], ymm1
    vpmovzxwd ymm0, [r0 + CRD - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8 + 32], ymm0
    vmovaps [r8 + 32 - 128], ymm1
    vpmovzxwd ymm0, [r0 + CST - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8 + SPBC], ymm0
    vmovaps [r8 + SPBC - 128], ymm1
    vpmovzxwd ymm0, [r0 + CST + CRD - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8 + SPBC + 32], ymm0
    vmovaps [r8 + SPBC + 32 - 128], ymm1
    vxorps ymm0, ymm0, ymm0
    vmovaps [rsp + 5536], ymm0
    vmovaps [rsp + 5568], ymm0
    vmovaps [rsp + 5600], ymm0
    vmovaps [rsp + 5632], ymm0
    vmovups ymm0, [c_s2]
    vmovaps [rsp + 5664], ymm0
    mov r3, -(W/2)
..@s1:
SECTION .text
PN equ (64 - (($ - $$) + (..@s1 - ..@s0) + 2) % 64) % 64
    times (PN >= 2) jmp strict short .period
    times (PN >= 2) * (PN - 2) int3
    times (PN == 1) nop
.period:
    movzx r2d, word [r0 - 2]
    mov [r0], r2w
    mov [r0 + 2], r2w
    movzx r2d, word [r0 + CRD - 2]
    mov [r0 + CRD], r2w
    mov [r0 + CRD + 2], r2w
    movzx r2d, word [r0 + CST - 2]
    mov [r0 + CST], r2w
    mov [r0 + CST + 2], r2w
    movzx r2d, word [r0 + CST + CRD - 2]
    mov [r0 + CST + CRD], r2w
    mov [r0 + CST + CRD + 2], r2w
    vpmovzxwd ymm0, [r0 - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8], ymm0
    vmovaps [r8 - 128], ymm1
    vpmovzxwd ymm0, [r0 + CRD - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8 + 32], ymm0
    vmovaps [r8 + 32 - 128], ymm1
    vpmovzxwd ymm0, [r0 + CST - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8 + SPBC], ymm0
    vmovaps [r8 + SPBC - 128], ymm1
    vpmovzxwd ymm0, [r0 + CST + CRD - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8 + SPBC + 32], ymm0
    vmovaps [r8 + SPBC + 32 - 128], ymm1
    vxorps ymm0, ymm0, ymm0
    vmovaps [rsp + 5536], ymm0
    vmovaps [rsp + 5568], ymm0
    vmovaps [rsp + 5600], ymm0
    vmovaps [rsp + 5632], ymm0
    vmovups ymm0, [c_s2]
    vmovaps [rsp + 5664], ymm0
    mov r3, -(W/2)
    jmp strict short .pair
    ALIGN 64
.pair:
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_ieq]
    vmovups ymm13, [c_eq]
    vmovups ymm12, [c_sign]
    vmovups ymm11, [c_epsf]
    vsubps ymm0, ymm11, [r14 + 96]
    vmovups ymm1, [c_anegl]
    vmovups ymm2, [r14]
    vmovups ymm3, [r14 + 32]
    vrsqrtps ymm4, ymm0
    vmovups ymm5, [r14 + 64]
    vfmadd231ps ymm1, ymm4, [c_snegl]
    vandnps ymm6, ymm12, ymm2
    vandnps ymm7, ymm12, ymm3
    vandnps ymm8, ymm12, ymm5
    vfmadd213ps ymm1, ymm0, [c_tabsl]
    vmovaps ymm9, ymm1
    vfmadd231ps ymm9, ymm6, [c_rgl0]
    vmovaps ymm10, ymm1
    vfmadd231ps ymm10, ymm7, [c_rgl1]
    vfmadd231ps ymm1, ymm8, [c_rgl2]
    vsubps ymm4, ymm6, ymm9
    vsubps ymm2, ymm7, ymm10
    vsubps ymm3, ymm8, ymm1
    vcmpps ymm5, ymm4, ymm15, 30
    vrcpps ymm0, ymm4
    vmovaps [rsp], ymm5
    vandnps ymm4, ymm5, ymm9
    vaddps ymm6, ymm6, ymm4
    vmulps ymm4, ymm9, ymm0
    vcmpps ymm9, ymm2, ymm15, 30
    vrcpps ymm0, ymm2
    vmovaps [rsp + 2016], ymm6
    vandnps ymm2, ymm9, ymm10
    vblendvps ymm6, ymm14, ymm4, ymm5
    vmovaps [rsp + 32], ymm9
    vaddps ymm4, ymm7, ymm2
    vcmpps ymm5, ymm3, ymm15, 30
    vrcpps ymm7, ymm3
    vmovups ymm2, [c_anegl]
    vmulps ymm3, ymm10, ymm0
    vsubps ymm10, ymm11, [r14 + 224]
    vfmadd213ps ymm6, ymm13, [c_oml0]
    vmovaps [rsp + 2080], ymm4
    vandnps ymm0, ymm5, ymm1
    vmovaps [rsp + 64], ymm5
    vaddps ymm4, ymm8, ymm0
    vrsqrtps ymm8, ymm10
    vblendvps ymm0, ymm14, ymm3, ymm9
    vmulps ymm3, ymm1, ymm7
    vmovups ymm9, [r14 + 128]
    vmovups ymm1, [r14 + 160]
    vmovaps [rsp + 2144], ymm4
    vmovups ymm7, [r14 + 192]
    vmovaps [rsp + 2048], ymm6
    vfmadd213ps ymm0, ymm13, [c_oml1]
    vblendvps ymm4, ymm14, ymm3, ymm5
    vfmadd231ps ymm2, ymm8, [c_snegl]
    vfmadd213ps ymm4, ymm13, [c_oml2]
    vmovaps [rsp + 2112], ymm0
    vfmadd213ps ymm2, ymm10, [c_tabsl]
    vandnps ymm6, ymm12, ymm9
    vandnps ymm3, ymm12, ymm1
    vandnps ymm5, ymm12, ymm7
    vmovaps [rsp + 2176], ymm4
    vmovaps ymm8, ymm2
    vfmadd231ps ymm8, ymm6, [c_rgl0]
    vmovaps ymm0, ymm2
    vfmadd231ps ymm0, ymm3, [c_rgl1]
    vfmadd231ps ymm2, ymm5, [c_rgl2]
    vsubps ymm10, ymm6, ymm8
    vsubps ymm9, ymm3, ymm0
    vsubps ymm1, ymm5, ymm2
    vcmpps ymm7, ymm10, ymm15, 30
    vrcpps ymm4, ymm10
    vmovaps [rsp + 96], ymm7
    vandnps ymm10, ymm7, ymm8
    vaddps ymm6, ymm6, ymm10
    vmulps ymm10, ymm8, ymm4
    vcmpps ymm8, ymm9, ymm15, 30
    vrcpps ymm4, ymm9
    vmovaps [rsp + 2208], ymm6
    vandnps ymm9, ymm8, ymm0
    vblendvps ymm6, ymm14, ymm10, ymm7
    vmovaps [rsp + 128], ymm8
    vaddps ymm10, ymm3, ymm9
    vcmpps ymm7, ymm1, ymm15, 30
    vrcpps ymm3, ymm1
    vmovups ymm9, [c_anegl]
    vmulps ymm1, ymm0, ymm4
    vsubps ymm0, ymm11, [r14 + 352]
    vfmadd213ps ymm6, ymm13, [c_oml0]
    vmovaps [rsp + 2272], ymm10
    vandnps ymm4, ymm7, ymm2
    vmovaps [rsp + 160], ymm7
    vaddps ymm10, ymm5, ymm4
    vrsqrtps ymm5, ymm0
    vblendvps ymm4, ymm14, ymm1, ymm8
    vmulps ymm1, ymm2, ymm3
    vmovups ymm8, [r14 + 256]
    vmovups ymm2, [r14 + 288]
    vmovaps [rsp + 2336], ymm10
    vmovups ymm3, [r14 + 320]
    vmovaps [rsp + 2240], ymm6
    vfmadd213ps ymm4, ymm13, [c_oml1]
    vblendvps ymm10, ymm14, ymm1, ymm7
    vfmadd231ps ymm9, ymm5, [c_snegl]
    vfmadd213ps ymm10, ymm13, [c_oml2]
    vmovaps [rsp + 2304], ymm4
    vfmadd213ps ymm9, ymm0, [c_tabsl]
    vandnps ymm6, ymm12, ymm8
    vandnps ymm1, ymm12, ymm2
    vandnps ymm7, ymm12, ymm3
    vmovaps [rsp + 2368], ymm10
    vmovaps ymm5, ymm9
    vfmadd231ps ymm5, ymm6, [c_rgl0]
    vmovaps ymm4, ymm9
    vfmadd231ps ymm4, ymm1, [c_rgl1]
    vfmadd231ps ymm9, ymm7, [c_rgl2]
    vsubps ymm0, ymm6, ymm5
    vsubps ymm8, ymm1, ymm4
    vsubps ymm2, ymm7, ymm9
    vcmpps ymm3, ymm0, ymm15, 30
    vrcpps ymm10, ymm0
    vmovaps [rsp + 192], ymm3
    vandnps ymm0, ymm3, ymm5
    vaddps ymm6, ymm6, ymm0
    jmp .j128
.j128:
    vmulps ymm0, ymm5, ymm10
    vcmpps ymm5, ymm8, ymm15, 30
    vrcpps ymm10, ymm8
    vmovaps [rsp + 2400], ymm6
    vandnps ymm8, ymm5, ymm4
    vblendvps ymm6, ymm14, ymm0, ymm3
    vmovaps [rsp + 224], ymm5
    vaddps ymm0, ymm1, ymm8
    vcmpps ymm3, ymm2, ymm15, 30
    vrcpps ymm1, ymm2
    vmovups ymm8, [c_anegl]
    vmulps ymm2, ymm4, ymm10
    vsubps ymm4, ymm11, [r14 + 480]
    vfmadd213ps ymm6, ymm13, [c_oml0]
    vmovaps [rsp + 2464], ymm0
    vandnps ymm10, ymm3, ymm9
    vmovaps [rsp + 256], ymm3
    vaddps ymm0, ymm7, ymm10
    vrsqrtps ymm7, ymm4
    vblendvps ymm10, ymm14, ymm2, ymm5
    vmulps ymm2, ymm9, ymm1
    vmovups ymm5, [r14 + 384]
    vmovups ymm9, [r14 + 416]
    vmovaps [rsp + 2528], ymm0
    vmovups ymm1, [r14 + 448]
    vmovaps [rsp + 2432], ymm6
    vfmadd213ps ymm10, ymm13, [c_oml1]
    vblendvps ymm0, ymm14, ymm2, ymm3
    vfmadd231ps ymm8, ymm7, [c_snegl]
    vfmadd213ps ymm0, ymm13, [c_oml2]
    vmovaps [rsp + 2496], ymm10
    vfmadd213ps ymm8, ymm4, [c_tabsl]
    vandnps ymm6, ymm12, ymm5
    vandnps ymm2, ymm12, ymm9
    vandnps ymm3, ymm12, ymm1
    vmovaps [rsp + 2560], ymm0
    vmovaps ymm7, ymm8
    vfmadd231ps ymm7, ymm6, [c_rgl0]
    vmovaps ymm10, ymm8
    vfmadd231ps ymm10, ymm2, [c_rgl1]
    vfmadd231ps ymm8, ymm3, [c_rgl2]
    vsubps ymm4, ymm6, ymm7
    vsubps ymm5, ymm2, ymm10
    vsubps ymm9, ymm3, ymm8
    vcmpps ymm1, ymm4, ymm15, 30
    vrcpps ymm0, ymm4
    vmovaps [rsp + 288], ymm1
    vandnps ymm4, ymm1, ymm7
    vaddps ymm6, ymm6, ymm4
    vmulps ymm4, ymm7, ymm0
    vcmpps ymm7, ymm5, ymm15, 30
    vrcpps ymm0, ymm5
    vsubps ymm5, ymm11, [r14 + 608]
    vmovaps [rsp + 2592], ymm6
    vblendvps ymm6, ymm14, ymm4, ymm1
    vmovaps [rsp + 320], ymm7
    vandnps ymm4, ymm7, ymm10
    vaddps ymm1, ymm2, ymm4
    vmulps ymm2, ymm10, ymm0
    vcmpps ymm4, ymm9, ymm15, 30
    vrcpps ymm10, ymm9
    vmovups ymm0, [c_anegh]
    vfmadd213ps ymm6, ymm13, [c_oml0]
    vmovaps [rsp + 2656], ymm1
    vandnps ymm9, ymm4, ymm8
    vblendvps ymm1, ymm14, ymm2, ymm7
    vmovaps [rsp + 352], ymm4
    vaddps ymm2, ymm3, ymm9
    vrsqrtps ymm7, ymm5
    vmovups ymm3, [r14 + 512]
    vmulps ymm9, ymm8, ymm10
    vmovups ymm8, [r14 + 544]
    vmovaps [rsp + 2624], ymm6
    vfmadd213ps ymm1, ymm13, [c_oml1]
    vmovups ymm10, [r14 + 576]
    vmovaps [rsp + 2720], ymm2
    vblendvps ymm6, ymm14, ymm9, ymm4
    vfmadd231ps ymm0, ymm7, [c_snegh]
    vmovaps [rsp + 2688], ymm1
    vfmadd213ps ymm6, ymm13, [c_oml2]
    vandnps ymm2, ymm12, ymm3
    vfmadd213ps ymm0, ymm5, [c_tabsh]
    vandnps ymm9, ymm12, ymm8
    vandnps ymm4, ymm12, ymm10
    vmovaps [rsp + 2752], ymm6
    vmovaps ymm7, ymm0
    vfmadd231ps ymm7, ymm2, [c_rgh0]
    vmovaps ymm1, ymm0
    vfmadd231ps ymm1, ymm9, [c_rgh1]
    vfmadd231ps ymm0, ymm4, [c_rgh2]
    vsubps ymm3, ymm2, ymm7
    vsubps ymm5, ymm9, ymm1
    vsubps ymm8, ymm4, ymm0
    vcmpps ymm10, ymm3, ymm15, 30
    vrcpps ymm6, ymm3
    vmovaps [rsp + 384], ymm10
    vandnps ymm3, ymm10, ymm7
    vaddps ymm2, ymm2, ymm3
    vmulps ymm3, ymm7, ymm6
    vcmpps ymm7, ymm5, ymm15, 30
    vrcpps ymm6, ymm5
    vcmpps ymm5, ymm8, ymm15, 30
    vmovaps [rsp + 2784], ymm2
    vrcpps ymm2, ymm8
    vblendvps ymm8, ymm14, ymm3, ymm10
    vmovaps [rsp + 416], ymm7
    vandnps ymm3, ymm7, ymm1
    vaddps ymm10, ymm9, ymm3
    vmulps ymm9, ymm1, ymm6
    vmovaps [rsp + 448], ymm5
    vandnps ymm3, ymm5, ymm0
    vfmadd213ps ymm8, ymm13, [c_omh0]
    vaddps ymm1, ymm4, ymm3
    vmovaps [rsp + 2848], ymm10
    vmulps ymm6, ymm0, ymm2
    vblendvps ymm4, ymm14, ymm9, ymm7
    vmovaps [rsp + 2912], ymm1
    vmovaps [rsp + 2816], ymm8
    vfmadd213ps ymm4, ymm13, [c_omh1]
    vblendvps ymm3, ymm14, ymm6, ymm5
    vfmadd213ps ymm3, ymm13, [c_omh2]
    vmovaps [rsp + 2880], ymm4
    vmovaps [rsp + 2944], ymm3
    vmovups ymm15, [c_kh4]
    vmovups ymm14, [c_kh5]
    vmovups ymm13, [c_kh0]
    vmovups ymm12, [c_kh1]
    vmovups ymm0, [r4 + SPBC]
    jmp .j256
.j256:
    vmovups ymm1, [r5]
    vmovups ymm2, [r5 + SPBC]
    vmovups ymm3, [r7]
    vsubps ymm4, ymm0, [r7 + SPBC]
    vaddps ymm5, ymm0, ymm3
    vaddps ymm6, ymm1, ymm2
    vsubps ymm7, ymm0, ymm3
    vsubps ymm8, ymm1, ymm2
    vmovups ymm9, [r4 + 32 + SPBC]
    vmulps ymm10, ymm5, ymm13
    vsubps ymm11, ymm0, ymm2
    vsubps ymm5, ymm3, [r4]
    vmovups ymm0, [r5 + 32]
    vmulps ymm2, ymm7, [c_kh2]
    vsubps ymm7, ymm3, ymm1
    vmovups ymm3, [r5 + 32 + SPBC]
    vfmadd231ps ymm10, ymm6, ymm12
    vmovups ymm1, [r7 + 32]
    vfmadd231ps ymm2, ymm8, [c_kh3]
    vsubps ymm6, ymm10, ymm2
    vaddps ymm8, ymm10, ymm2
    vaddps ymm10, ymm0, ymm3
    vfmadd213ps ymm11, ymm15, ymm6
    vfmadd213ps ymm7, ymm15, ymm8
    vfnmadd231ps ymm11, ymm5, ymm14
    vfnmadd231ps ymm7, ymm4, ymm14
    vaddps ymm2, ymm9, ymm1
    vsubps ymm5, ymm9, ymm1
    vsubps ymm4, ymm0, ymm3
    vmulps ymm2, ymm2, ymm13
    vfmadd231ps ymm2, ymm10, ymm12
    vmulps ymm10, ymm5, [c_kh2]
    vsubps ymm5, ymm9, ymm3
    vsubps ymm3, ymm1, ymm0
    vsubps ymm0, ymm1, [r4 + 32]
    vsubps ymm1, ymm9, [r7 + 32 + SPBC]
    vfmadd231ps ymm10, ymm4, [c_kh3]
    vmovups ymm9, [r1 + r3*4]
    vsubps ymm4, ymm2, ymm10
    vaddps ymm2, ymm2, ymm10
    vfmadd213ps ymm5, ymm15, ymm4
    vfmadd213ps ymm3, ymm15, ymm2
    vpaddw ymm10, ymm9, [c_n64w]
    vpmaddwd ymm9, ymm10, [c_onesw]
    vfnmadd231ps ymm5, ymm0, ymm14
    vfnmadd231ps ymm3, ymm1, ymm14
    vmovups ymm10, [r1 + r3*4 + 2*W]
    vcvtdq2ps ymm0, ymm9
    vmovaps ymm1, ymm0
    vfmadd231ps ymm1, ymm5, [c_xgcr]
    vfmadd132ps ymm5, ymm0, [c_xrcr]
    vfmadd231ps ymm0, ymm11, [c_xbcb]
    vpaddw ymm9, ymm10, [c_n64w]
    vfmadd231ps ymm1, ymm11, [c_xgcb]
    vmovaps [rsp + 480], ymm5
    vpmaddwd ymm10, ymm9, [c_onesw]
    vmovaps [rsp + 544], ymm0
    vmovups ymm11, [r1 + r3*4 + 2*W*2]
    vcvtdq2ps ymm5, ymm10
    vmovaps [rsp + 512], ymm1
    vmovaps ymm9, ymm5
    vfmadd231ps ymm9, ymm4, [c_xgcr]
    vfmadd132ps ymm4, ymm5, [c_xrcr]
    vfmadd231ps ymm5, ymm6, [c_xbcb]
    vmovups ymm0, [r1 + r3*4 + 2*W*3]
    vpaddw ymm10, ymm11, [c_n64w]
    vpmaddwd ymm1, ymm10, [c_onesw]
    vfmadd231ps ymm9, ymm6, [c_xgcb]
    vmovaps [rsp + 576], ymm4
    vmovaps [rsp + 640], ymm5
    vcvtdq2ps ymm11, ymm1
    vmovaps [rsp + 608], ymm9
    vpaddw ymm10, ymm0, [c_n64w]
    vmovaps ymm6, ymm11
    vfmadd231ps ymm6, ymm2, [c_xgcr]
    vfmadd132ps ymm2, ymm11, [c_xrcr]
    vfmadd231ps ymm11, ymm8, [c_xbcb]
    vpmaddwd ymm4, ymm10, [c_onesw]
    vmovups ymm5, [r4 + 64 + SPBC]
    vmovups ymm1, [r5 + 64]
    vmovups ymm9, [r5 + 64 + SPBC]
    vmovups ymm0, [r7 + 64]
    vfmadd231ps ymm6, ymm8, [c_xgcb]
    vmovaps [rsp + 672], ymm2
    vcvtdq2ps ymm10, ymm4
    vmovaps [rsp + 736], ymm11
    vmovaps ymm8, ymm10
    vfmadd231ps ymm8, ymm3, [c_xgcr]
    vfmadd132ps ymm3, ymm10, [c_xrcr]
    vmovaps [rsp + 704], ymm6
    vfmadd231ps ymm10, ymm7, [c_xbcb]
    vaddps ymm2, ymm5, ymm0
    vaddps ymm4, ymm1, ymm9
    vfmadd231ps ymm8, ymm7, [c_xgcb]
    vmovaps [rsp + 768], ymm3
    vsubps ymm11, ymm5, ymm0
    vsubps ymm6, ymm1, ymm9
    vmovaps [rsp + 832], ymm10
    vmulps ymm7, ymm2, ymm13
    vsubps ymm3, ymm5, ymm9
    vsubps ymm10, ymm0, [r4 + 64]
    vmulps ymm2, ymm11, [c_kh2]
    vsubps ymm9, ymm0, ymm1
    vsubps ymm11, ymm5, [r7 + 64 + SPBC]
    vmovups ymm0, [r4 + 96 + SPBC]
    vmovups ymm1, [r5 + 96]
    vmovaps [rsp + 800], ymm8
    vfmadd231ps ymm7, ymm4, ymm12
    vmovups ymm5, [r5 + 96 + SPBC]
    vmovups ymm8, [r7 + 96]
    vfmadd231ps ymm2, ymm6, [c_kh3]
    vsubps ymm4, ymm7, ymm2
    vaddps ymm6, ymm7, ymm2
    vfmadd213ps ymm3, ymm15, ymm4
    vfmadd213ps ymm9, ymm15, ymm6
    vaddps ymm7, ymm0, ymm8
    vmulps ymm2, ymm7, ymm13
    vfnmadd231ps ymm3, ymm10, ymm14
    vfnmadd231ps ymm9, ymm11, ymm14
    vaddps ymm7, ymm1, ymm5
    vsubps ymm10, ymm0, ymm8
    vsubps ymm11, ymm1, ymm5
    vfmadd231ps ymm2, ymm7, ymm12
    vmulps ymm7, ymm10, [c_kh2]
    vsubps ymm10, ymm0, ymm5
    vsubps ymm5, ymm8, ymm1
    vsubps ymm1, ymm8, [r4 + 96]
    vsubps ymm8, ymm0, [r7 + 96 + SPBC]
    jmp .j384
.j384:
    vfmadd231ps ymm7, ymm11, [c_kh3]
    vmovups ymm0, [r1 + r3*4]
    vsubps ymm11, ymm2, ymm7
    vaddps ymm2, ymm2, ymm7
    vfmadd213ps ymm10, ymm15, ymm11
    vfmadd213ps ymm5, ymm15, ymm2
    vpaddw ymm7, ymm0, [c_n64w]
    vpsrad ymm0, ymm7, 16
    vcvtdq2ps ymm7, ymm0
    vfnmadd231ps ymm10, ymm1, ymm14
    vfnmadd231ps ymm5, ymm8, ymm14
    vmovups ymm0, [r1 + r3*4 + 2*W]
    vmovaps ymm1, ymm7
    vfmadd231ps ymm1, ymm10, [c_xgcr]
    vfmadd132ps ymm10, ymm7, [c_xrcr]
    vfmadd231ps ymm7, ymm3, [c_xbcb]
    vpaddw ymm8, ymm0, [c_n64w]
    vfmadd231ps ymm1, ymm3, [c_xgcb]
    vmovaps [rsp + 864], ymm10
    vpsrad ymm0, ymm8, 16
    vmovups ymm3, [r1 + r3*4 + 2*W*2]
    vmovaps [rsp + 928], ymm7
    vcvtdq2ps ymm10, ymm0
    vmovaps [rsp + 896], ymm1
    vmovaps ymm8, ymm10
    vfmadd231ps ymm8, ymm11, [c_xgcr]
    vfmadd132ps ymm11, ymm10, [c_xrcr]
    vfmadd231ps ymm10, ymm4, [c_xbcb]
    vmovups ymm7, [r1 + r3*4 + 2*W*3]
    vpaddw ymm0, ymm3, [c_n64w]
    vfmadd231ps ymm8, ymm4, [c_xgcb]
    vmovaps [rsp + 960], ymm11
    vpsrad ymm1, ymm0, 16
    vmovaps [rsp + 1024], ymm10
    vcvtdq2ps ymm3, ymm1
    vmovaps [rsp + 992], ymm8
    vmovaps ymm4, ymm3
    vfmadd231ps ymm4, ymm2, [c_xgcr]
    vfmadd132ps ymm2, ymm3, [c_xrcr]
    vfmadd231ps ymm3, ymm6, [c_xbcb]
    vpaddw ymm11, ymm7, [c_n64w]
    vpsrad ymm0, ymm11, 16
    vmovups ymm10, [r4 + 128 + SPBC]
    vmovups ymm1, [r5 + 128]
    vcvtdq2ps ymm8, ymm0
    vmovups ymm7, [r5 + 128 + SPBC]
    vmovups ymm11, [r7 + 128]
    vfmadd231ps ymm4, ymm6, [c_xgcb]
    vmovaps [rsp + 1056], ymm2
    vmovaps [rsp + 1120], ymm3
    vmovaps ymm0, ymm8
    vfmadd231ps ymm0, ymm5, [c_xgcr]
    vfmadd132ps ymm5, ymm8, [c_xrcr]
    vfmadd231ps ymm8, ymm9, [c_xbcb]
    vmovaps [rsp + 1088], ymm4
    vfmadd231ps ymm0, ymm9, [c_xgcb]
    vmovaps [rsp + 1152], ymm5
    vaddps ymm6, ymm10, ymm11
    vaddps ymm2, ymm1, ymm7
    vmovaps [rsp + 1216], ymm8
    vsubps ymm3, ymm10, ymm11
    vsubps ymm4, ymm1, ymm7
    vmulps ymm9, ymm6, ymm13
    vsubps ymm5, ymm10, ymm7
    vsubps ymm8, ymm11, [r4 + 128]
    vmovups ymm6, [r4 + 160 + SPBC]
    vmulps ymm7, ymm3, [c_kh2]
    vsubps ymm3, ymm11, ymm1
    vsubps ymm11, ymm10, [r7 + 128 + SPBC]
    vmovaps [rsp + 1184], ymm0
    vmovups ymm1, [r5 + 160]
    vmovups ymm10, [r5 + 160 + SPBC]
    vfmadd231ps ymm9, ymm2, ymm12
    vmovups ymm0, [r7 + 160]
    vfmadd231ps ymm7, ymm4, [c_kh3]
    vsubps ymm2, ymm9, ymm7
    vaddps ymm4, ymm9, ymm7
    vaddps ymm9, ymm1, ymm10
    vfmadd213ps ymm5, ymm15, ymm2
    vfmadd213ps ymm3, ymm15, ymm4
    vfnmadd231ps ymm5, ymm8, ymm14
    vfnmadd231ps ymm3, ymm11, ymm14
    vaddps ymm7, ymm6, ymm0
    vsubps ymm8, ymm6, ymm0
    vsubps ymm11, ymm1, ymm10
    vmulps ymm7, ymm7, ymm13
    vfmadd231ps ymm7, ymm9, ymm12
    vmulps ymm9, ymm8, [c_kh2]
    vsubps ymm8, ymm6, ymm10
    vsubps ymm10, ymm0, ymm1
    vsubps ymm1, ymm0, [r4 + 160]
    vsubps ymm0, ymm6, [r7 + 160 + SPBC]
    vfmadd231ps ymm9, ymm11, [c_kh3]
    vmovups ymm6, [r1 + r3*4 + 32]
    vsubps ymm11, ymm7, ymm9
    vaddps ymm7, ymm7, ymm9
    vfmadd213ps ymm8, ymm15, ymm11
    vfmadd213ps ymm10, ymm15, ymm7
    vpaddw ymm9, ymm6, [c_n64w]
    vpmaddwd ymm6, ymm9, [c_onesw]
    vfnmadd231ps ymm8, ymm1, ymm14
    vfnmadd231ps ymm10, ymm0, ymm14
    vmovups ymm9, [r1 + r3*4 + 32 + 2*W]
    vcvtdq2ps ymm1, ymm6
    vmovaps ymm0, ymm1
    vfmadd231ps ymm0, ymm8, [c_xgcr]
    vfmadd132ps ymm8, ymm1, [c_xrcr]
    vfmadd231ps ymm1, ymm5, [c_xbcb]
    vpaddw ymm6, ymm9, [c_n64w]
    vfmadd231ps ymm0, ymm5, [c_xgcb]
    vmovaps [rsp + 1248], ymm8
    vpmaddwd ymm9, ymm6, [c_onesw]
    vmovaps [rsp + 1312], ymm1
    vmovups ymm5, [r1 + r3*4 + 32 + 2*W*2]
    vcvtdq2ps ymm8, ymm9
    vmovaps [rsp + 1280], ymm0
    vmovaps ymm6, ymm8
    vfmadd231ps ymm6, ymm11, [c_xgcr]
    vfmadd132ps ymm11, ymm8, [c_xrcr]
    vfmadd231ps ymm8, ymm2, [c_xbcb]
    vmovups ymm1, [r1 + r3*4 + 32 + 2*W*3]
    vpaddw ymm9, ymm5, [c_n64w]
    vpmaddwd ymm0, ymm9, [c_onesw]
    vfmadd231ps ymm6, ymm2, [c_xgcb]
    vmovaps [rsp + 1344], ymm11
    vmovaps [rsp + 1408], ymm8
    vcvtdq2ps ymm5, ymm0
    vmovaps [rsp + 1376], ymm6
    jmp .j512
.j512:
    vpaddw ymm9, ymm1, [c_n64w]
    vmovaps ymm2, ymm5
    vfmadd231ps ymm2, ymm7, [c_xgcr]
    vfmadd132ps ymm7, ymm5, [c_xrcr]
    vfmadd231ps ymm5, ymm4, [c_xbcb]
    vpmaddwd ymm11, ymm9, [c_onesw]
    vmovups ymm8, [r4 + 192 + SPBC]
    vmovups ymm0, [r5 + 192]
    vmovups ymm6, [r5 + 192 + SPBC]
    vmovups ymm1, [r7 + 192]
    vfmadd231ps ymm2, ymm4, [c_xgcb]
    vmovaps [rsp + 1440], ymm7
    vcvtdq2ps ymm9, ymm11
    vmovaps [rsp + 1504], ymm5
    vmovaps ymm4, ymm9
    vfmadd231ps ymm4, ymm10, [c_xgcr]
    vfmadd132ps ymm10, ymm9, [c_xrcr]
    vmovaps [rsp + 1472], ymm2
    vfmadd231ps ymm9, ymm3, [c_xbcb]
    vaddps ymm7, ymm8, ymm1
    vaddps ymm11, ymm0, ymm6
    vfmadd231ps ymm4, ymm3, [c_xgcb]
    vmovaps [rsp + 1536], ymm10
    vsubps ymm5, ymm8, ymm1
    vsubps ymm2, ymm0, ymm6
    vmovaps [rsp + 1600], ymm9
    vmulps ymm3, ymm7, ymm13
    vsubps ymm10, ymm8, ymm6
    vsubps ymm9, ymm1, [r4 + 192]
    vmulps ymm7, ymm5, [c_kh2]
    vsubps ymm6, ymm1, ymm0
    vsubps ymm5, ymm8, [r7 + 192 + SPBC]
    vmovups ymm1, [r4 + 224 + SPBC]
    vmovups ymm0, [r5 + 224]
    vmovaps [rsp + 1568], ymm4
    vfmadd231ps ymm3, ymm11, ymm12
    vmovups ymm8, [r5 + 224 + SPBC]
    vmovups ymm4, [r7 + 224]
    vfmadd231ps ymm7, ymm2, [c_kh3]
    vsubps ymm11, ymm3, ymm7
    vaddps ymm2, ymm3, ymm7
    vfmadd213ps ymm10, ymm15, ymm11
    vfmadd213ps ymm6, ymm15, ymm2
    vaddps ymm3, ymm1, ymm4
    vmulps ymm7, ymm3, ymm13
    vfnmadd231ps ymm10, ymm9, ymm14
    vfnmadd231ps ymm6, ymm5, ymm14
    vaddps ymm3, ymm0, ymm8
    vsubps ymm9, ymm1, ymm4
    vsubps ymm5, ymm0, ymm8
    vfmadd231ps ymm7, ymm3, ymm12
    vmulps ymm3, ymm9, [c_kh2]
    vsubps ymm9, ymm1, ymm8
    vsubps ymm8, ymm4, ymm0
    vsubps ymm0, ymm4, [r4 + 224]
    vsubps ymm4, ymm1, [r7 + 224 + SPBC]
    vfmadd231ps ymm3, ymm5, [c_kh3]
    vmovups ymm1, [r1 + r3*4 + 32]
    vsubps ymm5, ymm7, ymm3
    vaddps ymm7, ymm7, ymm3
    vfmadd213ps ymm9, ymm15, ymm5
    vfmadd213ps ymm8, ymm15, ymm7
    vpaddw ymm3, ymm1, [c_n64w]
    vpsrad ymm1, ymm3, 16
    vcvtdq2ps ymm3, ymm1
    vfnmadd231ps ymm9, ymm0, ymm14
    vfnmadd231ps ymm8, ymm4, ymm14
    vmovups ymm1, [r1 + r3*4 + 32 + 2*W]
    vmovaps ymm0, ymm3
    vfmadd231ps ymm0, ymm9, [c_xgcr]
    vfmadd132ps ymm9, ymm3, [c_xrcr]
    vfmadd231ps ymm3, ymm10, [c_xbcb]
    vpaddw ymm4, ymm1, [c_n64w]
    vfmadd231ps ymm0, ymm10, [c_xgcb]
    vmovaps [rsp + 1632], ymm9
    vpsrad ymm1, ymm4, 16
    vmovups ymm10, [r1 + r3*4 + 32 + 2*W*2]
    vmovaps [rsp + 1696], ymm3
    vcvtdq2ps ymm9, ymm1
    vmovaps [rsp + 1664], ymm0
    vmovaps ymm4, ymm9
    vfmadd231ps ymm4, ymm5, [c_xgcr]
    vfmadd132ps ymm5, ymm9, [c_xrcr]
    vfmadd231ps ymm9, ymm11, [c_xbcb]
    vmovups ymm3, [r1 + r3*4 + 32 + 2*W*3]
    vpaddw ymm1, ymm10, [c_n64w]
    vfmadd231ps ymm4, ymm11, [c_xgcb]
    vmovaps [rsp + 1728], ymm5
    vpsrad ymm0, ymm1, 16
    vmovaps [rsp + 1792], ymm9
    vcvtdq2ps ymm10, ymm0
    vmovaps [rsp + 1760], ymm4
    vmovaps ymm11, ymm10
    vfmadd231ps ymm11, ymm7, [c_xgcr]
    vfmadd132ps ymm7, ymm10, [c_xrcr]
    vfmadd231ps ymm10, ymm2, [c_xbcb]
    vpaddw ymm5, ymm3, [c_n64w]
    vpsrad ymm1, ymm5, 16
    vcvtdq2ps ymm9, ymm1
    vfmadd231ps ymm11, ymm2, [c_xgcb]
    vmovaps [rsp + 1824], ymm7
    vmovaps [rsp + 1888], ymm10
    vmovaps ymm0, ymm9
    vfmadd231ps ymm0, ymm8, [c_xgcr]
    vfmadd132ps ymm8, ymm9, [c_xrcr]
    vfmadd231ps ymm9, ymm6, [c_xbcb]
    vmovaps [rsp + 1856], ymm11
    vfmadd231ps ymm0, ymm6, [c_xgcb]
    vmovaps [rsp + 1920], ymm8
    vmovaps [rsp + 1984], ymm9
    vmovaps [rsp + 1952], ymm0
    vmovups ymm15, [c_sign]
    vmovups ymm14, [c_one]
    vmovups ymm13, [c_q8o0]
    vmovups ymm0, [rsp + 2144]
    vmaxps ymm1, ymm0, [c_xlo]
    vpsrld ymm2, ymm1, 23
    vpsrld ymm3, ymm1, 20
    vpslld ymm4, ymm1, 5
    vpslld ymm5, ymm1, 4
    vpermps ymm6, ymm2, [c_to]
    vpermps ymm7, ymm2, [c_to + 32]
    vpermps ymm8, ymm2, [c_to + 64]
    vpslld ymm9, ymm1, 9
    vpermps ymm10, ymm2, [c_to + 96]
    vpermps ymm11, ymm3, [c_w8o]
    vpsrld ymm12, ymm9, 9
    vpermps ymm0, ymm3, [c_r8o]
    jmp .j640
.j640:
    vorps ymm1, ymm12, ymm14
    vmovups ymm2, [rsp + 2016]
    vblendvps ymm9, ymm6, ymm7, ymm4
    vblendvps ymm3, ymm8, ymm10, ymm4
    vfmsub213ps ymm1, ymm0, ymm14
    vblendvps ymm12, ymm9, ymm3, ymm5
    vmulps ymm6, ymm12, ymm11
    vmaxps ymm7, ymm2, [c_xlo]
    vpsrld ymm8, ymm7, 23
    vpsrld ymm10, ymm7, 20
    vpslld ymm4, ymm7, 5
    vpslld ymm0, ymm7, 4
    vpermps ymm9, ymm8, [c_to]
    vpermps ymm3, ymm8, [c_to + 32]
    vpermps ymm5, ymm8, [c_to + 64]
    vpslld ymm12, ymm7, 9
    vpermps ymm11, ymm8, [c_to + 96]
    vpermps ymm2, ymm10, [c_w8o]
    vpsrld ymm7, ymm12, 9
    vmulps ymm8, ymm6, ymm1
    vpermps ymm12, ymm10, [c_r8o]
    vorps ymm10, ymm7, ymm14
    vblendvps ymm7, ymm9, ymm3, ymm4
    vmovups ymm9, [c_q8o2]
    vblendvps ymm3, ymm5, ymm11, ymm4
    vandps ymm5, ymm15, [r14 + 64]
    vmovups ymm11, [c_slkl]
    vfmsub213ps ymm10, ymm12, ymm14
    vmovups ymm4, [rsp + 2080]
    vblendvps ymm12, ymm7, ymm3, ymm0
    vmulps ymm7, ymm12, ymm2
    vfmadd231ps ymm9, ymm1, [c_q8o3]
    vmaxps ymm3, ymm4, [c_xlo]
    vfmadd213ps ymm9, ymm1, [c_q8o1]
    vpsrld ymm0, ymm3, 23
    vpsrld ymm12, ymm3, 20
    vpslld ymm2, ymm3, 5
    vfmadd213ps ymm9, ymm1, ymm13
    vpslld ymm4, ymm3, 4
    vpslld ymm1, ymm3, 9
    vpsrld ymm3, ymm1, 9
    vorps ymm1, ymm3, ymm14
    vfmadd231ps ymm6, ymm8, ymm9
    vpermps ymm3, ymm0, [c_to]
    vpermps ymm8, ymm0, [c_to + 32]
    vmulps ymm9, ymm6, [rsp + 2176]
    vorps ymm6, ymm6, ymm5
    vblendvps ymm5, ymm3, ymm8, ymm2
    vpermps ymm3, ymm12, [c_w8o]
    vandps ymm8, ymm6, [rsp + 64]
    vpermps ymm6, ymm12, [c_r8o]
    vmulps ymm12, ymm8, [c_mtl2]
    vfmadd231ps ymm11, ymm9, [c_mtl2]
    vpermps ymm8, ymm0, [c_to + 64]
    vpermps ymm9, ymm0, [c_to + 96]
    vfmsub213ps ymm1, ymm6, ymm14
    vmovups ymm0, [c_q8o2]
    vblendvps ymm6, ymm8, ymm9, ymm2
    vmulps ymm8, ymm7, ymm10
    vandps ymm9, ymm15, [r14]
    vblendvps ymm2, ymm5, ymm6, ymm4
    vmovups ymm5, [rsp + 2528]
    vmulps ymm6, ymm2, ymm3
    vfmadd231ps ymm0, ymm10, [c_q8o3]
    vfmadd213ps ymm0, ymm10, [c_q8o1]
    vmaxps ymm4, ymm5, [c_xlo]
    vpsrld ymm2, ymm4, 23
    vpsrld ymm3, ymm4, 20
    vfmadd213ps ymm0, ymm10, ymm13
    vpslld ymm5, ymm4, 5
    vfmadd231ps ymm7, ymm8, ymm0
    vpslld ymm10, ymm4, 4
    vpermps ymm8, ymm2, [c_to]
    vpslld ymm0, ymm4, 9
    vpsrld ymm4, ymm0, 9
    vorps ymm0, ymm4, ymm14
    vmulps ymm4, ymm7, [rsp + 2048]
    vorps ymm7, ymm7, ymm9
    vandps ymm9, ymm7, [rsp]
    vfmadd231ps ymm12, ymm9, [c_mtl0]
    vpermps ymm7, ymm2, [c_to + 32]
    vfmadd231ps ymm11, ymm4, [c_mtl0]
    vpermps ymm9, ymm2, [c_to + 64]
    vpermps ymm4, ymm2, [c_to + 96]
    vblendvps ymm2, ymm8, ymm7, ymm5
    vpermps ymm8, ymm3, [c_w8o]
    vpermps ymm7, ymm3, [c_r8o]
    vblendvps ymm3, ymm9, ymm4, ymm5
    vmovups ymm9, [c_q8o2]
    vmulps ymm4, ymm6, ymm1
    vblendvps ymm5, ymm2, ymm3, ymm10
    vfmsub213ps ymm0, ymm7, ymm14
    vandps ymm2, ymm15, [r14 + 32]
    vmulps ymm3, ymm5, ymm8
    vfmadd231ps ymm9, ymm1, [c_q8o3]
    vfmadd213ps ymm9, ymm1, [c_q8o1]
    vmovups ymm10, [rsp + 2400]
    vfmadd213ps ymm9, ymm1, ymm13
    vfmadd231ps ymm6, ymm4, ymm9
    vmaxps ymm7, ymm10, [c_xlo]
    vpsrld ymm5, ymm7, 23
    vpsrld ymm8, ymm7, 20
    vpslld ymm1, ymm7, 5
    vpslld ymm4, ymm7, 4
    vpermps ymm9, ymm5, [c_to]
    vmulps ymm10, ymm6, [rsp + 2112]
    vorps ymm6, ymm6, ymm2
    vandps ymm2, ymm6, [rsp + 32]
    vfmadd231ps ymm12, ymm2, [c_mtl1]
    vpermps ymm6, ymm5, [c_to + 32]
    vfmadd231ps ymm11, ymm10, [c_mtl1]
    vpermps ymm2, ymm5, [c_to + 64]
    vpermps ymm10, ymm5, [c_to + 96]
    vpslld ymm5, ymm7, 9
    vpsrld ymm7, ymm5, 9
    vroundps ymm5, ymm12, 8
    vblendvps ymm9, ymm9, ymm6, ymm1
    vorps ymm6, ymm7, ymm14
    vblendvps ymm7, ymm2, ymm10, ymm1
    vpermps ymm2, ymm8, [c_w8o]
    vpermps ymm10, ymm8, [c_r8o]
    vsubps ymm1, ymm12, ymm5
    vcvtps2dq ymm8, ymm12
    vmovups ymm5, [c_q8o2]
    vblendvps ymm12, ymm9, ymm7, ymm4
    vmulps ymm9, ymm3, ymm0
    vandps ymm7, ymm15, [r14 + 320]
    vandnps ymm4, ymm15, ymm1
    jmp .j768
.j768:
    vaddps ymm1, ymm4, ymm11
    vpaddd ymm4, ymm8, [c_i64]
    vfmsub213ps ymm6, ymm10, ymm14
    vmulps ymm11, ymm12, ymm2
    vmovups ymm8, [c_slkl]
    vpminsd ymm10, ymm4, [c_i1023]
    vmovups ymm12, [rsp + 2464]
    vcmpps ymm2, ymm1, [c_half], 5
    vfmadd231ps ymm5, ymm0, [c_q8o3]
    vfmadd213ps ymm5, ymm0, [c_q8o1]
    vmaxps ymm4, ymm12, [c_xlo]
    vpsrld ymm1, ymm4, 23
    vfmadd213ps ymm5, ymm0, ymm13
    vpsrld ymm12, ymm4, 20
    vfmadd231ps ymm3, ymm9, ymm5
    vpslld ymm0, ymm4, 5
    vpslld ymm9, ymm4, 4
    vpslld ymm5, ymm4, 9
    vpsrld ymm4, ymm5, 9
    vorps ymm5, ymm4, ymm14
    vmulps ymm4, ymm3, [rsp + 2560]
    vorps ymm3, ymm3, ymm7
    vandps ymm7, ymm3, [rsp + 256]
    vmulps ymm3, ymm7, [c_mtl2]
    vfmadd231ps ymm8, ymm4, [c_mtl2]
    vpermps ymm7, ymm1, [c_to]
    vpermps ymm4, ymm1, [c_to + 32]
    vblendvps ymm7, ymm7, ymm4, ymm0
    vpermps ymm4, ymm1, [c_to + 64]
    vpermps ymm1, ymm1, [c_to + 96]
    vblendvps ymm4, ymm4, ymm1, ymm0
    vpermps ymm1, ymm12, [c_w8o]
    vpermps ymm0, ymm12, [c_r8o]
    vblendvps ymm12, ymm7, ymm4, ymm9
    vmovups ymm7, [c_q8o2]
    vmulps ymm4, ymm11, ymm6
    vfmsub213ps ymm5, ymm0, ymm14
    vmulps ymm9, ymm12, ymm1
    vandps ymm0, ymm15, [r14 + 256]
    vmovups ymm12, [rsp + 2336]
    vfmadd231ps ymm7, ymm6, [c_q8o3]
    vmaxps ymm1, ymm12, [c_xlo]
    vfmadd213ps ymm7, ymm6, [c_q8o1]
    vfmadd213ps ymm7, ymm6, ymm13
    vpsrld ymm12, ymm1, 23
    vfmadd231ps ymm11, ymm4, ymm7
    vpsrld ymm6, ymm1, 20
    vpslld ymm4, ymm1, 5
    vmulps ymm7, ymm11, [rsp + 2432]
    vorps ymm11, ymm11, ymm0
    vandps ymm0, ymm11, [rsp + 192]
    vfmadd231ps ymm3, ymm0, [c_mtl0]
    vpslld ymm11, ymm1, 4
    vpslld ymm0, ymm1, 9
    vfmadd231ps ymm8, ymm7, [c_mtl0]
    vpermps ymm1, ymm12, [c_to]
    vpsrld ymm7, ymm0, 9
    vpermps ymm0, ymm12, [c_to + 32]
    vblendvps ymm1, ymm1, ymm0, ymm4
    vorps ymm0, ymm7, ymm14
    vpermps ymm7, ymm12, [c_to + 64]
    vpermps ymm12, ymm12, [c_to + 96]
    vblendvps ymm7, ymm7, ymm12, ymm4
    vpermps ymm12, ymm6, [c_w8o]
    vpermps ymm4, ymm6, [c_r8o]
    vblendvps ymm6, ymm1, ymm7, ymm11
    vmovups ymm1, [c_q8o2]
    vmulps ymm7, ymm9, ymm5
    vfmsub213ps ymm0, ymm4, ymm14
    vmulps ymm11, ymm6, ymm12
    vandps ymm4, ymm15, [r14 + 288]
    vfmadd231ps ymm1, ymm5, [c_q8o3]
    vfmadd213ps ymm1, ymm5, [c_q8o1]
    vfmadd213ps ymm1, ymm5, ymm13
    vfmadd231ps ymm9, ymm7, ymm1
    vmulps ymm6, ymm9, [rsp + 2496]
    vorps ymm12, ymm9, ymm4
    vandps ymm5, ymm12, [rsp + 224]
    vfmadd231ps ymm3, ymm5, [c_mtl1]
    vmovups ymm7, [rsp + 2208]
    vfmadd231ps ymm8, ymm6, [c_mtl1]
    vroundps ymm1, ymm3, 8
    vcvtps2dq ymm9, ymm3
    vsubps ymm4, ymm3, ymm1
    vpaddd ymm12, ymm9, [c_i64]
    vmaxps ymm5, ymm7, [c_xlo]
    vpminsd ymm6, ymm12, [c_i1023]
    vandnps ymm3, ymm15, ymm4
    vpackusdw ymm1, ymm10, ymm6
    vpsrld ymm9, ymm5, 23
    vpsrld ymm7, ymm5, 20
    vaddps ymm12, ymm3, ymm8
    vpslld ymm4, ymm5, 5
    vpermps ymm10, ymm9, [c_to]
    vpermq ymm6, ymm1, 216
    vpslld ymm3, ymm5, 4
    vpermps ymm8, ymm9, [c_to + 32]
    vcmpps ymm1, ymm12, [c_half], 5
    vpslld ymm12, ymm5, 9
    vpsrld ymm5, ymm12, 9
    vorps ymm12, ymm5, ymm14
    vmovdqu [r11], ymm6
    vpermps ymm5, ymm9, [c_to + 64]
    vpermps ymm6, ymm9, [c_to + 96]
    vblendvps ymm9, ymm10, ymm8, ymm4
    vptest ymm2, ymm2
    jnz .c0
.r0:
    vptest ymm1, ymm1
    jnz .c1
.r1:
    vmovups ymm10, [c_q8o2]
    vmulps ymm8, ymm11, ymm0
    vandps ymm2, ymm15, [r14 + 192]
    vblendvps ymm1, ymm5, ymm6, ymm4
    vpermps ymm5, ymm7, [c_w8o]
    vpermps ymm6, ymm7, [c_r8o]
    vmovups ymm4, [c_slkl]
    vblendvps ymm7, ymm9, ymm1, ymm3
    vmovups ymm9, [rsp + 2272]
    vfmsub213ps ymm12, ymm6, ymm14
    vmulps ymm1, ymm7, ymm5
    vfmadd231ps ymm10, ymm0, [c_q8o3]
    vfmadd213ps ymm10, ymm0, [c_q8o1]
    vmaxps ymm3, ymm9, [c_xlo]
    vpsrld ymm6, ymm3, 23
    vpsrld ymm7, ymm3, 20
    vpslld ymm5, ymm3, 5
    vfmadd213ps ymm10, ymm0, ymm13
    vpslld ymm9, ymm3, 4
    vpslld ymm0, ymm3, 9
    vpsrld ymm3, ymm0, 9
    jmp .j896
.j896:
    vorps ymm0, ymm3, ymm14
    vfmadd231ps ymm11, ymm8, ymm10
    vpermps ymm3, ymm6, [c_to]
    vpermps ymm8, ymm6, [c_to + 32]
    vmulps ymm10, ymm11, [rsp + 2368]
    vorps ymm11, ymm11, ymm2
    vblendvps ymm2, ymm3, ymm8, ymm5
    vpermps ymm3, ymm7, [c_w8o]
    vandps ymm8, ymm11, [rsp + 160]
    vpermps ymm11, ymm7, [c_r8o]
    vmulps ymm7, ymm8, [c_mtl2]
    vfmadd231ps ymm4, ymm10, [c_mtl2]
    vpermps ymm8, ymm6, [c_to + 64]
    vpermps ymm10, ymm6, [c_to + 96]
    vfmsub213ps ymm0, ymm11, ymm14
    vmovups ymm6, [c_q8o2]
    vblendvps ymm11, ymm8, ymm10, ymm5
    vmulps ymm8, ymm1, ymm12
    vandps ymm10, ymm15, [r14 + 128]
    vblendvps ymm5, ymm2, ymm11, ymm9
    vmovups ymm2, [rsp + 2720]
    vmulps ymm11, ymm5, ymm3
    vfmadd231ps ymm6, ymm12, [c_q8o3]
    vfmadd213ps ymm6, ymm12, [c_q8o1]
    vmaxps ymm9, ymm2, [c_xlo]
    vpsrld ymm5, ymm9, 23
    vpsrld ymm3, ymm9, 20
    vfmadd213ps ymm6, ymm12, ymm13
    vpslld ymm2, ymm9, 5
    vfmadd231ps ymm1, ymm8, ymm6
    vpslld ymm12, ymm9, 4
    vpermps ymm8, ymm5, [c_to]
    vpslld ymm6, ymm9, 9
    vpsrld ymm9, ymm6, 9
    vorps ymm6, ymm9, ymm14
    vmulps ymm9, ymm1, [rsp + 2240]
    vorps ymm1, ymm1, ymm10
    vandps ymm10, ymm1, [rsp + 96]
    vfmadd231ps ymm7, ymm10, [c_mtl0]
    vpermps ymm1, ymm5, [c_to + 32]
    vfmadd231ps ymm4, ymm9, [c_mtl0]
    vpermps ymm10, ymm5, [c_to + 64]
    vpermps ymm9, ymm5, [c_to + 96]
    vblendvps ymm5, ymm8, ymm1, ymm2
    vpermps ymm8, ymm3, [c_w8o]
    vpermps ymm1, ymm3, [c_r8o]
    vblendvps ymm3, ymm10, ymm9, ymm2
    vmovups ymm10, [c_q8o2]
    vmulps ymm9, ymm11, ymm0
    vblendvps ymm2, ymm5, ymm3, ymm12
    vfmsub213ps ymm6, ymm1, ymm14
    vandps ymm5, ymm15, [r14 + 160]
    vmulps ymm3, ymm2, ymm8
    vfmadd231ps ymm10, ymm0, [c_q8o3]
    vfmadd213ps ymm10, ymm0, [c_q8o1]
    vmovups ymm12, [rsp + 2592]
    vfmadd213ps ymm10, ymm0, ymm13
    vfmadd231ps ymm11, ymm9, ymm10
    vmaxps ymm1, ymm12, [c_xlo]
    vpsrld ymm2, ymm1, 23
    vpsrld ymm8, ymm1, 20
    vpslld ymm0, ymm1, 5
    vpslld ymm9, ymm1, 4
    vpermps ymm10, ymm2, [c_to]
    vmulps ymm12, ymm11, [rsp + 2304]
    vorps ymm11, ymm11, ymm5
    vandps ymm5, ymm11, [rsp + 128]
    vfmadd231ps ymm7, ymm5, [c_mtl1]
    vpermps ymm11, ymm2, [c_to + 32]
    vfmadd231ps ymm4, ymm12, [c_mtl1]
    vpermps ymm5, ymm2, [c_to + 64]
    vpermps ymm12, ymm2, [c_to + 96]
    vpslld ymm2, ymm1, 9
    vpsrld ymm1, ymm2, 9
    vroundps ymm2, ymm7, 8
    vblendvps ymm10, ymm10, ymm11, ymm0
    vorps ymm11, ymm1, ymm14
    vblendvps ymm1, ymm5, ymm12, ymm0
    vpermps ymm5, ymm8, [c_w8o]
    vpermps ymm12, ymm8, [c_r8o]
    vsubps ymm0, ymm7, ymm2
    vcvtps2dq ymm8, ymm7
    vmovups ymm2, [c_q8o2]
    vblendvps ymm7, ymm10, ymm1, ymm9
    vmulps ymm10, ymm3, ymm6
    vandps ymm1, ymm15, [r14 + 448]
    vandnps ymm9, ymm15, ymm0
    vaddps ymm0, ymm9, ymm4
    vpaddd ymm9, ymm8, [c_i64]
    vfmsub213ps ymm11, ymm12, ymm14
    vmulps ymm4, ymm7, ymm5
    vmovups ymm8, [c_slkl]
    vpminsd ymm12, ymm9, [c_i1023]
    vmovups ymm7, [rsp + 2656]
    vcmpps ymm5, ymm0, [c_half], 5
    vfmadd231ps ymm2, ymm6, [c_q8o3]
    vfmadd213ps ymm2, ymm6, [c_q8o1]
    vmaxps ymm9, ymm7, [c_xlo]
    vpsrld ymm0, ymm9, 23
    vfmadd213ps ymm2, ymm6, ymm13
    vpsrld ymm7, ymm9, 20
    vfmadd231ps ymm3, ymm10, ymm2
    vpslld ymm6, ymm9, 5
    vpslld ymm10, ymm9, 4
    vpslld ymm2, ymm9, 9
    vpsrld ymm9, ymm2, 9
    vorps ymm2, ymm9, ymm14
    vmulps ymm9, ymm3, [rsp + 2752]
    vorps ymm3, ymm3, ymm1
    vandps ymm1, ymm3, [rsp + 352]
    vmulps ymm3, ymm1, [c_mtl2]
    vfmadd231ps ymm8, ymm9, [c_mtl2]
    vpermps ymm1, ymm0, [c_to]
    vpermps ymm9, ymm0, [c_to + 32]
    vblendvps ymm1, ymm1, ymm9, ymm6
    vpermps ymm9, ymm0, [c_to + 64]
    vpermps ymm0, ymm0, [c_to + 96]
    vblendvps ymm9, ymm9, ymm0, ymm6
    vpermps ymm0, ymm7, [c_w8o]
    vpermps ymm6, ymm7, [c_r8o]
    vblendvps ymm7, ymm1, ymm9, ymm10
    vmovups ymm1, [c_q8o2]
    vmulps ymm9, ymm4, ymm11
    vfmsub213ps ymm2, ymm6, ymm14
    vmulps ymm10, ymm7, ymm0
    vandps ymm6, ymm15, [r14 + 384]
    vmovups ymm7, [rsp + 2784]
    vfmadd231ps ymm1, ymm11, [c_q8o3]
    jmp .j1024
.j1024:
    vmaxps ymm0, ymm7, [c_xlo]
    vfmadd213ps ymm1, ymm11, [c_q8o1]
    vfmadd213ps ymm1, ymm11, ymm13
    vpsrld ymm7, ymm0, 23
    vfmadd231ps ymm4, ymm9, ymm1
    vpsrld ymm11, ymm0, 20
    vpslld ymm9, ymm0, 5
    vmulps ymm1, ymm4, [rsp + 2624]
    vorps ymm4, ymm4, ymm6
    vandps ymm6, ymm4, [rsp + 288]
    vfmadd231ps ymm3, ymm6, [c_mtl0]
    vpslld ymm4, ymm0, 4
    vpslld ymm6, ymm0, 9
    vfmadd231ps ymm8, ymm1, [c_mtl0]
    vpermps ymm0, ymm7, [c_to]
    vpsrld ymm1, ymm6, 9
    vpermps ymm6, ymm7, [c_to + 32]
    vblendvps ymm0, ymm0, ymm6, ymm9
    vorps ymm6, ymm1, ymm14
    vpermps ymm1, ymm7, [c_to + 64]
    vpermps ymm7, ymm7, [c_to + 96]
    vblendvps ymm1, ymm1, ymm7, ymm9
    vpermps ymm7, ymm11, [c_w8o]
    vpermps ymm9, ymm11, [c_r8o]
    vblendvps ymm11, ymm0, ymm1, ymm4
    vmovups ymm0, [c_q8o2]
    vmulps ymm1, ymm10, ymm2
    vfmsub213ps ymm6, ymm9, ymm14
    vmulps ymm4, ymm11, ymm7
    vandps ymm9, ymm15, [r14 + 416]
    vfmadd231ps ymm0, ymm2, [c_q8o3]
    vfmadd213ps ymm0, ymm2, [c_q8o1]
    vfmadd213ps ymm0, ymm2, ymm13
    vfmadd231ps ymm10, ymm1, ymm0
    vmulps ymm11, ymm10, [rsp + 2688]
    vorps ymm7, ymm10, ymm9
    vandps ymm2, ymm7, [rsp + 320]
    vfmadd231ps ymm3, ymm2, [c_mtl1]
    vmovups ymm1, [rsp + 2848]
    vfmadd231ps ymm8, ymm11, [c_mtl1]
    vroundps ymm0, ymm3, 8
    vcvtps2dq ymm10, ymm3
    vsubps ymm9, ymm3, ymm0
    vpaddd ymm7, ymm10, [c_i64]
    vmaxps ymm2, ymm1, [c_xlo]
    vpminsd ymm11, ymm7, [c_i1023]
    vandnps ymm3, ymm15, ymm9
    vpackusdw ymm0, ymm12, ymm11
    vpsrld ymm10, ymm2, 23
    vpsrld ymm1, ymm2, 20
    vaddps ymm7, ymm3, ymm8
    vpslld ymm9, ymm2, 5
    vpermps ymm12, ymm10, [c_to]
    vpermq ymm11, ymm0, 216
    vpslld ymm3, ymm2, 4
    vpermps ymm8, ymm10, [c_to + 32]
    vcmpps ymm0, ymm7, [c_half], 5
    vpslld ymm7, ymm2, 9
    vpsrld ymm2, ymm7, 9
    vorps ymm7, ymm2, ymm14
    vmovdqu [r11 + W], ymm11
    vpermps ymm2, ymm10, [c_to + 64]
    vpermps ymm11, ymm10, [c_to + 96]
    vblendvps ymm10, ymm12, ymm8, ymm9
    vptest ymm5, ymm5
    jnz .c2
.r2:
    vptest ymm0, ymm0
    jnz .c3
.r3:
    vmovups ymm12, [c_q8o2]
    vmulps ymm8, ymm4, ymm6
    vandps ymm5, ymm15, [r14 + 512]
    vblendvps ymm0, ymm2, ymm11, ymm9
    vpermps ymm2, ymm1, [c_w8o]
    vpermps ymm11, ymm1, [c_r8o]
    vmovups ymm9, [rsp + 2912]
    vblendvps ymm1, ymm10, ymm0, ymm3
    vfmsub213ps ymm7, ymm11, ymm14
    vmulps ymm10, ymm1, ymm2
    vfmadd231ps ymm12, ymm6, [c_q8o3]
    vmaxps ymm0, ymm9, [c_xlo]
    vfmadd213ps ymm12, ymm6, [c_q8o1]
    vpsrld ymm3, ymm0, 23
    vpsrld ymm11, ymm0, 20
    vpslld ymm1, ymm0, 5
    vpslld ymm2, ymm0, 4
    vpslld ymm9, ymm0, 9
    vfmadd213ps ymm12, ymm6, ymm13
    vpermps ymm0, ymm3, [c_to]
    vpsrld ymm6, ymm9, 9
    vorps ymm9, ymm6, ymm14
    vfmadd231ps ymm4, ymm8, ymm12
    vpermps ymm6, ymm3, [c_to + 32]
    vpermps ymm8, ymm3, [c_to + 64]
    vpermps ymm12, ymm3, [c_to + 96]
    vmulps ymm3, ymm4, [rsp + 2816]
    vorps ymm4, ymm4, ymm5
    vblendvps ymm5, ymm0, ymm6, ymm1
    vpermps ymm0, ymm11, [c_w8o]
    vandps ymm6, ymm4, [rsp + 384]
    vblendvps ymm4, ymm8, ymm12, ymm1
    vpermps ymm8, ymm11, [c_r8o]
    vmulps ymm12, ymm10, ymm7
    vmovups ymm1, [c_q8o2]
    vblendvps ymm11, ymm5, ymm4, ymm2
    vandps ymm5, ymm15, [r14 + 544]
    vmovups ymm4, [c_q8o2]
    vfmsub231ps ymm14, ymm9, ymm8
    vmulps ymm2, ymm11, ymm0
    vandps ymm9, ymm15, [r14 + 576]
    vmulps ymm8, ymm6, [c_mth1]
    vfmadd231ps ymm1, ymm7, [c_q8o3]
    vmulps ymm11, ymm2, ymm14
    vfmadd231ps ymm4, ymm14, [c_q8o3]
    vfmadd213ps ymm1, ymm7, [c_q8o1]
    vfmadd213ps ymm4, ymm14, [c_q8o1]
    vfmadd213ps ymm1, ymm7, ymm13
    vmovups ymm0, [c_slkh0]
    vfmadd231ps ymm13, ymm4, ymm14
    vfmadd231ps ymm10, ymm12, ymm1
    vfmadd231ps ymm2, ymm11, ymm13
    vmovups ymm7, [c_slkh1]
    vfmadd231ps ymm0, ymm3, [c_mth1]
    vmulps ymm4, ymm10, [rsp + 2880]
    vorps ymm14, ymm10, ymm5
    vandps ymm12, ymm14, [rsp + 416]
    vmulps ymm1, ymm2, [rsp + 2944]
    vorps ymm11, ymm2, ymm9
    vandps ymm13, ymm11, [rsp + 448]
    vfmadd231ps ymm8, ymm12, [c_mth2]
    vfmadd231ps ymm0, ymm4, [c_mth2]
    jmp .j1152
.j1152:
    vmulps ymm10, ymm13, [c_mth5]
    vfmadd231ps ymm7, ymm1, [c_mth5]
    vfmsub231ps ymm8, ymm13, [c_mth0]
    vfmadd231ps ymm10, ymm12, [c_mth4]
    vfmadd231ps ymm0, ymm1, [c_mth0]
    vfmadd231ps ymm7, ymm4, [c_mth4]
    vfmsub231ps ymm10, ymm6, [c_mth3]
    vroundps ymm5, ymm8, 8
    vcvtps2dq ymm14, ymm8
    vfmadd231ps ymm7, ymm3, [c_mth3]
    vsubps ymm2, ymm8, ymm5
    vpaddd ymm9, ymm14, [c_i512]
    vmovups ymm11, [c_pd8]
    vpminsd ymm13, ymm9, [c_i1023]
    vroundps ymm12, ymm10, 8
    vcvtps2dq ymm1, ymm10
    vandnps ymm4, ymm15, ymm2
    vaddps ymm6, ymm4, ymm0
    vsubps ymm3, ymm10, ymm12
    vpaddd ymm8, ymm1, [c_i512]
    vcmpps ymm5, ymm6, [c_half], 5
    vpminsd ymm14, ymm8, [c_i1023]
    vandnps ymm9, ymm15, ymm3
    vpackusdw ymm2, ymm13, ymm14
    vaddps ymm4, ymm9, ymm7
    vpermd ymm0, ymm11, ymm2
    vcmpps ymm10, ymm4, [c_half], 5
    vorps ymm12, ymm5, ymm10
    vmovdqu [r6], xmm0
    CRST r6, vextracti128 [CRS r6], ymm0, 1
    vptest ymm12, ymm12
    jnz .c4
.r4:
    vmovups ymm15, [c_sign]
    vmovups ymm14, [c_one]
    vmovups ymm13, [c_q8e0]
    vmovups ymm0, [rsp + 480]
    vmovups ymm1, [rsp + 576]
    vandnps ymm2, ymm15, ymm0
    vandps ymm3, ymm0, ymm15
    vandnps ymm4, ymm15, ymm1
    vpmaxud ymm5, ymm2, [c_xflr]
    vpmaxud ymm6, ymm4, [c_xflr]
    vandps ymm7, ymm1, ymm15
    vpsrld ymm8, ymm5, 23
    vpsrld ymm9, ymm5, 20
    vmovups ymm10, [c_q8e2]
    vpmaddwd ymm11, ymm8, [c_k5e]
    vpermps ymm12, ymm9, [c_w8e]
    vpslld ymm0, ymm8, 23
    vpsrld ymm2, ymm6, 23
    vpermps ymm4, ymm9, [c_r8x]
    vpmaddwd ymm1, ymm2, [c_k5e]
    vpsrld ymm8, ymm6, 20
    vpslld ymm9, ymm2, 23
    vpsrld ymm2, ymm11, 14
    vpsrld ymm11, ymm11, 17
    vpermps ymm2, ymm2, [c_c8e]
    vpsubd ymm4, ymm4, ymm0
    vpermps ymm0, ymm11, [c_p8e]
    vfmsub213ps ymm5, ymm4, ymm14
    vpsrld ymm11, ymm1, 14
    vpsrld ymm4, ymm1, 17
    vpermps ymm1, ymm11, [c_c8e]
    vpermps ymm11, ymm4, [c_p8e]
    vpaddd ymm4, ymm2, ymm0
    vpermps ymm2, ymm8, [c_w8e]
    vpermps ymm0, ymm8, [c_r8x]
    vorps ymm8, ymm4, ymm3
    vpaddd ymm4, ymm1, ymm11
    vfmadd231ps ymm10, ymm5, [c_q8e3]
    vmovups ymm3, [rsp + 512]
    vmulps ymm1, ymm8, ymm12
    vorps ymm11, ymm4, ymm7
    vmovups ymm8, [c_q8e2]
    vpsubd ymm12, ymm0, ymm9
    vmulps ymm4, ymm11, ymm2
    vfmsub213ps ymm6, ymm12, ymm14
    vfmadd213ps ymm10, ymm5, [c_q8e1]
    vmovups ymm7, [rsp + 608]
    vmulps ymm0, ymm1, ymm5
    vandnps ymm9, ymm15, ymm3
    vandps ymm11, ymm3, ymm15
    vfmadd213ps ymm10, ymm5, ymm13
    vpmaxud ymm2, ymm9, [c_xflr]
    vfmadd231ps ymm8, ymm6, [c_q8e3]
    vpsrld ymm12, ymm2, 23
    vpsrld ymm3, ymm2, 20
    vmulps ymm5, ymm4, ymm6
    vfmadd231ps ymm1, ymm0, ymm10
    vpmaddwd ymm9, ymm12, [c_k5e]
    vpermps ymm0, ymm3, [c_w8e]
    vpslld ymm10, ymm12, 23
    vpermps ymm12, ymm3, [c_r8x]
    vfmadd213ps ymm8, ymm6, [c_q8e1]
    vpsrld ymm3, ymm9, 14
    vpsrld ymm9, ymm9, 17
    vpermps ymm3, ymm3, [c_c8e]
    vpsubd ymm12, ymm12, ymm10
    vfmadd213ps ymm8, ymm6, ymm13
    vandnps ymm10, ymm15, ymm7
    vpermps ymm6, ymm9, [c_p8e]
    vfmsub213ps ymm2, ymm12, ymm14
    vpmaxud ymm9, ymm10, [c_xflr]
    vandps ymm12, ymm7, ymm15
    vpsrld ymm10, ymm9, 23
    vfmadd231ps ymm4, ymm5, ymm8
    vpmaddwd ymm7, ymm10, [c_k5e]
    vpsrld ymm5, ymm9, 20
    vpslld ymm8, ymm10, 23
    vpaddd ymm10, ymm3, ymm6
    vpermps ymm3, ymm5, [c_w8e]
    vpermps ymm6, ymm5, [c_r8x]
    vorps ymm5, ymm10, ymm11
    vmovups ymm10, [c_q8e2]
    vmulps ymm11, ymm5, ymm0
    vpsrld ymm5, ymm7, 14
    vpsrld ymm0, ymm7, 17
    vaddps ymm7, ymm1, ymm4
    vpsubd ymm6, ymm6, ymm8
    vmovaps [rsp + 2976], ymm7
    vpermps ymm8, ymm5, [c_c8e]
    vpermps ymm5, ymm0, [c_p8e]
    vfmsub213ps ymm9, ymm6, ymm14
    vmovaps [rsp + 5024], ymm7
    vmulps ymm0, ymm11, ymm2
    vmovups ymm6, [rsp + 544]
    vfmadd231ps ymm10, ymm2, [c_q8e3]
    vpaddd ymm7, ymm8, ymm5
    vmovups ymm8, [c_q8e2]
    jmp .j1280
.j1280:
    vorps ymm5, ymm7, ymm12
    vmulps ymm7, ymm5, ymm3
    vfmadd213ps ymm10, ymm2, [c_q8e1]
    vmovups ymm12, [rsp + 640]
    vandnps ymm5, ymm15, ymm6
    vandps ymm3, ymm6, ymm15
    vpmaxud ymm6, ymm5, [c_xflr]
    vfmadd213ps ymm10, ymm2, ymm13
    vpsrld ymm5, ymm6, 23
    vfmadd231ps ymm8, ymm9, [c_q8e3]
    vfmadd231ps ymm11, ymm0, ymm10
    vpmaddwd ymm2, ymm5, [c_k5e]
    vpsrld ymm0, ymm6, 20
    vpslld ymm10, ymm5, 23
    vfmadd213ps ymm8, ymm9, [c_q8e1]
    vpmaxud ymm5, ymm1, ymm11
    vpsrld ymm1, ymm2, 14
    vpsrld ymm2, ymm2, 17
    vpermps ymm1, ymm1, [c_c8e]
    vpermps ymm2, ymm2, [c_p8e]
    vpaddd ymm1, ymm1, ymm2
    vfmadd213ps ymm8, ymm9, ymm13
    vmulps ymm2, ymm7, ymm9
    vpermps ymm9, ymm0, [c_w8e]
    vorps ymm1, ymm1, ymm3
    vpermps ymm3, ymm0, [c_r8x]
    vfmadd231ps ymm7, ymm2, ymm8
    vandnps ymm0, ymm15, ymm12
    vandps ymm2, ymm12, ymm15
    vmovups ymm8, [c_q8e2]
    vmulps ymm12, ymm1, ymm9
    vpmaxud ymm1, ymm0, [c_xflr]
    vmovups ymm9, [rsp + 864]
    vpsubd ymm0, ymm3, ymm10
    vpsrld ymm3, ymm1, 23
    vfmsub213ps ymm6, ymm0, ymm14
    vpmaddwd ymm10, ymm3, [c_k5e]
    vpslld ymm0, ymm3, 23
    vpmaxud ymm3, ymm4, ymm7
    vaddps ymm4, ymm11, ymm7
    vpsrld ymm11, ymm1, 20
    vmovaps [rsp + 3008], ymm4
    vmovaps [rsp + 5056], ymm4
    vpsrld ymm7, ymm10, 14
    vpsrld ymm4, ymm10, 17
    vfmadd231ps ymm8, ymm6, [c_q8e3]
    vpermps ymm10, ymm7, [c_c8e]
    vpermps ymm7, ymm4, [c_p8e]
    vfmadd213ps ymm8, ymm6, [c_q8e1]
    vpaddd ymm4, ymm10, ymm7
    vpermps ymm10, ymm11, [c_w8e]
    vpermps ymm7, ymm11, [c_r8x]
    vorps ymm11, ymm4, ymm2
    vmulps ymm4, ymm12, ymm6
    vfmadd213ps ymm8, ymm6, ymm13
    vandnps ymm2, ymm15, ymm9
    vandps ymm6, ymm9, ymm15
    vpsubd ymm9, ymm7, ymm0
    vmulps ymm7, ymm11, ymm10
    vpmaxud ymm0, ymm2, [c_xflr]
    vmovups ymm11, [c_q8e2]
    vfmsub213ps ymm1, ymm9, ymm14
    vpsrld ymm10, ymm0, 23
    vpsrld ymm2, ymm0, 20
    vfmadd231ps ymm12, ymm4, ymm8
    vpmaddwd ymm9, ymm10, [c_k5e]
    vpermps ymm4, ymm2, [c_w8e]
    vpslld ymm8, ymm10, 23
    vpermps ymm10, ymm2, [c_r8x]
    vpmaxud ymm2, ymm5, ymm12
    vfmadd231ps ymm11, ymm1, [c_q8e3]
    vpsrld ymm5, ymm9, 14
    vpsubd ymm10, ymm10, ymm8
    vpminsd ymm8, ymm2, [c_zero]
    vpsrld ymm2, ymm9, 17
    vpermps ymm9, ymm5, [c_c8e]
    vfmsub213ps ymm0, ymm10, ymm14
    vmulps ymm5, ymm7, ymm1
    vpermps ymm10, ymm2, [c_p8e]
    vfmadd213ps ymm11, ymm1, [c_q8e1]
    vpaddd ymm2, ymm9, ymm10
    vmovups ymm9, [rsp + 960]
    vorps ymm10, ymm2, ymm6
    vfmadd213ps ymm11, ymm1, ymm13
    vmovups ymm2, [c_q8e2]
    vmulps ymm6, ymm10, ymm4
    vfmadd231ps ymm7, ymm5, ymm11
    vmulps ymm1, ymm6, ymm0
    vmovups ymm10, [rsp + 896]
    vandnps ymm4, ymm15, ymm9
    vandps ymm5, ymm9, ymm15
    vpmaxud ymm11, ymm4, [c_xflr]
    vfmadd231ps ymm2, ymm0, [c_q8e3]
    vpmaxud ymm9, ymm3, ymm7
    vaddps ymm4, ymm12, ymm7
    vpsrld ymm3, ymm11, 23
    vpminsd ymm12, ymm9, [c_zero]
    vpmaddwd ymm7, ymm3, [c_k5e]
    vpslld ymm9, ymm3, 23
    vmovaps [rsp + 3040], ymm4
    vaddps ymm3, ymm8, ymm12
    vpsrld ymm8, ymm11, 20
    vmovaps [rsp + 5088], ymm4
    vpermps ymm12, ymm8, [c_w8e]
    vpermps ymm4, ymm8, [c_r8x]
    vmovaps [rsp + 3072], ymm3
    vfmadd213ps ymm2, ymm0, [c_q8e1]
    vmovaps [rsp + 5120], ymm3
    vpsrld ymm8, ymm7, 14
    vpsrld ymm3, ymm7, 17
    vpermps ymm7, ymm8, [c_c8e]
    vpermps ymm8, ymm3, [c_p8e]
    vpsubd ymm3, ymm4, ymm9
    vandnps ymm4, ymm15, ymm10
    vandps ymm9, ymm10, ymm15
    vfmsub213ps ymm11, ymm3, ymm14
    vfmadd213ps ymm2, ymm0, ymm13
    vpmaxud ymm10, ymm4, [c_xflr]
    vmovups ymm3, [c_q8e2]
    vpsrld ymm0, ymm10, 23
    vpaddd ymm4, ymm7, ymm8
    vpmaddwd ymm7, ymm0, [c_k5e]
    vpslld ymm8, ymm0, 23
    vorps ymm0, ymm4, ymm5
    vpsrld ymm4, ymm10, 20
    vmulps ymm5, ymm0, ymm12
    vfmadd231ps ymm6, ymm1, ymm2
    vpermps ymm0, ymm4, [c_w8e]
    jmp .j1408
.j1408:
    vmovups ymm12, [rsp + 992]
    vpsrld ymm1, ymm7, 14
    vpsrld ymm2, ymm7, 17
    vpermps ymm7, ymm4, [c_r8x]
    vpermps ymm4, ymm1, [c_c8e]
    vpermps ymm1, ymm2, [c_p8e]
    vfmadd231ps ymm3, ymm11, [c_q8e3]
    vpsubd ymm2, ymm7, ymm8
    vmulps ymm7, ymm5, ymm11
    vpaddd ymm8, ymm4, ymm1
    vfmsub213ps ymm10, ymm2, ymm14
    vmovups ymm4, [c_q8e2]
    vorps ymm1, ymm8, ymm9
    vfmadd213ps ymm3, ymm11, [c_q8e1]
    vandnps ymm2, ymm15, ymm12
    vandps ymm8, ymm12, ymm15
    vmulps ymm9, ymm1, ymm0
    vpmaxud ymm12, ymm2, [c_xflr]
    vmovups ymm1, [rsp + 928]
    vpsrld ymm0, ymm12, 23
    vfmadd213ps ymm3, ymm11, ymm13
    vpmaddwd ymm2, ymm0, [c_k5e]
    vpslld ymm11, ymm0, 23
    vfmadd231ps ymm4, ymm10, [c_q8e3]
    vfmadd231ps ymm5, ymm7, ymm3
    vpsrld ymm0, ymm2, 14
    vpsrld ymm7, ymm2, 17
    vmulps ymm3, ymm9, ymm10
    vpermps ymm2, ymm0, [c_c8e]
    vpermps ymm0, ymm7, [c_p8e]
    vfmadd213ps ymm4, ymm10, [c_q8e1]
    vaddps ymm7, ymm6, ymm5
    vpaddd ymm2, ymm2, ymm0
    vmovaps [rsp + 3104], ymm7
    vaddps ymm0, ymm7, [rsp + 5024]
    vorps ymm7, ymm2, ymm8
    vfmadd213ps ymm4, ymm10, ymm13
    vandnps ymm2, ymm15, ymm1
    vmovups ymm8, [c_q8e2]
    vpmaxud ymm10, ymm2, [c_xflr]
    vandps ymm2, ymm1, ymm15
    vmovaps [r13], ymm0
    vpsrld ymm1, ymm12, 20
    vpermps ymm0, ymm1, [c_w8e]
    vpermps ymm1, ymm1, [c_r8x]
    vfmadd231ps ymm9, ymm3, ymm4
    vpsrld ymm3, ymm10, 23
    vmulps ymm4, ymm7, ymm0
    vpmaddwd ymm7, ymm3, [c_k5e]
    vpslld ymm0, ymm3, 23
    vpsubd ymm3, ymm1, ymm11
    vpmaxud ymm1, ymm6, ymm9
    vpsrld ymm11, ymm10, 20
    vfmsub213ps ymm12, ymm3, ymm14
    vpermps ymm6, ymm11, [c_w8e]
    vpermps ymm3, ymm11, [c_r8x]
    vpsrld ymm11, ymm7, 14
    vpsrld ymm7, ymm7, 17
    vpermps ymm11, ymm11, [c_c8e]
    vpermps ymm7, ymm7, [c_p8e]
    vpsubd ymm3, ymm3, ymm0
    vfmadd231ps ymm8, ymm12, [c_q8e3]
    vfmsub213ps ymm10, ymm3, ymm14
    vmulps ymm0, ymm4, ymm12
    vpaddd ymm3, ymm11, ymm7
    vfmadd213ps ymm8, ymm12, [c_q8e1]
    vmovups ymm11, [rsp + 1024]
    vorps ymm7, ymm3, ymm2
    vmovups ymm3, [c_q8e2]
    vmulps ymm2, ymm7, ymm6
    vmovups ymm7, [rsp + 1248]
    vfmadd213ps ymm8, ymm12, ymm13
    vmulps ymm6, ymm2, ymm10
    vfmadd231ps ymm4, ymm0, ymm8
    vandnps ymm12, ymm15, ymm11
    vandps ymm0, ymm11, ymm15
    vfmadd231ps ymm3, ymm10, [c_q8e3]
    vpmaxud ymm8, ymm12, [c_xflr]
    vpsrld ymm11, ymm8, 23
    vpmaxud ymm12, ymm5, ymm4
    vaddps ymm5, ymm9, ymm4
    vpmaddwd ymm9, ymm11, [c_k5e]
    vpslld ymm4, ymm11, 23
    vfmadd213ps ymm3, ymm10, [c_q8e1]
    vmovaps [rsp + 3136], ymm5
    vaddps ymm11, ymm5, [rsp + 5056]
    vmovaps [r13 + 32], ymm11
    vpsrld ymm5, ymm9, 14
    vpsrld ymm11, ymm9, 17
    vpermps ymm9, ymm5, [c_c8e]
    vpermps ymm5, ymm11, [c_p8e]
    vfmadd213ps ymm3, ymm10, ymm13
    vandnps ymm11, ymm15, ymm7
    vpmaxud ymm10, ymm11, [c_xflr]
    vandps ymm11, ymm7, ymm15
    vpaddd ymm7, ymm9, ymm5
    vpsrld ymm9, ymm8, 20
    vfmadd231ps ymm2, ymm6, ymm3
    vpsrld ymm5, ymm10, 23
    vmovups ymm6, [c_q8e2]
    vpermps ymm3, ymm9, [c_w8e]
    vorps ymm7, ymm7, ymm0
    vpermps ymm0, ymm9, [c_r8x]
    vpmaxud ymm9, ymm1, ymm2
    vmulps ymm1, ymm7, ymm3
    vpmaddwd ymm7, ymm5, [c_k5e]
    vpslld ymm3, ymm5, 23
    vpminsd ymm5, ymm9, [c_zero]
    vpsubd ymm9, ymm0, ymm4
    vpsrld ymm0, ymm10, 20
    vfmsub213ps ymm8, ymm9, ymm14
    vpermps ymm4, ymm0, [c_w8e]
    vpermps ymm9, ymm0, [c_r8x]
    vpsrld ymm0, ymm7, 14
    vpsrld ymm7, ymm7, 17
    vpermps ymm0, ymm0, [c_c8e]
    vpermps ymm7, ymm7, [c_p8e]
    vpsubd ymm9, ymm9, ymm3
    vfmadd231ps ymm6, ymm8, [c_q8e3]
    vfmsub213ps ymm10, ymm9, ymm14
    vmulps ymm3, ymm1, ymm8
    vpaddd ymm9, ymm0, ymm7
    vfmadd213ps ymm6, ymm8, [c_q8e1]
    vmovups ymm0, [rsp + 1344]
    vorps ymm7, ymm9, ymm11
    vmulps ymm9, ymm7, ymm4
    vmovups ymm11, [c_q8e2]
    vfmadd213ps ymm6, ymm8, ymm13
    jmp .j1536
.j1536:
    vandnps ymm7, ymm15, ymm0
    vandps ymm4, ymm0, ymm15
    vfmadd231ps ymm1, ymm3, ymm6
    vpmaxud ymm8, ymm7, [c_xflr]
    vmulps ymm0, ymm9, ymm10
    vpsrld ymm3, ymm8, 23
    vpsrld ymm6, ymm8, 20
    vfmadd231ps ymm11, ymm10, [c_q8e3]
    vpmaxud ymm7, ymm12, ymm1
    vaddps ymm12, ymm2, ymm1
    vpmaddwd ymm2, ymm3, [c_k5e]
    vpslld ymm1, ymm3, 23
    vpminsd ymm3, ymm7, [c_zero]
    vfmadd213ps ymm11, ymm10, [c_q8e1]
    vmovaps [rsp + 3168], ymm12
    vaddps ymm7, ymm12, [rsp + 5088]
    vaddps ymm12, ymm5, ymm3
    vpermps ymm5, ymm6, [c_w8e]
    vpermps ymm3, ymm6, [c_r8x]
    vmovaps [r13 + 64], ymm7
    vaddps ymm6, ymm12, [rsp + 5120]
    vmovaps [rsp + 3200], ymm12
    vpsrld ymm7, ymm2, 14
    vpsrld ymm12, ymm2, 17
    vfmadd213ps ymm11, ymm10, ymm13
    vmovups ymm2, [rsp + 1280]
    vmovaps [r13 + 96], ymm6
    vpermps ymm10, ymm7, [c_c8e]
    vpermps ymm6, ymm12, [c_p8e]
    vpsubd ymm7, ymm3, ymm1
    vmovups ymm12, [c_q8e2]
    vfmsub213ps ymm8, ymm7, ymm14
    vmovups ymm3, [rsp + 1376]
    vfmadd231ps ymm9, ymm0, ymm11
    vpaddd ymm1, ymm10, ymm6
    vorps ymm7, ymm1, ymm4
    vmulps ymm0, ymm7, ymm5
    vandnps ymm11, ymm15, ymm2
    vandps ymm10, ymm2, ymm15
    vpmaxud ymm6, ymm11, [c_xflr]
    vpsrld ymm1, ymm6, 23
    vpsrld ymm4, ymm6, 20
    vfmadd231ps ymm12, ymm8, [c_q8e3]
    vpmaddwd ymm7, ymm1, [c_k5e]
    vpermps ymm5, ymm4, [c_w8e]
    vpslld ymm2, ymm1, 23
    vmulps ymm11, ymm0, ymm8
    vpermps ymm1, ymm4, [c_r8x]
    vpsrld ymm4, ymm7, 14
    vpsrld ymm7, ymm7, 17
    vpermps ymm4, ymm4, [c_c8e]
    vpsubd ymm1, ymm1, ymm2
    vfmadd213ps ymm12, ymm8, [c_q8e1]
    vpermps ymm2, ymm7, [c_p8e]
    vfmsub213ps ymm6, ymm1, ymm14
    vandnps ymm7, ymm15, ymm3
    vandps ymm1, ymm3, ymm15
    vpmaxud ymm3, ymm7, [c_xflr]
    vfmadd213ps ymm12, ymm8, ymm13
    vpsrld ymm7, ymm3, 23
    vpaddd ymm8, ymm4, ymm2
    vpmaddwd ymm4, ymm7, [c_k5e]
    vpslld ymm2, ymm7, 23
    vorps ymm7, ymm8, ymm10
    vpsrld ymm8, ymm3, 20
    vmulps ymm10, ymm7, ymm5
    vpermps ymm7, ymm8, [c_w8e]
    vpermps ymm5, ymm8, [c_r8x]
    vfmadd231ps ymm0, ymm11, ymm12
    vpsrld ymm8, ymm4, 14
    vpsrld ymm11, ymm4, 17
    vmovups ymm12, [c_q8e2]
    vpermps ymm4, ymm8, [c_c8e]
    vpermps ymm8, ymm11, [c_p8e]
    vpsubd ymm11, ymm5, ymm2
    vmulps ymm5, ymm10, ymm6
    vaddps ymm2, ymm9, ymm0
    vfmsub213ps ymm3, ymm11, ymm14
    vpaddd ymm11, ymm4, ymm8
    vmovups ymm4, [rsp + 1312]
    vmovaps [rsp + 3232], ymm2
    vorps ymm8, ymm11, ymm1
    vmovups ymm11, [c_q8e2]
    vmovaps [rsp + 5280], ymm2
    vmulps ymm1, ymm8, ymm7
    vfmadd231ps ymm12, ymm6, [c_q8e3]
    vmovups ymm2, [rsp + 1408]
    vmulps ymm8, ymm1, ymm3
    vfmadd213ps ymm12, ymm6, [c_q8e1]
    vfmadd231ps ymm11, ymm3, [c_q8e3]
    vfmadd213ps ymm12, ymm6, ymm13
    vandnps ymm7, ymm15, ymm4
    vandps ymm6, ymm4, ymm15
    vpmaxud ymm4, ymm7, [c_xflr]
    vfmadd213ps ymm11, ymm3, [c_q8e1]
    vfmadd231ps ymm10, ymm5, ymm12
    vpsrld ymm7, ymm4, 23
    vpsrld ymm5, ymm4, 20
    vfmadd213ps ymm11, ymm3, ymm13
    vandnps ymm12, ymm15, ymm2
    vpmaxud ymm3, ymm12, [c_xflr]
    vpmaxud ymm12, ymm9, ymm10
    vpmaddwd ymm9, ymm7, [c_k5e]
    vfmadd231ps ymm1, ymm8, ymm11
    vpsrld ymm8, ymm3, 23
    vandps ymm11, ymm2, ymm15
    vpslld ymm2, ymm7, 23
    vpsrld ymm7, ymm9, 14
    vpsrld ymm9, ymm9, 17
    vpermps ymm7, ymm7, [c_c8e]
    vpermps ymm9, ymm9, [c_p8e]
    vpaddd ymm7, ymm7, ymm9
    vpmaxud ymm9, ymm0, ymm1
    vaddps ymm0, ymm10, ymm1
    vpmaddwd ymm10, ymm8, [c_k5e]
    vpermps ymm1, ymm5, [c_w8e]
    vorps ymm7, ymm7, ymm6
    vpslld ymm6, ymm8, 23
    vpermps ymm8, ymm5, [c_r8x]
    vmovaps [rsp + 3264], ymm0
    vmovaps [rsp + 5312], ymm0
    vpsrld ymm5, ymm10, 14
    vpsrld ymm0, ymm10, 17
    vpermps ymm10, ymm5, [c_c8e]
    vpermps ymm5, ymm0, [c_p8e]
    vmulps ymm0, ymm7, ymm1
    vpsrld ymm7, ymm3, 20
    vpsubd ymm1, ymm8, ymm2
    jmp .j1664
.j1664:
    vpermps ymm8, ymm7, [c_w8e]
    vpermps ymm2, ymm7, [c_r8x]
    vfmsub213ps ymm4, ymm1, ymm14
    vmovups ymm7, [c_q8e2]
    vpaddd ymm1, ymm10, ymm5
    vmovups ymm10, [rsp + 1632]
    vorps ymm5, ymm1, ymm11
    vmovups ymm1, [c_q8e2]
    vpsubd ymm11, ymm2, ymm6
    vmulps ymm2, ymm5, ymm8
    vfmsub213ps ymm3, ymm11, ymm14
    vmulps ymm6, ymm0, ymm4
    vfmadd231ps ymm7, ymm4, [c_q8e3]
    vandnps ymm5, ymm15, ymm10
    vandps ymm8, ymm10, ymm15
    vmulps ymm11, ymm2, ymm3
    vpmaxud ymm10, ymm5, [c_xflr]
    vfmadd231ps ymm1, ymm3, [c_q8e3]
    vfmadd213ps ymm7, ymm4, [c_q8e1]
    vfmadd213ps ymm1, ymm3, [c_q8e1]
    vfmadd213ps ymm7, ymm4, ymm13
    vpsrld ymm5, ymm10, 23
    vfmadd213ps ymm1, ymm3, ymm13
    vmovups ymm4, [rsp + 1728]
    vfmadd231ps ymm0, ymm6, ymm7
    vpmaddwd ymm3, ymm5, [c_k5e]
    vpsrld ymm6, ymm10, 20
    vpslld ymm7, ymm5, 23
    vfmadd231ps ymm2, ymm11, ymm1
    vpsrld ymm5, ymm3, 14
    vpsrld ymm11, ymm3, 17
    vpermps ymm1, ymm6, [c_w8e]
    vpmaxud ymm3, ymm12, ymm0
    vpermps ymm12, ymm5, [c_c8e]
    vpermps ymm5, ymm11, [c_p8e]
    vpermps ymm11, ymm6, [c_r8x]
    vpminsd ymm6, ymm3, [c_zero]
    vpmaxud ymm3, ymm9, ymm2
    vaddps ymm9, ymm0, ymm2
    vandnps ymm0, ymm15, ymm4
    vandps ymm2, ymm4, ymm15
    vpminsd ymm4, ymm3, [c_zero]
    vpmaxud ymm3, ymm0, [c_xflr]
    vpaddd ymm0, ymm12, ymm5
    vmovaps [rsp + 3296], ymm9
    vaddps ymm12, ymm6, ymm4
    vpsrld ymm5, ymm3, 23
    vmovups ymm6, [c_q8e2]
    vpsubd ymm4, ymm11, ymm7
    vorps ymm11, ymm0, ymm8
    vmovaps [rsp + 5344], ymm9
    vpmaddwd ymm7, ymm5, [c_k5e]
    vpsrld ymm0, ymm3, 20
    vmovups ymm8, [rsp + 1664]
    vfmsub213ps ymm10, ymm4, ymm14
    vmulps ymm9, ymm11, ymm1
    vmovaps [rsp + 3328], ymm12
    vpermps ymm4, ymm0, [c_w8e]
    vpslld ymm11, ymm5, 23
    vmovaps [rsp + 5376], ymm12
    vpermps ymm1, ymm0, [c_r8x]
    vpsrld ymm5, ymm7, 14
    vpsrld ymm12, ymm7, 17
    vpermps ymm0, ymm5, [c_c8e]
    vpermps ymm7, ymm12, [c_p8e]
    vmulps ymm5, ymm9, ymm10
    vpsubd ymm12, ymm1, ymm11
    vfmadd231ps ymm6, ymm10, [c_q8e3]
    vmovups ymm1, [c_q8e2]
    vfmsub213ps ymm3, ymm12, ymm14
    vandnps ymm11, ymm15, ymm8
    vandps ymm12, ymm8, ymm15
    vpaddd ymm8, ymm0, ymm7
    vpmaxud ymm0, ymm11, [c_xflr]
    vmovups ymm7, [rsp + 1760]
    vorps ymm11, ymm8, ymm2
    vpsrld ymm8, ymm0, 23
    vmulps ymm2, ymm11, ymm4
    vfmadd213ps ymm6, ymm10, [c_q8e1]
    vpsrld ymm11, ymm0, 20
    vfmadd231ps ymm1, ymm3, [c_q8e3]
    vfmadd213ps ymm6, ymm10, ymm13
    vpmaddwd ymm4, ymm8, [c_k5e]
    vpslld ymm10, ymm8, 23
    vfmadd213ps ymm1, ymm3, [c_q8e1]
    vfmadd231ps ymm9, ymm5, ymm6
    vpsrld ymm8, ymm4, 14
    vpsrld ymm5, ymm4, 17
    vpermps ymm6, ymm11, [c_w8e]
    vpermps ymm4, ymm8, [c_c8e]
    vpermps ymm8, ymm5, [c_p8e]
    vpermps ymm5, ymm11, [c_r8x]
    vfmadd213ps ymm1, ymm3, ymm13
    vmulps ymm11, ymm2, ymm3
    vpaddd ymm3, ymm4, ymm8
    vandnps ymm4, ymm15, ymm7
    vandps ymm8, ymm7, ymm15
    vpsubd ymm7, ymm5, ymm10
    vorps ymm5, ymm3, ymm12
    vpmaxud ymm10, ymm4, [c_xflr]
    vmovups ymm3, [c_q8e2]
    vfmsub213ps ymm0, ymm7, ymm14
    vmulps ymm12, ymm5, ymm6
    vpsrld ymm4, ymm10, 23
    vpsrld ymm7, ymm10, 20
    vmovups ymm5, [rsp + 1696]
    vfmadd231ps ymm2, ymm11, ymm1
    vpmaddwd ymm6, ymm4, [c_k5e]
    vpermps ymm11, ymm7, [c_w8e]
    vpslld ymm1, ymm4, 23
    vpermps ymm4, ymm7, [c_r8x]
    vaddps ymm7, ymm9, ymm2
    vpsubd ymm4, ymm4, ymm1
    vfmadd231ps ymm3, ymm0, [c_q8e3]
    vmovaps [rsp + 3360], ymm7
    vaddps ymm1, ymm7, [rsp + 5280]
    vfmsub213ps ymm10, ymm4, ymm14
    vmulps ymm7, ymm12, ymm0
    vmovaps [r13 + 256], ymm1
    vpsrld ymm4, ymm6, 14
    vpsrld ymm1, ymm6, 17
    vpermps ymm6, ymm4, [c_c8e]
    vpermps ymm4, ymm1, [c_p8e]
    vfmadd213ps ymm3, ymm0, [c_q8e1]
    vpaddd ymm1, ymm6, ymm4
    vandnps ymm6, ymm15, ymm5
    vandps ymm4, ymm5, ymm15
    vorps ymm5, ymm1, ymm8
    jmp .j1792
.j1792:
    vfmadd213ps ymm3, ymm0, ymm13
    vpmaxud ymm1, ymm6, [c_xflr]
    vmovups ymm8, [c_q8e2]
    vmulps ymm0, ymm5, ymm11
    vpsrld ymm6, ymm1, 23
    vpsrld ymm5, ymm1, 20
    vfmadd231ps ymm12, ymm7, ymm3
    vpmaddwd ymm11, ymm6, [c_k5e]
    vpermps ymm7, ymm5, [c_w8e]
    vpslld ymm3, ymm6, 23
    vpermps ymm6, ymm5, [c_r8x]
    vfmadd231ps ymm8, ymm10, [c_q8e3]
    vpmaxud ymm5, ymm9, ymm12
    vpsrld ymm9, ymm11, 14
    vpsubd ymm6, ymm6, ymm3
    vpsrld ymm3, ymm11, 17
    vpermps ymm11, ymm9, [c_c8e]
    vfmsub213ps ymm1, ymm6, ymm14
    vmulps ymm9, ymm0, ymm10
    vpermps ymm6, ymm3, [c_p8e]
    vfmadd213ps ymm8, ymm10, [c_q8e1]
    vpaddd ymm3, ymm11, ymm6
    vfmadd213ps ymm8, ymm10, ymm13
    vmovups ymm11, [rsp + 1792]
    vmovups ymm6, [c_q8e2]
    vorps ymm10, ymm3, ymm4
    vmulps ymm3, ymm10, ymm7
    vmovups ymm4, [rsp + 672]
    vfmadd231ps ymm0, ymm9, ymm8
    vmulps ymm10, ymm3, ymm1
    vandnps ymm7, ymm15, ymm11
    vandps ymm9, ymm11, ymm15
    vfmadd231ps ymm6, ymm1, [c_q8e3]
    vpmaxud ymm8, ymm2, ymm0
    vaddps ymm11, ymm12, ymm0
    vpmaxud ymm2, ymm7, [c_xflr]
    vpsrld ymm12, ymm2, 23
    vpsrld ymm0, ymm2, 20
    vmovaps [rsp + 3392], ymm11
    vaddps ymm7, ymm11, [rsp + 5312]
    vfmadd213ps ymm6, ymm1, [c_q8e1]
    vmovaps [r13 + 288], ymm7
    vpmaddwd ymm11, ymm12, [c_k5e]
    vpslld ymm7, ymm12, 23
    vpsrld ymm12, ymm11, 14
    vfmadd213ps ymm6, ymm1, ymm13
    vpsrld ymm1, ymm11, 17
    vpermps ymm11, ymm12, [c_c8e]
    vpermps ymm12, ymm1, [c_p8e]
    vfmadd231ps ymm3, ymm10, ymm6
    vandnps ymm1, ymm15, ymm4
    vandps ymm10, ymm4, ymm15
    vmovups ymm6, [c_q8e2]
    vpmaxud ymm4, ymm1, [c_xflr]
    vpaddd ymm1, ymm11, ymm12
    vpermps ymm11, ymm0, [c_w8e]
    vpermps ymm12, ymm0, [c_r8x]
    vorps ymm0, ymm1, ymm9
    vpsrld ymm1, ymm4, 23
    vpmaxud ymm9, ymm5, ymm3
    vpminsd ymm5, ymm9, [c_zero]
    vpsubd ymm9, ymm12, ymm7
    vmulps ymm12, ymm0, ymm11
    vpmaddwd ymm7, ymm1, [c_k5e]
    vpsrld ymm0, ymm4, 20
    vfmsub213ps ymm2, ymm9, ymm14
    vpermps ymm11, ymm0, [c_w8e]
    vpermps ymm9, ymm0, [c_r8x]
    vpslld ymm0, ymm1, 23
    vpsrld ymm1, ymm7, 14
    vpsrld ymm7, ymm7, 17
    vpermps ymm1, ymm1, [c_c8e]
    vpsubd ymm9, ymm9, ymm0
    vfmadd231ps ymm6, ymm2, [c_q8e3]
    vpermps ymm0, ymm7, [c_p8e]
    vfmsub213ps ymm4, ymm9, ymm14
    vmulps ymm7, ymm12, ymm2
    vfmadd213ps ymm6, ymm2, [c_q8e1]
    vpaddd ymm9, ymm1, ymm0
    vmovups ymm1, [rsp + 768]
    vorps ymm0, ymm9, ymm10
    vmulps ymm9, ymm0, ymm11
    vmovups ymm10, [c_q8e2]
    vfmadd213ps ymm6, ymm2, ymm13
    vfmadd231ps ymm12, ymm7, ymm6
    vandnps ymm0, ymm15, ymm1
    vandps ymm11, ymm1, ymm15
    vpmaxud ymm2, ymm0, [c_xflr]
    vmulps ymm7, ymm9, ymm4
    vmovups ymm6, [rsp + 704]
    vpsrld ymm1, ymm2, 23
    vfmadd231ps ymm10, ymm4, [c_q8e3]
    vpmaxud ymm0, ymm8, ymm12
    vaddps ymm8, ymm3, ymm12
    vpmaddwd ymm3, ymm1, [c_k5e]
    vpslld ymm12, ymm1, 23
    vpminsd ymm1, ymm0, [c_zero]
    vmovaps [rsp + 3424], ymm8
    vaddps ymm0, ymm8, [rsp + 5344]
    vaddps ymm8, ymm5, ymm1
    vfmadd213ps ymm10, ymm4, [c_q8e1]
    vpsrld ymm5, ymm3, 14
    vpsrld ymm1, ymm3, 17
    vmovaps [r13 + 320], ymm0
    vaddps ymm3, ymm8, [rsp + 5376]
    vpermps ymm0, ymm5, [c_c8e]
    vmovaps [rsp + 3456], ymm8
    vpermps ymm5, ymm1, [c_p8e]
    vpsrld ymm8, ymm2, 20
    vmovaps [r13 + 352], ymm3
    vpermps ymm1, ymm8, [c_w8e]
    vpermps ymm3, ymm8, [c_r8x]
    vfmadd213ps ymm10, ymm4, ymm13
    vandnps ymm8, ymm15, ymm6
    vpmaxud ymm4, ymm8, [c_xflr]
    vandps ymm8, ymm6, ymm15
    vpaddd ymm6, ymm0, ymm5
    vpsrld ymm0, ymm4, 23
    vpsubd ymm5, ymm3, ymm12
    vorps ymm3, ymm6, ymm11
    vfmadd231ps ymm9, ymm7, ymm10
    vpmaddwd ymm12, ymm0, [c_k5e]
    vmovups ymm6, [c_q8e2]
    vfmsub213ps ymm2, ymm5, ymm14
    vmulps ymm11, ymm3, ymm1
    vpsrld ymm7, ymm4, 20
    vpslld ymm10, ymm0, 23
    vmovups ymm5, [rsp + 800]
    jmp .j1920
.j1920:
    vpermps ymm3, ymm7, [c_w8e]
    vpermps ymm1, ymm7, [c_r8x]
    vpsrld ymm0, ymm12, 14
    vpsrld ymm7, ymm12, 17
    vpermps ymm12, ymm0, [c_c8e]
    vpermps ymm0, ymm7, [c_p8e]
    vpsubd ymm7, ymm1, ymm10
    vmulps ymm1, ymm11, ymm2
    vfmsub213ps ymm4, ymm7, ymm14
    vfmadd231ps ymm6, ymm2, [c_q8e3]
    vmovups ymm10, [c_q8e2]
    vpaddd ymm7, ymm12, ymm0
    vandnps ymm12, ymm15, ymm5
    vandps ymm0, ymm5, ymm15
    vorps ymm5, ymm7, ymm8
    vpmaxud ymm7, ymm12, [c_xflr]
    vmovups ymm8, [rsp + 736]
    vmulps ymm12, ymm5, ymm3
    vpsrld ymm5, ymm7, 23
    vfmadd213ps ymm6, ymm2, [c_q8e1]
    vfmadd231ps ymm10, ymm4, [c_q8e3]
    vfmadd213ps ymm6, ymm2, ymm13
    vpmaddwd ymm3, ymm5, [c_k5e]
    vpslld ymm2, ymm5, 23
    vfmadd213ps ymm10, ymm4, [c_q8e1]
    vfmadd231ps ymm11, ymm1, ymm6
    vpsrld ymm5, ymm3, 14
    vpsrld ymm1, ymm3, 17
    vmulps ymm6, ymm12, ymm4
    vpermps ymm3, ymm5, [c_c8e]
    vpermps ymm5, ymm1, [c_p8e]
    vfmadd213ps ymm10, ymm4, ymm13
    vandnps ymm1, ymm15, ymm8
    vandps ymm4, ymm8, ymm15
    vaddps ymm8, ymm9, ymm11
    vpaddd ymm3, ymm3, ymm5
    vpmaxud ymm5, ymm1, [c_xflr]
    vaddps ymm1, ymm8, [rsp + 2976]
    vmovaps [rsp + 5152], ymm8
    vorps ymm8, ymm3, ymm0
    vpsrld ymm3, ymm5, 23
    vfmadd231ps ymm12, ymm6, ymm10
    vpmaddwd ymm0, ymm3, [c_k5e]
    vpsrld ymm6, ymm5, 20
    vpslld ymm10, ymm3, 23
    vmovaps [rsp + 3488], ymm1
    vpsrld ymm3, ymm7, 20
    vpermps ymm1, ymm3, [c_w8e]
    vpermps ymm3, ymm3, [c_r8x]
    vmulps ymm8, ymm8, ymm1
    vpmaxud ymm1, ymm9, ymm12
    vpsubd ymm9, ymm3, ymm2
    vpsrld ymm3, ymm0, 14
    vpsrld ymm2, ymm0, 17
    vfmsub213ps ymm7, ymm9, ymm14
    vpermps ymm0, ymm3, [c_c8e]
    vpermps ymm9, ymm2, [c_p8e]
    vpermps ymm3, ymm6, [c_w8e]
    vpermps ymm2, ymm6, [c_r8x]
    vpaddd ymm6, ymm0, ymm9
    vmovups ymm0, [c_q8e2]
    vpsubd ymm9, ymm2, ymm10
    vorps ymm2, ymm6, ymm4
    vmulps ymm10, ymm8, ymm7
    vmovups ymm6, [rsp + 832]
    vfmsub213ps ymm5, ymm9, ymm14
    vmulps ymm4, ymm2, ymm3
    vmovups ymm9, [c_q8e2]
    vmulps ymm2, ymm4, ymm5
    vfmadd231ps ymm0, ymm7, [c_q8e3]
    vfmadd231ps ymm9, ymm5, [c_q8e3]
    vfmadd213ps ymm0, ymm7, [c_q8e1]
    vfmadd213ps ymm9, ymm5, [c_q8e1]
    vfmadd213ps ymm0, ymm7, ymm13
    vandnps ymm3, ymm15, ymm6
    vandps ymm7, ymm6, ymm15
    vpmaxud ymm6, ymm3, [c_xflr]
    vfmadd213ps ymm9, ymm5, ymm13
    vmovups ymm3, [rsp + 1056]
    vfmadd231ps ymm8, ymm10, ymm0
    vpsrld ymm5, ymm6, 23
    vpsrld ymm10, ymm6, 20
    vfmadd231ps ymm4, ymm2, ymm9
    vpmaddwd ymm0, ymm5, [c_k5e]
    vpermps ymm2, ymm10, [c_w8e]
    vpslld ymm9, ymm5, 23
    vpmaxud ymm5, ymm11, ymm8
    vaddps ymm11, ymm12, ymm8
    vpermps ymm12, ymm10, [c_r8x]
    vandnps ymm8, ymm15, ymm3
    vandps ymm10, ymm3, ymm15
    vaddps ymm3, ymm11, [rsp + 3008]
    vmovaps [rsp + 5184], ymm11
    vpmaxud ymm11, ymm1, ymm4
    vpmaxud ymm1, ymm8, [c_xflr]
    vmovaps [rsp + 3520], ymm3
    vpsrld ymm8, ymm0, 14
    vpsrld ymm3, ymm0, 17
    vpsubd ymm0, ymm12, ymm9
    vmovups ymm12, [c_q8e2]
    vpermps ymm9, ymm8, [c_c8e]
    vpermps ymm8, ymm3, [c_p8e]
    vfmsub213ps ymm6, ymm0, ymm14
    vpsrld ymm3, ymm1, 23
    vpminsd ymm0, ymm11, [c_zero]
    vpaddd ymm11, ymm9, ymm8
    vpmaddwd ymm9, ymm3, [c_k5e]
    vpslld ymm8, ymm3, 23
    vorps ymm3, ymm11, ymm7
    vpsrld ymm11, ymm1, 20
    vmulps ymm7, ymm3, ymm2
    vpermps ymm3, ymm11, [c_w8e]
    vpermps ymm2, ymm11, [c_r8x]
    vpsrld ymm11, ymm9, 14
    vpsrld ymm9, ymm9, 17
    vpermps ymm11, ymm11, [c_c8e]
    vpermps ymm9, ymm9, [c_p8e]
    vpsubd ymm2, ymm2, ymm8
    vfmadd231ps ymm12, ymm6, [c_q8e3]
    vfmsub213ps ymm1, ymm2, ymm14
    vmulps ymm8, ymm7, ymm6
    vpaddd ymm2, ymm11, ymm9
    vfmadd213ps ymm12, ymm6, [c_q8e1]
    vmovups ymm11, [rsp + 1152]
    vorps ymm9, ymm2, ymm10
    vmulps ymm2, ymm9, ymm3
    vmovups ymm10, [c_q8e2]
    vfmadd213ps ymm12, ymm6, ymm13
    jmp .j2048
.j2048:
    vandnps ymm9, ymm15, ymm11
    vandps ymm3, ymm11, ymm15
    vfmadd231ps ymm7, ymm8, ymm12
    vpmaxud ymm6, ymm9, [c_xflr]
    vmulps ymm11, ymm2, ymm1
    vpsrld ymm8, ymm6, 23
    vpsrld ymm12, ymm6, 20
    vfmadd231ps ymm10, ymm1, [c_q8e3]
    vpmaxud ymm9, ymm5, ymm7
    vaddps ymm5, ymm4, ymm7
    vpmaddwd ymm4, ymm8, [c_k5e]
    vpslld ymm7, ymm8, 23
    vpminsd ymm8, ymm9, [c_zero]
    vfmadd213ps ymm10, ymm1, [c_q8e1]
    vaddps ymm9, ymm5, [rsp + 3040]
    vmovaps [rsp + 5216], ymm5
    vaddps ymm5, ymm0, ymm8
    vpermps ymm0, ymm12, [c_w8e]
    vpermps ymm8, ymm12, [c_r8x]
    vmovaps [rsp + 3552], ymm9
    vaddps ymm12, ymm5, [rsp + 3072]
    vmovaps [rsp + 5248], ymm5
    vpsrld ymm9, ymm4, 14
    vpsrld ymm5, ymm4, 17
    vfmadd213ps ymm10, ymm1, ymm13
    vmovups ymm4, [rsp + 1088]
    vmovaps [rsp + 3584], ymm12
    vpermps ymm1, ymm9, [c_c8e]
    vpermps ymm12, ymm5, [c_p8e]
    vpsubd ymm9, ymm8, ymm7
    vmovups ymm5, [c_q8e2]
    vfmsub213ps ymm6, ymm9, ymm14
    vfmadd231ps ymm2, ymm11, ymm10
    vpaddd ymm8, ymm1, ymm12
    vmovups ymm7, [rsp + 1184]
    vorps ymm9, ymm8, ymm3
    vmulps ymm11, ymm9, ymm0
    vandnps ymm10, ymm15, ymm4
    vandps ymm1, ymm4, ymm15
    vpmaxud ymm12, ymm10, [c_xflr]
    vpsrld ymm8, ymm12, 23
    vpsrld ymm3, ymm12, 20
    vfmadd231ps ymm5, ymm6, [c_q8e3]
    vpmaddwd ymm9, ymm8, [c_k5e]
    vpermps ymm0, ymm3, [c_w8e]
    vpslld ymm4, ymm8, 23
    vmulps ymm10, ymm11, ymm6
    vpermps ymm8, ymm3, [c_r8x]
    vpsrld ymm3, ymm9, 14
    vpsrld ymm9, ymm9, 17
    vpermps ymm3, ymm3, [c_c8e]
    vpsubd ymm8, ymm8, ymm4
    vfmadd213ps ymm5, ymm6, [c_q8e1]
    vpermps ymm4, ymm9, [c_p8e]
    vfmsub213ps ymm12, ymm8, ymm14
    vandnps ymm9, ymm15, ymm7
    vandps ymm8, ymm7, ymm15
    vpmaxud ymm7, ymm9, [c_xflr]
    vfmadd213ps ymm5, ymm6, ymm13
    vpsrld ymm9, ymm7, 23
    vpaddd ymm6, ymm3, ymm4
    vpmaddwd ymm3, ymm9, [c_k5e]
    vpslld ymm4, ymm9, 23
    vorps ymm9, ymm6, ymm1
    vpsrld ymm6, ymm7, 20
    vmulps ymm1, ymm9, ymm0
    vpermps ymm9, ymm6, [c_w8e]
    vpermps ymm0, ymm6, [c_r8x]
    vfmadd231ps ymm11, ymm10, ymm5
    vpsrld ymm6, ymm3, 14
    vpsrld ymm10, ymm3, 17
    vmovups ymm5, [c_q8e2]
    vpermps ymm3, ymm6, [c_c8e]
    vpermps ymm6, ymm10, [c_p8e]
    vpsubd ymm10, ymm0, ymm4
    vmulps ymm0, ymm1, ymm12
    vaddps ymm4, ymm2, ymm11
    vfmsub213ps ymm7, ymm10, ymm14
    vpaddd ymm10, ymm3, ymm6
    vmovups ymm3, [rsp + 1120]
    vaddps ymm6, ymm4, [rsp + 3104]
    vorps ymm10, ymm10, ymm8
    vaddps ymm8, ymm4, [rsp + 5152]
    vmulps ymm4, ymm10, ymm9
    vfmadd231ps ymm5, ymm12, [c_q8e3]
    vmovaps [rsp + 3616], ymm6
    vmovups ymm10, [c_q8e2]
    vmovaps [r13 + 128], ymm8
    vmulps ymm9, ymm4, ymm7
    vfmadd213ps ymm5, ymm12, [c_q8e1]
    vandnps ymm6, ymm15, ymm3
    vandps ymm8, ymm3, ymm15
    vpmaxud ymm3, ymm6, [c_xflr]
    vfmadd213ps ymm5, ymm12, ymm13
    vpsrld ymm6, ymm3, 23
    vfmadd231ps ymm10, ymm7, [c_q8e3]
    vfmadd231ps ymm1, ymm0, ymm5
    vpmaddwd ymm12, ymm6, [c_k5e]
    vpsrld ymm0, ymm3, 20
    vpslld ymm5, ymm6, 23
    vfmadd213ps ymm10, ymm7, [c_q8e1]
    vpmaxud ymm6, ymm2, ymm1
    vpsrld ymm2, ymm12, 14
    vfmadd213ps ymm10, ymm7, ymm13
    vpsrld ymm7, ymm12, 17
    vpermps ymm12, ymm2, [c_c8e]
    vpermps ymm2, ymm7, [c_p8e]
    vfmadd231ps ymm4, ymm9, ymm10
    vmovups ymm7, [rsp + 1216]
    vpermps ymm9, ymm0, [c_w8e]
    vpermps ymm10, ymm0, [c_r8x]
    vpaddd ymm0, ymm12, ymm2
    vmovups ymm12, [c_q8e2]
    vorps ymm2, ymm0, ymm8
    vpmaxud ymm0, ymm11, ymm4
    vaddps ymm8, ymm1, ymm4
    vpsubd ymm11, ymm10, ymm5
    vmulps ymm1, ymm2, ymm9
    vmovups ymm4, [rsp + 1440]
    vfmsub213ps ymm3, ymm11, ymm14
    vaddps ymm10, ymm8, [rsp + 3136]
    vaddps ymm5, ymm8, [rsp + 5184]
    vandnps ymm2, ymm15, ymm7
    vandps ymm9, ymm7, ymm15
    vmovaps [rsp + 3648], ymm10
    vpmaxud ymm11, ymm2, [c_xflr]
    vmovaps [r13 + 160], ymm5
    vpsrld ymm8, ymm11, 23
    jmp .j2176
.j2176:
    vpsrld ymm7, ymm11, 20
    vpmaddwd ymm10, ymm8, [c_k5e]
    vpermps ymm2, ymm7, [c_w8e]
    vpslld ymm5, ymm8, 23
    vpermps ymm8, ymm7, [c_r8x]
    vfmadd231ps ymm12, ymm3, [c_q8e3]
    vpsrld ymm7, ymm10, 14
    vpsrld ymm10, ymm10, 17
    vpermps ymm7, ymm7, [c_c8e]
    vpsubd ymm8, ymm8, ymm5
    vfmadd213ps ymm12, ymm3, [c_q8e1]
    vpermps ymm5, ymm10, [c_p8e]
    vfmsub213ps ymm11, ymm8, ymm14
    vmulps ymm10, ymm1, ymm3
    vfmadd213ps ymm12, ymm3, ymm13
    vandnps ymm8, ymm15, ymm4
    vandps ymm3, ymm4, ymm15
    vpaddd ymm4, ymm7, ymm5
    vpmaxud ymm7, ymm8, [c_xflr]
    vmovups ymm5, [c_q8e2]
    vorps ymm8, ymm4, ymm9
    vpsrld ymm4, ymm7, 23
    vmulps ymm9, ymm8, ymm2
    vpmaddwd ymm8, ymm4, [c_k5e]
    vpslld ymm2, ymm4, 23
    vfmadd231ps ymm1, ymm10, ymm12
    vpsrld ymm4, ymm7, 20
    vpermps ymm10, ymm4, [c_w8e]
    vpermps ymm12, ymm4, [c_r8x]
    vpmaxud ymm4, ymm6, ymm1
    vfmadd231ps ymm5, ymm11, [c_q8e3]
    vpsrld ymm6, ymm8, 14
    vpsubd ymm12, ymm12, ymm2
    vpminsd ymm2, ymm4, [c_zero]
    vpsrld ymm4, ymm8, 17
    vpermps ymm8, ymm6, [c_c8e]
    vfmsub213ps ymm7, ymm12, ymm14
    vmulps ymm6, ymm9, ymm11
    vpermps ymm12, ymm4, [c_p8e]
    vfmadd213ps ymm5, ymm11, [c_q8e1]
    vpaddd ymm4, ymm8, ymm12
    vmovups ymm8, [rsp + 1536]
    vorps ymm12, ymm4, ymm3
    vfmadd213ps ymm5, ymm11, ymm13
    vmulps ymm4, ymm12, ymm10
    vmovups ymm3, [c_q8e2]
    vfmadd231ps ymm9, ymm6, ymm5
    vandnps ymm11, ymm15, ymm8
    vandps ymm12, ymm8, ymm15
    vpmaxud ymm10, ymm11, [c_xflr]
    vmulps ymm6, ymm4, ymm7
    vpmaxud ymm5, ymm0, ymm9
    vaddps ymm8, ymm1, ymm9
    vpsrld ymm11, ymm10, 23
    vmovups ymm0, [rsp + 1472]
    vpminsd ymm1, ymm5, [c_zero]
    vpmaddwd ymm9, ymm11, [c_k5e]
    vpslld ymm5, ymm11, 23
    vaddps ymm11, ymm8, [rsp + 3168]
    vaddps ymm2, ymm2, ymm1
    vfmadd231ps ymm3, ymm7, [c_q8e3]
    vaddps ymm1, ymm8, [rsp + 5216]
    vmovaps [rsp + 3680], ymm11
    vaddps ymm8, ymm2, [rsp + 3200]
    vaddps ymm11, ymm2, [rsp + 5248]
    vmovaps [r13 + 192], ymm1
    vpsrld ymm2, ymm9, 14
    vpsrld ymm1, ymm9, 17
    vmovaps [rsp + 3712], ymm8
    vpermps ymm9, ymm2, [c_c8e]
    vpermps ymm8, ymm1, [c_p8e]
    vpsrld ymm2, ymm10, 20
    vmovaps [r13 + 224], ymm11
    vpermps ymm1, ymm2, [c_w8e]
    vpermps ymm11, ymm2, [c_r8x]
    vfmadd213ps ymm3, ymm7, [c_q8e1]
    vpaddd ymm2, ymm9, ymm8
    vandnps ymm9, ymm15, ymm0
    vandps ymm8, ymm0, ymm15
    vpsubd ymm0, ymm11, ymm5
    vorps ymm11, ymm2, ymm12
    vpmaxud ymm5, ymm9, [c_xflr]
    vmovups ymm2, [c_q8e2]
    vfmsub213ps ymm10, ymm0, ymm14
    vmulps ymm12, ymm11, ymm1
    vpsrld ymm9, ymm5, 23
    vpsrld ymm0, ymm5, 20
    vmovups ymm11, [rsp + 1568]
    vfmadd213ps ymm3, ymm7, ymm13
    vpmaddwd ymm1, ymm9, [c_k5e]
    vpslld ymm7, ymm9, 23
    vfmadd231ps ymm4, ymm6, ymm3
    vpsrld ymm9, ymm1, 14
    vpsrld ymm6, ymm1, 17
    vpermps ymm3, ymm0, [c_w8e]
    vpermps ymm1, ymm9, [c_c8e]
    vpermps ymm9, ymm6, [c_p8e]
    vpermps ymm6, ymm0, [c_r8x]
    vfmadd231ps ymm2, ymm10, [c_q8e3]
    vpaddd ymm0, ymm1, ymm9
    vmulps ymm1, ymm12, ymm10
    vpsubd ymm9, ymm6, ymm7
    vorps ymm6, ymm0, ymm8
    vfmadd213ps ymm2, ymm10, [c_q8e1]
    vandnps ymm7, ymm15, ymm11
    vmovups ymm0, [c_q8e2]
    vfmsub213ps ymm5, ymm9, ymm14
    vmulps ymm8, ymm6, ymm3
    vpmaxud ymm9, ymm7, [c_xflr]
    vandps ymm6, ymm11, ymm15
    vmovups ymm3, [rsp + 1504]
    vpsrld ymm7, ymm9, 23
    vfmadd213ps ymm2, ymm10, ymm13
    vpmaddwd ymm11, ymm7, [c_k5e]
    vpslld ymm10, ymm7, 23
    vfmadd231ps ymm0, ymm5, [c_q8e3]
    vfmadd231ps ymm12, ymm1, ymm2
    vpsrld ymm7, ymm11, 14
    vpsrld ymm1, ymm11, 17
    vmulps ymm2, ymm8, ymm5
    vpermps ymm11, ymm7, [c_c8e]
    vpermps ymm7, ymm1, [c_p8e]
    vfmadd213ps ymm0, ymm5, [c_q8e1]
    vaddps ymm1, ymm4, ymm12
    vpaddd ymm11, ymm11, ymm7
    vaddps ymm7, ymm1, [rsp + 3232]
    vmovaps [rsp + 5408], ymm1
    vorps ymm1, ymm11, ymm6
    jmp .j2304
.j2304:
    vandnps ymm11, ymm15, ymm3
    vandps ymm6, ymm3, ymm15
    vfmadd213ps ymm0, ymm5, ymm13
    vpmaxud ymm3, ymm11, [c_xflr]
    vmovups ymm5, [c_q8e2]
    vmovaps [rsp + 3744], ymm7
    vpsrld ymm11, ymm9, 20
    vpermps ymm7, ymm11, [c_w8e]
    vpermps ymm11, ymm11, [c_r8x]
    vfmadd231ps ymm8, ymm2, ymm0
    vpsrld ymm2, ymm3, 23
    vmulps ymm0, ymm1, ymm7
    vpmaddwd ymm1, ymm2, [c_k5e]
    vpslld ymm7, ymm2, 23
    vpsubd ymm2, ymm11, ymm10
    vpsrld ymm11, ymm3, 20
    vfmsub213ps ymm9, ymm2, ymm14
    vpmaxud ymm10, ymm4, ymm8
    vpermps ymm2, ymm11, [c_w8e]
    vpermps ymm4, ymm11, [c_r8x]
    vpsrld ymm11, ymm1, 14
    vpsrld ymm1, ymm1, 17
    vpermps ymm11, ymm11, [c_c8e]
    vpermps ymm1, ymm1, [c_p8e]
    vpsubd ymm4, ymm4, ymm7
    vfmadd231ps ymm5, ymm9, [c_q8e3]
    vfmsub213ps ymm3, ymm4, ymm14
    vmulps ymm7, ymm0, ymm9
    vpaddd ymm4, ymm11, ymm1
    vfmadd213ps ymm5, ymm9, [c_q8e1]
    vmovups ymm11, [rsp + 1600]
    vorps ymm1, ymm4, ymm6
    vmovups ymm4, [c_q8e2]
    vmulps ymm6, ymm1, ymm2
    vmovups ymm1, [rsp + 1824]
    vfmadd213ps ymm5, ymm9, ymm13
    vmulps ymm2, ymm6, ymm3
    vfmadd231ps ymm0, ymm7, ymm5
    vandnps ymm9, ymm15, ymm11
    vandps ymm7, ymm11, ymm15
    vfmadd231ps ymm4, ymm3, [c_q8e3]
    vpmaxud ymm5, ymm9, [c_xflr]
    vpsrld ymm11, ymm5, 23
    vpmaxud ymm9, ymm12, ymm0
    vaddps ymm12, ymm8, ymm0
    vpmaddwd ymm8, ymm11, [c_k5e]
    vpslld ymm0, ymm11, 23
    vfmadd213ps ymm4, ymm3, [c_q8e1]
    vaddps ymm11, ymm12, [rsp + 3264]
    vmovaps [rsp + 5440], ymm12
    vmovaps [rsp + 3776], ymm11
    vpsrld ymm12, ymm8, 14
    vpsrld ymm11, ymm8, 17
    vpermps ymm8, ymm12, [c_c8e]
    vpermps ymm12, ymm11, [c_p8e]
    vfmadd213ps ymm4, ymm3, ymm13
    vandnps ymm11, ymm15, ymm1
    vpmaxud ymm3, ymm11, [c_xflr]
    vandps ymm11, ymm1, ymm15
    vpaddd ymm1, ymm8, ymm12
    vpsrld ymm8, ymm5, 20
    vfmadd231ps ymm6, ymm2, ymm4
    vpsrld ymm12, ymm3, 23
    vmovups ymm2, [c_q8e2]
    vpermps ymm4, ymm8, [c_w8e]
    vorps ymm1, ymm1, ymm7
    vpermps ymm7, ymm8, [c_r8x]
    vpmaxud ymm8, ymm10, ymm6
    vmulps ymm10, ymm1, ymm4
    vpmaddwd ymm1, ymm12, [c_k5e]
    vpslld ymm4, ymm12, 23
    vpminsd ymm12, ymm8, [c_zero]
    vpsubd ymm8, ymm7, ymm0
    vpsrld ymm7, ymm3, 20
    vfmsub213ps ymm5, ymm8, ymm14
    vpermps ymm0, ymm7, [c_w8e]
    vpermps ymm8, ymm7, [c_r8x]
    vpsrld ymm7, ymm1, 14
    vpsrld ymm1, ymm1, 17
    vpermps ymm7, ymm7, [c_c8e]
    vpermps ymm1, ymm1, [c_p8e]
    vpsubd ymm8, ymm8, ymm4
    vfmadd231ps ymm2, ymm5, [c_q8e3]
    vfmsub213ps ymm3, ymm8, ymm14
    vmulps ymm4, ymm10, ymm5
    vpaddd ymm8, ymm7, ymm1
    vfmadd213ps ymm2, ymm5, [c_q8e1]
    vmovups ymm7, [rsp + 1920]
    vorps ymm1, ymm8, ymm11
    vmulps ymm8, ymm1, ymm0
    vmovups ymm11, [c_q8e2]
    vfmadd213ps ymm2, ymm5, ymm13
    vandnps ymm1, ymm15, ymm7
    vandps ymm0, ymm7, ymm15
    vfmadd231ps ymm10, ymm4, ymm2
    vpmaxud ymm5, ymm1, [c_xflr]
    vmulps ymm7, ymm8, ymm3
    vpsrld ymm4, ymm5, 23
    vpsrld ymm2, ymm5, 20
    vfmadd231ps ymm11, ymm3, [c_q8e3]
    vpmaxud ymm1, ymm9, ymm10
    vaddps ymm9, ymm6, ymm10
    vpmaddwd ymm6, ymm4, [c_k5e]
    vpslld ymm10, ymm4, 23
    vpminsd ymm4, ymm1, [c_zero]
    vfmadd213ps ymm11, ymm3, [c_q8e1]
    vaddps ymm1, ymm9, [rsp + 3296]
    vmovaps [rsp + 5472], ymm9
    vaddps ymm9, ymm12, ymm4
    vpermps ymm12, ymm2, [c_w8e]
    vpermps ymm4, ymm2, [c_r8x]
    vmovaps [rsp + 3808], ymm1
    vaddps ymm2, ymm9, [rsp + 3328]
    vmovaps [rsp + 5504], ymm9
    vpsrld ymm1, ymm6, 14
    vpsrld ymm9, ymm6, 17
    vfmadd213ps ymm11, ymm3, ymm13
    vmovups ymm6, [rsp + 1856]
    vmovaps [rsp + 3840], ymm2
    vpermps ymm3, ymm1, [c_c8e]
    vpermps ymm2, ymm9, [c_p8e]
    vpsubd ymm1, ymm4, ymm10
    vmovups ymm9, [c_q8e2]
    vfmsub213ps ymm5, ymm1, ymm14
    vfmadd231ps ymm8, ymm7, ymm11
    vpaddd ymm4, ymm3, ymm2
    vmovups ymm10, [rsp + 1952]
    vorps ymm1, ymm4, ymm0
    jmp .j2432
.j2432:
    vmulps ymm7, ymm1, ymm12
    vandnps ymm11, ymm15, ymm6
    vandps ymm3, ymm6, ymm15
    vpmaxud ymm2, ymm11, [c_xflr]
    vpsrld ymm4, ymm2, 23
    vpsrld ymm0, ymm2, 20
    vfmadd231ps ymm9, ymm5, [c_q8e3]
    vpmaddwd ymm1, ymm4, [c_k5e]
    vpermps ymm12, ymm0, [c_w8e]
    vpslld ymm6, ymm4, 23
    vmulps ymm11, ymm7, ymm5
    vpermps ymm4, ymm0, [c_r8x]
    vpsrld ymm0, ymm1, 14
    vpsrld ymm1, ymm1, 17
    vpermps ymm0, ymm0, [c_c8e]
    vpsubd ymm4, ymm4, ymm6
    vfmadd213ps ymm9, ymm5, [c_q8e1]
    vpermps ymm6, ymm1, [c_p8e]
    vfmsub213ps ymm2, ymm4, ymm14
    vandnps ymm1, ymm15, ymm10
    vandps ymm4, ymm10, ymm15
    vpmaxud ymm10, ymm1, [c_xflr]
    vfmadd213ps ymm9, ymm5, ymm13
    vpsrld ymm1, ymm10, 23
    vpaddd ymm5, ymm0, ymm6
    vpmaddwd ymm0, ymm1, [c_k5e]
    vpslld ymm6, ymm1, 23
    vorps ymm1, ymm5, ymm3
    vpsrld ymm5, ymm10, 20
    vmulps ymm3, ymm1, ymm12
    vpermps ymm1, ymm5, [c_w8e]
    vpermps ymm12, ymm5, [c_r8x]
    vfmadd231ps ymm7, ymm11, ymm9
    vpsrld ymm5, ymm0, 14
    vpsrld ymm11, ymm0, 17
    vmovups ymm9, [c_q8e2]
    vpermps ymm0, ymm5, [c_c8e]
    vpermps ymm5, ymm11, [c_p8e]
    vpsubd ymm11, ymm12, ymm6
    vmulps ymm12, ymm3, ymm2
    vaddps ymm6, ymm8, ymm7
    vfmsub213ps ymm10, ymm11, ymm14
    vpaddd ymm11, ymm0, ymm5
    vmovups ymm0, [rsp + 1888]
    vaddps ymm5, ymm6, [rsp + 3360]
    vorps ymm11, ymm11, ymm4
    vaddps ymm4, ymm6, [rsp + 5408]
    vmulps ymm6, ymm11, ymm1
    vfmadd231ps ymm9, ymm2, [c_q8e3]
    vmovaps [rsp + 3872], ymm5
    vmovups ymm11, [c_q8e2]
    vmovaps [r13 + 384], ymm4
    vmulps ymm1, ymm6, ymm10
    vfmadd213ps ymm9, ymm2, [c_q8e1]
    vandnps ymm5, ymm15, ymm0
    vandps ymm4, ymm0, ymm15
    vpmaxud ymm0, ymm5, [c_xflr]
    vfmadd213ps ymm9, ymm2, ymm13
    vpsrld ymm5, ymm0, 23
    vfmadd231ps ymm11, ymm10, [c_q8e3]
    vfmadd231ps ymm3, ymm12, ymm9
    vpmaddwd ymm2, ymm5, [c_k5e]
    vpsrld ymm12, ymm0, 20
    vpslld ymm9, ymm5, 23
    vfmadd213ps ymm11, ymm10, [c_q8e1]
    vpmaxud ymm5, ymm8, ymm3
    vpsrld ymm8, ymm2, 14
    vfmadd213ps ymm11, ymm10, ymm13
    vpsrld ymm10, ymm2, 17
    vpermps ymm2, ymm8, [c_c8e]
    vpermps ymm8, ymm10, [c_p8e]
    vfmadd231ps ymm6, ymm1, ymm11
    vmovups ymm10, [rsp + 1984]
    vpermps ymm1, ymm12, [c_w8e]
    vpermps ymm11, ymm12, [c_r8x]
    vpaddd ymm12, ymm2, ymm8
    vmovups ymm2, [c_q8e2]
    vorps ymm8, ymm12, ymm4
    vpmaxud ymm12, ymm7, ymm6
    vaddps ymm4, ymm3, ymm6
    vpsubd ymm7, ymm11, ymm9
    vmulps ymm3, ymm8, ymm1
    vmovups ymm6, [c_q8e2]
    vfmsub213ps ymm0, ymm7, ymm14
    vaddps ymm11, ymm4, [rsp + 3392]
    vaddps ymm9, ymm4, [rsp + 5440]
    vandnps ymm8, ymm15, ymm10
    vandps ymm1, ymm10, ymm15
    vmovaps [rsp + 3904], ymm11
    vpmaxud ymm7, ymm8, [c_xflr]
    vmovaps [r13 + 416], ymm9
    vpsrld ymm4, ymm7, 23
    vpsrld ymm10, ymm7, 20
    vpmaddwd ymm11, ymm4, [c_k5e]
    vpermps ymm8, ymm10, [c_w8e]
    vpslld ymm9, ymm4, 23
    vpermps ymm4, ymm10, [c_r8x]
    vfmadd231ps ymm2, ymm0, [c_q8e3]
    vpsrld ymm10, ymm11, 14
    vpsrld ymm11, ymm11, 17
    vpermps ymm10, ymm10, [c_c8e]
    vpsubd ymm4, ymm4, ymm9
    vfmadd213ps ymm2, ymm0, [c_q8e1]
    vpermps ymm9, ymm11, [c_p8e]
    vfmsub231ps ymm14, ymm7, ymm4
    vmulps ymm11, ymm3, ymm0
    vmovups ymm7, [rsp + 3616]
    vfmadd213ps ymm2, ymm0, ymm13
    vmovups ymm4, [rsp + 3872]
    vpaddd ymm0, ymm10, ymm9
    vfmadd231ps ymm6, ymm14, [c_q8e3]
    vmovups ymm10, [rsp + 3488]
    vorps ymm9, ymm0, ymm1
    vmulps ymm0, ymm9, ymm8
    vmovups ymm1, [rsp + 3648]
    vfmadd231ps ymm3, ymm11, ymm2
    vperm2f128 ymm9, ymm7, [rsp + 5536], 3
    vmovups ymm8, [rsp + 3904]
    vfmadd213ps ymm6, ymm14, [c_q8e1]
    vmovups ymm11, [rsp + 3520]
    vpalignr ymm2, ymm7, ymm9, 12
    vperm2f128 ymm9, ymm4, ymm7, 3
    vmovaps [rsp + 5536], ymm4
    vpmaxud ymm7, ymm5, ymm3
    vfmadd231ps ymm13, ymm6, ymm14
    vmulps ymm5, ymm0, ymm14
    vpminsd ymm6, ymm7, [c_zero]
    vfmadd231ps ymm2, ymm10, [rsp + 5664]
    jmp .j2560
.j2560:
    vpalignr ymm14, ymm4, ymm9, 12
    vperm2f128 ymm7, ymm1, [rsp + 5568], 3
    vperm2f128 ymm10, ymm8, ymm1, 3
    vmovups ymm4, [rsp + 3680]
    vaddps ymm9, ymm14, [rsp + 3744]
    vfmadd231ps ymm0, ymm5, ymm13
    vpalignr ymm14, ymm1, ymm7, 12
    vmovaps [rsp + 5568], ymm8
    vmovups ymm5, [rsp + 3552]
    vshufps ymm13, ymm2, ymm9, 136
    vshufps ymm1, ymm2, ymm9, 221
    vpalignr ymm7, ymm8, ymm10, 12
    vaddps ymm2, ymm13, ymm1
    vfmadd231ps ymm14, ymm11, [rsp + 5664]
    vaddps ymm9, ymm7, [rsp + 3776]
    vmovups ymm8, [rsp + 3712]
    vpmaxud ymm10, ymm12, ymm0
    vaddps ymm13, ymm3, ymm0
    vmovaps [r13 + 512], ymm2
    vpminsd ymm1, ymm10, [c_zero]
    vperm2f128 ymm11, ymm4, [rsp + 5600], 3
    vaddps ymm7, ymm13, [rsp + 3424]
    vaddps ymm12, ymm13, [rsp + 5472]
    vshufps ymm3, ymm14, ymm9, 136
    vshufps ymm0, ymm14, ymm9, 221
    vaddps ymm2, ymm6, ymm1
    vaddps ymm10, ymm3, ymm0
    vmovups ymm13, [rsp + 3584]
    vmovaps [rsp + 3936], ymm7
    vpalignr ymm14, ymm4, ymm11, 12
    vmovups ymm9, [c_ones]
    vmovaps [r13 + 448], ymm12
    vaddps ymm6, ymm2, [rsp + 3456]
    vaddps ymm1, ymm2, [rsp + 5504]
    vmovaps [r13 + 544], ymm10
    vmovups ymm3, [rsp + 3936]
    vfmadd231ps ymm14, ymm5, [rsp + 5664]
    vmovaps [rsp + 3968], ymm6
    vperm2f128 ymm0, ymm8, [rsp + 5632], 3
    vmovaps [r13 + 480], ymm1
    vmovups ymm7, [rsp + 3968]
    vpalignr ymm11, ymm8, ymm0, 12
    vfmadd231ps ymm11, ymm13, [rsp + 5664]
    vperm2f128 ymm12, ymm3, ymm4, 3
    vmovaps [rsp + 5600], ymm3
    vperm2f128 ymm2, ymm7, ymm8, 3
    vmovaps [rsp + 5632], ymm7
    vpalignr ymm10, ymm3, ymm12, 12
    vmovaps [rsp + 5664], ymm9
    vaddps ymm5, ymm10, [rsp + 3808]
    vpalignr ymm6, ymm7, ymm2, 12
    vshufps ymm1, ymm14, ymm5, 136
    vshufps ymm0, ymm14, ymm5, 221
    vaddps ymm13, ymm6, [rsp + 3840]
    vaddps ymm4, ymm1, ymm0
    vshufps ymm8, ymm11, ymm13, 136
    vshufps ymm3, ymm11, ymm13, 221
    vmovaps [r13 + 576], ymm4
    vaddps ymm12, ymm8, ymm3
    vmovaps [r13 + 608], ymm12
    vmovups ymm15, [c_h0625]
    vpmovzxwd ymm0, [r0 + r3*2 + 16]
    vpmovzxwd ymm1, [r0 + r3*2 + 32]
    vmovups ymm2, [r8]
    vpmovzxwd ymm3, [r0 + r3*2 + 16 + CRD]
    vpmovzxwd ymm4, [r0 + r3*2 + 32 + CRD]
    vmovups ymm5, [r8 + 32]
    vpsubd ymm6, ymm0, [c_i512]
    vpsubd ymm7, ymm1, [c_i512]
    vcvtdq2ps ymm8, ymm6
    vcvtdq2ps ymm9, ymm7
    vpsubd ymm10, ymm3, [c_i512]
    vcvtdq2ps ymm11, ymm10
    vpsubd ymm12, ymm4, [c_i512]
    vpmovzxwd ymm13, [r0 + r3*2 + 16 + CST]
    vcvtdq2ps ymm14, ymm12
    vmovaps [r8 + 128], ymm8
    vperm2f128 ymm0, ymm2, [r8 - 128], 3
    vperm2f128 ymm1, ymm2, ymm8, 33
    vmovaps [r8 + 256], ymm9
    vperm2f128 ymm6, ymm8, ymm2, 3
    vperm2f128 ymm7, ymm8, ymm9, 33
    vmovaps [r8 + 128 + 32], ymm11
    vperm2f128 ymm3, ymm5, [r8 - 128 + 32], 3
    vperm2f128 ymm10, ymm5, ymm11, 33
    vpsubd ymm4, ymm13, [c_i512]
    vpalignr ymm12, ymm2, ymm0, 12
    vpalignr ymm9, ymm1, ymm2, 4
    vmovaps [r8 + 256 + 32], ymm14
    vcvtdq2ps ymm13, ymm4
    vmovups ymm0, [r8 + SPBC]
    vpalignr ymm4, ymm1, ymm2, 8
    vpalignr ymm1, ymm8, ymm6, 12
    vaddps ymm6, ymm9, ymm2
    vpalignr ymm9, ymm7, ymm8, 4
    vpalignr ymm2, ymm7, ymm8, 8
    vaddps ymm7, ymm12, ymm4
    vpalignr ymm12, ymm5, ymm3, 12
    vpalignr ymm4, ymm10, ymm5, 4
    vmovaps [r8 + 128 + SPBC], ymm13
    vaddps ymm3, ymm9, ymm8
    vaddps ymm9, ymm1, ymm2
    vpalignr ymm8, ymm10, ymm5, 8
    vmulps ymm1, ymm7, ymm15
    vaddps ymm2, ymm4, ymm5
    vperm2f128 ymm10, ymm11, ymm5, 3
    vperm2f128 ymm7, ymm11, ymm14, 33
    vmulps ymm4, ymm9, ymm15
    vaddps ymm5, ymm12, ymm8
    vpmovzxwd ymm14, [r0 + r3*2 + 32 + CST]
    vpmovzxwd ymm9, [r0 + r3*2 + 16 + CST + CRD]
    vperm2f128 ymm12, ymm0, [r8 - 128 + SPBC], 3
    vfmsub231ps ymm1, ymm6, [c_h5625]
    vmulps ymm8, ymm5, ymm15
    vpalignr ymm6, ymm11, ymm10, 12
    vmovups ymm5, [r8 + 32 + SPBC]
    vfmsub231ps ymm4, ymm3, [c_h5625]
    vpalignr ymm10, ymm7, ymm11, 4
    vpalignr ymm3, ymm7, ymm11, 8
    vpsubd ymm7, ymm14, [c_i512]
    vpalignr ymm14, ymm0, ymm12, 12
    vpsubd ymm12, ymm9, [c_i512]
    vfmsub231ps ymm8, ymm2, [c_h5625]
    vaddps ymm9, ymm10, ymm11
    vaddps ymm2, ymm6, ymm3
    vperm2f128 ymm10, ymm0, ymm13, 33
    vmovaps [r8 + 64], ymm1
    vcvtdq2ps ymm11, ymm7
    jmp .j2688
.j2688:
    vperm2f128 ymm6, ymm13, ymm0, 3
    vcvtdq2ps ymm3, ymm12
    vmovaps [r8 + 192], ymm4
    vmulps ymm1, ymm2, ymm15
    vpmovzxwd ymm7, [r0 + r3*2 + 32 + CST + CRD]
    vpalignr ymm12, ymm10, ymm0, 4
    vpalignr ymm4, ymm10, ymm0, 8
    vmovaps [r8 + 64 + 32], ymm8
    vpalignr ymm2, ymm13, ymm6, 12
    vperm2f128 ymm10, ymm13, ymm11, 33
    vfmsub231ps ymm1, ymm9, [c_h5625]
    vmovaps [r8 + 256 + SPBC], ymm11
    vaddps ymm8, ymm12, ymm0
    vaddps ymm6, ymm14, ymm4
    vperm2f128 ymm9, ymm5, [r8 - 128 + 32 + SPBC], 3
    vmovaps [r8 + 128 + 32 + SPBC], ymm3
    vpsubd ymm11, ymm7, [c_i512]
    vperm2f128 ymm12, ymm5, ymm3, 33
    vperm2f128 ymm0, ymm3, ymm5, 3
    vmulps ymm14, ymm6, ymm15
    vpalignr ymm4, ymm10, ymm13, 4
    vpalignr ymm7, ymm10, ymm13, 8
    vcvtdq2ps ymm6, ymm11
    vpalignr ymm10, ymm5, ymm9, 12
    vmovaps [r8 + 192 + 32], ymm1
    vaddps ymm11, ymm4, ymm13
    vaddps ymm9, ymm2, ymm7
    vpalignr ymm1, ymm12, ymm5, 4
    vfmsub231ps ymm14, ymm8, [c_h5625]
    vmovaps [r8 + 256 + 32 + SPBC], ymm6
    vpalignr ymm4, ymm12, ymm5, 8
    vpalignr ymm13, ymm3, ymm0, 12
    vmulps ymm2, ymm9, ymm15
    vaddps ymm7, ymm1, ymm5
    vperm2f128 ymm8, ymm3, ymm6, 33
    vaddps ymm12, ymm10, ymm4
    vmovaps [r8 + 64 + SPBC], ymm14
    vfmsub231ps ymm2, ymm11, [c_h5625]
    vmulps ymm0, ymm12, ymm15
    vpalignr ymm9, ymm8, ymm3, 4
    vpalignr ymm1, ymm8, ymm3, 8
    vaddps ymm5, ymm9, ymm3
    vfmsub231ps ymm0, ymm7, [c_h5625]
    vaddps ymm6, ymm13, ymm1
    vmovaps [r8 + 192 + SPBC], ymm2
    vmulps ymm10, ymm6, ymm15
    vmovaps [r8 + 64 + 32 + SPBC], ymm0
    vfmsub231ps ymm10, ymm5, [c_h5625]
    vmovaps [r8 + 192 + 32 + SPBC], ymm10
    add r4, 256
    add r5, 256
    add r7, 256
    add r8, 256
    xchg r13, r14
    mov r11, r9
    add r9, 32
    mov r6, r10
    add r10, 16
    add r3, 16
    jnz .pair
    mov r2, r4
    lea r4, [r5 - 8*W]
    lea r5, [r7 - 8*W]
    lea r7, [r8 - 8*W]
    lea r8, [r2 - 8*W]
    add r1, 8*W
    add r0, 2*CST
    add r9, W
    sub r12, W
    jnz .period
    vmovups ymm15, [c_xlo]
    vmovups ymm14, [c_ieq]
    vmovups ymm13, [c_eq]
    vmovups ymm12, [c_sign]
    vmovups ymm11, [c_epsf]
    vsubps ymm0, ymm11, [r14 + 96]
    vmovups ymm1, [c_anegl]
    vmovups ymm2, [r14]
    vmovups ymm3, [r14 + 32]
    vrsqrtps ymm4, ymm0
    vmovups ymm5, [r14 + 64]
    vfmadd231ps ymm1, ymm4, [c_snegl]
    vandnps ymm6, ymm12, ymm2
    vandnps ymm7, ymm12, ymm3
    vandnps ymm8, ymm12, ymm5
    vfmadd213ps ymm1, ymm0, [c_tabsl]
    vmovaps ymm9, ymm1
    vfmadd231ps ymm9, ymm6, [c_rgl0]
    vmovaps ymm10, ymm1
    vfmadd231ps ymm10, ymm7, [c_rgl1]
    vfmadd231ps ymm1, ymm8, [c_rgl2]
    vsubps ymm4, ymm6, ymm9
    vsubps ymm2, ymm7, ymm10
    vsubps ymm3, ymm8, ymm1
    vcmpps ymm5, ymm4, ymm15, 30
    vrcpps ymm0, ymm4
    vmovaps [rsp], ymm5
    vandnps ymm4, ymm5, ymm9
    vaddps ymm6, ymm6, ymm4
    vmulps ymm4, ymm9, ymm0
    vcmpps ymm9, ymm2, ymm15, 30
    vrcpps ymm0, ymm2
    vmovaps [rsp + 2016], ymm6
    vandnps ymm2, ymm9, ymm10
    vblendvps ymm6, ymm14, ymm4, ymm5
    vmovaps [rsp + 32], ymm9
    vaddps ymm4, ymm7, ymm2
    vcmpps ymm5, ymm3, ymm15, 30
    vrcpps ymm7, ymm3
    vmovups ymm2, [c_anegl]
    vmulps ymm3, ymm10, ymm0
    vsubps ymm10, ymm11, [r14 + 224]
    vfmadd213ps ymm6, ymm13, [c_oml0]
    vmovaps [rsp + 2080], ymm4
    vandnps ymm0, ymm5, ymm1
    vmovaps [rsp + 64], ymm5
    vaddps ymm4, ymm8, ymm0
    vrsqrtps ymm8, ymm10
    vblendvps ymm0, ymm14, ymm3, ymm9
    vmulps ymm3, ymm1, ymm7
    vmovups ymm9, [r14 + 128]
    vmovups ymm1, [r14 + 160]
    vmovaps [rsp + 2144], ymm4
    vmovups ymm7, [r14 + 192]
    vmovaps [rsp + 2048], ymm6
    vfmadd213ps ymm0, ymm13, [c_oml1]
    vblendvps ymm4, ymm14, ymm3, ymm5
    vfmadd231ps ymm2, ymm8, [c_snegl]
    vfmadd213ps ymm4, ymm13, [c_oml2]
    vmovaps [rsp + 2112], ymm0
    vfmadd213ps ymm2, ymm10, [c_tabsl]
    vandnps ymm6, ymm12, ymm9
    vandnps ymm3, ymm12, ymm1
    vandnps ymm5, ymm12, ymm7
    vmovaps [rsp + 2176], ymm4
    vmovaps ymm8, ymm2
    vfmadd231ps ymm8, ymm6, [c_rgl0]
    vmovaps ymm0, ymm2
    vfmadd231ps ymm0, ymm3, [c_rgl1]
    vfmadd231ps ymm2, ymm5, [c_rgl2]
    vsubps ymm10, ymm6, ymm8
    vsubps ymm9, ymm3, ymm0
    vsubps ymm1, ymm5, ymm2
    vcmpps ymm7, ymm10, ymm15, 30
    vrcpps ymm4, ymm10
    vmovaps [rsp + 96], ymm7
    vandnps ymm10, ymm7, ymm8
    vaddps ymm6, ymm6, ymm10
    vmulps ymm10, ymm8, ymm4
    jmp .j2816
.j2816:
    vcmpps ymm8, ymm9, ymm15, 30
    vrcpps ymm4, ymm9
    vmovaps [rsp + 2208], ymm6
    vandnps ymm9, ymm8, ymm0
    vblendvps ymm6, ymm14, ymm10, ymm7
    vmovaps [rsp + 128], ymm8
    vaddps ymm10, ymm3, ymm9
    vcmpps ymm7, ymm1, ymm15, 30
    vrcpps ymm3, ymm1
    vmovups ymm9, [c_anegl]
    vmulps ymm1, ymm0, ymm4
    vsubps ymm0, ymm11, [r14 + 352]
    vfmadd213ps ymm6, ymm13, [c_oml0]
    vmovaps [rsp + 2272], ymm10
    vandnps ymm4, ymm7, ymm2
    vmovaps [rsp + 160], ymm7
    vaddps ymm10, ymm5, ymm4
    vrsqrtps ymm5, ymm0
    vblendvps ymm4, ymm14, ymm1, ymm8
    vmulps ymm1, ymm2, ymm3
    vmovups ymm8, [r14 + 256]
    vmovups ymm2, [r14 + 288]
    vmovaps [rsp + 2336], ymm10
    vmovups ymm3, [r14 + 320]
    vmovaps [rsp + 2240], ymm6
    vfmadd213ps ymm4, ymm13, [c_oml1]
    vblendvps ymm10, ymm14, ymm1, ymm7
    vfmadd231ps ymm9, ymm5, [c_snegl]
    vfmadd213ps ymm10, ymm13, [c_oml2]
    vmovaps [rsp + 2304], ymm4
    vfmadd213ps ymm9, ymm0, [c_tabsl]
    vandnps ymm6, ymm12, ymm8
    vandnps ymm1, ymm12, ymm2
    vandnps ymm7, ymm12, ymm3
    vmovaps [rsp + 2368], ymm10
    vmovaps ymm5, ymm9
    vfmadd231ps ymm5, ymm6, [c_rgl0]
    vmovaps ymm4, ymm9
    vfmadd231ps ymm4, ymm1, [c_rgl1]
    vfmadd231ps ymm9, ymm7, [c_rgl2]
    vsubps ymm0, ymm6, ymm5
    vsubps ymm8, ymm1, ymm4
    vsubps ymm2, ymm7, ymm9
    vcmpps ymm3, ymm0, ymm15, 30
    vrcpps ymm10, ymm0
    vmovaps [rsp + 192], ymm3
    vandnps ymm0, ymm3, ymm5
    vaddps ymm6, ymm6, ymm0
    vmulps ymm0, ymm5, ymm10
    vcmpps ymm5, ymm8, ymm15, 30
    vrcpps ymm10, ymm8
    vmovaps [rsp + 2400], ymm6
    vandnps ymm8, ymm5, ymm4
    vblendvps ymm6, ymm14, ymm0, ymm3
    vmovaps [rsp + 224], ymm5
    vaddps ymm0, ymm1, ymm8
    vcmpps ymm3, ymm2, ymm15, 30
    vrcpps ymm1, ymm2
    vmovups ymm8, [c_anegl]
    vmulps ymm2, ymm4, ymm10
    vsubps ymm4, ymm11, [r14 + 480]
    vfmadd213ps ymm6, ymm13, [c_oml0]
    vmovaps [rsp + 2464], ymm0
    vandnps ymm10, ymm3, ymm9
    vmovaps [rsp + 256], ymm3
    vaddps ymm0, ymm7, ymm10
    vrsqrtps ymm7, ymm4
    vblendvps ymm10, ymm14, ymm2, ymm5
    vmulps ymm2, ymm9, ymm1
    vmovups ymm5, [r14 + 384]
    vmovups ymm9, [r14 + 416]
    vmovaps [rsp + 2528], ymm0
    vmovups ymm1, [r14 + 448]
    vmovaps [rsp + 2432], ymm6
    vfmadd213ps ymm10, ymm13, [c_oml1]
    vblendvps ymm0, ymm14, ymm2, ymm3
    vfmadd231ps ymm8, ymm7, [c_snegl]
    vfmadd213ps ymm0, ymm13, [c_oml2]
    vmovaps [rsp + 2496], ymm10
    vfmadd213ps ymm8, ymm4, [c_tabsl]
    vandnps ymm6, ymm12, ymm5
    vandnps ymm2, ymm12, ymm9
    vandnps ymm3, ymm12, ymm1
    vmovaps [rsp + 2560], ymm0
    vmovaps ymm7, ymm8
    vfmadd231ps ymm7, ymm6, [c_rgl0]
    vmovaps ymm10, ymm8
    vfmadd231ps ymm10, ymm2, [c_rgl1]
    vfmadd231ps ymm8, ymm3, [c_rgl2]
    vsubps ymm4, ymm6, ymm7
    vsubps ymm5, ymm2, ymm10
    vsubps ymm9, ymm3, ymm8
    vcmpps ymm1, ymm4, ymm15, 30
    vrcpps ymm0, ymm4
    vmovaps [rsp + 288], ymm1
    vandnps ymm4, ymm1, ymm7
    vaddps ymm6, ymm6, ymm4
    vmulps ymm4, ymm7, ymm0
    vcmpps ymm7, ymm5, ymm15, 30
    vrcpps ymm0, ymm5
    vsubps ymm5, ymm11, [r14 + 608]
    vmovaps [rsp + 2592], ymm6
    vblendvps ymm6, ymm14, ymm4, ymm1
    vmovaps [rsp + 320], ymm7
    vandnps ymm4, ymm7, ymm10
    vaddps ymm1, ymm2, ymm4
    vmulps ymm2, ymm10, ymm0
    vcmpps ymm4, ymm9, ymm15, 30
    vrcpps ymm10, ymm9
    vmovups ymm0, [c_anegh]
    vfmadd213ps ymm6, ymm13, [c_oml0]
    vmovaps [rsp + 2656], ymm1
    vandnps ymm9, ymm4, ymm8
    vblendvps ymm1, ymm14, ymm2, ymm7
    vmovaps [rsp + 352], ymm4
    vaddps ymm2, ymm3, ymm9
    vrsqrtps ymm7, ymm5
    vmovups ymm3, [r14 + 512]
    vmulps ymm9, ymm8, ymm10
    vmovups ymm8, [r14 + 544]
    vmovaps [rsp + 2624], ymm6
    vfmadd213ps ymm1, ymm13, [c_oml1]
    vmovups ymm10, [r14 + 576]
    vmovaps [rsp + 2720], ymm2
    vblendvps ymm6, ymm14, ymm9, ymm4
    vfmadd231ps ymm0, ymm7, [c_snegh]
    vmovaps [rsp + 2688], ymm1
    vfmadd213ps ymm6, ymm13, [c_oml2]
    jmp .j2944
.j2944:
    vandnps ymm2, ymm12, ymm3
    vfmadd213ps ymm0, ymm5, [c_tabsh]
    vandnps ymm9, ymm12, ymm8
    vandnps ymm4, ymm12, ymm10
    vmovaps [rsp + 2752], ymm6
    vmovaps ymm7, ymm0
    vfmadd231ps ymm7, ymm2, [c_rgh0]
    vmovaps ymm1, ymm0
    vfmadd231ps ymm1, ymm9, [c_rgh1]
    vfmadd231ps ymm0, ymm4, [c_rgh2]
    vsubps ymm3, ymm2, ymm7
    vsubps ymm5, ymm9, ymm1
    vsubps ymm8, ymm4, ymm0
    vcmpps ymm10, ymm3, ymm15, 30
    vrcpps ymm6, ymm3
    vmovaps [rsp + 384], ymm10
    vandnps ymm3, ymm10, ymm7
    vaddps ymm2, ymm2, ymm3
    vmulps ymm3, ymm7, ymm6
    vcmpps ymm7, ymm5, ymm15, 30
    vrcpps ymm6, ymm5
    vcmpps ymm5, ymm8, ymm15, 30
    vmovaps [rsp + 2784], ymm2
    vrcpps ymm2, ymm8
    vblendvps ymm8, ymm14, ymm3, ymm10
    vmovaps [rsp + 416], ymm7
    vandnps ymm3, ymm7, ymm1
    vaddps ymm10, ymm9, ymm3
    vmulps ymm9, ymm1, ymm6
    vmovaps [rsp + 448], ymm5
    vandnps ymm3, ymm5, ymm0
    vfmadd213ps ymm8, ymm13, [c_omh0]
    vaddps ymm1, ymm4, ymm3
    vmovaps [rsp + 2848], ymm10
    vmulps ymm6, ymm0, ymm2
    vblendvps ymm4, ymm14, ymm9, ymm7
    vmovaps [rsp + 2912], ymm1
    vmovaps [rsp + 2816], ymm8
    vfmadd213ps ymm4, ymm13, [c_omh1]
    vblendvps ymm3, ymm14, ymm6, ymm5
    vfmadd213ps ymm3, ymm13, [c_omh2]
    vmovaps [rsp + 2880], ymm4
    vmovaps [rsp + 2944], ymm3
    vmovups ymm15, [c_sign]
    vmovups ymm14, [c_one]
    vmovups ymm13, [c_q8o0]
    vmovups ymm0, [rsp + 2144]
    vmaxps ymm1, ymm0, [c_xlo]
    vpsrld ymm2, ymm1, 23
    vpsrld ymm3, ymm1, 20
    vpslld ymm4, ymm1, 5
    vpslld ymm5, ymm1, 4
    vpermps ymm6, ymm2, [c_to]
    vpermps ymm7, ymm2, [c_to + 32]
    vpermps ymm8, ymm2, [c_to + 64]
    vpslld ymm9, ymm1, 9
    vpermps ymm10, ymm2, [c_to + 96]
    vpermps ymm11, ymm3, [c_w8o]
    vpsrld ymm12, ymm9, 9
    vpermps ymm0, ymm3, [c_r8o]
    vorps ymm1, ymm12, ymm14
    vmovups ymm2, [rsp + 2016]
    vblendvps ymm9, ymm6, ymm7, ymm4
    vblendvps ymm3, ymm8, ymm10, ymm4
    vfmsub213ps ymm1, ymm0, ymm14
    vblendvps ymm12, ymm9, ymm3, ymm5
    vmulps ymm6, ymm12, ymm11
    vmaxps ymm7, ymm2, [c_xlo]
    vpsrld ymm8, ymm7, 23
    vpsrld ymm10, ymm7, 20
    vpslld ymm4, ymm7, 5
    vpslld ymm0, ymm7, 4
    vpermps ymm9, ymm8, [c_to]
    vpermps ymm3, ymm8, [c_to + 32]
    vpermps ymm5, ymm8, [c_to + 64]
    vpslld ymm12, ymm7, 9
    vpermps ymm11, ymm8, [c_to + 96]
    vpermps ymm2, ymm10, [c_w8o]
    vpsrld ymm7, ymm12, 9
    vmulps ymm8, ymm6, ymm1
    vpermps ymm12, ymm10, [c_r8o]
    vorps ymm10, ymm7, ymm14
    vblendvps ymm7, ymm9, ymm3, ymm4
    vmovups ymm9, [c_q8o2]
    vblendvps ymm3, ymm5, ymm11, ymm4
    vandps ymm5, ymm15, [r14 + 64]
    vmovups ymm11, [c_slkl]
    vfmsub213ps ymm10, ymm12, ymm14
    vmovups ymm4, [rsp + 2080]
    vblendvps ymm12, ymm7, ymm3, ymm0
    vmulps ymm7, ymm12, ymm2
    vfmadd231ps ymm9, ymm1, [c_q8o3]
    vmaxps ymm3, ymm4, [c_xlo]
    vfmadd213ps ymm9, ymm1, [c_q8o1]
    vpsrld ymm0, ymm3, 23
    vpsrld ymm12, ymm3, 20
    vpslld ymm2, ymm3, 5
    vfmadd213ps ymm9, ymm1, ymm13
    vpslld ymm4, ymm3, 4
    vpslld ymm1, ymm3, 9
    vpsrld ymm3, ymm1, 9
    vorps ymm1, ymm3, ymm14
    vfmadd231ps ymm6, ymm8, ymm9
    vpermps ymm3, ymm0, [c_to]
    vpermps ymm8, ymm0, [c_to + 32]
    vmulps ymm9, ymm6, [rsp + 2176]
    vorps ymm6, ymm6, ymm5
    vblendvps ymm5, ymm3, ymm8, ymm2
    vpermps ymm3, ymm12, [c_w8o]
    vandps ymm8, ymm6, [rsp + 64]
    vpermps ymm6, ymm12, [c_r8o]
    vmulps ymm12, ymm8, [c_mtl2]
    vfmadd231ps ymm11, ymm9, [c_mtl2]
    vpermps ymm8, ymm0, [c_to + 64]
    vpermps ymm9, ymm0, [c_to + 96]
    vfmsub213ps ymm1, ymm6, ymm14
    vmovups ymm0, [c_q8o2]
    vblendvps ymm6, ymm8, ymm9, ymm2
    vmulps ymm8, ymm7, ymm10
    vandps ymm9, ymm15, [r14]
    vblendvps ymm2, ymm5, ymm6, ymm4
    vmovups ymm5, [rsp + 2528]
    vmulps ymm6, ymm2, ymm3
    vfmadd231ps ymm0, ymm10, [c_q8o3]
    vfmadd213ps ymm0, ymm10, [c_q8o1]
    vmaxps ymm4, ymm5, [c_xlo]
    vpsrld ymm2, ymm4, 23
    vpsrld ymm3, ymm4, 20
    jmp .j3072
.j3072:
    vfmadd213ps ymm0, ymm10, ymm13
    vpslld ymm5, ymm4, 5
    vfmadd231ps ymm7, ymm8, ymm0
    vpslld ymm10, ymm4, 4
    vpermps ymm8, ymm2, [c_to]
    vpslld ymm0, ymm4, 9
    vpsrld ymm4, ymm0, 9
    vorps ymm0, ymm4, ymm14
    vmulps ymm4, ymm7, [rsp + 2048]
    vorps ymm7, ymm7, ymm9
    vandps ymm9, ymm7, [rsp]
    vfmadd231ps ymm12, ymm9, [c_mtl0]
    vpermps ymm7, ymm2, [c_to + 32]
    vfmadd231ps ymm11, ymm4, [c_mtl0]
    vpermps ymm9, ymm2, [c_to + 64]
    vpermps ymm4, ymm2, [c_to + 96]
    vblendvps ymm2, ymm8, ymm7, ymm5
    vpermps ymm8, ymm3, [c_w8o]
    vpermps ymm7, ymm3, [c_r8o]
    vblendvps ymm3, ymm9, ymm4, ymm5
    vmovups ymm9, [c_q8o2]
    vmulps ymm4, ymm6, ymm1
    vblendvps ymm5, ymm2, ymm3, ymm10
    vfmsub213ps ymm0, ymm7, ymm14
    vandps ymm2, ymm15, [r14 + 32]
    vmulps ymm3, ymm5, ymm8
    vfmadd231ps ymm9, ymm1, [c_q8o3]
    vfmadd213ps ymm9, ymm1, [c_q8o1]
    vmovups ymm10, [rsp + 2400]
    vfmadd213ps ymm9, ymm1, ymm13
    vfmadd231ps ymm6, ymm4, ymm9
    vmaxps ymm7, ymm10, [c_xlo]
    vpsrld ymm5, ymm7, 23
    vpsrld ymm8, ymm7, 20
    vpslld ymm1, ymm7, 5
    vpslld ymm4, ymm7, 4
    vpermps ymm9, ymm5, [c_to]
    vmulps ymm10, ymm6, [rsp + 2112]
    vorps ymm6, ymm6, ymm2
    vandps ymm2, ymm6, [rsp + 32]
    vfmadd231ps ymm12, ymm2, [c_mtl1]
    vpermps ymm6, ymm5, [c_to + 32]
    vfmadd231ps ymm11, ymm10, [c_mtl1]
    vpermps ymm2, ymm5, [c_to + 64]
    vpermps ymm10, ymm5, [c_to + 96]
    vpslld ymm5, ymm7, 9
    vpsrld ymm7, ymm5, 9
    vroundps ymm5, ymm12, 8
    vblendvps ymm9, ymm9, ymm6, ymm1
    vorps ymm6, ymm7, ymm14
    vblendvps ymm7, ymm2, ymm10, ymm1
    vpermps ymm2, ymm8, [c_w8o]
    vpermps ymm10, ymm8, [c_r8o]
    vsubps ymm1, ymm12, ymm5
    vcvtps2dq ymm8, ymm12
    vmovups ymm5, [c_q8o2]
    vblendvps ymm12, ymm9, ymm7, ymm4
    vmulps ymm9, ymm3, ymm0
    vandps ymm7, ymm15, [r14 + 320]
    vandnps ymm4, ymm15, ymm1
    vaddps ymm1, ymm4, ymm11
    vpaddd ymm4, ymm8, [c_i64]
    vfmsub213ps ymm6, ymm10, ymm14
    vmulps ymm11, ymm12, ymm2
    vmovups ymm8, [c_slkl]
    vpminsd ymm10, ymm4, [c_i1023]
    vmovups ymm12, [rsp + 2464]
    vcmpps ymm2, ymm1, [c_half], 5
    vfmadd231ps ymm5, ymm0, [c_q8o3]
    vfmadd213ps ymm5, ymm0, [c_q8o1]
    vmaxps ymm4, ymm12, [c_xlo]
    vpsrld ymm1, ymm4, 23
    vfmadd213ps ymm5, ymm0, ymm13
    vpsrld ymm12, ymm4, 20
    vfmadd231ps ymm3, ymm9, ymm5
    vpslld ymm0, ymm4, 5
    vpslld ymm9, ymm4, 4
    vpslld ymm5, ymm4, 9
    vpsrld ymm4, ymm5, 9
    vorps ymm5, ymm4, ymm14
    vmulps ymm4, ymm3, [rsp + 2560]
    vorps ymm3, ymm3, ymm7
    vandps ymm7, ymm3, [rsp + 256]
    vmulps ymm3, ymm7, [c_mtl2]
    vfmadd231ps ymm8, ymm4, [c_mtl2]
    vpermps ymm7, ymm1, [c_to]
    vpermps ymm4, ymm1, [c_to + 32]
    vblendvps ymm7, ymm7, ymm4, ymm0
    vpermps ymm4, ymm1, [c_to + 64]
    vpermps ymm1, ymm1, [c_to + 96]
    vblendvps ymm4, ymm4, ymm1, ymm0
    vpermps ymm1, ymm12, [c_w8o]
    vpermps ymm0, ymm12, [c_r8o]
    vblendvps ymm12, ymm7, ymm4, ymm9
    vmovups ymm7, [c_q8o2]
    vmulps ymm4, ymm11, ymm6
    vfmsub213ps ymm5, ymm0, ymm14
    vmulps ymm9, ymm12, ymm1
    vandps ymm0, ymm15, [r14 + 256]
    vmovups ymm12, [rsp + 2336]
    vfmadd231ps ymm7, ymm6, [c_q8o3]
    vmaxps ymm1, ymm12, [c_xlo]
    vfmadd213ps ymm7, ymm6, [c_q8o1]
    vfmadd213ps ymm7, ymm6, ymm13
    vpsrld ymm12, ymm1, 23
    vfmadd231ps ymm11, ymm4, ymm7
    vpsrld ymm6, ymm1, 20
    vpslld ymm4, ymm1, 5
    vmulps ymm7, ymm11, [rsp + 2432]
    vorps ymm11, ymm11, ymm0
    vandps ymm0, ymm11, [rsp + 192]
    vfmadd231ps ymm3, ymm0, [c_mtl0]
    vpslld ymm11, ymm1, 4
    vpslld ymm0, ymm1, 9
    vfmadd231ps ymm8, ymm7, [c_mtl0]
    vpermps ymm1, ymm12, [c_to]
    vpsrld ymm7, ymm0, 9
    vpermps ymm0, ymm12, [c_to + 32]
    vblendvps ymm1, ymm1, ymm0, ymm4
    vorps ymm0, ymm7, ymm14
    vpermps ymm7, ymm12, [c_to + 64]
    vpermps ymm12, ymm12, [c_to + 96]
    vblendvps ymm7, ymm7, ymm12, ymm4
    vpermps ymm12, ymm6, [c_w8o]
    vpermps ymm4, ymm6, [c_r8o]
    vblendvps ymm6, ymm1, ymm7, ymm11
    vmovups ymm1, [c_q8o2]
    vmulps ymm7, ymm9, ymm5
    jmp .j3200
.j3200:
    vfmsub213ps ymm0, ymm4, ymm14
    vmulps ymm11, ymm6, ymm12
    vandps ymm4, ymm15, [r14 + 288]
    vfmadd231ps ymm1, ymm5, [c_q8o3]
    vfmadd213ps ymm1, ymm5, [c_q8o1]
    vfmadd213ps ymm1, ymm5, ymm13
    vfmadd231ps ymm9, ymm7, ymm1
    vmulps ymm6, ymm9, [rsp + 2496]
    vorps ymm12, ymm9, ymm4
    vandps ymm5, ymm12, [rsp + 224]
    vfmadd231ps ymm3, ymm5, [c_mtl1]
    vmovups ymm7, [rsp + 2208]
    vfmadd231ps ymm8, ymm6, [c_mtl1]
    vroundps ymm1, ymm3, 8
    vcvtps2dq ymm9, ymm3
    vsubps ymm4, ymm3, ymm1
    vpaddd ymm12, ymm9, [c_i64]
    vmaxps ymm5, ymm7, [c_xlo]
    vpminsd ymm6, ymm12, [c_i1023]
    vandnps ymm3, ymm15, ymm4
    vpackusdw ymm1, ymm10, ymm6
    vpsrld ymm9, ymm5, 23
    vpsrld ymm7, ymm5, 20
    vaddps ymm12, ymm3, ymm8
    vpslld ymm4, ymm5, 5
    vpermps ymm10, ymm9, [c_to]
    vpermq ymm6, ymm1, 216
    vpslld ymm3, ymm5, 4
    vpermps ymm8, ymm9, [c_to + 32]
    vcmpps ymm1, ymm12, [c_half], 5
    vpslld ymm12, ymm5, 9
    vpsrld ymm5, ymm12, 9
    vorps ymm12, ymm5, ymm14
    vmovdqu [r11], ymm6
    vpermps ymm5, ymm9, [c_to + 64]
    vpermps ymm6, ymm9, [c_to + 96]
    vblendvps ymm9, ymm10, ymm8, ymm4
    vptest ymm2, ymm2
    jnz .c5
.r5:
    vptest ymm1, ymm1
    jnz .c6
.r6:
    vmovups ymm10, [c_q8o2]
    vmulps ymm8, ymm11, ymm0
    vandps ymm2, ymm15, [r14 + 192]
    vblendvps ymm1, ymm5, ymm6, ymm4
    vpermps ymm5, ymm7, [c_w8o]
    vpermps ymm6, ymm7, [c_r8o]
    vmovups ymm4, [c_slkl]
    vblendvps ymm7, ymm9, ymm1, ymm3
    vmovups ymm9, [rsp + 2272]
    vfmsub213ps ymm12, ymm6, ymm14
    vmulps ymm1, ymm7, ymm5
    vfmadd231ps ymm10, ymm0, [c_q8o3]
    vfmadd213ps ymm10, ymm0, [c_q8o1]
    vmaxps ymm3, ymm9, [c_xlo]
    vpsrld ymm6, ymm3, 23
    vpsrld ymm7, ymm3, 20
    vpslld ymm5, ymm3, 5
    vfmadd213ps ymm10, ymm0, ymm13
    vpslld ymm9, ymm3, 4
    vpslld ymm0, ymm3, 9
    vpsrld ymm3, ymm0, 9
    vorps ymm0, ymm3, ymm14
    vfmadd231ps ymm11, ymm8, ymm10
    vpermps ymm3, ymm6, [c_to]
    vpermps ymm8, ymm6, [c_to + 32]
    vmulps ymm10, ymm11, [rsp + 2368]
    vorps ymm11, ymm11, ymm2
    vblendvps ymm2, ymm3, ymm8, ymm5
    vpermps ymm3, ymm7, [c_w8o]
    vandps ymm8, ymm11, [rsp + 160]
    vpermps ymm11, ymm7, [c_r8o]
    vmulps ymm7, ymm8, [c_mtl2]
    vfmadd231ps ymm4, ymm10, [c_mtl2]
    vpermps ymm8, ymm6, [c_to + 64]
    vpermps ymm10, ymm6, [c_to + 96]
    vfmsub213ps ymm0, ymm11, ymm14
    vmovups ymm6, [c_q8o2]
    vblendvps ymm11, ymm8, ymm10, ymm5
    vmulps ymm8, ymm1, ymm12
    vandps ymm10, ymm15, [r14 + 128]
    vblendvps ymm5, ymm2, ymm11, ymm9
    vmovups ymm2, [rsp + 2720]
    vmulps ymm11, ymm5, ymm3
    vfmadd231ps ymm6, ymm12, [c_q8o3]
    vfmadd213ps ymm6, ymm12, [c_q8o1]
    vmaxps ymm9, ymm2, [c_xlo]
    vpsrld ymm5, ymm9, 23
    vpsrld ymm3, ymm9, 20
    vfmadd213ps ymm6, ymm12, ymm13
    vpslld ymm2, ymm9, 5
    vfmadd231ps ymm1, ymm8, ymm6
    vpslld ymm12, ymm9, 4
    vpermps ymm8, ymm5, [c_to]
    vpslld ymm6, ymm9, 9
    vpsrld ymm9, ymm6, 9
    vorps ymm6, ymm9, ymm14
    vmulps ymm9, ymm1, [rsp + 2240]
    vorps ymm1, ymm1, ymm10
    vandps ymm10, ymm1, [rsp + 96]
    vfmadd231ps ymm7, ymm10, [c_mtl0]
    vpermps ymm1, ymm5, [c_to + 32]
    vfmadd231ps ymm4, ymm9, [c_mtl0]
    vpermps ymm10, ymm5, [c_to + 64]
    vpermps ymm9, ymm5, [c_to + 96]
    vblendvps ymm5, ymm8, ymm1, ymm2
    vpermps ymm8, ymm3, [c_w8o]
    vpermps ymm1, ymm3, [c_r8o]
    vblendvps ymm3, ymm10, ymm9, ymm2
    vmovups ymm10, [c_q8o2]
    vmulps ymm9, ymm11, ymm0
    vblendvps ymm2, ymm5, ymm3, ymm12
    vfmsub213ps ymm6, ymm1, ymm14
    vandps ymm5, ymm15, [r14 + 160]
    vmulps ymm3, ymm2, ymm8
    vfmadd231ps ymm10, ymm0, [c_q8o3]
    vfmadd213ps ymm10, ymm0, [c_q8o1]
    vmovups ymm12, [rsp + 2592]
    vfmadd213ps ymm10, ymm0, ymm13
    vfmadd231ps ymm11, ymm9, ymm10
    vmaxps ymm1, ymm12, [c_xlo]
    vpsrld ymm2, ymm1, 23
    vpsrld ymm8, ymm1, 20
    vpslld ymm0, ymm1, 5
    vpslld ymm9, ymm1, 4
    vpermps ymm10, ymm2, [c_to]
    vmulps ymm12, ymm11, [rsp + 2304]
    vorps ymm11, ymm11, ymm5
    vandps ymm5, ymm11, [rsp + 128]
    vfmadd231ps ymm7, ymm5, [c_mtl1]
    jmp .j3328
.j3328:
    vpermps ymm11, ymm2, [c_to + 32]
    vfmadd231ps ymm4, ymm12, [c_mtl1]
    vpermps ymm5, ymm2, [c_to + 64]
    vpermps ymm12, ymm2, [c_to + 96]
    vpslld ymm2, ymm1, 9
    vpsrld ymm1, ymm2, 9
    vroundps ymm2, ymm7, 8
    vblendvps ymm10, ymm10, ymm11, ymm0
    vorps ymm11, ymm1, ymm14
    vblendvps ymm1, ymm5, ymm12, ymm0
    vpermps ymm5, ymm8, [c_w8o]
    vpermps ymm12, ymm8, [c_r8o]
    vsubps ymm0, ymm7, ymm2
    vcvtps2dq ymm8, ymm7
    vmovups ymm2, [c_q8o2]
    vblendvps ymm7, ymm10, ymm1, ymm9
    vmulps ymm10, ymm3, ymm6
    vandps ymm1, ymm15, [r14 + 448]
    vandnps ymm9, ymm15, ymm0
    vaddps ymm0, ymm9, ymm4
    vpaddd ymm9, ymm8, [c_i64]
    vfmsub213ps ymm11, ymm12, ymm14
    vmulps ymm4, ymm7, ymm5
    vmovups ymm8, [c_slkl]
    vpminsd ymm12, ymm9, [c_i1023]
    vmovups ymm7, [rsp + 2656]
    vcmpps ymm5, ymm0, [c_half], 5
    vfmadd231ps ymm2, ymm6, [c_q8o3]
    vfmadd213ps ymm2, ymm6, [c_q8o1]
    vmaxps ymm9, ymm7, [c_xlo]
    vpsrld ymm0, ymm9, 23
    vfmadd213ps ymm2, ymm6, ymm13
    vpsrld ymm7, ymm9, 20
    vfmadd231ps ymm3, ymm10, ymm2
    vpslld ymm6, ymm9, 5
    vpslld ymm10, ymm9, 4
    vpslld ymm2, ymm9, 9
    vpsrld ymm9, ymm2, 9
    vorps ymm2, ymm9, ymm14
    vmulps ymm9, ymm3, [rsp + 2752]
    vorps ymm3, ymm3, ymm1
    vandps ymm1, ymm3, [rsp + 352]
    vmulps ymm3, ymm1, [c_mtl2]
    vfmadd231ps ymm8, ymm9, [c_mtl2]
    vpermps ymm1, ymm0, [c_to]
    vpermps ymm9, ymm0, [c_to + 32]
    vblendvps ymm1, ymm1, ymm9, ymm6
    vpermps ymm9, ymm0, [c_to + 64]
    vpermps ymm0, ymm0, [c_to + 96]
    vblendvps ymm9, ymm9, ymm0, ymm6
    vpermps ymm0, ymm7, [c_w8o]
    vpermps ymm6, ymm7, [c_r8o]
    vblendvps ymm7, ymm1, ymm9, ymm10
    vmovups ymm1, [c_q8o2]
    vmulps ymm9, ymm4, ymm11
    vfmsub213ps ymm2, ymm6, ymm14
    vmulps ymm10, ymm7, ymm0
    vandps ymm6, ymm15, [r14 + 384]
    vmovups ymm7, [rsp + 2784]
    vfmadd231ps ymm1, ymm11, [c_q8o3]
    vmaxps ymm0, ymm7, [c_xlo]
    vfmadd213ps ymm1, ymm11, [c_q8o1]
    vfmadd213ps ymm1, ymm11, ymm13
    vpsrld ymm7, ymm0, 23
    vfmadd231ps ymm4, ymm9, ymm1
    vpsrld ymm11, ymm0, 20
    vpslld ymm9, ymm0, 5
    vmulps ymm1, ymm4, [rsp + 2624]
    vorps ymm4, ymm4, ymm6
    vandps ymm6, ymm4, [rsp + 288]
    vfmadd231ps ymm3, ymm6, [c_mtl0]
    vpslld ymm4, ymm0, 4
    vpslld ymm6, ymm0, 9
    vfmadd231ps ymm8, ymm1, [c_mtl0]
    vpermps ymm0, ymm7, [c_to]
    vpsrld ymm1, ymm6, 9
    vpermps ymm6, ymm7, [c_to + 32]
    vblendvps ymm0, ymm0, ymm6, ymm9
    vorps ymm6, ymm1, ymm14
    vpermps ymm1, ymm7, [c_to + 64]
    vpermps ymm7, ymm7, [c_to + 96]
    vblendvps ymm1, ymm1, ymm7, ymm9
    vpermps ymm7, ymm11, [c_w8o]
    vpermps ymm9, ymm11, [c_r8o]
    vblendvps ymm11, ymm0, ymm1, ymm4
    vmovups ymm0, [c_q8o2]
    vmulps ymm1, ymm10, ymm2
    vfmsub213ps ymm6, ymm9, ymm14
    vmulps ymm4, ymm11, ymm7
    vandps ymm9, ymm15, [r14 + 416]
    vfmadd231ps ymm0, ymm2, [c_q8o3]
    vfmadd213ps ymm0, ymm2, [c_q8o1]
    vfmadd213ps ymm0, ymm2, ymm13
    vfmadd231ps ymm10, ymm1, ymm0
    vmulps ymm11, ymm10, [rsp + 2688]
    vorps ymm7, ymm10, ymm9
    vandps ymm2, ymm7, [rsp + 320]
    vfmadd231ps ymm3, ymm2, [c_mtl1]
    vmovups ymm1, [rsp + 2848]
    vfmadd231ps ymm8, ymm11, [c_mtl1]
    vroundps ymm0, ymm3, 8
    vcvtps2dq ymm10, ymm3
    vsubps ymm9, ymm3, ymm0
    vpaddd ymm7, ymm10, [c_i64]
    vmaxps ymm2, ymm1, [c_xlo]
    vpminsd ymm11, ymm7, [c_i1023]
    vandnps ymm3, ymm15, ymm9
    vpackusdw ymm0, ymm12, ymm11
    vpsrld ymm10, ymm2, 23
    vpsrld ymm1, ymm2, 20
    vaddps ymm7, ymm3, ymm8
    vpslld ymm9, ymm2, 5
    vpermps ymm12, ymm10, [c_to]
    vpermq ymm11, ymm0, 216
    vpslld ymm3, ymm2, 4
    vpermps ymm8, ymm10, [c_to + 32]
    vcmpps ymm0, ymm7, [c_half], 5
    vpslld ymm7, ymm2, 9
    vpsrld ymm2, ymm7, 9
    vorps ymm7, ymm2, ymm14
    vmovdqu [r11 + W], ymm11
    vpermps ymm2, ymm10, [c_to + 64]
    vpermps ymm11, ymm10, [c_to + 96]
    vblendvps ymm10, ymm12, ymm8, ymm9
    vptest ymm5, ymm5
    jnz .c7
.r7:
    vptest ymm0, ymm0
    jnz .c8
.r8:
    vmovups ymm12, [c_q8o2]
    vmulps ymm8, ymm4, ymm6
    jmp .j3456
.j3456:
    vandps ymm5, ymm15, [r14 + 512]
    vblendvps ymm0, ymm2, ymm11, ymm9
    vpermps ymm2, ymm1, [c_w8o]
    vpermps ymm11, ymm1, [c_r8o]
    vmovups ymm9, [rsp + 2912]
    vblendvps ymm1, ymm10, ymm0, ymm3
    vfmsub213ps ymm7, ymm11, ymm14
    vmulps ymm10, ymm1, ymm2
    vfmadd231ps ymm12, ymm6, [c_q8o3]
    vmaxps ymm0, ymm9, [c_xlo]
    vfmadd213ps ymm12, ymm6, [c_q8o1]
    vpsrld ymm3, ymm0, 23
    vpsrld ymm11, ymm0, 20
    vpslld ymm1, ymm0, 5
    vpslld ymm2, ymm0, 4
    vpslld ymm9, ymm0, 9
    vfmadd213ps ymm12, ymm6, ymm13
    vpermps ymm0, ymm3, [c_to]
    vpsrld ymm6, ymm9, 9
    vorps ymm9, ymm6, ymm14
    vfmadd231ps ymm4, ymm8, ymm12
    vpermps ymm6, ymm3, [c_to + 32]
    vpermps ymm8, ymm3, [c_to + 64]
    vpermps ymm12, ymm3, [c_to + 96]
    vmulps ymm3, ymm4, [rsp + 2816]
    vorps ymm4, ymm4, ymm5
    vblendvps ymm5, ymm0, ymm6, ymm1
    vpermps ymm0, ymm11, [c_w8o]
    vandps ymm6, ymm4, [rsp + 384]
    vblendvps ymm4, ymm8, ymm12, ymm1
    vpermps ymm8, ymm11, [c_r8o]
    vmulps ymm12, ymm10, ymm7
    vmovups ymm1, [c_q8o2]
    vblendvps ymm11, ymm5, ymm4, ymm2
    vandps ymm5, ymm15, [r14 + 544]
    vmovups ymm4, [c_q8o2]
    vfmsub231ps ymm14, ymm9, ymm8
    vmulps ymm2, ymm11, ymm0
    vandps ymm9, ymm15, [r14 + 576]
    vmulps ymm8, ymm6, [c_mth1]
    vfmadd231ps ymm1, ymm7, [c_q8o3]
    vmulps ymm11, ymm2, ymm14
    vfmadd231ps ymm4, ymm14, [c_q8o3]
    vfmadd213ps ymm1, ymm7, [c_q8o1]
    vfmadd213ps ymm4, ymm14, [c_q8o1]
    vfmadd213ps ymm1, ymm7, ymm13
    vmovups ymm0, [c_slkh0]
    vfmadd231ps ymm13, ymm4, ymm14
    vfmadd231ps ymm10, ymm12, ymm1
    vfmadd231ps ymm2, ymm11, ymm13
    vmovups ymm7, [c_slkh1]
    vfmadd231ps ymm0, ymm3, [c_mth1]
    vmulps ymm4, ymm10, [rsp + 2880]
    vorps ymm14, ymm10, ymm5
    vandps ymm12, ymm14, [rsp + 416]
    vmulps ymm1, ymm2, [rsp + 2944]
    vorps ymm11, ymm2, ymm9
    vandps ymm13, ymm11, [rsp + 448]
    vfmadd231ps ymm8, ymm12, [c_mth2]
    vfmadd231ps ymm0, ymm4, [c_mth2]
    vmulps ymm10, ymm13, [c_mth5]
    vfmadd231ps ymm7, ymm1, [c_mth5]
    vfmsub231ps ymm8, ymm13, [c_mth0]
    vfmadd231ps ymm10, ymm12, [c_mth4]
    vfmadd231ps ymm0, ymm1, [c_mth0]
    vfmadd231ps ymm7, ymm4, [c_mth4]
    vfmsub231ps ymm10, ymm6, [c_mth3]
    vroundps ymm5, ymm8, 8
    vcvtps2dq ymm14, ymm8
    vfmadd231ps ymm7, ymm3, [c_mth3]
    vsubps ymm2, ymm8, ymm5
    vpaddd ymm9, ymm14, [c_i512]
    vmovups ymm11, [c_pd8]
    vpminsd ymm13, ymm9, [c_i1023]
    vroundps ymm12, ymm10, 8
    vcvtps2dq ymm1, ymm10
    vandnps ymm4, ymm15, ymm2
    vaddps ymm6, ymm4, ymm0
    vsubps ymm3, ymm10, ymm12
    vpaddd ymm8, ymm1, [c_i512]
    vcmpps ymm5, ymm6, [c_half], 5
    vpminsd ymm14, ymm8, [c_i1023]
    vandnps ymm9, ymm15, ymm3
    vpackusdw ymm2, ymm13, ymm14
    vaddps ymm4, ymm9, ymm7
    vpermd ymm0, ymm11, ymm2
    vcmpps ymm10, ymm4, [c_half], 5
    vorps ymm12, ymm5, ymm10
    vmovdqu [r6], xmm0
    CRST r6, vextracti128 [CRS r6], ymm0, 1
    vptest ymm12, ymm12
    jnz .c9
.r9:
    mov rsp, [rsp + 7104]
%if WIN64
    vmovdqu xmm6, [rsp]
    vmovdqu xmm7, [rsp + 16]
    vmovdqu xmm8, [rsp + 32]
    vmovdqu xmm9, [rsp + 48]
    vmovdqu xmm10, [rsp + 64]
    vmovdqu xmm11, [rsp + 80]
    vmovdqu xmm12, [rsp + 96]
    vmovdqu xmm13, [rsp + 112]
    vmovdqu xmm14, [rsp + 128]
    vmovdqu xmm15, [rsp + 144]
    add rsp, 160
    pop r8
    pop r7
%endif
    pop r12
    pop r11
    pop r14
    pop r13
    pop r10
    pop r9
    vzeroupper
    ret
.c0:
    mov [rsp + 6976], r1
    mov [rsp + 6984], r0
    mov [rsp + 6992], r2
    vmovmskps r2d, ymm2
    lea r1, [r11]
    lea r0, [r14]
    call .tl
    mov r1, [rsp + 6976]
    mov r0, [rsp + 6984]
    mov r2, [rsp + 6992]
    jmp .r0
.c1:
    mov [rsp + 6976], r1
    mov [rsp + 6984], r0
    mov [rsp + 6992], r2
    vmovmskps r2d, ymm1
    lea r1, [r11 + 16]
    lea r0, [r14 + 256]
    call .tl
    mov r1, [rsp + 6976]
    mov r0, [rsp + 6984]
    mov r2, [rsp + 6992]
    jmp .r1
.c2:
    mov [rsp + 6976], r1
    mov [rsp + 6984], r0
    mov [rsp + 6992], r2
    vmovmskps r2d, ymm5
    lea r1, [r11 + W]
    lea r0, [r14 + 128]
    call .tl
    mov r1, [rsp + 6976]
    mov r0, [rsp + 6984]
    mov r2, [rsp + 6992]
    jmp .r2
.c3:
    mov [rsp + 6976], r1
    mov [rsp + 6984], r0
    mov [rsp + 6992], r2
    vmovmskps r2d, ymm0
    lea r1, [r11 + 16 + W]
    lea r0, [r14 + 384]
    call .tl
    mov r1, [rsp + 6976]
    mov r0, [rsp + 6984]
    mov r2, [rsp + 6992]
    jmp .r3
.c4:
    mov [rsp + 6976], r1
    mov [rsp + 6984], r0
    mov [rsp + 6992], r2
    vmovmskps r2d, ymm12
    mov r1, r6
    lea r0, [r14 + 512]
    call .tc
    mov r1, [rsp + 6976]
    mov r0, [rsp + 6984]
    mov r2, [rsp + 6992]
    jmp .r4
.c5:
    vmovmskps r2d, ymm2
    lea r1, [r11]
    lea r0, [r14]
    call .tl
    jmp .r5
.c6:
    vmovmskps r2d, ymm1
    lea r1, [r11 + 16]
    lea r0, [r14 + 256]
    call .tl
    jmp .r6
.c7:
    vmovmskps r2d, ymm5
    lea r1, [r11 + W]
    lea r0, [r14 + 128]
    call .tl
    jmp .r7
.c8:
    vmovmskps r2d, ymm0
    lea r1, [r11 + 16 + W]
    lea r0, [r14 + 384]
    call .tl
    jmp .r8
.c9:
    vmovmskps r2d, ymm12
    mov r1, r6
    lea r0, [r14 + 512]
    call .tc
    jmp .r9
T_ZS equ 0
T_E equ 512
T_V equ 704
T_V2 equ 736
T_J equ 768
T_X0 equ 800
T_L equ 832
T_XL equ 864
T_SY equ 896
T_SB equ 1024
T_SR equ 1152
T_VB equ 1280
T_AA equ 1344
T_LA equ 1376
T_LV equ 1408
T_TV equ 1440
T_LO equ 1472
T_HI equ 1504
T_LN equ 1536
T_SG equ 1632
T_ZM equ 1664
T_V3 equ 1696
T_X equ 2464
T_ACC equ 3232
T_E3 equ 3296
T_L4 equ 3392
T_K equ 3424
T_RR equ 3456
T_S equ 3520
T_T equ 3584
TSZ equ 3680
.tl:
    push r10
    mov r10, rsp
    push r6
    push r9
    push r3
    push r4
    push r5
    push r7
    push r8
    push r13
    push r14
    push r11
    push r12
    lea r13, [rsp - TSZ]
    and r13, -32
    lea rsp, [r13 - 64]
    vmovapd [r13 + T_ZS], ymm0
    vmovapd [r13 + T_ZS + 32], ymm1
    vmovapd [r13 + T_ZS + 64], ymm2
    vmovapd [r13 + T_ZS + 96], ymm3
    vmovapd [r13 + T_ZS + 128], ymm4
    vmovapd [r13 + T_ZS + 160], ymm5
    vmovapd [r13 + T_ZS + 192], ymm6
    vmovapd [r13 + T_ZS + 224], ymm7
    vmovapd [r13 + T_ZS + 256], ymm8
    vmovapd [r13 + T_ZS + 288], ymm9
    vmovapd [r13 + T_ZS + 320], ymm10
    vmovapd [r13 + T_ZS + 352], ymm11
    vmovapd [r13 + T_ZS + 384], ymm12
    vmovapd [r13 + T_ZS + 416], ymm13
    vmovapd [r13 + T_ZS + 448], ymm14
    vmovapd [r13 + T_ZS + 480], ymm15
    movzx r12d, r2b
    mov r14, r1
    mov r11, r0
    mov r6, r1
    sub r6, [r10 + 16 + S_DST]
    shr r6, 1
    mov r2, r6
    shr r2, 5
    imul r2, r2, MG
    shr r2, 32
    imul r3, r2, 32*M
    sub r6, r3
    mov [r13 + T_J], r2d
    mov [r13 + T_X0], r6d
    mov r9d, r12d
    and r9d, 15
    jz .tl_n0
    lea r0, [r11]
    call .t1l
    vmovdqa [r13 + T_V], xmm4
.tl_l0:
    test r9d, r9d
    jz .tl_n0
    tzcnt r3d, r9d
    blsr r9d, r9d
    mov [r13 + T_L], r3d
    mov r6d, [r13 + T_V + r3*4]
    test r6d, r6d
    js .tl_t0
    jmp .tl_s0
.tl_t0:
    lea r2d, [r3]
    add r2d, [r13 + T_X0]
    mov r6d, r2d
    call .g2l
    call .t2l
    test r6d, r6d
    jns .tl_s0
    call .t3l
.tl_s0:
    mov r3d, [r13 + T_L]
    mov [r14 + r3*2], r6w
    jmp .tl_l0
.tl_n0:
    mov r9d, r12d
    shr r9d, 4
    and r9d, 15
    jz .tl_n1
    lea r0, [r11 + 16]
    call .t1l
    vmovdqa [r13 + T_V], xmm4
.tl_l1:
    test r9d, r9d
    jz .tl_n1
    tzcnt r3d, r9d
    blsr r9d, r9d
    mov [r13 + T_L], r3d
    mov r6d, [r13 + T_V + r3*4]
    test r6d, r6d
    js .tl_t1
    jmp .tl_s1
.tl_t1:
    lea r2d, [r3 + 4]
    add r2d, [r13 + T_X0]
    mov r6d, r2d
    call .g2l
    call .t2l
    test r6d, r6d
    jns .tl_s1
    call .t3l
.tl_s1:
    mov r3d, [r13 + T_L]
    mov [r14 + r3*2 + 8], r6w
    jmp .tl_l1
.tl_n1:
    vmovapd ymm0, [r13 + T_ZS]
    vmovapd ymm1, [r13 + T_ZS + 32]
    vmovapd ymm2, [r13 + T_ZS + 64]
    vmovapd ymm3, [r13 + T_ZS + 96]
    vmovapd ymm4, [r13 + T_ZS + 128]
    vmovapd ymm5, [r13 + T_ZS + 160]
    vmovapd ymm6, [r13 + T_ZS + 192]
    vmovapd ymm7, [r13 + T_ZS + 224]
    vmovapd ymm8, [r13 + T_ZS + 256]
    vmovapd ymm9, [r13 + T_ZS + 288]
    vmovapd ymm10, [r13 + T_ZS + 320]
    vmovapd ymm11, [r13 + T_ZS + 352]
    vmovapd ymm12, [r13 + T_ZS + 384]
    vmovapd ymm13, [r13 + T_ZS + 416]
    vmovapd ymm14, [r13 + T_ZS + 448]
    vmovapd ymm15, [r13 + T_ZS + 480]
    lea rsp, [r10 - 88]
    pop r12
    pop r11
    pop r14
    pop r13
    pop r8
    pop r7
    pop r5
    pop r4
    pop r3
    pop r9
    pop r6
    pop r10
    ret
.tc:
    push r10
    mov r10, rsp
    push r9
    push r3
    push r4
    push r5
    push r7
    push r8
    push r13
    push r14
    push r12
    lea r13, [rsp - TSZ]
    and r13, -32
    lea rsp, [r13 - 64]
    movzx r12d, r2b
    mov r14, r1
    mov r11, r0
    mov r6, r1
    sub r6, [r10 + 16 + S_DST]
    sub r6, [dp + 16]
    shr r6, 1
    mov r2, r6
    shr r2, 4
    imul r2, r2, MG
    shr r2, 32
    imul r3, r2, 16*M
    sub r6, r3
    mov [r13 + T_J], r2d
    mov [r13 + T_X0], r6d
    mov r9d, r12d
    and r9d, 15
    jz .tc_n0
    lea r0, [r11]
    call .t1c
    vmovdqa [r13 + T_V], xmm4
    vmovdqa [r13 + T_V2], xmm5
.tc_l0:
    test r9d, r9d
    jz .tc_n0
    tzcnt r3d, r9d
    blsr r9d, r9d
    mov [r13 + T_L], r3d
    mov r6d, [r13 + T_V + r3*4]
    test r6d, r6d
    js .tc_t0
    mov r2d, [r13 + T_V2 + r3*4]
    shl r2d, 16
    or r6d, r2d
    jmp .tc_s0
.tc_t0:
    lea r2, [u_prm]
    mov r2d, [r2 + r3*4]
    add r2d, [r13 + T_X0]
    mov r6d, r2d
    call .g2c
    call .t2c
    test r6d, r6d
    jns .tc_s0
    call .t3c
.tc_s0:
    mov r3d, [r13 + T_L]
    lea r2, [u_prm]
    mov r3d, [r2 + r3*4]
    mov [r14 + r3*2], r6w
    shr r6d, 16
    CRST r14, mov [CRS r14 + r3*2], r6w
    jmp .tc_l0
.tc_n0:
    mov r9d, r12d
    shr r9d, 4
    and r9d, 15
    jz .tc_n1
    lea r0, [r11 + 16]
    call .t1c
    vmovdqa [r13 + T_V], xmm4
    vmovdqa [r13 + T_V2], xmm5
.tc_l1:
    test r9d, r9d
    jz .tc_n1
    tzcnt r3d, r9d
    blsr r9d, r9d
    mov [r13 + T_L], r3d
    mov r6d, [r13 + T_V + r3*4]
    test r6d, r6d
    js .tc_t1
    mov r2d, [r13 + T_V2 + r3*4]
    shl r2d, 16
    or r6d, r2d
    jmp .tc_s1
.tc_t1:
    lea r2, [u_prm]
    mov r2d, [r2 + r3*4 + 16]
    add r2d, [r13 + T_X0]
    mov r6d, r2d
    call .g2c
    call .t2c
    test r6d, r6d
    jns .tc_s1
    call .t3c
.tc_s1:
    mov r3d, [r13 + T_L]
    lea r2, [u_prm]
    mov r3d, [r2 + r3*4 + 16]
    mov [r14 + r3*2], r6w
    shr r6d, 16
    CRST r14, mov [CRS r14 + r3*2], r6w
    jmp .tc_l1
.tc_n1:
    lea rsp, [r10 - 72]
    pop r12
    pop r14
    pop r13
    pop r8
    pop r7
    pop r5
    pop r4
    pop r3
    pop r9
    pop r10
    ret
.t1l:
    vcvtps2pd ymm0, [r0 + 96]
    vmovapd ymm1, [u_epsn]
    vsubpd ymm1, ymm1, ymm0
    vsqrtpd ymm2, ymm1
    vmovapd ymm3, [u_one]
    vdivpd ymm2, ymm3, ymm2
    vmovapd ymm15, [u_snegl]
    vfmadd213pd ymm15, ymm2, [u_anegl]
    vfmadd213pd ymm15, ymm1, [u_tabsl]
    vmovapd ymm13, [u_slol0]
    vmovapd ymm14, [u_shil0]
    vcvtps2pd ymm0, [r0]
    lea r6, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [u_rgl0]
    vsubpd ymm3, ymm1, ymm2
    vcmppd ymm4, ymm3, ymm2, 0x1e
    vaddpd ymm5, ymm1, ymm2
    vblendvpd ymm5, ymm5, ymm1, ymm4
    vpsrlq ymm7, ymm5, 48
    vpand ymm8, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8], ymm9
    vandpd ymm11, ymm5, [u_mant]
    vorpd ymm11, ymm11, [u_oneb]
    vfmsub213pd ymm11, ymm10, [u_one]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8 + u_ow - u_rx], ymm9
    vpsrlq ymm7, ymm5, 52
    vpand ymm7, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm6, [r6 + ymm7*8 + u_oa - u_rx], ymm9
    vpsrlq ymm7, ymm5, 56
    vpand ymm7, ymm7, [u_i7]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm8, [r6 + ymm7*8 + u_ob - u_rx], ymm9
    vmulpd ymm6, ymm6, ymm8
    vmulpd ymm6, ymm6, ymm10
    vmulpd ymm12, ymm11, ymm11
    vmovapd ymm7, [u_op3]
    vfmadd213pd ymm7, ymm11, [u_op2]
    vmovapd ymm8, [u_op4]
    vfmadd213pd ymm8, ymm12, ymm7
    vmovapd ymm9, [u_op1]
    vfmadd213pd ymm9, ymm11, [u_op0]
    vfmadd213pd ymm8, ymm12, ymm9
    vmulpd ymm6, ymm6, ymm8
    vdivpd ymm7, ymm2, ymm3
    vandpd ymm7, ymm7, ymm4
    vmovapd ymm8, [u_eq0]
    vfmadd213pd ymm8, ymm7, [u_omg]
    vmovapd ymm9, ymm6
    vfnmadd231pd ymm9, ymm8, ymm6
    vandpd ymm9, ymm9, ymm4
    vfmadd213pd ymm8, ymm6, ymm6
    vxorpd ymm10, ymm8, [u_mzero]
    vcmppd ymm11, ymm3, [u_zero], 0x1a
    vblendvpd ymm9, ymm9, ymm10, ymm11
    vxorpd ymm11, ymm9, [u_mzero]
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vfmadd231pd ymm13, ymm9, [u_mtl0]
    vfmadd231pd ymm14, ymm8, [u_mtl0]
    vcvtps2pd ymm0, [r0 + 32]
    lea r6, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [u_rgl1]
    vsubpd ymm3, ymm1, ymm2
    vcmppd ymm4, ymm3, ymm2, 0x1e
    vaddpd ymm5, ymm1, ymm2
    vblendvpd ymm5, ymm5, ymm1, ymm4
    vpsrlq ymm7, ymm5, 48
    vpand ymm8, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8], ymm9
    vandpd ymm11, ymm5, [u_mant]
    vorpd ymm11, ymm11, [u_oneb]
    vfmsub213pd ymm11, ymm10, [u_one]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8 + u_ow - u_rx], ymm9
    vpsrlq ymm7, ymm5, 52
    vpand ymm7, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm6, [r6 + ymm7*8 + u_oa - u_rx], ymm9
    vpsrlq ymm7, ymm5, 56
    vpand ymm7, ymm7, [u_i7]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm8, [r6 + ymm7*8 + u_ob - u_rx], ymm9
    vmulpd ymm6, ymm6, ymm8
    vmulpd ymm6, ymm6, ymm10
    vmulpd ymm12, ymm11, ymm11
    vmovapd ymm7, [u_op3]
    vfmadd213pd ymm7, ymm11, [u_op2]
    vmovapd ymm8, [u_op4]
    vfmadd213pd ymm8, ymm12, ymm7
    vmovapd ymm9, [u_op1]
    vfmadd213pd ymm9, ymm11, [u_op0]
    vfmadd213pd ymm8, ymm12, ymm9
    vmulpd ymm6, ymm6, ymm8
    vdivpd ymm7, ymm2, ymm3
    vandpd ymm7, ymm7, ymm4
    vmovapd ymm8, [u_eq0]
    vfmadd213pd ymm8, ymm7, [u_omg]
    vmovapd ymm9, ymm6
    vfnmadd231pd ymm9, ymm8, ymm6
    vandpd ymm9, ymm9, ymm4
    vfmadd213pd ymm8, ymm6, ymm6
    vxorpd ymm10, ymm8, [u_mzero]
    vcmppd ymm11, ymm3, [u_zero], 0x1a
    vblendvpd ymm9, ymm9, ymm10, ymm11
    vxorpd ymm11, ymm9, [u_mzero]
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vfmadd231pd ymm13, ymm9, [u_mtl1]
    vfmadd231pd ymm14, ymm8, [u_mtl1]
    vcvtps2pd ymm0, [r0 + 64]
    lea r6, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [u_rgl2]
    vsubpd ymm3, ymm1, ymm2
    vcmppd ymm4, ymm3, ymm2, 0x1e
    vaddpd ymm5, ymm1, ymm2
    vblendvpd ymm5, ymm5, ymm1, ymm4
    vpsrlq ymm7, ymm5, 48
    vpand ymm8, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8], ymm9
    vandpd ymm11, ymm5, [u_mant]
    vorpd ymm11, ymm11, [u_oneb]
    vfmsub213pd ymm11, ymm10, [u_one]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8 + u_ow - u_rx], ymm9
    vpsrlq ymm7, ymm5, 52
    vpand ymm7, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm6, [r6 + ymm7*8 + u_oa - u_rx], ymm9
    vpsrlq ymm7, ymm5, 56
    vpand ymm7, ymm7, [u_i7]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm8, [r6 + ymm7*8 + u_ob - u_rx], ymm9
    vmulpd ymm6, ymm6, ymm8
    vmulpd ymm6, ymm6, ymm10
    vmulpd ymm12, ymm11, ymm11
    vmovapd ymm7, [u_op3]
    vfmadd213pd ymm7, ymm11, [u_op2]
    vmovapd ymm8, [u_op4]
    vfmadd213pd ymm8, ymm12, ymm7
    vmovapd ymm9, [u_op1]
    vfmadd213pd ymm9, ymm11, [u_op0]
    vfmadd213pd ymm8, ymm12, ymm9
    vmulpd ymm6, ymm6, ymm8
    vdivpd ymm7, ymm2, ymm3
    vandpd ymm7, ymm7, ymm4
    vmovapd ymm8, [u_eq0]
    vfmadd213pd ymm8, ymm7, [u_omg]
    vmovapd ymm9, ymm6
    vfnmadd231pd ymm9, ymm8, ymm6
    vandpd ymm9, ymm9, ymm4
    vfmadd213pd ymm8, ymm6, ymm6
    vxorpd ymm10, ymm8, [u_mzero]
    vcmppd ymm11, ymm3, [u_zero], 0x1a
    vblendvpd ymm9, ymm9, ymm10, ymm11
    vxorpd ymm11, ymm9, [u_mzero]
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vfmadd231pd ymm13, ymm9, [u_mtl2]
    vfmadd231pd ymm14, ymm8, [u_mtl2]
    vroundpd ymm13, ymm13, 8
    vroundpd ymm14, ymm14, 8
    vcmppd ymm0, ymm13, ymm14, 0
    vmaxpd ymm13, ymm13, [u_zero]
    vminpd ymm13, ymm13, [u_1023]
    vmovapd ymm1, [u_mone]
    vblendvpd ymm1, ymm1, ymm13, ymm0
    vcvtpd2dq xmm4, ymm1
    ret
.t1c:
    vcvtps2pd ymm0, [r0 + 96]
    vmovapd ymm1, [u_epsn]
    vsubpd ymm1, ymm1, ymm0
    vsqrtpd ymm2, ymm1
    vmovapd ymm3, [u_one]
    vdivpd ymm2, ymm3, ymm2
    vmovapd ymm15, [u_snegh]
    vfmadd213pd ymm15, ymm2, [u_anegh]
    vfmadd213pd ymm15, ymm1, [u_tabsh]
    vcvtps2pd ymm0, [r0]
    lea r6, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [u_rgh0]
    vsubpd ymm3, ymm1, ymm2
    vcmppd ymm4, ymm3, ymm2, 0x1e
    vaddpd ymm5, ymm1, ymm2
    vblendvpd ymm5, ymm5, ymm1, ymm4
    vpsrlq ymm7, ymm5, 48
    vpand ymm8, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8], ymm9
    vandpd ymm11, ymm5, [u_mant]
    vorpd ymm11, ymm11, [u_oneb]
    vfmsub213pd ymm11, ymm10, [u_one]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8 + u_ow - u_rx], ymm9
    vpsrlq ymm7, ymm5, 52
    vpand ymm7, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm6, [r6 + ymm7*8 + u_oa - u_rx], ymm9
    vpsrlq ymm7, ymm5, 56
    vpand ymm7, ymm7, [u_i7]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm8, [r6 + ymm7*8 + u_ob - u_rx], ymm9
    vmulpd ymm6, ymm6, ymm8
    vmulpd ymm6, ymm6, ymm10
    vmulpd ymm12, ymm11, ymm11
    vmovapd ymm7, [u_op3]
    vfmadd213pd ymm7, ymm11, [u_op2]
    vmovapd ymm8, [u_op4]
    vfmadd213pd ymm8, ymm12, ymm7
    vmovapd ymm9, [u_op1]
    vfmadd213pd ymm9, ymm11, [u_op0]
    vfmadd213pd ymm8, ymm12, ymm9
    vmulpd ymm6, ymm6, ymm8
    vdivpd ymm7, ymm2, ymm3
    vandpd ymm7, ymm7, ymm4
    vmovapd ymm8, [u_eq0]
    vfmadd213pd ymm8, ymm7, [u_omg]
    vmovapd ymm9, ymm6
    vfnmadd231pd ymm9, ymm8, ymm6
    vandpd ymm9, ymm9, ymm4
    vfmadd213pd ymm8, ymm6, ymm6
    vxorpd ymm10, ymm8, [u_mzero]
    vcmppd ymm11, ymm3, [u_zero], 0x1a
    vblendvpd ymm9, ymm9, ymm10, ymm11
    vxorpd ymm11, ymm9, [u_mzero]
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vmovapd [r13 + T_E], ymm9
    vmovapd [r13 + T_E + 32], ymm8
    vcvtps2pd ymm0, [r0 + 32]
    lea r6, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [u_rgh1]
    vsubpd ymm3, ymm1, ymm2
    vcmppd ymm4, ymm3, ymm2, 0x1e
    vaddpd ymm5, ymm1, ymm2
    vblendvpd ymm5, ymm5, ymm1, ymm4
    vpsrlq ymm7, ymm5, 48
    vpand ymm8, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8], ymm9
    vandpd ymm11, ymm5, [u_mant]
    vorpd ymm11, ymm11, [u_oneb]
    vfmsub213pd ymm11, ymm10, [u_one]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8 + u_ow - u_rx], ymm9
    vpsrlq ymm7, ymm5, 52
    vpand ymm7, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm6, [r6 + ymm7*8 + u_oa - u_rx], ymm9
    vpsrlq ymm7, ymm5, 56
    vpand ymm7, ymm7, [u_i7]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm8, [r6 + ymm7*8 + u_ob - u_rx], ymm9
    vmulpd ymm6, ymm6, ymm8
    vmulpd ymm6, ymm6, ymm10
    vmulpd ymm12, ymm11, ymm11
    vmovapd ymm7, [u_op3]
    vfmadd213pd ymm7, ymm11, [u_op2]
    vmovapd ymm8, [u_op4]
    vfmadd213pd ymm8, ymm12, ymm7
    vmovapd ymm9, [u_op1]
    vfmadd213pd ymm9, ymm11, [u_op0]
    vfmadd213pd ymm8, ymm12, ymm9
    vmulpd ymm6, ymm6, ymm8
    vdivpd ymm7, ymm2, ymm3
    vandpd ymm7, ymm7, ymm4
    vmovapd ymm8, [u_eq0]
    vfmadd213pd ymm8, ymm7, [u_omg]
    vmovapd ymm9, ymm6
    vfnmadd231pd ymm9, ymm8, ymm6
    vandpd ymm9, ymm9, ymm4
    vfmadd213pd ymm8, ymm6, ymm6
    vxorpd ymm10, ymm8, [u_mzero]
    vcmppd ymm11, ymm3, [u_zero], 0x1a
    vblendvpd ymm9, ymm9, ymm10, ymm11
    vxorpd ymm11, ymm9, [u_mzero]
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vmovapd [r13 + T_E + 64], ymm9
    vmovapd [r13 + T_E + 96], ymm8
    vcvtps2pd ymm0, [r0 + 64]
    lea r6, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [u_rgh2]
    vsubpd ymm3, ymm1, ymm2
    vcmppd ymm4, ymm3, ymm2, 0x1e
    vaddpd ymm5, ymm1, ymm2
    vblendvpd ymm5, ymm5, ymm1, ymm4
    vpsrlq ymm7, ymm5, 48
    vpand ymm8, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8], ymm9
    vandpd ymm11, ymm5, [u_mant]
    vorpd ymm11, ymm11, [u_oneb]
    vfmsub213pd ymm11, ymm10, [u_one]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8 + u_ow - u_rx], ymm9
    vpsrlq ymm7, ymm5, 52
    vpand ymm7, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm6, [r6 + ymm7*8 + u_oa - u_rx], ymm9
    vpsrlq ymm7, ymm5, 56
    vpand ymm7, ymm7, [u_i7]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm8, [r6 + ymm7*8 + u_ob - u_rx], ymm9
    vmulpd ymm6, ymm6, ymm8
    vmulpd ymm6, ymm6, ymm10
    vmulpd ymm12, ymm11, ymm11
    vmovapd ymm7, [u_op3]
    vfmadd213pd ymm7, ymm11, [u_op2]
    vmovapd ymm8, [u_op4]
    vfmadd213pd ymm8, ymm12, ymm7
    vmovapd ymm9, [u_op1]
    vfmadd213pd ymm9, ymm11, [u_op0]
    vfmadd213pd ymm8, ymm12, ymm9
    vmulpd ymm6, ymm6, ymm8
    vdivpd ymm7, ymm2, ymm3
    vandpd ymm7, ymm7, ymm4
    vmovapd ymm8, [u_eq0]
    vfmadd213pd ymm8, ymm7, [u_omg]
    vmovapd ymm9, ymm6
    vfnmadd231pd ymm9, ymm8, ymm6
    vandpd ymm9, ymm9, ymm4
    vfmadd213pd ymm8, ymm6, ymm6
    vxorpd ymm10, ymm8, [u_mzero]
    vcmppd ymm11, ymm3, [u_zero], 0x1a
    vblendvpd ymm9, ymm9, ymm10, ymm11
    vxorpd ymm11, ymm9, [u_mzero]
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vmovapd [r13 + T_E + 128], ymm9
    vmovapd [r13 + T_E + 160], ymm8
    vmovapd ymm13, [u_sloh0]
    vmovapd ymm2, [r13 + T_E + 96]
    vfnmadd231pd ymm13, ymm2, [u_mth2]
    vmovapd ymm2, [r13 + T_E + 32]
    vfnmadd231pd ymm13, ymm2, [u_mth1]
    vmovapd ymm2, [r13 + T_E + 128]
    vfmadd231pd ymm13, ymm2, [u_mth0]
    vmovapd ymm14, [u_shih0]
    vmovapd ymm2, [r13 + T_E + 64]
    vfnmadd231pd ymm14, ymm2, [u_mth2]
    vmovapd ymm2, [r13 + T_E]
    vfnmadd231pd ymm14, ymm2, [u_mth1]
    vmovapd ymm2, [r13 + T_E + 160]
    vfmadd231pd ymm14, ymm2, [u_mth0]
    vroundpd ymm13, ymm13, 8
    vroundpd ymm14, ymm14, 8
    vcmppd ymm0, ymm13, ymm14, 0
    vmaxpd ymm13, ymm13, [u_zero]
    vminpd ymm13, ymm13, [u_1023]
    vmovapd ymm1, [u_mone]
    vblendvpd ymm1, ymm1, ymm13, ymm0
    vcvtpd2dq xmm4, ymm1
    vmovapd ymm13, [u_sloh1]
    vmovapd ymm2, [r13 + T_E + 160]
    vfnmadd231pd ymm13, ymm2, [u_mth5]
    vmovapd ymm2, [r13 + T_E + 96]
    vfnmadd231pd ymm13, ymm2, [u_mth4]
    vmovapd ymm2, [r13 + T_E]
    vfmadd231pd ymm13, ymm2, [u_mth3]
    vmovapd ymm14, [u_shih1]
    vmovapd ymm2, [r13 + T_E + 128]
    vfnmadd231pd ymm14, ymm2, [u_mth5]
    vmovapd ymm2, [r13 + T_E + 64]
    vfnmadd231pd ymm14, ymm2, [u_mth4]
    vmovapd ymm2, [r13 + T_E + 32]
    vfmadd231pd ymm14, ymm2, [u_mth3]
    vroundpd ymm13, ymm13, 8
    vroundpd ymm14, ymm14, 8
    vcmppd ymm0, ymm13, ymm14, 0
    vmaxpd ymm13, ymm13, [u_zero]
    vminpd ymm13, ymm13, [u_1023]
    vmovapd ymm1, [u_mone]
    vblendvpd ymm1, ymm1, ymm13, ymm0
    vcvtpd2dq xmm5, ymm1
    vpcmpeqd xmm3, xmm3, xmm3
    vpcmpeqd xmm3, xmm3, xmm5
    vpor xmm4, xmm4, xmm3
    ret
.t2l:
    lea r6, [u_rx]
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r13 + T_AA], ymm0
    vmovapd [r13 + T_LA], ymm0
    vmovapd ymm0, [r13 + T_SY]
    vmovapd ymm1, [r13 + T_SB]
    vmovapd ymm2, [r13 + T_SR]
    vmovapd ymm3, [u_lzm5]
    vfmadd231pd ymm3, ymm0, [u_lzm0]
    vmovapd ymm4, ymm3
    vfmadd231pd ymm4, ymm2, [u_lzm1]
    vmovapd ymm5, ymm3
    vfmadd231pd ymm5, ymm2, [u_lzm2]
    vfmadd231pd ymm5, ymm1, [u_lzm3]
    vfmadd231pd ymm3, ymm1, [u_lzm4]
    vandpd ymm6, ymm4, [u_absm]
    vmaxpd ymm6, ymm6, [u_xflr]
    vpsrlq ymm7, ymm6, 52
    vpsrlq ymm8, ymm6, 48
    vpand ymm8, ymm8, [u_i15]
    vpand ymm9, ymm7, [u_i15]
    vpcmpeqq ymm11, ymm11, ymm11
    vgatherqpd ymm10, [r6 + ymm9*8 + u_tsl - u_rx], ymm11
    vpand ymm9, ymm7, [u_i16]
    vpxor ymm11, ymm11, ymm11
    vpcmpeqq ymm9, ymm9, ymm11
    vmulpd ymm11, ymm10, [u_tsk]
    vblendvpd ymm10, ymm10, ymm11, ymm9
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [r6 + ymm8*8 + u_wsx - u_rx], ymm9
    vmulpd ymm10, ymm10, ymm11
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [r6 + ymm8*8], ymm9
    vandpd ymm7, ymm6, [u_mant]
    vorpd ymm7, ymm7, [u_oneb]
    vfmsub213pd ymm7, ymm11, [u_one]
    vaddpd ymm9, ymm7, [u_psx3]
    vfmadd213pd ymm9, ymm7, [u_psx2]
    vfmadd213pd ymm9, ymm7, [u_psx1]
    vfmadd213pd ymm9, ymm7, [u_psx0]
    vmulpd ymm12, ymm10, ymm9
    vandpd ymm13, ymm4, [u_mzero]
    vorpd ymm13, ymm13, ymm12
    vextractf128 xmm11, ymm12, 1
    vhaddpd xmm12, xmm12, xmm11
    vpermilpd xmm11, xmm12, 1
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r13 + T_AA]
    vmovsd [r13 + T_AA], xmm12
    vextractf128 xmm11, ymm13, 1
    vhaddpd xmm13, xmm13, xmm11
    vpermilpd xmm11, xmm13, 1
    vaddsd xmm13, xmm13, xmm11
    vaddsd xmm13, xmm13, [r13 + T_LA]
    vmovsd [r13 + T_LA], xmm13
    vandpd ymm6, ymm5, [u_absm]
    vmaxpd ymm6, ymm6, [u_xflr]
    vpsrlq ymm7, ymm6, 52
    vpsrlq ymm8, ymm6, 48
    vpand ymm8, ymm8, [u_i15]
    vpand ymm9, ymm7, [u_i15]
    vpcmpeqq ymm11, ymm11, ymm11
    vgatherqpd ymm10, [r6 + ymm9*8 + u_tsl - u_rx], ymm11
    vpand ymm9, ymm7, [u_i16]
    vpxor ymm11, ymm11, ymm11
    vpcmpeqq ymm9, ymm9, ymm11
    vmulpd ymm11, ymm10, [u_tsk]
    vblendvpd ymm10, ymm10, ymm11, ymm9
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [r6 + ymm8*8 + u_wsx - u_rx], ymm9
    vmulpd ymm10, ymm10, ymm11
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [r6 + ymm8*8], ymm9
    vandpd ymm7, ymm6, [u_mant]
    vorpd ymm7, ymm7, [u_oneb]
    vfmsub213pd ymm7, ymm11, [u_one]
    vaddpd ymm9, ymm7, [u_psx3]
    vfmadd213pd ymm9, ymm7, [u_psx2]
    vfmadd213pd ymm9, ymm7, [u_psx1]
    vfmadd213pd ymm9, ymm7, [u_psx0]
    vmulpd ymm12, ymm10, ymm9
    vandpd ymm13, ymm5, [u_mzero]
    vorpd ymm13, ymm13, ymm12
    vextractf128 xmm11, ymm12, 1
    vhaddpd xmm12, xmm12, xmm11
    vpermilpd xmm11, xmm12, 1
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r13 + T_AA + 8]
    vmovsd [r13 + T_AA + 8], xmm12
    vextractf128 xmm11, ymm13, 1
    vhaddpd xmm13, xmm13, xmm11
    vpermilpd xmm11, xmm13, 1
    vaddsd xmm13, xmm13, xmm11
    vaddsd xmm13, xmm13, [r13 + T_LA + 8]
    vmovsd [r13 + T_LA + 8], xmm13
    vandpd ymm6, ymm3, [u_absm]
    vmaxpd ymm6, ymm6, [u_xflr]
    vpsrlq ymm7, ymm6, 52
    vpsrlq ymm8, ymm6, 48
    vpand ymm8, ymm8, [u_i15]
    vpand ymm9, ymm7, [u_i15]
    vpcmpeqq ymm11, ymm11, ymm11
    vgatherqpd ymm10, [r6 + ymm9*8 + u_tsl - u_rx], ymm11
    vpand ymm9, ymm7, [u_i16]
    vpxor ymm11, ymm11, ymm11
    vpcmpeqq ymm9, ymm9, ymm11
    vmulpd ymm11, ymm10, [u_tsk]
    vblendvpd ymm10, ymm10, ymm11, ymm9
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [r6 + ymm8*8 + u_wsx - u_rx], ymm9
    vmulpd ymm10, ymm10, ymm11
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [r6 + ymm8*8], ymm9
    vandpd ymm7, ymm6, [u_mant]
    vorpd ymm7, ymm7, [u_oneb]
    vfmsub213pd ymm7, ymm11, [u_one]
    vaddpd ymm9, ymm7, [u_psx3]
    vfmadd213pd ymm9, ymm7, [u_psx2]
    vfmadd213pd ymm9, ymm7, [u_psx1]
    vfmadd213pd ymm9, ymm7, [u_psx0]
    vmulpd ymm12, ymm10, ymm9
    vandpd ymm13, ymm3, [u_mzero]
    vorpd ymm13, ymm13, ymm12
    vextractf128 xmm11, ymm12, 1
    vhaddpd xmm12, xmm12, xmm11
    vpermilpd xmm11, xmm12, 1
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r13 + T_AA + 16]
    vmovsd [r13 + T_AA + 16], xmm12
    vextractf128 xmm11, ymm13, 1
    vhaddpd xmm13, xmm13, xmm11
    vpermilpd xmm11, xmm13, 1
    vaddsd xmm13, xmm13, xmm11
    vaddsd xmm13, xmm13, [r13 + T_LA + 16]
    vmovsd [r13 + T_LA + 16], xmm13
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r13 + T_LV], ymm0
    vmovsd xmm1, [u_tab]
    vmovsd [r13 + T_TV + 24], xmm1
    vmovsd xmm2, [r13 + T_LA]
    vmulsd xmm2, xmm2, [u_quart]
    vmovsd [r13 + T_LV], xmm2
    vandpd xmm3, xmm2, [u_absm]
    vmovsd xmm4, [r13 + T_AA]
    vfmsub132sd xmm4, xmm3, [u_quart]
    vmovsd xmm5, [u_rg2]
    vfmadd213sd xmm4, xmm5, [u_tab]
    vmovsd [r13 + T_TV], xmm4
    vmovsd xmm2, [r13 + T_LA + 8]
    vmulsd xmm2, xmm2, [u_quart]
    vmovsd [r13 + T_LV + 8], xmm2
    vandpd xmm3, xmm2, [u_absm]
    vmovsd xmm4, [r13 + T_AA + 8]
    vfmsub132sd xmm4, xmm3, [u_quart]
    vmovsd xmm5, [u_rg2]
    vfmadd213sd xmm4, xmm5, [u_tab]
    vmovsd [r13 + T_TV + 8], xmm4
    vmovsd xmm2, [r13 + T_LA + 16]
    vmulsd xmm2, xmm2, [u_quart]
    vmovsd [r13 + T_LV + 16], xmm2
    vandpd xmm3, xmm2, [u_absm]
    vmovsd xmm4, [r13 + T_AA + 16]
    vfmsub132sd xmm4, xmm3, [u_quart]
    vmovsd xmm5, [u_rg2]
    vfmadd213sd xmm4, xmm5, [u_tab]
    vmovsd [r13 + T_TV + 16], xmm4
    vmovapd ymm0, [r13 + T_LV]
    vmovapd ymm15, [r13 + T_TV]
    lea r6, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [u_rg2]
    vsubpd ymm3, ymm1, ymm2
    vcmppd ymm4, ymm3, ymm2, 0x1e
    vaddpd ymm5, ymm1, ymm2
    vblendvpd ymm5, ymm5, ymm1, ymm4
    vpsrlq ymm7, ymm5, 48
    vpand ymm8, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8], ymm9
    vandpd ymm11, ymm5, [u_mant]
    vorpd ymm11, ymm11, [u_oneb]
    vfmsub213pd ymm11, ymm10, [u_one]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8 + u_ow - u_rx], ymm9
    vpsrlq ymm7, ymm5, 52
    vpand ymm7, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm6, [r6 + ymm7*8 + u_oa - u_rx], ymm9
    vpsrlq ymm7, ymm5, 56
    vpand ymm7, ymm7, [u_i7]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm8, [r6 + ymm7*8 + u_ob - u_rx], ymm9
    vmulpd ymm6, ymm6, ymm8
    vmulpd ymm6, ymm6, ymm10
    vmulpd ymm12, ymm11, ymm11
    vmovapd ymm7, [u_op3]
    vfmadd213pd ymm7, ymm11, [u_op2]
    vmovapd ymm8, [u_op4]
    vfmadd213pd ymm8, ymm12, ymm7
    vmovapd ymm9, [u_op1]
    vfmadd213pd ymm9, ymm11, [u_op0]
    vfmadd213pd ymm8, ymm12, ymm9
    vmulpd ymm6, ymm6, ymm8
    vdivpd ymm7, ymm2, ymm3
    vandpd ymm7, ymm7, ymm4
    vmovapd ymm8, [u_eq0]
    vfmadd213pd ymm8, ymm7, [u_omg]
    vmovapd ymm9, ymm6
    vfnmadd231pd ymm9, ymm8, ymm6
    vandpd ymm9, ymm9, ymm4
    vfmadd213pd ymm8, ymm6, ymm6
    vxorpd ymm10, ymm8, [u_mzero]
    vcmppd ymm11, ymm3, [u_zero], 0x1a
    vblendvpd ymm9, ymm9, ymm10, ymm11
    vxorpd ymm11, ymm9, [u_mzero]
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vmovapd [r13 + T_LO], ymm9
    vmovapd [r13 + T_HI], ymm8
    vmovsd xmm0, [u_ylo]
    vmovsd xmm1, [u_emc0]
    vfmadd231sd xmm0, xmm1, [r13 + T_LO]
    vmovsd xmm1, [u_emc1]
    vfmadd231sd xmm0, xmm1, [r13 + T_LO + 8]
    vmovsd xmm1, [u_emc2]
    vfmadd231sd xmm0, xmm1, [r13 + T_LO + 16]
    vmovsd xmm2, [u_yhi]
    vmovsd xmm1, [u_emc0]
    vfmadd231sd xmm2, xmm1, [r13 + T_HI]
    vmovsd xmm1, [u_emc1]
    vfmadd231sd xmm2, xmm1, [r13 + T_HI + 8]
    vmovsd xmm1, [u_emc2]
    vfmadd231sd xmm2, xmm1, [r13 + T_HI + 16]
    vroundsd xmm0, xmm0, xmm0, 8
    vroundsd xmm2, xmm2, xmm2, 8
    vmovq r6, xmm0
    vmovq r3, xmm2
    vcvttsd2si r2d, xmm0
    xor r1d, r1d
    test r2d, r2d
    cmovs r2d, r1d
    mov r1d, 1023
    cmp r2d, r1d
    cmovg r2d, r1d
    mov r1d, -1
    cmp r6, r3
    cmovne r2d, r1d
    mov r6d, r2d
    ret
.t2c:
    lea r6, [u_rx]
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r13 + T_AA], ymm0
    vmovapd [r13 + T_LA], ymm0
    xor r5d, r5d
.t2c_g:
    vmovapd ymm0, [r13 + r5 + T_SY]
    vmovapd ymm1, [r13 + r5 + T_SB]
    vmovapd ymm2, [r13 + r5 + T_SR]
    vmovapd ymm3, [u_lzm5]
    vfmadd231pd ymm3, ymm0, [u_lzm0]
    vmovapd ymm4, ymm3
    vfmadd231pd ymm4, ymm2, [u_lzm1]
    vmovapd ymm5, ymm3
    vfmadd231pd ymm5, ymm2, [u_lzm2]
    vfmadd231pd ymm5, ymm1, [u_lzm3]
    vfmadd231pd ymm3, ymm1, [u_lzm4]
    vandpd ymm6, ymm4, [u_absm]
    vmaxpd ymm6, ymm6, [u_xflr]
    vpsrlq ymm7, ymm6, 52
    vpsrlq ymm8, ymm6, 48
    vpand ymm8, ymm8, [u_i15]
    vpand ymm9, ymm7, [u_i15]
    vpcmpeqq ymm11, ymm11, ymm11
    vgatherqpd ymm10, [r6 + ymm9*8 + u_tsl - u_rx], ymm11
    vpand ymm9, ymm7, [u_i16]
    vpxor ymm11, ymm11, ymm11
    vpcmpeqq ymm9, ymm9, ymm11
    vmulpd ymm11, ymm10, [u_tsk]
    vblendvpd ymm10, ymm10, ymm11, ymm9
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [r6 + ymm8*8 + u_wsx - u_rx], ymm9
    vmulpd ymm10, ymm10, ymm11
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [r6 + ymm8*8], ymm9
    vandpd ymm7, ymm6, [u_mant]
    vorpd ymm7, ymm7, [u_oneb]
    vfmsub213pd ymm7, ymm11, [u_one]
    vaddpd ymm9, ymm7, [u_psx3]
    vfmadd213pd ymm9, ymm7, [u_psx2]
    vfmadd213pd ymm9, ymm7, [u_psx1]
    vfmadd213pd ymm9, ymm7, [u_psx0]
    vmulpd ymm12, ymm10, ymm9
    vandpd ymm13, ymm4, [u_mzero]
    vorpd ymm13, ymm13, ymm12
    vextractf128 xmm11, ymm12, 1
    vhaddpd xmm12, xmm12, xmm11
    vpermilpd xmm11, xmm12, 1
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r13 + T_AA]
    vmovsd [r13 + T_AA], xmm12
    vextractf128 xmm11, ymm13, 1
    vhaddpd xmm13, xmm13, xmm11
    vpermilpd xmm11, xmm13, 1
    vaddsd xmm13, xmm13, xmm11
    vaddsd xmm13, xmm13, [r13 + T_LA]
    vmovsd [r13 + T_LA], xmm13
    vandpd ymm6, ymm5, [u_absm]
    vmaxpd ymm6, ymm6, [u_xflr]
    vpsrlq ymm7, ymm6, 52
    vpsrlq ymm8, ymm6, 48
    vpand ymm8, ymm8, [u_i15]
    vpand ymm9, ymm7, [u_i15]
    vpcmpeqq ymm11, ymm11, ymm11
    vgatherqpd ymm10, [r6 + ymm9*8 + u_tsl - u_rx], ymm11
    vpand ymm9, ymm7, [u_i16]
    vpxor ymm11, ymm11, ymm11
    vpcmpeqq ymm9, ymm9, ymm11
    vmulpd ymm11, ymm10, [u_tsk]
    vblendvpd ymm10, ymm10, ymm11, ymm9
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [r6 + ymm8*8 + u_wsx - u_rx], ymm9
    vmulpd ymm10, ymm10, ymm11
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [r6 + ymm8*8], ymm9
    vandpd ymm7, ymm6, [u_mant]
    vorpd ymm7, ymm7, [u_oneb]
    vfmsub213pd ymm7, ymm11, [u_one]
    vaddpd ymm9, ymm7, [u_psx3]
    vfmadd213pd ymm9, ymm7, [u_psx2]
    vfmadd213pd ymm9, ymm7, [u_psx1]
    vfmadd213pd ymm9, ymm7, [u_psx0]
    vmulpd ymm12, ymm10, ymm9
    vandpd ymm13, ymm5, [u_mzero]
    vorpd ymm13, ymm13, ymm12
    vextractf128 xmm11, ymm12, 1
    vhaddpd xmm12, xmm12, xmm11
    vpermilpd xmm11, xmm12, 1
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r13 + T_AA + 8]
    vmovsd [r13 + T_AA + 8], xmm12
    vextractf128 xmm11, ymm13, 1
    vhaddpd xmm13, xmm13, xmm11
    vpermilpd xmm11, xmm13, 1
    vaddsd xmm13, xmm13, xmm11
    vaddsd xmm13, xmm13, [r13 + T_LA + 8]
    vmovsd [r13 + T_LA + 8], xmm13
    vandpd ymm6, ymm3, [u_absm]
    vmaxpd ymm6, ymm6, [u_xflr]
    vpsrlq ymm7, ymm6, 52
    vpsrlq ymm8, ymm6, 48
    vpand ymm8, ymm8, [u_i15]
    vpand ymm9, ymm7, [u_i15]
    vpcmpeqq ymm11, ymm11, ymm11
    vgatherqpd ymm10, [r6 + ymm9*8 + u_tsl - u_rx], ymm11
    vpand ymm9, ymm7, [u_i16]
    vpxor ymm11, ymm11, ymm11
    vpcmpeqq ymm9, ymm9, ymm11
    vmulpd ymm11, ymm10, [u_tsk]
    vblendvpd ymm10, ymm10, ymm11, ymm9
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [r6 + ymm8*8 + u_wsx - u_rx], ymm9
    vmulpd ymm10, ymm10, ymm11
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm11, [r6 + ymm8*8], ymm9
    vandpd ymm7, ymm6, [u_mant]
    vorpd ymm7, ymm7, [u_oneb]
    vfmsub213pd ymm7, ymm11, [u_one]
    vaddpd ymm9, ymm7, [u_psx3]
    vfmadd213pd ymm9, ymm7, [u_psx2]
    vfmadd213pd ymm9, ymm7, [u_psx1]
    vfmadd213pd ymm9, ymm7, [u_psx0]
    vmulpd ymm12, ymm10, ymm9
    vandpd ymm13, ymm3, [u_mzero]
    vorpd ymm13, ymm13, ymm12
    vextractf128 xmm11, ymm12, 1
    vhaddpd xmm12, xmm12, xmm11
    vpermilpd xmm11, xmm12, 1
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm12, xmm12, [r13 + T_AA + 16]
    vmovsd [r13 + T_AA + 16], xmm12
    vextractf128 xmm11, ymm13, 1
    vhaddpd xmm13, xmm13, xmm11
    vpermilpd xmm11, xmm13, 1
    vaddsd xmm13, xmm13, xmm11
    vaddsd xmm13, xmm13, [r13 + T_LA + 16]
    vmovsd [r13 + T_LA + 16], xmm13
    add r5, 32
    cmp r5, 128
    jne .t2c_g
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r13 + T_LV], ymm0
    vmovsd xmm1, [u_tab]
    vmovsd [r13 + T_TV + 24], xmm1
    vmovsd xmm2, [r13 + T_LA]
    vmulsd xmm2, xmm2, [u_six]
    vmovsd [r13 + T_LV], xmm2
    vandpd xmm3, xmm2, [u_absm]
    vmovsd xmm4, [r13 + T_AA]
    vfmsub132sd xmm4, xmm3, [u_six]
    vmovsd xmm5, [u_rg2]
    vfmadd213sd xmm4, xmm5, [u_tab]
    vmovsd [r13 + T_TV], xmm4
    vmovsd xmm2, [r13 + T_LA + 8]
    vmulsd xmm2, xmm2, [u_six]
    vmovsd [r13 + T_LV + 8], xmm2
    vandpd xmm3, xmm2, [u_absm]
    vmovsd xmm4, [r13 + T_AA + 8]
    vfmsub132sd xmm4, xmm3, [u_six]
    vmovsd xmm5, [u_rg2]
    vfmadd213sd xmm4, xmm5, [u_tab]
    vmovsd [r13 + T_TV + 8], xmm4
    vmovsd xmm2, [r13 + T_LA + 16]
    vmulsd xmm2, xmm2, [u_six]
    vmovsd [r13 + T_LV + 16], xmm2
    vandpd xmm3, xmm2, [u_absm]
    vmovsd xmm4, [r13 + T_AA + 16]
    vfmsub132sd xmm4, xmm3, [u_six]
    vmovsd xmm5, [u_rg2]
    vfmadd213sd xmm4, xmm5, [u_tab]
    vmovsd [r13 + T_TV + 16], xmm4
    vmovapd ymm0, [r13 + T_LV]
    vmovapd ymm15, [r13 + T_TV]
    lea r6, [u_rx]
    vandpd ymm1, ymm0, [u_absm]
    vmovapd ymm2, ymm15
    vfmadd231pd ymm2, ymm1, [u_rg2]
    vsubpd ymm3, ymm1, ymm2
    vcmppd ymm4, ymm3, ymm2, 0x1e
    vaddpd ymm5, ymm1, ymm2
    vblendvpd ymm5, ymm5, ymm1, ymm4
    vpsrlq ymm7, ymm5, 48
    vpand ymm8, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8], ymm9
    vandpd ymm11, ymm5, [u_mant]
    vorpd ymm11, ymm11, [u_oneb]
    vfmsub213pd ymm11, ymm10, [u_one]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm10, [r6 + ymm8*8 + u_ow - u_rx], ymm9
    vpsrlq ymm7, ymm5, 52
    vpand ymm7, ymm7, [u_i15]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm6, [r6 + ymm7*8 + u_oa - u_rx], ymm9
    vpsrlq ymm7, ymm5, 56
    vpand ymm7, ymm7, [u_i7]
    vpcmpeqq ymm9, ymm9, ymm9
    vgatherqpd ymm8, [r6 + ymm7*8 + u_ob - u_rx], ymm9
    vmulpd ymm6, ymm6, ymm8
    vmulpd ymm6, ymm6, ymm10
    vmulpd ymm12, ymm11, ymm11
    vmovapd ymm7, [u_op3]
    vfmadd213pd ymm7, ymm11, [u_op2]
    vmovapd ymm8, [u_op4]
    vfmadd213pd ymm8, ymm12, ymm7
    vmovapd ymm9, [u_op1]
    vfmadd213pd ymm9, ymm11, [u_op0]
    vfmadd213pd ymm8, ymm12, ymm9
    vmulpd ymm6, ymm6, ymm8
    vdivpd ymm7, ymm2, ymm3
    vandpd ymm7, ymm7, ymm4
    vmovapd ymm8, [u_eq0]
    vfmadd213pd ymm8, ymm7, [u_omg]
    vmovapd ymm9, ymm6
    vfnmadd231pd ymm9, ymm8, ymm6
    vandpd ymm9, ymm9, ymm4
    vfmadd213pd ymm8, ymm6, ymm6
    vxorpd ymm10, ymm8, [u_mzero]
    vcmppd ymm11, ymm3, [u_zero], 0x1a
    vblendvpd ymm9, ymm9, ymm10, ymm11
    vxorpd ymm11, ymm9, [u_mzero]
    vblendvpd ymm9, ymm9, ymm10, ymm0
    vblendvpd ymm8, ymm8, ymm11, ymm0
    vmovapd [r13 + T_LO], ymm9
    vmovapd [r13 + T_HI], ymm8
    vmovsd xmm0, [u_clo]
    vmovsd xmm1, [u_emc5]
    vfnmadd231sd xmm0, xmm1, [r13 + T_HI + 8]
    vmovsd xmm1, [u_emc4]
    vfnmadd231sd xmm0, xmm1, [r13 + T_HI]
    vmovsd xmm1, [u_emc3]
    vfmadd231sd xmm0, xmm1, [r13 + T_LO + 16]
    vmovsd xmm2, [u_chi]
    vmovsd xmm1, [u_emc5]
    vfnmadd231sd xmm2, xmm1, [r13 + T_LO + 8]
    vmovsd xmm1, [u_emc4]
    vfnmadd231sd xmm2, xmm1, [r13 + T_LO]
    vmovsd xmm1, [u_emc3]
    vfmadd231sd xmm2, xmm1, [r13 + T_HI + 16]
    vroundsd xmm0, xmm0, xmm0, 8
    vroundsd xmm2, xmm2, xmm2, 8
    vmovq r6, xmm0
    vmovq r3, xmm2
    vcvttsd2si r2d, xmm0
    xor r1d, r1d
    test r2d, r2d
    cmovs r2d, r1d
    mov r1d, 1023
    cmp r2d, r1d
    cmovg r2d, r1d
    mov r1d, -1
    cmp r6, r3
    cmovne r2d, r1d
    mov r6d, r2d
    mov r4d, r6d
    vmovsd xmm0, [u_clo]
    vmovsd xmm1, [u_emc8]
    vfnmadd231sd xmm0, xmm1, [r13 + T_HI + 16]
    vmovsd xmm1, [u_emc7]
    vfnmadd231sd xmm0, xmm1, [r13 + T_HI + 8]
    vmovsd xmm1, [u_emc6]
    vfmadd231sd xmm0, xmm1, [r13 + T_LO]
    vmovsd xmm2, [u_chi]
    vmovsd xmm1, [u_emc8]
    vfnmadd231sd xmm2, xmm1, [r13 + T_LO + 16]
    vmovsd xmm1, [u_emc7]
    vfnmadd231sd xmm2, xmm1, [r13 + T_LO + 8]
    vmovsd xmm1, [u_emc6]
    vfmadd231sd xmm2, xmm1, [r13 + T_HI]
    vroundsd xmm0, xmm0, xmm0, 8
    vroundsd xmm2, xmm2, xmm2, 8
    vmovq r6, xmm0
    vmovq r3, xmm2
    vcvttsd2si r2d, xmm0
    xor r1d, r1d
    test r2d, r2d
    cmovs r2d, r1d
    mov r1d, 1023
    cmp r2d, r1d
    cmovg r2d, r1d
    mov r1d, -1
    cmp r6, r3
    cmovne r2d, r1d
    mov r6d, r2d
    mov r3d, r6d
    or r3d, r4d
    shl r6d, 16
    or r6d, r4d
    test r3d, r3d
    mov r3d, -1
    cmovs r6d, r3d
    ret
.t3l:
    vxorpd ymm0, ymm0, ymm0
    vmovapd ymm1, [r13 + T_SY]
    vmovapd ymm2, [r13 + T_SB]
    vmovapd ymm3, [r13 + T_SR]
    vbroadcastsd ymm4, [u_ysc]
    vbroadcastsd ymm5, [u_ysc + 8]
    vmulpd ymm6, ymm1, ymm4
    vmovapd ymm7, ymm6
    vfmsub231pd ymm7, ymm1, ymm4
    vmulpd ymm8, ymm0, ymm4
    vfmadd231pd ymm8, ymm1, ymm5
    vaddpd ymm7, ymm7, ymm8
    vaddpd ymm8, ymm6, ymm7
    vsubpd ymm9, ymm8, ymm6
    vsubpd ymm9, ymm7, ymm9
    vbroadcastsd ymm1, [u_yof]
    vbroadcastsd ymm5, [u_yof + 8]
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
    vbroadcastsd ymm5, [u_rcr]
    vbroadcastsd ymm1, [u_rcr + 8]
    vmulpd ymm9, ymm5, ymm3
    vmovapd ymm8, ymm9
    vfmsub231pd ymm8, ymm5, ymm3
    vmulpd ymm10, ymm1, ymm3
    vfmadd231pd ymm10, ymm5, ymm0
    vaddpd ymm8, ymm8, ymm10
    vaddpd ymm10, ymm9, ymm8
    vsubpd ymm7, ymm10, ymm9
    vsubpd ymm7, ymm8, ymm7
    vaddpd ymm1, ymm11, ymm10
    vsubpd ymm5, ymm1, ymm11
    vsubpd ymm8, ymm1, ymm5
    vsubpd ymm8, ymm11, ymm8
    vsubpd ymm5, ymm10, ymm5
    vaddpd ymm8, ymm8, ymm5
    vaddpd ymm5, ymm6, ymm7
    vsubpd ymm9, ymm5, ymm6
    vsubpd ymm4, ymm5, ymm9
    vsubpd ymm4, ymm6, ymm4
    vsubpd ymm9, ymm7, ymm9
    vaddpd ymm4, ymm4, ymm9
    vaddpd ymm9, ymm8, ymm5
    vaddpd ymm5, ymm1, ymm9
    vsubpd ymm8, ymm5, ymm1
    vsubpd ymm8, ymm9, ymm8
    vaddpd ymm9, ymm8, ymm4
    vaddpd ymm4, ymm5, ymm9
    vsubpd ymm8, ymm4, ymm5
    vsubpd ymm8, ymm9, ymm8
    vmovapd [r13 + T_V3], ymm4
    vmovapd [r13 + T_V3 + 32], ymm8
    vbroadcastsd ymm8, [u_gcr]
    vbroadcastsd ymm4, [u_gcr + 8]
    vmulpd ymm7, ymm8, ymm3
    vmovapd ymm10, ymm7
    vfmsub231pd ymm10, ymm8, ymm3
    vmulpd ymm9, ymm4, ymm3
    vfmadd231pd ymm9, ymm8, ymm0
    vaddpd ymm10, ymm10, ymm9
    vaddpd ymm9, ymm7, ymm10
    vsubpd ymm5, ymm9, ymm7
    vsubpd ymm5, ymm10, ymm5
    vaddpd ymm4, ymm11, ymm9
    vsubpd ymm8, ymm4, ymm11
    vsubpd ymm10, ymm4, ymm8
    vsubpd ymm10, ymm11, ymm10
    vsubpd ymm8, ymm9, ymm8
    vaddpd ymm10, ymm10, ymm8
    vaddpd ymm8, ymm6, ymm5
    vsubpd ymm7, ymm8, ymm6
    vsubpd ymm1, ymm8, ymm7
    vsubpd ymm1, ymm6, ymm1
    vsubpd ymm7, ymm5, ymm7
    vaddpd ymm1, ymm1, ymm7
    vaddpd ymm7, ymm10, ymm8
    vaddpd ymm8, ymm4, ymm7
    vsubpd ymm10, ymm8, ymm4
    vsubpd ymm10, ymm7, ymm10
    vaddpd ymm7, ymm10, ymm1
    vaddpd ymm1, ymm8, ymm7
    vsubpd ymm10, ymm1, ymm8
    vsubpd ymm10, ymm7, ymm10
    vbroadcastsd ymm3, [u_gcb]
    vbroadcastsd ymm5, [u_gcb + 8]
    vmulpd ymm9, ymm3, ymm2
    vmovapd ymm7, ymm9
    vfmsub231pd ymm7, ymm3, ymm2
    vmulpd ymm8, ymm5, ymm2
    vfmadd231pd ymm8, ymm3, ymm0
    vaddpd ymm7, ymm7, ymm8
    vaddpd ymm8, ymm9, ymm7
    vsubpd ymm4, ymm8, ymm9
    vsubpd ymm4, ymm7, ymm4
    vaddpd ymm5, ymm1, ymm8
    vsubpd ymm3, ymm5, ymm1
    vsubpd ymm7, ymm5, ymm3
    vsubpd ymm7, ymm1, ymm7
    vsubpd ymm3, ymm8, ymm3
    vaddpd ymm7, ymm7, ymm3
    vaddpd ymm3, ymm10, ymm4
    vsubpd ymm9, ymm3, ymm10
    vsubpd ymm12, ymm3, ymm9
    vsubpd ymm12, ymm10, ymm12
    vsubpd ymm9, ymm4, ymm9
    vaddpd ymm12, ymm12, ymm9
    vaddpd ymm9, ymm7, ymm3
    vaddpd ymm3, ymm5, ymm9
    vsubpd ymm7, ymm3, ymm5
    vsubpd ymm7, ymm9, ymm7
    vaddpd ymm9, ymm7, ymm12
    vaddpd ymm12, ymm3, ymm9
    vsubpd ymm7, ymm12, ymm3
    vsubpd ymm7, ymm9, ymm7
    vmovapd [r13 + T_V3 + 64], ymm12
    vmovapd [r13 + T_V3 + 96], ymm7
    vbroadcastsd ymm7, [u_bcb]
    vbroadcastsd ymm12, [u_bcb + 8]
    vmulpd ymm10, ymm7, ymm2
    vmovapd ymm1, ymm10
    vfmsub231pd ymm1, ymm7, ymm2
    vmulpd ymm4, ymm12, ymm2
    vfmadd231pd ymm4, ymm7, ymm0
    vaddpd ymm1, ymm1, ymm4
    vaddpd ymm4, ymm10, ymm1
    vsubpd ymm8, ymm4, ymm10
    vsubpd ymm8, ymm1, ymm8
    vaddpd ymm12, ymm11, ymm4
    vsubpd ymm7, ymm12, ymm11
    vsubpd ymm1, ymm12, ymm7
    vsubpd ymm1, ymm11, ymm1
    vsubpd ymm7, ymm4, ymm7
    vaddpd ymm1, ymm1, ymm7
    vaddpd ymm7, ymm6, ymm8
    vsubpd ymm10, ymm7, ymm6
    vsubpd ymm9, ymm7, ymm10
    vsubpd ymm9, ymm6, ymm9
    vsubpd ymm10, ymm8, ymm10
    vaddpd ymm9, ymm9, ymm10
    vaddpd ymm10, ymm1, ymm7
    vaddpd ymm7, ymm12, ymm10
    vsubpd ymm1, ymm7, ymm12
    vsubpd ymm1, ymm10, ymm1
    vaddpd ymm10, ymm1, ymm9
    vaddpd ymm9, ymm7, ymm10
    vsubpd ymm1, ymm9, ymm7
    vsubpd ymm1, ymm10, ymm1
    vmovapd [r13 + T_V3 + 128], ymm9
    vmovapd [r13 + T_V3 + 160], ymm1
    xor r7d, r7d
.t3l_b:
    vmovapd ymm14, [r13 + r7 + T_V3]
    vmovapd ymm15, [r7 + r13 + T_V3 + 32]
    call .xeo
    vmovapd [r13 + r7 + T_X], ymm14
    vmovapd [r7 + r13 + T_X + 32], ymm15
    add r7, 64
    cmp r7, 192
    jne .t3l_b
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r13 + T_ACC], ymm0
    vmovapd [r13 + T_ACC + 32], ymm0
    vxorpd xmm0, xmm0, xmm0
    vxorpd xmm1, xmm1, xmm1
    vmovsd xmm2, [r13 + T_X]
    vmovsd xmm3, [r13 + T_X + 32]
    vaddsd xmm4, xmm0, xmm2
    vsubsd xmm5, xmm4, xmm0
    vsubsd xmm6, xmm4, xmm5
    vsubsd xmm6, xmm0, xmm6
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm6, xmm6, xmm5
    vaddsd xmm5, xmm1, xmm3
    vsubsd xmm7, xmm5, xmm1
    vsubsd xmm8, xmm5, xmm7
    vsubsd xmm8, xmm1, xmm8
    vsubsd xmm7, xmm3, xmm7
    vaddsd xmm8, xmm8, xmm7
    vaddsd xmm7, xmm6, xmm5
    vaddsd xmm5, xmm4, xmm7
    vsubsd xmm6, xmm5, xmm4
    vsubsd xmm6, xmm7, xmm6
    vaddsd xmm7, xmm6, xmm8
    vaddsd xmm8, xmm5, xmm7
    vsubsd xmm6, xmm8, xmm5
    vsubsd xmm6, xmm7, xmm6
    vmovsd xmm3, [r13 + T_X + 8]
    vmovsd xmm2, [r13 + T_X + 40]
    vaddsd xmm7, xmm8, xmm3
    vsubsd xmm5, xmm7, xmm8
    vsubsd xmm4, xmm7, xmm5
    vsubsd xmm4, xmm8, xmm4
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm6, xmm2
    vsubsd xmm9, xmm5, xmm6
    vsubsd xmm10, xmm5, xmm9
    vsubsd xmm10, xmm6, xmm10
    vsubsd xmm9, xmm2, xmm9
    vaddsd xmm10, xmm10, xmm9
    vaddsd xmm9, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm9
    vsubsd xmm4, xmm5, xmm7
    vsubsd xmm4, xmm9, xmm4
    vaddsd xmm9, xmm4, xmm10
    vaddsd xmm10, xmm5, xmm9
    vsubsd xmm4, xmm10, xmm5
    vsubsd xmm4, xmm9, xmm4
    vmovsd xmm2, [r13 + T_X + 16]
    vmovsd xmm3, [r13 + T_X + 48]
    vaddsd xmm6, xmm10, xmm2
    vsubsd xmm8, xmm6, xmm10
    vsubsd xmm9, xmm6, xmm8
    vsubsd xmm9, xmm10, xmm9
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm9, xmm9, xmm8
    vaddsd xmm8, xmm4, xmm3
    vsubsd xmm5, xmm8, xmm4
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm7, xmm4, xmm7
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm7, xmm7, xmm5
    vaddsd xmm5, xmm9, xmm8
    vaddsd xmm8, xmm6, xmm5
    vsubsd xmm9, xmm8, xmm6
    vsubsd xmm9, xmm5, xmm9
    vaddsd xmm5, xmm9, xmm7
    vaddsd xmm7, xmm8, xmm5
    vsubsd xmm9, xmm7, xmm8
    vsubsd xmm9, xmm5, xmm9
    vmovsd xmm3, [r13 + T_X + 24]
    vmovsd xmm2, [r13 + T_X + 56]
    vaddsd xmm4, xmm7, xmm3
    vsubsd xmm10, xmm4, xmm7
    vsubsd xmm5, xmm4, xmm10
    vsubsd xmm5, xmm7, xmm5
    vsubsd xmm10, xmm3, xmm10
    vaddsd xmm5, xmm5, xmm10
    vaddsd xmm10, xmm9, xmm2
    vsubsd xmm8, xmm10, xmm9
    vsubsd xmm6, xmm10, xmm8
    vsubsd xmm6, xmm9, xmm6
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm6, xmm6, xmm8
    vaddsd xmm8, xmm5, xmm10
    vaddsd xmm10, xmm4, xmm8
    vsubsd xmm5, xmm10, xmm4
    vsubsd xmm5, xmm8, xmm5
    vaddsd xmm8, xmm5, xmm6
    vaddsd xmm6, xmm10, xmm8
    vsubsd xmm5, xmm6, xmm10
    vsubsd xmm5, xmm8, xmm5
    vmovsd [r13 + T_ACC], xmm6
    vmovsd [r13 + T_ACC + 32], xmm5
    vxorpd xmm0, xmm0, xmm0
    vxorpd xmm1, xmm1, xmm1
    vmovsd xmm2, [r13 + T_X + 64]
    vmovsd xmm3, [r13 + T_X + 96]
    vaddsd xmm4, xmm0, xmm2
    vsubsd xmm5, xmm4, xmm0
    vsubsd xmm6, xmm4, xmm5
    vsubsd xmm6, xmm0, xmm6
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm6, xmm6, xmm5
    vaddsd xmm5, xmm1, xmm3
    vsubsd xmm7, xmm5, xmm1
    vsubsd xmm8, xmm5, xmm7
    vsubsd xmm8, xmm1, xmm8
    vsubsd xmm7, xmm3, xmm7
    vaddsd xmm8, xmm8, xmm7
    vaddsd xmm7, xmm6, xmm5
    vaddsd xmm5, xmm4, xmm7
    vsubsd xmm6, xmm5, xmm4
    vsubsd xmm6, xmm7, xmm6
    vaddsd xmm7, xmm6, xmm8
    vaddsd xmm8, xmm5, xmm7
    vsubsd xmm6, xmm8, xmm5
    vsubsd xmm6, xmm7, xmm6
    vmovsd xmm3, [r13 + T_X + 72]
    vmovsd xmm2, [r13 + T_X + 104]
    vaddsd xmm7, xmm8, xmm3
    vsubsd xmm5, xmm7, xmm8
    vsubsd xmm4, xmm7, xmm5
    vsubsd xmm4, xmm8, xmm4
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm6, xmm2
    vsubsd xmm9, xmm5, xmm6
    vsubsd xmm10, xmm5, xmm9
    vsubsd xmm10, xmm6, xmm10
    vsubsd xmm9, xmm2, xmm9
    vaddsd xmm10, xmm10, xmm9
    vaddsd xmm9, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm9
    vsubsd xmm4, xmm5, xmm7
    vsubsd xmm4, xmm9, xmm4
    vaddsd xmm9, xmm4, xmm10
    vaddsd xmm10, xmm5, xmm9
    vsubsd xmm4, xmm10, xmm5
    vsubsd xmm4, xmm9, xmm4
    vmovsd xmm2, [r13 + T_X + 80]
    vmovsd xmm3, [r13 + T_X + 112]
    vaddsd xmm6, xmm10, xmm2
    vsubsd xmm8, xmm6, xmm10
    vsubsd xmm9, xmm6, xmm8
    vsubsd xmm9, xmm10, xmm9
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm9, xmm9, xmm8
    vaddsd xmm8, xmm4, xmm3
    vsubsd xmm5, xmm8, xmm4
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm7, xmm4, xmm7
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm7, xmm7, xmm5
    vaddsd xmm5, xmm9, xmm8
    vaddsd xmm8, xmm6, xmm5
    vsubsd xmm9, xmm8, xmm6
    vsubsd xmm9, xmm5, xmm9
    vaddsd xmm5, xmm9, xmm7
    vaddsd xmm7, xmm8, xmm5
    vsubsd xmm9, xmm7, xmm8
    vsubsd xmm9, xmm5, xmm9
    vmovsd xmm3, [r13 + T_X + 88]
    vmovsd xmm2, [r13 + T_X + 120]
    vaddsd xmm4, xmm7, xmm3
    vsubsd xmm10, xmm4, xmm7
    vsubsd xmm5, xmm4, xmm10
    vsubsd xmm5, xmm7, xmm5
    vsubsd xmm10, xmm3, xmm10
    vaddsd xmm5, xmm5, xmm10
    vaddsd xmm10, xmm9, xmm2
    vsubsd xmm8, xmm10, xmm9
    vsubsd xmm6, xmm10, xmm8
    vsubsd xmm6, xmm9, xmm6
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm6, xmm6, xmm8
    vaddsd xmm8, xmm5, xmm10
    vaddsd xmm10, xmm4, xmm8
    vsubsd xmm5, xmm10, xmm4
    vsubsd xmm5, xmm8, xmm5
    vaddsd xmm8, xmm5, xmm6
    vaddsd xmm6, xmm10, xmm8
    vsubsd xmm5, xmm6, xmm10
    vsubsd xmm5, xmm8, xmm5
    vmovsd [r13 + T_ACC + 8], xmm6
    vmovsd [r13 + T_ACC + 40], xmm5
    vxorpd xmm0, xmm0, xmm0
    vxorpd xmm1, xmm1, xmm1
    vmovsd xmm2, [r13 + T_X + 128]
    vmovsd xmm3, [r13 + T_X + 160]
    vaddsd xmm4, xmm0, xmm2
    vsubsd xmm5, xmm4, xmm0
    vsubsd xmm6, xmm4, xmm5
    vsubsd xmm6, xmm0, xmm6
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm6, xmm6, xmm5
    vaddsd xmm5, xmm1, xmm3
    vsubsd xmm7, xmm5, xmm1
    vsubsd xmm8, xmm5, xmm7
    vsubsd xmm8, xmm1, xmm8
    vsubsd xmm7, xmm3, xmm7
    vaddsd xmm8, xmm8, xmm7
    vaddsd xmm7, xmm6, xmm5
    vaddsd xmm5, xmm4, xmm7
    vsubsd xmm6, xmm5, xmm4
    vsubsd xmm6, xmm7, xmm6
    vaddsd xmm7, xmm6, xmm8
    vaddsd xmm8, xmm5, xmm7
    vsubsd xmm6, xmm8, xmm5
    vsubsd xmm6, xmm7, xmm6
    vmovsd xmm3, [r13 + T_X + 136]
    vmovsd xmm2, [r13 + T_X + 168]
    vaddsd xmm7, xmm8, xmm3
    vsubsd xmm5, xmm7, xmm8
    vsubsd xmm4, xmm7, xmm5
    vsubsd xmm4, xmm8, xmm4
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm6, xmm2
    vsubsd xmm9, xmm5, xmm6
    vsubsd xmm10, xmm5, xmm9
    vsubsd xmm10, xmm6, xmm10
    vsubsd xmm9, xmm2, xmm9
    vaddsd xmm10, xmm10, xmm9
    vaddsd xmm9, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm9
    vsubsd xmm4, xmm5, xmm7
    vsubsd xmm4, xmm9, xmm4
    vaddsd xmm9, xmm4, xmm10
    vaddsd xmm10, xmm5, xmm9
    vsubsd xmm4, xmm10, xmm5
    vsubsd xmm4, xmm9, xmm4
    vmovsd xmm2, [r13 + T_X + 144]
    vmovsd xmm3, [r13 + T_X + 176]
    vaddsd xmm6, xmm10, xmm2
    vsubsd xmm8, xmm6, xmm10
    vsubsd xmm9, xmm6, xmm8
    vsubsd xmm9, xmm10, xmm9
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm9, xmm9, xmm8
    vaddsd xmm8, xmm4, xmm3
    vsubsd xmm5, xmm8, xmm4
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm7, xmm4, xmm7
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm7, xmm7, xmm5
    vaddsd xmm5, xmm9, xmm8
    vaddsd xmm8, xmm6, xmm5
    vsubsd xmm9, xmm8, xmm6
    vsubsd xmm9, xmm5, xmm9
    vaddsd xmm5, xmm9, xmm7
    vaddsd xmm7, xmm8, xmm5
    vsubsd xmm9, xmm7, xmm8
    vsubsd xmm9, xmm5, xmm9
    vmovsd xmm3, [r13 + T_X + 152]
    vmovsd xmm2, [r13 + T_X + 184]
    vaddsd xmm4, xmm7, xmm3
    vsubsd xmm10, xmm4, xmm7
    vsubsd xmm5, xmm4, xmm10
    vsubsd xmm5, xmm7, xmm5
    vsubsd xmm10, xmm3, xmm10
    vaddsd xmm5, xmm5, xmm10
    vaddsd xmm10, xmm9, xmm2
    vsubsd xmm8, xmm10, xmm9
    vsubsd xmm6, xmm10, xmm8
    vsubsd xmm6, xmm9, xmm6
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm6, xmm6, xmm8
    vaddsd xmm8, xmm5, xmm10
    vaddsd xmm10, xmm4, xmm8
    vsubsd xmm5, xmm10, xmm4
    vsubsd xmm5, xmm8, xmm5
    vaddsd xmm8, xmm5, xmm6
    vaddsd xmm6, xmm10, xmm8
    vsubsd xmm5, xmm6, xmm10
    vsubsd xmm5, xmm8, xmm5
    vmovsd [r13 + T_ACC + 16], xmm6
    vmovsd [r13 + T_ACC + 48], xmm5
    vxorpd ymm0, ymm0, ymm0
    vmovapd ymm1, [r13 + T_ACC]
    vmovapd ymm2, [r13 + T_ACC + 32]
    vbroadcastsd ymm3, [u_quart]
    vmulpd ymm4, ymm1, ymm3
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm1, ymm3
    vmulpd ymm6, ymm2, ymm3
    vfmadd231pd ymm6, ymm1, ymm0
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm4, ymm5
    vsubpd ymm7, ymm6, ymm4
    vsubpd ymm7, ymm5, ymm7
    vmovapd ymm14, ymm6
    vmovapd ymm15, ymm7
    call .xoe
    vmovapd [r13 + T_E3], ymm14
    vmovapd [r13 + T_E3 + 32], ymm15
    vmovsd xmm0, [r13 + T_E3]
    vmovsd xmm1, [r13 + T_E3 + 32]
    vmovsd xmm2, [r13 + T_E3 + 8]
    vmovsd xmm3, [r13 + T_E3 + 40]
    vmovsd xmm4, [r13 + T_E3 + 16]
    vmovsd xmm5, [r13 + T_E3 + 48]
    vmovsd xmm6, [u_kr]
    vmovsd xmm7, [u_kr + 8]
    vmulsd xmm8, xmm6, xmm0
    vmovapd xmm9, xmm8
    vfmsub231sd xmm9, xmm6, xmm0
    vmulsd xmm10, xmm7, xmm0
    vfmadd231sd xmm10, xmm6, xmm1
    vaddsd xmm9, xmm9, xmm10
    vaddsd xmm10, xmm8, xmm9
    vsubsd xmm11, xmm10, xmm8
    vsubsd xmm11, xmm9, xmm11
    vmovsd xmm7, [u_kg]
    vmovsd xmm6, [u_kg + 8]
    vmulsd xmm9, xmm7, xmm2
    vmovapd xmm8, xmm9
    vfmsub231sd xmm8, xmm7, xmm2
    vmulsd xmm12, xmm6, xmm2
    vfmadd231sd xmm12, xmm7, xmm3
    vaddsd xmm8, xmm8, xmm12
    vaddsd xmm12, xmm9, xmm8
    vsubsd xmm13, xmm12, xmm9
    vsubsd xmm13, xmm8, xmm13
    vaddsd xmm6, xmm10, xmm12
    vsubsd xmm7, xmm6, xmm10
    vsubsd xmm8, xmm6, xmm7
    vsubsd xmm8, xmm10, xmm8
    vsubsd xmm7, xmm12, xmm7
    vaddsd xmm8, xmm8, xmm7
    vaddsd xmm7, xmm11, xmm13
    vsubsd xmm9, xmm7, xmm11
    vsubsd xmm14, xmm7, xmm9
    vsubsd xmm14, xmm11, xmm14
    vsubsd xmm9, xmm13, xmm9
    vaddsd xmm14, xmm14, xmm9
    vaddsd xmm9, xmm8, xmm7
    vaddsd xmm7, xmm6, xmm9
    vsubsd xmm8, xmm7, xmm6
    vsubsd xmm8, xmm9, xmm8
    vaddsd xmm9, xmm8, xmm14
    vaddsd xmm14, xmm7, xmm9
    vsubsd xmm8, xmm14, xmm7
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm13, [u_kb]
    vmovsd xmm12, [u_kb + 8]
    vmulsd xmm11, xmm13, xmm4
    vmovapd xmm10, xmm11
    vfmsub231sd xmm10, xmm13, xmm4
    vmulsd xmm9, xmm12, xmm4
    vfmadd231sd xmm9, xmm13, xmm5
    vaddsd xmm10, xmm10, xmm9
    vaddsd xmm9, xmm11, xmm10
    vsubsd xmm7, xmm9, xmm11
    vsubsd xmm7, xmm10, xmm7
    vaddsd xmm12, xmm14, xmm9
    vsubsd xmm13, xmm12, xmm14
    vsubsd xmm10, xmm12, xmm13
    vsubsd xmm10, xmm14, xmm10
    vsubsd xmm13, xmm9, xmm13
    vaddsd xmm10, xmm10, xmm13
    vaddsd xmm13, xmm8, xmm7
    vsubsd xmm11, xmm13, xmm8
    vsubsd xmm6, xmm13, xmm11
    vsubsd xmm6, xmm8, xmm6
    vsubsd xmm11, xmm7, xmm11
    vaddsd xmm6, xmm6, xmm11
    vaddsd xmm11, xmm10, xmm13
    vaddsd xmm13, xmm12, xmm11
    vsubsd xmm10, xmm13, xmm12
    vsubsd xmm10, xmm11, xmm10
    vaddsd xmm11, xmm10, xmm6
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
    vcvttsd2si r6d, xmm0
    xor r3d, r3d
    test r6d, r6d
    cmovs r6d, r3d
    mov r3d, 1023
    cmp r6d, r3d
    cmovg r6d, r3d
    ret
.t3c:
    xor r7d, r7d
    xor r8d, r8d
.t3c_a:
    vxorpd ymm0, ymm0, ymm0
    vmovapd ymm1, [r13 + r7 + T_SY]
    vmovapd ymm2, [r13 + r7 + T_SB]
    vmovapd ymm3, [r13 + r7 + T_SR]
    vbroadcastsd ymm4, [u_ysc]
    vbroadcastsd ymm5, [u_ysc + 8]
    vmulpd ymm6, ymm1, ymm4
    vmovapd ymm7, ymm6
    vfmsub231pd ymm7, ymm1, ymm4
    vmulpd ymm8, ymm0, ymm4
    vfmadd231pd ymm8, ymm1, ymm5
    vaddpd ymm7, ymm7, ymm8
    vaddpd ymm8, ymm6, ymm7
    vsubpd ymm9, ymm8, ymm6
    vsubpd ymm9, ymm7, ymm9
    vbroadcastsd ymm1, [u_yof]
    vbroadcastsd ymm5, [u_yof + 8]
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
    vbroadcastsd ymm5, [u_rcr]
    vbroadcastsd ymm1, [u_rcr + 8]
    vmulpd ymm9, ymm5, ymm3
    vmovapd ymm8, ymm9
    vfmsub231pd ymm8, ymm5, ymm3
    vmulpd ymm10, ymm1, ymm3
    vfmadd231pd ymm10, ymm5, ymm0
    vaddpd ymm8, ymm8, ymm10
    vaddpd ymm10, ymm9, ymm8
    vsubpd ymm7, ymm10, ymm9
    vsubpd ymm7, ymm8, ymm7
    vaddpd ymm1, ymm11, ymm10
    vsubpd ymm5, ymm1, ymm11
    vsubpd ymm8, ymm1, ymm5
    vsubpd ymm8, ymm11, ymm8
    vsubpd ymm5, ymm10, ymm5
    vaddpd ymm8, ymm8, ymm5
    vaddpd ymm5, ymm6, ymm7
    vsubpd ymm9, ymm5, ymm6
    vsubpd ymm4, ymm5, ymm9
    vsubpd ymm4, ymm6, ymm4
    vsubpd ymm9, ymm7, ymm9
    vaddpd ymm4, ymm4, ymm9
    vaddpd ymm9, ymm8, ymm5
    vaddpd ymm5, ymm1, ymm9
    vsubpd ymm8, ymm5, ymm1
    vsubpd ymm8, ymm9, ymm8
    vaddpd ymm9, ymm8, ymm4
    vaddpd ymm4, ymm5, ymm9
    vsubpd ymm8, ymm4, ymm5
    vsubpd ymm8, ymm9, ymm8
    vmovapd [r13 + r8 + T_V3], ymm4
    vmovapd [r8 + r13 + T_V3 + 32], ymm8
    vbroadcastsd ymm8, [u_gcr]
    vbroadcastsd ymm4, [u_gcr + 8]
    vmulpd ymm7, ymm8, ymm3
    vmovapd ymm10, ymm7
    vfmsub231pd ymm10, ymm8, ymm3
    vmulpd ymm9, ymm4, ymm3
    vfmadd231pd ymm9, ymm8, ymm0
    vaddpd ymm10, ymm10, ymm9
    vaddpd ymm9, ymm7, ymm10
    vsubpd ymm5, ymm9, ymm7
    vsubpd ymm5, ymm10, ymm5
    vaddpd ymm4, ymm11, ymm9
    vsubpd ymm8, ymm4, ymm11
    vsubpd ymm10, ymm4, ymm8
    vsubpd ymm10, ymm11, ymm10
    vsubpd ymm8, ymm9, ymm8
    vaddpd ymm10, ymm10, ymm8
    vaddpd ymm8, ymm6, ymm5
    vsubpd ymm7, ymm8, ymm6
    vsubpd ymm1, ymm8, ymm7
    vsubpd ymm1, ymm6, ymm1
    vsubpd ymm7, ymm5, ymm7
    vaddpd ymm1, ymm1, ymm7
    vaddpd ymm7, ymm10, ymm8
    vaddpd ymm8, ymm4, ymm7
    vsubpd ymm10, ymm8, ymm4
    vsubpd ymm10, ymm7, ymm10
    vaddpd ymm7, ymm10, ymm1
    vaddpd ymm1, ymm8, ymm7
    vsubpd ymm10, ymm1, ymm8
    vsubpd ymm10, ymm7, ymm10
    vbroadcastsd ymm3, [u_gcb]
    vbroadcastsd ymm5, [u_gcb + 8]
    vmulpd ymm9, ymm3, ymm2
    vmovapd ymm7, ymm9
    vfmsub231pd ymm7, ymm3, ymm2
    vmulpd ymm8, ymm5, ymm2
    vfmadd231pd ymm8, ymm3, ymm0
    vaddpd ymm7, ymm7, ymm8
    vaddpd ymm8, ymm9, ymm7
    vsubpd ymm4, ymm8, ymm9
    vsubpd ymm4, ymm7, ymm4
    vaddpd ymm5, ymm1, ymm8
    vsubpd ymm3, ymm5, ymm1
    vsubpd ymm7, ymm5, ymm3
    vsubpd ymm7, ymm1, ymm7
    vsubpd ymm3, ymm8, ymm3
    vaddpd ymm7, ymm7, ymm3
    vaddpd ymm3, ymm10, ymm4
    vsubpd ymm9, ymm3, ymm10
    vsubpd ymm12, ymm3, ymm9
    vsubpd ymm12, ymm10, ymm12
    vsubpd ymm9, ymm4, ymm9
    vaddpd ymm12, ymm12, ymm9
    vaddpd ymm9, ymm7, ymm3
    vaddpd ymm3, ymm5, ymm9
    vsubpd ymm7, ymm3, ymm5
    vsubpd ymm7, ymm9, ymm7
    vaddpd ymm9, ymm7, ymm12
    vaddpd ymm12, ymm3, ymm9
    vsubpd ymm7, ymm12, ymm3
    vsubpd ymm7, ymm9, ymm7
    vmovapd [r8 + r13 + T_V3 + 64], ymm12
    vmovapd [r8 + r13 + T_V3 + 96], ymm7
    vbroadcastsd ymm7, [u_bcb]
    vbroadcastsd ymm12, [u_bcb + 8]
    vmulpd ymm10, ymm7, ymm2
    vmovapd ymm1, ymm10
    vfmsub231pd ymm1, ymm7, ymm2
    vmulpd ymm4, ymm12, ymm2
    vfmadd231pd ymm4, ymm7, ymm0
    vaddpd ymm1, ymm1, ymm4
    vaddpd ymm4, ymm10, ymm1
    vsubpd ymm8, ymm4, ymm10
    vsubpd ymm8, ymm1, ymm8
    vaddpd ymm12, ymm11, ymm4
    vsubpd ymm7, ymm12, ymm11
    vsubpd ymm1, ymm12, ymm7
    vsubpd ymm1, ymm11, ymm1
    vsubpd ymm7, ymm4, ymm7
    vaddpd ymm1, ymm1, ymm7
    vaddpd ymm7, ymm6, ymm8
    vsubpd ymm10, ymm7, ymm6
    vsubpd ymm9, ymm7, ymm10
    vsubpd ymm9, ymm6, ymm9
    vsubpd ymm10, ymm8, ymm10
    vaddpd ymm9, ymm9, ymm10
    vaddpd ymm10, ymm1, ymm7
    vaddpd ymm7, ymm12, ymm10
    vsubpd ymm1, ymm7, ymm12
    vsubpd ymm1, ymm10, ymm1
    vaddpd ymm10, ymm1, ymm9
    vaddpd ymm9, ymm7, ymm10
    vsubpd ymm1, ymm9, ymm7
    vsubpd ymm1, ymm10, ymm1
    vmovapd [r8 + r13 + T_V3 + 128], ymm9
    vmovapd [r8 + r13 + T_V3 + 160], ymm1
    add r7, 32
    add r8, 192
    cmp r7, 128
    jne .t3c_a
    xor r7d, r7d
.t3c_b:
    vmovapd ymm14, [r13 + r7 + T_V3]
    vmovapd ymm15, [r7 + r13 + T_V3 + 32]
    call .xeo
    vmovapd [r13 + r7 + T_X], ymm14
    vmovapd [r7 + r13 + T_X + 32], ymm15
    add r7, 64
    cmp r7, 768
    jne .t3c_b
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r13 + T_ACC], ymm0
    vmovapd [r13 + T_ACC + 32], ymm0
    vxorpd xmm0, xmm0, xmm0
    vxorpd xmm1, xmm1, xmm1
    xor r7d, r7d
.t3c_c0:
    vmovsd xmm2, [r7 + r13 + T_X]
    vmovsd xmm3, [r7 + r13 + T_X + 32]
    vaddsd xmm4, xmm0, xmm2
    vsubsd xmm5, xmm4, xmm0
    vsubsd xmm6, xmm4, xmm5
    vsubsd xmm6, xmm0, xmm6
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm6, xmm6, xmm5
    vaddsd xmm5, xmm1, xmm3
    vsubsd xmm7, xmm5, xmm1
    vsubsd xmm8, xmm5, xmm7
    vsubsd xmm8, xmm1, xmm8
    vsubsd xmm7, xmm3, xmm7
    vaddsd xmm8, xmm8, xmm7
    vaddsd xmm7, xmm6, xmm5
    vaddsd xmm5, xmm4, xmm7
    vsubsd xmm6, xmm5, xmm4
    vsubsd xmm6, xmm7, xmm6
    vaddsd xmm7, xmm6, xmm8
    vaddsd xmm8, xmm5, xmm7
    vsubsd xmm6, xmm8, xmm5
    vsubsd xmm6, xmm7, xmm6
    vmovsd xmm3, [r7 + r13 + T_X + 8]
    vmovsd xmm2, [r7 + r13 + T_X + 40]
    vaddsd xmm7, xmm8, xmm3
    vsubsd xmm5, xmm7, xmm8
    vsubsd xmm4, xmm7, xmm5
    vsubsd xmm4, xmm8, xmm4
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm6, xmm2
    vsubsd xmm9, xmm5, xmm6
    vsubsd xmm10, xmm5, xmm9
    vsubsd xmm10, xmm6, xmm10
    vsubsd xmm9, xmm2, xmm9
    vaddsd xmm10, xmm10, xmm9
    vaddsd xmm9, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm9
    vsubsd xmm4, xmm5, xmm7
    vsubsd xmm4, xmm9, xmm4
    vaddsd xmm9, xmm4, xmm10
    vaddsd xmm10, xmm5, xmm9
    vsubsd xmm4, xmm10, xmm5
    vsubsd xmm4, xmm9, xmm4
    vmovsd xmm2, [r7 + r13 + T_X + 16]
    vmovsd xmm3, [r7 + r13 + T_X + 48]
    vaddsd xmm6, xmm10, xmm2
    vsubsd xmm8, xmm6, xmm10
    vsubsd xmm9, xmm6, xmm8
    vsubsd xmm9, xmm10, xmm9
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm9, xmm9, xmm8
    vaddsd xmm8, xmm4, xmm3
    vsubsd xmm5, xmm8, xmm4
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm7, xmm4, xmm7
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm7, xmm7, xmm5
    vaddsd xmm5, xmm9, xmm8
    vaddsd xmm8, xmm6, xmm5
    vsubsd xmm9, xmm8, xmm6
    vsubsd xmm9, xmm5, xmm9
    vaddsd xmm5, xmm9, xmm7
    vaddsd xmm7, xmm8, xmm5
    vsubsd xmm9, xmm7, xmm8
    vsubsd xmm9, xmm5, xmm9
    vmovsd xmm3, [r7 + r13 + T_X + 24]
    vmovsd xmm2, [r7 + r13 + T_X + 56]
    vaddsd xmm4, xmm7, xmm3
    vsubsd xmm10, xmm4, xmm7
    vsubsd xmm5, xmm4, xmm10
    vsubsd xmm5, xmm7, xmm5
    vsubsd xmm10, xmm3, xmm10
    vaddsd xmm5, xmm5, xmm10
    vaddsd xmm10, xmm9, xmm2
    vsubsd xmm8, xmm10, xmm9
    vsubsd xmm6, xmm10, xmm8
    vsubsd xmm6, xmm9, xmm6
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm6, xmm6, xmm8
    vaddsd xmm8, xmm5, xmm10
    vaddsd xmm10, xmm4, xmm8
    vsubsd xmm5, xmm10, xmm4
    vsubsd xmm5, xmm8, xmm5
    vaddsd xmm8, xmm5, xmm6
    vaddsd xmm6, xmm10, xmm8
    vsubsd xmm5, xmm6, xmm10
    vsubsd xmm5, xmm8, xmm5
    vmovapd xmm0, xmm6
    vmovapd xmm1, xmm5
    add r7, 192
    cmp r7, 768
    jne .t3c_c0
    vmovsd [r13 + T_ACC], xmm0
    vmovsd [r13 + T_ACC + 32], xmm1
    vxorpd xmm0, xmm0, xmm0
    vxorpd xmm1, xmm1, xmm1
    xor r7d, r7d
.t3c_c1:
    vmovsd xmm2, [r7 + r13 + T_X + 64]
    vmovsd xmm3, [r7 + r13 + T_X + 96]
    vaddsd xmm4, xmm0, xmm2
    vsubsd xmm5, xmm4, xmm0
    vsubsd xmm6, xmm4, xmm5
    vsubsd xmm6, xmm0, xmm6
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm6, xmm6, xmm5
    vaddsd xmm5, xmm1, xmm3
    vsubsd xmm7, xmm5, xmm1
    vsubsd xmm8, xmm5, xmm7
    vsubsd xmm8, xmm1, xmm8
    vsubsd xmm7, xmm3, xmm7
    vaddsd xmm8, xmm8, xmm7
    vaddsd xmm7, xmm6, xmm5
    vaddsd xmm5, xmm4, xmm7
    vsubsd xmm6, xmm5, xmm4
    vsubsd xmm6, xmm7, xmm6
    vaddsd xmm7, xmm6, xmm8
    vaddsd xmm8, xmm5, xmm7
    vsubsd xmm6, xmm8, xmm5
    vsubsd xmm6, xmm7, xmm6
    vmovsd xmm3, [r7 + r13 + T_X + 72]
    vmovsd xmm2, [r7 + r13 + T_X + 104]
    vaddsd xmm7, xmm8, xmm3
    vsubsd xmm5, xmm7, xmm8
    vsubsd xmm4, xmm7, xmm5
    vsubsd xmm4, xmm8, xmm4
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm6, xmm2
    vsubsd xmm9, xmm5, xmm6
    vsubsd xmm10, xmm5, xmm9
    vsubsd xmm10, xmm6, xmm10
    vsubsd xmm9, xmm2, xmm9
    vaddsd xmm10, xmm10, xmm9
    vaddsd xmm9, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm9
    vsubsd xmm4, xmm5, xmm7
    vsubsd xmm4, xmm9, xmm4
    vaddsd xmm9, xmm4, xmm10
    vaddsd xmm10, xmm5, xmm9
    vsubsd xmm4, xmm10, xmm5
    vsubsd xmm4, xmm9, xmm4
    vmovsd xmm2, [r7 + r13 + T_X + 80]
    vmovsd xmm3, [r7 + r13 + T_X + 112]
    vaddsd xmm6, xmm10, xmm2
    vsubsd xmm8, xmm6, xmm10
    vsubsd xmm9, xmm6, xmm8
    vsubsd xmm9, xmm10, xmm9
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm9, xmm9, xmm8
    vaddsd xmm8, xmm4, xmm3
    vsubsd xmm5, xmm8, xmm4
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm7, xmm4, xmm7
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm7, xmm7, xmm5
    vaddsd xmm5, xmm9, xmm8
    vaddsd xmm8, xmm6, xmm5
    vsubsd xmm9, xmm8, xmm6
    vsubsd xmm9, xmm5, xmm9
    vaddsd xmm5, xmm9, xmm7
    vaddsd xmm7, xmm8, xmm5
    vsubsd xmm9, xmm7, xmm8
    vsubsd xmm9, xmm5, xmm9
    vmovsd xmm3, [r7 + r13 + T_X + 88]
    vmovsd xmm2, [r7 + r13 + T_X + 120]
    vaddsd xmm4, xmm7, xmm3
    vsubsd xmm10, xmm4, xmm7
    vsubsd xmm5, xmm4, xmm10
    vsubsd xmm5, xmm7, xmm5
    vsubsd xmm10, xmm3, xmm10
    vaddsd xmm5, xmm5, xmm10
    vaddsd xmm10, xmm9, xmm2
    vsubsd xmm8, xmm10, xmm9
    vsubsd xmm6, xmm10, xmm8
    vsubsd xmm6, xmm9, xmm6
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm6, xmm6, xmm8
    vaddsd xmm8, xmm5, xmm10
    vaddsd xmm10, xmm4, xmm8
    vsubsd xmm5, xmm10, xmm4
    vsubsd xmm5, xmm8, xmm5
    vaddsd xmm8, xmm5, xmm6
    vaddsd xmm6, xmm10, xmm8
    vsubsd xmm5, xmm6, xmm10
    vsubsd xmm5, xmm8, xmm5
    vmovapd xmm0, xmm6
    vmovapd xmm1, xmm5
    add r7, 192
    cmp r7, 768
    jne .t3c_c1
    vmovsd [r13 + T_ACC + 8], xmm0
    vmovsd [r13 + T_ACC + 40], xmm1
    vxorpd xmm0, xmm0, xmm0
    vxorpd xmm1, xmm1, xmm1
    xor r7d, r7d
.t3c_c2:
    vmovsd xmm2, [r7 + r13 + T_X + 128]
    vmovsd xmm3, [r7 + r13 + T_X + 160]
    vaddsd xmm4, xmm0, xmm2
    vsubsd xmm5, xmm4, xmm0
    vsubsd xmm6, xmm4, xmm5
    vsubsd xmm6, xmm0, xmm6
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm6, xmm6, xmm5
    vaddsd xmm5, xmm1, xmm3
    vsubsd xmm7, xmm5, xmm1
    vsubsd xmm8, xmm5, xmm7
    vsubsd xmm8, xmm1, xmm8
    vsubsd xmm7, xmm3, xmm7
    vaddsd xmm8, xmm8, xmm7
    vaddsd xmm7, xmm6, xmm5
    vaddsd xmm5, xmm4, xmm7
    vsubsd xmm6, xmm5, xmm4
    vsubsd xmm6, xmm7, xmm6
    vaddsd xmm7, xmm6, xmm8
    vaddsd xmm8, xmm5, xmm7
    vsubsd xmm6, xmm8, xmm5
    vsubsd xmm6, xmm7, xmm6
    vmovsd xmm3, [r7 + r13 + T_X + 136]
    vmovsd xmm2, [r7 + r13 + T_X + 168]
    vaddsd xmm7, xmm8, xmm3
    vsubsd xmm5, xmm7, xmm8
    vsubsd xmm4, xmm7, xmm5
    vsubsd xmm4, xmm8, xmm4
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm6, xmm2
    vsubsd xmm9, xmm5, xmm6
    vsubsd xmm10, xmm5, xmm9
    vsubsd xmm10, xmm6, xmm10
    vsubsd xmm9, xmm2, xmm9
    vaddsd xmm10, xmm10, xmm9
    vaddsd xmm9, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm9
    vsubsd xmm4, xmm5, xmm7
    vsubsd xmm4, xmm9, xmm4
    vaddsd xmm9, xmm4, xmm10
    vaddsd xmm10, xmm5, xmm9
    vsubsd xmm4, xmm10, xmm5
    vsubsd xmm4, xmm9, xmm4
    vmovsd xmm2, [r7 + r13 + T_X + 144]
    vmovsd xmm3, [r7 + r13 + T_X + 176]
    vaddsd xmm6, xmm10, xmm2
    vsubsd xmm8, xmm6, xmm10
    vsubsd xmm9, xmm6, xmm8
    vsubsd xmm9, xmm10, xmm9
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm9, xmm9, xmm8
    vaddsd xmm8, xmm4, xmm3
    vsubsd xmm5, xmm8, xmm4
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm7, xmm4, xmm7
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm7, xmm7, xmm5
    vaddsd xmm5, xmm9, xmm8
    vaddsd xmm8, xmm6, xmm5
    vsubsd xmm9, xmm8, xmm6
    vsubsd xmm9, xmm5, xmm9
    vaddsd xmm5, xmm9, xmm7
    vaddsd xmm7, xmm8, xmm5
    vsubsd xmm9, xmm7, xmm8
    vsubsd xmm9, xmm5, xmm9
    vmovsd xmm3, [r7 + r13 + T_X + 152]
    vmovsd xmm2, [r7 + r13 + T_X + 184]
    vaddsd xmm4, xmm7, xmm3
    vsubsd xmm10, xmm4, xmm7
    vsubsd xmm5, xmm4, xmm10
    vsubsd xmm5, xmm7, xmm5
    vsubsd xmm10, xmm3, xmm10
    vaddsd xmm5, xmm5, xmm10
    vaddsd xmm10, xmm9, xmm2
    vsubsd xmm8, xmm10, xmm9
    vsubsd xmm6, xmm10, xmm8
    vsubsd xmm6, xmm9, xmm6
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm6, xmm6, xmm8
    vaddsd xmm8, xmm5, xmm10
    vaddsd xmm10, xmm4, xmm8
    vsubsd xmm5, xmm10, xmm4
    vsubsd xmm5, xmm8, xmm5
    vaddsd xmm8, xmm5, xmm6
    vaddsd xmm6, xmm10, xmm8
    vsubsd xmm5, xmm6, xmm10
    vsubsd xmm5, xmm8, xmm5
    vmovapd xmm0, xmm6
    vmovapd xmm1, xmm5
    add r7, 192
    cmp r7, 768
    jne .t3c_c2
    vmovsd [r13 + T_ACC + 16], xmm0
    vmovsd [r13 + T_ACC + 48], xmm1
    vxorpd ymm0, ymm0, ymm0
    vmovapd ymm1, [r13 + T_ACC]
    vmovapd ymm2, [r13 + T_ACC + 32]
    vbroadcastsd ymm3, [u_six]
    vmulpd ymm4, ymm1, ymm3
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm1, ymm3
    vmulpd ymm6, ymm2, ymm3
    vfmadd231pd ymm6, ymm1, ymm0
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm4, ymm5
    vsubpd ymm7, ymm6, ymm4
    vsubpd ymm7, ymm5, ymm7
    vmovapd ymm14, ymm6
    vmovapd ymm15, ymm7
    call .xoe
    vmovapd [r13 + T_E3], ymm14
    vmovapd [r13 + T_E3 + 32], ymm15
    vmovsd xmm0, [r13 + T_E3]
    vmovsd xmm1, [r13 + T_E3 + 32]
    vmovsd xmm2, [r13 + T_E3 + 8]
    vmovsd xmm3, [r13 + T_E3 + 40]
    vmovsd xmm4, [r13 + T_E3 + 16]
    vmovsd xmm5, [r13 + T_E3 + 48]
    vmovsd xmm6, [u_kr]
    vmovsd xmm7, [u_kr + 8]
    vmulsd xmm8, xmm6, xmm0
    vmovapd xmm9, xmm8
    vfmsub231sd xmm9, xmm6, xmm0
    vmulsd xmm10, xmm7, xmm0
    vfmadd231sd xmm10, xmm6, xmm1
    vaddsd xmm9, xmm9, xmm10
    vaddsd xmm10, xmm8, xmm9
    vsubsd xmm11, xmm10, xmm8
    vsubsd xmm11, xmm9, xmm11
    vmovsd xmm7, [u_kg]
    vmovsd xmm6, [u_kg + 8]
    vmulsd xmm9, xmm7, xmm2
    vmovapd xmm8, xmm9
    vfmsub231sd xmm8, xmm7, xmm2
    vmulsd xmm12, xmm6, xmm2
    vfmadd231sd xmm12, xmm7, xmm3
    vaddsd xmm8, xmm8, xmm12
    vaddsd xmm12, xmm9, xmm8
    vsubsd xmm13, xmm12, xmm9
    vsubsd xmm13, xmm8, xmm13
    vaddsd xmm6, xmm10, xmm12
    vsubsd xmm7, xmm6, xmm10
    vsubsd xmm8, xmm6, xmm7
    vsubsd xmm8, xmm10, xmm8
    vsubsd xmm7, xmm12, xmm7
    vaddsd xmm8, xmm8, xmm7
    vaddsd xmm7, xmm11, xmm13
    vsubsd xmm9, xmm7, xmm11
    vsubsd xmm14, xmm7, xmm9
    vsubsd xmm14, xmm11, xmm14
    vsubsd xmm9, xmm13, xmm9
    vaddsd xmm14, xmm14, xmm9
    vaddsd xmm9, xmm8, xmm7
    vaddsd xmm7, xmm6, xmm9
    vsubsd xmm8, xmm7, xmm6
    vsubsd xmm8, xmm9, xmm8
    vaddsd xmm9, xmm8, xmm14
    vaddsd xmm14, xmm7, xmm9
    vsubsd xmm8, xmm14, xmm7
    vsubsd xmm8, xmm9, xmm8
    vmovsd xmm13, [u_kb]
    vmovsd xmm12, [u_kb + 8]
    vmulsd xmm11, xmm13, xmm4
    vmovapd xmm10, xmm11
    vfmsub231sd xmm10, xmm13, xmm4
    vmulsd xmm9, xmm12, xmm4
    vfmadd231sd xmm9, xmm13, xmm5
    vaddsd xmm10, xmm10, xmm9
    vaddsd xmm9, xmm11, xmm10
    vsubsd xmm7, xmm9, xmm11
    vsubsd xmm7, xmm10, xmm7
    vaddsd xmm12, xmm14, xmm9
    vsubsd xmm13, xmm12, xmm14
    vsubsd xmm10, xmm12, xmm13
    vsubsd xmm10, xmm14, xmm10
    vsubsd xmm13, xmm9, xmm13
    vaddsd xmm10, xmm10, xmm13
    vaddsd xmm13, xmm8, xmm7
    vsubsd xmm11, xmm13, xmm8
    vsubsd xmm6, xmm13, xmm11
    vsubsd xmm6, xmm8, xmm6
    vsubsd xmm11, xmm7, xmm11
    vaddsd xmm6, xmm6, xmm11
    vaddsd xmm11, xmm10, xmm13
    vaddsd xmm13, xmm12, xmm11
    vsubsd xmm10, xmm13, xmm12
    vsubsd xmm10, xmm11, xmm10
    vaddsd xmm11, xmm10, xmm6
    vaddsd xmm6, xmm13, xmm11
    vsubsd xmm10, xmm6, xmm13
    vsubsd xmm10, xmm11, xmm10
    vxorpd xmm3, xmm6, [u_mzero]
    vxorpd xmm2, xmm10, [u_mzero]
    vaddsd xmm10, xmm4, xmm3
    vsubsd xmm6, xmm10, xmm4
    vsubsd xmm7, xmm10, xmm6
    vsubsd xmm7, xmm4, xmm7
    vsubsd xmm6, xmm3, xmm6
    vaddsd xmm7, xmm7, xmm6
    vaddsd xmm6, xmm5, xmm2
    vsubsd xmm9, xmm6, xmm5
    vsubsd xmm8, xmm6, xmm9
    vsubsd xmm8, xmm5, xmm8
    vsubsd xmm9, xmm2, xmm9
    vaddsd xmm8, xmm8, xmm9
    vaddsd xmm9, xmm7, xmm6
    vaddsd xmm6, xmm10, xmm9
    vsubsd xmm7, xmm6, xmm10
    vsubsd xmm7, xmm9, xmm7
    vaddsd xmm9, xmm7, xmm8
    vaddsd xmm8, xmm6, xmm9
    vsubsd xmm7, xmm8, xmm6
    vsubsd xmm7, xmm9, xmm7
    vmovsd xmm9, [u_cbs]
    vmovsd xmm6, [u_cbs + 8]
    vmulsd xmm10, xmm9, xmm8
    vmovapd xmm14, xmm10
    vfmsub231sd xmm14, xmm9, xmm8
    vmulsd xmm11, xmm6, xmm8
    vfmadd231sd xmm11, xmm9, xmm7
    vaddsd xmm14, xmm14, xmm11
    vaddsd xmm11, xmm10, xmm14
    vsubsd xmm13, xmm11, xmm10
    vsubsd xmm13, xmm14, xmm13
    vxorpd xmm7, xmm7, xmm7
    vmovsd xmm8, [u_512]
    vaddsd xmm6, xmm11, xmm8
    vsubsd xmm9, xmm6, xmm11
    vsubsd xmm14, xmm6, xmm9
    vsubsd xmm14, xmm11, xmm14
    vsubsd xmm9, xmm8, xmm9
    vaddsd xmm14, xmm14, xmm9
    vaddsd xmm9, xmm13, xmm7
    vsubsd xmm10, xmm9, xmm13
    vsubsd xmm12, xmm9, xmm10
    vsubsd xmm12, xmm13, xmm12
    vsubsd xmm10, xmm7, xmm10
    vaddsd xmm12, xmm12, xmm10
    vaddsd xmm10, xmm14, xmm9
    vaddsd xmm9, xmm6, xmm10
    vsubsd xmm14, xmm9, xmm6
    vsubsd xmm14, xmm10, xmm14
    vaddsd xmm10, xmm14, xmm12
    vaddsd xmm12, xmm9, xmm10
    vsubsd xmm14, xmm12, xmm9
    vsubsd xmm14, xmm10, xmm14
    vaddsd xmm8, xmm0, xmm3
    vsubsd xmm13, xmm8, xmm0
    vsubsd xmm11, xmm8, xmm13
    vsubsd xmm11, xmm0, xmm11
    vsubsd xmm13, xmm3, xmm13
    vaddsd xmm11, xmm11, xmm13
    vaddsd xmm13, xmm1, xmm2
    vsubsd xmm10, xmm13, xmm1
    vsubsd xmm9, xmm13, xmm10
    vsubsd xmm9, xmm1, xmm9
    vsubsd xmm10, xmm2, xmm10
    vaddsd xmm9, xmm9, xmm10
    vaddsd xmm10, xmm11, xmm13
    vaddsd xmm13, xmm8, xmm10
    vsubsd xmm11, xmm13, xmm8
    vsubsd xmm11, xmm10, xmm11
    vaddsd xmm10, xmm11, xmm9
    vaddsd xmm9, xmm13, xmm10
    vsubsd xmm11, xmm9, xmm13
    vsubsd xmm11, xmm10, xmm11
    vmovsd xmm2, [u_crs]
    vmovsd xmm3, [u_crs + 8]
    vmulsd xmm10, xmm2, xmm9
    vmovapd xmm13, xmm10
    vfmsub231sd xmm13, xmm2, xmm9
    vmulsd xmm8, xmm3, xmm9
    vfmadd231sd xmm8, xmm2, xmm11
    vaddsd xmm13, xmm13, xmm8
    vaddsd xmm8, xmm10, xmm13
    vsubsd xmm6, xmm8, xmm10
    vsubsd xmm6, xmm13, xmm6
    vmovsd xmm11, [u_512]
    vaddsd xmm9, xmm8, xmm11
    vsubsd xmm3, xmm9, xmm8
    vsubsd xmm2, xmm9, xmm3
    vsubsd xmm2, xmm8, xmm2
    vsubsd xmm3, xmm11, xmm3
    vaddsd xmm2, xmm2, xmm3
    vaddsd xmm3, xmm6, xmm7
    vsubsd xmm13, xmm3, xmm6
    vsubsd xmm10, xmm3, xmm13
    vsubsd xmm10, xmm6, xmm10
    vsubsd xmm13, xmm7, xmm13
    vaddsd xmm10, xmm10, xmm13
    vaddsd xmm13, xmm2, xmm3
    vaddsd xmm3, xmm9, xmm13
    vsubsd xmm2, xmm3, xmm9
    vsubsd xmm2, xmm13, xmm2
    vaddsd xmm13, xmm2, xmm10
    vaddsd xmm10, xmm3, xmm13
    vsubsd xmm2, xmm10, xmm3
    vsubsd xmm2, xmm13, xmm2
    vmovsd [r13 + T_E3 + 64], xmm10
    vmovsd [r13 + T_E3 + 72], xmm2
    vroundsd xmm7, xmm12, xmm12, 8
    vsubsd xmm11, xmm12, xmm7
    vxorpd xmm6, xmm6, xmm6
    vaddsd xmm8, xmm11, xmm14
    vsubsd xmm13, xmm8, xmm11
    vsubsd xmm3, xmm8, xmm13
    vsubsd xmm3, xmm11, xmm3
    vsubsd xmm13, xmm14, xmm13
    vaddsd xmm3, xmm3, xmm13
    vaddsd xmm13, xmm6, xmm6
    vsubsd xmm9, xmm13, xmm6
    vsubsd xmm15, xmm13, xmm9
    vsubsd xmm15, xmm6, xmm15
    vsubsd xmm9, xmm6, xmm9
    vaddsd xmm15, xmm15, xmm9
    vaddsd xmm9, xmm3, xmm13
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
    vcvttsd2si r6d, xmm7
    xor r3d, r3d
    test r6d, r6d
    cmovs r6d, r3d
    mov r3d, 1023
    cmp r6d, r3d
    cmovg r6d, r3d
    mov [r13 + T_L4], r6d
    vmovsd xmm0, [r13 + T_E3 + 64]
    vmovsd xmm1, [r13 + T_E3 + 72]
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
    vcvttsd2si r6d, xmm2
    xor r3d, r3d
    test r6d, r6d
    cmovs r6d, r3d
    mov r3d, 1023
    cmp r6d, r3d
    cmovg r6d, r3d
    shl r6d, 16
    or r6d, [r13 + T_L4]
    ret
.g2l:
    mov [r13 + T_XL], r6d
    mov r4, [r10 + 16 + S_SRC]
    mov r3d, [r13 + T_J]
    imul r3, r3, 4*W
    add r3, r4
    mov r2d, r6d
    movzx r1d, word [r3 + r2*4]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r13 + T_SY], xmm0
    movzx r1d, word [r3 + r2*4 + 2]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r13 + T_SY + 8], xmm0
    movzx r1d, word [r3 + r2*4 + 2*W]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r13 + T_SY + 16], xmm0
    movzx r1d, word [r3 + r2*4 + 2*W + 2]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r13 + T_SY + 24], xmm0
    mov r3d, [r13 + T_J]
    lea r3d, [r3*2]
    mov r2d, [r13 + T_XL]
    dec r2d
    call .cvr
    vmovaps [r13 + T_VB], ymm0
    vmovaps [r13 + T_VB + 32], ymm1
    vmovss xmm2, [r13 + T_VB + 4]
    vmovss xmm3, [r13 + T_VB + 36]
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [u_k50]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 32]
    vmovss xmm6, [u_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 36]
    vmovss xmm6, [u_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 40]
    vmovss xmm6, [u_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 44]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [u_512]
    vmovsd [r13 + T_SB], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [u_512]
    vmovsd [r13 + T_SR], xmm3
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [u_512]
    vmovsd [r13 + T_SB + 8], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [u_512]
    vmovsd [r13 + T_SR + 8], xmm5
    mov r3d, [r13 + T_J]
    lea r3d, [r3*2 + 1]
    mov r2d, [r13 + T_XL]
    dec r2d
    call .cvr
    vmovaps [r13 + T_VB], ymm0
    vmovaps [r13 + T_VB + 32], ymm1
    vmovss xmm2, [r13 + T_VB + 4]
    vmovss xmm3, [r13 + T_VB + 36]
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [u_k50]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 32]
    vmovss xmm6, [u_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 36]
    vmovss xmm6, [u_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 40]
    vmovss xmm6, [u_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 44]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [u_512]
    vmovsd [r13 + T_SB + 16], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [u_512]
    vmovsd [r13 + T_SR + 16], xmm3
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [u_512]
    vmovsd [r13 + T_SB + 24], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [u_512]
    vmovsd [r13 + T_SR + 24], xmm5
    ret
.g2c:
    mov [r13 + T_XL], r6d
    mov r4, [r10 + 16 + S_SRC]
    xor r5d, r5d
    xor r7d, r7d
.g2c_r:
    mov r3d, [r13 + T_J]
    lea r3d, [r3*4 + r5]
    imul r3, r3, 2*W
    add r3, r4
    mov r2d, [r13 + T_XL]
    lea r2d, [r2*4 - 1]
    xor r6d, r6d
    mov r1d, r2d
    test r1d, r1d
    cmovs r1d, r6d
    vmovd xmm7, r2d
    vpbroadcastd ymm7, xmm7
    vpaddd ymm7, ymm7, [u_iota]
    vpxor ymm6, ymm6, ymm6
    vpmaxsd ymm7, ymm7, ymm6
    vmovd xmm6, r1d
    vpbroadcastd ymm6, xmm6
    vpsubd ymm7, ymm7, ymm6
    vpmovzxwd ymm2, [r3 + r1*2]
    vpermd ymm2, ymm7, ymm2
    vcvtdq2pd ymm2, xmm2
    vmovapd [r13 + r7 + T_SY], ymm2
    mov r3d, [r13 + T_J]
    lea r3d, [r3*4 + r5]
    mov r2d, [r13 + T_XL]
    lea r2d, [r2*2 - 2]
    call .cvr
    vmovaps [r13 + T_VB], ymm0
    vmovaps [r13 + T_VB + 32], ymm1
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [u_k50]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 32]
    vmovss xmm6, [u_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 36]
    vmovss xmm6, [u_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 40]
    vmovss xmm6, [u_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 44]
    cmp dword [r13 + T_XL], 0
    jne .g2c_s
    vmovss xmm4, [r13 + T_VB + 8]
    vmovss xmm5, [r13 + T_VB + 40]
.g2c_s:
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [u_512]
    vmovsd [r7 + r13 + T_SB], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [u_512]
    vmovsd [r7 + r13 + T_SR], xmm5
    vmovss xmm2, [r13 + T_VB + 8]
    vmovss xmm3, [r13 + T_VB + 40]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [u_512]
    vmovsd [r7 + r13 + T_SB + 8], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [u_512]
    vmovsd [r7 + r13 + T_SR + 8], xmm3
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [u_k50]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 36]
    vmovss xmm6, [u_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 40]
    vmovss xmm6, [u_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 44]
    vmovss xmm6, [u_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r13 + T_VB + 16]
    vfmadd231ss xmm5, xmm6, [r13 + T_VB + 48]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [u_512]
    vmovsd [r7 + r13 + T_SB + 16], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [u_512]
    vmovsd [r7 + r13 + T_SR + 16], xmm5
    vmovss xmm2, [r13 + T_VB + 12]
    vmovss xmm3, [r13 + T_VB + 44]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [u_512]
    vmovsd [r7 + r13 + T_SB + 24], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [u_512]
    vmovsd [r7 + r13 + T_SR + 24], xmm3
    inc r5d
    add r7, 32
    cmp r5d, 4
    jne .g2c_r
    ret
.cvr:
    lea r1, [u_k75]
    lea r0, [u_k25]
    test r3b, 1
    cmovnz r1, r0
    lea r0d, [r3 + 1]
    shr r0d, 1
    xor r6d, r6d
    mov r3d, r2d
    test r3d, r3d
    cmovs r3d, r6d
    vmovd xmm7, r2d
    vpbroadcastd ymm7, xmm7
    vpaddd ymm7, ymm7, [u_iota]
    vpxor ymm6, ymm6, ymm6
    vpmaxsd ymm7, ymm7, ymm6
    vmovd xmm6, r3d
    vpbroadcastd ymm6, xmm6
    vpsubd ymm7, ymm7, ymm6
    lea r2, [r4 + r3*2 + CB]
    vxorps ymm0, ymm0, ymm0
    vxorps ymm1, ymm1, ymm1
    lea r3d, [r0 - 2]
    test r3d, r3d
    cmovs r3d, r6d
    imul r3, r3, CST
    vpmovzxwd ymm2, [r2 + r3]
    vpmovzxwd ymm3, [r2 + r3 + CRD]
    vpermd ymm2, ymm7, ymm2
    vpermd ymm3, ymm7, ymm3
    vcvtdq2ps ymm2, ymm2
    vcvtdq2ps ymm3, ymm3
    vbroadcastss ymm4, [r1]
    vfmadd231ps ymm0, ymm4, ymm2
    vfmadd231ps ymm1, ymm4, ymm3
    lea r3d, [r0 - 1]
    test r3d, r3d
    cmovs r3d, r6d
    imul r3, r3, CST
    vpmovzxwd ymm2, [r2 + r3]
    vpmovzxwd ymm3, [r2 + r3 + CRD]
    vpermd ymm2, ymm7, ymm2
    vpermd ymm3, ymm7, ymm3
    vcvtdq2ps ymm2, ymm2
    vcvtdq2ps ymm3, ymm3
    vbroadcastss ymm4, [r1 + 4]
    vfmadd231ps ymm0, ymm4, ymm2
    vfmadd231ps ymm1, ymm4, ymm3
    mov r6d, [dp + 4]
    mov r3d, r0d
    cmp r3d, r6d
    cmovg r3d, r6d
    imul r3, r3, CST
    vpmovzxwd ymm2, [r2 + r3]
    vpmovzxwd ymm3, [r2 + r3 + CRD]
    vpermd ymm2, ymm7, ymm2
    vpermd ymm3, ymm7, ymm3
    vcvtdq2ps ymm2, ymm2
    vcvtdq2ps ymm3, ymm3
    vbroadcastss ymm4, [r1 + 8]
    vfmadd231ps ymm0, ymm4, ymm2
    vfmadd231ps ymm1, ymm4, ymm3
    lea r3d, [r0 + 1]
    cmp r3d, r6d
    cmovg r3d, r6d
    imul r3, r3, CST
    vpmovzxwd ymm2, [r2 + r3]
    vpmovzxwd ymm3, [r2 + r3 + CRD]
    vpermd ymm2, ymm7, ymm2
    vpermd ymm3, ymm7, ymm3
    vcvtdq2ps ymm2, ymm2
    vcvtdq2ps ymm3, ymm3
    vbroadcastss ymm4, [r1 + 12]
    vfmadd231ps ymm0, ymm4, ymm2
    vfmadd231ps ymm1, ymm4, ymm3
    ret
.xeo:
    vandpd ymm13, ymm14, [u_mzero]
    vxorpd ymm14, ymm14, ymm13
    vxorpd ymm15, ymm15, ymm13
    vmovapd [r13 + T_SG], ymm13
    vxorpd ymm12, ymm12, ymm12
    vcmppd ymm12, ymm14, ymm12, 0x12
    vmovapd [r13 + T_ZM], ymm12
    vmovapd ymm11, [u_one]
    vblendvpd ymm14, ymm14, ymm11, ymm12
    vandnpd ymm15, ymm12, ymm15
    call .dln
    vbroadcastsd ymm0, [u_e125]
    vbroadcastsd ymm1, [u_e125 + 8]
    vmulpd ymm2, ymm0, ymm14
    vmovapd ymm3, ymm2
    vfmsub231pd ymm3, ymm0, ymm14
    vmulpd ymm4, ymm1, ymm14
    vfmadd231pd ymm4, ymm0, ymm15
    vaddpd ymm3, ymm3, ymm4
    vaddpd ymm4, ymm2, ymm3
    vsubpd ymm5, ymm4, ymm2
    vsubpd ymm5, ymm3, ymm5
    vmovapd ymm14, ymm4
    vmovapd ymm15, ymm5
    call .dexp
    vmovapd ymm12, [r13 + T_ZM]
    vandnpd ymm14, ymm12, ymm14
    vandnpd ymm15, ymm12, ymm15
    vxorpd ymm14, ymm14, [r13 + T_SG]
    vxorpd ymm15, ymm15, [r13 + T_SG]
    ret
.xoe:
    vandpd ymm13, ymm14, [u_mzero]
    vxorpd ymm14, ymm14, ymm13
    vxorpd ymm15, ymm15, ymm13
    vmovapd [r13 + T_SG], ymm13
    vxorpd ymm12, ymm12, ymm12
    vcmppd ymm12, ymm14, ymm12, 0x12
    vmovapd [r13 + T_ZM], ymm12
    vmovapd ymm11, [u_one]
    vblendvpd ymm14, ymm14, ymm11, ymm12
    vandnpd ymm15, ymm12, ymm15
    call .dln
    vbroadcastsd ymm0, [u_e512]
    vbroadcastsd ymm1, [u_e512 + 8]
    vmulpd ymm2, ymm0, ymm14
    vmovapd ymm3, ymm2
    vfmsub231pd ymm3, ymm0, ymm14
    vmulpd ymm4, ymm1, ymm14
    vfmadd231pd ymm4, ymm0, ymm15
    vaddpd ymm3, ymm3, ymm4
    vaddpd ymm4, ymm2, ymm3
    vsubpd ymm5, ymm4, ymm2
    vsubpd ymm5, ymm3, ymm5
    vmovapd ymm14, ymm4
    vmovapd ymm15, ymm5
    call .dexp
    vmovapd ymm12, [r13 + T_ZM]
    vandnpd ymm14, ymm12, ymm14
    vandnpd ymm15, ymm12, ymm15
    vxorpd ymm14, ymm14, [r13 + T_SG]
    vxorpd ymm15, ymm15, [r13 + T_SG]
    ret
.dln:
    vmovapd [r13 + T_LN], ymm14
    vmovapd [r13 + T_LN + 32], ymm14
    vmovapd [r13 + T_LN + 64], ymm15
    fldln2
    fld qword [r13 + T_LN]
    fyl2x
    fstp qword [r13 + T_LN]
    fldln2
    fld qword [r13 + T_LN + 8]
    fyl2x
    fstp qword [r13 + T_LN + 8]
    fldln2
    fld qword [r13 + T_LN + 16]
    fyl2x
    fstp qword [r13 + T_LN + 16]
    fldln2
    fld qword [r13 + T_LN + 24]
    fyl2x
    fstp qword [r13 + T_LN + 24]
    vmovapd ymm14, [r13 + T_LN]
    vxorpd ymm14, ymm14, [u_mzero]
    vxorpd ymm15, ymm15, ymm15
    call .dexp
    vxorpd ymm0, ymm0, ymm0
    vmovapd ymm1, [r13 + T_LN + 32]
    vmovapd ymm2, [r13 + T_LN + 64]
    vmulpd ymm3, ymm1, ymm14
    vmovapd ymm4, ymm3
    vfmsub231pd ymm4, ymm1, ymm14
    vmulpd ymm5, ymm2, ymm14
    vfmadd231pd ymm5, ymm1, ymm15
    vaddpd ymm4, ymm4, ymm5
    vaddpd ymm5, ymm3, ymm4
    vsubpd ymm6, ymm5, ymm3
    vsubpd ymm6, ymm4, ymm6
    vbroadcastsd ymm2, [u_mone]
    vbroadcastsd ymm1, [u_mzero]
    vaddpd ymm4, ymm5, ymm2
    vsubpd ymm3, ymm4, ymm5
    vsubpd ymm7, ymm4, ymm3
    vsubpd ymm7, ymm5, ymm7
    vsubpd ymm3, ymm2, ymm3
    vaddpd ymm7, ymm7, ymm3
    vaddpd ymm3, ymm6, ymm1
    vsubpd ymm8, ymm3, ymm6
    vsubpd ymm9, ymm3, ymm8
    vsubpd ymm9, ymm6, ymm9
    vsubpd ymm8, ymm1, ymm8
    vaddpd ymm9, ymm9, ymm8
    vaddpd ymm8, ymm7, ymm3
    vaddpd ymm3, ymm4, ymm8
    vsubpd ymm7, ymm3, ymm4
    vsubpd ymm7, ymm8, ymm7
    vaddpd ymm8, ymm7, ymm9
    vaddpd ymm9, ymm3, ymm8
    vsubpd ymm7, ymm9, ymm3
    vsubpd ymm7, ymm8, ymm7
    vmovapd ymm6, [r13 + T_LN]
    vaddpd ymm5, ymm6, ymm9
    vsubpd ymm1, ymm5, ymm6
    vsubpd ymm2, ymm5, ymm1
    vsubpd ymm2, ymm6, ymm2
    vsubpd ymm1, ymm9, ymm1
    vaddpd ymm2, ymm2, ymm1
    vaddpd ymm1, ymm0, ymm7
    vsubpd ymm8, ymm1, ymm0
    vsubpd ymm3, ymm1, ymm8
    vsubpd ymm3, ymm0, ymm3
    vsubpd ymm8, ymm7, ymm8
    vaddpd ymm3, ymm3, ymm8
    vaddpd ymm8, ymm2, ymm1
    vaddpd ymm1, ymm5, ymm8
    vsubpd ymm2, ymm1, ymm5
    vsubpd ymm2, ymm8, ymm2
    vaddpd ymm8, ymm2, ymm3
    vaddpd ymm3, ymm1, ymm8
    vsubpd ymm2, ymm3, ymm1
    vsubpd ymm2, ymm8, ymm2
    vmovapd ymm14, ymm3
    vmovapd ymm15, ymm2
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
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm4, ymm5
    vsubpd ymm7, ymm6, ymm4
    vsubpd ymm7, ymm5, ymm7
    vmovapd [r13 + T_K], ymm2
    vxorpd ymm2, ymm6, [u_mzero]
    vxorpd ymm3, ymm7, [u_mzero]
    vaddpd ymm7, ymm14, ymm2
    vsubpd ymm6, ymm7, ymm14
    vsubpd ymm1, ymm7, ymm6
    vsubpd ymm1, ymm14, ymm1
    vsubpd ymm6, ymm2, ymm6
    vaddpd ymm1, ymm1, ymm6
    vaddpd ymm6, ymm15, ymm3
    vsubpd ymm5, ymm6, ymm15
    vsubpd ymm4, ymm6, ymm5
    vsubpd ymm4, ymm15, ymm4
    vsubpd ymm5, ymm3, ymm5
    vaddpd ymm4, ymm4, ymm5
    vaddpd ymm5, ymm1, ymm6
    vaddpd ymm6, ymm7, ymm5
    vsubpd ymm1, ymm6, ymm7
    vsubpd ymm1, ymm5, ymm1
    vaddpd ymm5, ymm1, ymm4
    vaddpd ymm4, ymm6, ymm5
    vsubpd ymm1, ymm4, ymm6
    vsubpd ymm1, ymm5, ymm1
    vbroadcastsd ymm3, [u_i1024]
    vmulpd ymm2, ymm4, ymm3
    vmovapd ymm5, ymm2
    vfmsub231pd ymm5, ymm4, ymm3
    vmulpd ymm6, ymm1, ymm3
    vfmadd231pd ymm6, ymm4, ymm0
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm2, ymm5
    vsubpd ymm7, ymm6, ymm2
    vsubpd ymm7, ymm5, ymm7
    vmovapd [r13 + T_RR], ymm6
    vmovapd [r13 + T_RR + 32], ymm7
    vbroadcastsd ymm7, [u_one]
    vmovapd ymm6, ymm0
    vmovapd [r13 + T_S], ymm7
    vmovapd [r13 + T_S + 32], ymm6
    vmovapd [r13 + T_T], ymm7
    vmovapd [r13 + T_T + 32], ymm6
    lea r4, [u_cs]
.dexp_t:
    vmovapd ymm6, [r13 + T_T]
    vmovapd ymm7, [r13 + T_T + 32]
    vmulpd ymm1, ymm6, [r13 + T_RR]
    vmovapd ymm4, ymm1
    vfmsub231pd ymm4, ymm6, [r13 + T_RR]
    vmulpd ymm3, ymm7, [r13 + T_RR]
    vfmadd231pd ymm3, ymm6, [r13 + T_RR + 32]
    vaddpd ymm4, ymm4, ymm3
    vaddpd ymm3, ymm1, ymm4
    vsubpd ymm5, ymm3, ymm1
    vsubpd ymm5, ymm4, ymm5
    vbroadcastsd ymm7, [r4]
    vdivpd ymm6, ymm3, ymm7
    vxorpd ymm4, ymm6, [u_mzero]
    vmulpd ymm1, ymm7, ymm4
    vmovapd ymm2, ymm1
    vfmsub231pd ymm2, ymm7, ymm4
    vmulpd ymm8, ymm0, ymm4
    vfmadd231pd ymm8, ymm7, ymm0
    vaddpd ymm2, ymm2, ymm8
    vaddpd ymm8, ymm1, ymm2
    vsubpd ymm9, ymm8, ymm1
    vsubpd ymm9, ymm2, ymm9
    vaddpd ymm4, ymm3, ymm8
    vsubpd ymm2, ymm4, ymm3
    vsubpd ymm1, ymm4, ymm2
    vsubpd ymm1, ymm3, ymm1
    vsubpd ymm2, ymm8, ymm2
    vaddpd ymm1, ymm1, ymm2
    vaddpd ymm2, ymm5, ymm9
    vsubpd ymm10, ymm2, ymm5
    vsubpd ymm11, ymm2, ymm10
    vsubpd ymm11, ymm5, ymm11
    vsubpd ymm10, ymm9, ymm10
    vaddpd ymm11, ymm11, ymm10
    vaddpd ymm10, ymm1, ymm2
    vaddpd ymm2, ymm4, ymm10
    vsubpd ymm1, ymm2, ymm4
    vsubpd ymm1, ymm10, ymm1
    vaddpd ymm10, ymm1, ymm11
    vaddpd ymm11, ymm2, ymm10
    vsubpd ymm1, ymm11, ymm2
    vsubpd ymm1, ymm10, ymm1
    vdivpd ymm5, ymm11, ymm7
    vxorpd ymm3, ymm5, [u_mzero]
    vmulpd ymm9, ymm7, ymm3
    vmovapd ymm8, ymm9
    vfmsub231pd ymm8, ymm7, ymm3
    vmulpd ymm10, ymm0, ymm3
    vfmadd231pd ymm10, ymm7, ymm0
    vaddpd ymm8, ymm8, ymm10
    vaddpd ymm10, ymm9, ymm8
    vsubpd ymm2, ymm10, ymm9
    vsubpd ymm2, ymm8, ymm2
    vaddpd ymm3, ymm11, ymm10
    vsubpd ymm8, ymm3, ymm11
    vsubpd ymm9, ymm3, ymm8
    vsubpd ymm9, ymm11, ymm9
    vsubpd ymm8, ymm10, ymm8
    vaddpd ymm9, ymm9, ymm8
    vaddpd ymm8, ymm1, ymm2
    vsubpd ymm4, ymm8, ymm1
    vsubpd ymm12, ymm8, ymm4
    vsubpd ymm12, ymm1, ymm12
    vsubpd ymm4, ymm2, ymm4
    vaddpd ymm12, ymm12, ymm4
    vaddpd ymm4, ymm9, ymm8
    vaddpd ymm8, ymm3, ymm4
    vsubpd ymm9, ymm8, ymm3
    vsubpd ymm9, ymm4, ymm9
    vaddpd ymm4, ymm9, ymm12
    vaddpd ymm12, ymm8, ymm4
    vdivpd ymm1, ymm12, ymm7
    vaddpd ymm9, ymm6, ymm5
    vsubpd ymm12, ymm9, ymm6
    vsubpd ymm12, ymm5, ymm12
    vaddpd ymm5, ymm9, ymm1
    vsubpd ymm6, ymm5, ymm9
    vsubpd ymm11, ymm5, ymm6
    vsubpd ymm11, ymm9, ymm11
    vsubpd ymm6, ymm1, ymm6
    vaddpd ymm11, ymm11, ymm6
    vaddpd ymm6, ymm12, ymm0
    vsubpd ymm2, ymm6, ymm12
    vsubpd ymm10, ymm6, ymm2
    vsubpd ymm10, ymm12, ymm10
    vsubpd ymm2, ymm0, ymm2
    vaddpd ymm10, ymm10, ymm2
    vaddpd ymm2, ymm11, ymm6
    vaddpd ymm6, ymm5, ymm2
    vsubpd ymm11, ymm6, ymm5
    vsubpd ymm11, ymm2, ymm11
    vaddpd ymm2, ymm11, ymm10
    vaddpd ymm10, ymm6, ymm2
    vsubpd ymm11, ymm10, ymm6
    vsubpd ymm11, ymm2, ymm11
    vmovapd [r13 + T_T], ymm10
    vmovapd [r13 + T_T + 32], ymm11
    vmovapd ymm7, [r13 + T_S]
    vmovapd ymm1, [r13 + T_S + 32]
    vaddpd ymm12, ymm7, ymm10
    vsubpd ymm9, ymm12, ymm7
    vsubpd ymm2, ymm12, ymm9
    vsubpd ymm2, ymm7, ymm2
    vsubpd ymm9, ymm10, ymm9
    vaddpd ymm2, ymm2, ymm9
    vaddpd ymm9, ymm1, ymm11
    vsubpd ymm6, ymm9, ymm1
    vsubpd ymm5, ymm9, ymm6
    vsubpd ymm5, ymm1, ymm5
    vsubpd ymm6, ymm11, ymm6
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm2, ymm9
    vaddpd ymm9, ymm12, ymm6
    vsubpd ymm2, ymm9, ymm12
    vsubpd ymm2, ymm6, ymm2
    vaddpd ymm6, ymm2, ymm5
    vaddpd ymm5, ymm9, ymm6
    vsubpd ymm2, ymm5, ymm9
    vsubpd ymm2, ymm6, ymm2
    vmovapd [r13 + T_S], ymm5
    vmovapd [r13 + T_S + 32], ymm2
    add r4, 8
    lea r5, [u_cs + 104]
    cmp r4, r5
    jne .dexp_t
    vmovapd ymm2, [r13 + T_S]
    vmovapd ymm5, [r13 + T_S + 32]
    mov r4d, 10
.dexp_q:
    vmulpd ymm11, ymm2, ymm2
    vmovapd ymm10, ymm11
    vfmsub231pd ymm10, ymm2, ymm2
    vmulpd ymm1, ymm5, ymm2
    vfmadd231pd ymm1, ymm2, ymm5
    vaddpd ymm10, ymm10, ymm1
    vaddpd ymm1, ymm11, ymm10
    vsubpd ymm7, ymm1, ymm11
    vsubpd ymm7, ymm10, ymm7
    vmovapd ymm2, ymm1
    vmovapd ymm5, ymm7
    dec r4d
    jnz .dexp_q
    vmovapd ymm7, [r13 + T_K]
    vaddpd ymm7, ymm7, [u_magic]
    vpsllq ymm7, ymm7, 52
    vmulpd ymm14, ymm2, ymm7
    vmulpd ymm15, ymm5, ymm7
    ret
