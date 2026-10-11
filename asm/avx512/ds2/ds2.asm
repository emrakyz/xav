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
SLT equ 11136 + 256
CARRY equ 11136 + 8*SPBC + 512
CARZ equ (16*(9*M+1)+63)/64*64
FMR equ CARRY + CARZ
BMS equ FMR + 64*((M+3)/2)
%assign SPS 16
%if M > SPS
%assign SSZ SPS
%assign SLST ((M-1) % SPS) + 1
%else
%assign SSZ M
%assign SLST M
%endif
%assign NCL (SLST+1)/2
STX equ BMS + 2560*SSZ
FRAME equ STX + 3328
BH0 equ BMS
S_DST equ 9928
S_SRC equ 9936

SECTION_RODATA 8

t_lof: dq 0, W, 32, W + 32

SECTION .text align=64
INIT_ZMM avx512

cextern ro
cextern dp

%define c_tx ro
%define c_wx (ro + 128)
%define c_rx (ro + 192)
%define c_to (ro + 256)
%define c_wo (ro + 384)
%define c_ro (ro + 448)
%define c_s2 (ro + 512)
%define c_ones (ro + 576)
%define c_onesw (ro + 640)
%define c_n64w (ro + 704)
%define c_qx0 (ro + 768)
%define c_qx1 (ro + 772)
%define c_qx2 (ro + 776)
%define c_qo0 (ro + 780)
%define c_qo1 (ro + 784)
%define c_qo2 (ro + 788)
%define c_xflr (ro + 792)
%define c_xlo (ro + 796)
%define c_eq (ro + 800)
%define c_ieq (ro + 804)
%define c_epsf (ro + 808)
%define c_xrcr (ro + 812)
%define c_xgcr (ro + 816)
%define c_xgcb (ro + 820)
%define c_xbcb (ro + 824)
%define c_kh0 (ro + 828)
%define c_kh1 (ro + 832)
%define c_kh2 (ro + 836)
%define c_kh3 (ro + 840)
%define c_kh4 (ro + 844)
%define c_kh5 (ro + 848)
%define c_h0625 (ro + 852)
%define c_h5625 (ro + 856)
%define c_one (ro + 860)
%define c_half (ro + 864)
%define c_rgl0 (ro + 868)
%define c_rgl1 (ro + 872)
%define c_rgl2 (ro + 876)
%define c_oml0 (ro + 880)
%define c_oml1 (ro + 884)
%define c_oml2 (ro + 888)
%define c_anegl (ro + 892)
%define c_snegl (ro + 896)
%define c_tabsl (ro + 900)
%define c_mtl0 (ro + 904)
%define c_mtl1 (ro + 908)
%define c_mtl2 (ro + 912)
%define c_slkl (ro + 916)
%define c_rgh0 (ro + 920)
%define c_rgh1 (ro + 924)
%define c_rgh2 (ro + 928)
%define c_omh0 (ro + 932)
%define c_omh1 (ro + 936)
%define c_omh2 (ro + 940)
%define c_anegh (ro + 944)
%define c_snegh (ro + 948)
%define c_tabsh (ro + 952)
%define c_mth0 (ro + 956)
%define c_mth1 (ro + 960)
%define c_mth2 (ro + 964)
%define c_mth4 (ro + 968)
%define c_mth5 (ro + 972)
%define c_slkh0 (ro + 976)
%define c_slkh1 (ro + 980)
%define c_sign (ro + 984)
%define c_absm (ro + 988)
%define c_i64 (ro + 992)
%define c_i512 (ro + 996)
%define c_i1023 (ro + 1000)
%define c_zero (ro + 1004)
%define c_m1 (ro + 1008)
%define c_pkw (ro + 1024)
%define t_oa (ro + 1088)
%define t_ob (ro + 1216)
%define t_ow (ro + 1280)
%define t_rx (ro + 1408)
%define t_tsl (ro + 1536)
%define t_wsx (ro + 1664)
%define t_iota (ro + 1792)
%define t_k75 (ro + 1824)
%define t_k25 (ro + 1840)
%define t_k50 (ro + 1856)
%define t_one2 (ro + 1872)
%define t_sgn2 (ro + 1888)
%define t_abs2 (ro + 1904)
%define t_q2i (ro + 1920)
%define t_q2j (ro + 1936)
%define t_one (ro + 1952)
%define t_eq0 (ro + 1960)
%define t_omg (ro + 1968)
%define t_epsn (ro + 1976)
%define t_rg2 (ro + 1984)
%define t_tab (ro + 1992)
%define t_xflr (ro + 2000)
%define t_tsk (ro + 2008)
%define t_mone (ro + 2016)
%define t_mzero (ro + 2024)
%define t_zero (ro + 2032)
%define t_half (ro + 2040)
%define t_mhalf (ro + 2048)
%define t_ln2 (ro + 2056)
%define t_i1024 (ro + 2064)
%define t_876 (ro + 2072)
%define t_64 (ro + 2080)
%define t_512 (ro + 2088)
%define t_quart (ro + 2096)
%define t_six (ro + 2104)
%define t_ylo (ro + 2112)
%define t_yhi (ro + 2120)
%define t_clo (ro + 2128)
%define t_chi (ro + 2136)
%define t_c1 (ro + 2144)
%define t_c2 (ro + 2152)
%define t_c3 (ro + 2160)
%define t_c4 (ro + 2168)
%define t_c5 (ro + 2176)
%define t_c6 (ro + 2184)
%define t_c7 (ro + 2192)
%define t_c8 (ro + 2200)
%define t_c9 (ro + 2208)
%define t_c10 (ro + 2216)
%define t_c11 (ro + 2224)
%define t_c12 (ro + 2232)
%define t_c13 (ro + 2240)
%define t_lzm0 (ro + 2248)
%define t_lzm1 (ro + 2256)
%define t_lzm2 (ro + 2264)
%define t_lzm3 (ro + 2272)
%define t_lzm4 (ro + 2280)
%define t_lzm5 (ro + 2288)
%define t_emc0 (ro + 2296)
%define t_emc1 (ro + 2304)
%define t_emc2 (ro + 2312)
%define t_emc3 (ro + 2320)
%define t_emc4 (ro + 2328)
%define t_emc5 (ro + 2336)
%define t_emc6 (ro + 2344)
%define t_emc7 (ro + 2352)
%define t_emc8 (ro + 2360)
%define t_psx0 (ro + 2368)
%define t_psx1 (ro + 2376)
%define t_psx2 (ro + 2384)
%define t_psx3 (ro + 2392)
%define t_op0 (ro + 2400)
%define t_op1 (ro + 2408)
%define t_op2 (ro + 2416)
%define t_op3 (ro + 2424)
%define t_op4 (ro + 2432)
%define t_rgl0 (ro + 2440)
%define t_rgl1 (ro + 2448)
%define t_rgl2 (ro + 2456)
%define t_mtl0 (ro + 2464)
%define t_mtl1 (ro + 2472)
%define t_mtl2 (ro + 2480)
%define t_slol0 (ro + 2488)
%define t_shil0 (ro + 2496)
%define t_anegl (ro + 2504)
%define t_snegl (ro + 2512)
%define t_tabsl (ro + 2520)
%define t_rgh0 (ro + 2528)
%define t_rgh1 (ro + 2536)
%define t_rgh2 (ro + 2544)
%define t_mth0 (ro + 2552)
%define t_mth1 (ro + 2560)
%define t_mth2 (ro + 2568)
%define t_mth3 (ro + 2576)
%define t_mth4 (ro + 2584)
%define t_mth5 (ro + 2592)
%define t_sloh0 (ro + 2600)
%define t_sloh1 (ro + 2608)
%define t_shih0 (ro + 2616)
%define t_shih1 (ro + 2624)
%define t_anegh (ro + 2632)
%define t_snegh (ro + 2640)
%define t_tabsh (ro + 2648)
%define t_sign (ro + 2656)
%define t_q1023 (ro + 2664)
%define t_q16 (ro + 2672)
%define t_ln2d (ro + 2680)
%define t_e125 (ro + 2696)
%define t_e512 (ro + 2712)
%define t_kr (ro + 2728)
%define t_kg (ro + 2744)
%define t_kb (ro + 2760)
%define t_ysc (ro + 2776)
%define t_yof (ro + 2792)
%define t_rcr (ro + 2808)
%define t_gcr (ro + 2824)
%define t_gcb (ro + 2840)
%define t_bcb (ro + 2856)
%define t_cbs (ro + 2872)
%define t_crs (ro + 2888)
%define t_wid (ro + 2944)
%define t_w32 (ro + 3008)
%define t_ones (ro + 3072)
%define t_l2d (ro + 3136)
%define t_c2d (ro + 3200)

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
    mov [rsp + 9920], r6
    mov [rsp + 9928], r1
    mov [rsp + 9936], r0
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
    vpmovzxwd zmm0, [r3 + r2 + W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vmovaps [r4 + r3*8 + 8*W], zmm0
    vpmovzxwd zmm1, [r3 + r2 + W + CRD]
    vpsubd zmm1, zmm1, [c_i512]{1to16}
    vcvtdq2ps zmm1, zmm1
    vmovaps [r4 + r3*8 + 8*W + 64], zmm1
    add r3, 32
    jnz .cpe
    vpmovzxwd zmm0, [r2 + W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vmovaps [r4 + 8*W], zmm0
    vbroadcastss zmm0, [r4]
    vmovaps [r4 - 256], zmm0
    vpmovzxwd zmm1, [r2 + W + CRD]
    vpsubd zmm1, zmm1, [c_i512]{1to16}
    vcvtdq2ps zmm1, zmm1
    vmovaps [r4 + 8*W + 64], zmm1
    vbroadcastss zmm1, [r4 + 64]
    vmovaps [r4 - 192], zmm1
    mov r3, -8*W
.cpo:
    vmovaps zmm0, [r4 + r3 + 8*W]
    vmovaps zmm1, [r4 + r3 + 8*W + 256]
    valignd zmm2, zmm0, [r4 + r3 + 8*W - 256], 15
    valignd zmm3, zmm1, zmm0, 1
    valignd zmm4, zmm1, zmm0, 2
    vaddps zmm3, zmm3, zmm0
    vaddps zmm2, zmm2, zmm4
    vmulps zmm2, zmm2, [c_h0625]{1to16}
    vfmsub132ps zmm3, zmm2, [c_h5625]{1to16}
    vmovaps [r4 + r3 + 8*W + 128], zmm3
    vmovaps zmm8, [r4 + r3 + 8*W + 64]
    vmovaps zmm9, [r4 + r3 + 8*W + 320]
    valignd zmm10, zmm8, [r4 + r3 + 8*W - 192], 15
    valignd zmm11, zmm9, zmm8, 1
    valignd zmm12, zmm9, zmm8, 2
    vaddps zmm11, zmm11, zmm8
    vaddps zmm10, zmm10, zmm12
    vmulps zmm10, zmm10, [c_h0625]{1to16}
    vfmsub132ps zmm11, zmm10, [c_h5625]{1to16}
    vmovaps [r4 + r3 + 8*W + 192], zmm11
    add r3, 256
    jnz .cpo
    add r2, CST
    add r4, SPBC
    dec r5d
    jnz .cpr
    lea r4, [rsp + SLT]
    mov r3, -8*W
.cpc:
    vmovaps zmm0, [r4 + r3 + 8*W + 2*SPBC]
    vmovaps [r4 + r3 + 8*W], zmm0
    vmovaps [r4 + r3 + 8*W + SPBC], zmm0
    vmovaps zmm1, [r4 + r3 + 8*W + 2*SPBC + 128]
    vmovaps [r4 + r3 + 8*W + 128], zmm1
    vmovaps [r4 + r3 + 8*W + SPBC + 128], zmm1
    vmovaps zmm2, [r4 + r3 + 8*W + 2*SPBC + 256]
    vmovaps [r4 + r3 + 8*W + 256], zmm2
    vmovaps [r4 + r3 + 8*W + SPBC + 256], zmm2
    vmovaps zmm3, [r4 + r3 + 8*W + 2*SPBC + 384]
    vmovaps [r4 + r3 + 8*W + 384], zmm3
    vmovaps [r4 + r3 + 8*W + SPBC + 384], zmm3
    vmovaps zmm0, [r4 + r3 + 8*W + 2*SPBC + 64]
    vmovaps [r4 + r3 + 8*W + 64], zmm0
    vmovaps [r4 + r3 + 8*W + SPBC + 64], zmm0
    vmovaps zmm1, [r4 + r3 + 8*W + 2*SPBC + 192]
    vmovaps [r4 + r3 + 8*W + 192], zmm1
    vmovaps [r4 + r3 + 8*W + SPBC + 192], zmm1
    vmovaps zmm2, [r4 + r3 + 8*W + 2*SPBC + 320]
    vmovaps [r4 + r3 + 8*W + 320], zmm2
    vmovaps [r4 + r3 + 8*W + SPBC + 320], zmm2
    vmovaps zmm3, [r4 + r3 + 8*W + 2*SPBC + 448]
    vmovaps [r4 + r3 + 8*W + 448], zmm3
    vmovaps [r4 + r3 + 8*W + SPBC + 448], zmm3
    add r3, 512
    jnz .cpc
    mov r2, [dp + 8]
    add r2, r0
    mov r3, -W
.cpb:
    vmovdqu16 zmm0, [r3 + r2 - CST]
    vmovdqu16 [r2 + r3], zmm0
    vmovdqu16 [r3 + r2 + CST], zmm0
    vmovdqu16 zmm0, [r3 + r2 + CRD - CST]
    vmovdqu16 [r2 + r3 + CRD], zmm0
    vmovdqu16 [r3 + r2 + CRD + CST], zmm0
    add r3, 64
    jnz .cpb
    vpxord zmm0, zmm0, zmm0
    vmovaps [rsp + BH0], zmm0
    vmovaps [rsp + BH0 + 64], zmm0
    vmovaps [rsp + BH0 + 128], zmm0
    vmovaps [rsp + BH0 + 192], zmm0
    vmovaps [rsp + BH0 + 256], zmm0
    vmovaps [rsp + BH0 + 320], zmm0
    vmovaps [rsp + BH0 + 384], zmm0
    vmovaps [rsp + BH0 + 448], zmm0
    vmovaps [rsp + BH0 + 512], zmm0
    vmovaps [rsp + BH0 + 576], zmm0
    vmovaps [rsp + BH0 + 640], zmm0
    vmovaps [rsp + BH0 + 704], zmm0
    vmovaps [rsp + BH0 + 768], zmm0
    vmovaps [rsp + BH0 + 832], zmm0
    vmovaps [rsp + BH0 + 896], zmm0
    vmovaps [rsp + BH0 + 960], zmm0
    vmovaps [rsp + BH0 + 1024], zmm0
    vmovaps [rsp + BH0 + 1088], zmm0
    vmovaps [rsp + BH0 + 1152], zmm0
    vmovaps [rsp + BH0 + 1216], zmm0
    vpternlogd zmm0, zmm0, zmm0, 0xff
    mov r3, -64*((M+3)/2)
.fmi:
    vmovaps [rsp + r3 + FMR + 64*((M+3)/2)], zmm0
    add r3, 64
    jnz .fmi
    mov dword [rsp + 10000], 1280*SSZ
    mov qword [rsp + STX + 3264], 0
    mov qword [rsp + STX + 3272], 0
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
    lea r14, [rsp + BH0]
%if FORMAT_ELF
SECTION .note.GNU-stack
%else
SECTION .dry info
%endif
..@s0:
    mov [rsp + 9944], r14
    mov [rsp + 9952], r11
    mov [rsp + 9960], r6
    mov r2d, [rsp + 10000]
    xor r2d, 1280*SSZ
    mov [rsp + 10000], r2d
    lea r13, [rsp + r2 + BMS]
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
    vpmovzxwd zmm0, [r0 - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8], zmm0
    vmovaps [r8 - 256], zmm1
    vpmovzxwd zmm0, [r0 + CRD - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8 + 64], zmm0
    vmovaps [r8 + 64 - 256], zmm1
    vpmovzxwd zmm0, [r0 + CST - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8 + SPBC], zmm0
    vmovaps [r8 + SPBC - 256], zmm1
    vpmovzxwd zmm0, [r0 + CST + CRD - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8 + SPBC + 64], zmm0
    vmovaps [r8 + SPBC + 64 - 256], zmm1
    vpxord zmm0, zmm0, zmm0
    vmovaps [rsp + 6848], zmm0
    vmovaps [rsp + 6912], zmm0
    vmovaps [rsp + 6976], zmm0
    vmovaps [rsp + 7040], zmm0
    vmovups zmm0, [c_s2]
    vmovaps [rsp + 7104], zmm0
    mov r3, -(W/2)
..@s1:
SECTION .text
PN equ (64 - (($ - $$) + (..@s1 - ..@s0)) % 64) % 64
    times (PN >= 2) jmp strict short .period
    times (PN >= 2) * (PN - 2) int3
    times (PN == 1) nop
.period:
    mov [rsp + 9944], r14
    mov [rsp + 9952], r11
    mov [rsp + 9960], r6
    mov r2d, [rsp + 10000]
    xor r2d, 1280*SSZ
    mov [rsp + 10000], r2d
    lea r13, [rsp + r2 + BMS]
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
    vpmovzxwd zmm0, [r0 - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8], zmm0
    vmovaps [r8 - 256], zmm1
    vpmovzxwd zmm0, [r0 + CRD - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8 + 64], zmm0
    vmovaps [r8 + 64 - 256], zmm1
    vpmovzxwd zmm0, [r0 + CST - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8 + SPBC], zmm0
    vmovaps [r8 + SPBC - 256], zmm1
    vpmovzxwd zmm0, [r0 + CST + CRD - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8 + SPBC + 64], zmm0
    vmovaps [r8 + SPBC + 64 - 256], zmm1
    vpxord zmm0, zmm0, zmm0
    vmovaps [rsp + 6848], zmm0
    vmovaps [rsp + 6912], zmm0
    vmovaps [rsp + 6976], zmm0
    vmovaps [rsp + 7040], zmm0
    vmovups zmm0, [c_s2]
    vmovaps [rsp + 7104], zmm0
    mov r3, -(W/2)
    ALIGN 64
.pair:
    vbroadcastss zmm31, [c_xlo]
    vbroadcastss zmm30, [c_absm]
    vbroadcastss zmm29, [c_eq]
    vbroadcastss zmm28, [c_ieq]
    vbroadcastss zmm27, [c_rgl0]
    vbroadcastss zmm26, [c_rgl1]
    vbroadcastss zmm25, [c_rgl2]
    vbroadcastss zmm24, [c_oml0]
    vbroadcastss zmm23, [c_oml1]
    vbroadcastss zmm22, [c_oml2]
    vbroadcastss zmm21, [c_epsf]
    vbroadcastss zmm20, [c_anegl]
    vbroadcastss zmm19, [c_snegl]
    vbroadcastss zmm18, [c_tabsl]
    vsubps zmm0, zmm21, [r14 + 192]
    vmovups zmm1, [r14]
    vmovups zmm2, [r14 + 64]
    vmovups zmm3, [r14 + 128]
    vsubps zmm4, zmm21, [r14 + 448]
    vmovups zmm5, [r14 + 256]
    vmovups zmm6, [r14 + 320]
    vmovups zmm7, [r14 + 384]
    vrsqrt14ps zmm8, zmm0
    vmovaps zmm9, zmm28
    vrsqrt14ps zmm10, zmm4
    vandps zmm11, zmm1, zmm30
    vandps zmm12, zmm2, zmm30
    vandps zmm13, zmm3, zmm30
    vandps zmm14, zmm5, zmm30
    vandps zmm15, zmm6, zmm30
    vandps zmm16, zmm7, zmm30
    vfmadd213ps zmm8, zmm19, zmm20
    vfmadd213ps zmm10, zmm19, zmm20
    vfmadd213ps zmm8, zmm0, zmm18
    vmovaps zmm17, zmm28
    vfmadd213ps zmm10, zmm4, zmm18
    vmovaps zmm1, zmm8
    vfmadd231ps zmm1, zmm11, zmm27
    vmovaps zmm2, zmm8
    vfmadd231ps zmm2, zmm12, zmm26
    vsubps zmm3, zmm11, zmm1
    vsubps zmm5, zmm12, zmm2
    vfmadd231ps zmm8, zmm13, zmm25
    vcmpps k1, zmm3, zmm31, 30
    vcmpps k2, zmm3, zmm31, 26
    vrcp14ps zmm6, zmm3
    vcmpps k3, zmm5, zmm31, 30
    vcmpps k4, zmm5, zmm31, 26
    vrcp14ps zmm7, zmm5
    vsubps zmm0, zmm13, zmm8
    vmovaps zmm4, zmm28
    vcmpps k5, zmm0, zmm31, 30
    vcmpps k6, zmm0, zmm31, 26
    vaddps zmm11{k2}, zmm11, zmm1
    vmulps zmm9{k1}, zmm1, zmm6
    kmovw [rsp], k1
    vrcp14ps zmm3, zmm0
    vsubps zmm5, zmm21, [r14 + 704]
    vmulps zmm17{k3}, zmm2, zmm7
    kmovw [rsp + 2], k3
    vmovups zmm1, [r14 + 512]
    vaddps zmm12{k4}, zmm12, zmm2
    vmovups zmm6, [r14 + 576]
    vmovups zmm0, [r14 + 640]
    vmovaps zmm7, zmm10
    vfmadd231ps zmm7, zmm14, zmm27
    vmovaps [rsp + 3136], zmm11
    vrsqrt14ps zmm2, zmm5
    vfmadd213ps zmm9, zmm29, zmm24
    vmovaps [rsp + 3264], zmm12
    vfmadd213ps zmm17, zmm29, zmm23
    vaddps zmm13{k6}, zmm13, zmm8
    vmulps zmm4{k5}, zmm8, zmm3
    kmovw [rsp + 4], k5
    vmovaps zmm11, zmm28
    vandps zmm12, zmm1, zmm30
    vandps zmm8, zmm6, zmm30
    vandps zmm3, zmm0, zmm30
    vsubps zmm1, zmm14, zmm7
    vmovaps zmm6, zmm10
    vfmadd231ps zmm6, zmm15, zmm26
    vmovaps [rsp + 3200], zmm9
    vfmadd213ps zmm2, zmm19, zmm20
    vmovaps [rsp + 3328], zmm17
    vfmadd213ps zmm4, zmm29, zmm22
    vmovaps [rsp + 3392], zmm13
    vcmpps k7, zmm1, zmm31, 30
    vcmpps k2, zmm1, zmm31, 26
    vmovaps zmm0, zmm28
    vrcp14ps zmm9, zmm1
    vfmadd231ps zmm10, zmm16, zmm25
    vsubps zmm17, zmm15, zmm6
    vfmadd213ps zmm2, zmm5, zmm18
    vmovaps [rsp + 3456], zmm4
    vcmpps k1, zmm17, zmm31, 30
    vcmpps k3, zmm17, zmm31, 26
    vrcp14ps zmm13, zmm17
    vsubps zmm1, zmm16, zmm10
    vmovaps zmm5, zmm28
    vaddps zmm14{k2}, zmm14, zmm7
    vmulps zmm11{k7}, zmm7, zmm9
    kmovw [rsp + 6], k7
    vsubps zmm4, zmm21, [r14 + 960]
    vcmpps k4, zmm1, zmm31, 30
    vcmpps k6, zmm1, zmm31, 26
    vmovaps [rsp + 3520], zmm14
    vrcp14ps zmm17, zmm1
    vmovups zmm7, [r14 + 768]
    vfmadd213ps zmm11, zmm29, zmm24
    vrsqrt14ps zmm9, zmm4
    vmovups zmm14, [r14 + 832]
    vaddps zmm15{k3}, zmm15, zmm6
    vmulps zmm0{k1}, zmm6, zmm13
    kmovw [rsp + 8], k1
    vmovups zmm1, [r14 + 896]
    vmovaps zmm6, zmm2
    vfmadd231ps zmm6, zmm12, zmm27
    vmovaps [rsp + 3648], zmm15
    vmovaps [rsp + 3584], zmm11
    vfmadd213ps zmm0, zmm29, zmm23
    vaddps zmm16{k6}, zmm16, zmm10
    vmulps zmm5{k4}, zmm10, zmm17
    vandps zmm13, zmm7, zmm30
    kmovw [rsp + 10], k4
    vfmadd231ps zmm20, zmm9, zmm19
    vandps zmm15, zmm14, zmm30
    vsubps zmm11, zmm12, zmm6
    jmp .j128
.j128:
    vmovaps zmm10, zmm28
    vandps zmm17, zmm1, zmm30
    vmovaps zmm7, zmm2
    vfmadd231ps zmm7, zmm8, zmm26
    vmovaps [rsp + 3776], zmm16
    vfmadd213ps zmm5, zmm29, zmm22
    vcmpps k5, zmm11, zmm31, 30
    vcmpps k2, zmm11, zmm31, 26
    vmovaps zmm9, zmm28
    vmovaps [rsp + 3712], zmm0
    vrcp14ps zmm14, zmm11
    vfmadd231ps zmm18, zmm20, zmm4
    vfmadd231ps zmm2, zmm3, zmm25
    vsubps zmm1, zmm8, zmm7
    vmovaps [rsp + 3840], zmm5
    vcmpps k7, zmm1, zmm31, 30
    vcmpps k3, zmm1, zmm31, 26
    vaddps zmm12{k2}, zmm12, zmm6
    vmulps zmm10{k5}, zmm6, zmm14
    kmovw [rsp + 12], k5
    vrcp14ps zmm16, zmm1
    vsubps zmm0, zmm3, zmm2
    vmovaps zmm11, zmm28
    vbroadcastss zmm20, [c_epsf]
    vmovaps [rsp + 3904], zmm12
    vcmpps k1, zmm0, zmm31, 30
    vcmpps k6, zmm0, zmm31, 26
    vfmadd213ps zmm10, zmm29, zmm24
    vrcp14ps zmm4, zmm0
    vbroadcastss zmm5, [c_anegh]
    vmovups zmm6, [r14 + 1024]
    vmovups zmm14, [r14 + 1088]
    vaddps zmm8{k3}, zmm8, zmm7
    vmulps zmm9{k7}, zmm7, zmm16
    kmovw [rsp + 14], k7
    vmovups zmm1, [r14 + 1152]
    vsubps zmm12, zmm20, [r14 + 1216]
    vfmadd213ps zmm27, zmm13, zmm18
    vmovaps [rsp + 3968], zmm10
    vmovaps [rsp + 4032], zmm8
    vfmadd213ps zmm9, zmm29, zmm23
    vaddps zmm3{k6}, zmm3, zmm2
    vmulps zmm11{k1}, zmm2, zmm4
    vrsqrt14ps zmm0, zmm12
    kmovw [rsp + 16], k1
    vandps zmm7, zmm6, zmm30
    vandps zmm16, zmm14, zmm30
    vmovaps zmm20, zmm28
    vandps zmm10, zmm1, zmm30
    vsubps zmm8, zmm13, zmm27
    vfmadd213ps zmm26, zmm15, zmm18
    vmovaps [rsp + 4160], zmm3
    vfmadd213ps zmm11, zmm29, zmm22
    vmovaps [rsp + 4096], zmm9
    vcmpps k4, zmm8, zmm31, 30
    vcmpps k2, zmm8, zmm31, 26
    vmovaps zmm2, zmm28
    vfmadd231ps zmm5, zmm0, [c_snegh]{1to16}
    vrcp14ps zmm4, zmm8
    vsubps zmm6, zmm15, zmm26
    vfmadd231ps zmm18, zmm17, zmm25
    vmovaps [rsp + 4224], zmm11
    vcmpps k5, zmm6, zmm31, 30
    vcmpps k3, zmm6, zmm31, 26
    vfmadd213ps zmm5, zmm12, [c_tabsh]{1to16}
    vrcp14ps zmm14, zmm6
    vaddps zmm13{k2}, zmm13, zmm27
    vmulps zmm20{k4}, zmm27, zmm4
    kmovw [rsp + 18], k4
    vsubps zmm1, zmm17, zmm18
    vmovaps zmm3, zmm28
    vmovaps [rsp + 4288], zmm13
    vcmpps k7, zmm1, zmm31, 30
    vcmpps k6, zmm1, zmm31, 26
    vfmadd231ps zmm24, zmm20, zmm29
    vrcp14ps zmm9, zmm1
    vmovaps zmm0, zmm5
    vfmadd231ps zmm0, zmm7, [c_rgh0]{1to16}
    vaddps zmm15{k3}, zmm15, zmm26
    vmulps zmm2{k5}, zmm26, zmm14
    kmovw [rsp + 20], k5
    vmovaps zmm8, zmm28
    vbroadcastss zmm11, [c_omh0]
    vmovaps [rsp + 4416], zmm15
    vmovaps [rsp + 4352], zmm24
    vfmadd231ps zmm23, zmm2, zmm29
    vsubps zmm12, zmm7, zmm0
    vmovaps zmm6, zmm5
    vfmadd231ps zmm6, zmm16, [c_rgh1]{1to16}
    vaddps zmm17{k6}, zmm17, zmm18
    vmulps zmm3{k7}, zmm18, zmm9
    kmovw [rsp + 22], k7
    vmovaps zmm27, zmm28
    vcmpps k1, zmm12, zmm31, 30
    vcmpps k2, zmm12, zmm31, 26
    vmovaps [rsp + 4544], zmm17
    vrcp14ps zmm4, zmm12
    vbroadcastss zmm13, [c_omh1]
    vmovaps [rsp + 4480], zmm23
    vfmadd231ps zmm22, zmm3, zmm29
    vsubps zmm20, zmm16, zmm6
    vfmadd231ps zmm5, zmm10, [c_rgh2]{1to16}
    vcmpps k4, zmm20, zmm31, 30
    vcmpps k3, zmm20, zmm31, 26
    vrcp14ps zmm1, zmm20
    vmovaps [rsp + 4608], zmm22
    vaddps zmm7{k2}, zmm7, zmm0
    vmulps zmm8{k1}, zmm0, zmm4
    vsubps zmm26, zmm10, zmm5
    vmovaps zmm14, zmm28
    kmovw [rsp + 24], k1
    vbroadcastss zmm15, [c_omh2]
    vmovaps [rsp + 4672], zmm7
    vcmpps k5, zmm26, zmm31, 30
    vcmpps k6, zmm26, zmm31, 26
    vfmadd231ps zmm11, zmm8, zmm29
    vrcp14ps zmm24, zmm26
    vaddps zmm16{k3}, zmm16, zmm6
    vmulps zmm27{k4}, zmm6, zmm1
    kmovw [rsp + 26], k4
    vmovaps [rsp + 4800], zmm16
    vmovaps [rsp + 4736], zmm11
    vfmadd231ps zmm13, zmm27, zmm29
    vaddps zmm10{k6}, zmm10, zmm5
    vmulps zmm14{k5}, zmm5, zmm24
    kmovw [rsp + 28], k5
    vmovaps [rsp + 4928], zmm10
    vmovaps [rsp + 4864], zmm13
    jmp .j256
.j256:
    vfmadd231ps zmm15, zmm14, zmm29
    vmovaps [rsp + 4992], zmm15
    vbroadcastss zmm31, [c_kh0]
    vbroadcastss zmm30, [c_kh1]
    vbroadcastss zmm29, [c_kh2]
    vbroadcastss zmm28, [c_kh3]
    vbroadcastss zmm27, [c_kh4]
    vbroadcastss zmm26, [c_kh5]
    vbroadcastss zmm25, [c_xrcr]
    vbroadcastss zmm24, [c_xgcr]
    vbroadcastss zmm23, [c_xgcb]
    vbroadcastss zmm22, [c_xbcb]
    vmovups zmm21, [c_n64w]
    vmovups zmm20, [c_onesw]
    vmovups zmm0, [r4 + SPBC]
    vmovups zmm1, [r5]
    vmovups zmm2, [r5 + SPBC]
    vmovups zmm3, [r7]
    vmovups zmm4, [r4 + 64 + SPBC]
    vmovups zmm5, [r5 + 64]
    vmovups zmm6, [r5 + 64 + SPBC]
    vmovups zmm7, [r7 + 64]
    vsubps zmm8, zmm0, [r7 + SPBC]
    vaddps zmm9, zmm0, zmm3
    vaddps zmm10, zmm1, zmm2
    vsubps zmm11, zmm0, zmm3
    vsubps zmm12, zmm1, zmm2
    vsubps zmm13, zmm0, zmm2
    vsubps zmm14, zmm3, [r4]
    vsubps zmm15, zmm3, zmm1
    vaddps zmm16, zmm4, zmm7
    vmovups zmm17, [r1 + r3*4]
    vmulps zmm18, zmm9, zmm31
    vaddps zmm19, zmm5, zmm6
    vsubps zmm0, zmm4, zmm7
    vmulps zmm2, zmm11, zmm29
    vsubps zmm3, zmm5, zmm6
    vsubps zmm1, zmm4, zmm6
    vsubps zmm9, zmm7, [r4 + 64]
    vsubps zmm11, zmm7, zmm5
    vmulps zmm6, zmm16, zmm31
    vsubps zmm7, zmm4, [r7 + 64 + SPBC]
    vmovups zmm5, [r1 + r3*4 + 2*W]
    vmulps zmm16, zmm0, zmm29
    vfmadd231ps zmm18, zmm10, zmm30
    vfmadd231ps zmm2, zmm12, zmm28
    vpaddw zmm4, zmm17, zmm21
    vfmadd231ps zmm6, zmm19, zmm30
    vfmadd231ps zmm16, zmm3, zmm28
    vpmaddwd zmm0, zmm4, zmm20
    vpaddw zmm10, zmm5, zmm21
    vmovups zmm12, [r1 + r3*4 + 2*W*2]
    vsubps zmm17, zmm18, zmm2
    vaddps zmm19, zmm18, zmm2
    vpmaddwd zmm3, zmm10, zmm20
    vcvtdq2ps zmm4, zmm0
    vsubps zmm5, zmm6, zmm16
    vaddps zmm18, zmm6, zmm16
    vfmadd213ps zmm13, zmm27, zmm17
    vfmadd213ps zmm15, zmm27, zmm19
    vcvtdq2ps zmm2, zmm3
    vpaddw zmm10, zmm12, zmm21
    vfmadd213ps zmm1, zmm27, zmm5
    vfmadd213ps zmm11, zmm27, zmm18
    vmovups zmm0, [r1 + r3*4 + 2*W*3]
    vpmaddwd zmm6, zmm10, zmm20
    vfnmadd231ps zmm13, zmm14, zmm26
    vfnmadd231ps zmm15, zmm8, zmm26
    vmovaps zmm16, zmm2
    vfmadd231ps zmm16, zmm5, zmm24
    vfmadd213ps zmm5, zmm25, zmm2
    vfmadd231ps zmm2, zmm17, zmm22
    vfnmadd231ps zmm1, zmm9, zmm26
    vfnmadd231ps zmm11, zmm7, zmm26
    vcvtdq2ps zmm3, zmm6
    vpaddw zmm12, zmm0, zmm21
    vmovups zmm10, [r4 + 128 + SPBC]
    vmovups zmm14, [r5 + 128]
    vmovups zmm8, [r5 + 128 + SPBC]
    vmovaps zmm9, zmm4
    vfmadd231ps zmm9, zmm13, zmm22
    vmovups zmm7, [r7 + 128]
    vfmadd231ps zmm16, zmm17, zmm23
    vmovaps [rsp + 256], zmm5
    vpmaddwd zmm6, zmm12, zmm20
    vmovaps [rsp + 384], zmm2
    vmovaps zmm0, zmm4
    vfmadd231ps zmm0, zmm1, zmm24
    vfmadd231ps zmm4, zmm1, zmm25
    vmovaps zmm17, zmm3
    vfmadd231ps zmm17, zmm18, zmm24
    vfmadd213ps zmm18, zmm25, zmm3
    vfmadd231ps zmm3, zmm19, zmm22
    vmovaps [rsp + 192], zmm9
    vcvtdq2ps zmm5, zmm6
    vaddps zmm12, zmm14, zmm8
    vmovaps [rsp + 320], zmm16
    vaddps zmm2, zmm10, zmm7
    vsubps zmm1, zmm10, zmm7
    vsubps zmm9, zmm14, zmm8
    vsubps zmm6, zmm10, zmm8
    vmovups zmm16, [r4 + 192 + SPBC]
    vfmadd231ps zmm0, zmm13, zmm23
    vmovaps [rsp + 64], zmm4
    vsubps zmm8, zmm7, [r4 + 128]
    vsubps zmm13, zmm7, zmm14
    vmovups zmm4, [r5 + 192]
    vfmadd231ps zmm17, zmm19, zmm23
    vmovaps [rsp + 448], zmm18
    vsubps zmm7, zmm10, [r7 + 128 + SPBC]
    vmovups zmm14, [r5 + 192 + SPBC]
    vmovaps [rsp + 576], zmm3
    vmovaps zmm19, zmm5
    vfmadd231ps zmm19, zmm11, zmm24
    vfmadd213ps zmm11, zmm25, zmm5
    vmovups zmm18, [r7 + 192]
    vfmadd231ps zmm5, zmm15, zmm22
    vmulps zmm10, zmm2, zmm31
    vmulps zmm3, zmm1, zmm29
    vmovaps [rsp + 128], zmm0
    vsubps zmm2, zmm16, [r7 + 192 + SPBC]
    vmovaps [rsp + 512], zmm17
    vfmadd231ps zmm19, zmm15, zmm23
    vmovaps [rsp + 640], zmm11
    vfmadd231ps zmm10, zmm12, zmm30
    vaddps zmm1, zmm4, zmm14
    vsubps zmm0, zmm4, zmm14
    vmovups zmm17, [r1 + r3*4]
    jmp .j384
.j384:
    vmovaps [rsp + 768], zmm5
    vfmadd231ps zmm3, zmm9, zmm28
    vaddps zmm15, zmm16, zmm18
    vsubps zmm11, zmm16, zmm18
    vsubps zmm12, zmm16, zmm14
    vsubps zmm5, zmm18, [r4 + 192]
    vsubps zmm9, zmm18, zmm4
    vmovups zmm16, [r1 + r3*4 + 2*W]
    vmulps zmm14, zmm15, zmm31
    vmulps zmm18, zmm11, zmm29
    vmovaps [rsp + 704], zmm19
    vsubps zmm4, zmm10, zmm3
    vaddps zmm15, zmm10, zmm3
    vpaddw zmm11, zmm17, zmm21
    vfmadd231ps zmm14, zmm1, zmm30
    vfmadd231ps zmm18, zmm0, zmm28
    vpsrad zmm19, zmm11, 16
    vpaddw zmm10, zmm16, zmm21
    vfmadd213ps zmm6, zmm27, zmm4
    vfmadd213ps zmm13, zmm27, zmm15
    vmovups zmm3, [r1 + r3*4 + 2*W*2]
    vcvtdq2ps zmm17, zmm19
    vpsrad zmm1, zmm10, 16
    vsubps zmm0, zmm14, zmm18
    vaddps zmm11, zmm14, zmm18
    vfnmadd231ps zmm6, zmm8, zmm26
    vfnmadd231ps zmm13, zmm7, zmm26
    vcvtdq2ps zmm16, zmm1
    vpaddw zmm19, zmm3, zmm21
    vmovups zmm10, [r1 + r3*4 + 2*W*3]
    vfmadd213ps zmm12, zmm27, zmm0
    vfmadd213ps zmm9, zmm27, zmm11
    vpsrad zmm14, zmm19, 16
    vmovaps zmm18, zmm16
    vfmadd231ps zmm18, zmm0, zmm24
    vfmadd213ps zmm0, zmm25, zmm16
    vmovaps zmm8, zmm17
    vfmadd231ps zmm8, zmm6, zmm22
    vfmadd231ps zmm16, zmm4, zmm22
    vcvtdq2ps zmm7, zmm14
    vpaddw zmm1, zmm10, zmm21
    vmovups zmm3, [r4 + 256 + SPBC]
    vfnmadd231ps zmm12, zmm5, zmm26
    vfnmadd231ps zmm9, zmm2, zmm26
    vmovups zmm19, [r5 + 256]
    vmovups zmm14, [r5 + 256 + SPBC]
    vmovups zmm10, [r7 + 256]
    vfmadd231ps zmm18, zmm4, zmm23
    vmovaps [rsp + 1024], zmm0
    vpsrad zmm5, zmm1, 16
    vmovaps [rsp + 960], zmm8
    vmovaps zmm2, zmm7
    vfmadd231ps zmm2, zmm11, zmm24
    vfmadd213ps zmm11, zmm25, zmm7
    vmovaps [rsp + 1152], zmm16
    vfmadd231ps zmm7, zmm15, zmm22
    vcvtdq2ps zmm4, zmm5
    vmovaps zmm0, zmm17
    vfmadd231ps zmm0, zmm12, zmm24
    vfmadd231ps zmm17, zmm12, zmm25
    vaddps zmm1, zmm19, zmm14
    vsubps zmm8, zmm19, zmm14
    vmovaps [rsp + 1088], zmm18
    vaddps zmm16, zmm3, zmm10
    vsubps zmm5, zmm3, zmm10
    vfmadd231ps zmm2, zmm15, zmm23
    vmovaps [rsp + 1216], zmm11
    vsubps zmm12, zmm3, zmm14
    vsubps zmm18, zmm10, [r4 + 256]
    vmovups zmm15, [r4 + 320 + SPBC]
    vmovaps [rsp + 1344], zmm7
    vmovaps zmm11, zmm4
    vfmadd231ps zmm11, zmm9, zmm24
    vfmadd213ps zmm9, zmm25, zmm4
    vsubps zmm14, zmm10, zmm19
    vsubps zmm7, zmm3, [r7 + 256 + SPBC]
    vmovups zmm10, [r5 + 320]
    vfmadd231ps zmm4, zmm13, zmm22
    vmovups zmm19, [r5 + 320 + SPBC]
    vmovups zmm3, [r7 + 320]
    vfmadd231ps zmm0, zmm6, zmm23
    vmovaps [rsp + 832], zmm17
    vmulps zmm6, zmm16, zmm31
    vmulps zmm17, zmm5, zmm29
    vmovaps [rsp + 1280], zmm2
    vfmadd231ps zmm11, zmm13, zmm23
    vmovaps [rsp + 1408], zmm9
    vsubps zmm16, zmm15, [r7 + 320 + SPBC]
    vmovaps [rsp + 1536], zmm4
    vfmadd231ps zmm6, zmm1, zmm30
    vmovups zmm5, [r1 + r3*4 + 64]
    vmovaps [rsp + 896], zmm0
    vfmadd231ps zmm17, zmm8, zmm28
    vaddps zmm2, zmm15, zmm3
    vaddps zmm13, zmm10, zmm19
    vsubps zmm9, zmm15, zmm3
    vsubps zmm4, zmm10, zmm19
    vsubps zmm1, zmm15, zmm19
    vsubps zmm0, zmm3, [r4 + 320]
    vsubps zmm8, zmm3, zmm10
    vmovups zmm15, [r1 + r3*4 + 64 + 2*W]
    vmovaps [rsp + 1472], zmm11
    vmulps zmm19, zmm2, zmm31
    vmulps zmm3, zmm9, zmm29
    vsubps zmm10, zmm6, zmm17
    vaddps zmm11, zmm6, zmm17
    vpaddw zmm2, zmm5, zmm21
    vfmadd231ps zmm19, zmm13, zmm30
    vpmaddwd zmm9, zmm2, zmm20
    vfmadd213ps zmm12, zmm27, zmm10
    vfmadd213ps zmm14, zmm27, zmm11
    vpaddw zmm6, zmm15, zmm21
    vmovups zmm17, [r1 + r3*4 + 64 + 2*W*2]
    vfmadd231ps zmm3, zmm4, zmm28
    vpmaddwd zmm5, zmm6, zmm20
    vcvtdq2ps zmm13, zmm9
    vfnmadd231ps zmm12, zmm18, zmm26
    vfnmadd231ps zmm14, zmm7, zmm26
    vsubps zmm2, zmm19, zmm3
    vaddps zmm15, zmm19, zmm3
    vpaddw zmm4, zmm17, zmm21
    vcvtdq2ps zmm6, zmm5
    vmovups zmm9, [r1 + r3*4 + 64 + 2*W*3]
    vpmaddwd zmm18, zmm4, zmm20
    vfmadd213ps zmm1, zmm27, zmm2
    vfmadd213ps zmm8, zmm27, zmm15
    vmovaps zmm7, zmm13
    vfmadd231ps zmm7, zmm12, zmm22
    jmp .j512
.j512:
    vmovaps zmm19, zmm6
    vfmadd231ps zmm19, zmm2, zmm24
    vfmadd213ps zmm2, zmm25, zmm6
    vfmadd231ps zmm6, zmm10, zmm22
    vcvtdq2ps zmm3, zmm18
    vpaddw zmm17, zmm9, zmm21
    vmovups zmm5, [r4 + 384 + SPBC]
    vmovups zmm4, [r5 + 384]
    vfnmadd231ps zmm1, zmm0, zmm26
    vfnmadd231ps zmm8, zmm16, zmm26
    vmovups zmm18, [r5 + 384 + SPBC]
    vmovups zmm9, [r7 + 384]
    vmovaps [rsp + 1728], zmm7
    vpmaddwd zmm0, zmm17, zmm20
    vfmadd231ps zmm19, zmm10, zmm23
    vmovaps [rsp + 1792], zmm2
    vmovaps [rsp + 1920], zmm6
    vmovaps zmm16, zmm3
    vfmadd231ps zmm16, zmm15, zmm24
    vfmadd213ps zmm15, zmm25, zmm3
    vfmadd231ps zmm3, zmm11, zmm22
    vmovaps zmm7, zmm13
    vfmadd231ps zmm7, zmm1, zmm24
    vfmadd231ps zmm13, zmm1, zmm25
    vcvtdq2ps zmm17, zmm0
    vaddps zmm10, zmm5, zmm9
    vaddps zmm2, zmm4, zmm18
    vmovaps [rsp + 1856], zmm19
    vsubps zmm6, zmm5, zmm9
    vsubps zmm1, zmm4, zmm18
    vfmadd231ps zmm16, zmm11, zmm23
    vmovaps [rsp + 1984], zmm15
    vsubps zmm0, zmm5, zmm18
    vsubps zmm19, zmm9, [r4 + 384]
    vmovups zmm11, [r4 + 448 + SPBC]
    vmovaps [rsp + 2112], zmm3
    vsubps zmm15, zmm9, zmm4
    vsubps zmm18, zmm5, [r7 + 384 + SPBC]
    vmovups zmm3, [r5 + 448]
    vmovaps zmm9, zmm17
    vfmadd231ps zmm9, zmm8, zmm24
    vfmadd213ps zmm8, zmm25, zmm17
    vmovups zmm4, [r5 + 448 + SPBC]
    vmovups zmm5, [r7 + 448]
    vfmadd231ps zmm7, zmm12, zmm23
    vmovaps [rsp + 1600], zmm13
    vfmadd231ps zmm17, zmm14, zmm22
    vmulps zmm12, zmm10, zmm31
    vmulps zmm13, zmm6, zmm29
    vmovaps [rsp + 2048], zmm16
    vsubps zmm10, zmm11, [r7 + 448 + SPBC]
    vfmadd231ps zmm9, zmm14, zmm23
    vmovaps [rsp + 2176], zmm8
    vmovaps [rsp + 1664], zmm7
    vfmadd231ps zmm12, zmm2, zmm30
    vfmadd231ps zmm13, zmm1, zmm28
    vaddps zmm6, zmm11, zmm5
    vaddps zmm16, zmm3, zmm4
    vmovups zmm14, [r1 + r3*4 + 64]
    vmovaps [rsp + 2304], zmm17
    vsubps zmm8, zmm11, zmm5
    vsubps zmm7, zmm3, zmm4
    vsubps zmm2, zmm11, zmm4
    vsubps zmm1, zmm5, [r4 + 448]
    vsubps zmm17, zmm5, zmm3
    vmovups zmm11, [r1 + r3*4 + 64 + 2*W]
    vmulps zmm4, zmm6, zmm31
    vmovaps [rsp + 2240], zmm9
    vmulps zmm5, zmm8, zmm29
    vsubps zmm3, zmm12, zmm13
    vaddps zmm6, zmm12, zmm13
    vpaddw zmm9, zmm14, zmm21
    vfmadd231ps zmm4, zmm16, zmm30
    vfmadd213ps zmm0, zmm27, zmm3
    vfmadd213ps zmm15, zmm27, zmm6
    vpsrad zmm8, zmm9, 16
    vpaddw zmm12, zmm11, zmm21
    vfmadd231ps zmm5, zmm7, zmm28
    vmovups zmm13, [r1 + r3*4 + 64 + 2*W*2]
    vcvtdq2ps zmm14, zmm8
    vpsrad zmm16, zmm12, 16
    vfnmadd231ps zmm0, zmm19, zmm26
    vfnmadd231ps zmm15, zmm18, zmm26
    vcvtdq2ps zmm9, zmm16
    vsubps zmm11, zmm4, zmm5
    vaddps zmm7, zmm4, zmm5
    vpaddw zmm8, zmm13, zmm21
    vmovups zmm12, [r1 + r3*4 + 64 + 2*W*3]
    vfmadd213ps zmm2, zmm27, zmm11
    vfmadd213ps zmm17, zmm27, zmm7
    vpsrad zmm19, zmm8, 16
    vmovaps zmm18, zmm14
    vfmadd231ps zmm18, zmm0, zmm22
    vmovaps zmm16, zmm9
    vfmadd231ps zmm16, zmm11, zmm24
    vfmadd213ps zmm11, zmm25, zmm9
    vfmadd231ps zmm9, zmm3, zmm22
    vcvtdq2ps zmm4, zmm19
    vpaddw zmm5, zmm12, zmm21
    vfnmadd231ps zmm2, zmm1, zmm26
    vfnmadd231ps zmm17, zmm10, zmm26
    vmovaps [rsp + 2496], zmm18
    vfmadd231ps zmm16, zmm3, zmm23
    vpsrad zmm13, zmm5, 16
    vmovaps [rsp + 2560], zmm11
    vmovaps zmm8, zmm4
    vfmadd231ps zmm8, zmm7, zmm24
    vfmadd213ps zmm7, zmm25, zmm4
    vmovaps [rsp + 2688], zmm9
    vfmadd231ps zmm4, zmm6, zmm22
    vcvtdq2ps zmm19, zmm13
    vmovaps zmm12, zmm14
    vfmadd231ps zmm12, zmm2, zmm24
    vfmadd231ps zmm14, zmm2, zmm25
    vmovaps [rsp + 2624], zmm16
    vfmadd231ps zmm8, zmm6, zmm23
    vmovaps [rsp + 2752], zmm7
    vmovaps [rsp + 2880], zmm4
    vfmadd213ps zmm24, zmm17, zmm19
    vfmadd213ps zmm17, zmm25, zmm19
    vfmadd231ps zmm19, zmm15, zmm22
    vfmadd231ps zmm12, zmm0, zmm23
    vmovaps [rsp + 2368], zmm14
    vmovaps [rsp + 2816], zmm8
    vfmadd231ps zmm24, zmm15, zmm23
    vmovaps [rsp + 2944], zmm17
    vmovaps [rsp + 3072], zmm19
    vmovaps [rsp + 2432], zmm12
    jmp .j640
.j640:
    vmovaps [rsp + 3008], zmm24
    lea r2d, [r12 + r3*2]
    and r2d, 16383
    vmovups zmm31, [c_to]
    vmovups zmm30, [c_to + 64]
    vmovups zmm29, [c_wo]
    vmovups zmm28, [c_ro]
    vbroadcastss zmm27, [c_one]
    vbroadcastss zmm26, [c_qo0]
    vbroadcastss zmm25, [c_qo1]
    vbroadcastss zmm24, [c_qo2]
    vbroadcastss zmm23, [c_xlo]
    vbroadcastss zmm22, [c_sign]
    vbroadcastss zmm21, [c_half]
    vmovups zmm0, [rsp + 3392]
    vmovups zmm1, [rsp + 3136]
    vmovups zmm2, [rsp + 3264]
    vmaxps zmm3, zmm0, zmm23
    vmaxps zmm4, zmm1, zmm23
    vmaxps zmm5, zmm2, zmm23
    vpsrld zmm6, zmm3, 23
    vpsrld zmm7, zmm3, 19
    vgetmantps zmm8, zmm3, 4
    vpsrld zmm9, zmm4, 23
    vmovups zmm10, [rsp + 3776]
    vpsrld zmm11, zmm4, 19
    vgetmantps zmm12, zmm4, 4
    vpermi2ps zmm6, zmm31, zmm30
    vpermps zmm13, zmm7, zmm29
    vpsrld zmm14, zmm5, 23
    vpermps zmm15, zmm7, zmm28
    vpermi2ps zmm9, zmm31, zmm30
    vpsrld zmm16, zmm5, 19
    vpermps zmm17, zmm11, zmm29
    vpermps zmm18, zmm11, zmm28
    vgetmantps zmm19, zmm5, 4
    vpermi2ps zmm14, zmm31, zmm30
    kmovw k1, [rsp + 4]
    vpermps zmm20, zmm16, zmm29
    vpermps zmm0, zmm16, zmm28
    vmovups zmm1, [r14 + 128]
    vmaxps zmm2, zmm10, zmm23
    vbroadcastss zmm3, [c_slkl]
    vmovups zmm4, [rsp + 3520]
    vmulps zmm7, zmm6, zmm13
    vfmsub213ps zmm8, zmm15, zmm27
    vfmsub213ps zmm12, zmm18, zmm27
    vmulps zmm11, zmm9, zmm17
    vpsrld zmm5, zmm2, 23
    vpsrld zmm16, zmm2, 19
    vgetmantps zmm10, zmm2, 4
    vfmsub213ps zmm19, zmm0, zmm27
    vmulps zmm6, zmm14, zmm20
    vpermi2ps zmm5, zmm31, zmm30
    vpermps zmm13, zmm16, zmm29
    vpermps zmm15, zmm16, zmm28
    vmaxps zmm18, zmm4, zmm23
    vmovaps zmm9, zmm25
    vfmadd231ps zmm9, zmm8, zmm24
    vmulps zmm17, zmm7, zmm8
    kmovw k2, [rsp]
    vmovaps zmm2, zmm25
    vfmadd231ps zmm2, zmm12, zmm24
    vmulps zmm0, zmm11, zmm12
    vmovups zmm14, [r14]
    vmovups zmm20, [rsp + 3648]
    vpsrld zmm16, zmm18, 23
    vpsrld zmm4, zmm18, 19
    vgetmantps zmm18, zmm18, 4
    vmulps zmm5, zmm5, zmm13
    vfmsub213ps zmm10, zmm15, zmm27
    vfmadd213ps zmm9, zmm8, zmm26
    vpermi2ps zmm16, zmm31, zmm30
    vpermps zmm13, zmm4, zmm29
    vpermps zmm15, zmm4, zmm28
    vfmadd213ps zmm2, zmm12, zmm26
    vmovaps zmm8, zmm25
    vfmadd231ps zmm8, zmm19, zmm24
    vmulps zmm4, zmm6, zmm19
    vmaxps zmm12, zmm20, zmm23
    kmovw k3, [rsp + 2]
    vmovups zmm20, [r14 + 64]
    vfmadd231ps zmm7, zmm17, zmm9
    vfmadd231ps zmm11, zmm0, zmm2
    vpsrld zmm17, zmm12, 23
    vpsrld zmm9, zmm12, 19
    vfmsub213ps zmm18, zmm15, zmm27
    vmulps zmm0, zmm16, zmm13
    vgetmantps zmm2, zmm12, 4
    vfmadd213ps zmm8, zmm19, zmm26
    vpermi2ps zmm17, zmm31, zmm30
    vpermps zmm15, zmm9, zmm29
    vpermps zmm16, zmm9, zmm28
    vpbroadcastd zmm13, [c_m1]
    vmulps zmm12, zmm7, [rsp + 3456]
    vpternlogd zmm7{k1}{z}, zmm1, zmm22, 216
    vmulps zmm19, zmm11, [rsp + 3200]
    vpternlogd zmm11{k2}{z}, zmm14, zmm22, 216
    vmovups zmm9, [rsp + 4160]
    vmulps zmm1, zmm7, [c_mtl2]{1to16}
    vfmadd231ps zmm6, zmm4, zmm8
    vfmadd231ps zmm3, zmm12, [c_mtl2]{1to16}
    vmulps zmm14, zmm17, zmm15
    vfmsub213ps zmm2, zmm16, zmm27
    vfmadd231ps zmm1, zmm11, [c_mtl0]{1to16}
    vmaxps zmm7, zmm9, zmm23
    vmulps zmm4, zmm6, [rsp + 3328]
    vpternlogd zmm6{k3}{z}, zmm20, zmm22, 216
    vmovaps zmm8, zmm25
    vfmadd231ps zmm8, zmm10, zmm24
    vmulps zmm12, zmm5, zmm10
    vfmadd231ps zmm3, zmm19, [c_mtl0]{1to16}
    vpsrld zmm17, zmm7, 23
    vpsrld zmm15, zmm7, 19
    kmovw k4, [rsp + 10]
    vgetmantps zmm16, zmm7, 4
    vmovups zmm11, [r14 + 384]
    vfmadd231ps zmm1, zmm6, [c_mtl1]{1to16}
    vbroadcastss zmm9, [c_slkl]
    vpermi2ps zmm17, zmm31, zmm30
    vpermps zmm20, zmm15, zmm29
    vfmadd213ps zmm8, zmm10, zmm26
    vmovups zmm19, [rsp + 3904]
    vpermps zmm7, zmm15, zmm28
    vfmadd231ps zmm3, zmm4, [c_mtl1]{1to16}
    vreduceps zmm6, zmm1, 8
    vcvtps2dq zmm10, zmm1, {rn-sae}
    vfmadd231ps zmm5, zmm12, zmm8
    vmulps zmm15, zmm17, zmm20
    vmaxps zmm4, zmm19, zmm23
    jmp .j768
.j768:
    vmovaps zmm1, zmm25
    vfmadd231ps zmm1, zmm18, zmm24
    vfmsub213ps zmm16, zmm7, zmm27
    vmulps zmm12, zmm0, zmm18
    kmovw k5, [rsp + 6]
    vpaddd zmm8, zmm10, [c_i64]{1to16}
    vmovups zmm17, [r14 + 256]
    vpsrld zmm20, zmm4, 23
    vpsrld zmm19, zmm4, 19
    vmulps zmm7, zmm5, [rsp + 3840]
    vpternlogd zmm5{k4}{z}, zmm11, zmm22, 216
    vgetmantps zmm10, zmm4, 4
    vmovups zmm11, [rsp + 4032]
    vandps zmm4, zmm6, [c_absm]{1to16}
    vpminsd zmm6, zmm8, [c_i1023]{1to16}
    vfmadd213ps zmm1, zmm18, zmm26
    vpermi2ps zmm20, zmm31, zmm30
    vpermps zmm8, zmm19, zmm29
    vmulps zmm18, zmm5, [c_mtl2]{1to16}
    vpermps zmm5, zmm19, zmm28
    vaddps zmm19, zmm4, zmm3
    vmovaps zmm4, zmm25
    vfmadd231ps zmm4, zmm2, zmm24
    vfmadd231ps zmm9, zmm7, [c_mtl2]{1to16}
    vmulps zmm3, zmm14, zmm2
    kmovw k6, [rsp + 8]
    vfmadd231ps zmm0, zmm12, zmm1
    vmaxps zmm7, zmm11, zmm23
    vmovups zmm12, [r14 + 320]
    vcmpps k7, zmm19, zmm21, 17
    vmulps zmm1, zmm20, zmm8
    vfmsub213ps zmm10, zmm5, zmm27
    vfmadd213ps zmm4, zmm2, zmm26
    vpsrld zmm11, zmm7, 23
    vpsrld zmm19, zmm7, 19
    vgetmantps zmm20, zmm7, 4
    vmulps zmm8, zmm0, [rsp + 3584]
    vpternlogd zmm0{k5}{z}, zmm17, zmm22, 216
    vpermi2ps zmm11, zmm31, zmm30
    vpermps zmm5, zmm19, zmm29
    vpbroadcastd zmm2, [c_m1]
    vpermps zmm7, zmm19, zmm28
    vmovups zmm17, [rsp + 4544]
    vpmaxsd zmm13{k7}, zmm6, [c_zero]{1to16}
    kmovw [rsp + r3 + FMR + W/2], k7
    vfmadd231ps zmm18, zmm0, [c_mtl0]{1to16}
    vfmadd231ps zmm14, zmm3, zmm4
    vfmadd231ps zmm9, zmm8, [c_mtl0]{1to16}
    vpmovdw [r11], zmm13
    vmulps zmm19, zmm11, zmm5
    vfmsub213ps zmm20, zmm7, zmm27
    vmulps zmm6, zmm14, [rsp + 3712]
    vpternlogd zmm14{k6}{z}, zmm12, zmm22, 216
    vmaxps zmm0, zmm17, zmm23
    vmovaps zmm3, zmm25
    vfmadd231ps zmm3, zmm16, zmm24
    vmulps zmm4, zmm15, zmm16
    kmovw k1, [rsp + 16]
    vfmadd231ps zmm18, zmm14, [c_mtl1]{1to16}
    vmovups zmm8, [r14 + 640]
    vpsrld zmm13, zmm0, 23
    vpsrld zmm11, zmm0, 19
    vfmadd231ps zmm9, zmm6, [c_mtl1]{1to16}
    vgetmantps zmm5, zmm0, 4
    vbroadcastss zmm7, [c_slkl]
    vmovups zmm12, [rsp + 4288]
    vpermi2ps zmm13, zmm31, zmm30
    vpermps zmm17, zmm11, zmm29
    vfmadd213ps zmm3, zmm16, zmm26
    vpermps zmm14, zmm11, zmm28
    vreduceps zmm6, zmm18, 8
    vcvtps2dq zmm0, zmm18, {rn-sae}
    vfmadd231ps zmm15, zmm4, zmm3
    vmaxps zmm16, zmm12, zmm23
    vpaddd zmm11, zmm0, [c_i64]{1to16}
    vmulps zmm18, zmm13, zmm17
    vmovaps zmm4, zmm25
    vfmadd231ps zmm4, zmm10, zmm24
    vfmsub213ps zmm5, zmm14, zmm27
    vmulps zmm3, zmm1, zmm10
    kmovw k2, [rsp + 12]
    vmovups zmm12, [r14 + 512]
    vandps zmm0, zmm6, [c_absm]{1to16}
    vpminsd zmm13, zmm11, [c_i1023]{1to16}
    vpsrld zmm17, zmm16, 23
    vpsrld zmm14, zmm16, 19
    vgetmantps zmm6, zmm16, 4
    vmovups zmm11, [rsp + 4416]
    vmulps zmm16, zmm15, [rsp + 4224]
    vpternlogd zmm15{k1}{z}, zmm8, zmm22, 216
    vaddps zmm8, zmm0, zmm9
    vpermi2ps zmm17, zmm31, zmm30
    vpermps zmm0, zmm14, zmm29
    vfmadd213ps zmm4, zmm10, zmm26
    vpermps zmm9, zmm14, zmm28
    vmovaps zmm10, zmm25
    vfmadd231ps zmm10, zmm20, zmm24
    vmulps zmm14, zmm15, [c_mtl2]{1to16}
    vmulps zmm15, zmm19, zmm20
    vcmpps k3, zmm8, zmm21, 17
    vfmadd231ps zmm7, zmm16, [c_mtl2]{1to16}
    vmaxps zmm8, zmm11, zmm23
    kmovw k4, [rsp + 14]
    vmovups zmm16, [r14 + 576]
    vfmadd231ps zmm1, zmm3, zmm4
    vmulps zmm11, zmm17, zmm0
    vfmadd213ps zmm10, zmm20, zmm26
    vfmsub213ps zmm6, zmm9, zmm27
    vpsrld zmm3, zmm8, 23
    vpsrld zmm4, zmm8, 19
    vgetmantps zmm17, zmm8, 4
    vpmaxsd zmm2{k3}, zmm13, [c_zero]{1to16}
    kmovw [rsp + r3 + FMR + W/2 + 2], k3
    vmulps zmm0, zmm1, [rsp + 3968]
    vpternlogd zmm1{k2}{z}, zmm12, zmm22, 216
    vpermi2ps zmm3, zmm31, zmm30
    vpermps zmm20, zmm4, zmm29
    vpermps zmm9, zmm4, zmm28
    vfmadd231ps zmm19, zmm15, zmm10
    vpbroadcastd zmm8, [c_m1]
    vmovups zmm13, [rsp + 4672]
    vpmovdw [r11 + W], zmm2
    vfmadd231ps zmm14, zmm1, [c_mtl0]{1to16}
    vfmadd231ps zmm7, zmm0, [c_mtl0]{1to16}
    vmulps zmm12, zmm19, [rsp + 4096]
    vpternlogd zmm19{k4}{z}, zmm16, zmm22, 216
    vfmsub213ps zmm17, zmm9, zmm27
    vmulps zmm4, zmm3, zmm20
    jmp .j896
.j896:
    vmaxps zmm15, zmm13, zmm23
    vmovaps zmm10, zmm25
    vfmadd231ps zmm10, zmm5, zmm24
    vmulps zmm2, zmm18, zmm5
    vfmadd231ps zmm14, zmm19, [c_mtl1]{1to16}
    kmovw k5, [rsp + 22]
    vmovups zmm1, [r14 + 896]
    vfmadd231ps zmm7, zmm12, [c_mtl1]{1to16}
    vpsrld zmm0, zmm15, 23
    vpsrld zmm16, zmm15, 19
    vgetmantps zmm9, zmm15, 4
    vbroadcastss zmm3, [c_slkl]
    vmovups zmm20, [rsp + 4800]
    vpermi2ps zmm0, zmm31, zmm30
    vpermps zmm13, zmm16, zmm29
    vfmadd213ps zmm10, zmm5, zmm26
    vreduceps zmm19, zmm14, 8
    vcvtps2dq zmm12, zmm14, {rn-sae}
    vpermps zmm15, zmm16, zmm28
    vmaxps zmm5, zmm20, zmm23
    vpaddd zmm14, zmm12, [c_i64]{1to16}
    vfmadd231ps zmm18, zmm2, zmm10
    vmovaps zmm16, zmm25
    vfmadd231ps zmm16, zmm6, zmm24
    vmulps zmm20, zmm0, zmm13
    vmulps zmm12, zmm11, zmm6
    vfmsub213ps zmm9, zmm15, zmm27
    kmovw k7, [rsp + 18]
    vandps zmm2, zmm19, [c_absm]{1to16}
    vpminsd zmm10, zmm14, [c_i1023]{1to16}
    vpsrld zmm0, zmm5, 23
    vpsrld zmm13, zmm5, 19
    vgetmantps zmm15, zmm5, 4
    vmovups zmm19, [r14 + 768]
    vmovups zmm14, [rsp + 4928]
    vaddps zmm5, zmm2, zmm7
    vmulps zmm2, zmm18, [rsp + 4608]
    vpternlogd zmm18{k5}{z}, zmm1, zmm22, 216
    vpermi2ps zmm0, zmm31, zmm30
    vpermps zmm7, zmm13, zmm29
    vpermps zmm1, zmm13, zmm28
    vfmadd213ps zmm16, zmm6, zmm26
    vmovaps zmm13, zmm25
    vfmadd231ps zmm13, zmm17, zmm24
    vmulps zmm6, zmm18, [c_mtl2]{1to16}
    vmulps zmm18, zmm4, zmm17
    vcmpps k6, zmm5, zmm21, 17
    vfmadd231ps zmm3, zmm2, [c_mtl2]{1to16}
    vmaxps zmm5, zmm14, zmm23
    kmovw k1, [rsp + 20]
    vmovups zmm2, [r14 + 832]
    vfmadd231ps zmm11, zmm12, zmm16
    vfmsub213ps zmm15, zmm1, zmm27
    vmulps zmm14, zmm0, zmm7
    vpsrld zmm12, zmm5, 23
    vpsrld zmm16, zmm5, 19
    vfmadd213ps zmm13, zmm17, zmm26
    vgetmantps zmm1, zmm5, 4
    vpmaxsd zmm8{k6}, zmm10, [c_zero]{1to16}
    kmovw [rsp + r3 + FMR + W/2 + 4], k6
    vpermi2ps zmm12, zmm31, zmm30
    vpermps zmm0, zmm16, zmm29
    vmulps zmm7, zmm11, [rsp + 4352]
    vpternlogd zmm11{k7}{z}, zmm19, zmm22, 216
    vpermps zmm17, zmm16, zmm28
    vpbroadcastd zmm5, [c_m1]
    vmovaps zmm10, zmm25
    vfmadd231ps zmm10, zmm9, zmm24
    vmulps zmm19, zmm20, zmm9
    vpmovdw [r11 + 32], zmm8
    vfmadd231ps zmm4, zmm18, zmm13
    kmovw k3, [rsp + 24]
    vfmadd231ps zmm6, zmm11, [c_mtl0]{1to16}
    vmovups zmm16, [r14 + 1024]
    vmovaps zmm8, zmm25
    vfmadd231ps zmm8, zmm15, zmm24
    vmulps zmm18, zmm14, zmm15
    vfmadd231ps zmm3, zmm7, [c_mtl0]{1to16}
    vmulps zmm13, zmm12, zmm0
    kmovw k2, [rsp + 26]
    vfmsub231ps zmm27, zmm1, zmm17
    vfmadd213ps zmm10, zmm9, zmm26
    vmovups zmm11, [r14 + 1088]
    vmulps zmm7, zmm4, [rsp + 4480]
    vpternlogd zmm4{k1}{z}, zmm2, zmm22, 216
    vfmadd213ps zmm8, zmm15, zmm26
    kmovw k4, [rsp + 28]
    vfmadd231ps zmm6, zmm4, [c_mtl1]{1to16}
    vmovups zmm12, [r14 + 1152]
    vfmadd231ps zmm3, zmm7, [c_mtl1]{1to16}
    vfmadd231ps zmm20, zmm19, zmm10
    vfmadd231ps zmm25, zmm27, zmm24
    vmulps zmm0, zmm13, zmm27
    vfmadd231ps zmm14, zmm18, zmm8
    vbroadcastss zmm1, [c_slkh0]
    vreduceps zmm17, zmm6, 8
    vcvtps2dq zmm9, zmm6, {rn-sae}
    vmulps zmm2, zmm20, [rsp + 4736]
    vpternlogd zmm20{k3}{z}, zmm16, zmm22, 216
    vfmadd231ps zmm26, zmm25, zmm27
    vbroadcastss zmm15, [c_slkh1]
    vmulps zmm4, zmm14, [rsp + 4864]
    vpternlogd zmm14{k2}{z}, zmm11, zmm22, 216
    vpaddd zmm7, zmm9, [c_i64]{1to16}
    vmulps zmm19, zmm20, [c_mth1]{1to16}
    vfmadd231ps zmm1, zmm2, [c_mth1]{1to16}
    vandps zmm10, zmm17, [c_absm]{1to16}
    vpminsd zmm18, zmm7, [c_i1023]{1to16}
    vfmadd231ps zmm13, zmm0, zmm26
    vfmadd231ps zmm19, zmm14, [c_mth2]{1to16}
    vaddps zmm8, zmm10, zmm3
    vfmadd231ps zmm1, zmm4, [c_mth2]{1to16}
    vcmpps k5, zmm8, zmm21, 17
    vmulps zmm6, zmm13, [rsp + 4992]
    vpternlogd zmm13{k4}{z}, zmm12, zmm22, 216
    vfmsub231ps zmm19, zmm13, [c_mth0]{1to16}
    vmulps zmm16, zmm13, [c_mth5]{1to16}
    vfmadd231ps zmm1, zmm6, [c_mth0]{1to16}
    vfmadd231ps zmm15, zmm6, [c_mth5]{1to16}
    vpbroadcastd zmm25, [c_m1]
    vpbroadcastd zmm27, [c_m1]
    vpmaxsd zmm5{k5}, zmm18, [c_zero]{1to16}
    kmovw [rsp + r3 + FMR + W/2 + 6], k5
    vfmadd231ps zmm16, zmm14, [c_mth4]{1to16}
    vreduceps zmm11, zmm19, 8
    vcvtps2dq zmm9, zmm19, {rn-sae}
    vmovups zmm17, [c_pkw]
    vpmovdw [r11 + 32 + W], zmm5
    jmp .j1024
.j1024:
    vfmadd231ps zmm15, zmm4, [c_mth4]{1to16}
    vfmsub231ps zmm16, zmm20, [c_mth0]{1to16}
    vpaddd zmm7, zmm9, [c_i512]{1to16}
    vfmadd231ps zmm15, zmm2, [c_mth0]{1to16}
    vandps zmm0, zmm11, [c_absm]{1to16}
    vpminsd zmm26, zmm7, [c_i1023]{1to16}
    vaddps zmm10, zmm0, zmm1
    vreduceps zmm3, zmm16, 8
    vcvtps2dq zmm8, zmm16, {rn-sae}
    vcmpps k6, zmm10, zmm21, 17
    vpaddd zmm12, zmm8, [c_i512]{1to16}
    vandps zmm13, zmm3, [c_absm]{1to16}
    vpminsd zmm6, zmm12, [c_i1023]{1to16}
    vaddps zmm18, zmm13, zmm15
    vcmpps k7, zmm18, zmm21, 17
    kandw k1, k6, k7
    vpmaxsd zmm27{k7}, zmm6, [c_zero]{1to16}
    vpmaxsd zmm25{k1}, zmm26, [c_zero]{1to16}
    vpermw zmm14, zmm17, zmm27
    kmovw [rsp + r3 + FMR + W/2 + 8], k1
    vpermw zmm19, zmm17, zmm25
    CRST r6, vmovdqu16 [CRS r6], ymm14
    vmovdqu16 [r6], ymm19
    prefetcht1 [r2 + .period]
    vmovups zmm31, [c_tx]
    vmovups zmm30, [c_tx + 64]
    vmovups zmm29, [c_wx]
    vmovups zmm28, [c_rx]
    vbroadcastss zmm27, [c_qx0]
    vbroadcastss zmm26, [c_qx1]
    vbroadcastss zmm25, [c_qx2]
    vmovups zmm0, [rsp + 64]
    vmovups zmm1, [rsp + 128]
    vrangeps zmm2, zmm0, [c_xflr]{1to16}, 7
    vrangeps zmm3, zmm1, [c_xflr]{1to16}, 7
    vpsrld zmm4, zmm2, 23
    vpsrld zmm5, zmm2, 19
    vgetmantps zmm6, zmm2, 4
    vpsrld zmm7, zmm3, 23
    vpsrld zmm8, zmm3, 19
    vgetmantps zmm9, zmm3, 4
    vpermi2ps zmm4, zmm31, zmm30
    vpermps zmm10, zmm5, zmm29
    vpermps zmm11, zmm5, zmm28
    vpermi2ps zmm7, zmm31, zmm30
    vmovups zmm12, [rsp + 192]
    vpermps zmm13, zmm8, zmm29
    vpermps zmm14, zmm8, zmm28
    vpternlogd zmm4, zmm2, [c_sign]{1to16}, 216
    vfmsub213ps zmm6, zmm11, [c_one]{1to16}
    vpternlogd zmm7, zmm3, [c_sign]{1to16}, 216
    vfmsub213ps zmm9, zmm14, [c_one]{1to16}
    vrangeps zmm15, zmm12, [c_xflr]{1to16}, 7
    vmulps zmm16, zmm4, zmm10
    vmovups zmm17, [rsp + 256]
    vmulps zmm18, zmm7, zmm13
    vpsrld zmm19, zmm15, 23
    vpsrld zmm20, zmm15, 19
    vgetmantps zmm21, zmm15, 4
    vpermi2ps zmm19, zmm31, zmm30
    vpermps zmm22, zmm20, zmm29
    vpermps zmm23, zmm20, zmm28
    vrangeps zmm24, zmm17, [c_xflr]{1to16}, 7
    vpsrld zmm0, zmm24, 23
    vpsrld zmm1, zmm24, 19
    vgetmantps zmm5, zmm24, 4
    vmovups zmm8, [rsp + 320]
    vpternlogd zmm19, zmm15, [c_sign]{1to16}, 216
    vfmsub213ps zmm21, zmm23, [c_one]{1to16}
    vpermi2ps zmm0, zmm31, zmm30
    vpermps zmm2, zmm1, zmm29
    vpermps zmm11, zmm1, zmm28
    vmulps zmm3, zmm19, zmm22
    vrangeps zmm14, zmm8, [c_xflr]{1to16}, 7
    vpternlogd zmm0, zmm24, [c_sign]{1to16}, 216
    vfmsub213ps zmm5, zmm11, [c_one]{1to16}
    vmovaps zmm12, zmm26
    vfmadd231ps zmm12, zmm6, zmm25
    vpsrld zmm4, zmm14, 23
    vpsrld zmm10, zmm14, 19
    vmulps zmm7, zmm16, zmm6
    vmulps zmm13, zmm0, zmm2
    vgetmantps zmm20, zmm14, 4
    vmovups zmm17, [rsp + 384]
    vpermi2ps zmm4, zmm31, zmm30
    vpermps zmm15, zmm10, zmm29
    vpermps zmm23, zmm10, zmm28
    vfmadd213ps zmm12, zmm6, zmm27
    vrangeps zmm1, zmm17, [c_xflr]{1to16}, 7
    vpternlogd zmm4, zmm14, [c_sign]{1to16}, 216
    vfmsub213ps zmm20, zmm23, [c_one]{1to16}
    vfmadd231ps zmm16, zmm7, zmm12
    vpsrld zmm19, zmm1, 23
    vpsrld zmm22, zmm1, 19
    vmovaps zmm8, zmm26
    vfmadd231ps zmm8, zmm9, zmm25
    vmulps zmm24, zmm4, zmm15
    vgetmantps zmm11, zmm1, 4
    vmulps zmm0, zmm18, zmm9
    vmovups zmm2, [rsp + 832]
    vpermi2ps zmm19, zmm31, zmm30
    vpermps zmm10, zmm22, zmm29
    vpermps zmm6, zmm22, zmm28
    vfmadd213ps zmm8, zmm9, zmm27
    vrangeps zmm17, zmm2, [c_xflr]{1to16}, 7
    vpternlogd zmm19, zmm1, [c_sign]{1to16}, 216
    vfmsub213ps zmm11, zmm6, [c_one]{1to16}
    vfmadd231ps zmm18, zmm0, zmm8
    vpsrld zmm14, zmm17, 23
    vpsrld zmm23, zmm17, 19
    vmovaps zmm7, zmm26
    vfmadd231ps zmm7, zmm21, zmm25
    vmulps zmm12, zmm19, zmm10
    vgetmantps zmm4, zmm17, 4
    vmulps zmm15, zmm3, zmm21
    vmovups zmm22, [rsp + 896]
    vpermi2ps zmm14, zmm31, zmm30
    vpermps zmm9, zmm23, zmm29
    vpermps zmm2, zmm23, zmm28
    vfmadd213ps zmm7, zmm21, zmm27
    vpmaxud zmm1, zmm16, zmm18
    vrangeps zmm6, zmm22, [c_xflr]{1to16}, 7
    vpternlogd zmm14, zmm17, [c_sign]{1to16}, 216
    vfmsub213ps zmm4, zmm2, [c_one]{1to16}
    vfmadd231ps zmm3, zmm15, zmm7
    vmulps zmm0, zmm14, zmm9
    vpsrld zmm8, zmm6, 23
    vpsrld zmm19, zmm6, 19
    vgetmantps zmm10, zmm6, 4
    jmp .j1152
.j1152:
    vmovaps zmm23, zmm26
    vfmadd231ps zmm23, zmm5, zmm25
    vmulps zmm21, zmm13, zmm5
    vmovups zmm22, [rsp + 960]
    vpermi2ps zmm8, zmm31, zmm30
    vpermps zmm17, zmm19, zmm29
    vpermps zmm2, zmm19, zmm28
    vpmaxud zmm15, zmm1, zmm3
    vfmadd213ps zmm23, zmm5, zmm27
    vpminsd zmm7, zmm15, [c_zero]{1to16}
    vrangeps zmm14, zmm22, [c_xflr]{1to16}, 7
    vpternlogd zmm8, zmm6, [c_sign]{1to16}, 216
    vfmsub213ps zmm10, zmm2, [c_one]{1to16}
    vmovaps zmm9, zmm26
    vfmadd231ps zmm9, zmm20, zmm25
    vmulps zmm19, zmm8, zmm17
    vfmadd231ps zmm13, zmm21, zmm23
    vpsrld zmm1, zmm14, 23
    vpsrld zmm5, zmm14, 19
    vgetmantps zmm15, zmm14, 4
    vmulps zmm22, zmm24, zmm20
    vmovups zmm6, [rsp + 1024]
    vpermi2ps zmm1, zmm31, zmm30
    vpermps zmm2, zmm5, zmm29
    vpermps zmm8, zmm5, zmm28
    vfmadd213ps zmm9, zmm20, zmm27
    vrangeps zmm17, zmm6, [c_xflr]{1to16}, 7
    vpternlogd zmm1, zmm14, [c_sign]{1to16}, 216
    vfmsub213ps zmm15, zmm8, [c_one]{1to16}
    vfmadd231ps zmm24, zmm22, zmm9
    vpsrld zmm21, zmm17, 23
    vpsrld zmm23, zmm17, 19
    vmovaps zmm5, zmm26
    vfmadd231ps zmm5, zmm11, zmm25
    vmulps zmm20, zmm1, zmm2
    vgetmantps zmm6, zmm17, 4
    vmulps zmm14, zmm12, zmm11
    vaddps zmm8, zmm16, zmm13
    vpermi2ps zmm21, zmm31, zmm30
    vpermps zmm22, zmm23, zmm29
    vpermps zmm9, zmm23, zmm28
    vpmaxud zmm1, zmm13, zmm24
    vaddps zmm2, zmm18, zmm24
    vfmadd213ps zmm5, zmm11, zmm27
    vmovaps [rsp + 5056], zmm8
    vmovups zmm16, [rsp + 1088]
    vmovaps [rsp + 5120], zmm2
    vpternlogd zmm21, zmm17, [c_sign]{1to16}, 216
    vfmsub213ps zmm6, zmm9, [c_one]{1to16}
    vfmadd231ps zmm12, zmm14, zmm5
    vmulps zmm23, zmm21, zmm22
    vrangeps zmm13, zmm16, [c_xflr]{1to16}, 7
    vpmaxud zmm18, zmm1, zmm12
    vaddps zmm24, zmm3, zmm12
    vpsrld zmm11, zmm13, 23
    vpsrld zmm17, zmm13, 19
    vgetmantps zmm9, zmm13, 4
    vmovaps zmm14, zmm26
    vfmadd231ps zmm14, zmm4, zmm25
    vpminsd zmm5, zmm18, [c_zero]{1to16}
    vpermi2ps zmm11, zmm31, zmm30
    vmulps zmm21, zmm0, zmm4
    vmovaps [rsp + 5184], zmm24
    vpermps zmm22, zmm17, zmm29
    vpermps zmm16, zmm17, zmm28
    vmovups zmm1, [rsp + 1152]
    vaddps zmm3, zmm7, zmm5
    vfmadd213ps zmm14, zmm4, zmm27
    vmovaps [rsp + 5248], zmm3
    vpternlogd zmm11, zmm13, [c_sign]{1to16}, 216
    vfmsub213ps zmm9, zmm16, [c_one]{1to16}
    vrangeps zmm12, zmm1, [c_xflr]{1to16}, 7
    vmovaps zmm18, zmm26
    vfmadd231ps zmm18, zmm10, zmm25
    vmulps zmm17, zmm11, zmm22
    vfmadd231ps zmm0, zmm21, zmm14
    vmulps zmm7, zmm19, zmm10
    vpsrld zmm5, zmm12, 23
    vpsrld zmm4, zmm12, 19
    vmovups zmm13, [rsp + 1600]
    vgetmantps zmm16, zmm12, 4
    vpermi2ps zmm5, zmm31, zmm30
    vpermps zmm1, zmm4, zmm29
    vfmadd213ps zmm18, zmm10, zmm27
    vpermps zmm11, zmm4, zmm28
    vrangeps zmm22, zmm13, [c_xflr]{1to16}, 7
    vfmadd231ps zmm19, zmm7, zmm18
    vpternlogd zmm5, zmm12, [c_sign]{1to16}, 216
    vfmsub213ps zmm16, zmm11, [c_one]{1to16}
    vpsrld zmm21, zmm22, 23
    vpsrld zmm14, zmm22, 19
    vmovaps zmm10, zmm26
    vfmadd231ps zmm10, zmm15, zmm25
    vgetmantps zmm4, zmm22, 4
    vmulps zmm13, zmm20, zmm15
    vmulps zmm7, zmm5, zmm1
    vpermi2ps zmm21, zmm31, zmm30
    vpermps zmm18, zmm14, zmm29
    vmovups zmm12, [rsp + 1664]
    vpermps zmm11, zmm14, zmm28
    vpmaxud zmm5, zmm0, zmm19
    vfmadd213ps zmm10, zmm15, zmm27
    vpternlogd zmm21, zmm22, [c_sign]{1to16}, 216
    vrangeps zmm1, zmm12, [c_xflr]{1to16}, 7
    vfmsub213ps zmm4, zmm11, [c_one]{1to16}
    vfmadd231ps zmm20, zmm13, zmm10
    vmulps zmm14, zmm21, zmm18
    vpsrld zmm15, zmm1, 23
    vpsrld zmm22, zmm1, 19
    vmovaps zmm12, zmm26
    vfmadd231ps zmm12, zmm6, zmm25
    vgetmantps zmm11, zmm1, 4
    vmulps zmm13, zmm23, zmm6
    vmovups zmm10, [rsp + 1728]
    vpermi2ps zmm15, zmm31, zmm30
    vpermps zmm21, zmm22, zmm29
    vpmaxud zmm18, zmm5, zmm20
    vpermps zmm5, zmm22, zmm28
    vfmadd213ps zmm12, zmm6, zmm27
    vpminsd zmm22, zmm18, [c_zero]{1to16}
    vrangeps zmm6, zmm10, [c_xflr]{1to16}, 7
    vpternlogd zmm15, zmm1, [c_sign]{1to16}, 216
    vfmsub213ps zmm11, zmm5, [c_one]{1to16}
    vfmadd231ps zmm23, zmm13, zmm12
    vmovaps zmm18, zmm26
    vfmadd231ps zmm18, zmm9, zmm25
    vmulps zmm10, zmm15, zmm21
    vpsrld zmm1, zmm6, 23
    jmp .j1280
.j1280:
    vpsrld zmm5, zmm6, 19
    vmulps zmm13, zmm17, zmm9
    vgetmantps zmm12, zmm6, 4
    vmovups zmm15, [rsp + 1792]
    vpermi2ps zmm1, zmm31, zmm30
    vpermps zmm21, zmm5, zmm29
    vpermps zmm5, zmm5, zmm28
    vfmadd213ps zmm18, zmm9, zmm27
    vrangeps zmm9, zmm15, [c_xflr]{1to16}, 7
    vpternlogd zmm1, zmm6, [c_sign]{1to16}, 216
    vfmsub213ps zmm12, zmm5, [c_one]{1to16}
    vfmadd231ps zmm17, zmm13, zmm18
    vpsrld zmm15, zmm9, 23
    vpsrld zmm6, zmm9, 19
    vmovaps zmm5, zmm26
    vfmadd231ps zmm5, zmm16, zmm25
    vmulps zmm13, zmm1, zmm21
    vgetmantps zmm18, zmm9, 4
    vmulps zmm1, zmm7, zmm16
    vaddps zmm21, zmm0, zmm23
    vpermi2ps zmm15, zmm31, zmm30
    vpermps zmm0, zmm6, zmm29
    vpermps zmm6, zmm6, zmm28
    vpmaxud zmm23, zmm23, zmm17
    vaddps zmm19, zmm19, zmm17
    vfmadd213ps zmm5, zmm16, zmm27
    vmovaps [rsp + 5312], zmm21
    vaddps zmm17, zmm21, zmm8
    vmovaps [rsp + 5376], zmm19
    vpternlogd zmm15, zmm9, [c_sign]{1to16}, 216
    vaddps zmm16, zmm19, zmm2
    vfmsub213ps zmm18, zmm6, [c_one]{1to16}
    vmovaps [r13], zmm17
    vfmadd231ps zmm7, zmm1, zmm5
    vmulps zmm21, zmm15, zmm0
    vmovaps [r13 + 64], zmm16
    vmovups zmm8, [rsp + 1856]
    vpmaxud zmm9, zmm23, zmm7
    vaddps zmm19, zmm20, zmm7
    vpminsd zmm2, zmm9, [c_zero]{1to16}
    vrangeps zmm6, zmm8, [c_xflr]{1to16}, 7
    vmovaps [rsp + 5440], zmm19
    vaddps zmm17, zmm19, zmm24
    vaddps zmm1, zmm22, zmm2
    vpsrld zmm5, zmm6, 23
    vpsrld zmm15, zmm6, 19
    vmovaps [r13 + 128], zmm17
    vgetmantps zmm0, zmm6, 4
    vmovaps zmm16, zmm26
    vfmadd231ps zmm16, zmm4, zmm25
    vmulps zmm23, zmm14, zmm4
    vmovaps [rsp + 5504], zmm1
    vaddps zmm20, zmm1, zmm3
    vpermi2ps zmm5, zmm31, zmm30
    vpermps zmm7, zmm15, zmm29
    vmovups zmm9, [rsp + 1920]
    vpermps zmm8, zmm15, zmm28
    vmovaps [r13 + 192], zmm20
    vfmadd213ps zmm16, zmm4, zmm27
    vpternlogd zmm5, zmm6, [c_sign]{1to16}, 216
    vrangeps zmm19, zmm9, [c_xflr]{1to16}, 7
    vfmsub213ps zmm0, zmm8, [c_one]{1to16}
    vmovaps zmm24, zmm26
    vfmadd231ps zmm24, zmm11, zmm25
    vmulps zmm22, zmm5, zmm7
    vfmadd231ps zmm14, zmm23, zmm16
    vpsrld zmm2, zmm19, 23
    vpsrld zmm17, zmm19, 19
    vmulps zmm1, zmm10, zmm11
    vgetmantps zmm3, zmm19, 4
    vmovups zmm15, [rsp + 2368]
    vpermi2ps zmm2, zmm31, zmm30
    vpermps zmm20, zmm17, zmm29
    vpermps zmm4, zmm17, zmm28
    vfmadd213ps zmm24, zmm11, zmm27
    vrangeps zmm6, zmm15, [c_xflr]{1to16}, 7
    vpternlogd zmm2, zmm19, [c_sign]{1to16}, 216
    vfmadd231ps zmm10, zmm1, zmm24
    vfmsub213ps zmm3, zmm4, [c_one]{1to16}
    vmovaps zmm9, zmm26
    vfmadd231ps zmm9, zmm12, zmm25
    vpsrld zmm8, zmm6, 23
    vpsrld zmm5, zmm6, 19
    vmulps zmm7, zmm13, zmm12
    vmulps zmm23, zmm2, zmm20
    vgetmantps zmm16, zmm6, 4
    vmovups zmm17, [rsp + 2432]
    vpermi2ps zmm8, zmm31, zmm30
    vpermps zmm11, zmm5, zmm29
    vpermps zmm15, zmm5, zmm28
    vpmaxud zmm19, zmm14, zmm10
    vfmadd213ps zmm9, zmm12, zmm27
    vrangeps zmm1, zmm17, [c_xflr]{1to16}, 7
    vpternlogd zmm8, zmm6, [c_sign]{1to16}, 216
    vfmsub213ps zmm16, zmm15, [c_one]{1to16}
    vfmadd231ps zmm13, zmm7, zmm9
    vmulps zmm24, zmm8, zmm11
    vpsrld zmm4, zmm1, 23
    vpsrld zmm2, zmm1, 19
    vgetmantps zmm20, zmm1, 4
    vmovaps zmm5, zmm26
    vfmadd231ps zmm5, zmm18, zmm25
    vmulps zmm12, zmm21, zmm18
    vmovups zmm17, [rsp + 2496]
    vpermi2ps zmm4, zmm31, zmm30
    vpermps zmm6, zmm2, zmm29
    vpmaxud zmm15, zmm19, zmm13
    vpermps zmm7, zmm2, zmm28
    vpminsd zmm9, zmm15, [c_zero]{1to16}
    vfmadd213ps zmm5, zmm18, zmm27
    vrangeps zmm8, zmm17, [c_xflr]{1to16}, 7
    vpternlogd zmm4, zmm1, [c_sign]{1to16}, 216
    vfmsub213ps zmm20, zmm7, [c_one]{1to16}
    vmovaps zmm11, zmm26
    vfmadd231ps zmm11, zmm0, zmm25
    vmulps zmm19, zmm4, zmm6
    vfmadd231ps zmm21, zmm12, zmm5
    vpsrld zmm2, zmm8, 23
    vpsrld zmm15, zmm8, 19
    vgetmantps zmm18, zmm8, 4
    vmulps zmm17, zmm22, zmm0
    vmovups zmm1, [rsp + 2560]
    vpermi2ps zmm2, zmm31, zmm30
    vpermps zmm7, zmm15, zmm29
    vpermps zmm4, zmm15, zmm28
    vfmadd213ps zmm11, zmm0, zmm27
    vrangeps zmm6, zmm1, [c_xflr]{1to16}, 7
    vpternlogd zmm2, zmm8, [c_sign]{1to16}, 216
    jmp .j1408
.j1408:
    vfmsub213ps zmm18, zmm4, [c_one]{1to16}
    vfmadd231ps zmm22, zmm17, zmm11
    vpsrld zmm12, zmm6, 23
    vpsrld zmm5, zmm6, 19
    vmovaps zmm15, zmm26
    vfmadd231ps zmm15, zmm3, zmm25
    vmulps zmm0, zmm2, zmm7
    vgetmantps zmm1, zmm6, 4
    vmulps zmm8, zmm23, zmm3
    vaddps zmm4, zmm14, zmm21
    vpermi2ps zmm12, zmm31, zmm30
    vpermps zmm17, zmm5, zmm29
    vpermps zmm11, zmm5, zmm28
    vpmaxud zmm2, zmm21, zmm22
    vaddps zmm7, zmm10, zmm22
    vfmadd213ps zmm15, zmm3, zmm27
    vmovaps [rsp + 5568], zmm4
    vmovups zmm14, [rsp + 2624]
    vmovaps [rsp + 5632], zmm7
    vpternlogd zmm12, zmm6, [c_sign]{1to16}, 216
    vfmsub213ps zmm1, zmm11, [c_one]{1to16}
    vfmadd231ps zmm23, zmm8, zmm15
    vmulps zmm5, zmm12, zmm17
    vrangeps zmm21, zmm14, [c_xflr]{1to16}, 7
    vpmaxud zmm10, zmm2, zmm23
    vaddps zmm22, zmm13, zmm23
    vpsrld zmm3, zmm21, 23
    vpsrld zmm6, zmm21, 19
    vgetmantps zmm11, zmm21, 4
    vmovaps zmm8, zmm26
    vfmadd231ps zmm8, zmm16, zmm25
    vpminsd zmm15, zmm10, [c_zero]{1to16}
    vpermi2ps zmm3, zmm31, zmm30
    vmulps zmm12, zmm24, zmm16
    vmovaps [rsp + 5696], zmm22
    vpermps zmm17, zmm6, zmm29
    vpermps zmm14, zmm6, zmm28
    vmovups zmm2, [rsp + 2688]
    vaddps zmm13, zmm9, zmm15
    vfmadd213ps zmm8, zmm16, zmm27
    vmovaps [rsp + 5760], zmm13
    vpternlogd zmm3, zmm21, [c_sign]{1to16}, 216
    vfmsub213ps zmm11, zmm14, [c_one]{1to16}
    vrangeps zmm23, zmm2, [c_xflr]{1to16}, 7
    vmovaps zmm10, zmm26
    vfmadd231ps zmm10, zmm20, zmm25
    vmulps zmm6, zmm3, zmm17
    vfmadd231ps zmm24, zmm12, zmm8
    vmulps zmm9, zmm19, zmm20
    vpsrld zmm15, zmm23, 23
    vpsrld zmm16, zmm23, 19
    vmovups zmm21, [rsp + 448]
    vgetmantps zmm14, zmm23, 4
    vpermi2ps zmm15, zmm31, zmm30
    vpermps zmm2, zmm16, zmm29
    vfmadd213ps zmm10, zmm20, zmm27
    vpermps zmm3, zmm16, zmm28
    vrangeps zmm17, zmm21, [c_xflr]{1to16}, 7
    vfmadd231ps zmm19, zmm9, zmm10
    vpternlogd zmm15, zmm23, [c_sign]{1to16}, 216
    vfmsub213ps zmm14, zmm3, [c_one]{1to16}
    vpsrld zmm12, zmm17, 23
    vpsrld zmm8, zmm17, 19
    vmovaps zmm20, zmm26
    vfmadd231ps zmm20, zmm18, zmm25
    vgetmantps zmm16, zmm17, 4
    vmulps zmm21, zmm0, zmm18
    vmulps zmm9, zmm15, zmm2
    vpermi2ps zmm12, zmm31, zmm30
    vpermps zmm10, zmm8, zmm29
    vmovups zmm23, [rsp + 512]
    vpermps zmm3, zmm8, zmm28
    vpmaxud zmm15, zmm24, zmm19
    vfmadd213ps zmm20, zmm18, zmm27
    vpternlogd zmm12, zmm17, [c_sign]{1to16}, 216
    vrangeps zmm2, zmm23, [c_xflr]{1to16}, 7
    vfmsub213ps zmm16, zmm3, [c_one]{1to16}
    vfmadd231ps zmm0, zmm21, zmm20
    vmulps zmm8, zmm12, zmm10
    vpsrld zmm18, zmm2, 23
    vpsrld zmm17, zmm2, 19
    vmovaps zmm23, zmm26
    vfmadd231ps zmm23, zmm1, zmm25
    vgetmantps zmm3, zmm2, 4
    vmulps zmm21, zmm5, zmm1
    vmovups zmm20, [rsp + 576]
    vpermi2ps zmm18, zmm31, zmm30
    vpermps zmm12, zmm17, zmm29
    vpmaxud zmm10, zmm15, zmm0
    vpermps zmm15, zmm17, zmm28
    vfmadd213ps zmm23, zmm1, zmm27
    vpminsd zmm17, zmm10, [c_zero]{1to16}
    vrangeps zmm1, zmm20, [c_xflr]{1to16}, 7
    vpternlogd zmm18, zmm2, [c_sign]{1to16}, 216
    vfmsub213ps zmm3, zmm15, [c_one]{1to16}
    vfmadd231ps zmm5, zmm21, zmm23
    vmovaps zmm10, zmm26
    vfmadd231ps zmm10, zmm11, zmm25
    vmulps zmm20, zmm18, zmm12
    vpsrld zmm2, zmm1, 23
    vpsrld zmm15, zmm1, 19
    vmulps zmm21, zmm6, zmm11
    vgetmantps zmm23, zmm1, 4
    vmovups zmm18, [rsp + 640]
    vpermi2ps zmm2, zmm31, zmm30
    vpermps zmm12, zmm15, zmm29
    vpermps zmm15, zmm15, zmm28
    vfmadd213ps zmm10, zmm11, zmm27
    vrangeps zmm11, zmm18, [c_xflr]{1to16}, 7
    vpternlogd zmm2, zmm1, [c_sign]{1to16}, 216
    vfmsub213ps zmm23, zmm15, [c_one]{1to16}
    vfmadd231ps zmm6, zmm21, zmm10
    vpsrld zmm18, zmm11, 23
    vpsrld zmm1, zmm11, 19
    vmovaps zmm15, zmm26
    vfmadd231ps zmm15, zmm14, zmm25
    vmulps zmm21, zmm2, zmm12
    vgetmantps zmm10, zmm11, 4
    vmulps zmm2, zmm9, zmm14
    vaddps zmm12, zmm24, zmm5
    vpermi2ps zmm18, zmm31, zmm30
    vpermps zmm24, zmm1, zmm29
    vpermps zmm1, zmm1, zmm28
    vpmaxud zmm5, zmm5, zmm6
    vaddps zmm19, zmm19, zmm6
    vfmadd213ps zmm15, zmm14, zmm27
    vmovaps [rsp + 5824], zmm12
    vaddps zmm6, zmm12, zmm4
    jmp .j1536
.j1536:
    vmovaps [rsp + 5888], zmm19
    vpternlogd zmm18, zmm11, [c_sign]{1to16}, 216
    vaddps zmm14, zmm19, zmm7
    vfmsub213ps zmm10, zmm1, [c_one]{1to16}
    vmovaps [r13 + 512], zmm6
    vfmadd231ps zmm9, zmm2, zmm15
    vmulps zmm12, zmm18, zmm24
    vmovaps [r13 + 576], zmm14
    vmovups zmm4, [rsp + 704]
    vpmaxud zmm11, zmm5, zmm9
    vaddps zmm19, zmm0, zmm9
    vpminsd zmm7, zmm11, [c_zero]{1to16}
    vrangeps zmm1, zmm4, [c_xflr]{1to16}, 7
    vmovaps [rsp + 5952], zmm19
    vaddps zmm6, zmm19, zmm22
    vaddps zmm2, zmm17, zmm7
    vpsrld zmm15, zmm1, 23
    vpsrld zmm18, zmm1, 19
    vmovaps [r13 + 640], zmm6
    vgetmantps zmm24, zmm1, 4
    vmovaps zmm14, zmm26
    vfmadd231ps zmm14, zmm16, zmm25
    vmulps zmm5, zmm8, zmm16
    vmovaps [rsp + 6016], zmm2
    vaddps zmm0, zmm2, zmm13
    vpermi2ps zmm15, zmm31, zmm30
    vpermps zmm9, zmm18, zmm29
    vmovups zmm11, [rsp + 768]
    vpermps zmm4, zmm18, zmm28
    vmovaps [r13 + 704], zmm0
    vfmadd213ps zmm14, zmm16, zmm27
    vpternlogd zmm15, zmm1, [c_sign]{1to16}, 216
    vrangeps zmm19, zmm11, [c_xflr]{1to16}, 7
    vfmsub213ps zmm24, zmm4, [c_one]{1to16}
    vmovaps zmm22, zmm26
    vfmadd231ps zmm22, zmm3, zmm25
    vmulps zmm17, zmm15, zmm9
    vfmadd231ps zmm8, zmm5, zmm14
    vpsrld zmm7, zmm19, 23
    vpsrld zmm6, zmm19, 19
    vmulps zmm2, zmm20, zmm3
    vgetmantps zmm13, zmm19, 4
    vmovups zmm18, [rsp + 1216]
    vpermi2ps zmm7, zmm31, zmm30
    vpermps zmm0, zmm6, zmm29
    vpermps zmm16, zmm6, zmm28
    vfmadd213ps zmm22, zmm3, zmm27
    vrangeps zmm1, zmm18, [c_xflr]{1to16}, 7
    vpternlogd zmm7, zmm19, [c_sign]{1to16}, 216
    vfmadd231ps zmm20, zmm2, zmm22
    vfmsub213ps zmm13, zmm16, [c_one]{1to16}
    vmovaps zmm11, zmm26
    vfmadd231ps zmm11, zmm23, zmm25
    vpsrld zmm4, zmm1, 23
    vpsrld zmm15, zmm1, 19
    vmulps zmm9, zmm21, zmm23
    vmulps zmm5, zmm7, zmm0
    vgetmantps zmm14, zmm1, 4
    vmovups zmm6, [rsp + 1280]
    vpermi2ps zmm4, zmm31, zmm30
    vpermps zmm3, zmm15, zmm29
    vpermps zmm18, zmm15, zmm28
    vpmaxud zmm19, zmm8, zmm20
    vfmadd213ps zmm11, zmm23, zmm27
    vrangeps zmm2, zmm6, [c_xflr]{1to16}, 7
    vpternlogd zmm4, zmm1, [c_sign]{1to16}, 216
    vfmsub213ps zmm14, zmm18, [c_one]{1to16}
    vfmadd231ps zmm21, zmm9, zmm11
    vmulps zmm22, zmm4, zmm3
    vpsrld zmm16, zmm2, 23
    vpsrld zmm7, zmm2, 19
    vgetmantps zmm0, zmm2, 4
    vmovaps zmm15, zmm26
    vfmadd231ps zmm15, zmm10, zmm25
    vmulps zmm23, zmm12, zmm10
    vmovups zmm6, [rsp + 1344]
    vpermi2ps zmm16, zmm31, zmm30
    vpermps zmm1, zmm7, zmm29
    vpmaxud zmm18, zmm19, zmm21
    vpermps zmm9, zmm7, zmm28
    vpminsd zmm11, zmm18, [c_zero]{1to16}
    vfmadd213ps zmm15, zmm10, zmm27
    vrangeps zmm4, zmm6, [c_xflr]{1to16}, 7
    vpternlogd zmm16, zmm2, [c_sign]{1to16}, 216
    vfmsub213ps zmm0, zmm9, [c_one]{1to16}
    vmovaps zmm3, zmm26
    vfmadd231ps zmm3, zmm24, zmm25
    vmulps zmm19, zmm16, zmm1
    vfmadd231ps zmm12, zmm23, zmm15
    vpsrld zmm7, zmm4, 23
    vpsrld zmm18, zmm4, 19
    vgetmantps zmm10, zmm4, 4
    vmulps zmm6, zmm17, zmm24
    vmovups zmm2, [rsp + 1408]
    vpermi2ps zmm7, zmm31, zmm30
    vpermps zmm9, zmm18, zmm29
    vpermps zmm16, zmm18, zmm28
    vfmadd213ps zmm3, zmm24, zmm27
    vrangeps zmm1, zmm2, [c_xflr]{1to16}, 7
    vpternlogd zmm7, zmm4, [c_sign]{1to16}, 216
    vfmsub213ps zmm10, zmm16, [c_one]{1to16}
    vfmadd231ps zmm17, zmm6, zmm3
    vpsrld zmm23, zmm1, 23
    vpsrld zmm15, zmm1, 19
    vmovaps zmm18, zmm26
    vfmadd231ps zmm18, zmm13, zmm25
    vmulps zmm24, zmm7, zmm9
    vgetmantps zmm2, zmm1, 4
    vmulps zmm4, zmm5, zmm13
    vaddps zmm16, zmm8, zmm12
    vpermi2ps zmm23, zmm31, zmm30
    vpermps zmm6, zmm15, zmm29
    vpermps zmm3, zmm15, zmm28
    vpmaxud zmm7, zmm12, zmm17
    vaddps zmm9, zmm20, zmm17
    vfmadd213ps zmm18, zmm13, zmm27
    vaddps zmm8, zmm16, [rsp + 5056]
    vaddps zmm15, zmm9, [rsp + 5120]
    vpternlogd zmm23, zmm1, [c_sign]{1to16}, 216
    vmovaps [rsp + 6080], zmm8
    vfmsub213ps zmm2, zmm3, [c_one]{1to16}
    vfmadd231ps zmm5, zmm4, zmm18
    vmovups zmm12, [rsp + 1472]
    vmulps zmm20, zmm23, zmm6
    vmovaps [rsp + 6144], zmm15
    vpmaxud zmm17, zmm7, zmm5
    vaddps zmm13, zmm21, zmm5
    vrangeps zmm1, zmm12, [c_xflr]{1to16}, 7
    jmp .j1664
.j1664:
    vpminsd zmm8, zmm17, [c_zero]{1to16}
    vaddps zmm3, zmm13, [rsp + 5184]
    vpsrld zmm4, zmm1, 23
    vpsrld zmm18, zmm1, 19
    vaddps zmm23, zmm11, zmm8
    vgetmantps zmm6, zmm1, 4
    vmovaps zmm15, zmm26
    vfmadd231ps zmm15, zmm14, zmm25
    vmulps zmm7, zmm22, zmm14
    vmovaps [rsp + 6208], zmm3
    vpermi2ps zmm4, zmm31, zmm30
    vpermps zmm21, zmm18, zmm29
    vmovups zmm5, [rsp + 1536]
    vpermps zmm12, zmm18, zmm28
    vaddps zmm17, zmm23, [rsp + 5248]
    vfmadd213ps zmm15, zmm14, zmm27
    vmovaps [rsp + 6272], zmm17
    vpternlogd zmm4, zmm1, [c_sign]{1to16}, 216
    vrangeps zmm11, zmm5, [c_xflr]{1to16}, 7
    vfmsub213ps zmm6, zmm12, [c_one]{1to16}
    vmovaps zmm8, zmm26
    vfmadd231ps zmm8, zmm0, zmm25
    vmulps zmm3, zmm4, zmm21
    vfmadd231ps zmm22, zmm7, zmm15
    vpsrld zmm18, zmm11, 23
    vpsrld zmm14, zmm11, 19
    vmulps zmm17, zmm19, zmm0
    vgetmantps zmm1, zmm11, 4
    vmovups zmm5, [rsp + 1984]
    vpermi2ps zmm18, zmm31, zmm30
    vpermps zmm12, zmm14, zmm29
    vpermps zmm4, zmm14, zmm28
    vfmadd213ps zmm8, zmm0, zmm27
    vrangeps zmm21, zmm5, [c_xflr]{1to16}, 7
    vpternlogd zmm18, zmm11, [c_sign]{1to16}, 216
    vfmadd231ps zmm19, zmm17, zmm8
    vfmsub213ps zmm1, zmm4, [c_one]{1to16}
    vmovaps zmm7, zmm26
    vfmadd231ps zmm7, zmm10, zmm25
    vpsrld zmm15, zmm21, 23
    vpsrld zmm14, zmm21, 19
    vmulps zmm0, zmm24, zmm10
    vmulps zmm5, zmm18, zmm12
    vgetmantps zmm11, zmm21, 4
    vmovups zmm17, [rsp + 2048]
    vpermi2ps zmm15, zmm31, zmm30
    vpermps zmm8, zmm14, zmm29
    vpermps zmm4, zmm14, zmm28
    vpmaxud zmm18, zmm22, zmm19
    vfmadd213ps zmm7, zmm10, zmm27
    vrangeps zmm12, zmm17, [c_xflr]{1to16}, 7
    vpternlogd zmm15, zmm21, [c_sign]{1to16}, 216
    vfmsub213ps zmm11, zmm4, [c_one]{1to16}
    vfmadd231ps zmm24, zmm0, zmm7
    vmulps zmm14, zmm15, zmm8
    vpsrld zmm10, zmm12, 23
    vpsrld zmm17, zmm12, 19
    vgetmantps zmm21, zmm12, 4
    vmovaps zmm4, zmm26
    vfmadd231ps zmm4, zmm2, zmm25
    vmulps zmm0, zmm20, zmm2
    vmovups zmm7, [rsp + 2112]
    vpermi2ps zmm10, zmm31, zmm30
    vpermps zmm15, zmm17, zmm29
    vpmaxud zmm8, zmm18, zmm24
    vpermps zmm18, zmm17, zmm28
    vpminsd zmm17, zmm8, [c_zero]{1to16}
    vfmadd213ps zmm4, zmm2, zmm27
    vrangeps zmm8, zmm7, [c_xflr]{1to16}, 7
    vpternlogd zmm10, zmm12, [c_sign]{1to16}, 216
    vfmsub213ps zmm21, zmm18, [c_one]{1to16}
    vmovaps zmm2, zmm26
    vfmadd231ps zmm2, zmm6, zmm25
    vmulps zmm7, zmm10, zmm15
    vfmadd231ps zmm20, zmm0, zmm4
    vpsrld zmm12, zmm8, 23
    vpsrld zmm18, zmm8, 19
    vgetmantps zmm10, zmm8, 4
    vmulps zmm15, zmm3, zmm6
    vmovups zmm0, [rsp + 2176]
    vpermi2ps zmm12, zmm31, zmm30
    vpermps zmm4, zmm18, zmm29
    vpermps zmm18, zmm18, zmm28
    vfmadd213ps zmm2, zmm6, zmm27
    vrangeps zmm6, zmm0, [c_xflr]{1to16}, 7
    vpternlogd zmm12, zmm8, [c_sign]{1to16}, 216
    vfmsub213ps zmm10, zmm18, [c_one]{1to16}
    vfmadd231ps zmm3, zmm15, zmm2
    vpsrld zmm0, zmm6, 23
    vpsrld zmm8, zmm6, 19
    vmovaps zmm18, zmm26
    vfmadd231ps zmm18, zmm1, zmm25
    vmulps zmm15, zmm12, zmm4
    vgetmantps zmm2, zmm6, 4
    vmulps zmm12, zmm5, zmm1
    vaddps zmm4, zmm22, zmm20
    vpermi2ps zmm0, zmm31, zmm30
    vpermps zmm22, zmm8, zmm29
    vpermps zmm8, zmm8, zmm28
    vpmaxud zmm20, zmm20, zmm3
    vaddps zmm19, zmm19, zmm3
    vfmadd213ps zmm18, zmm1, zmm27
    vaddps zmm3, zmm4, [rsp + 5312]
    vaddps zmm1, zmm19, [rsp + 5376]
    vpternlogd zmm0, zmm6, [c_sign]{1to16}, 216
    vmovaps [rsp + 6336], zmm3
    vfmsub213ps zmm2, zmm8, [c_one]{1to16}
    vfmadd231ps zmm5, zmm12, zmm18
    vaddps zmm6, zmm4, zmm16
    vmulps zmm3, zmm0, zmm22
    vmovaps [rsp + 6400], zmm1
    vaddps zmm8, zmm19, zmm9
    vmovaps [r13 + 256], zmm6
    vmovaps [r13 + 320], zmm8
    vpmaxud zmm12, zmm20, zmm5
    vaddps zmm18, zmm24, zmm5
    vmovups zmm4, [rsp + 2240]
    vpminsd zmm16, zmm12, [c_zero]{1to16}
    vaddps zmm0, zmm18, [rsp + 5440]
    vaddps zmm22, zmm18, zmm13
    vaddps zmm1, zmm17, zmm16
    vmovaps [rsp + 6464], zmm0
    vrangeps zmm19, zmm4, [c_xflr]{1to16}, 7
    vmovaps [r13 + 384], zmm22
    vaddps zmm9, zmm1, [rsp + 5504]
    vaddps zmm6, zmm1, zmm23
    vmovaps zmm8, zmm26
    vfmadd231ps zmm8, zmm11, zmm25
    jmp .j1792
.j1792:
    vpsrld zmm20, zmm19, 23
    vpsrld zmm24, zmm19, 19
    vgetmantps zmm5, zmm19, 4
    vmulps zmm12, zmm14, zmm11
    vmovaps [rsp + 6528], zmm9
    vmovups zmm18, [rsp + 2304]
    vmovaps [r13 + 448], zmm6
    vpermi2ps zmm20, zmm31, zmm30
    vpermps zmm13, zmm24, zmm29
    vpermps zmm17, zmm24, zmm28
    vfmadd213ps zmm8, zmm11, zmm27
    vrangeps zmm16, zmm18, [c_xflr]{1to16}, 7
    vpternlogd zmm20, zmm19, [c_sign]{1to16}, 216
    vfmsub213ps zmm5, zmm17, [c_one]{1to16}
    vfmadd231ps zmm14, zmm12, zmm8
    vmovaps zmm0, zmm26
    vfmadd231ps zmm0, zmm21, zmm25
    vmulps zmm4, zmm20, zmm13
    vpsrld zmm22, zmm16, 23
    vpsrld zmm1, zmm16, 19
    vmulps zmm23, zmm7, zmm21
    vgetmantps zmm9, zmm16, 4
    vmovups zmm6, [rsp + 2752]
    vpermi2ps zmm22, zmm31, zmm30
    vpermps zmm24, zmm1, zmm29
    vpermps zmm11, zmm1, zmm28
    vfmadd213ps zmm0, zmm21, zmm27
    vrangeps zmm18, zmm6, [c_xflr]{1to16}, 7
    vpternlogd zmm22, zmm16, [c_sign]{1to16}, 216
    vfmsub213ps zmm9, zmm11, [c_one]{1to16}
    vfmadd231ps zmm7, zmm23, zmm0
    vpsrld zmm19, zmm18, 23
    vpsrld zmm17, zmm18, 19
    vmovaps zmm12, zmm26
    vfmadd231ps zmm12, zmm10, zmm25
    vmulps zmm8, zmm22, zmm24
    vgetmantps zmm20, zmm18, 4
    vmulps zmm13, zmm15, zmm10
    vmovups zmm1, [rsp + 2816]
    vpermi2ps zmm19, zmm31, zmm30
    vpermps zmm21, zmm17, zmm29
    vpermps zmm6, zmm17, zmm28
    vpmaxud zmm16, zmm14, zmm7
    vfmadd213ps zmm12, zmm10, zmm27
    vrangeps zmm11, zmm1, [c_xflr]{1to16}, 7
    vpternlogd zmm19, zmm18, [c_sign]{1to16}, 216
    vfmsub213ps zmm20, zmm6, [c_one]{1to16}
    vfmadd231ps zmm15, zmm13, zmm12
    vmulps zmm23, zmm19, zmm21
    vpsrld zmm0, zmm11, 23
    vpsrld zmm22, zmm11, 19
    vgetmantps zmm24, zmm11, 4
    vmovaps zmm17, zmm26
    vfmadd231ps zmm17, zmm2, zmm25
    vmulps zmm10, zmm3, zmm2
    vmovups zmm1, [rsp + 2880]
    vpermi2ps zmm0, zmm31, zmm30
    vpermps zmm18, zmm22, zmm29
    vpermps zmm6, zmm22, zmm28
    vpmaxud zmm13, zmm16, zmm15
    vfmadd213ps zmm17, zmm2, zmm27
    vpminsd zmm12, zmm13, [c_zero]{1to16}
    vrangeps zmm19, zmm1, [c_xflr]{1to16}, 7
    vpternlogd zmm0, zmm11, [c_sign]{1to16}, 216
    vfmsub213ps zmm24, zmm6, [c_one]{1to16}
    vmovaps zmm21, zmm26
    vfmadd231ps zmm21, zmm5, zmm25
    vmulps zmm22, zmm0, zmm18
    vfmadd231ps zmm3, zmm10, zmm17
    vpsrld zmm16, zmm19, 23
    vpsrld zmm2, zmm19, 19
    vgetmantps zmm13, zmm19, 4
    vmulps zmm1, zmm4, zmm5
    vmovups zmm11, [rsp + 2944]
    vpermi2ps zmm16, zmm31, zmm30
    vpermps zmm6, zmm2, zmm29
    vpermps zmm0, zmm2, zmm28
    vfmadd213ps zmm21, zmm5, zmm27
    vrangeps zmm18, zmm11, [c_xflr]{1to16}, 7
    vpternlogd zmm16, zmm19, [c_sign]{1to16}, 216
    vfmsub213ps zmm13, zmm0, [c_one]{1to16}
    vfmadd231ps zmm4, zmm1, zmm21
    vpsrld zmm10, zmm18, 23
    vpsrld zmm17, zmm18, 19
    vmovaps zmm2, zmm26
    vfmadd231ps zmm2, zmm9, zmm25
    vmulps zmm5, zmm16, zmm6
    vgetmantps zmm11, zmm18, 4
    vmulps zmm19, zmm8, zmm9
    vaddps zmm0, zmm14, zmm3
    vpermi2ps zmm10, zmm31, zmm30
    vpermps zmm1, zmm17, zmm29
    vpermps zmm21, zmm17, zmm28
    vpmaxud zmm16, zmm3, zmm4
    vaddps zmm6, zmm7, zmm4
    vfmadd213ps zmm2, zmm9, zmm27
    vaddps zmm14, zmm0, [rsp + 5568]
    vaddps zmm17, zmm6, [rsp + 5632]
    vpternlogd zmm10, zmm18, [c_sign]{1to16}, 216
    vmovaps [rsp + 6592], zmm14
    vfmsub213ps zmm11, zmm21, [c_one]{1to16}
    vfmadd231ps zmm8, zmm19, zmm2
    vmovups zmm3, [rsp + 3008]
    vmulps zmm7, zmm10, zmm1
    vmovaps [rsp + 6656], zmm17
    vpmaxud zmm4, zmm16, zmm8
    vaddps zmm9, zmm15, zmm8
    vrangeps zmm18, zmm3, [c_xflr]{1to16}, 7
    vpminsd zmm14, zmm4, [c_zero]{1to16}
    vaddps zmm21, zmm9, [rsp + 5696]
    vpsrld zmm19, zmm18, 23
    vpsrld zmm2, zmm18, 19
    vaddps zmm10, zmm12, zmm14
    vgetmantps zmm1, zmm18, 4
    vmovaps zmm17, zmm26
    vfmadd231ps zmm17, zmm20, zmm25
    vmulps zmm16, zmm23, zmm20
    vmovaps [rsp + 6720], zmm21
    vpermi2ps zmm19, zmm31, zmm30
    vpermps zmm15, zmm2, zmm29
    vmovups zmm8, [rsp + 3072]
    vpermps zmm3, zmm2, zmm28
    vaddps zmm4, zmm10, [rsp + 5760]
    vfmadd213ps zmm17, zmm20, zmm27
    vmovaps [rsp + 6784], zmm4
    vpternlogd zmm19, zmm18, [c_sign]{1to16}, 216
    vrangeps zmm12, zmm8, [c_xflr]{1to16}, 7
    vfmsub213ps zmm1, zmm3, [c_one]{1to16}
    jmp .j1920
.j1920:
    vmovaps zmm14, zmm26
    vfmadd231ps zmm14, zmm24, zmm25
    vmulps zmm21, zmm19, zmm15
    vfmadd231ps zmm23, zmm16, zmm17
    vpsrld zmm2, zmm12, 23
    vpsrld zmm20, zmm12, 19
    vmulps zmm4, zmm22, zmm24
    vgetmantps zmm18, zmm12, 4
    vmovaps zmm8, zmm26
    vfmadd231ps zmm8, zmm13, zmm25
    vmulps zmm3, zmm5, zmm13
    vpermi2ps zmm2, zmm31, zmm30
    vpermps zmm19, zmm20, zmm29
    vpermps zmm15, zmm20, zmm28
    vfmadd213ps zmm14, zmm24, zmm27
    vmovaps zmm16, zmm26
    vfmadd231ps zmm16, zmm11, zmm25
    vmulps zmm17, zmm7, zmm11
    vmovaps zmm20, zmm26
    vfmadd231ps zmm20, zmm1, zmm25
    vfmadd213ps zmm8, zmm13, zmm27
    vmulps zmm24, zmm21, zmm1
    vpternlogd zmm2, zmm12, [c_sign]{1to16}, 216
    vfmadd231ps zmm22, zmm4, zmm14
    vfmadd213ps zmm16, zmm11, zmm27
    vfmsub213ps zmm18, zmm15, [c_one]{1to16}
    vfmadd213ps zmm20, zmm1, zmm27
    vmulps zmm13, zmm2, zmm19
    vfmadd231ps zmm5, zmm3, zmm8
    vpmaxud zmm12, zmm23, zmm22
    vfmadd231ps zmm7, zmm17, zmm16
    vfmadd231ps zmm26, zmm18, zmm25
    vfmadd231ps zmm21, zmm24, zmm20
    vmulps zmm4, zmm13, zmm18
    vpmaxud zmm14, zmm12, zmm5
    vpminsd zmm11, zmm14, [c_zero]{1to16}
    vaddps zmm15, zmm23, zmm7
    vfmadd231ps zmm27, zmm26, zmm18
    vpmaxud zmm1, zmm7, zmm21
    vaddps zmm2, zmm22, zmm21
    vaddps zmm19, zmm15, [rsp + 5824]
    vaddps zmm3, zmm15, zmm0
    vaddps zmm8, zmm2, [rsp + 5888]
    vaddps zmm17, zmm2, zmm6
    vfmadd231ps zmm13, zmm4, zmm27
    vmovaps [r13 + 768], zmm3
    vmovups zmm16, [rsp + 6336]
    vmovaps [r13 + 832], zmm17
    vmovups zmm24, [rsp + 6080]
    vpmaxud zmm20, zmm1, zmm13
    vaddps zmm12, zmm5, zmm13
    vpminsd zmm14, zmm20, [c_zero]{1to16}
    valignd zmm23, zmm16, [rsp + 6848], 15
    valignd zmm26, zmm19, zmm16, 15
    vaddps zmm18, zmm12, [rsp + 5952]
    vaddps zmm7, zmm12, zmm9
    vaddps zmm22, zmm11, zmm14
    vmovups zmm21, [rsp + 6400]
    vmovaps [r13 + 896], zmm7
    vmovups zmm15, [rsp + 6144]
    vaddps zmm0, zmm22, [rsp + 6016]
    vaddps zmm2, zmm22, zmm10
    vfmadd231ps zmm23, zmm24, [rsp + 7104]
    vmovaps [rsp + 6848], zmm19
    vaddps zmm6, zmm26, [rsp + 6592]
    vmovaps [r13 + 960], zmm2
    valignd zmm4, zmm21, [rsp + 6912], 15
    valignd zmm27, zmm8, zmm21, 15
    vmovups zmm3, [rsp + 6464]
    vshufps zmm17, zmm23, zmm6, 136
    vshufps zmm1, zmm23, zmm6, 221
    vmovups zmm5, [rsp + 6208]
    vaddps zmm13, zmm17, zmm1
    vfmadd231ps zmm4, zmm15, [rsp + 7104]
    vaddps zmm20, zmm27, [rsp + 6656]
    vmovaps [rsp + 6912], zmm8
    valignd zmm16, zmm3, [rsp + 6976], 15
    valignd zmm12, zmm18, zmm3, 15
    vmovaps [r13 + 1024], zmm13
    vmovups zmm9, [rsp + 6528]
    vshufps zmm11, zmm4, zmm20, 136
    vshufps zmm14, zmm4, zmm20, 221
    vmovups zmm7, [rsp + 6272]
    vfmadd231ps zmm16, zmm5, [rsp + 7104]
    vaddps zmm22, zmm12, [rsp + 6720]
    vmovaps [rsp + 6976], zmm18
    vaddps zmm10, zmm11, zmm14
    valignd zmm24, zmm9, [rsp + 7040], 15
    valignd zmm19, zmm0, zmm9, 15
    vmovaps [r13 + 1088], zmm10
    vshufps zmm26, zmm16, zmm22, 136
    vshufps zmm2, zmm16, zmm22, 221
    vmovups zmm21, [c_ones]
    vaddps zmm23, zmm26, zmm2
    vfmadd231ps zmm24, zmm7, [rsp + 7104]
    vaddps zmm6, zmm19, [rsp + 6784]
    vmovaps [rsp + 7040], zmm0
    vmovaps [r13 + 1152], zmm23
    vshufps zmm17, zmm24, zmm6, 136
    vshufps zmm1, zmm24, zmm6, 221
    vmovaps [rsp + 7104], zmm21
    vaddps zmm15, zmm17, zmm1
    vmovaps [r13 + 1216], zmm15
    and r2d, 8191
    prefetcht1 [r2 + .cold]
    vbroadcastss zmm31, [c_h0625]
    vbroadcastss zmm30, [c_h5625]
    vbroadcastss zmm29, [c_i512]
    vpmovzxwd zmm0, [r0 + r3*2 + 32]
    vpmovzxwd zmm1, [r0 + r3*2 + 64]
    vmovups zmm2, [r8]
    vpmovzxwd zmm3, [r0 + r3*2 + 32 + CRD]
    vpmovzxwd zmm4, [r0 + r3*2 + 64 + CRD]
    vmovups zmm5, [r8 + 64]
    vpsubd zmm6, zmm0, zmm29
    vpsubd zmm7, zmm1, zmm29
    vpsubd zmm8, zmm3, zmm29
    valignd zmm9, zmm2, [r8 - 256], 15
    vpsubd zmm10, zmm4, zmm29
    vcvtdq2ps zmm11, zmm6
    vcvtdq2ps zmm12, zmm7
    valignd zmm13, zmm5, [r8 - 256 + 64], 15
    vcvtdq2ps zmm14, zmm8
    vcvtdq2ps zmm15, zmm10
    vmovaps [r8 + 256], zmm11
    valignd zmm16, zmm11, zmm2, 1
    valignd zmm17, zmm11, zmm2, 2
    vmovaps [r8 + 512], zmm12
    valignd zmm18, zmm11, zmm2, 15
    valignd zmm19, zmm12, zmm11, 1
    jmp .j2048
.j2048:
    valignd zmm20, zmm12, zmm11, 2
    vmovaps [r8 + 256 + 64], zmm14
    valignd zmm21, zmm14, zmm5, 1
    vmovaps [r8 + 512 + 64], zmm15
    valignd zmm22, zmm14, zmm5, 2
    valignd zmm23, zmm14, zmm5, 15
    valignd zmm24, zmm15, zmm14, 1
    valignd zmm25, zmm15, zmm14, 2
    vmovups zmm26, [r8 + SPBC]
    vpmovzxwd zmm27, [r0 + r3*2 + 32 + CST]
    vpmovzxwd zmm28, [r0 + r3*2 + 64 + CST]
    vaddps zmm0, zmm16, zmm2
    vaddps zmm1, zmm9, zmm17
    vaddps zmm3, zmm19, zmm11
    vaddps zmm4, zmm18, zmm20
    vaddps zmm6, zmm21, zmm5
    vaddps zmm7, zmm13, zmm22
    vmulps zmm8, zmm1, zmm31
    vaddps zmm10, zmm24, zmm14
    vaddps zmm12, zmm23, zmm25
    vpsubd zmm15, zmm27, zmm29
    vpsubd zmm16, zmm28, zmm29
    valignd zmm2, zmm26, [r8 - 256 + SPBC], 15
    vmulps zmm9, zmm4, zmm31
    vpmovzxwd zmm17, [r0 + r3*2 + 32 + CST + CRD]
    vmulps zmm19, zmm7, zmm31
    vcvtdq2ps zmm11, zmm15
    vmulps zmm18, zmm12, zmm31
    vcvtdq2ps zmm20, zmm16
    vpmovzxwd zmm21, [r0 + r3*2 + 64 + CST + CRD]
    vfmsub231ps zmm8, zmm0, zmm30
    vmovups zmm5, [r8 + 64 + SPBC]
    vfmsub231ps zmm9, zmm3, zmm30
    vfmsub231ps zmm19, zmm6, zmm30
    vmovaps [r8 + 256 + SPBC], zmm11
    valignd zmm13, zmm11, zmm26, 1
    valignd zmm22, zmm11, zmm26, 2
    vpsubd zmm1, zmm17, zmm29
    vfmsub231ps zmm18, zmm10, zmm30
    vmovaps [r8 + 512 + SPBC], zmm20
    valignd zmm24, zmm11, zmm26, 15
    valignd zmm14, zmm20, zmm11, 1
    valignd zmm23, zmm20, zmm11, 2
    vpsubd zmm25, zmm21, zmm29
    vmovaps [r8 + 128], zmm8
    vcvtdq2ps zmm27, zmm1
    valignd zmm28, zmm5, [r8 - 256 + 64 + SPBC], 15
    vmovaps [r8 + 384], zmm9
    vcvtdq2ps zmm4, zmm25
    vmovaps [r8 + 128 + 64], zmm19
    vmovaps [r8 + 384 + 64], zmm18
    vaddps zmm7, zmm13, zmm26
    vaddps zmm15, zmm2, zmm22
    vaddps zmm12, zmm14, zmm11
    vmovaps [r8 + 256 + 64 + SPBC], zmm27
    valignd zmm16, zmm27, zmm5, 1
    valignd zmm0, zmm27, zmm5, 2
    vaddps zmm3, zmm24, zmm23
    valignd zmm6, zmm27, zmm5, 15
    vmovaps [r8 + 512 + 64 + SPBC], zmm4
    valignd zmm17, zmm4, zmm27, 1
    valignd zmm10, zmm4, zmm27, 2
    vmulps zmm20, zmm15, zmm31
    vmulps zmm21, zmm3, zmm31
    vaddps zmm8, zmm16, zmm5
    vaddps zmm1, zmm28, zmm0
    vfmsub231ps zmm20, zmm7, zmm30
    vaddps zmm9, zmm17, zmm27
    vaddps zmm25, zmm6, zmm10
    vfmsub231ps zmm21, zmm12, zmm30
    vmulps zmm19, zmm1, zmm31
    vmulps zmm18, zmm25, zmm31
    vmovaps [r8 + 128 + SPBC], zmm20
    vmovaps [r8 + 384 + SPBC], zmm21
    vfmsub231ps zmm19, zmm8, zmm30
    vfmsub231ps zmm18, zmm9, zmm30
    vmovaps [r8 + 128 + 64 + SPBC], zmm19
    vmovaps [r8 + 384 + 64 + SPBC], zmm18
    add r4, 512
    add r5, 512
    add r7, 512
    add r8, 512
    mov r14, r13
    add r13, 1280
    mov r11, r9
    add r9, 64
    mov r6, r10
    add r10, 32
%if M > SPS
    add r3, 32
    jz .pend
    lea r2d, [r3 + W/2]
    test r2d, 32*SPS - 32
    jnz .pair
    vmovdqu16 zmm1, [rsp + r3 + FMR + W/2 - 32*SPS]
    vpandd zmm1, zmm1, [rsp + r3 + FMR + W/2 - 32*SPS + 64]
    vpandd zmm1, zmm1, [rsp + r3 + FMR + W/2 - 32*SPS + 128]
    vpandd zmm1, zmm1, [rsp + r3 + FMR + W/2 - 32*SPS + 192]
    vpandd zmm1, zmm1, [rsp + r3 + FMR + W/2 - 32*SPS + 256]
    vpandd zmm1, zmm1, [rsp + r3 + FMR + W/2 - 32*SPS + 320]
    vpandd zmm1, zmm1, [rsp + r3 + FMR + W/2 - 32*SPS + 384]
    vpandd zmm1, zmm1, [rsp + r3 + FMR + W/2 - 32*SPS + 448]
    vpcmpeqw k1, zmm1, [t_ones]
    kortestd k1, k1
    jnc .sfs
.sbs:
    mov [rsp + 9944], r14
    mov [rsp + 9952], r11
    mov [rsp + 9960], r6
    mov r2d, [rsp + 10000]
    xor r2d, 1280*SSZ
    mov [rsp + 10000], r2d
    lea r13, [rsp + r2 + BMS]
    jmp .pair
.pend:
%else
    add r3, 32
    jnz .pair
%endif
%if NCL == 1
    vpternlogd zmm0, zmm0, zmm0, 0xff
    vpcmpw k1, zmm0, [rsp + FMR + W/2 - 32*SLST], 4
    kortestd k1, k1
    jnz .sfp
%elif NCL == 2
    vpternlogd zmm0, zmm0, zmm0, 0xff
    vpcmpw k1, zmm0, [rsp + FMR + W/2 - 32*SLST], 4
    vpcmpw k2, zmm0, [rsp + FMR + W/2 - 32*SLST + 64], 4
    kortestd k1, k2
    jnz .sfp
%else
    vmovdqu16 zmm1, [rsp + FMR + W/2 - 32*SLST]
%assign ci 1
%rep NCL - 1
    vpandd zmm1, zmm1, [rsp + FMR + W/2 - 32*SLST + 64*ci]
%assign ci ci + 1
%endrep
    vpcmpeqw k1, zmm1, [t_ones]
    kortestd k1, k1
    jnc .sfp
%endif
.scr:
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
    xor r3d, r3d
    vbroadcastss zmm31, [c_xlo]
    vbroadcastss zmm30, [c_absm]
    vbroadcastss zmm29, [c_eq]
    vbroadcastss zmm28, [c_ieq]
    vbroadcastss zmm27, [c_rgl0]
    vbroadcastss zmm26, [c_rgl1]
    vbroadcastss zmm25, [c_rgl2]
    vbroadcastss zmm24, [c_oml0]
    vbroadcastss zmm23, [c_oml1]
    vbroadcastss zmm22, [c_oml2]
    vbroadcastss zmm21, [c_epsf]
    vbroadcastss zmm20, [c_anegl]
    vbroadcastss zmm19, [c_snegl]
    vbroadcastss zmm18, [c_tabsl]
    vsubps zmm0, zmm21, [r14 + 192]
    vmovups zmm1, [r14]
    vmovups zmm2, [r14 + 64]
    vmovups zmm3, [r14 + 128]
    vsubps zmm4, zmm21, [r14 + 448]
    vmovups zmm5, [r14 + 256]
    vmovups zmm6, [r14 + 320]
    vmovups zmm7, [r14 + 384]
    vrsqrt14ps zmm8, zmm0
    vmovaps zmm9, zmm28
    vrsqrt14ps zmm10, zmm4
    vandps zmm11, zmm1, zmm30
    vandps zmm12, zmm2, zmm30
    vandps zmm13, zmm3, zmm30
    vandps zmm14, zmm5, zmm30
    vandps zmm15, zmm6, zmm30
    vandps zmm16, zmm7, zmm30
    vfmadd213ps zmm8, zmm19, zmm20
    vfmadd213ps zmm10, zmm19, zmm20
    vfmadd213ps zmm8, zmm0, zmm18
    vmovaps zmm17, zmm28
    vfmadd213ps zmm10, zmm4, zmm18
    vmovaps zmm1, zmm8
    vfmadd231ps zmm1, zmm11, zmm27
    vmovaps zmm2, zmm8
    vfmadd231ps zmm2, zmm12, zmm26
    vsubps zmm3, zmm11, zmm1
    vsubps zmm5, zmm12, zmm2
    vfmadd231ps zmm8, zmm13, zmm25
    vcmpps k1, zmm3, zmm31, 30
    vcmpps k2, zmm3, zmm31, 26
    vrcp14ps zmm6, zmm3
    vcmpps k3, zmm5, zmm31, 30
    vcmpps k4, zmm5, zmm31, 26
    vrcp14ps zmm7, zmm5
    vsubps zmm0, zmm13, zmm8
    jmp .j2176
.j2176:
    vmovaps zmm4, zmm28
    vcmpps k5, zmm0, zmm31, 30
    vcmpps k6, zmm0, zmm31, 26
    vaddps zmm11{k2}, zmm11, zmm1
    vmulps zmm9{k1}, zmm1, zmm6
    kmovw [rsp], k1
    vrcp14ps zmm3, zmm0
    vsubps zmm5, zmm21, [r14 + 704]
    vmulps zmm17{k3}, zmm2, zmm7
    kmovw [rsp + 2], k3
    vmovups zmm1, [r14 + 512]
    vaddps zmm12{k4}, zmm12, zmm2
    vmovups zmm6, [r14 + 576]
    vmovups zmm0, [r14 + 640]
    vmovaps zmm7, zmm10
    vfmadd231ps zmm7, zmm14, zmm27
    vmovaps [rsp + 3136], zmm11
    vrsqrt14ps zmm2, zmm5
    vfmadd213ps zmm9, zmm29, zmm24
    vmovaps [rsp + 3264], zmm12
    vfmadd213ps zmm17, zmm29, zmm23
    vaddps zmm13{k6}, zmm13, zmm8
    vmulps zmm4{k5}, zmm8, zmm3
    kmovw [rsp + 4], k5
    vmovaps zmm11, zmm28
    vandps zmm12, zmm1, zmm30
    vandps zmm8, zmm6, zmm30
    vandps zmm3, zmm0, zmm30
    vsubps zmm1, zmm14, zmm7
    vmovaps zmm6, zmm10
    vfmadd231ps zmm6, zmm15, zmm26
    vmovaps [rsp + 3200], zmm9
    vfmadd213ps zmm2, zmm19, zmm20
    vmovaps [rsp + 3328], zmm17
    vfmadd213ps zmm4, zmm29, zmm22
    vmovaps [rsp + 3392], zmm13
    vcmpps k7, zmm1, zmm31, 30
    vcmpps k2, zmm1, zmm31, 26
    vmovaps zmm0, zmm28
    vrcp14ps zmm9, zmm1
    vfmadd231ps zmm10, zmm16, zmm25
    vsubps zmm17, zmm15, zmm6
    vfmadd213ps zmm2, zmm5, zmm18
    vmovaps [rsp + 3456], zmm4
    vcmpps k1, zmm17, zmm31, 30
    vcmpps k3, zmm17, zmm31, 26
    vrcp14ps zmm13, zmm17
    vsubps zmm1, zmm16, zmm10
    vmovaps zmm5, zmm28
    vaddps zmm14{k2}, zmm14, zmm7
    vmulps zmm11{k7}, zmm7, zmm9
    kmovw [rsp + 6], k7
    vsubps zmm4, zmm21, [r14 + 960]
    vcmpps k4, zmm1, zmm31, 30
    vcmpps k6, zmm1, zmm31, 26
    vmovaps [rsp + 3520], zmm14
    vrcp14ps zmm17, zmm1
    vmovups zmm7, [r14 + 768]
    vfmadd213ps zmm11, zmm29, zmm24
    vrsqrt14ps zmm9, zmm4
    vmovups zmm14, [r14 + 832]
    vaddps zmm15{k3}, zmm15, zmm6
    vmulps zmm0{k1}, zmm6, zmm13
    kmovw [rsp + 8], k1
    vmovups zmm1, [r14 + 896]
    vmovaps zmm6, zmm2
    vfmadd231ps zmm6, zmm12, zmm27
    vmovaps [rsp + 3648], zmm15
    vmovaps [rsp + 3584], zmm11
    vfmadd213ps zmm0, zmm29, zmm23
    vaddps zmm16{k6}, zmm16, zmm10
    vmulps zmm5{k4}, zmm10, zmm17
    vandps zmm13, zmm7, zmm30
    kmovw [rsp + 10], k4
    vfmadd231ps zmm20, zmm9, zmm19
    vandps zmm15, zmm14, zmm30
    vsubps zmm11, zmm12, zmm6
    vmovaps zmm10, zmm28
    vandps zmm17, zmm1, zmm30
    vmovaps zmm7, zmm2
    vfmadd231ps zmm7, zmm8, zmm26
    vmovaps [rsp + 3776], zmm16
    vfmadd213ps zmm5, zmm29, zmm22
    vcmpps k5, zmm11, zmm31, 30
    vcmpps k2, zmm11, zmm31, 26
    vmovaps zmm9, zmm28
    vmovaps [rsp + 3712], zmm0
    vrcp14ps zmm14, zmm11
    vfmadd231ps zmm18, zmm20, zmm4
    vfmadd231ps zmm2, zmm3, zmm25
    vsubps zmm1, zmm8, zmm7
    vmovaps [rsp + 3840], zmm5
    vcmpps k7, zmm1, zmm31, 30
    vcmpps k3, zmm1, zmm31, 26
    vaddps zmm12{k2}, zmm12, zmm6
    vmulps zmm10{k5}, zmm6, zmm14
    kmovw [rsp + 12], k5
    vrcp14ps zmm16, zmm1
    vsubps zmm0, zmm3, zmm2
    vmovaps zmm11, zmm28
    vbroadcastss zmm20, [c_epsf]
    vmovaps [rsp + 3904], zmm12
    vcmpps k1, zmm0, zmm31, 30
    vcmpps k6, zmm0, zmm31, 26
    vfmadd213ps zmm10, zmm29, zmm24
    vrcp14ps zmm4, zmm0
    vbroadcastss zmm5, [c_anegh]
    vmovups zmm6, [r14 + 1024]
    vmovups zmm14, [r14 + 1088]
    vaddps zmm8{k3}, zmm8, zmm7
    vmulps zmm9{k7}, zmm7, zmm16
    kmovw [rsp + 14], k7
    vmovups zmm1, [r14 + 1152]
    vsubps zmm12, zmm20, [r14 + 1216]
    vfmadd213ps zmm27, zmm13, zmm18
    vmovaps [rsp + 3968], zmm10
    vmovaps [rsp + 4032], zmm8
    vfmadd213ps zmm9, zmm29, zmm23
    vaddps zmm3{k6}, zmm3, zmm2
    vmulps zmm11{k1}, zmm2, zmm4
    vrsqrt14ps zmm0, zmm12
    kmovw [rsp + 16], k1
    vandps zmm7, zmm6, zmm30
    vandps zmm16, zmm14, zmm30
    vmovaps zmm20, zmm28
    vandps zmm10, zmm1, zmm30
    vsubps zmm8, zmm13, zmm27
    vfmadd213ps zmm26, zmm15, zmm18
    jmp .j2304
.j2304:
    vmovaps [rsp + 4160], zmm3
    vfmadd213ps zmm11, zmm29, zmm22
    vmovaps [rsp + 4096], zmm9
    vcmpps k4, zmm8, zmm31, 30
    vcmpps k2, zmm8, zmm31, 26
    vmovaps zmm2, zmm28
    vfmadd231ps zmm5, zmm0, [c_snegh]{1to16}
    vrcp14ps zmm4, zmm8
    vsubps zmm6, zmm15, zmm26
    vfmadd231ps zmm18, zmm17, zmm25
    vmovaps [rsp + 4224], zmm11
    vcmpps k5, zmm6, zmm31, 30
    vcmpps k3, zmm6, zmm31, 26
    vfmadd213ps zmm5, zmm12, [c_tabsh]{1to16}
    vrcp14ps zmm14, zmm6
    vaddps zmm13{k2}, zmm13, zmm27
    vmulps zmm20{k4}, zmm27, zmm4
    kmovw [rsp + 18], k4
    vsubps zmm1, zmm17, zmm18
    vmovaps zmm3, zmm28
    vmovaps [rsp + 4288], zmm13
    vcmpps k7, zmm1, zmm31, 30
    vcmpps k6, zmm1, zmm31, 26
    vfmadd231ps zmm24, zmm20, zmm29
    vrcp14ps zmm9, zmm1
    vmovaps zmm0, zmm5
    vfmadd231ps zmm0, zmm7, [c_rgh0]{1to16}
    vaddps zmm15{k3}, zmm15, zmm26
    vmulps zmm2{k5}, zmm26, zmm14
    kmovw [rsp + 20], k5
    vmovaps zmm8, zmm28
    vbroadcastss zmm11, [c_omh0]
    vmovaps [rsp + 4416], zmm15
    vmovaps [rsp + 4352], zmm24
    vfmadd231ps zmm23, zmm2, zmm29
    vsubps zmm12, zmm7, zmm0
    vmovaps zmm6, zmm5
    vfmadd231ps zmm6, zmm16, [c_rgh1]{1to16}
    vaddps zmm17{k6}, zmm17, zmm18
    vmulps zmm3{k7}, zmm18, zmm9
    kmovw [rsp + 22], k7
    vmovaps zmm27, zmm28
    vcmpps k1, zmm12, zmm31, 30
    vcmpps k2, zmm12, zmm31, 26
    vmovaps [rsp + 4544], zmm17
    vrcp14ps zmm4, zmm12
    vbroadcastss zmm13, [c_omh1]
    vmovaps [rsp + 4480], zmm23
    vfmadd231ps zmm22, zmm3, zmm29
    vsubps zmm20, zmm16, zmm6
    vfmadd231ps zmm5, zmm10, [c_rgh2]{1to16}
    vcmpps k4, zmm20, zmm31, 30
    vcmpps k3, zmm20, zmm31, 26
    vrcp14ps zmm1, zmm20
    vmovaps [rsp + 4608], zmm22
    vaddps zmm7{k2}, zmm7, zmm0
    vmulps zmm8{k1}, zmm0, zmm4
    vsubps zmm26, zmm10, zmm5
    vmovaps zmm14, zmm28
    kmovw [rsp + 24], k1
    vbroadcastss zmm15, [c_omh2]
    vmovaps [rsp + 4672], zmm7
    vcmpps k5, zmm26, zmm31, 30
    vcmpps k6, zmm26, zmm31, 26
    vfmadd231ps zmm11, zmm8, zmm29
    vrcp14ps zmm24, zmm26
    vaddps zmm16{k3}, zmm16, zmm6
    vmulps zmm27{k4}, zmm6, zmm1
    kmovw [rsp + 26], k4
    vmovaps [rsp + 4800], zmm16
    vmovaps [rsp + 4736], zmm11
    vfmadd231ps zmm13, zmm27, zmm29
    vaddps zmm10{k6}, zmm10, zmm5
    vmulps zmm14{k5}, zmm5, zmm24
    kmovw [rsp + 28], k5
    vmovaps [rsp + 4928], zmm10
    vmovaps [rsp + 4864], zmm13
    vfmadd231ps zmm15, zmm14, zmm29
    vmovaps [rsp + 4992], zmm15
    vmovups zmm31, [c_to]
    vmovups zmm30, [c_to + 64]
    vmovups zmm29, [c_wo]
    vmovups zmm28, [c_ro]
    vbroadcastss zmm27, [c_one]
    vbroadcastss zmm26, [c_qo0]
    vbroadcastss zmm25, [c_qo1]
    vbroadcastss zmm24, [c_qo2]
    vbroadcastss zmm23, [c_xlo]
    vbroadcastss zmm22, [c_sign]
    vbroadcastss zmm21, [c_half]
    vmovups zmm0, [rsp + 3392]
    vmovups zmm1, [rsp + 3136]
    vmovups zmm2, [rsp + 3264]
    vmaxps zmm3, zmm0, zmm23
    vmaxps zmm4, zmm1, zmm23
    vmaxps zmm5, zmm2, zmm23
    vpsrld zmm6, zmm3, 23
    vpsrld zmm7, zmm3, 19
    vgetmantps zmm8, zmm3, 4
    vpsrld zmm9, zmm4, 23
    vmovups zmm10, [rsp + 3776]
    vpsrld zmm11, zmm4, 19
    vgetmantps zmm12, zmm4, 4
    vpermi2ps zmm6, zmm31, zmm30
    vpermps zmm13, zmm7, zmm29
    vpsrld zmm14, zmm5, 23
    vpermps zmm15, zmm7, zmm28
    vpermi2ps zmm9, zmm31, zmm30
    vpsrld zmm16, zmm5, 19
    vpermps zmm17, zmm11, zmm29
    vpermps zmm18, zmm11, zmm28
    vgetmantps zmm19, zmm5, 4
    vpermi2ps zmm14, zmm31, zmm30
    kmovw k1, [rsp + 4]
    vpermps zmm20, zmm16, zmm29
    vpermps zmm0, zmm16, zmm28
    vmovups zmm1, [r14 + 128]
    vmaxps zmm2, zmm10, zmm23
    vbroadcastss zmm3, [c_slkl]
    vmovups zmm4, [rsp + 3520]
    vmulps zmm7, zmm6, zmm13
    vfmsub213ps zmm8, zmm15, zmm27
    vfmsub213ps zmm12, zmm18, zmm27
    vmulps zmm11, zmm9, zmm17
    vpsrld zmm5, zmm2, 23
    vpsrld zmm16, zmm2, 19
    vgetmantps zmm10, zmm2, 4
    vfmsub213ps zmm19, zmm0, zmm27
    jmp .j2432
.j2432:
    vmulps zmm6, zmm14, zmm20
    vpermi2ps zmm5, zmm31, zmm30
    vpermps zmm13, zmm16, zmm29
    vpermps zmm15, zmm16, zmm28
    vmaxps zmm18, zmm4, zmm23
    vmovaps zmm9, zmm25
    vfmadd231ps zmm9, zmm8, zmm24
    vmulps zmm17, zmm7, zmm8
    kmovw k2, [rsp]
    vmovaps zmm2, zmm25
    vfmadd231ps zmm2, zmm12, zmm24
    vmulps zmm0, zmm11, zmm12
    vmovups zmm14, [r14]
    vmovups zmm20, [rsp + 3648]
    vpsrld zmm16, zmm18, 23
    vpsrld zmm4, zmm18, 19
    vgetmantps zmm18, zmm18, 4
    vmulps zmm5, zmm5, zmm13
    vfmsub213ps zmm10, zmm15, zmm27
    vfmadd213ps zmm9, zmm8, zmm26
    vpermi2ps zmm16, zmm31, zmm30
    vpermps zmm13, zmm4, zmm29
    vpermps zmm15, zmm4, zmm28
    vfmadd213ps zmm2, zmm12, zmm26
    vmovaps zmm8, zmm25
    vfmadd231ps zmm8, zmm19, zmm24
    vmulps zmm4, zmm6, zmm19
    vmaxps zmm12, zmm20, zmm23
    kmovw k3, [rsp + 2]
    vmovups zmm20, [r14 + 64]
    vfmadd231ps zmm7, zmm17, zmm9
    vfmadd231ps zmm11, zmm0, zmm2
    vpsrld zmm17, zmm12, 23
    vpsrld zmm9, zmm12, 19
    vfmsub213ps zmm18, zmm15, zmm27
    vmulps zmm0, zmm16, zmm13
    vgetmantps zmm2, zmm12, 4
    vfmadd213ps zmm8, zmm19, zmm26
    vpermi2ps zmm17, zmm31, zmm30
    vpermps zmm15, zmm9, zmm29
    vpermps zmm16, zmm9, zmm28
    vpbroadcastd zmm13, [c_m1]
    vmulps zmm12, zmm7, [rsp + 3456]
    vpternlogd zmm7{k1}{z}, zmm1, zmm22, 216
    vmulps zmm19, zmm11, [rsp + 3200]
    vpternlogd zmm11{k2}{z}, zmm14, zmm22, 216
    vmovups zmm9, [rsp + 4160]
    vmulps zmm1, zmm7, [c_mtl2]{1to16}
    vfmadd231ps zmm6, zmm4, zmm8
    vfmadd231ps zmm3, zmm12, [c_mtl2]{1to16}
    vmulps zmm14, zmm17, zmm15
    vfmsub213ps zmm2, zmm16, zmm27
    vfmadd231ps zmm1, zmm11, [c_mtl0]{1to16}
    vmaxps zmm7, zmm9, zmm23
    vmulps zmm4, zmm6, [rsp + 3328]
    vpternlogd zmm6{k3}{z}, zmm20, zmm22, 216
    vmovaps zmm8, zmm25
    vfmadd231ps zmm8, zmm10, zmm24
    vmulps zmm12, zmm5, zmm10
    vfmadd231ps zmm3, zmm19, [c_mtl0]{1to16}
    vpsrld zmm17, zmm7, 23
    vpsrld zmm15, zmm7, 19
    kmovw k4, [rsp + 10]
    vgetmantps zmm16, zmm7, 4
    vmovups zmm11, [r14 + 384]
    vfmadd231ps zmm1, zmm6, [c_mtl1]{1to16}
    vbroadcastss zmm9, [c_slkl]
    vpermi2ps zmm17, zmm31, zmm30
    vpermps zmm20, zmm15, zmm29
    vfmadd213ps zmm8, zmm10, zmm26
    vmovups zmm19, [rsp + 3904]
    vpermps zmm7, zmm15, zmm28
    vfmadd231ps zmm3, zmm4, [c_mtl1]{1to16}
    vreduceps zmm6, zmm1, 8
    vcvtps2dq zmm10, zmm1, {rn-sae}
    vfmadd231ps zmm5, zmm12, zmm8
    vmulps zmm15, zmm17, zmm20
    vmaxps zmm4, zmm19, zmm23
    vmovaps zmm1, zmm25
    vfmadd231ps zmm1, zmm18, zmm24
    vfmsub213ps zmm16, zmm7, zmm27
    vmulps zmm12, zmm0, zmm18
    kmovw k5, [rsp + 6]
    vpaddd zmm8, zmm10, [c_i64]{1to16}
    vmovups zmm17, [r14 + 256]
    vpsrld zmm20, zmm4, 23
    vpsrld zmm19, zmm4, 19
    vmulps zmm7, zmm5, [rsp + 3840]
    vpternlogd zmm5{k4}{z}, zmm11, zmm22, 216
    vgetmantps zmm10, zmm4, 4
    vmovups zmm11, [rsp + 4032]
    vandps zmm4, zmm6, [c_absm]{1to16}
    vpminsd zmm6, zmm8, [c_i1023]{1to16}
    vfmadd213ps zmm1, zmm18, zmm26
    vpermi2ps zmm20, zmm31, zmm30
    vpermps zmm8, zmm19, zmm29
    vmulps zmm18, zmm5, [c_mtl2]{1to16}
    vpermps zmm5, zmm19, zmm28
    vaddps zmm19, zmm4, zmm3
    vmovaps zmm4, zmm25
    vfmadd231ps zmm4, zmm2, zmm24
    vfmadd231ps zmm9, zmm7, [c_mtl2]{1to16}
    vmulps zmm3, zmm14, zmm2
    kmovw k6, [rsp + 8]
    vfmadd231ps zmm0, zmm12, zmm1
    vmaxps zmm7, zmm11, zmm23
    vmovups zmm12, [r14 + 320]
    vcmpps k7, zmm19, zmm21, 17
    vmulps zmm1, zmm20, zmm8
    vfmsub213ps zmm10, zmm5, zmm27
    vfmadd213ps zmm4, zmm2, zmm26
    vpsrld zmm11, zmm7, 23
    vpsrld zmm19, zmm7, 19
    vgetmantps zmm20, zmm7, 4
    vmulps zmm8, zmm0, [rsp + 3584]
    vpternlogd zmm0{k5}{z}, zmm17, zmm22, 216
    vpermi2ps zmm11, zmm31, zmm30
    vpermps zmm5, zmm19, zmm29
    vpbroadcastd zmm2, [c_m1]
    vpermps zmm7, zmm19, zmm28
    vmovups zmm17, [rsp + 4544]
    vpmaxsd zmm13{k7}, zmm6, [c_zero]{1to16}
    kmovw [rsp + r3 + FMR + W/2], k7
    vfmadd231ps zmm18, zmm0, [c_mtl0]{1to16}
    vfmadd231ps zmm14, zmm3, zmm4
    vfmadd231ps zmm9, zmm8, [c_mtl0]{1to16}
    vpmovdw [r11], zmm13
    vmulps zmm19, zmm11, zmm5
    jmp .j2560
.j2560:
    vfmsub213ps zmm20, zmm7, zmm27
    vmulps zmm6, zmm14, [rsp + 3712]
    vpternlogd zmm14{k6}{z}, zmm12, zmm22, 216
    vmaxps zmm0, zmm17, zmm23
    vmovaps zmm3, zmm25
    vfmadd231ps zmm3, zmm16, zmm24
    vmulps zmm4, zmm15, zmm16
    kmovw k1, [rsp + 16]
    vfmadd231ps zmm18, zmm14, [c_mtl1]{1to16}
    vmovups zmm8, [r14 + 640]
    vpsrld zmm13, zmm0, 23
    vpsrld zmm11, zmm0, 19
    vfmadd231ps zmm9, zmm6, [c_mtl1]{1to16}
    vgetmantps zmm5, zmm0, 4
    vbroadcastss zmm7, [c_slkl]
    vmovups zmm12, [rsp + 4288]
    vpermi2ps zmm13, zmm31, zmm30
    vpermps zmm17, zmm11, zmm29
    vfmadd213ps zmm3, zmm16, zmm26
    vpermps zmm14, zmm11, zmm28
    vreduceps zmm6, zmm18, 8
    vcvtps2dq zmm0, zmm18, {rn-sae}
    vfmadd231ps zmm15, zmm4, zmm3
    vmaxps zmm16, zmm12, zmm23
    vpaddd zmm11, zmm0, [c_i64]{1to16}
    vmulps zmm18, zmm13, zmm17
    vmovaps zmm4, zmm25
    vfmadd231ps zmm4, zmm10, zmm24
    vfmsub213ps zmm5, zmm14, zmm27
    vmulps zmm3, zmm1, zmm10
    kmovw k2, [rsp + 12]
    vmovups zmm12, [r14 + 512]
    vandps zmm0, zmm6, [c_absm]{1to16}
    vpminsd zmm13, zmm11, [c_i1023]{1to16}
    vpsrld zmm17, zmm16, 23
    vpsrld zmm14, zmm16, 19
    vgetmantps zmm6, zmm16, 4
    vmovups zmm11, [rsp + 4416]
    vmulps zmm16, zmm15, [rsp + 4224]
    vpternlogd zmm15{k1}{z}, zmm8, zmm22, 216
    vaddps zmm8, zmm0, zmm9
    vpermi2ps zmm17, zmm31, zmm30
    vpermps zmm0, zmm14, zmm29
    vfmadd213ps zmm4, zmm10, zmm26
    vpermps zmm9, zmm14, zmm28
    vmovaps zmm10, zmm25
    vfmadd231ps zmm10, zmm20, zmm24
    vmulps zmm14, zmm15, [c_mtl2]{1to16}
    vmulps zmm15, zmm19, zmm20
    vcmpps k3, zmm8, zmm21, 17
    vfmadd231ps zmm7, zmm16, [c_mtl2]{1to16}
    vmaxps zmm8, zmm11, zmm23
    kmovw k4, [rsp + 14]
    vmovups zmm16, [r14 + 576]
    vfmadd231ps zmm1, zmm3, zmm4
    vmulps zmm11, zmm17, zmm0
    vfmadd213ps zmm10, zmm20, zmm26
    vfmsub213ps zmm6, zmm9, zmm27
    vpsrld zmm3, zmm8, 23
    vpsrld zmm4, zmm8, 19
    vgetmantps zmm17, zmm8, 4
    vpmaxsd zmm2{k3}, zmm13, [c_zero]{1to16}
    kmovw [rsp + r3 + FMR + W/2 + 2], k3
    vmulps zmm0, zmm1, [rsp + 3968]
    vpternlogd zmm1{k2}{z}, zmm12, zmm22, 216
    vpermi2ps zmm3, zmm31, zmm30
    vpermps zmm20, zmm4, zmm29
    vpermps zmm9, zmm4, zmm28
    vfmadd231ps zmm19, zmm15, zmm10
    vpbroadcastd zmm8, [c_m1]
    vmovups zmm13, [rsp + 4672]
    vpmovdw [r11 + W], zmm2
    vfmadd231ps zmm14, zmm1, [c_mtl0]{1to16}
    vfmadd231ps zmm7, zmm0, [c_mtl0]{1to16}
    vmulps zmm12, zmm19, [rsp + 4096]
    vpternlogd zmm19{k4}{z}, zmm16, zmm22, 216
    vfmsub213ps zmm17, zmm9, zmm27
    vmulps zmm4, zmm3, zmm20
    vmaxps zmm15, zmm13, zmm23
    vmovaps zmm10, zmm25
    vfmadd231ps zmm10, zmm5, zmm24
    vmulps zmm2, zmm18, zmm5
    vfmadd231ps zmm14, zmm19, [c_mtl1]{1to16}
    kmovw k5, [rsp + 22]
    vmovups zmm1, [r14 + 896]
    vfmadd231ps zmm7, zmm12, [c_mtl1]{1to16}
    vpsrld zmm0, zmm15, 23
    vpsrld zmm16, zmm15, 19
    vgetmantps zmm9, zmm15, 4
    vbroadcastss zmm3, [c_slkl]
    vmovups zmm20, [rsp + 4800]
    vpermi2ps zmm0, zmm31, zmm30
    vpermps zmm13, zmm16, zmm29
    vfmadd213ps zmm10, zmm5, zmm26
    vreduceps zmm19, zmm14, 8
    vcvtps2dq zmm12, zmm14, {rn-sae}
    vpermps zmm15, zmm16, zmm28
    vmaxps zmm5, zmm20, zmm23
    vpaddd zmm14, zmm12, [c_i64]{1to16}
    vfmadd231ps zmm18, zmm2, zmm10
    vmovaps zmm16, zmm25
    vfmadd231ps zmm16, zmm6, zmm24
    vmulps zmm20, zmm0, zmm13
    vmulps zmm12, zmm11, zmm6
    vfmsub213ps zmm9, zmm15, zmm27
    kmovw k7, [rsp + 18]
    vandps zmm2, zmm19, [c_absm]{1to16}
    vpminsd zmm10, zmm14, [c_i1023]{1to16}
    vpsrld zmm0, zmm5, 23
    vpsrld zmm13, zmm5, 19
    vgetmantps zmm15, zmm5, 4
    vmovups zmm19, [r14 + 768]
    vmovups zmm14, [rsp + 4928]
    vaddps zmm5, zmm2, zmm7
    vmulps zmm2, zmm18, [rsp + 4608]
    vpternlogd zmm18{k5}{z}, zmm1, zmm22, 216
    vpermi2ps zmm0, zmm31, zmm30
    vpermps zmm7, zmm13, zmm29
    vpermps zmm1, zmm13, zmm28
    vfmadd213ps zmm16, zmm6, zmm26
    vmovaps zmm13, zmm25
    vfmadd231ps zmm13, zmm17, zmm24
    vmulps zmm6, zmm18, [c_mtl2]{1to16}
    vmulps zmm18, zmm4, zmm17
    vcmpps k6, zmm5, zmm21, 17
    vfmadd231ps zmm3, zmm2, [c_mtl2]{1to16}
    vmaxps zmm5, zmm14, zmm23
    kmovw k1, [rsp + 20]
    jmp .j2688
.j2688:
    vmovups zmm2, [r14 + 832]
    vfmadd231ps zmm11, zmm12, zmm16
    vfmsub213ps zmm15, zmm1, zmm27
    vmulps zmm14, zmm0, zmm7
    vpsrld zmm12, zmm5, 23
    vpsrld zmm16, zmm5, 19
    vfmadd213ps zmm13, zmm17, zmm26
    vgetmantps zmm1, zmm5, 4
    vpmaxsd zmm8{k6}, zmm10, [c_zero]{1to16}
    kmovw [rsp + r3 + FMR + W/2 + 4], k6
    vpermi2ps zmm12, zmm31, zmm30
    vpermps zmm0, zmm16, zmm29
    vmulps zmm7, zmm11, [rsp + 4352]
    vpternlogd zmm11{k7}{z}, zmm19, zmm22, 216
    vpermps zmm17, zmm16, zmm28
    vpbroadcastd zmm5, [c_m1]
    vmovaps zmm10, zmm25
    vfmadd231ps zmm10, zmm9, zmm24
    vmulps zmm19, zmm20, zmm9
    vpmovdw [r11 + 32], zmm8
    vfmadd231ps zmm4, zmm18, zmm13
    kmovw k3, [rsp + 24]
    vfmadd231ps zmm6, zmm11, [c_mtl0]{1to16}
    vmovups zmm16, [r14 + 1024]
    vmovaps zmm8, zmm25
    vfmadd231ps zmm8, zmm15, zmm24
    vmulps zmm18, zmm14, zmm15
    vfmadd231ps zmm3, zmm7, [c_mtl0]{1to16}
    vmulps zmm13, zmm12, zmm0
    kmovw k2, [rsp + 26]
    vfmsub231ps zmm27, zmm1, zmm17
    vfmadd213ps zmm10, zmm9, zmm26
    vmovups zmm11, [r14 + 1088]
    vmulps zmm7, zmm4, [rsp + 4480]
    vpternlogd zmm4{k1}{z}, zmm2, zmm22, 216
    vfmadd213ps zmm8, zmm15, zmm26
    kmovw k4, [rsp + 28]
    vfmadd231ps zmm6, zmm4, [c_mtl1]{1to16}
    vmovups zmm12, [r14 + 1152]
    vfmadd231ps zmm3, zmm7, [c_mtl1]{1to16}
    vfmadd231ps zmm20, zmm19, zmm10
    vfmadd231ps zmm25, zmm27, zmm24
    vmulps zmm0, zmm13, zmm27
    vfmadd231ps zmm14, zmm18, zmm8
    vbroadcastss zmm1, [c_slkh0]
    vreduceps zmm17, zmm6, 8
    vcvtps2dq zmm9, zmm6, {rn-sae}
    vmulps zmm2, zmm20, [rsp + 4736]
    vpternlogd zmm20{k3}{z}, zmm16, zmm22, 216
    vfmadd231ps zmm26, zmm25, zmm27
    vbroadcastss zmm15, [c_slkh1]
    vmulps zmm4, zmm14, [rsp + 4864]
    vpternlogd zmm14{k2}{z}, zmm11, zmm22, 216
    vpaddd zmm7, zmm9, [c_i64]{1to16}
    vmulps zmm19, zmm20, [c_mth1]{1to16}
    vfmadd231ps zmm1, zmm2, [c_mth1]{1to16}
    vandps zmm10, zmm17, [c_absm]{1to16}
    vpminsd zmm18, zmm7, [c_i1023]{1to16}
    vfmadd231ps zmm13, zmm0, zmm26
    vfmadd231ps zmm19, zmm14, [c_mth2]{1to16}
    vaddps zmm8, zmm10, zmm3
    vfmadd231ps zmm1, zmm4, [c_mth2]{1to16}
    vcmpps k5, zmm8, zmm21, 17
    vmulps zmm6, zmm13, [rsp + 4992]
    vpternlogd zmm13{k4}{z}, zmm12, zmm22, 216
    vfmsub231ps zmm19, zmm13, [c_mth0]{1to16}
    vmulps zmm16, zmm13, [c_mth5]{1to16}
    vfmadd231ps zmm1, zmm6, [c_mth0]{1to16}
    vfmadd231ps zmm15, zmm6, [c_mth5]{1to16}
    vpbroadcastd zmm25, [c_m1]
    vpbroadcastd zmm27, [c_m1]
    vpmaxsd zmm5{k5}, zmm18, [c_zero]{1to16}
    kmovw [rsp + r3 + FMR + W/2 + 6], k5
    vfmadd231ps zmm16, zmm14, [c_mth4]{1to16}
    vreduceps zmm11, zmm19, 8
    vcvtps2dq zmm9, zmm19, {rn-sae}
    vmovups zmm17, [c_pkw]
    vpmovdw [r11 + 32 + W], zmm5
    vfmadd231ps zmm15, zmm4, [c_mth4]{1to16}
    vfmsub231ps zmm16, zmm20, [c_mth0]{1to16}
    vpaddd zmm7, zmm9, [c_i512]{1to16}
    vfmadd231ps zmm15, zmm2, [c_mth0]{1to16}
    vandps zmm0, zmm11, [c_absm]{1to16}
    vpminsd zmm26, zmm7, [c_i1023]{1to16}
    vaddps zmm10, zmm0, zmm1
    vreduceps zmm3, zmm16, 8
    vcvtps2dq zmm8, zmm16, {rn-sae}
    vcmpps k6, zmm10, zmm21, 17
    vpaddd zmm12, zmm8, [c_i512]{1to16}
    vandps zmm13, zmm3, [c_absm]{1to16}
    vpminsd zmm6, zmm12, [c_i1023]{1to16}
    vaddps zmm18, zmm13, zmm15
    vcmpps k7, zmm18, zmm21, 17
    kandw k1, k6, k7
    vpmaxsd zmm27{k7}, zmm6, [c_zero]{1to16}
    vpmaxsd zmm25{k1}, zmm26, [c_zero]{1to16}
    vpermw zmm14, zmm17, zmm27
    kmovw [rsp + r3 + FMR + W/2 + 8], k1
    vpermw zmm19, zmm17, zmm25
    CRST r6, vmovdqu16 [CRS r6], ymm14
    vmovdqu16 [r6], ymm19
    vpternlogd zmm0, zmm0, zmm0, 0xff
    vpcmpw k1, ymm0, [rsp + FMR + W/2], 4
    kortestd k1, k1
    jnz .sff
.sfd:
    cmp dword [rsp + STX + 3264], 0
    je .fe1
    call .f1hl
.fe1:
    cmp dword [rsp + STX + 3272], 0
    je .fe2
    call .f2l
    jmp .fe1
.fe2:
    cmp dword [rsp + STX + 3268], 0
    je .fe3
    call .f1hc
.fe3:
    cmp dword [rsp + STX + 3276], 0
    je .fe4
    call .f2c
    jmp .fe3
.fe4:
    mov rsp, [rsp + 9920]
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
    ret
.cold:
%if M > SPS
.sfs:
    mov [rsp + 9728], r1
    mov [rsp + 9736], r0
    mov [rsp + 9744], r6
    mov [rsp + 9752], r4
    mov [rsp + 9760], r5
    mov [rsp + 9768], r7
    mov [rsp + 9776], r8
    mov [rsp + 9784], r3
    lea r4, [rsp + r3 + FMR + W/2 - 32*SPS]
    vpternlogd zmm0, zmm0, zmm0, 0xff
    vmovdqu16 zmm2, [t_wid]
    vpcmpw k1, zmm0, [r4], 4
    vpcompressw zmm1{k1}{z}, zmm2
    vmovdqu16 [rsp + STX + 1920], zmm1
    kmovd r8d, k1
    popcnt r8d, r8d
    vpaddw zmm2, zmm2, [t_w32]
    vpcmpw k1, zmm0, [r4 + 64], 4
    vpcompressw zmm1{k1}{z}, zmm2
    vmovdqu16 [rsp + r8*2 + STX + 1920], zmm1
    kmovd r6d, k1
    popcnt r6d, r6d
    add r8d, r6d
    vpaddw zmm2, zmm2, [t_w32]
    vpcmpw k1, zmm0, [r4 + 128], 4
    vpcompressw zmm1{k1}{z}, zmm2
    vmovdqu16 [rsp + r8*2 + STX + 1920], zmm1
    kmovd r6d, k1
    popcnt r6d, r6d
    add r8d, r6d
    vpaddw zmm2, zmm2, [t_w32]
    vpcmpw k1, zmm0, [r4 + 192], 4
    vpcompressw zmm1{k1}{z}, zmm2
    vmovdqu16 [rsp + r8*2 + STX + 1920], zmm1
    kmovd r6d, k1
    popcnt r6d, r6d
    add r8d, r6d
    vpaddw zmm2, zmm2, [t_w32]
    vpcmpw k1, zmm0, [r4 + 256], 4
    vpcompressw zmm1{k1}{z}, zmm2
    vmovdqu16 [rsp + r8*2 + STX + 1920], zmm1
    kmovd r6d, k1
    popcnt r6d, r6d
    add r8d, r6d
    vpaddw zmm2, zmm2, [t_w32]
    vpcmpw k1, zmm0, [r4 + 320], 4
    vpcompressw zmm1{k1}{z}, zmm2
    vmovdqu16 [rsp + r8*2 + STX + 1920], zmm1
    kmovd r6d, k1
    popcnt r6d, r6d
    add r8d, r6d
    vpaddw zmm2, zmm2, [t_w32]
    vpcmpw k1, zmm0, [r4 + 384], 4
    vpcompressw zmm1{k1}{z}, zmm2
    vmovdqu16 [rsp + r8*2 + STX + 1920], zmm1
    kmovd r6d, k1
    popcnt r6d, r6d
    add r8d, r6d
    vpaddw zmm2, zmm2, [t_w32]
    vpcmpw k1, zmm0, [r4 + 448], 4
    vpcompressw zmm1{k1}{z}, zmm2
    vmovdqu16 [rsp + r8*2 + STX + 1920], zmm1
    kmovd r6d, k1
    popcnt r6d, r6d
    add r8d, r6d
    lea r0, [r13 + 40*(-32*SPS) - 1280]
    mov [rsp + 9976], r0
    lea r1, [r9 + 2*(-32*SPS) - 64]
    sub r1, [rsp + 9928]
    mov [rsp + 9984], r1
    lea r6, [r10 - 32*SPS - 32]
    sub r6, [rsp + 9928]
    mov [rsp + 9992], r6
    mov r6, [rsp + 9952]
    sub r6, [rsp + 9928]
    mov [rsp + 10008], r6
    mov r6, [rsp + 9960]
    sub r6, [rsp + 9928]
    mov [rsp + 10016], r6
    mov qword [rsp + 9968], .sbs
    jmp .sfw
%endif
.sfp:
    mov [rsp + 9728], r1
    mov [rsp + 9736], r0
    mov [rsp + 9744], r6
    mov [rsp + 9752], r4
    mov [rsp + 9760], r5
    mov [rsp + 9768], r7
    mov [rsp + 9776], r8
    mov [rsp + 9784], r3
    lea r4, [rsp + FMR + W/2 - 32*SLST]
%if NCL == 1
    vmovdqu16 zmm2, [t_wid]
    vpcompressw zmm1{k1}{z}, zmm2
    vmovdqu16 [rsp + STX + 1920], zmm1
    kmovd r8d, k1
    popcnt r8d, r8d
%elif NCL == 2
    vmovdqu16 zmm2, [t_wid]
    vpcompressw zmm1{k1}{z}, zmm2
    vmovdqu16 [rsp + STX + 1920], zmm1
    kmovd r8d, k1
    popcnt r8d, r8d
    vpaddw zmm2, zmm2, [t_w32]
    vpcompressw zmm1{k2}{z}, zmm2
    vmovdqu16 [rsp + r8*2 + STX + 1920], zmm1
    kmovd r6d, k2
    popcnt r6d, r6d
    add r8d, r6d
%else
    vpternlogd zmm0, zmm0, zmm0, 0xff
    vmovdqu16 zmm2, [t_wid]
    vpcmpw k1, zmm0, [r4], 4
    vpcompressw zmm1{k1}{z}, zmm2
    vmovdqu16 [rsp + STX + 1920], zmm1
    kmovd r8d, k1
    popcnt r8d, r8d
%assign ci 1
%rep NCL - 1
    vpaddw zmm2, zmm2, [t_w32]
    vpcmpw k1, zmm0, [r4 + 64*ci], 4
    vpcompressw zmm1{k1}{z}, zmm2
    vmovdqu16 [rsp + r8*2 + STX + 1920], zmm1
    kmovd r6d, k1
    popcnt r6d, r6d
    add r8d, r6d
%assign ci ci + 1
%endrep
%endif
    lea r0, [r13 + 40*(-32*SLST) - 1280]
    mov [rsp + 9976], r0
    lea r1, [r9 + 2*(-32*SLST) - 64]
    sub r1, [rsp + 9928]
    mov [rsp + 9984], r1
    lea r6, [r10 - 32*SLST - 32]
    sub r6, [rsp + 9928]
    mov [rsp + 9992], r6
    mov r6, [rsp + 9952]
    sub r6, [rsp + 9928]
    mov [rsp + 10008], r6
    mov r6, [rsp + 9960]
    sub r6, [rsp + 9928]
    mov [rsp + 10016], r6
    mov qword [rsp + 9968], .scr
    jmp .sfw
.sff:
    mov [rsp + 9728], r1
    mov [rsp + 9736], r0
    mov [rsp + 9744], r6
    mov [rsp + 9752], r4
    mov [rsp + 9760], r5
    mov [rsp + 9768], r7
    mov [rsp + 9776], r8
    mov [rsp + 9784], r3
    lea r4, [rsp + FMR + W/2]
    vmovdqu16 zmm2, [t_wid]
    vpcompressw zmm1{k1}{z}, zmm2
    vmovdqu16 [rsp + STX + 1920], zmm1
    kmovd r8d, k1
    popcnt r8d, r8d
    mov [rsp + 9944], r14
    mov r1, r11
    sub r1, [rsp + 9928]
    mov [rsp + 10008], r1
    mov r0, r6
    sub r0, [rsp + 9928]
    mov [rsp + 10016], r0
    mov qword [rsp + 9968], .sfd
.sfw:
    xor r3d, r3d
.sb:
    movzx r6d, word [rsp + r3*2 + STX + 1920]
    movzx r2d, word [r4 + r6*2]
    xor r2d, 0xffff
    kmovw k1, r2d
    popcnt r2d, r2d
    mov r5d, r6d
    and r5d, 15
    shr r6d, 4
    imul r0, r6, 1280
    add r0, [rsp + 9976]
    cmp r5d, 4
    je .sjc
    imul r1d, r6d, 64
    add r1, [rsp + 9984]
    test r6d, r6d
    cmovz r0, [rsp + 9944]
    cmovz r1, [rsp + 10008]
    add r1, [t_lof + r5*8]
    shl r5d, 8
    add r0, r5
    mov r7d, [rsp + STX + 3264]
    vmovups zmm1, [r0]
    vcompressps zmm1{k1}{z}, zmm1
    vmovups [rsp + r7*4 + STX], zmm1
    vmovups zmm1, [r0 + 64]
    vcompressps zmm1{k1}{z}, zmm1
    vmovups [rsp + r7*4 + STX + 128], zmm1
    vmovups zmm1, [r0 + 128]
    vcompressps zmm1{k1}{z}, zmm1
    vmovups [rsp + r7*4 + STX + 256], zmm1
    vmovups zmm1, [r0 + 192]
    vcompressps zmm1{k1}{z}, zmm1
    vmovups [rsp + r7*4 + STX + 384], zmm1
    vpbroadcastd zmm1, r1d
    vpaddd zmm1, zmm1, [t_l2d]
    vpcompressd zmm1{k1}{z}, zmm1
    vmovdqu32 [rsp + r7*4 + STX + 1024], zmm1
    add r7d, r2d
    mov [rsp + STX + 3264], r7d
    cmp r7d, 16
    jb .sjn
    call .f1l
.swl:
    cmp dword [rsp + STX + 3272], 8
    jb .sjn
    call .f2l
    jmp .swl
.sjc:
    imul r1d, r6d, 32
    add r1, [rsp + 9992]
    test r6d, r6d
    cmovz r0, [rsp + 9944]
    cmovz r1, [rsp + 10016]
    add r0, 1024
    mov r7d, [rsp + STX + 3268]
    vmovups zmm1, [r0]
    vcompressps zmm1{k1}{z}, zmm1
    vmovups [rsp + r7*4 + STX + 512], zmm1
    vmovups zmm1, [r0 + 64]
    vcompressps zmm1{k1}{z}, zmm1
    vmovups [rsp + r7*4 + STX + 640], zmm1
    vmovups zmm1, [r0 + 128]
    vcompressps zmm1{k1}{z}, zmm1
    vmovups [rsp + r7*4 + STX + 768], zmm1
    vmovups zmm1, [r0 + 192]
    vcompressps zmm1{k1}{z}, zmm1
    vmovups [rsp + r7*4 + STX + 896], zmm1
    vpbroadcastd zmm1, r1d
    vpaddd zmm1, zmm1, [t_c2d]
    vpcompressd zmm1{k1}{z}, zmm1
    vmovdqu32 [rsp + r7*4 + STX + 1280], zmm1
    add r7d, r2d
    mov [rsp + STX + 3268], r7d
    cmp r7d, 16
    jb .sjn
    call .f1c
.swc:
    cmp dword [rsp + STX + 3276], 8
    jb .sjn
    call .f2c
    jmp .swc
.sjn:
    inc r3d
    cmp r3d, r8d
    jb .sb
    mov r1, [rsp + 9728]
    mov r0, [rsp + 9736]
    mov r6, [rsp + 9744]
    mov r4, [rsp + 9752]
    mov r5, [rsp + 9760]
    mov r7, [rsp + 9768]
    mov r8, [rsp + 9776]
    mov r3, [rsp + 9784]
    jmp [rsp + 9968]
.f1l:
    push r10
    mov r10, rsp
    push r6
    push r9
    push r3
    push r2
    push r1
    push r0
    push r4
    push r5
    push r7
    push r8
    push r13
    lea r7, [rsp - TSZ]
    and r7, -64
    lea rsp, [r7 - 64]
    lea r0, [r10 + 16 + STX]
    call .t1l
    vmovdqu64 [r7 + T_ZS], zmm4
    lea r0, [r10 + 16 + STX + 32]
    call .t1l
    vmovdqu64 [r7 + T_ZS + 64], zmm4
    vpmovq2m k2, zmm4
    vmovdqu64 zmm5, [r7 + T_ZS]
    vpmovq2m k1, zmm5
    kunpckbw k1, k2, k1
    vmovdqu32 zmm6, [r10 + 16 + STX + 1024]
    mov r3d, [r10 + 16 + STX + 3272]
    vpcompressd zmm7{k1}{z}, zmm6
    vmovdqu32 [r10 + 16 + STX + 1536 + r3*4], zmm7
    kmovw r6d, k1
    popcnt r6d, r6d
    add r6d, r3d
    mov [r10 + 16 + STX + 3272], r6d
    mov r1, [r10 + 16 + S_DST]
    mov r8d, [r10 + 16 + STX + 1024]
    movzx r6d, word [r7 + T_ZS]
    mov [r1 + r8], r6w
    mov r8d, [r10 + 16 + STX + 1028]
    movzx r6d, word [r7 + T_ZS + 8]
    mov [r1 + r8], r6w
    mov r8d, [r10 + 16 + STX + 1032]
    movzx r6d, word [r7 + T_ZS + 16]
    mov [r1 + r8], r6w
    mov r8d, [r10 + 16 + STX + 1036]
    movzx r6d, word [r7 + T_ZS + 24]
    mov [r1 + r8], r6w
    mov r8d, [r10 + 16 + STX + 1040]
    movzx r6d, word [r7 + T_ZS + 32]
    mov [r1 + r8], r6w
    mov r8d, [r10 + 16 + STX + 1044]
    movzx r6d, word [r7 + T_ZS + 40]
    mov [r1 + r8], r6w
    mov r8d, [r10 + 16 + STX + 1048]
    movzx r6d, word [r7 + T_ZS + 48]
    mov [r1 + r8], r6w
    mov r8d, [r10 + 16 + STX + 1052]
    movzx r6d, word [r7 + T_ZS + 56]
    mov [r1 + r8], r6w
    mov r8d, [r10 + 16 + STX + 1056]
    movzx r6d, word [r7 + T_ZS + 64]
    mov [r1 + r8], r6w
    mov r8d, [r10 + 16 + STX + 1060]
    movzx r6d, word [r7 + T_ZS + 72]
    mov [r1 + r8], r6w
    mov r8d, [r10 + 16 + STX + 1064]
    movzx r6d, word [r7 + T_ZS + 80]
    mov [r1 + r8], r6w
    mov r8d, [r10 + 16 + STX + 1068]
    movzx r6d, word [r7 + T_ZS + 88]
    mov [r1 + r8], r6w
    mov r8d, [r10 + 16 + STX + 1072]
    movzx r6d, word [r7 + T_ZS + 96]
    mov [r1 + r8], r6w
    mov r8d, [r10 + 16 + STX + 1076]
    movzx r6d, word [r7 + T_ZS + 104]
    mov [r1 + r8], r6w
    mov r8d, [r10 + 16 + STX + 1080]
    movzx r6d, word [r7 + T_ZS + 112]
    mov [r1 + r8], r6w
    mov r8d, [r10 + 16 + STX + 1084]
    movzx r6d, word [r7 + T_ZS + 120]
    mov [r1 + r8], r6w
    sub dword [r10 + 16 + STX + 3264], 16
    vmovups zmm1, [r10 + 16 + STX + 64]
    vmovups [r10 + 16 + STX], zmm1
    vmovups zmm1, [r10 + 16 + STX + 192]
    vmovups [r10 + 16 + STX + 128], zmm1
    vmovups zmm1, [r10 + 16 + STX + 320]
    vmovups [r10 + 16 + STX + 256], zmm1
    vmovups zmm1, [r10 + 16 + STX + 448]
    vmovups [r10 + 16 + STX + 384], zmm1
    vmovdqu32 zmm1, [r10 + 16 + STX + 1088]
    vmovdqu32 [r10 + 16 + STX + 1024], zmm1
    lea rsp, [r10 - 88]
    pop r13
    pop r8
    pop r7
    pop r5
    pop r4
    pop r0
    pop r1
    pop r2
    pop r3
    pop r9
    pop r6
    pop r10
    ret
.f1hl:
    push r10
    mov r10, rsp
    push r6
    push r9
    push r3
    push r2
    push r1
    push r0
    push r4
    push r5
    push r7
    push r8
    push r13
    lea r7, [rsp - TSZ]
    and r7, -64
    lea rsp, [r7 - 64]
    lea r0, [r10 + 16 + STX]
    call .t1l
    vmovdqu64 [r7 + T_ZS], zmm4
    cmp dword [r10 + 16 + STX + 3264], 8
    jbe .f1hla
    lea r0, [r10 + 16 + STX + 32]
    call .t1l
    vmovdqu64 [r7 + T_ZS + 64], zmm4
.f1hla:
    mov r13d, [r10 + 16 + STX + 3264]
    xor r9d, r9d
    mov r3d, [r10 + 16 + STX + 3272]
    mov r1, [r10 + 16 + S_DST]
.f1hll:
    mov r8d, [r10 + 16 + STX + 1024 + r9*4]
    mov r6, [r7 + T_ZS + r9*8]
    mov [r1 + r8], r6w
    mov [r10 + 16 + STX + 1536 + r3*4], r8d
    shr r6, 63
    add r3d, r6d
    inc r9d
    cmp r9d, r13d
    jb .f1hll
    mov [r10 + 16 + STX + 3272], r3d
    mov dword [r10 + 16 + STX + 3264], 0
    lea rsp, [r10 - 88]
    pop r13
    pop r8
    pop r7
    pop r5
    pop r4
    pop r0
    pop r1
    pop r2
    pop r3
    pop r9
    pop r6
    pop r10
    ret
.f2l:
    push r10
    mov r10, rsp
    push r6
    push r9
    push r3
    push r2
    push r1
    push r0
    push r4
    push r5
    push r7
    push r8
    push r13
    lea r7, [rsp - TSZ]
    and r7, -64
    lea rsp, [r7 - 64]
    mov r13d, [r10 + 16 + STX + 3272]
    mov r6d, 8
    cmp r13d, r6d
    cmova r13d, r6d
    xor r9d, r9d
    cmp r13d, 2
    jbe .f2lx
.f2lg:
    mov r8d, [r10 + 16 + STX + 1536 + r9*4]
    mov r6d, r8d
    shr r6d, 1
    mov r2d, r6d
    shr r2d, 5
    imul r2, r2, MG
    shr r2, 32
    imul r3d, r2d, 32*M
    sub r6d, r3d
    mov [r7 + T_J], r2d
    add r8, [r10 + 16 + S_DST]
    lea r5d, [r9*8]
    call .q2l
    inc r9d
    cmp r9d, r13d
    jb .f2lg
    call .w2l
    xor r9d, r9d
    vmovdqu64 [r7 + T_ZS], zmm4
.f2ll:
    mov r8d, [r10 + 16 + STX + 1536 + r9*4]
    mov r6, [r7 + T_ZS + r9*8]
    test r6, r6
    js .f2lt
    add r8, [r10 + 16 + S_DST]
.f2ls:
    mov [r8], r6w
    inc r9d
    cmp r9d, r13d
    jb .f2ll
.f2le:
    mov r6d, [r10 + 16 + STX + 3272]
    sub r6d, r13d
    mov [r10 + 16 + STX + 3272], r6d
    vmovdqu32 zmm1, [r10 + 16 + STX + 1568]
    vmovdqu32 [r10 + 16 + STX + 1536], zmm1
    lea rsp, [r10 - 88]
    pop r13
    pop r8
    pop r7
    pop r5
    pop r4
    pop r0
    pop r1
    pop r2
    pop r3
    pop r9
    pop r6
    pop r10
    ret
.f2lt:
    mov r6d, r8d
    shr r6d, 1
    mov r2d, r6d
    shr r2d, 5
    imul r2, r2, MG
    shr r2, 32
    imul r3d, r2d, 32*M
    sub r6d, r3d
    mov [r7 + T_J], r2d
    add r8, [r10 + 16 + S_DST]
    call .c2l
    call .t3l
    jmp .f2ls
.f2lx:
    mov r8d, [r10 + 16 + STX + 1536 + r9*4]
    mov r6d, r8d
    shr r6d, 1
    mov r2d, r6d
    shr r2d, 5
    imul r2, r2, MG
    shr r2, 32
    imul r3d, r2d, 32*M
    sub r6d, r3d
    mov [r7 + T_J], r2d
    add r8, [r10 + 16 + S_DST]
    call .c2l
    call .t2l
    test r6d, r6d
    jns .f2ly
    call .t3l
.f2ly:
    mov [r8], r6w
    inc r9d
    cmp r9d, r13d
    jb .f2lx
    jmp .f2le
.f1c:
    push r10
    mov r10, rsp
    push r6
    push r9
    push r3
    push r2
    push r1
    push r0
    push r4
    push r5
    push r7
    push r8
    push r13
    lea r7, [rsp - TSZ]
    and r7, -64
    lea rsp, [r7 - 64]
    lea r0, [r10 + 16 + STX + 512]
    call .t1c
    vmovdqu64 [r7 + T_ZS], zmm4
    vmovdqu64 [r7 + T_ZS + 128], zmm5
    lea r0, [r10 + 16 + STX + 544]
    call .t1c
    vmovdqu64 [r7 + T_ZS + 64], zmm4
    vmovdqu64 [r7 + T_ZS + 192], zmm5
    vpmovq2m k2, zmm4
    vmovdqu64 zmm5, [r7 + T_ZS]
    vpmovq2m k1, zmm5
    kunpckbw k1, k2, k1
    vmovdqu32 zmm6, [r10 + 16 + STX + 1280]
    mov r3d, [r10 + 16 + STX + 3276]
    vpcompressd zmm7{k1}{z}, zmm6
    vmovdqu32 [r10 + 16 + STX + 1728 + r3*4], zmm7
    kmovw r6d, k1
    popcnt r6d, r6d
    add r6d, r3d
    mov [r10 + 16 + STX + 3276], r6d
    mov r1, [r10 + 16 + S_DST]
    mov r8d, [r10 + 16 + STX + 1280]
    movzx r6d, word [r7 + T_ZS]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 128]
    CRST r1, mov [CRS r1 + r8], r2w
    mov r8d, [r10 + 16 + STX + 1284]
    movzx r6d, word [r7 + T_ZS + 8]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 136]
    CRST r1, mov [CRS r1 + r8], r2w
    mov r8d, [r10 + 16 + STX + 1288]
    movzx r6d, word [r7 + T_ZS + 16]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 144]
    CRST r1, mov [CRS r1 + r8], r2w
    mov r8d, [r10 + 16 + STX + 1292]
    movzx r6d, word [r7 + T_ZS + 24]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 152]
    CRST r1, mov [CRS r1 + r8], r2w
    mov r8d, [r10 + 16 + STX + 1296]
    movzx r6d, word [r7 + T_ZS + 32]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 160]
    CRST r1, mov [CRS r1 + r8], r2w
    mov r8d, [r10 + 16 + STX + 1300]
    movzx r6d, word [r7 + T_ZS + 40]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 168]
    CRST r1, mov [CRS r1 + r8], r2w
    mov r8d, [r10 + 16 + STX + 1304]
    movzx r6d, word [r7 + T_ZS + 48]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 176]
    CRST r1, mov [CRS r1 + r8], r2w
    mov r8d, [r10 + 16 + STX + 1308]
    movzx r6d, word [r7 + T_ZS + 56]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 184]
    CRST r1, mov [CRS r1 + r8], r2w
    mov r8d, [r10 + 16 + STX + 1312]
    movzx r6d, word [r7 + T_ZS + 64]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 192]
    CRST r1, mov [CRS r1 + r8], r2w
    mov r8d, [r10 + 16 + STX + 1316]
    movzx r6d, word [r7 + T_ZS + 72]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 200]
    CRST r1, mov [CRS r1 + r8], r2w
    mov r8d, [r10 + 16 + STX + 1320]
    movzx r6d, word [r7 + T_ZS + 80]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 208]
    CRST r1, mov [CRS r1 + r8], r2w
    mov r8d, [r10 + 16 + STX + 1324]
    movzx r6d, word [r7 + T_ZS + 88]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 216]
    CRST r1, mov [CRS r1 + r8], r2w
    mov r8d, [r10 + 16 + STX + 1328]
    movzx r6d, word [r7 + T_ZS + 96]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 224]
    CRST r1, mov [CRS r1 + r8], r2w
    mov r8d, [r10 + 16 + STX + 1332]
    movzx r6d, word [r7 + T_ZS + 104]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 232]
    CRST r1, mov [CRS r1 + r8], r2w
    mov r8d, [r10 + 16 + STX + 1336]
    movzx r6d, word [r7 + T_ZS + 112]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 240]
    CRST r1, mov [CRS r1 + r8], r2w
    mov r8d, [r10 + 16 + STX + 1340]
    movzx r6d, word [r7 + T_ZS + 120]
    mov [r1 + r8], r6w
    movzx r2d, word [r7 + T_ZS + 248]
    CRST r1, mov [CRS r1 + r8], r2w
    sub dword [r10 + 16 + STX + 3268], 16
    vmovups zmm1, [r10 + 16 + STX + 576]
    vmovups [r10 + 16 + STX + 512], zmm1
    vmovups zmm1, [r10 + 16 + STX + 704]
    vmovups [r10 + 16 + STX + 640], zmm1
    vmovups zmm1, [r10 + 16 + STX + 832]
    vmovups [r10 + 16 + STX + 768], zmm1
    vmovups zmm1, [r10 + 16 + STX + 960]
    vmovups [r10 + 16 + STX + 896], zmm1
    vmovdqu32 zmm1, [r10 + 16 + STX + 1344]
    vmovdqu32 [r10 + 16 + STX + 1280], zmm1
    lea rsp, [r10 - 88]
    pop r13
    pop r8
    pop r7
    pop r5
    pop r4
    pop r0
    pop r1
    pop r2
    pop r3
    pop r9
    pop r6
    pop r10
    ret
.f1hc:
    push r10
    mov r10, rsp
    push r6
    push r9
    push r3
    push r2
    push r1
    push r0
    push r4
    push r5
    push r7
    push r8
    push r13
    lea r7, [rsp - TSZ]
    and r7, -64
    lea rsp, [r7 - 64]
    lea r0, [r10 + 16 + STX + 512]
    call .t1c
    vmovdqu64 [r7 + T_ZS], zmm4
    vmovdqu64 [r7 + T_ZS + 128], zmm5
    cmp dword [r10 + 16 + STX + 3268], 8
    jbe .f1hca
    lea r0, [r10 + 16 + STX + 544]
    call .t1c
    vmovdqu64 [r7 + T_ZS + 64], zmm4
    vmovdqu64 [r7 + T_ZS + 192], zmm5
.f1hca:
    mov r13d, [r10 + 16 + STX + 3268]
    xor r9d, r9d
    mov r3d, [r10 + 16 + STX + 3276]
    mov r1, [r10 + 16 + S_DST]
.f1hcl:
    mov r8d, [r10 + 16 + STX + 1280 + r9*4]
    mov r6, [r7 + T_ZS + r9*8]
    mov [r1 + r8], r6w
    mov r2, [r7 + T_ZS + 128 + r9*8]
    CRST r1, mov [CRS r1 + r8], r2w
    mov [r10 + 16 + STX + 1728 + r3*4], r8d
    shr r6, 63
    add r3d, r6d
    inc r9d
    cmp r9d, r13d
    jb .f1hcl
    mov [r10 + 16 + STX + 3276], r3d
    mov dword [r10 + 16 + STX + 3268], 0
    lea rsp, [r10 - 88]
    pop r13
    pop r8
    pop r7
    pop r5
    pop r4
    pop r0
    pop r1
    pop r2
    pop r3
    pop r9
    pop r6
    pop r10
    ret
.f2c:
    push r10
    mov r10, rsp
    push r6
    push r9
    push r3
    push r2
    push r1
    push r0
    push r4
    push r5
    push r7
    push r8
    push r13
    lea r7, [rsp - TSZ]
    and r7, -64
    lea rsp, [r7 - 64]
    mov r13d, [r10 + 16 + STX + 3276]
    mov r6d, 8
    cmp r13d, r6d
    cmova r13d, r6d
    xor r9d, r9d
    cmp r13d, 4
    jbe .f2cx
.f2cg:
    mov r8d, [r10 + 16 + STX + 1728 + r9*4]
    mov r6d, r8d
    sub r6d, [dp + 16]
    shr r6d, 1
    mov r2d, r6d
    shr r2d, 4
    imul r2, r2, MG
    shr r2, 32
    imul r3d, r2d, 16*M
    sub r6d, r3d
    mov [r7 + T_J], r2d
    add r8, [r10 + 16 + S_DST]
    lea r5d, [r9*8]
    call .q2c
    inc r9d
    cmp r9d, r13d
    jb .f2cg
    call .w2c
    xor r9d, r9d
    vmovdqu64 [r7 + T_ZS], zmm4
.f2cl:
    mov r8d, [r10 + 16 + STX + 1728 + r9*4]
    mov r6, [r7 + T_ZS + r9*8]
    test r6, r6
    js .f2ct
    add r8, [r10 + 16 + S_DST]
.f2cs:
    mov [r8], r6w
    shr r6d, 16
    CRST r8, mov [CRS r8], r6w
    inc r9d
    cmp r9d, r13d
    jb .f2cl
.f2ce:
    mov r6d, [r10 + 16 + STX + 3276]
    sub r6d, r13d
    mov [r10 + 16 + STX + 3276], r6d
    vmovdqu32 zmm1, [r10 + 16 + STX + 1760]
    vmovdqu32 [r10 + 16 + STX + 1728], zmm1
    lea rsp, [r10 - 88]
    pop r13
    pop r8
    pop r7
    pop r5
    pop r4
    pop r0
    pop r1
    pop r2
    pop r3
    pop r9
    pop r6
    pop r10
    ret
.f2ct:
    mov r6d, r8d
    sub r6d, [dp + 16]
    shr r6d, 1
    mov r2d, r6d
    shr r2d, 4
    imul r2, r2, MG
    shr r2, 32
    imul r3d, r2d, 16*M
    sub r6d, r3d
    mov [r7 + T_J], r2d
    add r8, [r10 + 16 + S_DST]
    call .c2c
    call .t3c
    jmp .f2cs
.f2cx:
    mov r8d, [r10 + 16 + STX + 1728 + r9*4]
    mov r6d, r8d
    sub r6d, [dp + 16]
    shr r6d, 1
    mov r2d, r6d
    shr r2d, 4
    imul r2, r2, MG
    shr r2, 32
    imul r3d, r2d, 16*M
    sub r6d, r3d
    mov [r7 + T_J], r2d
    add r8, [r10 + 16 + S_DST]
    call .c2c
    call .t2c
    test r6d, r6d
    jns .f2cy
    call .t3c
.f2cy:
    mov [r8], r6w
    shr r6d, 16
    CRST r8, mov [CRS r8], r6w
    inc r9d
    cmp r9d, r13d
    jb .f2cx
    jmp .f2ce
T_ZS equ 0
T_Z2 equ 1024
T_LO equ 2368
T_HI equ 2560
T_SY equ 2752
T_SB equ 2880
T_SR equ 3008
T_VB equ 3136
T_LV equ 3200
T_TV equ 3264
T_AA equ 3328
T_LA equ 3392
T_LN equ 3456
T_V equ 3648
T_X equ 4416
T_ACC equ 5184
T_E equ 5312
T_WY equ 5504
T_WB equ 6528
T_WR equ 7552
T_WS equ 8576
T_WE equ 10112
T_WAA equ 11648
T_WLA equ 11840
T_WLO equ 12032
T_WHI equ 12224
T_J equ 12416
T_L equ 12424
T_XL equ 12432
TSZ equ 12544
.t1l:
    vcvtps2pd zmm15, [r0 + 384]
    vbroadcastsd zmm14, [t_epsn]
    vsubpd zmm14, zmm14, zmm15
    vrsqrt14pd zmm13, zmm14
    vbroadcastsd zmm12, [t_snegl]
    vfmadd213pd zmm13, zmm12, [t_anegl]{1to8}
    vfmadd213pd zmm13, zmm14, [t_tabsl]{1to8}
    vmovapd zmm15, zmm13
    vcvtps2pd zmm0, [r0]
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm2, [t_rgl0]{1to8}
    vsubpd zmm4, zmm2, zmm3
    vcmppd k1, zmm4, zmm3, 0x1e
    vaddpd zmm5, zmm2, zmm3
    vmovapd zmm5{k1}, zmm2
    vpsrlq zmm1, zmm5, 48
    vmovapd zmm10, [t_rx]
    vpermt2pd zmm10, zmm1, [t_rx + 64]
    vgetmantpd zmm2, zmm5, 4
    vfmsub213pd zmm2, zmm10, [t_one]{1to8}
    vmulpd zmm7, zmm2, zmm2
    vpsrlq zmm8, zmm5, 52
    vmovapd zmm6, [t_oa]
    vpermt2pd zmm6, zmm8, [t_oa + 64]
    vpsrlq zmm9, zmm5, 56
    vpermpd zmm9, zmm9, [t_ob]
    vmovapd zmm10, [t_ow]
    vpermt2pd zmm10, zmm1, [t_ow + 64]
    vbroadcastsd zmm11, [t_op3]
    vfmadd213pd zmm11, zmm2, [t_op2]{1to8}
    vbroadcastsd zmm8, [t_op4]
    vfmadd213pd zmm8, zmm7, zmm11
    vbroadcastsd zmm11, [t_op1]
    vfmadd213pd zmm11, zmm2, [t_op0]{1to8}
    vfmadd213pd zmm8, zmm7, zmm11
    vmulpd zmm6, zmm6, zmm9
    vmulpd zmm6, zmm6, zmm10
    vmulpd zmm6, zmm6, zmm8
    vrcp14pd zmm7, zmm4
    vmulpd zmm7{k1}{z}, zmm3, zmm7
    vbroadcastsd zmm11, [t_omg]
    vfmadd132pd zmm7, zmm11, [t_eq0]{1to8}
    vmovapd zmm17, zmm6
    vfmadd231pd zmm17, zmm7, zmm6
    vpxorq zmm9, zmm17, [t_sign]{1to8}
    vmovapd zmm16, zmm6
    vfnmadd231pd zmm16{k1}{z}, zmm7, zmm6
    vcmppd k2, zmm4, [t_zero]{1to8}, 0x1a
    vmovapd zmm16{k2}, zmm9
    vpxorq zmm12, zmm16, [t_sign]{1to8}
    vpmovq2m k3, zmm0
    vmovapd zmm16{k3}, zmm9
    vmovapd zmm17{k3}, zmm12
    vcvtps2pd zmm0, [r0 + 128]
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm2, [t_rgl1]{1to8}
    vsubpd zmm4, zmm2, zmm3
    vcmppd k1, zmm4, zmm3, 0x1e
    vaddpd zmm5, zmm2, zmm3
    vmovapd zmm5{k1}, zmm2
    vpsrlq zmm1, zmm5, 48
    vmovapd zmm10, [t_rx]
    vpermt2pd zmm10, zmm1, [t_rx + 64]
    vgetmantpd zmm2, zmm5, 4
    vfmsub213pd zmm2, zmm10, [t_one]{1to8}
    vmulpd zmm7, zmm2, zmm2
    vpsrlq zmm8, zmm5, 52
    vmovapd zmm6, [t_oa]
    vpermt2pd zmm6, zmm8, [t_oa + 64]
    vpsrlq zmm9, zmm5, 56
    vpermpd zmm9, zmm9, [t_ob]
    vmovapd zmm10, [t_ow]
    vpermt2pd zmm10, zmm1, [t_ow + 64]
    vbroadcastsd zmm11, [t_op3]
    vfmadd213pd zmm11, zmm2, [t_op2]{1to8}
    vbroadcastsd zmm8, [t_op4]
    vfmadd213pd zmm8, zmm7, zmm11
    vbroadcastsd zmm11, [t_op1]
    vfmadd213pd zmm11, zmm2, [t_op0]{1to8}
    vfmadd213pd zmm8, zmm7, zmm11
    vmulpd zmm6, zmm6, zmm9
    vmulpd zmm6, zmm6, zmm10
    vmulpd zmm6, zmm6, zmm8
    vrcp14pd zmm7, zmm4
    vmulpd zmm7{k1}{z}, zmm3, zmm7
    vbroadcastsd zmm11, [t_omg]
    vfmadd132pd zmm7, zmm11, [t_eq0]{1to8}
    vmovapd zmm19, zmm6
    vfmadd231pd zmm19, zmm7, zmm6
    vpxorq zmm9, zmm19, [t_sign]{1to8}
    vmovapd zmm18, zmm6
    vfnmadd231pd zmm18{k1}{z}, zmm7, zmm6
    vcmppd k2, zmm4, [t_zero]{1to8}, 0x1a
    vmovapd zmm18{k2}, zmm9
    vpxorq zmm12, zmm18, [t_sign]{1to8}
    vpmovq2m k3, zmm0
    vmovapd zmm18{k3}, zmm9
    vmovapd zmm19{k3}, zmm12
    vcvtps2pd zmm0, [r0 + 256]
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm2, [t_rgl2]{1to8}
    vsubpd zmm4, zmm2, zmm3
    vcmppd k1, zmm4, zmm3, 0x1e
    vaddpd zmm5, zmm2, zmm3
    vmovapd zmm5{k1}, zmm2
    vpsrlq zmm1, zmm5, 48
    vmovapd zmm10, [t_rx]
    vpermt2pd zmm10, zmm1, [t_rx + 64]
    vgetmantpd zmm2, zmm5, 4
    vfmsub213pd zmm2, zmm10, [t_one]{1to8}
    vmulpd zmm7, zmm2, zmm2
    vpsrlq zmm8, zmm5, 52
    vmovapd zmm6, [t_oa]
    vpermt2pd zmm6, zmm8, [t_oa + 64]
    vpsrlq zmm9, zmm5, 56
    vpermpd zmm9, zmm9, [t_ob]
    vmovapd zmm10, [t_ow]
    vpermt2pd zmm10, zmm1, [t_ow + 64]
    vbroadcastsd zmm11, [t_op3]
    vfmadd213pd zmm11, zmm2, [t_op2]{1to8}
    vbroadcastsd zmm8, [t_op4]
    vfmadd213pd zmm8, zmm7, zmm11
    vbroadcastsd zmm11, [t_op1]
    vfmadd213pd zmm11, zmm2, [t_op0]{1to8}
    vfmadd213pd zmm8, zmm7, zmm11
    vmulpd zmm6, zmm6, zmm9
    vmulpd zmm6, zmm6, zmm10
    vmulpd zmm6, zmm6, zmm8
    vrcp14pd zmm7, zmm4
    vmulpd zmm7{k1}{z}, zmm3, zmm7
    vbroadcastsd zmm11, [t_omg]
    vfmadd132pd zmm7, zmm11, [t_eq0]{1to8}
    vmovapd zmm21, zmm6
    vfmadd231pd zmm21, zmm7, zmm6
    vpxorq zmm9, zmm21, [t_sign]{1to8}
    vmovapd zmm20, zmm6
    vfnmadd231pd zmm20{k1}{z}, zmm7, zmm6
    vcmppd k2, zmm4, [t_zero]{1to8}, 0x1a
    vmovapd zmm20{k2}, zmm9
    vpxorq zmm12, zmm20, [t_sign]{1to8}
    vpmovq2m k3, zmm0
    vmovapd zmm20{k3}, zmm9
    vmovapd zmm21{k3}, zmm12
    vbroadcastsd zmm0, [t_slol0]
    vfmadd231pd zmm0, zmm16, [t_mtl0]{1to8}
    vfmadd231pd zmm0, zmm18, [t_mtl1]{1to8}
    vfmadd231pd zmm0, zmm20, [t_mtl2]{1to8}
    vbroadcastsd zmm2, [t_shil0]
    vfmadd231pd zmm2, zmm17, [t_mtl0]{1to8}
    vfmadd231pd zmm2, zmm19, [t_mtl1]{1to8}
    vfmadd231pd zmm2, zmm21, [t_mtl2]{1to8}
    vcvtpd2qq zmm0, zmm0, {rn-sae}
    vcvtpd2qq zmm2, zmm2, {rn-sae}
    vpcmpeqq k1, zmm0, zmm2
    vpxorq zmm3, zmm3, zmm3
    vpmaxsq zmm0, zmm0, zmm3
    vpternlogq zmm4, zmm4, zmm4, 0xff
    vpminsq zmm4{k1}, zmm0, [t_q1023]{1to8}
    ret
.t1c:
    vcvtps2pd zmm15, [r0 + 384]
    vbroadcastsd zmm14, [t_epsn]
    vsubpd zmm14, zmm14, zmm15
    vrsqrt14pd zmm13, zmm14
    vbroadcastsd zmm12, [t_snegh]
    vfmadd213pd zmm13, zmm12, [t_anegh]{1to8}
    vfmadd213pd zmm13, zmm14, [t_tabsh]{1to8}
    vmovapd zmm15, zmm13
    vcvtps2pd zmm0, [r0]
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm2, [t_rgh0]{1to8}
    vsubpd zmm4, zmm2, zmm3
    vcmppd k1, zmm4, zmm3, 0x1e
    vaddpd zmm5, zmm2, zmm3
    vmovapd zmm5{k1}, zmm2
    vpsrlq zmm1, zmm5, 48
    vmovapd zmm10, [t_rx]
    vpermt2pd zmm10, zmm1, [t_rx + 64]
    vgetmantpd zmm2, zmm5, 4
    vfmsub213pd zmm2, zmm10, [t_one]{1to8}
    vmulpd zmm7, zmm2, zmm2
    vpsrlq zmm8, zmm5, 52
    vmovapd zmm6, [t_oa]
    vpermt2pd zmm6, zmm8, [t_oa + 64]
    vpsrlq zmm9, zmm5, 56
    vpermpd zmm9, zmm9, [t_ob]
    vmovapd zmm10, [t_ow]
    vpermt2pd zmm10, zmm1, [t_ow + 64]
    vbroadcastsd zmm11, [t_op3]
    vfmadd213pd zmm11, zmm2, [t_op2]{1to8}
    vbroadcastsd zmm8, [t_op4]
    vfmadd213pd zmm8, zmm7, zmm11
    vbroadcastsd zmm11, [t_op1]
    vfmadd213pd zmm11, zmm2, [t_op0]{1to8}
    vfmadd213pd zmm8, zmm7, zmm11
    vmulpd zmm6, zmm6, zmm9
    vmulpd zmm6, zmm6, zmm10
    vmulpd zmm6, zmm6, zmm8
    vrcp14pd zmm7, zmm4
    vmulpd zmm7{k1}{z}, zmm3, zmm7
    vbroadcastsd zmm11, [t_omg]
    vfmadd132pd zmm7, zmm11, [t_eq0]{1to8}
    vmovapd zmm17, zmm6
    vfmadd231pd zmm17, zmm7, zmm6
    vpxorq zmm9, zmm17, [t_sign]{1to8}
    vmovapd zmm16, zmm6
    vfnmadd231pd zmm16{k1}{z}, zmm7, zmm6
    vcmppd k2, zmm4, [t_zero]{1to8}, 0x1a
    vmovapd zmm16{k2}, zmm9
    vpxorq zmm12, zmm16, [t_sign]{1to8}
    vpmovq2m k3, zmm0
    vmovapd zmm16{k3}, zmm9
    vmovapd zmm17{k3}, zmm12
    vcvtps2pd zmm0, [r0 + 128]
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm2, [t_rgh1]{1to8}
    vsubpd zmm4, zmm2, zmm3
    vcmppd k1, zmm4, zmm3, 0x1e
    vaddpd zmm5, zmm2, zmm3
    vmovapd zmm5{k1}, zmm2
    vpsrlq zmm1, zmm5, 48
    vmovapd zmm10, [t_rx]
    vpermt2pd zmm10, zmm1, [t_rx + 64]
    vgetmantpd zmm2, zmm5, 4
    vfmsub213pd zmm2, zmm10, [t_one]{1to8}
    vmulpd zmm7, zmm2, zmm2
    vpsrlq zmm8, zmm5, 52
    vmovapd zmm6, [t_oa]
    vpermt2pd zmm6, zmm8, [t_oa + 64]
    vpsrlq zmm9, zmm5, 56
    vpermpd zmm9, zmm9, [t_ob]
    vmovapd zmm10, [t_ow]
    vpermt2pd zmm10, zmm1, [t_ow + 64]
    vbroadcastsd zmm11, [t_op3]
    vfmadd213pd zmm11, zmm2, [t_op2]{1to8}
    vbroadcastsd zmm8, [t_op4]
    vfmadd213pd zmm8, zmm7, zmm11
    vbroadcastsd zmm11, [t_op1]
    vfmadd213pd zmm11, zmm2, [t_op0]{1to8}
    vfmadd213pd zmm8, zmm7, zmm11
    vmulpd zmm6, zmm6, zmm9
    vmulpd zmm6, zmm6, zmm10
    vmulpd zmm6, zmm6, zmm8
    vrcp14pd zmm7, zmm4
    vmulpd zmm7{k1}{z}, zmm3, zmm7
    vbroadcastsd zmm11, [t_omg]
    vfmadd132pd zmm7, zmm11, [t_eq0]{1to8}
    vmovapd zmm19, zmm6
    vfmadd231pd zmm19, zmm7, zmm6
    vpxorq zmm9, zmm19, [t_sign]{1to8}
    vmovapd zmm18, zmm6
    vfnmadd231pd zmm18{k1}{z}, zmm7, zmm6
    vcmppd k2, zmm4, [t_zero]{1to8}, 0x1a
    vmovapd zmm18{k2}, zmm9
    vpxorq zmm12, zmm18, [t_sign]{1to8}
    vpmovq2m k3, zmm0
    vmovapd zmm18{k3}, zmm9
    vmovapd zmm19{k3}, zmm12
    vcvtps2pd zmm0, [r0 + 256]
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm2, [t_rgh2]{1to8}
    vsubpd zmm4, zmm2, zmm3
    vcmppd k1, zmm4, zmm3, 0x1e
    vaddpd zmm5, zmm2, zmm3
    vmovapd zmm5{k1}, zmm2
    vpsrlq zmm1, zmm5, 48
    vmovapd zmm10, [t_rx]
    vpermt2pd zmm10, zmm1, [t_rx + 64]
    vgetmantpd zmm2, zmm5, 4
    vfmsub213pd zmm2, zmm10, [t_one]{1to8}
    vmulpd zmm7, zmm2, zmm2
    vpsrlq zmm8, zmm5, 52
    vmovapd zmm6, [t_oa]
    vpermt2pd zmm6, zmm8, [t_oa + 64]
    vpsrlq zmm9, zmm5, 56
    vpermpd zmm9, zmm9, [t_ob]
    vmovapd zmm10, [t_ow]
    vpermt2pd zmm10, zmm1, [t_ow + 64]
    vbroadcastsd zmm11, [t_op3]
    vfmadd213pd zmm11, zmm2, [t_op2]{1to8}
    vbroadcastsd zmm8, [t_op4]
    vfmadd213pd zmm8, zmm7, zmm11
    vbroadcastsd zmm11, [t_op1]
    vfmadd213pd zmm11, zmm2, [t_op0]{1to8}
    vfmadd213pd zmm8, zmm7, zmm11
    vmulpd zmm6, zmm6, zmm9
    vmulpd zmm6, zmm6, zmm10
    vmulpd zmm6, zmm6, zmm8
    vrcp14pd zmm7, zmm4
    vmulpd zmm7{k1}{z}, zmm3, zmm7
    vbroadcastsd zmm11, [t_omg]
    vfmadd132pd zmm7, zmm11, [t_eq0]{1to8}
    vmovapd zmm21, zmm6
    vfmadd231pd zmm21, zmm7, zmm6
    vpxorq zmm9, zmm21, [t_sign]{1to8}
    vmovapd zmm20, zmm6
    vfnmadd231pd zmm20{k1}{z}, zmm7, zmm6
    vcmppd k2, zmm4, [t_zero]{1to8}, 0x1a
    vmovapd zmm20{k2}, zmm9
    vpxorq zmm12, zmm20, [t_sign]{1to8}
    vpmovq2m k3, zmm0
    vmovapd zmm20{k3}, zmm9
    vmovapd zmm21{k3}, zmm12
    vbroadcastsd zmm0, [t_sloh0]
    vfnmadd231pd zmm0, zmm19, [t_mth2]{1to8}
    vfnmadd231pd zmm0, zmm17, [t_mth1]{1to8}
    vfmadd231pd zmm0, zmm20, [t_mth0]{1to8}
    vbroadcastsd zmm2, [t_shih0]
    vfnmadd231pd zmm2, zmm18, [t_mth2]{1to8}
    vfnmadd231pd zmm2, zmm16, [t_mth1]{1to8}
    vfmadd231pd zmm2, zmm21, [t_mth0]{1to8}
    vcvtpd2qq zmm0, zmm0, {rn-sae}
    vcvtpd2qq zmm2, zmm2, {rn-sae}
    vpcmpeqq k1, zmm0, zmm2
    vpxorq zmm3, zmm3, zmm3
    vpmaxsq zmm0, zmm0, zmm3
    vpternlogq zmm4, zmm4, zmm4, 0xff
    vpminsq zmm4{k1}, zmm0, [t_q1023]{1to8}
    vbroadcastsd zmm0, [t_sloh1]
    vfnmadd231pd zmm0, zmm21, [t_mth5]{1to8}
    vfnmadd231pd zmm0, zmm19, [t_mth4]{1to8}
    vfmadd231pd zmm0, zmm16, [t_mth3]{1to8}
    vbroadcastsd zmm2, [t_shih1]
    vfnmadd231pd zmm2, zmm20, [t_mth5]{1to8}
    vfnmadd231pd zmm2, zmm18, [t_mth4]{1to8}
    vfmadd231pd zmm2, zmm17, [t_mth3]{1to8}
    vcvtpd2qq zmm0, zmm0, {rn-sae}
    vcvtpd2qq zmm2, zmm2, {rn-sae}
    vpcmpeqq k1, zmm0, zmm2
    vpxorq zmm3, zmm3, zmm3
    vpmaxsq zmm0, zmm0, zmm3
    vpternlogq zmm5, zmm5, zmm5, 0xff
    vpminsq zmm5{k1}, zmm0, [t_q1023]{1to8}
    vpternlogq zmm7, zmm7, zmm7, 0xff
    vpcmpeqq k1, zmm5, zmm7
    vmovdqa64 zmm4{k1}, zmm7
    ret
.q2l:
    test r6d, r6d
    jz .h2l
    cmp dword [r7 + T_J], 2
    jb .h2l
    mov [r7 + T_XL], r6d
    mov r4, [r10 + 16 + S_SRC]
    mov r3d, [r7 + T_J]
    imul r3, r3, 4*W
    add r3, r4
    mov r2d, r6d
    movzx r1d, word [r3 + r2*4]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + r5 + T_WY], xmm0
    movzx r1d, word [r3 + r2*4 + 2]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + r5 + T_WY + 64], xmm0
    movzx r1d, word [r3 + r2*4 + 2*W]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + r5 + T_WY + 128], xmm0
    movzx r1d, word [r3 + r2*4 + 2*W + 2]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + r5 + T_WY + 192], xmm0
    mov r3d, [r7 + T_J]
    sub r3d, 2
    imul r3, r3, CST
    lea r2, [r4 + r3 + CB - 2]
    lea r2, [r2 + r6*2]
    vpmovzxwd xmm8, [r2]
    vpmovzxwd xmm9, [r2 + CRD]
    vcvtdq2ps xmm8, xmm8
    vcvtdq2ps xmm9, xmm9
    vpmovzxwd xmm10, [r2 + CST]
    vpmovzxwd xmm11, [r2 + CST + CRD]
    vcvtdq2ps xmm10, xmm10
    vcvtdq2ps xmm11, xmm11
    vpmovzxwd xmm12, [r2 + 2*CST]
    vpmovzxwd xmm13, [r2 + 2*CST + CRD]
    vcvtdq2ps xmm12, xmm12
    vcvtdq2ps xmm13, xmm13
    vpmovzxwd xmm14, [r2 + 3*CST]
    vpmovzxwd xmm15, [r2 + 3*CST + CRD]
    vcvtdq2ps xmm14, xmm14
    vcvtdq2ps xmm15, xmm15
    vpmovzxwd xmm16, [r2 + 4*CST]
    vpmovzxwd xmm17, [r2 + 4*CST + CRD]
    vcvtdq2ps xmm16, xmm16
    vcvtdq2ps xmm17, xmm17
    vxorps xmm20, xmm20, xmm20
    vfmadd231ps xmm20, xmm8, [t_k75]{1to4}
    vfmadd231ps xmm20, xmm10, [t_k75 + 4]{1to4}
    vfmadd231ps xmm20, xmm12, [t_k75 + 8]{1to4}
    vfmadd231ps xmm20, xmm14, [t_k75 + 12]{1to4}
    vxorps xmm21, xmm21, xmm21
    vfmadd231ps xmm21, xmm9, [t_k75]{1to4}
    vfmadd231ps xmm21, xmm11, [t_k75 + 4]{1to4}
    vfmadd231ps xmm21, xmm13, [t_k75 + 8]{1to4}
    vfmadd231ps xmm21, xmm15, [t_k75 + 12]{1to4}
    vxorps xmm22, xmm22, xmm22
    vfmadd231ps xmm22, xmm10, [t_k25]{1to4}
    vfmadd231ps xmm22, xmm12, [t_k25 + 4]{1to4}
    vfmadd231ps xmm22, xmm14, [t_k25 + 8]{1to4}
    vfmadd231ps xmm22, xmm16, [t_k25 + 12]{1to4}
    vxorps xmm23, xmm23, xmm23
    vfmadd231ps xmm23, xmm11, [t_k25]{1to4}
    vfmadd231ps xmm23, xmm13, [t_k25 + 4]{1to4}
    vfmadd231ps xmm23, xmm15, [t_k25 + 8]{1to4}
    vfmadd231ps xmm23, xmm17, [t_k25 + 12]{1to4}
    vmovdqa xmm7, [t_q2j]
    vxorps xmm2, xmm2, xmm2
    vfmadd231ps xmm2, xmm20, [t_k50]{1to4}
    valignd xmm3, xmm20, xmm20, 1
    vfmadd231ps xmm2, xmm3, [t_k50 + 4]{1to4}
    valignd xmm3, xmm20, xmm20, 2
    vfmadd231ps xmm2, xmm3, [t_k50 + 8]{1to4}
    valignd xmm3, xmm20, xmm20, 3
    vfmadd231ps xmm2, xmm3, [t_k50 + 12]{1to4}
    vpermt2ps xmm2, xmm7, xmm20
    vcvtps2pd xmm2, xmm2
    vsubpd xmm2, xmm2, [t_512]{1to2}
    vmovsd [r7 + r5 + T_WB], xmm2
    vmovhpd [r7 + r5 + T_WB + 64], xmm2
    vxorps xmm2, xmm2, xmm2
    vfmadd231ps xmm2, xmm21, [t_k50]{1to4}
    valignd xmm3, xmm21, xmm21, 1
    vfmadd231ps xmm2, xmm3, [t_k50 + 4]{1to4}
    valignd xmm3, xmm21, xmm21, 2
    vfmadd231ps xmm2, xmm3, [t_k50 + 8]{1to4}
    valignd xmm3, xmm21, xmm21, 3
    vfmadd231ps xmm2, xmm3, [t_k50 + 12]{1to4}
    vpermt2ps xmm2, xmm7, xmm21
    vcvtps2pd xmm2, xmm2
    vsubpd xmm2, xmm2, [t_512]{1to2}
    vmovsd [r7 + r5 + T_WR], xmm2
    vmovhpd [r7 + r5 + T_WR + 64], xmm2
    vxorps xmm2, xmm2, xmm2
    vfmadd231ps xmm2, xmm22, [t_k50]{1to4}
    valignd xmm3, xmm22, xmm22, 1
    vfmadd231ps xmm2, xmm3, [t_k50 + 4]{1to4}
    valignd xmm3, xmm22, xmm22, 2
    vfmadd231ps xmm2, xmm3, [t_k50 + 8]{1to4}
    valignd xmm3, xmm22, xmm22, 3
    vfmadd231ps xmm2, xmm3, [t_k50 + 12]{1to4}
    vpermt2ps xmm2, xmm7, xmm22
    vcvtps2pd xmm2, xmm2
    vsubpd xmm2, xmm2, [t_512]{1to2}
    vmovsd [r7 + r5 + T_WB + 128], xmm2
    vmovhpd [r7 + r5 + T_WB + 192], xmm2
    vxorps xmm2, xmm2, xmm2
    vfmadd231ps xmm2, xmm23, [t_k50]{1to4}
    valignd xmm3, xmm23, xmm23, 1
    vfmadd231ps xmm2, xmm3, [t_k50 + 4]{1to4}
    valignd xmm3, xmm23, xmm23, 2
    vfmadd231ps xmm2, xmm3, [t_k50 + 8]{1to4}
    valignd xmm3, xmm23, xmm23, 3
    vfmadd231ps xmm2, xmm3, [t_k50 + 12]{1to4}
    vpermt2ps xmm2, xmm7, xmm23
    vcvtps2pd xmm2, xmm2
    vsubpd xmm2, xmm2, [t_512]{1to2}
    vmovsd [r7 + r5 + T_WR + 128], xmm2
    vmovhpd [r7 + r5 + T_WR + 192], xmm2
    ret
.q2c:
    test r6d, r6d
    jz .h2c
    cmp dword [r7 + T_J], 0
    je .h2c
    mov [r7 + T_XL], r6d
    mov r4, [r10 + 16 + S_SRC]
    mov r3d, [r7 + T_J]
    imul r3, r3, 8*W
    add r3, r4
    lea r3, [r3 + r6*8 - 2]
    vpmovzxwd xmm2, [r3]
    vcvtdq2pd ymm2, xmm2
    vmovsd [r7 + r5 + T_WY], xmm2
    vmovhpd [r7 + r5 + T_WY + 64], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WY + 128], xmm2
    vmovhpd [r7 + r5 + T_WY + 192], xmm2
    vpmovzxwd xmm2, [r3 + 2*W]
    vcvtdq2pd ymm2, xmm2
    vmovsd [r7 + r5 + T_WY + 256], xmm2
    vmovhpd [r7 + r5 + T_WY + 320], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WY + 384], xmm2
    vmovhpd [r7 + r5 + T_WY + 448], xmm2
    vpmovzxwd xmm2, [r3 + 4*W]
    vcvtdq2pd ymm2, xmm2
    vmovsd [r7 + r5 + T_WY + 512], xmm2
    vmovhpd [r7 + r5 + T_WY + 576], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WY + 640], xmm2
    vmovhpd [r7 + r5 + T_WY + 704], xmm2
    vpmovzxwd xmm2, [r3 + 6*W]
    vcvtdq2pd ymm2, xmm2
    vmovsd [r7 + r5 + T_WY + 768], xmm2
    vmovhpd [r7 + r5 + T_WY + 832], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WY + 896], xmm2
    vmovhpd [r7 + r5 + T_WY + 960], xmm2
    mov r3d, [r7 + T_J]
    lea r3d, [r3*2 - 2]
    imul r3, r3, CST
    lea r2, [r4 + r3 + CB - 4]
    lea r2, [r2 + r6*4]
    vpmovzxwd ymm8, [r2]
    vpmovzxwd ymm9, [r2 + CRD]
    vcvtdq2ps ymm8, ymm8
    vcvtdq2ps ymm9, ymm9
    vpmovzxwd ymm10, [r2 + CST]
    vpmovzxwd ymm11, [r2 + CST + CRD]
    vcvtdq2ps ymm10, ymm10
    vcvtdq2ps ymm11, ymm11
    vpmovzxwd ymm12, [r2 + 2*CST]
    vpmovzxwd ymm13, [r2 + 2*CST + CRD]
    vcvtdq2ps ymm12, ymm12
    vcvtdq2ps ymm13, ymm13
    vpmovzxwd ymm14, [r2 + 3*CST]
    vpmovzxwd ymm15, [r2 + 3*CST + CRD]
    vcvtdq2ps ymm14, ymm14
    vcvtdq2ps ymm15, ymm15
    vpmovzxwd ymm16, [r2 + 4*CST]
    vpmovzxwd ymm17, [r2 + 4*CST + CRD]
    vcvtdq2ps ymm16, ymm16
    vcvtdq2ps ymm17, ymm17
    vpmovzxwd ymm18, [r2 + 5*CST]
    vpmovzxwd ymm19, [r2 + 5*CST + CRD]
    vcvtdq2ps ymm18, ymm18
    vcvtdq2ps ymm19, ymm19
    vxorps ymm20, ymm20, ymm20
    vfmadd231ps ymm20, ymm8, [t_k75]{1to8}
    vfmadd231ps ymm20, ymm10, [t_k75 + 4]{1to8}
    vfmadd231ps ymm20, ymm12, [t_k75 + 8]{1to8}
    vfmadd231ps ymm20, ymm14, [t_k75 + 12]{1to8}
    vxorps ymm21, ymm21, ymm21
    vfmadd231ps ymm21, ymm9, [t_k75]{1to8}
    vfmadd231ps ymm21, ymm11, [t_k75 + 4]{1to8}
    vfmadd231ps ymm21, ymm13, [t_k75 + 8]{1to8}
    vfmadd231ps ymm21, ymm15, [t_k75 + 12]{1to8}
    vxorps ymm22, ymm22, ymm22
    vfmadd231ps ymm22, ymm10, [t_k25]{1to8}
    vfmadd231ps ymm22, ymm12, [t_k25 + 4]{1to8}
    vfmadd231ps ymm22, ymm14, [t_k25 + 8]{1to8}
    vfmadd231ps ymm22, ymm16, [t_k25 + 12]{1to8}
    vxorps ymm23, ymm23, ymm23
    vfmadd231ps ymm23, ymm11, [t_k25]{1to8}
    vfmadd231ps ymm23, ymm13, [t_k25 + 4]{1to8}
    vfmadd231ps ymm23, ymm15, [t_k25 + 8]{1to8}
    vfmadd231ps ymm23, ymm17, [t_k25 + 12]{1to8}
    vxorps ymm24, ymm24, ymm24
    vfmadd231ps ymm24, ymm10, [t_k75]{1to8}
    vfmadd231ps ymm24, ymm12, [t_k75 + 4]{1to8}
    vfmadd231ps ymm24, ymm14, [t_k75 + 8]{1to8}
    vfmadd231ps ymm24, ymm16, [t_k75 + 12]{1to8}
    vxorps ymm25, ymm25, ymm25
    vfmadd231ps ymm25, ymm11, [t_k75]{1to8}
    vfmadd231ps ymm25, ymm13, [t_k75 + 4]{1to8}
    vfmadd231ps ymm25, ymm15, [t_k75 + 8]{1to8}
    vfmadd231ps ymm25, ymm17, [t_k75 + 12]{1to8}
    vxorps ymm26, ymm26, ymm26
    vfmadd231ps ymm26, ymm12, [t_k25]{1to8}
    vfmadd231ps ymm26, ymm14, [t_k25 + 4]{1to8}
    vfmadd231ps ymm26, ymm16, [t_k25 + 8]{1to8}
    vfmadd231ps ymm26, ymm18, [t_k25 + 12]{1to8}
    vxorps ymm27, ymm27, ymm27
    vfmadd231ps ymm27, ymm13, [t_k25]{1to8}
    vfmadd231ps ymm27, ymm15, [t_k25 + 4]{1to8}
    vfmadd231ps ymm27, ymm17, [t_k25 + 8]{1to8}
    vfmadd231ps ymm27, ymm19, [t_k25 + 12]{1to8}
    vmovdqa xmm7, [t_q2i]
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm20, [t_k50]{1to8}
    valignd ymm3, ymm20, ymm20, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm20, ymm20, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm20, ymm20, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm20
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovsd [r7 + r5 + T_WB], xmm2
    vmovhpd [r7 + r5 + T_WB + 64], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WB + 128], xmm2
    vmovhpd [r7 + r5 + T_WB + 192], xmm2
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm21, [t_k50]{1to8}
    valignd ymm3, ymm21, ymm21, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm21, ymm21, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm21, ymm21, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm21
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovsd [r7 + r5 + T_WR], xmm2
    vmovhpd [r7 + r5 + T_WR + 64], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WR + 128], xmm2
    vmovhpd [r7 + r5 + T_WR + 192], xmm2
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm22, [t_k50]{1to8}
    valignd ymm3, ymm22, ymm22, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm22, ymm22, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm22, ymm22, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm22
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovsd [r7 + r5 + T_WB + 256], xmm2
    vmovhpd [r7 + r5 + T_WB + 320], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WB + 384], xmm2
    vmovhpd [r7 + r5 + T_WB + 448], xmm2
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm23, [t_k50]{1to8}
    valignd ymm3, ymm23, ymm23, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm23, ymm23, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm23, ymm23, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm23
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovsd [r7 + r5 + T_WR + 256], xmm2
    vmovhpd [r7 + r5 + T_WR + 320], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WR + 384], xmm2
    vmovhpd [r7 + r5 + T_WR + 448], xmm2
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm24, [t_k50]{1to8}
    valignd ymm3, ymm24, ymm24, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm24, ymm24, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm24, ymm24, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm24
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovsd [r7 + r5 + T_WB + 512], xmm2
    vmovhpd [r7 + r5 + T_WB + 576], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WB + 640], xmm2
    vmovhpd [r7 + r5 + T_WB + 704], xmm2
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm25, [t_k50]{1to8}
    valignd ymm3, ymm25, ymm25, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm25, ymm25, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm25, ymm25, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm25
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovsd [r7 + r5 + T_WR + 512], xmm2
    vmovhpd [r7 + r5 + T_WR + 576], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WR + 640], xmm2
    vmovhpd [r7 + r5 + T_WR + 704], xmm2
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm26, [t_k50]{1to8}
    valignd ymm3, ymm26, ymm26, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm26, ymm26, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm26, ymm26, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm26
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovsd [r7 + r5 + T_WB + 768], xmm2
    vmovhpd [r7 + r5 + T_WB + 832], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WB + 896], xmm2
    vmovhpd [r7 + r5 + T_WB + 960], xmm2
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm27, [t_k50]{1to8}
    valignd ymm3, ymm27, ymm27, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm27, ymm27, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm27, ymm27, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm27
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovsd [r7 + r5 + T_WR + 768], xmm2
    vmovhpd [r7 + r5 + T_WR + 832], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WR + 896], xmm2
    vmovhpd [r7 + r5 + T_WR + 960], xmm2
    ret
.w2l:
    vpxorq zmm31, zmm31, zmm31
    vmovapd [r7 + T_WAA], zmm31
    vmovapd [r7 + T_WLA], zmm31
    vmovapd [r7 + T_WAA + 64], zmm31
    vmovapd [r7 + T_WLA + 64], zmm31
    vmovapd [r7 + T_WAA + 128], zmm31
    vmovapd [r7 + T_WLA + 128], zmm31
    xor r2d, r2d
    xor r6d, r6d
.w2li:
    lea r3, [r6 + r2]
    vmovapd zmm0, [r7 + r3 + T_WY]
    vmovapd zmm1, [r7 + r3 + T_WB]
    vmovapd zmm2, [r7 + r3 + T_WR]
    vbroadcastsd zmm3, [t_lzm5]
    vfmadd231pd zmm3, zmm0, [t_lzm0]{1to8}
    vmovapd zmm4, zmm3
    vfmadd231pd zmm4, zmm2, [t_lzm1]{1to8}
    vmovapd zmm5, zmm3
    vfmadd231pd zmm5, zmm2, [t_lzm2]{1to8}
    vfmadd231pd zmm5, zmm1, [t_lzm3]{1to8}
    vmovapd zmm6, zmm3
    vfmadd231pd zmm6, zmm1, [t_lzm4]{1to8}
    vrangepd zmm7, zmm4, [t_xflr]{1to8}, 0x0b
    vpsrlq zmm8, zmm7, 52
    vpsrlq zmm9, zmm7, 48
    vmovapd zmm10, [t_tsl]
    vpermt2pd zmm10, zmm8, [t_tsl + 64]
    vmovapd zmm12, [t_rx]
    vpermt2pd zmm12, zmm9, [t_rx + 64]
    vgetmantpd zmm11, zmm7, 4
    vfmsub213pd zmm11, zmm12, [t_one]{1to8}
    vptestnmq k5, zmm8, [t_q16]{1to8}
    vmulpd zmm10{k5}, zmm10, [t_tsk]{1to8}
    vmovapd zmm12, [t_wsx]
    vpermt2pd zmm12, zmm9, [t_wsx + 64]
    vmulpd zmm10, zmm10, zmm12
    vaddpd zmm13, zmm11, [t_psx3]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx2]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx1]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx0]{1to8}
    vmulpd zmm7, zmm10, zmm13
    vmovapd [r7 + r6 + T_WS], zmm7
    vpternlogq zmm7, zmm4, [t_sign]{1to8}, 0xd8
    vmovapd [r7 + r6 + T_WE], zmm7
    vrangepd zmm7, zmm5, [t_xflr]{1to8}, 0x0b
    vpsrlq zmm8, zmm7, 52
    vpsrlq zmm9, zmm7, 48
    vmovapd zmm10, [t_tsl]
    vpermt2pd zmm10, zmm8, [t_tsl + 64]
    vmovapd zmm12, [t_rx]
    vpermt2pd zmm12, zmm9, [t_rx + 64]
    vgetmantpd zmm11, zmm7, 4
    vfmsub213pd zmm11, zmm12, [t_one]{1to8}
    vptestnmq k5, zmm8, [t_q16]{1to8}
    vmulpd zmm10{k5}, zmm10, [t_tsk]{1to8}
    vmovapd zmm12, [t_wsx]
    vpermt2pd zmm12, zmm9, [t_wsx + 64]
    vmulpd zmm10, zmm10, zmm12
    vaddpd zmm13, zmm11, [t_psx3]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx2]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx1]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx0]{1to8}
    vmulpd zmm7, zmm10, zmm13
    vmovapd [r7 + r6 + T_WS + 512], zmm7
    vpternlogq zmm7, zmm5, [t_sign]{1to8}, 0xd8
    vmovapd [r7 + r6 + T_WE + 512], zmm7
    vrangepd zmm7, zmm6, [t_xflr]{1to8}, 0x0b
    vpsrlq zmm8, zmm7, 52
    vpsrlq zmm9, zmm7, 48
    vmovapd zmm10, [t_tsl]
    vpermt2pd zmm10, zmm8, [t_tsl + 64]
    vmovapd zmm12, [t_rx]
    vpermt2pd zmm12, zmm9, [t_rx + 64]
    vgetmantpd zmm11, zmm7, 4
    vfmsub213pd zmm11, zmm12, [t_one]{1to8}
    vptestnmq k5, zmm8, [t_q16]{1to8}
    vmulpd zmm10{k5}, zmm10, [t_tsk]{1to8}
    vmovapd zmm12, [t_wsx]
    vpermt2pd zmm12, zmm9, [t_wsx + 64]
    vmulpd zmm10, zmm10, zmm12
    vaddpd zmm13, zmm11, [t_psx3]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx2]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx1]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx0]{1to8}
    vmulpd zmm7, zmm10, zmm13
    vmovapd [r7 + r6 + T_WS + 1024], zmm7
    vpternlogq zmm7, zmm6, [t_sign]{1to8}, 0xd8
    vmovapd [r7 + r6 + T_WE + 1024], zmm7
    add r6d, 64
    cmp r6d, 256
    jb .w2li
    vmovapd zmm0, [r7 + T_WS]
    vaddpd zmm0, zmm0, zmm31
    vmovapd zmm1, [r7 + T_WS + 64]
    vaddpd zmm1, zmm1, zmm31
    vmovapd zmm2, [r7 + T_WS + 128]
    vaddpd zmm2, zmm2, zmm31
    vmovapd zmm3, [r7 + T_WS + 192]
    vaddpd zmm3, zmm3, zmm31
    vaddpd zmm0, zmm0, zmm2
    vaddpd zmm1, zmm1, zmm3
    vaddpd zmm0, zmm0, zmm1
    vmovapd zmm1, [r7 + T_WAA]
    vaddpd zmm1, zmm1, zmm0
    vmovapd [r7 + T_WAA], zmm1
    vmovapd zmm0, [r7 + T_WE]
    vaddpd zmm0, zmm0, zmm31
    vmovapd zmm1, [r7 + T_WE + 64]
    vaddpd zmm1, zmm1, zmm31
    vmovapd zmm2, [r7 + T_WE + 128]
    vaddpd zmm2, zmm2, zmm31
    vmovapd zmm3, [r7 + T_WE + 192]
    vaddpd zmm3, zmm3, zmm31
    vaddpd zmm0, zmm0, zmm2
    vaddpd zmm1, zmm1, zmm3
    vaddpd zmm0, zmm0, zmm1
    vmovapd zmm1, [r7 + T_WLA]
    vaddpd zmm1, zmm1, zmm0
    vmovapd [r7 + T_WLA], zmm1
    vmovapd zmm0, [r7 + T_WS + 512]
    vaddpd zmm0, zmm0, zmm31
    vmovapd zmm1, [r7 + T_WS + 576]
    vaddpd zmm1, zmm1, zmm31
    vmovapd zmm2, [r7 + T_WS + 640]
    vaddpd zmm2, zmm2, zmm31
    vmovapd zmm3, [r7 + T_WS + 704]
    vaddpd zmm3, zmm3, zmm31
    vaddpd zmm0, zmm0, zmm2
    vaddpd zmm1, zmm1, zmm3
    vaddpd zmm0, zmm0, zmm1
    vmovapd zmm1, [r7 + T_WAA + 64]
    vaddpd zmm1, zmm1, zmm0
    vmovapd [r7 + T_WAA + 64], zmm1
    vmovapd zmm0, [r7 + T_WE + 512]
    vaddpd zmm0, zmm0, zmm31
    vmovapd zmm1, [r7 + T_WE + 576]
    vaddpd zmm1, zmm1, zmm31
    vmovapd zmm2, [r7 + T_WE + 640]
    vaddpd zmm2, zmm2, zmm31
    vmovapd zmm3, [r7 + T_WE + 704]
    vaddpd zmm3, zmm3, zmm31
    vaddpd zmm0, zmm0, zmm2
    vaddpd zmm1, zmm1, zmm3
    vaddpd zmm0, zmm0, zmm1
    vmovapd zmm1, [r7 + T_WLA + 64]
    vaddpd zmm1, zmm1, zmm0
    vmovapd [r7 + T_WLA + 64], zmm1
    vmovapd zmm0, [r7 + T_WS + 1024]
    vaddpd zmm0, zmm0, zmm31
    vmovapd zmm1, [r7 + T_WS + 1088]
    vaddpd zmm1, zmm1, zmm31
    vmovapd zmm2, [r7 + T_WS + 1152]
    vaddpd zmm2, zmm2, zmm31
    vmovapd zmm3, [r7 + T_WS + 1216]
    vaddpd zmm3, zmm3, zmm31
    vaddpd zmm0, zmm0, zmm2
    vaddpd zmm1, zmm1, zmm3
    vaddpd zmm0, zmm0, zmm1
    vmovapd zmm1, [r7 + T_WAA + 128]
    vaddpd zmm1, zmm1, zmm0
    vmovapd [r7 + T_WAA + 128], zmm1
    vmovapd zmm0, [r7 + T_WE + 1024]
    vaddpd zmm0, zmm0, zmm31
    vmovapd zmm1, [r7 + T_WE + 1088]
    vaddpd zmm1, zmm1, zmm31
    vmovapd zmm2, [r7 + T_WE + 1152]
    vaddpd zmm2, zmm2, zmm31
    vmovapd zmm3, [r7 + T_WE + 1216]
    vaddpd zmm3, zmm3, zmm31
    vaddpd zmm0, zmm0, zmm2
    vaddpd zmm1, zmm1, zmm3
    vaddpd zmm0, zmm0, zmm1
    vmovapd zmm1, [r7 + T_WLA + 128]
    vaddpd zmm1, zmm1, zmm0
    vmovapd [r7 + T_WLA + 128], zmm1
    xor r3d, r3d
.w2lv:
    vmovapd zmm2, [r7 + r3 + T_WLA]
    vmulpd zmm2, zmm2, [t_quart]{1to8}
    vandpd zmm3, zmm2, [t_abs2]{1to8}
    vxorpd zmm3, zmm3, [t_sgn2]{1to8}
    vmovapd zmm4, [r7 + r3 + T_WAA]
    vfmadd132pd zmm4, zmm3, [t_quart]{1to8}
    vbroadcastsd zmm5, [t_tab]
    vfmadd132pd zmm4, zmm5, [t_rg2]{1to8}
    vmovapd zmm0, zmm2
    vmovapd zmm15, zmm4
    vbroadcastsd zmm1, [t_rg2]
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm1, zmm2
    vsubpd zmm4, zmm2, zmm3
    vcmppd k1, zmm4, zmm3, 0x1e
    vaddpd zmm5, zmm2, zmm3
    vmovapd zmm5{k1}, zmm2
    vpsrlq zmm1, zmm5, 48
    vmovapd zmm10, [t_rx]
    vpermt2pd zmm10, zmm1, [t_rx + 64]
    vgetmantpd zmm2, zmm5, 4
    vfmsub213pd zmm2, zmm10, [t_one]{1to8}
    vmulpd zmm7, zmm2, zmm2
    vpsrlq zmm8, zmm5, 52
    vmovapd zmm6, [t_oa]
    vpermt2pd zmm6, zmm8, [t_oa + 64]
    vpsrlq zmm9, zmm5, 56
    vpermpd zmm9, zmm9, [t_ob]
    vmovapd zmm10, [t_ow]
    vpermt2pd zmm10, zmm1, [t_ow + 64]
    vbroadcastsd zmm11, [t_op3]
    vfmadd213pd zmm11, zmm2, [t_op2]{1to8}
    vbroadcastsd zmm8, [t_op4]
    vfmadd213pd zmm8, zmm7, zmm11
    vbroadcastsd zmm11, [t_op1]
    vfmadd213pd zmm11, zmm2, [t_op0]{1to8}
    vfmadd213pd zmm8, zmm7, zmm11
    vmulpd zmm6, zmm6, zmm9
    vmulpd zmm6, zmm6, zmm10
    vmulpd zmm6, zmm6, zmm8
    vrcp14pd zmm7, zmm4
    vmulpd zmm7{k1}{z}, zmm3, zmm7
    vbroadcastsd zmm11, [t_omg]
    vfmadd132pd zmm7, zmm11, [t_eq0]{1to8}
    vmovapd zmm8, zmm6
    vfmadd231pd zmm8, zmm7, zmm6
    vpxorq zmm9, zmm8, [t_sign]{1to8}
    vmovapd zmm10, zmm6
    vfnmadd231pd zmm10{k1}{z}, zmm7, zmm6
    vcmppd k2, zmm4, [t_zero]{1to8}, 0x1a
    vmovapd zmm10{k2}, zmm9
    vpxorq zmm12, zmm10, [t_sign]{1to8}
    vpmovq2m k3, zmm0
    vmovapd zmm10{k3}, zmm9
    vmovapd zmm8{k3}, zmm12
    vmovapd [r7 + r3 + T_WLO], zmm10
    vmovapd [r7 + r3 + T_WHI], zmm8
    add r3d, 64
    cmp r3d, 192
    jb .w2lv
    vbroadcastsd zmm0, [t_ylo]
    vbroadcastsd zmm1, [t_emc0]
    vfmadd231pd zmm0, zmm1, [r7 + T_WLO]
    vbroadcastsd zmm1, [t_emc1]
    vfmadd231pd zmm0, zmm1, [r7 + T_WLO + 64]
    vbroadcastsd zmm1, [t_emc2]
    vfmadd231pd zmm0, zmm1, [r7 + T_WLO + 128]
    vbroadcastsd zmm2, [t_yhi]
    vbroadcastsd zmm1, [t_emc0]
    vfmadd231pd zmm2, zmm1, [r7 + T_WHI]
    vbroadcastsd zmm1, [t_emc1]
    vfmadd231pd zmm2, zmm1, [r7 + T_WHI + 64]
    vbroadcastsd zmm1, [t_emc2]
    vfmadd231pd zmm2, zmm1, [r7 + T_WHI + 128]
    vrndscalepd zmm0, zmm0, 8
    vrndscalepd zmm2, zmm2, 8
    vcvttpd2dq ymm4, zmm0
    vpmovsxdq zmm4, ymm4
    vpxorq zmm3, zmm3, zmm3
    vpmaxsq zmm4, zmm4, zmm3
    vpminsq zmm4, zmm4, [t_q1023]{1to8}
    vpcmpq k1, zmm0, zmm2, 4
    vpternlogq zmm4{k1}, zmm4, zmm4, 0xff
    ret
.w2c:
    vpxorq zmm31, zmm31, zmm31
    vmovapd [r7 + T_WAA], zmm31
    vmovapd [r7 + T_WLA], zmm31
    vmovapd [r7 + T_WAA + 64], zmm31
    vmovapd [r7 + T_WLA + 64], zmm31
    vmovapd [r7 + T_WAA + 128], zmm31
    vmovapd [r7 + T_WLA + 128], zmm31
    xor r2d, r2d
.w2cg:
    xor r6d, r6d
.w2ci:
    lea r3, [r6 + r2]
    vmovapd zmm0, [r7 + r3 + T_WY]
    vmovapd zmm1, [r7 + r3 + T_WB]
    vmovapd zmm2, [r7 + r3 + T_WR]
    vbroadcastsd zmm3, [t_lzm5]
    vfmadd231pd zmm3, zmm0, [t_lzm0]{1to8}
    vmovapd zmm4, zmm3
    vfmadd231pd zmm4, zmm2, [t_lzm1]{1to8}
    vmovapd zmm5, zmm3
    vfmadd231pd zmm5, zmm2, [t_lzm2]{1to8}
    vfmadd231pd zmm5, zmm1, [t_lzm3]{1to8}
    vmovapd zmm6, zmm3
    vfmadd231pd zmm6, zmm1, [t_lzm4]{1to8}
    vrangepd zmm7, zmm4, [t_xflr]{1to8}, 0x0b
    vpsrlq zmm8, zmm7, 52
    vpsrlq zmm9, zmm7, 48
    vmovapd zmm10, [t_tsl]
    vpermt2pd zmm10, zmm8, [t_tsl + 64]
    vmovapd zmm12, [t_rx]
    vpermt2pd zmm12, zmm9, [t_rx + 64]
    vgetmantpd zmm11, zmm7, 4
    vfmsub213pd zmm11, zmm12, [t_one]{1to8}
    vptestnmq k5, zmm8, [t_q16]{1to8}
    vmulpd zmm10{k5}, zmm10, [t_tsk]{1to8}
    vmovapd zmm12, [t_wsx]
    vpermt2pd zmm12, zmm9, [t_wsx + 64]
    vmulpd zmm10, zmm10, zmm12
    vaddpd zmm13, zmm11, [t_psx3]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx2]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx1]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx0]{1to8}
    vmulpd zmm7, zmm10, zmm13
    vmovapd [r7 + r6 + T_WS], zmm7
    vpternlogq zmm7, zmm4, [t_sign]{1to8}, 0xd8
    vmovapd [r7 + r6 + T_WE], zmm7
    vrangepd zmm7, zmm5, [t_xflr]{1to8}, 0x0b
    vpsrlq zmm8, zmm7, 52
    vpsrlq zmm9, zmm7, 48
    vmovapd zmm10, [t_tsl]
    vpermt2pd zmm10, zmm8, [t_tsl + 64]
    vmovapd zmm12, [t_rx]
    vpermt2pd zmm12, zmm9, [t_rx + 64]
    vgetmantpd zmm11, zmm7, 4
    vfmsub213pd zmm11, zmm12, [t_one]{1to8}
    vptestnmq k5, zmm8, [t_q16]{1to8}
    vmulpd zmm10{k5}, zmm10, [t_tsk]{1to8}
    vmovapd zmm12, [t_wsx]
    vpermt2pd zmm12, zmm9, [t_wsx + 64]
    vmulpd zmm10, zmm10, zmm12
    vaddpd zmm13, zmm11, [t_psx3]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx2]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx1]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx0]{1to8}
    vmulpd zmm7, zmm10, zmm13
    vmovapd [r7 + r6 + T_WS + 512], zmm7
    vpternlogq zmm7, zmm5, [t_sign]{1to8}, 0xd8
    vmovapd [r7 + r6 + T_WE + 512], zmm7
    vrangepd zmm7, zmm6, [t_xflr]{1to8}, 0x0b
    vpsrlq zmm8, zmm7, 52
    vpsrlq zmm9, zmm7, 48
    vmovapd zmm10, [t_tsl]
    vpermt2pd zmm10, zmm8, [t_tsl + 64]
    vmovapd zmm12, [t_rx]
    vpermt2pd zmm12, zmm9, [t_rx + 64]
    vgetmantpd zmm11, zmm7, 4
    vfmsub213pd zmm11, zmm12, [t_one]{1to8}
    vptestnmq k5, zmm8, [t_q16]{1to8}
    vmulpd zmm10{k5}, zmm10, [t_tsk]{1to8}
    vmovapd zmm12, [t_wsx]
    vpermt2pd zmm12, zmm9, [t_wsx + 64]
    vmulpd zmm10, zmm10, zmm12
    vaddpd zmm13, zmm11, [t_psx3]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx2]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx1]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx0]{1to8}
    vmulpd zmm7, zmm10, zmm13
    vmovapd [r7 + r6 + T_WS + 1024], zmm7
    vpternlogq zmm7, zmm6, [t_sign]{1to8}, 0xd8
    vmovapd [r7 + r6 + T_WE + 1024], zmm7
    add r6d, 64
    cmp r6d, 512
    jb .w2ci
    vmovapd zmm0, [r7 + T_WS]
    vaddpd zmm0, zmm0, [r7 + T_WS + 256]
    vmovapd zmm1, [r7 + T_WS + 64]
    vaddpd zmm1, zmm1, [r7 + T_WS + 320]
    vmovapd zmm2, [r7 + T_WS + 128]
    vaddpd zmm2, zmm2, [r7 + T_WS + 384]
    vmovapd zmm3, [r7 + T_WS + 192]
    vaddpd zmm3, zmm3, [r7 + T_WS + 448]
    vaddpd zmm0, zmm0, zmm2
    vaddpd zmm1, zmm1, zmm3
    vaddpd zmm0, zmm0, zmm1
    vmovapd zmm1, [r7 + T_WAA]
    vaddpd zmm1, zmm1, zmm0
    vmovapd [r7 + T_WAA], zmm1
    vmovapd zmm0, [r7 + T_WE]
    vaddpd zmm0, zmm0, [r7 + T_WE + 256]
    vmovapd zmm1, [r7 + T_WE + 64]
    vaddpd zmm1, zmm1, [r7 + T_WE + 320]
    vmovapd zmm2, [r7 + T_WE + 128]
    vaddpd zmm2, zmm2, [r7 + T_WE + 384]
    vmovapd zmm3, [r7 + T_WE + 192]
    vaddpd zmm3, zmm3, [r7 + T_WE + 448]
    vaddpd zmm0, zmm0, zmm2
    vaddpd zmm1, zmm1, zmm3
    vaddpd zmm0, zmm0, zmm1
    vmovapd zmm1, [r7 + T_WLA]
    vaddpd zmm1, zmm1, zmm0
    vmovapd [r7 + T_WLA], zmm1
    vmovapd zmm0, [r7 + T_WS + 512]
    vaddpd zmm0, zmm0, [r7 + T_WS + 768]
    vmovapd zmm1, [r7 + T_WS + 576]
    vaddpd zmm1, zmm1, [r7 + T_WS + 832]
    vmovapd zmm2, [r7 + T_WS + 640]
    vaddpd zmm2, zmm2, [r7 + T_WS + 896]
    vmovapd zmm3, [r7 + T_WS + 704]
    vaddpd zmm3, zmm3, [r7 + T_WS + 960]
    vaddpd zmm0, zmm0, zmm2
    vaddpd zmm1, zmm1, zmm3
    vaddpd zmm0, zmm0, zmm1
    vmovapd zmm1, [r7 + T_WAA + 64]
    vaddpd zmm1, zmm1, zmm0
    vmovapd [r7 + T_WAA + 64], zmm1
    vmovapd zmm0, [r7 + T_WE + 512]
    vaddpd zmm0, zmm0, [r7 + T_WE + 768]
    vmovapd zmm1, [r7 + T_WE + 576]
    vaddpd zmm1, zmm1, [r7 + T_WE + 832]
    vmovapd zmm2, [r7 + T_WE + 640]
    vaddpd zmm2, zmm2, [r7 + T_WE + 896]
    vmovapd zmm3, [r7 + T_WE + 704]
    vaddpd zmm3, zmm3, [r7 + T_WE + 960]
    vaddpd zmm0, zmm0, zmm2
    vaddpd zmm1, zmm1, zmm3
    vaddpd zmm0, zmm0, zmm1
    vmovapd zmm1, [r7 + T_WLA + 64]
    vaddpd zmm1, zmm1, zmm0
    vmovapd [r7 + T_WLA + 64], zmm1
    vmovapd zmm0, [r7 + T_WS + 1024]
    vaddpd zmm0, zmm0, [r7 + T_WS + 1280]
    vmovapd zmm1, [r7 + T_WS + 1088]
    vaddpd zmm1, zmm1, [r7 + T_WS + 1344]
    vmovapd zmm2, [r7 + T_WS + 1152]
    vaddpd zmm2, zmm2, [r7 + T_WS + 1408]
    vmovapd zmm3, [r7 + T_WS + 1216]
    vaddpd zmm3, zmm3, [r7 + T_WS + 1472]
    vaddpd zmm0, zmm0, zmm2
    vaddpd zmm1, zmm1, zmm3
    vaddpd zmm0, zmm0, zmm1
    vmovapd zmm1, [r7 + T_WAA + 128]
    vaddpd zmm1, zmm1, zmm0
    vmovapd [r7 + T_WAA + 128], zmm1
    vmovapd zmm0, [r7 + T_WE + 1024]
    vaddpd zmm0, zmm0, [r7 + T_WE + 1280]
    vmovapd zmm1, [r7 + T_WE + 1088]
    vaddpd zmm1, zmm1, [r7 + T_WE + 1344]
    vmovapd zmm2, [r7 + T_WE + 1152]
    vaddpd zmm2, zmm2, [r7 + T_WE + 1408]
    vmovapd zmm3, [r7 + T_WE + 1216]
    vaddpd zmm3, zmm3, [r7 + T_WE + 1472]
    vaddpd zmm0, zmm0, zmm2
    vaddpd zmm1, zmm1, zmm3
    vaddpd zmm0, zmm0, zmm1
    vmovapd zmm1, [r7 + T_WLA + 128]
    vaddpd zmm1, zmm1, zmm0
    vmovapd [r7 + T_WLA + 128], zmm1
    add r2d, 512
    cmp r2d, 1024
    jb .w2cg
    xor r3d, r3d
.w2cv:
    vmovapd zmm2, [r7 + r3 + T_WLA]
    vmulpd zmm2, zmm2, [t_six]{1to8}
    vandpd zmm3, zmm2, [t_abs2]{1to8}
    vxorpd zmm3, zmm3, [t_sgn2]{1to8}
    vmovapd zmm4, [r7 + r3 + T_WAA]
    vfmadd132pd zmm4, zmm3, [t_six]{1to8}
    vbroadcastsd zmm5, [t_tab]
    vfmadd132pd zmm4, zmm5, [t_rg2]{1to8}
    vmovapd zmm0, zmm2
    vmovapd zmm15, zmm4
    vbroadcastsd zmm1, [t_rg2]
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm1, zmm2
    vsubpd zmm4, zmm2, zmm3
    vcmppd k1, zmm4, zmm3, 0x1e
    vaddpd zmm5, zmm2, zmm3
    vmovapd zmm5{k1}, zmm2
    vpsrlq zmm1, zmm5, 48
    vmovapd zmm10, [t_rx]
    vpermt2pd zmm10, zmm1, [t_rx + 64]
    vgetmantpd zmm2, zmm5, 4
    vfmsub213pd zmm2, zmm10, [t_one]{1to8}
    vmulpd zmm7, zmm2, zmm2
    vpsrlq zmm8, zmm5, 52
    vmovapd zmm6, [t_oa]
    vpermt2pd zmm6, zmm8, [t_oa + 64]
    vpsrlq zmm9, zmm5, 56
    vpermpd zmm9, zmm9, [t_ob]
    vmovapd zmm10, [t_ow]
    vpermt2pd zmm10, zmm1, [t_ow + 64]
    vbroadcastsd zmm11, [t_op3]
    vfmadd213pd zmm11, zmm2, [t_op2]{1to8}
    vbroadcastsd zmm8, [t_op4]
    vfmadd213pd zmm8, zmm7, zmm11
    vbroadcastsd zmm11, [t_op1]
    vfmadd213pd zmm11, zmm2, [t_op0]{1to8}
    vfmadd213pd zmm8, zmm7, zmm11
    vmulpd zmm6, zmm6, zmm9
    vmulpd zmm6, zmm6, zmm10
    vmulpd zmm6, zmm6, zmm8
    vrcp14pd zmm7, zmm4
    vmulpd zmm7{k1}{z}, zmm3, zmm7
    vbroadcastsd zmm11, [t_omg]
    vfmadd132pd zmm7, zmm11, [t_eq0]{1to8}
    vmovapd zmm8, zmm6
    vfmadd231pd zmm8, zmm7, zmm6
    vpxorq zmm9, zmm8, [t_sign]{1to8}
    vmovapd zmm10, zmm6
    vfnmadd231pd zmm10{k1}{z}, zmm7, zmm6
    vcmppd k2, zmm4, [t_zero]{1to8}, 0x1a
    vmovapd zmm10{k2}, zmm9
    vpxorq zmm12, zmm10, [t_sign]{1to8}
    vpmovq2m k3, zmm0
    vmovapd zmm10{k3}, zmm9
    vmovapd zmm8{k3}, zmm12
    vmovapd [r7 + r3 + T_WLO], zmm10
    vmovapd [r7 + r3 + T_WHI], zmm8
    add r3d, 64
    cmp r3d, 192
    jb .w2cv
    vbroadcastsd zmm0, [t_clo]
    vbroadcastsd zmm1, [t_emc5]
    vfnmadd231pd zmm0, zmm1, [r7 + T_WHI + 64]
    vbroadcastsd zmm1, [t_emc4]
    vfnmadd231pd zmm0, zmm1, [r7 + T_WHI]
    vbroadcastsd zmm1, [t_emc3]
    vfmadd231pd zmm0, zmm1, [r7 + T_WLO + 128]
    vbroadcastsd zmm2, [t_chi]
    vbroadcastsd zmm1, [t_emc5]
    vfnmadd231pd zmm2, zmm1, [r7 + T_WLO + 64]
    vbroadcastsd zmm1, [t_emc4]
    vfnmadd231pd zmm2, zmm1, [r7 + T_WLO]
    vbroadcastsd zmm1, [t_emc3]
    vfmadd231pd zmm2, zmm1, [r7 + T_WHI + 128]
    vrndscalepd zmm0, zmm0, 8
    vrndscalepd zmm2, zmm2, 8
    vcvttpd2dq ymm4, zmm0
    vpmovsxdq zmm4, ymm4
    vpxorq zmm3, zmm3, zmm3
    vpmaxsq zmm4, zmm4, zmm3
    vpminsq zmm4, zmm4, [t_q1023]{1to8}
    vpcmpq k1, zmm0, zmm2, 4
    vpternlogq zmm4{k1}, zmm4, zmm4, 0xff
    vbroadcastsd zmm0, [t_clo]
    vbroadcastsd zmm1, [t_emc8]
    vfnmadd231pd zmm0, zmm1, [r7 + T_WHI + 128]
    vbroadcastsd zmm1, [t_emc7]
    vfnmadd231pd zmm0, zmm1, [r7 + T_WHI + 64]
    vbroadcastsd zmm1, [t_emc6]
    vfmadd231pd zmm0, zmm1, [r7 + T_WLO]
    vbroadcastsd zmm2, [t_chi]
    vbroadcastsd zmm1, [t_emc8]
    vfnmadd231pd zmm2, zmm1, [r7 + T_WLO + 128]
    vbroadcastsd zmm1, [t_emc7]
    vfnmadd231pd zmm2, zmm1, [r7 + T_WLO + 64]
    vbroadcastsd zmm1, [t_emc6]
    vfmadd231pd zmm2, zmm1, [r7 + T_WHI]
    vrndscalepd zmm0, zmm0, 8
    vrndscalepd zmm2, zmm2, 8
    vcvttpd2dq ymm5, zmm0
    vpmovsxdq zmm5, ymm5
    vpxorq zmm3, zmm3, zmm3
    vpmaxsq zmm5, zmm5, zmm3
    vpminsq zmm5, zmm5, [t_q1023]{1to8}
    vpcmpq k1, zmm0, zmm2, 4
    vpternlogq zmm5{k1}, zmm5, zmm5, 0xff
    vporq zmm6, zmm4, zmm5
    vpmovq2m k2, zmm6
    vpsllq zmm5, zmm5, 16
    vporq zmm4, zmm4, zmm5
    vpternlogq zmm4{k2}, zmm4, zmm4, 0xff
    ret
.c2l:
    test r6d, r6d
    jz .g2l
    cmp dword [r7 + T_J], 2
    jb .g2l
    mov [r7 + T_XL], r6d
    mov r4, [r10 + 16 + S_SRC]
    mov r3d, [r7 + T_J]
    imul r3, r3, 4*W
    add r3, r4
    mov r2d, r6d
    movzx r1d, word [r3 + r2*4]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + T_SY], xmm0
    movzx r1d, word [r3 + r2*4 + 2]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + T_SY + 8], xmm0
    movzx r1d, word [r3 + r2*4 + 2*W]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + T_SY + 16], xmm0
    movzx r1d, word [r3 + r2*4 + 2*W + 2]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + T_SY + 24], xmm0
    mov r3d, [r7 + T_J]
    sub r3d, 2
    imul r3, r3, CST
    lea r2, [r4 + r3 + CB - 2]
    lea r2, [r2 + r6*2]
    vpmovzxwd xmm8, [r2]
    vpmovzxwd xmm9, [r2 + CRD]
    vcvtdq2ps xmm8, xmm8
    vcvtdq2ps xmm9, xmm9
    vpmovzxwd xmm10, [r2 + CST]
    vpmovzxwd xmm11, [r2 + CST + CRD]
    vcvtdq2ps xmm10, xmm10
    vcvtdq2ps xmm11, xmm11
    vpmovzxwd xmm12, [r2 + 2*CST]
    vpmovzxwd xmm13, [r2 + 2*CST + CRD]
    vcvtdq2ps xmm12, xmm12
    vcvtdq2ps xmm13, xmm13
    vpmovzxwd xmm14, [r2 + 3*CST]
    vpmovzxwd xmm15, [r2 + 3*CST + CRD]
    vcvtdq2ps xmm14, xmm14
    vcvtdq2ps xmm15, xmm15
    vpmovzxwd xmm16, [r2 + 4*CST]
    vpmovzxwd xmm17, [r2 + 4*CST + CRD]
    vcvtdq2ps xmm16, xmm16
    vcvtdq2ps xmm17, xmm17
    vxorps xmm20, xmm20, xmm20
    vfmadd231ps xmm20, xmm8, [t_k75]{1to4}
    vfmadd231ps xmm20, xmm10, [t_k75 + 4]{1to4}
    vfmadd231ps xmm20, xmm12, [t_k75 + 8]{1to4}
    vfmadd231ps xmm20, xmm14, [t_k75 + 12]{1to4}
    vxorps xmm21, xmm21, xmm21
    vfmadd231ps xmm21, xmm9, [t_k75]{1to4}
    vfmadd231ps xmm21, xmm11, [t_k75 + 4]{1to4}
    vfmadd231ps xmm21, xmm13, [t_k75 + 8]{1to4}
    vfmadd231ps xmm21, xmm15, [t_k75 + 12]{1to4}
    vxorps xmm22, xmm22, xmm22
    vfmadd231ps xmm22, xmm10, [t_k25]{1to4}
    vfmadd231ps xmm22, xmm12, [t_k25 + 4]{1to4}
    vfmadd231ps xmm22, xmm14, [t_k25 + 8]{1to4}
    vfmadd231ps xmm22, xmm16, [t_k25 + 12]{1to4}
    vxorps xmm23, xmm23, xmm23
    vfmadd231ps xmm23, xmm11, [t_k25]{1to4}
    vfmadd231ps xmm23, xmm13, [t_k25 + 4]{1to4}
    vfmadd231ps xmm23, xmm15, [t_k25 + 8]{1to4}
    vfmadd231ps xmm23, xmm17, [t_k25 + 12]{1to4}
    vmovdqa xmm7, [t_q2j]
    vxorps xmm2, xmm2, xmm2
    vfmadd231ps xmm2, xmm20, [t_k50]{1to4}
    valignd xmm3, xmm20, xmm20, 1
    vfmadd231ps xmm2, xmm3, [t_k50 + 4]{1to4}
    valignd xmm3, xmm20, xmm20, 2
    vfmadd231ps xmm2, xmm3, [t_k50 + 8]{1to4}
    valignd xmm3, xmm20, xmm20, 3
    vfmadd231ps xmm2, xmm3, [t_k50 + 12]{1to4}
    vpermt2ps xmm2, xmm7, xmm20
    vcvtps2pd xmm2, xmm2
    vsubpd xmm2, xmm2, [t_512]{1to2}
    vmovupd [r7 + T_SB], xmm2
    vxorps xmm2, xmm2, xmm2
    vfmadd231ps xmm2, xmm21, [t_k50]{1to4}
    valignd xmm3, xmm21, xmm21, 1
    vfmadd231ps xmm2, xmm3, [t_k50 + 4]{1to4}
    valignd xmm3, xmm21, xmm21, 2
    vfmadd231ps xmm2, xmm3, [t_k50 + 8]{1to4}
    valignd xmm3, xmm21, xmm21, 3
    vfmadd231ps xmm2, xmm3, [t_k50 + 12]{1to4}
    vpermt2ps xmm2, xmm7, xmm21
    vcvtps2pd xmm2, xmm2
    vsubpd xmm2, xmm2, [t_512]{1to2}
    vmovupd [r7 + T_SR], xmm2
    vxorps xmm2, xmm2, xmm2
    vfmadd231ps xmm2, xmm22, [t_k50]{1to4}
    valignd xmm3, xmm22, xmm22, 1
    vfmadd231ps xmm2, xmm3, [t_k50 + 4]{1to4}
    valignd xmm3, xmm22, xmm22, 2
    vfmadd231ps xmm2, xmm3, [t_k50 + 8]{1to4}
    valignd xmm3, xmm22, xmm22, 3
    vfmadd231ps xmm2, xmm3, [t_k50 + 12]{1to4}
    vpermt2ps xmm2, xmm7, xmm22
    vcvtps2pd xmm2, xmm2
    vsubpd xmm2, xmm2, [t_512]{1to2}
    vmovupd [r7 + T_SB + 16], xmm2
    vxorps xmm2, xmm2, xmm2
    vfmadd231ps xmm2, xmm23, [t_k50]{1to4}
    valignd xmm3, xmm23, xmm23, 1
    vfmadd231ps xmm2, xmm3, [t_k50 + 4]{1to4}
    valignd xmm3, xmm23, xmm23, 2
    vfmadd231ps xmm2, xmm3, [t_k50 + 8]{1to4}
    valignd xmm3, xmm23, xmm23, 3
    vfmadd231ps xmm2, xmm3, [t_k50 + 12]{1to4}
    vpermt2ps xmm2, xmm7, xmm23
    vcvtps2pd xmm2, xmm2
    vsubpd xmm2, xmm2, [t_512]{1to2}
    vmovupd [r7 + T_SR + 16], xmm2
    ret
.c2c:
    test r6d, r6d
    jz .g2c
    cmp dword [r7 + T_J], 0
    je .g2c
    mov [r7 + T_XL], r6d
    mov r4, [r10 + 16 + S_SRC]
    mov r3d, [r7 + T_J]
    imul r3, r3, 8*W
    add r3, r4
    lea r3, [r3 + r6*8 - 2]
    vpmovzxwd xmm2, [r3]
    vcvtdq2pd ymm2, xmm2
    vmovupd [r7 + T_SY], ymm2
    vpmovzxwd xmm2, [r3 + 2*W]
    vcvtdq2pd ymm2, xmm2
    vmovupd [r7 + T_SY + 32], ymm2
    vpmovzxwd xmm2, [r3 + 4*W]
    vcvtdq2pd ymm2, xmm2
    vmovupd [r7 + T_SY + 64], ymm2
    vpmovzxwd xmm2, [r3 + 6*W]
    vcvtdq2pd ymm2, xmm2
    vmovupd [r7 + T_SY + 96], ymm2
    mov r3d, [r7 + T_J]
    lea r3d, [r3*2 - 2]
    imul r3, r3, CST
    lea r2, [r4 + r3 + CB - 4]
    lea r2, [r2 + r6*4]
    vpmovzxwd ymm8, [r2]
    vpmovzxwd ymm9, [r2 + CRD]
    vcvtdq2ps ymm8, ymm8
    vcvtdq2ps ymm9, ymm9
    vpmovzxwd ymm10, [r2 + CST]
    vpmovzxwd ymm11, [r2 + CST + CRD]
    vcvtdq2ps ymm10, ymm10
    vcvtdq2ps ymm11, ymm11
    vpmovzxwd ymm12, [r2 + 2*CST]
    vpmovzxwd ymm13, [r2 + 2*CST + CRD]
    vcvtdq2ps ymm12, ymm12
    vcvtdq2ps ymm13, ymm13
    vpmovzxwd ymm14, [r2 + 3*CST]
    vpmovzxwd ymm15, [r2 + 3*CST + CRD]
    vcvtdq2ps ymm14, ymm14
    vcvtdq2ps ymm15, ymm15
    vpmovzxwd ymm16, [r2 + 4*CST]
    vpmovzxwd ymm17, [r2 + 4*CST + CRD]
    vcvtdq2ps ymm16, ymm16
    vcvtdq2ps ymm17, ymm17
    vpmovzxwd ymm18, [r2 + 5*CST]
    vpmovzxwd ymm19, [r2 + 5*CST + CRD]
    vcvtdq2ps ymm18, ymm18
    vcvtdq2ps ymm19, ymm19
    vxorps ymm20, ymm20, ymm20
    vfmadd231ps ymm20, ymm8, [t_k75]{1to8}
    vfmadd231ps ymm20, ymm10, [t_k75 + 4]{1to8}
    vfmadd231ps ymm20, ymm12, [t_k75 + 8]{1to8}
    vfmadd231ps ymm20, ymm14, [t_k75 + 12]{1to8}
    vxorps ymm21, ymm21, ymm21
    vfmadd231ps ymm21, ymm9, [t_k75]{1to8}
    vfmadd231ps ymm21, ymm11, [t_k75 + 4]{1to8}
    vfmadd231ps ymm21, ymm13, [t_k75 + 8]{1to8}
    vfmadd231ps ymm21, ymm15, [t_k75 + 12]{1to8}
    vxorps ymm22, ymm22, ymm22
    vfmadd231ps ymm22, ymm10, [t_k25]{1to8}
    vfmadd231ps ymm22, ymm12, [t_k25 + 4]{1to8}
    vfmadd231ps ymm22, ymm14, [t_k25 + 8]{1to8}
    vfmadd231ps ymm22, ymm16, [t_k25 + 12]{1to8}
    vxorps ymm23, ymm23, ymm23
    vfmadd231ps ymm23, ymm11, [t_k25]{1to8}
    vfmadd231ps ymm23, ymm13, [t_k25 + 4]{1to8}
    vfmadd231ps ymm23, ymm15, [t_k25 + 8]{1to8}
    vfmadd231ps ymm23, ymm17, [t_k25 + 12]{1to8}
    vxorps ymm24, ymm24, ymm24
    vfmadd231ps ymm24, ymm10, [t_k75]{1to8}
    vfmadd231ps ymm24, ymm12, [t_k75 + 4]{1to8}
    vfmadd231ps ymm24, ymm14, [t_k75 + 8]{1to8}
    vfmadd231ps ymm24, ymm16, [t_k75 + 12]{1to8}
    vxorps ymm25, ymm25, ymm25
    vfmadd231ps ymm25, ymm11, [t_k75]{1to8}
    vfmadd231ps ymm25, ymm13, [t_k75 + 4]{1to8}
    vfmadd231ps ymm25, ymm15, [t_k75 + 8]{1to8}
    vfmadd231ps ymm25, ymm17, [t_k75 + 12]{1to8}
    vxorps ymm26, ymm26, ymm26
    vfmadd231ps ymm26, ymm12, [t_k25]{1to8}
    vfmadd231ps ymm26, ymm14, [t_k25 + 4]{1to8}
    vfmadd231ps ymm26, ymm16, [t_k25 + 8]{1to8}
    vfmadd231ps ymm26, ymm18, [t_k25 + 12]{1to8}
    vxorps ymm27, ymm27, ymm27
    vfmadd231ps ymm27, ymm13, [t_k25]{1to8}
    vfmadd231ps ymm27, ymm15, [t_k25 + 4]{1to8}
    vfmadd231ps ymm27, ymm17, [t_k25 + 8]{1to8}
    vfmadd231ps ymm27, ymm19, [t_k25 + 12]{1to8}
    vmovdqa xmm7, [t_q2i]
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm20, [t_k50]{1to8}
    valignd ymm3, ymm20, ymm20, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm20, ymm20, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm20, ymm20, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm20
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovupd [r7 + T_SB], ymm2
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm21, [t_k50]{1to8}
    valignd ymm3, ymm21, ymm21, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm21, ymm21, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm21, ymm21, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm21
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovupd [r7 + T_SR], ymm2
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm22, [t_k50]{1to8}
    valignd ymm3, ymm22, ymm22, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm22, ymm22, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm22, ymm22, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm22
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovupd [r7 + T_SB + 32], ymm2
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm23, [t_k50]{1to8}
    valignd ymm3, ymm23, ymm23, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm23, ymm23, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm23, ymm23, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm23
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovupd [r7 + T_SR + 32], ymm2
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm24, [t_k50]{1to8}
    valignd ymm3, ymm24, ymm24, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm24, ymm24, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm24, ymm24, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm24
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovupd [r7 + T_SB + 64], ymm2
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm25, [t_k50]{1to8}
    valignd ymm3, ymm25, ymm25, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm25, ymm25, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm25, ymm25, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm25
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovupd [r7 + T_SR + 64], ymm2
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm26, [t_k50]{1to8}
    valignd ymm3, ymm26, ymm26, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm26, ymm26, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm26, ymm26, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm26
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovupd [r7 + T_SB + 96], ymm2
    vxorps ymm2, ymm2, ymm2
    vfmadd231ps ymm2, ymm27, [t_k50]{1to8}
    valignd ymm3, ymm27, ymm27, 1
    vfmadd231ps ymm2, ymm3, [t_k50 + 4]{1to8}
    valignd ymm3, ymm27, ymm27, 2
    vfmadd231ps ymm2, ymm3, [t_k50 + 8]{1to8}
    valignd ymm3, ymm27, ymm27, 3
    vfmadd231ps ymm2, ymm3, [t_k50 + 12]{1to8}
    vpermt2ps xmm2, xmm7, xmm27
    vcvtps2pd ymm2, xmm2
    vsubpd ymm2, ymm2, [t_512]{1to4}
    vmovupd [r7 + T_SR + 96], ymm2
    ret
.h2l:
    mov [r7 + T_XL], r6d
    mov r4, [r10 + 16 + S_SRC]
    mov r3d, [r7 + T_J]
    imul r3, r3, 4*W
    add r3, r4
    mov r2d, r6d
    movzx r1d, word [r3 + r2*4]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + r5 + T_WY], xmm0
    movzx r1d, word [r3 + r2*4 + 2]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + r5 + T_WY + 64], xmm0
    movzx r1d, word [r3 + r2*4 + 2*W]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + r5 + T_WY + 128], xmm0
    movzx r1d, word [r3 + r2*4 + 2*W + 2]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + r5 + T_WY + 192], xmm0
    mov r3d, [r7 + T_J]
    lea r3d, [r3*2]
    mov r2d, [r7 + T_XL]
    dec r2d
    call .cvr
    vmovaps [r7 + T_VB], ymm0
    vmovaps [r7 + T_VB + 32], ymm1
    vmovss xmm2, [r7 + T_VB + 4]
    vmovss xmm3, [r7 + T_VB + 36]
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 32]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + r5 + T_WB], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + r5 + T_WR], xmm3
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + r5 + T_WB + 64], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + r5 + T_WR + 64], xmm5
    mov r3d, [r7 + T_J]
    lea r3d, [r3*2 + 1]
    mov r2d, [r7 + T_XL]
    dec r2d
    call .cvr
    vmovaps [r7 + T_VB], ymm0
    vmovaps [r7 + T_VB + 32], ymm1
    vmovss xmm2, [r7 + T_VB + 4]
    vmovss xmm3, [r7 + T_VB + 36]
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 32]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + r5 + T_WB + 128], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + r5 + T_WR + 128], xmm3
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + r5 + T_WB + 192], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + r5 + T_WR + 192], xmm5
    ret
.h2c:
    mov [r7 + T_XL], r6d
    mov r4, [r10 + 16 + S_SRC]
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4]
    imul r3, r3, 2*W
    add r3, r4
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*4 - 1]
    xor r6d, r6d
    mov r1d, r2d
    test r1d, r1d
    cmovs r1d, r6d
    vpbroadcastd ymm7, r2d
    vpaddd ymm7, ymm7, [t_iota]
    vpxor ymm6, ymm6, ymm6
    vpmaxsd ymm7, ymm7, ymm6
    vpbroadcastd ymm6, r1d
    vpsubd ymm7, ymm7, ymm6
    vpmovzxwd ymm2, [r3 + r1*2]
    vpermd ymm2, ymm7, ymm2
    vcvtdq2pd ymm2, xmm2
    vmovsd [r7 + r5 + T_WY], xmm2
    vmovhpd [r7 + r5 + T_WY + 64], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WY + 128], xmm2
    vmovhpd [r7 + r5 + T_WY + 192], xmm2
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4]
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*2 - 2]
    call .cvr
    vmovaps [r7 + T_VB], ymm0
    vmovaps [r7 + T_VB + 32], ymm1
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 32]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    xor r3d, r3d
    cmp dword [r7 + T_XL], 0
    sete r3b
    kmovb k1, r3d
    vmovss xmm4{k1}, [r7 + T_VB + 8]
    vmovss xmm5{k1}, [r7 + T_VB + 40]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + r5 + T_WB], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + r5 + T_WR], xmm5
    vmovss xmm2, [r7 + T_VB + 8]
    vmovss xmm3, [r7 + T_VB + 40]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + r5 + T_WB + 64], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + r5 + T_WR + 64], xmm3
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 16]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 48]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + r5 + T_WB + 128], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + r5 + T_WR + 128], xmm5
    vmovss xmm2, [r7 + T_VB + 12]
    vmovss xmm3, [r7 + T_VB + 44]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + r5 + T_WB + 192], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + r5 + T_WR + 192], xmm3
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4 + 1]
    imul r3, r3, 2*W
    add r3, r4
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*4 - 1]
    xor r6d, r6d
    mov r1d, r2d
    test r1d, r1d
    cmovs r1d, r6d
    vpbroadcastd ymm7, r2d
    vpaddd ymm7, ymm7, [t_iota]
    vpxor ymm6, ymm6, ymm6
    vpmaxsd ymm7, ymm7, ymm6
    vpbroadcastd ymm6, r1d
    vpsubd ymm7, ymm7, ymm6
    vpmovzxwd ymm2, [r3 + r1*2]
    vpermd ymm2, ymm7, ymm2
    vcvtdq2pd ymm2, xmm2
    vmovsd [r7 + r5 + T_WY + 256], xmm2
    vmovhpd [r7 + r5 + T_WY + 320], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WY + 384], xmm2
    vmovhpd [r7 + r5 + T_WY + 448], xmm2
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4 + 1]
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*2 - 2]
    call .cvr
    vmovaps [r7 + T_VB], ymm0
    vmovaps [r7 + T_VB + 32], ymm1
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 32]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    xor r3d, r3d
    cmp dword [r7 + T_XL], 0
    sete r3b
    kmovb k1, r3d
    vmovss xmm4{k1}, [r7 + T_VB + 8]
    vmovss xmm5{k1}, [r7 + T_VB + 40]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + r5 + T_WB + 256], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + r5 + T_WR + 256], xmm5
    vmovss xmm2, [r7 + T_VB + 8]
    vmovss xmm3, [r7 + T_VB + 40]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + r5 + T_WB + 320], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + r5 + T_WR + 320], xmm3
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 16]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 48]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + r5 + T_WB + 384], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + r5 + T_WR + 384], xmm5
    vmovss xmm2, [r7 + T_VB + 12]
    vmovss xmm3, [r7 + T_VB + 44]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + r5 + T_WB + 448], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + r5 + T_WR + 448], xmm3
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4 + 2]
    imul r3, r3, 2*W
    add r3, r4
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*4 - 1]
    xor r6d, r6d
    mov r1d, r2d
    test r1d, r1d
    cmovs r1d, r6d
    vpbroadcastd ymm7, r2d
    vpaddd ymm7, ymm7, [t_iota]
    vpxor ymm6, ymm6, ymm6
    vpmaxsd ymm7, ymm7, ymm6
    vpbroadcastd ymm6, r1d
    vpsubd ymm7, ymm7, ymm6
    vpmovzxwd ymm2, [r3 + r1*2]
    vpermd ymm2, ymm7, ymm2
    vcvtdq2pd ymm2, xmm2
    vmovsd [r7 + r5 + T_WY + 512], xmm2
    vmovhpd [r7 + r5 + T_WY + 576], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WY + 640], xmm2
    vmovhpd [r7 + r5 + T_WY + 704], xmm2
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4 + 2]
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*2 - 2]
    call .cvr
    vmovaps [r7 + T_VB], ymm0
    vmovaps [r7 + T_VB + 32], ymm1
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 32]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    xor r3d, r3d
    cmp dword [r7 + T_XL], 0
    sete r3b
    kmovb k1, r3d
    vmovss xmm4{k1}, [r7 + T_VB + 8]
    vmovss xmm5{k1}, [r7 + T_VB + 40]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + r5 + T_WB + 512], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + r5 + T_WR + 512], xmm5
    vmovss xmm2, [r7 + T_VB + 8]
    vmovss xmm3, [r7 + T_VB + 40]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + r5 + T_WB + 576], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + r5 + T_WR + 576], xmm3
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 16]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 48]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + r5 + T_WB + 640], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + r5 + T_WR + 640], xmm5
    vmovss xmm2, [r7 + T_VB + 12]
    vmovss xmm3, [r7 + T_VB + 44]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + r5 + T_WB + 704], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + r5 + T_WR + 704], xmm3
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4 + 3]
    imul r3, r3, 2*W
    add r3, r4
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*4 - 1]
    xor r6d, r6d
    mov r1d, r2d
    test r1d, r1d
    cmovs r1d, r6d
    vpbroadcastd ymm7, r2d
    vpaddd ymm7, ymm7, [t_iota]
    vpxor ymm6, ymm6, ymm6
    vpmaxsd ymm7, ymm7, ymm6
    vpbroadcastd ymm6, r1d
    vpsubd ymm7, ymm7, ymm6
    vpmovzxwd ymm2, [r3 + r1*2]
    vpermd ymm2, ymm7, ymm2
    vcvtdq2pd ymm2, xmm2
    vmovsd [r7 + r5 + T_WY + 768], xmm2
    vmovhpd [r7 + r5 + T_WY + 832], xmm2
    vextractf128 xmm2, ymm2, 1
    vmovsd [r7 + r5 + T_WY + 896], xmm2
    vmovhpd [r7 + r5 + T_WY + 960], xmm2
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4 + 3]
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*2 - 2]
    call .cvr
    vmovaps [r7 + T_VB], ymm0
    vmovaps [r7 + T_VB + 32], ymm1
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 32]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    xor r3d, r3d
    cmp dword [r7 + T_XL], 0
    sete r3b
    kmovb k1, r3d
    vmovss xmm4{k1}, [r7 + T_VB + 8]
    vmovss xmm5{k1}, [r7 + T_VB + 40]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + r5 + T_WB + 768], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + r5 + T_WR + 768], xmm5
    vmovss xmm2, [r7 + T_VB + 8]
    vmovss xmm3, [r7 + T_VB + 40]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + r5 + T_WB + 832], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + r5 + T_WR + 832], xmm3
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 16]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 48]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + r5 + T_WB + 896], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + r5 + T_WR + 896], xmm5
    vmovss xmm2, [r7 + T_VB + 12]
    vmovss xmm3, [r7 + T_VB + 44]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + r5 + T_WB + 960], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + r5 + T_WR + 960], xmm3
    ret
.t2l:
    mov r6d, 15
    kmovb k4, r6d
    vpxorq zmm0, zmm0, zmm0
    vmovapd [r7 + T_AA], zmm0
    vmovapd [r7 + T_LA], zmm0
    vmovapd zmm0{k4}{z}, [r7 + T_SY]
    vmovapd zmm1{k4}{z}, [r7 + T_SB]
    vmovapd zmm2{k4}{z}, [r7 + T_SR]
    vbroadcastsd zmm3, [t_lzm5]
    vfmadd231pd zmm3, zmm0, [t_lzm0]{1to8}
    vmovapd zmm4, zmm3
    vfmadd231pd zmm4, zmm2, [t_lzm1]{1to8}
    vmovapd zmm5, zmm3
    vfmadd231pd zmm5, zmm2, [t_lzm2]{1to8}
    vfmadd231pd zmm5, zmm1, [t_lzm3]{1to8}
    vmovapd zmm6, zmm3
    vfmadd231pd zmm6, zmm1, [t_lzm4]{1to8}
    vrangepd zmm7, zmm4, [t_xflr]{1to8}, 0x0b
    vpsrlq zmm8, zmm7, 52
    vpsrlq zmm9, zmm7, 48
    vmovapd zmm10, [t_tsl]
    vpermt2pd zmm10, zmm8, [t_tsl + 64]
    vmovapd zmm12, [t_rx]
    vpermt2pd zmm12, zmm9, [t_rx + 64]
    vgetmantpd zmm11, zmm7, 4
    vfmsub213pd zmm11, zmm12, [t_one]{1to8}
    vptestnmq k5, zmm8, [t_q16]{1to8}
    vmulpd zmm10{k5}, zmm10, [t_tsk]{1to8}
    vmovapd zmm12, [t_wsx]
    vpermt2pd zmm12, zmm9, [t_wsx + 64]
    vmulpd zmm10, zmm10, zmm12
    vaddpd zmm13, zmm11, [t_psx3]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx2]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx1]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx0]{1to8}
    vmulpd zmm7, zmm10, zmm13
    vmovapd zmm8{k4}{z}, zmm7
    vmovdqa64 zmm9, zmm7
    vpternlogq zmm9, zmm4, [t_sign]{1to8}, 0xd8
    vmovapd zmm9{k4}{z}, zmm9
    vextractf64x4 ymm10, zmm8, 1
    vaddpd ymm8, ymm8, ymm10
    vextractf128 xmm10, ymm8, 1
    vaddpd xmm8, xmm8, xmm10
    vshufpd xmm10, xmm8, xmm8, 1
    vaddsd xmm8, xmm8, xmm10
    vextractf64x4 ymm11, zmm9, 1
    vaddpd ymm9, ymm9, ymm11
    vextractf128 xmm11, ymm9, 1
    vaddpd xmm9, xmm9, xmm11
    vshufpd xmm11, xmm9, xmm9, 1
    vaddsd xmm9, xmm9, xmm11
    vmovsd xmm10, [r7 + T_AA]
    vaddsd xmm10, xmm10, xmm8
    vmovsd [r7 + T_AA], xmm10
    vmovsd xmm11, [r7 + T_LA]
    vaddsd xmm11, xmm11, xmm9
    vmovsd [r7 + T_LA], xmm11
    vrangepd zmm7, zmm5, [t_xflr]{1to8}, 0x0b
    vpsrlq zmm8, zmm7, 52
    vpsrlq zmm9, zmm7, 48
    vmovapd zmm10, [t_tsl]
    vpermt2pd zmm10, zmm8, [t_tsl + 64]
    vmovapd zmm12, [t_rx]
    vpermt2pd zmm12, zmm9, [t_rx + 64]
    vgetmantpd zmm11, zmm7, 4
    vfmsub213pd zmm11, zmm12, [t_one]{1to8}
    vptestnmq k5, zmm8, [t_q16]{1to8}
    vmulpd zmm10{k5}, zmm10, [t_tsk]{1to8}
    vmovapd zmm12, [t_wsx]
    vpermt2pd zmm12, zmm9, [t_wsx + 64]
    vmulpd zmm10, zmm10, zmm12
    vaddpd zmm13, zmm11, [t_psx3]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx2]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx1]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx0]{1to8}
    vmulpd zmm7, zmm10, zmm13
    vmovapd zmm8{k4}{z}, zmm7
    vmovdqa64 zmm9, zmm7
    vpternlogq zmm9, zmm5, [t_sign]{1to8}, 0xd8
    vmovapd zmm9{k4}{z}, zmm9
    vextractf64x4 ymm10, zmm8, 1
    vaddpd ymm8, ymm8, ymm10
    vextractf128 xmm10, ymm8, 1
    vaddpd xmm8, xmm8, xmm10
    vshufpd xmm10, xmm8, xmm8, 1
    vaddsd xmm8, xmm8, xmm10
    vextractf64x4 ymm11, zmm9, 1
    vaddpd ymm9, ymm9, ymm11
    vextractf128 xmm11, ymm9, 1
    vaddpd xmm9, xmm9, xmm11
    vshufpd xmm11, xmm9, xmm9, 1
    vaddsd xmm9, xmm9, xmm11
    vmovsd xmm10, [r7 + T_AA + 8]
    vaddsd xmm10, xmm10, xmm8
    vmovsd [r7 + T_AA + 8], xmm10
    vmovsd xmm11, [r7 + T_LA + 8]
    vaddsd xmm11, xmm11, xmm9
    vmovsd [r7 + T_LA + 8], xmm11
    vrangepd zmm7, zmm6, [t_xflr]{1to8}, 0x0b
    vpsrlq zmm8, zmm7, 52
    vpsrlq zmm9, zmm7, 48
    vmovapd zmm10, [t_tsl]
    vpermt2pd zmm10, zmm8, [t_tsl + 64]
    vmovapd zmm12, [t_rx]
    vpermt2pd zmm12, zmm9, [t_rx + 64]
    vgetmantpd zmm11, zmm7, 4
    vfmsub213pd zmm11, zmm12, [t_one]{1to8}
    vptestnmq k5, zmm8, [t_q16]{1to8}
    vmulpd zmm10{k5}, zmm10, [t_tsk]{1to8}
    vmovapd zmm12, [t_wsx]
    vpermt2pd zmm12, zmm9, [t_wsx + 64]
    vmulpd zmm10, zmm10, zmm12
    vaddpd zmm13, zmm11, [t_psx3]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx2]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx1]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx0]{1to8}
    vmulpd zmm7, zmm10, zmm13
    vmovapd zmm8{k4}{z}, zmm7
    vmovdqa64 zmm9, zmm7
    vpternlogq zmm9, zmm6, [t_sign]{1to8}, 0xd8
    vmovapd zmm9{k4}{z}, zmm9
    vextractf64x4 ymm10, zmm8, 1
    vaddpd ymm8, ymm8, ymm10
    vextractf128 xmm10, ymm8, 1
    vaddpd xmm8, xmm8, xmm10
    vshufpd xmm10, xmm8, xmm8, 1
    vaddsd xmm8, xmm8, xmm10
    vextractf64x4 ymm11, zmm9, 1
    vaddpd ymm9, ymm9, ymm11
    vextractf128 xmm11, ymm9, 1
    vaddpd xmm9, xmm9, xmm11
    vshufpd xmm11, xmm9, xmm9, 1
    vaddsd xmm9, xmm9, xmm11
    vmovsd xmm10, [r7 + T_AA + 16]
    vaddsd xmm10, xmm10, xmm8
    vmovsd [r7 + T_AA + 16], xmm10
    vmovsd xmm11, [r7 + T_LA + 16]
    vaddsd xmm11, xmm11, xmm9
    vmovsd [r7 + T_LA + 16], xmm11
    vpxorq zmm0, zmm0, zmm0
    vmovapd [r7 + T_LV], zmm0
    vbroadcastsd zmm1, [t_tab]
    vmovapd [r7 + T_TV], zmm1
    vmovsd xmm2, [r7 + T_LA]
    vmulsd xmm2, xmm2, [t_quart]
    vmovsd [r7 + T_LV], xmm2
    vandpd xmm3, xmm2, [t_abs2]
    vxorpd xmm3, xmm3, [t_sgn2]
    vmovsd xmm4, [r7 + T_AA]
    vfmadd132sd xmm4, xmm3, [t_quart]
    vmovsd xmm5, [t_tab]
    vfmadd132sd xmm4, xmm5, [t_rg2]
    vmovsd [r7 + T_TV], xmm4
    vmovsd xmm2, [r7 + T_LA + 8]
    vmulsd xmm2, xmm2, [t_quart]
    vmovsd [r7 + T_LV + 8], xmm2
    vandpd xmm3, xmm2, [t_abs2]
    vxorpd xmm3, xmm3, [t_sgn2]
    vmovsd xmm4, [r7 + T_AA + 8]
    vfmadd132sd xmm4, xmm3, [t_quart]
    vmovsd xmm5, [t_tab]
    vfmadd132sd xmm4, xmm5, [t_rg2]
    vmovsd [r7 + T_TV + 8], xmm4
    vmovsd xmm2, [r7 + T_LA + 16]
    vmulsd xmm2, xmm2, [t_quart]
    vmovsd [r7 + T_LV + 16], xmm2
    vandpd xmm3, xmm2, [t_abs2]
    vxorpd xmm3, xmm3, [t_sgn2]
    vmovsd xmm4, [r7 + T_AA + 16]
    vfmadd132sd xmm4, xmm3, [t_quart]
    vmovsd xmm5, [t_tab]
    vfmadd132sd xmm4, xmm5, [t_rg2]
    vmovsd [r7 + T_TV + 16], xmm4
    vmovapd zmm0, [r7 + T_LV]
    vmovapd zmm15, [r7 + T_TV]
    vbroadcastsd zmm1, [t_rg2]
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm1, zmm2
    vsubpd zmm4, zmm2, zmm3
    vcmppd k1, zmm4, zmm3, 0x1e
    vaddpd zmm5, zmm2, zmm3
    vmovapd zmm5{k1}, zmm2
    vpsrlq zmm1, zmm5, 48
    vmovapd zmm10, [t_rx]
    vpermt2pd zmm10, zmm1, [t_rx + 64]
    vgetmantpd zmm2, zmm5, 4
    vfmsub213pd zmm2, zmm10, [t_one]{1to8}
    vmulpd zmm7, zmm2, zmm2
    vpsrlq zmm8, zmm5, 52
    vmovapd zmm6, [t_oa]
    vpermt2pd zmm6, zmm8, [t_oa + 64]
    vpsrlq zmm9, zmm5, 56
    vpermpd zmm9, zmm9, [t_ob]
    vmovapd zmm10, [t_ow]
    vpermt2pd zmm10, zmm1, [t_ow + 64]
    vbroadcastsd zmm11, [t_op3]
    vfmadd213pd zmm11, zmm2, [t_op2]{1to8}
    vbroadcastsd zmm8, [t_op4]
    vfmadd213pd zmm8, zmm7, zmm11
    vbroadcastsd zmm11, [t_op1]
    vfmadd213pd zmm11, zmm2, [t_op0]{1to8}
    vfmadd213pd zmm8, zmm7, zmm11
    vmulpd zmm6, zmm6, zmm9
    vmulpd zmm6, zmm6, zmm10
    vmulpd zmm6, zmm6, zmm8
    vrcp14pd zmm7, zmm4
    vmulpd zmm7{k1}{z}, zmm3, zmm7
    vbroadcastsd zmm11, [t_omg]
    vfmadd132pd zmm7, zmm11, [t_eq0]{1to8}
    vmovapd zmm8, zmm6
    vfmadd231pd zmm8, zmm7, zmm6
    vpxorq zmm9, zmm8, [t_sign]{1to8}
    vmovapd zmm10, zmm6
    vfnmadd231pd zmm10{k1}{z}, zmm7, zmm6
    vcmppd k2, zmm4, [t_zero]{1to8}, 0x1a
    vmovapd zmm10{k2}, zmm9
    vpxorq zmm12, zmm10, [t_sign]{1to8}
    vpmovq2m k3, zmm0
    vmovapd zmm10{k3}, zmm9
    vmovapd zmm8{k3}, zmm12
    vmovapd [r7 + T_LO], zmm10
    vmovapd [r7 + T_HI], zmm8
    vmovsd xmm0, [t_ylo]
    vmovsd xmm1, [t_emc0]
    vfmadd231sd xmm0, xmm1, [r7 + T_LO]
    vmovsd xmm1, [t_emc1]
    vfmadd231sd xmm0, xmm1, [r7 + T_LO + 8]
    vmovsd xmm1, [t_emc2]
    vfmadd231sd xmm0, xmm1, [r7 + T_LO + 16]
    vmovsd xmm2, [t_yhi]
    vmovsd xmm1, [t_emc0]
    vfmadd231sd xmm2, xmm1, [r7 + T_HI]
    vmovsd xmm1, [t_emc1]
    vfmadd231sd xmm2, xmm1, [r7 + T_HI + 8]
    vmovsd xmm1, [t_emc2]
    vfmadd231sd xmm2, xmm1, [r7 + T_HI + 16]
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
    mov r6d, 255
    kmovb k4, r6d
    vpxorq zmm0, zmm0, zmm0
    vmovapd [r7 + T_AA], zmm0
    vmovapd [r7 + T_LA], zmm0
    vmovapd zmm0{k4}{z}, [r7 + T_SY]
    vmovapd zmm1{k4}{z}, [r7 + T_SB]
    vmovapd zmm2{k4}{z}, [r7 + T_SR]
    vbroadcastsd zmm3, [t_lzm5]
    vfmadd231pd zmm3, zmm0, [t_lzm0]{1to8}
    vmovapd zmm4, zmm3
    vfmadd231pd zmm4, zmm2, [t_lzm1]{1to8}
    vmovapd zmm5, zmm3
    vfmadd231pd zmm5, zmm2, [t_lzm2]{1to8}
    vfmadd231pd zmm5, zmm1, [t_lzm3]{1to8}
    vmovapd zmm6, zmm3
    vfmadd231pd zmm6, zmm1, [t_lzm4]{1to8}
    vrangepd zmm7, zmm4, [t_xflr]{1to8}, 0x0b
    vpsrlq zmm8, zmm7, 52
    vpsrlq zmm9, zmm7, 48
    vmovapd zmm10, [t_tsl]
    vpermt2pd zmm10, zmm8, [t_tsl + 64]
    vmovapd zmm12, [t_rx]
    vpermt2pd zmm12, zmm9, [t_rx + 64]
    vgetmantpd zmm11, zmm7, 4
    vfmsub213pd zmm11, zmm12, [t_one]{1to8}
    vptestnmq k5, zmm8, [t_q16]{1to8}
    vmulpd zmm10{k5}, zmm10, [t_tsk]{1to8}
    vmovapd zmm12, [t_wsx]
    vpermt2pd zmm12, zmm9, [t_wsx + 64]
    vmulpd zmm10, zmm10, zmm12
    vaddpd zmm13, zmm11, [t_psx3]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx2]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx1]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx0]{1to8}
    vmulpd zmm7, zmm10, zmm13
    vmovapd zmm8{k4}{z}, zmm7
    vmovdqa64 zmm9, zmm7
    vpternlogq zmm9, zmm4, [t_sign]{1to8}, 0xd8
    vmovapd zmm9{k4}{z}, zmm9
    vextractf64x4 ymm10, zmm8, 1
    vaddpd ymm8, ymm8, ymm10
    vextractf128 xmm10, ymm8, 1
    vaddpd xmm8, xmm8, xmm10
    vshufpd xmm10, xmm8, xmm8, 1
    vaddsd xmm8, xmm8, xmm10
    vextractf64x4 ymm11, zmm9, 1
    vaddpd ymm9, ymm9, ymm11
    vextractf128 xmm11, ymm9, 1
    vaddpd xmm9, xmm9, xmm11
    vshufpd xmm11, xmm9, xmm9, 1
    vaddsd xmm9, xmm9, xmm11
    vmovsd xmm10, [r7 + T_AA]
    vaddsd xmm10, xmm10, xmm8
    vmovsd [r7 + T_AA], xmm10
    vmovsd xmm11, [r7 + T_LA]
    vaddsd xmm11, xmm11, xmm9
    vmovsd [r7 + T_LA], xmm11
    vrangepd zmm7, zmm5, [t_xflr]{1to8}, 0x0b
    vpsrlq zmm8, zmm7, 52
    vpsrlq zmm9, zmm7, 48
    vmovapd zmm10, [t_tsl]
    vpermt2pd zmm10, zmm8, [t_tsl + 64]
    vmovapd zmm12, [t_rx]
    vpermt2pd zmm12, zmm9, [t_rx + 64]
    vgetmantpd zmm11, zmm7, 4
    vfmsub213pd zmm11, zmm12, [t_one]{1to8}
    vptestnmq k5, zmm8, [t_q16]{1to8}
    vmulpd zmm10{k5}, zmm10, [t_tsk]{1to8}
    vmovapd zmm12, [t_wsx]
    vpermt2pd zmm12, zmm9, [t_wsx + 64]
    vmulpd zmm10, zmm10, zmm12
    vaddpd zmm13, zmm11, [t_psx3]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx2]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx1]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx0]{1to8}
    vmulpd zmm7, zmm10, zmm13
    vmovapd zmm8{k4}{z}, zmm7
    vmovdqa64 zmm9, zmm7
    vpternlogq zmm9, zmm5, [t_sign]{1to8}, 0xd8
    vmovapd zmm9{k4}{z}, zmm9
    vextractf64x4 ymm10, zmm8, 1
    vaddpd ymm8, ymm8, ymm10
    vextractf128 xmm10, ymm8, 1
    vaddpd xmm8, xmm8, xmm10
    vshufpd xmm10, xmm8, xmm8, 1
    vaddsd xmm8, xmm8, xmm10
    vextractf64x4 ymm11, zmm9, 1
    vaddpd ymm9, ymm9, ymm11
    vextractf128 xmm11, ymm9, 1
    vaddpd xmm9, xmm9, xmm11
    vshufpd xmm11, xmm9, xmm9, 1
    vaddsd xmm9, xmm9, xmm11
    vmovsd xmm10, [r7 + T_AA + 8]
    vaddsd xmm10, xmm10, xmm8
    vmovsd [r7 + T_AA + 8], xmm10
    vmovsd xmm11, [r7 + T_LA + 8]
    vaddsd xmm11, xmm11, xmm9
    vmovsd [r7 + T_LA + 8], xmm11
    vrangepd zmm7, zmm6, [t_xflr]{1to8}, 0x0b
    vpsrlq zmm8, zmm7, 52
    vpsrlq zmm9, zmm7, 48
    vmovapd zmm10, [t_tsl]
    vpermt2pd zmm10, zmm8, [t_tsl + 64]
    vmovapd zmm12, [t_rx]
    vpermt2pd zmm12, zmm9, [t_rx + 64]
    vgetmantpd zmm11, zmm7, 4
    vfmsub213pd zmm11, zmm12, [t_one]{1to8}
    vptestnmq k5, zmm8, [t_q16]{1to8}
    vmulpd zmm10{k5}, zmm10, [t_tsk]{1to8}
    vmovapd zmm12, [t_wsx]
    vpermt2pd zmm12, zmm9, [t_wsx + 64]
    vmulpd zmm10, zmm10, zmm12
    vaddpd zmm13, zmm11, [t_psx3]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx2]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx1]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx0]{1to8}
    vmulpd zmm7, zmm10, zmm13
    vmovapd zmm8{k4}{z}, zmm7
    vmovdqa64 zmm9, zmm7
    vpternlogq zmm9, zmm6, [t_sign]{1to8}, 0xd8
    vmovapd zmm9{k4}{z}, zmm9
    vextractf64x4 ymm10, zmm8, 1
    vaddpd ymm8, ymm8, ymm10
    vextractf128 xmm10, ymm8, 1
    vaddpd xmm8, xmm8, xmm10
    vshufpd xmm10, xmm8, xmm8, 1
    vaddsd xmm8, xmm8, xmm10
    vextractf64x4 ymm11, zmm9, 1
    vaddpd ymm9, ymm9, ymm11
    vextractf128 xmm11, ymm9, 1
    vaddpd xmm9, xmm9, xmm11
    vshufpd xmm11, xmm9, xmm9, 1
    vaddsd xmm9, xmm9, xmm11
    vmovsd xmm10, [r7 + T_AA + 16]
    vaddsd xmm10, xmm10, xmm8
    vmovsd [r7 + T_AA + 16], xmm10
    vmovsd xmm11, [r7 + T_LA + 16]
    vaddsd xmm11, xmm11, xmm9
    vmovsd [r7 + T_LA + 16], xmm11
    vmovapd zmm0{k4}{z}, [r7 + T_SY + 64]
    vmovapd zmm1{k4}{z}, [r7 + T_SB + 64]
    vmovapd zmm2{k4}{z}, [r7 + T_SR + 64]
    vbroadcastsd zmm3, [t_lzm5]
    vfmadd231pd zmm3, zmm0, [t_lzm0]{1to8}
    vmovapd zmm4, zmm3
    vfmadd231pd zmm4, zmm2, [t_lzm1]{1to8}
    vmovapd zmm5, zmm3
    vfmadd231pd zmm5, zmm2, [t_lzm2]{1to8}
    vfmadd231pd zmm5, zmm1, [t_lzm3]{1to8}
    vmovapd zmm6, zmm3
    vfmadd231pd zmm6, zmm1, [t_lzm4]{1to8}
    vrangepd zmm7, zmm4, [t_xflr]{1to8}, 0x0b
    vpsrlq zmm8, zmm7, 52
    vpsrlq zmm9, zmm7, 48
    vmovapd zmm10, [t_tsl]
    vpermt2pd zmm10, zmm8, [t_tsl + 64]
    vmovapd zmm12, [t_rx]
    vpermt2pd zmm12, zmm9, [t_rx + 64]
    vgetmantpd zmm11, zmm7, 4
    vfmsub213pd zmm11, zmm12, [t_one]{1to8}
    vptestnmq k5, zmm8, [t_q16]{1to8}
    vmulpd zmm10{k5}, zmm10, [t_tsk]{1to8}
    vmovapd zmm12, [t_wsx]
    vpermt2pd zmm12, zmm9, [t_wsx + 64]
    vmulpd zmm10, zmm10, zmm12
    vaddpd zmm13, zmm11, [t_psx3]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx2]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx1]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx0]{1to8}
    vmulpd zmm7, zmm10, zmm13
    vmovapd zmm8{k4}{z}, zmm7
    vmovdqa64 zmm9, zmm7
    vpternlogq zmm9, zmm4, [t_sign]{1to8}, 0xd8
    vmovapd zmm9{k4}{z}, zmm9
    vextractf64x4 ymm10, zmm8, 1
    vaddpd ymm8, ymm8, ymm10
    vextractf128 xmm10, ymm8, 1
    vaddpd xmm8, xmm8, xmm10
    vshufpd xmm10, xmm8, xmm8, 1
    vaddsd xmm8, xmm8, xmm10
    vextractf64x4 ymm11, zmm9, 1
    vaddpd ymm9, ymm9, ymm11
    vextractf128 xmm11, ymm9, 1
    vaddpd xmm9, xmm9, xmm11
    vshufpd xmm11, xmm9, xmm9, 1
    vaddsd xmm9, xmm9, xmm11
    vmovsd xmm10, [r7 + T_AA]
    vaddsd xmm10, xmm10, xmm8
    vmovsd [r7 + T_AA], xmm10
    vmovsd xmm11, [r7 + T_LA]
    vaddsd xmm11, xmm11, xmm9
    vmovsd [r7 + T_LA], xmm11
    vrangepd zmm7, zmm5, [t_xflr]{1to8}, 0x0b
    vpsrlq zmm8, zmm7, 52
    vpsrlq zmm9, zmm7, 48
    vmovapd zmm10, [t_tsl]
    vpermt2pd zmm10, zmm8, [t_tsl + 64]
    vmovapd zmm12, [t_rx]
    vpermt2pd zmm12, zmm9, [t_rx + 64]
    vgetmantpd zmm11, zmm7, 4
    vfmsub213pd zmm11, zmm12, [t_one]{1to8}
    vptestnmq k5, zmm8, [t_q16]{1to8}
    vmulpd zmm10{k5}, zmm10, [t_tsk]{1to8}
    vmovapd zmm12, [t_wsx]
    vpermt2pd zmm12, zmm9, [t_wsx + 64]
    vmulpd zmm10, zmm10, zmm12
    vaddpd zmm13, zmm11, [t_psx3]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx2]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx1]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx0]{1to8}
    vmulpd zmm7, zmm10, zmm13
    vmovapd zmm8{k4}{z}, zmm7
    vmovdqa64 zmm9, zmm7
    vpternlogq zmm9, zmm5, [t_sign]{1to8}, 0xd8
    vmovapd zmm9{k4}{z}, zmm9
    vextractf64x4 ymm10, zmm8, 1
    vaddpd ymm8, ymm8, ymm10
    vextractf128 xmm10, ymm8, 1
    vaddpd xmm8, xmm8, xmm10
    vshufpd xmm10, xmm8, xmm8, 1
    vaddsd xmm8, xmm8, xmm10
    vextractf64x4 ymm11, zmm9, 1
    vaddpd ymm9, ymm9, ymm11
    vextractf128 xmm11, ymm9, 1
    vaddpd xmm9, xmm9, xmm11
    vshufpd xmm11, xmm9, xmm9, 1
    vaddsd xmm9, xmm9, xmm11
    vmovsd xmm10, [r7 + T_AA + 8]
    vaddsd xmm10, xmm10, xmm8
    vmovsd [r7 + T_AA + 8], xmm10
    vmovsd xmm11, [r7 + T_LA + 8]
    vaddsd xmm11, xmm11, xmm9
    vmovsd [r7 + T_LA + 8], xmm11
    vrangepd zmm7, zmm6, [t_xflr]{1to8}, 0x0b
    vpsrlq zmm8, zmm7, 52
    vpsrlq zmm9, zmm7, 48
    vmovapd zmm10, [t_tsl]
    vpermt2pd zmm10, zmm8, [t_tsl + 64]
    vmovapd zmm12, [t_rx]
    vpermt2pd zmm12, zmm9, [t_rx + 64]
    vgetmantpd zmm11, zmm7, 4
    vfmsub213pd zmm11, zmm12, [t_one]{1to8}
    vptestnmq k5, zmm8, [t_q16]{1to8}
    vmulpd zmm10{k5}, zmm10, [t_tsk]{1to8}
    vmovapd zmm12, [t_wsx]
    vpermt2pd zmm12, zmm9, [t_wsx + 64]
    vmulpd zmm10, zmm10, zmm12
    vaddpd zmm13, zmm11, [t_psx3]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx2]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx1]{1to8}
    vfmadd213pd zmm13, zmm11, [t_psx0]{1to8}
    vmulpd zmm7, zmm10, zmm13
    vmovapd zmm8{k4}{z}, zmm7
    vmovdqa64 zmm9, zmm7
    vpternlogq zmm9, zmm6, [t_sign]{1to8}, 0xd8
    vmovapd zmm9{k4}{z}, zmm9
    vextractf64x4 ymm10, zmm8, 1
    vaddpd ymm8, ymm8, ymm10
    vextractf128 xmm10, ymm8, 1
    vaddpd xmm8, xmm8, xmm10
    vshufpd xmm10, xmm8, xmm8, 1
    vaddsd xmm8, xmm8, xmm10
    vextractf64x4 ymm11, zmm9, 1
    vaddpd ymm9, ymm9, ymm11
    vextractf128 xmm11, ymm9, 1
    vaddpd xmm9, xmm9, xmm11
    vshufpd xmm11, xmm9, xmm9, 1
    vaddsd xmm9, xmm9, xmm11
    vmovsd xmm10, [r7 + T_AA + 16]
    vaddsd xmm10, xmm10, xmm8
    vmovsd [r7 + T_AA + 16], xmm10
    vmovsd xmm11, [r7 + T_LA + 16]
    vaddsd xmm11, xmm11, xmm9
    vmovsd [r7 + T_LA + 16], xmm11
    vpxorq zmm0, zmm0, zmm0
    vmovapd [r7 + T_LV], zmm0
    vbroadcastsd zmm1, [t_tab]
    vmovapd [r7 + T_TV], zmm1
    vmovsd xmm2, [r7 + T_LA]
    vmulsd xmm2, xmm2, [t_six]
    vmovsd [r7 + T_LV], xmm2
    vandpd xmm3, xmm2, [t_abs2]
    vxorpd xmm3, xmm3, [t_sgn2]
    vmovsd xmm4, [r7 + T_AA]
    vfmadd132sd xmm4, xmm3, [t_six]
    vmovsd xmm5, [t_tab]
    vfmadd132sd xmm4, xmm5, [t_rg2]
    vmovsd [r7 + T_TV], xmm4
    vmovsd xmm2, [r7 + T_LA + 8]
    vmulsd xmm2, xmm2, [t_six]
    vmovsd [r7 + T_LV + 8], xmm2
    vandpd xmm3, xmm2, [t_abs2]
    vxorpd xmm3, xmm3, [t_sgn2]
    vmovsd xmm4, [r7 + T_AA + 8]
    vfmadd132sd xmm4, xmm3, [t_six]
    vmovsd xmm5, [t_tab]
    vfmadd132sd xmm4, xmm5, [t_rg2]
    vmovsd [r7 + T_TV + 8], xmm4
    vmovsd xmm2, [r7 + T_LA + 16]
    vmulsd xmm2, xmm2, [t_six]
    vmovsd [r7 + T_LV + 16], xmm2
    vandpd xmm3, xmm2, [t_abs2]
    vxorpd xmm3, xmm3, [t_sgn2]
    vmovsd xmm4, [r7 + T_AA + 16]
    vfmadd132sd xmm4, xmm3, [t_six]
    vmovsd xmm5, [t_tab]
    vfmadd132sd xmm4, xmm5, [t_rg2]
    vmovsd [r7 + T_TV + 16], xmm4
    vmovapd zmm0, [r7 + T_LV]
    vmovapd zmm15, [r7 + T_TV]
    vbroadcastsd zmm1, [t_rg2]
    vrangepd zmm2, zmm0, zmm0, 8
    vmovapd zmm3, zmm15
    vfmadd231pd zmm3, zmm1, zmm2
    vsubpd zmm4, zmm2, zmm3
    vcmppd k1, zmm4, zmm3, 0x1e
    vaddpd zmm5, zmm2, zmm3
    vmovapd zmm5{k1}, zmm2
    vpsrlq zmm1, zmm5, 48
    vmovapd zmm10, [t_rx]
    vpermt2pd zmm10, zmm1, [t_rx + 64]
    vgetmantpd zmm2, zmm5, 4
    vfmsub213pd zmm2, zmm10, [t_one]{1to8}
    vmulpd zmm7, zmm2, zmm2
    vpsrlq zmm8, zmm5, 52
    vmovapd zmm6, [t_oa]
    vpermt2pd zmm6, zmm8, [t_oa + 64]
    vpsrlq zmm9, zmm5, 56
    vpermpd zmm9, zmm9, [t_ob]
    vmovapd zmm10, [t_ow]
    vpermt2pd zmm10, zmm1, [t_ow + 64]
    vbroadcastsd zmm11, [t_op3]
    vfmadd213pd zmm11, zmm2, [t_op2]{1to8}
    vbroadcastsd zmm8, [t_op4]
    vfmadd213pd zmm8, zmm7, zmm11
    vbroadcastsd zmm11, [t_op1]
    vfmadd213pd zmm11, zmm2, [t_op0]{1to8}
    vfmadd213pd zmm8, zmm7, zmm11
    vmulpd zmm6, zmm6, zmm9
    vmulpd zmm6, zmm6, zmm10
    vmulpd zmm6, zmm6, zmm8
    vrcp14pd zmm7, zmm4
    vmulpd zmm7{k1}{z}, zmm3, zmm7
    vbroadcastsd zmm11, [t_omg]
    vfmadd132pd zmm7, zmm11, [t_eq0]{1to8}
    vmovapd zmm8, zmm6
    vfmadd231pd zmm8, zmm7, zmm6
    vpxorq zmm9, zmm8, [t_sign]{1to8}
    vmovapd zmm10, zmm6
    vfnmadd231pd zmm10{k1}{z}, zmm7, zmm6
    vcmppd k2, zmm4, [t_zero]{1to8}, 0x1a
    vmovapd zmm10{k2}, zmm9
    vpxorq zmm12, zmm10, [t_sign]{1to8}
    vpmovq2m k3, zmm0
    vmovapd zmm10{k3}, zmm9
    vmovapd zmm8{k3}, zmm12
    vmovapd [r7 + T_LO], zmm10
    vmovapd [r7 + T_HI], zmm8
    vmovsd xmm0, [t_clo]
    vmovsd xmm1, [t_emc5]
    vfnmadd231sd xmm0, xmm1, [r7 + T_HI + 8]
    vmovsd xmm1, [t_emc4]
    vfnmadd231sd xmm0, xmm1, [r7 + T_HI]
    vmovsd xmm1, [t_emc3]
    vfmadd231sd xmm0, xmm1, [r7 + T_LO + 16]
    vmovsd xmm2, [t_chi]
    vmovsd xmm1, [t_emc5]
    vfnmadd231sd xmm2, xmm1, [r7 + T_LO + 8]
    vmovsd xmm1, [t_emc4]
    vfnmadd231sd xmm2, xmm1, [r7 + T_LO]
    vmovsd xmm1, [t_emc3]
    vfmadd231sd xmm2, xmm1, [r7 + T_HI + 16]
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
    vmovsd xmm0, [t_clo]
    vmovsd xmm1, [t_emc8]
    vfnmadd231sd xmm0, xmm1, [r7 + T_HI + 16]
    vmovsd xmm1, [t_emc7]
    vfnmadd231sd xmm0, xmm1, [r7 + T_HI + 8]
    vmovsd xmm1, [t_emc6]
    vfmadd231sd xmm0, xmm1, [r7 + T_LO]
    vmovsd xmm2, [t_chi]
    vmovsd xmm1, [t_emc8]
    vfnmadd231sd xmm2, xmm1, [r7 + T_LO + 16]
    vmovsd xmm1, [t_emc7]
    vfnmadd231sd xmm2, xmm1, [r7 + T_LO + 8]
    vmovsd xmm1, [t_emc6]
    vfmadd231sd xmm2, xmm1, [r7 + T_HI]
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
    vmovapd [r7 + T_Z2], zmm16
    vmovapd [r7 + T_Z2 + 64], zmm17
    vmovapd [r7 + T_Z2 + 128], zmm18
    vmovapd [r7 + T_Z2 + 192], zmm19
    vmovapd [r7 + T_Z2 + 256], zmm20
    vmovapd [r7 + T_Z2 + 320], zmm21
    vmovapd [r7 + T_Z2 + 384], zmm22
    vmovapd [r7 + T_Z2 + 448], zmm23
    vmovapd [r7 + T_Z2 + 512], zmm24
    vmovapd [r7 + T_Z2 + 576], zmm25
    vmovapd [r7 + T_Z2 + 640], zmm26
    vmovapd [r7 + T_Z2 + 704], zmm27
    vmovapd [r7 + T_Z2 + 768], zmm28
    vmovapd [r7 + T_Z2 + 832], zmm29
    vmovapd [r7 + T_Z2 + 896], zmm30
    vmovapd [r7 + T_Z2 + 960], zmm31
    mov r6d, 15
    kmovb k4, r6d
    vpxorq zmm0, zmm0, zmm0
    vmovapd zmm1{k4}{z}, [r7 + T_SY]
    vmovapd zmm2{k4}{z}, [r7 + T_SB]
    vmovapd zmm3{k4}{z}, [r7 + T_SR]
    vbroadcastsd zmm4, [t_ysc]
    vbroadcastsd zmm5, [t_ysc + 8]
    vmulpd zmm6, zmm1, zmm4
    vmovapd zmm7, zmm6
    vfmsub231pd zmm7, zmm1, zmm4
    vmulpd zmm8, zmm0, zmm4
    vfmadd231pd zmm8, zmm1, zmm5
    vaddpd zmm7, zmm7, zmm8
    vaddpd zmm8, zmm6, zmm7
    vsubpd zmm9, zmm8, zmm6
    vsubpd zmm9, zmm7, zmm9
    vbroadcastsd zmm1, [t_yof]
    vbroadcastsd zmm5, [t_yof + 8]
    vaddpd zmm4, zmm8, zmm1
    vsubpd zmm7, zmm4, zmm8
    vsubpd zmm6, zmm4, zmm7
    vsubpd zmm6, zmm8, zmm6
    vsubpd zmm7, zmm1, zmm7
    vaddpd zmm6, zmm6, zmm7
    vaddpd zmm7, zmm9, zmm5
    vsubpd zmm10, zmm7, zmm9
    vsubpd zmm11, zmm7, zmm10
    vsubpd zmm11, zmm9, zmm11
    vsubpd zmm10, zmm5, zmm10
    vaddpd zmm11, zmm11, zmm10
    vaddpd zmm10, zmm6, zmm7
    vaddpd zmm7, zmm4, zmm10
    vsubpd zmm6, zmm7, zmm4
    vsubpd zmm6, zmm10, zmm6
    vaddpd zmm10, zmm6, zmm11
    vaddpd zmm11, zmm7, zmm10
    vsubpd zmm6, zmm11, zmm7
    vsubpd zmm6, zmm10, zmm6
    vbroadcastsd zmm5, [t_rcr]
    vbroadcastsd zmm1, [t_rcr + 8]
    vmulpd zmm9, zmm5, zmm3
    vmovapd zmm8, zmm9
    vfmsub231pd zmm8, zmm5, zmm3
    vmulpd zmm10, zmm1, zmm3
    vfmadd231pd zmm10, zmm5, zmm0
    vaddpd zmm8, zmm8, zmm10
    vaddpd zmm10, zmm9, zmm8
    vsubpd zmm7, zmm10, zmm9
    vsubpd zmm7, zmm8, zmm7
    vaddpd zmm1, zmm11, zmm10
    vsubpd zmm5, zmm1, zmm11
    vsubpd zmm8, zmm1, zmm5
    vsubpd zmm8, zmm11, zmm8
    vsubpd zmm5, zmm10, zmm5
    vaddpd zmm8, zmm8, zmm5
    vaddpd zmm5, zmm6, zmm7
    vsubpd zmm9, zmm5, zmm6
    vsubpd zmm4, zmm5, zmm9
    vsubpd zmm4, zmm6, zmm4
    vsubpd zmm9, zmm7, zmm9
    vaddpd zmm4, zmm4, zmm9
    vaddpd zmm9, zmm8, zmm5
    vaddpd zmm5, zmm1, zmm9
    vsubpd zmm8, zmm5, zmm1
    vsubpd zmm8, zmm9, zmm8
    vaddpd zmm9, zmm8, zmm4
    vaddpd zmm4, zmm5, zmm9
    vsubpd zmm8, zmm4, zmm5
    vsubpd zmm8, zmm9, zmm8
    vbroadcastsd zmm7, [t_gcr]
    vbroadcastsd zmm10, [t_gcr + 8]
    vmulpd zmm9, zmm7, zmm3
    vmovapd zmm5, zmm9
    vfmsub231pd zmm5, zmm7, zmm3
    vmulpd zmm1, zmm10, zmm3
    vfmadd231pd zmm1, zmm7, zmm0
    vaddpd zmm5, zmm5, zmm1
    vaddpd zmm1, zmm9, zmm5
    vsubpd zmm12, zmm1, zmm9
    vsubpd zmm12, zmm5, zmm12
    vaddpd zmm10, zmm11, zmm1
    vsubpd zmm7, zmm10, zmm11
    vsubpd zmm5, zmm10, zmm7
    vsubpd zmm5, zmm11, zmm5
    vsubpd zmm7, zmm1, zmm7
    vaddpd zmm5, zmm5, zmm7
    vaddpd zmm7, zmm6, zmm12
    vsubpd zmm9, zmm7, zmm6
    vsubpd zmm13, zmm7, zmm9
    vsubpd zmm13, zmm6, zmm13
    vsubpd zmm9, zmm12, zmm9
    vaddpd zmm13, zmm13, zmm9
    vaddpd zmm9, zmm5, zmm7
    vaddpd zmm7, zmm10, zmm9
    vsubpd zmm5, zmm7, zmm10
    vsubpd zmm5, zmm9, zmm5
    vaddpd zmm9, zmm5, zmm13
    vaddpd zmm13, zmm7, zmm9
    vsubpd zmm5, zmm13, zmm7
    vsubpd zmm5, zmm9, zmm5
    vbroadcastsd zmm12, [t_gcb]
    vbroadcastsd zmm1, [t_gcb + 8]
    vmulpd zmm9, zmm12, zmm2
    vmovapd zmm7, zmm9
    vfmsub231pd zmm7, zmm12, zmm2
    vmulpd zmm10, zmm1, zmm2
    vfmadd231pd zmm10, zmm12, zmm0
    vaddpd zmm7, zmm7, zmm10
    vaddpd zmm10, zmm9, zmm7
    vsubpd zmm14, zmm10, zmm9
    vsubpd zmm14, zmm7, zmm14
    vaddpd zmm1, zmm13, zmm10
    vsubpd zmm12, zmm1, zmm13
    vsubpd zmm7, zmm1, zmm12
    vsubpd zmm7, zmm13, zmm7
    vsubpd zmm12, zmm10, zmm12
    vaddpd zmm7, zmm7, zmm12
    vaddpd zmm12, zmm5, zmm14
    vsubpd zmm9, zmm12, zmm5
    vsubpd zmm15, zmm12, zmm9
    vsubpd zmm15, zmm5, zmm15
    vsubpd zmm9, zmm14, zmm9
    vaddpd zmm15, zmm15, zmm9
    vaddpd zmm9, zmm7, zmm12
    vaddpd zmm12, zmm1, zmm9
    vsubpd zmm7, zmm12, zmm1
    vsubpd zmm7, zmm9, zmm7
    vaddpd zmm9, zmm7, zmm15
    vaddpd zmm15, zmm12, zmm9
    vsubpd zmm7, zmm15, zmm12
    vsubpd zmm7, zmm9, zmm7
    vbroadcastsd zmm5, [t_bcb]
    vbroadcastsd zmm13, [t_bcb + 8]
    vmulpd zmm14, zmm5, zmm2
    vmovapd zmm10, zmm14
    vfmsub231pd zmm10, zmm5, zmm2
    vmulpd zmm9, zmm13, zmm2
    vfmadd231pd zmm9, zmm5, zmm0
    vaddpd zmm10, zmm10, zmm9
    vaddpd zmm9, zmm14, zmm10
    vsubpd zmm12, zmm9, zmm14
    vsubpd zmm12, zmm10, zmm12
    vaddpd zmm13, zmm11, zmm9
    vsubpd zmm5, zmm13, zmm11
    vsubpd zmm10, zmm13, zmm5
    vsubpd zmm10, zmm11, zmm10
    vsubpd zmm5, zmm9, zmm5
    vaddpd zmm10, zmm10, zmm5
    vaddpd zmm5, zmm6, zmm12
    vsubpd zmm14, zmm5, zmm6
    vsubpd zmm1, zmm5, zmm14
    vsubpd zmm1, zmm6, zmm1
    vsubpd zmm14, zmm12, zmm14
    vaddpd zmm1, zmm1, zmm14
    vaddpd zmm14, zmm10, zmm5
    vaddpd zmm5, zmm13, zmm14
    vsubpd zmm10, zmm5, zmm13
    vsubpd zmm10, zmm14, zmm10
    vaddpd zmm14, zmm10, zmm1
    vaddpd zmm1, zmm5, zmm14
    vsubpd zmm10, zmm1, zmm5
    vsubpd zmm10, zmm14, zmm10
    vmovapd [r7 + T_V], zmm4
    vmovapd [r7 + T_V + 64], zmm8
    vmovapd [r7 + T_V + 128], zmm15
    vmovapd [r7 + T_V + 192], zmm7
    vmovapd [r7 + T_V + 256], zmm1
    vmovapd [r7 + T_V + 320], zmm10
    vmovapd zmm16, [r7 + T_V]
    vmovapd zmm17, [r7 + T_V + 64]
    call .xeo
    vmovapd [r7 + T_X], zmm16
    vmovapd [r7 + T_X + 64], zmm17
    vmovapd zmm16, [r7 + T_V + 128]
    vmovapd zmm17, [r7 + T_V + 192]
    call .xeo
    vmovapd [r7 + T_X + 128], zmm16
    vmovapd [r7 + T_X + 192], zmm17
    vmovapd zmm16, [r7 + T_V + 256]
    vmovapd zmm17, [r7 + T_V + 320]
    call .xeo
    vmovapd [r7 + T_X + 256], zmm16
    vmovapd [r7 + T_X + 320], zmm17
    vpxorq zmm0, zmm0, zmm0
    vmovapd [r7 + T_ACC], zmm0
    vmovapd [r7 + T_ACC + 64], zmm0
    vxorpd xmm0, xmm0, xmm0
    vxorpd xmm1, xmm1, xmm1
    vmovsd xmm2, [r7 + T_X]
    vmovsd xmm3, [r7 + T_X + 64]
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
    vmovsd xmm3, [r7 + T_X + 8]
    vmovsd xmm2, [r7 + T_X + 72]
    vaddsd xmm1, xmm8, xmm3
    vsubsd xmm0, xmm1, xmm8
    vsubsd xmm7, xmm1, xmm0
    vsubsd xmm7, xmm8, xmm7
    vsubsd xmm0, xmm3, xmm0
    vaddsd xmm7, xmm7, xmm0
    vaddsd xmm0, xmm6, xmm2
    vsubsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm0, xmm5
    vsubsd xmm4, xmm6, xmm4
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm0
    vaddsd xmm0, xmm1, xmm5
    vsubsd xmm7, xmm0, xmm1
    vsubsd xmm7, xmm5, xmm7
    vaddsd xmm5, xmm7, xmm4
    vaddsd xmm4, xmm0, xmm5
    vsubsd xmm7, xmm4, xmm0
    vsubsd xmm7, xmm5, xmm7
    vmovsd xmm2, [r7 + T_X + 16]
    vmovsd xmm3, [r7 + T_X + 80]
    vaddsd xmm6, xmm4, xmm2
    vsubsd xmm8, xmm6, xmm4
    vsubsd xmm5, xmm6, xmm8
    vsubsd xmm5, xmm4, xmm5
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm5, xmm5, xmm8
    vaddsd xmm8, xmm7, xmm3
    vsubsd xmm0, xmm8, xmm7
    vsubsd xmm1, xmm8, xmm0
    vsubsd xmm1, xmm7, xmm1
    vsubsd xmm0, xmm3, xmm0
    vaddsd xmm1, xmm1, xmm0
    vaddsd xmm0, xmm5, xmm8
    vaddsd xmm8, xmm6, xmm0
    vsubsd xmm5, xmm8, xmm6
    vsubsd xmm5, xmm0, xmm5
    vaddsd xmm0, xmm5, xmm1
    vaddsd xmm1, xmm8, xmm0
    vsubsd xmm5, xmm1, xmm8
    vsubsd xmm5, xmm0, xmm5
    vmovsd xmm3, [r7 + T_X + 24]
    vmovsd xmm2, [r7 + T_X + 88]
    vaddsd xmm7, xmm1, xmm3
    vsubsd xmm4, xmm7, xmm1
    vsubsd xmm0, xmm7, xmm4
    vsubsd xmm0, xmm1, xmm0
    vsubsd xmm4, xmm3, xmm4
    vaddsd xmm0, xmm0, xmm4
    vaddsd xmm4, xmm5, xmm2
    vsubsd xmm8, xmm4, xmm5
    vsubsd xmm6, xmm4, xmm8
    vsubsd xmm6, xmm5, xmm6
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm6, xmm6, xmm8
    vaddsd xmm8, xmm0, xmm4
    vaddsd xmm4, xmm7, xmm8
    vsubsd xmm0, xmm4, xmm7
    vsubsd xmm0, xmm8, xmm0
    vaddsd xmm8, xmm0, xmm6
    vaddsd xmm6, xmm4, xmm8
    vsubsd xmm0, xmm6, xmm4
    vsubsd xmm0, xmm8, xmm0
    vmovsd [r7 + T_ACC], xmm6
    vmovsd [r7 + T_ACC + 64], xmm0
    vxorpd xmm0, xmm0, xmm0
    vxorpd xmm1, xmm1, xmm1
    vmovsd xmm2, [r7 + T_X + 128]
    vmovsd xmm3, [r7 + T_X + 192]
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
    vmovsd xmm3, [r7 + T_X + 136]
    vmovsd xmm2, [r7 + T_X + 200]
    vaddsd xmm1, xmm8, xmm3
    vsubsd xmm0, xmm1, xmm8
    vsubsd xmm7, xmm1, xmm0
    vsubsd xmm7, xmm8, xmm7
    vsubsd xmm0, xmm3, xmm0
    vaddsd xmm7, xmm7, xmm0
    vaddsd xmm0, xmm6, xmm2
    vsubsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm0, xmm5
    vsubsd xmm4, xmm6, xmm4
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm0
    vaddsd xmm0, xmm1, xmm5
    vsubsd xmm7, xmm0, xmm1
    vsubsd xmm7, xmm5, xmm7
    vaddsd xmm5, xmm7, xmm4
    vaddsd xmm4, xmm0, xmm5
    vsubsd xmm7, xmm4, xmm0
    vsubsd xmm7, xmm5, xmm7
    vmovsd xmm2, [r7 + T_X + 144]
    vmovsd xmm3, [r7 + T_X + 208]
    vaddsd xmm6, xmm4, xmm2
    vsubsd xmm8, xmm6, xmm4
    vsubsd xmm5, xmm6, xmm8
    vsubsd xmm5, xmm4, xmm5
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm5, xmm5, xmm8
    vaddsd xmm8, xmm7, xmm3
    vsubsd xmm0, xmm8, xmm7
    vsubsd xmm1, xmm8, xmm0
    vsubsd xmm1, xmm7, xmm1
    vsubsd xmm0, xmm3, xmm0
    vaddsd xmm1, xmm1, xmm0
    vaddsd xmm0, xmm5, xmm8
    vaddsd xmm8, xmm6, xmm0
    vsubsd xmm5, xmm8, xmm6
    vsubsd xmm5, xmm0, xmm5
    vaddsd xmm0, xmm5, xmm1
    vaddsd xmm1, xmm8, xmm0
    vsubsd xmm5, xmm1, xmm8
    vsubsd xmm5, xmm0, xmm5
    vmovsd xmm3, [r7 + T_X + 152]
    vmovsd xmm2, [r7 + T_X + 216]
    vaddsd xmm7, xmm1, xmm3
    vsubsd xmm4, xmm7, xmm1
    vsubsd xmm0, xmm7, xmm4
    vsubsd xmm0, xmm1, xmm0
    vsubsd xmm4, xmm3, xmm4
    vaddsd xmm0, xmm0, xmm4
    vaddsd xmm4, xmm5, xmm2
    vsubsd xmm8, xmm4, xmm5
    vsubsd xmm6, xmm4, xmm8
    vsubsd xmm6, xmm5, xmm6
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm6, xmm6, xmm8
    vaddsd xmm8, xmm0, xmm4
    vaddsd xmm4, xmm7, xmm8
    vsubsd xmm0, xmm4, xmm7
    vsubsd xmm0, xmm8, xmm0
    vaddsd xmm8, xmm0, xmm6
    vaddsd xmm6, xmm4, xmm8
    vsubsd xmm0, xmm6, xmm4
    vsubsd xmm0, xmm8, xmm0
    vmovsd [r7 + T_ACC + 8], xmm6
    vmovsd [r7 + T_ACC + 72], xmm0
    vxorpd xmm0, xmm0, xmm0
    vxorpd xmm1, xmm1, xmm1
    vmovsd xmm2, [r7 + T_X + 256]
    vmovsd xmm3, [r7 + T_X + 320]
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
    vmovsd xmm3, [r7 + T_X + 264]
    vmovsd xmm2, [r7 + T_X + 328]
    vaddsd xmm1, xmm8, xmm3
    vsubsd xmm0, xmm1, xmm8
    vsubsd xmm7, xmm1, xmm0
    vsubsd xmm7, xmm8, xmm7
    vsubsd xmm0, xmm3, xmm0
    vaddsd xmm7, xmm7, xmm0
    vaddsd xmm0, xmm6, xmm2
    vsubsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm0, xmm5
    vsubsd xmm4, xmm6, xmm4
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm0
    vaddsd xmm0, xmm1, xmm5
    vsubsd xmm7, xmm0, xmm1
    vsubsd xmm7, xmm5, xmm7
    vaddsd xmm5, xmm7, xmm4
    vaddsd xmm4, xmm0, xmm5
    vsubsd xmm7, xmm4, xmm0
    vsubsd xmm7, xmm5, xmm7
    vmovsd xmm2, [r7 + T_X + 272]
    vmovsd xmm3, [r7 + T_X + 336]
    vaddsd xmm6, xmm4, xmm2
    vsubsd xmm8, xmm6, xmm4
    vsubsd xmm5, xmm6, xmm8
    vsubsd xmm5, xmm4, xmm5
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm5, xmm5, xmm8
    vaddsd xmm8, xmm7, xmm3
    vsubsd xmm0, xmm8, xmm7
    vsubsd xmm1, xmm8, xmm0
    vsubsd xmm1, xmm7, xmm1
    vsubsd xmm0, xmm3, xmm0
    vaddsd xmm1, xmm1, xmm0
    vaddsd xmm0, xmm5, xmm8
    vaddsd xmm8, xmm6, xmm0
    vsubsd xmm5, xmm8, xmm6
    vsubsd xmm5, xmm0, xmm5
    vaddsd xmm0, xmm5, xmm1
    vaddsd xmm1, xmm8, xmm0
    vsubsd xmm5, xmm1, xmm8
    vsubsd xmm5, xmm0, xmm5
    vmovsd xmm3, [r7 + T_X + 280]
    vmovsd xmm2, [r7 + T_X + 344]
    vaddsd xmm7, xmm1, xmm3
    vsubsd xmm4, xmm7, xmm1
    vsubsd xmm0, xmm7, xmm4
    vsubsd xmm0, xmm1, xmm0
    vsubsd xmm4, xmm3, xmm4
    vaddsd xmm0, xmm0, xmm4
    vaddsd xmm4, xmm5, xmm2
    vsubsd xmm8, xmm4, xmm5
    vsubsd xmm6, xmm4, xmm8
    vsubsd xmm6, xmm5, xmm6
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm6, xmm6, xmm8
    vaddsd xmm8, xmm0, xmm4
    vaddsd xmm4, xmm7, xmm8
    vsubsd xmm0, xmm4, xmm7
    vsubsd xmm0, xmm8, xmm0
    vaddsd xmm8, xmm0, xmm6
    vaddsd xmm6, xmm4, xmm8
    vsubsd xmm0, xmm6, xmm4
    vsubsd xmm0, xmm8, xmm0
    vmovsd [r7 + T_ACC + 16], xmm6
    vmovsd [r7 + T_ACC + 80], xmm0
    vpxorq zmm0, zmm0, zmm0
    vmovapd zmm1, [r7 + T_ACC]
    vmovapd zmm2, [r7 + T_ACC + 64]
    vbroadcastsd zmm3, [t_quart]
    vmulpd zmm4, zmm1, zmm3
    vmovapd zmm5, zmm4
    vfmsub231pd zmm5, zmm1, zmm3
    vmulpd zmm6, zmm2, zmm3
    vfmadd231pd zmm6, zmm1, zmm0
    vaddpd zmm5, zmm5, zmm6
    vaddpd zmm6, zmm4, zmm5
    vsubpd zmm7, zmm6, zmm4
    vsubpd zmm7, zmm5, zmm7
    vmovapd zmm16, zmm6
    vmovapd zmm17, zmm7
    call .xoe
    vmovapd [r7 + T_E], zmm16
    vmovapd [r7 + T_E + 64], zmm17
    vmovsd xmm0, [r7 + T_E]
    vmovsd xmm1, [r7 + T_E + 64]
    vmovsd xmm2, [r7 + T_E + 8]
    vmovsd xmm3, [r7 + T_E + 72]
    vmovsd xmm4, [r7 + T_E + 16]
    vmovsd xmm5, [r7 + T_E + 80]
    vmovsd xmm6, [t_kr]
    vmovsd xmm7, [t_kr + 8]
    vmulsd xmm8, xmm6, xmm0
    vmovapd xmm9, xmm8
    vfmsub231sd xmm9, xmm6, xmm0
    vmulsd xmm10, xmm7, xmm0
    vfmadd231sd xmm10, xmm6, xmm1
    vaddsd xmm9, xmm9, xmm10
    vaddsd xmm10, xmm8, xmm9
    vsubsd xmm11, xmm10, xmm8
    vsubsd xmm11, xmm9, xmm11
    vmovsd xmm7, [t_kg]
    vmovsd xmm6, [t_kg + 8]
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
    vmovsd xmm13, [t_kb]
    vmovsd xmm12, [t_kb + 8]
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
    vmovsd xmm4, [t_876]
    vmulsd xmm3, xmm4, xmm6
    vmovapd xmm2, xmm3
    vfmsub231sd xmm2, xmm4, xmm6
    vmulsd xmm1, xmm5, xmm6
    vfmadd231sd xmm1, xmm4, xmm10
    vaddsd xmm2, xmm2, xmm1
    vaddsd xmm1, xmm3, xmm2
    vsubsd xmm0, xmm1, xmm3
    vsubsd xmm0, xmm2, xmm0
    vmovsd xmm10, [t_64]
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
    vsubsd xmm4, xmm9, xmm3
    vsubsd xmm4, xmm6, xmm4
    vcmpsd xmm5, xmm9, [t_half], 0x1e
    vandpd xmm5, xmm5, [t_one2]
    vcmpsd xmm1, xmm9, [t_mhalf], 0x11
    vandpd xmm1, xmm1, [t_one2]
    vaddsd xmm0, xmm0, xmm5
    vsubsd xmm0, xmm0, xmm1
    vcvttsd2si r6d, xmm0
    xor r3d, r3d
    test r6d, r6d
    cmovs r6d, r3d
    mov r3d, 1023
    cmp r6d, r3d
    cmovg r6d, r3d
    vmovapd zmm16, [r7 + T_Z2]
    vmovapd zmm17, [r7 + T_Z2 + 64]
    vmovapd zmm18, [r7 + T_Z2 + 128]
    vmovapd zmm19, [r7 + T_Z2 + 192]
    vmovapd zmm20, [r7 + T_Z2 + 256]
    vmovapd zmm21, [r7 + T_Z2 + 320]
    vmovapd zmm22, [r7 + T_Z2 + 384]
    vmovapd zmm23, [r7 + T_Z2 + 448]
    vmovapd zmm24, [r7 + T_Z2 + 512]
    vmovapd zmm25, [r7 + T_Z2 + 576]
    vmovapd zmm26, [r7 + T_Z2 + 640]
    vmovapd zmm27, [r7 + T_Z2 + 704]
    vmovapd zmm28, [r7 + T_Z2 + 768]
    vmovapd zmm29, [r7 + T_Z2 + 832]
    vmovapd zmm30, [r7 + T_Z2 + 896]
    vmovapd zmm31, [r7 + T_Z2 + 960]
    ret
.t3c:
    vmovapd [r7 + T_Z2], zmm16
    vmovapd [r7 + T_Z2 + 64], zmm17
    vmovapd [r7 + T_Z2 + 128], zmm18
    vmovapd [r7 + T_Z2 + 192], zmm19
    vmovapd [r7 + T_Z2 + 256], zmm20
    vmovapd [r7 + T_Z2 + 320], zmm21
    vmovapd [r7 + T_Z2 + 384], zmm22
    vmovapd [r7 + T_Z2 + 448], zmm23
    vmovapd [r7 + T_Z2 + 512], zmm24
    vmovapd [r7 + T_Z2 + 576], zmm25
    vmovapd [r7 + T_Z2 + 640], zmm26
    vmovapd [r7 + T_Z2 + 704], zmm27
    vmovapd [r7 + T_Z2 + 768], zmm28
    vmovapd [r7 + T_Z2 + 832], zmm29
    vmovapd [r7 + T_Z2 + 896], zmm30
    vmovapd [r7 + T_Z2 + 960], zmm31
    mov r6d, 255
    kmovb k4, r6d
    vpxorq zmm0, zmm0, zmm0
    vmovapd zmm1{k4}{z}, [r7 + T_SY]
    vmovapd zmm2{k4}{z}, [r7 + T_SB]
    vmovapd zmm3{k4}{z}, [r7 + T_SR]
    vbroadcastsd zmm4, [t_ysc]
    vbroadcastsd zmm5, [t_ysc + 8]
    vmulpd zmm6, zmm1, zmm4
    vmovapd zmm7, zmm6
    vfmsub231pd zmm7, zmm1, zmm4
    vmulpd zmm8, zmm0, zmm4
    vfmadd231pd zmm8, zmm1, zmm5
    vaddpd zmm7, zmm7, zmm8
    vaddpd zmm8, zmm6, zmm7
    vsubpd zmm9, zmm8, zmm6
    vsubpd zmm9, zmm7, zmm9
    vbroadcastsd zmm1, [t_yof]
    vbroadcastsd zmm5, [t_yof + 8]
    vaddpd zmm4, zmm8, zmm1
    vsubpd zmm7, zmm4, zmm8
    vsubpd zmm6, zmm4, zmm7
    vsubpd zmm6, zmm8, zmm6
    vsubpd zmm7, zmm1, zmm7
    vaddpd zmm6, zmm6, zmm7
    vaddpd zmm7, zmm9, zmm5
    vsubpd zmm10, zmm7, zmm9
    vsubpd zmm11, zmm7, zmm10
    vsubpd zmm11, zmm9, zmm11
    vsubpd zmm10, zmm5, zmm10
    vaddpd zmm11, zmm11, zmm10
    vaddpd zmm10, zmm6, zmm7
    vaddpd zmm7, zmm4, zmm10
    vsubpd zmm6, zmm7, zmm4
    vsubpd zmm6, zmm10, zmm6
    vaddpd zmm10, zmm6, zmm11
    vaddpd zmm11, zmm7, zmm10
    vsubpd zmm6, zmm11, zmm7
    vsubpd zmm6, zmm10, zmm6
    vbroadcastsd zmm5, [t_rcr]
    vbroadcastsd zmm1, [t_rcr + 8]
    vmulpd zmm9, zmm5, zmm3
    vmovapd zmm8, zmm9
    vfmsub231pd zmm8, zmm5, zmm3
    vmulpd zmm10, zmm1, zmm3
    vfmadd231pd zmm10, zmm5, zmm0
    vaddpd zmm8, zmm8, zmm10
    vaddpd zmm10, zmm9, zmm8
    vsubpd zmm7, zmm10, zmm9
    vsubpd zmm7, zmm8, zmm7
    vaddpd zmm1, zmm11, zmm10
    vsubpd zmm5, zmm1, zmm11
    vsubpd zmm8, zmm1, zmm5
    vsubpd zmm8, zmm11, zmm8
    vsubpd zmm5, zmm10, zmm5
    vaddpd zmm8, zmm8, zmm5
    vaddpd zmm5, zmm6, zmm7
    vsubpd zmm9, zmm5, zmm6
    vsubpd zmm4, zmm5, zmm9
    vsubpd zmm4, zmm6, zmm4
    vsubpd zmm9, zmm7, zmm9
    vaddpd zmm4, zmm4, zmm9
    vaddpd zmm9, zmm8, zmm5
    vaddpd zmm5, zmm1, zmm9
    vsubpd zmm8, zmm5, zmm1
    vsubpd zmm8, zmm9, zmm8
    vaddpd zmm9, zmm8, zmm4
    vaddpd zmm4, zmm5, zmm9
    vsubpd zmm8, zmm4, zmm5
    vsubpd zmm8, zmm9, zmm8
    vbroadcastsd zmm7, [t_gcr]
    vbroadcastsd zmm10, [t_gcr + 8]
    vmulpd zmm9, zmm7, zmm3
    vmovapd zmm5, zmm9
    vfmsub231pd zmm5, zmm7, zmm3
    vmulpd zmm1, zmm10, zmm3
    vfmadd231pd zmm1, zmm7, zmm0
    vaddpd zmm5, zmm5, zmm1
    vaddpd zmm1, zmm9, zmm5
    vsubpd zmm12, zmm1, zmm9
    vsubpd zmm12, zmm5, zmm12
    vaddpd zmm10, zmm11, zmm1
    vsubpd zmm7, zmm10, zmm11
    vsubpd zmm5, zmm10, zmm7
    vsubpd zmm5, zmm11, zmm5
    vsubpd zmm7, zmm1, zmm7
    vaddpd zmm5, zmm5, zmm7
    vaddpd zmm7, zmm6, zmm12
    vsubpd zmm9, zmm7, zmm6
    vsubpd zmm13, zmm7, zmm9
    vsubpd zmm13, zmm6, zmm13
    vsubpd zmm9, zmm12, zmm9
    vaddpd zmm13, zmm13, zmm9
    vaddpd zmm9, zmm5, zmm7
    vaddpd zmm7, zmm10, zmm9
    vsubpd zmm5, zmm7, zmm10
    vsubpd zmm5, zmm9, zmm5
    vaddpd zmm9, zmm5, zmm13
    vaddpd zmm13, zmm7, zmm9
    vsubpd zmm5, zmm13, zmm7
    vsubpd zmm5, zmm9, zmm5
    vbroadcastsd zmm12, [t_gcb]
    vbroadcastsd zmm1, [t_gcb + 8]
    vmulpd zmm9, zmm12, zmm2
    vmovapd zmm7, zmm9
    vfmsub231pd zmm7, zmm12, zmm2
    vmulpd zmm10, zmm1, zmm2
    vfmadd231pd zmm10, zmm12, zmm0
    vaddpd zmm7, zmm7, zmm10
    vaddpd zmm10, zmm9, zmm7
    vsubpd zmm14, zmm10, zmm9
    vsubpd zmm14, zmm7, zmm14
    vaddpd zmm1, zmm13, zmm10
    vsubpd zmm12, zmm1, zmm13
    vsubpd zmm7, zmm1, zmm12
    vsubpd zmm7, zmm13, zmm7
    vsubpd zmm12, zmm10, zmm12
    vaddpd zmm7, zmm7, zmm12
    vaddpd zmm12, zmm5, zmm14
    vsubpd zmm9, zmm12, zmm5
    vsubpd zmm15, zmm12, zmm9
    vsubpd zmm15, zmm5, zmm15
    vsubpd zmm9, zmm14, zmm9
    vaddpd zmm15, zmm15, zmm9
    vaddpd zmm9, zmm7, zmm12
    vaddpd zmm12, zmm1, zmm9
    vsubpd zmm7, zmm12, zmm1
    vsubpd zmm7, zmm9, zmm7
    vaddpd zmm9, zmm7, zmm15
    vaddpd zmm15, zmm12, zmm9
    vsubpd zmm7, zmm15, zmm12
    vsubpd zmm7, zmm9, zmm7
    vbroadcastsd zmm5, [t_bcb]
    vbroadcastsd zmm13, [t_bcb + 8]
    vmulpd zmm14, zmm5, zmm2
    vmovapd zmm10, zmm14
    vfmsub231pd zmm10, zmm5, zmm2
    vmulpd zmm9, zmm13, zmm2
    vfmadd231pd zmm9, zmm5, zmm0
    vaddpd zmm10, zmm10, zmm9
    vaddpd zmm9, zmm14, zmm10
    vsubpd zmm12, zmm9, zmm14
    vsubpd zmm12, zmm10, zmm12
    vaddpd zmm13, zmm11, zmm9
    vsubpd zmm5, zmm13, zmm11
    vsubpd zmm10, zmm13, zmm5
    vsubpd zmm10, zmm11, zmm10
    vsubpd zmm5, zmm9, zmm5
    vaddpd zmm10, zmm10, zmm5
    vaddpd zmm5, zmm6, zmm12
    vsubpd zmm14, zmm5, zmm6
    vsubpd zmm1, zmm5, zmm14
    vsubpd zmm1, zmm6, zmm1
    vsubpd zmm14, zmm12, zmm14
    vaddpd zmm1, zmm1, zmm14
    vaddpd zmm14, zmm10, zmm5
    vaddpd zmm5, zmm13, zmm14
    vsubpd zmm10, zmm5, zmm13
    vsubpd zmm10, zmm14, zmm10
    vaddpd zmm14, zmm10, zmm1
    vaddpd zmm1, zmm5, zmm14
    vsubpd zmm10, zmm1, zmm5
    vsubpd zmm10, zmm14, zmm10
    vmovapd [r7 + T_V], zmm4
    vmovapd [r7 + T_V + 64], zmm8
    vmovapd [r7 + T_V + 128], zmm15
    vmovapd [r7 + T_V + 192], zmm7
    vmovapd [r7 + T_V + 256], zmm1
    vmovapd [r7 + T_V + 320], zmm10
    vpxorq zmm0, zmm0, zmm0
    vmovapd zmm1{k4}{z}, [r7 + T_SY + 64]
    vmovapd zmm2{k4}{z}, [r7 + T_SB + 64]
    vmovapd zmm3{k4}{z}, [r7 + T_SR + 64]
    vbroadcastsd zmm4, [t_ysc]
    vbroadcastsd zmm5, [t_ysc + 8]
    vmulpd zmm6, zmm1, zmm4
    vmovapd zmm7, zmm6
    vfmsub231pd zmm7, zmm1, zmm4
    vmulpd zmm8, zmm0, zmm4
    vfmadd231pd zmm8, zmm1, zmm5
    vaddpd zmm7, zmm7, zmm8
    vaddpd zmm8, zmm6, zmm7
    vsubpd zmm9, zmm8, zmm6
    vsubpd zmm9, zmm7, zmm9
    vbroadcastsd zmm1, [t_yof]
    vbroadcastsd zmm5, [t_yof + 8]
    vaddpd zmm4, zmm8, zmm1
    vsubpd zmm7, zmm4, zmm8
    vsubpd zmm6, zmm4, zmm7
    vsubpd zmm6, zmm8, zmm6
    vsubpd zmm7, zmm1, zmm7
    vaddpd zmm6, zmm6, zmm7
    vaddpd zmm7, zmm9, zmm5
    vsubpd zmm10, zmm7, zmm9
    vsubpd zmm11, zmm7, zmm10
    vsubpd zmm11, zmm9, zmm11
    vsubpd zmm10, zmm5, zmm10
    vaddpd zmm11, zmm11, zmm10
    vaddpd zmm10, zmm6, zmm7
    vaddpd zmm7, zmm4, zmm10
    vsubpd zmm6, zmm7, zmm4
    vsubpd zmm6, zmm10, zmm6
    vaddpd zmm10, zmm6, zmm11
    vaddpd zmm11, zmm7, zmm10
    vsubpd zmm6, zmm11, zmm7
    vsubpd zmm6, zmm10, zmm6
    vbroadcastsd zmm5, [t_rcr]
    vbroadcastsd zmm1, [t_rcr + 8]
    vmulpd zmm9, zmm5, zmm3
    vmovapd zmm8, zmm9
    vfmsub231pd zmm8, zmm5, zmm3
    vmulpd zmm10, zmm1, zmm3
    vfmadd231pd zmm10, zmm5, zmm0
    vaddpd zmm8, zmm8, zmm10
    vaddpd zmm10, zmm9, zmm8
    vsubpd zmm7, zmm10, zmm9
    vsubpd zmm7, zmm8, zmm7
    vaddpd zmm1, zmm11, zmm10
    vsubpd zmm5, zmm1, zmm11
    vsubpd zmm8, zmm1, zmm5
    vsubpd zmm8, zmm11, zmm8
    vsubpd zmm5, zmm10, zmm5
    vaddpd zmm8, zmm8, zmm5
    vaddpd zmm5, zmm6, zmm7
    vsubpd zmm9, zmm5, zmm6
    vsubpd zmm4, zmm5, zmm9
    vsubpd zmm4, zmm6, zmm4
    vsubpd zmm9, zmm7, zmm9
    vaddpd zmm4, zmm4, zmm9
    vaddpd zmm9, zmm8, zmm5
    vaddpd zmm5, zmm1, zmm9
    vsubpd zmm8, zmm5, zmm1
    vsubpd zmm8, zmm9, zmm8
    vaddpd zmm9, zmm8, zmm4
    vaddpd zmm4, zmm5, zmm9
    vsubpd zmm8, zmm4, zmm5
    vsubpd zmm8, zmm9, zmm8
    vbroadcastsd zmm7, [t_gcr]
    vbroadcastsd zmm10, [t_gcr + 8]
    vmulpd zmm9, zmm7, zmm3
    vmovapd zmm5, zmm9
    vfmsub231pd zmm5, zmm7, zmm3
    vmulpd zmm1, zmm10, zmm3
    vfmadd231pd zmm1, zmm7, zmm0
    vaddpd zmm5, zmm5, zmm1
    vaddpd zmm1, zmm9, zmm5
    vsubpd zmm12, zmm1, zmm9
    vsubpd zmm12, zmm5, zmm12
    vaddpd zmm10, zmm11, zmm1
    vsubpd zmm7, zmm10, zmm11
    vsubpd zmm5, zmm10, zmm7
    vsubpd zmm5, zmm11, zmm5
    vsubpd zmm7, zmm1, zmm7
    vaddpd zmm5, zmm5, zmm7
    vaddpd zmm7, zmm6, zmm12
    vsubpd zmm9, zmm7, zmm6
    vsubpd zmm13, zmm7, zmm9
    vsubpd zmm13, zmm6, zmm13
    vsubpd zmm9, zmm12, zmm9
    vaddpd zmm13, zmm13, zmm9
    vaddpd zmm9, zmm5, zmm7
    vaddpd zmm7, zmm10, zmm9
    vsubpd zmm5, zmm7, zmm10
    vsubpd zmm5, zmm9, zmm5
    vaddpd zmm9, zmm5, zmm13
    vaddpd zmm13, zmm7, zmm9
    vsubpd zmm5, zmm13, zmm7
    vsubpd zmm5, zmm9, zmm5
    vbroadcastsd zmm12, [t_gcb]
    vbroadcastsd zmm1, [t_gcb + 8]
    vmulpd zmm9, zmm12, zmm2
    vmovapd zmm7, zmm9
    vfmsub231pd zmm7, zmm12, zmm2
    vmulpd zmm10, zmm1, zmm2
    vfmadd231pd zmm10, zmm12, zmm0
    vaddpd zmm7, zmm7, zmm10
    vaddpd zmm10, zmm9, zmm7
    vsubpd zmm14, zmm10, zmm9
    vsubpd zmm14, zmm7, zmm14
    vaddpd zmm1, zmm13, zmm10
    vsubpd zmm12, zmm1, zmm13
    vsubpd zmm7, zmm1, zmm12
    vsubpd zmm7, zmm13, zmm7
    vsubpd zmm12, zmm10, zmm12
    vaddpd zmm7, zmm7, zmm12
    vaddpd zmm12, zmm5, zmm14
    vsubpd zmm9, zmm12, zmm5
    vsubpd zmm15, zmm12, zmm9
    vsubpd zmm15, zmm5, zmm15
    vsubpd zmm9, zmm14, zmm9
    vaddpd zmm15, zmm15, zmm9
    vaddpd zmm9, zmm7, zmm12
    vaddpd zmm12, zmm1, zmm9
    vsubpd zmm7, zmm12, zmm1
    vsubpd zmm7, zmm9, zmm7
    vaddpd zmm9, zmm7, zmm15
    vaddpd zmm15, zmm12, zmm9
    vsubpd zmm7, zmm15, zmm12
    vsubpd zmm7, zmm9, zmm7
    vbroadcastsd zmm5, [t_bcb]
    vbroadcastsd zmm13, [t_bcb + 8]
    vmulpd zmm14, zmm5, zmm2
    vmovapd zmm10, zmm14
    vfmsub231pd zmm10, zmm5, zmm2
    vmulpd zmm9, zmm13, zmm2
    vfmadd231pd zmm9, zmm5, zmm0
    vaddpd zmm10, zmm10, zmm9
    vaddpd zmm9, zmm14, zmm10
    vsubpd zmm12, zmm9, zmm14
    vsubpd zmm12, zmm10, zmm12
    vaddpd zmm13, zmm11, zmm9
    vsubpd zmm5, zmm13, zmm11
    vsubpd zmm10, zmm13, zmm5
    vsubpd zmm10, zmm11, zmm10
    vsubpd zmm5, zmm9, zmm5
    vaddpd zmm10, zmm10, zmm5
    vaddpd zmm5, zmm6, zmm12
    vsubpd zmm14, zmm5, zmm6
    vsubpd zmm1, zmm5, zmm14
    vsubpd zmm1, zmm6, zmm1
    vsubpd zmm14, zmm12, zmm14
    vaddpd zmm1, zmm1, zmm14
    vaddpd zmm14, zmm10, zmm5
    vaddpd zmm5, zmm13, zmm14
    vsubpd zmm10, zmm5, zmm13
    vsubpd zmm10, zmm14, zmm10
    vaddpd zmm14, zmm10, zmm1
    vaddpd zmm1, zmm5, zmm14
    vsubpd zmm10, zmm1, zmm5
    vsubpd zmm10, zmm14, zmm10
    vmovapd [r7 + T_V + 384], zmm4
    vmovapd [r7 + T_V + 448], zmm8
    vmovapd [r7 + T_V + 512], zmm15
    vmovapd [r7 + T_V + 576], zmm7
    vmovapd [r7 + T_V + 640], zmm1
    vmovapd [r7 + T_V + 704], zmm10
    vmovapd zmm16, [r7 + T_V]
    vmovapd zmm17, [r7 + T_V + 64]
    call .xeo
    vmovapd [r7 + T_X], zmm16
    vmovapd [r7 + T_X + 64], zmm17
    vmovapd zmm16, [r7 + T_V + 128]
    vmovapd zmm17, [r7 + T_V + 192]
    call .xeo
    vmovapd [r7 + T_X + 128], zmm16
    vmovapd [r7 + T_X + 192], zmm17
    vmovapd zmm16, [r7 + T_V + 256]
    vmovapd zmm17, [r7 + T_V + 320]
    call .xeo
    vmovapd [r7 + T_X + 256], zmm16
    vmovapd [r7 + T_X + 320], zmm17
    vmovapd zmm16, [r7 + T_V + 384]
    vmovapd zmm17, [r7 + T_V + 448]
    call .xeo
    vmovapd [r7 + T_X + 384], zmm16
    vmovapd [r7 + T_X + 448], zmm17
    vmovapd zmm16, [r7 + T_V + 512]
    vmovapd zmm17, [r7 + T_V + 576]
    call .xeo
    vmovapd [r7 + T_X + 512], zmm16
    vmovapd [r7 + T_X + 576], zmm17
    vmovapd zmm16, [r7 + T_V + 640]
    vmovapd zmm17, [r7 + T_V + 704]
    call .xeo
    vmovapd [r7 + T_X + 640], zmm16
    vmovapd [r7 + T_X + 704], zmm17
    vpxorq zmm0, zmm0, zmm0
    vmovapd [r7 + T_ACC], zmm0
    vmovapd [r7 + T_ACC + 64], zmm0
    vxorpd xmm0, xmm0, xmm0
    vxorpd xmm1, xmm1, xmm1
    vmovsd xmm2, [r7 + T_X]
    vmovsd xmm3, [r7 + T_X + 64]
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
    vmovsd xmm3, [r7 + T_X + 8]
    vmovsd xmm2, [r7 + T_X + 72]
    vaddsd xmm1, xmm8, xmm3
    vsubsd xmm0, xmm1, xmm8
    vsubsd xmm7, xmm1, xmm0
    vsubsd xmm7, xmm8, xmm7
    vsubsd xmm0, xmm3, xmm0
    vaddsd xmm7, xmm7, xmm0
    vaddsd xmm0, xmm6, xmm2
    vsubsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm0, xmm5
    vsubsd xmm4, xmm6, xmm4
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm0
    vaddsd xmm0, xmm1, xmm5
    vsubsd xmm7, xmm0, xmm1
    vsubsd xmm7, xmm5, xmm7
    vaddsd xmm5, xmm7, xmm4
    vaddsd xmm4, xmm0, xmm5
    vsubsd xmm7, xmm4, xmm0
    vsubsd xmm7, xmm5, xmm7
    vmovsd xmm2, [r7 + T_X + 16]
    vmovsd xmm3, [r7 + T_X + 80]
    vaddsd xmm6, xmm4, xmm2
    vsubsd xmm8, xmm6, xmm4
    vsubsd xmm5, xmm6, xmm8
    vsubsd xmm5, xmm4, xmm5
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm5, xmm5, xmm8
    vaddsd xmm8, xmm7, xmm3
    vsubsd xmm0, xmm8, xmm7
    vsubsd xmm1, xmm8, xmm0
    vsubsd xmm1, xmm7, xmm1
    vsubsd xmm0, xmm3, xmm0
    vaddsd xmm1, xmm1, xmm0
    vaddsd xmm0, xmm5, xmm8
    vaddsd xmm8, xmm6, xmm0
    vsubsd xmm5, xmm8, xmm6
    vsubsd xmm5, xmm0, xmm5
    vaddsd xmm0, xmm5, xmm1
    vaddsd xmm1, xmm8, xmm0
    vsubsd xmm5, xmm1, xmm8
    vsubsd xmm5, xmm0, xmm5
    vmovsd xmm3, [r7 + T_X + 24]
    vmovsd xmm2, [r7 + T_X + 88]
    vaddsd xmm7, xmm1, xmm3
    vsubsd xmm4, xmm7, xmm1
    vsubsd xmm0, xmm7, xmm4
    vsubsd xmm0, xmm1, xmm0
    vsubsd xmm4, xmm3, xmm4
    vaddsd xmm0, xmm0, xmm4
    vaddsd xmm4, xmm5, xmm2
    vsubsd xmm8, xmm4, xmm5
    vsubsd xmm6, xmm4, xmm8
    vsubsd xmm6, xmm5, xmm6
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm6, xmm6, xmm8
    vaddsd xmm8, xmm0, xmm4
    vaddsd xmm4, xmm7, xmm8
    vsubsd xmm0, xmm4, xmm7
    vsubsd xmm0, xmm8, xmm0
    vaddsd xmm8, xmm0, xmm6
    vaddsd xmm6, xmm4, xmm8
    vsubsd xmm0, xmm6, xmm4
    vsubsd xmm0, xmm8, xmm0
    vmovsd xmm2, [r7 + T_X + 32]
    vmovsd xmm3, [r7 + T_X + 96]
    vaddsd xmm5, xmm6, xmm2
    vsubsd xmm1, xmm5, xmm6
    vsubsd xmm8, xmm5, xmm1
    vsubsd xmm8, xmm6, xmm8
    vsubsd xmm1, xmm2, xmm1
    vaddsd xmm8, xmm8, xmm1
    vaddsd xmm1, xmm0, xmm3
    vsubsd xmm4, xmm1, xmm0
    vsubsd xmm7, xmm1, xmm4
    vsubsd xmm7, xmm0, xmm7
    vsubsd xmm4, xmm3, xmm4
    vaddsd xmm7, xmm7, xmm4
    vaddsd xmm4, xmm8, xmm1
    vaddsd xmm1, xmm5, xmm4
    vsubsd xmm8, xmm1, xmm5
    vsubsd xmm8, xmm4, xmm8
    vaddsd xmm4, xmm8, xmm7
    vaddsd xmm7, xmm1, xmm4
    vsubsd xmm8, xmm7, xmm1
    vsubsd xmm8, xmm4, xmm8
    vmovsd xmm3, [r7 + T_X + 40]
    vmovsd xmm2, [r7 + T_X + 104]
    vaddsd xmm0, xmm7, xmm3
    vsubsd xmm6, xmm0, xmm7
    vsubsd xmm4, xmm0, xmm6
    vsubsd xmm4, xmm7, xmm4
    vsubsd xmm6, xmm3, xmm6
    vaddsd xmm4, xmm4, xmm6
    vaddsd xmm6, xmm8, xmm2
    vsubsd xmm1, xmm6, xmm8
    vsubsd xmm5, xmm6, xmm1
    vsubsd xmm5, xmm8, xmm5
    vsubsd xmm1, xmm2, xmm1
    vaddsd xmm5, xmm5, xmm1
    vaddsd xmm1, xmm4, xmm6
    vaddsd xmm6, xmm0, xmm1
    vsubsd xmm4, xmm6, xmm0
    vsubsd xmm4, xmm1, xmm4
    vaddsd xmm1, xmm4, xmm5
    vaddsd xmm5, xmm6, xmm1
    vsubsd xmm4, xmm5, xmm6
    vsubsd xmm4, xmm1, xmm4
    vmovsd xmm2, [r7 + T_X + 48]
    vmovsd xmm3, [r7 + T_X + 112]
    vaddsd xmm8, xmm5, xmm2
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm1, xmm8, xmm7
    vsubsd xmm1, xmm5, xmm1
    vsubsd xmm7, xmm2, xmm7
    vaddsd xmm1, xmm1, xmm7
    vaddsd xmm7, xmm4, xmm3
    vsubsd xmm6, xmm7, xmm4
    vsubsd xmm0, xmm7, xmm6
    vsubsd xmm0, xmm4, xmm0
    vsubsd xmm6, xmm3, xmm6
    vaddsd xmm0, xmm0, xmm6
    vaddsd xmm6, xmm1, xmm7
    vaddsd xmm7, xmm8, xmm6
    vsubsd xmm1, xmm7, xmm8
    vsubsd xmm1, xmm6, xmm1
    vaddsd xmm6, xmm1, xmm0
    vaddsd xmm0, xmm7, xmm6
    vsubsd xmm1, xmm0, xmm7
    vsubsd xmm1, xmm6, xmm1
    vmovsd xmm3, [r7 + T_X + 56]
    vmovsd xmm2, [r7 + T_X + 120]
    vaddsd xmm4, xmm0, xmm3
    vsubsd xmm5, xmm4, xmm0
    vsubsd xmm6, xmm4, xmm5
    vsubsd xmm6, xmm0, xmm6
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm6, xmm6, xmm5
    vaddsd xmm5, xmm1, xmm2
    vsubsd xmm7, xmm5, xmm1
    vsubsd xmm8, xmm5, xmm7
    vsubsd xmm8, xmm1, xmm8
    vsubsd xmm7, xmm2, xmm7
    vaddsd xmm8, xmm8, xmm7
    vaddsd xmm7, xmm6, xmm5
    vaddsd xmm5, xmm4, xmm7
    vsubsd xmm6, xmm5, xmm4
    vsubsd xmm6, xmm7, xmm6
    vaddsd xmm7, xmm6, xmm8
    vaddsd xmm8, xmm5, xmm7
    vsubsd xmm6, xmm8, xmm5
    vsubsd xmm6, xmm7, xmm6
    vmovsd xmm2, [r7 + T_X + 384]
    vmovsd xmm3, [r7 + T_X + 448]
    vaddsd xmm1, xmm8, xmm2
    vsubsd xmm0, xmm1, xmm8
    vsubsd xmm7, xmm1, xmm0
    vsubsd xmm7, xmm8, xmm7
    vsubsd xmm0, xmm2, xmm0
    vaddsd xmm7, xmm7, xmm0
    vaddsd xmm0, xmm6, xmm3
    vsubsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm0, xmm5
    vsubsd xmm4, xmm6, xmm4
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm0
    vaddsd xmm0, xmm1, xmm5
    vsubsd xmm7, xmm0, xmm1
    vsubsd xmm7, xmm5, xmm7
    vaddsd xmm5, xmm7, xmm4
    vaddsd xmm4, xmm0, xmm5
    vsubsd xmm7, xmm4, xmm0
    vsubsd xmm7, xmm5, xmm7
    vmovsd xmm3, [r7 + T_X + 392]
    vmovsd xmm2, [r7 + T_X + 456]
    vaddsd xmm6, xmm4, xmm3
    vsubsd xmm8, xmm6, xmm4
    vsubsd xmm5, xmm6, xmm8
    vsubsd xmm5, xmm4, xmm5
    vsubsd xmm8, xmm3, xmm8
    vaddsd xmm5, xmm5, xmm8
    vaddsd xmm8, xmm7, xmm2
    vsubsd xmm0, xmm8, xmm7
    vsubsd xmm1, xmm8, xmm0
    vsubsd xmm1, xmm7, xmm1
    vsubsd xmm0, xmm2, xmm0
    vaddsd xmm1, xmm1, xmm0
    vaddsd xmm0, xmm5, xmm8
    vaddsd xmm8, xmm6, xmm0
    vsubsd xmm5, xmm8, xmm6
    vsubsd xmm5, xmm0, xmm5
    vaddsd xmm0, xmm5, xmm1
    vaddsd xmm1, xmm8, xmm0
    vsubsd xmm5, xmm1, xmm8
    vsubsd xmm5, xmm0, xmm5
    vmovsd xmm2, [r7 + T_X + 400]
    vmovsd xmm3, [r7 + T_X + 464]
    vaddsd xmm7, xmm1, xmm2
    vsubsd xmm4, xmm7, xmm1
    vsubsd xmm0, xmm7, xmm4
    vsubsd xmm0, xmm1, xmm0
    vsubsd xmm4, xmm2, xmm4
    vaddsd xmm0, xmm0, xmm4
    vaddsd xmm4, xmm5, xmm3
    vsubsd xmm8, xmm4, xmm5
    vsubsd xmm6, xmm4, xmm8
    vsubsd xmm6, xmm5, xmm6
    vsubsd xmm8, xmm3, xmm8
    vaddsd xmm6, xmm6, xmm8
    vaddsd xmm8, xmm0, xmm4
    vaddsd xmm4, xmm7, xmm8
    vsubsd xmm0, xmm4, xmm7
    vsubsd xmm0, xmm8, xmm0
    vaddsd xmm8, xmm0, xmm6
    vaddsd xmm6, xmm4, xmm8
    vsubsd xmm0, xmm6, xmm4
    vsubsd xmm0, xmm8, xmm0
    vmovsd xmm3, [r7 + T_X + 408]
    vmovsd xmm2, [r7 + T_X + 472]
    vaddsd xmm5, xmm6, xmm3
    vsubsd xmm1, xmm5, xmm6
    vsubsd xmm8, xmm5, xmm1
    vsubsd xmm8, xmm6, xmm8
    vsubsd xmm1, xmm3, xmm1
    vaddsd xmm8, xmm8, xmm1
    vaddsd xmm1, xmm0, xmm2
    vsubsd xmm4, xmm1, xmm0
    vsubsd xmm7, xmm1, xmm4
    vsubsd xmm7, xmm0, xmm7
    vsubsd xmm4, xmm2, xmm4
    vaddsd xmm7, xmm7, xmm4
    vaddsd xmm4, xmm8, xmm1
    vaddsd xmm1, xmm5, xmm4
    vsubsd xmm8, xmm1, xmm5
    vsubsd xmm8, xmm4, xmm8
    vaddsd xmm4, xmm8, xmm7
    vaddsd xmm7, xmm1, xmm4
    vsubsd xmm8, xmm7, xmm1
    vsubsd xmm8, xmm4, xmm8
    vmovsd xmm2, [r7 + T_X + 416]
    vmovsd xmm3, [r7 + T_X + 480]
    vaddsd xmm0, xmm7, xmm2
    vsubsd xmm6, xmm0, xmm7
    vsubsd xmm4, xmm0, xmm6
    vsubsd xmm4, xmm7, xmm4
    vsubsd xmm6, xmm2, xmm6
    vaddsd xmm4, xmm4, xmm6
    vaddsd xmm6, xmm8, xmm3
    vsubsd xmm1, xmm6, xmm8
    vsubsd xmm5, xmm6, xmm1
    vsubsd xmm5, xmm8, xmm5
    vsubsd xmm1, xmm3, xmm1
    vaddsd xmm5, xmm5, xmm1
    vaddsd xmm1, xmm4, xmm6
    vaddsd xmm6, xmm0, xmm1
    vsubsd xmm4, xmm6, xmm0
    vsubsd xmm4, xmm1, xmm4
    vaddsd xmm1, xmm4, xmm5
    vaddsd xmm5, xmm6, xmm1
    vsubsd xmm4, xmm5, xmm6
    vsubsd xmm4, xmm1, xmm4
    vmovsd xmm3, [r7 + T_X + 424]
    vmovsd xmm2, [r7 + T_X + 488]
    vaddsd xmm8, xmm5, xmm3
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm1, xmm8, xmm7
    vsubsd xmm1, xmm5, xmm1
    vsubsd xmm7, xmm3, xmm7
    vaddsd xmm1, xmm1, xmm7
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm6, xmm7, xmm4
    vsubsd xmm0, xmm7, xmm6
    vsubsd xmm0, xmm4, xmm0
    vsubsd xmm6, xmm2, xmm6
    vaddsd xmm0, xmm0, xmm6
    vaddsd xmm6, xmm1, xmm7
    vaddsd xmm7, xmm8, xmm6
    vsubsd xmm1, xmm7, xmm8
    vsubsd xmm1, xmm6, xmm1
    vaddsd xmm6, xmm1, xmm0
    vaddsd xmm0, xmm7, xmm6
    vsubsd xmm1, xmm0, xmm7
    vsubsd xmm1, xmm6, xmm1
    vmovsd xmm2, [r7 + T_X + 432]
    vmovsd xmm3, [r7 + T_X + 496]
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
    vmovsd xmm3, [r7 + T_X + 440]
    vmovsd xmm2, [r7 + T_X + 504]
    vaddsd xmm1, xmm8, xmm3
    vsubsd xmm0, xmm1, xmm8
    vsubsd xmm7, xmm1, xmm0
    vsubsd xmm7, xmm8, xmm7
    vsubsd xmm0, xmm3, xmm0
    vaddsd xmm7, xmm7, xmm0
    vaddsd xmm0, xmm6, xmm2
    vsubsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm0, xmm5
    vsubsd xmm4, xmm6, xmm4
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm0
    vaddsd xmm0, xmm1, xmm5
    vsubsd xmm7, xmm0, xmm1
    vsubsd xmm7, xmm5, xmm7
    vaddsd xmm5, xmm7, xmm4
    vaddsd xmm4, xmm0, xmm5
    vsubsd xmm7, xmm4, xmm0
    vsubsd xmm7, xmm5, xmm7
    vmovsd [r7 + T_ACC], xmm4
    vmovsd [r7 + T_ACC + 64], xmm7
    vxorpd xmm0, xmm0, xmm0
    vxorpd xmm1, xmm1, xmm1
    vmovsd xmm2, [r7 + T_X + 128]
    vmovsd xmm3, [r7 + T_X + 192]
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
    vmovsd xmm3, [r7 + T_X + 136]
    vmovsd xmm2, [r7 + T_X + 200]
    vaddsd xmm1, xmm8, xmm3
    vsubsd xmm0, xmm1, xmm8
    vsubsd xmm7, xmm1, xmm0
    vsubsd xmm7, xmm8, xmm7
    vsubsd xmm0, xmm3, xmm0
    vaddsd xmm7, xmm7, xmm0
    vaddsd xmm0, xmm6, xmm2
    vsubsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm0, xmm5
    vsubsd xmm4, xmm6, xmm4
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm0
    vaddsd xmm0, xmm1, xmm5
    vsubsd xmm7, xmm0, xmm1
    vsubsd xmm7, xmm5, xmm7
    vaddsd xmm5, xmm7, xmm4
    vaddsd xmm4, xmm0, xmm5
    vsubsd xmm7, xmm4, xmm0
    vsubsd xmm7, xmm5, xmm7
    vmovsd xmm2, [r7 + T_X + 144]
    vmovsd xmm3, [r7 + T_X + 208]
    vaddsd xmm6, xmm4, xmm2
    vsubsd xmm8, xmm6, xmm4
    vsubsd xmm5, xmm6, xmm8
    vsubsd xmm5, xmm4, xmm5
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm5, xmm5, xmm8
    vaddsd xmm8, xmm7, xmm3
    vsubsd xmm0, xmm8, xmm7
    vsubsd xmm1, xmm8, xmm0
    vsubsd xmm1, xmm7, xmm1
    vsubsd xmm0, xmm3, xmm0
    vaddsd xmm1, xmm1, xmm0
    vaddsd xmm0, xmm5, xmm8
    vaddsd xmm8, xmm6, xmm0
    vsubsd xmm5, xmm8, xmm6
    vsubsd xmm5, xmm0, xmm5
    vaddsd xmm0, xmm5, xmm1
    vaddsd xmm1, xmm8, xmm0
    vsubsd xmm5, xmm1, xmm8
    vsubsd xmm5, xmm0, xmm5
    vmovsd xmm3, [r7 + T_X + 152]
    vmovsd xmm2, [r7 + T_X + 216]
    vaddsd xmm7, xmm1, xmm3
    vsubsd xmm4, xmm7, xmm1
    vsubsd xmm0, xmm7, xmm4
    vsubsd xmm0, xmm1, xmm0
    vsubsd xmm4, xmm3, xmm4
    vaddsd xmm0, xmm0, xmm4
    vaddsd xmm4, xmm5, xmm2
    vsubsd xmm8, xmm4, xmm5
    vsubsd xmm6, xmm4, xmm8
    vsubsd xmm6, xmm5, xmm6
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm6, xmm6, xmm8
    vaddsd xmm8, xmm0, xmm4
    vaddsd xmm4, xmm7, xmm8
    vsubsd xmm0, xmm4, xmm7
    vsubsd xmm0, xmm8, xmm0
    vaddsd xmm8, xmm0, xmm6
    vaddsd xmm6, xmm4, xmm8
    vsubsd xmm0, xmm6, xmm4
    vsubsd xmm0, xmm8, xmm0
    vmovsd xmm2, [r7 + T_X + 160]
    vmovsd xmm3, [r7 + T_X + 224]
    vaddsd xmm5, xmm6, xmm2
    vsubsd xmm1, xmm5, xmm6
    vsubsd xmm8, xmm5, xmm1
    vsubsd xmm8, xmm6, xmm8
    vsubsd xmm1, xmm2, xmm1
    vaddsd xmm8, xmm8, xmm1
    vaddsd xmm1, xmm0, xmm3
    vsubsd xmm4, xmm1, xmm0
    vsubsd xmm7, xmm1, xmm4
    vsubsd xmm7, xmm0, xmm7
    vsubsd xmm4, xmm3, xmm4
    vaddsd xmm7, xmm7, xmm4
    vaddsd xmm4, xmm8, xmm1
    vaddsd xmm1, xmm5, xmm4
    vsubsd xmm8, xmm1, xmm5
    vsubsd xmm8, xmm4, xmm8
    vaddsd xmm4, xmm8, xmm7
    vaddsd xmm7, xmm1, xmm4
    vsubsd xmm8, xmm7, xmm1
    vsubsd xmm8, xmm4, xmm8
    vmovsd xmm3, [r7 + T_X + 168]
    vmovsd xmm2, [r7 + T_X + 232]
    vaddsd xmm0, xmm7, xmm3
    vsubsd xmm6, xmm0, xmm7
    vsubsd xmm4, xmm0, xmm6
    vsubsd xmm4, xmm7, xmm4
    vsubsd xmm6, xmm3, xmm6
    vaddsd xmm4, xmm4, xmm6
    vaddsd xmm6, xmm8, xmm2
    vsubsd xmm1, xmm6, xmm8
    vsubsd xmm5, xmm6, xmm1
    vsubsd xmm5, xmm8, xmm5
    vsubsd xmm1, xmm2, xmm1
    vaddsd xmm5, xmm5, xmm1
    vaddsd xmm1, xmm4, xmm6
    vaddsd xmm6, xmm0, xmm1
    vsubsd xmm4, xmm6, xmm0
    vsubsd xmm4, xmm1, xmm4
    vaddsd xmm1, xmm4, xmm5
    vaddsd xmm5, xmm6, xmm1
    vsubsd xmm4, xmm5, xmm6
    vsubsd xmm4, xmm1, xmm4
    vmovsd xmm2, [r7 + T_X + 176]
    vmovsd xmm3, [r7 + T_X + 240]
    vaddsd xmm8, xmm5, xmm2
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm1, xmm8, xmm7
    vsubsd xmm1, xmm5, xmm1
    vsubsd xmm7, xmm2, xmm7
    vaddsd xmm1, xmm1, xmm7
    vaddsd xmm7, xmm4, xmm3
    vsubsd xmm6, xmm7, xmm4
    vsubsd xmm0, xmm7, xmm6
    vsubsd xmm0, xmm4, xmm0
    vsubsd xmm6, xmm3, xmm6
    vaddsd xmm0, xmm0, xmm6
    vaddsd xmm6, xmm1, xmm7
    vaddsd xmm7, xmm8, xmm6
    vsubsd xmm1, xmm7, xmm8
    vsubsd xmm1, xmm6, xmm1
    vaddsd xmm6, xmm1, xmm0
    vaddsd xmm0, xmm7, xmm6
    vsubsd xmm1, xmm0, xmm7
    vsubsd xmm1, xmm6, xmm1
    vmovsd xmm3, [r7 + T_X + 184]
    vmovsd xmm2, [r7 + T_X + 248]
    vaddsd xmm4, xmm0, xmm3
    vsubsd xmm5, xmm4, xmm0
    vsubsd xmm6, xmm4, xmm5
    vsubsd xmm6, xmm0, xmm6
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm6, xmm6, xmm5
    vaddsd xmm5, xmm1, xmm2
    vsubsd xmm7, xmm5, xmm1
    vsubsd xmm8, xmm5, xmm7
    vsubsd xmm8, xmm1, xmm8
    vsubsd xmm7, xmm2, xmm7
    vaddsd xmm8, xmm8, xmm7
    vaddsd xmm7, xmm6, xmm5
    vaddsd xmm5, xmm4, xmm7
    vsubsd xmm6, xmm5, xmm4
    vsubsd xmm6, xmm7, xmm6
    vaddsd xmm7, xmm6, xmm8
    vaddsd xmm8, xmm5, xmm7
    vsubsd xmm6, xmm8, xmm5
    vsubsd xmm6, xmm7, xmm6
    vmovsd xmm2, [r7 + T_X + 512]
    vmovsd xmm3, [r7 + T_X + 576]
    vaddsd xmm1, xmm8, xmm2
    vsubsd xmm0, xmm1, xmm8
    vsubsd xmm7, xmm1, xmm0
    vsubsd xmm7, xmm8, xmm7
    vsubsd xmm0, xmm2, xmm0
    vaddsd xmm7, xmm7, xmm0
    vaddsd xmm0, xmm6, xmm3
    vsubsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm0, xmm5
    vsubsd xmm4, xmm6, xmm4
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm0
    vaddsd xmm0, xmm1, xmm5
    vsubsd xmm7, xmm0, xmm1
    vsubsd xmm7, xmm5, xmm7
    vaddsd xmm5, xmm7, xmm4
    vaddsd xmm4, xmm0, xmm5
    vsubsd xmm7, xmm4, xmm0
    vsubsd xmm7, xmm5, xmm7
    vmovsd xmm3, [r7 + T_X + 520]
    vmovsd xmm2, [r7 + T_X + 584]
    vaddsd xmm6, xmm4, xmm3
    vsubsd xmm8, xmm6, xmm4
    vsubsd xmm5, xmm6, xmm8
    vsubsd xmm5, xmm4, xmm5
    vsubsd xmm8, xmm3, xmm8
    vaddsd xmm5, xmm5, xmm8
    vaddsd xmm8, xmm7, xmm2
    vsubsd xmm0, xmm8, xmm7
    vsubsd xmm1, xmm8, xmm0
    vsubsd xmm1, xmm7, xmm1
    vsubsd xmm0, xmm2, xmm0
    vaddsd xmm1, xmm1, xmm0
    vaddsd xmm0, xmm5, xmm8
    vaddsd xmm8, xmm6, xmm0
    vsubsd xmm5, xmm8, xmm6
    vsubsd xmm5, xmm0, xmm5
    vaddsd xmm0, xmm5, xmm1
    vaddsd xmm1, xmm8, xmm0
    vsubsd xmm5, xmm1, xmm8
    vsubsd xmm5, xmm0, xmm5
    vmovsd xmm2, [r7 + T_X + 528]
    vmovsd xmm3, [r7 + T_X + 592]
    vaddsd xmm7, xmm1, xmm2
    vsubsd xmm4, xmm7, xmm1
    vsubsd xmm0, xmm7, xmm4
    vsubsd xmm0, xmm1, xmm0
    vsubsd xmm4, xmm2, xmm4
    vaddsd xmm0, xmm0, xmm4
    vaddsd xmm4, xmm5, xmm3
    vsubsd xmm8, xmm4, xmm5
    vsubsd xmm6, xmm4, xmm8
    vsubsd xmm6, xmm5, xmm6
    vsubsd xmm8, xmm3, xmm8
    vaddsd xmm6, xmm6, xmm8
    vaddsd xmm8, xmm0, xmm4
    vaddsd xmm4, xmm7, xmm8
    vsubsd xmm0, xmm4, xmm7
    vsubsd xmm0, xmm8, xmm0
    vaddsd xmm8, xmm0, xmm6
    vaddsd xmm6, xmm4, xmm8
    vsubsd xmm0, xmm6, xmm4
    vsubsd xmm0, xmm8, xmm0
    vmovsd xmm3, [r7 + T_X + 536]
    vmovsd xmm2, [r7 + T_X + 600]
    vaddsd xmm5, xmm6, xmm3
    vsubsd xmm1, xmm5, xmm6
    vsubsd xmm8, xmm5, xmm1
    vsubsd xmm8, xmm6, xmm8
    vsubsd xmm1, xmm3, xmm1
    vaddsd xmm8, xmm8, xmm1
    vaddsd xmm1, xmm0, xmm2
    vsubsd xmm4, xmm1, xmm0
    vsubsd xmm7, xmm1, xmm4
    vsubsd xmm7, xmm0, xmm7
    vsubsd xmm4, xmm2, xmm4
    vaddsd xmm7, xmm7, xmm4
    vaddsd xmm4, xmm8, xmm1
    vaddsd xmm1, xmm5, xmm4
    vsubsd xmm8, xmm1, xmm5
    vsubsd xmm8, xmm4, xmm8
    vaddsd xmm4, xmm8, xmm7
    vaddsd xmm7, xmm1, xmm4
    vsubsd xmm8, xmm7, xmm1
    vsubsd xmm8, xmm4, xmm8
    vmovsd xmm2, [r7 + T_X + 544]
    vmovsd xmm3, [r7 + T_X + 608]
    vaddsd xmm0, xmm7, xmm2
    vsubsd xmm6, xmm0, xmm7
    vsubsd xmm4, xmm0, xmm6
    vsubsd xmm4, xmm7, xmm4
    vsubsd xmm6, xmm2, xmm6
    vaddsd xmm4, xmm4, xmm6
    vaddsd xmm6, xmm8, xmm3
    vsubsd xmm1, xmm6, xmm8
    vsubsd xmm5, xmm6, xmm1
    vsubsd xmm5, xmm8, xmm5
    vsubsd xmm1, xmm3, xmm1
    vaddsd xmm5, xmm5, xmm1
    vaddsd xmm1, xmm4, xmm6
    vaddsd xmm6, xmm0, xmm1
    vsubsd xmm4, xmm6, xmm0
    vsubsd xmm4, xmm1, xmm4
    vaddsd xmm1, xmm4, xmm5
    vaddsd xmm5, xmm6, xmm1
    vsubsd xmm4, xmm5, xmm6
    vsubsd xmm4, xmm1, xmm4
    vmovsd xmm3, [r7 + T_X + 552]
    vmovsd xmm2, [r7 + T_X + 616]
    vaddsd xmm8, xmm5, xmm3
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm1, xmm8, xmm7
    vsubsd xmm1, xmm5, xmm1
    vsubsd xmm7, xmm3, xmm7
    vaddsd xmm1, xmm1, xmm7
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm6, xmm7, xmm4
    vsubsd xmm0, xmm7, xmm6
    vsubsd xmm0, xmm4, xmm0
    vsubsd xmm6, xmm2, xmm6
    vaddsd xmm0, xmm0, xmm6
    vaddsd xmm6, xmm1, xmm7
    vaddsd xmm7, xmm8, xmm6
    vsubsd xmm1, xmm7, xmm8
    vsubsd xmm1, xmm6, xmm1
    vaddsd xmm6, xmm1, xmm0
    vaddsd xmm0, xmm7, xmm6
    vsubsd xmm1, xmm0, xmm7
    vsubsd xmm1, xmm6, xmm1
    vmovsd xmm2, [r7 + T_X + 560]
    vmovsd xmm3, [r7 + T_X + 624]
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
    vmovsd xmm3, [r7 + T_X + 568]
    vmovsd xmm2, [r7 + T_X + 632]
    vaddsd xmm1, xmm8, xmm3
    vsubsd xmm0, xmm1, xmm8
    vsubsd xmm7, xmm1, xmm0
    vsubsd xmm7, xmm8, xmm7
    vsubsd xmm0, xmm3, xmm0
    vaddsd xmm7, xmm7, xmm0
    vaddsd xmm0, xmm6, xmm2
    vsubsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm0, xmm5
    vsubsd xmm4, xmm6, xmm4
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm0
    vaddsd xmm0, xmm1, xmm5
    vsubsd xmm7, xmm0, xmm1
    vsubsd xmm7, xmm5, xmm7
    vaddsd xmm5, xmm7, xmm4
    vaddsd xmm4, xmm0, xmm5
    vsubsd xmm7, xmm4, xmm0
    vsubsd xmm7, xmm5, xmm7
    vmovsd [r7 + T_ACC + 8], xmm4
    vmovsd [r7 + T_ACC + 72], xmm7
    vxorpd xmm0, xmm0, xmm0
    vxorpd xmm1, xmm1, xmm1
    vmovsd xmm2, [r7 + T_X + 256]
    vmovsd xmm3, [r7 + T_X + 320]
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
    vmovsd xmm3, [r7 + T_X + 264]
    vmovsd xmm2, [r7 + T_X + 328]
    vaddsd xmm1, xmm8, xmm3
    vsubsd xmm0, xmm1, xmm8
    vsubsd xmm7, xmm1, xmm0
    vsubsd xmm7, xmm8, xmm7
    vsubsd xmm0, xmm3, xmm0
    vaddsd xmm7, xmm7, xmm0
    vaddsd xmm0, xmm6, xmm2
    vsubsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm0, xmm5
    vsubsd xmm4, xmm6, xmm4
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm0
    vaddsd xmm0, xmm1, xmm5
    vsubsd xmm7, xmm0, xmm1
    vsubsd xmm7, xmm5, xmm7
    vaddsd xmm5, xmm7, xmm4
    vaddsd xmm4, xmm0, xmm5
    vsubsd xmm7, xmm4, xmm0
    vsubsd xmm7, xmm5, xmm7
    vmovsd xmm2, [r7 + T_X + 272]
    vmovsd xmm3, [r7 + T_X + 336]
    vaddsd xmm6, xmm4, xmm2
    vsubsd xmm8, xmm6, xmm4
    vsubsd xmm5, xmm6, xmm8
    vsubsd xmm5, xmm4, xmm5
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm5, xmm5, xmm8
    vaddsd xmm8, xmm7, xmm3
    vsubsd xmm0, xmm8, xmm7
    vsubsd xmm1, xmm8, xmm0
    vsubsd xmm1, xmm7, xmm1
    vsubsd xmm0, xmm3, xmm0
    vaddsd xmm1, xmm1, xmm0
    vaddsd xmm0, xmm5, xmm8
    vaddsd xmm8, xmm6, xmm0
    vsubsd xmm5, xmm8, xmm6
    vsubsd xmm5, xmm0, xmm5
    vaddsd xmm0, xmm5, xmm1
    vaddsd xmm1, xmm8, xmm0
    vsubsd xmm5, xmm1, xmm8
    vsubsd xmm5, xmm0, xmm5
    vmovsd xmm3, [r7 + T_X + 280]
    vmovsd xmm2, [r7 + T_X + 344]
    vaddsd xmm7, xmm1, xmm3
    vsubsd xmm4, xmm7, xmm1
    vsubsd xmm0, xmm7, xmm4
    vsubsd xmm0, xmm1, xmm0
    vsubsd xmm4, xmm3, xmm4
    vaddsd xmm0, xmm0, xmm4
    vaddsd xmm4, xmm5, xmm2
    vsubsd xmm8, xmm4, xmm5
    vsubsd xmm6, xmm4, xmm8
    vsubsd xmm6, xmm5, xmm6
    vsubsd xmm8, xmm2, xmm8
    vaddsd xmm6, xmm6, xmm8
    vaddsd xmm8, xmm0, xmm4
    vaddsd xmm4, xmm7, xmm8
    vsubsd xmm0, xmm4, xmm7
    vsubsd xmm0, xmm8, xmm0
    vaddsd xmm8, xmm0, xmm6
    vaddsd xmm6, xmm4, xmm8
    vsubsd xmm0, xmm6, xmm4
    vsubsd xmm0, xmm8, xmm0
    vmovsd xmm2, [r7 + T_X + 288]
    vmovsd xmm3, [r7 + T_X + 352]
    vaddsd xmm5, xmm6, xmm2
    vsubsd xmm1, xmm5, xmm6
    vsubsd xmm8, xmm5, xmm1
    vsubsd xmm8, xmm6, xmm8
    vsubsd xmm1, xmm2, xmm1
    vaddsd xmm8, xmm8, xmm1
    vaddsd xmm1, xmm0, xmm3
    vsubsd xmm4, xmm1, xmm0
    vsubsd xmm7, xmm1, xmm4
    vsubsd xmm7, xmm0, xmm7
    vsubsd xmm4, xmm3, xmm4
    vaddsd xmm7, xmm7, xmm4
    vaddsd xmm4, xmm8, xmm1
    vaddsd xmm1, xmm5, xmm4
    vsubsd xmm8, xmm1, xmm5
    vsubsd xmm8, xmm4, xmm8
    vaddsd xmm4, xmm8, xmm7
    vaddsd xmm7, xmm1, xmm4
    vsubsd xmm8, xmm7, xmm1
    vsubsd xmm8, xmm4, xmm8
    vmovsd xmm3, [r7 + T_X + 296]
    vmovsd xmm2, [r7 + T_X + 360]
    vaddsd xmm0, xmm7, xmm3
    vsubsd xmm6, xmm0, xmm7
    vsubsd xmm4, xmm0, xmm6
    vsubsd xmm4, xmm7, xmm4
    vsubsd xmm6, xmm3, xmm6
    vaddsd xmm4, xmm4, xmm6
    vaddsd xmm6, xmm8, xmm2
    vsubsd xmm1, xmm6, xmm8
    vsubsd xmm5, xmm6, xmm1
    vsubsd xmm5, xmm8, xmm5
    vsubsd xmm1, xmm2, xmm1
    vaddsd xmm5, xmm5, xmm1
    vaddsd xmm1, xmm4, xmm6
    vaddsd xmm6, xmm0, xmm1
    vsubsd xmm4, xmm6, xmm0
    vsubsd xmm4, xmm1, xmm4
    vaddsd xmm1, xmm4, xmm5
    vaddsd xmm5, xmm6, xmm1
    vsubsd xmm4, xmm5, xmm6
    vsubsd xmm4, xmm1, xmm4
    vmovsd xmm2, [r7 + T_X + 304]
    vmovsd xmm3, [r7 + T_X + 368]
    vaddsd xmm8, xmm5, xmm2
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm1, xmm8, xmm7
    vsubsd xmm1, xmm5, xmm1
    vsubsd xmm7, xmm2, xmm7
    vaddsd xmm1, xmm1, xmm7
    vaddsd xmm7, xmm4, xmm3
    vsubsd xmm6, xmm7, xmm4
    vsubsd xmm0, xmm7, xmm6
    vsubsd xmm0, xmm4, xmm0
    vsubsd xmm6, xmm3, xmm6
    vaddsd xmm0, xmm0, xmm6
    vaddsd xmm6, xmm1, xmm7
    vaddsd xmm7, xmm8, xmm6
    vsubsd xmm1, xmm7, xmm8
    vsubsd xmm1, xmm6, xmm1
    vaddsd xmm6, xmm1, xmm0
    vaddsd xmm0, xmm7, xmm6
    vsubsd xmm1, xmm0, xmm7
    vsubsd xmm1, xmm6, xmm1
    vmovsd xmm3, [r7 + T_X + 312]
    vmovsd xmm2, [r7 + T_X + 376]
    vaddsd xmm4, xmm0, xmm3
    vsubsd xmm5, xmm4, xmm0
    vsubsd xmm6, xmm4, xmm5
    vsubsd xmm6, xmm0, xmm6
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm6, xmm6, xmm5
    vaddsd xmm5, xmm1, xmm2
    vsubsd xmm7, xmm5, xmm1
    vsubsd xmm8, xmm5, xmm7
    vsubsd xmm8, xmm1, xmm8
    vsubsd xmm7, xmm2, xmm7
    vaddsd xmm8, xmm8, xmm7
    vaddsd xmm7, xmm6, xmm5
    vaddsd xmm5, xmm4, xmm7
    vsubsd xmm6, xmm5, xmm4
    vsubsd xmm6, xmm7, xmm6
    vaddsd xmm7, xmm6, xmm8
    vaddsd xmm8, xmm5, xmm7
    vsubsd xmm6, xmm8, xmm5
    vsubsd xmm6, xmm7, xmm6
    vmovsd xmm2, [r7 + T_X + 640]
    vmovsd xmm3, [r7 + T_X + 704]
    vaddsd xmm1, xmm8, xmm2
    vsubsd xmm0, xmm1, xmm8
    vsubsd xmm7, xmm1, xmm0
    vsubsd xmm7, xmm8, xmm7
    vsubsd xmm0, xmm2, xmm0
    vaddsd xmm7, xmm7, xmm0
    vaddsd xmm0, xmm6, xmm3
    vsubsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm0, xmm5
    vsubsd xmm4, xmm6, xmm4
    vsubsd xmm5, xmm3, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm0
    vaddsd xmm0, xmm1, xmm5
    vsubsd xmm7, xmm0, xmm1
    vsubsd xmm7, xmm5, xmm7
    vaddsd xmm5, xmm7, xmm4
    vaddsd xmm4, xmm0, xmm5
    vsubsd xmm7, xmm4, xmm0
    vsubsd xmm7, xmm5, xmm7
    vmovsd xmm3, [r7 + T_X + 648]
    vmovsd xmm2, [r7 + T_X + 712]
    vaddsd xmm6, xmm4, xmm3
    vsubsd xmm8, xmm6, xmm4
    vsubsd xmm5, xmm6, xmm8
    vsubsd xmm5, xmm4, xmm5
    vsubsd xmm8, xmm3, xmm8
    vaddsd xmm5, xmm5, xmm8
    vaddsd xmm8, xmm7, xmm2
    vsubsd xmm0, xmm8, xmm7
    vsubsd xmm1, xmm8, xmm0
    vsubsd xmm1, xmm7, xmm1
    vsubsd xmm0, xmm2, xmm0
    vaddsd xmm1, xmm1, xmm0
    vaddsd xmm0, xmm5, xmm8
    vaddsd xmm8, xmm6, xmm0
    vsubsd xmm5, xmm8, xmm6
    vsubsd xmm5, xmm0, xmm5
    vaddsd xmm0, xmm5, xmm1
    vaddsd xmm1, xmm8, xmm0
    vsubsd xmm5, xmm1, xmm8
    vsubsd xmm5, xmm0, xmm5
    vmovsd xmm2, [r7 + T_X + 656]
    vmovsd xmm3, [r7 + T_X + 720]
    vaddsd xmm7, xmm1, xmm2
    vsubsd xmm4, xmm7, xmm1
    vsubsd xmm0, xmm7, xmm4
    vsubsd xmm0, xmm1, xmm0
    vsubsd xmm4, xmm2, xmm4
    vaddsd xmm0, xmm0, xmm4
    vaddsd xmm4, xmm5, xmm3
    vsubsd xmm8, xmm4, xmm5
    vsubsd xmm6, xmm4, xmm8
    vsubsd xmm6, xmm5, xmm6
    vsubsd xmm8, xmm3, xmm8
    vaddsd xmm6, xmm6, xmm8
    vaddsd xmm8, xmm0, xmm4
    vaddsd xmm4, xmm7, xmm8
    vsubsd xmm0, xmm4, xmm7
    vsubsd xmm0, xmm8, xmm0
    vaddsd xmm8, xmm0, xmm6
    vaddsd xmm6, xmm4, xmm8
    vsubsd xmm0, xmm6, xmm4
    vsubsd xmm0, xmm8, xmm0
    vmovsd xmm3, [r7 + T_X + 664]
    vmovsd xmm2, [r7 + T_X + 728]
    vaddsd xmm5, xmm6, xmm3
    vsubsd xmm1, xmm5, xmm6
    vsubsd xmm8, xmm5, xmm1
    vsubsd xmm8, xmm6, xmm8
    vsubsd xmm1, xmm3, xmm1
    vaddsd xmm8, xmm8, xmm1
    vaddsd xmm1, xmm0, xmm2
    vsubsd xmm4, xmm1, xmm0
    vsubsd xmm7, xmm1, xmm4
    vsubsd xmm7, xmm0, xmm7
    vsubsd xmm4, xmm2, xmm4
    vaddsd xmm7, xmm7, xmm4
    vaddsd xmm4, xmm8, xmm1
    vaddsd xmm1, xmm5, xmm4
    vsubsd xmm8, xmm1, xmm5
    vsubsd xmm8, xmm4, xmm8
    vaddsd xmm4, xmm8, xmm7
    vaddsd xmm7, xmm1, xmm4
    vsubsd xmm8, xmm7, xmm1
    vsubsd xmm8, xmm4, xmm8
    vmovsd xmm2, [r7 + T_X + 672]
    vmovsd xmm3, [r7 + T_X + 736]
    vaddsd xmm0, xmm7, xmm2
    vsubsd xmm6, xmm0, xmm7
    vsubsd xmm4, xmm0, xmm6
    vsubsd xmm4, xmm7, xmm4
    vsubsd xmm6, xmm2, xmm6
    vaddsd xmm4, xmm4, xmm6
    vaddsd xmm6, xmm8, xmm3
    vsubsd xmm1, xmm6, xmm8
    vsubsd xmm5, xmm6, xmm1
    vsubsd xmm5, xmm8, xmm5
    vsubsd xmm1, xmm3, xmm1
    vaddsd xmm5, xmm5, xmm1
    vaddsd xmm1, xmm4, xmm6
    vaddsd xmm6, xmm0, xmm1
    vsubsd xmm4, xmm6, xmm0
    vsubsd xmm4, xmm1, xmm4
    vaddsd xmm1, xmm4, xmm5
    vaddsd xmm5, xmm6, xmm1
    vsubsd xmm4, xmm5, xmm6
    vsubsd xmm4, xmm1, xmm4
    vmovsd xmm3, [r7 + T_X + 680]
    vmovsd xmm2, [r7 + T_X + 744]
    vaddsd xmm8, xmm5, xmm3
    vsubsd xmm7, xmm8, xmm5
    vsubsd xmm1, xmm8, xmm7
    vsubsd xmm1, xmm5, xmm1
    vsubsd xmm7, xmm3, xmm7
    vaddsd xmm1, xmm1, xmm7
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm6, xmm7, xmm4
    vsubsd xmm0, xmm7, xmm6
    vsubsd xmm0, xmm4, xmm0
    vsubsd xmm6, xmm2, xmm6
    vaddsd xmm0, xmm0, xmm6
    vaddsd xmm6, xmm1, xmm7
    vaddsd xmm7, xmm8, xmm6
    vsubsd xmm1, xmm7, xmm8
    vsubsd xmm1, xmm6, xmm1
    vaddsd xmm6, xmm1, xmm0
    vaddsd xmm0, xmm7, xmm6
    vsubsd xmm1, xmm0, xmm7
    vsubsd xmm1, xmm6, xmm1
    vmovsd xmm2, [r7 + T_X + 688]
    vmovsd xmm3, [r7 + T_X + 752]
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
    vmovsd xmm3, [r7 + T_X + 696]
    vmovsd xmm2, [r7 + T_X + 760]
    vaddsd xmm1, xmm8, xmm3
    vsubsd xmm0, xmm1, xmm8
    vsubsd xmm7, xmm1, xmm0
    vsubsd xmm7, xmm8, xmm7
    vsubsd xmm0, xmm3, xmm0
    vaddsd xmm7, xmm7, xmm0
    vaddsd xmm0, xmm6, xmm2
    vsubsd xmm5, xmm0, xmm6
    vsubsd xmm4, xmm0, xmm5
    vsubsd xmm4, xmm6, xmm4
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm4, xmm4, xmm5
    vaddsd xmm5, xmm7, xmm0
    vaddsd xmm0, xmm1, xmm5
    vsubsd xmm7, xmm0, xmm1
    vsubsd xmm7, xmm5, xmm7
    vaddsd xmm5, xmm7, xmm4
    vaddsd xmm4, xmm0, xmm5
    vsubsd xmm7, xmm4, xmm0
    vsubsd xmm7, xmm5, xmm7
    vmovsd [r7 + T_ACC + 16], xmm4
    vmovsd [r7 + T_ACC + 80], xmm7
    vpxorq zmm0, zmm0, zmm0
    vmovapd zmm1, [r7 + T_ACC]
    vmovapd zmm2, [r7 + T_ACC + 64]
    vbroadcastsd zmm3, [t_six]
    vmulpd zmm4, zmm1, zmm3
    vmovapd zmm5, zmm4
    vfmsub231pd zmm5, zmm1, zmm3
    vmulpd zmm6, zmm2, zmm3
    vfmadd231pd zmm6, zmm1, zmm0
    vaddpd zmm5, zmm5, zmm6
    vaddpd zmm6, zmm4, zmm5
    vsubpd zmm7, zmm6, zmm4
    vsubpd zmm7, zmm5, zmm7
    vmovapd zmm16, zmm6
    vmovapd zmm17, zmm7
    call .xoe
    vmovapd [r7 + T_E], zmm16
    vmovapd [r7 + T_E + 64], zmm17
    vmovsd xmm0, [r7 + T_E]
    vmovsd xmm1, [r7 + T_E + 64]
    vmovsd xmm2, [r7 + T_E + 8]
    vmovsd xmm3, [r7 + T_E + 72]
    vmovsd xmm4, [r7 + T_E + 16]
    vmovsd xmm5, [r7 + T_E + 80]
    vmovsd xmm6, [t_kr]
    vmovsd xmm7, [t_kr + 8]
    vmulsd xmm8, xmm6, xmm0
    vmovapd xmm9, xmm8
    vfmsub231sd xmm9, xmm6, xmm0
    vmulsd xmm10, xmm7, xmm0
    vfmadd231sd xmm10, xmm6, xmm1
    vaddsd xmm9, xmm9, xmm10
    vaddsd xmm10, xmm8, xmm9
    vsubsd xmm11, xmm10, xmm8
    vsubsd xmm11, xmm9, xmm11
    vmovsd xmm7, [t_kg]
    vmovsd xmm6, [t_kg + 8]
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
    vmovsd xmm13, [t_kb]
    vmovsd xmm12, [t_kb + 8]
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
    vxorpd xmm3, xmm6, [t_sgn2]
    vxorpd xmm2, xmm10, [t_sgn2]
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
    vmovsd xmm9, [t_cbs]
    vmovsd xmm6, [t_cbs + 8]
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
    vmovsd xmm8, [t_512]
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
    vmovsd xmm2, [t_crs]
    vmovsd xmm3, [t_crs + 8]
    vmulsd xmm10, xmm2, xmm9
    vmovapd xmm13, xmm10
    vfmsub231sd xmm13, xmm2, xmm9
    vmulsd xmm8, xmm3, xmm9
    vfmadd231sd xmm8, xmm2, xmm11
    vaddsd xmm13, xmm13, xmm8
    vaddsd xmm8, xmm10, xmm13
    vsubsd xmm6, xmm8, xmm10
    vsubsd xmm6, xmm13, xmm6
    vmovsd xmm11, [t_512]
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
    vmovsd [r7 + T_E + 128], xmm10
    vmovsd [r7 + T_E + 136], xmm2
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
    vsubsd xmm3, xmm15, xmm13
    vsubsd xmm3, xmm9, xmm3
    vcmpsd xmm6, xmm15, [t_half], 0x1e
    vandpd xmm6, xmm6, [t_one2]
    vcmpsd xmm11, xmm15, [t_mhalf], 0x11
    vandpd xmm11, xmm11, [t_one2]
    vaddsd xmm7, xmm7, xmm6
    vsubsd xmm7, xmm7, xmm11
    vcvttsd2si r6d, xmm7
    xor r3d, r3d
    test r6d, r6d
    cmovs r6d, r3d
    mov r3d, 1023
    cmp r6d, r3d
    cmovg r6d, r3d
    mov [r7 + T_L + 4], r6d
    vmovsd xmm0, [r7 + T_E + 128]
    vmovsd xmm1, [r7 + T_E + 136]
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
    vsubsd xmm7, xmm9, xmm6
    vsubsd xmm7, xmm8, xmm7
    vcmpsd xmm4, xmm9, [t_half], 0x1e
    vandpd xmm4, xmm4, [t_one2]
    vcmpsd xmm3, xmm9, [t_mhalf], 0x11
    vandpd xmm3, xmm3, [t_one2]
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
    or r6d, [r7 + T_L + 4]
    vmovapd zmm16, [r7 + T_Z2]
    vmovapd zmm17, [r7 + T_Z2 + 64]
    vmovapd zmm18, [r7 + T_Z2 + 128]
    vmovapd zmm19, [r7 + T_Z2 + 192]
    vmovapd zmm20, [r7 + T_Z2 + 256]
    vmovapd zmm21, [r7 + T_Z2 + 320]
    vmovapd zmm22, [r7 + T_Z2 + 384]
    vmovapd zmm23, [r7 + T_Z2 + 448]
    vmovapd zmm24, [r7 + T_Z2 + 512]
    vmovapd zmm25, [r7 + T_Z2 + 576]
    vmovapd zmm26, [r7 + T_Z2 + 640]
    vmovapd zmm27, [r7 + T_Z2 + 704]
    vmovapd zmm28, [r7 + T_Z2 + 768]
    vmovapd zmm29, [r7 + T_Z2 + 832]
    vmovapd zmm30, [r7 + T_Z2 + 896]
    vmovapd zmm31, [r7 + T_Z2 + 960]
    ret
.g2l:
    mov [r7 + T_XL], r6d
    mov r4, [r10 + 16 + S_SRC]
    mov r3d, [r7 + T_J]
    imul r3, r3, 4*W
    add r3, r4
    mov r2d, r6d
    movzx r1d, word [r3 + r2*4]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + T_SY], xmm0
    movzx r1d, word [r3 + r2*4 + 2]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + T_SY + 8], xmm0
    movzx r1d, word [r3 + r2*4 + 2*W]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + T_SY + 16], xmm0
    movzx r1d, word [r3 + r2*4 + 2*W + 2]
    vcvtsi2sd xmm0, xmm0, r1d
    vmovsd [r7 + T_SY + 24], xmm0
    mov r3d, [r7 + T_J]
    lea r3d, [r3*2]
    mov r2d, [r7 + T_XL]
    dec r2d
    call .cvr
    vmovaps [r7 + T_VB], ymm0
    vmovaps [r7 + T_VB + 32], ymm1
    vmovss xmm2, [r7 + T_VB + 4]
    vmovss xmm3, [r7 + T_VB + 36]
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 32]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + T_SB], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + T_SR], xmm3
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + T_SB + 8], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + T_SR + 8], xmm5
    mov r3d, [r7 + T_J]
    lea r3d, [r3*2 + 1]
    mov r2d, [r7 + T_XL]
    dec r2d
    call .cvr
    vmovaps [r7 + T_VB], ymm0
    vmovaps [r7 + T_VB + 32], ymm1
    vmovss xmm2, [r7 + T_VB + 4]
    vmovss xmm3, [r7 + T_VB + 36]
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 32]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + T_SB + 16], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + T_SR + 16], xmm3
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + T_SB + 24], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + T_SR + 24], xmm5
    ret
.g2c:
    mov [r7 + T_XL], r6d
    mov r4, [r10 + 16 + S_SRC]
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4]
    imul r3, r3, 2*W
    add r3, r4
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*4 - 1]
    xor r6d, r6d
    mov r1d, r2d
    test r1d, r1d
    cmovs r1d, r6d
    vpbroadcastd ymm7, r2d
    vpaddd ymm7, ymm7, [t_iota]
    vpxor ymm6, ymm6, ymm6
    vpmaxsd ymm7, ymm7, ymm6
    vpbroadcastd ymm6, r1d
    vpsubd ymm7, ymm7, ymm6
    vpmovzxwd ymm2, [r3 + r1*2]
    vpermd ymm2, ymm7, ymm2
    vcvtdq2pd ymm2, xmm2
    vmovapd [r7 + T_SY], ymm2
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4]
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*2 - 2]
    call .cvr
    vmovaps [r7 + T_VB], ymm0
    vmovaps [r7 + T_VB + 32], ymm1
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 32]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    xor r3d, r3d
    cmp dword [r7 + T_XL], 0
    sete r3b
    kmovb k1, r3d
    vmovss xmm4{k1}, [r7 + T_VB + 8]
    vmovss xmm5{k1}, [r7 + T_VB + 40]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + T_SB], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + T_SR], xmm5
    vmovss xmm2, [r7 + T_VB + 8]
    vmovss xmm3, [r7 + T_VB + 40]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + T_SB + 8], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + T_SR + 8], xmm3
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 16]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 48]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + T_SB + 16], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + T_SR + 16], xmm5
    vmovss xmm2, [r7 + T_VB + 12]
    vmovss xmm3, [r7 + T_VB + 44]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + T_SB + 24], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + T_SR + 24], xmm3
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4 + 1]
    imul r3, r3, 2*W
    add r3, r4
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*4 - 1]
    xor r6d, r6d
    mov r1d, r2d
    test r1d, r1d
    cmovs r1d, r6d
    vpbroadcastd ymm7, r2d
    vpaddd ymm7, ymm7, [t_iota]
    vpxor ymm6, ymm6, ymm6
    vpmaxsd ymm7, ymm7, ymm6
    vpbroadcastd ymm6, r1d
    vpsubd ymm7, ymm7, ymm6
    vpmovzxwd ymm2, [r3 + r1*2]
    vpermd ymm2, ymm7, ymm2
    vcvtdq2pd ymm2, xmm2
    vmovapd [r7 + T_SY + 32], ymm2
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4 + 1]
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*2 - 2]
    call .cvr
    vmovaps [r7 + T_VB], ymm0
    vmovaps [r7 + T_VB + 32], ymm1
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 32]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    xor r3d, r3d
    cmp dword [r7 + T_XL], 0
    sete r3b
    kmovb k1, r3d
    vmovss xmm4{k1}, [r7 + T_VB + 8]
    vmovss xmm5{k1}, [r7 + T_VB + 40]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + T_SB + 32], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + T_SR + 32], xmm5
    vmovss xmm2, [r7 + T_VB + 8]
    vmovss xmm3, [r7 + T_VB + 40]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + T_SB + 40], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + T_SR + 40], xmm3
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 16]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 48]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + T_SB + 48], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + T_SR + 48], xmm5
    vmovss xmm2, [r7 + T_VB + 12]
    vmovss xmm3, [r7 + T_VB + 44]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + T_SB + 56], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + T_SR + 56], xmm3
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4 + 2]
    imul r3, r3, 2*W
    add r3, r4
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*4 - 1]
    xor r6d, r6d
    mov r1d, r2d
    test r1d, r1d
    cmovs r1d, r6d
    vpbroadcastd ymm7, r2d
    vpaddd ymm7, ymm7, [t_iota]
    vpxor ymm6, ymm6, ymm6
    vpmaxsd ymm7, ymm7, ymm6
    vpbroadcastd ymm6, r1d
    vpsubd ymm7, ymm7, ymm6
    vpmovzxwd ymm2, [r3 + r1*2]
    vpermd ymm2, ymm7, ymm2
    vcvtdq2pd ymm2, xmm2
    vmovapd [r7 + T_SY + 64], ymm2
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4 + 2]
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*2 - 2]
    call .cvr
    vmovaps [r7 + T_VB], ymm0
    vmovaps [r7 + T_VB + 32], ymm1
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 32]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    xor r3d, r3d
    cmp dword [r7 + T_XL], 0
    sete r3b
    kmovb k1, r3d
    vmovss xmm4{k1}, [r7 + T_VB + 8]
    vmovss xmm5{k1}, [r7 + T_VB + 40]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + T_SB + 64], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + T_SR + 64], xmm5
    vmovss xmm2, [r7 + T_VB + 8]
    vmovss xmm3, [r7 + T_VB + 40]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + T_SB + 72], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + T_SR + 72], xmm3
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 16]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 48]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + T_SB + 80], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + T_SR + 80], xmm5
    vmovss xmm2, [r7 + T_VB + 12]
    vmovss xmm3, [r7 + T_VB + 44]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + T_SB + 88], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + T_SR + 88], xmm3
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4 + 3]
    imul r3, r3, 2*W
    add r3, r4
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*4 - 1]
    xor r6d, r6d
    mov r1d, r2d
    test r1d, r1d
    cmovs r1d, r6d
    vpbroadcastd ymm7, r2d
    vpaddd ymm7, ymm7, [t_iota]
    vpxor ymm6, ymm6, ymm6
    vpmaxsd ymm7, ymm7, ymm6
    vpbroadcastd ymm6, r1d
    vpsubd ymm7, ymm7, ymm6
    vpmovzxwd ymm2, [r3 + r1*2]
    vpermd ymm2, ymm7, ymm2
    vcvtdq2pd ymm2, xmm2
    vmovapd [r7 + T_SY + 96], ymm2
    mov r3d, [r7 + T_J]
    lea r3d, [r3*4 + 3]
    mov r2d, [r7 + T_XL]
    lea r2d, [r2*2 - 2]
    call .cvr
    vmovaps [r7 + T_VB], ymm0
    vmovaps [r7 + T_VB + 32], ymm1
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 32]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    xor r3d, r3d
    cmp dword [r7 + T_XL], 0
    sete r3b
    kmovb k1, r3d
    vmovss xmm4{k1}, [r7 + T_VB + 8]
    vmovss xmm5{k1}, [r7 + T_VB + 40]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + T_SB + 96], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + T_SR + 96], xmm5
    vmovss xmm2, [r7 + T_VB + 8]
    vmovss xmm3, [r7 + T_VB + 40]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + T_SB + 104], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + T_SR + 104], xmm3
    vxorps xmm4, xmm4, xmm4
    vxorps xmm5, xmm5, xmm5
    vmovss xmm6, [t_k50]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 4]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 36]
    vmovss xmm6, [t_k50 + 4]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 8]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 40]
    vmovss xmm6, [t_k50 + 8]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 12]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 44]
    vmovss xmm6, [t_k50 + 12]
    vfmadd231ss xmm4, xmm6, [r7 + T_VB + 16]
    vfmadd231ss xmm5, xmm6, [r7 + T_VB + 48]
    vcvtss2sd xmm4, xmm4, xmm4
    vsubsd xmm4, xmm4, [t_512]
    vmovsd [r7 + T_SB + 112], xmm4
    vcvtss2sd xmm5, xmm5, xmm5
    vsubsd xmm5, xmm5, [t_512]
    vmovsd [r7 + T_SR + 112], xmm5
    vmovss xmm2, [r7 + T_VB + 12]
    vmovss xmm3, [r7 + T_VB + 44]
    vcvtss2sd xmm2, xmm2, xmm2
    vsubsd xmm2, xmm2, [t_512]
    vmovsd [r7 + T_SB + 120], xmm2
    vcvtss2sd xmm3, xmm3, xmm3
    vsubsd xmm3, xmm3, [t_512]
    vmovsd [r7 + T_SR + 120], xmm3
    ret
.cvr:
    lea r1, [t_k75]
    lea r0, [t_k25]
    test r3b, 1
    cmovnz r1, r0
    lea r0d, [r3 + 1]
    shr r0d, 1
    xor r6d, r6d
    mov r3d, r2d
    test r3d, r3d
    cmovs r3d, r6d
    vpbroadcastd ymm7, r2d
    vpaddd ymm7, ymm7, [t_iota]
    vpxor ymm6, ymm6, ymm6
    vpmaxsd ymm7, ymm7, ymm6
    vpbroadcastd ymm6, r3d
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
    vpmovq2m k6, zmm16
    vpbroadcastq zmm20, [t_sign]
    vpxorq zmm16{k6}, zmm16, zmm20
    vpxorq zmm17{k6}, zmm17, zmm20
    vpxorq zmm21, zmm21, zmm21
    vcmppd k7, zmm16, zmm21, 0x12
    vbroadcastsd zmm16{k7}, [t_one]
    vmovapd zmm17{k7}, zmm21
    call .dln
    vbroadcastsd zmm0, [t_e125]
    vbroadcastsd zmm1, [t_e125 + 8]
    vmulpd zmm2, zmm0, zmm16
    vmovapd zmm3, zmm2
    vfmsub231pd zmm3, zmm0, zmm16
    vmulpd zmm4, zmm1, zmm16
    vfmadd231pd zmm4, zmm0, zmm17
    vaddpd zmm3, zmm3, zmm4
    vaddpd zmm4, zmm2, zmm3
    vsubpd zmm5, zmm4, zmm2
    vsubpd zmm5, zmm3, zmm5
    vmovapd zmm16, zmm4
    vmovapd zmm17, zmm5
    call .dexp
    vpxorq zmm21, zmm21, zmm21
    vmovapd zmm16{k7}, zmm21
    vmovapd zmm17{k7}, zmm21
    vpbroadcastq zmm20, [t_sign]
    vpxorq zmm16{k6}, zmm16, zmm20
    vpxorq zmm17{k6}, zmm17, zmm20
    ret
.xoe:
    vpmovq2m k6, zmm16
    vpbroadcastq zmm20, [t_sign]
    vpxorq zmm16{k6}, zmm16, zmm20
    vpxorq zmm17{k6}, zmm17, zmm20
    vpxorq zmm21, zmm21, zmm21
    vcmppd k7, zmm16, zmm21, 0x12
    vbroadcastsd zmm16{k7}, [t_one]
    vmovapd zmm17{k7}, zmm21
    call .dln
    vbroadcastsd zmm0, [t_e512]
    vbroadcastsd zmm1, [t_e512 + 8]
    vmulpd zmm2, zmm0, zmm16
    vmovapd zmm3, zmm2
    vfmsub231pd zmm3, zmm0, zmm16
    vmulpd zmm4, zmm1, zmm16
    vfmadd231pd zmm4, zmm0, zmm17
    vaddpd zmm3, zmm3, zmm4
    vaddpd zmm4, zmm2, zmm3
    vsubpd zmm5, zmm4, zmm2
    vsubpd zmm5, zmm3, zmm5
    vmovapd zmm16, zmm4
    vmovapd zmm17, zmm5
    call .dexp
    vpxorq zmm21, zmm21, zmm21
    vmovapd zmm16{k7}, zmm21
    vmovapd zmm17{k7}, zmm21
    vpbroadcastq zmm20, [t_sign]
    vpxorq zmm16{k6}, zmm16, zmm20
    vpxorq zmm17{k6}, zmm17, zmm20
    ret
.dln:
    vmovapd [r7 + T_LN], zmm16
    vmovapd [r7 + T_LN + 64], zmm16
    vmovapd [r7 + T_LN + 128], zmm17
    fldln2
    fld qword [r7 + T_LN]
    fyl2x
    fstp qword [r7 + T_LN]
    fldln2
    fld qword [r7 + T_LN + 8]
    fyl2x
    fstp qword [r7 + T_LN + 8]
    fldln2
    fld qword [r7 + T_LN + 16]
    fyl2x
    fstp qword [r7 + T_LN + 16]
    fldln2
    fld qword [r7 + T_LN + 24]
    fyl2x
    fstp qword [r7 + T_LN + 24]
    fldln2
    fld qword [r7 + T_LN + 32]
    fyl2x
    fstp qword [r7 + T_LN + 32]
    fldln2
    fld qword [r7 + T_LN + 40]
    fyl2x
    fstp qword [r7 + T_LN + 40]
    fldln2
    fld qword [r7 + T_LN + 48]
    fyl2x
    fstp qword [r7 + T_LN + 48]
    fldln2
    fld qword [r7 + T_LN + 56]
    fyl2x
    fstp qword [r7 + T_LN + 56]
    vmovapd zmm16, [r7 + T_LN]
    vpxorq zmm16, zmm16, [t_sign]{1to8}
    vpxorq zmm17, zmm17, zmm17
    call .dexp
    vpxorq zmm0, zmm0, zmm0
    vmovapd zmm1, [r7 + T_LN + 64]
    vmovapd zmm2, [r7 + T_LN + 128]
    vmulpd zmm3, zmm1, zmm16
    vmovapd zmm4, zmm3
    vfmsub231pd zmm4, zmm1, zmm16
    vmulpd zmm5, zmm2, zmm16
    vfmadd231pd zmm5, zmm1, zmm17
    vaddpd zmm4, zmm4, zmm5
    vaddpd zmm5, zmm3, zmm4
    vsubpd zmm6, zmm5, zmm3
    vsubpd zmm6, zmm4, zmm6
    vbroadcastsd zmm2, [t_mone]
    vbroadcastsd zmm1, [t_mzero]
    vaddpd zmm4, zmm5, zmm2
    vsubpd zmm3, zmm4, zmm5
    vsubpd zmm7, zmm4, zmm3
    vsubpd zmm7, zmm5, zmm7
    vsubpd zmm3, zmm2, zmm3
    vaddpd zmm7, zmm7, zmm3
    vaddpd zmm3, zmm6, zmm1
    vsubpd zmm8, zmm3, zmm6
    vsubpd zmm9, zmm3, zmm8
    vsubpd zmm9, zmm6, zmm9
    vsubpd zmm8, zmm1, zmm8
    vaddpd zmm9, zmm9, zmm8
    vaddpd zmm8, zmm7, zmm3
    vaddpd zmm3, zmm4, zmm8
    vsubpd zmm7, zmm3, zmm4
    vsubpd zmm7, zmm8, zmm7
    vaddpd zmm8, zmm7, zmm9
    vaddpd zmm9, zmm3, zmm8
    vsubpd zmm7, zmm9, zmm3
    vsubpd zmm7, zmm8, zmm7
    vmovapd zmm6, [r7 + T_LN]
    vaddpd zmm5, zmm6, zmm9
    vsubpd zmm1, zmm5, zmm6
    vsubpd zmm2, zmm5, zmm1
    vsubpd zmm2, zmm6, zmm2
    vsubpd zmm1, zmm9, zmm1
    vaddpd zmm2, zmm2, zmm1
    vaddpd zmm1, zmm0, zmm7
    vsubpd zmm8, zmm1, zmm0
    vsubpd zmm3, zmm1, zmm8
    vsubpd zmm3, zmm0, zmm3
    vsubpd zmm8, zmm7, zmm8
    vaddpd zmm3, zmm3, zmm8
    vaddpd zmm8, zmm2, zmm1
    vaddpd zmm1, zmm5, zmm8
    vsubpd zmm2, zmm1, zmm5
    vsubpd zmm2, zmm8, zmm2
    vaddpd zmm8, zmm2, zmm3
    vaddpd zmm3, zmm1, zmm8
    vsubpd zmm2, zmm3, zmm1
    vsubpd zmm2, zmm8, zmm2
    vmovapd zmm16, zmm3
    vmovapd zmm17, zmm2
    ret
.dexp:
    vpxorq zmm0, zmm0, zmm0
    vbroadcastsd zmm1, [t_ln2]
    vdivpd zmm2, zmm16, zmm1
    vrndscalepd zmm1, zmm2, 0
    vbroadcastsd zmm2, [t_ln2d]
    vbroadcastsd zmm3, [t_ln2d + 8]
    vmulpd zmm4, zmm2, zmm1
    vmovapd zmm5, zmm4
    vfmsub231pd zmm5, zmm2, zmm1
    vmulpd zmm6, zmm3, zmm1
    vfmadd231pd zmm6, zmm2, zmm0
    vaddpd zmm5, zmm5, zmm6
    vaddpd zmm6, zmm4, zmm5
    vsubpd zmm7, zmm6, zmm4
    vsubpd zmm7, zmm5, zmm7
    vpxorq zmm3, zmm6, [t_sign]{1to8}
    vpxorq zmm2, zmm7, [t_sign]{1to8}
    vaddpd zmm7, zmm16, zmm3
    vsubpd zmm6, zmm7, zmm16
    vsubpd zmm5, zmm7, zmm6
    vsubpd zmm5, zmm16, zmm5
    vsubpd zmm6, zmm3, zmm6
    vaddpd zmm5, zmm5, zmm6
    vaddpd zmm6, zmm17, zmm2
    vsubpd zmm4, zmm6, zmm17
    vsubpd zmm8, zmm6, zmm4
    vsubpd zmm8, zmm17, zmm8
    vsubpd zmm4, zmm2, zmm4
    vaddpd zmm8, zmm8, zmm4
    vaddpd zmm4, zmm5, zmm6
    vaddpd zmm6, zmm7, zmm4
    vsubpd zmm5, zmm6, zmm7
    vsubpd zmm5, zmm4, zmm5
    vaddpd zmm4, zmm5, zmm8
    vaddpd zmm8, zmm6, zmm4
    vsubpd zmm5, zmm8, zmm6
    vsubpd zmm5, zmm4, zmm5
    vbroadcastsd zmm2, [t_i1024]
    vmulpd zmm3, zmm8, zmm2
    vmovapd zmm4, zmm3
    vfmsub231pd zmm4, zmm8, zmm2
    vmulpd zmm6, zmm5, zmm2
    vfmadd231pd zmm6, zmm8, zmm0
    vaddpd zmm4, zmm4, zmm6
    vaddpd zmm6, zmm3, zmm4
    vsubpd zmm7, zmm6, zmm3
    vsubpd zmm7, zmm4, zmm7
    vbroadcastsd zmm5, [t_one]
    vmovapd zmm8, zmm0
    vbroadcastsd zmm2, [t_one]
    vmovapd zmm4, zmm0
    vmulpd zmm3, zmm2, zmm6
    vmovapd zmm9, zmm3
    vfmsub231pd zmm9, zmm2, zmm6
    vmulpd zmm10, zmm4, zmm6
    vfmadd231pd zmm10, zmm2, zmm7
    vaddpd zmm9, zmm9, zmm10
    vaddpd zmm10, zmm3, zmm9
    vsubpd zmm11, zmm10, zmm3
    vsubpd zmm11, zmm9, zmm11
    vbroadcastsd zmm4, [t_c1]
    vdivpd zmm2, zmm10, zmm4
    vpxorq zmm9, zmm2, [t_sign]{1to8}
    vmulpd zmm3, zmm4, zmm9
    vmovapd zmm12, zmm3
    vfmsub231pd zmm12, zmm4, zmm9
    vmulpd zmm13, zmm0, zmm9
    vfmadd231pd zmm13, zmm4, zmm0
    vaddpd zmm12, zmm12, zmm13
    vaddpd zmm13, zmm3, zmm12
    vsubpd zmm14, zmm13, zmm3
    vsubpd zmm14, zmm12, zmm14
    vaddpd zmm9, zmm10, zmm13
    vsubpd zmm12, zmm9, zmm10
    vsubpd zmm3, zmm9, zmm12
    vsubpd zmm3, zmm10, zmm3
    vsubpd zmm12, zmm13, zmm12
    vaddpd zmm3, zmm3, zmm12
    vaddpd zmm12, zmm11, zmm14
    vsubpd zmm15, zmm12, zmm11
    vsubpd zmm18, zmm12, zmm15
    vsubpd zmm18, zmm11, zmm18
    vsubpd zmm15, zmm14, zmm15
    vaddpd zmm18, zmm18, zmm15
    vaddpd zmm15, zmm3, zmm12
    vaddpd zmm12, zmm9, zmm15
    vsubpd zmm3, zmm12, zmm9
    vsubpd zmm3, zmm15, zmm3
    vaddpd zmm15, zmm3, zmm18
    vaddpd zmm18, zmm12, zmm15
    vsubpd zmm3, zmm18, zmm12
    vsubpd zmm3, zmm15, zmm3
    vdivpd zmm14, zmm18, zmm4
    vpxorq zmm13, zmm14, [t_sign]{1to8}
    vmulpd zmm15, zmm4, zmm13
    vmovapd zmm12, zmm15
    vfmsub231pd zmm12, zmm4, zmm13
    vmulpd zmm9, zmm0, zmm13
    vfmadd231pd zmm9, zmm4, zmm0
    vaddpd zmm12, zmm12, zmm9
    vaddpd zmm9, zmm15, zmm12
    vsubpd zmm19, zmm9, zmm15
    vsubpd zmm19, zmm12, zmm19
    vaddpd zmm13, zmm18, zmm9
    vsubpd zmm12, zmm13, zmm18
    vsubpd zmm15, zmm13, zmm12
    vsubpd zmm15, zmm18, zmm15
    vsubpd zmm12, zmm9, zmm12
    vaddpd zmm15, zmm15, zmm12
    vaddpd zmm12, zmm3, zmm19
    vsubpd zmm20, zmm12, zmm3
    vsubpd zmm21, zmm12, zmm20
    vsubpd zmm21, zmm3, zmm21
    vsubpd zmm20, zmm19, zmm20
    vaddpd zmm21, zmm21, zmm20
    vaddpd zmm20, zmm15, zmm12
    vaddpd zmm12, zmm13, zmm20
    vsubpd zmm15, zmm12, zmm13
    vsubpd zmm15, zmm20, zmm15
    vaddpd zmm20, zmm15, zmm21
    vaddpd zmm21, zmm12, zmm20
    vsubpd zmm15, zmm21, zmm12
    vsubpd zmm15, zmm20, zmm15
    vdivpd zmm3, zmm21, zmm4
    vaddpd zmm15, zmm2, zmm14
    vsubpd zmm21, zmm15, zmm2
    vsubpd zmm21, zmm14, zmm21
    vaddpd zmm14, zmm15, zmm3
    vsubpd zmm2, zmm14, zmm15
    vsubpd zmm18, zmm14, zmm2
    vsubpd zmm18, zmm15, zmm18
    vsubpd zmm2, zmm3, zmm2
    vaddpd zmm18, zmm18, zmm2
    vaddpd zmm2, zmm21, zmm0
    vsubpd zmm19, zmm2, zmm21
    vsubpd zmm9, zmm2, zmm19
    vsubpd zmm9, zmm21, zmm9
    vsubpd zmm19, zmm0, zmm19
    vaddpd zmm9, zmm9, zmm19
    vaddpd zmm19, zmm18, zmm2
    vaddpd zmm2, zmm14, zmm19
    vsubpd zmm18, zmm2, zmm14
    vsubpd zmm18, zmm19, zmm18
    vaddpd zmm19, zmm18, zmm9
    vaddpd zmm9, zmm2, zmm19
    vsubpd zmm18, zmm9, zmm2
    vsubpd zmm18, zmm19, zmm18
    vaddpd zmm11, zmm5, zmm9
    vsubpd zmm10, zmm11, zmm5
    vsubpd zmm4, zmm11, zmm10
    vsubpd zmm4, zmm5, zmm4
    vsubpd zmm10, zmm9, zmm10
    vaddpd zmm4, zmm4, zmm10
    vaddpd zmm10, zmm8, zmm18
    vsubpd zmm3, zmm10, zmm8
    vsubpd zmm21, zmm10, zmm3
    vsubpd zmm21, zmm8, zmm21
    vsubpd zmm3, zmm18, zmm3
    vaddpd zmm21, zmm21, zmm3
    vaddpd zmm3, zmm4, zmm10
    vaddpd zmm10, zmm11, zmm3
    vsubpd zmm4, zmm10, zmm11
    vsubpd zmm4, zmm3, zmm4
    vaddpd zmm3, zmm4, zmm21
    vaddpd zmm21, zmm10, zmm3
    vsubpd zmm4, zmm21, zmm10
    vsubpd zmm4, zmm3, zmm4
    vmulpd zmm8, zmm9, zmm6
    vmovapd zmm5, zmm8
    vfmsub231pd zmm5, zmm9, zmm6
    vmulpd zmm3, zmm18, zmm6
    vfmadd231pd zmm3, zmm9, zmm7
    vaddpd zmm5, zmm5, zmm3
    vaddpd zmm3, zmm8, zmm5
    vsubpd zmm10, zmm3, zmm8
    vsubpd zmm10, zmm5, zmm10
    vbroadcastsd zmm18, [t_c2]
    vdivpd zmm9, zmm3, zmm18
    vpxorq zmm5, zmm9, [t_sign]{1to8}
    vmulpd zmm8, zmm18, zmm5
    vmovapd zmm11, zmm8
    vfmsub231pd zmm11, zmm18, zmm5
    vmulpd zmm15, zmm0, zmm5
    vfmadd231pd zmm15, zmm18, zmm0
    vaddpd zmm11, zmm11, zmm15
    vaddpd zmm15, zmm8, zmm11
    vsubpd zmm19, zmm15, zmm8
    vsubpd zmm19, zmm11, zmm19
    vaddpd zmm5, zmm3, zmm15
    vsubpd zmm11, zmm5, zmm3
    vsubpd zmm8, zmm5, zmm11
    vsubpd zmm8, zmm3, zmm8
    vsubpd zmm11, zmm15, zmm11
    vaddpd zmm8, zmm8, zmm11
    vaddpd zmm11, zmm10, zmm19
    vsubpd zmm2, zmm11, zmm10
    vsubpd zmm14, zmm11, zmm2
    vsubpd zmm14, zmm10, zmm14
    vsubpd zmm2, zmm19, zmm2
    vaddpd zmm14, zmm14, zmm2
    vaddpd zmm2, zmm8, zmm11
    vaddpd zmm11, zmm5, zmm2
    vsubpd zmm8, zmm11, zmm5
    vsubpd zmm8, zmm2, zmm8
    vaddpd zmm2, zmm8, zmm14
    vaddpd zmm14, zmm11, zmm2
    vsubpd zmm8, zmm14, zmm11
    vsubpd zmm8, zmm2, zmm8
    vdivpd zmm19, zmm14, zmm18
    vpxorq zmm15, zmm19, [t_sign]{1to8}
    vmulpd zmm2, zmm18, zmm15
    vmovapd zmm11, zmm2
    vfmsub231pd zmm11, zmm18, zmm15
    vmulpd zmm5, zmm0, zmm15
    vfmadd231pd zmm5, zmm18, zmm0
    vaddpd zmm11, zmm11, zmm5
    vaddpd zmm5, zmm2, zmm11
    vsubpd zmm20, zmm5, zmm2
    vsubpd zmm20, zmm11, zmm20
    vaddpd zmm15, zmm14, zmm5
    vsubpd zmm11, zmm15, zmm14
    vsubpd zmm2, zmm15, zmm11
    vsubpd zmm2, zmm14, zmm2
    vsubpd zmm11, zmm5, zmm11
    vaddpd zmm2, zmm2, zmm11
    vaddpd zmm11, zmm8, zmm20
    vsubpd zmm12, zmm11, zmm8
    vsubpd zmm13, zmm11, zmm12
    vsubpd zmm13, zmm8, zmm13
    vsubpd zmm12, zmm20, zmm12
    vaddpd zmm13, zmm13, zmm12
    vaddpd zmm12, zmm2, zmm11
    vaddpd zmm11, zmm15, zmm12
    vsubpd zmm2, zmm11, zmm15
    vsubpd zmm2, zmm12, zmm2
    vaddpd zmm12, zmm2, zmm13
    vaddpd zmm13, zmm11, zmm12
    vsubpd zmm2, zmm13, zmm11
    vsubpd zmm2, zmm12, zmm2
    vdivpd zmm8, zmm13, zmm18
    vaddpd zmm2, zmm9, zmm19
    vsubpd zmm13, zmm2, zmm9
    vsubpd zmm13, zmm19, zmm13
    vaddpd zmm19, zmm2, zmm8
    vsubpd zmm9, zmm19, zmm2
    vsubpd zmm14, zmm19, zmm9
    vsubpd zmm14, zmm2, zmm14
    vsubpd zmm9, zmm8, zmm9
    vaddpd zmm14, zmm14, zmm9
    vaddpd zmm9, zmm13, zmm0
    vsubpd zmm20, zmm9, zmm13
    vsubpd zmm5, zmm9, zmm20
    vsubpd zmm5, zmm13, zmm5
    vsubpd zmm20, zmm0, zmm20
    vaddpd zmm5, zmm5, zmm20
    vaddpd zmm20, zmm14, zmm9
    vaddpd zmm9, zmm19, zmm20
    vsubpd zmm14, zmm9, zmm19
    vsubpd zmm14, zmm20, zmm14
    vaddpd zmm20, zmm14, zmm5
    vaddpd zmm5, zmm9, zmm20
    vsubpd zmm14, zmm5, zmm9
    vsubpd zmm14, zmm20, zmm14
    vaddpd zmm10, zmm21, zmm5
    vsubpd zmm3, zmm10, zmm21
    vsubpd zmm18, zmm10, zmm3
    vsubpd zmm18, zmm21, zmm18
    vsubpd zmm3, zmm5, zmm3
    vaddpd zmm18, zmm18, zmm3
    vaddpd zmm3, zmm4, zmm14
    vsubpd zmm8, zmm3, zmm4
    vsubpd zmm13, zmm3, zmm8
    vsubpd zmm13, zmm4, zmm13
    vsubpd zmm8, zmm14, zmm8
    vaddpd zmm13, zmm13, zmm8
    vaddpd zmm8, zmm18, zmm3
    vaddpd zmm3, zmm10, zmm8
    vsubpd zmm18, zmm3, zmm10
    vsubpd zmm18, zmm8, zmm18
    vaddpd zmm8, zmm18, zmm13
    vaddpd zmm13, zmm3, zmm8
    vsubpd zmm18, zmm13, zmm3
    vsubpd zmm18, zmm8, zmm18
    vmulpd zmm4, zmm5, zmm6
    vmovapd zmm21, zmm4
    vfmsub231pd zmm21, zmm5, zmm6
    vmulpd zmm8, zmm14, zmm6
    vfmadd231pd zmm8, zmm5, zmm7
    vaddpd zmm21, zmm21, zmm8
    vaddpd zmm8, zmm4, zmm21
    vsubpd zmm3, zmm8, zmm4
    vsubpd zmm3, zmm21, zmm3
    vbroadcastsd zmm14, [t_c3]
    vdivpd zmm5, zmm8, zmm14
    vpxorq zmm21, zmm5, [t_sign]{1to8}
    vmulpd zmm4, zmm14, zmm21
    vmovapd zmm10, zmm4
    vfmsub231pd zmm10, zmm14, zmm21
    vmulpd zmm2, zmm0, zmm21
    vfmadd231pd zmm2, zmm14, zmm0
    vaddpd zmm10, zmm10, zmm2
    vaddpd zmm2, zmm4, zmm10
    vsubpd zmm20, zmm2, zmm4
    vsubpd zmm20, zmm10, zmm20
    vaddpd zmm21, zmm8, zmm2
    vsubpd zmm10, zmm21, zmm8
    vsubpd zmm4, zmm21, zmm10
    vsubpd zmm4, zmm8, zmm4
    vsubpd zmm10, zmm2, zmm10
    vaddpd zmm4, zmm4, zmm10
    vaddpd zmm10, zmm3, zmm20
    vsubpd zmm9, zmm10, zmm3
    vsubpd zmm19, zmm10, zmm9
    vsubpd zmm19, zmm3, zmm19
    vsubpd zmm9, zmm20, zmm9
    vaddpd zmm19, zmm19, zmm9
    vaddpd zmm9, zmm4, zmm10
    vaddpd zmm10, zmm21, zmm9
    vsubpd zmm4, zmm10, zmm21
    vsubpd zmm4, zmm9, zmm4
    vaddpd zmm9, zmm4, zmm19
    vaddpd zmm19, zmm10, zmm9
    vsubpd zmm4, zmm19, zmm10
    vsubpd zmm4, zmm9, zmm4
    vdivpd zmm20, zmm19, zmm14
    vpxorq zmm2, zmm20, [t_sign]{1to8}
    vmulpd zmm9, zmm14, zmm2
    vmovapd zmm10, zmm9
    vfmsub231pd zmm10, zmm14, zmm2
    vmulpd zmm21, zmm0, zmm2
    vfmadd231pd zmm21, zmm14, zmm0
    vaddpd zmm10, zmm10, zmm21
    vaddpd zmm21, zmm9, zmm10
    vsubpd zmm12, zmm21, zmm9
    vsubpd zmm12, zmm10, zmm12
    vaddpd zmm2, zmm19, zmm21
    vsubpd zmm10, zmm2, zmm19
    vsubpd zmm9, zmm2, zmm10
    vsubpd zmm9, zmm19, zmm9
    vsubpd zmm10, zmm21, zmm10
    vaddpd zmm9, zmm9, zmm10
    vaddpd zmm10, zmm4, zmm12
    vsubpd zmm11, zmm10, zmm4
    vsubpd zmm15, zmm10, zmm11
    vsubpd zmm15, zmm4, zmm15
    vsubpd zmm11, zmm12, zmm11
    vaddpd zmm15, zmm15, zmm11
    vaddpd zmm11, zmm9, zmm10
    vaddpd zmm10, zmm2, zmm11
    vsubpd zmm9, zmm10, zmm2
    vsubpd zmm9, zmm11, zmm9
    vaddpd zmm11, zmm9, zmm15
    vaddpd zmm15, zmm10, zmm11
    vsubpd zmm9, zmm15, zmm10
    vsubpd zmm9, zmm11, zmm9
    vdivpd zmm4, zmm15, zmm14
    vaddpd zmm9, zmm5, zmm20
    vsubpd zmm15, zmm9, zmm5
    vsubpd zmm15, zmm20, zmm15
    vaddpd zmm20, zmm9, zmm4
    vsubpd zmm5, zmm20, zmm9
    vsubpd zmm19, zmm20, zmm5
    vsubpd zmm19, zmm9, zmm19
    vsubpd zmm5, zmm4, zmm5
    vaddpd zmm19, zmm19, zmm5
    vaddpd zmm5, zmm15, zmm0
    vsubpd zmm12, zmm5, zmm15
    vsubpd zmm21, zmm5, zmm12
    vsubpd zmm21, zmm15, zmm21
    vsubpd zmm12, zmm0, zmm12
    vaddpd zmm21, zmm21, zmm12
    vaddpd zmm12, zmm19, zmm5
    vaddpd zmm5, zmm20, zmm12
    vsubpd zmm19, zmm5, zmm20
    vsubpd zmm19, zmm12, zmm19
    vaddpd zmm12, zmm19, zmm21
    vaddpd zmm21, zmm5, zmm12
    vsubpd zmm19, zmm21, zmm5
    vsubpd zmm19, zmm12, zmm19
    vaddpd zmm3, zmm13, zmm21
    vsubpd zmm8, zmm3, zmm13
    vsubpd zmm14, zmm3, zmm8
    vsubpd zmm14, zmm13, zmm14
    vsubpd zmm8, zmm21, zmm8
    vaddpd zmm14, zmm14, zmm8
    vaddpd zmm8, zmm18, zmm19
    vsubpd zmm4, zmm8, zmm18
    vsubpd zmm15, zmm8, zmm4
    vsubpd zmm15, zmm18, zmm15
    vsubpd zmm4, zmm19, zmm4
    vaddpd zmm15, zmm15, zmm4
    vaddpd zmm4, zmm14, zmm8
    vaddpd zmm8, zmm3, zmm4
    vsubpd zmm14, zmm8, zmm3
    vsubpd zmm14, zmm4, zmm14
    vaddpd zmm4, zmm14, zmm15
    vaddpd zmm15, zmm8, zmm4
    vsubpd zmm14, zmm15, zmm8
    vsubpd zmm14, zmm4, zmm14
    vmulpd zmm18, zmm21, zmm6
    vmovapd zmm13, zmm18
    vfmsub231pd zmm13, zmm21, zmm6
    vmulpd zmm4, zmm19, zmm6
    vfmadd231pd zmm4, zmm21, zmm7
    vaddpd zmm13, zmm13, zmm4
    vaddpd zmm4, zmm18, zmm13
    vsubpd zmm8, zmm4, zmm18
    vsubpd zmm8, zmm13, zmm8
    vbroadcastsd zmm19, [t_c4]
    vdivpd zmm21, zmm4, zmm19
    vpxorq zmm13, zmm21, [t_sign]{1to8}
    vmulpd zmm18, zmm19, zmm13
    vmovapd zmm3, zmm18
    vfmsub231pd zmm3, zmm19, zmm13
    vmulpd zmm9, zmm0, zmm13
    vfmadd231pd zmm9, zmm19, zmm0
    vaddpd zmm3, zmm3, zmm9
    vaddpd zmm9, zmm18, zmm3
    vsubpd zmm12, zmm9, zmm18
    vsubpd zmm12, zmm3, zmm12
    vaddpd zmm13, zmm4, zmm9
    vsubpd zmm3, zmm13, zmm4
    vsubpd zmm18, zmm13, zmm3
    vsubpd zmm18, zmm4, zmm18
    vsubpd zmm3, zmm9, zmm3
    vaddpd zmm18, zmm18, zmm3
    vaddpd zmm3, zmm8, zmm12
    vsubpd zmm5, zmm3, zmm8
    vsubpd zmm20, zmm3, zmm5
    vsubpd zmm20, zmm8, zmm20
    vsubpd zmm5, zmm12, zmm5
    vaddpd zmm20, zmm20, zmm5
    vaddpd zmm5, zmm18, zmm3
    vaddpd zmm3, zmm13, zmm5
    vsubpd zmm18, zmm3, zmm13
    vsubpd zmm18, zmm5, zmm18
    vaddpd zmm5, zmm18, zmm20
    vaddpd zmm20, zmm3, zmm5
    vsubpd zmm18, zmm20, zmm3
    vsubpd zmm18, zmm5, zmm18
    vdivpd zmm12, zmm20, zmm19
    vpxorq zmm9, zmm12, [t_sign]{1to8}
    vmulpd zmm5, zmm19, zmm9
    vmovapd zmm3, zmm5
    vfmsub231pd zmm3, zmm19, zmm9
    vmulpd zmm13, zmm0, zmm9
    vfmadd231pd zmm13, zmm19, zmm0
    vaddpd zmm3, zmm3, zmm13
    vaddpd zmm13, zmm5, zmm3
    vsubpd zmm11, zmm13, zmm5
    vsubpd zmm11, zmm3, zmm11
    vaddpd zmm9, zmm20, zmm13
    vsubpd zmm3, zmm9, zmm20
    vsubpd zmm5, zmm9, zmm3
    vsubpd zmm5, zmm20, zmm5
    vsubpd zmm3, zmm13, zmm3
    vaddpd zmm5, zmm5, zmm3
    vaddpd zmm3, zmm18, zmm11
    vsubpd zmm10, zmm3, zmm18
    vsubpd zmm2, zmm3, zmm10
    vsubpd zmm2, zmm18, zmm2
    vsubpd zmm10, zmm11, zmm10
    vaddpd zmm2, zmm2, zmm10
    vaddpd zmm10, zmm5, zmm3
    vaddpd zmm3, zmm9, zmm10
    vsubpd zmm5, zmm3, zmm9
    vsubpd zmm5, zmm10, zmm5
    vaddpd zmm10, zmm5, zmm2
    vaddpd zmm2, zmm3, zmm10
    vsubpd zmm5, zmm2, zmm3
    vsubpd zmm5, zmm10, zmm5
    vdivpd zmm18, zmm2, zmm19
    vaddpd zmm5, zmm21, zmm12
    vsubpd zmm2, zmm5, zmm21
    vsubpd zmm2, zmm12, zmm2
    vaddpd zmm12, zmm5, zmm18
    vsubpd zmm21, zmm12, zmm5
    vsubpd zmm20, zmm12, zmm21
    vsubpd zmm20, zmm5, zmm20
    vsubpd zmm21, zmm18, zmm21
    vaddpd zmm20, zmm20, zmm21
    vaddpd zmm21, zmm2, zmm0
    vsubpd zmm11, zmm21, zmm2
    vsubpd zmm13, zmm21, zmm11
    vsubpd zmm13, zmm2, zmm13
    vsubpd zmm11, zmm0, zmm11
    vaddpd zmm13, zmm13, zmm11
    vaddpd zmm11, zmm20, zmm21
    vaddpd zmm21, zmm12, zmm11
    vsubpd zmm20, zmm21, zmm12
    vsubpd zmm20, zmm11, zmm20
    vaddpd zmm11, zmm20, zmm13
    vaddpd zmm13, zmm21, zmm11
    vsubpd zmm20, zmm13, zmm21
    vsubpd zmm20, zmm11, zmm20
    vaddpd zmm8, zmm15, zmm13
    vsubpd zmm4, zmm8, zmm15
    vsubpd zmm19, zmm8, zmm4
    vsubpd zmm19, zmm15, zmm19
    vsubpd zmm4, zmm13, zmm4
    vaddpd zmm19, zmm19, zmm4
    vaddpd zmm4, zmm14, zmm20
    vsubpd zmm18, zmm4, zmm14
    vsubpd zmm2, zmm4, zmm18
    vsubpd zmm2, zmm14, zmm2
    vsubpd zmm18, zmm20, zmm18
    vaddpd zmm2, zmm2, zmm18
    vaddpd zmm18, zmm19, zmm4
    vaddpd zmm4, zmm8, zmm18
    vsubpd zmm19, zmm4, zmm8
    vsubpd zmm19, zmm18, zmm19
    vaddpd zmm18, zmm19, zmm2
    vaddpd zmm2, zmm4, zmm18
    vsubpd zmm19, zmm2, zmm4
    vsubpd zmm19, zmm18, zmm19
    vmulpd zmm14, zmm13, zmm6
    vmovapd zmm15, zmm14
    vfmsub231pd zmm15, zmm13, zmm6
    vmulpd zmm18, zmm20, zmm6
    vfmadd231pd zmm18, zmm13, zmm7
    vaddpd zmm15, zmm15, zmm18
    vaddpd zmm18, zmm14, zmm15
    vsubpd zmm4, zmm18, zmm14
    vsubpd zmm4, zmm15, zmm4
    vbroadcastsd zmm20, [t_c5]
    vdivpd zmm13, zmm18, zmm20
    vpxorq zmm15, zmm13, [t_sign]{1to8}
    vmulpd zmm14, zmm20, zmm15
    vmovapd zmm8, zmm14
    vfmsub231pd zmm8, zmm20, zmm15
    vmulpd zmm5, zmm0, zmm15
    vfmadd231pd zmm5, zmm20, zmm0
    vaddpd zmm8, zmm8, zmm5
    vaddpd zmm5, zmm14, zmm8
    vsubpd zmm11, zmm5, zmm14
    vsubpd zmm11, zmm8, zmm11
    vaddpd zmm15, zmm18, zmm5
    vsubpd zmm8, zmm15, zmm18
    vsubpd zmm14, zmm15, zmm8
    vsubpd zmm14, zmm18, zmm14
    vsubpd zmm8, zmm5, zmm8
    vaddpd zmm14, zmm14, zmm8
    vaddpd zmm8, zmm4, zmm11
    vsubpd zmm21, zmm8, zmm4
    vsubpd zmm12, zmm8, zmm21
    vsubpd zmm12, zmm4, zmm12
    vsubpd zmm21, zmm11, zmm21
    vaddpd zmm12, zmm12, zmm21
    vaddpd zmm21, zmm14, zmm8
    vaddpd zmm8, zmm15, zmm21
    vsubpd zmm14, zmm8, zmm15
    vsubpd zmm14, zmm21, zmm14
    vaddpd zmm21, zmm14, zmm12
    vaddpd zmm12, zmm8, zmm21
    vsubpd zmm14, zmm12, zmm8
    vsubpd zmm14, zmm21, zmm14
    vdivpd zmm11, zmm12, zmm20
    vpxorq zmm5, zmm11, [t_sign]{1to8}
    vmulpd zmm21, zmm20, zmm5
    vmovapd zmm8, zmm21
    vfmsub231pd zmm8, zmm20, zmm5
    vmulpd zmm15, zmm0, zmm5
    vfmadd231pd zmm15, zmm20, zmm0
    vaddpd zmm8, zmm8, zmm15
    vaddpd zmm15, zmm21, zmm8
    vsubpd zmm10, zmm15, zmm21
    vsubpd zmm10, zmm8, zmm10
    vaddpd zmm5, zmm12, zmm15
    vsubpd zmm8, zmm5, zmm12
    vsubpd zmm21, zmm5, zmm8
    vsubpd zmm21, zmm12, zmm21
    vsubpd zmm8, zmm15, zmm8
    vaddpd zmm21, zmm21, zmm8
    vaddpd zmm8, zmm14, zmm10
    vsubpd zmm3, zmm8, zmm14
    vsubpd zmm9, zmm8, zmm3
    vsubpd zmm9, zmm14, zmm9
    vsubpd zmm3, zmm10, zmm3
    vaddpd zmm9, zmm9, zmm3
    vaddpd zmm3, zmm21, zmm8
    vaddpd zmm8, zmm5, zmm3
    vsubpd zmm21, zmm8, zmm5
    vsubpd zmm21, zmm3, zmm21
    vaddpd zmm3, zmm21, zmm9
    vaddpd zmm9, zmm8, zmm3
    vsubpd zmm21, zmm9, zmm8
    vsubpd zmm21, zmm3, zmm21
    vdivpd zmm14, zmm9, zmm20
    vaddpd zmm21, zmm13, zmm11
    vsubpd zmm9, zmm21, zmm13
    vsubpd zmm9, zmm11, zmm9
    vaddpd zmm11, zmm21, zmm14
    vsubpd zmm13, zmm11, zmm21
    vsubpd zmm12, zmm11, zmm13
    vsubpd zmm12, zmm21, zmm12
    vsubpd zmm13, zmm14, zmm13
    vaddpd zmm12, zmm12, zmm13
    vaddpd zmm13, zmm9, zmm0
    vsubpd zmm10, zmm13, zmm9
    vsubpd zmm15, zmm13, zmm10
    vsubpd zmm15, zmm9, zmm15
    vsubpd zmm10, zmm0, zmm10
    vaddpd zmm15, zmm15, zmm10
    vaddpd zmm10, zmm12, zmm13
    vaddpd zmm13, zmm11, zmm10
    vsubpd zmm12, zmm13, zmm11
    vsubpd zmm12, zmm10, zmm12
    vaddpd zmm10, zmm12, zmm15
    vaddpd zmm15, zmm13, zmm10
    vsubpd zmm12, zmm15, zmm13
    vsubpd zmm12, zmm10, zmm12
    vaddpd zmm4, zmm2, zmm15
    vsubpd zmm18, zmm4, zmm2
    vsubpd zmm20, zmm4, zmm18
    vsubpd zmm20, zmm2, zmm20
    vsubpd zmm18, zmm15, zmm18
    vaddpd zmm20, zmm20, zmm18
    vaddpd zmm18, zmm19, zmm12
    vsubpd zmm14, zmm18, zmm19
    vsubpd zmm9, zmm18, zmm14
    vsubpd zmm9, zmm19, zmm9
    vsubpd zmm14, zmm12, zmm14
    vaddpd zmm9, zmm9, zmm14
    vaddpd zmm14, zmm20, zmm18
    vaddpd zmm18, zmm4, zmm14
    vsubpd zmm20, zmm18, zmm4
    vsubpd zmm20, zmm14, zmm20
    vaddpd zmm14, zmm20, zmm9
    vaddpd zmm9, zmm18, zmm14
    vsubpd zmm20, zmm9, zmm18
    vsubpd zmm20, zmm14, zmm20
    vmulpd zmm19, zmm15, zmm6
    vmovapd zmm2, zmm19
    vfmsub231pd zmm2, zmm15, zmm6
    vmulpd zmm14, zmm12, zmm6
    vfmadd231pd zmm14, zmm15, zmm7
    vaddpd zmm2, zmm2, zmm14
    vaddpd zmm14, zmm19, zmm2
    vsubpd zmm18, zmm14, zmm19
    vsubpd zmm18, zmm2, zmm18
    vbroadcastsd zmm12, [t_c6]
    vdivpd zmm15, zmm14, zmm12
    vpxorq zmm2, zmm15, [t_sign]{1to8}
    vmulpd zmm19, zmm12, zmm2
    vmovapd zmm4, zmm19
    vfmsub231pd zmm4, zmm12, zmm2
    vmulpd zmm21, zmm0, zmm2
    vfmadd231pd zmm21, zmm12, zmm0
    vaddpd zmm4, zmm4, zmm21
    vaddpd zmm21, zmm19, zmm4
    vsubpd zmm10, zmm21, zmm19
    vsubpd zmm10, zmm4, zmm10
    vaddpd zmm2, zmm14, zmm21
    vsubpd zmm4, zmm2, zmm14
    vsubpd zmm19, zmm2, zmm4
    vsubpd zmm19, zmm14, zmm19
    vsubpd zmm4, zmm21, zmm4
    vaddpd zmm19, zmm19, zmm4
    vaddpd zmm4, zmm18, zmm10
    vsubpd zmm13, zmm4, zmm18
    vsubpd zmm11, zmm4, zmm13
    vsubpd zmm11, zmm18, zmm11
    vsubpd zmm13, zmm10, zmm13
    vaddpd zmm11, zmm11, zmm13
    vaddpd zmm13, zmm19, zmm4
    vaddpd zmm4, zmm2, zmm13
    vsubpd zmm19, zmm4, zmm2
    vsubpd zmm19, zmm13, zmm19
    vaddpd zmm13, zmm19, zmm11
    vaddpd zmm11, zmm4, zmm13
    vsubpd zmm19, zmm11, zmm4
    vsubpd zmm19, zmm13, zmm19
    vdivpd zmm10, zmm11, zmm12
    vpxorq zmm21, zmm10, [t_sign]{1to8}
    vmulpd zmm13, zmm12, zmm21
    vmovapd zmm4, zmm13
    vfmsub231pd zmm4, zmm12, zmm21
    vmulpd zmm2, zmm0, zmm21
    vfmadd231pd zmm2, zmm12, zmm0
    vaddpd zmm4, zmm4, zmm2
    vaddpd zmm2, zmm13, zmm4
    vsubpd zmm3, zmm2, zmm13
    vsubpd zmm3, zmm4, zmm3
    vaddpd zmm21, zmm11, zmm2
    vsubpd zmm4, zmm21, zmm11
    vsubpd zmm13, zmm21, zmm4
    vsubpd zmm13, zmm11, zmm13
    vsubpd zmm4, zmm2, zmm4
    vaddpd zmm13, zmm13, zmm4
    vaddpd zmm4, zmm19, zmm3
    vsubpd zmm8, zmm4, zmm19
    vsubpd zmm5, zmm4, zmm8
    vsubpd zmm5, zmm19, zmm5
    vsubpd zmm8, zmm3, zmm8
    vaddpd zmm5, zmm5, zmm8
    vaddpd zmm8, zmm13, zmm4
    vaddpd zmm4, zmm21, zmm8
    vsubpd zmm13, zmm4, zmm21
    vsubpd zmm13, zmm8, zmm13
    vaddpd zmm8, zmm13, zmm5
    vaddpd zmm5, zmm4, zmm8
    vsubpd zmm13, zmm5, zmm4
    vsubpd zmm13, zmm8, zmm13
    vdivpd zmm19, zmm5, zmm12
    vaddpd zmm13, zmm15, zmm10
    vsubpd zmm5, zmm13, zmm15
    vsubpd zmm5, zmm10, zmm5
    vaddpd zmm10, zmm13, zmm19
    vsubpd zmm15, zmm10, zmm13
    vsubpd zmm11, zmm10, zmm15
    vsubpd zmm11, zmm13, zmm11
    vsubpd zmm15, zmm19, zmm15
    vaddpd zmm11, zmm11, zmm15
    vaddpd zmm15, zmm5, zmm0
    vsubpd zmm3, zmm15, zmm5
    vsubpd zmm2, zmm15, zmm3
    vsubpd zmm2, zmm5, zmm2
    vsubpd zmm3, zmm0, zmm3
    vaddpd zmm2, zmm2, zmm3
    vaddpd zmm3, zmm11, zmm15
    vaddpd zmm15, zmm10, zmm3
    vsubpd zmm11, zmm15, zmm10
    vsubpd zmm11, zmm3, zmm11
    vaddpd zmm3, zmm11, zmm2
    vaddpd zmm2, zmm15, zmm3
    vsubpd zmm11, zmm2, zmm15
    vsubpd zmm11, zmm3, zmm11
    vaddpd zmm18, zmm9, zmm2
    vsubpd zmm14, zmm18, zmm9
    vsubpd zmm12, zmm18, zmm14
    vsubpd zmm12, zmm9, zmm12
    vsubpd zmm14, zmm2, zmm14
    vaddpd zmm12, zmm12, zmm14
    vaddpd zmm14, zmm20, zmm11
    vsubpd zmm19, zmm14, zmm20
    vsubpd zmm5, zmm14, zmm19
    vsubpd zmm5, zmm20, zmm5
    vsubpd zmm19, zmm11, zmm19
    vaddpd zmm5, zmm5, zmm19
    vaddpd zmm19, zmm12, zmm14
    vaddpd zmm14, zmm18, zmm19
    vsubpd zmm12, zmm14, zmm18
    vsubpd zmm12, zmm19, zmm12
    vaddpd zmm19, zmm12, zmm5
    vaddpd zmm5, zmm14, zmm19
    vsubpd zmm12, zmm5, zmm14
    vsubpd zmm12, zmm19, zmm12
    vmulpd zmm20, zmm2, zmm6
    vmovapd zmm9, zmm20
    vfmsub231pd zmm9, zmm2, zmm6
    vmulpd zmm19, zmm11, zmm6
    vfmadd231pd zmm19, zmm2, zmm7
    vaddpd zmm9, zmm9, zmm19
    vaddpd zmm19, zmm20, zmm9
    vsubpd zmm14, zmm19, zmm20
    vsubpd zmm14, zmm9, zmm14
    vbroadcastsd zmm11, [t_c7]
    vdivpd zmm2, zmm19, zmm11
    vpxorq zmm9, zmm2, [t_sign]{1to8}
    vmulpd zmm20, zmm11, zmm9
    vmovapd zmm18, zmm20
    vfmsub231pd zmm18, zmm11, zmm9
    vmulpd zmm13, zmm0, zmm9
    vfmadd231pd zmm13, zmm11, zmm0
    vaddpd zmm18, zmm18, zmm13
    vaddpd zmm13, zmm20, zmm18
    vsubpd zmm3, zmm13, zmm20
    vsubpd zmm3, zmm18, zmm3
    vaddpd zmm9, zmm19, zmm13
    vsubpd zmm18, zmm9, zmm19
    vsubpd zmm20, zmm9, zmm18
    vsubpd zmm20, zmm19, zmm20
    vsubpd zmm18, zmm13, zmm18
    vaddpd zmm20, zmm20, zmm18
    vaddpd zmm18, zmm14, zmm3
    vsubpd zmm15, zmm18, zmm14
    vsubpd zmm10, zmm18, zmm15
    vsubpd zmm10, zmm14, zmm10
    vsubpd zmm15, zmm3, zmm15
    vaddpd zmm10, zmm10, zmm15
    vaddpd zmm15, zmm20, zmm18
    vaddpd zmm18, zmm9, zmm15
    vsubpd zmm20, zmm18, zmm9
    vsubpd zmm20, zmm15, zmm20
    vaddpd zmm15, zmm20, zmm10
    vaddpd zmm10, zmm18, zmm15
    vsubpd zmm20, zmm10, zmm18
    vsubpd zmm20, zmm15, zmm20
    vdivpd zmm3, zmm10, zmm11
    vpxorq zmm13, zmm3, [t_sign]{1to8}
    vmulpd zmm15, zmm11, zmm13
    vmovapd zmm18, zmm15
    vfmsub231pd zmm18, zmm11, zmm13
    vmulpd zmm9, zmm0, zmm13
    vfmadd231pd zmm9, zmm11, zmm0
    vaddpd zmm18, zmm18, zmm9
    vaddpd zmm9, zmm15, zmm18
    vsubpd zmm8, zmm9, zmm15
    vsubpd zmm8, zmm18, zmm8
    vaddpd zmm13, zmm10, zmm9
    vsubpd zmm18, zmm13, zmm10
    vsubpd zmm15, zmm13, zmm18
    vsubpd zmm15, zmm10, zmm15
    vsubpd zmm18, zmm9, zmm18
    vaddpd zmm15, zmm15, zmm18
    vaddpd zmm18, zmm20, zmm8
    vsubpd zmm4, zmm18, zmm20
    vsubpd zmm21, zmm18, zmm4
    vsubpd zmm21, zmm20, zmm21
    vsubpd zmm4, zmm8, zmm4
    vaddpd zmm21, zmm21, zmm4
    vaddpd zmm4, zmm15, zmm18
    vaddpd zmm18, zmm13, zmm4
    vsubpd zmm15, zmm18, zmm13
    vsubpd zmm15, zmm4, zmm15
    vaddpd zmm4, zmm15, zmm21
    vaddpd zmm21, zmm18, zmm4
    vsubpd zmm15, zmm21, zmm18
    vsubpd zmm15, zmm4, zmm15
    vdivpd zmm20, zmm21, zmm11
    vaddpd zmm15, zmm2, zmm3
    vsubpd zmm21, zmm15, zmm2
    vsubpd zmm21, zmm3, zmm21
    vaddpd zmm3, zmm15, zmm20
    vsubpd zmm2, zmm3, zmm15
    vsubpd zmm10, zmm3, zmm2
    vsubpd zmm10, zmm15, zmm10
    vsubpd zmm2, zmm20, zmm2
    vaddpd zmm10, zmm10, zmm2
    vaddpd zmm2, zmm21, zmm0
    vsubpd zmm8, zmm2, zmm21
    vsubpd zmm9, zmm2, zmm8
    vsubpd zmm9, zmm21, zmm9
    vsubpd zmm8, zmm0, zmm8
    vaddpd zmm9, zmm9, zmm8
    vaddpd zmm8, zmm10, zmm2
    vaddpd zmm2, zmm3, zmm8
    vsubpd zmm10, zmm2, zmm3
    vsubpd zmm10, zmm8, zmm10
    vaddpd zmm8, zmm10, zmm9
    vaddpd zmm9, zmm2, zmm8
    vsubpd zmm10, zmm9, zmm2
    vsubpd zmm10, zmm8, zmm10
    vaddpd zmm14, zmm5, zmm9
    vsubpd zmm19, zmm14, zmm5
    vsubpd zmm11, zmm14, zmm19
    vsubpd zmm11, zmm5, zmm11
    vsubpd zmm19, zmm9, zmm19
    vaddpd zmm11, zmm11, zmm19
    vaddpd zmm19, zmm12, zmm10
    vsubpd zmm20, zmm19, zmm12
    vsubpd zmm21, zmm19, zmm20
    vsubpd zmm21, zmm12, zmm21
    vsubpd zmm20, zmm10, zmm20
    vaddpd zmm21, zmm21, zmm20
    vaddpd zmm20, zmm11, zmm19
    vaddpd zmm19, zmm14, zmm20
    vsubpd zmm11, zmm19, zmm14
    vsubpd zmm11, zmm20, zmm11
    vaddpd zmm20, zmm11, zmm21
    vaddpd zmm21, zmm19, zmm20
    vsubpd zmm11, zmm21, zmm19
    vsubpd zmm11, zmm20, zmm11
    vmulpd zmm12, zmm9, zmm6
    vmovapd zmm5, zmm12
    vfmsub231pd zmm5, zmm9, zmm6
    vmulpd zmm20, zmm10, zmm6
    vfmadd231pd zmm20, zmm9, zmm7
    vaddpd zmm5, zmm5, zmm20
    vaddpd zmm20, zmm12, zmm5
    vsubpd zmm19, zmm20, zmm12
    vsubpd zmm19, zmm5, zmm19
    vbroadcastsd zmm10, [t_c8]
    vdivpd zmm9, zmm20, zmm10
    vpxorq zmm5, zmm9, [t_sign]{1to8}
    vmulpd zmm12, zmm10, zmm5
    vmovapd zmm14, zmm12
    vfmsub231pd zmm14, zmm10, zmm5
    vmulpd zmm15, zmm0, zmm5
    vfmadd231pd zmm15, zmm10, zmm0
    vaddpd zmm14, zmm14, zmm15
    vaddpd zmm15, zmm12, zmm14
    vsubpd zmm8, zmm15, zmm12
    vsubpd zmm8, zmm14, zmm8
    vaddpd zmm5, zmm20, zmm15
    vsubpd zmm14, zmm5, zmm20
    vsubpd zmm12, zmm5, zmm14
    vsubpd zmm12, zmm20, zmm12
    vsubpd zmm14, zmm15, zmm14
    vaddpd zmm12, zmm12, zmm14
    vaddpd zmm14, zmm19, zmm8
    vsubpd zmm2, zmm14, zmm19
    vsubpd zmm3, zmm14, zmm2
    vsubpd zmm3, zmm19, zmm3
    vsubpd zmm2, zmm8, zmm2
    vaddpd zmm3, zmm3, zmm2
    vaddpd zmm2, zmm12, zmm14
    vaddpd zmm14, zmm5, zmm2
    vsubpd zmm12, zmm14, zmm5
    vsubpd zmm12, zmm2, zmm12
    vaddpd zmm2, zmm12, zmm3
    vaddpd zmm3, zmm14, zmm2
    vsubpd zmm12, zmm3, zmm14
    vsubpd zmm12, zmm2, zmm12
    vdivpd zmm8, zmm3, zmm10
    vpxorq zmm15, zmm8, [t_sign]{1to8}
    vmulpd zmm2, zmm10, zmm15
    vmovapd zmm14, zmm2
    vfmsub231pd zmm14, zmm10, zmm15
    vmulpd zmm5, zmm0, zmm15
    vfmadd231pd zmm5, zmm10, zmm0
    vaddpd zmm14, zmm14, zmm5
    vaddpd zmm5, zmm2, zmm14
    vsubpd zmm4, zmm5, zmm2
    vsubpd zmm4, zmm14, zmm4
    vaddpd zmm15, zmm3, zmm5
    vsubpd zmm14, zmm15, zmm3
    vsubpd zmm2, zmm15, zmm14
    vsubpd zmm2, zmm3, zmm2
    vsubpd zmm14, zmm5, zmm14
    vaddpd zmm2, zmm2, zmm14
    vaddpd zmm14, zmm12, zmm4
    vsubpd zmm18, zmm14, zmm12
    vsubpd zmm13, zmm14, zmm18
    vsubpd zmm13, zmm12, zmm13
    vsubpd zmm18, zmm4, zmm18
    vaddpd zmm13, zmm13, zmm18
    vaddpd zmm18, zmm2, zmm14
    vaddpd zmm14, zmm15, zmm18
    vsubpd zmm2, zmm14, zmm15
    vsubpd zmm2, zmm18, zmm2
    vaddpd zmm18, zmm2, zmm13
    vaddpd zmm13, zmm14, zmm18
    vsubpd zmm2, zmm13, zmm14
    vsubpd zmm2, zmm18, zmm2
    vdivpd zmm12, zmm13, zmm10
    vaddpd zmm2, zmm9, zmm8
    vsubpd zmm13, zmm2, zmm9
    vsubpd zmm13, zmm8, zmm13
    vaddpd zmm8, zmm2, zmm12
    vsubpd zmm9, zmm8, zmm2
    vsubpd zmm3, zmm8, zmm9
    vsubpd zmm3, zmm2, zmm3
    vsubpd zmm9, zmm12, zmm9
    vaddpd zmm3, zmm3, zmm9
    vaddpd zmm9, zmm13, zmm0
    vsubpd zmm4, zmm9, zmm13
    vsubpd zmm5, zmm9, zmm4
    vsubpd zmm5, zmm13, zmm5
    vsubpd zmm4, zmm0, zmm4
    vaddpd zmm5, zmm5, zmm4
    vaddpd zmm4, zmm3, zmm9
    vaddpd zmm9, zmm8, zmm4
    vsubpd zmm3, zmm9, zmm8
    vsubpd zmm3, zmm4, zmm3
    vaddpd zmm4, zmm3, zmm5
    vaddpd zmm5, zmm9, zmm4
    vsubpd zmm3, zmm5, zmm9
    vsubpd zmm3, zmm4, zmm3
    vaddpd zmm19, zmm21, zmm5
    vsubpd zmm20, zmm19, zmm21
    vsubpd zmm10, zmm19, zmm20
    vsubpd zmm10, zmm21, zmm10
    vsubpd zmm20, zmm5, zmm20
    vaddpd zmm10, zmm10, zmm20
    vaddpd zmm20, zmm11, zmm3
    vsubpd zmm12, zmm20, zmm11
    vsubpd zmm13, zmm20, zmm12
    vsubpd zmm13, zmm11, zmm13
    vsubpd zmm12, zmm3, zmm12
    vaddpd zmm13, zmm13, zmm12
    vaddpd zmm12, zmm10, zmm20
    vaddpd zmm20, zmm19, zmm12
    vsubpd zmm10, zmm20, zmm19
    vsubpd zmm10, zmm12, zmm10
    vaddpd zmm12, zmm10, zmm13
    vaddpd zmm13, zmm20, zmm12
    vsubpd zmm10, zmm13, zmm20
    vsubpd zmm10, zmm12, zmm10
    vmulpd zmm11, zmm5, zmm6
    vmovapd zmm21, zmm11
    vfmsub231pd zmm21, zmm5, zmm6
    vmulpd zmm12, zmm3, zmm6
    vfmadd231pd zmm12, zmm5, zmm7
    vaddpd zmm21, zmm21, zmm12
    vaddpd zmm12, zmm11, zmm21
    vsubpd zmm20, zmm12, zmm11
    vsubpd zmm20, zmm21, zmm20
    vbroadcastsd zmm3, [t_c9]
    vdivpd zmm5, zmm12, zmm3
    vpxorq zmm21, zmm5, [t_sign]{1to8}
    vmulpd zmm11, zmm3, zmm21
    vmovapd zmm19, zmm11
    vfmsub231pd zmm19, zmm3, zmm21
    vmulpd zmm2, zmm0, zmm21
    vfmadd231pd zmm2, zmm3, zmm0
    vaddpd zmm19, zmm19, zmm2
    vaddpd zmm2, zmm11, zmm19
    vsubpd zmm4, zmm2, zmm11
    vsubpd zmm4, zmm19, zmm4
    vaddpd zmm21, zmm12, zmm2
    vsubpd zmm19, zmm21, zmm12
    vsubpd zmm11, zmm21, zmm19
    vsubpd zmm11, zmm12, zmm11
    vsubpd zmm19, zmm2, zmm19
    vaddpd zmm11, zmm11, zmm19
    vaddpd zmm19, zmm20, zmm4
    vsubpd zmm9, zmm19, zmm20
    vsubpd zmm8, zmm19, zmm9
    vsubpd zmm8, zmm20, zmm8
    vsubpd zmm9, zmm4, zmm9
    vaddpd zmm8, zmm8, zmm9
    vaddpd zmm9, zmm11, zmm19
    vaddpd zmm19, zmm21, zmm9
    vsubpd zmm11, zmm19, zmm21
    vsubpd zmm11, zmm9, zmm11
    vaddpd zmm9, zmm11, zmm8
    vaddpd zmm8, zmm19, zmm9
    vsubpd zmm11, zmm8, zmm19
    vsubpd zmm11, zmm9, zmm11
    vdivpd zmm4, zmm8, zmm3
    vpxorq zmm2, zmm4, [t_sign]{1to8}
    vmulpd zmm9, zmm3, zmm2
    vmovapd zmm19, zmm9
    vfmsub231pd zmm19, zmm3, zmm2
    vmulpd zmm21, zmm0, zmm2
    vfmadd231pd zmm21, zmm3, zmm0
    vaddpd zmm19, zmm19, zmm21
    vaddpd zmm21, zmm9, zmm19
    vsubpd zmm18, zmm21, zmm9
    vsubpd zmm18, zmm19, zmm18
    vaddpd zmm2, zmm8, zmm21
    vsubpd zmm19, zmm2, zmm8
    vsubpd zmm9, zmm2, zmm19
    vsubpd zmm9, zmm8, zmm9
    vsubpd zmm19, zmm21, zmm19
    vaddpd zmm9, zmm9, zmm19
    vaddpd zmm19, zmm11, zmm18
    vsubpd zmm14, zmm19, zmm11
    vsubpd zmm15, zmm19, zmm14
    vsubpd zmm15, zmm11, zmm15
    vsubpd zmm14, zmm18, zmm14
    vaddpd zmm15, zmm15, zmm14
    vaddpd zmm14, zmm9, zmm19
    vaddpd zmm19, zmm2, zmm14
    vsubpd zmm9, zmm19, zmm2
    vsubpd zmm9, zmm14, zmm9
    vaddpd zmm14, zmm9, zmm15
    vaddpd zmm15, zmm19, zmm14
    vsubpd zmm9, zmm15, zmm19
    vsubpd zmm9, zmm14, zmm9
    vdivpd zmm11, zmm15, zmm3
    vaddpd zmm9, zmm5, zmm4
    vsubpd zmm15, zmm9, zmm5
    vsubpd zmm15, zmm4, zmm15
    vaddpd zmm4, zmm9, zmm11
    vsubpd zmm5, zmm4, zmm9
    vsubpd zmm8, zmm4, zmm5
    vsubpd zmm8, zmm9, zmm8
    vsubpd zmm5, zmm11, zmm5
    vaddpd zmm8, zmm8, zmm5
    vaddpd zmm5, zmm15, zmm0
    vsubpd zmm18, zmm5, zmm15
    vsubpd zmm21, zmm5, zmm18
    vsubpd zmm21, zmm15, zmm21
    vsubpd zmm18, zmm0, zmm18
    vaddpd zmm21, zmm21, zmm18
    vaddpd zmm18, zmm8, zmm5
    vaddpd zmm5, zmm4, zmm18
    vsubpd zmm8, zmm5, zmm4
    vsubpd zmm8, zmm18, zmm8
    vaddpd zmm18, zmm8, zmm21
    vaddpd zmm21, zmm5, zmm18
    vsubpd zmm8, zmm21, zmm5
    vsubpd zmm8, zmm18, zmm8
    vaddpd zmm20, zmm13, zmm21
    vsubpd zmm12, zmm20, zmm13
    vsubpd zmm3, zmm20, zmm12
    vsubpd zmm3, zmm13, zmm3
    vsubpd zmm12, zmm21, zmm12
    vaddpd zmm3, zmm3, zmm12
    vaddpd zmm12, zmm10, zmm8
    vsubpd zmm11, zmm12, zmm10
    vsubpd zmm15, zmm12, zmm11
    vsubpd zmm15, zmm10, zmm15
    vsubpd zmm11, zmm8, zmm11
    vaddpd zmm15, zmm15, zmm11
    vaddpd zmm11, zmm3, zmm12
    vaddpd zmm12, zmm20, zmm11
    vsubpd zmm3, zmm12, zmm20
    vsubpd zmm3, zmm11, zmm3
    vaddpd zmm11, zmm3, zmm15
    vaddpd zmm15, zmm12, zmm11
    vsubpd zmm3, zmm15, zmm12
    vsubpd zmm3, zmm11, zmm3
    vmulpd zmm10, zmm21, zmm6
    vmovapd zmm13, zmm10
    vfmsub231pd zmm13, zmm21, zmm6
    vmulpd zmm11, zmm8, zmm6
    vfmadd231pd zmm11, zmm21, zmm7
    vaddpd zmm13, zmm13, zmm11
    vaddpd zmm11, zmm10, zmm13
    vsubpd zmm12, zmm11, zmm10
    vsubpd zmm12, zmm13, zmm12
    vbroadcastsd zmm8, [t_c10]
    vdivpd zmm21, zmm11, zmm8
    vpxorq zmm13, zmm21, [t_sign]{1to8}
    vmulpd zmm10, zmm8, zmm13
    vmovapd zmm20, zmm10
    vfmsub231pd zmm20, zmm8, zmm13
    vmulpd zmm9, zmm0, zmm13
    vfmadd231pd zmm9, zmm8, zmm0
    vaddpd zmm20, zmm20, zmm9
    vaddpd zmm9, zmm10, zmm20
    vsubpd zmm18, zmm9, zmm10
    vsubpd zmm18, zmm20, zmm18
    vaddpd zmm13, zmm11, zmm9
    vsubpd zmm20, zmm13, zmm11
    vsubpd zmm10, zmm13, zmm20
    vsubpd zmm10, zmm11, zmm10
    vsubpd zmm20, zmm9, zmm20
    vaddpd zmm10, zmm10, zmm20
    vaddpd zmm20, zmm12, zmm18
    vsubpd zmm5, zmm20, zmm12
    vsubpd zmm4, zmm20, zmm5
    vsubpd zmm4, zmm12, zmm4
    vsubpd zmm5, zmm18, zmm5
    vaddpd zmm4, zmm4, zmm5
    vaddpd zmm5, zmm10, zmm20
    vaddpd zmm20, zmm13, zmm5
    vsubpd zmm10, zmm20, zmm13
    vsubpd zmm10, zmm5, zmm10
    vaddpd zmm5, zmm10, zmm4
    vaddpd zmm4, zmm20, zmm5
    vsubpd zmm10, zmm4, zmm20
    vsubpd zmm10, zmm5, zmm10
    vdivpd zmm18, zmm4, zmm8
    vpxorq zmm9, zmm18, [t_sign]{1to8}
    vmulpd zmm5, zmm8, zmm9
    vmovapd zmm20, zmm5
    vfmsub231pd zmm20, zmm8, zmm9
    vmulpd zmm13, zmm0, zmm9
    vfmadd231pd zmm13, zmm8, zmm0
    vaddpd zmm20, zmm20, zmm13
    vaddpd zmm13, zmm5, zmm20
    vsubpd zmm14, zmm13, zmm5
    vsubpd zmm14, zmm20, zmm14
    vaddpd zmm9, zmm4, zmm13
    vsubpd zmm20, zmm9, zmm4
    vsubpd zmm5, zmm9, zmm20
    vsubpd zmm5, zmm4, zmm5
    vsubpd zmm20, zmm13, zmm20
    vaddpd zmm5, zmm5, zmm20
    vaddpd zmm20, zmm10, zmm14
    vsubpd zmm19, zmm20, zmm10
    vsubpd zmm2, zmm20, zmm19
    vsubpd zmm2, zmm10, zmm2
    vsubpd zmm19, zmm14, zmm19
    vaddpd zmm2, zmm2, zmm19
    vaddpd zmm19, zmm5, zmm20
    vaddpd zmm20, zmm9, zmm19
    vsubpd zmm5, zmm20, zmm9
    vsubpd zmm5, zmm19, zmm5
    vaddpd zmm19, zmm5, zmm2
    vaddpd zmm2, zmm20, zmm19
    vsubpd zmm5, zmm2, zmm20
    vsubpd zmm5, zmm19, zmm5
    vdivpd zmm10, zmm2, zmm8
    vaddpd zmm5, zmm21, zmm18
    vsubpd zmm2, zmm5, zmm21
    vsubpd zmm2, zmm18, zmm2
    vaddpd zmm18, zmm5, zmm10
    vsubpd zmm21, zmm18, zmm5
    vsubpd zmm4, zmm18, zmm21
    vsubpd zmm4, zmm5, zmm4
    vsubpd zmm21, zmm10, zmm21
    vaddpd zmm4, zmm4, zmm21
    vaddpd zmm21, zmm2, zmm0
    vsubpd zmm14, zmm21, zmm2
    vsubpd zmm13, zmm21, zmm14
    vsubpd zmm13, zmm2, zmm13
    vsubpd zmm14, zmm0, zmm14
    vaddpd zmm13, zmm13, zmm14
    vaddpd zmm14, zmm4, zmm21
    vaddpd zmm21, zmm18, zmm14
    vsubpd zmm4, zmm21, zmm18
    vsubpd zmm4, zmm14, zmm4
    vaddpd zmm14, zmm4, zmm13
    vaddpd zmm13, zmm21, zmm14
    vsubpd zmm4, zmm13, zmm21
    vsubpd zmm4, zmm14, zmm4
    vaddpd zmm12, zmm15, zmm13
    vsubpd zmm11, zmm12, zmm15
    vsubpd zmm8, zmm12, zmm11
    vsubpd zmm8, zmm15, zmm8
    vsubpd zmm11, zmm13, zmm11
    vaddpd zmm8, zmm8, zmm11
    vaddpd zmm11, zmm3, zmm4
    vsubpd zmm10, zmm11, zmm3
    vsubpd zmm2, zmm11, zmm10
    vsubpd zmm2, zmm3, zmm2
    vsubpd zmm10, zmm4, zmm10
    vaddpd zmm2, zmm2, zmm10
    vaddpd zmm10, zmm8, zmm11
    vaddpd zmm11, zmm12, zmm10
    vsubpd zmm8, zmm11, zmm12
    vsubpd zmm8, zmm10, zmm8
    vaddpd zmm10, zmm8, zmm2
    vaddpd zmm2, zmm11, zmm10
    vsubpd zmm8, zmm2, zmm11
    vsubpd zmm8, zmm10, zmm8
    vmulpd zmm3, zmm13, zmm6
    vmovapd zmm15, zmm3
    vfmsub231pd zmm15, zmm13, zmm6
    vmulpd zmm10, zmm4, zmm6
    vfmadd231pd zmm10, zmm13, zmm7
    vaddpd zmm15, zmm15, zmm10
    vaddpd zmm10, zmm3, zmm15
    vsubpd zmm11, zmm10, zmm3
    vsubpd zmm11, zmm15, zmm11
    vbroadcastsd zmm4, [t_c11]
    vdivpd zmm13, zmm10, zmm4
    vpxorq zmm15, zmm13, [t_sign]{1to8}
    vmulpd zmm3, zmm4, zmm15
    vmovapd zmm12, zmm3
    vfmsub231pd zmm12, zmm4, zmm15
    vmulpd zmm5, zmm0, zmm15
    vfmadd231pd zmm5, zmm4, zmm0
    vaddpd zmm12, zmm12, zmm5
    vaddpd zmm5, zmm3, zmm12
    vsubpd zmm14, zmm5, zmm3
    vsubpd zmm14, zmm12, zmm14
    vaddpd zmm15, zmm10, zmm5
    vsubpd zmm12, zmm15, zmm10
    vsubpd zmm3, zmm15, zmm12
    vsubpd zmm3, zmm10, zmm3
    vsubpd zmm12, zmm5, zmm12
    vaddpd zmm3, zmm3, zmm12
    vaddpd zmm12, zmm11, zmm14
    vsubpd zmm21, zmm12, zmm11
    vsubpd zmm18, zmm12, zmm21
    vsubpd zmm18, zmm11, zmm18
    vsubpd zmm21, zmm14, zmm21
    vaddpd zmm18, zmm18, zmm21
    vaddpd zmm21, zmm3, zmm12
    vaddpd zmm12, zmm15, zmm21
    vsubpd zmm3, zmm12, zmm15
    vsubpd zmm3, zmm21, zmm3
    vaddpd zmm21, zmm3, zmm18
    vaddpd zmm18, zmm12, zmm21
    vsubpd zmm3, zmm18, zmm12
    vsubpd zmm3, zmm21, zmm3
    vdivpd zmm14, zmm18, zmm4
    vpxorq zmm5, zmm14, [t_sign]{1to8}
    vmulpd zmm21, zmm4, zmm5
    vmovapd zmm12, zmm21
    vfmsub231pd zmm12, zmm4, zmm5
    vmulpd zmm15, zmm0, zmm5
    vfmadd231pd zmm15, zmm4, zmm0
    vaddpd zmm12, zmm12, zmm15
    vaddpd zmm15, zmm21, zmm12
    vsubpd zmm19, zmm15, zmm21
    vsubpd zmm19, zmm12, zmm19
    vaddpd zmm5, zmm18, zmm15
    vsubpd zmm12, zmm5, zmm18
    vsubpd zmm21, zmm5, zmm12
    vsubpd zmm21, zmm18, zmm21
    vsubpd zmm12, zmm15, zmm12
    vaddpd zmm21, zmm21, zmm12
    vaddpd zmm12, zmm3, zmm19
    vsubpd zmm20, zmm12, zmm3
    vsubpd zmm9, zmm12, zmm20
    vsubpd zmm9, zmm3, zmm9
    vsubpd zmm20, zmm19, zmm20
    vaddpd zmm9, zmm9, zmm20
    vaddpd zmm20, zmm21, zmm12
    vaddpd zmm12, zmm5, zmm20
    vsubpd zmm21, zmm12, zmm5
    vsubpd zmm21, zmm20, zmm21
    vaddpd zmm20, zmm21, zmm9
    vaddpd zmm9, zmm12, zmm20
    vsubpd zmm21, zmm9, zmm12
    vsubpd zmm21, zmm20, zmm21
    vdivpd zmm3, zmm9, zmm4
    vaddpd zmm21, zmm13, zmm14
    vsubpd zmm9, zmm21, zmm13
    vsubpd zmm9, zmm14, zmm9
    vaddpd zmm14, zmm21, zmm3
    vsubpd zmm13, zmm14, zmm21
    vsubpd zmm18, zmm14, zmm13
    vsubpd zmm18, zmm21, zmm18
    vsubpd zmm13, zmm3, zmm13
    vaddpd zmm18, zmm18, zmm13
    vaddpd zmm13, zmm9, zmm0
    vsubpd zmm19, zmm13, zmm9
    vsubpd zmm15, zmm13, zmm19
    vsubpd zmm15, zmm9, zmm15
    vsubpd zmm19, zmm0, zmm19
    vaddpd zmm15, zmm15, zmm19
    vaddpd zmm19, zmm18, zmm13
    vaddpd zmm13, zmm14, zmm19
    vsubpd zmm18, zmm13, zmm14
    vsubpd zmm18, zmm19, zmm18
    vaddpd zmm19, zmm18, zmm15
    vaddpd zmm15, zmm13, zmm19
    vsubpd zmm18, zmm15, zmm13
    vsubpd zmm18, zmm19, zmm18
    vaddpd zmm11, zmm2, zmm15
    vsubpd zmm10, zmm11, zmm2
    vsubpd zmm4, zmm11, zmm10
    vsubpd zmm4, zmm2, zmm4
    vsubpd zmm10, zmm15, zmm10
    vaddpd zmm4, zmm4, zmm10
    vaddpd zmm10, zmm8, zmm18
    vsubpd zmm3, zmm10, zmm8
    vsubpd zmm9, zmm10, zmm3
    vsubpd zmm9, zmm8, zmm9
    vsubpd zmm3, zmm18, zmm3
    vaddpd zmm9, zmm9, zmm3
    vaddpd zmm3, zmm4, zmm10
    vaddpd zmm10, zmm11, zmm3
    vsubpd zmm4, zmm10, zmm11
    vsubpd zmm4, zmm3, zmm4
    vaddpd zmm3, zmm4, zmm9
    vaddpd zmm9, zmm10, zmm3
    vsubpd zmm4, zmm9, zmm10
    vsubpd zmm4, zmm3, zmm4
    vmulpd zmm8, zmm15, zmm6
    vmovapd zmm2, zmm8
    vfmsub231pd zmm2, zmm15, zmm6
    vmulpd zmm3, zmm18, zmm6
    vfmadd231pd zmm3, zmm15, zmm7
    vaddpd zmm2, zmm2, zmm3
    vaddpd zmm3, zmm8, zmm2
    vsubpd zmm10, zmm3, zmm8
    vsubpd zmm10, zmm2, zmm10
    vbroadcastsd zmm18, [t_c12]
    vdivpd zmm15, zmm3, zmm18
    vpxorq zmm2, zmm15, [t_sign]{1to8}
    vmulpd zmm8, zmm18, zmm2
    vmovapd zmm11, zmm8
    vfmsub231pd zmm11, zmm18, zmm2
    vmulpd zmm21, zmm0, zmm2
    vfmadd231pd zmm21, zmm18, zmm0
    vaddpd zmm11, zmm11, zmm21
    vaddpd zmm21, zmm8, zmm11
    vsubpd zmm19, zmm21, zmm8
    vsubpd zmm19, zmm11, zmm19
    vaddpd zmm2, zmm3, zmm21
    vsubpd zmm11, zmm2, zmm3
    vsubpd zmm8, zmm2, zmm11
    vsubpd zmm8, zmm3, zmm8
    vsubpd zmm11, zmm21, zmm11
    vaddpd zmm8, zmm8, zmm11
    vaddpd zmm11, zmm10, zmm19
    vsubpd zmm13, zmm11, zmm10
    vsubpd zmm14, zmm11, zmm13
    vsubpd zmm14, zmm10, zmm14
    vsubpd zmm13, zmm19, zmm13
    vaddpd zmm14, zmm14, zmm13
    vaddpd zmm13, zmm8, zmm11
    vaddpd zmm11, zmm2, zmm13
    vsubpd zmm8, zmm11, zmm2
    vsubpd zmm8, zmm13, zmm8
    vaddpd zmm13, zmm8, zmm14
    vaddpd zmm14, zmm11, zmm13
    vsubpd zmm8, zmm14, zmm11
    vsubpd zmm8, zmm13, zmm8
    vdivpd zmm19, zmm14, zmm18
    vpxorq zmm21, zmm19, [t_sign]{1to8}
    vmulpd zmm13, zmm18, zmm21
    vmovapd zmm11, zmm13
    vfmsub231pd zmm11, zmm18, zmm21
    vmulpd zmm2, zmm0, zmm21
    vfmadd231pd zmm2, zmm18, zmm0
    vaddpd zmm11, zmm11, zmm2
    vaddpd zmm2, zmm13, zmm11
    vsubpd zmm20, zmm2, zmm13
    vsubpd zmm20, zmm11, zmm20
    vaddpd zmm21, zmm14, zmm2
    vsubpd zmm11, zmm21, zmm14
    vsubpd zmm13, zmm21, zmm11
    vsubpd zmm13, zmm14, zmm13
    vsubpd zmm11, zmm2, zmm11
    vaddpd zmm13, zmm13, zmm11
    vaddpd zmm11, zmm8, zmm20
    vsubpd zmm12, zmm11, zmm8
    vsubpd zmm5, zmm11, zmm12
    vsubpd zmm5, zmm8, zmm5
    vsubpd zmm12, zmm20, zmm12
    vaddpd zmm5, zmm5, zmm12
    vaddpd zmm12, zmm13, zmm11
    vaddpd zmm11, zmm21, zmm12
    vsubpd zmm13, zmm11, zmm21
    vsubpd zmm13, zmm12, zmm13
    vaddpd zmm12, zmm13, zmm5
    vaddpd zmm5, zmm11, zmm12
    vsubpd zmm13, zmm5, zmm11
    vsubpd zmm13, zmm12, zmm13
    vdivpd zmm8, zmm5, zmm18
    vaddpd zmm13, zmm15, zmm19
    vsubpd zmm5, zmm13, zmm15
    vsubpd zmm5, zmm19, zmm5
    vaddpd zmm19, zmm13, zmm8
    vsubpd zmm15, zmm19, zmm13
    vsubpd zmm14, zmm19, zmm15
    vsubpd zmm14, zmm13, zmm14
    vsubpd zmm15, zmm8, zmm15
    vaddpd zmm14, zmm14, zmm15
    vaddpd zmm15, zmm5, zmm0
    vsubpd zmm20, zmm15, zmm5
    vsubpd zmm2, zmm15, zmm20
    vsubpd zmm2, zmm5, zmm2
    vsubpd zmm20, zmm0, zmm20
    vaddpd zmm2, zmm2, zmm20
    vaddpd zmm20, zmm14, zmm15
    vaddpd zmm15, zmm19, zmm20
    vsubpd zmm14, zmm15, zmm19
    vsubpd zmm14, zmm20, zmm14
    vaddpd zmm20, zmm14, zmm2
    vaddpd zmm2, zmm15, zmm20
    vsubpd zmm14, zmm2, zmm15
    vsubpd zmm14, zmm20, zmm14
    vaddpd zmm10, zmm9, zmm2
    vsubpd zmm3, zmm10, zmm9
    vsubpd zmm18, zmm10, zmm3
    vsubpd zmm18, zmm9, zmm18
    vsubpd zmm3, zmm2, zmm3
    vaddpd zmm18, zmm18, zmm3
    vaddpd zmm3, zmm4, zmm14
    vsubpd zmm8, zmm3, zmm4
    vsubpd zmm5, zmm3, zmm8
    vsubpd zmm5, zmm4, zmm5
    vsubpd zmm8, zmm14, zmm8
    vaddpd zmm5, zmm5, zmm8
    vaddpd zmm8, zmm18, zmm3
    vaddpd zmm3, zmm10, zmm8
    vsubpd zmm18, zmm3, zmm10
    vsubpd zmm18, zmm8, zmm18
    vaddpd zmm8, zmm18, zmm5
    vaddpd zmm5, zmm3, zmm8
    vsubpd zmm18, zmm5, zmm3
    vsubpd zmm18, zmm8, zmm18
    vmulpd zmm4, zmm2, zmm6
    vmovapd zmm9, zmm4
    vfmsub231pd zmm9, zmm2, zmm6
    vmulpd zmm8, zmm14, zmm6
    vfmadd231pd zmm8, zmm2, zmm7
    vaddpd zmm9, zmm9, zmm8
    vaddpd zmm8, zmm4, zmm9
    vsubpd zmm3, zmm8, zmm4
    vsubpd zmm3, zmm9, zmm3
    vbroadcastsd zmm14, [t_c13]
    vdivpd zmm2, zmm8, zmm14
    vpxorq zmm9, zmm2, [t_sign]{1to8}
    vmulpd zmm4, zmm14, zmm9
    vmovapd zmm10, zmm4
    vfmsub231pd zmm10, zmm14, zmm9
    vmulpd zmm13, zmm0, zmm9
    vfmadd231pd zmm13, zmm14, zmm0
    vaddpd zmm10, zmm10, zmm13
    vaddpd zmm13, zmm4, zmm10
    vsubpd zmm20, zmm13, zmm4
    vsubpd zmm20, zmm10, zmm20
    vaddpd zmm9, zmm8, zmm13
    vsubpd zmm10, zmm9, zmm8
    vsubpd zmm4, zmm9, zmm10
    vsubpd zmm4, zmm8, zmm4
    vsubpd zmm10, zmm13, zmm10
    vaddpd zmm4, zmm4, zmm10
    vaddpd zmm10, zmm3, zmm20
    vsubpd zmm15, zmm10, zmm3
    vsubpd zmm19, zmm10, zmm15
    vsubpd zmm19, zmm3, zmm19
    vsubpd zmm15, zmm20, zmm15
    vaddpd zmm19, zmm19, zmm15
    vaddpd zmm15, zmm4, zmm10
    vaddpd zmm10, zmm9, zmm15
    vsubpd zmm4, zmm10, zmm9
    vsubpd zmm4, zmm15, zmm4
    vaddpd zmm15, zmm4, zmm19
    vaddpd zmm19, zmm10, zmm15
    vsubpd zmm4, zmm19, zmm10
    vsubpd zmm4, zmm15, zmm4
    vdivpd zmm20, zmm19, zmm14
    vpxorq zmm13, zmm20, [t_sign]{1to8}
    vmulpd zmm15, zmm14, zmm13
    vmovapd zmm10, zmm15
    vfmsub231pd zmm10, zmm14, zmm13
    vmulpd zmm9, zmm0, zmm13
    vfmadd231pd zmm9, zmm14, zmm0
    vaddpd zmm10, zmm10, zmm9
    vaddpd zmm9, zmm15, zmm10
    vsubpd zmm12, zmm9, zmm15
    vsubpd zmm12, zmm10, zmm12
    vaddpd zmm13, zmm19, zmm9
    vsubpd zmm10, zmm13, zmm19
    vsubpd zmm15, zmm13, zmm10
    vsubpd zmm15, zmm19, zmm15
    vsubpd zmm10, zmm9, zmm10
    vaddpd zmm15, zmm15, zmm10
    vaddpd zmm10, zmm4, zmm12
    vsubpd zmm11, zmm10, zmm4
    vsubpd zmm21, zmm10, zmm11
    vsubpd zmm21, zmm4, zmm21
    vsubpd zmm11, zmm12, zmm11
    vaddpd zmm21, zmm21, zmm11
    vaddpd zmm11, zmm15, zmm10
    vaddpd zmm10, zmm13, zmm11
    vsubpd zmm15, zmm10, zmm13
    vsubpd zmm15, zmm11, zmm15
    vaddpd zmm11, zmm15, zmm21
    vaddpd zmm21, zmm10, zmm11
    vsubpd zmm15, zmm21, zmm10
    vsubpd zmm15, zmm11, zmm15
    vdivpd zmm4, zmm21, zmm14
    vaddpd zmm15, zmm2, zmm20
    vsubpd zmm21, zmm15, zmm2
    vsubpd zmm21, zmm20, zmm21
    vaddpd zmm20, zmm15, zmm4
    vsubpd zmm2, zmm20, zmm15
    vsubpd zmm19, zmm20, zmm2
    vsubpd zmm19, zmm15, zmm19
    vsubpd zmm2, zmm4, zmm2
    vaddpd zmm19, zmm19, zmm2
    vaddpd zmm2, zmm21, zmm0
    vsubpd zmm12, zmm2, zmm21
    vsubpd zmm9, zmm2, zmm12
    vsubpd zmm9, zmm21, zmm9
    vsubpd zmm12, zmm0, zmm12
    vaddpd zmm9, zmm9, zmm12
    vaddpd zmm12, zmm19, zmm2
    vaddpd zmm2, zmm20, zmm12
    vsubpd zmm19, zmm2, zmm20
    vsubpd zmm19, zmm12, zmm19
    vaddpd zmm12, zmm19, zmm9
    vaddpd zmm9, zmm2, zmm12
    vsubpd zmm19, zmm9, zmm2
    vsubpd zmm19, zmm12, zmm19
    vaddpd zmm3, zmm5, zmm9
    vsubpd zmm8, zmm3, zmm5
    vsubpd zmm14, zmm3, zmm8
    vsubpd zmm14, zmm5, zmm14
    vsubpd zmm8, zmm9, zmm8
    vaddpd zmm14, zmm14, zmm8
    vaddpd zmm8, zmm18, zmm19
    vsubpd zmm4, zmm8, zmm18
    vsubpd zmm21, zmm8, zmm4
    vsubpd zmm21, zmm18, zmm21
    vsubpd zmm4, zmm19, zmm4
    vaddpd zmm21, zmm21, zmm4
    vaddpd zmm4, zmm14, zmm8
    vaddpd zmm8, zmm3, zmm4
    vsubpd zmm14, zmm8, zmm3
    vsubpd zmm14, zmm4, zmm14
    vaddpd zmm4, zmm14, zmm21
    vaddpd zmm21, zmm8, zmm4
    vsubpd zmm14, zmm21, zmm8
    vsubpd zmm14, zmm4, zmm14
    vmulpd zmm18, zmm21, zmm21
    vmovapd zmm5, zmm18
    vfmsub231pd zmm5, zmm21, zmm21
    vmulpd zmm4, zmm14, zmm21
    vfmadd231pd zmm4, zmm21, zmm14
    vaddpd zmm5, zmm5, zmm4
    vaddpd zmm4, zmm18, zmm5
    vsubpd zmm8, zmm4, zmm18
    vsubpd zmm8, zmm5, zmm8
    vmulpd zmm14, zmm4, zmm4
    vmovapd zmm21, zmm14
    vfmsub231pd zmm21, zmm4, zmm4
    vmulpd zmm5, zmm8, zmm4
    vfmadd231pd zmm5, zmm4, zmm8
    vaddpd zmm21, zmm21, zmm5
    vaddpd zmm5, zmm14, zmm21
    vsubpd zmm18, zmm5, zmm14
    vsubpd zmm18, zmm21, zmm18
    vmulpd zmm8, zmm5, zmm5
    vmovapd zmm4, zmm8
    vfmsub231pd zmm4, zmm5, zmm5
    vmulpd zmm21, zmm18, zmm5
    vfmadd231pd zmm21, zmm5, zmm18
    vaddpd zmm4, zmm4, zmm21
    vaddpd zmm21, zmm8, zmm4
    vsubpd zmm14, zmm21, zmm8
    vsubpd zmm14, zmm4, zmm14
    vmulpd zmm18, zmm21, zmm21
    vmovapd zmm5, zmm18
    vfmsub231pd zmm5, zmm21, zmm21
    vmulpd zmm4, zmm14, zmm21
    vfmadd231pd zmm4, zmm21, zmm14
    vaddpd zmm5, zmm5, zmm4
    vaddpd zmm4, zmm18, zmm5
    vsubpd zmm8, zmm4, zmm18
    vsubpd zmm8, zmm5, zmm8
    vmulpd zmm14, zmm4, zmm4
    vmovapd zmm21, zmm14
    vfmsub231pd zmm21, zmm4, zmm4
    vmulpd zmm5, zmm8, zmm4
    vfmadd231pd zmm5, zmm4, zmm8
    vaddpd zmm21, zmm21, zmm5
    vaddpd zmm5, zmm14, zmm21
    vsubpd zmm18, zmm5, zmm14
    vsubpd zmm18, zmm21, zmm18
    vmulpd zmm8, zmm5, zmm5
    vmovapd zmm4, zmm8
    vfmsub231pd zmm4, zmm5, zmm5
    vmulpd zmm21, zmm18, zmm5
    vfmadd231pd zmm21, zmm5, zmm18
    vaddpd zmm4, zmm4, zmm21
    vaddpd zmm21, zmm8, zmm4
    vsubpd zmm14, zmm21, zmm8
    vsubpd zmm14, zmm4, zmm14
    vmulpd zmm18, zmm21, zmm21
    vmovapd zmm5, zmm18
    vfmsub231pd zmm5, zmm21, zmm21
    vmulpd zmm4, zmm14, zmm21
    vfmadd231pd zmm4, zmm21, zmm14
    vaddpd zmm5, zmm5, zmm4
    vaddpd zmm4, zmm18, zmm5
    vsubpd zmm8, zmm4, zmm18
    vsubpd zmm8, zmm5, zmm8
    vmulpd zmm14, zmm4, zmm4
    vmovapd zmm21, zmm14
    vfmsub231pd zmm21, zmm4, zmm4
    vmulpd zmm5, zmm8, zmm4
    vfmadd231pd zmm5, zmm4, zmm8
    vaddpd zmm21, zmm21, zmm5
    vaddpd zmm5, zmm14, zmm21
    vsubpd zmm18, zmm5, zmm14
    vsubpd zmm18, zmm21, zmm18
    vmulpd zmm8, zmm5, zmm5
    vmovapd zmm4, zmm8
    vfmsub231pd zmm4, zmm5, zmm5
    vmulpd zmm21, zmm18, zmm5
    vfmadd231pd zmm21, zmm5, zmm18
    vaddpd zmm4, zmm4, zmm21
    vaddpd zmm21, zmm8, zmm4
    vsubpd zmm14, zmm21, zmm8
    vsubpd zmm14, zmm4, zmm14
    vmulpd zmm18, zmm21, zmm21
    vmovapd zmm5, zmm18
    vfmsub231pd zmm5, zmm21, zmm21
    vmulpd zmm4, zmm14, zmm21
    vfmadd231pd zmm4, zmm21, zmm14
    vaddpd zmm5, zmm5, zmm4
    vaddpd zmm4, zmm18, zmm5
    vsubpd zmm8, zmm4, zmm18
    vsubpd zmm8, zmm5, zmm8
    vscalefpd zmm16, zmm4, zmm1
    vscalefpd zmm17, zmm8, zmm1
    ret
