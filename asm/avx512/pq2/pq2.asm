%include "dav1d_x86inc.asm"

W equ 64*M
HMX equ 4320
CST equ W+64
CPL0 equ (18*M+4)*CST
CB0 equ 72*W*M+64
CRD equ CPL0 + 65536*(((HMX/2+4)*CST - CPL0 + 65535)/65536)
CB equ CB0 + 65536*((2*W*HMX + 64 - CB0 + 65535)/65536)
SPBC equ 512*(M+1)
SLT equ 11264+256
BMS equ 11264+8*SPBC+512
STX equ BMS+2688
CRY equ STX+5184
FRAME equ CRY+16*W

SECTION_RODATA 64

ALIGN 64
t_lad: dd 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, W+0, W+2, W+4, W+6, W+8, W+10, W+12, W+14, W+16, W+18, W+20, W+22, W+24, W+26, W+28, W+30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, W+32, W+34, W+36, W+38, W+40, W+42, W+44, W+46, W+48, W+50, W+52, W+54, W+56, W+58, W+60, W+62
d_wcl: dd W/2 - 1
MGM equ (0x100000000 + M - 1) / M
T_EXK equ 0
T_EXR equ 64
T_LN equ 192
T_E1 equ 384
T_RQ equ 768
T_SV equ 2816
T_Y equ 2944
T_B equ 3072
T_R equ 3200
T_XV equ 3328
T_LA equ 3520
T_AA equ 3584
T_LO equ 3648
T_HI equ 3712
T_SRC equ 3776
T_EH equ 3840
T_EL equ 4224
T_AC equ 4608
T_EC equ 4736
T_ZS equ 4864
T_O equ 4928
T_XS equ 4992
TS equ 5112

SECTION .text align=4096
INIT_ZMM avx512

cextern ro
cextern dp
%define c_rq (ro + 0)
%define c_vq (ro + 128)
%define c_uq (ro + 256)
%define c_t6 (ro + 384)
%define c_zero (ro + 384)
%define c_w6 (ro + 512)
%define c_t1l (ro + 640)
%define c_t1h (ro + 768)
%define c_w1 (ro + 896)
%define c_r1 (ro + 1024)
%define c_rk (ro + 1152)
%define c_rp (ro + 1280)
%define c_t2 (ro + 1408)
%define c_s2 (ro + 1536)
%define c_one (ro + 1540)
%define c_ones (ro + 1600)
%define c_n64w (ro + 1664)
%define c_pkw (ro + 1728)
%define c_flq (ro + 1792)
%define c_pu0 (ro + 1796)
%define c_pu1 (ro + 1800)
%define c_pu2 (ro + 1804)
%define c_c1q (ro + 1808)
%define c_aq (ro + 1812)
%define c_bq (ro + 1816)
%define c_c3 (ro + 1820)
%define c_q60 (ro + 1824)
%define c_q61 (ro + 1828)
%define c_q62 (ro + 1832)
%define c_anl (ro + 1836)
%define c_tbl (ro + 1840)
%define c_rgl (ro + 1844)
%define c_xll (ro + 1848)
%define c_omh1 (ro + 1852)
%define c_oml0 (ro + 1852)
%define c_oml1 (ro + 1856)
%define c_omh0 (ro + 1860)
%define c_omh2 (ro + 1860)
%define c_oml2 (ro + 1860)
%define c_mtl0 (ro + 1864)
%define c_mtl1 (ro + 1868)
%define c_mtl2 (ro + 1872)
%define c_anh (ro + 1876)
%define c_tbh (ro + 1880)
%define c_rgh (ro + 1884)
%define c_xlh (ro + 1888)
%define c_mth0 (ro + 1892)
%define c_mth1 (ro + 1896)
%define c_mth2 (ro + 1900)
%define c_mth4 (ro + 1904)
%define c_mth5 (ro + 1908)
%define c_nieq (ro + 1912)
%define c_eqp (ro + 1916)
%define c_q10 (ro + 1920)
%define c_q11 (ro + 1924)
%define c_s1q (ro + 1928)
%define c_48 (ro + 1932)
%define c_mag (ro + 1936)
%define c_p20 (ro + 1940)
%define c_p21 (ro + 1944)
%define c_p22 (ro + 1948)
%define c_p23 (ro + 1952)
%define c_oa (ro + 1956)
%define c_sl (ro + 1960)
%define c_half (ro + 1964)
%define c_h0625 (ro + 1968)
%define c_grh (ro + 1972)
%define c_h5625 (ro + 1972)
%define c_krh (ro + 1976)
%define c_krl (ro + 1980)
%define c_grl (ro + 1984)
%define c_gbh (ro + 1988)
%define c_gbl (ro + 1992)
%define c_kbh (ro + 1996)
%define c_kbl (ro + 2000)
%define c_sign (ro + 2004)
%define c_absm (ro + 2008)
%define c_i64 (ro + 2012)
%define c_i512 (ro + 2016)
%define c_i1023 (ro + 2020)
%define c_ffff (ro + 2024)
%define c_lo16 (ro + 2028)
%define d_xys (ro + 2032)
%define d_xyb (ro + 2040)
%define d_xec (ro + 2048)
%define d_xdr (ro + 2056)
%define d_xdg (ro + 2064)
%define t_c2d (ro + 2112)
%define d_one (ro + 2176)
%define d_qa (ro + 2176)
%define d_qw (ro + 2304)
%define d_rx (ro + 2432)
%define d_qr (ro + 2560)
%define d_qm (ro + 2688)
%define d_zero (ro + 2688)
%define d_qt (ro + 2816)
%define d_t2l (ro + 2944)
%define d_w2x (ro + 3072)
%define d_rxl (ro + 3200)
%define d_t1e (ro + 3328)
%define d_w1m (ro + 3456)
%define d_qb (ro + 3584)
%define d_lgt (ro + 3648)
%define d_ln2 (ro + 5696)
%define d_lzm0 (ro + 5712)
%define d_ysc (ro + 5712)
%define d_lzm5 (ro + 5728)
%define d_yof (ro + 5728)
%define d_lzm1 (ro + 5744)
%define d_rcr (ro + 5744)
%define d_gcr (ro + 5760)
%define d_lzm2 (ro + 5760)
%define d_gcb (ro + 5776)
%define d_lzm3 (ro + 5776)
%define d_bcb (ro + 5792)
%define d_lzm4 (ro + 5792)
%define d_kr (ro + 5808)
%define d_kg (ro + 5824)
%define d_kb (ro + 5840)
%define d_cbs (ro + 5856)
%define d_crs (ro + 5872)
%define d_im2 (ro + 5888)
%define d_im1 (ro + 5904)
%define d_k12 (ro + 5920)
%define d_pk (ro + 5920)
%define d_m12d (ro + 5936)
%define d_ex (ro + 5952)
%define d_half (ro + 5984)
%define d_lg0 (ro + 6096)
%define d_lg1 (ro + 6104)
%define d_lg2 (ro + 6112)
%define d_lg3 (ro + 6120)
%define d_lg4 (ro + 6128)
%define d_lg5 (ro + 6136)
%define d_lg6 (ro + 6144)
%define d_lg7 (ro + 6152)
%define d_mhalf (ro + 6152)
%define d_lg8 (ro + 6160)
%define d_lg9 (ro + 6168)
%define d_lg10 (ro + 6176)
%define d_lg11 (ro + 6184)
%define d_lg12 (ro + 6192)
%define d_lg13 (ro + 6200)
%define d_lg14 (ro + 6208)
%define d_lg15 (ro + 6216)
%define d_lg16 (ro + 6224)
%define d_lg17 (ro + 6232)
%define d_mc1 (ro + 6240)
%define d_mone (ro + 6248)
%define d_mzero (ro + 6256)
%define d_sgn (ro + 6256)
%define d_2p20 (ro + 6264)
%define d_i1024 (ro + 6272)
%define d_1024 (ro + 6280)
%define d_876 (ro + 6288)
%define d_64 (ro + 6296)
%define d_512 (ro + 6304)
%define d_120 (ro + 6312)
%define d_1023 (ro + 6320)
%define d_q4 (ro + 6328)
%define d_q16 (ro + 6336)
%define d_2p27 (ro + 6344)
%define d_epd (ro + 6352)
%define d_tab (ro + 6360)
%define d_tab2 (ro + 6368)
%define d_omg (ro + 6376)
%define d_eq0 (ro + 6384)
%define d_rg2 (ro + 6392)
%define d_c1 (ro + 6400)
%define d_c2 (ro + 6408)
%define d_c3 (ro + 6416)
%define d_m1 (ro + 6424)
%define d_m2 (ro + 6432)
%define d_c13 (ro + 6440)
%define d_c2c (ro + 6448)
%define d_laq (ro + 6456)
%define d_t2k (ro + 6464)
%define d_zz (ro + 6472)
%define d_m12 (ro + 6480)
%define d_flo (ro + 6488)
%define d_qtk (ro + 6496)
%define d_k7 (ro + 6504)
%define d_k7s (ro + 6512)
%define d_k7m (ro + 6520)
%define d_sga (ro + 6528)
%define d_rgl (ro + 6536)
%define d_anl (ro + 6544)
%define d_kvl (ro + 6552)
%define d_sll (ro + 6560)
%define d_ylo (ro + 6560)
%define d_shl (ro + 6568)
%define d_yhi (ro + 6568)
%define d_rgh (ro + 6576)
%define d_anh (ro + 6584)
%define d_kvh (ro + 6592)
%define d_clo (ro + 6600)
%define d_slh (ro + 6600)
%define d_chi (ro + 6608)
%define d_shh (ro + 6608)
%define d_hm (ro + 6616)
%define d_q1023 (ro + 6624)
%define d_lmo (ro + 6632)
%define d_lhl (ro + 6640)
%define d_lof (ro + 6648)
%define d_lfe (ro + 6656)
%define d_lhm (ro + 6664)
%define d_qp0 (ro + 6672)
%define d_qp1 (ro + 6680)
%define d_qp2 (ro + 6688)
%define d_qp3 (ro + 6696)
%define d_qp4 (ro + 6704)
%define d_qp5 (ro + 6712)
%define d_ql0 (ro + 6720)
%define d_ql1 (ro + 6728)
%define d_ql2 (ro + 6736)
%define d_ql3 (ro + 6744)
%define d_ql4 (ro + 6752)
%define d_qe0 (ro + 6760)
%define d_qe1 (ro + 6768)
%define d_qe2 (ro + 6776)
%define d_qe3 (ro + 6784)
%define d_qe4 (ro + 6792)
%define d_q2x0 (ro + 6800)
%define d_q2x1 (ro + 6808)
%define d_q2x2 (ro + 6816)
%define d_q2x3 (ro + 6824)
%define d_q2x4 (ro + 6832)
%define d_p1m0 (ro + 6840)
%define d_p1m1 (ro + 6848)
%define d_p1m2 (ro + 6856)
%define d_p1m3 (ro + 6864)
%define d_p1m4 (ro + 6872)
%define d_emc0 (ro + 6880)
%define d_emc1 (ro + 6888)
%define d_emc2 (ro + 6896)
%define d_emc3 (ro + 6904)
%define d_emc6 (ro + 6904)
%define d_emc4 (ro + 6912)
%define d_emc5 (ro + 6920)
%define d_emc7 (ro + 6928)
%define d_emc8 (ro + 6936)
%define d_pl2 (ro + 6976)
%define d_pc2 (ro + 7040)
%define d_iot (ro + 7104)
%define d_yp (ro + 7136)
%define d_w8 (ro + 7168)
%define d_mq1 (ro + 7184)
%define d_i16 (ro + 7192)
%define d_abs (ro + 7200)

cglobal pq2_ %+ M
    push r9
    push r10
    push r13
    push r14
    push r11
    push r12
    mov r6, rsp
    sub rsp, FRAME
    and rsp, -64
    mov [rsp + 11200], r6
    mov [rsp + 11208], r1
    mov [rsp + 11216], r0
    lea r2, [r0 + CB]
    lea r4, [rsp + SLT + 2*SPBC]
    mov r5d, 4
.cpr:
    movzx r6d, word [r2 + CRD*0 + W - 2]
    mov [r2 + CRD*0 + W], r6w
    mov [r2 + CRD*0 + W + 2], r6w
    movzx r6d, word [r2 + CRD*1 + W - 2]
    mov [r2 + CRD*1 + W], r6w
    mov [r2 + CRD*1 + W + 2], r6w
    mov r3, -W
.cpe:
    vpmovzxwd zmm0, [r2 + r3 + W + CRD*0]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vmovaps [r4 + r3*8 + 8*W + 0], zmm0
    vpmovzxwd zmm1, [r2 + r3 + W + CRD*1]
    vpsubd zmm1, zmm1, [c_i512]{1to16}
    vcvtdq2ps zmm1, zmm1
    vmovaps [r4 + r3*8 + 8*W + 64], zmm1
    add r3, 32
    jnz .cpe
    vpmovzxwd zmm0, [r2 + W + CRD*0]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vmovaps [r4 + 8*W + 0], zmm0
    vbroadcastss zmm0, [r4 + 0]
    vmovaps [r4 + -256], zmm0
    vpmovzxwd zmm1, [r2 + W + CRD*1]
    vpsubd zmm1, zmm1, [c_i512]{1to16}
    vcvtdq2ps zmm1, zmm1
    vmovaps [r4 + 8*W + 64], zmm1
    vbroadcastss zmm1, [r4 + 64]
    vmovaps [r4 + -192], zmm1
    mov r3, -8*W
.cpo:
    vmovaps zmm0, [r4 + r3 + 8*W + 0]
    vmovaps zmm1, [r4 + r3 + 8*W + 256]
    valignd zmm2, zmm0, [r4 + r3 + 8*W + -256], 15
    valignd zmm3, zmm1, zmm0, 1
    valignd zmm4, zmm1, zmm0, 2
    vaddps zmm3, zmm3, zmm0
    vaddps zmm2, zmm2, zmm4
    vmulps zmm2, zmm2, [c_h0625]{1to16}
    vfmsub132ps zmm3, zmm2, [c_h5625]{1to16}
    vmovaps [r4 + r3 + 8*W + 128], zmm3
    vmovaps zmm8, [r4 + r3 + 8*W + 64]
    vmovaps zmm9, [r4 + r3 + 8*W + 320]
    valignd zmm10, zmm8, [r4 + r3 + 8*W + -192], 15
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
    vmovaps zmm0, [r4 + r3 + 8*W + 2*SPBC + 0]
    vmovaps [r4 + r3 + 8*W + SPBC + 0], zmm0
    vmovaps zmm1, [r4 + r3 + 8*W + 2*SPBC + 128]
    vmovaps [r4 + r3 + 8*W + SPBC + 128], zmm1
    vmovaps zmm2, [r4 + r3 + 8*W + 2*SPBC + 256]
    vmovaps [r4 + r3 + 8*W + SPBC + 256], zmm2
    vmovaps zmm3, [r4 + r3 + 8*W + 2*SPBC + 384]
    vmovaps [r4 + r3 + 8*W + SPBC + 384], zmm3
    vmovaps zmm0, [r4 + r3 + 8*W + 2*SPBC + 64]
    vmovaps [r4 + r3 + 8*W + SPBC + 64], zmm0
    vmovaps zmm1, [r4 + r3 + 8*W + 2*SPBC + 192]
    vmovaps [r4 + r3 + 8*W + SPBC + 192], zmm1
    vmovaps zmm2, [r4 + r3 + 8*W + 2*SPBC + 320]
    vmovaps [r4 + r3 + 8*W + SPBC + 320], zmm2
    vmovaps zmm3, [r4 + r3 + 8*W + 2*SPBC + 448]
    vmovaps [r4 + r3 + 8*W + SPBC + 448], zmm3
    add r3, 512
    jnz .cpc
    mov r2, [dp + 8]
    add r2, r0
    mov r3, -W
.cpb:
    vmovdqu16 zmm0, [r2 + r3 + CRD*0 - CST]
    vmovdqu16 [r2 + r3 + CRD*0], zmm0
    vmovdqu16 [r2 + r3 + CRD*0 + CST], zmm0
    vmovdqu16 zmm0, [r2 + r3 + CRD*1 - CST]
    vmovdqu16 [r2 + r3 + CRD*1], zmm0
    vmovdqu16 [r2 + r3 + CRD*1 + CST], zmm0
    add r3, 64
    jnz .cpb
    vpxord zmm0, zmm0, zmm0
    vmovaps [rsp + BMS + 0], zmm0
    vmovaps [rsp + BMS + 64], zmm0
    vmovaps [rsp + BMS + 128], zmm0
    vmovaps [rsp + BMS + 192], zmm0
    vmovaps [rsp + BMS + 256], zmm0
    vmovaps [rsp + BMS + 320], zmm0
    vmovaps [rsp + BMS + 384], zmm0
    vmovaps [rsp + BMS + 448], zmm0
    vmovaps [rsp + BMS + 512], zmm0
    vmovaps [rsp + BMS + 576], zmm0
    vmovaps [rsp + BMS + 640], zmm0
    vmovaps [rsp + BMS + 704], zmm0
    vmovaps [rsp + BMS + 768], zmm0
    vmovaps [rsp + BMS + 832], zmm0
    vmovaps [rsp + BMS + 896], zmm0
    vmovaps [rsp + BMS + 960], zmm0
    vmovaps [rsp + BMS + 1024], zmm0
    vmovaps [rsp + BMS + 1088], zmm0
    vmovaps [rsp + BMS + 1152], zmm0
    vmovaps [rsp + BMS + 1216], zmm0
    mov qword [rsp + BMS + 1280], 0
    mov word [rsp + BMS + 1288], 0
    mov qword [rsp + BMS + 2624], 0
    mov word [rsp + BMS + 2632], 0
    mov qword [rsp + STX+5120], 0
    lea r6, [rsp + BMS]
    lea r2, [rsp + BMS + 1344]
    xor r6, r2
    mov [rsp + 11224], r6
    lea r1, [r0 + 2*W]
    lea r5, [rsp + SLT + 2*SPBC]
    mov r3, -(W/2)
.rz:
    vbroadcastss zmm29, [c_krh]
    vbroadcastss zmm28, [c_krl]
    vbroadcastss zmm27, [c_grh]
    vbroadcastss zmm26, [c_grl]
    vbroadcastss zmm25, [c_gbh]
    vbroadcastss zmm24, [c_gbl]
    vbroadcastss zmm23, [c_kbh]
    vbroadcastss zmm22, [c_kbl]
    vmovups zmm21, [c_n64w]
    vbroadcastss zmm20, [c_ffff]
    vmovups zmm0, [r1+r3*4]
    vmovups zmm1, [r5]
    vmovups zmm2, [r5+64]
    vmovups zmm3, [r5+128]
    vmovups zmm4, [r5+192]
    vpsubw zmm5, zmm0, zmm21
    vmulps zmm6, zmm1, zmm24
    vmulps zmm7, zmm3, zmm24
    vmovups zmm8, [r1+r3*4+64]
    vpsrad zmm9, zmm5, 16
    vpternlogd zmm5, zmm20, [c_lo16]{1to16}, 106
    vfmadd231ps zmm6, zmm2, zmm26
    vcvtdq2ps zmm10, zmm9
    vsubps zmm11, zmm5, [c_lo16]{1to16}
    vfmadd231ps zmm7, zmm4, zmm26
    vmovups zmm12, [r5+256]
    vmovups zmm13, [r5+320]
    vpsubw zmm14, zmm8, zmm21
    vmovaps zmm15, zmm11
    vfmadd231ps zmm15, zmm2, zmm29
    vmovaps zmm16, zmm11
    vfnmadd231ps zmm16, zmm2, zmm27
    vfmadd231ps zmm11, zmm1, zmm23
    vmovaps zmm17, zmm10
    vfmadd231ps zmm17, zmm4, zmm29
    vpsrad zmm18, zmm14, 16
    vpternlogd zmm14, zmm20, [c_lo16]{1to16}, 106
    vmovaps zmm19, zmm10
    vfnmadd231ps zmm19, zmm4, zmm27
    vfmadd231ps zmm10, zmm3, zmm23
    vcvtdq2ps zmm0, zmm18
    vsubps zmm9, zmm14, [c_lo16]{1to16}
    vmulps zmm5, zmm12, zmm24
    vmovups zmm8, [r5+384]
    vmovups zmm18, [r5+448]
    vfmadd231ps zmm15, zmm2, zmm28
    vfnmadd231ps zmm16, zmm1, zmm25
    vfmadd231ps zmm11, zmm1, zmm22
    vfmadd231ps zmm17, zmm4, zmm28
    vfnmadd231ps zmm19, zmm3, zmm25
    vfmadd231ps zmm10, zmm3, zmm22
    vmovaps zmm14, zmm9
    vfmadd231ps zmm14, zmm13, zmm29
    vmovaps zmm2, zmm9
    vfnmadd231ps zmm2, zmm13, zmm27
    vfmadd231ps zmm5, zmm13, zmm26
    vfmadd231ps zmm9, zmm12, zmm23
    vsubps zmm1, zmm16, zmm6
    vmovaps [rsp], zmm15
    vfmadd213ps zmm29, zmm18, zmm0
    vfnmadd213ps zmm27, zmm18, zmm0
    jmp .j64
.j64:
    vmovaps [rsp+128], zmm11
    vmulps zmm4, zmm8, zmm24
    vfmadd231ps zmm0, zmm8, zmm23
    vsubps zmm3, zmm19, zmm7
    vmovaps [rsp+768], zmm17
    vmovaps [rsp+896], zmm10
    vfmadd231ps zmm14, zmm13, zmm28
    vfnmadd231ps zmm2, zmm12, zmm25
    vmovaps [rsp+64], zmm1
    vfmadd231ps zmm9, zmm12, zmm22
    vmovaps [rsp+832], zmm3
    vfmadd231ps zmm29, zmm18, zmm28
    vfnmadd231ps zmm27, zmm8, zmm25
    vfmadd231ps zmm4, zmm18, zmm26
    vfmadd231ps zmm0, zmm8, zmm22
    vsubps zmm16, zmm2, zmm5
    vmovaps [rsp+1536], zmm14
    vmovaps [rsp+1664], zmm9
    vmovaps [rsp+2304], zmm29
    vmovaps [rsp+1600], zmm16
    vsubps zmm6, zmm27, zmm4
    vmovaps [rsp+2432], zmm0
    vmovaps [rsp+2368], zmm6
    vmovups zmm31, [c_rq]
    vmovups zmm30, [c_rq+64]
    vmovups zmm29, [c_vq]
    vmovups zmm28, [c_vq+64]
    vmovups zmm27, [c_uq]
    vmovups zmm26, [c_uq+64]
    vbroadcastss zmm25, [c_one]
    vbroadcastss zmm24, [c_pu0]
    vbroadcastss zmm23, [c_pu1]
    vbroadcastss zmm22, [c_pu2]
    vbroadcastss zmm21, [c_c1q]
    vbroadcastss zmm20, [c_aq]
    vbroadcastss zmm19, [c_bq]
    vmovups zmm0, [rsp]
    vmovups zmm1, [rsp+64]
    vrangeps zmm2, zmm0, [c_flq]{1to16}, 11
    vpsrld zmm3, zmm0, 18
    vrangeps zmm4, zmm1, [c_flq]{1to16}, 11
    vpsrld zmm5, zmm1, 18
    vmovaps zmm6, zmm3
    vpermi2ps zmm6, zmm31, zmm30
    vpermi2ps zmm3, zmm29, zmm28
    vprord zmm7, zmm2, 23
    vgetmantps zmm8, zmm2, 4
    vmovaps zmm9, zmm5
    vpermi2ps zmm9, zmm31, zmm30
    vpermi2ps zmm5, zmm29, zmm28
    vprord zmm10, zmm4, 23
    vgetmantps zmm11, zmm4, 4
    vmovups zmm12, [rsp+128]
    vpermi2ps zmm7, zmm27, zmm26
    vpermi2ps zmm10, zmm27, zmm26
    vfmsub213ps zmm8, zmm6, zmm25
    vfmsub213ps zmm11, zmm9, zmm25
    vrangeps zmm13, zmm12, [c_flq]{1to16}, 11
    vpsrld zmm14, zmm12, 18
    vsubps zmm15, zmm21, zmm7
    vmovaps zmm16, zmm14
    vpermi2ps zmm16, zmm31, zmm30
    vpermi2ps zmm14, zmm29, zmm28
    vmovaps zmm17, zmm23
    jmp .j128
.j128:
    vfmadd231ps zmm17, zmm22, zmm8
    vmovaps zmm18, zmm8
    vfmadd231ps zmm18, zmm3, zmm8
    vsubps zmm0, zmm21, zmm10
    vgetmantps zmm1, zmm13, 4
    vmovups zmm2, [rsp+768]
    vmovaps zmm4, zmm23
    vfmadd231ps zmm4, zmm22, zmm11
    vmovaps zmm6, zmm11
    vfmadd231ps zmm6, zmm5, zmm11
    vprord zmm9, zmm13, 23
    vfmadd213ps zmm17, zmm8, zmm24
    vfmsub213ps zmm1, zmm16, zmm25
    vpermi2ps zmm9, zmm27, zmm26
    vfmadd213ps zmm4, zmm11, zmm24
    vrangeps zmm12, zmm2, [c_flq]{1to16}, 11
    vpsrld zmm13, zmm2, 18
    vmovaps zmm8, zmm13
    vpermi2ps zmm8, zmm31, zmm30
    vpermi2ps zmm13, zmm29, zmm28
    vprord zmm16, zmm12, 23
    vgetmantps zmm11, zmm12, 4
    vmovups zmm2, [rsp+832]
    vfmadd231ps zmm3, zmm18, zmm17
    vmovaps zmm12, zmm23
    vfmadd231ps zmm12, zmm22, zmm1
    vfmadd231ps zmm5, zmm6, zmm4
    vsubps zmm18, zmm21, zmm9
    vmovaps zmm17, zmm1
    vfmadd231ps zmm17, zmm14, zmm1
    vpermi2ps zmm16, zmm27, zmm26
    vfmsub213ps zmm11, zmm8, zmm25
    vfnmadd231ps zmm7, zmm15, zmm3
    vfmadd213ps zmm12, zmm1, zmm24
    vrangeps zmm6, zmm2, [c_flq]{1to16}, 11
    vpsrld zmm4, zmm2, 18
    vfnmadd231ps zmm10, zmm0, zmm5
    vmovaps zmm8, zmm4
    vpermi2ps zmm8, zmm31, zmm30
    vpermi2ps zmm4, zmm29, zmm28
    vsubps zmm15, zmm21, zmm16
    vprord zmm3, zmm6, 23
    vgetmantps zmm1, zmm6, 4
    vmovups zmm2, [rsp+896]
    vmovaps zmm0, zmm23
    vfmadd231ps zmm0, zmm22, zmm11
    vmovaps zmm5, zmm11
    vfmadd231ps zmm5, zmm13, zmm11
    vfmadd231ps zmm14, zmm17, zmm12
    vdivps zmm6, zmm20, zmm7
    vpermi2ps zmm3, zmm27, zmm26
    vfmsub213ps zmm1, zmm8, zmm25
    vfmadd213ps zmm0, zmm11, zmm24
    vrangeps zmm17, zmm2, [c_flq]{1to16}, 11
    vpsrld zmm12, zmm2, 18
    vfnmadd231ps zmm9, zmm18, zmm14
    vmovaps zmm7, zmm12
    vpermi2ps zmm7, zmm31, zmm30
    vpermi2ps zmm12, zmm29, zmm28
    vsubps zmm8, zmm21, zmm3
    vprord zmm11, zmm17, 23
    vgetmantps zmm2, zmm17, 4
    vdivps zmm18, zmm20, zmm10
    vmovaps zmm14, zmm23
    jmp .j192
.j192:
    vfmadd231ps zmm14, zmm22, zmm1
    vmovaps zmm17, zmm1
    vfmadd231ps zmm17, zmm4, zmm1
    vmovups zmm10, [rsp+1536]
    vfmadd231ps zmm13, zmm5, zmm0
    vsubps zmm5, zmm6, zmm19
    vpermi2ps zmm11, zmm27, zmm26
    vfmsub213ps zmm2, zmm7, zmm25
    vfmadd213ps zmm14, zmm1, zmm24
    vmovaps [rsp+3072], zmm5
    vfnmadd231ps zmm16, zmm15, zmm13
    vrangeps zmm0, zmm10, [c_flq]{1to16}, 11
    vpsrld zmm6, zmm10, 18
    vsubps zmm7, zmm21, zmm11
    vmovaps zmm1, zmm6
    vpermi2ps zmm1, zmm31, zmm30
    vpermi2ps zmm6, zmm29, zmm28
    vmovaps zmm5, zmm23
    vfmadd231ps zmm5, zmm22, zmm2
    vmovaps zmm15, zmm2
    vfmadd231ps zmm15, zmm12, zmm2
    vsubps zmm13, zmm18, zmm19
    vgetmantps zmm10, zmm0, 4
    vfmadd231ps zmm4, zmm17, zmm14
    vprord zmm18, zmm0, 23
    vmovups zmm17, [rsp+1600]
    vdivps zmm14, zmm20, zmm9
    vmovaps [rsp+3136], zmm13
    vpermi2ps zmm18, zmm27, zmm26
    vfmadd213ps zmm5, zmm2, zmm24
    vfmsub213ps zmm10, zmm1, zmm25
    vfnmadd231ps zmm3, zmm8, zmm4
    vrangeps zmm0, zmm17, [c_flq]{1to16}, 11
    vpsrld zmm9, zmm17, 18
    vmovaps zmm13, zmm9
    vpermi2ps zmm13, zmm31, zmm30
    vpermi2ps zmm9, zmm29, zmm28
    vfmadd231ps zmm12, zmm15, zmm5
    vmovaps zmm2, zmm23
    vfmadd231ps zmm2, zmm22, zmm10
    vsubps zmm1, zmm21, zmm18
    vgetmantps zmm8, zmm0, 4
    vmovaps zmm4, zmm10
    vfmadd231ps zmm4, zmm6, zmm10
    vprord zmm17, zmm0, 23
    vmovups zmm15, [rsp+1664]
    vsubps zmm5, zmm14, zmm19
    vdivps zmm0, zmm20, zmm16
    vpermi2ps zmm17, zmm27, zmm26
    vfnmadd231ps zmm11, zmm7, zmm12
    vfmadd213ps zmm2, zmm10, zmm24
    vmovaps [rsp+3200], zmm5
    vfmsub213ps zmm8, zmm13, zmm25
    vrangeps zmm14, zmm15, [c_flq]{1to16}, 11
    vpsrld zmm16, zmm15, 18
    vmovaps zmm7, zmm16
    vpermi2ps zmm7, zmm31, zmm30
    vpermi2ps zmm16, zmm29, zmm28
    vfmadd231ps zmm6, zmm4, zmm2
    vsubps zmm12, zmm21, zmm17
    vprord zmm10, zmm14, 23
    vgetmantps zmm5, zmm14, 4
    vmovaps zmm13, zmm23
    vfmadd231ps zmm13, zmm22, zmm8
    jmp .j256
.j256:
    vmovaps zmm15, zmm8
    vfmadd231ps zmm15, zmm9, zmm8
    vmovups zmm4, [rsp+2304]
    vsubps zmm2, zmm0, zmm19
    vdivps zmm14, zmm20, zmm3
    vpermi2ps zmm10, zmm27, zmm26
    vfnmadd231ps zmm18, zmm1, zmm6
    vmovaps [rsp+3840], zmm2
    vfmsub213ps zmm5, zmm7, zmm25
    vfmadd213ps zmm13, zmm8, zmm24
    vrangeps zmm0, zmm4, [c_flq]{1to16}, 11
    vpsrld zmm3, zmm4, 18
    vsubps zmm1, zmm21, zmm10
    vmovaps zmm6, zmm3
    vpermi2ps zmm6, zmm31, zmm30
    vpermi2ps zmm3, zmm29, zmm28
    vmovaps zmm2, zmm23
    vfmadd231ps zmm2, zmm22, zmm5
    vmovaps zmm7, zmm5
    vfmadd231ps zmm7, zmm16, zmm5
    vgetmantps zmm8, zmm0, 4
    vfmadd231ps zmm9, zmm15, zmm13
    vprord zmm4, zmm0, 23
    vmovups zmm15, [rsp+2368]
    vsubps zmm13, zmm14, zmm19
    vdivps zmm0, zmm20, zmm11
    vpermi2ps zmm4, zmm27, zmm26
    vfmadd213ps zmm2, zmm5, zmm24
    vmovaps [rsp+3904], zmm13
    vfmsub213ps zmm8, zmm6, zmm25
    vfnmadd231ps zmm17, zmm12, zmm9
    vrangeps zmm14, zmm15, [c_flq]{1to16}, 11
    vpsrld zmm11, zmm15, 18
    vmovaps zmm5, zmm11
    vpermi2ps zmm5, zmm31, zmm30
    vpermi2ps zmm11, zmm29, zmm28
    vfmadd231ps zmm16, zmm7, zmm2
    vmovaps zmm13, zmm23
    vfmadd231ps zmm13, zmm22, zmm8
    vsubps zmm6, zmm21, zmm4
    vgetmantps zmm12, zmm14, 4
    vmovaps zmm9, zmm8
    vfmadd231ps zmm9, zmm3, zmm8
    vprord zmm15, zmm14, 23
    vmovups zmm7, [rsp+2432]
    vsubps zmm2, zmm0, zmm19
    vdivps zmm14, zmm20, zmm18
    vpermi2ps zmm15, zmm27, zmm26
    vfnmadd231ps zmm10, zmm1, zmm16
    vfmadd213ps zmm13, zmm8, zmm24
    vmovaps [rsp+3968], zmm2
    vfmsub213ps zmm12, zmm5, zmm25
    vrangeps zmm0, zmm7, [c_flq]{1to16}, 11
    vpsrld zmm18, zmm7, 18
    vmovaps zmm1, zmm18
    vpermi2ps zmm1, zmm31, zmm30
    vpermi2ps zmm18, zmm29, zmm28
    vfmadd231ps zmm3, zmm9, zmm13
    vsubps zmm16, zmm21, zmm15
    vprord zmm8, zmm0, 23
    vgetmantps zmm2, zmm0, 4
    vmovaps zmm5, zmm23
    vfmadd231ps zmm5, zmm22, zmm12
    vmovaps zmm7, zmm12
    jmp .j320
.j320:
    vfmadd231ps zmm7, zmm11, zmm12
    vsubps zmm9, zmm14, zmm19
    vdivps zmm13, zmm20, zmm17
    vdivps zmm0, zmm20, zmm10
    vpermi2ps zmm8, zmm27, zmm26
    vfnmadd231ps zmm4, zmm6, zmm3
    vmovaps [rsp+4608], zmm9
    vfmsub231ps zmm25, zmm2, zmm1
    vfmadd213ps zmm5, zmm12, zmm24
    vsubps zmm14, zmm21, zmm8
    vfmadd231ps zmm23, zmm22, zmm25
    vmovaps zmm17, zmm25
    vfmadd231ps zmm17, zmm18, zmm25
    vfmadd231ps zmm11, zmm7, zmm5
    vdivps zmm10, zmm20, zmm4
    vsubps zmm6, zmm13, zmm19
    vsubps zmm3, zmm0, zmm19
    vfmadd231ps zmm24, zmm23, zmm25
    vmovaps [rsp+4672], zmm6
    vfnmadd231ps zmm15, zmm16, zmm11
    vmovaps [rsp+4736], zmm3
    vfmadd231ps zmm18, zmm17, zmm24
    vsubps zmm9, zmm10, zmm19
    vdivps zmm2, zmm20, zmm15
    vmovaps [rsp+5376], zmm9
    vfnmadd231ps zmm8, zmm14, zmm18
    vdivps zmm1, zmm20, zmm8
    vsubps zmm12, zmm2, zmm19
    vmovaps [rsp+5440], zmm12
    vsubps zmm7, zmm1, zmm19
    vmovaps [rsp+5504], zmm7
    vmovups zmm31, [c_t6]
    vmovups zmm30, [c_t6+64]
    vmovups zmm29, [c_w6]
    vmovups zmm28, [c_w6+64]
    vmovups zmm27, [c_rq]
    vmovups zmm26, [c_rq+64]
    vbroadcastss zmm25, [c_one]
    vbroadcastss zmm24, [c_q60]
    vbroadcastss zmm23, [c_q61]
    vbroadcastss zmm22, [c_q62]
    vbroadcastss zmm21, [c_sign]
    vmovups zmm0, [rsp+3072]
    vmovups zmm1, [rsp+3136]
    vmovups zmm2, [rsp+3200]
    vpsrld zmm3, zmm0, 18
    vpsrld zmm4, zmm0, 23
    vgetmantps zmm5, zmm0, 4
    vpsrld zmm6, zmm1, 18
    vpsrld zmm7, zmm1, 23
    vgetmantps zmm8, zmm1, 4
    vpermi2ps zmm4, zmm31, zmm30
    vmovaps zmm9, zmm3
    vpermi2ps zmm9, zmm29, zmm28
    vpsrld zmm10, zmm2, 18
    vpermi2ps zmm3, zmm27, zmm26
    vmovaps zmm11, zmm6
    vpermi2ps zmm11, zmm29, zmm28
    vpsrld zmm12, zmm2, 23
    vpermi2ps zmm7, zmm31, zmm30
    vpermi2ps zmm6, zmm27, zmm26
    vgetmantps zmm13, zmm2, 4
    vmovaps zmm14, zmm10
    vpermi2ps zmm14, zmm29, zmm28
    jmp .j384
.j384:
    vpermi2ps zmm10, zmm27, zmm26
    vmovups zmm15, [rsp+3840]
    vpermi2ps zmm12, zmm31, zmm30
    vmulps zmm16, zmm4, zmm9
    vfmsub213ps zmm5, zmm3, zmm25
    vmulps zmm17, zmm7, zmm11
    vfmsub213ps zmm8, zmm6, zmm25
    vfmsub213ps zmm13, zmm10, zmm25
    vpsrld zmm18, zmm15, 18
    vpsrld zmm19, zmm15, 23
    vmulps zmm20, zmm12, zmm14
    vgetmantps zmm0, zmm15, 4
    vpermi2ps zmm19, zmm31, zmm30
    vmovaps zmm1, zmm18
    vpermi2ps zmm1, zmm29, zmm28
    vmovaps zmm2, zmm23
    vfmadd231ps zmm2, zmm22, zmm5
    vmulps zmm4, zmm16, zmm5
    vpermi2ps zmm18, zmm27, zmm26
    vmovups zmm9, [rsp+3904]
    vmovaps zmm3, zmm23
    vfmadd231ps zmm3, zmm22, zmm8
    vmulps zmm7, zmm17, zmm8
    vmovaps zmm11, zmm23
    vfmadd231ps zmm11, zmm22, zmm13
    vmulps zmm6, zmm20, zmm13
    vfmadd213ps zmm2, zmm5, zmm24
    vmulps zmm10, zmm19, zmm1
    vfmadd213ps zmm3, zmm8, zmm24
    vfmsub213ps zmm0, zmm18, zmm25
    vpsrld zmm12, zmm9, 18
    vpsrld zmm14, zmm9, 23
    vfmadd213ps zmm11, zmm13, zmm24
    vgetmantps zmm15, zmm9, 4
    vmovups zmm5, [rsp+3968]
    vpermi2ps zmm14, zmm31, zmm30
    vmovaps zmm19, zmm12
    vpermi2ps zmm19, zmm29, zmm28
    vpermi2ps zmm12, zmm27, zmm26
    vfmadd231ps zmm16, zmm4, zmm2
    vfmadd231ps zmm17, zmm7, zmm3
    vmovaps zmm1, zmm23
    vfmadd231ps zmm1, zmm22, zmm0
    vfmadd231ps zmm20, zmm6, zmm11
    vmulps zmm8, zmm10, zmm0
    vpsrld zmm18, zmm5, 18
    vpsrld zmm13, zmm5, 23
    vgetmantps zmm9, zmm5, 4
    vmulps zmm4, zmm14, zmm19
    vpternlogd zmm16, zmm21, [rsp], 184
    vfmsub213ps zmm15, zmm12, zmm25
    vpermi2ps zmm13, zmm31, zmm30
    vmovaps zmm2, zmm18
    vpermi2ps zmm2, zmm29, zmm28
    vpternlogd zmm17, zmm21, [rsp+64], 184
    vfmadd213ps zmm1, zmm0, zmm24
    vpermi2ps zmm18, zmm27, zmm26
    vpternlogd zmm20, zmm21, [rsp+128], 184
    vmovups zmm7, [rsp+4608]
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+0)], zmm16
    vpmaxud zmm3, zmm16, zmm17
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+64)], zmm17
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+128)], zmm20
    vmovaps zmm6, zmm23
    jmp .j448
.j448:
    vfmadd231ps zmm6, zmm22, zmm15
    vmulps zmm11, zmm4, zmm15
    vpmaxud zmm5, zmm3, zmm20
    vfmadd231ps zmm10, zmm8, zmm1
    vmulps zmm14, zmm13, zmm2
    vfmsub213ps zmm9, zmm18, zmm25
    vpsrld zmm19, zmm7, 18
    vpsrld zmm12, zmm7, 23
    vmovups zmm0, [rsp+4672]
    vpminsd zmm16, zmm5, [c_zero]{1to16}
    vgetmantps zmm17, zmm7, 4
    vfmadd213ps zmm6, zmm15, zmm24
    vpermi2ps zmm12, zmm31, zmm30
    vmovaps zmm3, zmm19
    vpermi2ps zmm3, zmm29, zmm28
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+192)], zmm16
    vpternlogd zmm10, zmm21, [rsp+768], 184
    vpermi2ps zmm19, zmm27, zmm26
    vmovaps zmm20, zmm23
    vfmadd231ps zmm20, zmm22, zmm9
    vmulps zmm8, zmm14, zmm9
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+0)], zmm10
    vpsrld zmm1, zmm0, 18
    vpsrld zmm13, zmm0, 23
    vgetmantps zmm2, zmm0, 4
    vmovups zmm18, [rsp+4736]
    vfmadd231ps zmm4, zmm11, zmm6
    vmulps zmm5, zmm12, zmm3
    vpermi2ps zmm13, zmm31, zmm30
    vmovaps zmm7, zmm1
    vpermi2ps zmm7, zmm29, zmm28
    vfmadd213ps zmm20, zmm9, zmm24
    vfmsub213ps zmm17, zmm19, zmm25
    vpermi2ps zmm1, zmm27, zmm26
    vpternlogd zmm4, zmm21, [rsp+832], 184
    vpsrld zmm15, zmm18, 18
    vpsrld zmm16, zmm18, 23
    vgetmantps zmm0, zmm18, 4
    vfmadd231ps zmm14, zmm8, zmm20
    vmovaps zmm11, zmm23
    vfmadd231ps zmm11, zmm22, zmm17
    vpmaxud zmm6, zmm10, zmm4
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+64)], zmm4
    vmulps zmm12, zmm5, zmm17
    vmulps zmm3, zmm13, zmm7
    vpermi2ps zmm16, zmm31, zmm30
    vfmsub213ps zmm2, zmm1, zmm25
    vmovaps zmm9, zmm15
    vpermi2ps zmm9, zmm29, zmm28
    vpermi2ps zmm15, zmm27, zmm26
    vmovups zmm19, [rsp+5376]
    vpternlogd zmm14, zmm21, [rsp+896], 184
    vfmadd213ps zmm11, zmm17, zmm24
    vmovaps zmm18, zmm23
    vfmadd231ps zmm18, zmm22, zmm2
    vmulps zmm8, zmm3, zmm2
    vpmaxud zmm20, zmm6, zmm14
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+128)], zmm14
    vmulps zmm10, zmm16, zmm9
    vfmsub213ps zmm0, zmm15, zmm25
    vpsrld zmm4, zmm19, 18
    vpsrld zmm13, zmm19, 23
    vgetmantps zmm7, zmm19, 4
    vmovups zmm1, [rsp+5440]
    jmp .j512
.j512:
    vpminsd zmm17, zmm20, [c_zero]{1to16}
    vfmadd231ps zmm5, zmm12, zmm11
    vmovaps zmm6, zmm4
    vpermi2ps zmm6, zmm29, zmm28
    vpermi2ps zmm4, zmm27, zmm26
    vpermi2ps zmm13, zmm31, zmm30
    vfmadd213ps zmm18, zmm2, zmm24
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+192)], zmm17
    vmovaps zmm14, zmm23
    vfmadd231ps zmm14, zmm22, zmm0
    vmulps zmm16, zmm10, zmm0
    vpsrld zmm9, zmm1, 18
    vpsrld zmm15, zmm1, 23
    vpternlogd zmm5, zmm21, [rsp+1536], 184
    vgetmantps zmm19, zmm1, 4
    vmovups zmm20, [rsp+5504]
    vfmsub213ps zmm7, zmm4, zmm25
    vfmadd231ps zmm3, zmm8, zmm18
    vmulps zmm12, zmm13, zmm6
    vpermi2ps zmm15, zmm31, zmm30
    vfmadd213ps zmm14, zmm0, zmm24
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+0)], zmm5
    vmovaps zmm11, zmm9
    vpermi2ps zmm11, zmm29, zmm28
    vpermi2ps zmm9, zmm27, zmm26
    vmovaps zmm2, zmm23
    vfmadd231ps zmm2, zmm22, zmm7
    vmulps zmm17, zmm12, zmm7
    vpsrld zmm1, zmm20, 18
    vpsrld zmm4, zmm20, 23
    vpternlogd zmm3, zmm21, [rsp+1600], 184
    vgetmantps zmm8, zmm20, 4
    vfmadd231ps zmm10, zmm16, zmm14
    vmulps zmm18, zmm15, zmm11
    vfmsub213ps zmm19, zmm9, zmm25
    vpermi2ps zmm4, zmm31, zmm30
    vpmaxud zmm13, zmm5, zmm3
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+64)], zmm3
    vmovaps zmm6, zmm1
    vpermi2ps zmm6, zmm29, zmm28
    vpermi2ps zmm1, zmm27, zmm26
    vfmadd213ps zmm2, zmm7, zmm24
    vpternlogd zmm10, zmm21, [rsp+1664], 184
    vmovaps zmm0, zmm23
    vfmadd231ps zmm0, zmm22, zmm19
    vmulps zmm20, zmm18, zmm19
    vpmaxud zmm16, zmm13, zmm10
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+128)], zmm10
    vmulps zmm14, zmm4, zmm6
    vfmsub231ps zmm25, zmm8, zmm1
    vfmadd231ps zmm12, zmm17, zmm2
    vpminsd zmm15, zmm16, [c_zero]{1to16}
    vfmadd213ps zmm0, zmm19, zmm24
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+192)], zmm15
    vfmadd231ps zmm23, zmm22, zmm25
    vmulps zmm11, zmm14, zmm25
    vpternlogd zmm12, zmm21, [rsp+2304], 184
    vfmadd231ps zmm18, zmm20, zmm0
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+0)], zmm12
    vfmadd231ps zmm24, zmm23, zmm25
    vpternlogd zmm18, zmm21, [rsp+2368], 184
    vfmadd231ps zmm14, zmm11, zmm24
    vpmaxud zmm9, zmm12, zmm18
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+64)], zmm18
    jmp .j576
.j576:
    vpternlogd zmm14, zmm21, [rsp+2432], 184
    vpmaxud zmm5, zmm9, zmm14
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+128)], zmm14
    vpminsd zmm3, zmm5, [c_zero]{1to16}
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+192)], zmm3
    add r5, 512
    add r3, 32
    jnz .rz
    mov r1, [rsp + 11208]
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
    lea r13, [rsp + BMS]
    mov r14, r13
    %if FORMAT_ELF
    SECTION .note.GNU-stack
    %else
    SECTION .dry info
    %endif
..@s0:
    movzx r2d, word [r0 + CST*0+CRD*0 - 2]
    mov [r0 + CST*0+CRD*0], r2w
    mov [r0 + CST*0+CRD*0 + 2], r2w
    movzx r2d, word [r0 + CST*0+CRD*1 - 2]
    mov [r0 + CST*0+CRD*1], r2w
    mov [r0 + CST*0+CRD*1 + 2], r2w
    movzx r2d, word [r0 + CST*1+CRD*0 - 2]
    mov [r0 + CST*1+CRD*0], r2w
    mov [r0 + CST*1+CRD*0 + 2], r2w
    movzx r2d, word [r0 + CST*1+CRD*1 - 2]
    mov [r0 + CST*1+CRD*1], r2w
    mov [r0 + CST*1+CRD*1 + 2], r2w
    vpmovzxwd zmm0, [r0 + CST*0+CRD*0 - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8 + SPBC*0+0], zmm0
    vmovaps [r8 + SPBC*0+0 - 256], zmm1
    vpmovzxwd zmm0, [r0 + CST*0+CRD*1 - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8 + SPBC*0+64], zmm0
    vmovaps [r8 + SPBC*0+64 - 256], zmm1
    vpmovzxwd zmm0, [r0 + CST*1+CRD*0 - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8 + SPBC*1+0], zmm0
    vmovaps [r8 + SPBC*1+0 - 256], zmm1
    vpmovzxwd zmm0, [r0 + CST*1+CRD*1 - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8 + SPBC*1+64], zmm0
    vmovaps [r8 + SPBC*1+64 - 256], zmm1
    vpxord zmm0, zmm0, zmm0
    vmovaps [rsp + 10816], zmm0
    vmovaps [rsp + 10880], zmm0
    vmovaps [rsp + 10944], zmm0
    vmovaps [rsp + 11008], zmm0
    vmovups zmm0, [c_s2]
    vmovaps [rsp + 11072], zmm0
    mov r3, -(W/2)
..@s1:
    SECTION .text
    PN equ (64 - (($ - $$) + (..@s1 - ..@s0)) % 64) % 64
    times (PN >= 2) jmp strict short .period
    times (PN >= 2) * (PN - 2) int3
    times (PN == 1) nop
.period:
    movzx r2d, word [r0 + CST*0+CRD*0 - 2]
    mov [r0 + CST*0+CRD*0], r2w
    mov [r0 + CST*0+CRD*0 + 2], r2w
    movzx r2d, word [r0 + CST*0+CRD*1 - 2]
    mov [r0 + CST*0+CRD*1], r2w
    mov [r0 + CST*0+CRD*1 + 2], r2w
    movzx r2d, word [r0 + CST*1+CRD*0 - 2]
    mov [r0 + CST*1+CRD*0], r2w
    mov [r0 + CST*1+CRD*0 + 2], r2w
    movzx r2d, word [r0 + CST*1+CRD*1 - 2]
    mov [r0 + CST*1+CRD*1], r2w
    mov [r0 + CST*1+CRD*1 + 2], r2w
    vpmovzxwd zmm0, [r0 + CST*0+CRD*0 - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8 + SPBC*0+0], zmm0
    vmovaps [r8 + SPBC*0+0 - 256], zmm1
    vpmovzxwd zmm0, [r0 + CST*0+CRD*1 - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8 + SPBC*0+64], zmm0
    vmovaps [r8 + SPBC*0+64 - 256], zmm1
    vpmovzxwd zmm0, [r0 + CST*1+CRD*0 - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8 + SPBC*1+0], zmm0
    vmovaps [r8 + SPBC*1+0 - 256], zmm1
    vpmovzxwd zmm0, [r0 + CST*1+CRD*1 - W]
    vpsubd zmm0, zmm0, [c_i512]{1to16}
    vcvtdq2ps zmm0, zmm0
    vbroadcastss zmm1, xmm0
    vmovaps [r8 + SPBC*1+64], zmm0
    vmovaps [r8 + SPBC*1+64 - 256], zmm1
    vpxord zmm0, zmm0, zmm0
    vmovaps [rsp + 10816], zmm0
    vmovaps [rsp + 10880], zmm0
    vmovaps [rsp + 10944], zmm0
    vmovaps [rsp + 11008], zmm0
    vmovups zmm0, [c_s2]
    vmovaps [rsp + 11072], zmm0
    mov r3, -(W/2)
    ALIGN 64
.pair:
.g_b1a:
    vbroadcastss zmm31, [c_absm]
    vbroadcastss zmm30, [c_rgl]
    vbroadcastss zmm29, [c_xll]
    vbroadcastss zmm28, [c_nieq]
    vbroadcastss zmm27, [c_eqp]
    vbroadcastss zmm0, [c_anl]
    vbroadcastss zmm1, [c_tbl]
    vmovaps zmm2, zmm28
    vmovups zmm3, [r14]
    vmovups zmm4, [r14+64]
    vmovups zmm5, [r14+128]
    vbroadcastss zmm6, [c_anl]
    vbroadcastss zmm7, [c_tbl]
    vmovups zmm8, [r14+256]
    vmovaps zmm9, zmm28
    vmovups zmm10, [r14+320]
    vmovups zmm11, [r14+384]
    vfnmadd231ps zmm1, zmm0, [r14+192]
    vandps zmm12, zmm3, zmm31
    vandps zmm13, zmm4, zmm31
    vandps zmm14, zmm5, zmm31
    vfnmadd231ps zmm7, zmm6, [r14+448]
    vmovaps zmm15, zmm1
    vfnmsub231ps zmm15, zmm30, zmm12
    vmovaps zmm16, zmm1
    vfnmsub231ps zmm16, zmm30, zmm13
    vfnmsub231ps zmm1, zmm30, zmm14
    vmovaps zmm17, zmm28
    vaddps zmm18, zmm12, zmm15
    vsubps zmm19, zmm15, zmm12
    vaddps zmm20, zmm13, zmm16
    vsubps zmm21, zmm16, zmm13
    vbroadcastss zmm22, [c_anl]
    vaddps zmm23, zmm14, zmm1
    vsubps zmm24, zmm1, zmm14
    vbroadcastss zmm25, [c_tbl]
    vmovups zmm26, [r14+512]
    vmovups zmm0, [r14+576]
    vmovups zmm3, [r14+640]
    vandps zmm4, zmm8, zmm31
    vcmpps k1, zmm18, zmm29, 30
    vrcp14ps zmm5, zmm18
    vcmpps k2, zmm20, zmm29, 30
    vrcp14ps zmm6, zmm20
    vcmpps k3, zmm23, zmm29, 30
    vrcp14ps zmm8, zmm23
    vmovaps zmm18, zmm7
    vfnmsub231ps zmm18, zmm30, zmm4
    vmovaps zmm20, zmm28
    vandps zmm23, zmm10, zmm31
    vfnmadd231ps zmm25, zmm22, [r14+704]
    vmovaps zmm10, zmm7
    vfnmsub231ps zmm10, zmm30, zmm23
    vblendmps zmm22{k1}, zmm19, zmm12
    vmulps zmm2{k1}, zmm15, zmm5
    vaddps zmm19, zmm4, zmm18
    vsubps zmm12, zmm18, zmm4
    vblendmps zmm15{k2}, zmm21, zmm13
    vmulps zmm9{k2}, zmm16, zmm6
    jmp .j640
    ALIGN 64
.j640:
    vmovaps zmm5, zmm28
    vblendmps zmm21{k3}, zmm24, zmm14
    vmulps zmm17{k3}, zmm1, zmm8
    vmovaps [rsp+6208], zmm22
    vandps zmm13, zmm11, zmm31
    vmovaps [rsp+6400], zmm15
    vcmpps k4, zmm19, zmm29, 30
    vrcp14ps zmm16, zmm19
    vaddps zmm6, zmm23, zmm10
    vfnmadd213ps zmm2, zmm27, [c_oml0]{1to16}
    vmovaps [rsp+6592], zmm21
    vsubps zmm24, zmm10, zmm23
    vfnmadd213ps zmm9, zmm27, [c_oml1]{1to16}
    vfnmsub231ps zmm7, zmm30, zmm13
    vmovaps zmm14, zmm28
    vfnmadd213ps zmm17, zmm27, [c_oml2]{1to16}
    vbroadcastss zmm1, [c_anl]
    vcmpps k5, zmm6, zmm29, 30
    vrcp14ps zmm8, zmm6
    vbroadcastss zmm22, [c_tbl]
    vmovups zmm11, [r14+768]
    vmovups zmm15, [r14+832]
    vmovups zmm19, [r14+896]
    vandps zmm21, zmm26, zmm31
    vmovaps [rsp+6272], zmm2
    vmovaps [rsp+6464], zmm9
    vblendmps zmm6{k4}, zmm12, zmm4
    vmulps zmm20{k4}, zmm18, zmm16
    vaddps zmm26, zmm13, zmm7
    vsubps zmm2, zmm7, zmm13
    vmovaps [rsp+6656], zmm17
    vmovaps zmm9, zmm25
    vfnmsub231ps zmm9, zmm30, zmm21
    vmovaps zmm12, zmm28
    vandps zmm4, zmm0, zmm31
    vmovaps [rsp+6784], zmm6
    vfnmadd231ps zmm22, zmm1, [r14+960]
    vblendmps zmm18{k5}, zmm24, zmm23
    vmulps zmm5{k5}, zmm10, zmm8
    vcmpps k6, zmm26, zmm29, 30
    vrcp14ps zmm16, zmm26
    vfnmadd213ps zmm20, zmm27, [c_oml0]{1to16}
    vmovaps zmm17, zmm25
    vfnmsub231ps zmm17, zmm30, zmm4
    vmovaps zmm0, zmm28
    vmovaps [rsp+6976], zmm18
    vaddps zmm6, zmm21, zmm9
    vsubps zmm1, zmm9, zmm21
    vandps zmm24, zmm3, zmm31
    vfnmadd213ps zmm5, zmm27, [c_oml1]{1to16}
    vmovaps [rsp+6848], zmm20
    vcmpps k7, zmm6, zmm29, 30
    vrcp14ps zmm23, zmm6
    vaddps zmm10, zmm4, zmm17
    vfnmsub231ps zmm25, zmm30, zmm24
    vblendmps zmm8{k6}, zmm2, zmm13
    vmulps zmm14{k6}, zmm7, zmm16
    vsubps zmm26, zmm17, zmm4
    vmovaps zmm18, zmm28
    vbroadcastss zmm3, [c_anh]
    vbroadcastss zmm20, [c_tbh]
    vmovaps [rsp+7040], zmm5
    vcmpps k1, zmm10, zmm29, 30
    vrcp14ps zmm6, zmm10
    jmp .j704
    ALIGN 64
.j704:
    vmovaps [rsp+7168], zmm8
    vmovups zmm2, [r14+1024]
    vmovups zmm13, [r14+1088]
    vfnmadd213ps zmm14, zmm27, [c_oml2]{1to16}
    vaddps zmm7, zmm24, zmm25
    vsubps zmm16, zmm25, zmm24
    vmovups zmm5, [r14+1152]
    vandps zmm10, zmm11, zmm31
    vmovaps zmm8, zmm28
    vblendmps zmm11{k7}, zmm1, zmm21
    vmulps zmm12{k7}, zmm9, zmm23
    vmovaps zmm1, zmm22
    vfnmsub231ps zmm1, zmm30, zmm10
    vcmpps k2, zmm7, zmm29, 30
    vrcp14ps zmm21, zmm7
    vfnmadd231ps zmm20, zmm3, [r14+1216]
    vmovaps [rsp+7360], zmm11
    vandps zmm9, zmm15, zmm31
    vmovaps [rsp+7232], zmm14
    vblendmps zmm23{k1}, zmm26, zmm4
    vmulps zmm0{k1}, zmm17, zmm6
    vfnmadd213ps zmm12, zmm27, [c_oml0]{1to16}
    vmovaps zmm7, zmm28
    vmovaps zmm3, zmm22
    vfnmsub231ps zmm3, zmm30, zmm9
    vmovaps [rsp+7552], zmm23
    vaddps zmm11, zmm10, zmm1
    vsubps zmm15, zmm1, zmm10
    vandps zmm14, zmm19, zmm31
    vfnmadd213ps zmm0, zmm27, [c_oml1]{1to16}
    vblendmps zmm26{k2}, zmm16, zmm24
    vmulps zmm18{k2}, zmm25, zmm21
    vmovaps [rsp+7424], zmm12
    vcmpps k3, zmm11, zmm29, 30
    vrcp14ps zmm4, zmm11
    vfnmsub231ps zmm22, zmm30, zmm14
    vaddps zmm17, zmm9, zmm3
    vsubps zmm6, zmm3, zmm9
    vmovaps zmm23, zmm28
    vmovaps [rsp+7744], zmm26
    vandps zmm19, zmm2, zmm31
    vmovaps [rsp+7616], zmm0
    vfnmadd213ps zmm18, zmm27, [c_oml2]{1to16}
    vcmpps k4, zmm17, zmm29, 30
    vrcp14ps zmm16, zmm17
    vmovaps zmm24, zmm20
    vfnmsub231ps zmm24, zmm19, [c_rgh]{1to16}
    vaddps zmm25, zmm14, zmm22
    vsubps zmm21, zmm22, zmm14
    vmovaps zmm12, zmm28
    vblendmps zmm11{k3}, zmm15, zmm10
    vmulps zmm8{k3}, zmm1, zmm4
    vandps zmm26, zmm13, zmm31
    vmovaps [rsp+7808], zmm18
    vcmpps k5, zmm25, zmm29, 30
    vrcp14ps zmm2, zmm25
    vmovaps [rsp+7936], zmm11
    vaddps zmm0, zmm19, zmm24
    vsubps zmm17, zmm24, zmm19
    vmovaps zmm15, zmm20
    vfnmsub231ps zmm15, zmm26, [c_rgh]{1to16}
    vmovaps zmm10, zmm28
    vfnmadd213ps zmm8, zmm27, [c_oml0]{1to16}
    vblendmps zmm1{k4}, zmm6, zmm9
    jmp .j768
    ALIGN 64
.j768:
    vmulps zmm7{k4}, zmm3, zmm16
    vandps zmm4, zmm5, zmm31
    vcmpps k6, zmm0, [c_xlh]{1to16}, 30
    vrcp14ps zmm13, zmm0
    vmovaps [rsp+8128], zmm1
    vfnmsub231ps zmm20, zmm4, [c_rgh]{1to16}
    vfnmadd213ps zmm7, zmm27, [c_oml1]{1to16}
    vblendmps zmm18{k5}, zmm21, zmm14
    vmulps zmm23{k5}, zmm22, zmm2
    vaddps zmm25, zmm26, zmm15
    vmovaps [rsp+8000], zmm8
    vsubps zmm11, zmm15, zmm26
    vmovaps zmm6, zmm28
    vmovaps [rsp+8320], zmm18
    vcmpps k7, zmm25, [c_xlh]{1to16}, 30
    vrcp14ps zmm9, zmm25
    vfnmadd213ps zmm23, zmm27, [c_oml2]{1to16}
    vblendmps zmm3{k6}, zmm17, zmm19
    vmulps zmm12{k6}, zmm24, zmm13
    vaddps zmm16, zmm4, zmm20
    vmovaps [rsp+8192], zmm7
    vsubps zmm5, zmm20, zmm4
    vmovaps [rsp+8512], zmm3
    vcmpps k1, zmm16, [c_xlh]{1to16}, 30
    vrcp14ps zmm0, zmm16
    vfnmadd213ps zmm12, zmm27, [c_omh0]{1to16}
    vmovaps [rsp+8384], zmm23
    vblendmps zmm1{k7}, zmm11, zmm26
    vmulps zmm10{k7}, zmm15, zmm9
    vmovaps [rsp+8704], zmm1
    vmovaps [rsp+8576], zmm12
    vfnmadd213ps zmm10, zmm27, [c_omh1]{1to16}
    vblendmps zmm21{k1}, zmm5, zmm4
    vmulps zmm6{k1}, zmm20, zmm0
    vmovaps [rsp+8896], zmm21
    vfnmadd213ps zmm27, zmm6, [c_omh2]{1to16}
    vmovaps [rsp+8768], zmm10
    vmovaps [rsp+8960], zmm27
.g_v:
    vbroadcastss zmm31, [c_h0625]
    vbroadcastss zmm30, [c_h5625]
    vbroadcastss zmm29, [c_krh]
    vbroadcastss zmm28, [c_krl]
    vbroadcastss zmm27, [c_grh]
    vbroadcastss zmm26, [c_grl]
    vbroadcastss zmm25, [c_gbh]
    vbroadcastss zmm24, [c_gbl]
    vbroadcastss zmm23, [c_kbh]
    vbroadcastss zmm22, [c_kbl]
    vmovups zmm21, [c_n64w]
    vbroadcastss zmm20, [c_ffff]
    vmovups zmm0, [r5]
    vmovups zmm1, [r5+(0+SPBC)]
    vmovups zmm2, [r7]
    vmovups zmm3, [r5+64]
    vmovups zmm4, [r5+(64+SPBC)]
    vmovups zmm5, [r7+64]
    vaddps zmm6, zmm0, zmm1
    vaddps zmm7, zmm0, [r7+(0+SPBC)]
    vaddps zmm8, zmm2, [r4+(0+SPBC)]
    vaddps zmm9, zmm1, zmm2
    vaddps zmm10, zmm3, zmm4
    vaddps zmm11, zmm5, [r4+(64+SPBC)]
    vmovups zmm12, [r1+r3*4+(0+2*W*0)]
    vaddps zmm13, zmm4, zmm5
    jmp .j832
    ALIGN 64
.j832:
    vaddps zmm14, zmm3, [r7+(64+SPBC)]
    vmulps zmm15, zmm31, zmm7
    vmulps zmm16, zmm31, zmm8
    vmulps zmm17, zmm31, zmm11
    vmulps zmm18, zmm31, zmm14
    vmulps zmm19, zmm0, zmm24
    vfmsub231ps zmm15, zmm30, zmm9
    vpsubw zmm2, zmm12, zmm21
    vfmsub231ps zmm16, zmm30, zmm6
    vfmsub231ps zmm17, zmm30, zmm10
    vfmsub231ps zmm18, zmm30, zmm13
    vpsrad zmm5, zmm2, 16
    vpternlogd zmm2, zmm20, [c_lo16]{1to16}, 106
    vfmadd231ps zmm19, zmm3, zmm26
    vmovups zmm7, [r1+r3*4+(0+2*W*1)]
    vcvtdq2ps zmm8, zmm5
    vsubps zmm11, zmm2, [c_lo16]{1to16}
    vmovaps zmm14, zmm11
    vfmadd231ps zmm14, zmm3, zmm29
    vmovaps zmm9, zmm11
    vfnmadd231ps zmm9, zmm3, zmm27
    vfmadd231ps zmm11, zmm0, zmm23
    vpsubw zmm12, zmm7, zmm21
    vpsrad zmm6, zmm12, 16
    vpternlogd zmm12, zmm20, [c_lo16]{1to16}, 106
    vmulps zmm10, zmm16, zmm24
    vfmadd231ps zmm14, zmm3, zmm28
    vfnmadd231ps zmm9, zmm0, zmm25
    vfmadd231ps zmm11, zmm0, zmm22
    vcvtdq2ps zmm13, zmm6
    vsubps zmm5, zmm12, [c_lo16]{1to16}
    vfmadd231ps zmm10, zmm17, zmm26
    vmovaps zmm2, zmm5
    vfmadd231ps zmm2, zmm17, zmm29
    vmovaps zmm7, zmm5
    vfnmadd231ps zmm7, zmm17, zmm27
    vsubps zmm3, zmm9, zmm19
    vmovaps [rsp], zmm14
    vfmadd231ps zmm5, zmm16, zmm23
    vmovups zmm0, [r1+r3*4+(0+2*W*2)]
    vmovaps [rsp+128], zmm11
    vmovaps [rsp+64], zmm3
    vfmadd231ps zmm2, zmm17, zmm28
    vfnmadd231ps zmm7, zmm16, zmm25
    vfmadd231ps zmm5, zmm16, zmm22
    vpsubw zmm6, zmm0, zmm21
    vmulps zmm12, zmm1, zmm24
    vpsrad zmm9, zmm6, 16
    vpternlogd zmm6, zmm20, [c_lo16]{1to16}, 106
    vsubps zmm19, zmm7, zmm10
    vmovaps [rsp+192], zmm2
    vmovaps [rsp+320], zmm5
    vfmadd231ps zmm12, zmm4, zmm26
    vcvtdq2ps zmm14, zmm9
    vsubps zmm11, zmm6, [c_lo16]{1to16}
    vmovups zmm3, [r1+r3*4+(0+2*W*3)]
    vmovaps [rsp+256], zmm19
    vmovaps zmm17, zmm11
    vfmadd231ps zmm17, zmm4, zmm29
    vmovaps zmm16, zmm11
    vfnmadd231ps zmm16, zmm4, zmm27
    vfmadd231ps zmm11, zmm1, zmm23
    vpsubw zmm0, zmm3, zmm21
    vfmadd231ps zmm17, zmm4, zmm28
    jmp .j896
    ALIGN 64
.j896:
    vfnmadd231ps zmm16, zmm1, zmm25
    vpsrad zmm7, zmm0, 16
    vpternlogd zmm0, zmm20, [c_lo16]{1to16}, 106
    vfmadd231ps zmm11, zmm1, zmm22
    vmulps zmm10, zmm15, zmm24
    vcvtdq2ps zmm2, zmm7
    vsubps zmm5, zmm0, [c_lo16]{1to16}
    vsubps zmm9, zmm16, zmm12
    vmovaps [rsp+384], zmm17
    vfmadd231ps zmm10, zmm18, zmm26
    vmovaps [rsp+512], zmm11
    vmovaps zmm6, zmm5
    vfmadd231ps zmm6, zmm18, zmm29
    vmovaps zmm19, zmm5
    vfnmadd231ps zmm19, zmm18, zmm27
    vmovups zmm3, [r5+128]
    vmovups zmm4, [r5+(128+SPBC)]
    vfmadd231ps zmm5, zmm15, zmm23
    vmovups zmm1, [r7+128]
    vmovaps [rsp+448], zmm9
    vfmadd231ps zmm6, zmm18, zmm28
    vfnmadd231ps zmm19, zmm15, zmm25
    vfmadd231ps zmm5, zmm15, zmm22
    vaddps zmm7, zmm3, zmm4
    vaddps zmm0, zmm3, [r7+(128+SPBC)]
    vmovups zmm16, [r5+192]
    vaddps zmm12, zmm1, [r4+(128+SPBC)]
    vaddps zmm17, zmm4, zmm1
    vmovups zmm11, [r5+(192+SPBC)]
    vmovups zmm9, [r7+192]
    vmulps zmm18, zmm31, zmm0
    vsubps zmm15, zmm19, zmm10
    vmovaps [rsp+576], zmm6
    vmulps zmm1, zmm31, zmm12
    vmovaps [rsp+704], zmm5
    vaddps zmm0, zmm16, [r7+(192+SPBC)]
    vmovaps zmm19, zmm8
    vfmadd231ps zmm19, zmm16, zmm29
    vmovaps zmm10, zmm8
    vfnmadd231ps zmm10, zmm16, zmm27
    vaddps zmm6, zmm16, zmm11
    vmulps zmm12, zmm3, zmm24
    vmovaps [rsp+640], zmm15
    vfmsub231ps zmm18, zmm30, zmm17
    vaddps zmm5, zmm9, [r4+(192+SPBC)]
    vaddps zmm15, zmm11, zmm9
    vfmadd231ps zmm8, zmm3, zmm23
    vfmsub231ps zmm1, zmm30, zmm7
    vmulps zmm17, zmm31, zmm0
    vmulps zmm9, zmm31, zmm5
    vfmadd231ps zmm19, zmm16, zmm28
    vfnmadd231ps zmm10, zmm3, zmm25
    vfmadd231ps zmm12, zmm16, zmm26
    vfmadd231ps zmm8, zmm3, zmm22
    vfmsub231ps zmm17, zmm30, zmm15
    vmulps zmm7, zmm1, zmm24
    vmovaps zmm0, zmm13
    vfmadd231ps zmm0, zmm1, zmm23
    vfmsub231ps zmm9, zmm30, zmm6
    vmovaps [rsp+768], zmm19
    vsubps zmm5, zmm10, zmm12
    vmovaps zmm16, zmm14
    vfmadd231ps zmm16, zmm11, zmm29
    vmovaps [rsp+896], zmm8
    jmp .j960
    ALIGN 64
.j960:
    vmovaps zmm3, zmm14
    vfnmadd231ps zmm3, zmm11, zmm27
    vmulps zmm15, zmm4, zmm24
    vfmadd231ps zmm0, zmm1, zmm22
    vmovaps [rsp+832], zmm5
    vmovaps zmm6, zmm13
    vfmadd231ps zmm6, zmm9, zmm29
    vfnmadd231ps zmm13, zmm9, zmm27
    vfmadd231ps zmm7, zmm9, zmm26
    vfmadd231ps zmm14, zmm4, zmm23
    vfmadd231ps zmm16, zmm11, zmm28
    vfnmadd231ps zmm3, zmm4, zmm25
    vfmadd231ps zmm15, zmm11, zmm26
    vmovaps zmm19, zmm2
    vfmadd231ps zmm19, zmm17, zmm29
    vmovaps zmm10, zmm2
    vfnmadd231ps zmm10, zmm17, zmm27
    vmovaps [rsp+1088], zmm0
    vmulps zmm12, zmm18, zmm24
    vfmadd231ps zmm6, zmm9, zmm28
    vfnmadd231ps zmm13, zmm1, zmm25
    vfmadd231ps zmm14, zmm4, zmm22
    vfmadd231ps zmm2, zmm18, zmm23
    vmovaps [rsp+1152], zmm16
    vsubps zmm8, zmm3, zmm15
    vfmadd231ps zmm19, zmm17, zmm28
    vfnmadd231ps zmm10, zmm18, zmm25
    vmovups zmm5, [r5+256]
    vfmadd231ps zmm12, zmm17, zmm26
    vmovups zmm11, [r5+(256+SPBC)]
    vmovups zmm0, [r7+256]
    vsubps zmm9, zmm13, zmm7
    vmovaps [rsp+960], zmm6
    vmovaps [rsp+1216], zmm8
    vfmadd231ps zmm2, zmm18, zmm22
    vmovaps [rsp+1280], zmm14
    vmovups zmm1, [r5+320]
    vmovaps [rsp+1024], zmm9
    vmovups zmm4, [r5+(320+SPBC)]
    vsubps zmm16, zmm10, zmm12
    vmovaps [rsp+1344], zmm19
    vaddps zmm3, zmm5, [r7+(256+SPBC)]
    vmovups zmm15, [r7+320]
    vaddps zmm17, zmm5, zmm11
    vaddps zmm13, zmm0, [r4+(256+SPBC)]
    vmovaps [rsp+1472], zmm2
    vaddps zmm7, zmm11, zmm0
    vmovups zmm6, [r1+r3*4+(64+2*W*0)]
    vmovaps [rsp+1408], zmm16
    vmulps zmm8, zmm31, zmm3
    vmulps zmm18, zmm31, zmm13
    vaddps zmm14, zmm1, [r7+(320+SPBC)]
    vaddps zmm9, zmm1, zmm4
    vaddps zmm10, zmm15, [r4+(320+SPBC)]
    vaddps zmm12, zmm4, zmm15
    vfmsub231ps zmm8, zmm30, zmm7
    vmulps zmm19, zmm31, zmm14
    vfmsub231ps zmm18, zmm30, zmm17
    vpsubw zmm2, zmm6, zmm21
    vmulps zmm0, zmm5, zmm24
    vmulps zmm16, zmm31, zmm10
    vpsrad zmm3, zmm2, 16
    vpternlogd zmm2, zmm20, [c_lo16]{1to16}, 106
    vfmsub231ps zmm19, zmm30, zmm12
    jmp .j1024
    ALIGN 64
.j1024:
    vfmadd231ps zmm0, zmm1, zmm26
    vfmsub231ps zmm16, zmm30, zmm9
    vcvtdq2ps zmm13, zmm3
    vsubps zmm15, zmm2, [c_lo16]{1to16}
    vmovups zmm7, [r1+r3*4+(64+2*W*1)]
    vmovaps zmm14, zmm15
    vfmadd231ps zmm14, zmm1, zmm29
    vmovaps zmm17, zmm15
    vfnmadd231ps zmm17, zmm1, zmm27
    vfmadd231ps zmm15, zmm5, zmm23
    vpsubw zmm6, zmm7, zmm21
    vfmadd231ps zmm14, zmm1, zmm28
    vfnmadd231ps zmm17, zmm5, zmm25
    vpsrad zmm10, zmm6, 16
    vpternlogd zmm6, zmm20, [c_lo16]{1to16}, 106
    vfmadd231ps zmm15, zmm5, zmm22
    vmulps zmm12, zmm18, zmm24
    vcvtdq2ps zmm9, zmm10
    vsubps zmm3, zmm6, [c_lo16]{1to16}
    vsubps zmm2, zmm17, zmm0
    vmovaps [rsp+1536], zmm14
    vfmadd231ps zmm12, zmm16, zmm26
    vmovaps [rsp+1664], zmm15
    vmovaps zmm7, zmm3
    vfmadd231ps zmm7, zmm16, zmm29
    vmovaps zmm1, zmm3
    vfnmadd231ps zmm1, zmm16, zmm27
    vmovups zmm5, [r1+r3*4+(64+2*W*2)]
    vfmadd231ps zmm3, zmm18, zmm23
    vmovaps [rsp+1600], zmm2
    vfmadd231ps zmm7, zmm16, zmm28
    vfnmadd231ps zmm1, zmm18, zmm25
    vfmadd231ps zmm3, zmm18, zmm22
    vpsubw zmm10, zmm5, zmm21
    vmulps zmm6, zmm11, zmm24
    vpsrad zmm17, zmm10, 16
    vpternlogd zmm10, zmm20, [c_lo16]{1to16}, 106
    vsubps zmm0, zmm1, zmm12
    vmovaps [rsp+1728], zmm7
    vmovaps [rsp+1856], zmm3
    vcvtdq2ps zmm14, zmm17
    vsubps zmm15, zmm10, [c_lo16]{1to16}
    vfmadd231ps zmm6, zmm4, zmm26
    vmovups zmm2, [r1+r3*4+(64+2*W*3)]
    vmovaps [rsp+1792], zmm0
    vmovaps zmm16, zmm15
    vfmadd231ps zmm16, zmm4, zmm29
    vmovaps zmm18, zmm15
    vfnmadd231ps zmm18, zmm4, zmm27
    vfmadd231ps zmm15, zmm11, zmm23
    vpsubw zmm5, zmm2, zmm21
    vfmadd231ps zmm16, zmm4, zmm28
    vfnmadd231ps zmm18, zmm11, zmm25
    vfmadd231ps zmm15, zmm11, zmm22
    vpsrad zmm1, zmm5, 16
    vpternlogd zmm5, zmm20, [c_lo16]{1to16}, 106
    vmulps zmm12, zmm8, zmm24
    vcvtdq2ps zmm7, zmm1
    vsubps zmm3, zmm5, [c_lo16]{1to16}
    vsubps zmm17, zmm18, zmm6
    vmovaps [rsp+1920], zmm16
    vfmadd231ps zmm12, zmm19, zmm26
    vmovaps [rsp+2048], zmm15
    vmovups zmm10, [r5+384]
    jmp .j1088
    ALIGN 64
.j1088:
    vmovups zmm0, [r5+(384+SPBC)]
    vmovaps zmm2, zmm3
    vfmadd231ps zmm2, zmm19, zmm29
    vmovaps zmm4, zmm3
    vfnmadd231ps zmm4, zmm19, zmm27
    vmovups zmm11, [r7+384]
    vfmadd231ps zmm3, zmm8, zmm23
    vmovaps [rsp+1984], zmm17
    vfmadd231ps zmm2, zmm19, zmm28
    vfnmadd231ps zmm4, zmm8, zmm25
    vaddps zmm1, zmm10, zmm0
    vaddps zmm5, zmm10, [r7+(384+SPBC)]
    vfmadd231ps zmm3, zmm8, zmm22
    vaddps zmm18, zmm11, [r4+(384+SPBC)]
    vaddps zmm6, zmm0, zmm11
    vmovups zmm16, [r5+448]
    vmovups zmm15, [r5+(448+SPBC)]
    vmovups zmm17, [r7+448]
    vmulps zmm19, zmm31, zmm5
    vmulps zmm8, zmm31, zmm18
    vsubps zmm11, zmm4, zmm12
    vmovaps [rsp+2112], zmm2
    vmovaps [rsp+2240], zmm3
    vaddps zmm5, zmm16, [r7+(448+SPBC)]
    vmovaps zmm18, zmm13
    vfmadd231ps zmm18, zmm16, zmm29
    vmovaps zmm4, zmm13
    vfnmadd231ps zmm4, zmm16, zmm27
    vfmsub231ps zmm19, zmm30, zmm6
    vaddps zmm12, zmm16, zmm15
    vaddps zmm2, zmm17, [r4+(448+SPBC)]
    vmulps zmm3, zmm10, zmm24
    vmovaps [rsp+2176], zmm11
    vfmsub231ps zmm8, zmm30, zmm1
    vaddps zmm6, zmm15, zmm17
    vfmadd231ps zmm13, zmm10, zmm23
    vmulps zmm11, zmm31, zmm5
    vmulps zmm1, zmm31, zmm2
    vfmadd231ps zmm18, zmm16, zmm28
    vfnmadd231ps zmm4, zmm10, zmm25
    vfmadd231ps zmm3, zmm16, zmm26
    vfmadd231ps zmm13, zmm10, zmm22
    vmulps zmm17, zmm8, zmm24
    vfmsub231ps zmm11, zmm30, zmm6
    vmovaps zmm5, zmm9
    vfmadd231ps zmm5, zmm8, zmm23
    vfmsub231ps zmm1, zmm30, zmm12
    vmovaps [rsp+2304], zmm18
    vsubps zmm2, zmm4, zmm3
    vmovaps zmm16, zmm14
    vfmadd231ps zmm16, zmm15, zmm29
    vmovaps [rsp+2432], zmm13
    vmovaps zmm10, zmm14
    vfnmadd231ps zmm10, zmm15, zmm27
    vfmadd231ps zmm5, zmm8, zmm22
    vmulps zmm6, zmm0, zmm24
    vmovaps zmm12, zmm9
    vfmadd231ps zmm12, zmm1, zmm29
    vfnmadd231ps zmm9, zmm1, zmm27
    vmovaps [rsp+2368], zmm2
    vfmadd231ps zmm17, zmm1, zmm26
    vfmadd231ps zmm14, zmm0, zmm23
    vfmadd231ps zmm16, zmm15, zmm28
    vfnmadd231ps zmm10, zmm0, zmm25
    jmp .j1152
    ALIGN 64
.j1152:
    vfmadd231ps zmm6, zmm15, zmm26
    vmovaps [rsp+2624], zmm5
    vfmadd213ps zmm29, zmm11, zmm7
    vfnmadd213ps zmm27, zmm11, zmm7
    vfmadd231ps zmm12, zmm1, zmm28
    vfnmadd231ps zmm9, zmm8, zmm25
    vfmadd231ps zmm14, zmm0, zmm22
    vmulps zmm18, zmm19, zmm24
    vfmadd231ps zmm7, zmm19, zmm23
    vmovaps [rsp+2688], zmm16
    vsubps zmm4, zmm10, zmm6
    vfmadd231ps zmm29, zmm11, zmm28
    vfnmadd231ps zmm27, zmm19, zmm25
    vsubps zmm3, zmm9, zmm17
    vmovaps [rsp+2496], zmm12
    vfmadd231ps zmm18, zmm11, zmm26
    vmovaps [rsp+2816], zmm14
    vmovaps [rsp+2752], zmm4
    vfmadd231ps zmm7, zmm19, zmm22
    vmovaps [rsp+2560], zmm3
    vmovaps [rsp+2880], zmm29
    vsubps zmm13, zmm27, zmm18
    vmovaps [rsp+3008], zmm7
    vmovaps [rsp+2944], zmm13
.g_b1b_c:
    vmovups zmm31, [c_t1l]
    vmovups zmm30, [c_t1l+64]
    vmovups zmm29, [c_w1]
    vmovups zmm28, [c_w1+64]
    vmovups zmm27, [c_r1]
    vmovups zmm26, [c_r1+64]
    vbroadcastss zmm25, [c_xll]
    vbroadcastss zmm24, [c_one]
    vbroadcastss zmm23, [c_q10]
    vbroadcastss zmm22, [c_q11]
    vbroadcastss zmm21, [c_s1q]
    vbroadcastss zmm20, [c_c3]
    vbroadcastss zmm19, [c_h0625]
    vbroadcastss zmm18, [c_h5625]
    vbroadcastss zmm17, [c_i512]
    vmovups zmm0, [rsp+6208]
    vpmovzxwd zmm1, [r0+r3*2+(32+CST*0+CRD*0)]
    vpmovzxwd zmm2, [r0+r3*2+(64+CST*0+CRD*0)]
    vpsubd zmm3, zmm1, zmm17
    vrangeps zmm4, zmm0, zmm25, 11
    vpsrld zmm5, zmm0, 18
    vpsubd zmm6, zmm2, zmm17
    vgetmantps zmm7, zmm0, 4
    vmovups zmm8, [rsp+6400]
    vcvtdq2ps zmm9, zmm3
    vmovaps zmm10, zmm5
    vpermi2ps zmm10, zmm29, zmm28
    vpermi2ps zmm5, zmm27, zmm26
    vcvtdq2ps zmm11, zmm6
    vpsrld zmm12, zmm4, 23
    vmovups zmm13, [r8+(0+SPBC*0)]
    vpermi2ps zmm12, zmm31, zmm30
    vmovaps [r8+(256+0+SPBC*0)], zmm9
    vrangeps zmm14, zmm8, zmm25, 11
    vmovaps [r8+(512+0+SPBC*0)], zmm11
    vpsrld zmm15, zmm8, 18
    vgetmantps zmm16, zmm8, 4
    vfmsub213ps zmm7, zmm5, zmm24
    vmovaps zmm1, zmm15
    vpermi2ps zmm1, zmm29, zmm28
    jmp .j1216
    ALIGN 64
.j1216:
    valignd zmm2, zmm13, [r8+(-256+0+SPBC*0)], 15
    vpsrld zmm0, zmm14, 23
    vpermi2ps zmm15, zmm27, zmm26
    valignd zmm3, zmm9, zmm13, 1
    valignd zmm6, zmm9, zmm13, 2
    vmulps zmm4, zmm12, zmm10
    vmovups zmm8, [rsp+6592]
    vpermi2ps zmm0, zmm31, zmm30
    vmovaps zmm5, zmm23
    vfmadd231ps zmm5, zmm22, zmm7
    vmulps zmm14, zmm4, zmm7
    vfmsub213ps zmm16, zmm15, zmm24
    vaddps zmm12, zmm3, zmm13
    vaddps zmm10, zmm2, zmm6
    vrangeps zmm7, zmm8, zmm25, 11
    vpsrld zmm15, zmm8, 18
    vmulps zmm3, zmm0, zmm1
    vgetmantps zmm2, zmm8, 4
    vfmadd231ps zmm4, zmm14, zmm5
    vmulps zmm6, zmm10, zmm19
    vmovaps zmm0, zmm15
    vpermi2ps zmm0, zmm29, zmm28
    vmovaps zmm1, zmm23
    vfmadd231ps zmm1, zmm22, zmm16
    vpsrld zmm8, zmm7, 23
    vpermi2ps zmm15, zmm27, zmm26
    valignd zmm14, zmm9, zmm13, 15
    valignd zmm5, zmm11, zmm9, 1
    vmulps zmm10, zmm3, zmm16
    vpermi2ps zmm8, zmm31, zmm30
    vfmsub231ps zmm6, zmm12, zmm18
    valignd zmm7, zmm11, zmm9, 2
    vsubps zmm13, zmm21, zmm4
    vfmadd213ps zmm4, zmm20, zmm21
    vmovups zmm16, [rsp+6784]
    vfmadd231ps zmm3, zmm10, zmm1
    vfmsub213ps zmm2, zmm15, zmm24
    vaddps zmm12, zmm5, zmm9
    vmulps zmm11, zmm8, zmm0
    vmovaps [r8+(128+0+SPBC*0)], zmm6
    vdivps zmm10, zmm13, zmm4
    vaddps zmm1, zmm14, zmm7
    vrangeps zmm15, zmm16, zmm25, 11
    vpsrld zmm5, zmm16, 18
    vsubps zmm9, zmm21, zmm3
    vfmadd213ps zmm3, zmm20, zmm21
    vmovaps zmm8, zmm23
    vfmadd231ps zmm8, zmm22, zmm2
    vgetmantps zmm0, zmm16, 4
    vmulps zmm6, zmm11, zmm2
    vmovaps zmm13, zmm5
    vpermi2ps zmm13, zmm29, zmm28
    vmulps zmm4, zmm1, zmm19
    vpsrld zmm14, zmm15, 23
    vpermi2ps zmm5, zmm27, zmm26
    vpmovzxwd zmm7, [r0+r3*2+(32+CST*0+CRD*1)]
    vdivps zmm16, zmm9, zmm3
    vpermi2ps zmm14, zmm31, zmm30
    vfmadd231ps zmm11, zmm6, zmm8
    vfmsub231ps zmm4, zmm12, zmm18
    vmovups zmm2, [rsp+6976]
    vmovaps [rsp+6144], zmm10
    vfmsub213ps zmm0, zmm5, zmm24
    vpsubd zmm1, zmm7, zmm17
    jmp .j1280
    ALIGN 64
.j1280:
    vsubps zmm15, zmm21, zmm11
    vfmadd213ps zmm11, zmm20, zmm21
    vmulps zmm9, zmm14, zmm13
    vmovaps [r8+(384+0+SPBC*0)], zmm4
    vcvtdq2ps zmm3, zmm1
    vrangeps zmm6, zmm2, zmm25, 11
    vpsrld zmm8, zmm2, 18
    vpmovzxwd zmm12, [r0+r3*2+(64+CST*0+CRD*1)]
    vgetmantps zmm10, zmm2, 4
    vmovaps zmm5, zmm23
    vfmadd231ps zmm5, zmm22, zmm0
    vmovaps zmm7, zmm8
    vpermi2ps zmm7, zmm29, zmm28
    vpermi2ps zmm8, zmm27, zmm26
    vmovaps [rsp+6336], zmm16
    vmulps zmm14, zmm9, zmm0
    vpsrld zmm13, zmm6, 23
    vdivps zmm4, zmm15, zmm11
    vmovaps [r8+(256+64+SPBC*0)], zmm3
    vpsubd zmm1, zmm12, zmm17
    vmovups zmm2, [rsp+7168]
    vpermi2ps zmm13, zmm31, zmm30
    vmovups zmm16, [r8+(64+SPBC*0)]
    vfmadd231ps zmm9, zmm14, zmm5
    vcvtdq2ps zmm0, zmm1
    vfmsub213ps zmm10, zmm8, zmm24
    vrangeps zmm6, zmm2, zmm25, 11
    vpsrld zmm15, zmm2, 18
    vmulps zmm11, zmm13, zmm7
    vmovaps [r8+(512+64+SPBC*0)], zmm0
    valignd zmm12, zmm16, [r8+(-256+64+SPBC*0)], 15
    valignd zmm14, zmm3, zmm16, 1
    vsubps zmm5, zmm21, zmm9
    vfmadd213ps zmm9, zmm20, zmm21
    vgetmantps zmm1, zmm2, 4
    valignd zmm8, zmm3, zmm16, 2
    vmovaps zmm13, zmm23
    vfmadd231ps zmm13, zmm22, zmm10
    vmovaps zmm7, zmm15
    vpermi2ps zmm7, zmm29, zmm28
    vpermi2ps zmm15, zmm27, zmm26
    vmovaps [rsp+6528], zmm4
    vpsrld zmm2, zmm6, 23
    vmulps zmm4, zmm11, zmm10
    vpermi2ps zmm2, zmm31, zmm30
    vdivps zmm6, zmm5, zmm9
    vaddps zmm10, zmm14, zmm16
    vmovups zmm5, [rsp+7360]
    vaddps zmm9, zmm12, zmm8
    vfmsub213ps zmm1, zmm15, zmm24
    vfmadd231ps zmm11, zmm4, zmm13
    vmulps zmm14, zmm9, zmm19
    vmulps zmm12, zmm2, zmm7
    vrangeps zmm8, zmm5, zmm25, 11
    vpsrld zmm15, zmm5, 18
    vmovaps zmm4, zmm23
    vfmadd231ps zmm4, zmm22, zmm1
    vgetmantps zmm13, zmm5, 4
    valignd zmm9, zmm3, zmm16, 15
    vsubps zmm2, zmm21, zmm11
    vfmadd213ps zmm11, zmm20, zmm21
    valignd zmm7, zmm0, zmm3, 1
    vfmsub231ps zmm14, zmm10, zmm18
    vmovaps zmm5, zmm15
    jmp .j1344
    ALIGN 64
.j1344:
    vpermi2ps zmm5, zmm29, zmm28
    vpermi2ps zmm15, zmm27, zmm26
    vmulps zmm16, zmm12, zmm1
    vpsrld zmm10, zmm8, 23
    valignd zmm1, zmm0, zmm3, 2
    vmovaps [rsp+6720], zmm6
    vmovups zmm8, [rsp+7552]
    vpermi2ps zmm10, zmm31, zmm30
    vdivps zmm0, zmm2, zmm11
    vfmadd231ps zmm12, zmm16, zmm4
    vmovaps [r8+(128+64+SPBC*0)], zmm14
    vaddps zmm6, zmm7, zmm3
    vfmsub213ps zmm13, zmm15, zmm24
    vaddps zmm2, zmm9, zmm1
    vrangeps zmm11, zmm8, zmm25, 11
    vpsrld zmm16, zmm8, 18
    vmulps zmm4, zmm10, zmm5
    vgetmantps zmm14, zmm8, 4
    vsubps zmm7, zmm21, zmm12
    vfmadd213ps zmm12, zmm20, zmm21
    vmulps zmm3, zmm2, zmm19
    vmovaps zmm15, zmm23
    vfmadd231ps zmm15, zmm22, zmm13
    vmovaps zmm9, zmm16
    vpermi2ps zmm9, zmm29, zmm28
    vpermi2ps zmm16, zmm27, zmm26
    vpsrld zmm1, zmm11, 23
    vpmovzxwd zmm10, [r0+r3*2+(32+CST*1+CRD*0)]
    vmulps zmm5, zmm4, zmm13
    vmovaps [rsp+6912], zmm0
    vpermi2ps zmm1, zmm31, zmm30
    vfmsub231ps zmm3, zmm6, zmm18
    vdivps zmm8, zmm7, zmm12
    vmovups zmm2, [rsp+7744]
    vfmsub213ps zmm14, zmm16, zmm24
    vpsubd zmm11, zmm10, zmm17
    vfmadd231ps zmm4, zmm5, zmm15
    vmovaps [r8+(384+64+SPBC*0)], zmm3
    vcvtdq2ps zmm13, zmm11
    vmulps zmm0, zmm1, zmm9
    vpmovzxwd zmm6, [r0+r3*2+(64+CST*1+CRD*0)]
    vrangeps zmm7, zmm2, zmm25, 11
    vpsrld zmm12, zmm2, 18
    vmovaps zmm16, zmm23
    vfmadd231ps zmm16, zmm22, zmm14
    vgetmantps zmm10, zmm2, 4
    vsubps zmm5, zmm21, zmm4
    vfmadd213ps zmm4, zmm20, zmm21
    vmovaps [r8+(256+0+SPBC*1)], zmm13
    vmovaps zmm15, zmm12
    vpermi2ps zmm15, zmm29, zmm28
    vpermi2ps zmm12, zmm27, zmm26
    vmulps zmm3, zmm0, zmm14
    vpsrld zmm11, zmm7, 23
    vmovaps [rsp+7104], zmm8
    vpsubd zmm1, zmm6, zmm17
    vmovups zmm9, [r8+(0+SPBC*1)]
    vmovups zmm2, [rsp+7936]
    vpermi2ps zmm11, zmm31, zmm30
    vdivps zmm14, zmm5, zmm4
    vcvtdq2ps zmm7, zmm1
    vfmadd231ps zmm0, zmm3, zmm16
    vfmsub213ps zmm10, zmm12, zmm24
    valignd zmm8, zmm9, [r8+(-256+0+SPBC*1)], 15
    jmp .j1408
    ALIGN 64
.j1408:
    valignd zmm6, zmm13, zmm9, 1
    vmovaps [r8+(512+0+SPBC*1)], zmm7
    vrangeps zmm5, zmm2, zmm25, 11
    vpsrld zmm4, zmm2, 18
    valignd zmm1, zmm13, zmm9, 2
    vmulps zmm3, zmm11, zmm15
    vgetmantps zmm16, zmm2, 4
    vsubps zmm12, zmm21, zmm0
    vfmadd213ps zmm0, zmm20, zmm21
    vmovaps zmm11, zmm23
    vfmadd231ps zmm11, zmm22, zmm10
    vmovaps zmm15, zmm4
    vpermi2ps zmm15, zmm29, zmm28
    vpermi2ps zmm4, zmm27, zmm26
    vpsrld zmm2, zmm5, 23
    vmulps zmm5, zmm3, zmm10
    vaddps zmm10, zmm6, zmm9
    vmovaps [rsp+7296], zmm14
    vpermi2ps zmm2, zmm31, zmm30
    vaddps zmm6, zmm8, zmm1
    vdivps zmm14, zmm12, zmm0
    vmovups zmm8, [rsp+8128]
    vfmsub213ps zmm16, zmm4, zmm24
    vfmadd231ps zmm3, zmm5, zmm11
    vmulps zmm1, zmm6, zmm19
    valignd zmm12, zmm13, zmm9, 15
    vmulps zmm0, zmm2, zmm15
    vrangeps zmm4, zmm8, zmm25, 11
    vpsrld zmm5, zmm8, 18
    vmovaps zmm11, zmm23
    vfmadd231ps zmm11, zmm22, zmm16
    vfmsub231ps zmm1, zmm10, zmm18
    valignd zmm6, zmm7, zmm13, 1
    vgetmantps zmm9, zmm8, 4
    vsubps zmm2, zmm21, zmm3
    vfmadd213ps zmm3, zmm20, zmm21
    valignd zmm15, zmm7, zmm13, 2
    vmovaps zmm10, zmm5
    vpermi2ps zmm10, zmm29, zmm28
    vpermi2ps zmm5, zmm27, zmm26
    vmulps zmm8, zmm0, zmm16
    vpsrld zmm7, zmm4, 23
    vmovaps [rsp+7488], zmm14
    vmovaps [r8+(128+0+SPBC*1)], zmm1
    vpermi2ps zmm7, zmm31, zmm30
    vdivps zmm16, zmm2, zmm3
    vaddps zmm4, zmm6, zmm13
    vmovups zmm14, [rsp+8320]
    vfmadd231ps zmm0, zmm8, zmm11
    vaddps zmm1, zmm12, zmm15
    vfmsub213ps zmm9, zmm5, zmm24
    vmulps zmm2, zmm1, zmm19
    vmulps zmm3, zmm7, zmm10
    vsubps zmm6, zmm21, zmm0
    vfmadd213ps zmm0, zmm20, zmm21
    vrangeps zmm13, zmm14, zmm25, 11
    vmovaps zmm8, zmm23
    vfmadd231ps zmm8, zmm22, zmm9
    vpsrld zmm11, zmm14, 18
    vgetmantps zmm12, zmm14, 4
    vpmovzxwd zmm15, [r0+r3*2+(32+CST*1+CRD*1)]
    vfmsub231ps zmm2, zmm4, zmm18
    vmulps zmm5, zmm3, zmm9
    vpsrld zmm1, zmm13, 23
    jmp .j1472
    ALIGN 64
.j1472:
    vmovaps zmm7, zmm11
    vpermi2ps zmm7, zmm29, zmm28
    vpermi2ps zmm11, zmm27, zmm26
    vmovaps [rsp+7680], zmm16
    vdivps zmm10, zmm6, zmm0
    vpermi2ps zmm1, zmm31, zmm30
    vpsubd zmm14, zmm15, zmm17
    vmovups zmm4, [rsp+8512]
    vpmovzxwd zmm9, [r0+r3*2+(64+CST*1+CRD*1)]
    vfmadd231ps zmm3, zmm5, zmm8
    vmovaps [r8+(384+0+SPBC*1)], zmm2
    vcvtdq2ps zmm13, zmm14
    vfmsub213ps zmm12, zmm11, zmm24
    vmovups zmm16, [c_t1h]
    vmulps zmm6, zmm1, zmm7
    vpsubd zmm0, zmm9, zmm17
    vsubps zmm15, zmm21, zmm3
    vfmadd213ps zmm3, zmm20, zmm21
    vmovaps [r8+(256+64+SPBC*1)], zmm13
    vrangeps zmm5, zmm4, [c_xlh]{1to16}, 11
    vpsrld zmm8, zmm4, 18
    vgetmantps zmm2, zmm4, 4
    vmovaps zmm14, zmm23
    vfmadd231ps zmm14, zmm22, zmm12
    vcvtdq2ps zmm11, zmm0
    vmovups zmm1, [r8+(64+SPBC*1)]
    vmovaps [rsp+7872], zmm10
    vmulps zmm7, zmm6, zmm12
    vpsrld zmm9, zmm5, 23
    vmovaps zmm4, zmm8
    vpermi2ps zmm4, zmm29, zmm28
    vpermi2ps zmm8, zmm27, zmm26
    vdivps zmm0, zmm15, zmm3
    vpermi2ps zmm9, zmm16, [c_t1h+64]
    vmovaps [r8+(512+64+SPBC*1)], zmm11
    vmovups zmm10, [rsp+8704]
    vfmadd231ps zmm6, zmm7, zmm14
    valignd zmm12, zmm1, [r8+(-256+64+SPBC*1)], 15
    valignd zmm5, zmm13, zmm1, 1
    valignd zmm15, zmm13, zmm1, 2
    vmovups zmm3, [c_t1h]
    vfmsub213ps zmm2, zmm8, zmm24
    vmulps zmm16, zmm9, zmm4
    vrangeps zmm7, zmm10, [c_xlh]{1to16}, 11
    vpsrld zmm14, zmm10, 18
    vsubps zmm8, zmm21, zmm6
    vfmadd213ps zmm6, zmm20, zmm21
    vgetmantps zmm9, zmm10, 4
    vaddps zmm4, zmm5, zmm1
    vmovaps zmm10, zmm23
    vfmadd231ps zmm10, zmm22, zmm2
    vaddps zmm5, zmm12, zmm15
    vmovaps zmm12, zmm14
    vpermi2ps zmm12, zmm29, zmm28
    vpermi2ps zmm14, zmm27, zmm26
    vmovaps [rsp+8064], zmm0
    vpsrld zmm15, zmm7, 23
    vmulps zmm0, zmm16, zmm2
    valignd zmm7, zmm13, zmm1, 15
    vdivps zmm2, zmm8, zmm6
    vpermi2ps zmm15, zmm3, [c_t1h+64]
    vmulps zmm1, zmm5, zmm19
    vmovups zmm8, [rsp+8896]
    valignd zmm6, zmm11, zmm13, 1
    jmp .j1536
    ALIGN 64
.j1536:
    vfmadd231ps zmm16, zmm0, zmm10
    vfmsub213ps zmm9, zmm14, zmm24
    valignd zmm3, zmm11, zmm13, 2
    vmovups zmm5, [c_t1h]
    vfmsub231ps zmm1, zmm4, zmm18
    vmulps zmm0, zmm15, zmm12
    vrangeps zmm10, zmm8, [c_xlh]{1to16}, 11
    vpsrld zmm14, zmm8, 18
    vsubps zmm11, zmm21, zmm16
    vfmadd213ps zmm16, zmm20, zmm21
    vmovaps zmm4, zmm23
    vfmadd231ps zmm4, zmm22, zmm9
    vaddps zmm15, zmm6, zmm13
    vgetmantps zmm12, zmm8, 4
    vmovaps [r8+(128+64+SPBC*1)], zmm1
    vmovaps zmm6, zmm14
    vpermi2ps zmm6, zmm29, zmm28
    vaddps zmm13, zmm7, zmm3
    vpermi2ps zmm14, zmm27, zmm26
    vmovaps [rsp+8256], zmm2
    vmulps zmm8, zmm0, zmm9
    vpsrld zmm1, zmm10, 23
    vdivps zmm7, zmm11, zmm16
    vpermi2ps zmm1, zmm5, [c_t1h+64]
    vmulps zmm3, zmm13, zmm19
    vfmadd231ps zmm0, zmm8, zmm4
    vfmsub231ps zmm24, zmm12, zmm14
    vfmsub231ps zmm3, zmm15, zmm18
    vmulps zmm2, zmm1, zmm6
    vsubps zmm9, zmm21, zmm0
    vfmadd213ps zmm0, zmm20, zmm21
    vfmadd231ps zmm23, zmm22, zmm24
    vmovaps [r8+(384+64+SPBC*1)], zmm3
    vmovaps [rsp+8448], zmm7
    vmulps zmm10, zmm2, zmm24
    vdivps zmm11, zmm9, zmm0
    vfmadd231ps zmm2, zmm10, zmm23
    vsubps zmm16, zmm21, zmm2
    vfmadd231ps zmm21, zmm20, zmm2
    vmovaps [rsp+8640], zmm11
    vdivps zmm5, zmm16, zmm21
    vmovaps [rsp+8832], zmm5
.g_qa:
    vmovups zmm31, [c_rq]
    vmovups zmm30, [c_rq+64]
    vmovups zmm29, [c_vq]
    vmovups zmm28, [c_vq+64]
    vmovups zmm27, [c_uq]
    vmovups zmm26, [c_uq+64]
    vbroadcastss zmm25, [c_one]
    vbroadcastss zmm24, [c_pu0]
    vbroadcastss zmm23, [c_pu1]
    vbroadcastss zmm22, [c_pu2]
    vbroadcastss zmm21, [c_c1q]
    vbroadcastss zmm20, [c_aq]
    vbroadcastss zmm19, [c_bq]
    vmovups zmm0, [rsp]
    vrangeps zmm1, zmm0, [c_flq]{1to16}, 11
    vpsrld zmm2, zmm0, 18
    vmovaps zmm3, zmm2
    vpermi2ps zmm3, zmm31, zmm30
    vprord zmm4, zmm1, 23
    vgetmantps zmm5, zmm1, 4
    vpermi2ps zmm2, zmm29, zmm28
    vmovups zmm6, [rsp+64]
    jmp .j1600
    ALIGN 64
.j1600:
    vpermi2ps zmm4, zmm27, zmm26
    vfmsub213ps zmm5, zmm3, zmm25
    vrangeps zmm7, zmm6, [c_flq]{1to16}, 11
    vpsrld zmm8, zmm6, 18
    vmovaps zmm9, zmm8
    vpermi2ps zmm9, zmm31, zmm30
    vprord zmm10, zmm7, 23
    vgetmantps zmm11, zmm7, 4
    vpermi2ps zmm8, zmm29, zmm28
    vmovups zmm12, [rsp+128]
    vpermi2ps zmm10, zmm27, zmm26
    vfmsub213ps zmm11, zmm9, zmm25
    vrangeps zmm13, zmm12, [c_flq]{1to16}, 11
    vpsrld zmm14, zmm12, 18
    vmovaps zmm15, zmm14
    vpermi2ps zmm15, zmm31, zmm30
    vprord zmm16, zmm13, 23
    vgetmantps zmm17, zmm13, 4
    vpermi2ps zmm14, zmm29, zmm28
    vmovaps zmm18, zmm23
    vfmadd231ps zmm18, zmm22, zmm5
    vsubps zmm0, zmm21, zmm4
    vmovaps zmm1, zmm5
    vfmadd231ps zmm1, zmm2, zmm5
    vpermi2ps zmm16, zmm27, zmm26
    vfmsub213ps zmm17, zmm15, zmm25
    vfmadd213ps zmm18, zmm5, zmm24
    vmovups zmm3, [rsp+192]
    vfmadd231ps zmm2, zmm1, zmm18
    vrangeps zmm6, zmm3, [c_flq]{1to16}, 11
    vpsrld zmm7, zmm3, 18
    vmovaps zmm9, zmm7
    vpermi2ps zmm9, zmm31, zmm30
    vprord zmm12, zmm6, 23
    vgetmantps zmm13, zmm6, 4
    vfnmadd231ps zmm4, zmm0, zmm2
    vpermi2ps zmm7, zmm29, zmm28
    vmovaps zmm15, zmm23
    vfmadd231ps zmm15, zmm22, zmm11
    vsubps zmm5, zmm21, zmm10
    vpermi2ps zmm12, zmm27, zmm26
    vmovaps zmm1, zmm11
    vfmadd231ps zmm1, zmm8, zmm11
    vfmsub213ps zmm13, zmm9, zmm25
    vmovups zmm18, [rsp+256]
    vfmadd213ps zmm15, zmm11, zmm24
    vfmadd231ps zmm8, zmm1, zmm15
    vrangeps zmm3, zmm18, [c_flq]{1to16}, 11
    vpsrld zmm6, zmm18, 18
    vprord zmm0, zmm3, 23
    vgetmantps zmm2, zmm3, 4
    vmovaps zmm9, zmm6
    vpermi2ps zmm9, zmm31, zmm30
    vpermi2ps zmm6, zmm29, zmm28
    vfnmadd231ps zmm10, zmm5, zmm8
    vmovaps zmm11, zmm23
    vfmadd231ps zmm11, zmm22, zmm17
    vsubps zmm1, zmm21, zmm16
    vpermi2ps zmm0, zmm27, zmm26
    vmovaps zmm15, zmm17
    vfmadd231ps zmm15, zmm14, zmm17
    vfmsub213ps zmm2, zmm9, zmm25
    vfmadd213ps zmm11, zmm17, zmm24
    vmovups zmm18, [rsp+320]
    jmp .j1664
    ALIGN 64
.j1664:
    vfmadd231ps zmm14, zmm15, zmm11
    vrangeps zmm3, zmm18, [c_flq]{1to16}, 11
    vpsrld zmm5, zmm18, 18
    vmovaps zmm8, zmm5
    vpermi2ps zmm8, zmm31, zmm30
    vprord zmm9, zmm3, 23
    vgetmantps zmm17, zmm3, 4
    vfnmadd231ps zmm16, zmm1, zmm14
    vpermi2ps zmm5, zmm29, zmm28
    vmovaps zmm15, zmm23
    vfmadd231ps zmm15, zmm22, zmm13
    vsubps zmm11, zmm21, zmm12
    vpermi2ps zmm9, zmm27, zmm26
    vmovaps zmm18, zmm13
    vfmadd231ps zmm18, zmm7, zmm13
    vfmsub213ps zmm17, zmm8, zmm25
    vmovups zmm3, [rsp+768]
    vfmadd213ps zmm15, zmm13, zmm24
    vfmadd231ps zmm7, zmm18, zmm15
    vrangeps zmm1, zmm3, [c_flq]{1to16}, 11
    vpsrld zmm14, zmm3, 18
    vprord zmm8, zmm1, 23
    vgetmantps zmm13, zmm1, 4
    vmovaps zmm18, zmm14
    vpermi2ps zmm18, zmm31, zmm30
    vpermi2ps zmm14, zmm29, zmm28
    vfnmadd231ps zmm12, zmm11, zmm7
    vmovaps zmm15, zmm23
    vfmadd231ps zmm15, zmm22, zmm2
    vsubps zmm3, zmm21, zmm0
    vpermi2ps zmm8, zmm27, zmm26
    vmovaps zmm1, zmm2
    vfmadd231ps zmm1, zmm6, zmm2
    vfmsub213ps zmm13, zmm18, zmm25
    vfmadd213ps zmm15, zmm2, zmm24
    vdivps zmm11, zmm20, zmm4
    vfmadd231ps zmm6, zmm1, zmm15
    vmovups zmm7, [rsp+832]
    vfnmadd231ps zmm0, zmm3, zmm6
    vsubps zmm18, zmm11, zmm19
    vrangeps zmm2, zmm7, [c_flq]{1to16}, 11
    vpsrld zmm4, zmm7, 18
    vmovaps [rsp+3072], zmm18
    vmovaps zmm1, zmm4
    vpermi2ps zmm1, zmm31, zmm30
    vprord zmm15, zmm2, 23
    vgetmantps zmm3, zmm2, 4
    vpermi2ps zmm4, zmm29, zmm28
    vmovaps zmm6, zmm23
    vfmadd231ps zmm6, zmm22, zmm17
    vsubps zmm11, zmm21, zmm9
    vmovaps zmm7, zmm17
    vfmadd231ps zmm7, zmm5, zmm17
    vpermi2ps zmm15, zmm27, zmm26
    vfmsub213ps zmm3, zmm1, zmm25
    vfmadd213ps zmm6, zmm17, zmm24
    vdivps zmm18, zmm20, zmm10
    vfmadd231ps zmm5, zmm7, zmm6
    vmovups zmm2, [rsp+896]
    vfnmadd231ps zmm9, zmm11, zmm5
    vsubps zmm1, zmm18, zmm19
    vrangeps zmm17, zmm2, [c_flq]{1to16}, 11
    vpsrld zmm10, zmm2, 18
    vmovaps [rsp+3136], zmm1
    jmp .j1728
    ALIGN 64
.j1728:
    vmovaps zmm7, zmm10
    vpermi2ps zmm7, zmm31, zmm30
    vprord zmm6, zmm17, 23
    vgetmantps zmm11, zmm17, 4
    vpermi2ps zmm10, zmm29, zmm28
    vmovaps zmm5, zmm23
    vfmadd231ps zmm5, zmm22, zmm13
    vsubps zmm18, zmm21, zmm8
    vmovaps zmm2, zmm13
    vfmadd231ps zmm2, zmm14, zmm13
    vpermi2ps zmm6, zmm27, zmm26
    vfmsub213ps zmm11, zmm7, zmm25
    vfmadd213ps zmm5, zmm13, zmm24
    vdivps zmm1, zmm20, zmm16
    vfmadd231ps zmm14, zmm2, zmm5
    vmovups zmm17, [rsp+960]
    vfnmadd231ps zmm8, zmm18, zmm14
    vsubps zmm7, zmm1, zmm19
    vrangeps zmm13, zmm17, [c_flq]{1to16}, 11
    vpsrld zmm16, zmm17, 18
    vmovaps [rsp+3200], zmm7
    vmovaps zmm2, zmm16
    vpermi2ps zmm2, zmm31, zmm30
    vprord zmm5, zmm13, 23
    vgetmantps zmm18, zmm13, 4
    vpermi2ps zmm16, zmm29, zmm28
    vmovaps zmm14, zmm23
    vfmadd231ps zmm14, zmm22, zmm3
    vsubps zmm1, zmm21, zmm15
    vmovaps zmm17, zmm3
    vfmadd231ps zmm17, zmm4, zmm3
    vpermi2ps zmm5, zmm27, zmm26
    vfmsub213ps zmm18, zmm2, zmm25
    vfmadd213ps zmm14, zmm3, zmm24
    vdivps zmm7, zmm20, zmm12
    vfmadd231ps zmm4, zmm17, zmm14
    vmovups zmm13, [rsp+1024]
    vfnmadd231ps zmm15, zmm1, zmm4
    vsubps zmm2, zmm7, zmm19
    vrangeps zmm3, zmm13, [c_flq]{1to16}, 11
    vpsrld zmm12, zmm13, 18
    vmovaps [rsp+3264], zmm2
    vmovaps zmm17, zmm12
    vpermi2ps zmm17, zmm31, zmm30
    vprord zmm14, zmm3, 23
    vgetmantps zmm1, zmm3, 4
    vpermi2ps zmm12, zmm29, zmm28
    vmovaps zmm4, zmm23
    vfmadd231ps zmm4, zmm22, zmm11
    vsubps zmm7, zmm21, zmm6
    vmovaps zmm13, zmm11
    vfmadd231ps zmm13, zmm10, zmm11
    vpermi2ps zmm14, zmm27, zmm26
    vfmsub213ps zmm1, zmm17, zmm25
    vfmadd213ps zmm4, zmm11, zmm24
    vdivps zmm2, zmm20, zmm0
    vfmadd231ps zmm10, zmm13, zmm4
    vmovups zmm3, [rsp+1088]
    vfnmadd231ps zmm6, zmm7, zmm10
    vsubps zmm17, zmm2, zmm19
    vrangeps zmm11, zmm3, [c_flq]{1to16}, 11
    vpsrld zmm0, zmm3, 18
    vmovaps [rsp+3328], zmm17
    vmovaps zmm13, zmm0
    jmp .j1792
    ALIGN 64
.j1792:
    vpermi2ps zmm13, zmm31, zmm30
    vprord zmm4, zmm11, 23
    vgetmantps zmm7, zmm11, 4
    vpermi2ps zmm0, zmm29, zmm28
    vmovaps zmm10, zmm23
    vfmadd231ps zmm10, zmm22, zmm18
    vsubps zmm2, zmm21, zmm5
    vmovaps zmm3, zmm18
    vfmadd231ps zmm3, zmm16, zmm18
    vpermi2ps zmm4, zmm27, zmm26
    vfmsub213ps zmm7, zmm13, zmm25
    vfmadd213ps zmm10, zmm18, zmm24
    vdivps zmm17, zmm20, zmm9
    vfmadd231ps zmm16, zmm3, zmm10
    vmovups zmm11, [rsp+1536]
    vfnmadd231ps zmm5, zmm2, zmm16
    vsubps zmm13, zmm17, zmm19
    vrangeps zmm18, zmm11, [c_flq]{1to16}, 11
    vpsrld zmm9, zmm11, 18
    vmovaps [rsp+3392], zmm13
    vmovaps zmm3, zmm9
    vpermi2ps zmm3, zmm31, zmm30
    vprord zmm10, zmm18, 23
    vgetmantps zmm2, zmm18, 4
    vpermi2ps zmm9, zmm29, zmm28
    vmovaps zmm16, zmm23
    vfmadd231ps zmm16, zmm22, zmm1
    vsubps zmm17, zmm21, zmm14
    vmovaps zmm11, zmm1
    vfmadd231ps zmm11, zmm12, zmm1
    vpermi2ps zmm10, zmm27, zmm26
    vfmsub213ps zmm2, zmm3, zmm25
    vfmadd213ps zmm16, zmm1, zmm24
    vdivps zmm13, zmm20, zmm8
    vfmadd231ps zmm12, zmm11, zmm16
    vmovups zmm18, [rsp+1600]
    vfnmadd231ps zmm14, zmm17, zmm12
    vsubps zmm3, zmm13, zmm19
    vrangeps zmm1, zmm18, [c_flq]{1to16}, 11
    vpsrld zmm8, zmm18, 18
    vmovaps [rsp+3840], zmm3
    vmovaps zmm11, zmm8
    vpermi2ps zmm11, zmm31, zmm30
    vprord zmm16, zmm1, 23
    vgetmantps zmm17, zmm1, 4
    vpermi2ps zmm8, zmm29, zmm28
    vmovaps zmm12, zmm23
    vfmadd231ps zmm12, zmm22, zmm7
    vsubps zmm13, zmm21, zmm4
    vmovaps zmm18, zmm7
    vfmadd231ps zmm18, zmm0, zmm7
    vpermi2ps zmm16, zmm27, zmm26
    vfmsub213ps zmm17, zmm11, zmm25
    vfmadd213ps zmm12, zmm7, zmm24
    vdivps zmm3, zmm20, zmm15
    vfmadd231ps zmm0, zmm18, zmm12
    vmovups zmm1, [rsp+1664]
    vfnmadd231ps zmm4, zmm13, zmm0
    vsubps zmm11, zmm3, zmm19
    vrangeps zmm7, zmm1, [c_flq]{1to16}, 11
    vpsrld zmm15, zmm1, 18
    vmovaps [rsp+3904], zmm11
    vmovaps zmm18, zmm15
    vpermi2ps zmm18, zmm31, zmm30
    jmp .j1856
    ALIGN 64
.j1856:
    vprord zmm12, zmm7, 23
    vgetmantps zmm13, zmm7, 4
    vpermi2ps zmm15, zmm29, zmm28
    vmovaps zmm0, zmm23
    vfmadd231ps zmm0, zmm22, zmm2
    vsubps zmm3, zmm21, zmm10
    vmovaps zmm1, zmm2
    vfmadd231ps zmm1, zmm9, zmm2
    vpermi2ps zmm12, zmm27, zmm26
    vfmsub213ps zmm13, zmm18, zmm25
    vfmadd213ps zmm0, zmm2, zmm24
    vdivps zmm11, zmm20, zmm6
    vfmadd231ps zmm9, zmm1, zmm0
    vmovups zmm7, [rsp+1728]
    vfnmadd231ps zmm10, zmm3, zmm9
    vsubps zmm18, zmm11, zmm19
    vrangeps zmm2, zmm7, [c_flq]{1to16}, 11
    vpsrld zmm6, zmm7, 18
    vmovaps [rsp+3968], zmm18
    vmovaps zmm1, zmm6
    vpermi2ps zmm1, zmm31, zmm30
    vprord zmm0, zmm2, 23
    vgetmantps zmm3, zmm2, 4
    vpermi2ps zmm6, zmm29, zmm28
    vmovaps zmm9, zmm23
    vfmadd231ps zmm9, zmm22, zmm17
    vsubps zmm11, zmm21, zmm16
    vmovaps zmm7, zmm17
    vfmadd231ps zmm7, zmm8, zmm17
    vpermi2ps zmm0, zmm27, zmm26
    vfmsub213ps zmm3, zmm1, zmm25
    vfmadd213ps zmm9, zmm17, zmm24
    vdivps zmm18, zmm20, zmm5
    vfmadd231ps zmm8, zmm7, zmm9
    vmovups zmm2, [rsp+1792]
    vfnmadd231ps zmm16, zmm11, zmm8
    vsubps zmm1, zmm18, zmm19
    vrangeps zmm17, zmm2, [c_flq]{1to16}, 11
    vpsrld zmm5, zmm2, 18
    vmovaps [rsp+4032], zmm1
    vmovaps zmm7, zmm5
    vpermi2ps zmm7, zmm31, zmm30
    vprord zmm9, zmm17, 23
    vgetmantps zmm11, zmm17, 4
    vpermi2ps zmm5, zmm29, zmm28
    vmovaps zmm8, zmm23
    vfmadd231ps zmm8, zmm22, zmm13
    vsubps zmm18, zmm21, zmm12
    vmovaps zmm2, zmm13
    vfmadd231ps zmm2, zmm15, zmm13
    vpermi2ps zmm9, zmm27, zmm26
    vfmsub213ps zmm11, zmm7, zmm25
    vfmadd213ps zmm8, zmm13, zmm24
    vdivps zmm1, zmm20, zmm14
    vfmadd231ps zmm15, zmm2, zmm8
    vmovups zmm17, [rsp+1856]
    vfnmadd231ps zmm12, zmm18, zmm15
    vsubps zmm7, zmm1, zmm19
    vrangeps zmm13, zmm17, [c_flq]{1to16}, 11
    vpsrld zmm14, zmm17, 18
    vmovaps [rsp+4096], zmm7
    vmovaps zmm2, zmm14
    vpermi2ps zmm2, zmm31, zmm30
    vprord zmm8, zmm13, 23
    jmp .j1920
    ALIGN 64
.j1920:
    vgetmantps zmm18, zmm13, 4
    vpermi2ps zmm14, zmm29, zmm28
    vmovaps zmm15, zmm23
    vfmadd231ps zmm15, zmm22, zmm3
    vsubps zmm1, zmm21, zmm0
    vmovaps zmm17, zmm3
    vfmadd231ps zmm17, zmm6, zmm3
    vpermi2ps zmm8, zmm27, zmm26
    vfmsub213ps zmm18, zmm2, zmm25
    vfmadd213ps zmm15, zmm3, zmm24
    vdivps zmm7, zmm20, zmm4
    vfmadd231ps zmm6, zmm17, zmm15
    vmovups zmm13, [rsp+2304]
    vfnmadd231ps zmm0, zmm1, zmm6
    vsubps zmm2, zmm7, zmm19
    vrangeps zmm3, zmm13, [c_flq]{1to16}, 11
    vpsrld zmm4, zmm13, 18
    vmovaps [rsp+4160], zmm2
    vmovaps zmm17, zmm4
    vpermi2ps zmm17, zmm31, zmm30
    vprord zmm15, zmm3, 23
    vgetmantps zmm1, zmm3, 4
    vpermi2ps zmm4, zmm29, zmm28
    vmovaps zmm6, zmm23
    vfmadd231ps zmm6, zmm22, zmm11
    vsubps zmm7, zmm21, zmm9
    vmovaps zmm13, zmm11
    vfmadd231ps zmm13, zmm5, zmm11
    vpermi2ps zmm15, zmm27, zmm26
    vfmsub213ps zmm1, zmm17, zmm25
    vfmadd213ps zmm6, zmm11, zmm24
    vdivps zmm2, zmm20, zmm10
    vfmadd231ps zmm5, zmm13, zmm6
    vmovups zmm3, [rsp+2368]
    vfnmadd231ps zmm9, zmm7, zmm5
    vsubps zmm17, zmm2, zmm19
    vrangeps zmm11, zmm3, [c_flq]{1to16}, 11
    vpsrld zmm10, zmm3, 18
    vmovaps [rsp+4608], zmm17
    vmovaps zmm13, zmm10
    vpermi2ps zmm13, zmm31, zmm30
    vprord zmm6, zmm11, 23
    vgetmantps zmm7, zmm11, 4
    vpermi2ps zmm10, zmm29, zmm28
    vmovaps zmm5, zmm23
    vfmadd231ps zmm5, zmm22, zmm18
    vsubps zmm2, zmm21, zmm8
    vmovaps zmm3, zmm18
    vfmadd231ps zmm3, zmm14, zmm18
    vpermi2ps zmm6, zmm27, zmm26
    vfmsub213ps zmm7, zmm13, zmm25
    vfmadd213ps zmm5, zmm18, zmm24
    vdivps zmm17, zmm20, zmm16
    vfmadd231ps zmm14, zmm3, zmm5
    vmovups zmm11, [rsp+2432]
    vfnmadd231ps zmm8, zmm2, zmm14
    vsubps zmm13, zmm17, zmm19
    vrangeps zmm18, zmm11, [c_flq]{1to16}, 11
    vpsrld zmm16, zmm11, 18
    vmovaps [rsp+4672], zmm13
    vmovaps zmm3, zmm16
    vpermi2ps zmm3, zmm31, zmm30
    vprord zmm5, zmm18, 23
    vgetmantps zmm2, zmm18, 4
    jmp .j1984
    ALIGN 64
.j1984:
    vpermi2ps zmm16, zmm29, zmm28
    vmovaps zmm14, zmm23
    vfmadd231ps zmm14, zmm22, zmm1
    vsubps zmm17, zmm21, zmm15
    vmovaps zmm11, zmm1
    vfmadd231ps zmm11, zmm4, zmm1
    vpermi2ps zmm5, zmm27, zmm26
    vfmsub213ps zmm2, zmm3, zmm25
    vfmadd213ps zmm14, zmm1, zmm24
    vdivps zmm13, zmm20, zmm12
    vfmadd231ps zmm4, zmm11, zmm14
    vmovups zmm18, [rsp+2496]
    vfnmadd231ps zmm15, zmm17, zmm4
    vsubps zmm3, zmm13, zmm19
    vrangeps zmm1, zmm18, [c_flq]{1to16}, 11
    vpsrld zmm12, zmm18, 18
    vmovaps [rsp+4736], zmm3
    vmovaps zmm11, zmm12
    vpermi2ps zmm11, zmm31, zmm30
    vprord zmm14, zmm1, 23
    vgetmantps zmm17, zmm1, 4
    vpermi2ps zmm12, zmm29, zmm28
    vmovaps zmm4, zmm23
    vfmadd231ps zmm4, zmm22, zmm7
    vsubps zmm13, zmm21, zmm6
    vmovaps zmm18, zmm7
    vfmadd231ps zmm18, zmm10, zmm7
    vpermi2ps zmm14, zmm27, zmm26
    vfmsub213ps zmm17, zmm11, zmm25
    vfmadd213ps zmm4, zmm7, zmm24
    vdivps zmm3, zmm20, zmm0
    vfmadd231ps zmm10, zmm18, zmm4
    vmovups zmm1, [rsp+2560]
    vfnmadd231ps zmm6, zmm13, zmm10
    vsubps zmm11, zmm3, zmm19
    vrangeps zmm7, zmm1, [c_flq]{1to16}, 11
    vpsrld zmm0, zmm1, 18
    vmovaps [rsp+4800], zmm11
    vmovaps zmm18, zmm0
    vpermi2ps zmm18, zmm31, zmm30
    vprord zmm4, zmm7, 23
    vgetmantps zmm13, zmm7, 4
    vpermi2ps zmm0, zmm29, zmm28
    vmovaps zmm10, zmm23
    vfmadd231ps zmm10, zmm22, zmm2
    vsubps zmm3, zmm21, zmm5
    vmovaps zmm1, zmm2
    vfmadd231ps zmm1, zmm16, zmm2
    vpermi2ps zmm4, zmm27, zmm26
    vfmsub213ps zmm13, zmm18, zmm25
    vfmadd213ps zmm10, zmm2, zmm24
    vdivps zmm11, zmm20, zmm9
    vfmadd231ps zmm16, zmm1, zmm10
    vmovups zmm7, [rsp+2624]
    vfnmadd231ps zmm5, zmm3, zmm16
    vsubps zmm18, zmm11, zmm19
    vrangeps zmm2, zmm7, [c_flq]{1to16}, 11
    vpsrld zmm9, zmm7, 18
    vmovaps [rsp+4864], zmm18
    vmovaps zmm1, zmm9
    vpermi2ps zmm1, zmm31, zmm30
    vprord zmm10, zmm2, 23
    vgetmantps zmm3, zmm2, 4
    vpermi2ps zmm9, zmm29, zmm28
    jmp .j2048
    ALIGN 64
.j2048:
    vmovaps zmm16, zmm23
    vfmadd231ps zmm16, zmm22, zmm17
    vsubps zmm11, zmm21, zmm14
    vmovaps zmm7, zmm17
    vfmadd231ps zmm7, zmm12, zmm17
    vpermi2ps zmm10, zmm27, zmm26
    vfmsub213ps zmm3, zmm1, zmm25
    vfmadd213ps zmm16, zmm17, zmm24
    vdivps zmm18, zmm20, zmm8
    vfmadd231ps zmm12, zmm7, zmm16
    vmovups zmm2, [rsp+384]
    vfnmadd231ps zmm14, zmm11, zmm12
    vsubps zmm1, zmm18, zmm19
    vrangeps zmm17, zmm2, [c_flq]{1to16}, 11
    vpsrld zmm8, zmm2, 18
    vmovaps [rsp+4928], zmm1
    vmovaps zmm7, zmm8
    vpermi2ps zmm7, zmm31, zmm30
    vprord zmm16, zmm17, 23
    vgetmantps zmm11, zmm17, 4
    vpermi2ps zmm8, zmm29, zmm28
    vmovaps zmm12, zmm23
    vfmadd231ps zmm12, zmm22, zmm13
    vsubps zmm18, zmm21, zmm4
    vmovaps zmm2, zmm13
    vfmadd231ps zmm2, zmm0, zmm13
    vpermi2ps zmm16, zmm27, zmm26
    vfmsub213ps zmm11, zmm7, zmm25
    vfmadd213ps zmm12, zmm13, zmm24
    vdivps zmm1, zmm20, zmm15
    vfmadd231ps zmm0, zmm2, zmm12
    vmovups zmm17, [rsp+448]
    vfnmadd231ps zmm4, zmm18, zmm0
    vsubps zmm7, zmm1, zmm19
    vrangeps zmm13, zmm17, [c_flq]{1to16}, 11
    vpsrld zmm15, zmm17, 18
    vmovaps [rsp+5376], zmm7
    vmovaps zmm2, zmm15
    vpermi2ps zmm2, zmm31, zmm30
    vprord zmm12, zmm13, 23
    vgetmantps zmm18, zmm13, 4
    vpermi2ps zmm15, zmm29, zmm28
    vmovaps zmm0, zmm23
    vfmadd231ps zmm0, zmm22, zmm3
    vsubps zmm1, zmm21, zmm10
    vmovaps zmm17, zmm3
    vfmadd231ps zmm17, zmm9, zmm3
    vpermi2ps zmm12, zmm27, zmm26
    vfmsub213ps zmm18, zmm2, zmm25
    vfmadd213ps zmm0, zmm3, zmm24
    vdivps zmm7, zmm20, zmm6
    vfmadd231ps zmm9, zmm17, zmm0
    vmovups zmm13, [rsp+512]
    vfnmadd231ps zmm10, zmm1, zmm9
    vsubps zmm2, zmm7, zmm19
    vrangeps zmm3, zmm13, [c_flq]{1to16}, 11
    vpsrld zmm6, zmm13, 18
    vmovaps [rsp+5440], zmm2
    vmovaps zmm17, zmm6
    vpermi2ps zmm17, zmm31, zmm30
    vprord zmm0, zmm3, 23
    vgetmantps zmm1, zmm3, 4
    vpermi2ps zmm6, zmm29, zmm28
    vmovaps zmm9, zmm23
    jmp .j2112
    ALIGN 64
.j2112:
    vfmadd231ps zmm9, zmm22, zmm11
    vsubps zmm7, zmm21, zmm16
    vmovaps zmm13, zmm11
    vfmadd231ps zmm13, zmm8, zmm11
    vpermi2ps zmm0, zmm27, zmm26
    vfmsub213ps zmm1, zmm17, zmm25
    vfmadd213ps zmm9, zmm11, zmm24
    vdivps zmm2, zmm20, zmm5
    vfmadd231ps zmm8, zmm13, zmm9
    vmovups zmm3, [rsp+576]
    vfnmadd231ps zmm16, zmm7, zmm8
    vsubps zmm17, zmm2, zmm19
    vrangeps zmm11, zmm3, [c_flq]{1to16}, 11
    vpsrld zmm5, zmm3, 18
    vmovaps [rsp+5504], zmm17
    vmovaps zmm13, zmm5
    vpermi2ps zmm13, zmm31, zmm30
    vprord zmm9, zmm11, 23
    vgetmantps zmm7, zmm11, 4
    vpermi2ps zmm5, zmm29, zmm28
    vmovaps zmm8, zmm23
    vfmadd231ps zmm8, zmm22, zmm18
    vsubps zmm2, zmm21, zmm12
    vmovaps zmm3, zmm18
    vfmadd231ps zmm3, zmm15, zmm18
    vpermi2ps zmm9, zmm27, zmm26
    vfmsub213ps zmm7, zmm13, zmm25
    vfmadd213ps zmm8, zmm18, zmm24
    vdivps zmm17, zmm20, zmm14
    vfmadd231ps zmm15, zmm3, zmm8
    vmovups zmm11, [rsp+640]
    vfnmadd231ps zmm12, zmm2, zmm15
    vsubps zmm13, zmm17, zmm19
    vrangeps zmm18, zmm11, [c_flq]{1to16}, 11
    vpsrld zmm14, zmm11, 18
    vmovaps [rsp+5568], zmm13
    vmovaps zmm3, zmm14
    vpermi2ps zmm3, zmm31, zmm30
    vprord zmm8, zmm18, 23
    vgetmantps zmm2, zmm18, 4
    vpermi2ps zmm14, zmm29, zmm28
    vmovaps zmm15, zmm23
    vfmadd231ps zmm15, zmm22, zmm1
    vsubps zmm17, zmm21, zmm0
    vmovaps zmm11, zmm1
    vfmadd231ps zmm11, zmm6, zmm1
    vpermi2ps zmm8, zmm27, zmm26
    vfmsub213ps zmm2, zmm3, zmm25
    vfmadd213ps zmm15, zmm1, zmm24
    vdivps zmm13, zmm20, zmm4
    vfmadd231ps zmm6, zmm11, zmm15
    vmovups zmm18, [rsp+704]
    vfnmadd231ps zmm0, zmm17, zmm6
    vsubps zmm3, zmm13, zmm19
    vrangeps zmm1, zmm18, [c_flq]{1to16}, 11
    vpsrld zmm4, zmm18, 18
    vmovaps [rsp+5632], zmm3
    vmovaps zmm11, zmm4
    vpermi2ps zmm11, zmm31, zmm30
    vprord zmm15, zmm1, 23
    vgetmantps zmm17, zmm1, 4
    vpermi2ps zmm4, zmm29, zmm28
    vmovaps zmm6, zmm23
    vfmadd231ps zmm6, zmm22, zmm7
    jmp .j2176
    ALIGN 64
.j2176:
    vsubps zmm13, zmm21, zmm9
    vmovaps zmm18, zmm7
    vfmadd231ps zmm18, zmm5, zmm7
    vpermi2ps zmm15, zmm27, zmm26
    vfmsub213ps zmm17, zmm11, zmm25
    vfmadd213ps zmm6, zmm7, zmm24
    vdivps zmm3, zmm20, zmm10
    vfmadd231ps zmm5, zmm18, zmm6
    vmovups zmm1, [rsp+1152]
    vfnmadd231ps zmm9, zmm13, zmm5
    vsubps zmm11, zmm3, zmm19
    vrangeps zmm7, zmm1, [c_flq]{1to16}, 11
    vpsrld zmm10, zmm1, 18
    vmovaps [rsp+5696], zmm11
    vmovaps zmm18, zmm10
    vpermi2ps zmm18, zmm31, zmm30
    vprord zmm6, zmm7, 23
    vgetmantps zmm13, zmm7, 4
    vpermi2ps zmm10, zmm29, zmm28
    vmovaps zmm5, zmm23
    vfmadd231ps zmm5, zmm22, zmm2
    vsubps zmm3, zmm21, zmm8
    vmovaps zmm1, zmm2
    vfmadd231ps zmm1, zmm14, zmm2
    vpermi2ps zmm6, zmm27, zmm26
    vfmsub213ps zmm13, zmm18, zmm25
    vfmadd213ps zmm5, zmm2, zmm24
    vdivps zmm11, zmm20, zmm16
    vfmadd231ps zmm14, zmm1, zmm5
    vmovups zmm7, [rsp+1216]
    vfnmadd231ps zmm8, zmm3, zmm14
    vsubps zmm18, zmm11, zmm19
    vrangeps zmm2, zmm7, [c_flq]{1to16}, 11
    vpsrld zmm16, zmm7, 18
    vmovaps [rsp+3456], zmm18
    vmovaps zmm1, zmm16
    vpermi2ps zmm1, zmm31, zmm30
    vprord zmm5, zmm2, 23
    vgetmantps zmm3, zmm2, 4
    vpermi2ps zmm16, zmm29, zmm28
    vmovaps zmm14, zmm23
    vfmadd231ps zmm14, zmm22, zmm17
    vsubps zmm11, zmm21, zmm15
    vmovaps zmm7, zmm17
    vfmadd231ps zmm7, zmm4, zmm17
    vpermi2ps zmm5, zmm27, zmm26
    vfmsub213ps zmm3, zmm1, zmm25
    vfmadd213ps zmm14, zmm17, zmm24
    vdivps zmm18, zmm20, zmm12
    vfmadd231ps zmm4, zmm7, zmm14
    vmovups zmm2, [rsp+1280]
    vfnmadd231ps zmm15, zmm11, zmm4
    vsubps zmm1, zmm18, zmm19
    vrangeps zmm17, zmm2, [c_flq]{1to16}, 11
    vpsrld zmm12, zmm2, 18
    vmovaps [rsp+3520], zmm1
    vmovaps zmm7, zmm12
    vpermi2ps zmm7, zmm31, zmm30
    vprord zmm14, zmm17, 23
    vgetmantps zmm11, zmm17, 4
    vpermi2ps zmm12, zmm29, zmm28
    vmovaps zmm4, zmm23
    vfmadd231ps zmm4, zmm22, zmm13
    vsubps zmm18, zmm21, zmm6
    jmp .j2240
    ALIGN 64
.j2240:
    vmovaps zmm2, zmm13
    vfmadd231ps zmm2, zmm10, zmm13
    vpermi2ps zmm14, zmm27, zmm26
    vfmsub213ps zmm11, zmm7, zmm25
    vfmadd213ps zmm4, zmm13, zmm24
    vdivps zmm1, zmm20, zmm0
    vfmadd231ps zmm10, zmm2, zmm4
    vmovups zmm17, [rsp+1344]
    vfnmadd231ps zmm6, zmm18, zmm10
    vsubps zmm7, zmm1, zmm19
    vrangeps zmm13, zmm17, [c_flq]{1to16}, 11
    vpsrld zmm0, zmm17, 18
    vmovaps [rsp+3584], zmm7
    vmovaps zmm2, zmm0
    vpermi2ps zmm2, zmm31, zmm30
    vprord zmm4, zmm13, 23
    vgetmantps zmm18, zmm13, 4
    vpermi2ps zmm0, zmm29, zmm28
    vmovaps zmm10, zmm23
    vfmadd231ps zmm10, zmm22, zmm3
    vsubps zmm1, zmm21, zmm5
    vmovaps zmm17, zmm3
    vfmadd231ps zmm17, zmm16, zmm3
    vpermi2ps zmm4, zmm27, zmm26
    vfmsub213ps zmm18, zmm2, zmm25
    vfmadd213ps zmm10, zmm3, zmm24
    vdivps zmm7, zmm20, zmm9
    vfmadd231ps zmm16, zmm17, zmm10
    vmovups zmm13, [rsp+1408]
    vfnmadd231ps zmm5, zmm1, zmm16
    vsubps zmm2, zmm7, zmm19
    vrangeps zmm3, zmm13, [c_flq]{1to16}, 11
    vpsrld zmm9, zmm13, 18
    vmovaps [rsp+3648], zmm2
    vmovaps zmm17, zmm9
    vpermi2ps zmm17, zmm31, zmm30
    vprord zmm10, zmm3, 23
    vgetmantps zmm1, zmm3, 4
    vpermi2ps zmm9, zmm29, zmm28
    vmovaps zmm16, zmm23
    vfmadd231ps zmm16, zmm22, zmm11
    vsubps zmm7, zmm21, zmm14
    vmovaps zmm13, zmm11
    vfmadd231ps zmm13, zmm12, zmm11
    vpermi2ps zmm10, zmm27, zmm26
    vfmsub213ps zmm1, zmm17, zmm25
    vfmadd213ps zmm16, zmm11, zmm24
    vdivps zmm2, zmm20, zmm8
    vfmadd231ps zmm12, zmm13, zmm16
    vmovups zmm3, [rsp+1472]
    vfnmadd231ps zmm14, zmm7, zmm12
    vsubps zmm17, zmm2, zmm19
    vrangeps zmm11, zmm3, [c_flq]{1to16}, 11
    vpsrld zmm8, zmm3, 18
    vmovaps [rsp+3712], zmm17
    vmovaps zmm13, zmm8
    vpermi2ps zmm13, zmm31, zmm30
    vprord zmm16, zmm11, 23
    vgetmantps zmm7, zmm11, 4
    vpermi2ps zmm8, zmm29, zmm28
    vmovaps zmm12, zmm23
    vfmadd231ps zmm12, zmm22, zmm18
    vsubps zmm2, zmm21, zmm4
    vmovaps zmm3, zmm18
    jmp .j2304
    ALIGN 64
.j2304:
    vfmadd231ps zmm3, zmm0, zmm18
    vpermi2ps zmm16, zmm27, zmm26
    vfmsub213ps zmm7, zmm13, zmm25
    vfmadd213ps zmm12, zmm18, zmm24
    vdivps zmm17, zmm20, zmm15
    vfmadd231ps zmm0, zmm3, zmm12
    vmovups zmm11, [rsp+1920]
    vfnmadd231ps zmm4, zmm2, zmm0
    vsubps zmm13, zmm17, zmm19
    vrangeps zmm18, zmm11, [c_flq]{1to16}, 11
    vpsrld zmm15, zmm11, 18
    vmovaps [rsp+3776], zmm13
    vmovaps zmm3, zmm15
    vpermi2ps zmm3, zmm31, zmm30
    vprord zmm12, zmm18, 23
    vgetmantps zmm2, zmm18, 4
    vpermi2ps zmm15, zmm29, zmm28
    vmovaps zmm0, zmm23
    vfmadd231ps zmm0, zmm22, zmm1
    vsubps zmm17, zmm21, zmm10
    vmovaps zmm11, zmm1
    vfmadd231ps zmm11, zmm9, zmm1
    vpermi2ps zmm12, zmm27, zmm26
    vfmsub213ps zmm2, zmm3, zmm25
    vfmadd213ps zmm0, zmm1, zmm24
    vdivps zmm13, zmm20, zmm6
    vfmadd231ps zmm9, zmm11, zmm0
    vmovups zmm18, [rsp+1984]
    vfnmadd231ps zmm10, zmm17, zmm9
    vsubps zmm3, zmm13, zmm19
    vrangeps zmm1, zmm18, [c_flq]{1to16}, 11
    vpsrld zmm6, zmm18, 18
    vmovaps [rsp+4224], zmm3
    vmovaps zmm11, zmm6
    vpermi2ps zmm11, zmm31, zmm30
    vprord zmm0, zmm1, 23
    vgetmantps zmm17, zmm1, 4
    vpermi2ps zmm6, zmm29, zmm28
    vmovaps zmm9, zmm23
    vfmadd231ps zmm9, zmm22, zmm7
    vsubps zmm13, zmm21, zmm16
    vmovaps zmm18, zmm7
    vfmadd231ps zmm18, zmm8, zmm7
    vpermi2ps zmm0, zmm27, zmm26
    vfmsub213ps zmm17, zmm11, zmm25
    vfmadd213ps zmm9, zmm7, zmm24
    vdivps zmm3, zmm20, zmm5
    vfmadd231ps zmm8, zmm18, zmm9
    vmovups zmm1, [rsp+2048]
    vfnmadd231ps zmm16, zmm13, zmm8
    vsubps zmm11, zmm3, zmm19
    vrangeps zmm7, zmm1, [c_flq]{1to16}, 11
    vpsrld zmm5, zmm1, 18
    vmovaps [rsp+4288], zmm11
    vmovaps zmm18, zmm5
    vpermi2ps zmm18, zmm31, zmm30
    vprord zmm9, zmm7, 23
    vgetmantps zmm13, zmm7, 4
    vpermi2ps zmm5, zmm29, zmm28
    vmovaps zmm8, zmm23
    vfmadd231ps zmm8, zmm22, zmm2
    vsubps zmm3, zmm21, zmm12
    vmovaps zmm1, zmm2
    vfmadd231ps zmm1, zmm15, zmm2
    jmp .j2368
    ALIGN 64
.j2368:
    vpermi2ps zmm9, zmm27, zmm26
    vfmsub213ps zmm13, zmm18, zmm25
    vfmadd213ps zmm8, zmm2, zmm24
    vdivps zmm11, zmm20, zmm14
    vfmadd231ps zmm15, zmm1, zmm8
    vmovups zmm7, [rsp+2112]
    vfnmadd231ps zmm12, zmm3, zmm15
    vsubps zmm18, zmm11, zmm19
    vrangeps zmm2, zmm7, [c_flq]{1to16}, 11
    vpsrld zmm14, zmm7, 18
    vmovaps [rsp+4352], zmm18
    vmovaps zmm1, zmm14
    vpermi2ps zmm1, zmm31, zmm30
    vprord zmm8, zmm2, 23
    vgetmantps zmm3, zmm2, 4
    vpermi2ps zmm14, zmm29, zmm28
    vmovaps zmm15, zmm23
    vfmadd231ps zmm15, zmm22, zmm17
    vsubps zmm11, zmm21, zmm0
    vmovaps zmm7, zmm17
    vfmadd231ps zmm7, zmm6, zmm17
    vpermi2ps zmm8, zmm27, zmm26
    vfmsub213ps zmm3, zmm1, zmm25
    vfmadd213ps zmm15, zmm17, zmm24
    vdivps zmm18, zmm20, zmm4
    vfmadd231ps zmm6, zmm7, zmm15
    vmovups zmm2, [rsp+2176]
    vfnmadd231ps zmm0, zmm11, zmm6
    vsubps zmm1, zmm18, zmm19
    vrangeps zmm17, zmm2, [c_flq]{1to16}, 11
    vpsrld zmm4, zmm2, 18
    vmovaps [rsp+4416], zmm1
    vmovaps zmm7, zmm4
    vpermi2ps zmm7, zmm31, zmm30
    vprord zmm15, zmm17, 23
    vgetmantps zmm11, zmm17, 4
    vpermi2ps zmm4, zmm29, zmm28
    vmovaps zmm6, zmm23
    vfmadd231ps zmm6, zmm22, zmm13
    vsubps zmm18, zmm21, zmm9
    vmovaps zmm2, zmm13
    vfmadd231ps zmm2, zmm5, zmm13
    vpermi2ps zmm15, zmm27, zmm26
    vfmsub213ps zmm11, zmm7, zmm25
    vfmadd213ps zmm6, zmm13, zmm24
    vdivps zmm1, zmm20, zmm10
    vfmadd231ps zmm5, zmm2, zmm6
    vmovups zmm17, [rsp+2240]
    vfnmadd231ps zmm9, zmm18, zmm5
    vsubps zmm7, zmm1, zmm19
    vrangeps zmm13, zmm17, [c_flq]{1to16}, 11
    vpsrld zmm10, zmm17, 18
    vmovaps [rsp+4480], zmm7
    vmovaps zmm2, zmm10
    vpermi2ps zmm2, zmm31, zmm30
    vprord zmm6, zmm13, 23
    vgetmantps zmm18, zmm13, 4
    vpermi2ps zmm10, zmm29, zmm28
    vmovaps zmm5, zmm23
    vfmadd231ps zmm5, zmm22, zmm3
    vsubps zmm1, zmm21, zmm8
    vmovaps zmm17, zmm3
    vfmadd231ps zmm17, zmm14, zmm3
    vpermi2ps zmm6, zmm27, zmm26
    jmp .j2432
    ALIGN 64
.j2432:
    vfmsub213ps zmm18, zmm2, zmm25
    vfmadd213ps zmm5, zmm3, zmm24
    vdivps zmm7, zmm20, zmm16
    vfmadd231ps zmm14, zmm17, zmm5
    vmovups zmm13, [rsp+2688]
    vfnmadd231ps zmm8, zmm1, zmm14
    vsubps zmm2, zmm7, zmm19
    vrangeps zmm3, zmm13, [c_flq]{1to16}, 11
    vpsrld zmm16, zmm13, 18
    vmovaps [rsp+4544], zmm2
    vmovaps zmm17, zmm16
    vpermi2ps zmm17, zmm31, zmm30
    vprord zmm5, zmm3, 23
    vgetmantps zmm1, zmm3, 4
    vpermi2ps zmm16, zmm29, zmm28
    vmovaps zmm14, zmm23
    vfmadd231ps zmm14, zmm22, zmm11
    vsubps zmm7, zmm21, zmm15
    vmovaps zmm13, zmm11
    vfmadd231ps zmm13, zmm4, zmm11
    vpermi2ps zmm5, zmm27, zmm26
    vfmsub213ps zmm1, zmm17, zmm25
    vfmadd213ps zmm14, zmm11, zmm24
    vdivps zmm2, zmm20, zmm12
    vfmadd231ps zmm4, zmm13, zmm14
    vmovups zmm3, [rsp+2752]
    vfnmadd231ps zmm15, zmm7, zmm4
    vsubps zmm17, zmm2, zmm19
    vrangeps zmm11, zmm3, [c_flq]{1to16}, 11
    vpsrld zmm12, zmm3, 18
    vmovaps [rsp+4992], zmm17
    vmovaps zmm13, zmm12
    vpermi2ps zmm13, zmm31, zmm30
    vprord zmm14, zmm11, 23
    vgetmantps zmm7, zmm11, 4
    vpermi2ps zmm12, zmm29, zmm28
    vmovaps zmm4, zmm23
    vfmadd231ps zmm4, zmm22, zmm18
    vsubps zmm2, zmm21, zmm6
    vmovaps zmm3, zmm18
    vfmadd231ps zmm3, zmm10, zmm18
    vpermi2ps zmm14, zmm27, zmm26
    vfmsub213ps zmm7, zmm13, zmm25
    vfmadd213ps zmm4, zmm18, zmm24
    vdivps zmm17, zmm20, zmm0
    vfmadd231ps zmm10, zmm3, zmm4
    vmovups zmm11, [rsp+2816]
    vfnmadd231ps zmm6, zmm2, zmm10
    vsubps zmm13, zmm17, zmm19
    vrangeps zmm18, zmm11, [c_flq]{1to16}, 11
    vpsrld zmm0, zmm11, 18
    vmovaps [rsp+5056], zmm13
    vmovaps zmm3, zmm0
    vpermi2ps zmm3, zmm31, zmm30
    vprord zmm4, zmm18, 23
    vgetmantps zmm2, zmm18, 4
    vpermi2ps zmm0, zmm29, zmm28
    vmovaps zmm10, zmm23
    vfmadd231ps zmm10, zmm22, zmm1
    vsubps zmm17, zmm21, zmm5
    vmovaps zmm11, zmm1
    vfmadd231ps zmm11, zmm16, zmm1
    vpermi2ps zmm4, zmm27, zmm26
    vfmsub213ps zmm2, zmm3, zmm25
    jmp .j2496
    ALIGN 64
.j2496:
    vfmadd213ps zmm10, zmm1, zmm24
    vdivps zmm13, zmm20, zmm9
    vfmadd231ps zmm16, zmm11, zmm10
    vmovups zmm18, [rsp+2880]
    vfnmadd231ps zmm5, zmm17, zmm16
    vsubps zmm3, zmm13, zmm19
    vrangeps zmm1, zmm18, [c_flq]{1to16}, 11
    vpsrld zmm9, zmm18, 18
    vmovaps [rsp+5120], zmm3
    vmovaps zmm11, zmm9
    vpermi2ps zmm11, zmm31, zmm30
    vprord zmm10, zmm1, 23
    vgetmantps zmm17, zmm1, 4
    vpermi2ps zmm9, zmm29, zmm28
    vmovaps zmm16, zmm23
    vfmadd231ps zmm16, zmm22, zmm7
    vsubps zmm13, zmm21, zmm14
    vmovaps zmm18, zmm7
    vfmadd231ps zmm18, zmm12, zmm7
    vpermi2ps zmm10, zmm27, zmm26
    vfmsub213ps zmm17, zmm11, zmm25
    vfmadd213ps zmm16, zmm7, zmm24
    vdivps zmm3, zmm20, zmm8
    vfmadd231ps zmm12, zmm18, zmm16
    vmovups zmm1, [rsp+2944]
    vfnmadd231ps zmm14, zmm13, zmm12
    vsubps zmm11, zmm3, zmm19
    vrangeps zmm7, zmm1, [c_flq]{1to16}, 11
    vpsrld zmm8, zmm1, 18
    vmovaps [rsp+5184], zmm11
    vmovaps zmm18, zmm8
    vpermi2ps zmm18, zmm31, zmm30
    vprord zmm16, zmm7, 23
    vgetmantps zmm13, zmm7, 4
    vpermi2ps zmm8, zmm29, zmm28
    vmovaps zmm12, zmm23
    vfmadd231ps zmm12, zmm22, zmm2
    vsubps zmm3, zmm21, zmm4
    vmovaps zmm1, zmm2
    vfmadd231ps zmm1, zmm0, zmm2
    vpermi2ps zmm16, zmm27, zmm26
    vfmsub213ps zmm13, zmm18, zmm25
    vfmadd213ps zmm12, zmm2, zmm24
    vdivps zmm11, zmm20, zmm15
    vfmadd231ps zmm0, zmm1, zmm12
    vmovups zmm7, [rsp+3008]
    vfnmadd231ps zmm4, zmm3, zmm0
    vsubps zmm18, zmm11, zmm19
    vrangeps zmm2, zmm7, [c_flq]{1to16}, 11
    vpsrld zmm15, zmm7, 18
    vmovaps [rsp+5248], zmm18
    vmovaps zmm1, zmm15
    vpermi2ps zmm1, zmm31, zmm30
    vprord zmm12, zmm2, 23
    vgetmantps zmm3, zmm2, 4
    vpermi2ps zmm15, zmm29, zmm28
    vmovaps zmm0, zmm23
    vfmadd231ps zmm0, zmm22, zmm17
    vsubps zmm11, zmm21, zmm10
    vmovaps zmm7, zmm17
    vfmadd231ps zmm7, zmm9, zmm17
    vpermi2ps zmm12, zmm27, zmm26
    vfmsub231ps zmm25, zmm3, zmm1
    vfmadd213ps zmm0, zmm17, zmm24
    jmp .j2560
    ALIGN 64
.j2560:
    vdivps zmm18, zmm20, zmm6
    vfmadd231ps zmm9, zmm7, zmm0
    vmovaps zmm2, zmm23
    vfmadd231ps zmm2, zmm22, zmm13
    vfnmadd231ps zmm10, zmm11, zmm9
    vsubps zmm3, zmm18, zmm19
    vfmadd213ps zmm2, zmm13, zmm24
    vsubps zmm1, zmm21, zmm16
    vfmadd231ps zmm13, zmm8, zmm13
    vdivps zmm17, zmm20, zmm5
    vmovaps [rsp+5312], zmm3
    vfmadd231ps zmm8, zmm13, zmm2
    vfmadd231ps zmm23, zmm22, zmm25
    vfnmadd231ps zmm16, zmm1, zmm8
    vsubps zmm6, zmm17, zmm19
    vfmadd231ps zmm24, zmm23, zmm25
    vsubps zmm7, zmm21, zmm12
    vfmadd231ps zmm25, zmm15, zmm25
    vdivps zmm0, zmm20, zmm14
    vmovaps [rsp+5760], zmm6
    vfmadd231ps zmm15, zmm25, zmm24
    vdivps zmm11, zmm20, zmm4
    vfnmadd231ps zmm12, zmm7, zmm15
    vsubps zmm9, zmm0, zmm19
    vdivps zmm18, zmm20, zmm10
    vmovaps [rsp+5824], zmm9
    vsubps zmm5, zmm11, zmm19
    vdivps zmm3, zmm20, zmm16
    vmovaps [rsp+5888], zmm5
    vsubps zmm13, zmm18, zmm19
    vdivps zmm2, zmm20, zmm12
    vmovaps [rsp+5952], zmm13
    vsubps zmm1, zmm3, zmm19
    vmovaps [rsp+6016], zmm1
    vsubps zmm8, zmm2, zmm19
    vmovaps [rsp+6080], zmm8
    mov r2d, [r13 + 1286]
    or r2, [r13 + 1280]
    jnz .hk
.hr:
.g_qb:
    vmovups zmm31, [c_t6]
    vmovups zmm30, [c_t6+64]
    vmovups zmm29, [c_w6]
    vmovups zmm28, [c_w6+64]
    vmovups zmm27, [c_rq]
    vmovups zmm26, [c_rq+64]
    vbroadcastss zmm25, [c_one]
    vbroadcastss zmm24, [c_q60]
    vbroadcastss zmm23, [c_q61]
    vbroadcastss zmm22, [c_q62]
    vbroadcastss zmm21, [c_sign]
    vmovups zmm0, [rsp+3072]
    vmovups zmm1, [rsp+3136]
    vmovups zmm2, [rsp+3200]
    vpsrld zmm3, zmm0, 18
    vpsrld zmm4, zmm0, 23
    vgetmantps zmm5, zmm0, 4
    vpsrld zmm6, zmm1, 18
    vpsrld zmm7, zmm1, 23
    vgetmantps zmm8, zmm1, 4
    vpermi2ps zmm4, zmm31, zmm30
    vmovaps zmm9, zmm3
    vpermi2ps zmm9, zmm29, zmm28
    vpsrld zmm10, zmm2, 18
    vpermi2ps zmm3, zmm27, zmm26
    vmovaps zmm11, zmm6
    vpermi2ps zmm11, zmm29, zmm28
    vpsrld zmm12, zmm2, 23
    jmp .j2624
    ALIGN 64
.j2624:
    vpermi2ps zmm7, zmm31, zmm30
    vpermi2ps zmm6, zmm27, zmm26
    vgetmantps zmm13, zmm2, 4
    vmovaps zmm14, zmm10
    vpermi2ps zmm14, zmm29, zmm28
    vpermi2ps zmm10, zmm27, zmm26
    vmovups zmm15, [rsp+3264]
    vpermi2ps zmm12, zmm31, zmm30
    vmulps zmm16, zmm4, zmm9
    vfmsub213ps zmm5, zmm3, zmm25
    vmulps zmm17, zmm7, zmm11
    vfmsub213ps zmm8, zmm6, zmm25
    vfmsub213ps zmm13, zmm10, zmm25
    vpsrld zmm18, zmm15, 18
    vpsrld zmm19, zmm15, 23
    vmulps zmm20, zmm12, zmm14
    vgetmantps zmm0, zmm15, 4
    vpermi2ps zmm19, zmm31, zmm30
    vmovaps zmm1, zmm18
    vpermi2ps zmm1, zmm29, zmm28
    vmovaps zmm2, zmm23
    vfmadd231ps zmm2, zmm22, zmm5
    vmulps zmm4, zmm16, zmm5
    vpermi2ps zmm18, zmm27, zmm26
    vmovups zmm9, [rsp+3328]
    vmovaps zmm3, zmm23
    vfmadd231ps zmm3, zmm22, zmm8
    vmulps zmm7, zmm17, zmm8
    vmovaps zmm11, zmm23
    vfmadd231ps zmm11, zmm22, zmm13
    vmulps zmm6, zmm20, zmm13
    vfmadd213ps zmm2, zmm5, zmm24
    vmulps zmm10, zmm19, zmm1
    vfmadd213ps zmm3, zmm8, zmm24
    vfmsub213ps zmm0, zmm18, zmm25
    vpsrld zmm12, zmm9, 18
    vpsrld zmm14, zmm9, 23
    vfmadd213ps zmm11, zmm13, zmm24
    vgetmantps zmm15, zmm9, 4
    vmovups zmm5, [rsp+3392]
    vpermi2ps zmm14, zmm31, zmm30
    vmovaps zmm19, zmm12
    vpermi2ps zmm19, zmm29, zmm28
    vpermi2ps zmm12, zmm27, zmm26
    vfmadd231ps zmm16, zmm4, zmm2
    vfmadd231ps zmm17, zmm7, zmm3
    vmovaps zmm1, zmm23
    vfmadd231ps zmm1, zmm22, zmm0
    vfmadd231ps zmm20, zmm6, zmm11
    vmulps zmm8, zmm10, zmm0
    vpsrld zmm18, zmm5, 18
    vpsrld zmm13, zmm5, 23
    vgetmantps zmm9, zmm5, 4
    vmulps zmm4, zmm14, zmm19
    vpternlogd zmm16, zmm21, [rsp], 184
    vfmsub213ps zmm15, zmm12, zmm25
    vpermi2ps zmm13, zmm31, zmm30
    vmovaps zmm2, zmm18
    vpermi2ps zmm2, zmm29, zmm28
    vpternlogd zmm17, zmm21, [rsp+64], 184
    vfmadd213ps zmm1, zmm0, zmm24
    vpermi2ps zmm18, zmm27, zmm26
    vpternlogd zmm20, zmm21, [rsp+128], 184
    vpmaxud zmm7, zmm16, zmm17
    jmp .j2688
    ALIGN 64
.j2688:
    vmovups zmm3, [rsp+3840]
    vmovaps zmm6, zmm23
    vfmadd231ps zmm6, zmm22, zmm15
    vmulps zmm11, zmm4, zmm15
    vpmaxud zmm5, zmm7, zmm20
    vfmadd231ps zmm10, zmm8, zmm1
    vmulps zmm14, zmm13, zmm2
    vfmsub213ps zmm9, zmm18, zmm25
    vpminsd zmm19, zmm5, [c_zero]{1to16}
    vfmadd213ps zmm6, zmm15, zmm24
    vpsrld zmm12, zmm3, 18
    vpsrld zmm0, zmm3, 23
    vpternlogd zmm10, zmm21, [rsp+192], 184
    vgetmantps zmm7, zmm3, 4
    vmovaps zmm8, zmm23
    vfmadd231ps zmm8, zmm22, zmm9
    vmulps zmm1, zmm14, zmm9
    vpermi2ps zmm0, zmm31, zmm30
    vmovaps zmm13, zmm12
    vpermi2ps zmm13, zmm29, zmm28
    vmovups zmm2, [rsp+3904]
    vaddps zmm18, zmm16, zmm10
    vpermi2ps zmm12, zmm27, zmm26
    vfmadd231ps zmm4, zmm11, zmm6
    vfmadd213ps zmm8, zmm9, zmm24
    vmovaps [rsp+9024], zmm18
    vmulps zmm5, zmm0, zmm13
    vpsrld zmm15, zmm2, 18
    vpsrld zmm3, zmm2, 23
    vfmsub213ps zmm7, zmm12, zmm25
    vgetmantps zmm16, zmm2, 4
    vpternlogd zmm4, zmm21, [rsp+256], 184
    vmovups zmm11, [rsp+3968]
    vpermi2ps zmm3, zmm31, zmm30
    vmovaps zmm6, zmm15
    vpermi2ps zmm6, zmm29, zmm28
    vfmadd231ps zmm14, zmm1, zmm8
    vpermi2ps zmm15, zmm27, zmm26
    vpmaxud zmm9, zmm10, zmm4
    vaddps zmm0, zmm17, zmm4
    vmovaps zmm13, zmm23
    vfmadd231ps zmm13, zmm22, zmm7
    vmulps zmm12, zmm5, zmm7
    vmovaps [rsp+9088], zmm0
    vpsrld zmm2, zmm11, 18
    vpsrld zmm1, zmm11, 23
    vpternlogd zmm14, zmm21, [rsp+320], 184
    vmulps zmm8, zmm3, zmm6
    vgetmantps zmm10, zmm11, 4
    vfmsub213ps zmm16, zmm15, zmm25
    vpermi2ps zmm1, zmm31, zmm30
    vmovaps zmm17, zmm2
    vpermi2ps zmm17, zmm29, zmm28
    vmovups zmm4, [rsp+4032]
    vpmaxud zmm3, zmm9, zmm14
    vaddps zmm6, zmm20, zmm14
    vfmadd213ps zmm13, zmm7, zmm24
    vpermi2ps zmm2, zmm27, zmm26
    vpminsd zmm11, zmm3, [c_zero]{1to16}
    vmovaps [rsp+9152], zmm6
    vmovaps zmm15, zmm23
    vfmadd231ps zmm15, zmm22, zmm16
    vmulps zmm9, zmm8, zmm16
    vaddps zmm20, zmm19, zmm11
    jmp .j2752
    ALIGN 64
.j2752:
    vfmadd231ps zmm5, zmm12, zmm13
    vmulps zmm14, zmm1, zmm17
    vpsrld zmm7, zmm4, 18
    vfmsub213ps zmm10, zmm2, zmm25
    vpsrld zmm3, zmm4, 23
    vgetmantps zmm19, zmm4, 4
    vmovups zmm11, [rsp+4096]
    vmovaps zmm12, zmm7
    vpermi2ps zmm12, zmm29, zmm28
    vpermi2ps zmm7, zmm27, zmm26
    vmovaps [rsp+9216], zmm20
    vfmadd213ps zmm15, zmm16, zmm24
    vpermi2ps zmm3, zmm31, zmm30
    vpternlogd zmm5, zmm21, [rsp+768], 184
    vmovaps zmm13, zmm23
    vfmadd231ps zmm13, zmm22, zmm10
    vmulps zmm1, zmm14, zmm10
    vpsrld zmm17, zmm11, 18
    vpsrld zmm2, zmm11, 23
    vgetmantps zmm4, zmm11, 4
    vmovups zmm16, [rsp+4160]
    vfmadd231ps zmm8, zmm9, zmm15
    vfmsub213ps zmm19, zmm7, zmm25
    vmulps zmm11, zmm3, zmm12
    vpermi2ps zmm2, zmm31, zmm30
    vmovaps zmm9, zmm17
    vpermi2ps zmm9, zmm29, zmm28
    vpermi2ps zmm17, zmm27, zmm26
    vfmadd213ps zmm13, zmm10, zmm24
    vpternlogd zmm8, zmm21, [rsp+832], 184
    vmovaps zmm15, zmm23
    vfmadd231ps zmm15, zmm22, zmm19
    vmulps zmm7, zmm11, zmm19
    vpsrld zmm3, zmm16, 18
    vpsrld zmm12, zmm16, 23
    vgetmantps zmm10, zmm16, 4
    vmulps zmm16, zmm2, zmm9
    vfmadd231ps zmm14, zmm1, zmm13
    vpmaxud zmm2, zmm5, zmm8
    vfmsub213ps zmm4, zmm17, zmm25
    vmovaps zmm9, zmm3
    vpermi2ps zmm9, zmm29, zmm28
    vpermi2ps zmm12, zmm31, zmm30
    vpermi2ps zmm3, zmm27, zmm26
    vfmadd213ps zmm15, zmm19, zmm24
    vpternlogd zmm14, zmm21, [rsp+896], 184
    vmovaps zmm1, zmm23
    vfmadd231ps zmm1, zmm22, zmm4
    vmulps zmm13, zmm16, zmm4
    vmulps zmm17, zmm12, zmm9
    vfmsub213ps zmm10, zmm3, zmm25
    vpmaxud zmm19, zmm2, zmm14
    vfmadd231ps zmm11, zmm7, zmm15
    vpminsd zmm12, zmm19, [c_zero]{1to16}
    vfmadd213ps zmm1, zmm4, zmm24
    vmovups zmm9, [rsp+4608]
    vmovaps zmm3, zmm23
    vfmadd231ps zmm3, zmm22, zmm10
    vmulps zmm2, zmm17, zmm10
    vpternlogd zmm11, zmm21, [rsp+960], 184
    vfmadd231ps zmm16, zmm13, zmm1
    vaddps zmm7, zmm5, zmm11
    vfmadd213ps zmm3, zmm10, zmm24
    vpsrld zmm15, zmm9, 18
    jmp .j2816
    ALIGN 64
.j2816:
    vpsrld zmm19, zmm9, 23
    vgetmantps zmm4, zmm9, 4
    vmovaps [rsp+9280], zmm7
    vaddps zmm13, zmm7, zmm18
    vpermi2ps zmm19, zmm31, zmm30
    vmovaps zmm1, zmm15
    vpermi2ps zmm1, zmm29, zmm28
    vpternlogd zmm16, zmm21, [rsp+1024], 184
    vpermi2ps zmm15, zmm27, zmm26
    vmovups zmm5, [rsp+4672]
    vfmadd231ps zmm17, zmm2, zmm3
    vmovaps [r13], zmm13
    vpmaxud zmm10, zmm11, zmm16
    vaddps zmm9, zmm8, zmm16
    vmulps zmm7, zmm19, zmm1
    vmovaps [rsp+9344], zmm9
    vaddps zmm18, zmm9, zmm0
    vfmsub213ps zmm4, zmm15, zmm25
    vpsrld zmm2, zmm5, 18
    vpternlogd zmm17, zmm21, [rsp+1088], 184
    vpsrld zmm3, zmm5, 23
    vgetmantps zmm13, zmm5, 4
    vmovups zmm11, [rsp+4736]
    vmovaps zmm8, zmm2
    vpermi2ps zmm8, zmm29, zmm28
    vpermi2ps zmm2, zmm27, zmm26
    vpmaxud zmm16, zmm10, zmm17
    vaddps zmm19, zmm14, zmm17
    vmovaps [r13+64], zmm18
    vpermi2ps zmm3, zmm31, zmm30
    vmovaps zmm1, zmm23
    vfmadd231ps zmm1, zmm22, zmm4
    vmulps zmm9, zmm7, zmm4
    vpminsd zmm0, zmm16, [c_zero]{1to16}
    vmovaps [rsp+9408], zmm19
    vaddps zmm15, zmm19, zmm6
    vpsrld zmm5, zmm11, 18
    vpsrld zmm10, zmm11, 23
    vaddps zmm14, zmm12, zmm0
    vfmsub213ps zmm13, zmm2, zmm25
    vgetmantps zmm17, zmm11, 4
    vmulps zmm18, zmm3, zmm8
    vmovups zmm16, [rsp+4800]
    vmovaps [r13+128], zmm15
    vfmadd213ps zmm1, zmm4, zmm24
    vpermi2ps zmm10, zmm31, zmm30
    vmovaps zmm19, zmm5
    vpermi2ps zmm19, zmm29, zmm28
    vpermi2ps zmm5, zmm27, zmm26
    vmovaps [rsp+9472], zmm14
    vaddps zmm6, zmm14, zmm20
    vmovaps zmm12, zmm23
    vfmadd231ps zmm12, zmm22, zmm13
    vmulps zmm0, zmm18, zmm13
    vmovaps [r13+192], zmm6
    vfmadd231ps zmm7, zmm9, zmm1
    vpsrld zmm2, zmm16, 18
    vpsrld zmm11, zmm16, 23
    vmulps zmm3, zmm10, zmm19
    vgetmantps zmm8, zmm16, 4
    vmovups zmm15, [rsp+4864]
    vfmsub213ps zmm17, zmm5, zmm25
    vpermi2ps zmm11, zmm31, zmm30
    vmovaps zmm4, zmm2
    jmp .j2880
    ALIGN 64
.j2880:
    vpermi2ps zmm4, zmm29, zmm28
    vfmadd213ps zmm12, zmm13, zmm24
    vpermi2ps zmm2, zmm27, zmm26
    vpternlogd zmm7, zmm21, [rsp+1536], 184
    vmovaps zmm14, zmm23
    vfmadd231ps zmm14, zmm22, zmm17
    vmulps zmm20, zmm3, zmm17
    vpsrld zmm6, zmm15, 18
    vpsrld zmm9, zmm15, 23
    vgetmantps zmm1, zmm15, 4
    vmovups zmm10, [rsp+4928]
    vfmadd231ps zmm18, zmm0, zmm12
    vmulps zmm19, zmm11, zmm4
    vfmsub213ps zmm8, zmm2, zmm25
    vpermi2ps zmm9, zmm31, zmm30
    vmovaps zmm16, zmm6
    vpermi2ps zmm16, zmm29, zmm28
    vpermi2ps zmm6, zmm27, zmm26
    vfmadd213ps zmm14, zmm17, zmm24
    vpternlogd zmm18, zmm21, [rsp+1600], 184
    vpsrld zmm5, zmm10, 18
    vpsrld zmm13, zmm10, 23
    vmovaps zmm15, zmm23
    vfmadd231ps zmm15, zmm22, zmm8
    vmulps zmm0, zmm19, zmm8
    vgetmantps zmm12, zmm10, 4
    vmulps zmm11, zmm9, zmm16
    vpmaxud zmm4, zmm7, zmm18
    vfmsub213ps zmm1, zmm6, zmm25
    vpermi2ps zmm13, zmm31, zmm30
    vmovaps zmm2, zmm5
    vpermi2ps zmm2, zmm29, zmm28
    vfmadd231ps zmm3, zmm20, zmm14
    vpermi2ps zmm5, zmm27, zmm26
    vfmadd213ps zmm15, zmm8, zmm24
    vmovaps zmm17, zmm23
    vfmadd231ps zmm17, zmm22, zmm1
    vmulps zmm10, zmm11, zmm1
    vpternlogd zmm3, zmm21, [rsp+1664], 184
    vmulps zmm9, zmm13, zmm2
    vmovups zmm16, [rsp+5376]
    vfmsub213ps zmm12, zmm5, zmm25
    vpmaxud zmm6, zmm4, zmm3
    vfmadd231ps zmm19, zmm0, zmm15
    vfmadd213ps zmm17, zmm1, zmm24
    vpminsd zmm20, zmm6, [c_zero]{1to16}
    vmovaps zmm14, zmm23
    vfmadd231ps zmm14, zmm22, zmm12
    vmulps zmm8, zmm9, zmm12
    vpsrld zmm13, zmm16, 18
    vpsrld zmm2, zmm16, 23
    vgetmantps zmm5, zmm16, 4
    vpternlogd zmm19, zmm21, [rsp+1728], 184
    vmovups zmm4, [rsp+5440]
    vpermi2ps zmm2, zmm31, zmm30
    vmovaps zmm0, zmm13
    vpermi2ps zmm0, zmm29, zmm28
    vfmadd231ps zmm11, zmm10, zmm17
    vpermi2ps zmm13, zmm27, zmm26
    vaddps zmm15, zmm7, zmm19
    vfmadd213ps zmm14, zmm12, zmm24
    vmovaps [rsp+9536], zmm15
    vpsrld zmm1, zmm4, 18
    vpsrld zmm6, zmm4, 23
    jmp .j2944
    ALIGN 64
.j2944:
    vpternlogd zmm11, zmm21, [rsp+1792], 184
    vmulps zmm16, zmm2, zmm0
    vgetmantps zmm10, zmm4, 4
    vfmsub213ps zmm5, zmm13, zmm25
    vmovups zmm17, [rsp+5504]
    vfmadd231ps zmm9, zmm8, zmm14
    vpermi2ps zmm6, zmm31, zmm30
    vmovaps zmm7, zmm1
    vpermi2ps zmm7, zmm29, zmm28
    vpmaxud zmm12, zmm19, zmm11
    vaddps zmm2, zmm18, zmm11
    vpermi2ps zmm1, zmm27, zmm26
    vmovaps [rsp+9600], zmm2
    vmovaps zmm0, zmm23
    vfmadd231ps zmm0, zmm22, zmm5
    vmulps zmm4, zmm16, zmm5
    vpternlogd zmm9, zmm21, [rsp+1856], 184
    vpsrld zmm13, zmm17, 18
    vpsrld zmm8, zmm17, 23
    vmulps zmm14, zmm6, zmm7
    vgetmantps zmm19, zmm17, 4
    vfmsub213ps zmm10, zmm1, zmm25
    vpmaxud zmm18, zmm12, zmm9
    vaddps zmm11, zmm3, zmm9
    vpermi2ps zmm8, zmm31, zmm30
    vmovaps zmm6, zmm13
    vpermi2ps zmm6, zmm29, zmm28
    vmovups zmm7, [rsp+5568]
    vpermi2ps zmm13, zmm27, zmm26
    vfmadd213ps zmm0, zmm5, zmm24
    vpminsd zmm17, zmm18, [c_zero]{1to16}
    vmovaps [rsp+9664], zmm11
    vmovaps zmm1, zmm23
    vfmadd231ps zmm1, zmm22, zmm10
    vmulps zmm12, zmm14, zmm10
    vaddps zmm3, zmm20, zmm17
    vmulps zmm9, zmm8, zmm6
    vpsrld zmm5, zmm7, 18
    vpsrld zmm18, zmm7, 23
    vfmadd231ps zmm16, zmm4, zmm0
    vfmsub213ps zmm19, zmm13, zmm25
    vgetmantps zmm20, zmm7, 4
    vmovups zmm17, [rsp+5632]
    vmovaps [rsp+9728], zmm3
    vpermi2ps zmm18, zmm31, zmm30
    vmovaps zmm8, zmm5
    vpermi2ps zmm8, zmm29, zmm28
    vfmadd213ps zmm1, zmm10, zmm24
    vpermi2ps zmm5, zmm27, zmm26
    vpternlogd zmm16, zmm21, [rsp+2304], 184
    vmovaps zmm6, zmm23
    vfmadd231ps zmm6, zmm22, zmm19
    vmulps zmm4, zmm9, zmm19
    vpsrld zmm0, zmm17, 18
    vpsrld zmm13, zmm17, 23
    vgetmantps zmm7, zmm17, 4
    vmovups zmm10, [rsp+5696]
    vfmadd231ps zmm14, zmm12, zmm1
    vmulps zmm17, zmm18, zmm8
    vfmsub213ps zmm20, zmm5, zmm25
    vpermi2ps zmm13, zmm31, zmm30
    vmovaps zmm12, zmm0
    vpermi2ps zmm12, zmm29, zmm28
    vpermi2ps zmm0, zmm27, zmm26
    jmp .j3008
    ALIGN 64
.j3008:
    vfmadd213ps zmm6, zmm19, zmm24
    vpternlogd zmm14, zmm21, [rsp+2368], 184
    vpsrld zmm1, zmm10, 18
    vpsrld zmm18, zmm10, 23
    vmovaps zmm8, zmm23
    vfmadd231ps zmm8, zmm22, zmm20
    vmulps zmm5, zmm17, zmm20
    vgetmantps zmm19, zmm10, 4
    vmulps zmm10, zmm13, zmm12
    vfmadd231ps zmm9, zmm4, zmm6
    vpmaxud zmm13, zmm16, zmm14
    vfmsub213ps zmm7, zmm0, zmm25
    vpermi2ps zmm18, zmm31, zmm30
    vmovaps zmm12, zmm1
    vpermi2ps zmm12, zmm29, zmm28
    vpermi2ps zmm1, zmm27, zmm26
    vfmadd213ps zmm8, zmm20, zmm24
    vpternlogd zmm9, zmm21, [rsp+2432], 184
    vmovaps zmm4, zmm23
    vfmadd231ps zmm4, zmm22, zmm7
    vmulps zmm6, zmm10, zmm7
    vmulps zmm0, zmm18, zmm12
    vfmsub213ps zmm19, zmm1, zmm25
    vpmaxud zmm20, zmm13, zmm9
    vfmadd231ps zmm17, zmm5, zmm8
    vpminsd zmm18, zmm20, [c_zero]{1to16}
    vfmadd213ps zmm4, zmm7, zmm24
    vmovups zmm12, [rsp+3456]
    vmovaps zmm1, zmm23
    vfmadd231ps zmm1, zmm22, zmm19
    vmulps zmm13, zmm0, zmm19
    vpternlogd zmm17, zmm21, [rsp+2496], 184
    vfmadd231ps zmm10, zmm6, zmm4
    vaddps zmm5, zmm16, zmm17
    vfmadd213ps zmm1, zmm19, zmm24
    vpsrld zmm8, zmm12, 18
    vpsrld zmm20, zmm12, 23
    vgetmantps zmm7, zmm12, 4
    vmovaps [rsp+9792], zmm5
    vaddps zmm6, zmm5, zmm15
    vpermi2ps zmm20, zmm31, zmm30
    vmovaps zmm4, zmm8
    vpermi2ps zmm4, zmm29, zmm28
    vpternlogd zmm10, zmm21, [rsp+2560], 184
    vpermi2ps zmm8, zmm27, zmm26
    vmovups zmm16, [rsp+3520]
    vfmadd231ps zmm0, zmm13, zmm1
    vpmaxud zmm19, zmm17, zmm10
    vaddps zmm12, zmm14, zmm10
    vmovaps [r13+512], zmm6
    vmulps zmm5, zmm20, zmm4
    vmovaps [rsp+9856], zmm12
    vaddps zmm15, zmm12, zmm2
    vfmsub213ps zmm7, zmm8, zmm25
    vpsrld zmm13, zmm16, 18
    vpternlogd zmm0, zmm21, [rsp+2624], 184
    vpsrld zmm1, zmm16, 23
    vgetmantps zmm17, zmm16, 4
    vmovups zmm14, [rsp+3584]
    vmovaps zmm10, zmm13
    vpermi2ps zmm10, zmm29, zmm28
    vpermi2ps zmm13, zmm27, zmm26
    vpmaxud zmm6, zmm19, zmm0
    vaddps zmm20, zmm9, zmm0
    jmp .j3072
    ALIGN 64
.j3072:
    vmovaps [r13+576], zmm15
    vpermi2ps zmm1, zmm31, zmm30
    vmovaps zmm4, zmm23
    vfmadd231ps zmm4, zmm22, zmm7
    vmulps zmm12, zmm5, zmm7
    vpminsd zmm2, zmm6, [c_zero]{1to16}
    vmovaps [rsp+9920], zmm20
    vaddps zmm8, zmm20, zmm11
    vpsrld zmm16, zmm14, 18
    vpsrld zmm19, zmm14, 23
    vaddps zmm9, zmm18, zmm2
    vfmsub213ps zmm17, zmm13, zmm25
    vgetmantps zmm0, zmm14, 4
    vmulps zmm15, zmm1, zmm10
    vmovups zmm6, [rsp+3648]
    vmovaps [r13+640], zmm8
    vfmadd213ps zmm4, zmm7, zmm24
    vpermi2ps zmm19, zmm31, zmm30
    vmovaps zmm20, zmm16
    vpermi2ps zmm20, zmm29, zmm28
    vpermi2ps zmm16, zmm27, zmm26
    vmovaps [rsp+9984], zmm9
    vaddps zmm11, zmm9, zmm3
    vmovaps zmm18, zmm23
    vfmadd231ps zmm18, zmm22, zmm17
    vmulps zmm2, zmm15, zmm17
    vmovaps [r13+704], zmm11
    vfmadd231ps zmm5, zmm12, zmm4
    vpsrld zmm13, zmm6, 18
    vpsrld zmm14, zmm6, 23
    vmulps zmm1, zmm19, zmm20
    vgetmantps zmm10, zmm6, 4
    vmovups zmm8, [rsp+3712]
    vfmsub213ps zmm0, zmm16, zmm25
    vpermi2ps zmm14, zmm31, zmm30
    vmovaps zmm7, zmm13
    vpermi2ps zmm7, zmm29, zmm28
    vfmadd213ps zmm18, zmm17, zmm24
    vpermi2ps zmm13, zmm27, zmm26
    vpternlogd zmm5, zmm21, [rsp+384], 184
    vmovaps zmm9, zmm23
    vfmadd231ps zmm9, zmm22, zmm0
    vmulps zmm3, zmm1, zmm0
    vpsrld zmm11, zmm8, 18
    vpsrld zmm12, zmm8, 23
    vgetmantps zmm4, zmm8, 4
    vmovups zmm19, [rsp+3776]
    vfmadd231ps zmm15, zmm2, zmm18
    vmulps zmm20, zmm14, zmm7
    vfmsub213ps zmm10, zmm13, zmm25
    vpermi2ps zmm12, zmm31, zmm30
    vmovaps zmm6, zmm11
    vpermi2ps zmm6, zmm29, zmm28
    vpermi2ps zmm11, zmm27, zmm26
    vfmadd213ps zmm9, zmm0, zmm24
    vpternlogd zmm15, zmm21, [rsp+448], 184
    vpsrld zmm16, zmm19, 18
    vpsrld zmm17, zmm19, 23
    vmovaps zmm8, zmm23
    vfmadd231ps zmm8, zmm22, zmm10
    vmulps zmm2, zmm20, zmm10
    vgetmantps zmm18, zmm19, 4
    vmulps zmm14, zmm12, zmm6
    vpmaxud zmm7, zmm5, zmm15
    jmp .j3136
    ALIGN 64
.j3136:
    vfmsub213ps zmm4, zmm11, zmm25
    vpermi2ps zmm17, zmm31, zmm30
    vmovaps zmm13, zmm16
    vpermi2ps zmm13, zmm29, zmm28
    vfmadd231ps zmm1, zmm3, zmm9
    vpermi2ps zmm16, zmm27, zmm26
    vaddps zmm0, zmm5, [rsp+r3*8+(CRY+4*W+4*W*0+0)]
    vaddps zmm19, zmm15, [rsp+r3*8+(CRY+4*W+4*W*0+64)]
    vfmadd213ps zmm8, zmm10, zmm24
    vmovaps zmm12, zmm23
    vfmadd231ps zmm12, zmm22, zmm4
    vmulps zmm6, zmm14, zmm4
    vpternlogd zmm1, zmm21, [rsp+512], 184
    vmulps zmm11, zmm17, zmm13
    vfmsub213ps zmm18, zmm16, zmm25
    vaddps zmm3, zmm0, [rsp+9024]
    vaddps zmm9, zmm19, [rsp+9088]
    vpmaxud zmm10, zmm7, zmm1
    vfmadd231ps zmm20, zmm2, zmm8
    vaddps zmm17, zmm1, [rsp+r3*8+(CRY+4*W+4*W*0+128)]
    vfmadd213ps zmm12, zmm4, zmm24
    vmovaps [rsp+10048], zmm3
    vpminsd zmm13, zmm10, [c_zero]{1to16}
    vmovaps [rsp+10112], zmm9
    vmovups zmm16, [rsp+4224]
    vmovaps zmm0, zmm23
    vfmadd231ps zmm0, zmm22, zmm18
    vmulps zmm19, zmm11, zmm18
    vaddps zmm7, zmm17, [rsp+9152]
    vpternlogd zmm20, zmm21, [rsp+576], 184
    vaddps zmm2, zmm13, [rsp+r3*8+(CRY+4*W+4*W*0+192)]
    vfmadd231ps zmm14, zmm6, zmm12
    vmovaps [rsp+10176], zmm7
    vaddps zmm8, zmm5, zmm20
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+0)], zmm20
    vfmadd213ps zmm0, zmm18, zmm24
    vaddps zmm4, zmm2, [rsp+9216]
    vpsrld zmm3, zmm16, 18
    vpsrld zmm10, zmm16, 23
    vgetmantps zmm9, zmm16, 4
    vmovups zmm17, [rsp+4288]
    vmovaps zmm6, zmm3
    vpermi2ps zmm6, zmm29, zmm28
    vpermi2ps zmm3, zmm27, zmm26
    vpternlogd zmm14, zmm21, [rsp+640], 184
    vmovaps [rsp+10240], zmm4
    vpermi2ps zmm10, zmm31, zmm30
    vfmadd231ps zmm11, zmm19, zmm0
    vpmaxud zmm12, zmm20, zmm14
    vaddps zmm7, zmm15, zmm14
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+64)], zmm14
    vpsrld zmm5, zmm17, 18
    vpsrld zmm18, zmm17, 23
    vmovups zmm2, [rsp+4352]
    vgetmantps zmm16, zmm17, 4
    vfmsub213ps zmm9, zmm3, zmm25
    vmulps zmm4, zmm10, zmm6
    vpermi2ps zmm18, zmm31, zmm30
    vmovaps zmm19, zmm5
    vpermi2ps zmm19, zmm29, zmm28
    vpternlogd zmm11, zmm21, [rsp+704], 184
    vpermi2ps zmm5, zmm27, zmm26
    vpmaxud zmm0, zmm12, zmm11
    vaddps zmm20, zmm1, zmm11
    jmp .j3200
    ALIGN 64
.j3200:
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+128)], zmm11
    vpsrld zmm15, zmm2, 18
    vmovaps zmm14, zmm23
    vfmadd231ps zmm14, zmm22, zmm9
    vmulps zmm17, zmm4, zmm9
    vpsrld zmm3, zmm2, 23
    vgetmantps zmm10, zmm2, 4
    vmovups zmm6, [rsp+4416]
    vpminsd zmm12, zmm0, [c_zero]{1to16}
    vmulps zmm1, zmm18, zmm19
    vmovaps zmm11, zmm15
    vpermi2ps zmm11, zmm29, zmm28
    vpermi2ps zmm15, zmm27, zmm26
    vfmsub213ps zmm16, zmm5, zmm25
    vpermi2ps zmm3, zmm31, zmm30
    vaddps zmm2, zmm13, zmm12
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+192)], zmm12
    vfmadd213ps zmm14, zmm9, zmm24
    vpsrld zmm0, zmm6, 18
    vpsrld zmm18, zmm6, 23
    vmovaps zmm19, zmm23
    vfmadd231ps zmm19, zmm22, zmm16
    vmulps zmm5, zmm1, zmm16
    vgetmantps zmm13, zmm6, 4
    vmulps zmm12, zmm3, zmm11
    vfmsub213ps zmm10, zmm15, zmm25
    vmovups zmm9, [rsp+4480]
    vpermi2ps zmm18, zmm31, zmm30
    vmovaps zmm6, zmm0
    vpermi2ps zmm6, zmm29, zmm28
    vfmadd231ps zmm4, zmm17, zmm14
    vpermi2ps zmm0, zmm27, zmm26
    vfmadd213ps zmm19, zmm16, zmm24
    vmovaps zmm3, zmm23
    vfmadd231ps zmm3, zmm22, zmm10
    vmulps zmm11, zmm12, zmm10
    vpsrld zmm15, zmm9, 18
    vpsrld zmm17, zmm9, 23
    vpternlogd zmm4, zmm21, [rsp+1152], 184
    vmulps zmm14, zmm18, zmm6
    vgetmantps zmm16, zmm9, 4
    vmovups zmm18, [rsp+4544]
    vfmsub213ps zmm13, zmm0, zmm25
    vpermi2ps zmm17, zmm31, zmm30
    vmovaps zmm6, zmm15
    vpermi2ps zmm6, zmm29, zmm28
    vfmadd231ps zmm1, zmm5, zmm19
    vpermi2ps zmm15, zmm27, zmm26
    vfmadd213ps zmm3, zmm10, zmm24
    vmovaps zmm9, zmm23
    vfmadd231ps zmm9, zmm22, zmm13
    vmulps zmm0, zmm14, zmm13
    vpsrld zmm5, zmm18, 18
    vpsrld zmm19, zmm18, 23
    vgetmantps zmm10, zmm18, 4
    vpternlogd zmm1, zmm21, [rsp+1216], 184
    vmulps zmm18, zmm17, zmm6
    vfmadd231ps zmm12, zmm11, zmm3
    vfmsub213ps zmm16, zmm15, zmm25
    vpermi2ps zmm19, zmm31, zmm30
    vmovaps zmm17, zmm5
    vpermi2ps zmm17, zmm29, zmm28
    vpermi2ps zmm5, zmm27, zmm26
    vpmaxud zmm6, zmm4, zmm1
    jmp .j3264
    ALIGN 64
.j3264:
    vaddps zmm11, zmm4, [rsp+r3*8+(CRY+4*W+4*W*1+0)]
    vaddps zmm3, zmm1, [rsp+r3*8+(CRY+4*W+4*W*1+64)]
    vfmadd213ps zmm9, zmm13, zmm24
    vpternlogd zmm12, zmm21, [rsp+1280], 184
    vmovaps zmm15, zmm23
    vfmadd231ps zmm15, zmm22, zmm16
    vmulps zmm13, zmm18, zmm16
    vaddps zmm11, zmm11, [rsp+9280]
    vmulps zmm19, zmm19, zmm17
    vfmsub213ps zmm10, zmm5, zmm25
    vaddps zmm17, zmm3, [rsp+9344]
    vpmaxud zmm5, zmm6, zmm12
    vfmadd231ps zmm14, zmm0, zmm9
    vaddps zmm3, zmm12, [rsp+r3*8+(CRY+4*W+4*W*1+128)]
    vmovaps [rsp+10304], zmm11
    vpminsd zmm6, zmm5, [c_zero]{1to16}
    vfmadd213ps zmm15, zmm16, zmm24
    vmovaps [rsp+10368], zmm17
    vaddps zmm0, zmm3, [rsp+9408]
    vmovaps zmm9, zmm23
    vfmadd231ps zmm9, zmm22, zmm10
    vmulps zmm11, zmm19, zmm10
    vpternlogd zmm14, zmm21, [rsp+1344], 184
    vaddps zmm5, zmm6, [rsp+r3*8+(CRY+4*W+4*W*1+192)]
    vmovups zmm16, [rsp+4992]
    vmovaps [rsp+10432], zmm0
    vfmadd231ps zmm18, zmm13, zmm15
    vaddps zmm17, zmm4, zmm14
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+0)], zmm14
    vaddps zmm3, zmm5, [rsp+9472]
    vfmadd213ps zmm9, zmm10, zmm24
    vaddps zmm0, zmm17, zmm8
    vmovaps [rsp+10496], zmm3
    vpsrld zmm13, zmm16, 18
    vpsrld zmm15, zmm16, 23
    vpternlogd zmm18, zmm21, [rsp+1408], 184
    vgetmantps zmm4, zmm16, 4
    vfmadd231ps zmm19, zmm11, zmm9
    vmovaps [r13+256], zmm0
    vpermi2ps zmm15, zmm31, zmm30
    vmovaps zmm5, zmm13
    vpermi2ps zmm5, zmm29, zmm28
    vpmaxud zmm10, zmm14, zmm18
    vaddps zmm17, zmm1, zmm18
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+64)], zmm18
    vpermi2ps zmm13, zmm27, zmm26
    vmovups zmm8, [rsp+5056]
    vaddps zmm3, zmm17, zmm7
    vpternlogd zmm19, zmm21, [rsp+1472], 184
    vmulps zmm16, zmm15, zmm5
    vfmsub213ps zmm4, zmm13, zmm25
    vpsrld zmm11, zmm8, 18
    vpsrld zmm9, zmm8, 23
    vpmaxud zmm0, zmm10, zmm19
    vaddps zmm14, zmm12, zmm19
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+128)], zmm19
    vgetmantps zmm1, zmm8, 4
    vmovups zmm18, [rsp+5120]
    vmovaps [r13+320], zmm3
    vpermi2ps zmm9, zmm31, zmm30
    vmovaps zmm17, zmm11
    vpermi2ps zmm17, zmm29, zmm28
    vpminsd zmm7, zmm0, [c_zero]{1to16}
    vpermi2ps zmm11, zmm27, zmm26
    jmp .j3328
    ALIGN 64
.j3328:
    vaddps zmm15, zmm14, zmm20
    vmovaps zmm5, zmm23
    vfmadd231ps zmm5, zmm22, zmm4
    vmulps zmm13, zmm16, zmm4
    vaddps zmm10, zmm6, zmm7
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+192)], zmm7
    vpsrld zmm12, zmm18, 18
    vpsrld zmm19, zmm18, 23
    vmovaps [r13+384], zmm15
    vgetmantps zmm8, zmm18, 4
    vmovups zmm3, [rsp+5184]
    vmulps zmm0, zmm9, zmm17
    vaddps zmm14, zmm10, zmm2
    vfmsub213ps zmm1, zmm11, zmm25
    vpermi2ps zmm19, zmm31, zmm30
    vmovaps zmm20, zmm12
    vpermi2ps zmm20, zmm29, zmm28
    vfmadd213ps zmm5, zmm4, zmm24
    vpermi2ps zmm12, zmm27, zmm26
    vmovaps [r13+448], zmm14
    vpsrld zmm6, zmm3, 18
    vpsrld zmm7, zmm3, 23
    vmovaps zmm15, zmm23
    vfmadd231ps zmm15, zmm22, zmm1
    vmulps zmm18, zmm0, zmm1
    vgetmantps zmm9, zmm3, 4
    vfmadd231ps zmm16, zmm13, zmm5
    vmulps zmm17, zmm19, zmm20
    vmovups zmm10, [rsp+5248]
    vfmsub213ps zmm8, zmm12, zmm25
    vpermi2ps zmm7, zmm31, zmm30
    vmovaps zmm2, zmm6
    vpermi2ps zmm2, zmm29, zmm28
    vpermi2ps zmm6, zmm27, zmm26
    vfmadd213ps zmm15, zmm1, zmm24
    vpternlogd zmm16, zmm21, [rsp+1920], 184
    vmovaps zmm11, zmm23
    vfmadd231ps zmm11, zmm22, zmm8
    vmulps zmm4, zmm17, zmm8
    vpsrld zmm14, zmm10, 18
    vpsrld zmm3, zmm10, 23
    vmulps zmm13, zmm7, zmm2
    vgetmantps zmm5, zmm10, 4
    vmovups zmm19, [rsp+5312]
    vfmsub213ps zmm9, zmm6, zmm25
    vpermi2ps zmm3, zmm31, zmm30
    vmovaps zmm20, zmm14
    vpermi2ps zmm20, zmm29, zmm28
    vfmadd231ps zmm0, zmm18, zmm15
    vpermi2ps zmm14, zmm27, zmm26
    vfmadd213ps zmm11, zmm8, zmm24
    vmovaps zmm12, zmm23
    vfmadd231ps zmm12, zmm22, zmm9
    vmulps zmm1, zmm13, zmm9
    vpsrld zmm7, zmm19, 18
    vpsrld zmm2, zmm19, 23
    vgetmantps zmm10, zmm19, 4
    vpternlogd zmm0, zmm21, [rsp+1984], 184
    vmulps zmm6, zmm3, zmm20
    vfmsub213ps zmm5, zmm14, zmm25
    vpermi2ps zmm2, zmm31, zmm30
    vmovaps zmm18, zmm7
    vpermi2ps zmm18, zmm29, zmm28
    vfmadd231ps zmm17, zmm4, zmm11
    jmp .j3392
    ALIGN 64
.j3392:
    vpermi2ps zmm7, zmm27, zmm26
    vpmaxud zmm15, zmm16, zmm0
    vaddps zmm8, zmm16, [rsp+r3*8+(CRY+4*W+4*W*2+0)]
    vaddps zmm19, zmm0, [rsp+r3*8+(CRY+4*W+4*W*2+64)]
    vfmadd213ps zmm12, zmm9, zmm24
    vmovaps zmm3, zmm23
    vfmadd231ps zmm3, zmm22, zmm5
    vmulps zmm20, zmm6, zmm5
    vpternlogd zmm17, zmm21, [rsp+2048], 184
    vmulps zmm14, zmm2, zmm18
    vfmsub213ps zmm10, zmm7, zmm25
    vaddps zmm4, zmm8, [rsp+9536]
    vaddps zmm11, zmm19, [rsp+9600]
    vfmadd231ps zmm13, zmm1, zmm12
    vpmaxud zmm9, zmm15, zmm17
    vaddps zmm2, zmm17, [rsp+r3*8+(CRY+4*W+4*W*2+128)]
    vfmadd213ps zmm3, zmm5, zmm24
    vmovaps [rsp+10560], zmm4
    vpminsd zmm18, zmm9, [c_zero]{1to16}
    vmovaps [rsp+10624], zmm11
    vmovups zmm7, [rsp+5760]
    vmovaps zmm8, zmm23
    vfmadd231ps zmm8, zmm22, zmm10
    vmulps zmm19, zmm14, zmm10
    vaddps zmm1, zmm2, [rsp+9664]
    vpternlogd zmm13, zmm21, [rsp+2112], 184
    vaddps zmm12, zmm18, [rsp+r3*8+(CRY+4*W+4*W*2+192)]
    vfmadd231ps zmm6, zmm20, zmm3
    vaddps zmm15, zmm16, zmm13
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+0)], zmm13
    vmovaps [rsp+10688], zmm1
    vfmadd213ps zmm8, zmm10, zmm24
    vaddps zmm5, zmm12, [rsp+9728]
    vpsrld zmm4, zmm7, 18
    vpsrld zmm9, zmm7, 23
    vgetmantps zmm11, zmm7, 4
    vmovups zmm2, [rsp+5824]
    vmovaps zmm20, zmm4
    vpermi2ps zmm20, zmm29, zmm28
    vpermi2ps zmm4, zmm27, zmm26
    vpternlogd zmm6, zmm21, [rsp+2176], 184
    vmovaps [rsp+10752], zmm5
    vpermi2ps zmm9, zmm31, zmm30
    vfmadd231ps zmm14, zmm19, zmm8
    vpmaxud zmm3, zmm13, zmm6
    vaddps zmm16, zmm0, zmm6
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+64)], zmm6
    vpsrld zmm1, zmm2, 18
    vpsrld zmm10, zmm2, 23
    vmovups zmm12, [rsp+5888]
    vgetmantps zmm7, zmm2, 4
    vfmsub213ps zmm11, zmm4, zmm25
    vmulps zmm5, zmm9, zmm20
    vpermi2ps zmm10, zmm31, zmm30
    vmovaps zmm19, zmm1
    vpermi2ps zmm19, zmm29, zmm28
    vpternlogd zmm14, zmm21, [rsp+2240], 184
    vpermi2ps zmm1, zmm27, zmm26
    vpmaxud zmm8, zmm3, zmm14
    vaddps zmm13, zmm17, zmm14
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+128)], zmm14
    vpsrld zmm0, zmm12, 18
    vmovaps zmm6, zmm23
    vfmadd231ps zmm6, zmm22, zmm11
    jmp .j3456
    ALIGN 64
.j3456:
    vmulps zmm2, zmm5, zmm11
    vpsrld zmm4, zmm12, 23
    vgetmantps zmm9, zmm12, 4
    vmovups zmm20, [rsp+5952]
    vpminsd zmm3, zmm8, [c_zero]{1to16}
    vmulps zmm17, zmm10, zmm19
    vmovaps zmm14, zmm0
    vpermi2ps zmm14, zmm29, zmm28
    vpermi2ps zmm0, zmm27, zmm26
    vfmsub213ps zmm7, zmm1, zmm25
    vpermi2ps zmm4, zmm31, zmm30
    vaddps zmm12, zmm18, zmm3
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+192)], zmm3
    vfmadd213ps zmm6, zmm11, zmm24
    vpsrld zmm8, zmm20, 18
    vpsrld zmm10, zmm20, 23
    vmovaps zmm19, zmm23
    vfmadd231ps zmm19, zmm22, zmm7
    vmulps zmm1, zmm17, zmm7
    vgetmantps zmm18, zmm20, 4
    vmulps zmm3, zmm4, zmm14
    vfmsub213ps zmm9, zmm0, zmm25
    vmovups zmm11, [rsp+6016]
    vpermi2ps zmm10, zmm31, zmm30
    vmovaps zmm20, zmm8
    vpermi2ps zmm20, zmm29, zmm28
    vfmadd231ps zmm5, zmm2, zmm6
    vpermi2ps zmm8, zmm27, zmm26
    vfmadd213ps zmm19, zmm7, zmm24
    vmovaps zmm4, zmm23
    vfmadd231ps zmm4, zmm22, zmm9
    vmulps zmm14, zmm3, zmm9
    vpsrld zmm0, zmm11, 18
    vpsrld zmm2, zmm11, 23
    vpternlogd zmm5, zmm21, [rsp+2688], 184
    vmulps zmm6, zmm10, zmm20
    vgetmantps zmm7, zmm11, 4
    vmovups zmm10, [rsp+6080]
    vfmsub213ps zmm18, zmm8, zmm25
    vpermi2ps zmm2, zmm31, zmm30
    vmovaps zmm20, zmm0
    vpermi2ps zmm20, zmm29, zmm28
    vfmadd231ps zmm17, zmm1, zmm19
    vpermi2ps zmm0, zmm27, zmm26
    vfmadd213ps zmm4, zmm9, zmm24
    vmovaps zmm11, zmm23
    vfmadd231ps zmm11, zmm22, zmm18
    vmulps zmm8, zmm6, zmm18
    vpsrld zmm1, zmm10, 18
    vpsrld zmm19, zmm10, 23
    vgetmantps zmm9, zmm10, 4
    vpternlogd zmm17, zmm21, [rsp+2752], 184
    vmulps zmm10, zmm2, zmm20
    vfmadd231ps zmm3, zmm14, zmm4
    vfmsub213ps zmm7, zmm0, zmm25
    vpermi2ps zmm19, zmm31, zmm30
    vmovaps zmm2, zmm1
    vpermi2ps zmm2, zmm29, zmm28
    vpermi2ps zmm1, zmm27, zmm26
    vpmaxud zmm20, zmm5, zmm17
    vaddps zmm14, zmm5, [rsp+r3*8+(CRY+4*W+4*W*3+0)]
    vaddps zmm4, zmm17, [rsp+r3*8+(CRY+4*W+4*W*3+64)]
    vfmadd213ps zmm11, zmm18, zmm24
    vpternlogd zmm3, zmm21, [rsp+2816], 184
    jmp .j3520
    ALIGN 64
.j3520:
    vmovaps zmm0, zmm23
    vfmadd231ps zmm0, zmm22, zmm7
    vmulps zmm18, zmm10, zmm7
    vaddps zmm14, zmm14, [rsp+9792]
    vmulps zmm19, zmm19, zmm2
    vfmsub231ps zmm25, zmm9, zmm1
    vaddps zmm2, zmm4, [rsp+9856]
    vpmaxud zmm9, zmm20, zmm3
    vfmadd231ps zmm6, zmm8, zmm11
    vaddps zmm1, zmm3, [rsp+r3*8+(CRY+4*W+4*W*3+128)]
    vpminsd zmm4, zmm9, [c_zero]{1to16}
    vfmadd213ps zmm0, zmm7, zmm24
    vaddps zmm20, zmm1, [rsp+9920]
    vfmadd231ps zmm23, zmm22, zmm25
    vmulps zmm8, zmm19, zmm25
    vpternlogd zmm6, zmm21, [rsp+2880], 184
    vaddps zmm11, zmm4, [rsp+r3*8+(CRY+4*W+4*W*3+192)]
    vmovups zmm9, [rsp+10304]
    vmovups zmm7, [rsp+10048]
    vfmadd231ps zmm10, zmm18, zmm0
    vaddps zmm1, zmm5, zmm6
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+0)], zmm6
    vaddps zmm18, zmm11, [rsp+9984]
    vfmadd231ps zmm24, zmm23, zmm25
    vaddps zmm0, zmm1, zmm15
    valignd zmm5, zmm9, [rsp+10816], 15
    valignd zmm11, zmm14, zmm9, 15
    vpternlogd zmm10, zmm21, [rsp+2944], 184
    vmovups zmm23, [rsp+10368]
    vmovups zmm25, [rsp+10112]
    vfmadd231ps zmm19, zmm8, zmm24
    vmovaps [r13+768], zmm0
    vpmaxud zmm1, zmm6, zmm10
    vaddps zmm15, zmm17, zmm10
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+64)], zmm10
    vfmadd231ps zmm5, zmm7, [rsp+11072]
    vaddps zmm9, zmm11, [rsp+10560]
    vmovaps [rsp+10816], zmm14
    vaddps zmm8, zmm15, zmm16
    valignd zmm24, zmm23, [rsp+10880], 15
    valignd zmm0, zmm2, zmm23, 15
    vmovups zmm6, [rsp+10432]
    vpternlogd zmm19, zmm21, [rsp+3008], 184
    vmovups zmm17, [rsp+10176]
    vpmaxud zmm10, zmm1, zmm19
    vaddps zmm7, zmm3, zmm19
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+128)], zmm19
    vmovaps [r13+832], zmm8
    vshufps zmm11, zmm5, zmm9, 136
    vshufps zmm14, zmm5, zmm9, 221
    vmovups zmm15, [rsp+10496]
    vmovups zmm16, [rsp+10240]
    vpminsd zmm23, zmm10, [c_zero]{1to16}
    vfmadd231ps zmm24, zmm25, [rsp+11072]
    vmovaps [rsp+10880], zmm2
    valignd zmm1, zmm20, zmm6, 15
    vaddps zmm3, zmm7, zmm13
    vaddps zmm19, zmm11, zmm14
    valignd zmm8, zmm6, [rsp+10944], 15
    vaddps zmm5, zmm0, [rsp+10624]
    vmovups zmm9, [c_ones]
    vaddps zmm10, zmm4, zmm23
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+192)], zmm23
    vmovaps [r13+896], zmm3
    jmp .j3584
    ALIGN 64
.j3584:
    vmovaps [r13+1024], zmm19
    vshufps zmm25, zmm24, zmm5, 136
    vshufps zmm2, zmm24, zmm5, 221
    valignd zmm7, zmm15, [rsp+11008], 15
    valignd zmm13, zmm18, zmm15, 15
    vaddps zmm11, zmm10, zmm12
    vaddps zmm14, zmm1, [rsp+10688]
    vfmadd231ps zmm8, zmm17, [rsp+11072]
    vmovaps [rsp+10944], zmm20
    vaddps zmm6, zmm25, zmm2
    vmovaps [r13+960], zmm11
    vmovaps [r13+1088], zmm6
    vfmadd231ps zmm7, zmm16, [rsp+11072]
    vaddps zmm0, zmm13, [rsp+10752]
    vshufps zmm4, zmm8, zmm14, 136
    vshufps zmm23, zmm8, zmm14, 221
    vmovaps [rsp+11008], zmm18
    vaddps zmm3, zmm4, zmm23
    vshufps zmm19, zmm7, zmm0, 136
    vshufps zmm24, zmm7, zmm0, 221
    vmovaps [rsp+11072], zmm9
    vmovaps [r13+1152], zmm3
    vaddps zmm5, zmm19, zmm24
    vmovaps [r13+1216], zmm5
.g_b23:
    vmovups zmm31, [c_rk]
    vmovups zmm30, [c_rk+64]
    vmovups zmm29, [c_rp]
    vmovups zmm28, [c_rp+64]
    vmovups zmm27, [c_t2]
    vmovups zmm26, [c_t2+64]
    vbroadcastss zmm25, [c_48]
    vbroadcastss zmm24, [c_mag]
    vbroadcastss zmm23, [c_p20]
    vbroadcastss zmm22, [c_p21]
    vbroadcastss zmm21, [c_p22]
    vbroadcastss zmm20, [c_p23]
    vbroadcastss zmm19, [c_sign]
    vbroadcastss zmm18, [c_oa]
    vbroadcastss zmm17, [c_half]
    vmovups zmm0, [rsp+6528]
    vmovups zmm1, [rsp+6144]
    vmovups zmm2, [rsp+6592]
    vmovaps zmm3, zmm24
    vfmadd231ps zmm3, zmm0, zmm25
    vmovaps zmm4, zmm24
    vfmadd231ps zmm4, zmm1, zmm25
    vptestnmd k1, zmm2, zmm19
    vbroadcastss zmm5, [c_sl]
    vmovups zmm6, [rsp+6336]
    vmovaps zmm7, zmm3
    vpermi2ps zmm7, zmm31, zmm30
    vmovaps zmm8, zmm3
    vpermi2ps zmm8, zmm29, zmm28
    vpermi2ps zmm3, zmm27, zmm26
    vmovaps zmm9, zmm4
    vpermi2ps zmm9, zmm31, zmm30
    vmovaps zmm10, zmm4
    vpermi2ps zmm10, zmm29, zmm28
    vpermi2ps zmm4, zmm27, zmm26
    vmovaps zmm11, zmm24
    vfmadd231ps zmm11, zmm6, zmm25
    vfmsub231ps zmm8, zmm0, zmm7
    vmovaps zmm12, zmm11
    vpermi2ps zmm12, zmm31, zmm30
    jmp .j3648
    ALIGN 64
.j3648:
    vmovaps zmm13, zmm11
    vpermi2ps zmm13, zmm29, zmm28
    vfmsub231ps zmm10, zmm1, zmm9
    vpermi2ps zmm11, zmm27, zmm26
    vmovups zmm14, [rsp+6208]
    vmovaps zmm15, zmm21
    vfmadd231ps zmm15, zmm20, zmm8
    vmulps zmm16, zmm3, zmm8
    vmovups zmm2, [rsp+7104]
    vmovaps zmm0, zmm21
    vfmadd231ps zmm0, zmm20, zmm10
    vmulps zmm7, zmm4, zmm10
    vptestnmd k2, zmm14, zmm19
    vfmadd213ps zmm15, zmm8, zmm22
    vfmsub231ps zmm13, zmm6, zmm12
    vfmadd213ps zmm0, zmm10, zmm22
    vmovaps zmm1, zmm24
    vfmadd231ps zmm1, zmm2, zmm25
    vfmadd213ps zmm15, zmm8, zmm23
    vmovaps zmm9, zmm21
    vfmadd231ps zmm9, zmm20, zmm13
    vmulps zmm14, zmm11, zmm13
    vfmadd213ps zmm0, zmm10, zmm23
    vmovaps zmm6, zmm1
    vpermi2ps zmm6, zmm31, zmm30
    vmovaps zmm12, zmm1
    vpermi2ps zmm12, zmm29, zmm28
    vmovups zmm8, [rsp+6400]
    vpermi2ps zmm1, zmm27, zmm26
    vfmadd231ps zmm3, zmm16, zmm15
    vfmadd213ps zmm9, zmm13, zmm22
    vfmadd231ps zmm4, zmm7, zmm0
    vptestnmd k3, zmm8, zmm19
    vmovaps zmm10, zmm18
    vfmadd231ps zmm10, zmm3, [rsp+6656]
    vpternlogd zmm3{k1}{z}, zmm19, [r14+128], 184
    vfmadd213ps zmm9, zmm13, zmm23
    vmovaps zmm16, zmm18
    vfmadd231ps zmm16, zmm4, [rsp+6272]
    vpternlogd zmm4{k2}{z}, zmm19, [r14], 184
    vmulps zmm15, zmm3, [c_mtl2]{1to16}
    vfmadd231ps zmm5, zmm10, [c_mtl2]{1to16}
    vfmadd231ps zmm11, zmm14, zmm9
    vmovups zmm7, [rsp+6720]
    vfmadd231ps zmm15, zmm4, [c_mtl0]{1to16}
    vfmadd231ps zmm5, zmm16, [c_mtl0]{1to16}
    vmovaps zmm0, zmm18
    vfmadd231ps zmm0, zmm11, [rsp+6464]
    vpternlogd zmm11{k3}{z}, zmm19, [r14+64], 184
    vmovaps zmm8, zmm24
    vfmadd231ps zmm8, zmm7, zmm25
    vfmsub231ps zmm12, zmm2, zmm6
    vfmadd231ps zmm15, zmm11, [c_mtl1]{1to16}
    vfmadd231ps zmm5, zmm0, [c_mtl1]{1to16}
    vmovaps zmm13, zmm8
    vpermi2ps zmm13, zmm31, zmm30
    vmovaps zmm3, zmm8
    vpermi2ps zmm3, zmm29, zmm28
    vmovaps zmm10, zmm21
    vfmadd231ps zmm10, zmm20, zmm12
    vpermi2ps zmm8, zmm27, zmm26
    vmulps zmm14, zmm1, zmm12
    vmovups zmm9, [rsp+7168]
    vreduceps zmm4, zmm15, 8
    jmp .j3712
    ALIGN 64
.j3712:
    vcvtps2dq zmm16, zmm15, {rn-sae}
    vbroadcastss zmm2, [c_sl]
    vmovups zmm6, [rsp+6912]
    vfmadd213ps zmm10, zmm12, zmm22
    vpaddd zmm11, zmm16, [c_i64]{1to16}
    vptestnmd k4, zmm9, zmm19
    vfmsub231ps zmm3, zmm7, zmm13
    vandps zmm0, zmm4, [c_absm]{1to16}
    vpminsd zmm15, zmm11, [c_i1023]{1to16}
    vmovaps zmm16, zmm24
    vfmadd231ps zmm16, zmm6, zmm25
    vfmadd213ps zmm10, zmm12, zmm23
    vaddps zmm9, zmm0, zmm5
    vpmaxsd zmm7, zmm15, [c_zero]{1to16}
    vmovups zmm13, [rsp+6784]
    vmovaps zmm4, zmm21
    vfmadd231ps zmm4, zmm20, zmm3
    vmulps zmm11, zmm8, zmm3
    vpmovdw [r11+(0+W*0)], zmm7
    vmovaps zmm12, zmm16
    vpermi2ps zmm12, zmm31, zmm30
    vcmpps k5, zmm9, zmm17, 21
    vmovaps zmm0, zmm16
    vpermi2ps zmm0, zmm29, zmm28
    vmovups zmm5, [rsp+7680]
    vfmadd231ps zmm1, zmm14, zmm10
    vpermi2ps zmm16, zmm27, zmm26
    vfmadd213ps zmm4, zmm3, zmm22
    vptestnmd k6, zmm13, zmm19
    vmovaps zmm15, zmm18
    vfmadd231ps zmm15, zmm1, [rsp+7232]
    vpternlogd zmm1{k4}{z}, zmm19, [r14+384], 184
    vmovaps zmm7, zmm24
    vfmadd231ps zmm7, zmm5, zmm25
    kmovw [r14+1280], k5
    vfmsub231ps zmm0, zmm6, zmm12
    vmovups zmm9, [rsp+6976]
    vmulps zmm14, zmm1, [c_mtl2]{1to16}
    vfmadd213ps zmm4, zmm3, zmm23
    vfmadd231ps zmm2, zmm15, [c_mtl2]{1to16}
    vmovaps zmm10, zmm7
    vpermi2ps zmm10, zmm31, zmm30
    vmovaps zmm13, zmm7
    vpermi2ps zmm13, zmm29, zmm28
    vpermi2ps zmm7, zmm27, zmm26
    vmovaps zmm6, zmm21
    vfmadd231ps zmm6, zmm20, zmm0
    vmulps zmm12, zmm16, zmm0
    vfmadd231ps zmm8, zmm11, zmm4
    vptestnmd k7, zmm9, zmm19
    vfmadd213ps zmm6, zmm0, zmm22
    vmovaps zmm1, zmm18
    vfmadd231ps zmm1, zmm8, [rsp+6848]
    vpternlogd zmm8{k6}{z}, zmm19, [r14+256], 184
    vfmadd231ps zmm14, zmm8, [c_mtl0]{1to16}
    vfmadd213ps zmm6, zmm0, zmm23
    vmovups zmm3, [rsp+7296]
    vfmadd231ps zmm2, zmm1, [c_mtl0]{1to16}
    vfmadd231ps zmm16, zmm12, zmm6
    vmovaps zmm15, zmm24
    vfmadd231ps zmm15, zmm3, zmm25
    vfmsub231ps zmm13, zmm5, zmm10
    vmovaps zmm11, zmm18
    vfmadd231ps zmm11, zmm16, [rsp+7040]
    jmp .j3776
    ALIGN 64
.j3776:
    vpternlogd zmm16{k7}{z}, zmm19, [r14+320], 184
    vmovaps zmm4, zmm15
    vpermi2ps zmm4, zmm31, zmm30
    vmovaps zmm9, zmm15
    vpermi2ps zmm9, zmm29, zmm28
    vpermi2ps zmm15, zmm27, zmm26
    vmovaps zmm8, zmm21
    vfmadd231ps zmm8, zmm20, zmm13
    vmulps zmm0, zmm7, zmm13
    vfmadd231ps zmm14, zmm16, [c_mtl1]{1to16}
    vmovups zmm1, [rsp+7744]
    vfmadd231ps zmm2, zmm11, [c_mtl1]{1to16}
    vbroadcastss zmm12, [c_sl]
    vfmadd213ps zmm8, zmm13, zmm22
    vreduceps zmm6, zmm14, 8
    vcvtps2dq zmm5, zmm14, {rn-sae}
    vmovups zmm10, [rsp+7488]
    vptestnmd k1, zmm1, zmm19
    vpaddd zmm16, zmm5, [c_i64]{1to16}
    vfmadd213ps zmm8, zmm13, zmm23
    vfmsub231ps zmm9, zmm3, zmm4
    vmovaps zmm11, zmm24
    vfmadd231ps zmm11, zmm10, zmm25
    vandps zmm14, zmm6, [c_absm]{1to16}
    vpminsd zmm1, zmm16, [c_i1023]{1to16}
    vaddps zmm5, zmm14, zmm2
    vpmaxsd zmm13, zmm1, [c_zero]{1to16}
    vfmadd231ps zmm7, zmm0, zmm8
    vmovaps zmm3, zmm21
    vfmadd231ps zmm3, zmm20, zmm9
    vmulps zmm4, zmm15, zmm9
    vmovups zmm6, [rsp+7360]
    vmovaps zmm16, zmm11
    vpermi2ps zmm16, zmm31, zmm30
    vmovaps zmm14, zmm11
    vpermi2ps zmm14, zmm29, zmm28
    vpmovdw [r11+(0+W*1)], zmm13
    vpermi2ps zmm11, zmm27, zmm26
    vmovups zmm2, [rsp+8256]
    vcmpps k2, zmm5, zmm17, 21
    vmovaps zmm1, zmm18
    vfmadd231ps zmm1, zmm7, [rsp+7808]
    vpternlogd zmm7{k1}{z}, zmm19, [r14+640], 184
    vfmadd213ps zmm3, zmm9, zmm22
    vptestnmd k3, zmm6, zmm19
    vmulps zmm0, zmm7, [c_mtl2]{1to16}
    vfmsub231ps zmm14, zmm10, zmm16
    vmovaps zmm8, zmm24
    vfmadd231ps zmm8, zmm2, zmm25
    vmovups zmm13, [rsp+7552]
    kmovw [r14+1282], k2
    vfmadd231ps zmm12, zmm1, [c_mtl2]{1to16}
    vfmadd213ps zmm3, zmm9, zmm23
    vmovaps zmm5, zmm21
    vfmadd231ps zmm5, zmm20, zmm14
    vmulps zmm6, zmm11, zmm14
    vmovaps zmm7, zmm8
    vpermi2ps zmm7, zmm31, zmm30
    vmovaps zmm10, zmm8
    vpermi2ps zmm10, zmm29, zmm28
    vpermi2ps zmm8, zmm27, zmm26
    vptestnmd k4, zmm13, zmm19
    vfmadd231ps zmm15, zmm4, zmm3
    vfmadd213ps zmm5, zmm14, zmm22
    jmp .j3840
    ALIGN 64
.j3840:
    vmovaps zmm16, zmm18
    vfmadd231ps zmm16, zmm15, [rsp+7424]
    vpternlogd zmm15{k3}{z}, zmm19, [r14+512], 184
    vfmadd213ps zmm5, zmm14, zmm23
    vfmadd231ps zmm0, zmm15, [c_mtl0]{1to16}
    vmovups zmm1, [rsp+7872]
    vfmadd231ps zmm12, zmm16, [c_mtl0]{1to16}
    vfmadd231ps zmm11, zmm6, zmm5
    vmovaps zmm9, zmm24
    vfmadd231ps zmm9, zmm1, zmm25
    vfmsub231ps zmm10, zmm2, zmm7
    vmovaps zmm13, zmm18
    vfmadd231ps zmm13, zmm11, [rsp+7616]
    vpternlogd zmm11{k4}{z}, zmm19, [r14+576], 184
    vmovaps zmm4, zmm9
    vpermi2ps zmm4, zmm31, zmm30
    vmovaps zmm3, zmm9
    vpermi2ps zmm3, zmm29, zmm28
    vfmadd231ps zmm0, zmm11, [c_mtl1]{1to16}
    vpermi2ps zmm9, zmm27, zmm26
    vmovaps zmm14, zmm21
    vfmadd231ps zmm14, zmm20, zmm10
    vmulps zmm15, zmm8, zmm10
    vmovups zmm16, [rsp+8320]
    vfmadd231ps zmm12, zmm13, [c_mtl1]{1to16}
    vbroadcastss zmm6, [c_sl]
    vreduceps zmm5, zmm0, 8
    vcvtps2dq zmm2, zmm0, {rn-sae}
    vfmadd213ps zmm14, zmm10, zmm22
    vmovups zmm7, [rsp+8064]
    vptestnmd k5, zmm16, zmm19
    vpaddd zmm11, zmm2, [c_i64]{1to16}
    vfmadd213ps zmm14, zmm10, zmm23
    vfmsub231ps zmm3, zmm1, zmm4
    vandps zmm13, zmm5, [c_absm]{1to16}
    vpminsd zmm0, zmm11, [c_i1023]{1to16}
    vmovaps zmm16, zmm24
    vfmadd231ps zmm16, zmm7, zmm25
    vaddps zmm2, zmm13, zmm12
    vpmaxsd zmm10, zmm0, [c_zero]{1to16}
    vfmadd231ps zmm8, zmm15, zmm14
    vmovaps zmm1, zmm21
    vfmadd231ps zmm1, zmm20, zmm3
    vmovups zmm4, [rsp+7936]
    vmulps zmm5, zmm9, zmm3
    vpmovdw [r11+(32+W*0)], zmm10
    vmovaps zmm11, zmm16
    vpermi2ps zmm11, zmm31, zmm30
    vcmpps k6, zmm2, zmm17, 21
    vmovaps zmm13, zmm16
    vpermi2ps zmm13, zmm29, zmm28
    vmovups zmm12, [rsp+8448]
    vpermi2ps zmm16, zmm27, zmm26
    vmovaps zmm0, zmm18
    vfmadd231ps zmm0, zmm8, [rsp+8384]
    vpternlogd zmm8{k5}{z}, zmm19, [r14+896], 184
    vfmadd213ps zmm1, zmm3, zmm22
    vptestnmd k7, zmm4, zmm19
    vmulps zmm15, zmm8, [c_mtl2]{1to16}
    vmovaps zmm14, zmm24
    vfmadd231ps zmm14, zmm12, zmm25
    vfmsub231ps zmm13, zmm7, zmm11
    kmovw [r14+1284], k6
    vmovups zmm10, [rsp+8128]
    jmp .j3904
    ALIGN 64
.j3904:
    vfmadd231ps zmm6, zmm0, [c_mtl2]{1to16}
    vfmadd213ps zmm1, zmm3, zmm23
    vmovaps zmm2, zmm14
    vpermi2ps zmm2, zmm31, zmm30
    vmovaps zmm4, zmm14
    vpermi2ps zmm4, zmm29, zmm28
    vmovaps zmm8, zmm21
    vfmadd231ps zmm8, zmm20, zmm13
    vpermi2ps zmm14, zmm27, zmm26
    vmulps zmm7, zmm16, zmm13
    vfmadd231ps zmm9, zmm5, zmm1
    vptestnmd k1, zmm10, zmm19
    vfmadd213ps zmm8, zmm13, zmm22
    vmovaps zmm11, zmm18
    vfmadd231ps zmm11, zmm9, [rsp+8000]
    vpternlogd zmm9{k7}{z}, zmm19, [r14+768], 184
    vfmadd231ps zmm15, zmm9, [c_mtl0]{1to16}
    vfmadd213ps zmm8, zmm13, zmm23
    vmovups zmm0, [rsp+8640]
    vfmadd231ps zmm6, zmm11, [c_mtl0]{1to16}
    vfmadd231ps zmm16, zmm7, zmm8
    vmovaps zmm3, zmm24
    vfmadd231ps zmm3, zmm0, zmm25
    vfmsub231ps zmm4, zmm12, zmm2
    vmovaps zmm5, zmm18
    vfmadd231ps zmm5, zmm16, [rsp+8192]
    vpternlogd zmm16{k1}{z}, zmm19, [r14+832], 184
    vmovaps zmm1, zmm3
    vpermi2ps zmm1, zmm31, zmm30
    vmovaps zmm10, zmm3
    vpermi2ps zmm10, zmm29, zmm28
    vpermi2ps zmm3, zmm27, zmm26
    vmovaps zmm9, zmm21
    vfmadd231ps zmm9, zmm20, zmm4
    vmulps zmm13, zmm14, zmm4
    vfmadd231ps zmm15, zmm16, [c_mtl1]{1to16}
    vmovups zmm11, [rsp+8512]
    vmovups zmm7, [rsp+8832]
    vfmadd231ps zmm6, zmm5, [c_mtl1]{1to16}
    vfmadd213ps zmm9, zmm4, zmm22
    vreduceps zmm8, zmm15, 8
    vcvtps2dq zmm12, zmm15, {rn-sae}
    vptestnmd k2, zmm11, zmm19
    vfmsub231ps zmm10, zmm0, zmm1
    vfmadd231ps zmm24, zmm7, zmm25
    vpaddd zmm2, zmm12, [c_i64]{1to16}
    vfmadd213ps zmm9, zmm4, zmm23
    vmovaps zmm16, zmm21
    vfmadd231ps zmm16, zmm20, zmm10
    vmulps zmm5, zmm3, zmm10
    vandps zmm15, zmm8, [c_absm]{1to16}
    vpminsd zmm11, zmm2, [c_i1023]{1to16}
    vmovaps zmm0, zmm24
    vpermi2ps zmm0, zmm31, zmm30
    vmovaps zmm1, zmm24
    vpermi2ps zmm1, zmm29, zmm28
    vpermi2ps zmm24, zmm27, zmm26
    vmovups zmm12, [rsp+8704]
    vaddps zmm4, zmm15, zmm6
    vpmaxsd zmm8, zmm11, [c_zero]{1to16}
    vfmadd231ps zmm14, zmm13, zmm9
    vmovups zmm2, [rsp+8896]
    vfmadd213ps zmm16, zmm10, zmm22
    vpmovdw [r11+(32+W*1)], zmm8
    jmp .j3968
    ALIGN 64
.j3968:
    vcmpps k3, zmm4, zmm17, 21
    vfmsub231ps zmm1, zmm7, zmm0
    vptestnmd k4, zmm12, zmm19
    vmovaps zmm15, zmm18
    vfmadd231ps zmm15, zmm14, [rsp+8576]
    vpternlogd zmm14{k2}{z}, zmm19, [r14+1024], 184
    vbroadcastss zmm6, [c_sl]
    vfmadd213ps zmm16, zmm10, zmm23
    vptestnmd k5, zmm2, zmm19
    vmulps zmm11, zmm14, [c_mth1]{1to16}
    vfmadd231ps zmm21, zmm20, zmm1
    vmulps zmm13, zmm24, zmm1
    vbroadcastss zmm9, [c_sl]
    kmovw [r14+1286], k3
    vfmadd231ps zmm3, zmm5, zmm16
    vfmadd231ps zmm6, zmm15, [c_mth1]{1to16}
    vfmadd231ps zmm22, zmm21, zmm1
    vmovaps zmm8, zmm18
    vfmadd231ps zmm8, zmm3, [rsp+8768]
    vpternlogd zmm3{k4}{z}, zmm19, [r14+1088], 184
    vfmadd231ps zmm23, zmm22, zmm1
    vfmadd231ps zmm11, zmm3, [c_mth2]{1to16}
    vfmadd231ps zmm6, zmm8, [c_mth2]{1to16}
    vfmadd231ps zmm24, zmm13, zmm23
    vfmadd231ps zmm18, zmm24, [rsp+8960]
    vpternlogd zmm24{k5}{z}, zmm19, [r14+1152], 184
    vfmsub231ps zmm11, zmm24, [c_mth0]{1to16}
    vmulps zmm4, zmm24, [c_mth5]{1to16}
    vfmadd231ps zmm6, zmm18, [c_mth0]{1to16}
    vfmadd231ps zmm9, zmm18, [c_mth5]{1to16}
    vfmadd231ps zmm4, zmm3, [c_mth4]{1to16}
    vreduceps zmm7, zmm11, 8
    vcvtps2dq zmm0, zmm11, {rn-sae}
    vfmadd231ps zmm9, zmm8, [c_mth4]{1to16}
    vmovups zmm12, [c_pkw]
    vfmsub231ps zmm4, zmm14, [c_mth0]{1to16}
    vpaddd zmm10, zmm0, [c_i512]{1to16}
    vandps zmm2, zmm7, [c_absm]{1to16}
    vpminsd zmm5, zmm10, [c_i1023]{1to16}
    vfmadd231ps zmm9, zmm15, [c_mth0]{1to16}
    vaddps zmm16, zmm2, zmm6
    vreduceps zmm21, zmm4, 8
    vpmaxsd zmm22, zmm5, [c_zero]{1to16}
    vcvtps2dq zmm1, zmm4, {rn-sae}
    vpermw zmm13, zmm12, zmm22
    vcmpps k6, zmm16, zmm17, 21
    vpaddd zmm23, zmm1, [c_i512]{1to16}
    vandps zmm24, zmm21, [c_absm]{1to16}
    vpminsd zmm18, zmm23, [c_i1023]{1to16}
    vmovdqu16 [r6], ymm13
    vaddps zmm3, zmm24, zmm9
    vpmaxsd zmm11, zmm18, [c_zero]{1to16}
    vcmpps k7, zmm3, zmm17, 21
    vpermw zmm8, zmm12, zmm11
    vmovdqu16 [gs:r6], ymm8
    korw k1, k6, k7
    kmovw [r14+1288], k1
    lea r2d, [r12 + r3*2]
    and r2d, 32767
    prefetcht1 [r2 + .period]
    prefetcht0 [r1 + r3*4 + 8*W + 2*W*0 + 0]
    prefetcht0 [r1 + r3*4 + 8*W + 2*W*1 + 0]
    prefetcht0 [r1 + r3*4 + 8*W + 2*W*2 + 0]
    prefetcht0 [r1 + r3*4 + 8*W + 2*W*3 + 0]
    prefetcht0 [r0 + r3*2 + 2*CST + CST*0 + CRD*0]
    prefetcht0 [r0 + r3*2 + 2*CST + CST*0 + CRD*1]
    prefetcht0 [r0 + r3*2 + 2*CST + CST*1 + CRD*0]
    prefetcht0 [r0 + r3*2 + 2*CST + CST*1 + CRD*1]
    add r4, 512
    add r5, 512
    add r7, 512
    add r8, 512
    mov r14, r13
    xor r13, [rsp + 11224]
    mov r11, r9
    add r9, 64
    mov r6, r10
    add r10, 32
    add r3, 32
    jnz .pair
    cmp dword [rsp + STX+5120], 16
    jb .pl
    call .fll
.pl:
    cmp dword [rsp + STX+5124], 16
    jb .pc
    call .flc
.pc:
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
.e_b1a:
    vbroadcastss zmm31, [c_absm]
    vbroadcastss zmm30, [c_rgl]
    vbroadcastss zmm29, [c_xll]
    vbroadcastss zmm28, [c_nieq]
    vbroadcastss zmm27, [c_eqp]
    vbroadcastss zmm0, [c_anl]
    vbroadcastss zmm1, [c_tbl]
    jmp .j4032
.j4032:
    vmovaps zmm2, zmm28
    vmovups zmm3, [r14]
    vmovups zmm4, [r14+64]
    vmovups zmm5, [r14+128]
    vbroadcastss zmm6, [c_anl]
    vbroadcastss zmm7, [c_tbl]
    vmovups zmm8, [r14+256]
    vmovaps zmm9, zmm28
    vmovups zmm10, [r14+320]
    vmovups zmm11, [r14+384]
    vfnmadd231ps zmm1, zmm0, [r14+192]
    vandps zmm12, zmm3, zmm31
    vandps zmm13, zmm4, zmm31
    vandps zmm14, zmm5, zmm31
    vfnmadd231ps zmm7, zmm6, [r14+448]
    vmovaps zmm15, zmm1
    vfnmsub231ps zmm15, zmm30, zmm12
    vmovaps zmm16, zmm1
    vfnmsub231ps zmm16, zmm30, zmm13
    vfnmsub231ps zmm1, zmm30, zmm14
    vmovaps zmm17, zmm28
    vaddps zmm18, zmm12, zmm15
    vsubps zmm19, zmm15, zmm12
    vaddps zmm20, zmm13, zmm16
    vsubps zmm21, zmm16, zmm13
    vbroadcastss zmm22, [c_anl]
    vaddps zmm23, zmm14, zmm1
    vsubps zmm24, zmm1, zmm14
    vbroadcastss zmm25, [c_tbl]
    vmovups zmm26, [r14+512]
    vmovups zmm0, [r14+576]
    vmovups zmm3, [r14+640]
    vandps zmm4, zmm8, zmm31
    vcmpps k1, zmm18, zmm29, 30
    vrcp14ps zmm5, zmm18
    vcmpps k2, zmm20, zmm29, 30
    vrcp14ps zmm6, zmm20
    vcmpps k3, zmm23, zmm29, 30
    vrcp14ps zmm8, zmm23
    vmovaps zmm18, zmm7
    vfnmsub231ps zmm18, zmm30, zmm4
    vmovaps zmm20, zmm28
    vandps zmm23, zmm10, zmm31
    vfnmadd231ps zmm25, zmm22, [r14+704]
    vmovaps zmm10, zmm7
    vfnmsub231ps zmm10, zmm30, zmm23
    vblendmps zmm22{k1}, zmm19, zmm12
    vmulps zmm2{k1}, zmm15, zmm5
    vaddps zmm19, zmm4, zmm18
    vsubps zmm12, zmm18, zmm4
    vblendmps zmm15{k2}, zmm21, zmm13
    vmulps zmm9{k2}, zmm16, zmm6
    vmovaps zmm5, zmm28
    vblendmps zmm21{k3}, zmm24, zmm14
    vmulps zmm17{k3}, zmm1, zmm8
    vmovaps [rsp+6208], zmm22
    vandps zmm13, zmm11, zmm31
    vmovaps [rsp+6400], zmm15
    vcmpps k4, zmm19, zmm29, 30
    vrcp14ps zmm16, zmm19
    vaddps zmm6, zmm23, zmm10
    vfnmadd213ps zmm2, zmm27, [c_oml0]{1to16}
    vmovaps [rsp+6592], zmm21
    vsubps zmm24, zmm10, zmm23
    jmp .j4096
.j4096:
    vfnmadd213ps zmm9, zmm27, [c_oml1]{1to16}
    vfnmsub231ps zmm7, zmm30, zmm13
    vmovaps zmm14, zmm28
    vfnmadd213ps zmm17, zmm27, [c_oml2]{1to16}
    vbroadcastss zmm1, [c_anl]
    vcmpps k5, zmm6, zmm29, 30
    vrcp14ps zmm8, zmm6
    vbroadcastss zmm22, [c_tbl]
    vmovups zmm11, [r14+768]
    vmovups zmm15, [r14+832]
    vmovups zmm19, [r14+896]
    vandps zmm21, zmm26, zmm31
    vmovaps [rsp+6272], zmm2
    vmovaps [rsp+6464], zmm9
    vblendmps zmm6{k4}, zmm12, zmm4
    vmulps zmm20{k4}, zmm18, zmm16
    vaddps zmm26, zmm13, zmm7
    vsubps zmm2, zmm7, zmm13
    vmovaps [rsp+6656], zmm17
    vmovaps zmm9, zmm25
    vfnmsub231ps zmm9, zmm30, zmm21
    vmovaps zmm12, zmm28
    vandps zmm4, zmm0, zmm31
    vmovaps [rsp+6784], zmm6
    vfnmadd231ps zmm22, zmm1, [r14+960]
    vblendmps zmm18{k5}, zmm24, zmm23
    vmulps zmm5{k5}, zmm10, zmm8
    vcmpps k6, zmm26, zmm29, 30
    vrcp14ps zmm16, zmm26
    vfnmadd213ps zmm20, zmm27, [c_oml0]{1to16}
    vmovaps zmm17, zmm25
    vfnmsub231ps zmm17, zmm30, zmm4
    vmovaps zmm0, zmm28
    vmovaps [rsp+6976], zmm18
    vaddps zmm6, zmm21, zmm9
    vsubps zmm1, zmm9, zmm21
    vandps zmm24, zmm3, zmm31
    vfnmadd213ps zmm5, zmm27, [c_oml1]{1to16}
    vmovaps [rsp+6848], zmm20
    vcmpps k7, zmm6, zmm29, 30
    vrcp14ps zmm23, zmm6
    vaddps zmm10, zmm4, zmm17
    vfnmsub231ps zmm25, zmm30, zmm24
    vblendmps zmm8{k6}, zmm2, zmm13
    vmulps zmm14{k6}, zmm7, zmm16
    vsubps zmm26, zmm17, zmm4
    vmovaps zmm18, zmm28
    vbroadcastss zmm3, [c_anh]
    vbroadcastss zmm20, [c_tbh]
    vmovaps [rsp+7040], zmm5
    vcmpps k1, zmm10, zmm29, 30
    vrcp14ps zmm6, zmm10
    vmovaps [rsp+7168], zmm8
    vmovups zmm2, [r14+1024]
    vmovups zmm13, [r14+1088]
    vfnmadd213ps zmm14, zmm27, [c_oml2]{1to16}
    vaddps zmm7, zmm24, zmm25
    vsubps zmm16, zmm25, zmm24
    vmovups zmm5, [r14+1152]
    vandps zmm10, zmm11, zmm31
    vmovaps zmm8, zmm28
    vblendmps zmm11{k7}, zmm1, zmm21
    vmulps zmm12{k7}, zmm9, zmm23
    vmovaps zmm1, zmm22
    jmp .j4160
.j4160:
    vfnmsub231ps zmm1, zmm30, zmm10
    vcmpps k2, zmm7, zmm29, 30
    vrcp14ps zmm21, zmm7
    vfnmadd231ps zmm20, zmm3, [r14+1216]
    vmovaps [rsp+7360], zmm11
    vandps zmm9, zmm15, zmm31
    vmovaps [rsp+7232], zmm14
    vblendmps zmm23{k1}, zmm26, zmm4
    vmulps zmm0{k1}, zmm17, zmm6
    vfnmadd213ps zmm12, zmm27, [c_oml0]{1to16}
    vmovaps zmm7, zmm28
    vmovaps zmm3, zmm22
    vfnmsub231ps zmm3, zmm30, zmm9
    vmovaps [rsp+7552], zmm23
    vaddps zmm11, zmm10, zmm1
    vsubps zmm15, zmm1, zmm10
    vandps zmm14, zmm19, zmm31
    vfnmadd213ps zmm0, zmm27, [c_oml1]{1to16}
    vblendmps zmm26{k2}, zmm16, zmm24
    vmulps zmm18{k2}, zmm25, zmm21
    vmovaps [rsp+7424], zmm12
    vcmpps k3, zmm11, zmm29, 30
    vrcp14ps zmm4, zmm11
    vfnmsub231ps zmm22, zmm30, zmm14
    vaddps zmm17, zmm9, zmm3
    vsubps zmm6, zmm3, zmm9
    vmovaps zmm23, zmm28
    vmovaps [rsp+7744], zmm26
    vandps zmm19, zmm2, zmm31
    vmovaps [rsp+7616], zmm0
    vfnmadd213ps zmm18, zmm27, [c_oml2]{1to16}
    vcmpps k4, zmm17, zmm29, 30
    vrcp14ps zmm16, zmm17
    vmovaps zmm24, zmm20
    vfnmsub231ps zmm24, zmm19, [c_rgh]{1to16}
    vaddps zmm25, zmm14, zmm22
    vsubps zmm21, zmm22, zmm14
    vmovaps zmm12, zmm28
    vblendmps zmm11{k3}, zmm15, zmm10
    vmulps zmm8{k3}, zmm1, zmm4
    vandps zmm26, zmm13, zmm31
    vmovaps [rsp+7808], zmm18
    vcmpps k5, zmm25, zmm29, 30
    vrcp14ps zmm2, zmm25
    vmovaps [rsp+7936], zmm11
    vaddps zmm0, zmm19, zmm24
    vsubps zmm17, zmm24, zmm19
    vmovaps zmm15, zmm20
    vfnmsub231ps zmm15, zmm26, [c_rgh]{1to16}
    vmovaps zmm10, zmm28
    vfnmadd213ps zmm8, zmm27, [c_oml0]{1to16}
    vblendmps zmm1{k4}, zmm6, zmm9
    vmulps zmm7{k4}, zmm3, zmm16
    vandps zmm4, zmm5, zmm31
    vcmpps k6, zmm0, [c_xlh]{1to16}, 30
    vrcp14ps zmm13, zmm0
    vmovaps [rsp+8128], zmm1
    vfnmsub231ps zmm20, zmm4, [c_rgh]{1to16}
    vfnmadd213ps zmm7, zmm27, [c_oml1]{1to16}
    vblendmps zmm18{k5}, zmm21, zmm14
    vmulps zmm23{k5}, zmm22, zmm2
    vaddps zmm25, zmm26, zmm15
    vmovaps [rsp+8000], zmm8
    vsubps zmm11, zmm15, zmm26
    jmp .j4224
.j4224:
    vmovaps zmm6, zmm28
    vmovaps [rsp+8320], zmm18
    vcmpps k7, zmm25, [c_xlh]{1to16}, 30
    vrcp14ps zmm9, zmm25
    vfnmadd213ps zmm23, zmm27, [c_oml2]{1to16}
    vblendmps zmm3{k6}, zmm17, zmm19
    vmulps zmm12{k6}, zmm24, zmm13
    vaddps zmm16, zmm4, zmm20
    vmovaps [rsp+8192], zmm7
    vsubps zmm5, zmm20, zmm4
    vmovaps [rsp+8512], zmm3
    vcmpps k1, zmm16, [c_xlh]{1to16}, 30
    vrcp14ps zmm0, zmm16
    vfnmadd213ps zmm12, zmm27, [c_omh0]{1to16}
    vmovaps [rsp+8384], zmm23
    vblendmps zmm1{k7}, zmm11, zmm26
    vmulps zmm10{k7}, zmm15, zmm9
    vmovaps [rsp+8704], zmm1
    vmovaps [rsp+8576], zmm12
    vfnmadd213ps zmm10, zmm27, [c_omh1]{1to16}
    vblendmps zmm21{k1}, zmm5, zmm4
    vmulps zmm6{k1}, zmm20, zmm0
    vmovaps [rsp+8896], zmm21
    vfnmadd213ps zmm27, zmm6, [c_omh2]{1to16}
    vmovaps [rsp+8768], zmm10
    vmovaps [rsp+8960], zmm27
.e_b1b:
    vmovups zmm31, [c_t1l]
    vmovups zmm30, [c_t1l+64]
    vmovups zmm29, [c_w1]
    vmovups zmm28, [c_w1+64]
    vmovups zmm27, [c_r1]
    vmovups zmm26, [c_r1+64]
    vbroadcastss zmm25, [c_xll]
    vbroadcastss zmm24, [c_one]
    vbroadcastss zmm23, [c_q10]
    vbroadcastss zmm22, [c_q11]
    vbroadcastss zmm21, [c_s1q]
    vbroadcastss zmm20, [c_c3]
    vmovups zmm0, [rsp+6208]
    vmovups zmm1, [rsp+6400]
    vrangeps zmm2, zmm0, zmm25, 11
    vpsrld zmm3, zmm0, 18
    vgetmantps zmm4, zmm0, 4
    vrangeps zmm5, zmm1, zmm25, 11
    vmovups zmm6, [rsp+6592]
    vpsrld zmm7, zmm1, 18
    vgetmantps zmm8, zmm1, 4
    vmovaps zmm9, zmm3
    vpermi2ps zmm9, zmm29, zmm28
    vpermi2ps zmm3, zmm27, zmm26
    vpsrld zmm10, zmm2, 23
    vpsrld zmm11, zmm5, 23
    vmovaps zmm12, zmm7
    vpermi2ps zmm12, zmm29, zmm28
    vpermi2ps zmm7, zmm27, zmm26
    vpermi2ps zmm10, zmm31, zmm30
    vpermi2ps zmm11, zmm31, zmm30
    vrangeps zmm13, zmm6, zmm25, 11
    vpsrld zmm14, zmm6, 18
    vgetmantps zmm15, zmm6, 4
    vfmsub213ps zmm4, zmm3, zmm24
    vmovups zmm16, [rsp+6784]
    vmovaps zmm17, zmm14
    vpermi2ps zmm17, zmm29, zmm28
    jmp .j4288
.j4288:
    vpermi2ps zmm14, zmm27, zmm26
    vfmsub213ps zmm8, zmm7, zmm24
    vpsrld zmm18, zmm13, 23
    vmulps zmm19, zmm10, zmm9
    vmulps zmm0, zmm11, zmm12
    vpermi2ps zmm18, zmm31, zmm30
    vmovaps zmm1, zmm23
    vfmadd231ps zmm1, zmm22, zmm4
    vrangeps zmm2, zmm16, zmm25, 11
    vpsrld zmm5, zmm16, 18
    vmovaps zmm6, zmm23
    vfmadd231ps zmm6, zmm22, zmm8
    vfmsub213ps zmm15, zmm14, zmm24
    vgetmantps zmm3, zmm16, 4
    vmulps zmm7, zmm19, zmm4
    vmulps zmm13, zmm0, zmm8
    vmovaps zmm10, zmm5
    vpermi2ps zmm10, zmm29, zmm28
    vpermi2ps zmm5, zmm27, zmm26
    vpsrld zmm9, zmm2, 23
    vmovups zmm11, [rsp+6976]
    vmulps zmm12, zmm18, zmm17
    vfmadd231ps zmm19, zmm7, zmm1
    vmovaps zmm14, zmm23
    vfmadd231ps zmm14, zmm22, zmm15
    vpermi2ps zmm9, zmm31, zmm30
    vfmadd231ps zmm0, zmm13, zmm6
    vmulps zmm16, zmm12, zmm15
    vfmsub213ps zmm3, zmm5, zmm24
    vrangeps zmm4, zmm11, zmm25, 11
    vpsrld zmm8, zmm11, 18
    vgetmantps zmm2, zmm11, 4
    vsubps zmm18, zmm21, zmm19
    vfmadd213ps zmm19, zmm20, zmm21
    vsubps zmm17, zmm21, zmm0
    vfmadd213ps zmm0, zmm20, zmm21
    vmulps zmm7, zmm9, zmm10
    vmovaps zmm1, zmm8
    vpermi2ps zmm1, zmm29, zmm28
    vfmadd231ps zmm12, zmm16, zmm14
    vpsrld zmm13, zmm4, 23
    vpermi2ps zmm8, zmm27, zmm26
    vmovups zmm6, [rsp+7168]
    vmovaps zmm15, zmm23
    vfmadd231ps zmm15, zmm22, zmm3
    vpermi2ps zmm13, zmm31, zmm30
    vdivps zmm5, zmm18, zmm19
    vmulps zmm11, zmm7, zmm3
    vdivps zmm9, zmm17, zmm0
    vsubps zmm10, zmm21, zmm12
    vfmadd213ps zmm12, zmm20, zmm21
    vfmsub213ps zmm2, zmm8, zmm24
    vrangeps zmm16, zmm6, zmm25, 11
    vpsrld zmm14, zmm6, 18
    vgetmantps zmm4, zmm6, 4
    vmovups zmm18, [rsp+7360]
    vfmadd231ps zmm7, zmm11, zmm15
    vmulps zmm19, zmm13, zmm1
    vmovaps zmm3, zmm14
    vpermi2ps zmm3, zmm29, zmm28
    vpermi2ps zmm14, zmm27, zmm26
    vpsrld zmm17, zmm16, 23
    vdivps zmm0, zmm10, zmm12
    vmovaps zmm8, zmm23
    jmp .j4352
.j4352:
    vfmadd231ps zmm8, zmm22, zmm2
    vpermi2ps zmm17, zmm31, zmm30
    vsubps zmm6, zmm21, zmm7
    vfmadd213ps zmm7, zmm20, zmm21
    vmulps zmm11, zmm19, zmm2
    vrangeps zmm15, zmm18, zmm25, 11
    vmovaps [rsp+6144], zmm5
    vpsrld zmm13, zmm18, 18
    vgetmantps zmm1, zmm18, 4
    vmovaps [rsp+6336], zmm9
    vfmsub213ps zmm4, zmm14, zmm24
    vmovups zmm16, [rsp+7552]
    vpsrld zmm10, zmm15, 23
    vmovaps zmm12, zmm13
    vpermi2ps zmm12, zmm29, zmm28
    vpermi2ps zmm13, zmm27, zmm26
    vfmadd231ps zmm19, zmm11, zmm8
    vdivps zmm2, zmm6, zmm7
    vmulps zmm5, zmm17, zmm3
    vpermi2ps zmm10, zmm31, zmm30
    vmovaps zmm18, zmm23
    vfmadd231ps zmm18, zmm22, zmm4
    vmovaps [rsp+6528], zmm0
    vrangeps zmm9, zmm16, zmm25, 11
    vpsrld zmm14, zmm16, 18
    vgetmantps zmm15, zmm16, 4
    vsubps zmm11, zmm21, zmm19
    vfmadd213ps zmm19, zmm20, zmm21
    vmulps zmm8, zmm5, zmm4
    vfmsub213ps zmm1, zmm13, zmm24
    vmovaps zmm6, zmm14
    vpermi2ps zmm6, zmm29, zmm28
    vpermi2ps zmm14, zmm27, zmm26
    vmovups zmm7, [rsp+7744]
    vpsrld zmm17, zmm9, 23
    vmulps zmm3, zmm10, zmm12
    vfmadd231ps zmm5, zmm8, zmm18
    vpermi2ps zmm17, zmm31, zmm30
    vdivps zmm0, zmm11, zmm19
    vmovaps [rsp+6720], zmm2
    vmovaps zmm16, zmm23
    vfmadd231ps zmm16, zmm22, zmm1
    vmulps zmm4, zmm3, zmm1
    vfmsub213ps zmm15, zmm14, zmm24
    vrangeps zmm13, zmm7, zmm25, 11
    vpsrld zmm9, zmm7, 18
    vgetmantps zmm10, zmm7, 4
    vmovups zmm12, [rsp+7936]
    vsubps zmm8, zmm21, zmm5
    vfmadd213ps zmm5, zmm20, zmm21
    vmovaps zmm18, zmm9
    vpermi2ps zmm18, zmm29, zmm28
    vpermi2ps zmm9, zmm27, zmm26
    vmulps zmm11, zmm17, zmm6
    vpsrld zmm19, zmm13, 23
    vfmadd231ps zmm3, zmm4, zmm16
    vmovaps zmm2, zmm23
    vfmadd231ps zmm2, zmm22, zmm15
    vpermi2ps zmm19, zmm31, zmm30
    vdivps zmm1, zmm8, zmm5
    vmulps zmm14, zmm11, zmm15
    vrangeps zmm7, zmm12, zmm25, 11
    vpsrld zmm17, zmm12, 18
    vmovaps [rsp+6912], zmm0
    jmp .j4416
.j4416:
    vfmsub213ps zmm10, zmm9, zmm24
    vgetmantps zmm6, zmm12, 4
    vsubps zmm13, zmm21, zmm3
    vfmadd213ps zmm3, zmm20, zmm21
    vmovups zmm4, [rsp+8128]
    vmovaps zmm16, zmm17
    vpermi2ps zmm16, zmm29, zmm28
    vpermi2ps zmm17, zmm27, zmm26
    vpsrld zmm8, zmm7, 23
    vfmadd231ps zmm11, zmm14, zmm2
    vmulps zmm5, zmm19, zmm18
    vmovaps zmm15, zmm23
    vfmadd231ps zmm15, zmm22, zmm10
    vpermi2ps zmm8, zmm31, zmm30
    vdivps zmm0, zmm13, zmm3
    vrangeps zmm9, zmm4, zmm25, 11
    vpsrld zmm12, zmm4, 18
    vmulps zmm7, zmm5, zmm10
    vfmsub213ps zmm6, zmm17, zmm24
    vgetmantps zmm14, zmm4, 4
    vsubps zmm2, zmm21, zmm11
    vfmadd213ps zmm11, zmm20, zmm21
    vmovaps [rsp+7104], zmm1
    vmovaps zmm19, zmm12
    vpermi2ps zmm19, zmm29, zmm28
    vpermi2ps zmm12, zmm27, zmm26
    vmovups zmm18, [rsp+8320]
    vpsrld zmm13, zmm9, 23
    vmulps zmm3, zmm8, zmm16
    vfmadd231ps zmm5, zmm7, zmm15
    vmovaps zmm10, zmm23
    vfmadd231ps zmm10, zmm22, zmm6
    vpermi2ps zmm13, zmm31, zmm30
    vdivps zmm17, zmm2, zmm11
    vmulps zmm4, zmm3, zmm6
    vfmsub213ps zmm14, zmm12, zmm24
    vrangeps zmm1, zmm18, zmm25, 11
    vpsrld zmm9, zmm18, 18
    vmovaps [rsp+7296], zmm0
    vgetmantps zmm8, zmm18, 4
    vsubps zmm16, zmm21, zmm5
    vfmadd213ps zmm5, zmm20, zmm21
    vmovups zmm7, [rsp+8512]
    vmovaps zmm15, zmm9
    vpermi2ps zmm15, zmm29, zmm28
    vpermi2ps zmm9, zmm27, zmm26
    vmulps zmm2, zmm13, zmm19
    vpsrld zmm11, zmm1, 23
    vmovups zmm6, [c_t1h]
    vfmadd231ps zmm3, zmm4, zmm10
    vmovaps zmm12, zmm23
    vfmadd231ps zmm12, zmm22, zmm14
    vpermi2ps zmm11, zmm31, zmm30
    vdivps zmm0, zmm16, zmm5
    vmulps zmm18, zmm2, zmm14
    vrangeps zmm13, zmm7, [c_xlh]{1to16}, 11
    vpsrld zmm19, zmm7, 18
    vmovaps [rsp+7488], zmm17
    vfmsub213ps zmm8, zmm9, zmm24
    vgetmantps zmm1, zmm7, 4
    vsubps zmm4, zmm21, zmm3
    vfmadd213ps zmm3, zmm20, zmm21
    vmovups zmm10, [rsp+8704]
    vmovaps zmm16, zmm19
    jmp .j4480
.j4480:
    vpermi2ps zmm16, zmm29, zmm28
    vpermi2ps zmm19, zmm27, zmm26
    vpsrld zmm5, zmm13, 23
    vmovups zmm14, [c_t1h]
    vfmadd231ps zmm2, zmm18, zmm12
    vmulps zmm17, zmm11, zmm15
    vmovaps zmm9, zmm23
    vfmadd231ps zmm9, zmm22, zmm8
    vpermi2ps zmm5, zmm6, [c_t1h+64]
    vdivps zmm7, zmm4, zmm3
    vrangeps zmm13, zmm10, [c_xlh]{1to16}, 11
    vpsrld zmm18, zmm10, 18
    vmulps zmm12, zmm17, zmm8
    vfmsub213ps zmm1, zmm19, zmm24
    vgetmantps zmm11, zmm10, 4
    vmovaps [rsp+7680], zmm0
    vsubps zmm15, zmm21, zmm2
    vfmadd213ps zmm2, zmm20, zmm21
    vmovaps zmm6, zmm18
    vpermi2ps zmm6, zmm29, zmm28
    vpermi2ps zmm18, zmm27, zmm26
    vmovups zmm4, [rsp+8896]
    vpsrld zmm3, zmm13, 23
    vmovups zmm8, [c_t1h]
    vmulps zmm19, zmm5, zmm16
    vfmadd231ps zmm17, zmm12, zmm9
    vmovaps zmm10, zmm23
    vfmadd231ps zmm10, zmm22, zmm1
    vpermi2ps zmm3, zmm14, [c_t1h+64]
    vdivps zmm0, zmm15, zmm2
    vmulps zmm13, zmm19, zmm1
    vfmsub213ps zmm11, zmm18, zmm24
    vrangeps zmm5, zmm4, [c_xlh]{1to16}, 11
    vpsrld zmm16, zmm4, 18
    vmovaps [rsp+7872], zmm7
    vgetmantps zmm12, zmm4, 4
    vsubps zmm9, zmm21, zmm17
    vfmadd213ps zmm17, zmm20, zmm21
    vmovaps zmm14, zmm16
    vpermi2ps zmm14, zmm29, zmm28
    vpermi2ps zmm16, zmm27, zmm26
    vmulps zmm15, zmm3, zmm6
    vpsrld zmm2, zmm5, 23
    vfmadd231ps zmm19, zmm13, zmm10
    vmovaps zmm1, zmm23
    vfmadd231ps zmm1, zmm22, zmm11
    vpermi2ps zmm2, zmm8, [c_t1h+64]
    vdivps zmm18, zmm9, zmm17
    vmulps zmm7, zmm15, zmm11
    vmovaps [rsp+8064], zmm0
    vfmsub231ps zmm24, zmm12, zmm16
    vsubps zmm4, zmm21, zmm19
    vfmadd213ps zmm19, zmm20, zmm21
    vfmadd231ps zmm15, zmm7, zmm1
    vmulps zmm3, zmm2, zmm14
    vfmadd231ps zmm23, zmm22, zmm24
    vdivps zmm6, zmm4, zmm19
    vmulps zmm5, zmm3, zmm24
    vmovaps [rsp+8256], zmm18
    vsubps zmm13, zmm21, zmm15
    vfmadd213ps zmm15, zmm20, zmm21
    vfmadd231ps zmm3, zmm5, zmm23
    vdivps zmm10, zmm13, zmm15
    vmovaps [rsp+8448], zmm6
    jmp .j4544
.j4544:
    vsubps zmm8, zmm21, zmm3
    vfmadd231ps zmm21, zmm20, zmm3
    vdivps zmm9, zmm8, zmm21
    vmovaps [rsp+8640], zmm10
    vmovaps [rsp+8832], zmm9
.e_b23:
    vmovups zmm31, [c_rk]
    vmovups zmm30, [c_rk+64]
    vmovups zmm29, [c_rp]
    vmovups zmm28, [c_rp+64]
    vmovups zmm27, [c_t2]
    vmovups zmm26, [c_t2+64]
    vbroadcastss zmm25, [c_48]
    vbroadcastss zmm24, [c_mag]
    vbroadcastss zmm23, [c_p20]
    vbroadcastss zmm22, [c_p21]
    vbroadcastss zmm21, [c_p22]
    vbroadcastss zmm20, [c_p23]
    vbroadcastss zmm19, [c_sign]
    vbroadcastss zmm18, [c_oa]
    vbroadcastss zmm17, [c_half]
    vmovups zmm0, [rsp+6528]
    vmovups zmm1, [rsp+6144]
    vmovups zmm2, [rsp+6592]
    vmovaps zmm3, zmm24
    vfmadd231ps zmm3, zmm0, zmm25
    vmovaps zmm4, zmm24
    vfmadd231ps zmm4, zmm1, zmm25
    vptestnmd k1, zmm2, zmm19
    vbroadcastss zmm5, [c_sl]
    vmovups zmm6, [rsp+6336]
    vmovaps zmm7, zmm3
    vpermi2ps zmm7, zmm31, zmm30
    vmovaps zmm8, zmm3
    vpermi2ps zmm8, zmm29, zmm28
    vpermi2ps zmm3, zmm27, zmm26
    vmovaps zmm9, zmm4
    vpermi2ps zmm9, zmm31, zmm30
    vmovaps zmm10, zmm4
    vpermi2ps zmm10, zmm29, zmm28
    vpermi2ps zmm4, zmm27, zmm26
    vmovaps zmm11, zmm24
    vfmadd231ps zmm11, zmm6, zmm25
    vfmsub231ps zmm8, zmm0, zmm7
    vmovaps zmm12, zmm11
    vpermi2ps zmm12, zmm31, zmm30
    vmovaps zmm13, zmm11
    vpermi2ps zmm13, zmm29, zmm28
    vfmsub231ps zmm10, zmm1, zmm9
    vpermi2ps zmm11, zmm27, zmm26
    vmovups zmm14, [rsp+6208]
    vmovaps zmm15, zmm21
    vfmadd231ps zmm15, zmm20, zmm8
    vmulps zmm16, zmm3, zmm8
    vmovups zmm2, [rsp+7104]
    vmovaps zmm0, zmm21
    vfmadd231ps zmm0, zmm20, zmm10
    vmulps zmm7, zmm4, zmm10
    vptestnmd k2, zmm14, zmm19
    vfmadd213ps zmm15, zmm8, zmm22
    vfmsub231ps zmm13, zmm6, zmm12
    vfmadd213ps zmm0, zmm10, zmm22
    vmovaps zmm1, zmm24
    vfmadd231ps zmm1, zmm2, zmm25
    vfmadd213ps zmm15, zmm8, zmm23
    jmp .j4608
.j4608:
    vmovaps zmm9, zmm21
    vfmadd231ps zmm9, zmm20, zmm13
    vmulps zmm14, zmm11, zmm13
    vfmadd213ps zmm0, zmm10, zmm23
    vmovaps zmm6, zmm1
    vpermi2ps zmm6, zmm31, zmm30
    vmovaps zmm12, zmm1
    vpermi2ps zmm12, zmm29, zmm28
    vmovups zmm8, [rsp+6400]
    vpermi2ps zmm1, zmm27, zmm26
    vfmadd231ps zmm3, zmm16, zmm15
    vfmadd213ps zmm9, zmm13, zmm22
    vfmadd231ps zmm4, zmm7, zmm0
    vptestnmd k3, zmm8, zmm19
    vmovaps zmm10, zmm18
    vfmadd231ps zmm10, zmm3, [rsp+6656]
    vpternlogd zmm3{k1}{z}, zmm19, [r14+128], 184
    vfmadd213ps zmm9, zmm13, zmm23
    vmovaps zmm16, zmm18
    vfmadd231ps zmm16, zmm4, [rsp+6272]
    vpternlogd zmm4{k2}{z}, zmm19, [r14], 184
    vmulps zmm15, zmm3, [c_mtl2]{1to16}
    vfmadd231ps zmm5, zmm10, [c_mtl2]{1to16}
    vfmadd231ps zmm11, zmm14, zmm9
    vmovups zmm7, [rsp+6720]
    vfmadd231ps zmm15, zmm4, [c_mtl0]{1to16}
    vfmadd231ps zmm5, zmm16, [c_mtl0]{1to16}
    vmovaps zmm0, zmm18
    vfmadd231ps zmm0, zmm11, [rsp+6464]
    vpternlogd zmm11{k3}{z}, zmm19, [r14+64], 184
    vmovaps zmm8, zmm24
    vfmadd231ps zmm8, zmm7, zmm25
    vfmsub231ps zmm12, zmm2, zmm6
    vfmadd231ps zmm15, zmm11, [c_mtl1]{1to16}
    vfmadd231ps zmm5, zmm0, [c_mtl1]{1to16}
    vmovaps zmm13, zmm8
    vpermi2ps zmm13, zmm31, zmm30
    vmovaps zmm3, zmm8
    vpermi2ps zmm3, zmm29, zmm28
    vmovaps zmm10, zmm21
    vfmadd231ps zmm10, zmm20, zmm12
    vpermi2ps zmm8, zmm27, zmm26
    vmulps zmm14, zmm1, zmm12
    vmovups zmm9, [rsp+7168]
    vreduceps zmm4, zmm15, 8
    vcvtps2dq zmm16, zmm15, {rn-sae}
    vbroadcastss zmm2, [c_sl]
    vmovups zmm6, [rsp+6912]
    vfmadd213ps zmm10, zmm12, zmm22
    vpaddd zmm11, zmm16, [c_i64]{1to16}
    vptestnmd k4, zmm9, zmm19
    vfmsub231ps zmm3, zmm7, zmm13
    vandps zmm0, zmm4, [c_absm]{1to16}
    vpminsd zmm15, zmm11, [c_i1023]{1to16}
    vmovaps zmm16, zmm24
    vfmadd231ps zmm16, zmm6, zmm25
    vfmadd213ps zmm10, zmm12, zmm23
    vaddps zmm9, zmm0, zmm5
    vpmaxsd zmm7, zmm15, [c_zero]{1to16}
    vmovups zmm13, [rsp+6784]
    vmovaps zmm4, zmm21
    vfmadd231ps zmm4, zmm20, zmm3
    vmulps zmm11, zmm8, zmm3
    vpmovdw [r11+(0+W*0)], zmm7
    jmp .j4672
.j4672:
    vmovaps zmm12, zmm16
    vpermi2ps zmm12, zmm31, zmm30
    vcmpps k5, zmm9, zmm17, 21
    vmovaps zmm0, zmm16
    vpermi2ps zmm0, zmm29, zmm28
    vmovups zmm5, [rsp+7680]
    vfmadd231ps zmm1, zmm14, zmm10
    vpermi2ps zmm16, zmm27, zmm26
    vfmadd213ps zmm4, zmm3, zmm22
    vptestnmd k6, zmm13, zmm19
    vmovaps zmm15, zmm18
    vfmadd231ps zmm15, zmm1, [rsp+7232]
    vpternlogd zmm1{k4}{z}, zmm19, [r14+384], 184
    vmovaps zmm7, zmm24
    vfmadd231ps zmm7, zmm5, zmm25
    kmovw [r14+1280], k5
    vfmsub231ps zmm0, zmm6, zmm12
    vmovups zmm9, [rsp+6976]
    vmulps zmm14, zmm1, [c_mtl2]{1to16}
    vfmadd213ps zmm4, zmm3, zmm23
    vfmadd231ps zmm2, zmm15, [c_mtl2]{1to16}
    vmovaps zmm10, zmm7
    vpermi2ps zmm10, zmm31, zmm30
    vmovaps zmm13, zmm7
    vpermi2ps zmm13, zmm29, zmm28
    vpermi2ps zmm7, zmm27, zmm26
    vmovaps zmm6, zmm21
    vfmadd231ps zmm6, zmm20, zmm0
    vmulps zmm12, zmm16, zmm0
    vfmadd231ps zmm8, zmm11, zmm4
    vptestnmd k7, zmm9, zmm19
    vfmadd213ps zmm6, zmm0, zmm22
    vmovaps zmm1, zmm18
    vfmadd231ps zmm1, zmm8, [rsp+6848]
    vpternlogd zmm8{k6}{z}, zmm19, [r14+256], 184
    vfmadd231ps zmm14, zmm8, [c_mtl0]{1to16}
    vfmadd213ps zmm6, zmm0, zmm23
    vmovups zmm3, [rsp+7296]
    vfmadd231ps zmm2, zmm1, [c_mtl0]{1to16}
    vfmadd231ps zmm16, zmm12, zmm6
    vmovaps zmm15, zmm24
    vfmadd231ps zmm15, zmm3, zmm25
    vfmsub231ps zmm13, zmm5, zmm10
    vmovaps zmm11, zmm18
    vfmadd231ps zmm11, zmm16, [rsp+7040]
    vpternlogd zmm16{k7}{z}, zmm19, [r14+320], 184
    vmovaps zmm4, zmm15
    vpermi2ps zmm4, zmm31, zmm30
    vmovaps zmm9, zmm15
    vpermi2ps zmm9, zmm29, zmm28
    vpermi2ps zmm15, zmm27, zmm26
    vmovaps zmm8, zmm21
    vfmadd231ps zmm8, zmm20, zmm13
    vmulps zmm0, zmm7, zmm13
    vfmadd231ps zmm14, zmm16, [c_mtl1]{1to16}
    vmovups zmm1, [rsp+7744]
    vfmadd231ps zmm2, zmm11, [c_mtl1]{1to16}
    vbroadcastss zmm12, [c_sl]
    vfmadd213ps zmm8, zmm13, zmm22
    vreduceps zmm6, zmm14, 8
    vcvtps2dq zmm5, zmm14, {rn-sae}
    vmovups zmm10, [rsp+7488]
    vptestnmd k1, zmm1, zmm19
    vpaddd zmm16, zmm5, [c_i64]{1to16}
    jmp .j4736
.j4736:
    vfmadd213ps zmm8, zmm13, zmm23
    vfmsub231ps zmm9, zmm3, zmm4
    vmovaps zmm11, zmm24
    vfmadd231ps zmm11, zmm10, zmm25
    vandps zmm14, zmm6, [c_absm]{1to16}
    vpminsd zmm1, zmm16, [c_i1023]{1to16}
    vaddps zmm5, zmm14, zmm2
    vpmaxsd zmm13, zmm1, [c_zero]{1to16}
    vfmadd231ps zmm7, zmm0, zmm8
    vmovaps zmm3, zmm21
    vfmadd231ps zmm3, zmm20, zmm9
    vmulps zmm4, zmm15, zmm9
    vmovups zmm6, [rsp+7360]
    vmovaps zmm16, zmm11
    vpermi2ps zmm16, zmm31, zmm30
    vmovaps zmm14, zmm11
    vpermi2ps zmm14, zmm29, zmm28
    vpmovdw [r11+(0+W*1)], zmm13
    vpermi2ps zmm11, zmm27, zmm26
    vmovups zmm2, [rsp+8256]
    vcmpps k2, zmm5, zmm17, 21
    vmovaps zmm1, zmm18
    vfmadd231ps zmm1, zmm7, [rsp+7808]
    vpternlogd zmm7{k1}{z}, zmm19, [r14+640], 184
    vfmadd213ps zmm3, zmm9, zmm22
    vptestnmd k3, zmm6, zmm19
    vmulps zmm0, zmm7, [c_mtl2]{1to16}
    vfmsub231ps zmm14, zmm10, zmm16
    vmovaps zmm8, zmm24
    vfmadd231ps zmm8, zmm2, zmm25
    vmovups zmm13, [rsp+7552]
    kmovw [r14+1282], k2
    vfmadd231ps zmm12, zmm1, [c_mtl2]{1to16}
    vfmadd213ps zmm3, zmm9, zmm23
    vmovaps zmm5, zmm21
    vfmadd231ps zmm5, zmm20, zmm14
    vmulps zmm6, zmm11, zmm14
    vmovaps zmm7, zmm8
    vpermi2ps zmm7, zmm31, zmm30
    vmovaps zmm10, zmm8
    vpermi2ps zmm10, zmm29, zmm28
    vpermi2ps zmm8, zmm27, zmm26
    vptestnmd k4, zmm13, zmm19
    vfmadd231ps zmm15, zmm4, zmm3
    vfmadd213ps zmm5, zmm14, zmm22
    vmovaps zmm16, zmm18
    vfmadd231ps zmm16, zmm15, [rsp+7424]
    vpternlogd zmm15{k3}{z}, zmm19, [r14+512], 184
    vfmadd213ps zmm5, zmm14, zmm23
    vfmadd231ps zmm0, zmm15, [c_mtl0]{1to16}
    vmovups zmm1, [rsp+7872]
    vfmadd231ps zmm12, zmm16, [c_mtl0]{1to16}
    vfmadd231ps zmm11, zmm6, zmm5
    vmovaps zmm9, zmm24
    vfmadd231ps zmm9, zmm1, zmm25
    vfmsub231ps zmm10, zmm2, zmm7
    vmovaps zmm13, zmm18
    vfmadd231ps zmm13, zmm11, [rsp+7616]
    vpternlogd zmm11{k4}{z}, zmm19, [r14+576], 184
    vmovaps zmm4, zmm9
    vpermi2ps zmm4, zmm31, zmm30
    vmovaps zmm3, zmm9
    vpermi2ps zmm3, zmm29, zmm28
    vfmadd231ps zmm0, zmm11, [c_mtl1]{1to16}
    jmp .j4800
.j4800:
    vpermi2ps zmm9, zmm27, zmm26
    vmovaps zmm14, zmm21
    vfmadd231ps zmm14, zmm20, zmm10
    vmulps zmm15, zmm8, zmm10
    vmovups zmm16, [rsp+8320]
    vfmadd231ps zmm12, zmm13, [c_mtl1]{1to16}
    vbroadcastss zmm6, [c_sl]
    vreduceps zmm5, zmm0, 8
    vcvtps2dq zmm2, zmm0, {rn-sae}
    vfmadd213ps zmm14, zmm10, zmm22
    vmovups zmm7, [rsp+8064]
    vptestnmd k5, zmm16, zmm19
    vpaddd zmm11, zmm2, [c_i64]{1to16}
    vfmadd213ps zmm14, zmm10, zmm23
    vfmsub231ps zmm3, zmm1, zmm4
    vandps zmm13, zmm5, [c_absm]{1to16}
    vpminsd zmm0, zmm11, [c_i1023]{1to16}
    vmovaps zmm16, zmm24
    vfmadd231ps zmm16, zmm7, zmm25
    vaddps zmm2, zmm13, zmm12
    vpmaxsd zmm10, zmm0, [c_zero]{1to16}
    vfmadd231ps zmm8, zmm15, zmm14
    vmovaps zmm1, zmm21
    vfmadd231ps zmm1, zmm20, zmm3
    vmovups zmm4, [rsp+7936]
    vmulps zmm5, zmm9, zmm3
    vpmovdw [r11+(32+W*0)], zmm10
    vmovaps zmm11, zmm16
    vpermi2ps zmm11, zmm31, zmm30
    vcmpps k6, zmm2, zmm17, 21
    vmovaps zmm13, zmm16
    vpermi2ps zmm13, zmm29, zmm28
    vmovups zmm12, [rsp+8448]
    vpermi2ps zmm16, zmm27, zmm26
    vmovaps zmm0, zmm18
    vfmadd231ps zmm0, zmm8, [rsp+8384]
    vpternlogd zmm8{k5}{z}, zmm19, [r14+896], 184
    vfmadd213ps zmm1, zmm3, zmm22
    vptestnmd k7, zmm4, zmm19
    vmulps zmm15, zmm8, [c_mtl2]{1to16}
    vmovaps zmm14, zmm24
    vfmadd231ps zmm14, zmm12, zmm25
    vfmsub231ps zmm13, zmm7, zmm11
    kmovw [r14+1284], k6
    vmovups zmm10, [rsp+8128]
    vfmadd231ps zmm6, zmm0, [c_mtl2]{1to16}
    vfmadd213ps zmm1, zmm3, zmm23
    vmovaps zmm2, zmm14
    vpermi2ps zmm2, zmm31, zmm30
    vmovaps zmm4, zmm14
    vpermi2ps zmm4, zmm29, zmm28
    vmovaps zmm8, zmm21
    vfmadd231ps zmm8, zmm20, zmm13
    vpermi2ps zmm14, zmm27, zmm26
    vmulps zmm7, zmm16, zmm13
    vfmadd231ps zmm9, zmm5, zmm1
    vptestnmd k1, zmm10, zmm19
    vfmadd213ps zmm8, zmm13, zmm22
    vmovaps zmm11, zmm18
    vfmadd231ps zmm11, zmm9, [rsp+8000]
    vpternlogd zmm9{k7}{z}, zmm19, [r14+768], 184
    vfmadd231ps zmm15, zmm9, [c_mtl0]{1to16}
    vfmadd213ps zmm8, zmm13, zmm23
    vmovups zmm0, [rsp+8640]
    jmp .j4864
.j4864:
    vfmadd231ps zmm6, zmm11, [c_mtl0]{1to16}
    vfmadd231ps zmm16, zmm7, zmm8
    vmovaps zmm3, zmm24
    vfmadd231ps zmm3, zmm0, zmm25
    vfmsub231ps zmm4, zmm12, zmm2
    vmovaps zmm5, zmm18
    vfmadd231ps zmm5, zmm16, [rsp+8192]
    vpternlogd zmm16{k1}{z}, zmm19, [r14+832], 184
    vmovaps zmm1, zmm3
    vpermi2ps zmm1, zmm31, zmm30
    vmovaps zmm10, zmm3
    vpermi2ps zmm10, zmm29, zmm28
    vpermi2ps zmm3, zmm27, zmm26
    vmovaps zmm9, zmm21
    vfmadd231ps zmm9, zmm20, zmm4
    vmulps zmm13, zmm14, zmm4
    vfmadd231ps zmm15, zmm16, [c_mtl1]{1to16}
    vmovups zmm11, [rsp+8512]
    vmovups zmm7, [rsp+8832]
    vfmadd231ps zmm6, zmm5, [c_mtl1]{1to16}
    vfmadd213ps zmm9, zmm4, zmm22
    vreduceps zmm8, zmm15, 8
    vcvtps2dq zmm12, zmm15, {rn-sae}
    vptestnmd k2, zmm11, zmm19
    vfmsub231ps zmm10, zmm0, zmm1
    vfmadd231ps zmm24, zmm7, zmm25
    vpaddd zmm2, zmm12, [c_i64]{1to16}
    vfmadd213ps zmm9, zmm4, zmm23
    vmovaps zmm16, zmm21
    vfmadd231ps zmm16, zmm20, zmm10
    vmulps zmm5, zmm3, zmm10
    vandps zmm15, zmm8, [c_absm]{1to16}
    vpminsd zmm11, zmm2, [c_i1023]{1to16}
    vmovaps zmm0, zmm24
    vpermi2ps zmm0, zmm31, zmm30
    vmovaps zmm1, zmm24
    vpermi2ps zmm1, zmm29, zmm28
    vpermi2ps zmm24, zmm27, zmm26
    vmovups zmm12, [rsp+8704]
    vaddps zmm4, zmm15, zmm6
    vpmaxsd zmm8, zmm11, [c_zero]{1to16}
    vfmadd231ps zmm14, zmm13, zmm9
    vmovups zmm2, [rsp+8896]
    vfmadd213ps zmm16, zmm10, zmm22
    vpmovdw [r11+(32+W*1)], zmm8
    vcmpps k3, zmm4, zmm17, 21
    vfmsub231ps zmm1, zmm7, zmm0
    vptestnmd k4, zmm12, zmm19
    vmovaps zmm15, zmm18
    vfmadd231ps zmm15, zmm14, [rsp+8576]
    vpternlogd zmm14{k2}{z}, zmm19, [r14+1024], 184
    vbroadcastss zmm6, [c_sl]
    vfmadd213ps zmm16, zmm10, zmm23
    vptestnmd k5, zmm2, zmm19
    vmulps zmm11, zmm14, [c_mth1]{1to16}
    vfmadd231ps zmm21, zmm20, zmm1
    vmulps zmm13, zmm24, zmm1
    vbroadcastss zmm9, [c_sl]
    kmovw [r14+1286], k3
    vfmadd231ps zmm3, zmm5, zmm16
    vfmadd231ps zmm6, zmm15, [c_mth1]{1to16}
    vfmadd231ps zmm22, zmm21, zmm1
    vmovaps zmm8, zmm18
    vfmadd231ps zmm8, zmm3, [rsp+8768]
    jmp .j4928
.j4928:
    vpternlogd zmm3{k4}{z}, zmm19, [r14+1088], 184
    vfmadd231ps zmm23, zmm22, zmm1
    vfmadd231ps zmm11, zmm3, [c_mth2]{1to16}
    vfmadd231ps zmm6, zmm8, [c_mth2]{1to16}
    vfmadd231ps zmm24, zmm13, zmm23
    vfmadd231ps zmm18, zmm24, [rsp+8960]
    vpternlogd zmm24{k5}{z}, zmm19, [r14+1152], 184
    vfmsub231ps zmm11, zmm24, [c_mth0]{1to16}
    vmulps zmm4, zmm24, [c_mth5]{1to16}
    vfmadd231ps zmm6, zmm18, [c_mth0]{1to16}
    vfmadd231ps zmm9, zmm18, [c_mth5]{1to16}
    vfmadd231ps zmm4, zmm3, [c_mth4]{1to16}
    vreduceps zmm7, zmm11, 8
    vcvtps2dq zmm0, zmm11, {rn-sae}
    vfmadd231ps zmm9, zmm8, [c_mth4]{1to16}
    vmovups zmm12, [c_pkw]
    vfmsub231ps zmm4, zmm14, [c_mth0]{1to16}
    vpaddd zmm10, zmm0, [c_i512]{1to16}
    vandps zmm2, zmm7, [c_absm]{1to16}
    vpminsd zmm5, zmm10, [c_i1023]{1to16}
    vfmadd231ps zmm9, zmm15, [c_mth0]{1to16}
    vaddps zmm16, zmm2, zmm6
    vreduceps zmm21, zmm4, 8
    vpmaxsd zmm22, zmm5, [c_zero]{1to16}
    vcvtps2dq zmm1, zmm4, {rn-sae}
    vpermw zmm13, zmm12, zmm22
    vcmpps k6, zmm16, zmm17, 21
    vpaddd zmm23, zmm1, [c_i512]{1to16}
    vandps zmm24, zmm21, [c_absm]{1to16}
    vpminsd zmm18, zmm23, [c_i1023]{1to16}
    vmovdqu16 [r6], ymm13
    vaddps zmm3, zmm24, zmm9
    vpmaxsd zmm11, zmm18, [c_zero]{1to16}
    vcmpps k7, zmm3, zmm17, 21
    vpermw zmm8, zmm12, zmm11
    vmovdqu16 [gs:r6], ymm8
    korw k1, k6, k7
    kmovw [r14+1288], k1
    kmovq k1, [r13 + 1280]
    kortestq k1, k1
    jz .xle0
    lea r2, [r11 - 64]
    sub r2, [rsp + 11208]
    vpbroadcastd zmm3, r2d
    mov r2d, [rsp + STX+5120]
    kmovw k2, [r13 + 1280]
    vmovups zmm0, [r13 + 0]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+0], zmm0
    vmovups zmm0, [r13 + 64]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+512], zmm0
    vmovups zmm0, [r13 + 128]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1024], zmm0
    vmovups zmm0, [r13 + 192]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1536], zmm0
    vpaddd zmm0, zmm3, [t_lad + 0]
    vpcompressd zmm0{k2}{z}, zmm0
    vmovdqu32 [rsp + r2*4 + STX+2048], zmm0
    movzx r5d, word [r13 + 1280]
    popcnt r5d, r5d
    add r2d, r5d
    kmovw k2, [r13 + 1282]
    vmovups zmm0, [r13 + 256]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+0], zmm0
    vmovups zmm0, [r13 + 320]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+512], zmm0
    vmovups zmm0, [r13 + 384]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1024], zmm0
    vmovups zmm0, [r13 + 448]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1536], zmm0
    vpaddd zmm0, zmm3, [t_lad + 64]
    vpcompressd zmm0{k2}{z}, zmm0
    vmovdqu32 [rsp + r2*4 + STX+2048], zmm0
    movzx r5d, word [r13 + 1282]
    popcnt r5d, r5d
    add r2d, r5d
    kmovw k2, [r13 + 1284]
    vmovups zmm0, [r13 + 512]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+0], zmm0
    vmovups zmm0, [r13 + 576]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+512], zmm0
    vmovups zmm0, [r13 + 640]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1024], zmm0
    vmovups zmm0, [r13 + 704]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1536], zmm0
    vpaddd zmm0, zmm3, [t_lad + 128]
    vpcompressd zmm0{k2}{z}, zmm0
    vmovdqu32 [rsp + r2*4 + STX+2048], zmm0
    movzx r5d, word [r13 + 1284]
    popcnt r5d, r5d
    add r2d, r5d
    kmovw k2, [r13 + 1286]
    vmovups zmm0, [r13 + 768]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+0], zmm0
    vmovups zmm0, [r13 + 832]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+512], zmm0
    vmovups zmm0, [r13 + 896]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1024], zmm0
    vmovups zmm0, [r13 + 960]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1536], zmm0
    vpaddd zmm0, zmm3, [t_lad + 192]
    vpcompressd zmm0{k2}{z}, zmm0
    vmovdqu32 [rsp + r2*4 + STX+2048], zmm0
    movzx r5d, word [r13 + 1286]
    popcnt r5d, r5d
    add r2d, r5d
    mov [rsp + STX+5120], r2d
    cmp r2d, 65
    jb .xle0
    call .fll
.xle0:
    lea r5, [r6 - 32]
    sub r5, [rsp + 11208]
    vpbroadcastd zmm3, r5d
    mov r2d, [rsp + STX+5124]
    kmovw k1, [r13 + 1288]
    vmovups zmm0, [r13 + 1024]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [rsp + r2*4 + STX+2560], zmm0
    vmovups zmm0, [r13 + 1088]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [rsp + r2*4 + STX+3072], zmm0
    vmovups zmm0, [r13 + 1152]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [rsp + r2*4 + STX+3584], zmm0
    vmovups zmm0, [r13 + 1216]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [rsp + r2*4 + STX+4096], zmm0
    vpaddd zmm0, zmm3, [t_c2d]
    vpcompressd zmm0{k1}{z}, zmm0
    vmovdqu32 [rsp + r2*4 + STX+4608], zmm0
    movzx r5d, word [r13 + 1288]
    popcnt r5d, r5d
    add r2d, r5d
    mov [rsp + STX+5124], r2d
    cmp r2d, 65
    jb .xce0
    call .flc
.xce0:
    kmovq k1, [r14 + 1280]
    kortestq k1, k1
    jz .xle1
    lea r2, [r11 - 0]
    sub r2, [rsp + 11208]
    vpbroadcastd zmm3, r2d
    mov r2d, [rsp + STX+5120]
    kmovw k2, [r14 + 1280]
    vmovups zmm0, [r14 + 0]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+0], zmm0
    vmovups zmm0, [r14 + 64]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+512], zmm0
    vmovups zmm0, [r14 + 128]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1024], zmm0
    vmovups zmm0, [r14 + 192]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1536], zmm0
    vpaddd zmm0, zmm3, [t_lad + 0]
    vpcompressd zmm0{k2}{z}, zmm0
    vmovdqu32 [rsp + r2*4 + STX+2048], zmm0
    movzx r5d, word [r14 + 1280]
    popcnt r5d, r5d
    add r2d, r5d
    kmovw k2, [r14 + 1282]
    vmovups zmm0, [r14 + 256]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+0], zmm0
    vmovups zmm0, [r14 + 320]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+512], zmm0
    vmovups zmm0, [r14 + 384]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1024], zmm0
    vmovups zmm0, [r14 + 448]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1536], zmm0
    vpaddd zmm0, zmm3, [t_lad + 64]
    vpcompressd zmm0{k2}{z}, zmm0
    vmovdqu32 [rsp + r2*4 + STX+2048], zmm0
    movzx r5d, word [r14 + 1282]
    popcnt r5d, r5d
    add r2d, r5d
    kmovw k2, [r14 + 1284]
    vmovups zmm0, [r14 + 512]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+0], zmm0
    vmovups zmm0, [r14 + 576]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+512], zmm0
    vmovups zmm0, [r14 + 640]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1024], zmm0
    vmovups zmm0, [r14 + 704]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1536], zmm0
    vpaddd zmm0, zmm3, [t_lad + 128]
    vpcompressd zmm0{k2}{z}, zmm0
    vmovdqu32 [rsp + r2*4 + STX+2048], zmm0
    movzx r5d, word [r14 + 1284]
    popcnt r5d, r5d
    add r2d, r5d
    kmovw k2, [r14 + 1286]
    vmovups zmm0, [r14 + 768]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+0], zmm0
    vmovups zmm0, [r14 + 832]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+512], zmm0
    vmovups zmm0, [r14 + 896]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1024], zmm0
    vmovups zmm0, [r14 + 960]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1536], zmm0
    vpaddd zmm0, zmm3, [t_lad + 192]
    vpcompressd zmm0{k2}{z}, zmm0
    vmovdqu32 [rsp + r2*4 + STX+2048], zmm0
    movzx r5d, word [r14 + 1286]
    popcnt r5d, r5d
    add r2d, r5d
    mov [rsp + STX+5120], r2d
    cmp r2d, 65
    jb .xle1
    call .fll
.xle1:
    lea r5, [r6 - 0]
    sub r5, [rsp + 11208]
    vpbroadcastd zmm3, r5d
    mov r2d, [rsp + STX+5124]
    kmovw k1, [r14 + 1288]
    vmovups zmm0, [r14 + 1024]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [rsp + r2*4 + STX+2560], zmm0
    vmovups zmm0, [r14 + 1088]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [rsp + r2*4 + STX+3072], zmm0
    vmovups zmm0, [r14 + 1152]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [rsp + r2*4 + STX+3584], zmm0
    vmovups zmm0, [r14 + 1216]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [rsp + r2*4 + STX+4096], zmm0
    vpaddd zmm0, zmm3, [t_c2d]
    vpcompressd zmm0{k1}{z}, zmm0
    vmovdqu32 [rsp + r2*4 + STX+4608], zmm0
    movzx r5d, word [r14 + 1288]
    popcnt r5d, r5d
    add r2d, r5d
    mov [rsp + STX+5124], r2d
    cmp r2d, 65
    jb .xce1
    call .flc
.xce1:
    cmp dword [rsp + STX+5120], 0
    je .fel
    call .fll
.fel:
    cmp dword [rsp + STX+5124], 0
    je .fec
    call .flc
.fec:
    mov rsp, [rsp + 11200]
    pop r12
    pop r11
    pop r14
    pop r13
    pop r10
    pop r9
    ret
.hk:
    mov [rsp + 11136], r5
    kmovq k1, [r13 + 1280]
    kortestq k1, k1
    jz .xlh
    lea r5, [r11 - 64 - W]
    lea r2, [r11 - 64]
    cmp r3d, 32 - W/2
    cmove r2, r5
    sub r2, [rsp + 11208]
    vpbroadcastd zmm3, r2d
    mov r2d, [rsp + STX+5120]
    kmovw k2, [r13 + 1280]
    vmovups zmm0, [r13 + 0]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+0], zmm0
    vmovups zmm0, [r13 + 64]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+512], zmm0
    vmovups zmm0, [r13 + 128]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1024], zmm0
    vmovups zmm0, [r13 + 192]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1536], zmm0
    vpaddd zmm0, zmm3, [t_lad + 0]
    vpcompressd zmm0{k2}{z}, zmm0
    vmovdqu32 [rsp + r2*4 + STX+2048], zmm0
    movzx r5d, word [r13 + 1280]
    popcnt r5d, r5d
    add r2d, r5d
    kmovw k2, [r13 + 1282]
    vmovups zmm0, [r13 + 256]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+0], zmm0
    vmovups zmm0, [r13 + 320]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+512], zmm0
    vmovups zmm0, [r13 + 384]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1024], zmm0
    vmovups zmm0, [r13 + 448]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1536], zmm0
    vpaddd zmm0, zmm3, [t_lad + 64]
    vpcompressd zmm0{k2}{z}, zmm0
    vmovdqu32 [rsp + r2*4 + STX+2048], zmm0
    movzx r5d, word [r13 + 1282]
    popcnt r5d, r5d
    add r2d, r5d
    kmovw k2, [r13 + 1284]
    vmovups zmm0, [r13 + 512]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+0], zmm0
    vmovups zmm0, [r13 + 576]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+512], zmm0
    vmovups zmm0, [r13 + 640]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1024], zmm0
    vmovups zmm0, [r13 + 704]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1536], zmm0
    vpaddd zmm0, zmm3, [t_lad + 128]
    vpcompressd zmm0{k2}{z}, zmm0
    vmovdqu32 [rsp + r2*4 + STX+2048], zmm0
    movzx r5d, word [r13 + 1284]
    popcnt r5d, r5d
    add r2d, r5d
    kmovw k2, [r13 + 1286]
    vmovups zmm0, [r13 + 768]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+0], zmm0
    vmovups zmm0, [r13 + 832]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+512], zmm0
    vmovups zmm0, [r13 + 896]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1024], zmm0
    vmovups zmm0, [r13 + 960]
    vcompressps zmm0{k2}{z}, zmm0
    vmovups [rsp + r2*4 + STX+1536], zmm0
    vpaddd zmm0, zmm3, [t_lad + 192]
    vpcompressd zmm0{k2}{z}, zmm0
    vmovdqu32 [rsp + r2*4 + STX+2048], zmm0
    movzx r5d, word [r13 + 1286]
    popcnt r5d, r5d
    add r2d, r5d
    mov [rsp + STX+5120], r2d
    cmp r2d, 65
    jb .xlh
    call .fll
.xlh:
    lea r5, [r6 - 32]
    sub r5, [rsp + 11208]
    vpbroadcastd zmm3, r5d
    mov r2d, [rsp + STX+5124]
    kmovw k1, [r13 + 1288]
    vmovups zmm0, [r13 + 1024]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [rsp + r2*4 + STX+2560], zmm0
    vmovups zmm0, [r13 + 1088]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [rsp + r2*4 + STX+3072], zmm0
    vmovups zmm0, [r13 + 1152]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [rsp + r2*4 + STX+3584], zmm0
    vmovups zmm0, [r13 + 1216]
    vcompressps zmm0{k1}{z}, zmm0
    vmovups [rsp + r2*4 + STX+4096], zmm0
    vpaddd zmm0, zmm3, [t_c2d]
    vpcompressd zmm0{k1}{z}, zmm0
    vmovdqu32 [rsp + r2*4 + STX+4608], zmm0
    movzx r5d, word [r13 + 1288]
    popcnt r5d, r5d
    add r2d, r5d
    mov [rsp + STX+5124], r2d
    cmp r2d, 65
    jb .xch
    call .flc
.xch:
    mov r5, [rsp + 11136]
    jmp .hr
.fll:
    sub rsp, TS
    mov [rsp + T_SV], r10
    mov [rsp + T_SV + 8], r6
    mov [rsp + T_SV + 16], r9
    mov [rsp + T_SV + 24], r3
    mov [rsp + T_SV + 32], r1
    mov [rsp + T_SV + 40], r0
    mov [rsp + T_SV + 48], r4
    mov [rsp + T_SV + 56], r5
    mov r10, rsp
    mov r6, [r10 + TS + 8 + 11216]
    mov [r10 + T_SRC], r6
    lea r0, [r10 + TS + 8 + STX+2048]
    mov r4, [r10 + TS + 8 + 11208]
    mov r5d, [r10 + TS + 8 + STX+5120]
    mov dword [r10 + TS + 8 + STX+5120], 0
    xor r9d, r9d
    lea r1, [r10 + TS + 8 + STX+0]
.fl1:
    kxorb k7, k7, k7
    vcvtps2pd zmm16, [r1 + 1536]
    vbroadcastsd zmm17, [d_anl]
    vfnmadd213pd zmm16, zmm17, [d_tab]{1to8}
    xor r6d, r6d
.cl:
    vcvtps2pd zmm0, [r1 + r6*4]
    vmulpd zmm0, zmm0, [d_kvl]{1to8}
    vmovapd zmm1, zmm16
    vbroadcastsd zmm2, [d_rgl]
    call .ivq
    vmovapd [r10 + T_E1 + r6], zmm0
    vmovapd [r10 + T_E1 + r6 + 64], zmm1
    sub r6d, -128
    cmp r6d, 384
    jne .cl
    vbroadcastsd zmm0, [d_sll]
    vbroadcastsd zmm1, [d_shl]
    vbroadcastsd zmm2, [d_emc0]
    vfmadd231pd zmm0, zmm2, [r10 + T_E1 + 0]
    vfmadd231pd zmm1, zmm2, [r10 + T_E1 + 64]
    vbroadcastsd zmm2, [d_emc1]
    vfmadd231pd zmm0, zmm2, [r10 + T_E1 + 128]
    vfmadd231pd zmm1, zmm2, [r10 + T_E1 + 192]
    vbroadcastsd zmm2, [d_emc2]
    vfmadd231pd zmm0, zmm2, [r10 + T_E1 + 256]
    vfmadd231pd zmm1, zmm2, [r10 + T_E1 + 320]
    vcvtpd2qq zmm2, zmm0, {rn-sae}
    vcvtpd2qq zmm3, zmm1, {rn-sae}
    vcmppd k1, zmm0, zmm1, 7
    vpcmpeqq k1{k1}, zmm2, zmm3
    vpxorq xmm3, xmm3, xmm3
    vpmaxsq zmm2, zmm2, zmm3
    vpternlogq zmm4, zmm4, zmm4, 0xff
    vpminsq zmm4{k1}, zmm2, [d_q1023]{1to8}
    vmovdqa64 [r10 + T_RQ + r9*8], zmm4
    add r1, 32
    add r9d, 8
    cmp r9d, r5d
    jb .fl1
    xor r9d, r9d
.fl2:
    mov r6d, [r0 + r9*4]
    mov r2, [r10 + T_RQ + r9*8]
    test r2, r2
    js .fl4
    jmp .fl3
.fl4:
    mov [r10 + T_O], r6d
    mov [r10 + T_SV + 64], r7
    mov [r10 + T_SV + 72], r8
    mov [r10 + T_SV + 80], r14
    mov [r10 + T_SV + 88], r11
    mov [r10 + T_SV + 96], r12
    call .t2l
    mov r7, [r10 + T_SV + 64]
    mov r8, [r10 + T_SV + 72]
    mov r14, [r10 + T_SV + 80]
    mov r11, [r10 + T_SV + 88]
    mov r12, [r10 + T_SV + 96]
    mov r6d, [r10 + T_O]
.fl3:
    mov [r4 + r6], r2w
    inc r9d
    cmp r9d, r5d
    jb .fl2
    mov r6, [r10 + T_SV + 8]
    mov r9, [r10 + T_SV + 16]
    mov r3, [r10 + T_SV + 24]
    mov r1, [r10 + T_SV + 32]
    mov r0, [r10 + T_SV + 40]
    mov r4, [r10 + T_SV + 48]
    mov r5, [r10 + T_SV + 56]
    mov r10, [rsp + T_SV]
    add rsp, TS
    ret
.flc:
    sub rsp, TS
    mov [rsp + T_SV], r10
    mov [rsp + T_SV + 8], r6
    mov [rsp + T_SV + 16], r9
    mov [rsp + T_SV + 24], r3
    mov [rsp + T_SV + 32], r1
    mov [rsp + T_SV + 40], r0
    mov [rsp + T_SV + 48], r4
    mov [rsp + T_SV + 56], r5
    mov r10, rsp
    mov r6, [r10 + TS + 8 + 11216]
    mov [r10 + T_SRC], r6
    lea r0, [r10 + TS + 8 + STX+4608]
    mov r4, [r10 + TS + 8 + 11208]
    mov r5d, [r10 + TS + 8 + STX+5124]
    mov dword [r10 + TS + 8 + STX+5124], 0
    xor r9d, r9d
    lea r1, [r10 + TS + 8 + STX+2560]
.fc1:
    kxorb k7, k7, k7
    vcvtps2pd zmm16, [r1 + 1536]
    vbroadcastsd zmm17, [d_anh]
    vfnmadd213pd zmm16, zmm17, [d_tab]{1to8}
    xor r6d, r6d
.ch:
    vcvtps2pd zmm0, [r1 + r6*4]
    vmulpd zmm0, zmm0, [d_kvh]{1to8}
    vmovapd zmm1, zmm16
    vbroadcastsd zmm2, [d_rgh]
    call .ivq
    vmovapd [r10 + T_E1 + r6], zmm0
    vmovapd [r10 + T_E1 + r6 + 64], zmm1
    sub r6d, -128
    cmp r6d, 384
    jne .ch
    vbroadcastsd zmm0, [d_slh]
    vbroadcastsd zmm2, [d_emc5]
    vfnmadd231pd zmm0, zmm2, [r10 + T_E1 + 192]
    vbroadcastsd zmm2, [d_emc4]
    vfnmadd231pd zmm0, zmm2, [r10 + T_E1 + 64]
    vbroadcastsd zmm2, [d_emc3]
    vfmadd231pd zmm0, zmm2, [r10 + T_E1 + 256]
    vbroadcastsd zmm1, [d_shh]
    vbroadcastsd zmm2, [d_emc5]
    vfnmadd231pd zmm1, zmm2, [r10 + T_E1 + 128]
    vbroadcastsd zmm2, [d_emc4]
    vfnmadd231pd zmm1, zmm2, [r10 + T_E1 + 0]
    vbroadcastsd zmm2, [d_emc3]
    vfmadd231pd zmm1, zmm2, [r10 + T_E1 + 320]
    vbroadcastsd zmm5, [d_slh]
    vbroadcastsd zmm2, [d_emc8]
    vfnmadd231pd zmm5, zmm2, [r10 + T_E1 + 320]
    vbroadcastsd zmm2, [d_emc7]
    vfnmadd231pd zmm5, zmm2, [r10 + T_E1 + 192]
    vbroadcastsd zmm2, [d_emc6]
    vfmadd231pd zmm5, zmm2, [r10 + T_E1 + 0]
    vbroadcastsd zmm6, [d_shh]
    vbroadcastsd zmm2, [d_emc8]
    vfnmadd231pd zmm6, zmm2, [r10 + T_E1 + 256]
    vbroadcastsd zmm2, [d_emc7]
    vfnmadd231pd zmm6, zmm2, [r10 + T_E1 + 128]
    vbroadcastsd zmm2, [d_emc6]
    vfmadd231pd zmm6, zmm2, [r10 + T_E1 + 64]
    vcvtpd2qq zmm2, zmm5, {rn-sae}
    vcvtpd2qq zmm3, zmm6, {rn-sae}
    vcmppd k1, zmm5, zmm6, 7
    vpcmpeqq k1{k1}, zmm2, zmm3
    vpxorq xmm3, xmm3, xmm3
    vpmaxsq zmm2, zmm2, zmm3
    vpternlogq zmm7, zmm7, zmm7, 0xff
    vpminsq zmm7{k1}, zmm2, [d_q1023]{1to8}
    vcvtpd2qq zmm2, zmm0, {rn-sae}
    vcvtpd2qq zmm3, zmm1, {rn-sae}
    vcmppd k1, zmm0, zmm1, 7
    vpcmpeqq k1{k1}, zmm2, zmm3
    vpxorq xmm3, xmm3, xmm3
    vpmaxsq zmm2, zmm2, zmm3
    vpternlogq zmm4, zmm4, zmm4, 0xff
    vpminsq zmm4{k1}, zmm2, [d_q1023]{1to8}
    vpcmpeqq k2, zmm7, [d_mq1]{1to8}
    vmovdqa64 zmm4{k2}, zmm7
    vmovdqa64 [r10 + T_RQ + r9*8], zmm4
    vmovdqa64 [r10 + T_RQ + 1024 + r9*8], zmm7
    add r1, 32
    add r9d, 8
    cmp r9d, r5d
    jb .fc1
    xor r9d, r9d
.fc2:
    mov r6d, [r0 + r9*4]
    mov r2, [r10 + T_RQ + r9*8]
    test r2, r2
    js .fc4
    mov r3, [r10 + T_RQ + 1024 + r9*8]
    shl r3d, 16
    or r2d, r3d
    jmp .fc3
.fc4:
    mov [r10 + T_O], r6d
    mov [r10 + T_SV + 64], r7
    mov [r10 + T_SV + 72], r8
    mov [r10 + T_SV + 80], r14
    mov [r10 + T_SV + 88], r11
    mov [r10 + T_SV + 96], r12
    call .t2c
    mov r7, [r10 + T_SV + 64]
    mov r8, [r10 + T_SV + 72]
    mov r14, [r10 + T_SV + 80]
    mov r11, [r10 + T_SV + 88]
    mov r12, [r10 + T_SV + 96]
    mov r6d, [r10 + T_O]
.fc3:
    mov [r4 + r6], r2w
    shr r2d, 16
    mov [gs:r4 + r6], r2w
    inc r9d
    cmp r9d, r5d
    jb .fc2
    mov r6, [r10 + T_SV + 8]
    mov r9, [r10 + T_SV + 16]
    mov r3, [r10 + T_SV + 24]
    mov r1, [r10 + T_SV + 32]
    mov r0, [r10 + T_SV + 40]
    mov r4, [r10 + T_SV + 48]
    mov r5, [r10 + T_SV + 56]
    mov r10, [rsp + T_SV]
    add rsp, TS
    ret
.ivq:
    vrangepd zmm3, zmm0, zmm0, 8
    vfmadd213pd zmm2, zmm3, zmm1
    vsubpd zmm4, zmm3, zmm2
    vcmppd k1, zmm4, zmm2, 0x1e
    vaddpd zmm5, zmm3, zmm2
    vmovapd zmm5{k1}, zmm3
    vpsrlq zmm6, zmm5, 48
    vpsrlq zmm7, zmm5, 52
    vmovapd zmm8, [d_qa]
    vpermt2pd zmm8, zmm7, [d_qa + 64]
    vpsrlq zmm7, zmm5, 56
    vpermpd zmm7, zmm7, [d_qb]
    vmulpd zmm8, zmm8, zmm7
    vmovapd zmm7, [d_qw]
    vpermt2pd zmm7, zmm6, [d_qw + 64]
    vmulpd zmm8, zmm8, zmm7
    vgetmantpd zmm9, zmm5, 4
    vmovapd zmm7, [d_rx]
    vpermt2pd zmm7, zmm6, [d_rx + 64]
    vfmsub213pd zmm9, zmm7, [d_one]{1to8}
    vmulpd zmm10, zmm9, zmm9
    vbroadcastsd zmm11, [d_qp5]
    vfmadd213pd zmm11, zmm9, [d_qp4]{1to8}
    vbroadcastsd zmm12, [d_qp3]
    vfmadd213pd zmm12, zmm9, [d_qp2]{1to8}
    vbroadcastsd zmm13, [d_qp1]
    vfmadd213pd zmm13, zmm9, [d_qp0]{1to8}
    vfmadd213pd zmm11, zmm10, zmm12
    vfmadd213pd zmm11, zmm10, zmm13
    vmulpd zmm8, zmm8, zmm11
    vbroadcastsd zmm9, [d_c2]
    vfmadd213pd zmm9, zmm8, [d_c1]{1to8}
    vbroadcastsd zmm10, [d_c3]
    vfmadd213pd zmm10, zmm8, [d_one]{1to8}
    vdivpd zmm9, zmm9, zmm10
    vpsrlq zmm6, zmm9, 47
    vmovapd zmm7, [d_qr]
    vpermt2pd zmm7, zmm6, [d_qr + 64]
    vfmsub213pd zmm7, zmm9, [d_one]{1to8}
    vmulpd zmm10, zmm7, zmm7
    vbroadcastsd zmm11, [d_ql3]
    vfmadd213pd zmm11, zmm7, [d_ql2]{1to8}
    vbroadcastsd zmm12, [d_ql1]
    vfmadd213pd zmm12, zmm7, [d_ql0]{1to8}
    vbroadcastsd zmm13, [d_ql4]
    vfmadd213pd zmm13, zmm10, zmm11
    vfmadd213pd zmm13, zmm10, zmm12
    vmovapd zmm11, [d_qm]
    vpermt2pd zmm11, zmm6, [d_qm + 64]
    vfmadd213pd zmm13, zmm7, zmm11
    vrndscalepd zmm14, zmm13, 0x48
    vaddpd zmm6, zmm14, [d_qtk]{1to8}
    vmovapd zmm11, [d_qt]
    vpermt2pd zmm11, zmm6, [d_qt + 64]
    vsubpd zmm13, zmm13, zmm14
    vmulpd zmm10, zmm13, zmm13
    vbroadcastsd zmm7, [d_qe3]
    vfmadd213pd zmm7, zmm13, [d_qe2]{1to8}
    vbroadcastsd zmm12, [d_qe1]
    vfmadd213pd zmm12, zmm13, [d_qe0]{1to8}
    vbroadcastsd zmm15, [d_qe4]
    vfmadd213pd zmm15, zmm10, zmm7
    vfmadd213pd zmm15, zmm10, zmm12
    vmulpd zmm11, zmm11, zmm15
    vscalefpd zmm11, zmm11, zmm14
    vcmppd k2, zmm5, [d_one]{1to8}, 0x1e
    vsubpd zmm7, zmm5, [d_one]{1to8}
    vbroadcastsd zmm12, [d_m12]
    vfmadd213pd zmm7, zmm12, [d_one]{1to8}
    vmovapd zmm11{k2}, zmm7
    vmulpd zmm6, zmm2, [d_1024]{1to8}
    vcmppd k3, zmm6, zmm4, 0x16
    vsubpd zmm6, zmm9, [d_c1]{1to8}
    vbroadcastsd zmm7, [d_c2]
    vdivpd zmm7, zmm7, zmm9
    vsubpd zmm7, zmm7, [d_c3]{1to8}
    vmulpd zmm6, zmm6, zmm7
    vbroadcastsd zmm7, [d_k7]
    vfmadd213pd zmm7, zmm5, [d_k7s]{1to8}
    vdivpd zmm6{k2}, zmm5, zmm7
    vbroadcastsd zmm7, [d_k7m]
    vfmadd213pd zmm6, zmm7, [d_sga]{1to8}
    vbroadcastsd zmm6{k3}, [d_eq0]
    vbroadcastsd zmm6{k7}, [d_eq0]
    vrcp14pd zmm7, zmm4
    vmulpd zmm7{k1}{z}, zmm2, zmm7
    vfmadd213pd zmm7, zmm6, [d_omg]{1to8}
    vmovapd zmm1, zmm11
    vfmadd213pd zmm1, zmm7, zmm11
    vpxorq zmm8, zmm1, [d_sgn]{1to8}
    vmovapd zmm9, zmm11
    vfnmadd213pd zmm9{k1}{z}, zmm7, zmm11
    vxorpd xmm10, xmm10, xmm10
    vcmppd k2, zmm4, zmm10, 0x1a
    vmovapd zmm9{k2}, zmm8
    vpxorq zmm10, zmm9, [d_sgn]{1to8}
    vpmovq2m k3, zmm0
    vblendmpd zmm0{k3}, zmm9, zmm8
    vblendmpd zmm1{k3}, zmm1, zmm10
    ret
.t2l:
    mov r2d, r6d
    shr r2d, 6
    imul r2, r2, MGM
    shr r2, 32
    imul r3d, r2d, W
    sub r6d, r3d
    shr r6d, 1
    mov r7, [r10 + T_SRC]
    imul r3, r2, 4*W
    lea r3, [r3 + r6*4]
    vmovd xmm0, [r7 + r3]
    vpinsrd xmm0, xmm0, [r7 + r3 + 2*W], 1
    vpmovzxwd xmm0, xmm0
    vcvtdq2pd ymm0, xmm0
    vmovapd [r10 + T_Y], ymm0
    lea r3d, [r6 - 1]
    vpbroadcastd ymm1, r3d
    vpaddd ymm1, ymm1, [d_iot]
    vpxor xmm2, xmm2, xmm2
    vpmaxsd ymm1, ymm1, ymm2
    vpminsd ymm1, ymm1, [d_wcl]{1to8}
    vmovd r3d, xmm1
    vpbroadcastd ymm2, r3d
    vpsubd ymm1, ymm1, ymm2
    vpmovdw xmm1, ymm1
    vpaddw xmm2, xmm1, [d_w8]
    vinserti128 ymm1, ymm1, xmm2, 1
    imul r8, r2, CST
    add r8, r7
    lea r8, [r8 + r3*2 + CB]
    mov r7, -CST
    test r2d, r2d
    cmovz r7, r2
    vmovdqu xmm3, [r8 + r7]
    vinserti128 ymm3, ymm3, [r8 + r7 + CRD], 1
    vpermw ymm3, ymm1, ymm3
    vpmovzxwd zmm3, ymm3
    vcvtdq2ps zmm3, zmm3
    vmovdqu xmm4, [r8]
    vinserti128 ymm4, ymm4, [r8 + CRD], 1
    vpermw ymm4, ymm1, ymm4
    vpmovzxwd zmm4, ymm4
    vcvtdq2ps zmm4, zmm4
    vmovdqu xmm5, [r8 + CST]
    vinserti128 ymm5, ymm5, [r8 + CST + CRD], 1
    vpermw ymm5, ymm1, ymm5
    vpmovzxwd zmm5, ymm5
    vcvtdq2ps zmm5, zmm5
    vmovdqu xmm6, [r8 + 2*CST]
    vinserti128 ymm6, ymm6, [r8 + 2*CST + CRD], 1
    vpermw ymm6, ymm1, ymm6
    vpmovzxwd zmm6, ymm6
    vcvtdq2ps zmm6, zmm6
    vaddps zmm7, zmm4, zmm5
    vaddps zmm15, zmm3, zmm6
    vmulps zmm15, zmm15, [c_h0625]{1to16}
    vfmsub132ps zmm7, zmm15, [c_h5625]{1to16}
    mov r6d, 0x0101
    kmovw k3, r6d
    valignd zmm12, zmm4, zmm4, 1
    valignd zmm13, zmm4, zmm4, 2
    valignd zmm14, zmm4, zmm4, 3
    vaddps zmm11, zmm12, zmm13
    vaddps zmm15, zmm4, zmm14
    vmulps zmm15, zmm15, [c_h0625]{1to16}
    vfmsub132ps zmm11, zmm15, [c_h5625]{1to16}
    vmovaps zmm4{k3}, zmm11
    valignd zmm12, zmm7, zmm7, 1
    valignd zmm13, zmm7, zmm7, 2
    valignd zmm14, zmm7, zmm7, 3
    vaddps zmm11, zmm12, zmm13
    vaddps zmm15, zmm7, zmm14
    vmulps zmm15, zmm15, [c_h0625]{1to16}
    vfmsub132ps zmm11, zmm15, [c_h5625]{1to16}
    vmovaps zmm7{k3}, zmm11
    vmovdqa32 zmm0, [d_pl2]
    vpermt2ps zmm4, zmm0, zmm7
    vcvtps2pd zmm4, ymm4
    vsubpd zmm4, zmm4, [d_512]{1to8}
    vmovapd [r10 + T_B], ymm4
    vextractf64x4 [r10 + T_R], zmm4, 1
    vpxorq xmm0, xmm0, xmm0
    vmovapd [r10 + T_LA], zmm0
    vmovapd [r10 + T_AA], zmm0
    mov r6d, 15
    kmovb k6, r6d
    xor r2d, r2d
    call .xmv
    vmovapd zmm0, [r10 + T_LA]
    vmulpd zmm0, zmm0, [d_q4]{1to8}
    vandpd zmm2, zmm0, [d_abs]{1to8}
    vmovapd zmm1, [r10 + T_AA]
    vfmsub132pd zmm1, zmm2, [d_q4]{1to8}
    vbroadcastsd zmm2, [d_rg2]
    vfmadd213pd zmm1, zmm2, [d_tab2]{1to8}
    kxnorb k7, k7, k7
    call .ivq
    vmovapd [r10 + T_LO], zmm0
    vmovapd [r10 + T_HI], zmm1
    vmovsd xmm0, [d_ylo]
    vmovsd xmm9, [d_emc0]
    vfmadd231sd xmm0, xmm9, [r10 + T_LO + 0]
    vmovsd xmm9, [d_emc1]
    vfmadd231sd xmm0, xmm9, [r10 + T_LO + 8]
    vmovsd xmm9, [d_emc2]
    vfmadd231sd xmm0, xmm9, [r10 + T_LO + 16]
    vmovsd xmm1, [d_yhi]
    vmovsd xmm9, [d_emc0]
    vfmadd231sd xmm1, xmm9, [r10 + T_HI + 0]
    vmovsd xmm9, [d_emc1]
    vfmadd231sd xmm1, xmm9, [r10 + T_HI + 8]
    vmovsd xmm9, [d_emc2]
    vfmadd231sd xmm1, xmm9, [r10 + T_HI + 16]
    vroundsd xmm0, xmm0, xmm0, 8
    vroundsd xmm1, xmm1, xmm1, 8
    vmovq r6, xmm0
    vmovq r3, xmm1
    cmp r6, r3
    jne .t3l
    vxorpd xmm9, xmm9, xmm9
    vmaxsd xmm0, xmm0, xmm9
    vminsd xmm0, xmm0, [d_1023]
    vcvttsd2si r2d, xmm0
    ret
.t2c:
    sub r6d, [dp + 16]
    shr r6d, 1
    mov r2d, r6d
    shr r2d, 4
    imul r2, r2, MGM
    shr r2, 32
    imul r3d, r2d, 16*M
    sub r6d, r3d
    xor r3d, r3d
    test r2d, r2d
    setnz r3b
    neg r3d
    kmovw k4, r3d
    mov r3d, 0x0202
    mov r8d, 0x0303
    test r6d, r6d
    cmovnz r3d, r8d
    kmovw k3, r3d
    xor r3d, r3d
    test r6d, r6d
    setz r3b
    neg r3d
    kmovw k5, r3d
    mov r7, [r10 + T_SRC]
    lea r8d, [r6*4 - 1]
    test r6d, r6d
    cmovz r8d, r6d
    imul r3, r2, 8*W
    add r3, r7
    lea r3, [r3 + r8*2]
    mov r8, -2*W
    test r2d, r2d
    cmovz r8, r2
    vmovq xmm0, [r3 + r8]
    vpinsrq xmm0, xmm0, [r3], 1
    vmovq xmm1, [r3 + 2*W]
    vpinsrq xmm1, xmm1, [r3 + 4*W], 1
    vinserti128 ymm0, ymm0, xmm1, 1
    vmovdqu16 ymm1, [d_yp]
    vpermw ymm0{k5}, ymm1, ymm0
    vpmovzxwd zmm0, ymm0
    vcvtdq2pd zmm1, ymm0
    vextracti64x4 ymm0, zmm0, 1
    vcvtdq2pd zmm0, ymm0
    vmovapd [r10 + T_Y], zmm1
    vmovapd [r10 + T_Y + 64], zmm0
    lea r3d, [r6*2 - 2]
    vpbroadcastd ymm1, r3d
    vpaddd ymm1, ymm1, [d_iot]
    vpxor xmm2, xmm2, xmm2
    vpmaxsd ymm1, ymm1, ymm2
    vpminsd ymm1, ymm1, [d_wcl]{1to8}
    vmovd r3d, xmm1
    vpbroadcastd ymm2, r3d
    vpsubd ymm1, ymm1, ymm2
    vpmovdw xmm1, ymm1
    vpaddw xmm2, xmm1, [d_w8]
    vinserti128 ymm1, ymm1, xmm2, 1
    imul r8, r2, 2*CST
    add r8, r7
    lea r8, [r8 + r3*2 + CB]
    mov r7, -2*CST
    mov r3, -CST
    test r2d, r2d
    cmovz r7, r2
    cmovz r3, r2
    vmovdqu xmm3, [r8 + r7]
    vinserti128 ymm3, ymm3, [r8 + r7 + CRD], 1
    vpermw ymm3, ymm1, ymm3
    vpmovzxwd zmm3, ymm3
    vcvtdq2ps zmm3, zmm3
    vmovdqu xmm4, [r8 + r3]
    vinserti128 ymm4, ymm4, [r8 + r3 + CRD], 1
    vpermw ymm4, ymm1, ymm4
    vpmovzxwd zmm4, ymm4
    vcvtdq2ps zmm4, zmm4
    vmovdqu xmm5, [r8]
    vinserti128 ymm5, ymm5, [r8 + CRD], 1
    vpermw ymm5, ymm1, ymm5
    vpmovzxwd zmm5, ymm5
    vcvtdq2ps zmm5, zmm5
    vmovdqu xmm6, [r8 + CST]
    vinserti128 ymm6, ymm6, [r8 + CST + CRD], 1
    vpermw ymm6, ymm1, ymm6
    vpmovzxwd zmm6, ymm6
    vcvtdq2ps zmm6, zmm6
    vmovdqu xmm7, [r8 + 2*CST]
    vinserti128 ymm7, ymm7, [r8 + 2*CST + CRD], 1
    vpermw ymm7, ymm1, ymm7
    vpmovzxwd zmm7, ymm7
    vcvtdq2ps zmm7, zmm7
    vaddps zmm8, zmm4, zmm5
    vaddps zmm15, zmm3, zmm6
    vmulps zmm15, zmm15, [c_h0625]{1to16}
    vfmsub132ps zmm8, zmm15, [c_h5625]{1to16}
    vblendmps zmm8{k4}, zmm3, zmm8
    vaddps zmm9, zmm5, zmm6
    vaddps zmm15, zmm4, zmm7
    vmulps zmm15, zmm15, [c_h0625]{1to16}
    vfmsub132ps zmm9, zmm15, [c_h5625]{1to16}
    valignd zmm12, zmm8, zmm8, 1
    valignd zmm13, zmm8, zmm8, 2
    valignd zmm14, zmm8, zmm8, 3
    vaddps zmm11, zmm12, zmm13
    vaddps zmm15, zmm8, zmm14
    vmulps zmm15, zmm15, [c_h0625]{1to16}
    vfmsub132ps zmm11, zmm15, [c_h5625]{1to16}
    vmovaps zmm8{k3}, zmm11
    valignd zmm12, zmm5, zmm5, 1
    valignd zmm13, zmm5, zmm5, 2
    valignd zmm14, zmm5, zmm5, 3
    vaddps zmm11, zmm12, zmm13
    vaddps zmm15, zmm5, zmm14
    vmulps zmm15, zmm15, [c_h0625]{1to16}
    vfmsub132ps zmm11, zmm15, [c_h5625]{1to16}
    vmovaps zmm5{k3}, zmm11
    valignd zmm12, zmm9, zmm9, 1
    valignd zmm13, zmm9, zmm9, 2
    valignd zmm14, zmm9, zmm9, 3
    vaddps zmm11, zmm12, zmm13
    vaddps zmm15, zmm9, zmm14
    vmulps zmm15, zmm15, [c_h0625]{1to16}
    vfmsub132ps zmm11, zmm15, [c_h5625]{1to16}
    vmovaps zmm9{k3}, zmm11
    valignd zmm12, zmm6, zmm6, 1
    valignd zmm13, zmm6, zmm6, 2
    valignd zmm14, zmm6, zmm6, 3
    vaddps zmm11, zmm12, zmm13
    vaddps zmm15, zmm6, zmm14
    vmulps zmm15, zmm15, [c_h0625]{1to16}
    vfmsub132ps zmm11, zmm15, [c_h5625]{1to16}
    vmovaps zmm6{k3}, zmm11
    vmovdqa32 zmm0, [d_pc2]
    vpermt2ps zmm8, zmm0, zmm5
    vpermt2ps zmm9, zmm0, zmm6
    vcvtps2pd zmm1, ymm8
    vextractf32x8 ymm2, zmm8, 1
    vcvtps2pd zmm2, ymm2
    vsubpd zmm1, zmm1, [d_512]{1to8}
    vsubpd zmm2, zmm2, [d_512]{1to8}
    vmovapd [r10 + T_B + 0], zmm1
    vmovapd [r10 + T_R + 0], zmm2
    vcvtps2pd zmm1, ymm9
    vextractf32x8 ymm2, zmm9, 1
    vcvtps2pd zmm2, ymm2
    vsubpd zmm1, zmm1, [d_512]{1to8}
    vsubpd zmm2, zmm2, [d_512]{1to8}
    vmovapd [r10 + T_B + 64], zmm1
    vmovapd [r10 + T_R + 64], zmm2
    vpxorq xmm0, xmm0, xmm0
    vmovapd [r10 + T_LA], zmm0
    vmovapd [r10 + T_AA], zmm0
    mov r6d, 255
    kmovb k6, r6d
    xor r2d, r2d
    call .xmv
    mov r2d, 64
    call .xmv
    vmovapd zmm0, [r10 + T_LA]
    vmulpd zmm0, zmm0, [d_q16]{1to8}
    vandpd zmm2, zmm0, [d_abs]{1to8}
    vmovapd zmm1, [r10 + T_AA]
    vfmsub132pd zmm1, zmm2, [d_q16]{1to8}
    vbroadcastsd zmm2, [d_rg2]
    vfmadd213pd zmm1, zmm2, [d_tab2]{1to8}
    kxnorb k7, k7, k7
    call .ivq
    vmovapd [r10 + T_LO], zmm0
    vmovapd [r10 + T_HI], zmm1
    vmovsd xmm0, [d_clo]
    vmovsd xmm9, [d_emc5]
    vfnmadd231sd xmm0, xmm9, [r10 + T_HI + 8]
    vmovsd xmm9, [d_emc4]
    vfnmadd231sd xmm0, xmm9, [r10 + T_HI + 0]
    vmovsd xmm9, [d_emc3]
    vfmadd231sd xmm0, xmm9, [r10 + T_LO + 16]
    vmovsd xmm1, [d_chi]
    vmovsd xmm9, [d_emc5]
    vfnmadd231sd xmm1, xmm9, [r10 + T_LO + 8]
    vmovsd xmm9, [d_emc4]
    vfnmadd231sd xmm1, xmm9, [r10 + T_LO + 0]
    vmovsd xmm9, [d_emc3]
    vfmadd231sd xmm1, xmm9, [r10 + T_HI + 16]
    vroundsd xmm0, xmm0, xmm0, 8
    vroundsd xmm1, xmm1, xmm1, 8
    vmovq r6, xmm0
    vmovq r3, xmm1
    cmp r6, r3
    jne .t3c
    vxorpd xmm9, xmm9, xmm9
    vmaxsd xmm0, xmm0, xmm9
    vminsd xmm0, xmm0, [d_1023]
    vmovsd xmm2, [d_clo]
    vmovsd xmm9, [d_emc8]
    vfnmadd231sd xmm2, xmm9, [r10 + T_HI + 16]
    vmovsd xmm9, [d_emc7]
    vfnmadd231sd xmm2, xmm9, [r10 + T_HI + 8]
    vmovsd xmm9, [d_emc6]
    vfmadd231sd xmm2, xmm9, [r10 + T_LO + 0]
    vmovsd xmm3, [d_chi]
    vmovsd xmm9, [d_emc8]
    vfnmadd231sd xmm3, xmm9, [r10 + T_LO + 16]
    vmovsd xmm9, [d_emc7]
    vfnmadd231sd xmm3, xmm9, [r10 + T_LO + 8]
    vmovsd xmm9, [d_emc6]
    vfmadd231sd xmm3, xmm9, [r10 + T_HI + 0]
    vroundsd xmm2, xmm2, xmm2, 8
    vroundsd xmm3, xmm3, xmm3, 8
    vmovq r6, xmm2
    vmovq r3, xmm3
    cmp r6, r3
    jne .t3c
    vxorpd xmm9, xmm9, xmm9
    vmaxsd xmm2, xmm2, xmm9
    vminsd xmm2, xmm2, [d_1023]
    vcvttsd2si r2d, xmm0
    vcvttsd2si r6d, xmm2
    shl r6d, 16
    or r2d, r6d
    ret
.xmv:
    vmovapd zmm20, [r10 + T_Y + r2]
    vbroadcastsd zmm21, [d_lzm0]
    vfmadd213pd zmm20, zmm21, [d_lzm5]{1to8}
    vmovapd zmm21, [r10 + T_R + r2]
    vmovapd zmm22, [r10 + T_B + r2]
    vmovapd zmm23, zmm20
    vfmadd231pd zmm23, zmm21, [d_lzm1]{1to8}
    vmovapd [r10 + T_XV], zmm23
    vmovapd zmm23, zmm20
    vfmadd231pd zmm23, zmm21, [d_lzm2]{1to8}
    vfmadd231pd zmm23, zmm22, [d_lzm3]{1to8}
    vmovapd [r10 + T_XV + 64], zmm23
    vfmadd231pd zmm20, zmm22, [d_lzm4]{1to8}
    vmovapd [r10 + T_XV + 128], zmm20
    xor r3d, r3d
.xmc:
    vmovapd zmm0, [r10 + T_XV + r3*8]
    vrangepd zmm1, zmm0, [d_one]{1to8}, 10
    vmaxpd zmm1, zmm1, [d_zz]{1to8}
    vpsrlq zmm2, zmm1, 52
    vptestnmq k1, zmm2, [d_i16]{1to8}
    vpsrlq zmm3, zmm1, 48
    vmovapd zmm4, [d_t2l]
    vpermt2pd zmm4, zmm2, [d_t2l + 64]
    vmulpd zmm4{k1}, zmm4, [d_t2k]{1to8}
    vmovapd zmm5, [d_w2x]
    vpermt2pd zmm5, zmm3, [d_w2x + 64]
    vmulpd zmm4, zmm4, zmm5
    vgetmantpd zmm6, zmm1, 4
    vmovapd zmm5, [d_rxl]
    vpermt2pd zmm5, zmm3, [d_rxl + 64]
    vfmsub213pd zmm6, zmm5, [d_laq]{1to8}
    vaddpd zmm7, zmm6, [d_q2x4]{1to8}
    vfmadd213pd zmm7, zmm6, [d_q2x3]{1to8}
    vfmadd213pd zmm7, zmm6, [d_q2x2]{1to8}
    vfmadd213pd zmm7, zmm6, [d_q2x1]{1to8}
    vfmadd213pd zmm7, zmm6, [d_q2x0]{1to8}
    vmulpd zmm6, zmm4, zmm6
    vsubpd zmm8, zmm4, [d_c13]{1to8}
    vfnmadd231pd zmm8, zmm6, zmm7
    vbroadcastsd zmm9, [d_c2c]
    vsubpd zmm9, zmm9, zmm8
    vdivpd zmm8, zmm8, zmm9
    vpsrlq zmm2, zmm8, 48
    vpsrlq zmm3, zmm8, 52
    vmovapd zmm4, [d_t1e]
    vpermt2pd zmm4, zmm3, [d_t1e + 64]
    vmovapd zmm5, [d_w1m]
    vpermt2pd zmm5, zmm2, [d_w1m + 64]
    vcmppd k2, zmm8, [d_flo]{1to8}, 0x1d
    vmulpd zmm4{k2}{z}, zmm4, zmm5
    vgetmantpd zmm6, zmm8, 4
    vmovapd zmm5, [d_rx]
    vpermt2pd zmm5, zmm2, [d_rx + 64]
    vfmsub213pd zmm6, zmm5, [d_one]{1to8}
    vaddpd zmm7, zmm6, [d_p1m4]{1to8}
    vfmadd213pd zmm7, zmm6, [d_p1m3]{1to8}
    vfmadd213pd zmm7, zmm6, [d_p1m2]{1to8}
    vfmadd213pd zmm7, zmm6, [d_p1m1]{1to8}
    vfmadd213pd zmm7, zmm6, [d_p1m0]{1to8}
    vrangepd zmm9, zmm0, [d_one]{1to8}, 11
    vbroadcastsd zmm10, [d_pk]
    vfmsub213pd zmm9, zmm10, zmm10
    vfmadd213pd zmm4, zmm7, zmm9
    vmovapd zmm5, zmm4
    vpternlogq zmm5, zmm0, [d_sgn]{1to8}, 0xd8
    vmovapd zmm4{k6}{z}, zmm4
    vmovapd zmm5{k6}{z}, zmm5
    vextractf64x4 ymm9, zmm4, 1
    vaddpd ymm9, ymm9, ymm4
    vextractf128 xmm10, ymm9, 1
    vaddpd xmm9, xmm9, xmm10
    vpermilpd xmm10, xmm9, 1
    vaddsd xmm9, xmm9, xmm10
    vaddsd xmm9, xmm9, [r10 + T_AA + r3]
    vmovsd [r10 + T_AA + r3], xmm9
    vextractf64x4 ymm9, zmm5, 1
    vaddpd ymm9, ymm9, ymm5
    vextractf128 xmm10, ymm9, 1
    vaddpd xmm9, xmm9, xmm10
    vpermilpd xmm10, xmm9, 1
    vaddsd xmm9, xmm9, xmm10
    vaddsd xmm9, xmm9, [r10 + T_LA + r3]
    vmovsd [r10 + T_LA + r3], xmm9
    add r3d, 8
    cmp r3d, 24
    jne .xmc
    ret
.t3l:
    xor r2d, r2d
    mov r3d, 32
    call .ecp
    xor r3d, r3d
.xb4:
    vmovapd zmm16, [r10 + T_EH + r3]
    vmovapd zmm17, [r10 + T_EL + r3]
    call .xeo
    vmovapd [r10 + T_EH + r3], zmm16
    vmovapd [r10 + T_EL + r3], zmm17
    sub r3d, -64
    cmp r3d, 128
    jne .xb4
    mov r3d, 32
    lea r6, [d_q4]
    call .acc
    vpxorq zmm18, zmm18, zmm18
    vbroadcastsd zmm19, [d_876]
    vmulpd zmm20, zmm19, zmm16
    vmovapd zmm21, zmm20
    vfmsub231pd zmm21, zmm19, zmm16
    vmulpd zmm22, zmm18, zmm16
    vfmadd231pd zmm22, zmm19, zmm17
    vaddpd zmm21, zmm21, zmm22
    vaddpd zmm22, zmm20, zmm21
    vsubpd zmm23, zmm22, zmm20
    vsubpd zmm23, zmm21, zmm23
    vbroadcastsd zmm19, [d_64]
    vaddpd zmm21, zmm22, zmm19
    vsubpd zmm20, zmm21, zmm22
    vsubpd zmm24, zmm21, zmm20
    vsubpd zmm24, zmm22, zmm24
    vsubpd zmm20, zmm19, zmm20
    vaddpd zmm24, zmm24, zmm20
    vaddpd zmm20, zmm23, zmm18
    vsubpd zmm25, zmm20, zmm23
    vsubpd zmm26, zmm20, zmm25
    vsubpd zmm26, zmm23, zmm26
    vsubpd zmm25, zmm18, zmm25
    vaddpd zmm26, zmm26, zmm25
    vaddpd zmm25, zmm24, zmm20
    vaddpd zmm20, zmm21, zmm25
    vsubpd zmm24, zmm20, zmm21
    vsubpd zmm24, zmm25, zmm24
    vaddpd zmm25, zmm24, zmm26
    vaddpd zmm26, zmm20, zmm25
    vsubpd zmm24, zmm26, zmm20
    vsubpd zmm24, zmm25, zmm24
    vmovapd zmm16, zmm26
    vmovapd zmm17, zmm24
    call .rn2
    test r6b, 1
    jz .x3l
    ret
.x3l:
    mov dword [r10 + T_O + 24], 4
    call .xr
    mov r6, [r10 + T_XS + 0]
    mov r3, r6
    sar r3, 2
    and r3d, 1
    lea r6, [r6 + r3 + 1]
    sar r6, 2
    xor r3d, r3d
    test r6, r6
    cmovs r6, r3
    mov r3d, 1023
    cmp r6, r3
    cmovg r6, r3
    mov r2d, r6d
    ret
.t3c:
    xor r2d, r2d
    mov r3d, 128
    call .ecp
    mov r2d, 64
    call .ecp
    xor r3d, r3d
.xb16:
    vmovapd zmm16, [r10 + T_EH + r3]
    vmovapd zmm17, [r10 + T_EL + r3]
    call .xeo
    vmovapd [r10 + T_EH + r3], zmm16
    vmovapd [r10 + T_EL + r3], zmm17
    sub r3d, -64
    cmp r3d, 384
    jne .xb16
    mov r3d, 128
    lea r6, [d_q16]
    call .acc
    vpxorq zmm0, zmm0, zmm0
    vpxorq zmm1, zmm16, [d_sgn]{1to8}
    vpxorq zmm2, zmm17, [d_sgn]{1to8}
    vbroadcastsd zmm3, [r10 + T_EC + 16]
    vbroadcastsd zmm4, [r10 + T_EC + 64 + 16]
    vaddpd zmm5, zmm3, zmm1
    vsubpd zmm6, zmm5, zmm3
    vsubpd zmm7, zmm5, zmm6
    vsubpd zmm7, zmm3, zmm7
    vsubpd zmm6, zmm1, zmm6
    vaddpd zmm7, zmm7, zmm6
    vaddpd zmm6, zmm4, zmm2
    vsubpd zmm8, zmm6, zmm4
    vsubpd zmm9, zmm6, zmm8
    vsubpd zmm9, zmm4, zmm9
    vsubpd zmm8, zmm2, zmm8
    vaddpd zmm9, zmm9, zmm8
    vaddpd zmm8, zmm7, zmm6
    vaddpd zmm6, zmm5, zmm8
    vsubpd zmm7, zmm6, zmm5
    vsubpd zmm7, zmm8, zmm7
    vaddpd zmm8, zmm7, zmm9
    vaddpd zmm9, zmm6, zmm8
    vsubpd zmm7, zmm9, zmm6
    vsubpd zmm7, zmm8, zmm7
    vbroadcastsd zmm4, [d_cbs]
    vbroadcastsd zmm3, [d_cbs + 8]
    vmulpd zmm8, zmm4, zmm9
    vmovapd zmm6, zmm8
    vfmsub231pd zmm6, zmm4, zmm9
    vmulpd zmm5, zmm3, zmm9
    vfmadd231pd zmm5, zmm4, zmm7
    vaddpd zmm6, zmm6, zmm5
    vaddpd zmm5, zmm8, zmm6
    vsubpd zmm10, zmm5, zmm8
    vsubpd zmm10, zmm6, zmm10
    vbroadcastsd zmm7, [d_512]
    vaddpd zmm9, zmm5, zmm7
    vsubpd zmm3, zmm9, zmm5
    vsubpd zmm4, zmm9, zmm3
    vsubpd zmm4, zmm5, zmm4
    vsubpd zmm3, zmm7, zmm3
    vaddpd zmm4, zmm4, zmm3
    vaddpd zmm3, zmm10, zmm0
    vsubpd zmm6, zmm3, zmm10
    vsubpd zmm8, zmm3, zmm6
    vsubpd zmm8, zmm10, zmm8
    vsubpd zmm6, zmm0, zmm6
    vaddpd zmm8, zmm8, zmm6
    vaddpd zmm6, zmm4, zmm3
    vaddpd zmm3, zmm9, zmm6
    vsubpd zmm4, zmm3, zmm9
    vsubpd zmm4, zmm6, zmm4
    vaddpd zmm6, zmm4, zmm8
    vaddpd zmm8, zmm3, zmm6
    vsubpd zmm4, zmm8, zmm3
    vsubpd zmm4, zmm6, zmm4
    vmovapd zmm16, zmm8
    vmovapd zmm17, zmm4
    call .rn2
    mov [r10 + T_O + 8], r2d
    mov [r10 + T_O + 16], r6d
    vbroadcastsd zmm4, [r10 + T_EC + 0]
    vbroadcastsd zmm8, [r10 + T_EC + 64 + 0]
    vaddpd zmm10, zmm4, zmm1
    vsubpd zmm5, zmm10, zmm4
    vsubpd zmm7, zmm10, zmm5
    vsubpd zmm7, zmm4, zmm7
    vsubpd zmm5, zmm1, zmm5
    vaddpd zmm7, zmm7, zmm5
    vaddpd zmm5, zmm8, zmm2
    vsubpd zmm6, zmm5, zmm8
    vsubpd zmm3, zmm5, zmm6
    vsubpd zmm3, zmm8, zmm3
    vsubpd zmm6, zmm2, zmm6
    vaddpd zmm3, zmm3, zmm6
    vaddpd zmm6, zmm7, zmm5
    vaddpd zmm5, zmm10, zmm6
    vsubpd zmm7, zmm5, zmm10
    vsubpd zmm7, zmm6, zmm7
    vaddpd zmm6, zmm7, zmm3
    vaddpd zmm3, zmm5, zmm6
    vsubpd zmm7, zmm3, zmm5
    vsubpd zmm7, zmm6, zmm7
    vbroadcastsd zmm8, [d_crs]
    vbroadcastsd zmm4, [d_crs + 8]
    vmulpd zmm6, zmm8, zmm3
    vmovapd zmm5, zmm6
    vfmsub231pd zmm5, zmm8, zmm3
    vmulpd zmm10, zmm4, zmm3
    vfmadd231pd zmm10, zmm8, zmm7
    vaddpd zmm5, zmm5, zmm10
    vaddpd zmm10, zmm6, zmm5
    vsubpd zmm9, zmm10, zmm6
    vsubpd zmm9, zmm5, zmm9
    vbroadcastsd zmm7, [d_512]
    vaddpd zmm3, zmm10, zmm7
    vsubpd zmm4, zmm3, zmm10
    vsubpd zmm8, zmm3, zmm4
    vsubpd zmm8, zmm10, zmm8
    vsubpd zmm4, zmm7, zmm4
    vaddpd zmm8, zmm8, zmm4
    vaddpd zmm4, zmm9, zmm0
    vsubpd zmm5, zmm4, zmm9
    vsubpd zmm6, zmm4, zmm5
    vsubpd zmm6, zmm9, zmm6
    vsubpd zmm5, zmm0, zmm5
    vaddpd zmm6, zmm6, zmm5
    vaddpd zmm5, zmm8, zmm4
    vaddpd zmm4, zmm3, zmm5
    vsubpd zmm8, zmm4, zmm3
    vsubpd zmm8, zmm5, zmm8
    vaddpd zmm5, zmm8, zmm6
    vaddpd zmm6, zmm4, zmm5
    vsubpd zmm8, zmm6, zmm4
    vsubpd zmm8, zmm5, zmm8
    vmovapd zmm16, zmm6
    vmovapd zmm17, zmm8
    call .rn2
    mov [r10 + T_O + 12], r2d
    mov [r10 + T_O + 20], r6d
    mov r6d, [r10 + T_O + 16]
    and r6d, [r10 + T_O + 20]
    test r6b, 1
    jnz .xcm
    mov dword [r10 + T_O + 24], 16
    call .xr
    test byte [r10 + T_O + 16], 1
    jnz .xc0
    mov r6, [r10 + T_XS + 8]
    mov r3, r6
    sar r3, 24
    and r3d, 1
    lea r6, [r6 + r3 + 8388607]
    sar r6, 24
    xor r3d, r3d
    test r6, r6
    cmovs r6, r3
    mov r3d, 1023
    cmp r6, r3
    cmovg r6, r3
    mov dword [r10 + T_O + 8], r6d
.xc0:
    test byte [r10 + T_O + 20], 1
    jnz .xc1
    mov r6, [r10 + T_XS + 16]
    mov r3, r6
    sar r3, 24
    and r3d, 1
    lea r6, [r6 + r3 + 8388607]
    sar r6, 24
    xor r3d, r3d
    test r6, r6
    cmovs r6, r3
    mov r3d, 1023
    cmp r6, r3
    cmovg r6, r3
    mov dword [r10 + T_O + 12], r6d
.xc1:
.xcm:
    mov r2d, [r10 + T_O + 8]
    mov r3d, [r10 + T_O + 12]
    shl r3d, 16
    or r2d, r3d
    ret
.ecp:
    lea r7, [r10 + r2]
    vpxorq zmm0, zmm0, zmm0
    vmovapd zmm1, [r7 + T_Y]
    vbroadcastsd zmm2, [d_ysc]
    vbroadcastsd zmm3, [d_ysc + 8]
    vmulpd zmm4, zmm1, zmm2
    vmovapd zmm5, zmm4
    vfmsub231pd zmm5, zmm1, zmm2
    vmulpd zmm6, zmm0, zmm2
    vfmadd231pd zmm6, zmm1, zmm3
    vaddpd zmm5, zmm5, zmm6
    vaddpd zmm6, zmm4, zmm5
    vsubpd zmm7, zmm6, zmm4
    vsubpd zmm7, zmm5, zmm7
    vbroadcastsd zmm3, [d_yof]
    vbroadcastsd zmm2, [d_yof + 8]
    vaddpd zmm1, zmm6, zmm3
    vsubpd zmm5, zmm1, zmm6
    vsubpd zmm4, zmm1, zmm5
    vsubpd zmm4, zmm6, zmm4
    vsubpd zmm5, zmm3, zmm5
    vaddpd zmm4, zmm4, zmm5
    vaddpd zmm5, zmm7, zmm2
    vsubpd zmm8, zmm5, zmm7
    vsubpd zmm9, zmm5, zmm8
    vsubpd zmm9, zmm7, zmm9
    vsubpd zmm8, zmm2, zmm8
    vaddpd zmm9, zmm9, zmm8
    vaddpd zmm8, zmm4, zmm5
    vaddpd zmm5, zmm1, zmm8
    vsubpd zmm4, zmm5, zmm1
    vsubpd zmm4, zmm8, zmm4
    vaddpd zmm8, zmm4, zmm9
    vaddpd zmm9, zmm5, zmm8
    vsubpd zmm4, zmm9, zmm5
    vsubpd zmm4, zmm8, zmm4
    vmovapd zmm2, [r7 + T_R]
    vmovapd zmm3, [r7 + T_B]
    vbroadcastsd zmm7, [d_rcr]
    vbroadcastsd zmm6, [d_rcr + 8]
    vmulpd zmm8, zmm7, zmm2
    vmovapd zmm5, zmm8
    vfmsub231pd zmm5, zmm7, zmm2
    vmulpd zmm1, zmm6, zmm2
    vfmadd231pd zmm1, zmm7, zmm0
    vaddpd zmm5, zmm5, zmm1
    vaddpd zmm1, zmm8, zmm5
    vsubpd zmm10, zmm1, zmm8
    vsubpd zmm10, zmm5, zmm10
    vaddpd zmm6, zmm9, zmm1
    vsubpd zmm7, zmm6, zmm9
    vsubpd zmm5, zmm6, zmm7
    vsubpd zmm5, zmm9, zmm5
    vsubpd zmm7, zmm1, zmm7
    vaddpd zmm5, zmm5, zmm7
    vaddpd zmm7, zmm4, zmm10
    vsubpd zmm8, zmm7, zmm4
    vsubpd zmm11, zmm7, zmm8
    vsubpd zmm11, zmm4, zmm11
    vsubpd zmm8, zmm10, zmm8
    vaddpd zmm11, zmm11, zmm8
    vaddpd zmm8, zmm5, zmm7
    vaddpd zmm7, zmm6, zmm8
    vsubpd zmm5, zmm7, zmm6
    vsubpd zmm5, zmm8, zmm5
    vaddpd zmm8, zmm5, zmm11
    vaddpd zmm11, zmm7, zmm8
    vsubpd zmm5, zmm11, zmm7
    vsubpd zmm5, zmm8, zmm5
    vmovupd [r7 + T_EH], zmm11
    vmovupd [r7 + T_EL], zmm5
    vbroadcastsd zmm10, [d_gcr]
    vbroadcastsd zmm1, [d_gcr + 8]
    vmulpd zmm5, zmm10, zmm2
    vmovapd zmm11, zmm5
    vfmsub231pd zmm11, zmm10, zmm2
    vmulpd zmm8, zmm1, zmm2
    vfmadd231pd zmm8, zmm10, zmm0
    vaddpd zmm11, zmm11, zmm8
    vaddpd zmm8, zmm5, zmm11
    vsubpd zmm7, zmm8, zmm5
    vsubpd zmm7, zmm11, zmm7
    vaddpd zmm1, zmm9, zmm8
    vsubpd zmm10, zmm1, zmm9
    vsubpd zmm11, zmm1, zmm10
    vsubpd zmm11, zmm9, zmm11
    vsubpd zmm10, zmm8, zmm10
    vaddpd zmm11, zmm11, zmm10
    vaddpd zmm10, zmm4, zmm7
    vsubpd zmm5, zmm10, zmm4
    vsubpd zmm6, zmm10, zmm5
    vsubpd zmm6, zmm4, zmm6
    vsubpd zmm5, zmm7, zmm5
    vaddpd zmm6, zmm6, zmm5
    vaddpd zmm5, zmm11, zmm10
    vaddpd zmm10, zmm1, zmm5
    vsubpd zmm11, zmm10, zmm1
    vsubpd zmm11, zmm5, zmm11
    vaddpd zmm5, zmm11, zmm6
    vaddpd zmm6, zmm10, zmm5
    vsubpd zmm11, zmm6, zmm10
    vsubpd zmm11, zmm5, zmm11
    vbroadcastsd zmm7, [d_gcb]
    vbroadcastsd zmm8, [d_gcb + 8]
    vmulpd zmm5, zmm7, zmm3
    vmovapd zmm10, zmm5
    vfmsub231pd zmm10, zmm7, zmm3
    vmulpd zmm1, zmm8, zmm3
    vfmadd231pd zmm1, zmm7, zmm0
    vaddpd zmm10, zmm10, zmm1
    vaddpd zmm1, zmm5, zmm10
    vsubpd zmm12, zmm1, zmm5
    vsubpd zmm12, zmm10, zmm12
    vaddpd zmm8, zmm6, zmm1
    vsubpd zmm7, zmm8, zmm6
    vsubpd zmm10, zmm8, zmm7
    vsubpd zmm10, zmm6, zmm10
    vsubpd zmm7, zmm1, zmm7
    vaddpd zmm10, zmm10, zmm7
    vaddpd zmm7, zmm11, zmm12
    vsubpd zmm5, zmm7, zmm11
    vsubpd zmm13, zmm7, zmm5
    vsubpd zmm13, zmm11, zmm13
    vsubpd zmm5, zmm12, zmm5
    vaddpd zmm13, zmm13, zmm5
    vaddpd zmm5, zmm10, zmm7
    vaddpd zmm7, zmm8, zmm5
    vsubpd zmm10, zmm7, zmm8
    vsubpd zmm10, zmm5, zmm10
    vaddpd zmm5, zmm10, zmm13
    vaddpd zmm13, zmm7, zmm5
    vsubpd zmm10, zmm13, zmm7
    vsubpd zmm10, zmm5, zmm10
    vmovupd [r7 + r3 + T_EH], zmm13
    vmovupd [r7 + r3 + T_EL], zmm10
    vbroadcastsd zmm11, [d_bcb]
    vbroadcastsd zmm6, [d_bcb + 8]
    vmulpd zmm12, zmm11, zmm3
    vmovapd zmm1, zmm12
    vfmsub231pd zmm1, zmm11, zmm3
    vmulpd zmm10, zmm6, zmm3
    vfmadd231pd zmm10, zmm11, zmm0
    vaddpd zmm1, zmm1, zmm10
    vaddpd zmm10, zmm12, zmm1
    vsubpd zmm13, zmm10, zmm12
    vsubpd zmm13, zmm1, zmm13
    vaddpd zmm6, zmm9, zmm10
    vsubpd zmm11, zmm6, zmm9
    vsubpd zmm1, zmm6, zmm11
    vsubpd zmm1, zmm9, zmm1
    vsubpd zmm11, zmm10, zmm11
    vaddpd zmm1, zmm1, zmm11
    vaddpd zmm11, zmm4, zmm13
    vsubpd zmm12, zmm11, zmm4
    vsubpd zmm5, zmm11, zmm12
    vsubpd zmm5, zmm4, zmm5
    vsubpd zmm12, zmm13, zmm12
    vaddpd zmm5, zmm5, zmm12
    vaddpd zmm12, zmm1, zmm11
    vaddpd zmm11, zmm6, zmm12
    vsubpd zmm1, zmm11, zmm6
    vsubpd zmm1, zmm12, zmm1
    vaddpd zmm12, zmm1, zmm5
    vaddpd zmm5, zmm11, zmm12
    vsubpd zmm1, zmm5, zmm11
    vsubpd zmm1, zmm12, zmm1
    vmovupd [r7 + r3*2 + T_EH], zmm5
    vmovupd [r7 + r3*2 + T_EL], zmm1
    ret
.acc:
    vxorpd xmm0, xmm0, xmm0
    vxorpd xmm1, xmm1, xmm1
    vxorpd xmm2, xmm2, xmm2
    vxorpd xmm3, xmm3, xmm3
    vxorpd xmm4, xmm4, xmm4
    vxorpd xmm5, xmm5, xmm5
    mov r7, r10
    lea r8, [r10 + r3]
.acl:
    vmovsd xmm6, [r7 + T_EH]
    vmovsd xmm7, [r7 + T_EL]
    vaddpd xmm8, xmm0, xmm6
    vsubpd xmm9, xmm8, xmm0
    vsubpd xmm10, xmm8, xmm9
    vsubpd xmm10, xmm0, xmm10
    vsubpd xmm9, xmm6, xmm9
    vaddpd xmm10, xmm10, xmm9
    vaddpd xmm9, xmm1, xmm7
    vsubpd xmm11, xmm9, xmm1
    vsubpd xmm12, xmm9, xmm11
    vsubpd xmm12, xmm1, xmm12
    vsubpd xmm11, xmm7, xmm11
    vaddpd xmm12, xmm12, xmm11
    vaddpd xmm11, xmm10, xmm9
    vaddpd xmm9, xmm8, xmm11
    vsubpd xmm10, xmm9, xmm8
    vsubpd xmm10, xmm11, xmm10
    vaddpd xmm11, xmm10, xmm12
    vaddpd xmm12, xmm9, xmm11
    vsubpd xmm10, xmm12, xmm9
    vsubpd xmm10, xmm11, xmm10
    vmovapd xmm0, xmm12
    vmovapd xmm1, xmm10
    vmovsd xmm10, [r7 + r3 + T_EH]
    vmovsd xmm12, [r7 + r3 + T_EL]
    vaddpd xmm7, xmm2, xmm10
    vsubpd xmm6, xmm7, xmm2
    vsubpd xmm11, xmm7, xmm6
    vsubpd xmm11, xmm2, xmm11
    vsubpd xmm6, xmm10, xmm6
    vaddpd xmm11, xmm11, xmm6
    vaddpd xmm6, xmm3, xmm12
    vsubpd xmm9, xmm6, xmm3
    vsubpd xmm8, xmm6, xmm9
    vsubpd xmm8, xmm3, xmm8
    vsubpd xmm9, xmm12, xmm9
    vaddpd xmm8, xmm8, xmm9
    vaddpd xmm9, xmm11, xmm6
    vaddpd xmm6, xmm7, xmm9
    vsubpd xmm11, xmm6, xmm7
    vsubpd xmm11, xmm9, xmm11
    vaddpd xmm9, xmm11, xmm8
    vaddpd xmm8, xmm6, xmm9
    vsubpd xmm11, xmm8, xmm6
    vsubpd xmm11, xmm9, xmm11
    vmovapd xmm2, xmm8
    vmovapd xmm3, xmm11
    vmovsd xmm11, [r7 + r3*2 + T_EH]
    vmovsd xmm8, [r7 + r3*2 + T_EL]
    vaddpd xmm12, xmm4, xmm11
    vsubpd xmm10, xmm12, xmm4
    vsubpd xmm9, xmm12, xmm10
    vsubpd xmm9, xmm4, xmm9
    vsubpd xmm10, xmm11, xmm10
    vaddpd xmm9, xmm9, xmm10
    vaddpd xmm10, xmm5, xmm8
    vsubpd xmm6, xmm10, xmm5
    vsubpd xmm7, xmm10, xmm6
    vsubpd xmm7, xmm5, xmm7
    vsubpd xmm6, xmm8, xmm6
    vaddpd xmm7, xmm7, xmm6
    vaddpd xmm6, xmm9, xmm10
    vaddpd xmm10, xmm12, xmm6
    vsubpd xmm9, xmm10, xmm12
    vsubpd xmm9, xmm6, xmm9
    vaddpd xmm6, xmm9, xmm7
    vaddpd xmm7, xmm10, xmm6
    vsubpd xmm9, xmm7, xmm10
    vsubpd xmm9, xmm6, xmm9
    vmovapd xmm4, xmm7
    vmovapd xmm5, xmm9
    add r7, 8
    cmp r7, r8
    jne .acl
    vmovsd [r10 + T_AC + 0], xmm0
    vmovsd [r10 + T_AC + 64 + 0], xmm1
    vmovsd [r10 + T_AC + 8], xmm2
    vmovsd [r10 + T_AC + 64 + 8], xmm3
    vmovsd [r10 + T_AC + 16], xmm4
    vmovsd [r10 + T_AC + 64 + 16], xmm5
    vpxorq zmm0, zmm0, zmm0
    vmovapd zmm1, [r10 + T_AC]
    vmovapd zmm2, [r10 + T_AC + 64]
    vbroadcastsd zmm3, [r6]
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
    vmovapd [r10 + T_EC], zmm16
    vmovapd [r10 + T_EC + 64], zmm17
    vbroadcastsd zmm0, [r10 + T_EC + 0]
    vbroadcastsd zmm1, [r10 + T_EC + 64 + 0]
    vbroadcastsd zmm2, [r10 + T_EC + 8]
    vbroadcastsd zmm3, [r10 + T_EC + 64 + 8]
    vbroadcastsd zmm4, [r10 + T_EC + 16]
    vbroadcastsd zmm5, [r10 + T_EC + 64 + 16]
    vbroadcastsd zmm6, [d_kr]
    vbroadcastsd zmm7, [d_kr + 8]
    vmulpd zmm8, zmm6, zmm0
    vmovapd zmm9, zmm8
    vfmsub231pd zmm9, zmm6, zmm0
    vmulpd zmm10, zmm7, zmm0
    vfmadd231pd zmm10, zmm6, zmm1
    vaddpd zmm9, zmm9, zmm10
    vaddpd zmm10, zmm8, zmm9
    vsubpd zmm11, zmm10, zmm8
    vsubpd zmm11, zmm9, zmm11
    vbroadcastsd zmm7, [d_kg]
    vbroadcastsd zmm6, [d_kg + 8]
    vmulpd zmm9, zmm7, zmm2
    vmovapd zmm8, zmm9
    vfmsub231pd zmm8, zmm7, zmm2
    vmulpd zmm12, zmm6, zmm2
    vfmadd231pd zmm12, zmm7, zmm3
    vaddpd zmm8, zmm8, zmm12
    vaddpd zmm12, zmm9, zmm8
    vsubpd zmm13, zmm12, zmm9
    vsubpd zmm13, zmm8, zmm13
    vaddpd zmm6, zmm10, zmm12
    vsubpd zmm7, zmm6, zmm10
    vsubpd zmm8, zmm6, zmm7
    vsubpd zmm8, zmm10, zmm8
    vsubpd zmm7, zmm12, zmm7
    vaddpd zmm8, zmm8, zmm7
    vaddpd zmm7, zmm11, zmm13
    vsubpd zmm9, zmm7, zmm11
    vsubpd zmm14, zmm7, zmm9
    vsubpd zmm14, zmm11, zmm14
    vsubpd zmm9, zmm13, zmm9
    vaddpd zmm14, zmm14, zmm9
    vaddpd zmm9, zmm8, zmm7
    vaddpd zmm7, zmm6, zmm9
    vsubpd zmm8, zmm7, zmm6
    vsubpd zmm8, zmm9, zmm8
    vaddpd zmm9, zmm8, zmm14
    vaddpd zmm14, zmm7, zmm9
    vsubpd zmm8, zmm14, zmm7
    vsubpd zmm8, zmm9, zmm8
    vbroadcastsd zmm13, [d_kb]
    vbroadcastsd zmm12, [d_kb + 8]
    vmulpd zmm11, zmm13, zmm4
    vmovapd zmm10, zmm11
    vfmsub231pd zmm10, zmm13, zmm4
    vmulpd zmm9, zmm12, zmm4
    vfmadd231pd zmm9, zmm13, zmm5
    vaddpd zmm10, zmm10, zmm9
    vaddpd zmm9, zmm11, zmm10
    vsubpd zmm7, zmm9, zmm11
    vsubpd zmm7, zmm10, zmm7
    vaddpd zmm12, zmm14, zmm9
    vsubpd zmm13, zmm12, zmm14
    vsubpd zmm10, zmm12, zmm13
    vsubpd zmm10, zmm14, zmm10
    vsubpd zmm13, zmm9, zmm13
    vaddpd zmm10, zmm10, zmm13
    vaddpd zmm13, zmm8, zmm7
    vsubpd zmm11, zmm13, zmm8
    vsubpd zmm6, zmm13, zmm11
    vsubpd zmm6, zmm8, zmm6
    vsubpd zmm11, zmm7, zmm11
    vaddpd zmm6, zmm6, zmm11
    vaddpd zmm11, zmm10, zmm13
    vaddpd zmm13, zmm12, zmm11
    vsubpd zmm10, zmm13, zmm12
    vsubpd zmm10, zmm11, zmm10
    vaddpd zmm11, zmm10, zmm6
    vaddpd zmm6, zmm13, zmm11
    vsubpd zmm10, zmm6, zmm13
    vsubpd zmm10, zmm11, zmm10
    vmovapd zmm16, zmm6
    vmovapd zmm17, zmm10
    ret
.rn2:
    vpxorq zmm18, zmm18, zmm18
    vrndscalepd zmm19, zmm16, 8
    vsubpd zmm20, zmm16, zmm19
    vaddpd zmm21, zmm20, zmm17
    vsubpd zmm22, zmm21, zmm20
    vsubpd zmm23, zmm21, zmm22
    vsubpd zmm23, zmm20, zmm23
    vsubpd zmm22, zmm17, zmm22
    vaddpd zmm23, zmm23, zmm22
    vaddpd zmm22, zmm18, zmm18
    vsubpd zmm24, zmm22, zmm18
    vsubpd zmm25, zmm22, zmm24
    vsubpd zmm25, zmm18, zmm25
    vsubpd zmm24, zmm18, zmm24
    vaddpd zmm25, zmm25, zmm24
    vaddpd zmm24, zmm23, zmm22
    vaddpd zmm22, zmm21, zmm24
    vsubpd zmm23, zmm22, zmm21
    vsubpd zmm23, zmm24, zmm23
    vaddpd zmm24, zmm23, zmm25
    vaddpd zmm25, zmm22, zmm24
    vcmppd k1, zmm25, [d_half]{1to8}, 0x1e
    vaddpd zmm19{k1}, zmm19, [d_one]{1to8}
    vcmppd k1, zmm25, [d_mhalf]{1to8}, 0x11
    vsubpd zmm19{k1}, zmm19, [d_one]{1to8}
    vandpd zmm25, zmm25, [d_abs]{1to8}
    vsubpd zmm25, zmm25, [d_half]{1to8}
    vandpd zmm25, zmm25, [d_abs]{1to8}
    vcmppd k2, zmm25, [d_epd]{1to8}, 0x1e
    vmaxpd zmm19, zmm19, zmm18
    vminpd zmm19, zmm19, [d_1023]{1to8}
    vcvttpd2dq ymm19, zmm19
    vmovd r2d, xmm19
    kmovb r6d, k2
    ret
.xr:
    vpxorq xmm0, xmm0, xmm0
    vmovdqa64 [r10 + T_ZS], zmm0
    vmovdqa64 [r10 + T_XS], zmm0
    xor r7d, r7d
.xrl:
    vcvttsd2si r8, [r10 + T_Y + r7*8]
    add [r10 + T_XS], r8
    vmovsd xmm0, [r10 + T_B + r7*8]
    vmulsd xmm0, xmm0, [d_2p20]
    vcvttsd2si r14, xmm0
    lea r6, [r14 + 0x20000000]
    add [r10 + T_XS + 8], r6
    vmovsd xmm0, [r10 + T_R + r7*8]
    vmulsd xmm0, xmm0, [d_2p20]
    vcvttsd2si r11, xmm0
    lea r6, [r11 + 0x20000000]
    add [r10 + T_XS + 16], r6
    imul r14, [d_xys]
    imul r11, [d_xys]
    sub r8, [d_xyb]
    imul r8, [d_xec]
    imul r6, r11, 14746
    add r6, r8
    mov r2, [d_xdr]
    cmp r6, r2
    setge r3b
    neg r2
    cmp r6, r2
    setle r2b
    sub r3b, r2b
    movsx r3, r3b
    add [r10 + T_ZS + 0], r3
    imul r6, r14, 18814
    add r6, r8
    mov r2, [d_xdr]
    cmp r6, r2
    setge r3b
    neg r2
    cmp r6, r2
    setle r2b
    sub r3b, r2b
    movsx r3, r3b
    add [r10 + T_ZS + 16], r3
    mov r6, r8
    mov r3, 6780
    imul r3
    mov r8, r6
    mov r12, r2
    mov r6, r11
    mov r3, 38737742
    imul r3
    sub r8, r6
    sbb r12, r2
    mov r6, r14
    mov r3, 11156702
    imul r3
    sub r8, r6
    sbb r12, r2
    mov r6, [d_xdg]
    mov r2, [d_xdg + 8]
    mov r14, r8
    mov r11, r12
    sub r14, r6
    sbb r11, r2
    setns r3b
    add r8, r6
    adc r12, r2
    sets r2b
    or r8, r12
    setz r6b
    or r2b, r6b
    sub r3b, r2b
    movsx r3, r3b
    add [r10 + T_ZS + 8], r3
    inc r7d
    cmp r7d, [r10 + T_O + 24]
    jne .xrl
    mov r6, [r10 + T_ZS + 0]
    mov r3, r6
    neg r3
    cmovl r3, r6
    cmp r3d, [r10 + T_O + 24]
    jne .xud
    mov r6, [r10 + T_ZS + 8]
    mov r3, r6
    neg r3
    cmovl r3, r6
    cmp r3d, [r10 + T_O + 24]
    jne .xud
    mov r6, [r10 + T_ZS + 16]
    mov r3, r6
    neg r3
    cmovl r3, r6
    cmp r3d, [r10 + T_O + 24]
    jne .xud
    ret
.xud:
    ud2
.lgv:
    vpaddq zmm18, zmm16, [d_lmo]{1to8}
    vpcmpuq k1, zmm18, [d_lhl]{1to8}, 1
    vpaddq zmm19, zmm16, [d_lof]{1to8}
    vpsrlq zmm20, zmm19, 44
    vpandq zmm20, zmm20, [d_lfe]{1to8}
    vpsraq zmm21, zmm19, 52
    vpandq zmm19, zmm19, [d_lhm]{1to8}
    vpsubq zmm19, zmm16, zmm19
    vcvtqq2pd zmm21, zmm21
    lea r6, [d_lgt]
    kxnorb k2, k2, k2
    vgatherqpd zmm22{k2}, [r6 + zmm20*8]
    kxnorb k3, k3, k3
    vgatherqpd zmm23{k3}, [r6 + zmm20*8 + 8]
    vbroadcastsd zmm24, [d_lg0]
    vfmadd213pd zmm24, zmm21, zmm23
    vbroadcastsd zmm25, [d_mone]
    vfmadd231pd zmm25, zmm19, zmm22
    vbroadcastsd zmm26, [d_lg4]
    vfmadd213pd zmm26, zmm25, [d_lg3]{1to8}
    vaddpd zmm27, zmm25, zmm24
    vmulpd zmm28, zmm25, zmm25
    vsubpd zmm24, zmm24, zmm27
    vaddpd zmm24, zmm24, zmm25
    vfmadd132pd zmm21, zmm24, [d_lg1]{1to8}
    vmulpd zmm29, zmm25, zmm28
    vbroadcastsd zmm30, [d_lg6]
    vfmadd213pd zmm30, zmm25, [d_lg5]{1to8}
    vfmadd231pd zmm21, zmm28, [d_lg2]{1to8}
    vfmadd213pd zmm30, zmm28, zmm26
    vfmadd231pd zmm21, zmm29, zmm30
    vaddpd zmm21, zmm21, zmm27
    vsubpd zmm18, zmm16, [d_one]{1to8}
    vbroadcastsd zmm19, [d_lg9]
    vfmadd213pd zmm19, zmm18, [d_lg8]{1to8}
    vbroadcastsd zmm20, [d_lg15]
    vfmadd213pd zmm20, zmm18, [d_lg14]{1to8}
    vbroadcastsd zmm22, [d_lg12]
    vfmadd213pd zmm22, zmm18, [d_lg11]{1to8}
    vmulpd zmm23, zmm18, zmm18
    vfmadd231pd zmm19, zmm23, [d_lg10]{1to8}
    vfmadd231pd zmm22, zmm23, [d_lg13]{1to8}
    vmulpd zmm24, zmm18, zmm23
    vfmadd231pd zmm20, zmm23, [d_lg16]{1to8}
    vfmadd231pd zmm20, zmm24, [d_lg17]{1to8}
    vfmadd213pd zmm20, zmm24, zmm22
    vfmadd213pd zmm20, zmm24, zmm19
    vmovapd zmm25, zmm18
    vfmadd132pd zmm25, zmm18, [d_2p27]{1to8}
    vfnmadd231pd zmm25, zmm18, [d_2p27]{1to8}
    vmulpd zmm26, zmm25, zmm25
    vsubpd zmm28, zmm18, zmm25
    vmovapd zmm29, zmm18
    vfmadd231pd zmm29, zmm26, [d_lg7]{1to8}
    vsubpd zmm30, zmm18, zmm29
    vaddpd zmm31, zmm18, zmm25
    vfmadd132pd zmm26, zmm30, [d_lg7]{1to8}
    vmulpd zmm28, zmm28, [d_lg7]{1to8}
    vfmadd213pd zmm28, zmm31, zmm26
    vfmadd213pd zmm20, zmm24, zmm28
    vaddpd zmm29, zmm29, zmm20
    vblendmpd zmm16{k1}, zmm21, zmm29
    ret
.dexp:
    vdivpd zmm18, zmm16, [d_ln2]{1to8}
    vbroadcastsd zmm19, [d_hm]
    vpternlogq zmm19, zmm18, [d_sgn]{1to8}, 0xf8
    vaddpd zmm19, zmm19, zmm18
    vrndscalepd zmm19, zmm19, 11
    vpxorq zmm18, zmm18, zmm18
    vbroadcastsd zmm20, [d_ln2]
    vbroadcastsd zmm21, [d_ln2 + 8]
    vmulpd zmm22, zmm20, zmm19
    vmovapd zmm23, zmm22
    vfmsub231pd zmm23, zmm20, zmm19
    vmulpd zmm24, zmm21, zmm19
    vfmadd231pd zmm24, zmm20, zmm18
    vaddpd zmm23, zmm23, zmm24
    vaddpd zmm24, zmm22, zmm23
    vsubpd zmm25, zmm24, zmm22
    vsubpd zmm25, zmm23, zmm25
    vpxorq zmm21, zmm24, [d_sgn]{1to8}
    vpxorq zmm20, zmm25, [d_sgn]{1to8}
    vaddpd zmm25, zmm16, zmm21
    vsubpd zmm24, zmm25, zmm16
    vsubpd zmm23, zmm25, zmm24
    vsubpd zmm23, zmm16, zmm23
    vsubpd zmm24, zmm21, zmm24
    vaddpd zmm23, zmm23, zmm24
    vaddpd zmm24, zmm17, zmm20
    vsubpd zmm22, zmm24, zmm17
    vsubpd zmm26, zmm24, zmm22
    vsubpd zmm26, zmm17, zmm26
    vsubpd zmm22, zmm20, zmm22
    vaddpd zmm26, zmm26, zmm22
    vaddpd zmm22, zmm23, zmm24
    vaddpd zmm24, zmm25, zmm22
    vsubpd zmm23, zmm24, zmm25
    vsubpd zmm23, zmm22, zmm23
    vaddpd zmm22, zmm23, zmm26
    vaddpd zmm26, zmm24, zmm22
    vsubpd zmm23, zmm26, zmm24
    vsubpd zmm23, zmm22, zmm23
    vbroadcastsd zmm20, [d_i1024]
    vmulpd zmm21, zmm26, zmm20
    vmovapd zmm22, zmm21
    vfmsub231pd zmm22, zmm26, zmm20
    vmulpd zmm24, zmm23, zmm20
    vfmadd231pd zmm24, zmm26, zmm18
    vaddpd zmm22, zmm22, zmm24
    vaddpd zmm24, zmm21, zmm22
    vsubpd zmm25, zmm24, zmm21
    vsubpd zmm25, zmm22, zmm25
    vcvttpd2qq zmm19, zmm19
    vpaddq zmm19, zmm19, [d_q1023]{1to8}
    vpsllq zmm19, zmm19, 52
    vmovapd [r10 + T_EXK], zmm19
    vmovapd [r10 + T_EXR], zmm24
    vmovapd [r10 + T_EXR + 64], zmm25
    vbroadcastsd zmm16, [d_ex + 128]
    vbroadcastsd zmm17, [d_ex + 136]
    mov r6d, 7*16
.dexh:
    vmovapd zmm25, [r10 + T_EXR]
    vmovapd zmm24, [r10 + T_EXR + 64]
    vmulpd zmm19, zmm16, zmm25
    vmovapd zmm23, zmm19
    vfmsub231pd zmm23, zmm16, zmm25
    vmulpd zmm26, zmm17, zmm25
    vfmadd231pd zmm26, zmm16, zmm24
    vaddpd zmm23, zmm23, zmm26
    vaddpd zmm26, zmm19, zmm23
    vsubpd zmm20, zmm26, zmm19
    vsubpd zmm20, zmm23, zmm20
    vbroadcastsd zmm24, [d_ex + r6]
    vbroadcastsd zmm25, [d_ex + r6 + 8]
    vaddpd zmm23, zmm26, zmm24
    vsubpd zmm19, zmm23, zmm26
    vsubpd zmm22, zmm23, zmm19
    vsubpd zmm22, zmm26, zmm22
    vsubpd zmm19, zmm24, zmm19
    vaddpd zmm22, zmm22, zmm19
    vaddpd zmm19, zmm20, zmm25
    vsubpd zmm21, zmm19, zmm20
    vsubpd zmm27, zmm19, zmm21
    vsubpd zmm27, zmm20, zmm27
    vsubpd zmm21, zmm25, zmm21
    vaddpd zmm27, zmm27, zmm21
    vaddpd zmm21, zmm22, zmm19
    vaddpd zmm19, zmm23, zmm21
    vsubpd zmm22, zmm19, zmm23
    vsubpd zmm22, zmm21, zmm22
    vaddpd zmm21, zmm22, zmm27
    vaddpd zmm27, zmm19, zmm21
    vsubpd zmm22, zmm27, zmm19
    vsubpd zmm22, zmm21, zmm22
    vmovapd zmm16, zmm27
    vmovapd zmm17, zmm22
    sub r6d, 16
    jns .dexh
    mov r6d, 10
.dexq:
    vmulpd zmm22, zmm16, zmm16
    vmovapd zmm27, zmm22
    vfmsub231pd zmm27, zmm16, zmm16
    vmulpd zmm25, zmm17, zmm16
    vfmadd231pd zmm25, zmm16, zmm17
    vaddpd zmm27, zmm27, zmm25
    vaddpd zmm25, zmm22, zmm27
    vsubpd zmm24, zmm25, zmm22
    vsubpd zmm24, zmm27, zmm24
    vmovapd zmm16, zmm25
    vmovapd zmm17, zmm24
    dec r6d
    jnz .dexq
    vmulpd zmm16, zmm16, [r10 + T_EXK]
    vmulpd zmm17, zmm17, [r10 + T_EXK]
    ret
.dln:
    vmovapd [r10 + T_LN], zmm16
    vmovapd [r10 + T_LN + 64], zmm17
    call .lgv
    vmovapd [r10 + T_LN + 128], zmm16
    vpxorq zmm16, zmm16, [d_sgn]{1to8}
    vpxorq zmm17, zmm17, zmm17
    call .dexp
    vmovapd zmm18, [r10 + T_LN]
    vmovapd zmm19, [r10 + T_LN + 64]
    vmulpd zmm20, zmm18, zmm16
    vmovapd zmm21, zmm20
    vfmsub231pd zmm21, zmm18, zmm16
    vmulpd zmm22, zmm19, zmm16
    vfmadd231pd zmm22, zmm18, zmm17
    vaddpd zmm21, zmm21, zmm22
    vaddpd zmm22, zmm20, zmm21
    vsubpd zmm23, zmm22, zmm20
    vsubpd zmm23, zmm21, zmm23
    vbroadcastsd zmm19, [d_mone]
    vbroadcastsd zmm18, [d_mzero]
    vaddpd zmm21, zmm22, zmm19
    vsubpd zmm20, zmm21, zmm22
    vsubpd zmm24, zmm21, zmm20
    vsubpd zmm24, zmm22, zmm24
    vsubpd zmm20, zmm19, zmm20
    vaddpd zmm24, zmm24, zmm20
    vaddpd zmm20, zmm23, zmm18
    vsubpd zmm25, zmm20, zmm23
    vsubpd zmm26, zmm20, zmm25
    vsubpd zmm26, zmm23, zmm26
    vsubpd zmm25, zmm18, zmm25
    vaddpd zmm26, zmm26, zmm25
    vaddpd zmm25, zmm24, zmm20
    vaddpd zmm20, zmm21, zmm25
    vsubpd zmm24, zmm20, zmm21
    vsubpd zmm24, zmm25, zmm24
    vaddpd zmm25, zmm24, zmm26
    vaddpd zmm26, zmm20, zmm25
    vsubpd zmm24, zmm26, zmm20
    vsubpd zmm24, zmm25, zmm24
    vpxorq zmm23, zmm23, zmm23
    vmovapd zmm22, [r10 + T_LN + 128]
    vaddpd zmm18, zmm22, zmm26
    vsubpd zmm19, zmm18, zmm22
    vsubpd zmm25, zmm18, zmm19
    vsubpd zmm25, zmm22, zmm25
    vsubpd zmm19, zmm26, zmm19
    vaddpd zmm25, zmm25, zmm19
    vaddpd zmm19, zmm23, zmm24
    vsubpd zmm20, zmm19, zmm23
    vsubpd zmm21, zmm19, zmm20
    vsubpd zmm21, zmm23, zmm21
    vsubpd zmm20, zmm24, zmm20
    vaddpd zmm21, zmm21, zmm20
    vaddpd zmm20, zmm25, zmm19
    vaddpd zmm19, zmm18, zmm20
    vsubpd zmm25, zmm19, zmm18
    vsubpd zmm25, zmm20, zmm25
    vaddpd zmm20, zmm25, zmm21
    vaddpd zmm21, zmm19, zmm20
    vsubpd zmm25, zmm21, zmm19
    vsubpd zmm25, zmm20, zmm25
    vmovapd zmm16, zmm21
    vmovapd zmm17, zmm25
    ret
.xeo:
    vbroadcastsd zmm18, [d_one]
    vpxorq zmm0, zmm0, zmm0
    vpmovq2m k4, zmm16
    vmovapd zmm1, zmm18
    vbroadcastsd zmm1{k4}, [d_mone]
    vmulpd zmm19, zmm16, zmm1
    vmulpd zmm20, zmm17, zmm1
    vcmppd k5, zmm19, zmm0, 0x12
    vcmppd k6, zmm19, zmm18, 0x1e
    vblendmpd zmm21{k6}, zmm19, zmm18
    vblendmpd zmm22{k6}, zmm20, zmm0
    vpxorq zmm18, zmm21, [d_sgn]{1to8}
    vpxorq zmm23, zmm22, [d_sgn]{1to8}
    vaddpd zmm24, zmm19, zmm18
    vsubpd zmm25, zmm24, zmm19
    vsubpd zmm26, zmm24, zmm25
    vsubpd zmm26, zmm19, zmm26
    vsubpd zmm25, zmm18, zmm25
    vaddpd zmm26, zmm26, zmm25
    vaddpd zmm25, zmm20, zmm23
    vsubpd zmm27, zmm25, zmm20
    vsubpd zmm28, zmm25, zmm27
    vsubpd zmm28, zmm20, zmm28
    vsubpd zmm27, zmm23, zmm27
    vaddpd zmm28, zmm28, zmm27
    vaddpd zmm27, zmm26, zmm25
    vaddpd zmm25, zmm24, zmm27
    vsubpd zmm26, zmm25, zmm24
    vsubpd zmm26, zmm27, zmm26
    vaddpd zmm27, zmm26, zmm28
    vaddpd zmm28, zmm25, zmm27
    vsubpd zmm26, zmm28, zmm25
    vsubpd zmm26, zmm27, zmm26
    vmovapd zmm2, zmm28
    vmovapd zmm3, zmm26
    vmovapd zmm16, zmm21
    vmovapd zmm17, zmm22
    call .dln
    vbroadcastsd zmm26, [d_im2]
    vbroadcastsd zmm28, [d_im2 + 8]
    vmulpd zmm20, zmm26, zmm16
    vmovapd zmm19, zmm20
    vfmsub231pd zmm19, zmm26, zmm16
    vmulpd zmm23, zmm28, zmm16
    vfmadd231pd zmm23, zmm26, zmm17
    vaddpd zmm19, zmm19, zmm23
    vaddpd zmm23, zmm20, zmm19
    vsubpd zmm18, zmm23, zmm20
    vsubpd zmm18, zmm19, zmm18
    vmovapd zmm16, zmm23
    vmovapd zmm17, zmm18
    call .dexp
    vmovapd zmm22, zmm16
    vmovapd zmm21, zmm17
    vbroadcastsd zmm18, [d_mc1]
    vbroadcastsd zmm23, [d_mzero]
    vaddpd zmm28, zmm22, zmm18
    vsubpd zmm26, zmm28, zmm22
    vsubpd zmm19, zmm28, zmm26
    vsubpd zmm19, zmm22, zmm19
    vsubpd zmm26, zmm18, zmm26
    vaddpd zmm19, zmm19, zmm26
    vaddpd zmm26, zmm21, zmm23
    vsubpd zmm20, zmm26, zmm21
    vsubpd zmm27, zmm26, zmm20
    vsubpd zmm27, zmm21, zmm27
    vsubpd zmm20, zmm23, zmm20
    vaddpd zmm27, zmm27, zmm20
    vaddpd zmm20, zmm19, zmm26
    vaddpd zmm26, zmm28, zmm20
    vsubpd zmm19, zmm26, zmm28
    vsubpd zmm19, zmm20, zmm19
    vaddpd zmm20, zmm19, zmm27
    vaddpd zmm27, zmm26, zmm20
    vsubpd zmm19, zmm27, zmm26
    vsubpd zmm19, zmm20, zmm19
    vcmppd k7, zmm27, zmm0, 0x1e
    vbroadcastsd zmm23, [d_c3]
    vmulpd zmm18, zmm23, zmm22
    vmovapd zmm20, zmm18
    vfmsub231pd zmm20, zmm23, zmm22
    vmulpd zmm26, zmm0, zmm22
    vfmadd231pd zmm26, zmm23, zmm21
    vaddpd zmm20, zmm20, zmm26
    vaddpd zmm26, zmm18, zmm20
    vsubpd zmm28, zmm26, zmm18
    vsubpd zmm28, zmm20, zmm28
    vpxorq zmm21, zmm26, [d_sgn]{1to8}
    vpxorq zmm22, zmm28, [d_sgn]{1to8}
    vbroadcastsd zmm28, [d_c2]
    vaddpd zmm26, zmm28, zmm21
    vsubpd zmm23, zmm26, zmm28
    vsubpd zmm20, zmm26, zmm23
    vsubpd zmm20, zmm28, zmm20
    vsubpd zmm23, zmm21, zmm23
    vaddpd zmm20, zmm20, zmm23
    vaddpd zmm23, zmm0, zmm22
    vsubpd zmm18, zmm23, zmm0
    vsubpd zmm25, zmm23, zmm18
    vsubpd zmm25, zmm0, zmm25
    vsubpd zmm18, zmm22, zmm18
    vaddpd zmm25, zmm25, zmm18
    vaddpd zmm18, zmm20, zmm23
    vaddpd zmm23, zmm26, zmm18
    vsubpd zmm20, zmm23, zmm26
    vsubpd zmm20, zmm18, zmm20
    vaddpd zmm18, zmm20, zmm25
    vaddpd zmm25, zmm23, zmm18
    vsubpd zmm20, zmm25, zmm23
    vsubpd zmm20, zmm18, zmm20
    vdivpd zmm22, zmm27, zmm25
    vpxorq zmm21, zmm22, [d_sgn]{1to8}
    vmulpd zmm28, zmm25, zmm21
    vmovapd zmm18, zmm28
    vfmsub231pd zmm18, zmm25, zmm21
    vmulpd zmm23, zmm20, zmm21
    vfmadd231pd zmm23, zmm25, zmm0
    vaddpd zmm18, zmm18, zmm23
    vaddpd zmm23, zmm28, zmm18
    vsubpd zmm26, zmm23, zmm28
    vsubpd zmm26, zmm18, zmm26
    vaddpd zmm21, zmm27, zmm23
    vsubpd zmm18, zmm21, zmm27
    vsubpd zmm28, zmm21, zmm18
    vsubpd zmm28, zmm27, zmm28
    vsubpd zmm18, zmm23, zmm18
    vaddpd zmm28, zmm28, zmm18
    vaddpd zmm18, zmm19, zmm26
    vsubpd zmm24, zmm18, zmm19
    vsubpd zmm29, zmm18, zmm24
    vsubpd zmm29, zmm19, zmm29
    vsubpd zmm24, zmm26, zmm24
    vaddpd zmm29, zmm29, zmm24
    vaddpd zmm24, zmm28, zmm18
    vaddpd zmm18, zmm21, zmm24
    vsubpd zmm28, zmm18, zmm21
    vsubpd zmm28, zmm24, zmm28
    vaddpd zmm24, zmm28, zmm29
    vaddpd zmm29, zmm18, zmm24
    vsubpd zmm28, zmm29, zmm18
    vsubpd zmm28, zmm24, zmm28
    vdivpd zmm26, zmm29, zmm25
    vpxorq zmm23, zmm26, [d_sgn]{1to8}
    vmulpd zmm24, zmm25, zmm23
    vmovapd zmm18, zmm24
    vfmsub231pd zmm18, zmm25, zmm23
    vmulpd zmm21, zmm20, zmm23
    vfmadd231pd zmm21, zmm25, zmm0
    vaddpd zmm18, zmm18, zmm21
    vaddpd zmm21, zmm24, zmm18
    vsubpd zmm30, zmm21, zmm24
    vsubpd zmm30, zmm18, zmm30
    vaddpd zmm23, zmm29, zmm21
    vsubpd zmm18, zmm23, zmm29
    vsubpd zmm24, zmm23, zmm18
    vsubpd zmm24, zmm29, zmm24
    vsubpd zmm18, zmm21, zmm18
    vaddpd zmm24, zmm24, zmm18
    vaddpd zmm18, zmm28, zmm30
    vsubpd zmm31, zmm18, zmm28
    vsubpd zmm4, zmm18, zmm31
    vsubpd zmm4, zmm28, zmm4
    vsubpd zmm31, zmm30, zmm31
    vaddpd zmm4, zmm4, zmm31
    vaddpd zmm31, zmm24, zmm18
    vaddpd zmm18, zmm23, zmm31
    vsubpd zmm24, zmm18, zmm23
    vsubpd zmm24, zmm31, zmm24
    vaddpd zmm31, zmm24, zmm4
    vaddpd zmm4, zmm18, zmm31
    vdivpd zmm28, zmm4, zmm25
    vaddpd zmm24, zmm22, zmm26
    vsubpd zmm4, zmm24, zmm22
    vsubpd zmm4, zmm26, zmm4
    vaddpd zmm26, zmm24, zmm28
    vsubpd zmm22, zmm26, zmm24
    vsubpd zmm29, zmm26, zmm22
    vsubpd zmm29, zmm24, zmm29
    vsubpd zmm22, zmm28, zmm22
    vaddpd zmm29, zmm29, zmm22
    vaddpd zmm22, zmm4, zmm0
    vsubpd zmm30, zmm22, zmm4
    vsubpd zmm21, zmm22, zmm30
    vsubpd zmm21, zmm4, zmm21
    vsubpd zmm30, zmm0, zmm30
    vaddpd zmm21, zmm21, zmm30
    vaddpd zmm30, zmm29, zmm22
    vaddpd zmm22, zmm26, zmm30
    vsubpd zmm29, zmm22, zmm26
    vsubpd zmm29, zmm30, zmm29
    vaddpd zmm30, zmm29, zmm21
    vaddpd zmm21, zmm22, zmm30
    vsubpd zmm29, zmm21, zmm22
    vsubpd zmm29, zmm30, zmm29
    vmovapd zmm16, zmm21
    vmovapd zmm17, zmm29
    call .dln
    vbroadcastsd zmm20, [d_im1]
    vbroadcastsd zmm25, [d_im1 + 8]
    vmulpd zmm19, zmm20, zmm16
    vmovapd zmm27, zmm19
    vfmsub231pd zmm27, zmm20, zmm16
    vmulpd zmm28, zmm25, zmm16
    vfmadd231pd zmm28, zmm20, zmm17
    vaddpd zmm27, zmm27, zmm28
    vaddpd zmm28, zmm19, zmm27
    vsubpd zmm4, zmm28, zmm19
    vsubpd zmm4, zmm27, zmm4
    vmovapd zmm16, zmm28
    vmovapd zmm17, zmm4
    call .dexp
    vmovapd zmm16{k7}{z}, zmm16
    vmovapd zmm17{k7}{z}, zmm17
    vbroadcastsd zmm29, [d_k12]
    vbroadcastsd zmm21, [d_k12 + 8]
    vmulpd zmm4, zmm29, zmm2
    vmovapd zmm28, zmm4
    vfmsub231pd zmm28, zmm29, zmm2
    vmulpd zmm25, zmm21, zmm2
    vfmadd231pd zmm25, zmm29, zmm3
    vaddpd zmm28, zmm28, zmm25
    vaddpd zmm25, zmm4, zmm28
    vsubpd zmm20, zmm25, zmm4
    vsubpd zmm20, zmm28, zmm20
    vaddpd zmm3, zmm16, zmm25
    vsubpd zmm2, zmm3, zmm16
    vsubpd zmm21, zmm3, zmm2
    vsubpd zmm21, zmm16, zmm21
    vsubpd zmm2, zmm25, zmm2
    vaddpd zmm21, zmm21, zmm2
    vaddpd zmm2, zmm17, zmm20
    vsubpd zmm29, zmm2, zmm17
    vsubpd zmm28, zmm2, zmm29
    vsubpd zmm28, zmm17, zmm28
    vsubpd zmm29, zmm20, zmm29
    vaddpd zmm28, zmm28, zmm29
    vaddpd zmm29, zmm21, zmm2
    vaddpd zmm2, zmm3, zmm29
    vsubpd zmm21, zmm2, zmm3
    vsubpd zmm21, zmm29, zmm21
    vaddpd zmm29, zmm21, zmm28
    vaddpd zmm28, zmm2, zmm29
    vsubpd zmm21, zmm28, zmm2
    vsubpd zmm21, zmm29, zmm21
    vmovapd zmm28{k5}, zmm0
    vmovapd zmm21{k5}, zmm0
    vmulpd zmm16, zmm28, zmm1
    vmulpd zmm17, zmm21, zmm1
    ret
.xoe:
    vbroadcastsd zmm18, [d_one]
    vpxorq zmm0, zmm0, zmm0
    vpmovq2m k4, zmm16
    vmovapd zmm1, zmm18
    vbroadcastsd zmm1{k4}, [d_mone]
    vmulpd zmm19, zmm16, zmm1
    vmulpd zmm20, zmm17, zmm1
    vcmppd k5, zmm19, zmm0, 0x12
    vcmppd k6, zmm19, zmm18, 0x1e
    vbroadcastsd zmm21, [d_mone]
    vbroadcastsd zmm22, [d_mzero]
    vaddpd zmm23, zmm19, zmm21
    vsubpd zmm24, zmm23, zmm19
    vsubpd zmm25, zmm23, zmm24
    vsubpd zmm25, zmm19, zmm25
    vsubpd zmm24, zmm21, zmm24
    vaddpd zmm25, zmm25, zmm24
    vaddpd zmm24, zmm20, zmm22
    vsubpd zmm26, zmm24, zmm20
    vsubpd zmm27, zmm24, zmm26
    vsubpd zmm27, zmm20, zmm27
    vsubpd zmm26, zmm22, zmm26
    vaddpd zmm27, zmm27, zmm26
    vaddpd zmm26, zmm25, zmm24
    vaddpd zmm24, zmm23, zmm26
    vsubpd zmm25, zmm24, zmm23
    vsubpd zmm25, zmm26, zmm25
    vaddpd zmm26, zmm25, zmm27
    vaddpd zmm27, zmm24, zmm26
    vsubpd zmm25, zmm27, zmm24
    vsubpd zmm25, zmm26, zmm25
    vbroadcastsd zmm22, [d_m12d]
    vbroadcastsd zmm21, [d_m12d + 8]
    vmulpd zmm26, zmm27, zmm22
    vmovapd zmm24, zmm26
    vfmsub231pd zmm24, zmm27, zmm22
    vmulpd zmm23, zmm25, zmm22
    vfmadd231pd zmm23, zmm27, zmm21
    vaddpd zmm24, zmm24, zmm23
    vaddpd zmm23, zmm26, zmm24
    vsubpd zmm28, zmm23, zmm26
    vsubpd zmm28, zmm24, zmm28
    vbroadcastsd zmm25, [d_120]
    vdivpd zmm27, zmm23, zmm25
    vpxorq zmm21, zmm27, [d_sgn]{1to8}
    vmulpd zmm22, zmm25, zmm21
    vmovapd zmm24, zmm22
    vfmsub231pd zmm24, zmm25, zmm21
    vmulpd zmm26, zmm0, zmm21
    vfmadd231pd zmm26, zmm25, zmm0
    vaddpd zmm24, zmm24, zmm26
    vaddpd zmm26, zmm22, zmm24
    vsubpd zmm29, zmm26, zmm22
    vsubpd zmm29, zmm24, zmm29
    vaddpd zmm21, zmm23, zmm26
    vsubpd zmm24, zmm21, zmm23
    vsubpd zmm22, zmm21, zmm24
    vsubpd zmm22, zmm23, zmm22
    vsubpd zmm24, zmm26, zmm24
    vaddpd zmm22, zmm22, zmm24
    vaddpd zmm24, zmm28, zmm29
    vsubpd zmm30, zmm24, zmm28
    vsubpd zmm31, zmm24, zmm30
    vsubpd zmm31, zmm28, zmm31
    vsubpd zmm30, zmm29, zmm30
    vaddpd zmm31, zmm31, zmm30
    vaddpd zmm30, zmm22, zmm24
    vaddpd zmm24, zmm21, zmm30
    vsubpd zmm22, zmm24, zmm21
    vsubpd zmm22, zmm30, zmm22
    vaddpd zmm30, zmm22, zmm31
    vaddpd zmm31, zmm24, zmm30
    vsubpd zmm22, zmm31, zmm24
    vsubpd zmm22, zmm30, zmm22
    vdivpd zmm29, zmm31, zmm25
    vpxorq zmm26, zmm29, [d_sgn]{1to8}
    vmulpd zmm30, zmm25, zmm26
    vmovapd zmm24, zmm30
    vfmsub231pd zmm24, zmm25, zmm26
    vmulpd zmm21, zmm0, zmm26
    vfmadd231pd zmm21, zmm25, zmm0
    vaddpd zmm24, zmm24, zmm21
    vaddpd zmm21, zmm30, zmm24
    vsubpd zmm2, zmm21, zmm30
    vsubpd zmm2, zmm24, zmm2
    vaddpd zmm26, zmm31, zmm21
    vsubpd zmm24, zmm26, zmm31
    vsubpd zmm30, zmm26, zmm24
    vsubpd zmm30, zmm31, zmm30
    vsubpd zmm24, zmm21, zmm24
    vaddpd zmm30, zmm30, zmm24
    vaddpd zmm24, zmm22, zmm2
    vsubpd zmm3, zmm24, zmm22
    vsubpd zmm4, zmm24, zmm3
    vsubpd zmm4, zmm22, zmm4
    vsubpd zmm3, zmm2, zmm3
    vaddpd zmm4, zmm4, zmm3
    vaddpd zmm3, zmm30, zmm24
    vaddpd zmm24, zmm26, zmm3
    vsubpd zmm30, zmm24, zmm26
    vsubpd zmm30, zmm3, zmm30
    vaddpd zmm3, zmm30, zmm4
    vaddpd zmm4, zmm24, zmm3
    vdivpd zmm22, zmm4, zmm25
    vaddpd zmm30, zmm27, zmm29
    vsubpd zmm4, zmm30, zmm27
    vsubpd zmm4, zmm29, zmm4
    vaddpd zmm29, zmm30, zmm22
    vsubpd zmm27, zmm29, zmm30
    vsubpd zmm31, zmm29, zmm27
    vsubpd zmm31, zmm30, zmm31
    vsubpd zmm27, zmm22, zmm27
    vaddpd zmm31, zmm31, zmm27
    vaddpd zmm27, zmm4, zmm0
    vsubpd zmm2, zmm27, zmm4
    vsubpd zmm21, zmm27, zmm2
    vsubpd zmm21, zmm4, zmm21
    vsubpd zmm2, zmm0, zmm2
    vaddpd zmm21, zmm21, zmm2
    vaddpd zmm2, zmm31, zmm27
    vaddpd zmm27, zmm29, zmm2
    vsubpd zmm31, zmm27, zmm29
    vsubpd zmm31, zmm2, zmm31
    vaddpd zmm2, zmm31, zmm21
    vaddpd zmm21, zmm27, zmm2
    vsubpd zmm31, zmm21, zmm27
    vsubpd zmm31, zmm2, zmm31
    vaddpd zmm28, zmm18, zmm21
    vsubpd zmm23, zmm28, zmm18
    vsubpd zmm25, zmm28, zmm23
    vsubpd zmm25, zmm18, zmm25
    vsubpd zmm23, zmm21, zmm23
    vaddpd zmm25, zmm25, zmm23
    vaddpd zmm23, zmm0, zmm31
    vsubpd zmm22, zmm23, zmm0
    vsubpd zmm4, zmm23, zmm22
    vsubpd zmm4, zmm0, zmm4
    vsubpd zmm22, zmm31, zmm22
    vaddpd zmm4, zmm4, zmm22
    vaddpd zmm22, zmm25, zmm23
    vaddpd zmm23, zmm28, zmm22
    vsubpd zmm25, zmm23, zmm28
    vsubpd zmm25, zmm22, zmm25
    vaddpd zmm22, zmm25, zmm4
    vaddpd zmm4, zmm23, zmm22
    vsubpd zmm25, zmm4, zmm23
    vsubpd zmm25, zmm22, zmm25
    vmovapd zmm2, zmm25
    vmovapd zmm16, zmm19
    vmovapd zmm17, zmm20
    call .dln
    vbroadcastsd zmm25, [d_m1]
    vbroadcastsd zmm18, [d_zero]
    vmulpd zmm31, zmm25, zmm16
    vmovapd zmm21, zmm31
    vfmsub231pd zmm21, zmm25, zmm16
    vmulpd zmm22, zmm18, zmm16
    vfmadd231pd zmm22, zmm25, zmm17
    vaddpd zmm21, zmm21, zmm22
    vaddpd zmm22, zmm31, zmm21
    vsubpd zmm23, zmm22, zmm31
    vsubpd zmm23, zmm21, zmm23
    vmovapd zmm16, zmm22
    vmovapd zmm17, zmm23
    call .dexp
    vmovapd zmm16{k5}, zmm0
    vmovapd zmm17{k5}, zmm0
    vbroadcastsd zmm20, [d_c2]
    vmulpd zmm19, zmm20, zmm16
    vmovapd zmm23, zmm19
    vfmsub231pd zmm23, zmm20, zmm16
    vmulpd zmm22, zmm0, zmm16
    vfmadd231pd zmm22, zmm20, zmm17
    vaddpd zmm23, zmm23, zmm22
    vaddpd zmm22, zmm19, zmm23
    vsubpd zmm18, zmm22, zmm19
    vsubpd zmm18, zmm23, zmm18
    vbroadcastsd zmm20, [d_c1]
    vaddpd zmm23, zmm20, zmm22
    vsubpd zmm19, zmm23, zmm20
    vsubpd zmm25, zmm23, zmm19
    vsubpd zmm25, zmm20, zmm25
    vsubpd zmm19, zmm22, zmm19
    vaddpd zmm25, zmm25, zmm19
    vaddpd zmm19, zmm0, zmm18
    vsubpd zmm21, zmm19, zmm0
    vsubpd zmm31, zmm19, zmm21
    vsubpd zmm31, zmm0, zmm31
    vsubpd zmm21, zmm18, zmm21
    vaddpd zmm31, zmm31, zmm21
    vaddpd zmm21, zmm25, zmm19
    vaddpd zmm19, zmm23, zmm21
    vsubpd zmm25, zmm19, zmm23
    vsubpd zmm25, zmm21, zmm25
    vaddpd zmm21, zmm25, zmm31
    vaddpd zmm31, zmm19, zmm21
    vsubpd zmm25, zmm31, zmm19
    vsubpd zmm25, zmm21, zmm25
    vbroadcastsd zmm18, [d_c3]
    vmulpd zmm22, zmm18, zmm16
    vmovapd zmm20, zmm22
    vfmsub231pd zmm20, zmm18, zmm16
    vmulpd zmm21, zmm0, zmm16
    vfmadd231pd zmm21, zmm18, zmm17
    vaddpd zmm20, zmm20, zmm21
    vaddpd zmm21, zmm22, zmm20
    vsubpd zmm19, zmm21, zmm22
    vsubpd zmm19, zmm20, zmm19
    vbroadcastsd zmm18, [d_one]
    vaddpd zmm20, zmm18, zmm21
    vsubpd zmm22, zmm20, zmm18
    vsubpd zmm23, zmm20, zmm22
    vsubpd zmm23, zmm18, zmm23
    vsubpd zmm22, zmm21, zmm22
    vaddpd zmm23, zmm23, zmm22
    vaddpd zmm22, zmm0, zmm19
    vsubpd zmm28, zmm22, zmm0
    vsubpd zmm30, zmm22, zmm28
    vsubpd zmm30, zmm0, zmm30
    vsubpd zmm28, zmm19, zmm28
    vaddpd zmm30, zmm30, zmm28
    vaddpd zmm28, zmm23, zmm22
    vaddpd zmm22, zmm20, zmm28
    vsubpd zmm23, zmm22, zmm20
    vsubpd zmm23, zmm28, zmm23
    vaddpd zmm28, zmm23, zmm30
    vaddpd zmm30, zmm22, zmm28
    vsubpd zmm23, zmm30, zmm22
    vsubpd zmm23, zmm28, zmm23
    vdivpd zmm18, zmm31, zmm30
    vpxorq zmm19, zmm18, [d_sgn]{1to8}
    vmulpd zmm21, zmm30, zmm19
    vmovapd zmm28, zmm21
    vfmsub231pd zmm28, zmm30, zmm19
    vmulpd zmm22, zmm23, zmm19
    vfmadd231pd zmm22, zmm30, zmm0
    vaddpd zmm28, zmm28, zmm22
    vaddpd zmm22, zmm21, zmm28
    vsubpd zmm20, zmm22, zmm21
    vsubpd zmm20, zmm28, zmm20
    vaddpd zmm19, zmm31, zmm22
    vsubpd zmm28, zmm19, zmm31
    vsubpd zmm21, zmm19, zmm28
    vsubpd zmm21, zmm31, zmm21
    vsubpd zmm28, zmm22, zmm28
    vaddpd zmm21, zmm21, zmm28
    vaddpd zmm28, zmm25, zmm20
    vsubpd zmm27, zmm28, zmm25
    vsubpd zmm29, zmm28, zmm27
    vsubpd zmm29, zmm25, zmm29
    vsubpd zmm27, zmm20, zmm27
    vaddpd zmm29, zmm29, zmm27
    vaddpd zmm27, zmm21, zmm28
    vaddpd zmm28, zmm19, zmm27
    vsubpd zmm21, zmm28, zmm19
    vsubpd zmm21, zmm27, zmm21
    vaddpd zmm27, zmm21, zmm29
    vaddpd zmm29, zmm28, zmm27
    vsubpd zmm21, zmm29, zmm28
    vsubpd zmm21, zmm27, zmm21
    vdivpd zmm20, zmm29, zmm30
    vpxorq zmm22, zmm20, [d_sgn]{1to8}
    vmulpd zmm27, zmm30, zmm22
    vmovapd zmm28, zmm27
    vfmsub231pd zmm28, zmm30, zmm22
    vmulpd zmm19, zmm23, zmm22
    vfmadd231pd zmm19, zmm30, zmm0
    vaddpd zmm28, zmm28, zmm19
    vaddpd zmm19, zmm27, zmm28
    vsubpd zmm3, zmm19, zmm27
    vsubpd zmm3, zmm28, zmm3
    vaddpd zmm22, zmm29, zmm19
    vsubpd zmm28, zmm22, zmm29
    vsubpd zmm27, zmm22, zmm28
    vsubpd zmm27, zmm29, zmm27
    vsubpd zmm28, zmm19, zmm28
    vaddpd zmm27, zmm27, zmm28
    vaddpd zmm28, zmm21, zmm3
    vsubpd zmm24, zmm28, zmm21
    vsubpd zmm26, zmm28, zmm24
    vsubpd zmm26, zmm21, zmm26
    vsubpd zmm24, zmm3, zmm24
    vaddpd zmm26, zmm26, zmm24
    vaddpd zmm24, zmm27, zmm28
    vaddpd zmm28, zmm22, zmm24
    vsubpd zmm27, zmm28, zmm22
    vsubpd zmm27, zmm24, zmm27
    vaddpd zmm24, zmm27, zmm26
    vaddpd zmm26, zmm28, zmm24
    vdivpd zmm21, zmm26, zmm30
    vaddpd zmm27, zmm18, zmm20
    vsubpd zmm26, zmm27, zmm18
    vsubpd zmm26, zmm20, zmm26
    vaddpd zmm20, zmm27, zmm21
    vsubpd zmm18, zmm20, zmm27
    vsubpd zmm29, zmm20, zmm18
    vsubpd zmm29, zmm27, zmm29
    vsubpd zmm18, zmm21, zmm18
    vaddpd zmm29, zmm29, zmm18
    vaddpd zmm18, zmm26, zmm0
    vsubpd zmm3, zmm18, zmm26
    vsubpd zmm19, zmm18, zmm3
    vsubpd zmm19, zmm26, zmm19
    vsubpd zmm3, zmm0, zmm3
    vaddpd zmm19, zmm19, zmm3
    vaddpd zmm3, zmm29, zmm18
    vaddpd zmm18, zmm20, zmm3
    vsubpd zmm29, zmm18, zmm20
    vsubpd zmm29, zmm3, zmm29
    vaddpd zmm3, zmm29, zmm19
    vaddpd zmm19, zmm18, zmm3
    vsubpd zmm29, zmm19, zmm18
    vsubpd zmm29, zmm3, zmm29
    vmovapd zmm16, zmm19
    vmovapd zmm17, zmm29
    call .dln
    vbroadcastsd zmm23, [d_m2]
    vbroadcastsd zmm30, [d_zero]
    vmulpd zmm25, zmm23, zmm16
    vmovapd zmm31, zmm25
    vfmsub231pd zmm31, zmm23, zmm16
    vmulpd zmm21, zmm30, zmm16
    vfmadd231pd zmm21, zmm23, zmm17
    vaddpd zmm31, zmm31, zmm21
    vaddpd zmm21, zmm25, zmm31
    vsubpd zmm26, zmm21, zmm25
    vsubpd zmm26, zmm31, zmm26
    vmovapd zmm16, zmm21
    vmovapd zmm17, zmm26
    call .dexp
    vmovapd zmm16{k6}, zmm4
    vmovapd zmm17{k6}, zmm2
    vmulpd zmm16, zmm16, zmm1
    vmulpd zmm17, zmm17, zmm1
    ret

