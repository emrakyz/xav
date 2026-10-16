%include "dav1d_x86inc.asm"

W equ 64*M
HMX equ 4320
CST equ W+64
CPL0 equ (18*M+4)*CST
CB0 equ 72*W*M+64
CRD equ CPL0 + 65536*(((HMX/2+4)*CST - CPL0 + 65535)/65536)
CB equ CB0 + 65536*((2*W*HMX + 64 - CB0 + 65535)/65536)
SPBC equ 512*(M+1)
SLT equ 6784+256
BMS equ 6784+8*SPBC+512
STX equ BMS+1408
CRY equ STX+5184
FRAME equ CRY+16*W

SECTION_RODATA 64

ALIGN 64
t_lad: dd 0, 2, 4, 6, 8, 10, 12, 14, W+0, W+2, W+4, W+6, W+8, W+10, W+12, W+14, 16, 18, 20, 22, 24, 26, 28, 30, W+16, W+18, W+20, W+22, W+24, W+26, W+28, W+30
d_wcl: dd W/2 - 1
MGM equ (0x100000000 + M - 1) / M
T_EXK equ 0
T_EXR equ 32
T_LN equ 96
T_IV equ 192
T_QF equ 320
T_XO equ 352
T_T1 equ 576
T_E1 equ 608
T_RQ equ 800
T_SV equ 2848
T_Y equ 2976
T_B equ 3104
T_R equ 3232
T_XV equ 3360
T_ZB equ 3456
T_LA equ 4224
T_AA equ 4256
T_LO equ 4288
T_HI equ 4320
T_SRC equ 4352
T_IX equ 4384
T_HM equ 4416
T_VM equ 4448
T_EH equ 4480
T_EL equ 4864
T_AC equ 5248
T_EC equ 5312
T_V equ 5376
T_ZS equ 5504
T_XS equ 5536
T_O equ 5568
TS equ 5688

SECTION .text align=4096
INIT_YMM avx2

cextern ro
cextern dp
%define c_rq8 (ro + 0)
%define c_vq8 (ro + 32)
%define c_uq0 (ro + 64)
%define c_uq1 (ro + 96)
%define c_uq2 (ro + 128)
%define c_t68 (ro + 160)
%define c_w68 (ro + 192)
%define c_tll (ro + 224)
%define c_tlh (ro + 256)
%define c_thi (ro + 288)
%define c_w1q (ro + 320)
%define c_r1q (ro + 352)
%define c_t2q (ro + 384)
%define c_rkq (ro + 416)
%define c_rpq (ro + 448)
%define c_s2 (ro + 480)
%define c_one (ro + 512)
%define c_flq (ro + 544)
%define c_pu0 (ro + 576)
%define c_pu1 (ro + 608)
%define c_pu2 (ro + 640)
%define c_pu3 (ro + 672)
%define c_c1q (ro + 704)
%define c_aq (ro + 736)
%define c_bq (ro + 768)
%define c_q60 (ro + 800)
%define c_q61 (ro + 832)
%define c_q62 (ro + 864)
%define c_q63 (ro + 896)
%define c_anl (ro + 928)
%define c_tbl (ro + 960)
%define c_rgl (ro + 992)
%define c_xll (ro + 1024)
%define c_onl (ro + 1056)
%define c_omh1 (ro + 1088)
%define c_oml0 (ro + 1088)
%define c_oml1 (ro + 1120)
%define c_omh0 (ro + 1152)
%define c_omh2 (ro + 1152)
%define c_oml2 (ro + 1152)
%define c_mtl0 (ro + 1184)
%define c_mtl1 (ro + 1216)
%define c_mtl2 (ro + 1248)
%define c_anh (ro + 1280)
%define c_tbh (ro + 1312)
%define c_rgh (ro + 1344)
%define c_xlh (ro + 1376)
%define c_onh (ro + 1408)
%define c_mth0 (ro + 1440)
%define c_mth3 (ro + 1440)
%define c_mth1 (ro + 1472)
%define c_mth2 (ro + 1504)
%define c_mth4 (ro + 1536)
%define c_mth5 (ro + 1568)
%define c_nieq (ro + 1600)
%define c_eqp (ro + 1632)
%define c_q10 (ro + 1664)
%define c_q11 (ro + 1696)
%define c_q12 (ro + 1728)
%define c_s1q (ro + 1760)
%define c_c3 (ro + 1792)
%define c_hq (ro + 1824)
%define c_mag (ro + 1856)
%define c_p20 (ro + 1888)
%define c_p21 (ro + 1920)
%define c_p22 (ro + 1952)
%define c_p23 (ro + 1984)
%define c_p24 (ro + 2016)
%define c_p25 (ro + 2048)
%define c_oa (ro + 2080)
%define c_sl (ro + 2112)
%define c_half (ro + 2144)
%define c_h0625 (ro + 2176)
%define c_h5625 (ro + 2208)
%define c_krh (ro + 2240)
%define c_krl (ro + 2272)
%define c_grh (ro + 2304)
%define c_grl (ro + 2336)
%define c_gbh (ro + 2368)
%define c_gbl (ro + 2400)
%define c_kbh (ro + 2432)
%define c_kbl (ro + 2464)
%define c_sign (ro + 2496)
%define c_mant (ro + 2528)
%define c_zero (ro + 2560)
%define c_i64 (ro + 2592)
%define c_i512 (ro + 2624)
%define c_w1023 (ro + 2656)
%define c_n64w (ro + 2688)
%define c_pd8 (ro + 2720)
%define t_c2d (ro + 2752)
%define t_cmp (ro + 2784)
%define d_i7 (ro + 3808)
%define d_one (ro + 4864)
%define d_qa (ro + 4864)
%define d_qw (ro + 4992)
%define d_rx (ro + 5120)
%define d_qr (ro + 5248)
%define d_qm (ro + 5376)
%define d_zero (ro + 5376)
%define d_qt (ro + 5504)
%define d_t2l (ro + 5632)
%define d_w2x (ro + 5760)
%define d_rxl (ro + 5888)
%define d_t1e (ro + 6016)
%define d_w1m (ro + 6144)
%define d_qb (ro + 6272)
%define d_lgt (ro + 6336)
%define d_ln2 (ro + 8384)
%define d_lzm0 (ro + 8400)
%define d_ysc (ro + 8400)
%define d_lzm5 (ro + 8416)
%define d_yof (ro + 8416)
%define d_lzm1 (ro + 8432)
%define d_rcr (ro + 8432)
%define d_gcr (ro + 8448)
%define d_lzm2 (ro + 8448)
%define d_gcb (ro + 8464)
%define d_lzm3 (ro + 8464)
%define d_bcb (ro + 8480)
%define d_lzm4 (ro + 8480)
%define d_kr (ro + 8496)
%define d_kg (ro + 8512)
%define d_kb (ro + 8528)
%define d_cbs (ro + 8544)
%define d_crs (ro + 8560)
%define d_im2 (ro + 8576)
%define d_im1 (ro + 8592)
%define d_k12 (ro + 8608)
%define d_pk (ro + 8608)
%define d_m12d (ro + 8624)
%define d_ex (ro + 8640)
%define d_half (ro + 8672)
%define d_lg0 (ro + 8784)
%define d_lg1 (ro + 8792)
%define d_lg2 (ro + 8800)
%define d_lg3 (ro + 8808)
%define d_lg4 (ro + 8816)
%define d_lg5 (ro + 8824)
%define d_lg6 (ro + 8832)
%define d_lg7 (ro + 8840)
%define d_mhalf (ro + 8840)
%define d_lg8 (ro + 8848)
%define d_lg9 (ro + 8856)
%define d_lg10 (ro + 8864)
%define d_lg11 (ro + 8872)
%define d_lg12 (ro + 8880)
%define d_lg13 (ro + 8888)
%define d_lg14 (ro + 8896)
%define d_lg15 (ro + 8904)
%define d_lg16 (ro + 8912)
%define d_lg17 (ro + 8920)
%define d_mc1 (ro + 8928)
%define d_mone (ro + 8936)
%define d_mzero (ro + 8944)
%define d_sgn (ro + 8944)
%define d_2p20 (ro + 8952)
%define d_i1024 (ro + 8960)
%define d_1024 (ro + 8968)
%define d_ys (ro + 8976)
%define d_yb (ro + 8984)
%define d_512 (ro + 8992)
%define d_120 (ro + 9000)
%define d_1023 (ro + 9008)
%define d_16 (ro + 9016)
%define d_q4 (ro + 9024)
%define d_q16 (ro + 9032)
%define d_2p27 (ro + 9040)
%define d_m63 (ro + 9048)
%define d_p63 (ro + 9056)
%define d_epd (ro + 9064)
%define d_tab (ro + 9072)
%define d_tab2 (ro + 9080)
%define d_omg (ro + 9088)
%define d_eq0 (ro + 9096)
%define d_rg2 (ro + 9104)
%define d_c1 (ro + 9112)
%define d_c2 (ro + 9120)
%define d_c3 (ro + 9128)
%define d_m1 (ro + 9136)
%define d_m2 (ro + 9144)
%define d_c13 (ro + 9152)
%define d_c2c (ro + 9160)
%define d_laq (ro + 9168)
%define d_t2k (ro + 9176)
%define d_zz (ro + 9184)
%define d_m12 (ro + 9192)
%define d_flo (ro + 9200)
%define d_qtk (ro + 9208)
%define d_k7 (ro + 9216)
%define d_k7s (ro + 9224)
%define d_k7m (ro + 9232)
%define d_sga (ro + 9240)
%define d_rgl (ro + 9248)
%define d_anl (ro + 9256)
%define d_kvl (ro + 9264)
%define d_sll (ro + 9272)
%define d_ylo (ro + 9272)
%define d_shl (ro + 9280)
%define d_yhi (ro + 9280)
%define d_rgh (ro + 9288)
%define d_anh (ro + 9296)
%define d_kvh (ro + 9304)
%define d_clo (ro + 9312)
%define d_slh (ro + 9312)
%define d_chi (ro + 9320)
%define d_shh (ro + 9320)
%define d_abs (ro + 9328)
%define d_mant (ro + 9336)
%define d_hm (ro + 9344)
%define d_q1023 (ro + 9352)
%define d_i15 (ro + 9360)
%define d_i16 (ro + 9368)
%define d_lmx (ro + 9376)
%define d_lhx (ro + 9384)
%define d_lof (ro + 9392)
%define d_lfe (ro + 9400)
%define d_lhm (ro + 9408)
%define d_xys (ro + 9416)
%define d_xyb (ro + 9424)
%define d_xec (ro + 9432)
%define d_xdr (ro + 9440)
%define d_xdg (ro + 9448)
%define d_qp0 (ro + 9464)
%define d_qp1 (ro + 9472)
%define d_qp2 (ro + 9480)
%define d_qp3 (ro + 9488)
%define d_qp4 (ro + 9496)
%define d_qp5 (ro + 9504)
%define d_ql0 (ro + 9512)
%define d_ql1 (ro + 9520)
%define d_ql2 (ro + 9528)
%define d_ql3 (ro + 9536)
%define d_ql4 (ro + 9544)
%define d_qe0 (ro + 9552)
%define d_qe1 (ro + 9560)
%define d_qe2 (ro + 9568)
%define d_qe3 (ro + 9576)
%define d_qe4 (ro + 9584)
%define d_q2x0 (ro + 9592)
%define d_q2x1 (ro + 9600)
%define d_q2x2 (ro + 9608)
%define d_q2x3 (ro + 9616)
%define d_q2x4 (ro + 9624)
%define d_p1m0 (ro + 9632)
%define d_p1m1 (ro + 9640)
%define d_p1m2 (ro + 9648)
%define d_p1m3 (ro + 9656)
%define d_p1m4 (ro + 9664)
%define d_emc0 (ro + 9672)
%define d_emc1 (ro + 9680)
%define d_emc2 (ro + 9688)
%define d_emc3 (ro + 9696)
%define d_emc6 (ro + 9696)
%define d_emc4 (ro + 9704)
%define d_emc5 (ro + 9712)
%define d_emc7 (ro + 9720)
%define d_emc8 (ro + 9728)
%define d_iot (ro + 9760)
%define d_pi1 (ro + 9792)
%define d_po (ro + 9824)
%define d_yp (ro + 9856)

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
    mov [rsp + 6752], r6
    mov [rsp + 6760], r1
    mov [rsp + 6768], r0
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
    vpmovzxwd ymm0, [r2 + r3 + W + CRD*0]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vmovaps [r4 + r3*8 + 8*W + 0], ymm0
    vpmovzxwd ymm1, [r2 + r3 + W + CRD*1]
    vpsubd ymm1, ymm1, [c_i512]
    vcvtdq2ps ymm1, ymm1
    vmovaps [r4 + r3*8 + 8*W + 32], ymm1
    add r3, 16
    jnz .cpe
    vpmovzxwd ymm0, [r2 + W + CRD*0]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vmovaps [r4 + 8*W + 0], ymm0
    vbroadcastss ymm0, [r4 + 0]
    vmovaps [r4 + -128], ymm0
    vpmovzxwd ymm1, [r2 + W + CRD*1]
    vpsubd ymm1, ymm1, [c_i512]
    vcvtdq2ps ymm1, ymm1
    vmovaps [r4 + 8*W + 32], ymm1
    vbroadcastss ymm1, [r4 + 32]
    vmovaps [r4 + -96], ymm1
    mov r3, -8*W
.cpo:
    vmovaps ymm0, [r4 + r3 + 8*W + 0]
    vmovaps ymm1, [r4 + r3 + 8*W + 128]
    vperm2f128 ymm2, ymm0, [r4 + r3 + 8*W + -128], 3
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
    vperm2f128 ymm2, ymm0, [r4 + r3 + 8*W + -96], 3
    vpalignr ymm2, ymm0, ymm2, 12
    vperm2f128 ymm3, ymm0, ymm1, 0x21
    vpalignr ymm4, ymm3, ymm0, 4
    vpalignr ymm3, ymm3, ymm0, 8
    vaddps ymm4, ymm4, ymm0
    vaddps ymm2, ymm2, ymm3
    vmulps ymm2, ymm2, [c_h0625]
    vfmsub132ps ymm4, ymm2, [c_h5625]
    vmovaps [r4 + r3 + 8*W + 96], ymm4
    add r3, 128
    jnz .cpo
    add r2, CST
    add r4, SPBC
    dec r5d
    jnz .cpr
    lea r4, [rsp + SLT]
    mov r3, -8*W
.cpc:
    vmovaps ymm0, [r4 + r3 + 8*W + 2*SPBC + 0]
    vmovaps [r4 + r3 + 8*W + 0], ymm0
    vmovaps [r4 + r3 + 8*W + SPBC + 0], ymm0
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
    vmovdqu ymm0, [r2 + r3 + CRD*0 - CST]
    vmovdqu [r2 + r3 + CRD*0], ymm0
    vmovdqu [r2 + r3 + CRD*0 + CST], ymm0
    vmovdqu ymm0, [r2 + r3 + CRD*1 - CST]
    vmovdqu [r2 + r3 + CRD*1], ymm0
    vmovdqu [r2 + r3 + CRD*1 + CST], ymm0
    add r3, 32
    jnz .cpb
    vxorps ymm0, ymm0, ymm0
    vmovaps [rsp + BMS + 0], ymm0
    vmovaps [rsp + BMS + 32], ymm0
    vmovaps [rsp + BMS + 64], ymm0
    vmovaps [rsp + BMS + 96], ymm0
    vmovaps [rsp + BMS + 128], ymm0
    vmovaps [rsp + BMS + 160], ymm0
    vmovaps [rsp + BMS + 192], ymm0
    vmovaps [rsp + BMS + 224], ymm0
    vmovaps [rsp + BMS + 256], ymm0
    vmovaps [rsp + BMS + 288], ymm0
    vmovaps [rsp + BMS + 320], ymm0
    vmovaps [rsp + BMS + 352], ymm0
    vmovaps [rsp + BMS + 384], ymm0
    vmovaps [rsp + BMS + 416], ymm0
    vmovaps [rsp + BMS + 448], ymm0
    vmovaps [rsp + BMS + 480], ymm0
    vmovaps [rsp + BMS + 512], ymm0
    vmovaps [rsp + BMS + 544], ymm0
    vmovaps [rsp + BMS + 576], ymm0
    vmovaps [rsp + BMS + 608], ymm0
    vmovaps [rsp + BMS + 640], ymm0
    vmovaps [rsp + BMS + 672], ymm0
    vmovaps [rsp + BMS + 704], ymm0
    vmovaps [rsp + BMS + 736], ymm0
    vmovaps [rsp + BMS + 768], ymm0
    vmovaps [rsp + BMS + 800], ymm0
    vmovaps [rsp + BMS + 832], ymm0
    vmovaps [rsp + BMS + 864], ymm0
    vmovaps [rsp + BMS + 896], ymm0
    vmovaps [rsp + BMS + 928], ymm0
    vmovaps [rsp + BMS + 960], ymm0
    vmovaps [rsp + BMS + 992], ymm0
    vmovaps [rsp + BMS + 1024], ymm0
    vmovaps [rsp + BMS + 1056], ymm0
    vmovaps [rsp + BMS + 1088], ymm0
    vmovaps [rsp + BMS + 1120], ymm0
    vmovaps [rsp + BMS + 1152], ymm0
    vmovaps [rsp + BMS + 1184], ymm0
    vmovaps [rsp + BMS + 1216], ymm0
    vmovaps [rsp + BMS + 1248], ymm0
    vmovaps [rsp + BMS + 1280], ymm0
    vmovaps [rsp + BMS + 1312], ymm0
    vmovaps [rsp + BMS + 1344], ymm0
    vmovaps [rsp + BMS + 1376], ymm0
    mov qword [rsp + STX+5120], 0
    lea r6, [rsp + BMS]
    lea r2, [rsp + BMS + 704]
    xor r6, r2
    mov [rsp + 6776], r6
    lea r1, [r0 + 2*W]
    lea r5, [rsp + SLT + 2*SPBC]
    mov r3, -(W/2)
.rz:
    vmovups ymm15, [c_krh]
    vmovups ymm14, [c_krl]
    vmovups ymm13, [c_grh]
    vmovups ymm12, [c_grl]
    vmovups ymm11, [c_gbh]
    vmovups ymm0, [r1+r3*4]
    vmovups ymm1, [r5]
    vmovups ymm2, [r5+32]
    vpsubw ymm3, ymm0, [c_n64w]
    vmulps ymm4, ymm1, [c_gbl]
    vpslld ymm5, ymm3, 16
    vpsrad ymm6, ymm3, 16
    vpsrad ymm7, ymm5, 12
    vpslld ymm8, ymm6, 4
    vmovups ymm9, [r5+64]
    vcvtdq2ps ymm10, ymm7
    vcvtdq2ps ymm0, ymm8
    vfmadd231ps ymm4, ymm2, ymm12
    vmovups ymm3, [r5+96]
    vmovaps ymm5, ymm10
    vfmadd231ps ymm5, ymm2, ymm15
    vmovaps ymm6, ymm10
    vfnmadd231ps ymm6, ymm2, ymm13
    vfmadd231ps ymm10, ymm1, [c_kbh]
    vmulps ymm7, ymm9, [c_gbl]
    vfmadd231ps ymm5, ymm2, ymm14
    vfnmadd231ps ymm6, ymm1, ymm11
    vfmadd231ps ymm10, ymm1, [c_kbl]
    vmovaps ymm8, ymm0
    vfmadd231ps ymm8, ymm3, ymm15
    vfmadd231ps ymm7, ymm3, ymm12
    vmovups ymm2, [r1+r3*4+32]
    vsubps ymm1, ymm6, ymm4
    vmovaps [rsp], ymm5
    vmovaps ymm6, ymm0
    vfnmadd231ps ymm6, ymm3, ymm13
    vfmadd231ps ymm0, ymm9, [c_kbh]
    vmovaps [rsp+64], ymm10
    vfmadd231ps ymm8, ymm3, ymm14
    vmovaps [rsp+32], ymm1
    vmovups ymm4, [r5+128]
    vmovups ymm5, [r5+160]
    vfnmadd231ps ymm6, ymm9, ymm11
    vfmadd231ps ymm0, ymm9, [c_kbl]
    vmovaps [rsp+384], ymm8
    vpsubw ymm10, ymm2, [c_n64w]
    vpslld ymm3, ymm10, 16
    vpsrad ymm1, ymm10, 16
    vpsrad ymm9, ymm3, 12
    vpslld ymm8, ymm1, 4
    vsubps ymm2, ymm6, ymm7
    vmovaps [rsp+448], ymm0
    vcvtdq2ps ymm10, ymm9
    vcvtdq2ps ymm3, ymm8
    vmulps ymm1, ymm4, [c_gbl]
    vmovups ymm6, [r5+192]
    vmovaps [rsp+416], ymm2
    vmovups ymm7, [r5+224]
    vmovaps ymm0, ymm10
    vfmadd231ps ymm0, ymm5, ymm15
    vmovaps ymm9, ymm10
    vfnmadd231ps ymm9, ymm5, ymm13
    vfmadd231ps ymm1, ymm5, ymm12
    jmp .j64
.j64:
    vfmadd231ps ymm10, ymm4, [c_kbh]
    vfmadd231ps ymm0, ymm5, ymm14
    vfnmadd231ps ymm9, ymm4, ymm11
    vfmadd231ps ymm10, ymm4, [c_kbl]
    vmulps ymm8, ymm6, [c_gbl]
    vfmadd213ps ymm15, ymm7, ymm3
    vfnmadd213ps ymm13, ymm7, ymm3
    vfmadd231ps ymm3, ymm6, [c_kbh]
    vsubps ymm2, ymm9, ymm1
    vmovaps [rsp+768], ymm0
    vfmadd231ps ymm8, ymm7, ymm12
    vmovaps [rsp+832], ymm10
    vmovaps [rsp+800], ymm2
    vfmadd231ps ymm15, ymm7, ymm14
    vfnmadd231ps ymm13, ymm6, ymm11
    vfmadd231ps ymm3, ymm6, [c_kbl]
    vsubps ymm5, ymm13, ymm8
    vmovaps [rsp+1152], ymm15
    vmovaps [rsp+1216], ymm3
    vmovaps [rsp+1184], ymm5
    vmovups ymm15, [c_one]
    vmovups ymm14, [c_sign]
    vmovups ymm13, [c_aq]
    vmovups ymm12, [c_flq]
    vmovups ymm11, [c_rq8]
    vandnps ymm0, ymm14, [rsp]
    vmovups ymm1, [c_pu2]
    vpmaxsd ymm2, ymm0, ymm12
    vandnps ymm3, ymm14, [rsp+32]
    vmovups ymm4, [c_pu2]
    vpsrld ymm5, ymm2, 20
    vandps ymm6, ymm2, [c_mant]
    vpsrld ymm7, ymm2, 23
    vpmaxsd ymm8, ymm3, ymm12
    vorps ymm9, ymm6, ymm15
    vpermps ymm10, ymm5, ymm11
    vpslld ymm0, ymm2, 5
    vpslld ymm3, ymm2, 4
    vpermps ymm6, ymm7, [c_uq1]
    vpermps ymm2, ymm5, [c_vq8]
    vfmsub213ps ymm9, ymm10, ymm15
    vpermps ymm5, ymm7, [c_uq2]
    vpermps ymm10, ymm7, [c_uq0]
    vblendvps ymm7, ymm6, ymm5, ymm0
    vfmadd231ps ymm1, ymm9, [c_pu3]
    vpsrld ymm6, ymm8, 20
    vandps ymm5, ymm8, [c_mant]
    vblendvps ymm0, ymm7, ymm10, ymm3
    vmovaps ymm7, ymm9
    vfmadd231ps ymm7, ymm2, ymm9
    vorps ymm10, ymm5, ymm15
    vpermps ymm3, ymm6, ymm11
    vpermps ymm5, ymm6, [c_vq8]
    vfmadd213ps ymm1, ymm9, [c_pu1]
    vfmsub213ps ymm10, ymm3, ymm15
    vpsrld ymm6, ymm8, 23
    vfmadd213ps ymm1, ymm9, [c_pu0]
    vpslld ymm3, ymm8, 5
    vpslld ymm9, ymm8, 4
    vfmadd231ps ymm4, ymm10, [c_pu3]
    vfmadd231ps ymm2, ymm7, ymm1
    vmovaps ymm8, ymm0
    vfmsub213ps ymm8, ymm15, [c_c1q]
    vpermps ymm7, ymm6, [c_uq1]
    jmp .j128
.j128:
    vfmadd213ps ymm4, ymm10, [c_pu1]
    vfmadd231ps ymm0, ymm8, ymm2
    vpermps ymm1, ymm6, [c_uq2]
    vpermps ymm8, ymm6, [c_uq0]
    vfmadd213ps ymm4, ymm10, [c_pu0]
    vfmadd231ps ymm10, ymm5, ymm10
    vandnps ymm2, ymm14, [rsp+64]
    vpmaxsd ymm6, ymm2, ymm12
    vdivps ymm2, ymm13, ymm0
    vblendvps ymm0, ymm7, ymm1, ymm3
    vpsrld ymm7, ymm6, 20
    vandps ymm1, ymm6, [c_mant]
    vblendvps ymm3, ymm0, ymm8, ymm9
    vfmadd231ps ymm5, ymm10, ymm4
    vorps ymm0, ymm1, ymm15
    vpermps ymm8, ymm7, ymm11
    vmovups ymm9, [c_pu2]
    vmovaps ymm10, ymm3
    vfmsub213ps ymm10, ymm15, [c_c1q]
    vpsrld ymm4, ymm6, 23
    vpermps ymm1, ymm7, [c_vq8]
    vfmsub213ps ymm0, ymm8, ymm15
    vpslld ymm7, ymm6, 5
    vpslld ymm8, ymm6, 4
    vfmadd231ps ymm3, ymm10, ymm5
    vpermps ymm6, ymm4, [c_uq1]
    vpermps ymm10, ymm4, [c_uq2]
    vpermps ymm5, ymm4, [c_uq0]
    vfmadd231ps ymm9, ymm0, [c_pu3]
    vfmsub213ps ymm2, ymm15, [c_bq]
    vdivps ymm4, ymm13, ymm3
    vblendvps ymm3, ymm6, ymm10, ymm7
    vmovaps ymm6, ymm0
    vfmadd231ps ymm6, ymm1, ymm0
    vandnps ymm10, ymm14, [rsp+384]
    vblendvps ymm7, ymm3, ymm5, ymm8
    vpmaxsd ymm3, ymm10, ymm12
    vmovups ymm5, [c_pu2]
    vandnps ymm8, ymm14, [rsp+416]
    vfmadd213ps ymm9, ymm0, [c_pu1]
    vpmaxsd ymm10, ymm8, ymm12
    vmovaps [rsp+1536], ymm2
    vpsrld ymm8, ymm3, 20
    vfmadd213ps ymm9, ymm0, [c_pu0]
    vandps ymm2, ymm3, [c_mant]
    vorps ymm0, ymm2, ymm15
    vfmsub213ps ymm4, ymm15, [c_bq]
    vfmadd231ps ymm1, ymm6, ymm9
    vmovaps ymm2, ymm7
    vfmsub213ps ymm2, ymm15, [c_c1q]
    vpermps ymm6, ymm8, ymm11
    vpermps ymm9, ymm8, [c_vq8]
    vmovaps [rsp+1568], ymm4
    vpsrld ymm8, ymm3, 23
    vfmadd231ps ymm7, ymm2, ymm1
    vfmsub213ps ymm0, ymm6, ymm15
    vpslld ymm4, ymm3, 5
    vpslld ymm2, ymm3, 4
    vmovups ymm1, [c_pu2]
    vpermps ymm6, ymm8, [c_uq1]
    vdivps ymm3, ymm13, ymm7
    vfmadd231ps ymm5, ymm0, [c_pu3]
    vfmadd213ps ymm5, ymm0, [c_pu1]
    vfmadd213ps ymm5, ymm0, [c_pu0]
    jmp .j192
.j192:
    vfmadd231ps ymm0, ymm9, ymm0
    vfmsub213ps ymm3, ymm15, [c_bq]
    vfmadd231ps ymm9, ymm0, ymm5
    vpsrld ymm7, ymm10, 20
    vandps ymm0, ymm10, [c_mant]
    vorps ymm5, ymm0, ymm15
    vmovaps [rsp+1600], ymm3
    vpermps ymm0, ymm8, [c_uq2]
    vpermps ymm3, ymm8, [c_uq0]
    vblendvps ymm8, ymm6, ymm0, ymm4
    vpermps ymm6, ymm7, ymm11
    vpsrld ymm0, ymm10, 23
    vpermps ymm4, ymm7, [c_vq8]
    vblendvps ymm7, ymm8, ymm3, ymm2
    vpslld ymm8, ymm10, 5
    vpslld ymm3, ymm10, 4
    vpermps ymm2, ymm0, [c_uq1]
    vfmsub213ps ymm5, ymm6, ymm15
    vpermps ymm10, ymm0, [c_uq2]
    vpermps ymm6, ymm0, [c_uq0]
    vblendvps ymm0, ymm2, ymm10, ymm8
    vfmadd231ps ymm1, ymm5, [c_pu3]
    vandnps ymm2, ymm14, [rsp+448]
    vmovaps ymm10, ymm7
    vfmsub213ps ymm10, ymm15, [c_c1q]
    vblendvps ymm8, ymm0, ymm6, ymm3
    vpmaxsd ymm0, ymm2, ymm12
    vmovups ymm6, [c_pu2]
    vpsrld ymm3, ymm0, 20
    vfmadd213ps ymm1, ymm5, [c_pu1]
    vfmadd231ps ymm7, ymm10, ymm9
    vmovaps ymm2, ymm5
    vfmadd231ps ymm2, ymm4, ymm5
    vandps ymm10, ymm0, [c_mant]
    vorps ymm9, ymm10, ymm15
    vfmadd213ps ymm1, ymm5, [c_pu0]
    vpermps ymm10, ymm3, ymm11
    vpermps ymm5, ymm3, [c_vq8]
    vdivps ymm3, ymm13, ymm7
    vfmadd231ps ymm4, ymm2, ymm1
    vmovaps ymm7, ymm8
    vfmsub213ps ymm7, ymm15, [c_c1q]
    vpsrld ymm2, ymm0, 23
    vfmsub213ps ymm9, ymm10, ymm15
    vpslld ymm1, ymm0, 5
    vpslld ymm10, ymm0, 4
    vfmadd231ps ymm8, ymm7, ymm4
    vpermps ymm0, ymm2, [c_uq1]
    vpermps ymm7, ymm2, [c_uq2]
    vpermps ymm4, ymm2, [c_uq0]
    vfmadd231ps ymm6, ymm9, [c_pu3]
    vfmsub213ps ymm3, ymm15, [c_bq]
    vdivps ymm2, ymm13, ymm8
    vblendvps ymm8, ymm0, ymm7, ymm1
    vandnps ymm0, ymm14, [rsp+768]
    vmovups ymm7, [c_pu2]
    vblendvps ymm1, ymm8, ymm4, ymm10
    vfmadd213ps ymm6, ymm9, [c_pu1]
    vpmaxsd ymm8, ymm0, ymm12
    vandnps ymm4, ymm14, [rsp+800]
    vpsrld ymm10, ymm8, 20
    vpmaxsd ymm0, ymm4, ymm12
    vmovaps [rsp+1920], ymm3
    vandps ymm4, ymm8, [c_mant]
    jmp .j256
.j256:
    vorps ymm3, ymm4, ymm15
    vfmadd213ps ymm6, ymm9, [c_pu0]
    vfmadd231ps ymm9, ymm5, ymm9
    vfmadd231ps ymm5, ymm9, ymm6
    vmovaps ymm4, ymm1
    vfmsub213ps ymm4, ymm15, [c_c1q]
    vpermps ymm9, ymm10, ymm11
    vfmsub213ps ymm2, ymm15, [c_bq]
    vpermps ymm6, ymm10, [c_vq8]
    vfmadd231ps ymm1, ymm4, ymm5
    vfmsub213ps ymm3, ymm9, ymm15
    vpsrld ymm10, ymm8, 23
    vpslld ymm4, ymm8, 5
    vmovups ymm5, [c_pu2]
    vmovaps [rsp+1952], ymm2
    vpslld ymm9, ymm8, 4
    vpermps ymm2, ymm10, [c_uq1]
    vdivps ymm8, ymm13, ymm1
    vfmadd231ps ymm7, ymm3, [c_pu3]
    vfmadd213ps ymm7, ymm3, [c_pu1]
    vfmadd213ps ymm7, ymm3, [c_pu0]
    vfmadd231ps ymm3, ymm6, ymm3
    vfmsub213ps ymm8, ymm15, [c_bq]
    vfmadd231ps ymm6, ymm3, ymm7
    vpsrld ymm1, ymm0, 20
    vandps ymm3, ymm0, [c_mant]
    vorps ymm7, ymm3, ymm15
    vmovaps [rsp+1984], ymm8
    vpermps ymm3, ymm10, [c_uq2]
    vpermps ymm8, ymm10, [c_uq0]
    vblendvps ymm10, ymm2, ymm3, ymm4
    vpermps ymm2, ymm1, ymm11
    vpsrld ymm3, ymm0, 23
    vpermps ymm4, ymm1, [c_vq8]
    vblendvps ymm1, ymm10, ymm8, ymm9
    vpslld ymm10, ymm0, 5
    vpslld ymm8, ymm0, 4
    vpermps ymm9, ymm3, [c_uq1]
    vfmsub213ps ymm7, ymm2, ymm15
    vpermps ymm0, ymm3, [c_uq2]
    vpermps ymm2, ymm3, [c_uq0]
    vblendvps ymm3, ymm9, ymm0, ymm10
    vfmadd231ps ymm5, ymm7, [c_pu3]
    vandnps ymm9, ymm14, [rsp+832]
    vmovaps ymm0, ymm1
    vfmsub213ps ymm0, ymm15, [c_c1q]
    vblendvps ymm10, ymm3, ymm2, ymm8
    vpmaxsd ymm3, ymm9, ymm12
    vmovups ymm2, [c_pu2]
    vpsrld ymm8, ymm3, 20
    vfmadd213ps ymm5, ymm7, [c_pu1]
    vfmadd231ps ymm1, ymm0, ymm6
    vmovaps ymm9, ymm7
    vfmadd231ps ymm9, ymm4, ymm7
    vandps ymm0, ymm3, [c_mant]
    vorps ymm6, ymm0, ymm15
    vfmadd213ps ymm5, ymm7, [c_pu0]
    vpermps ymm0, ymm8, ymm11
    vpermps ymm7, ymm8, [c_vq8]
    vdivps ymm8, ymm13, ymm1
    vfmadd231ps ymm4, ymm9, ymm5
    vmovaps ymm1, ymm10
    vfmsub213ps ymm1, ymm15, [c_c1q]
    vpsrld ymm9, ymm3, 23
    jmp .j320
.j320:
    vfmsub213ps ymm6, ymm0, ymm15
    vpslld ymm5, ymm3, 5
    vpslld ymm0, ymm3, 4
    vfmadd231ps ymm10, ymm1, ymm4
    vpermps ymm3, ymm9, [c_uq1]
    vpermps ymm1, ymm9, [c_uq2]
    vpermps ymm4, ymm9, [c_uq0]
    vfmadd231ps ymm2, ymm6, [c_pu3]
    vfmsub213ps ymm8, ymm15, [c_bq]
    vdivps ymm9, ymm13, ymm10
    vblendvps ymm10, ymm3, ymm1, ymm5
    vandnps ymm3, ymm14, [rsp+1152]
    vmovups ymm1, [c_pu2]
    vblendvps ymm5, ymm10, ymm4, ymm0
    vfmadd213ps ymm2, ymm6, [c_pu1]
    vpmaxsd ymm10, ymm3, ymm12
    vandnps ymm4, ymm14, [rsp+1184]
    vpsrld ymm0, ymm10, 20
    vpmaxsd ymm3, ymm4, ymm12
    vmovaps [rsp+2304], ymm8
    vandps ymm4, ymm10, [c_mant]
    vorps ymm8, ymm4, ymm15
    vfmadd213ps ymm2, ymm6, [c_pu0]
    vfmadd231ps ymm6, ymm7, ymm6
    vfmadd231ps ymm7, ymm6, ymm2
    vmovaps ymm4, ymm5
    vfmsub213ps ymm4, ymm15, [c_c1q]
    vpermps ymm6, ymm0, ymm11
    vfmsub213ps ymm9, ymm15, [c_bq]
    vpermps ymm2, ymm0, [c_vq8]
    vfmadd231ps ymm5, ymm4, ymm7
    vfmsub213ps ymm8, ymm6, ymm15
    vpsrld ymm0, ymm10, 23
    vpslld ymm4, ymm10, 5
    vmovups ymm7, [c_pu2]
    vmovaps [rsp+2336], ymm9
    vpslld ymm6, ymm10, 4
    vpermps ymm9, ymm0, [c_uq1]
    vandnps ymm10, ymm14, [rsp+1216]
    vpmaxsd ymm14, ymm10, ymm12
    vpermps ymm10, ymm0, [c_uq2]
    vpermps ymm12, ymm0, [c_uq0]
    vdivps ymm0, ymm13, ymm5
    vfmadd231ps ymm1, ymm8, [c_pu3]
    vblendvps ymm5, ymm9, ymm10, ymm4
    vmovaps ymm9, ymm8
    vfmadd231ps ymm9, ymm2, ymm8
    vpsrld ymm10, ymm3, 20
    vblendvps ymm4, ymm5, ymm12, ymm6
    vfmadd213ps ymm1, ymm8, [c_pu1]
    vandps ymm5, ymm3, [c_mant]
    vpermps ymm12, ymm10, ymm11
    vorps ymm6, ymm5, ymm15
    vpermps ymm5, ymm10, [c_vq8]
    vfmadd213ps ymm1, ymm8, [c_pu0]
    vfmsub213ps ymm6, ymm12, ymm15
    vpsrld ymm10, ymm3, 23
    vpslld ymm8, ymm3, 5
    vpslld ymm12, ymm3, 4
    vfmsub213ps ymm0, ymm15, [c_bq]
    vfmadd231ps ymm2, ymm9, ymm1
    vmovaps ymm3, ymm4
    vfmsub213ps ymm3, ymm15, [c_c1q]
    vpermps ymm9, ymm10, [c_uq1]
    jmp .j384
.j384:
    vfmadd231ps ymm7, ymm6, [c_pu3]
    vmovaps [rsp+2368], ymm0
    vpermps ymm1, ymm10, [c_uq2]
    vpermps ymm0, ymm10, [c_uq0]
    vfmadd231ps ymm4, ymm3, ymm2
    vmovaps ymm10, ymm6
    vfmadd231ps ymm10, ymm5, ymm6
    vpsrld ymm3, ymm14, 20
    vfmadd213ps ymm7, ymm6, [c_pu1]
    vpermps ymm2, ymm3, ymm11
    vpermps ymm11, ymm3, [c_vq8]
    vblendvps ymm3, ymm9, ymm1, ymm8
    vandps ymm9, ymm14, [c_mant]
    vpsrld ymm1, ymm14, 23
    vblendvps ymm8, ymm3, ymm0, ymm12
    vorps ymm3, ymm9, ymm15
    vpslld ymm0, ymm14, 5
    vpslld ymm12, ymm14, 4
    vmovups ymm9, [c_pu2]
    vdivps ymm14, ymm13, ymm4
    vfmadd213ps ymm7, ymm6, [c_pu0]
    vfmsub213ps ymm3, ymm2, ymm15
    vpermps ymm4, ymm1, [c_uq1]
    vpermps ymm6, ymm1, [c_uq2]
    vpermps ymm2, ymm1, [c_uq0]
    vfmadd231ps ymm5, ymm10, ymm7
    vmovaps ymm1, ymm8
    vfmsub213ps ymm1, ymm15, [c_c1q]
    vblendvps ymm10, ymm4, ymm6, ymm0
    vfmadd231ps ymm9, ymm3, [c_pu3]
    vblendvps ymm7, ymm10, ymm2, ymm12
    vmovaps ymm4, ymm3
    vfmadd231ps ymm4, ymm11, ymm3
    vmovaps ymm6, ymm7
    vfmsub213ps ymm6, ymm15, [c_c1q]
    vfmadd231ps ymm8, ymm1, ymm5
    vfmsub213ps ymm14, ymm15, [c_bq]
    vfmadd213ps ymm9, ymm3, [c_pu1]
    vdivps ymm0, ymm13, ymm8
    vmovaps [rsp+2688], ymm14
    vfmadd213ps ymm9, ymm3, [c_pu0]
    vfmadd231ps ymm11, ymm4, ymm9
    vfmadd231ps ymm7, ymm6, ymm11
    vfmsub213ps ymm0, ymm15, [c_bq]
    vdivps ymm10, ymm13, ymm7
    vmovaps [rsp+2720], ymm0
    vfmsub213ps ymm10, ymm15, [c_bq]
    vmovaps [rsp+2752], ymm10
    vmovups ymm15, [c_one]
    vmovups ymm14, [c_sign]
    vmovups ymm13, [c_t68]
    vmovups ymm12, [c_w68]
    vmovups ymm11, [c_rq8]
    vmovups ymm0, [rsp+1536]
    vmovups ymm1, [c_q62]
    vandps ymm2, ymm14, [rsp]
    vmovups ymm3, [rsp+1568]
    vpsrld ymm4, ymm0, 20
    vpsrld ymm5, ymm0, 23
    vandps ymm6, ymm0, [c_mant]
    vpermps ymm7, ymm5, ymm13
    vpermps ymm8, ymm4, ymm12
    vorps ymm9, ymm6, ymm15
    vpermps ymm10, ymm4, ymm11
    jmp .j448
.j448:
    vpsrld ymm0, ymm3, 20
    vpsrld ymm5, ymm3, 23
    vandps ymm6, ymm3, [c_mant]
    vpermps ymm4, ymm5, ymm13
    vpermps ymm3, ymm0, ymm12
    vorps ymm5, ymm6, ymm15
    vpermps ymm6, ymm0, ymm11
    vmulps ymm0, ymm7, ymm8
    vmovups ymm7, [c_q62]
    vfmsub213ps ymm9, ymm10, ymm15
    vandps ymm8, ymm14, [rsp+32]
    vmulps ymm10, ymm4, ymm3
    vmovups ymm4, [rsp+1600]
    vfmsub213ps ymm5, ymm6, ymm15
    vfmadd231ps ymm1, ymm9, [c_q63]
    vmulps ymm3, ymm0, ymm9
    vfmadd231ps ymm7, ymm5, [c_q63]
    vfmadd213ps ymm1, ymm9, [c_q61]
    vfmadd213ps ymm7, ymm5, [c_q61]
    vfmadd213ps ymm1, ymm9, [c_q60]
    vmulps ymm6, ymm10, ymm5
    vfmadd213ps ymm7, ymm5, [c_q60]
    vpsrld ymm9, ymm4, 20
    vfmadd231ps ymm0, ymm3, ymm1
    vpsrld ymm5, ymm4, 23
    vpermps ymm3, ymm9, ymm12
    vandps ymm1, ymm4, [c_mant]
    vpermps ymm4, ymm5, ymm13
    vorps ymm5, ymm1, ymm15
    vpermps ymm1, ymm9, ymm11
    vfmadd231ps ymm10, ymm6, ymm7
    vmovups ymm9, [c_q62]
    vandps ymm6, ymm14, [rsp+64]
    vorps ymm7, ymm0, ymm2
    vmulps ymm0, ymm4, ymm3
    vfmsub213ps ymm5, ymm1, ymm15
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+0)], ymm7
    vorps ymm2, ymm10, ymm8
    vmovups ymm4, [rsp+1920]
    vpmaxud ymm3, ymm7, ymm2
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+32)], ymm2
    vfmadd231ps ymm9, ymm5, [c_q63]
    vmulps ymm1, ymm0, ymm5
    vfmadd213ps ymm9, ymm5, [c_q61]
    vpsrld ymm10, ymm4, 20
    vpsrld ymm8, ymm4, 23
    vandps ymm7, ymm4, [c_mant]
    vpermps ymm2, ymm8, ymm13
    vpermps ymm4, ymm10, ymm12
    vorps ymm8, ymm7, ymm15
    vpermps ymm7, ymm10, ymm11
    vfmadd213ps ymm9, ymm5, [c_q60]
    vmovups ymm10, [c_q62]
    vmulps ymm5, ymm2, ymm4
    vandps ymm2, ymm14, [rsp+384]
    vfmsub213ps ymm8, ymm7, ymm15
    vmovups ymm4, [rsp+1952]
    vfmadd231ps ymm0, ymm1, ymm9
    vmulps ymm7, ymm5, ymm8
    vfmadd231ps ymm10, ymm8, [c_q63]
    vorps ymm1, ymm0, ymm6
    vpmaxud ymm9, ymm3, ymm1
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+64)], ymm1
    vpsrld ymm0, ymm4, 20
    jmp .j512
.j512:
    vpsrld ymm6, ymm4, 23
    vandps ymm3, ymm4, [c_mant]
    vpminsd ymm1, ymm9, [c_zero]
    vpermps ymm4, ymm6, ymm13
    vpermps ymm9, ymm0, ymm12
    vorps ymm6, ymm3, ymm15
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+96)], ymm1
    vfmadd213ps ymm10, ymm8, [c_q61]
    vpermps ymm3, ymm0, ymm11
    vmovups ymm1, [c_q62]
    vmulps ymm0, ymm4, ymm9
    vandps ymm4, ymm14, [rsp+416]
    vfmadd213ps ymm10, ymm8, [c_q60]
    vfmsub213ps ymm6, ymm3, ymm15
    vmovups ymm9, [rsp+1984]
    vfmadd231ps ymm5, ymm7, ymm10
    vfmadd231ps ymm1, ymm6, [c_q63]
    vmulps ymm8, ymm0, ymm6
    vmovups ymm3, [c_q62]
    vpsrld ymm7, ymm9, 20
    vorps ymm10, ymm5, ymm2
    vfmadd213ps ymm1, ymm6, [c_q61]
    vpsrld ymm5, ymm9, 23
    vandps ymm2, ymm9, [c_mant]
    vpermps ymm9, ymm5, ymm13
    vorps ymm5, ymm2, ymm15
    vfmadd213ps ymm1, ymm6, [c_q60]
    vpermps ymm2, ymm7, ymm12
    vpermps ymm6, ymm7, ymm11
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+0)], ymm10
    vfmadd231ps ymm0, ymm8, ymm1
    vmulps ymm7, ymm9, ymm2
    vandps ymm8, ymm14, [rsp+448]
    vfmsub213ps ymm5, ymm6, ymm15
    vmovups ymm1, [rsp+2304]
    vorps ymm9, ymm0, ymm4
    vfmadd231ps ymm3, ymm5, [c_q63]
    vmulps ymm2, ymm7, ymm5
    vpmaxud ymm6, ymm10, ymm9
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+32)], ymm9
    vpsrld ymm0, ymm1, 20
    vpsrld ymm4, ymm1, 23
    vandps ymm10, ymm1, [c_mant]
    vfmadd213ps ymm3, ymm5, [c_q61]
    vpermps ymm9, ymm4, ymm13
    vpermps ymm1, ymm0, ymm12
    vorps ymm4, ymm10, ymm15
    vpermps ymm10, ymm0, ymm11
    vfmadd213ps ymm3, ymm5, [c_q60]
    vmulps ymm0, ymm9, ymm1
    vmovups ymm5, [c_q62]
    vfmsub213ps ymm4, ymm10, ymm15
    vandps ymm9, ymm14, [rsp+768]
    vmovups ymm1, [rsp+2336]
    vfmadd231ps ymm7, ymm2, ymm3
    vmulps ymm10, ymm0, ymm4
    vfmadd231ps ymm5, ymm4, [c_q63]
    vorps ymm2, ymm7, ymm8
    vpsrld ymm3, ymm1, 20
    vpsrld ymm7, ymm1, 23
    vandps ymm8, ymm1, [c_mant]
    vpmaxud ymm1, ymm6, ymm2
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+64)], ymm2
    vpermps ymm6, ymm7, ymm13
    jmp .j576
.j576:
    vpermps ymm2, ymm3, ymm12
    vorps ymm7, ymm8, ymm15
    vpminsd ymm8, ymm1, [c_zero]
    vpermps ymm1, ymm3, ymm11
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+96)], ymm8
    vfmadd213ps ymm5, ymm4, [c_q61]
    vmovups ymm3, [c_q62]
    vmulps ymm8, ymm6, ymm2
    vandps ymm6, ymm14, [rsp+800]
    vfmsub213ps ymm7, ymm1, ymm15
    vmovups ymm2, [rsp+2368]
    vfmadd213ps ymm5, ymm4, [c_q60]
    vfmadd231ps ymm3, ymm7, [c_q63]
    vmulps ymm1, ymm8, ymm7
    vfmadd231ps ymm0, ymm10, ymm5
    vmovups ymm4, [c_q62]
    vpsrld ymm10, ymm2, 20
    vfmadd213ps ymm3, ymm7, [c_q61]
    vorps ymm5, ymm0, ymm9
    vpsrld ymm0, ymm2, 23
    vandps ymm9, ymm2, [c_mant]
    vpermps ymm2, ymm0, ymm13
    vorps ymm0, ymm9, ymm15
    vfmadd213ps ymm3, ymm7, [c_q60]
    vpermps ymm9, ymm10, ymm12
    vpermps ymm7, ymm10, ymm11
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+0)], ymm5
    vfmadd231ps ymm8, ymm1, ymm3
    vmulps ymm10, ymm2, ymm9
    vandps ymm1, ymm14, [rsp+832]
    vfmsub213ps ymm0, ymm7, ymm15
    vmovups ymm3, [rsp+2688]
    vorps ymm2, ymm8, ymm6
    vfmadd231ps ymm4, ymm0, [c_q63]
    vmulps ymm9, ymm10, ymm0
    vpmaxud ymm7, ymm5, ymm2
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+32)], ymm2
    vpsrld ymm8, ymm3, 20
    vpsrld ymm6, ymm3, 23
    vandps ymm5, ymm3, [c_mant]
    vfmadd213ps ymm4, ymm0, [c_q61]
    vpermps ymm2, ymm6, ymm13
    vpermps ymm3, ymm8, ymm12
    vorps ymm6, ymm5, ymm15
    vpermps ymm5, ymm8, ymm11
    vfmadd213ps ymm4, ymm0, [c_q60]
    vmulps ymm8, ymm2, ymm3
    vmovups ymm0, [c_q62]
    vfmsub213ps ymm6, ymm5, ymm15
    vandps ymm2, ymm14, [rsp+1152]
    vmovups ymm3, [rsp+2720]
    vfmadd231ps ymm10, ymm9, ymm4
    vmulps ymm5, ymm8, ymm6
    vfmadd231ps ymm0, ymm6, [c_q63]
    vorps ymm9, ymm10, ymm1
    vpsrld ymm4, ymm3, 20
    vpsrld ymm10, ymm3, 23
    vandps ymm1, ymm3, [c_mant]
    vpmaxud ymm3, ymm7, ymm9
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+64)], ymm9
    vpermps ymm7, ymm10, ymm13
    vpermps ymm9, ymm4, ymm12
    vorps ymm10, ymm1, ymm15
    vpminsd ymm1, ymm3, [c_zero]
    jmp .j640
.j640:
    vpermps ymm3, ymm4, ymm11
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+96)], ymm1
    vfmadd213ps ymm0, ymm6, [c_q61]
    vmovups ymm4, [c_q62]
    vmulps ymm1, ymm7, ymm9
    vandps ymm7, ymm14, [rsp+1184]
    vfmsub213ps ymm10, ymm3, ymm15
    vmovups ymm9, [rsp+2752]
    vfmadd213ps ymm0, ymm6, [c_q60]
    vfmadd231ps ymm4, ymm10, [c_q63]
    vmulps ymm3, ymm1, ymm10
    vfmadd231ps ymm8, ymm5, ymm0
    vmovups ymm6, [c_q62]
    vpsrld ymm5, ymm9, 20
    vfmadd213ps ymm4, ymm10, [c_q61]
    vpermps ymm0, ymm5, ymm12
    vpermps ymm12, ymm5, ymm11
    vorps ymm5, ymm8, ymm2
    vpsrld ymm11, ymm9, 23
    vandps ymm8, ymm9, [c_mant]
    vandps ymm2, ymm14, [rsp+1216]
    vpermps ymm9, ymm11, ymm13
    vorps ymm14, ymm8, ymm15
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+0)], ymm5
    vfmadd213ps ymm4, ymm10, [c_q60]
    vfmsub231ps ymm15, ymm14, ymm12
    vmulps ymm11, ymm9, ymm0
    vfmadd231ps ymm1, ymm3, ymm4
    vfmadd231ps ymm6, ymm15, [c_q63]
    vmulps ymm13, ymm11, ymm15
    vorps ymm8, ymm1, ymm7
    vfmadd213ps ymm6, ymm15, [c_q61]
    vpmaxud ymm10, ymm5, ymm8
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+32)], ymm8
    vfmadd213ps ymm6, ymm15, [c_q60]
    vfmadd231ps ymm11, ymm13, ymm6
    vorps ymm14, ymm11, ymm2
    vpmaxud ymm12, ymm10, ymm14
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+64)], ymm14
    vpminsd ymm9, ymm12, [c_zero]
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+96)], ymm9
    add r5, 256
    add r3, 16
    jnz .rz
    mov r1, [rsp + 6760]
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
    vpmovzxwd ymm0, [r0 + CST*0+CRD*0 - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8 + SPBC*0+0], ymm0
    vmovaps [r8 + SPBC*0+0 - 128], ymm1
    vpmovzxwd ymm0, [r0 + CST*0+CRD*1 - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8 + SPBC*0+32], ymm0
    vmovaps [r8 + SPBC*0+32 - 128], ymm1
    vpmovzxwd ymm0, [r0 + CST*1+CRD*0 - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8 + SPBC*1+0], ymm0
    vmovaps [r8 + SPBC*1+0 - 128], ymm1
    vpmovzxwd ymm0, [r0 + CST*1+CRD*1 - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8 + SPBC*1+32], ymm0
    vmovaps [r8 + SPBC*1+32 - 128], ymm1
    vxorps ymm0, ymm0, ymm0
    vmovaps [rsp + 6528], ymm0
    vmovaps [rsp + 6560], ymm0
    vmovaps [rsp + 6592], ymm0
    vmovaps [rsp + 6624], ymm0
    vmovups ymm0, [c_s2]
    vmovaps [rsp + 6656], ymm0
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
    vpmovzxwd ymm0, [r0 + CST*0+CRD*0 - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8 + SPBC*0+0], ymm0
    vmovaps [r8 + SPBC*0+0 - 128], ymm1
    vpmovzxwd ymm0, [r0 + CST*0+CRD*1 - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8 + SPBC*0+32], ymm0
    vmovaps [r8 + SPBC*0+32 - 128], ymm1
    vpmovzxwd ymm0, [r0 + CST*1+CRD*0 - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8 + SPBC*1+0], ymm0
    vmovaps [r8 + SPBC*1+0 - 128], ymm1
    vpmovzxwd ymm0, [r0 + CST*1+CRD*1 - W]
    vpsubd ymm0, ymm0, [c_i512]
    vcvtdq2ps ymm0, ymm0
    vbroadcastss ymm1, xmm0
    vmovaps [r8 + SPBC*1+32], ymm0
    vmovaps [r8 + SPBC*1+32 - 128], ymm1
    vxorps ymm0, ymm0, ymm0
    vmovaps [rsp + 6528], ymm0
    vmovaps [rsp + 6560], ymm0
    vmovaps [rsp + 6592], ymm0
    vmovaps [rsp + 6624], ymm0
    vmovups ymm0, [c_s2]
    vmovaps [rsp + 6656], ymm0
    mov r3, -(W/2)
    ALIGN 64
.pair:
.g_v:
    vmovups ymm15, [c_krh]
    vmovups ymm14, [c_krl]
    vmovups ymm13, [c_grh]
    vmovups ymm12, [c_grl]
    vmovups ymm11, [c_gbh]
    vmovups ymm10, [c_gbl]
    vmovups ymm9, [c_kbh]
    vmovups ymm0, [r1+r3*4+(0+2*W*0)]
    vmovups ymm1, [r5]
    vmovups ymm2, [r5+32]
    vpsubw ymm3, ymm0, [c_n64w]
    vpslld ymm4, ymm3, 16
    vpsrad ymm5, ymm3, 16
    vpsrad ymm6, ymm4, 12
    vpslld ymm7, ymm5, 4
    vcvtdq2ps ymm8, ymm6
    vcvtdq2ps ymm0, ymm7
    vmulps ymm3, ymm1, ymm10
    vmovaps ymm4, ymm8
    vfmadd231ps ymm4, ymm2, ymm15
    vmovaps ymm5, ymm8
    vfnmadd231ps ymm5, ymm2, ymm13
    vfmadd231ps ymm3, ymm2, ymm12
    jmp .j704
    ALIGN 64
.j704:
    vfmadd231ps ymm8, ymm1, ymm9
    vmovups ymm6, [r5+64]
    vfmadd231ps ymm4, ymm2, ymm14
    vfnmadd231ps ymm5, ymm1, ymm11
    vmovups ymm7, [r5+96]
    vfmadd231ps ymm8, ymm1, [c_kbl]
    vsubps ymm2, ymm5, ymm3
    vmovaps [rsp], ymm4
    vmovaps [rsp+64], ymm8
    vmulps ymm1, ymm6, ymm10
    vmovaps [rsp+32], ymm2
    vmovaps ymm5, ymm0
    vfmadd231ps ymm5, ymm6, ymm9
    vmovaps ymm3, ymm0
    vfmadd231ps ymm3, ymm7, ymm15
    vfnmadd231ps ymm0, ymm7, ymm13
    vfmadd231ps ymm1, ymm7, ymm12
    vmovups ymm4, [r1+r3*4+(0+2*W*1)]
    vfmadd231ps ymm5, ymm6, [c_kbl]
    vfmadd231ps ymm3, ymm7, ymm14
    vfnmadd231ps ymm0, ymm6, ymm11
    vmovaps [rsp+448], ymm5
    vsubps ymm8, ymm0, ymm1
    vmovaps [rsp+384], ymm3
    vpsubw ymm2, ymm4, [c_n64w]
    vmovaps [rsp+416], ymm8
    vpslld ymm7, ymm2, 16
    vpsrad ymm6, ymm2, 16
    vmovups ymm5, [r5]
    vpsrad ymm0, ymm7, 12
    vpslld ymm1, ymm6, 4
    vmovups ymm3, [r5+(0+SPBC)]
    vmovups ymm4, [r7]
    vcvtdq2ps ymm8, ymm0
    vcvtdq2ps ymm2, ymm1
    vmovups ymm7, [r5+32]
    vmovups ymm6, [r5+(32+SPBC)]
    vmovups ymm0, [r7+32]
    vaddps ymm1, ymm5, ymm3
    vaddps ymm5, ymm4, [r4+(0+SPBC)]
    vaddps ymm3, ymm7, ymm6
    vmulps ymm4, ymm5, [c_h0625]
    vaddps ymm7, ymm0, [r4+(32+SPBC)]
    vmulps ymm6, ymm7, [c_h0625]
    vfmsub231ps ymm4, ymm1, [c_h5625]
    vfmsub231ps ymm6, ymm3, [c_h5625]
    vmulps ymm5, ymm4, ymm10
    vmovaps ymm0, ymm8
    vfmadd231ps ymm0, ymm4, ymm9
    vmovaps ymm7, ymm8
    vfmadd231ps ymm7, ymm6, ymm15
    vfnmadd231ps ymm8, ymm6, ymm13
    vfmadd231ps ymm5, ymm6, ymm12
    vfmadd231ps ymm0, ymm4, [c_kbl]
    vmovups ymm1, [r5+64]
    vfmadd231ps ymm7, ymm6, ymm14
    vfnmadd231ps ymm8, ymm4, ymm11
    vmovups ymm3, [r5+(64+SPBC)]
    vmovups ymm6, [r7+64]
    vmovaps [rsp+160], ymm0
    vmovups ymm4, [r5+96]
    vsubps ymm0, ymm8, ymm5
    vmovaps [rsp+96], ymm7
    vmovups ymm8, [r5+(96+SPBC)]
    jmp .j768
    ALIGN 64
.j768:
    vmovups ymm5, [r7+96]
    vmovaps [rsp+128], ymm0
    vaddps ymm7, ymm1, ymm3
    vaddps ymm0, ymm6, [r4+(64+SPBC)]
    vmulps ymm1, ymm0, [c_h0625]
    vaddps ymm3, ymm4, ymm8
    vaddps ymm6, ymm5, [r4+(96+SPBC)]
    vfmsub231ps ymm1, ymm7, [c_h5625]
    vmulps ymm0, ymm6, [c_h0625]
    vfmsub231ps ymm0, ymm3, [c_h5625]
    vmulps ymm4, ymm1, ymm10
    vmovaps ymm8, ymm2
    vfmadd231ps ymm8, ymm1, ymm9
    vmovaps ymm5, ymm2
    vfmadd231ps ymm5, ymm0, ymm15
    vfnmadd231ps ymm2, ymm0, ymm13
    vfmadd231ps ymm4, ymm0, ymm12
    vfmadd231ps ymm8, ymm1, [c_kbl]
    vmovups ymm7, [r1+r3*4+(0+2*W*2)]
    vfmadd231ps ymm5, ymm0, ymm14
    vfnmadd231ps ymm2, ymm1, ymm11
    vmovaps [rsp+544], ymm8
    vsubps ymm6, ymm2, ymm4
    vmovaps [rsp+480], ymm5
    vpsubw ymm3, ymm7, [c_n64w]
    vmovaps [rsp+512], ymm6
    vpslld ymm0, ymm3, 16
    vpsrad ymm1, ymm3, 16
    vmovups ymm8, [r5+(0+SPBC)]
    vpsrad ymm2, ymm0, 12
    vpslld ymm4, ymm1, 4
    vmovups ymm5, [r5+(32+SPBC)]
    vcvtdq2ps ymm7, ymm2
    vcvtdq2ps ymm6, ymm4
    vmulps ymm3, ymm8, ymm10
    vmovaps ymm0, ymm7
    vfmadd231ps ymm0, ymm8, ymm9
    vmovaps ymm1, ymm7
    vfmadd231ps ymm1, ymm5, ymm15
    vfnmadd231ps ymm7, ymm5, ymm13
    vfmadd231ps ymm3, ymm5, ymm12
    vfmadd231ps ymm0, ymm8, [c_kbl]
    vmovups ymm2, [r5+(64+SPBC)]
    vfmadd231ps ymm1, ymm5, ymm14
    vfnmadd231ps ymm7, ymm8, ymm11
    vmovups ymm4, [r5+(96+SPBC)]
    vmovaps [rsp+256], ymm0
    vsubps ymm5, ymm7, ymm3
    vmovaps [rsp+192], ymm1
    vmovaps [rsp+224], ymm5
    vmulps ymm8, ymm2, ymm10
    vmovaps ymm0, ymm6
    vfmadd231ps ymm0, ymm4, ymm15
    vmovaps ymm7, ymm6
    vfnmadd231ps ymm7, ymm4, ymm13
    vfmadd231ps ymm6, ymm2, ymm9
    vfmadd231ps ymm8, ymm4, ymm12
    vmovups ymm3, [r1+r3*4+(0+2*W*3)]
    vfmadd231ps ymm0, ymm4, ymm14
    vfnmadd231ps ymm7, ymm2, ymm11
    vfmadd231ps ymm6, ymm2, [c_kbl]
    vsubps ymm1, ymm7, ymm8
    vmovaps [rsp+576], ymm0
    vmovaps [rsp+640], ymm6
    jmp .j832
    ALIGN 64
.j832:
    vmovaps [rsp+608], ymm1
    vpsubw ymm5, ymm3, [c_n64w]
    vpslld ymm4, ymm5, 16
    vpsrad ymm2, ymm5, 16
    vmovups ymm7, [r5+(0+SPBC)]
    vmovups ymm8, [r7]
    vpsrad ymm0, ymm4, 12
    vpslld ymm6, ymm2, 4
    vmovups ymm1, [r5]
    vcvtdq2ps ymm3, ymm0
    vcvtdq2ps ymm5, ymm6
    vmovups ymm4, [r5+(32+SPBC)]
    vmovups ymm2, [r7+32]
    vmovups ymm0, [r5+32]
    vaddps ymm6, ymm7, ymm8
    vaddps ymm7, ymm1, [r7+(0+SPBC)]
    vaddps ymm8, ymm4, ymm2
    vmulps ymm1, ymm7, [c_h0625]
    vaddps ymm4, ymm0, [r7+(32+SPBC)]
    vmulps ymm2, ymm4, [c_h0625]
    vfmsub231ps ymm1, ymm6, [c_h5625]
    vfmsub231ps ymm2, ymm8, [c_h5625]
    vmulps ymm7, ymm1, ymm10
    vmovaps ymm0, ymm3
    vfmadd231ps ymm0, ymm1, ymm9
    vmovaps ymm4, ymm3
    vfmadd231ps ymm4, ymm2, ymm15
    vfnmadd231ps ymm3, ymm2, ymm13
    vfmadd231ps ymm7, ymm2, ymm12
    vfmadd231ps ymm0, ymm1, [c_kbl]
    vmovups ymm6, [r5+(64+SPBC)]
    vfmadd231ps ymm4, ymm2, ymm14
    vfnmadd231ps ymm3, ymm1, ymm11
    vmovups ymm8, [r7+64]
    vmovups ymm2, [r5+64]
    vmovaps [rsp+352], ymm0
    vmovups ymm1, [r5+(96+SPBC)]
    vsubps ymm0, ymm3, ymm7
    vmovaps [rsp+288], ymm4
    vmovups ymm3, [r7+96]
    vmovups ymm7, [r5+96]
    vmovaps [rsp+320], ymm0
    vaddps ymm4, ymm6, ymm8
    vaddps ymm0, ymm2, [r7+(64+SPBC)]
    vmulps ymm6, ymm0, [c_h0625]
    vaddps ymm8, ymm1, ymm3
    vaddps ymm2, ymm7, [r7+(96+SPBC)]
    vfmsub231ps ymm6, ymm4, [c_h5625]
    vmulps ymm0, ymm2, [c_h0625]
    vfmsub231ps ymm0, ymm8, [c_h5625]
    vmulps ymm1, ymm6, ymm10
    vmovaps ymm3, ymm5
    vfmadd231ps ymm3, ymm6, ymm9
    vmovaps ymm7, ymm5
    vfmadd231ps ymm7, ymm0, ymm15
    vfnmadd231ps ymm5, ymm0, ymm13
    vfmadd231ps ymm1, ymm0, ymm12
    vfmadd231ps ymm3, ymm6, [c_kbl]
    vmovups ymm4, [r1+r3*4+(32+2*W*0)]
    vfmadd231ps ymm7, ymm0, ymm14
    vfnmadd231ps ymm5, ymm6, ymm11
    vmovaps [rsp+736], ymm3
    vsubps ymm2, ymm5, ymm1
    vmovaps [rsp+672], ymm7
    jmp .j896
    ALIGN 64
.j896:
    vpsubw ymm8, ymm4, [c_n64w]
    vmovaps [rsp+704], ymm2
    vpslld ymm0, ymm8, 16
    vpsrad ymm6, ymm8, 16
    vmovups ymm3, [r5+128]
    vpsrad ymm5, ymm0, 12
    vpslld ymm1, ymm6, 4
    vmovups ymm7, [r5+160]
    vcvtdq2ps ymm4, ymm5
    vcvtdq2ps ymm2, ymm1
    vmulps ymm8, ymm3, ymm10
    vmovaps ymm0, ymm4
    vfmadd231ps ymm0, ymm3, ymm9
    vmovaps ymm6, ymm4
    vfmadd231ps ymm6, ymm7, ymm15
    vfnmadd231ps ymm4, ymm7, ymm13
    vfmadd231ps ymm8, ymm7, ymm12
    vfmadd231ps ymm0, ymm3, [c_kbl]
    vmovups ymm5, [r5+192]
    vfmadd231ps ymm6, ymm7, ymm14
    vfnmadd231ps ymm4, ymm3, ymm11
    vmovups ymm1, [r5+224]
    vmovaps [rsp+832], ymm0
    vsubps ymm7, ymm4, ymm8
    vmovaps [rsp+768], ymm6
    vmovaps [rsp+800], ymm7
    vmulps ymm3, ymm5, ymm10
    vmovaps ymm0, ymm2
    vfmadd231ps ymm0, ymm1, ymm15
    vmovaps ymm4, ymm2
    vfnmadd231ps ymm4, ymm1, ymm13
    vfmadd231ps ymm2, ymm5, ymm9
    vfmadd231ps ymm3, ymm1, ymm12
    vmovups ymm8, [r1+r3*4+(32+2*W*1)]
    vfmadd231ps ymm0, ymm1, ymm14
    vfnmadd231ps ymm4, ymm5, ymm11
    vfmadd231ps ymm2, ymm5, [c_kbl]
    vsubps ymm6, ymm4, ymm3
    vmovaps [rsp+1152], ymm0
    vmovaps [rsp+1216], ymm2
    vmovaps [rsp+1184], ymm6
    vpsubw ymm7, ymm8, [c_n64w]
    vpslld ymm1, ymm7, 16
    vpsrad ymm5, ymm7, 16
    vmovups ymm4, [r5+128]
    vmovups ymm3, [r5+(128+SPBC)]
    vpsrad ymm0, ymm1, 12
    vpslld ymm2, ymm5, 4
    vmovups ymm6, [r7+128]
    vcvtdq2ps ymm8, ymm0
    vcvtdq2ps ymm7, ymm2
    vmovups ymm1, [r5+160]
    vmovups ymm5, [r5+(160+SPBC)]
    vmovups ymm0, [r7+160]
    vaddps ymm2, ymm4, ymm3
    vaddps ymm4, ymm6, [r4+(128+SPBC)]
    vaddps ymm3, ymm1, ymm5
    vmulps ymm6, ymm4, [c_h0625]
    vaddps ymm1, ymm0, [r4+(160+SPBC)]
    vmulps ymm5, ymm1, [c_h0625]
    vfmsub231ps ymm6, ymm2, [c_h5625]
    vfmsub231ps ymm5, ymm3, [c_h5625]
    vmulps ymm4, ymm6, ymm10
    vmovaps ymm0, ymm8
    jmp .j960
    ALIGN 64
.j960:
    vfmadd231ps ymm0, ymm6, ymm9
    vmovaps ymm1, ymm8
    vfmadd231ps ymm1, ymm5, ymm15
    vfnmadd231ps ymm8, ymm5, ymm13
    vfmadd231ps ymm4, ymm5, ymm12
    vfmadd231ps ymm0, ymm6, [c_kbl]
    vmovups ymm2, [r5+192]
    vfmadd231ps ymm1, ymm5, ymm14
    vfnmadd231ps ymm8, ymm6, ymm11
    vmovups ymm3, [r5+(192+SPBC)]
    vmovups ymm5, [r7+192]
    vmovaps [rsp+928], ymm0
    vmovups ymm6, [r5+224]
    vsubps ymm0, ymm8, ymm4
    vmovaps [rsp+864], ymm1
    vmovups ymm8, [r5+(224+SPBC)]
    vmovups ymm4, [r7+224]
    vmovaps [rsp+896], ymm0
    vaddps ymm1, ymm2, ymm3
    vaddps ymm0, ymm5, [r4+(192+SPBC)]
    vmulps ymm2, ymm0, [c_h0625]
    vaddps ymm3, ymm6, ymm8
    vaddps ymm5, ymm4, [r4+(224+SPBC)]
    vfmsub231ps ymm2, ymm1, [c_h5625]
    vmulps ymm0, ymm5, [c_h0625]
    vfmsub231ps ymm0, ymm3, [c_h5625]
    vmulps ymm6, ymm2, ymm10
    vmovaps ymm8, ymm7
    vfmadd231ps ymm8, ymm2, ymm9
    vmovaps ymm4, ymm7
    vfmadd231ps ymm4, ymm0, ymm15
    vfnmadd231ps ymm7, ymm0, ymm13
    vfmadd231ps ymm6, ymm0, ymm12
    vfmadd231ps ymm8, ymm2, [c_kbl]
    vmovups ymm1, [r1+r3*4+(32+2*W*2)]
    vfmadd231ps ymm4, ymm0, ymm14
    vfnmadd231ps ymm7, ymm2, ymm11
    vmovaps [rsp+1312], ymm8
    vsubps ymm5, ymm7, ymm6
    vmovaps [rsp+1248], ymm4
    vpsubw ymm3, ymm1, [c_n64w]
    vmovaps [rsp+1280], ymm5
    vpslld ymm0, ymm3, 16
    vpsrad ymm2, ymm3, 16
    vmovups ymm8, [r5+(128+SPBC)]
    vpsrad ymm7, ymm0, 12
    vpslld ymm6, ymm2, 4
    vmovups ymm4, [r5+(160+SPBC)]
    vcvtdq2ps ymm1, ymm7
    vcvtdq2ps ymm5, ymm6
    vmulps ymm3, ymm8, ymm10
    vmovaps ymm0, ymm1
    vfmadd231ps ymm0, ymm8, ymm9
    vmovaps ymm2, ymm1
    vfmadd231ps ymm2, ymm4, ymm15
    vfnmadd231ps ymm1, ymm4, ymm13
    vfmadd231ps ymm3, ymm4, ymm12
    vfmadd231ps ymm0, ymm8, [c_kbl]
    vmovups ymm7, [r5+(192+SPBC)]
    vfmadd231ps ymm2, ymm4, ymm14
    vfnmadd231ps ymm1, ymm8, ymm11
    vmovups ymm6, [r5+(224+SPBC)]
    vmovaps [rsp+1024], ymm0
    vsubps ymm4, ymm1, ymm3
    jmp .j1024
    ALIGN 64
.j1024:
    vmovaps [rsp+960], ymm2
    vmovaps [rsp+992], ymm4
    vmulps ymm8, ymm7, ymm10
    vmovaps ymm0, ymm5
    vfmadd231ps ymm0, ymm6, ymm15
    vmovaps ymm1, ymm5
    vfnmadd231ps ymm1, ymm6, ymm13
    vfmadd231ps ymm5, ymm7, ymm9
    vfmadd231ps ymm8, ymm6, ymm12
    vmovups ymm3, [r1+r3*4+(32+2*W*3)]
    vfmadd231ps ymm0, ymm6, ymm14
    vfnmadd231ps ymm1, ymm7, ymm11
    vfmadd231ps ymm5, ymm7, [c_kbl]
    vsubps ymm2, ymm1, ymm8
    vmovaps [rsp+1344], ymm0
    vmovaps [rsp+1408], ymm5
    vmovaps [rsp+1376], ymm2
    vpsubw ymm4, ymm3, [c_n64w]
    vpslld ymm6, ymm4, 16
    vpsrad ymm7, ymm4, 16
    vmovups ymm1, [r5+(128+SPBC)]
    vmovups ymm8, [r7+128]
    vpsrad ymm0, ymm6, 12
    vpslld ymm5, ymm7, 4
    vmovups ymm2, [r5+128]
    vcvtdq2ps ymm3, ymm0
    vcvtdq2ps ymm4, ymm5
    vmovups ymm6, [r5+(160+SPBC)]
    vmovups ymm7, [r7+160]
    vmovups ymm0, [r5+160]
    vaddps ymm5, ymm1, ymm8
    vaddps ymm1, ymm2, [r7+(128+SPBC)]
    vaddps ymm8, ymm6, ymm7
    vmulps ymm2, ymm1, [c_h0625]
    vaddps ymm6, ymm0, [r7+(160+SPBC)]
    vmulps ymm7, ymm6, [c_h0625]
    vfmsub231ps ymm2, ymm5, [c_h5625]
    vfmsub231ps ymm7, ymm8, [c_h5625]
    vmulps ymm1, ymm2, ymm10
    vmovaps ymm0, ymm3
    vfmadd231ps ymm0, ymm2, ymm9
    vmovaps ymm6, ymm3
    vfmadd231ps ymm6, ymm7, ymm15
    vfnmadd231ps ymm3, ymm7, ymm13
    vfmadd231ps ymm1, ymm7, ymm12
    vfmadd231ps ymm0, ymm2, [c_kbl]
    vmovups ymm5, [r5+(192+SPBC)]
    vfmadd231ps ymm6, ymm7, ymm14
    vfnmadd231ps ymm3, ymm2, ymm11
    vmovups ymm8, [r7+192]
    vmovups ymm7, [r5+192]
    vmovaps [rsp+1120], ymm0
    vmovups ymm2, [r5+(224+SPBC)]
    vsubps ymm0, ymm3, ymm1
    vmovaps [rsp+1056], ymm6
    vmovups ymm3, [r7+224]
    vmovups ymm1, [r5+224]
    vmovaps [rsp+1088], ymm0
    vaddps ymm6, ymm5, ymm8
    vaddps ymm0, ymm7, [r7+(192+SPBC)]
    vmulps ymm5, ymm0, [c_h0625]
    vaddps ymm8, ymm2, ymm3
    vaddps ymm7, ymm1, [r7+(224+SPBC)]
    vfmsub231ps ymm5, ymm6, [c_h5625]
    jmp .j1088
    ALIGN 64
.j1088:
    vmulps ymm0, ymm7, [c_h0625]
    vfmsub231ps ymm0, ymm8, [c_h5625]
    vmulps ymm2, ymm5, ymm10
    vfmadd213ps ymm9, ymm5, ymm4
    vfmadd213ps ymm15, ymm0, ymm4
    vfnmadd231ps ymm4, ymm0, ymm13
    vfmadd231ps ymm2, ymm0, ymm12
    vfmadd231ps ymm9, ymm5, [c_kbl]
    vfmadd231ps ymm15, ymm0, ymm14
    vfnmadd231ps ymm4, ymm5, ymm11
    vmovaps [rsp+1504], ymm9
    vsubps ymm3, ymm4, ymm2
    vmovaps [rsp+1440], ymm15
    vmovaps [rsp+1472], ymm3
.g_b1a:
    vmovups ymm15, [c_sign]
    vmovups ymm14, [c_rgl]
    vmovups ymm13, [c_xll]
    vmovups ymm12, [c_nieq]
    vmovups ymm11, [c_eqp]
    vmovups ymm0, [c_anl]
    vmovups ymm1, [c_tbl]
    vmovups ymm2, [c_anl]
    vmovups ymm3, [c_tbl]
    vandnps ymm4, ymm15, [r14]
    vandnps ymm5, ymm15, [r14+32]
    vandnps ymm6, ymm15, [r14+64]
    vfnmadd231ps ymm1, ymm0, [r14+96]
    vfnmadd231ps ymm3, ymm2, [r14+224]
    vmovaps ymm7, ymm1
    vfnmsub231ps ymm7, ymm14, ymm4
    vmovaps ymm8, ymm1
    vfnmsub231ps ymm8, ymm14, ymm5
    vfnmsub231ps ymm1, ymm14, ymm6
    vaddps ymm9, ymm4, ymm7
    vsubps ymm10, ymm7, ymm4
    vaddps ymm0, ymm5, ymm8
    vcmpps ymm2, ymm9, ymm13, 30
    vdivps ymm7, ymm7, ymm9
    vblendvps ymm9, ymm10, ymm4, ymm2
    vcmpps ymm10, ymm0, ymm13, 30
    vdivps ymm4, ymm8, ymm0
    vmovaps [rsp+4096], ymm9
    vsubps ymm0, ymm8, ymm5
    vaddps ymm9, ymm6, ymm1
    vblendvps ymm8, ymm0, ymm5, ymm10
    vcmpps ymm0, ymm9, ymm13, 30
    vdivps ymm5, ymm1, ymm9
    vmovaps [rsp+4192], ymm8
    vsubps ymm9, ymm1, ymm6
    vmovups ymm8, [c_anl]
    vblendvps ymm1, ymm9, ymm6, ymm0
    vmovups ymm9, [c_tbl]
    vmovaps [rsp+4288], ymm1
    vandnps ymm6, ymm15, [r14+128]
    vblendvps ymm1, ymm12, ymm7, ymm2
    vandnps ymm7, ymm15, [r14+160]
    vfnmadd213ps ymm1, ymm11, [c_oml0]
    vblendvps ymm2, ymm12, ymm4, ymm10
    vfnmadd213ps ymm2, ymm11, [c_oml1]
    vmovaps [rsp+4128], ymm1
    vblendvps ymm4, ymm12, ymm5, ymm0
    vfnmadd231ps ymm9, ymm8, [r14+352]
    vfnmadd213ps ymm4, ymm11, [c_oml2]
    vmovaps ymm10, ymm3
    jmp .j1152
    ALIGN 64
.j1152:
    vfnmsub231ps ymm10, ymm14, ymm6
    vandnps ymm1, ymm15, [r14+192]
    vmovaps [rsp+4224], ymm2
    vmovaps ymm5, ymm3
    vfnmsub231ps ymm5, ymm14, ymm7
    vfnmsub231ps ymm3, ymm14, ymm1
    vmovaps [rsp+4320], ymm4
    vaddps ymm0, ymm6, ymm10
    vsubps ymm8, ymm10, ymm6
    vaddps ymm2, ymm7, ymm5
    vcmpps ymm4, ymm0, ymm13, 30
    vdivps ymm10, ymm10, ymm0
    vblendvps ymm0, ymm8, ymm6, ymm4
    vcmpps ymm8, ymm2, ymm13, 30
    vdivps ymm6, ymm5, ymm2
    vmovaps [rsp+4384], ymm0
    vsubps ymm2, ymm5, ymm7
    vaddps ymm0, ymm1, ymm3
    vblendvps ymm5, ymm2, ymm7, ymm8
    vcmpps ymm2, ymm0, ymm13, 30
    vdivps ymm7, ymm3, ymm0
    vmovaps [rsp+4480], ymm5
    vsubps ymm0, ymm3, ymm1
    vmovups ymm5, [c_anl]
    vblendvps ymm3, ymm0, ymm1, ymm2
    vmovups ymm0, [c_tbl]
    vmovaps [rsp+4576], ymm3
    vandnps ymm1, ymm15, [r14+256]
    vblendvps ymm3, ymm12, ymm10, ymm4
    vandnps ymm10, ymm15, [r14+288]
    vfnmadd213ps ymm3, ymm11, [c_oml0]
    vblendvps ymm4, ymm12, ymm6, ymm8
    vfnmadd213ps ymm4, ymm11, [c_oml1]
    vmovaps [rsp+4416], ymm3
    vblendvps ymm6, ymm12, ymm7, ymm2
    vfnmadd231ps ymm0, ymm5, [r14+480]
    vfnmadd213ps ymm6, ymm11, [c_oml2]
    vmovaps ymm8, ymm9
    vfnmsub231ps ymm8, ymm14, ymm1
    vandnps ymm3, ymm15, [r14+320]
    vmovaps [rsp+4512], ymm4
    vmovaps ymm7, ymm9
    vfnmsub231ps ymm7, ymm14, ymm10
    vfnmsub231ps ymm9, ymm14, ymm3
    vmovaps [rsp+4608], ymm6
    vaddps ymm2, ymm1, ymm8
    vsubps ymm5, ymm8, ymm1
    vaddps ymm4, ymm10, ymm7
    vcmpps ymm6, ymm2, ymm13, 30
    vdivps ymm8, ymm8, ymm2
    vblendvps ymm2, ymm5, ymm1, ymm6
    vcmpps ymm5, ymm4, ymm13, 30
    vdivps ymm1, ymm7, ymm4
    vmovaps [rsp+4672], ymm2
    vsubps ymm4, ymm7, ymm10
    vaddps ymm2, ymm3, ymm9
    vblendvps ymm7, ymm4, ymm10, ymm5
    vcmpps ymm4, ymm2, ymm13, 30
    vdivps ymm10, ymm9, ymm2
    vmovaps [rsp+4768], ymm7
    vsubps ymm2, ymm9, ymm3
    vmovups ymm7, [c_anh]
    vblendvps ymm9, ymm2, ymm3, ymm4
    vmovups ymm2, [c_tbh]
    jmp .j1216
    ALIGN 64
.j1216:
    vmovaps [rsp+4864], ymm9
    vandnps ymm3, ymm15, [r14+384]
    vblendvps ymm9, ymm12, ymm8, ymm6
    vandnps ymm8, ymm15, [r14+416]
    vfnmadd213ps ymm9, ymm11, [c_oml0]
    vblendvps ymm6, ymm12, ymm1, ymm5
    vfnmadd213ps ymm6, ymm11, [c_oml1]
    vmovaps [rsp+4704], ymm9
    vblendvps ymm1, ymm12, ymm10, ymm4
    vfnmadd231ps ymm2, ymm7, [r14+608]
    vfnmadd213ps ymm1, ymm11, [c_oml2]
    vmovaps ymm5, ymm0
    vfnmsub231ps ymm5, ymm14, ymm3
    vandnps ymm9, ymm15, [r14+448]
    vmovaps [rsp+4800], ymm6
    vmovaps ymm10, ymm0
    vfnmsub231ps ymm10, ymm14, ymm8
    vfnmsub231ps ymm0, ymm14, ymm9
    vmovaps [rsp+4896], ymm1
    vaddps ymm4, ymm3, ymm5
    vsubps ymm7, ymm5, ymm3
    vaddps ymm6, ymm8, ymm10
    vsubps ymm14, ymm10, ymm8
    vcmpps ymm1, ymm4, ymm13, 30
    vdivps ymm5, ymm5, ymm4
    vdivps ymm4, ymm10, ymm6
    vblendvps ymm10, ymm7, ymm3, ymm1
    vcmpps ymm7, ymm6, ymm13, 30
    vaddps ymm3, ymm9, ymm0
    vmovaps [rsp+4960], ymm10
    vsubps ymm6, ymm0, ymm9
    vblendvps ymm10, ymm14, ymm8, ymm7
    vcmpps ymm14, ymm3, ymm13, 30
    vdivps ymm8, ymm0, ymm3
    vandnps ymm13, ymm15, [r14+512]
    vmovaps [rsp+5056], ymm10
    vmovaps ymm0, ymm2
    vfnmsub231ps ymm0, ymm13, [c_rgh]
    vandnps ymm3, ymm15, [r14+544]
    vblendvps ymm10, ymm6, ymm9, ymm14
    vmovaps [rsp+5152], ymm10
    vmovaps ymm6, ymm2
    vfnmsub231ps ymm6, ymm3, [c_rgh]
    vaddps ymm9, ymm13, ymm0
    vblendvps ymm10, ymm12, ymm5, ymm1
    vsubps ymm5, ymm0, ymm13
    vfnmadd213ps ymm10, ymm11, [c_oml0]
    vblendvps ymm1, ymm12, ymm4, ymm7
    vcmpps ymm4, ymm9, [c_xlh], 30
    vfnmadd213ps ymm1, ymm11, [c_oml1]
    vdivps ymm7, ymm0, ymm9
    vaddps ymm0, ymm3, ymm6
    vandnps ymm9, ymm15, [r14+576]
    vblendvps ymm15, ymm5, ymm13, ymm4
    vsubps ymm5, ymm6, ymm3
    vfnmsub231ps ymm2, ymm9, [c_rgh]
    vblendvps ymm13, ymm12, ymm8, ymm14
    vmovaps [rsp+5248], ymm15
    vcmpps ymm8, ymm0, [c_xlh], 30
    vdivps ymm14, ymm6, ymm0
    vmovaps [rsp+4992], ymm10
    vfnmadd213ps ymm13, ymm11, [c_oml2]
    vmovaps [rsp+5088], ymm1
    vblendvps ymm15, ymm5, ymm3, ymm8
    jmp .j1280
    ALIGN 64
.j1280:
    vmovaps [rsp+5344], ymm15
    vaddps ymm6, ymm9, ymm2
    vsubps ymm0, ymm2, ymm9
    vmovaps [rsp+5184], ymm13
    vcmpps ymm10, ymm6, [c_xlh], 30
    vdivps ymm1, ymm2, ymm6
    vblendvps ymm5, ymm0, ymm9, ymm10
    vblendvps ymm3, ymm12, ymm7, ymm4
    vmovaps [rsp+5440], ymm5
    vfnmadd213ps ymm3, ymm11, [c_omh0]
    vblendvps ymm15, ymm12, ymm14, ymm8
    vfnmadd213ps ymm15, ymm11, [c_omh1]
    vmovaps [rsp+5280], ymm3
    vmovaps [rsp+5376], ymm15
    vblendvps ymm13, ymm12, ymm1, ymm10
    vfnmadd213ps ymm11, ymm13, [c_omh2]
    vmovaps [rsp+5472], ymm11
.g_qa_b1b:
    vmovups ymm15, [c_one]
    vmovups ymm14, [c_sign]
    vmovups ymm13, [c_aq]
    vmovups ymm12, [c_flq]
    vmovups ymm11, [c_rq8]
    vmovups ymm10, [c_vq8]
    vandnps ymm0, ymm14, [rsp]
    vmovups ymm1, [rsp+4096]
    vpmaxsd ymm2, ymm0, ymm12
    vmovups ymm3, [c_pu2]
    vandnps ymm4, ymm14, [rsp+32]
    vpsrld ymm5, ymm2, 20
    vandps ymm6, ymm2, [c_mant]
    vpsrld ymm7, ymm2, 23
    vpmaxsd ymm8, ymm4, ymm12
    vorps ymm9, ymm6, ymm15
    vpermps ymm0, ymm5, ymm11
    vpermps ymm4, ymm5, ymm10
    vandnps ymm6, ymm14, ymm1
    vfmsub213ps ymm9, ymm0, ymm15
    vpslld ymm5, ymm2, 5
    vpmaxsd ymm0, ymm6, [c_xll]
    vpslld ymm6, ymm2, 4
    vpermps ymm2, ymm7, [c_uq1]
    vfmadd231ps ymm3, ymm9, [c_pu3]
    vfmadd213ps ymm3, ymm9, [c_pu1]
    vfmadd213ps ymm3, ymm9, [c_pu0]
    vfmadd231ps ymm9, ymm4, ymm9
    vfmadd231ps ymm4, ymm9, ymm3
    vpermps ymm9, ymm7, [c_uq2]
    vpermps ymm3, ymm7, [c_uq0]
    vpsrld ymm7, ymm1, 20
    vandps ymm1, ymm1, [c_mant]
    vorps ymm1, ymm1, ymm15
    vblendvps ymm2, ymm2, ymm9, ymm5
    vblendvps ymm9, ymm2, ymm3, ymm6
    vpsrld ymm5, ymm0, 23
    vpsrld ymm2, ymm0, 26
    vandps ymm3, ymm8, [c_mant]
    vpermps ymm6, ymm5, [c_tll]
    vpermps ymm0, ymm2, [c_thi]
    vorps ymm5, ymm3, ymm15
    vmovaps ymm2, ymm9
    vfmsub213ps ymm2, ymm15, [c_c1q]
    vmulps ymm3, ymm6, ymm0
    vfmadd231ps ymm9, ymm2, ymm4
    vpsrld ymm6, ymm8, 20
    jmp .j1344
    ALIGN 64
.j1344:
    vpermps ymm0, ymm7, [c_w1q]
    vpermps ymm2, ymm7, [c_r1q]
    vdivps ymm4, ymm13, ymm9
    vmulps ymm7, ymm3, ymm0
    vpslld ymm9, ymm8, 4
    vfmsub213ps ymm1, ymm2, ymm15
    vmovups ymm3, [c_q11]
    vfmadd231ps ymm3, ymm1, [c_q12]
    vfmsub213ps ymm4, ymm15, [c_bq]
    vfmadd213ps ymm3, ymm1, [c_q10]
    vmulps ymm0, ymm7, ymm1
    vmovaps [rsp+1536], ymm4
    vpermps ymm2, ymm6, ymm11
    vpermps ymm1, ymm6, ymm10
    vfmadd231ps ymm7, ymm0, ymm3
    vmovups ymm4, [c_pu2]
    vmovups ymm6, [c_s1q]
    vfmsub213ps ymm5, ymm2, ymm15
    vpsrld ymm0, ymm8, 23
    vpslld ymm3, ymm8, 5
    vpermps ymm2, ymm0, [c_uq1]
    vpermps ymm8, ymm0, [c_uq2]
    vpermps ymm0, ymm0, [c_uq0]
    vfnmsub231ps ymm6, ymm7, [c_c3]
    vblendvps ymm2, ymm2, ymm8, ymm3
    vsubps ymm8, ymm7, [c_s1q]
    vblendvps ymm3, ymm2, ymm0, ymm9
    vmovups ymm7, [c_pu2]
    vandnps ymm2, ymm14, [rsp+64]
    vpmaxsd ymm0, ymm2, ymm12
    vdivps ymm9, ymm8, ymm6
    vandnps ymm2, ymm14, [rsp+96]
    vpmaxsd ymm8, ymm2, ymm12
    vfmadd231ps ymm7, ymm5, [c_pu3]
    vfmadd213ps ymm7, ymm5, [c_pu1]
    vmovaps [rsp+4064], ymm9
    vmovups ymm6, [rsp+4192]
    vfmadd213ps ymm7, ymm5, [c_pu0]
    vfmadd231ps ymm5, ymm1, ymm5
    vfmadd231ps ymm1, ymm5, ymm7
    vmovaps ymm2, ymm3
    vfmsub213ps ymm2, ymm15, [c_c1q]
    vpsrld ymm9, ymm0, 20
    vfmadd231ps ymm3, ymm2, ymm1
    vandps ymm5, ymm0, [c_mant]
    vpermps ymm7, ymm9, ymm11
    vpermps ymm2, ymm9, ymm10
    vorps ymm1, ymm5, ymm15
    vdivps ymm9, ymm13, ymm3
    vfmsub213ps ymm1, ymm7, ymm15
    vpsrld ymm5, ymm0, 23
    vfmadd231ps ymm4, ymm1, [c_pu3]
    vfmadd213ps ymm4, ymm1, [c_pu1]
    vfmsub213ps ymm9, ymm15, [c_bq]
    vfmadd213ps ymm4, ymm1, [c_pu0]
    vfmadd231ps ymm1, ymm2, ymm1
    vmovaps [rsp+1568], ymm9
    vpslld ymm3, ymm0, 5
    vpslld ymm7, ymm0, 4
    vpermps ymm9, ymm5, [c_uq1]
    vpermps ymm0, ymm5, [c_uq2]
    vpermps ymm5, ymm5, [c_uq0]
    vfmadd231ps ymm2, ymm1, ymm4
    vblendvps ymm1, ymm9, ymm0, ymm3
    jmp .j1408
    ALIGN 64
.j1408:
    vpsrld ymm4, ymm8, 20
    vandps ymm9, ymm8, [c_mant]
    vblendvps ymm0, ymm1, ymm5, ymm7
    vorps ymm3, ymm9, ymm15
    vpermps ymm1, ymm4, ymm11
    vpsrld ymm5, ymm8, 23
    vmovaps ymm7, ymm0
    vfmsub213ps ymm7, ymm15, [c_c1q]
    vpermps ymm9, ymm4, ymm10
    vfmsub213ps ymm3, ymm1, ymm15
    vfmadd231ps ymm0, ymm7, ymm2
    vpslld ymm4, ymm8, 5
    vpslld ymm1, ymm8, 4
    vpermps ymm7, ymm5, [c_uq1]
    vdivps ymm2, ymm13, ymm0
    vfmsub213ps ymm2, ymm15, [c_bq]
    vmovaps [rsp+1600], ymm2
    vandnps ymm8, ymm14, ymm6
    vpermps ymm0, ymm5, [c_uq2]
    vpermps ymm2, ymm5, [c_uq0]
    vpmaxsd ymm5, ymm8, [c_xll]
    vblendvps ymm8, ymm7, ymm0, ymm4
    vmovups ymm7, [c_pu2]
    vblendvps ymm0, ymm8, ymm2, ymm1
    vpsrld ymm4, ymm6, 20
    vpsrld ymm8, ymm5, 23
    vandps ymm2, ymm6, [c_mant]
    vpermps ymm1, ymm8, [c_tll]
    vpsrld ymm6, ymm5, 26
    vorps ymm8, ymm2, ymm15
    vpermps ymm5, ymm6, [c_thi]
    vfmadd231ps ymm7, ymm3, [c_pu3]
    vmulps ymm2, ymm1, ymm5
    vpermps ymm6, ymm4, [c_w1q]
    vpermps ymm1, ymm4, [c_r1q]
    vfmadd213ps ymm7, ymm3, [c_pu1]
    vmulps ymm5, ymm2, ymm6
    vmovups ymm4, [c_pu2]
    vfmsub213ps ymm8, ymm1, ymm15
    vmovups ymm2, [c_q11]
    vfmadd213ps ymm7, ymm3, [c_pu0]
    vfmadd231ps ymm3, ymm9, ymm3
    vfmadd231ps ymm9, ymm3, ymm7
    vmovaps ymm6, ymm0
    vfmsub213ps ymm6, ymm15, [c_c1q]
    vandnps ymm1, ymm14, [rsp+128]
    vpmaxsd ymm3, ymm1, ymm12
    vfmadd231ps ymm2, ymm8, [c_q12]
    vfmadd231ps ymm0, ymm6, ymm9
    vpsrld ymm7, ymm3, 20
    vandps ymm1, ymm3, [c_mant]
    vorps ymm6, ymm1, ymm15
    vfmadd213ps ymm2, ymm8, [c_q10]
    vmulps ymm9, ymm5, ymm8
    vdivps ymm1, ymm13, ymm0
    vfmadd231ps ymm5, ymm9, ymm2
    vpermps ymm8, ymm7, ymm11
    vpsrld ymm0, ymm3, 23
    vpermps ymm9, ymm7, ymm10
    vfmsub213ps ymm6, ymm8, ymm15
    vpslld ymm2, ymm3, 5
    vpslld ymm7, ymm3, 4
    vfmsub213ps ymm1, ymm15, [c_bq]
    vfmadd231ps ymm4, ymm6, [c_pu3]
    jmp .j1472
    ALIGN 64
.j1472:
    vmovaps [rsp+1632], ymm1
    vpermps ymm8, ymm0, [c_uq1]
    vfmadd213ps ymm4, ymm6, [c_pu1]
    vpermps ymm3, ymm0, [c_uq2]
    vpermps ymm1, ymm0, [c_uq0]
    vfmadd213ps ymm4, ymm6, [c_pu0]
    vfmadd231ps ymm6, ymm9, ymm6
    vblendvps ymm0, ymm8, ymm3, ymm2
    vandnps ymm8, ymm14, [rsp+160]
    vblendvps ymm3, ymm0, ymm1, ymm7
    vpmaxsd ymm2, ymm8, ymm12
    vmovups ymm0, [c_pu2]
    vsubps ymm1, ymm5, [c_s1q]
    vfmadd231ps ymm9, ymm6, ymm4
    vmovaps ymm7, ymm3
    vfmsub213ps ymm7, ymm15, [c_c1q]
    vpsrld ymm8, ymm2, 20
    vfmadd231ps ymm3, ymm7, ymm9
    vandps ymm6, ymm2, [c_mant]
    vpermps ymm4, ymm8, ymm11
    vpermps ymm7, ymm8, ymm10
    vorps ymm9, ymm6, ymm15
    vdivps ymm8, ymm13, ymm3
    vfmsub213ps ymm9, ymm4, ymm15
    vpsrld ymm6, ymm2, 23
    vfmadd231ps ymm0, ymm9, [c_pu3]
    vfmadd213ps ymm0, ymm9, [c_pu1]
    vfmsub213ps ymm8, ymm15, [c_bq]
    vfmadd213ps ymm0, ymm9, [c_pu0]
    vfmadd231ps ymm9, ymm7, ymm9
    vmovaps [rsp+1664], ymm8
    vpslld ymm3, ymm2, 5
    vpslld ymm4, ymm2, 4
    vpermps ymm8, ymm6, [c_uq1]
    vpermps ymm2, ymm6, [c_uq2]
    vpermps ymm6, ymm6, [c_uq0]
    vfmadd231ps ymm7, ymm9, ymm0
    vblendvps ymm9, ymm8, ymm2, ymm3
    vmovups ymm0, [c_s1q]
    vandnps ymm8, ymm14, [rsp+384]
    vblendvps ymm2, ymm9, ymm6, ymm4
    vpmaxsd ymm3, ymm8, ymm12
    vmovups ymm9, [rsp+4288]
    vmovups ymm6, [c_pu2]
    vmovaps ymm4, ymm2
    vfmsub213ps ymm4, ymm15, [c_c1q]
    vfmadd231ps ymm2, ymm4, ymm7
    vpsrld ymm8, ymm3, 20
    vfnmsub231ps ymm0, ymm5, [c_c3]
    vandps ymm4, ymm3, [c_mant]
    vorps ymm7, ymm4, ymm15
    vdivps ymm5, ymm13, ymm2
    vdivps ymm4, ymm1, ymm0
    vpsrld ymm2, ymm3, 23
    vfmsub213ps ymm5, ymm15, [c_bq]
    vmovaps [rsp+4160], ymm4
    vpslld ymm1, ymm3, 4
    vpslld ymm0, ymm3, 5
    vmovaps [rsp+1696], ymm5
    vpermps ymm4, ymm8, ymm11
    vpermps ymm3, ymm8, ymm10
    vfmsub213ps ymm7, ymm4, ymm15
    vpermps ymm5, ymm2, [c_uq1]
    vpermps ymm8, ymm2, [c_uq2]
    jmp .j1536
    ALIGN 64
.j1536:
    vpermps ymm4, ymm2, [c_uq0]
    vfmadd231ps ymm6, ymm7, [c_pu3]
    vblendvps ymm2, ymm5, ymm8, ymm0
    vandnps ymm5, ymm14, ymm9
    vblendvps ymm8, ymm2, ymm4, ymm1
    vpmaxsd ymm0, ymm5, [c_xll]
    vmovaps ymm2, ymm7
    vfmadd231ps ymm2, ymm3, ymm7
    vpsrld ymm4, ymm9, 20
    vandps ymm1, ymm9, [c_mant]
    vfmadd213ps ymm6, ymm7, [c_pu1]
    vorps ymm5, ymm1, ymm15
    vfmadd213ps ymm6, ymm7, [c_pu0]
    vpsrld ymm9, ymm0, 23
    vpsrld ymm1, ymm0, 26
    vpermps ymm7, ymm9, [c_tll]
    vpermps ymm0, ymm1, [c_thi]
    vfmadd231ps ymm3, ymm2, ymm6
    vmovaps ymm9, ymm8
    vfmsub213ps ymm9, ymm15, [c_c1q]
    vandnps ymm1, ymm14, [rsp+416]
    vpmaxsd ymm2, ymm1, ymm12
    vmulps ymm6, ymm7, ymm0
    vmovups ymm1, [c_pu2]
    vfmadd231ps ymm8, ymm9, ymm3
    vpsrld ymm7, ymm2, 20
    vandps ymm0, ymm2, [c_mant]
    vorps ymm9, ymm0, ymm15
    vdivps ymm3, ymm13, ymm8
    vfmsub213ps ymm3, ymm15, [c_bq]
    vmovaps [rsp+1920], ymm3
    vpermps ymm0, ymm7, ymm11
    vpermps ymm8, ymm7, ymm10
    vfmsub213ps ymm9, ymm0, ymm15
    vpsrld ymm3, ymm2, 23
    vpslld ymm7, ymm2, 5
    vpslld ymm0, ymm2, 4
    vpermps ymm2, ymm3, [c_uq1]
    vfmadd231ps ymm1, ymm9, [c_pu3]
    vfmadd213ps ymm1, ymm9, [c_pu1]
    vfmadd213ps ymm1, ymm9, [c_pu0]
    vfmadd231ps ymm9, ymm8, ymm9
    vfmadd231ps ymm8, ymm9, ymm1
    vpermps ymm9, ymm3, [c_uq2]
    vpermps ymm1, ymm3, [c_uq0]
    vblendvps ymm3, ymm2, ymm9, ymm7
    vpermps ymm2, ymm4, [c_w1q]
    vpermps ymm9, ymm4, [c_r1q]
    vblendvps ymm7, ymm3, ymm1, ymm0
    vandnps ymm4, ymm14, [rsp+448]
    vmovups ymm3, [c_q11]
    vpmaxsd ymm1, ymm4, ymm12
    vmulps ymm0, ymm6, ymm2
    vpsrld ymm4, ymm1, 20
    vfmsub213ps ymm5, ymm9, ymm15
    vpsrld ymm6, ymm1, 23
    vmovaps ymm2, ymm7
    vfmsub213ps ymm2, ymm15, [c_c1q]
    vfmadd231ps ymm3, ymm5, [c_q12]
    vfmadd231ps ymm7, ymm2, ymm8
    vandps ymm9, ymm1, [c_mant]
    vorps ymm2, ymm9, ymm15
    vfmadd213ps ymm3, ymm5, [c_q10]
    vmulps ymm8, ymm0, ymm5
    jmp .j1600
    ALIGN 64
.j1600:
    vdivps ymm9, ymm13, ymm7
    vfmadd231ps ymm0, ymm8, ymm3
    vandnps ymm5, ymm14, [rsp+480]
    vmovups ymm7, [c_s1q]
    vpmaxsd ymm8, ymm5, ymm12
    vfmsub213ps ymm9, ymm15, [c_bq]
    vfnmsub231ps ymm7, ymm0, [c_c3]
    vsubps ymm3, ymm0, [c_s1q]
    vmovaps [rsp+1952], ymm9
    vpermps ymm5, ymm4, ymm11
    vpermps ymm0, ymm4, ymm10
    vdivps ymm9, ymm3, ymm7
    vmovups ymm4, [c_pu2]
    vfmsub213ps ymm2, ymm5, ymm15
    vpslld ymm3, ymm1, 5
    vpslld ymm7, ymm1, 4
    vpermps ymm5, ymm6, [c_uq1]
    vpermps ymm1, ymm6, [c_uq2]
    vpermps ymm6, ymm6, [c_uq0]
    vblendvps ymm5, ymm5, ymm1, ymm3
    vblendvps ymm1, ymm5, ymm6, ymm7
    vmovups ymm3, [c_pu2]
    vpsrld ymm5, ymm8, 20
    vmovaps [rsp+4256], ymm9
    vmovups ymm6, [rsp+4384]
    vfmadd231ps ymm3, ymm2, [c_pu3]
    vfmadd213ps ymm3, ymm2, [c_pu1]
    vfmadd213ps ymm3, ymm2, [c_pu0]
    vfmadd231ps ymm2, ymm0, ymm2
    vfmadd231ps ymm0, ymm2, ymm3
    vmovaps ymm7, ymm1
    vfmsub213ps ymm7, ymm15, [c_c1q]
    vandps ymm9, ymm8, [c_mant]
    vorps ymm2, ymm9, ymm15
    vfmadd231ps ymm1, ymm7, ymm0
    vpermps ymm3, ymm5, ymm11
    vpsrld ymm9, ymm8, 23
    vpermps ymm7, ymm5, ymm10
    vdivps ymm0, ymm13, ymm1
    vfmsub213ps ymm2, ymm3, ymm15
    vpslld ymm5, ymm8, 5
    vpslld ymm1, ymm8, 4
    vfmadd231ps ymm4, ymm2, [c_pu3]
    vfmadd213ps ymm4, ymm2, [c_pu1]
    vfmsub213ps ymm0, ymm15, [c_bq]
    vfmadd213ps ymm4, ymm2, [c_pu0]
    vfmadd231ps ymm2, ymm7, ymm2
    vmovaps [rsp+1984], ymm0
    vpermps ymm3, ymm9, [c_uq1]
    vpermps ymm8, ymm9, [c_uq2]
    vpermps ymm0, ymm9, [c_uq0]
    vfmadd231ps ymm7, ymm2, ymm4
    vandnps ymm9, ymm14, [rsp+512]
    vpmaxsd ymm2, ymm9, ymm12
    vblendvps ymm4, ymm3, ymm8, ymm5
    vandnps ymm9, ymm14, ymm6
    vpsrld ymm3, ymm6, 20
    vandps ymm8, ymm6, [c_mant]
    vblendvps ymm5, ymm4, ymm0, ymm1
    vpmaxsd ymm6, ymm9, [c_xll]
    vpsrld ymm4, ymm2, 20
    vandps ymm0, ymm2, [c_mant]
    vmovaps ymm1, ymm5
    vfmsub213ps ymm1, ymm15, [c_c1q]
    jmp .j1664
    ALIGN 64
.j1664:
    vorps ymm9, ymm0, ymm15
    vorps ymm0, ymm8, ymm15
    vfmadd231ps ymm5, ymm1, ymm7
    vpsrld ymm8, ymm6, 23
    vpsrld ymm1, ymm6, 26
    vpermps ymm7, ymm8, [c_tll]
    vpermps ymm6, ymm1, [c_thi]
    vdivps ymm8, ymm13, ymm5
    vmulps ymm1, ymm7, ymm6
    vpermps ymm5, ymm3, [c_w1q]
    vpermps ymm7, ymm3, [c_r1q]
    vmulps ymm6, ymm1, ymm5
    vandnps ymm3, ymm14, [rsp+544]
    vfmsub213ps ymm0, ymm7, ymm15
    vmovups ymm1, [c_q11]
    vpmaxsd ymm5, ymm3, ymm12
    vfmsub213ps ymm8, ymm15, [c_bq]
    vfmadd231ps ymm1, ymm0, [c_q12]
    vmovaps [rsp+2016], ymm8
    vpermps ymm7, ymm4, ymm11
    vpermps ymm3, ymm4, ymm10
    vfmadd213ps ymm1, ymm0, [c_q10]
    vmulps ymm8, ymm6, ymm0
    vfmsub213ps ymm9, ymm7, ymm15
    vpsrld ymm4, ymm2, 23
    vpslld ymm0, ymm2, 5
    vpslld ymm7, ymm2, 4
    vpermps ymm2, ymm4, [c_uq1]
    vfmadd231ps ymm6, ymm8, ymm1
    vpermps ymm8, ymm4, [c_uq2]
    vpermps ymm1, ymm4, [c_uq0]
    vblendvps ymm4, ymm2, ymm8, ymm0
    vmovups ymm2, [c_pu2]
    vblendvps ymm8, ymm4, ymm1, ymm7
    vmovaps ymm0, ymm9
    vfmadd231ps ymm0, ymm3, ymm9
    vpsrld ymm4, ymm5, 20
    vfmadd231ps ymm2, ymm9, [c_pu3]
    vfmadd213ps ymm2, ymm9, [c_pu1]
    vfmadd213ps ymm2, ymm9, [c_pu0]
    vandps ymm1, ymm5, [c_mant]
    vorps ymm7, ymm1, ymm15
    vfmadd231ps ymm3, ymm0, ymm2
    vmovaps ymm9, ymm8
    vfmsub213ps ymm9, ymm15, [c_c1q]
    vpermps ymm1, ymm4, ymm11
    vpermps ymm0, ymm4, ymm10
    vfmadd231ps ymm8, ymm9, ymm3
    vfmsub213ps ymm7, ymm1, ymm15
    vpsrld ymm2, ymm5, 23
    vpslld ymm4, ymm5, 5
    vmovups ymm9, [c_pu2]
    vpslld ymm3, ymm5, 4
    vdivps ymm1, ymm13, ymm8
    vfmadd231ps ymm9, ymm7, [c_pu3]
    vfmadd213ps ymm9, ymm7, [c_pu1]
    vfmsub213ps ymm1, ymm15, [c_bq]
    vfmadd213ps ymm9, ymm7, [c_pu0]
    vfmadd231ps ymm7, ymm0, ymm7
    vmovaps [rsp+2048], ymm1
    vpermps ymm5, ymm2, [c_uq1]
    vpermps ymm8, ymm2, [c_uq2]
    vpermps ymm1, ymm2, [c_uq0]
    vfmadd231ps ymm0, ymm7, ymm9
    jmp .j1728
    ALIGN 64
.j1728:
    vandnps ymm2, ymm14, [rsp+768]
    vpmaxsd ymm7, ymm2, ymm12
    vblendvps ymm9, ymm5, ymm8, ymm4
    vpsrld ymm2, ymm7, 20
    vandps ymm5, ymm7, [c_mant]
    vblendvps ymm8, ymm9, ymm1, ymm3
    vorps ymm4, ymm5, ymm15
    vpermps ymm9, ymm2, ymm11
    vsubps ymm1, ymm6, [c_s1q]
    vmovaps ymm3, ymm8
    vfmsub213ps ymm3, ymm15, [c_c1q]
    vpermps ymm5, ymm2, ymm10
    vfmsub213ps ymm4, ymm9, ymm15
    vfmadd231ps ymm8, ymm3, ymm0
    vpsrld ymm2, ymm7, 23
    vpslld ymm9, ymm7, 5
    vpslld ymm3, ymm7, 4
    vdivps ymm0, ymm13, ymm8
    vfmsub213ps ymm0, ymm15, [c_bq]
    vmovaps [rsp+2080], ymm0
    vmovups ymm7, [c_s1q]
    vpermps ymm8, ymm2, [c_uq1]
    vpermps ymm0, ymm2, [c_uq2]
    vpermps ymm2, ymm2, [c_uq0]
    vblendvps ymm8, ymm8, ymm0, ymm9
    vfnmsub231ps ymm7, ymm6, [c_c3]
    vblendvps ymm0, ymm8, ymm2, ymm3
    vmovups ymm9, [c_pu2]
    vmovaps ymm6, ymm4
    vfmadd231ps ymm6, ymm5, ymm4
    vmovups ymm8, [rsp+4480]
    vdivps ymm2, ymm1, ymm7
    vandnps ymm3, ymm14, [rsp+800]
    vpmaxsd ymm1, ymm3, ymm12
    vfmadd231ps ymm9, ymm4, [c_pu3]
    vfmadd213ps ymm9, ymm4, [c_pu1]
    vmovaps [rsp+4352], ymm2
    vandnps ymm7, ymm14, ymm8
    vfmadd213ps ymm9, ymm4, [c_pu0]
    vpsrld ymm3, ymm1, 20
    vpmaxsd ymm2, ymm7, [c_xll]
    vfmadd231ps ymm5, ymm6, ymm9
    vmovaps ymm4, ymm0
    vfmsub213ps ymm4, ymm15, [c_c1q]
    vandps ymm7, ymm1, [c_mant]
    vorps ymm6, ymm7, ymm15
    vfmadd231ps ymm0, ymm4, ymm5
    vpermps ymm9, ymm3, ymm11
    vpsrld ymm7, ymm8, 20
    vpermps ymm4, ymm3, ymm10
    vandps ymm5, ymm8, [c_mant]
    vorps ymm3, ymm5, ymm15
    vdivps ymm8, ymm13, ymm0
    vfmsub213ps ymm6, ymm9, ymm15
    vpsrld ymm5, ymm1, 23
    vfmsub213ps ymm8, ymm15, [c_bq]
    vmovaps [rsp+2304], ymm8
    vpslld ymm0, ymm1, 5
    vpslld ymm9, ymm1, 4
    vpsrld ymm8, ymm2, 23
    vpsrld ymm1, ymm2, 26
    vpermps ymm2, ymm5, [c_uq1]
    vpermps ymm8, ymm8, [c_tll]
    vpermps ymm1, ymm1, [c_thi]
    jmp .j1792
    ALIGN 64
.j1792:
    vmulps ymm8, ymm8, ymm1
    vpermps ymm1, ymm5, [c_uq2]
    vpermps ymm5, ymm5, [c_uq0]
    vblendvps ymm2, ymm2, ymm1, ymm0
    vblendvps ymm1, ymm2, ymm5, ymm9
    vmovups ymm0, [c_pu2]
    vpermps ymm2, ymm7, [c_w1q]
    vpermps ymm5, ymm7, [c_r1q]
    vmulps ymm9, ymm8, ymm2
    vmovups ymm7, [c_pu2]
    vfmsub213ps ymm3, ymm5, ymm15
    vmovups ymm8, [c_q11]
    vfmadd231ps ymm0, ymm6, [c_pu3]
    vfmadd213ps ymm0, ymm6, [c_pu1]
    vfmadd231ps ymm8, ymm3, [c_q12]
    vfmadd213ps ymm0, ymm6, [c_pu0]
    vfmadd231ps ymm6, ymm4, ymm6
    vfmadd213ps ymm8, ymm3, [c_q10]
    vmulps ymm2, ymm9, ymm3
    vfmadd231ps ymm4, ymm6, ymm0
    vmovaps ymm5, ymm1
    vfmsub213ps ymm5, ymm15, [c_c1q]
    vandnps ymm3, ymm14, [rsp+832]
    vpmaxsd ymm6, ymm3, ymm12
    vfmadd231ps ymm9, ymm2, ymm8
    vmovups ymm0, [c_s1q]
    vpsrld ymm3, ymm6, 20
    vfmadd231ps ymm1, ymm5, ymm4
    vandps ymm2, ymm6, [c_mant]
    vpermps ymm8, ymm3, ymm11
    vpermps ymm5, ymm3, ymm10
    vorps ymm4, ymm2, ymm15
    vdivps ymm3, ymm13, ymm1
    vfmsub213ps ymm4, ymm8, ymm15
    vpsrld ymm2, ymm6, 23
    vfnmsub231ps ymm0, ymm9, [c_c3]
    vsubps ymm1, ymm9, [c_s1q]
    vfmadd231ps ymm7, ymm4, [c_pu3]
    vdivps ymm8, ymm1, ymm0
    vandnps ymm9, ymm14, [rsp+896]
    vpmaxsd ymm1, ymm9, ymm12
    vfmadd213ps ymm7, ymm4, [c_pu1]
    vfmsub213ps ymm3, ymm15, [c_bq]
    vfmadd213ps ymm7, ymm4, [c_pu0]
    vfmadd231ps ymm4, ymm5, ymm4
    vmovaps [rsp+2336], ymm3
    vpslld ymm0, ymm6, 5
    vpslld ymm9, ymm6, 4
    vpermps ymm3, ymm2, [c_uq1]
    vmovaps [rsp+4448], ymm8
    vpermps ymm6, ymm2, [c_uq2]
    vpermps ymm8, ymm2, [c_uq0]
    vfmadd231ps ymm5, ymm4, ymm7
    vpsrld ymm2, ymm1, 20
    vblendvps ymm4, ymm3, ymm6, ymm0
    vandnps ymm7, ymm14, [rsp+864]
    vmovups ymm3, [c_pu2]
    vblendvps ymm6, ymm4, ymm8, ymm9
    vpmaxsd ymm0, ymm7, ymm12
    vmovups ymm4, [rsp+4576]
    vandps ymm8, ymm1, [c_mant]
    vmovaps ymm9, ymm6
    vfmsub213ps ymm9, ymm15, [c_c1q]
    vorps ymm7, ymm8, ymm15
    jmp .j1856
    ALIGN 64
.j1856:
    vfmadd231ps ymm6, ymm9, ymm5
    vpsrld ymm8, ymm0, 20
    vdivps ymm9, ymm13, ymm6
    vfmsub213ps ymm9, ymm15, [c_bq]
    vmovaps [rsp+2368], ymm9
    vandps ymm5, ymm0, [c_mant]
    vorps ymm6, ymm5, ymm15
    vpermps ymm9, ymm8, ymm11
    vpermps ymm5, ymm8, ymm10
    vfmsub213ps ymm6, ymm9, ymm15
    vpsrld ymm8, ymm0, 23
    vpslld ymm9, ymm0, 5
    vpslld ymm0, ymm0, 4
    vfmadd231ps ymm3, ymm6, [c_pu3]
    vfmadd213ps ymm3, ymm6, [c_pu1]
    vfmadd213ps ymm3, ymm6, [c_pu0]
    vfmadd231ps ymm6, ymm5, ymm6
    vfmadd231ps ymm5, ymm6, ymm3
    vpermps ymm6, ymm8, [c_uq1]
    vpermps ymm3, ymm8, [c_uq2]
    vpermps ymm8, ymm8, [c_uq0]
    vblendvps ymm6, ymm6, ymm3, ymm9
    vblendvps ymm3, ymm6, ymm8, ymm0
    vandnps ymm9, ymm14, ymm4
    vpermps ymm6, ymm2, ymm11
    vpermps ymm8, ymm2, ymm10
    vmovaps ymm0, ymm3
    vfmsub213ps ymm0, ymm15, [c_c1q]
    vpmaxsd ymm2, ymm9, [c_xll]
    vfmsub213ps ymm7, ymm6, ymm15
    vfmadd231ps ymm3, ymm0, ymm5
    vpsrld ymm9, ymm1, 23
    vpslld ymm6, ymm1, 5
    vpslld ymm0, ymm1, 4
    vdivps ymm5, ymm13, ymm3
    vfmsub213ps ymm5, ymm15, [c_bq]
    vmovaps [rsp+2400], ymm5
    vpermps ymm1, ymm9, [c_uq1]
    vpermps ymm3, ymm9, [c_uq2]
    vpermps ymm5, ymm9, [c_uq0]
    vpsrld ymm9, ymm4, 20
    vandps ymm4, ymm4, [c_mant]
    vorps ymm4, ymm4, ymm15
    vblendvps ymm1, ymm1, ymm3, ymm6
    vblendvps ymm3, ymm1, ymm5, ymm0
    vpsrld ymm6, ymm2, 23
    vmovups ymm1, [c_pu2]
    vpsrld ymm5, ymm2, 26
    vpermps ymm0, ymm6, [c_tll]
    vpermps ymm2, ymm5, [c_thi]
    vmulps ymm6, ymm0, ymm2
    vpermps ymm5, ymm9, [c_w1q]
    vpermps ymm0, ymm9, [c_r1q]
    vfmadd231ps ymm1, ymm7, [c_pu3]
    vmulps ymm2, ymm6, ymm5
    vmovups ymm9, [c_pu2]
    vfmsub213ps ymm4, ymm0, ymm15
    vmovups ymm6, [c_q11]
    vfmadd213ps ymm1, ymm7, [c_pu1]
    vfmadd213ps ymm1, ymm7, [c_pu0]
    vfmadd231ps ymm7, ymm8, ymm7
    vfmadd231ps ymm6, ymm4, [c_q12]
    vfmadd231ps ymm8, ymm7, ymm1
    vmovaps ymm5, ymm3
    jmp .j1920
    ALIGN 64
.j1920:
    vfmsub213ps ymm5, ymm15, [c_c1q]
    vandnps ymm0, ymm14, [rsp+928]
    vpmaxsd ymm7, ymm0, ymm12
    vfmadd213ps ymm6, ymm4, [c_q10]
    vmulps ymm1, ymm2, ymm4
    vfmadd231ps ymm3, ymm5, ymm8
    vpsrld ymm0, ymm7, 20
    vandps ymm4, ymm7, [c_mant]
    vorps ymm5, ymm4, ymm15
    vfmadd231ps ymm2, ymm1, ymm6
    vmovups ymm8, [c_pu2]
    vmovups ymm4, [c_s1q]
    vdivps ymm1, ymm13, ymm3
    vfnmsub231ps ymm4, ymm2, [c_c3]
    vsubps ymm6, ymm2, [c_s1q]
    vfmsub213ps ymm1, ymm15, [c_bq]
    vmovaps [rsp+2432], ymm1
    vpermps ymm3, ymm0, ymm11
    vpermps ymm2, ymm0, ymm10
    vdivps ymm1, ymm6, ymm4
    vandnps ymm0, ymm14, [rsp+1184]
    vpmaxsd ymm6, ymm0, ymm12
    vfmsub213ps ymm5, ymm3, ymm15
    vpsrld ymm4, ymm7, 23
    vpslld ymm0, ymm7, 5
    vpslld ymm3, ymm7, 4
    vpermps ymm7, ymm4, [c_uq1]
    vfmadd231ps ymm9, ymm5, [c_pu3]
    vmovaps [rsp+4544], ymm1
    vpermps ymm1, ymm4, [c_uq2]
    vpermps ymm4, ymm4, [c_uq0]
    vfmadd213ps ymm9, ymm5, [c_pu1]
    vblendvps ymm7, ymm7, ymm1, ymm0
    vblendvps ymm1, ymm7, ymm4, ymm3
    vfmadd213ps ymm9, ymm5, [c_pu0]
    vandnps ymm0, ymm14, [rsp+1152]
    vpsrld ymm7, ymm6, 20
    vfmadd231ps ymm5, ymm2, ymm5
    vpmaxsd ymm4, ymm0, ymm12
    vfmadd231ps ymm2, ymm5, ymm9
    vmovaps ymm3, ymm1
    vfmsub213ps ymm3, ymm15, [c_c1q]
    vpsrld ymm0, ymm4, 20
    vfmadd231ps ymm1, ymm3, ymm2
    vandps ymm5, ymm4, [c_mant]
    vpermps ymm9, ymm0, ymm11
    vpermps ymm3, ymm0, ymm10
    vorps ymm2, ymm5, ymm15
    vdivps ymm0, ymm13, ymm1
    vfmsub213ps ymm2, ymm9, ymm15
    vpsrld ymm5, ymm4, 23
    vfmadd231ps ymm8, ymm2, [c_pu3]
    vfmadd213ps ymm8, ymm2, [c_pu1]
    vfmsub213ps ymm0, ymm15, [c_bq]
    vfmadd213ps ymm8, ymm2, [c_pu0]
    vfmadd231ps ymm2, ymm3, ymm2
    vmovaps [rsp+2464], ymm0
    vpslld ymm1, ymm4, 5
    vpslld ymm9, ymm4, 4
    vpermps ymm0, ymm5, [c_uq1]
    vpermps ymm4, ymm5, [c_uq2]
    vpermps ymm5, ymm5, [c_uq0]
    vfmadd231ps ymm3, ymm2, ymm8
    vblendvps ymm2, ymm0, ymm4, ymm1
    jmp .j1984
    ALIGN 64
.j1984:
    vandps ymm8, ymm6, [c_mant]
    vpermps ymm0, ymm7, ymm11
    vpermps ymm4, ymm7, ymm10
    vblendvps ymm1, ymm2, ymm5, ymm9
    vorps ymm7, ymm8, ymm15
    vmovups ymm2, [rsp+4672]
    vpsrld ymm5, ymm6, 23
    vmovaps ymm9, ymm1
    vfmsub213ps ymm9, ymm15, [c_c1q]
    vfmsub213ps ymm7, ymm0, ymm15
    vfmadd231ps ymm1, ymm9, ymm3
    vpslld ymm8, ymm6, 5
    vpslld ymm0, ymm6, 4
    vpermps ymm9, ymm5, [c_uq1]
    vdivps ymm3, ymm13, ymm1
    vfmsub213ps ymm3, ymm15, [c_bq]
    vmovaps [rsp+2688], ymm3
    vandnps ymm6, ymm14, ymm2
    vpermps ymm1, ymm5, [c_uq2]
    vpermps ymm3, ymm5, [c_uq0]
    vpmaxsd ymm5, ymm6, [c_xll]
    vblendvps ymm6, ymm9, ymm1, ymm8
    vmovups ymm9, [c_pu2]
    vblendvps ymm1, ymm6, ymm3, ymm0
    vpsrld ymm8, ymm2, 20
    vpsrld ymm6, ymm5, 23
    vandps ymm3, ymm2, [c_mant]
    vpermps ymm0, ymm6, [c_tll]
    vpsrld ymm2, ymm5, 26
    vorps ymm6, ymm3, ymm15
    vpermps ymm5, ymm2, [c_thi]
    vfmadd231ps ymm9, ymm7, [c_pu3]
    vmulps ymm3, ymm0, ymm5
    vpermps ymm2, ymm8, [c_w1q]
    vpermps ymm0, ymm8, [c_r1q]
    vfmadd213ps ymm9, ymm7, [c_pu1]
    vmulps ymm5, ymm3, ymm2
    vmovups ymm8, [c_pu2]
    vfmsub213ps ymm6, ymm0, ymm15
    vmovups ymm3, [c_q11]
    vfmadd213ps ymm9, ymm7, [c_pu0]
    vfmadd231ps ymm7, ymm4, ymm7
    vfmadd231ps ymm4, ymm7, ymm9
    vmovaps ymm2, ymm1
    vfmsub213ps ymm2, ymm15, [c_c1q]
    vandnps ymm0, ymm14, [rsp+1216]
    vpmaxsd ymm7, ymm0, ymm12
    vfmadd231ps ymm3, ymm6, [c_q12]
    vfmadd231ps ymm1, ymm2, ymm4
    vpsrld ymm9, ymm7, 20
    vandps ymm0, ymm7, [c_mant]
    vorps ymm2, ymm0, ymm15
    vfmadd213ps ymm3, ymm6, [c_q10]
    vmulps ymm4, ymm5, ymm6
    vdivps ymm0, ymm13, ymm1
    vfmadd231ps ymm5, ymm4, ymm3
    vpermps ymm6, ymm9, ymm11
    vpsrld ymm1, ymm7, 23
    vpermps ymm4, ymm9, ymm10
    vfmsub213ps ymm2, ymm6, ymm15
    vpslld ymm3, ymm7, 5
    vpslld ymm9, ymm7, 4
    vfmsub213ps ymm0, ymm15, [c_bq]
    vfmadd231ps ymm8, ymm2, [c_pu3]
    jmp .j2048
    ALIGN 64
.j2048:
    vmovaps [rsp+2720], ymm0
    vpermps ymm6, ymm1, [c_uq1]
    vfmadd213ps ymm8, ymm2, [c_pu1]
    vpermps ymm7, ymm1, [c_uq2]
    vpermps ymm0, ymm1, [c_uq0]
    vfmadd213ps ymm8, ymm2, [c_pu0]
    vfmadd231ps ymm2, ymm4, ymm2
    vblendvps ymm1, ymm6, ymm7, ymm3
    vandnps ymm6, ymm14, [rsp+1248]
    vblendvps ymm7, ymm1, ymm0, ymm9
    vpmaxsd ymm3, ymm6, ymm12
    vmovups ymm1, [c_pu2]
    vsubps ymm0, ymm5, [c_s1q]
    vfmadd231ps ymm4, ymm2, ymm8
    vmovaps ymm9, ymm7
    vfmsub213ps ymm9, ymm15, [c_c1q]
    vpsrld ymm6, ymm3, 20
    vfmadd231ps ymm7, ymm9, ymm4
    vandps ymm2, ymm3, [c_mant]
    vpermps ymm8, ymm6, ymm11
    vpermps ymm9, ymm6, ymm10
    vorps ymm4, ymm2, ymm15
    vdivps ymm6, ymm13, ymm7
    vfmsub213ps ymm4, ymm8, ymm15
    vpsrld ymm2, ymm3, 23
    vfmadd231ps ymm1, ymm4, [c_pu3]
    vfmadd213ps ymm1, ymm4, [c_pu1]
    vfmsub213ps ymm6, ymm15, [c_bq]
    vfmadd213ps ymm1, ymm4, [c_pu0]
    vfmadd231ps ymm4, ymm9, ymm4
    vmovaps [rsp+2752], ymm6
    vpslld ymm7, ymm3, 5
    vpslld ymm8, ymm3, 4
    vpermps ymm6, ymm2, [c_uq1]
    vpermps ymm3, ymm2, [c_uq2]
    vpermps ymm2, ymm2, [c_uq0]
    vfmadd231ps ymm9, ymm4, ymm1
    vblendvps ymm4, ymm6, ymm3, ymm7
    vmovups ymm1, [c_s1q]
    vandnps ymm6, ymm14, [rsp+1280]
    vblendvps ymm3, ymm4, ymm2, ymm8
    vpmaxsd ymm7, ymm6, ymm12
    vmovups ymm4, [rsp+4768]
    vmovups ymm2, [c_pu2]
    vmovaps ymm8, ymm3
    vfmsub213ps ymm8, ymm15, [c_c1q]
    vfmadd231ps ymm3, ymm8, ymm9
    vpsrld ymm6, ymm7, 20
    vfnmsub231ps ymm1, ymm5, [c_c3]
    vandps ymm8, ymm7, [c_mant]
    vorps ymm9, ymm8, ymm15
    vdivps ymm5, ymm13, ymm3
    vdivps ymm8, ymm0, ymm1
    vpsrld ymm3, ymm7, 23
    vfmsub213ps ymm5, ymm15, [c_bq]
    vmovaps [rsp+4640], ymm8
    vpslld ymm0, ymm7, 4
    vpslld ymm1, ymm7, 5
    vmovaps [rsp+2784], ymm5
    vpermps ymm8, ymm6, ymm11
    vpermps ymm7, ymm6, ymm10
    vfmsub213ps ymm9, ymm8, ymm15
    vpermps ymm5, ymm3, [c_uq1]
    vpermps ymm6, ymm3, [c_uq2]
    jmp .j2112
    ALIGN 64
.j2112:
    vpermps ymm8, ymm3, [c_uq0]
    vfmadd231ps ymm2, ymm9, [c_pu3]
    vblendvps ymm3, ymm5, ymm6, ymm1
    vandnps ymm5, ymm14, ymm4
    vblendvps ymm6, ymm3, ymm8, ymm0
    vpmaxsd ymm1, ymm5, [c_xll]
    vmovaps ymm3, ymm9
    vfmadd231ps ymm3, ymm7, ymm9
    vpsrld ymm8, ymm4, 20
    vandps ymm0, ymm4, [c_mant]
    vfmadd213ps ymm2, ymm9, [c_pu1]
    vorps ymm5, ymm0, ymm15
    vfmadd213ps ymm2, ymm9, [c_pu0]
    vpsrld ymm4, ymm1, 23
    vpsrld ymm0, ymm1, 26
    vpermps ymm9, ymm4, [c_tll]
    vpermps ymm1, ymm0, [c_thi]
    vfmadd231ps ymm7, ymm3, ymm2
    vmovaps ymm4, ymm6
    vfmsub213ps ymm4, ymm15, [c_c1q]
    vandnps ymm0, ymm14, [rsp+1312]
    vpmaxsd ymm3, ymm0, ymm12
    vmulps ymm2, ymm9, ymm1
    vmovups ymm0, [c_pu2]
    vfmadd231ps ymm6, ymm4, ymm7
    vpsrld ymm9, ymm3, 20
    vandps ymm1, ymm3, [c_mant]
    vorps ymm4, ymm1, ymm15
    vdivps ymm7, ymm13, ymm6
    vfmsub213ps ymm7, ymm15, [c_bq]
    vmovaps [rsp+2816], ymm7
    vpermps ymm1, ymm9, ymm11
    vpermps ymm6, ymm9, ymm10
    vfmsub213ps ymm4, ymm1, ymm15
    vpsrld ymm7, ymm3, 23
    vpslld ymm9, ymm3, 5
    vpslld ymm1, ymm3, 4
    vpermps ymm3, ymm7, [c_uq1]
    vfmadd231ps ymm0, ymm4, [c_pu3]
    vfmadd213ps ymm0, ymm4, [c_pu1]
    vfmadd213ps ymm0, ymm4, [c_pu0]
    vfmadd231ps ymm4, ymm6, ymm4
    vfmadd231ps ymm6, ymm4, ymm0
    vpermps ymm4, ymm7, [c_uq2]
    vpermps ymm0, ymm7, [c_uq0]
    vblendvps ymm7, ymm3, ymm4, ymm9
    vpermps ymm3, ymm8, [c_w1q]
    vpermps ymm4, ymm8, [c_r1q]
    vblendvps ymm9, ymm7, ymm0, ymm1
    vandnps ymm8, ymm14, [rsp+192]
    vmovups ymm7, [c_q11]
    vpmaxsd ymm0, ymm8, ymm12
    vmulps ymm1, ymm2, ymm3
    vpsrld ymm8, ymm0, 20
    vfmsub213ps ymm5, ymm4, ymm15
    vpsrld ymm2, ymm0, 23
    vmovaps ymm3, ymm9
    vfmsub213ps ymm3, ymm15, [c_c1q]
    vfmadd231ps ymm7, ymm5, [c_q12]
    vfmadd231ps ymm9, ymm3, ymm6
    vandps ymm4, ymm0, [c_mant]
    vorps ymm3, ymm4, ymm15
    vfmadd213ps ymm7, ymm5, [c_q10]
    vmulps ymm6, ymm1, ymm5
    jmp .j2176
    ALIGN 64
.j2176:
    vdivps ymm4, ymm13, ymm9
    vfmadd231ps ymm1, ymm6, ymm7
    vandnps ymm5, ymm14, [rsp+224]
    vmovups ymm9, [c_s1q]
    vpmaxsd ymm6, ymm5, ymm12
    vfmsub213ps ymm4, ymm15, [c_bq]
    vfnmsub231ps ymm9, ymm1, [c_c3]
    vsubps ymm7, ymm1, [c_s1q]
    vmovaps [rsp+2848], ymm4
    vpermps ymm5, ymm8, ymm11
    vpermps ymm1, ymm8, ymm10
    vdivps ymm4, ymm7, ymm9
    vmovups ymm8, [c_pu2]
    vfmsub213ps ymm3, ymm5, ymm15
    vpslld ymm7, ymm0, 5
    vpslld ymm9, ymm0, 4
    vpermps ymm5, ymm2, [c_uq1]
    vpermps ymm0, ymm2, [c_uq2]
    vpermps ymm2, ymm2, [c_uq0]
    vblendvps ymm5, ymm5, ymm0, ymm7
    vblendvps ymm0, ymm5, ymm2, ymm9
    vmovups ymm7, [c_pu2]
    vpsrld ymm5, ymm6, 20
    vmovaps [rsp+4736], ymm4
    vmovups ymm2, [rsp+4864]
    vfmadd231ps ymm7, ymm3, [c_pu3]
    vfmadd213ps ymm7, ymm3, [c_pu1]
    vfmadd213ps ymm7, ymm3, [c_pu0]
    vfmadd231ps ymm3, ymm1, ymm3
    vfmadd231ps ymm1, ymm3, ymm7
    vmovaps ymm9, ymm0
    vfmsub213ps ymm9, ymm15, [c_c1q]
    vandps ymm4, ymm6, [c_mant]
    vorps ymm3, ymm4, ymm15
    vfmadd231ps ymm0, ymm9, ymm1
    vpermps ymm7, ymm5, ymm11
    vpsrld ymm4, ymm6, 23
    vpermps ymm9, ymm5, ymm10
    vdivps ymm1, ymm13, ymm0
    vfmsub213ps ymm3, ymm7, ymm15
    vpslld ymm5, ymm6, 5
    vpslld ymm0, ymm6, 4
    vfmadd231ps ymm8, ymm3, [c_pu3]
    vfmadd213ps ymm8, ymm3, [c_pu1]
    vfmsub213ps ymm1, ymm15, [c_bq]
    vfmadd213ps ymm8, ymm3, [c_pu0]
    vfmadd231ps ymm3, ymm9, ymm3
    vmovaps [rsp+1728], ymm1
    vpermps ymm7, ymm4, [c_uq1]
    vpermps ymm6, ymm4, [c_uq2]
    vpermps ymm1, ymm4, [c_uq0]
    vfmadd231ps ymm9, ymm3, ymm8
    vandnps ymm4, ymm14, [rsp+256]
    vpmaxsd ymm3, ymm4, ymm12
    vblendvps ymm8, ymm7, ymm6, ymm5
    vandnps ymm4, ymm14, ymm2
    vpsrld ymm7, ymm2, 20
    vandps ymm6, ymm2, [c_mant]
    vblendvps ymm5, ymm8, ymm1, ymm0
    vpmaxsd ymm2, ymm4, [c_xll]
    vpsrld ymm8, ymm3, 20
    vandps ymm1, ymm3, [c_mant]
    vmovaps ymm0, ymm5
    vfmsub213ps ymm0, ymm15, [c_c1q]
    jmp .j2240
    ALIGN 64
.j2240:
    vorps ymm4, ymm1, ymm15
    vorps ymm1, ymm6, ymm15
    vfmadd231ps ymm5, ymm0, ymm9
    vpsrld ymm6, ymm2, 23
    vpsrld ymm0, ymm2, 26
    vpermps ymm9, ymm6, [c_tll]
    vpermps ymm2, ymm0, [c_thi]
    vdivps ymm6, ymm13, ymm5
    vmulps ymm0, ymm9, ymm2
    vpermps ymm5, ymm7, [c_w1q]
    vpermps ymm9, ymm7, [c_r1q]
    vmulps ymm2, ymm0, ymm5
    vandnps ymm7, ymm14, [rsp+288]
    vfmsub213ps ymm1, ymm9, ymm15
    vmovups ymm0, [c_q11]
    vpmaxsd ymm5, ymm7, ymm12
    vfmsub213ps ymm6, ymm15, [c_bq]
    vfmadd231ps ymm0, ymm1, [c_q12]
    vmovaps [rsp+1760], ymm6
    vpermps ymm9, ymm8, ymm11
    vpermps ymm7, ymm8, ymm10
    vfmadd213ps ymm0, ymm1, [c_q10]
    vmulps ymm6, ymm2, ymm1
    vfmsub213ps ymm4, ymm9, ymm15
    vpsrld ymm8, ymm3, 23
    vpslld ymm1, ymm3, 5
    vpslld ymm9, ymm3, 4
    vpermps ymm3, ymm8, [c_uq1]
    vfmadd231ps ymm2, ymm6, ymm0
    vpermps ymm6, ymm8, [c_uq2]
    vpermps ymm0, ymm8, [c_uq0]
    vblendvps ymm8, ymm3, ymm6, ymm1
    vmovups ymm3, [c_pu2]
    vblendvps ymm6, ymm8, ymm0, ymm9
    vmovaps ymm1, ymm4
    vfmadd231ps ymm1, ymm7, ymm4
    vpsrld ymm8, ymm5, 20
    vfmadd231ps ymm3, ymm4, [c_pu3]
    vfmadd213ps ymm3, ymm4, [c_pu1]
    vfmadd213ps ymm3, ymm4, [c_pu0]
    vandps ymm0, ymm5, [c_mant]
    vorps ymm9, ymm0, ymm15
    vfmadd231ps ymm7, ymm1, ymm3
    vmovaps ymm4, ymm6
    vfmsub213ps ymm4, ymm15, [c_c1q]
    vpermps ymm0, ymm8, ymm11
    vpermps ymm1, ymm8, ymm10
    vfmadd231ps ymm6, ymm4, ymm7
    vfmsub213ps ymm9, ymm0, ymm15
    vpsrld ymm3, ymm5, 23
    vpslld ymm8, ymm5, 5
    vmovups ymm4, [c_pu2]
    vpslld ymm7, ymm5, 4
    vdivps ymm0, ymm13, ymm6
    vfmadd231ps ymm4, ymm9, [c_pu3]
    vfmadd213ps ymm4, ymm9, [c_pu1]
    vfmsub213ps ymm0, ymm15, [c_bq]
    vfmadd213ps ymm4, ymm9, [c_pu0]
    vfmadd231ps ymm9, ymm1, ymm9
    vmovaps [rsp+1792], ymm0
    vpermps ymm5, ymm3, [c_uq1]
    vpermps ymm6, ymm3, [c_uq2]
    vpermps ymm0, ymm3, [c_uq0]
    vfmadd231ps ymm1, ymm9, ymm4
    jmp .j2304
    ALIGN 64
.j2304:
    vandnps ymm3, ymm14, [rsp+320]
    vpmaxsd ymm9, ymm3, ymm12
    vblendvps ymm4, ymm5, ymm6, ymm8
    vpsrld ymm3, ymm9, 20
    vandps ymm5, ymm9, [c_mant]
    vblendvps ymm6, ymm4, ymm0, ymm7
    vorps ymm8, ymm5, ymm15
    vpermps ymm4, ymm3, ymm11
    vsubps ymm0, ymm2, [c_s1q]
    vmovaps ymm7, ymm6
    vfmsub213ps ymm7, ymm15, [c_c1q]
    vpermps ymm5, ymm3, ymm10
    vfmsub213ps ymm8, ymm4, ymm15
    vfmadd231ps ymm6, ymm7, ymm1
    vpsrld ymm3, ymm9, 23
    vpslld ymm4, ymm9, 5
    vpslld ymm7, ymm9, 4
    vdivps ymm1, ymm13, ymm6
    vfmsub213ps ymm1, ymm15, [c_bq]
    vmovaps [rsp+1824], ymm1
    vmovups ymm9, [c_s1q]
    vpermps ymm6, ymm3, [c_uq1]
    vpermps ymm1, ymm3, [c_uq2]
    vpermps ymm3, ymm3, [c_uq0]
    vblendvps ymm6, ymm6, ymm1, ymm4
    vfnmsub231ps ymm9, ymm2, [c_c3]
    vblendvps ymm1, ymm6, ymm3, ymm7
    vmovups ymm4, [c_pu2]
    vmovaps ymm2, ymm8
    vfmadd231ps ymm2, ymm5, ymm8
    vmovups ymm6, [rsp+4960]
    vdivps ymm3, ymm0, ymm9
    vandnps ymm7, ymm14, [rsp+352]
    vpmaxsd ymm0, ymm7, ymm12
    vfmadd231ps ymm4, ymm8, [c_pu3]
    vfmadd213ps ymm4, ymm8, [c_pu1]
    vmovaps [rsp+4832], ymm3
    vandnps ymm9, ymm14, ymm6
    vfmadd213ps ymm4, ymm8, [c_pu0]
    vpsrld ymm7, ymm0, 20
    vpmaxsd ymm3, ymm9, [c_xll]
    vfmadd231ps ymm5, ymm2, ymm4
    vmovaps ymm8, ymm1
    vfmsub213ps ymm8, ymm15, [c_c1q]
    vandps ymm9, ymm0, [c_mant]
    vorps ymm2, ymm9, ymm15
    vfmadd231ps ymm1, ymm8, ymm5
    vpermps ymm4, ymm7, ymm11
    vpsrld ymm9, ymm6, 20
    vpermps ymm8, ymm7, ymm10
    vandps ymm5, ymm6, [c_mant]
    vorps ymm7, ymm5, ymm15
    vdivps ymm6, ymm13, ymm1
    vfmsub213ps ymm2, ymm4, ymm15
    vpsrld ymm5, ymm0, 23
    vfmsub213ps ymm6, ymm15, [c_bq]
    vmovaps [rsp+1856], ymm6
    vpslld ymm1, ymm0, 5
    vpslld ymm4, ymm0, 4
    vpsrld ymm6, ymm3, 23
    vpsrld ymm0, ymm3, 26
    vpermps ymm3, ymm5, [c_uq1]
    vpermps ymm6, ymm6, [c_tll]
    vpermps ymm0, ymm0, [c_thi]
    jmp .j2368
    ALIGN 64
.j2368:
    vmulps ymm6, ymm6, ymm0
    vpermps ymm0, ymm5, [c_uq2]
    vpermps ymm5, ymm5, [c_uq0]
    vblendvps ymm3, ymm3, ymm0, ymm1
    vblendvps ymm0, ymm3, ymm5, ymm4
    vmovups ymm1, [c_pu2]
    vpermps ymm3, ymm9, [c_w1q]
    vpermps ymm5, ymm9, [c_r1q]
    vmulps ymm4, ymm6, ymm3
    vmovups ymm9, [c_pu2]
    vfmsub213ps ymm7, ymm5, ymm15
    vmovups ymm6, [c_q11]
    vfmadd231ps ymm1, ymm2, [c_pu3]
    vfmadd213ps ymm1, ymm2, [c_pu1]
    vfmadd231ps ymm6, ymm7, [c_q12]
    vfmadd213ps ymm1, ymm2, [c_pu0]
    vfmadd231ps ymm2, ymm8, ymm2
    vfmadd213ps ymm6, ymm7, [c_q10]
    vmulps ymm3, ymm4, ymm7
    vfmadd231ps ymm8, ymm2, ymm1
    vmovaps ymm5, ymm0
    vfmsub213ps ymm5, ymm15, [c_c1q]
    vandnps ymm7, ymm14, [rsp+576]
    vpmaxsd ymm2, ymm7, ymm12
    vfmadd231ps ymm4, ymm3, ymm6
    vmovups ymm1, [c_s1q]
    vpsrld ymm7, ymm2, 20
    vfmadd231ps ymm0, ymm5, ymm8
    vandps ymm3, ymm2, [c_mant]
    vpermps ymm6, ymm7, ymm11
    vpermps ymm5, ymm7, ymm10
    vorps ymm8, ymm3, ymm15
    vdivps ymm7, ymm13, ymm0
    vfmsub213ps ymm8, ymm6, ymm15
    vpsrld ymm3, ymm2, 23
    vfnmsub231ps ymm1, ymm4, [c_c3]
    vsubps ymm0, ymm4, [c_s1q]
    vfmadd231ps ymm9, ymm8, [c_pu3]
    vdivps ymm6, ymm0, ymm1
    vandnps ymm4, ymm14, [rsp+640]
    vpmaxsd ymm0, ymm4, ymm12
    vfmadd213ps ymm9, ymm8, [c_pu1]
    vfmsub213ps ymm7, ymm15, [c_bq]
    vfmadd213ps ymm9, ymm8, [c_pu0]
    vfmadd231ps ymm8, ymm5, ymm8
    vmovaps [rsp+1888], ymm7
    vpslld ymm1, ymm2, 5
    vpslld ymm4, ymm2, 4
    vpermps ymm7, ymm3, [c_uq1]
    vmovaps [rsp+4928], ymm6
    vpermps ymm2, ymm3, [c_uq2]
    vpermps ymm6, ymm3, [c_uq0]
    vfmadd231ps ymm5, ymm8, ymm9
    vpsrld ymm3, ymm0, 20
    vblendvps ymm8, ymm7, ymm2, ymm1
    vandnps ymm9, ymm14, [rsp+608]
    vmovups ymm7, [c_pu2]
    vblendvps ymm2, ymm8, ymm6, ymm4
    vpmaxsd ymm1, ymm9, ymm12
    vmovups ymm8, [rsp+5056]
    vandps ymm6, ymm0, [c_mant]
    vmovaps ymm4, ymm2
    vfmsub213ps ymm4, ymm15, [c_c1q]
    vorps ymm9, ymm6, ymm15
    jmp .j2432
    ALIGN 64
.j2432:
    vfmadd231ps ymm2, ymm4, ymm5
    vpsrld ymm6, ymm1, 20
    vdivps ymm4, ymm13, ymm2
    vfmsub213ps ymm4, ymm15, [c_bq]
    vmovaps [rsp+2112], ymm4
    vandps ymm5, ymm1, [c_mant]
    vorps ymm2, ymm5, ymm15
    vpermps ymm4, ymm6, ymm11
    vpermps ymm5, ymm6, ymm10
    vfmsub213ps ymm2, ymm4, ymm15
    vpsrld ymm6, ymm1, 23
    vpslld ymm4, ymm1, 5
    vpslld ymm1, ymm1, 4
    vfmadd231ps ymm7, ymm2, [c_pu3]
    vfmadd213ps ymm7, ymm2, [c_pu1]
    vfmadd213ps ymm7, ymm2, [c_pu0]
    vfmadd231ps ymm2, ymm5, ymm2
    vfmadd231ps ymm5, ymm2, ymm7
    vpermps ymm2, ymm6, [c_uq1]
    vpermps ymm7, ymm6, [c_uq2]
    vpermps ymm6, ymm6, [c_uq0]
    vblendvps ymm2, ymm2, ymm7, ymm4
    vblendvps ymm7, ymm2, ymm6, ymm1
    vandnps ymm4, ymm14, ymm8
    vpermps ymm2, ymm3, ymm11
    vpermps ymm6, ymm3, ymm10
    vmovaps ymm1, ymm7
    vfmsub213ps ymm1, ymm15, [c_c1q]
    vpmaxsd ymm3, ymm4, [c_xll]
    vfmsub213ps ymm9, ymm2, ymm15
    vfmadd231ps ymm7, ymm1, ymm5
    vpsrld ymm4, ymm0, 23
    vpslld ymm2, ymm0, 5
    vpslld ymm1, ymm0, 4
    vdivps ymm5, ymm13, ymm7
    vfmsub213ps ymm5, ymm15, [c_bq]
    vmovaps [rsp+2144], ymm5
    vpermps ymm0, ymm4, [c_uq1]
    vpermps ymm7, ymm4, [c_uq2]
    vpermps ymm5, ymm4, [c_uq0]
    vpsrld ymm4, ymm8, 20
    vandps ymm8, ymm8, [c_mant]
    vorps ymm8, ymm8, ymm15
    vblendvps ymm0, ymm0, ymm7, ymm2
    vblendvps ymm7, ymm0, ymm5, ymm1
    vpsrld ymm2, ymm3, 23
    vmovups ymm0, [c_pu2]
    vpsrld ymm5, ymm3, 26
    vpermps ymm1, ymm2, [c_tll]
    vpermps ymm3, ymm5, [c_thi]
    vmulps ymm2, ymm1, ymm3
    vpermps ymm5, ymm4, [c_w1q]
    vpermps ymm1, ymm4, [c_r1q]
    vfmadd231ps ymm0, ymm9, [c_pu3]
    vmulps ymm3, ymm2, ymm5
    vmovups ymm4, [c_pu2]
    vfmsub213ps ymm8, ymm1, ymm15
    vmovups ymm2, [c_q11]
    vfmadd213ps ymm0, ymm9, [c_pu1]
    vfmadd213ps ymm0, ymm9, [c_pu0]
    vfmadd231ps ymm9, ymm6, ymm9
    vfmadd231ps ymm2, ymm8, [c_q12]
    vfmadd231ps ymm6, ymm9, ymm0
    vmovaps ymm5, ymm7
    jmp .j2496
    ALIGN 64
.j2496:
    vfmsub213ps ymm5, ymm15, [c_c1q]
    vandnps ymm1, ymm14, [rsp+672]
    vpmaxsd ymm9, ymm1, ymm12
    vfmadd213ps ymm2, ymm8, [c_q10]
    vmulps ymm0, ymm3, ymm8
    vfmadd231ps ymm7, ymm5, ymm6
    vpsrld ymm1, ymm9, 20
    vandps ymm8, ymm9, [c_mant]
    vorps ymm5, ymm8, ymm15
    vfmadd231ps ymm3, ymm0, ymm2
    vmovups ymm6, [c_pu2]
    vmovups ymm8, [c_s1q]
    vdivps ymm0, ymm13, ymm7
    vfnmsub231ps ymm8, ymm3, [c_c3]
    vsubps ymm2, ymm3, [c_s1q]
    vfmsub213ps ymm0, ymm15, [c_bq]
    vmovaps [rsp+2176], ymm0
    vpermps ymm7, ymm1, ymm11
    vpermps ymm3, ymm1, ymm10
    vdivps ymm0, ymm2, ymm8
    vandnps ymm1, ymm14, [rsp+736]
    vpmaxsd ymm2, ymm1, ymm12
    vfmsub213ps ymm5, ymm7, ymm15
    vpsrld ymm8, ymm9, 23
    vpslld ymm1, ymm9, 5
    vpslld ymm7, ymm9, 4
    vpermps ymm9, ymm8, [c_uq1]
    vfmadd231ps ymm4, ymm5, [c_pu3]
    vmovaps [rsp+5024], ymm0
    vpermps ymm0, ymm8, [c_uq2]
    vpermps ymm8, ymm8, [c_uq0]
    vfmadd213ps ymm4, ymm5, [c_pu1]
    vblendvps ymm9, ymm9, ymm0, ymm1
    vblendvps ymm0, ymm9, ymm8, ymm7
    vfmadd213ps ymm4, ymm5, [c_pu0]
    vandnps ymm1, ymm14, [rsp+704]
    vpsrld ymm9, ymm2, 20
    vfmadd231ps ymm5, ymm3, ymm5
    vpmaxsd ymm8, ymm1, ymm12
    vfmadd231ps ymm3, ymm5, ymm4
    vmovaps ymm7, ymm0
    vfmsub213ps ymm7, ymm15, [c_c1q]
    vpsrld ymm1, ymm8, 20
    vfmadd231ps ymm0, ymm7, ymm3
    vandps ymm5, ymm8, [c_mant]
    vpermps ymm4, ymm1, ymm11
    vpermps ymm7, ymm1, ymm10
    vorps ymm3, ymm5, ymm15
    vdivps ymm1, ymm13, ymm0
    vfmsub213ps ymm3, ymm4, ymm15
    vpsrld ymm5, ymm8, 23
    vfmadd231ps ymm6, ymm3, [c_pu3]
    vfmadd213ps ymm6, ymm3, [c_pu1]
    vfmsub213ps ymm1, ymm15, [c_bq]
    vfmadd213ps ymm6, ymm3, [c_pu0]
    vfmadd231ps ymm3, ymm7, ymm3
    vmovaps [rsp+2208], ymm1
    vpslld ymm0, ymm8, 5
    vpslld ymm4, ymm8, 4
    vpermps ymm1, ymm5, [c_uq1]
    vpermps ymm8, ymm5, [c_uq2]
    vpermps ymm5, ymm5, [c_uq0]
    vfmadd231ps ymm7, ymm3, ymm6
    vblendvps ymm3, ymm1, ymm8, ymm0
    jmp .j2560
    ALIGN 64
.j2560:
    vandps ymm6, ymm2, [c_mant]
    vpermps ymm1, ymm9, ymm11
    vpermps ymm8, ymm9, ymm10
    vblendvps ymm0, ymm3, ymm5, ymm4
    vorps ymm9, ymm6, ymm15
    vmovups ymm3, [rsp+5152]
    vpsrld ymm5, ymm2, 23
    vmovaps ymm4, ymm0
    vfmsub213ps ymm4, ymm15, [c_c1q]
    vfmsub213ps ymm9, ymm1, ymm15
    vfmadd231ps ymm0, ymm4, ymm7
    vpslld ymm6, ymm2, 5
    vpslld ymm1, ymm2, 4
    vpermps ymm4, ymm5, [c_uq1]
    vdivps ymm7, ymm13, ymm0
    vfmsub213ps ymm7, ymm15, [c_bq]
    vmovaps [rsp+2240], ymm7
    vandnps ymm2, ymm14, ymm3
    vpermps ymm0, ymm5, [c_uq2]
    vpermps ymm7, ymm5, [c_uq0]
    vpmaxsd ymm5, ymm2, [c_xll]
    vblendvps ymm2, ymm4, ymm0, ymm6
    vmovups ymm4, [c_pu2]
    vblendvps ymm0, ymm2, ymm7, ymm1
    vpsrld ymm6, ymm3, 20
    vpsrld ymm2, ymm5, 23
    vandps ymm7, ymm3, [c_mant]
    vpermps ymm1, ymm2, [c_tll]
    vpsrld ymm3, ymm5, 26
    vorps ymm2, ymm7, ymm15
    vpermps ymm5, ymm3, [c_thi]
    vfmadd231ps ymm4, ymm9, [c_pu3]
    vmulps ymm7, ymm1, ymm5
    vpermps ymm3, ymm6, [c_w1q]
    vpermps ymm1, ymm6, [c_r1q]
    vfmadd213ps ymm4, ymm9, [c_pu1]
    vmulps ymm5, ymm7, ymm3
    vmovups ymm6, [c_pu2]
    vfmsub213ps ymm2, ymm1, ymm15
    vmovups ymm7, [c_q11]
    vfmadd213ps ymm4, ymm9, [c_pu0]
    vfmadd231ps ymm9, ymm8, ymm9
    vfmadd231ps ymm8, ymm9, ymm4
    vmovaps ymm3, ymm0
    vfmsub213ps ymm3, ymm15, [c_c1q]
    vandnps ymm1, ymm14, [rsp+960]
    vpmaxsd ymm9, ymm1, ymm12
    vfmadd231ps ymm7, ymm2, [c_q12]
    vfmadd231ps ymm0, ymm3, ymm8
    vpsrld ymm4, ymm9, 20
    vandps ymm1, ymm9, [c_mant]
    vorps ymm3, ymm1, ymm15
    vfmadd213ps ymm7, ymm2, [c_q10]
    vmulps ymm8, ymm5, ymm2
    vdivps ymm1, ymm13, ymm0
    vfmadd231ps ymm5, ymm8, ymm7
    vpermps ymm2, ymm4, ymm11
    vpsrld ymm0, ymm9, 23
    vpermps ymm8, ymm4, ymm10
    vfmsub213ps ymm3, ymm2, ymm15
    vpslld ymm7, ymm9, 5
    vpslld ymm4, ymm9, 4
    vfmsub213ps ymm1, ymm15, [c_bq]
    vfmadd231ps ymm6, ymm3, [c_pu3]
    jmp .j2624
    ALIGN 64
.j2624:
    vmovaps [rsp+2272], ymm1
    vpermps ymm2, ymm0, [c_uq1]
    vfmadd213ps ymm6, ymm3, [c_pu1]
    vpermps ymm9, ymm0, [c_uq2]
    vpermps ymm1, ymm0, [c_uq0]
    vfmadd213ps ymm6, ymm3, [c_pu0]
    vfmadd231ps ymm3, ymm8, ymm3
    vblendvps ymm0, ymm2, ymm9, ymm7
    vandnps ymm2, ymm14, [rsp+992]
    vblendvps ymm9, ymm0, ymm1, ymm4
    vpmaxsd ymm7, ymm2, ymm12
    vmovups ymm0, [c_pu2]
    vsubps ymm1, ymm5, [c_s1q]
    vfmadd231ps ymm8, ymm3, ymm6
    vmovaps ymm4, ymm9
    vfmsub213ps ymm4, ymm15, [c_c1q]
    vpsrld ymm2, ymm7, 20
    vfmadd231ps ymm9, ymm4, ymm8
    vandps ymm3, ymm7, [c_mant]
    vpermps ymm6, ymm2, ymm11
    vpermps ymm4, ymm2, ymm10
    vorps ymm8, ymm3, ymm15
    vdivps ymm2, ymm13, ymm9
    vfmsub213ps ymm8, ymm6, ymm15
    vpsrld ymm3, ymm7, 23
    vfmadd231ps ymm0, ymm8, [c_pu3]
    vfmadd213ps ymm0, ymm8, [c_pu1]
    vfmsub213ps ymm2, ymm15, [c_bq]
    vfmadd213ps ymm0, ymm8, [c_pu0]
    vfmadd231ps ymm8, ymm4, ymm8
    vmovaps [rsp+2496], ymm2
    vpslld ymm9, ymm7, 5
    vpslld ymm6, ymm7, 4
    vpermps ymm2, ymm3, [c_uq1]
    vpermps ymm7, ymm3, [c_uq2]
    vpermps ymm3, ymm3, [c_uq0]
    vfmadd231ps ymm4, ymm8, ymm0
    vblendvps ymm8, ymm2, ymm7, ymm9
    vmovups ymm0, [c_s1q]
    vandnps ymm2, ymm14, [rsp+1024]
    vblendvps ymm7, ymm8, ymm3, ymm6
    vpmaxsd ymm9, ymm2, ymm12
    vmovups ymm8, [rsp+5248]
    vmovups ymm3, [c_pu2]
    vmovaps ymm6, ymm7
    vfmsub213ps ymm6, ymm15, [c_c1q]
    vfmadd231ps ymm7, ymm6, ymm4
    vpsrld ymm2, ymm9, 20
    vfnmsub231ps ymm0, ymm5, [c_c3]
    vandps ymm6, ymm9, [c_mant]
    vorps ymm4, ymm6, ymm15
    vdivps ymm5, ymm13, ymm7
    vdivps ymm6, ymm1, ymm0
    vpsrld ymm7, ymm9, 23
    vfmsub213ps ymm5, ymm15, [c_bq]
    vmovaps [rsp+5120], ymm6
    vpslld ymm1, ymm9, 4
    vpslld ymm0, ymm9, 5
    vmovaps [rsp+2528], ymm5
    vpermps ymm6, ymm2, ymm11
    vpermps ymm9, ymm2, ymm10
    vfmsub213ps ymm4, ymm6, ymm15
    vpermps ymm5, ymm7, [c_uq1]
    vpermps ymm2, ymm7, [c_uq2]
    jmp .j2688
    ALIGN 64
.j2688:
    vpermps ymm6, ymm7, [c_uq0]
    vfmadd231ps ymm3, ymm4, [c_pu3]
    vblendvps ymm7, ymm5, ymm2, ymm0
    vandnps ymm5, ymm14, ymm8
    vblendvps ymm2, ymm7, ymm6, ymm1
    vpmaxsd ymm0, ymm5, [c_xlh]
    vmovaps ymm7, ymm4
    vfmadd231ps ymm7, ymm9, ymm4
    vpsrld ymm6, ymm8, 20
    vandps ymm1, ymm8, [c_mant]
    vfmadd213ps ymm3, ymm4, [c_pu1]
    vorps ymm5, ymm1, ymm15
    vfmadd213ps ymm3, ymm4, [c_pu0]
    vpsrld ymm8, ymm0, 23
    vpsrld ymm1, ymm0, 26
    vpermps ymm4, ymm8, [c_tlh]
    vpermps ymm0, ymm1, [c_thi]
    vfmadd231ps ymm9, ymm7, ymm3
    vmovaps ymm8, ymm2
    vfmsub213ps ymm8, ymm15, [c_c1q]
    vandnps ymm1, ymm14, [rsp+1056]
    vpmaxsd ymm7, ymm1, ymm12
    vmulps ymm3, ymm4, ymm0
    vmovups ymm1, [c_pu2]
    vfmadd231ps ymm2, ymm8, ymm9
    vpsrld ymm4, ymm7, 20
    vandps ymm0, ymm7, [c_mant]
    vorps ymm8, ymm0, ymm15
    vdivps ymm9, ymm13, ymm2
    vfmsub213ps ymm9, ymm15, [c_bq]
    vmovaps [rsp+2560], ymm9
    vpermps ymm0, ymm4, ymm11
    vpermps ymm2, ymm4, ymm10
    vfmsub213ps ymm8, ymm0, ymm15
    vpsrld ymm9, ymm7, 23
    vpslld ymm4, ymm7, 5
    vpslld ymm0, ymm7, 4
    vpermps ymm7, ymm9, [c_uq1]
    vfmadd231ps ymm1, ymm8, [c_pu3]
    vfmadd213ps ymm1, ymm8, [c_pu1]
    vfmadd213ps ymm1, ymm8, [c_pu0]
    vfmadd231ps ymm8, ymm2, ymm8
    vfmadd231ps ymm2, ymm8, ymm1
    vpermps ymm8, ymm9, [c_uq2]
    vpermps ymm1, ymm9, [c_uq0]
    vblendvps ymm9, ymm7, ymm8, ymm4
    vpermps ymm7, ymm6, [c_w1q]
    vpermps ymm8, ymm6, [c_r1q]
    vblendvps ymm4, ymm9, ymm1, ymm0
    vandnps ymm6, ymm14, [rsp+1088]
    vmovups ymm9, [c_q11]
    vpmaxsd ymm1, ymm6, ymm12
    vmulps ymm0, ymm3, ymm7
    vpsrld ymm6, ymm1, 20
    vfmsub213ps ymm5, ymm8, ymm15
    vpsrld ymm3, ymm1, 23
    vmovaps ymm7, ymm4
    vfmsub213ps ymm7, ymm15, [c_c1q]
    vfmadd231ps ymm9, ymm5, [c_q12]
    vfmadd231ps ymm4, ymm7, ymm2
    vandps ymm8, ymm1, [c_mant]
    vorps ymm7, ymm8, ymm15
    vfmadd213ps ymm9, ymm5, [c_q10]
    vmulps ymm2, ymm0, ymm5
    jmp .j2752
    ALIGN 64
.j2752:
    vdivps ymm8, ymm13, ymm4
    vfmadd231ps ymm0, ymm2, ymm9
    vandnps ymm5, ymm14, [rsp+1120]
    vmovups ymm4, [c_s1q]
    vpmaxsd ymm2, ymm5, ymm12
    vfmsub213ps ymm8, ymm15, [c_bq]
    vfnmsub231ps ymm4, ymm0, [c_c3]
    vsubps ymm9, ymm0, [c_s1q]
    vmovaps [rsp+2592], ymm8
    vpermps ymm5, ymm6, ymm11
    vpermps ymm0, ymm6, ymm10
    vdivps ymm8, ymm9, ymm4
    vmovups ymm6, [c_pu2]
    vfmsub213ps ymm7, ymm5, ymm15
    vpslld ymm9, ymm1, 5
    vpslld ymm4, ymm1, 4
    vpermps ymm5, ymm3, [c_uq1]
    vpermps ymm1, ymm3, [c_uq2]
    vpermps ymm3, ymm3, [c_uq0]
    vblendvps ymm5, ymm5, ymm1, ymm9
    vblendvps ymm1, ymm5, ymm3, ymm4
    vmovups ymm9, [c_pu2]
    vpsrld ymm5, ymm2, 20
    vmovaps [rsp+5216], ymm8
    vmovups ymm3, [rsp+5344]
    vfmadd231ps ymm9, ymm7, [c_pu3]
    vfmadd213ps ymm9, ymm7, [c_pu1]
    vfmadd213ps ymm9, ymm7, [c_pu0]
    vfmadd231ps ymm7, ymm0, ymm7
    vfmadd231ps ymm0, ymm7, ymm9
    vmovaps ymm4, ymm1
    vfmsub213ps ymm4, ymm15, [c_c1q]
    vandps ymm8, ymm2, [c_mant]
    vorps ymm7, ymm8, ymm15
    vfmadd231ps ymm1, ymm4, ymm0
    vpermps ymm9, ymm5, ymm11
    vpsrld ymm8, ymm2, 23
    vpermps ymm4, ymm5, ymm10
    vdivps ymm0, ymm13, ymm1
    vfmsub213ps ymm7, ymm9, ymm15
    vpslld ymm5, ymm2, 5
    vpslld ymm1, ymm2, 4
    vfmadd231ps ymm6, ymm7, [c_pu3]
    vfmadd213ps ymm6, ymm7, [c_pu1]
    vfmsub213ps ymm0, ymm15, [c_bq]
    vfmadd213ps ymm6, ymm7, [c_pu0]
    vfmadd231ps ymm7, ymm4, ymm7
    vmovaps [rsp+2624], ymm0
    vpermps ymm9, ymm8, [c_uq1]
    vpermps ymm2, ymm8, [c_uq2]
    vpermps ymm0, ymm8, [c_uq0]
    vfmadd231ps ymm4, ymm7, ymm6
    vandnps ymm8, ymm14, [rsp+1344]
    vpmaxsd ymm7, ymm8, ymm12
    vblendvps ymm6, ymm9, ymm2, ymm5
    vandnps ymm8, ymm14, ymm3
    vpsrld ymm9, ymm3, 20
    vandps ymm2, ymm3, [c_mant]
    vblendvps ymm5, ymm6, ymm0, ymm1
    vpmaxsd ymm3, ymm8, [c_xlh]
    vpsrld ymm6, ymm7, 20
    vandps ymm0, ymm7, [c_mant]
    vmovaps ymm1, ymm5
    vfmsub213ps ymm1, ymm15, [c_c1q]
    jmp .j2816
    ALIGN 64
.j2816:
    vorps ymm8, ymm0, ymm15
    vorps ymm0, ymm2, ymm15
    vfmadd231ps ymm5, ymm1, ymm4
    vpsrld ymm2, ymm3, 23
    vpsrld ymm1, ymm3, 26
    vpermps ymm4, ymm2, [c_tlh]
    vpermps ymm3, ymm1, [c_thi]
    vdivps ymm2, ymm13, ymm5
    vmulps ymm1, ymm4, ymm3
    vpermps ymm5, ymm9, [c_w1q]
    vpermps ymm4, ymm9, [c_r1q]
    vmulps ymm3, ymm1, ymm5
    vandnps ymm9, ymm14, [rsp+1376]
    vfmsub213ps ymm0, ymm4, ymm15
    vmovups ymm1, [c_q11]
    vpmaxsd ymm5, ymm9, ymm12
    vfmsub213ps ymm2, ymm15, [c_bq]
    vfmadd231ps ymm1, ymm0, [c_q12]
    vmovaps [rsp+2656], ymm2
    vpermps ymm4, ymm6, ymm11
    vpermps ymm9, ymm6, ymm10
    vfmadd213ps ymm1, ymm0, [c_q10]
    vmulps ymm2, ymm3, ymm0
    vfmsub213ps ymm8, ymm4, ymm15
    vpsrld ymm6, ymm7, 23
    vpslld ymm0, ymm7, 5
    vpslld ymm4, ymm7, 4
    vpermps ymm7, ymm6, [c_uq1]
    vfmadd231ps ymm3, ymm2, ymm1
    vpermps ymm2, ymm6, [c_uq2]
    vpermps ymm1, ymm6, [c_uq0]
    vblendvps ymm6, ymm7, ymm2, ymm0
    vmovups ymm7, [c_pu2]
    vblendvps ymm2, ymm6, ymm1, ymm4
    vmovaps ymm0, ymm8
    vfmadd231ps ymm0, ymm9, ymm8
    vpsrld ymm6, ymm5, 20
    vfmadd231ps ymm7, ymm8, [c_pu3]
    vfmadd213ps ymm7, ymm8, [c_pu1]
    vfmadd213ps ymm7, ymm8, [c_pu0]
    vandps ymm1, ymm5, [c_mant]
    vorps ymm4, ymm1, ymm15
    vfmadd231ps ymm9, ymm0, ymm7
    vmovaps ymm8, ymm2
    vfmsub213ps ymm8, ymm15, [c_c1q]
    vpermps ymm1, ymm6, ymm11
    vpermps ymm0, ymm6, ymm10
    vfmadd231ps ymm2, ymm8, ymm9
    vfmsub213ps ymm4, ymm1, ymm15
    vpsrld ymm7, ymm5, 23
    vpslld ymm6, ymm5, 5
    vmovups ymm8, [c_pu2]
    vpslld ymm9, ymm5, 4
    vdivps ymm1, ymm13, ymm2
    vfmadd231ps ymm8, ymm4, [c_pu3]
    vfmadd213ps ymm8, ymm4, [c_pu1]
    vfmsub213ps ymm1, ymm15, [c_bq]
    vfmadd213ps ymm8, ymm4, [c_pu0]
    vfmadd231ps ymm4, ymm0, ymm4
    vmovaps [rsp+2880], ymm1
    vpermps ymm5, ymm7, [c_uq1]
    vpermps ymm2, ymm7, [c_uq2]
    vpermps ymm1, ymm7, [c_uq0]
    vfmadd231ps ymm0, ymm4, ymm8
    jmp .j2880
    ALIGN 64
.j2880:
    vandnps ymm7, ymm14, [rsp+1408]
    vpmaxsd ymm4, ymm7, ymm12
    vblendvps ymm8, ymm5, ymm2, ymm6
    vpsrld ymm7, ymm4, 20
    vandps ymm5, ymm4, [c_mant]
    vblendvps ymm2, ymm8, ymm1, ymm9
    vorps ymm6, ymm5, ymm15
    vpermps ymm8, ymm7, ymm11
    vsubps ymm1, ymm3, [c_s1q]
    vmovaps ymm9, ymm2
    vfmsub213ps ymm9, ymm15, [c_c1q]
    vpermps ymm5, ymm7, ymm10
    vfmsub213ps ymm6, ymm8, ymm15
    vfmadd231ps ymm2, ymm9, ymm0
    vpsrld ymm7, ymm4, 23
    vpslld ymm8, ymm4, 5
    vpslld ymm9, ymm4, 4
    vdivps ymm0, ymm13, ymm2
    vfmsub213ps ymm0, ymm15, [c_bq]
    vmovaps [rsp+2912], ymm0
    vmovups ymm4, [c_s1q]
    vpermps ymm2, ymm7, [c_uq1]
    vpermps ymm0, ymm7, [c_uq2]
    vpermps ymm7, ymm7, [c_uq0]
    vblendvps ymm2, ymm2, ymm0, ymm8
    vfnmsub231ps ymm4, ymm3, [c_c3]
    vblendvps ymm0, ymm2, ymm7, ymm9
    vmovups ymm8, [c_pu2]
    vmovaps ymm3, ymm6
    vfmadd231ps ymm3, ymm5, ymm6
    vmovups ymm2, [rsp+5440]
    vdivps ymm7, ymm1, ymm4
    vandnps ymm9, ymm14, [rsp+1440]
    vpmaxsd ymm1, ymm9, ymm12
    vfmadd231ps ymm8, ymm6, [c_pu3]
    vfmadd213ps ymm8, ymm6, [c_pu1]
    vmovaps [rsp+5312], ymm7
    vandnps ymm4, ymm14, ymm2
    vfmadd213ps ymm8, ymm6, [c_pu0]
    vpsrld ymm9, ymm1, 20
    vpmaxsd ymm7, ymm4, [c_xlh]
    vfmadd231ps ymm5, ymm3, ymm8
    vmovaps ymm6, ymm0
    vfmsub213ps ymm6, ymm15, [c_c1q]
    vandps ymm4, ymm1, [c_mant]
    vorps ymm3, ymm4, ymm15
    vfmadd231ps ymm0, ymm6, ymm5
    vpermps ymm8, ymm9, ymm11
    vpsrld ymm4, ymm2, 20
    vpermps ymm6, ymm9, ymm10
    vandps ymm5, ymm2, [c_mant]
    vorps ymm9, ymm5, ymm15
    vdivps ymm2, ymm13, ymm0
    vfmsub213ps ymm3, ymm8, ymm15
    vpsrld ymm5, ymm1, 23
    vfmsub213ps ymm2, ymm15, [c_bq]
    vmovaps [rsp+2944], ymm2
    vpslld ymm0, ymm1, 5
    vpslld ymm8, ymm1, 4
    vpsrld ymm2, ymm7, 23
    vpsrld ymm1, ymm7, 26
    vpermps ymm7, ymm5, [c_uq1]
    vpermps ymm2, ymm2, [c_tlh]
    vpermps ymm1, ymm1, [c_thi]
    jmp .j2944
    ALIGN 64
.j2944:
    vmulps ymm2, ymm2, ymm1
    vpermps ymm1, ymm5, [c_uq2]
    vpermps ymm5, ymm5, [c_uq0]
    vblendvps ymm7, ymm7, ymm1, ymm0
    vblendvps ymm1, ymm7, ymm5, ymm8
    vmovups ymm0, [c_pu2]
    vpermps ymm7, ymm4, [c_w1q]
    vpermps ymm5, ymm4, [c_r1q]
    vmulps ymm8, ymm2, ymm7
    vmovups ymm4, [c_pu2]
    vfmsub213ps ymm9, ymm5, ymm15
    vmovups ymm2, [c_q11]
    vfmadd231ps ymm0, ymm3, [c_pu3]
    vfmadd213ps ymm0, ymm3, [c_pu1]
    vfmadd231ps ymm2, ymm9, [c_q12]
    vfmadd213ps ymm0, ymm3, [c_pu0]
    vfmadd231ps ymm3, ymm6, ymm3
    vfmadd213ps ymm2, ymm9, [c_q10]
    vmulps ymm7, ymm8, ymm9
    vfmadd231ps ymm6, ymm3, ymm0
    vmovaps ymm5, ymm1
    vfmsub213ps ymm5, ymm15, [c_c1q]
    vandnps ymm9, ymm14, [rsp+1472]
    vpmaxsd ymm3, ymm9, ymm12
    vandnps ymm0, ymm14, [rsp+1504]
    vfmadd231ps ymm8, ymm7, ymm2
    vmovups ymm9, [c_s1q]
    vpsrld ymm14, ymm3, 20
    vpmaxsd ymm7, ymm0, ymm12
    vmovups ymm2, [c_pu2]
    vfmadd231ps ymm1, ymm5, ymm6
    vandps ymm0, ymm3, [c_mant]
    vpermps ymm12, ymm14, ymm11
    vpermps ymm5, ymm14, ymm10
    vorps ymm6, ymm0, ymm15
    vdivps ymm14, ymm13, ymm1
    vfmsub213ps ymm6, ymm12, ymm15
    vpsrld ymm0, ymm3, 23
    vfnmsub231ps ymm9, ymm8, [c_c3]
    vsubps ymm1, ymm8, [c_s1q]
    vfmadd231ps ymm4, ymm6, [c_pu3]
    vdivps ymm12, ymm1, ymm9
    vpslld ymm8, ymm3, 5
    vpslld ymm1, ymm3, 4
    vfmadd213ps ymm4, ymm6, [c_pu1]
    vfmsub213ps ymm14, ymm15, [c_bq]
    vfmadd213ps ymm4, ymm6, [c_pu0]
    vfmadd231ps ymm6, ymm5, ymm6
    vmovaps [rsp+2976], ymm14
    vpermps ymm9, ymm0, [c_uq1]
    vpermps ymm3, ymm0, [c_uq2]
    vpermps ymm14, ymm0, [c_uq0]
    vmovaps [rsp+5408], ymm12
    vfmadd231ps ymm5, ymm6, ymm4
    vpsrld ymm0, ymm7, 20
    vandps ymm12, ymm7, [c_mant]
    vorps ymm6, ymm12, ymm15
    vpermps ymm4, ymm0, ymm11
    vpermps ymm12, ymm0, ymm10
    vpsrld ymm11, ymm7, 23
    vblendvps ymm0, ymm9, ymm3, ymm8
    vpslld ymm10, ymm7, 5
    vpslld ymm9, ymm7, 4
    vpermps ymm3, ymm11, [c_uq1]
    jmp .j3008
    ALIGN 64
.j3008:
    vblendvps ymm8, ymm0, ymm14, ymm1
    vpermps ymm7, ymm11, [c_uq2]
    vpermps ymm0, ymm11, [c_uq0]
    vmovaps ymm14, ymm8
    vfmsub213ps ymm14, ymm15, [c_c1q]
    vfmsub213ps ymm6, ymm4, ymm15
    vblendvps ymm1, ymm3, ymm7, ymm10
    vfmadd231ps ymm8, ymm14, ymm5
    vblendvps ymm11, ymm1, ymm0, ymm9
    vfmadd231ps ymm2, ymm6, [c_pu3]
    vmovaps ymm4, ymm6
    vfmadd231ps ymm4, ymm12, ymm6
    vmovaps ymm3, ymm11
    vfmsub213ps ymm3, ymm15, [c_c1q]
    vdivps ymm7, ymm13, ymm8
    vfmadd213ps ymm2, ymm6, [c_pu1]
    vfmadd213ps ymm2, ymm6, [c_pu0]
    vfmadd231ps ymm12, ymm4, ymm2
    vfmsub213ps ymm7, ymm15, [c_bq]
    vfmadd231ps ymm11, ymm3, ymm12
    vmovaps [rsp+3008], ymm7
    vdivps ymm10, ymm13, ymm11
    vfmsub213ps ymm10, ymm15, [c_bq]
    vmovaps [rsp+3040], ymm10
.g_qy:
    vmovups ymm15, [c_one]
    vmovups ymm14, [c_sign]
    vmovups ymm13, [c_t68]
    vmovups ymm12, [c_w68]
    vmovups ymm11, [c_rq8]
    vmovups ymm10, [c_q60]
    vmovups ymm9, [c_q61]
    vmovups ymm8, [c_q62]
    vmovups ymm7, [c_q63]
    vmovups ymm6, [c_mant]
    vmovups ymm0, [rsp+1536]
    vpsrld ymm1, ymm0, 20
    vpsrld ymm2, ymm0, 23
    vandps ymm3, ymm0, ymm6
    vpermps ymm4, ymm2, ymm13
    vpermps ymm5, ymm1, ymm12
    vorps ymm0, ymm3, ymm15
    vpermps ymm2, ymm1, ymm11
    vmulps ymm3, ymm4, ymm5
    vandps ymm1, ymm14, [rsp]
    vfmsub213ps ymm0, ymm2, ymm15
    vmovups ymm4, [rsp+1568]
    vmovaps ymm5, ymm8
    vfmadd231ps ymm5, ymm7, ymm0
    vfmadd213ps ymm5, ymm0, ymm9
    vfmadd213ps ymm5, ymm0, ymm10
    vmulps ymm2, ymm3, ymm0
    vfmadd231ps ymm3, ymm2, ymm5
    vpsrld ymm0, ymm4, 20
    vorps ymm2, ymm3, ymm1
    vpsrld ymm5, ymm4, 23
    vandps ymm3, ymm4, ymm6
    vmovaps [rsp+1536], ymm2
    vpermps ymm1, ymm5, ymm13
    vorps ymm4, ymm3, ymm15
    vpermps ymm5, ymm0, ymm12
    vpermps ymm3, ymm0, ymm11
    vmulps ymm0, ymm1, ymm5
    vfmsub213ps ymm4, ymm3, ymm15
    vandps ymm1, ymm14, [rsp+32]
    jmp .j3072
    ALIGN 64
.j3072:
    vmovaps ymm5, ymm8
    vfmadd231ps ymm5, ymm7, ymm4
    vfmadd213ps ymm5, ymm4, ymm9
    vfmadd213ps ymm5, ymm4, ymm10
    vmulps ymm3, ymm0, ymm4
    vfmadd231ps ymm0, ymm3, ymm5
    vmovups ymm4, [rsp+1600]
    vorps ymm3, ymm0, ymm1
    vmovaps [rsp+1568], ymm3
    vpsrld ymm5, ymm4, 20
    vpsrld ymm0, ymm4, 23
    vandps ymm1, ymm4, ymm6
    vpermps ymm4, ymm0, ymm13
    vorps ymm0, ymm1, ymm15
    vpermps ymm1, ymm5, ymm12
    vpermps ymm5, ymm5, ymm11
    vmulps ymm4, ymm4, ymm1
    vfmsub213ps ymm0, ymm5, ymm15
    vmovaps ymm1, ymm8
    vfmadd231ps ymm1, ymm7, ymm0
    vpmaxud ymm5, ymm2, ymm3
    vfmadd213ps ymm1, ymm0, ymm9
    vfmadd213ps ymm1, ymm0, ymm10
    vmulps ymm2, ymm4, ymm0
    vfmadd231ps ymm4, ymm2, ymm1
    vandps ymm3, ymm14, [rsp+64]
    vmovups ymm0, [rsp+1632]
    vorps ymm2, ymm4, ymm3
    vmovaps [rsp+1600], ymm2
    vpmaxud ymm1, ymm5, ymm2
    vpminsd ymm4, ymm1, [c_zero]
    vmovaps [rsp+3072], ymm4
    vpsrld ymm3, ymm0, 20
    vpsrld ymm5, ymm0, 23
    vandps ymm2, ymm0, ymm6
    vpermps ymm1, ymm5, ymm13
    vpermps ymm4, ymm3, ymm12
    vorps ymm0, ymm2, ymm15
    vpermps ymm5, ymm3, ymm11
    vmulps ymm2, ymm1, ymm4
    vandps ymm3, ymm14, [rsp+96]
    vfmsub213ps ymm0, ymm5, ymm15
    vmovups ymm1, [rsp+1664]
    vmovaps ymm4, ymm8
    vfmadd231ps ymm4, ymm7, ymm0
    vfmadd213ps ymm4, ymm0, ymm9
    vfmadd213ps ymm4, ymm0, ymm10
    vmulps ymm5, ymm2, ymm0
    vfmadd231ps ymm2, ymm5, ymm4
    vpsrld ymm0, ymm1, 20
    vorps ymm5, ymm2, ymm3
    vpsrld ymm4, ymm1, 23
    vandps ymm2, ymm1, ymm6
    vmovaps [rsp+1632], ymm5
    vpermps ymm3, ymm4, ymm13
    vorps ymm1, ymm2, ymm15
    vpermps ymm4, ymm0, ymm12
    vpermps ymm2, ymm0, ymm11
    vmulps ymm0, ymm3, ymm4
    vfmsub213ps ymm1, ymm2, ymm15
    vandps ymm3, ymm14, [rsp+128]
    vmovaps ymm4, ymm8
    vfmadd231ps ymm4, ymm7, ymm1
    vfmadd213ps ymm4, ymm1, ymm9
    jmp .j3136
    ALIGN 64
.j3136:
    vfmadd213ps ymm4, ymm1, ymm10
    vmulps ymm2, ymm0, ymm1
    vfmadd231ps ymm0, ymm2, ymm4
    vmovups ymm1, [rsp+1696]
    vorps ymm2, ymm0, ymm3
    vmovaps [rsp+1664], ymm2
    vpsrld ymm4, ymm1, 20
    vpsrld ymm0, ymm1, 23
    vandps ymm3, ymm1, ymm6
    vpermps ymm1, ymm0, ymm13
    vorps ymm0, ymm3, ymm15
    vpermps ymm3, ymm4, ymm12
    vpermps ymm4, ymm4, ymm11
    vmulps ymm1, ymm1, ymm3
    vfmsub213ps ymm0, ymm4, ymm15
    vmovaps ymm3, ymm8
    vfmadd231ps ymm3, ymm7, ymm0
    vpmaxud ymm4, ymm5, ymm2
    vfmadd213ps ymm3, ymm0, ymm9
    vfmadd213ps ymm3, ymm0, ymm10
    vmulps ymm5, ymm1, ymm0
    vfmadd231ps ymm1, ymm5, ymm3
    vandps ymm2, ymm14, [rsp+160]
    vmovups ymm0, [rsp+1920]
    vorps ymm5, ymm1, ymm2
    vmovaps [rsp+1696], ymm5
    vpmaxud ymm3, ymm4, ymm5
    vpminsd ymm1, ymm3, [c_zero]
    vmovaps [rsp+3104], ymm1
    vpsrld ymm2, ymm0, 20
    vpsrld ymm4, ymm0, 23
    vandps ymm5, ymm0, ymm6
    vpermps ymm3, ymm4, ymm13
    vpermps ymm1, ymm2, ymm12
    vorps ymm0, ymm5, ymm15
    vpermps ymm4, ymm2, ymm11
    vmulps ymm5, ymm3, ymm1
    vandps ymm2, ymm14, [rsp+384]
    vfmsub213ps ymm0, ymm4, ymm15
    vmovups ymm3, [rsp+1952]
    vmovaps ymm1, ymm8
    vfmadd231ps ymm1, ymm7, ymm0
    vfmadd213ps ymm1, ymm0, ymm9
    vfmadd213ps ymm1, ymm0, ymm10
    vmulps ymm4, ymm5, ymm0
    vfmadd231ps ymm5, ymm4, ymm1
    vpsrld ymm0, ymm3, 20
    vorps ymm4, ymm5, ymm2
    vpsrld ymm1, ymm3, 23
    vandps ymm5, ymm3, ymm6
    vmovaps [rsp+1920], ymm4
    vpermps ymm2, ymm1, ymm13
    vorps ymm3, ymm5, ymm15
    vpermps ymm1, ymm0, ymm12
    vpermps ymm5, ymm0, ymm11
    vmulps ymm0, ymm2, ymm1
    vfmsub213ps ymm3, ymm5, ymm15
    vandps ymm2, ymm14, [rsp+416]
    vmovaps ymm1, ymm8
    vfmadd231ps ymm1, ymm7, ymm3
    vfmadd213ps ymm1, ymm3, ymm9
    vfmadd213ps ymm1, ymm3, ymm10
    vmulps ymm5, ymm0, ymm3
    vfmadd231ps ymm0, ymm5, ymm1
    jmp .j3200
    ALIGN 64
.j3200:
    vmovups ymm3, [rsp+1984]
    vorps ymm5, ymm0, ymm2
    vmovaps [rsp+1952], ymm5
    vpsrld ymm1, ymm3, 20
    vpsrld ymm0, ymm3, 23
    vandps ymm2, ymm3, ymm6
    vpermps ymm3, ymm0, ymm13
    vorps ymm0, ymm2, ymm15
    vpermps ymm2, ymm1, ymm12
    vpermps ymm1, ymm1, ymm11
    vmulps ymm3, ymm3, ymm2
    vfmsub213ps ymm0, ymm1, ymm15
    vmovaps ymm2, ymm8
    vfmadd231ps ymm2, ymm7, ymm0
    vpmaxud ymm1, ymm4, ymm5
    vfmadd213ps ymm2, ymm0, ymm9
    vfmadd213ps ymm2, ymm0, ymm10
    vmulps ymm4, ymm3, ymm0
    vfmadd231ps ymm3, ymm4, ymm2
    vandps ymm5, ymm14, [rsp+448]
    vmovups ymm0, [rsp+2016]
    vorps ymm4, ymm3, ymm5
    vmovaps [rsp+1984], ymm4
    vpmaxud ymm2, ymm1, ymm4
    vpminsd ymm3, ymm2, [c_zero]
    vmovaps [rsp+3200], ymm3
    vpsrld ymm5, ymm0, 20
    vpsrld ymm1, ymm0, 23
    vandps ymm4, ymm0, ymm6
    vpermps ymm2, ymm1, ymm13
    vpermps ymm3, ymm5, ymm12
    vorps ymm0, ymm4, ymm15
    vpermps ymm1, ymm5, ymm11
    vmulps ymm4, ymm2, ymm3
    vandps ymm5, ymm14, [rsp+480]
    vfmsub213ps ymm0, ymm1, ymm15
    vmovups ymm2, [rsp+2048]
    vmovaps ymm3, ymm8
    vfmadd231ps ymm3, ymm7, ymm0
    vfmadd213ps ymm3, ymm0, ymm9
    vfmadd213ps ymm3, ymm0, ymm10
    vmulps ymm1, ymm4, ymm0
    vfmadd231ps ymm4, ymm1, ymm3
    vpsrld ymm0, ymm2, 20
    vorps ymm1, ymm4, ymm5
    vpsrld ymm3, ymm2, 23
    vandps ymm4, ymm2, ymm6
    vmovaps [rsp+2016], ymm1
    vpermps ymm5, ymm3, ymm13
    vorps ymm2, ymm4, ymm15
    vpermps ymm3, ymm0, ymm12
    vpermps ymm4, ymm0, ymm11
    vmulps ymm0, ymm5, ymm3
    vfmsub213ps ymm2, ymm4, ymm15
    vandps ymm5, ymm14, [rsp+512]
    vmovaps ymm3, ymm8
    vfmadd231ps ymm3, ymm7, ymm2
    vfmadd213ps ymm3, ymm2, ymm9
    vfmadd213ps ymm3, ymm2, ymm10
    vmulps ymm4, ymm0, ymm2
    vfmadd231ps ymm0, ymm4, ymm3
    vmovups ymm2, [rsp+2080]
    vorps ymm4, ymm0, ymm5
    vmovaps [rsp+2048], ymm4
    jmp .j3264
    ALIGN 64
.j3264:
    vpsrld ymm3, ymm2, 20
    vpsrld ymm0, ymm2, 23
    vandps ymm5, ymm2, ymm6
    vpermps ymm2, ymm0, ymm13
    vorps ymm0, ymm5, ymm15
    vpermps ymm5, ymm3, ymm12
    vpermps ymm3, ymm3, ymm11
    vmulps ymm2, ymm2, ymm5
    vfmsub213ps ymm0, ymm3, ymm15
    vmovaps ymm5, ymm8
    vfmadd231ps ymm5, ymm7, ymm0
    vpmaxud ymm3, ymm1, ymm4
    vfmadd213ps ymm5, ymm0, ymm9
    vfmadd213ps ymm5, ymm0, ymm10
    vmulps ymm1, ymm2, ymm0
    vfmadd231ps ymm2, ymm1, ymm5
    vandps ymm4, ymm14, [rsp+544]
    vmovups ymm0, [rsp+2304]
    vorps ymm1, ymm2, ymm4
    vmovaps [rsp+2080], ymm1
    vpmaxud ymm5, ymm3, ymm1
    vpminsd ymm2, ymm5, [c_zero]
    vmovaps [rsp+3232], ymm2
    vpsrld ymm4, ymm0, 20
    vpsrld ymm3, ymm0, 23
    vandps ymm1, ymm0, ymm6
    vpermps ymm5, ymm3, ymm13
    vpermps ymm2, ymm4, ymm12
    vorps ymm0, ymm1, ymm15
    vpermps ymm3, ymm4, ymm11
    vmulps ymm1, ymm5, ymm2
    vandps ymm4, ymm14, [rsp+768]
    vfmsub213ps ymm0, ymm3, ymm15
    vmovups ymm5, [rsp+2336]
    vmovaps ymm2, ymm8
    vfmadd231ps ymm2, ymm7, ymm0
    vfmadd213ps ymm2, ymm0, ymm9
    vfmadd213ps ymm2, ymm0, ymm10
    vmulps ymm3, ymm1, ymm0
    vfmadd231ps ymm1, ymm3, ymm2
    vpsrld ymm0, ymm5, 20
    vorps ymm3, ymm1, ymm4
    vpsrld ymm2, ymm5, 23
    vandps ymm1, ymm5, ymm6
    vmovaps [rsp+2304], ymm3
    vpermps ymm4, ymm2, ymm13
    vorps ymm5, ymm1, ymm15
    vpermps ymm2, ymm0, ymm12
    vpermps ymm1, ymm0, ymm11
    vmulps ymm0, ymm4, ymm2
    vfmsub213ps ymm5, ymm1, ymm15
    vandps ymm4, ymm14, [rsp+800]
    vmovaps ymm2, ymm8
    vfmadd231ps ymm2, ymm7, ymm5
    vfmadd213ps ymm2, ymm5, ymm9
    vfmadd213ps ymm2, ymm5, ymm10
    vmulps ymm1, ymm0, ymm5
    vfmadd231ps ymm0, ymm1, ymm2
    vmovups ymm5, [rsp+2368]
    vorps ymm1, ymm0, ymm4
    vmovaps [rsp+2336], ymm1
    vpsrld ymm2, ymm5, 20
    vpsrld ymm0, ymm5, 23
    vandps ymm4, ymm5, ymm6
    jmp .j3328
    ALIGN 64
.j3328:
    vpermps ymm5, ymm0, ymm13
    vorps ymm0, ymm4, ymm15
    vpermps ymm4, ymm2, ymm12
    vpermps ymm2, ymm2, ymm11
    vmulps ymm5, ymm5, ymm4
    vfmsub213ps ymm0, ymm2, ymm15
    vmovaps ymm4, ymm8
    vfmadd231ps ymm4, ymm7, ymm0
    vpmaxud ymm2, ymm3, ymm1
    vfmadd213ps ymm4, ymm0, ymm9
    vfmadd213ps ymm4, ymm0, ymm10
    vmulps ymm3, ymm5, ymm0
    vfmadd231ps ymm5, ymm3, ymm4
    vandps ymm1, ymm14, [rsp+832]
    vmovups ymm0, [rsp+2400]
    vorps ymm3, ymm5, ymm1
    vmovaps [rsp+2368], ymm3
    vpmaxud ymm4, ymm2, ymm3
    vpminsd ymm5, ymm4, [c_zero]
    vmovaps [rsp+3328], ymm5
    vpsrld ymm1, ymm0, 20
    vpsrld ymm2, ymm0, 23
    vandps ymm3, ymm0, ymm6
    vpermps ymm4, ymm2, ymm13
    vpermps ymm5, ymm1, ymm12
    vorps ymm0, ymm3, ymm15
    vpermps ymm2, ymm1, ymm11
    vmulps ymm3, ymm4, ymm5
    vandps ymm1, ymm14, [rsp+864]
    vfmsub213ps ymm0, ymm2, ymm15
    vmovups ymm4, [rsp+2432]
    vmovaps ymm5, ymm8
    vfmadd231ps ymm5, ymm7, ymm0
    vfmadd213ps ymm5, ymm0, ymm9
    vfmadd213ps ymm5, ymm0, ymm10
    vmulps ymm2, ymm3, ymm0
    vfmadd231ps ymm3, ymm2, ymm5
    vpsrld ymm0, ymm4, 20
    vorps ymm2, ymm3, ymm1
    vpsrld ymm5, ymm4, 23
    vandps ymm3, ymm4, ymm6
    vmovaps [rsp+2400], ymm2
    vpermps ymm1, ymm5, ymm13
    vorps ymm4, ymm3, ymm15
    vpermps ymm5, ymm0, ymm12
    vpermps ymm3, ymm0, ymm11
    vmulps ymm0, ymm1, ymm5
    vfmsub213ps ymm4, ymm3, ymm15
    vandps ymm1, ymm14, [rsp+896]
    vmovaps ymm5, ymm8
    vfmadd231ps ymm5, ymm7, ymm4
    vfmadd213ps ymm5, ymm4, ymm9
    vfmadd213ps ymm5, ymm4, ymm10
    vmulps ymm3, ymm0, ymm4
    vfmadd231ps ymm0, ymm3, ymm5
    vmovups ymm4, [rsp+2464]
    vorps ymm3, ymm0, ymm1
    vmovaps [rsp+2432], ymm3
    vpsrld ymm5, ymm4, 20
    vpsrld ymm0, ymm4, 23
    vandps ymm1, ymm4, ymm6
    vpermps ymm4, ymm0, ymm13
    vorps ymm0, ymm1, ymm15
    vpermps ymm1, ymm5, ymm12
    jmp .j3392
    ALIGN 64
.j3392:
    vpermps ymm5, ymm5, ymm11
    vmulps ymm4, ymm4, ymm1
    vfmsub213ps ymm0, ymm5, ymm15
    vmovaps ymm1, ymm8
    vfmadd231ps ymm1, ymm7, ymm0
    vpmaxud ymm5, ymm2, ymm3
    vfmadd213ps ymm1, ymm0, ymm9
    vfmadd213ps ymm1, ymm0, ymm10
    vmulps ymm2, ymm4, ymm0
    vfmadd231ps ymm4, ymm2, ymm1
    vandps ymm3, ymm14, [rsp+928]
    vmovups ymm0, [rsp+2688]
    vorps ymm2, ymm4, ymm3
    vmovaps [rsp+2464], ymm2
    vpmaxud ymm1, ymm5, ymm2
    vpminsd ymm4, ymm1, [c_zero]
    vmovaps [rsp+3360], ymm4
    vpsrld ymm3, ymm0, 20
    vpsrld ymm5, ymm0, 23
    vandps ymm2, ymm0, ymm6
    vpermps ymm1, ymm5, ymm13
    vpermps ymm4, ymm3, ymm12
    vorps ymm0, ymm2, ymm15
    vpermps ymm5, ymm3, ymm11
    vmulps ymm2, ymm1, ymm4
    vandps ymm3, ymm14, [rsp+1152]
    vfmsub213ps ymm0, ymm5, ymm15
    vmovups ymm1, [rsp+2720]
    vmovaps ymm4, ymm8
    vfmadd231ps ymm4, ymm7, ymm0
    vfmadd213ps ymm4, ymm0, ymm9
    vfmadd213ps ymm4, ymm0, ymm10
    vmulps ymm5, ymm2, ymm0
    vfmadd231ps ymm2, ymm5, ymm4
    vpsrld ymm0, ymm1, 20
    vorps ymm5, ymm2, ymm3
    vpsrld ymm4, ymm1, 23
    vandps ymm2, ymm1, ymm6
    vmovaps [rsp+2688], ymm5
    vpermps ymm3, ymm4, ymm13
    vorps ymm1, ymm2, ymm15
    vpermps ymm4, ymm0, ymm12
    vpermps ymm2, ymm0, ymm11
    vmulps ymm0, ymm3, ymm4
    vfmsub213ps ymm1, ymm2, ymm15
    vandps ymm3, ymm14, [rsp+1184]
    vmovaps ymm4, ymm8
    vfmadd231ps ymm4, ymm7, ymm1
    vfmadd213ps ymm4, ymm1, ymm9
    vfmadd213ps ymm4, ymm1, ymm10
    vmulps ymm2, ymm0, ymm1
    vfmadd231ps ymm0, ymm2, ymm4
    vmovups ymm1, [rsp+2752]
    vorps ymm2, ymm0, ymm3
    vmovaps [rsp+2720], ymm2
    vpsrld ymm4, ymm1, 20
    vpsrld ymm0, ymm1, 23
    vandps ymm3, ymm1, ymm6
    vpermps ymm1, ymm0, ymm13
    vorps ymm0, ymm3, ymm15
    vpermps ymm3, ymm4, ymm12
    vpermps ymm4, ymm4, ymm11
    vmulps ymm1, ymm1, ymm3
    vfmsub213ps ymm0, ymm4, ymm15
    jmp .j3456
    ALIGN 64
.j3456:
    vmovaps ymm3, ymm8
    vfmadd231ps ymm3, ymm7, ymm0
    vpmaxud ymm4, ymm5, ymm2
    vfmadd213ps ymm3, ymm0, ymm9
    vfmadd213ps ymm3, ymm0, ymm10
    vmulps ymm5, ymm1, ymm0
    vfmadd231ps ymm1, ymm5, ymm3
    vandps ymm2, ymm14, [rsp+1216]
    vmovups ymm0, [rsp+2784]
    vorps ymm5, ymm1, ymm2
    vmovaps [rsp+2752], ymm5
    vpmaxud ymm3, ymm4, ymm5
    vpminsd ymm1, ymm3, [c_zero]
    vmovaps [rsp+3456], ymm1
    vpsrld ymm2, ymm0, 20
    vpsrld ymm4, ymm0, 23
    vandps ymm5, ymm0, ymm6
    vpermps ymm3, ymm4, ymm13
    vpermps ymm1, ymm2, ymm12
    vorps ymm0, ymm5, ymm15
    vpermps ymm4, ymm2, ymm11
    vmulps ymm5, ymm3, ymm1
    vandps ymm2, ymm14, [rsp+1248]
    vfmsub213ps ymm0, ymm4, ymm15
    vmovups ymm3, [rsp+2816]
    vmovaps ymm1, ymm8
    vfmadd231ps ymm1, ymm7, ymm0
    vfmadd213ps ymm1, ymm0, ymm9
    vfmadd213ps ymm1, ymm0, ymm10
    vmulps ymm4, ymm5, ymm0
    vfmadd231ps ymm5, ymm4, ymm1
    vpsrld ymm0, ymm3, 20
    vorps ymm4, ymm5, ymm2
    vpsrld ymm1, ymm3, 23
    vandps ymm5, ymm3, ymm6
    vmovaps [rsp+2784], ymm4
    vpermps ymm2, ymm1, ymm13
    vorps ymm3, ymm5, ymm15
    vpermps ymm1, ymm0, ymm12
    vpermps ymm5, ymm0, ymm11
    vmulps ymm0, ymm2, ymm1
    vfmsub213ps ymm3, ymm5, ymm15
    vandps ymm2, ymm14, [rsp+1280]
    vmovaps ymm1, ymm8
    vfmadd231ps ymm1, ymm7, ymm3
    vfmadd213ps ymm1, ymm3, ymm9
    vfmadd213ps ymm1, ymm3, ymm10
    vmulps ymm5, ymm0, ymm3
    vfmadd231ps ymm0, ymm5, ymm1
    vmovups ymm3, [rsp+2848]
    vorps ymm5, ymm0, ymm2
    vmovaps [rsp+2816], ymm5
    vpsrld ymm1, ymm3, 20
    vpsrld ymm0, ymm3, 23
    vandps ymm2, ymm3, ymm6
    vpermps ymm3, ymm0, ymm13
    vorps ymm0, ymm2, ymm15
    vpermps ymm2, ymm1, ymm12
    vpermps ymm1, ymm1, ymm11
    vmulps ymm3, ymm3, ymm2
    vfmsub213ps ymm0, ymm1, ymm15
    vmovaps ymm2, ymm8
    vfmadd231ps ymm2, ymm7, ymm0
    vpmaxud ymm1, ymm4, ymm5
    jmp .j3520
    ALIGN 64
.j3520:
    vfmadd213ps ymm2, ymm0, ymm9
    vfmadd213ps ymm2, ymm0, ymm10
    vmulps ymm4, ymm3, ymm0
    vfmadd231ps ymm3, ymm4, ymm2
    vandps ymm5, ymm14, [rsp+1312]
    vmovups ymm0, [rsp+1728]
    vorps ymm4, ymm3, ymm5
    vmovaps [rsp+2848], ymm4
    vpmaxud ymm2, ymm1, ymm4
    vpminsd ymm3, ymm2, [c_zero]
    vmovaps [rsp+3488], ymm3
    vpsrld ymm5, ymm0, 20
    vpsrld ymm1, ymm0, 23
    vandps ymm4, ymm0, ymm6
    vpermps ymm2, ymm1, ymm13
    vpermps ymm3, ymm5, ymm12
    vorps ymm0, ymm4, ymm15
    vpermps ymm1, ymm5, ymm11
    vmulps ymm4, ymm2, ymm3
    vandps ymm5, ymm14, [rsp+192]
    vfmsub213ps ymm0, ymm1, ymm15
    vmovups ymm2, [rsp+1760]
    vmovaps ymm3, ymm8
    vfmadd231ps ymm3, ymm7, ymm0
    vfmadd213ps ymm3, ymm0, ymm9
    vfmadd213ps ymm3, ymm0, ymm10
    vmulps ymm1, ymm4, ymm0
    vfmadd231ps ymm4, ymm1, ymm3
    vpsrld ymm0, ymm2, 20
    vorps ymm1, ymm4, ymm5
    vpsrld ymm3, ymm2, 23
    vandps ymm4, ymm2, ymm6
    vmovaps [rsp+1728], ymm1
    vpermps ymm5, ymm3, ymm13
    vorps ymm2, ymm4, ymm15
    vpermps ymm3, ymm0, ymm12
    vpermps ymm4, ymm0, ymm11
    vmulps ymm0, ymm5, ymm3
    vfmsub213ps ymm2, ymm4, ymm15
    vandps ymm5, ymm14, [rsp+224]
    vmovaps ymm3, ymm8
    vfmadd231ps ymm3, ymm7, ymm2
    vfmadd213ps ymm3, ymm2, ymm9
    vfmadd213ps ymm3, ymm2, ymm10
    vmulps ymm4, ymm0, ymm2
    vfmadd231ps ymm0, ymm4, ymm3
    vmovups ymm2, [rsp+1792]
    vorps ymm4, ymm0, ymm5
    vmovaps [rsp+1760], ymm4
    vpsrld ymm3, ymm2, 20
    vpsrld ymm0, ymm2, 23
    vandps ymm5, ymm2, ymm6
    vpermps ymm2, ymm0, ymm13
    vorps ymm0, ymm5, ymm15
    vpermps ymm5, ymm3, ymm12
    vpermps ymm3, ymm3, ymm11
    vmulps ymm2, ymm2, ymm5
    vfmsub213ps ymm0, ymm3, ymm15
    vmovaps ymm5, ymm8
    vfmadd231ps ymm5, ymm7, ymm0
    vpmaxud ymm3, ymm1, ymm4
    vfmadd213ps ymm5, ymm0, ymm9
    vfmadd213ps ymm5, ymm0, ymm10
    vmulps ymm1, ymm2, ymm0
    jmp .j3584
    ALIGN 64
.j3584:
    vfmadd231ps ymm2, ymm1, ymm5
    vandps ymm4, ymm14, [rsp+256]
    vmovups ymm0, [rsp+1824]
    vorps ymm1, ymm2, ymm4
    vmovaps [rsp+1792], ymm1
    vpmaxud ymm5, ymm3, ymm1
    vpminsd ymm2, ymm5, [c_zero]
    vmovaps [rsp+3136], ymm2
    vpsrld ymm4, ymm0, 20
    vpsrld ymm3, ymm0, 23
    vandps ymm1, ymm0, ymm6
    vpermps ymm5, ymm3, ymm13
    vpermps ymm2, ymm4, ymm12
    vorps ymm0, ymm1, ymm15
    vpermps ymm3, ymm4, ymm11
    vmulps ymm1, ymm5, ymm2
    vandps ymm4, ymm14, [rsp+288]
    vfmsub213ps ymm0, ymm3, ymm15
    vmovups ymm5, [rsp+1856]
    vmovaps ymm2, ymm8
    vfmadd231ps ymm2, ymm7, ymm0
    vfmadd213ps ymm2, ymm0, ymm9
    vfmadd213ps ymm2, ymm0, ymm10
    vmulps ymm3, ymm1, ymm0
    vfmadd231ps ymm1, ymm3, ymm2
    vpsrld ymm0, ymm5, 20
    vorps ymm3, ymm1, ymm4
    vpsrld ymm2, ymm5, 23
    vandps ymm1, ymm5, ymm6
    vmovaps [rsp+1824], ymm3
    vpermps ymm4, ymm2, ymm13
    vorps ymm5, ymm1, ymm15
    vpermps ymm2, ymm0, ymm12
    vpermps ymm1, ymm0, ymm11
    vmulps ymm0, ymm4, ymm2
    vfmsub213ps ymm5, ymm1, ymm15
    vandps ymm4, ymm14, [rsp+320]
    vmovaps ymm2, ymm8
    vfmadd231ps ymm2, ymm7, ymm5
    vfmadd213ps ymm2, ymm5, ymm9
    vfmadd213ps ymm2, ymm5, ymm10
    vmulps ymm1, ymm0, ymm5
    vfmadd231ps ymm0, ymm1, ymm2
    vmovups ymm5, [rsp+1888]
    vorps ymm1, ymm0, ymm4
    vmovaps [rsp+1856], ymm1
    vpsrld ymm2, ymm5, 20
    vpsrld ymm0, ymm5, 23
    vandps ymm4, ymm5, ymm6
    vpermps ymm5, ymm0, ymm13
    vorps ymm0, ymm4, ymm15
    vpermps ymm4, ymm2, ymm12
    vpermps ymm2, ymm2, ymm11
    vmulps ymm5, ymm5, ymm4
    vfmsub213ps ymm0, ymm2, ymm15
    vmovaps ymm4, ymm8
    vfmadd231ps ymm4, ymm7, ymm0
    vpmaxud ymm2, ymm3, ymm1
    vfmadd213ps ymm4, ymm0, ymm9
    vfmadd213ps ymm4, ymm0, ymm10
    vmulps ymm3, ymm5, ymm0
    vfmadd231ps ymm5, ymm3, ymm4
    vandps ymm1, ymm14, [rsp+352]
    vmovups ymm0, [rsp+2112]
    jmp .j3648
    ALIGN 64
.j3648:
    vorps ymm3, ymm5, ymm1
    vmovaps [rsp+1888], ymm3
    vpmaxud ymm4, ymm2, ymm3
    vpminsd ymm5, ymm4, [c_zero]
    vmovaps [rsp+3168], ymm5
    vpsrld ymm1, ymm0, 20
    vpsrld ymm2, ymm0, 23
    vandps ymm3, ymm0, ymm6
    vpermps ymm4, ymm2, ymm13
    vpermps ymm5, ymm1, ymm12
    vorps ymm0, ymm3, ymm15
    vpermps ymm2, ymm1, ymm11
    vmulps ymm3, ymm4, ymm5
    vandps ymm1, ymm14, [rsp+576]
    vfmsub213ps ymm0, ymm2, ymm15
    vmovups ymm4, [rsp+2144]
    vmovaps ymm5, ymm8
    vfmadd231ps ymm5, ymm7, ymm0
    vfmadd213ps ymm5, ymm0, ymm9
    vfmadd213ps ymm5, ymm0, ymm10
    vmulps ymm2, ymm3, ymm0
    vfmadd231ps ymm3, ymm2, ymm5
    vpsrld ymm0, ymm4, 20
    vorps ymm2, ymm3, ymm1
    vpsrld ymm5, ymm4, 23
    vandps ymm3, ymm4, ymm6
    vmovaps [rsp+2112], ymm2
    vpermps ymm1, ymm5, ymm13
    vorps ymm4, ymm3, ymm15
    vpermps ymm5, ymm0, ymm12
    vpermps ymm3, ymm0, ymm11
    vmulps ymm0, ymm1, ymm5
    vfmsub213ps ymm4, ymm3, ymm15
    vandps ymm1, ymm14, [rsp+608]
    vmovaps ymm5, ymm8
    vfmadd231ps ymm5, ymm7, ymm4
    vfmadd213ps ymm5, ymm4, ymm9
    vfmadd213ps ymm5, ymm4, ymm10
    vmulps ymm3, ymm0, ymm4
    vfmadd231ps ymm0, ymm3, ymm5
    vmovups ymm4, [rsp+2176]
    vorps ymm3, ymm0, ymm1
    vmovaps [rsp+2144], ymm3
    vpsrld ymm5, ymm4, 20
    vpsrld ymm0, ymm4, 23
    vandps ymm1, ymm4, ymm6
    vpermps ymm4, ymm0, ymm13
    vorps ymm0, ymm1, ymm15
    vpermps ymm1, ymm5, ymm12
    vpermps ymm5, ymm5, ymm11
    vmulps ymm4, ymm4, ymm1
    vfmsub213ps ymm0, ymm5, ymm15
    vmovaps ymm1, ymm8
    vfmadd231ps ymm1, ymm7, ymm0
    vpmaxud ymm5, ymm2, ymm3
    vfmadd213ps ymm1, ymm0, ymm9
    vfmadd213ps ymm1, ymm0, ymm10
    vmulps ymm2, ymm4, ymm0
    vfmadd231ps ymm4, ymm2, ymm1
    vandps ymm3, ymm14, [rsp+640]
    vmovups ymm0, [rsp+2208]
    vorps ymm2, ymm4, ymm3
    vmovaps [rsp+2176], ymm2
    vpmaxud ymm1, ymm5, ymm2
    jmp .j3712
    ALIGN 64
.j3712:
    vpminsd ymm4, ymm1, [c_zero]
    vmovaps [rsp+3264], ymm4
    vpsrld ymm3, ymm0, 20
    vpsrld ymm5, ymm0, 23
    vandps ymm2, ymm0, ymm6
    vpermps ymm1, ymm5, ymm13
    vpermps ymm4, ymm3, ymm12
    vorps ymm0, ymm2, ymm15
    vpermps ymm5, ymm3, ymm11
    vmulps ymm2, ymm1, ymm4
    vandps ymm3, ymm14, [rsp+672]
    vfmsub213ps ymm0, ymm5, ymm15
    vmovups ymm1, [rsp+2240]
    vmovaps ymm4, ymm8
    vfmadd231ps ymm4, ymm7, ymm0
    vfmadd213ps ymm4, ymm0, ymm9
    vfmadd213ps ymm4, ymm0, ymm10
    vmulps ymm5, ymm2, ymm0
    vfmadd231ps ymm2, ymm5, ymm4
    vpsrld ymm0, ymm1, 20
    vorps ymm5, ymm2, ymm3
    vpsrld ymm4, ymm1, 23
    vandps ymm2, ymm1, ymm6
    vmovaps [rsp+2208], ymm5
    vpermps ymm3, ymm4, ymm13
    vorps ymm1, ymm2, ymm15
    vpermps ymm4, ymm0, ymm12
    vpermps ymm2, ymm0, ymm11
    vmulps ymm0, ymm3, ymm4
    vfmsub213ps ymm1, ymm2, ymm15
    vandps ymm3, ymm14, [rsp+704]
    vmovaps ymm4, ymm8
    vfmadd231ps ymm4, ymm7, ymm1
    vfmadd213ps ymm4, ymm1, ymm9
    vfmadd213ps ymm4, ymm1, ymm10
    vmulps ymm2, ymm0, ymm1
    vfmadd231ps ymm0, ymm2, ymm4
    vmovups ymm1, [rsp+2272]
    vorps ymm2, ymm0, ymm3
    vmovaps [rsp+2240], ymm2
    vpsrld ymm4, ymm1, 20
    vpsrld ymm0, ymm1, 23
    vandps ymm3, ymm1, ymm6
    vpermps ymm1, ymm0, ymm13
    vorps ymm0, ymm3, ymm15
    vpermps ymm3, ymm4, ymm12
    vpermps ymm4, ymm4, ymm11
    vmulps ymm1, ymm1, ymm3
    vfmsub213ps ymm0, ymm4, ymm15
    vmovaps ymm3, ymm8
    vfmadd231ps ymm3, ymm7, ymm0
    vpmaxud ymm4, ymm5, ymm2
    vfmadd213ps ymm3, ymm0, ymm9
    vfmadd213ps ymm3, ymm0, ymm10
    vmulps ymm5, ymm1, ymm0
    vfmadd231ps ymm1, ymm5, ymm3
    vandps ymm2, ymm14, [rsp+736]
    vmovups ymm0, [rsp+2496]
    vorps ymm5, ymm1, ymm2
    vmovaps [rsp+2272], ymm5
    vpmaxud ymm3, ymm4, ymm5
    vpminsd ymm1, ymm3, [c_zero]
    vmovaps [rsp+3296], ymm1
    vpsrld ymm2, ymm0, 20
    jmp .j3776
    ALIGN 64
.j3776:
    vpsrld ymm4, ymm0, 23
    vandps ymm5, ymm0, ymm6
    vpermps ymm3, ymm4, ymm13
    vpermps ymm1, ymm2, ymm12
    vorps ymm0, ymm5, ymm15
    vpermps ymm4, ymm2, ymm11
    vmulps ymm5, ymm3, ymm1
    vandps ymm2, ymm14, [rsp+960]
    vfmsub213ps ymm0, ymm4, ymm15
    vmovups ymm3, [rsp+2528]
    vmovaps ymm1, ymm8
    vfmadd231ps ymm1, ymm7, ymm0
    vfmadd213ps ymm1, ymm0, ymm9
    vfmadd213ps ymm1, ymm0, ymm10
    vmulps ymm4, ymm5, ymm0
    vfmadd231ps ymm5, ymm4, ymm1
    vpsrld ymm0, ymm3, 20
    vorps ymm4, ymm5, ymm2
    vpsrld ymm1, ymm3, 23
    vandps ymm5, ymm3, ymm6
    vmovaps [rsp+2496], ymm4
    vpermps ymm2, ymm1, ymm13
    vorps ymm3, ymm5, ymm15
    vpermps ymm1, ymm0, ymm12
    vpermps ymm5, ymm0, ymm11
    vmulps ymm0, ymm2, ymm1
    vfmsub213ps ymm3, ymm5, ymm15
    vandps ymm2, ymm14, [rsp+992]
    vmovaps ymm1, ymm8
    vfmadd231ps ymm1, ymm7, ymm3
    vfmadd213ps ymm1, ymm3, ymm9
    vfmadd213ps ymm1, ymm3, ymm10
    vmulps ymm5, ymm0, ymm3
    vfmadd231ps ymm0, ymm5, ymm1
    vmovups ymm3, [rsp+2560]
    vorps ymm5, ymm0, ymm2
    vmovaps [rsp+2528], ymm5
    vpsrld ymm1, ymm3, 20
    vpsrld ymm0, ymm3, 23
    vandps ymm2, ymm3, ymm6
    vpermps ymm3, ymm0, ymm13
    vorps ymm0, ymm2, ymm15
    vpermps ymm2, ymm1, ymm12
    vpermps ymm1, ymm1, ymm11
    vmulps ymm3, ymm3, ymm2
    vfmsub213ps ymm0, ymm1, ymm15
    vmovaps ymm2, ymm8
    vfmadd231ps ymm2, ymm7, ymm0
    vpmaxud ymm1, ymm4, ymm5
    vfmadd213ps ymm2, ymm0, ymm9
    vfmadd213ps ymm2, ymm0, ymm10
    vmulps ymm4, ymm3, ymm0
    vfmadd231ps ymm3, ymm4, ymm2
    vandps ymm5, ymm14, [rsp+1024]
    vmovups ymm0, [rsp+2592]
    vorps ymm4, ymm3, ymm5
    vmovaps [rsp+2560], ymm4
    vpmaxud ymm2, ymm1, ymm4
    vpminsd ymm3, ymm2, [c_zero]
    vmovaps [rsp+3392], ymm3
    vpsrld ymm5, ymm0, 20
    vpsrld ymm1, ymm0, 23
    vandps ymm4, ymm0, ymm6
    vpermps ymm2, ymm1, ymm13
    jmp .j3840
    ALIGN 64
.j3840:
    vpermps ymm3, ymm5, ymm12
    vorps ymm0, ymm4, ymm15
    vpermps ymm1, ymm5, ymm11
    vmulps ymm4, ymm2, ymm3
    vandps ymm5, ymm14, [rsp+1056]
    vfmsub213ps ymm0, ymm1, ymm15
    vmovups ymm2, [rsp+2624]
    vmovaps ymm3, ymm8
    vfmadd231ps ymm3, ymm7, ymm0
    vfmadd213ps ymm3, ymm0, ymm9
    vfmadd213ps ymm3, ymm0, ymm10
    vmulps ymm1, ymm4, ymm0
    vfmadd231ps ymm4, ymm1, ymm3
    vpsrld ymm0, ymm2, 20
    vorps ymm1, ymm4, ymm5
    vpsrld ymm3, ymm2, 23
    vandps ymm4, ymm2, ymm6
    vmovaps [rsp+2592], ymm1
    vpermps ymm5, ymm3, ymm13
    vorps ymm2, ymm4, ymm15
    vpermps ymm3, ymm0, ymm12
    vpermps ymm4, ymm0, ymm11
    vmulps ymm0, ymm5, ymm3
    vfmsub213ps ymm2, ymm4, ymm15
    vandps ymm5, ymm14, [rsp+1088]
    vmovaps ymm3, ymm8
    vfmadd231ps ymm3, ymm7, ymm2
    vfmadd213ps ymm3, ymm2, ymm9
    vfmadd213ps ymm3, ymm2, ymm10
    vmulps ymm4, ymm0, ymm2
    vfmadd231ps ymm0, ymm4, ymm3
    vmovups ymm2, [rsp+2656]
    vorps ymm4, ymm0, ymm5
    vmovaps [rsp+2624], ymm4
    vpsrld ymm3, ymm2, 20
    vpsrld ymm0, ymm2, 23
    vandps ymm5, ymm2, ymm6
    vpermps ymm2, ymm0, ymm13
    vorps ymm0, ymm5, ymm15
    vpermps ymm5, ymm3, ymm12
    vpermps ymm3, ymm3, ymm11
    vmulps ymm2, ymm2, ymm5
    vfmsub213ps ymm0, ymm3, ymm15
    vmovaps ymm5, ymm8
    vfmadd231ps ymm5, ymm7, ymm0
    vpmaxud ymm3, ymm1, ymm4
    vfmadd213ps ymm5, ymm0, ymm9
    vfmadd213ps ymm5, ymm0, ymm10
    vmulps ymm1, ymm2, ymm0
    vfmadd231ps ymm2, ymm1, ymm5
    vandps ymm4, ymm14, [rsp+1120]
    vmovups ymm0, [rsp+2880]
    vorps ymm1, ymm2, ymm4
    vmovaps [rsp+2656], ymm1
    vpmaxud ymm5, ymm3, ymm1
    vpminsd ymm2, ymm5, [c_zero]
    vmovaps [rsp+3424], ymm2
    vpsrld ymm4, ymm0, 20
    vpsrld ymm3, ymm0, 23
    vandps ymm1, ymm0, ymm6
    vpermps ymm5, ymm3, ymm13
    vpermps ymm2, ymm4, ymm12
    vorps ymm0, ymm1, ymm15
    vpermps ymm3, ymm4, ymm11
    jmp .j3904
    ALIGN 64
.j3904:
    vmulps ymm1, ymm5, ymm2
    vandps ymm4, ymm14, [rsp+1344]
    vfmsub213ps ymm0, ymm3, ymm15
    vmovups ymm5, [rsp+2912]
    vmovaps ymm2, ymm8
    vfmadd231ps ymm2, ymm7, ymm0
    vfmadd213ps ymm2, ymm0, ymm9
    vfmadd213ps ymm2, ymm0, ymm10
    vmulps ymm3, ymm1, ymm0
    vfmadd231ps ymm1, ymm3, ymm2
    vpsrld ymm0, ymm5, 20
    vorps ymm3, ymm1, ymm4
    vpsrld ymm2, ymm5, 23
    vandps ymm1, ymm5, ymm6
    vmovaps [rsp+2880], ymm3
    vpermps ymm4, ymm2, ymm13
    vorps ymm5, ymm1, ymm15
    vpermps ymm2, ymm0, ymm12
    vpermps ymm1, ymm0, ymm11
    vmulps ymm0, ymm4, ymm2
    vfmsub213ps ymm5, ymm1, ymm15
    vandps ymm4, ymm14, [rsp+1376]
    vmovaps ymm2, ymm8
    vfmadd231ps ymm2, ymm7, ymm5
    vfmadd213ps ymm2, ymm5, ymm9
    vfmadd213ps ymm2, ymm5, ymm10
    vmulps ymm1, ymm0, ymm5
    vfmadd231ps ymm0, ymm1, ymm2
    vmovups ymm5, [rsp+2944]
    vorps ymm1, ymm0, ymm4
    vmovaps [rsp+2912], ymm1
    vpsrld ymm2, ymm5, 20
    vpsrld ymm0, ymm5, 23
    vandps ymm4, ymm5, ymm6
    vpermps ymm5, ymm0, ymm13
    vorps ymm0, ymm4, ymm15
    vpermps ymm4, ymm2, ymm12
    vpermps ymm2, ymm2, ymm11
    vmulps ymm5, ymm5, ymm4
    vfmsub213ps ymm0, ymm2, ymm15
    vmovaps ymm4, ymm8
    vfmadd231ps ymm4, ymm7, ymm0
    vpmaxud ymm2, ymm3, ymm1
    vfmadd213ps ymm4, ymm0, ymm9
    vfmadd213ps ymm4, ymm0, ymm10
    vmulps ymm3, ymm5, ymm0
    vfmadd231ps ymm5, ymm3, ymm4
    vandps ymm1, ymm14, [rsp+1408]
    vmovups ymm0, [rsp+2976]
    vorps ymm3, ymm5, ymm1
    vmovaps [rsp+2944], ymm3
    vpmaxud ymm4, ymm2, ymm3
    vpminsd ymm5, ymm4, [c_zero]
    vmovaps [rsp+3520], ymm5
    vpsrld ymm1, ymm0, 20
    vpsrld ymm2, ymm0, 23
    vandps ymm3, ymm0, ymm6
    vpermps ymm4, ymm2, ymm13
    vpermps ymm5, ymm1, ymm12
    vorps ymm0, ymm3, ymm15
    vpermps ymm2, ymm1, ymm11
    vmulps ymm3, ymm4, ymm5
    vandps ymm1, ymm14, [rsp+1440]
    vfmsub213ps ymm0, ymm2, ymm15
    jmp .j3968
    ALIGN 64
.j3968:
    vmovups ymm4, [rsp+3008]
    vmovaps ymm5, ymm8
    vfmadd231ps ymm5, ymm7, ymm0
    vfmadd213ps ymm5, ymm0, ymm9
    vfmadd213ps ymm5, ymm0, ymm10
    vmulps ymm2, ymm3, ymm0
    vfmadd231ps ymm3, ymm2, ymm5
    vpsrld ymm0, ymm4, 20
    vorps ymm2, ymm3, ymm1
    vpsrld ymm5, ymm4, 23
    vandps ymm3, ymm4, ymm6
    vmovaps [rsp+2976], ymm2
    vpermps ymm1, ymm5, ymm13
    vorps ymm4, ymm3, ymm15
    vpermps ymm5, ymm0, ymm12
    vpermps ymm3, ymm0, ymm11
    vmulps ymm0, ymm1, ymm5
    vfmsub213ps ymm4, ymm3, ymm15
    vandps ymm1, ymm14, [rsp+1472]
    vmovaps ymm5, ymm8
    vfmadd231ps ymm5, ymm7, ymm4
    vfmadd213ps ymm5, ymm4, ymm9
    vfmadd213ps ymm5, ymm4, ymm10
    vmulps ymm3, ymm0, ymm4
    vfmadd231ps ymm0, ymm3, ymm5
    vmovups ymm4, [rsp+3040]
    vorps ymm3, ymm0, ymm1
    vmovaps [rsp+3008], ymm3
    vpsrld ymm5, ymm4, 20
    vandps ymm0, ymm4, ymm6
    vpsrld ymm1, ymm4, 23
    vpermps ymm6, ymm5, ymm12
    vorps ymm4, ymm0, ymm15
    vpermps ymm12, ymm5, ymm11
    vpermps ymm0, ymm1, ymm13
    vandps ymm5, ymm14, [rsp+1504]
    vfmsub231ps ymm15, ymm4, ymm12
    vmulps ymm11, ymm0, ymm6
    vpmaxud ymm1, ymm2, ymm3
    vfmadd231ps ymm8, ymm7, ymm15
    vmulps ymm13, ymm11, ymm15
    vfmadd231ps ymm9, ymm8, ymm15
    vfmadd231ps ymm10, ymm9, ymm15
    vfmadd231ps ymm11, ymm13, ymm10
    vorps ymm14, ymm11, ymm5
    vmovaps [rsp+3040], ymm14
    vpmaxud ymm4, ymm1, ymm14
    vpminsd ymm12, ymm4, [c_zero]
    vmovaps [rsp+3552], ymm12
.g_b2:
    vmovups ymm15, [c_hq]
    vmovups ymm14, [c_mag]
    vmovups ymm13, [c_rkq]
    vmovups ymm12, [c_rpq]
    vmovups ymm0, [rsp+4256]
    vmovups ymm1, [c_p24]
    vmovups ymm2, [rsp+4064]
    vmovups ymm3, [c_p24]
    vmovups ymm4, [rsp+4160]
    vmovups ymm5, [c_p24]
    vmovaps ymm6, ymm14
    vfmadd231ps ymm6, ymm0, ymm15
    vmovaps ymm7, ymm14
    vfmadd231ps ymm7, ymm2, ymm15
    vmovaps ymm8, ymm14
    jmp .j4032
    ALIGN 64
.j4032:
    vfmadd231ps ymm8, ymm4, ymm15
    vpermps ymm9, ymm6, ymm13
    vpermps ymm10, ymm6, ymm12
    vpermps ymm11, ymm6, [c_t2q]
    vfmsub231ps ymm10, ymm0, ymm9
    vpermps ymm6, ymm7, ymm13
    vpermps ymm0, ymm7, ymm12
    vpermps ymm9, ymm7, [c_t2q]
    vfmadd231ps ymm1, ymm10, [c_p25]
    vfmsub231ps ymm0, ymm2, ymm6
    vpermps ymm7, ymm8, ymm13
    vmovups ymm2, [rsp+4832]
    vfmadd213ps ymm1, ymm10, [c_p23]
    vfmadd231ps ymm3, ymm0, [c_p25]
    vfmadd213ps ymm1, ymm10, [c_p22]
    vfmadd213ps ymm3, ymm0, [c_p23]
    vfmadd213ps ymm1, ymm10, [c_p21]
    vfmadd213ps ymm3, ymm0, [c_p22]
    vfmadd213ps ymm1, ymm10, [c_p20]
    vmulps ymm6, ymm11, ymm10
    vfmadd213ps ymm3, ymm0, [c_p21]
    vfmadd231ps ymm11, ymm6, ymm1
    vmulps ymm10, ymm9, ymm0
    vpermps ymm6, ymm8, ymm12
    vfmadd213ps ymm3, ymm0, [c_p20]
    vpermps ymm1, ymm8, [c_t2q]
    vmovups ymm0, [c_p24]
    vmovaps [rsp+4256], ymm11
    vfmsub231ps ymm6, ymm4, ymm7
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm2, ymm15
    vmovups ymm11, [rsp+4640]
    vmovups ymm4, [c_p24]
    vfmadd231ps ymm9, ymm10, ymm3
    vfmadd231ps ymm5, ymm6, [c_p25]
    vmulps ymm7, ymm1, ymm6
    vpermps ymm10, ymm8, ymm13
    vmovaps [rsp+4064], ymm9
    vpermps ymm3, ymm8, ymm12
    vpermps ymm9, ymm8, [c_t2q]
    vfmadd213ps ymm5, ymm6, [c_p23]
    vfmsub231ps ymm3, ymm2, ymm10
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm11, ymm15
    vmovups ymm2, [rsp+4736]
    vfmadd213ps ymm5, ymm6, [c_p22]
    vfmadd231ps ymm0, ymm3, [c_p25]
    vfmadd213ps ymm5, ymm6, [c_p21]
    vfmadd213ps ymm0, ymm3, [c_p23]
    vfmadd213ps ymm5, ymm6, [c_p20]
    vmulps ymm10, ymm9, ymm3
    vfmadd213ps ymm0, ymm3, [c_p22]
    vfmadd231ps ymm1, ymm7, ymm5
    vpermps ymm6, ymm8, ymm13
    vpermps ymm7, ymm8, ymm12
    vfmadd213ps ymm0, ymm3, [c_p21]
    vpermps ymm5, ymm8, [c_t2q]
    vmovaps [rsp+4160], ymm1
    vfmsub231ps ymm7, ymm11, ymm6
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm2, ymm15
    vmovups ymm1, [c_p24]
    vmovups ymm11, [rsp+4544]
    vfmadd213ps ymm0, ymm3, [c_p20]
    jmp .j4096
    ALIGN 64
.j4096:
    vmovups ymm6, [c_p24]
    vfmadd231ps ymm4, ymm7, [c_p25]
    vfmadd231ps ymm9, ymm10, ymm0
    vmulps ymm3, ymm5, ymm7
    vpermps ymm10, ymm8, ymm13
    vfmadd213ps ymm4, ymm7, [c_p23]
    vmovaps [rsp+4832], ymm9
    vpermps ymm0, ymm8, ymm12
    vpermps ymm9, ymm8, [c_t2q]
    vfmadd213ps ymm4, ymm7, [c_p22]
    vfmsub231ps ymm0, ymm2, ymm10
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm11, ymm15
    vmovups ymm2, [rsp+4352]
    vfmadd213ps ymm4, ymm7, [c_p21]
    vfmadd231ps ymm1, ymm0, [c_p25]
    vfmadd213ps ymm4, ymm7, [c_p20]
    vmulps ymm10, ymm9, ymm0
    vfmadd213ps ymm1, ymm0, [c_p23]
    vfmadd231ps ymm5, ymm3, ymm4
    vpermps ymm7, ymm8, ymm13
    vpermps ymm3, ymm8, ymm12
    vfmadd213ps ymm1, ymm0, [c_p22]
    vpermps ymm4, ymm8, [c_t2q]
    vmovaps [rsp+4640], ymm5
    vfmsub231ps ymm3, ymm11, ymm7
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm2, ymm15
    vmovups ymm5, [c_p24]
    vmovups ymm11, [rsp+4448]
    vfmadd213ps ymm1, ymm0, [c_p21]
    vfmadd231ps ymm6, ymm3, [c_p25]
    vfmadd213ps ymm1, ymm0, [c_p20]
    vmulps ymm7, ymm4, ymm3
    vfmadd213ps ymm6, ymm3, [c_p23]
    vfmadd231ps ymm9, ymm10, ymm1
    vpermps ymm0, ymm8, ymm13
    vpermps ymm10, ymm8, ymm12
    vpermps ymm1, ymm8, [c_t2q]
    vfmadd213ps ymm6, ymm3, [c_p22]
    vmovaps [rsp+4736], ymm9
    vfmsub231ps ymm10, ymm2, ymm0
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm11, ymm15
    vmovups ymm9, [c_p24]
    vmovups ymm2, [rsp+5120]
    vfmadd213ps ymm6, ymm3, [c_p21]
    vfmadd231ps ymm5, ymm10, [c_p25]
    vfmadd213ps ymm6, ymm3, [c_p20]
    vmulps ymm0, ymm1, ymm10
    vfmadd213ps ymm5, ymm10, [c_p23]
    vfmadd231ps ymm4, ymm7, ymm6
    vpermps ymm3, ymm8, ymm13
    vpermps ymm7, ymm8, ymm12
    vfmadd213ps ymm5, ymm10, [c_p22]
    vpermps ymm6, ymm8, [c_t2q]
    vmovaps [rsp+4544], ymm4
    vfmsub231ps ymm7, ymm11, ymm3
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm2, ymm15
    vmovups ymm4, [c_p24]
    vmovups ymm11, [rsp+4928]
    vfmadd213ps ymm5, ymm10, [c_p21]
    vfmadd231ps ymm9, ymm7, [c_p25]
    jmp .j4160
    ALIGN 64
.j4160:
    vfmadd213ps ymm5, ymm10, [c_p20]
    vmulps ymm3, ymm6, ymm7
    vfmadd213ps ymm9, ymm7, [c_p23]
    vfmadd231ps ymm1, ymm0, ymm5
    vpermps ymm10, ymm8, ymm13
    vpermps ymm0, ymm8, ymm12
    vpermps ymm5, ymm8, [c_t2q]
    vfmadd213ps ymm9, ymm7, [c_p22]
    vmovaps [rsp+4352], ymm1
    vfmsub231ps ymm0, ymm2, ymm10
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm11, ymm15
    vmovups ymm1, [c_p24]
    vmovups ymm2, [rsp+5024]
    vfmadd213ps ymm9, ymm7, [c_p21]
    vfmadd231ps ymm4, ymm0, [c_p25]
    vfmadd213ps ymm9, ymm7, [c_p20]
    vmulps ymm10, ymm5, ymm0
    vfmadd213ps ymm4, ymm0, [c_p23]
    vfmadd231ps ymm6, ymm3, ymm9
    vpermps ymm7, ymm8, ymm13
    vpermps ymm3, ymm8, ymm12
    vfmadd213ps ymm4, ymm0, [c_p22]
    vpermps ymm9, ymm8, [c_t2q]
    vmovaps [rsp+4448], ymm6
    vfmsub231ps ymm3, ymm11, ymm7
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm2, ymm15
    vmovups ymm6, [c_p24]
    vmovups ymm11, [rsp+5216]
    vfmadd213ps ymm4, ymm0, [c_p21]
    vfmadd231ps ymm1, ymm3, [c_p25]
    vfmadd213ps ymm4, ymm0, [c_p20]
    vmulps ymm7, ymm9, ymm3
    vfmadd213ps ymm1, ymm3, [c_p23]
    vfmadd231ps ymm5, ymm10, ymm4
    vpermps ymm0, ymm8, ymm13
    vpermps ymm10, ymm8, ymm12
    vpermps ymm4, ymm8, [c_t2q]
    vfmadd213ps ymm1, ymm3, [c_p22]
    vmovaps [rsp+5120], ymm5
    vfmsub231ps ymm10, ymm2, ymm0
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm11, ymm15
    vmovups ymm5, [c_p24]
    vmovups ymm2, [rsp+5312]
    vfmadd213ps ymm1, ymm3, [c_p21]
    vfmadd231ps ymm6, ymm10, [c_p25]
    vfmadd213ps ymm1, ymm3, [c_p20]
    vmulps ymm0, ymm4, ymm10
    vfmadd213ps ymm6, ymm10, [c_p23]
    vfmadd231ps ymm9, ymm7, ymm1
    vpermps ymm3, ymm8, ymm13
    vpermps ymm7, ymm8, ymm12
    vfmadd213ps ymm6, ymm10, [c_p22]
    vpermps ymm1, ymm8, [c_t2q]
    vmovaps [rsp+4928], ymm9
    vfmsub231ps ymm7, ymm11, ymm3
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm2, ymm15
    vmovups ymm9, [c_p24]
    vmovups ymm11, [rsp+5408]
    vfmadd213ps ymm6, ymm10, [c_p21]
    vfmadd231ps ymm5, ymm7, [c_p25]
    jmp .j4224
    ALIGN 64
.j4224:
    vfmadd213ps ymm6, ymm10, [c_p20]
    vmulps ymm3, ymm1, ymm7
    vfmadd231ps ymm14, ymm11, ymm15
    vmovups ymm10, [c_p24]
    vfmadd213ps ymm5, ymm7, [c_p23]
    vfmadd231ps ymm4, ymm0, ymm6
    vpermps ymm15, ymm8, ymm13
    vpermps ymm0, ymm8, ymm12
    vpermps ymm6, ymm8, [c_t2q]
    vpermps ymm8, ymm14, ymm13
    vpermps ymm13, ymm14, ymm12
    vfmadd213ps ymm5, ymm7, [c_p22]
    vpermps ymm12, ymm14, [c_t2q]
    vmovaps [rsp+5024], ymm4
    vfmsub231ps ymm0, ymm2, ymm15
    vfmsub231ps ymm13, ymm11, ymm8
    vfmadd213ps ymm5, ymm7, [c_p21]
    vfmadd231ps ymm9, ymm0, [c_p25]
    vmulps ymm14, ymm6, ymm0
    vfmadd231ps ymm10, ymm13, [c_p25]
    vmulps ymm4, ymm12, ymm13
    vfmadd213ps ymm5, ymm7, [c_p20]
    vfmadd213ps ymm9, ymm0, [c_p23]
    vfmadd213ps ymm10, ymm13, [c_p23]
    vfmadd231ps ymm1, ymm3, ymm5
    vfmadd213ps ymm9, ymm0, [c_p22]
    vfmadd213ps ymm10, ymm13, [c_p22]
    vmovaps [rsp+5216], ymm1
    vfmadd213ps ymm9, ymm0, [c_p21]
    vfmadd213ps ymm10, ymm13, [c_p21]
    vfmadd213ps ymm9, ymm0, [c_p20]
    vfmadd213ps ymm10, ymm13, [c_p20]
    vfmadd231ps ymm6, ymm14, ymm9
    vfmadd231ps ymm12, ymm4, ymm10
    vmovaps [rsp+5312], ymm6
    vmovaps [rsp+5408], ymm12
.g_c:
    vmovups ymm15, [c_h0625]
    vmovups ymm14, [c_h5625]
    vmovups ymm13, [c_i512]
    vpmovzxwd ymm0, [r0+r3*2+(16+CST*0+CRD*0)]
    vpmovzxwd ymm1, [r0+r3*2+(32+CST*0+CRD*0)]
    vmovups ymm2, [r8+(0+SPBC*0)]
    vpmovzxwd ymm3, [r0+r3*2+(16+CST*0+CRD*1)]
    vpmovzxwd ymm4, [r0+r3*2+(32+CST*0+CRD*1)]
    vmovups ymm5, [r8+(32+SPBC*0)]
    vpsubd ymm6, ymm0, ymm13
    vpsubd ymm7, ymm1, ymm13
    vcvtdq2ps ymm8, ymm6
    vcvtdq2ps ymm9, ymm7
    vpsubd ymm10, ymm3, ymm13
    vcvtdq2ps ymm11, ymm10
    vpsubd ymm12, ymm4, ymm13
    vpmovzxwd ymm0, [r0+r3*2+(16+CST*1+CRD*0)]
    vcvtdq2ps ymm1, ymm12
    vmovaps [r8+(128+0+SPBC*0)], ymm8
    vperm2f128 ymm6, ymm2, [r8+(-128+0+SPBC*0)], 3
    vperm2f128 ymm7, ymm2, ymm8, 33
    vmovaps [r8+(256+0+SPBC*0)], ymm9
    vperm2f128 ymm3, ymm8, ymm2, 3
    vperm2f128 ymm10, ymm8, ymm9, 33
    vmovaps [r8+(128+32+SPBC*0)], ymm11
    vperm2f128 ymm4, ymm5, [r8+(-128+32+SPBC*0)], 3
    vperm2f128 ymm12, ymm5, ymm11, 33
    vpsubd ymm9, ymm0, ymm13
    jmp .j4288
    ALIGN 64
.j4288:
    vpalignr ymm0, ymm2, ymm6, 12
    vmovaps [r8+(256+32+SPBC*0)], ymm1
    vperm2f128 ymm6, ymm11, ymm1, 33
    vcvtdq2ps ymm1, ymm9
    vpalignr ymm9, ymm7, ymm2, 4
    vpalignr ymm7, ymm7, ymm2, 8
    vpalignr ymm3, ymm8, ymm3, 12
    vpalignr ymm4, ymm5, ymm4, 12
    vaddps ymm9, ymm9, ymm2
    vaddps ymm2, ymm0, ymm7
    vpalignr ymm0, ymm10, ymm8, 4
    vmovaps [r8+(128+0+SPBC*1)], ymm1
    vpalignr ymm7, ymm10, ymm8, 8
    vmulps ymm10, ymm2, ymm15
    vaddps ymm2, ymm0, ymm8
    vpalignr ymm0, ymm12, ymm5, 4
    vpalignr ymm8, ymm12, ymm5, 8
    vaddps ymm12, ymm3, ymm7
    vperm2f128 ymm3, ymm11, ymm5, 3
    vaddps ymm7, ymm0, ymm5
    vaddps ymm0, ymm4, ymm8
    vpalignr ymm5, ymm6, ymm11, 4
    vmovups ymm4, [r8+(0+SPBC*1)]
    vfmsub231ps ymm10, ymm9, ymm14
    vmulps ymm8, ymm12, ymm15
    vpalignr ymm9, ymm6, ymm11, 8
    vmovups ymm12, [r8+(32+SPBC*1)]
    vmulps ymm6, ymm0, ymm15
    vpalignr ymm0, ymm11, ymm3, 12
    vaddps ymm3, ymm5, ymm11
    vpmovzxwd ymm5, [r0+r3*2+(32+CST*1+CRD*0)]
    vfmsub231ps ymm8, ymm2, ymm14
    vaddps ymm11, ymm0, ymm9
    vpmovzxwd ymm2, [r0+r3*2+(16+CST*1+CRD*1)]
    vpmovzxwd ymm0, [r0+r3*2+(32+CST*1+CRD*1)]
    vmovaps [r8+(64+0+SPBC*0)], ymm10
    vfmsub231ps ymm6, ymm7, ymm14
    vmulps ymm9, ymm11, ymm15
    vpsubd ymm10, ymm5, ymm13
    vcvtdq2ps ymm7, ymm10
    vperm2f128 ymm11, ymm4, [r8+(-128+0+SPBC*1)], 3
    vperm2f128 ymm5, ymm4, ymm1, 33
    vmovaps [r8+(192+0+SPBC*0)], ymm8
    vperm2f128 ymm10, ymm1, ymm4, 3
    vpsubd ymm8, ymm2, ymm13
    vpsubd ymm2, ymm0, ymm13
    vperm2f128 ymm0, ymm12, [r8+(-128+32+SPBC*1)], 3
    vmovaps [r8+(64+32+SPBC*0)], ymm6
    vfmsub231ps ymm9, ymm3, ymm14
    vcvtdq2ps ymm13, ymm8
    vcvtdq2ps ymm6, ymm2
    vmovaps [r8+(256+0+SPBC*1)], ymm7
    vpalignr ymm3, ymm4, ymm11, 12
    vpalignr ymm8, ymm5, ymm4, 4
    vpalignr ymm2, ymm5, ymm4, 8
    vpalignr ymm11, ymm1, ymm10, 12
    vaddps ymm5, ymm8, ymm4
    vperm2f128 ymm10, ymm1, ymm7, 33
    vmovaps [r8+(128+32+SPBC*1)], ymm13
    vpalignr ymm8, ymm12, ymm0, 12
    vmovaps [r8+(192+32+SPBC*0)], ymm9
    vaddps ymm4, ymm3, ymm2
    vperm2f128 ymm7, ymm12, ymm13, 33
    vperm2f128 ymm0, ymm13, ymm12, 3
    jmp .j4352
    ALIGN 64
.j4352:
    vmovaps [r8+(256+32+SPBC*1)], ymm6
    vperm2f128 ymm9, ymm13, ymm6, 33
    vmulps ymm3, ymm4, ymm15
    vpalignr ymm2, ymm10, ymm1, 4
    vpalignr ymm6, ymm10, ymm1, 8
    vpalignr ymm4, ymm7, ymm12, 4
    vpalignr ymm10, ymm7, ymm12, 8
    vaddps ymm7, ymm2, ymm1
    vaddps ymm2, ymm11, ymm6
    vpalignr ymm1, ymm13, ymm0, 12
    vfmsub231ps ymm3, ymm5, ymm14
    vaddps ymm11, ymm4, ymm12
    vaddps ymm6, ymm8, ymm10
    vpalignr ymm0, ymm9, ymm13, 4
    vmulps ymm5, ymm2, ymm15
    vpalignr ymm4, ymm9, ymm13, 8
    vmulps ymm12, ymm6, ymm15
    vaddps ymm8, ymm0, ymm13
    vaddps ymm10, ymm1, ymm4
    vmovaps [r8+(64+0+SPBC*1)], ymm3
    vfmsub231ps ymm5, ymm7, ymm14
    vfmsub231ps ymm12, ymm11, ymm14
    vmulps ymm2, ymm10, ymm15
    vmovaps [r8+(192+0+SPBC*1)], ymm5
    vfmsub231ps ymm2, ymm8, ymm14
    vmovaps [r8+(64+32+SPBC*1)], ymm12
    vmovaps [r8+(192+32+SPBC*1)], ymm2
    mov r2, [r13 + 640]
    test r2, r2
    jnz .hk
.hr:
.g_qs:
    vmovups ymm0, [rsp+1536]
    vmovups ymm1, [rsp+1568]
    vmovups ymm2, [rsp+1600]
    vmovups ymm3, [rsp+3072]
    vmovups ymm4, [rsp+1920]
    vmovups ymm5, [rsp+1952]
    vmovups ymm6, [rsp+1984]
    vmovups ymm7, [rsp+3200]
    vmovups ymm8, [rsp+2304]
    vmovups ymm9, [rsp+2336]
    vmovups ymm10, [rsp+2368]
    vmovups ymm11, [rsp+3328]
    vmovups ymm12, [rsp+2688]
    vmovups ymm13, [rsp+2720]
    vaddps ymm14, ymm0, [rsp+1632]
    vaddps ymm15, ymm1, [rsp+1664]
    vaddps ymm0, ymm2, [rsp+1696]
    vaddps ymm1, ymm3, [rsp+3104]
    vmovaps [rsp+5504], ymm14
    vaddps ymm2, ymm4, [rsp+2016]
    vaddps ymm3, ymm5, [rsp+2048]
    vmovaps [rsp+5536], ymm15
    vaddps ymm4, ymm6, [rsp+2080]
    vaddps ymm5, ymm7, [rsp+3232]
    vmovaps [rsp+5568], ymm0
    vaddps ymm6, ymm2, ymm14
    vaddps ymm7, ymm3, ymm15
    vmovups ymm14, [rsp+2752]
    vmovaps [rsp+5600], ymm1
    vaddps ymm15, ymm4, ymm0
    vaddps ymm0, ymm5, ymm1
    vmovaps [rsp+5632], ymm2
    vaddps ymm1, ymm8, [rsp+2400]
    vaddps ymm2, ymm9, [rsp+2432]
    vmovaps [rsp+5664], ymm3
    vaddps ymm8, ymm10, [rsp+2464]
    vaddps ymm9, ymm11, [rsp+3360]
    jmp .j4416
    ALIGN 64
.j4416:
    vmovaps [rsp+5696], ymm4
    vmovups ymm3, [rsp+3456]
    vaddps ymm10, ymm12, [rsp+2784]
    vmovaps [rsp+5728], ymm5
    vaddps ymm11, ymm13, [rsp+2816]
    vmovups ymm4, [rsp+1728]
    vmovaps [r13], ymm6
    vaddps ymm12, ymm10, ymm1
    vmovups ymm5, [rsp+1760]
    vmovups ymm13, [rsp+1792]
    vmovaps [r13+32], ymm7
    vaddps ymm6, ymm14, [rsp+2848]
    vaddps ymm7, ymm11, ymm2
    vmovaps [r13+64], ymm15
    vmovups ymm14, [rsp+3136]
    vmovaps [r13+96], ymm0
    vaddps ymm15, ymm6, ymm8
    vmovaps [rsp+5760], ymm1
    vmovups ymm0, [rsp+1824]
    vmovaps [rsp+5792], ymm2
    vaddps ymm1, ymm3, [rsp+3488]
    vmovups ymm2, [rsp+1856]
    vmovaps [rsp+5824], ymm8
    vmovups ymm3, [rsp+1888]
    vmovaps [rsp+5856], ymm9
    vaddps ymm8, ymm1, ymm9
    vmovaps [rsp+5888], ymm10
    vmovups ymm9, [rsp+3168]
    vmovaps [rsp+5920], ymm11
    vaddps ymm10, ymm4, [rsp+r3*8+(CRY+4*W+4*W*0+0)]
    vmovaps [rsp+5952], ymm6
    vaddps ymm11, ymm5, [rsp+r3*8+(CRY+4*W+4*W*0+32)]
    vmovaps [rsp+5984], ymm1
    vaddps ymm6, ymm4, ymm0
    vaddps ymm1, ymm13, [rsp+r3*8+(CRY+4*W+4*W*0+64)]
    vmovaps [r13+256], ymm12
    vaddps ymm4, ymm5, ymm2
    vaddps ymm12, ymm14, [rsp+r3*8+(CRY+4*W+4*W*0+96)]
    vmovaps [r13+288], ymm7
    vaddps ymm5, ymm13, ymm3
    vaddps ymm7, ymm10, [rsp+5504]
    vmovups ymm13, [rsp+2112]
    vmovaps [r13+320], ymm15
    vaddps ymm10, ymm11, [rsp+5536]
    vaddps ymm15, ymm1, [rsp+5568]
    vmovaps [r13+352], ymm8
    vaddps ymm11, ymm14, ymm9
    vaddps ymm1, ymm12, [rsp+5600]
    vmovups ymm8, [rsp+2144]
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+0)], ymm0
    vmovups ymm14, [rsp+2176]
    vmovups ymm12, [rsp+3264]
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+32)], ymm2
    vmovups ymm0, [rsp+2208]
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+64)], ymm3
    vmovups ymm2, [rsp+2240]
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*0+96)], ymm9
    vmovups ymm3, [rsp+2272]
    vmovaps [rsp+6016], ymm7
    vmovups ymm9, [rsp+3296]
    vmovaps [rsp+6048], ymm10
    vaddps ymm7, ymm13, [rsp+r3*8+(CRY+4*W+4*W*1+0)]
    vmovaps [rsp+6080], ymm15
    vaddps ymm10, ymm8, [rsp+r3*8+(CRY+4*W+4*W*1+32)]
    jmp .j4480
    ALIGN 64
.j4480:
    vmovaps [rsp+6112], ymm1
    vaddps ymm15, ymm14, [rsp+r3*8+(CRY+4*W+4*W*1+64)]
    vaddps ymm1, ymm7, [rsp+5632]
    vaddps ymm7, ymm13, ymm0
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+0)], ymm0
    vaddps ymm13, ymm10, [rsp+5664]
    vmovups ymm0, [rsp+2496]
    vaddps ymm10, ymm8, ymm2
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+32)], ymm2
    vaddps ymm8, ymm15, [rsp+5696]
    vmovups ymm2, [rsp+2528]
    vaddps ymm15, ymm14, ymm3
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+64)], ymm3
    vaddps ymm14, ymm7, ymm6
    vmovups ymm3, [rsp+2560]
    vmovups ymm7, [rsp+3392]
    vaddps ymm6, ymm12, ymm9
    vaddps ymm12, ymm12, [rsp+r3*8+(CRY+4*W+4*W*1+96)]
    vmovaps [rsp+6144], ymm1
    vmovaps [rsp+6176], ymm13
    vaddps ymm1, ymm10, ymm4
    vaddps ymm13, ymm15, ymm5
    vmovups ymm10, [rsp+2592]
    vmovups ymm4, [rsp+2624]
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*1+96)], ymm9
    vaddps ymm15, ymm12, [rsp+5728]
    vaddps ymm5, ymm6, ymm11
    vmovups ymm9, [rsp+2656]
    vmovaps [rsp+6208], ymm8
    vmovups ymm12, [rsp+3424]
    vmovups ymm6, [rsp+2880]
    vmovaps [rsp+6240], ymm15
    vaddps ymm11, ymm0, [rsp+r3*8+(CRY+4*W+4*W*2+0)]
    vmovups ymm8, [rsp+2912]
    vmovaps [r13+128], ymm14
    vaddps ymm15, ymm2, [rsp+r3*8+(CRY+4*W+4*W*2+32)]
    vmovaps [r13+160], ymm1
    vaddps ymm14, ymm3, [rsp+r3*8+(CRY+4*W+4*W*2+64)]
    vaddps ymm1, ymm11, [rsp+5760]
    vmovaps [r13+192], ymm13
    vaddps ymm11, ymm7, [rsp+r3*8+(CRY+4*W+4*W*2+96)]
    vaddps ymm13, ymm15, [rsp+5792]
    vmovaps [r13+224], ymm5
    vaddps ymm15, ymm0, ymm10
    vaddps ymm5, ymm2, ymm4
    vmovups ymm0, [rsp+2944]
    vaddps ymm2, ymm3, ymm9
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+0)], ymm10
    vaddps ymm3, ymm14, [rsp+5824]
    vmovups ymm10, [rsp+3520]
    vaddps ymm14, ymm7, ymm12
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+32)], ymm4
    vaddps ymm7, ymm11, [rsp+5856]
    vmovups ymm4, [rsp+2976]
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+64)], ymm9
    vmovups ymm11, [rsp+3008]
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*2+96)], ymm12
    vmovups ymm9, [rsp+3040]
    vmovaps [rsp+6272], ymm1
    vmovups ymm12, [rsp+3552]
    vmovaps [rsp+6304], ymm13
    vaddps ymm1, ymm6, [rsp+r3*8+(CRY+4*W+4*W*3+0)]
    vmovaps [rsp+6336], ymm3
    vaddps ymm13, ymm8, [rsp+r3*8+(CRY+4*W+4*W*3+32)]
    jmp .j4544
    ALIGN 64
.j4544:
    vmovaps [rsp+6368], ymm7
    vaddps ymm3, ymm0, [rsp+r3*8+(CRY+4*W+4*W*3+64)]
    vaddps ymm7, ymm1, [rsp+5888]
    vaddps ymm1, ymm6, ymm4
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+0)], ymm4
    vaddps ymm6, ymm13, [rsp+5920]
    vmovups ymm4, [rsp+6144]
    vaddps ymm13, ymm8, ymm11
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+32)], ymm11
    vaddps ymm8, ymm3, [rsp+5952]
    vmovups ymm11, [rsp+6016]
    vaddps ymm3, ymm0, ymm9
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+64)], ymm9
    vaddps ymm0, ymm1, ymm15
    vmovups ymm9, [rsp+6176]
    vmovups ymm1, [rsp+6048]
    vaddps ymm15, ymm10, ymm12
    vaddps ymm10, ymm10, [rsp+r3*8+(CRY+4*W+4*W*3+96)]
    vmovaps [r13+384], ymm0
    vaddps ymm0, ymm13, ymm5
    vaddps ymm13, ymm3, ymm2
    vmovups ymm5, [rsp+6208]
    vmovups ymm3, [rsp+6080]
    vmovaps [rsp+r3*8+(CRY+4*W+4*W*3+96)], ymm12
    vaddps ymm2, ymm10, [rsp+5984]
    vaddps ymm12, ymm15, ymm14
    vmovups ymm10, [rsp+6240]
    vmovaps [r13+416], ymm0
    vmovups ymm15, [rsp+6112]
    vmovups ymm14, [c_one]
    vmovaps [r13+448], ymm13
    vperm2f128 ymm0, ymm4, [rsp+6528], 3
    vmovaps [r13+480], ymm12
    vperm2f128 ymm13, ymm7, ymm4, 3
    vpalignr ymm12, ymm4, ymm0, 12
    vmovaps [rsp+6528], ymm7
    vperm2f128 ymm4, ymm9, [rsp+6560], 3
    vpalignr ymm0, ymm7, ymm13, 12
    vperm2f128 ymm7, ymm6, ymm9, 3
    vfmadd231ps ymm12, ymm11, [rsp+6656]
    vperm2f128 ymm13, ymm5, [rsp+6592], 3
    vaddps ymm11, ymm0, [rsp+6272]
    vpalignr ymm0, ymm9, ymm4, 12
    vmovaps [rsp+6560], ymm6
    vperm2f128 ymm9, ymm8, ymm5, 3
    vpalignr ymm4, ymm6, ymm7, 12
    vperm2f128 ymm6, ymm10, [rsp+6624], 3
    vfmadd231ps ymm0, ymm1, [rsp+6656]
    vpalignr ymm7, ymm5, ymm13, 12
    vmovaps [rsp+6592], ymm8
    vperm2f128 ymm1, ymm2, ymm10, 3
    vshufps ymm5, ymm12, ymm11, 136
    vshufps ymm13, ymm12, ymm11, 221
    vaddps ymm12, ymm4, [rsp+6304]
    vpalignr ymm11, ymm8, ymm9, 12
    vaddps ymm4, ymm5, ymm13
    vfmadd231ps ymm7, ymm3, [rsp+6656]
    vpalignr ymm8, ymm10, ymm6, 12
    vmovaps [rsp+6624], ymm2
    vaddps ymm9, ymm11, [rsp+6336]
    vpalignr ymm5, ymm2, ymm1, 12
    vmovaps [r13+512], ymm4
    vshufps ymm13, ymm0, ymm12, 136
    vshufps ymm3, ymm0, ymm12, 221
    jmp .j4608
    ALIGN 64
.j4608:
    vfmadd231ps ymm8, ymm15, [rsp+6656]
    vaddps ymm10, ymm13, ymm3
    vaddps ymm6, ymm5, [rsp+6368]
    vshufps ymm11, ymm7, ymm9, 136
    vshufps ymm2, ymm7, ymm9, 221
    vmovaps [r13+544], ymm10
    vaddps ymm1, ymm11, ymm2
    vshufps ymm4, ymm8, ymm6, 136
    vshufps ymm0, ymm8, ymm6, 221
    vmovaps [rsp+6656], ymm14
    vmovaps [r13+576], ymm1
    vaddps ymm12, ymm4, ymm0
    vmovaps [r13+608], ymm12
.g_b3:
    vmovups ymm15, [c_sign]
    vmovups ymm14, [c_zero]
    vmovups ymm13, [c_onl]
    vmovups ymm12, [c_oa]
    vmovups ymm11, [c_half]
    vmovups ymm10, [c_mtl0]
    vmovups ymm9, [c_mtl1]
    vmovups ymm8, [c_mtl2]
    vmovups ymm7, [c_sl]
    vmovups ymm0, [rsp+4288]
    vandps ymm1, ymm15, [r14+64]
    vmovups ymm2, [rsp+4096]
    vandps ymm3, ymm15, [r14]
    vmovups ymm4, [rsp+4192]
    vandps ymm5, ymm15, [r14+32]
    vcmpps ymm6, ymm0, ymm13, 21
    vorps ymm6, ymm6, [rsp+4256]
    vorps ymm1, ymm6, ymm1
    vfmadd132ps ymm6, ymm12, [rsp+4320]
    vblendvps ymm1, ymm1, ymm14, ymm0
    vcmpps ymm0, ymm2, ymm13, 21
    vmulps ymm1, ymm1, ymm8
    vorps ymm0, ymm0, [rsp+4064]
    vfmadd213ps ymm6, ymm8, ymm7
    vorps ymm3, ymm0, ymm3
    vfmadd132ps ymm0, ymm12, [rsp+4128]
    vblendvps ymm3, ymm3, ymm14, ymm2
    vcmpps ymm2, ymm4, ymm13, 21
    vfmadd231ps ymm1, ymm3, ymm10
    vorps ymm3, ymm2, [rsp+4160]
    vfmadd231ps ymm6, ymm0, ymm10
    vmovups ymm2, [rsp+4864]
    vorps ymm0, ymm3, ymm5
    vfmadd132ps ymm3, ymm12, [rsp+4224]
    vblendvps ymm5, ymm0, ymm14, ymm4
    vandps ymm0, ymm15, [r14+320]
    vfmadd231ps ymm1, ymm5, ymm9
    vmovups ymm4, [rsp+4672]
    vfmadd231ps ymm6, ymm3, ymm9
    vandps ymm5, ymm15, [r14+256]
    vroundps ymm3, ymm1, 8
    vsubps ymm3, ymm1, ymm3
    vcvtps2dq ymm1, ymm1
    vandnps ymm3, ymm15, ymm3
    vaddps ymm3, ymm3, ymm6
    vpaddd ymm6, ymm1, [c_i64]
    vcmpps ymm1, ymm3, ymm11, 21
    vmovmskps r2d, ymm1
    mov [r14+640], r2b
    vcmpps ymm3, ymm2, ymm13, 21
    vorps ymm1, ymm3, [rsp+4832]
    vorps ymm3, ymm1, ymm0
    jmp .j4672
    ALIGN 64
.j4672:
    vfmadd132ps ymm1, ymm12, [rsp+4896]
    vblendvps ymm0, ymm3, ymm14, ymm2
    vcmpps ymm3, ymm4, ymm13, 21
    vmulps ymm2, ymm0, ymm8
    vorps ymm0, ymm3, [rsp+4640]
    vorps ymm3, ymm0, ymm5
    vfmadd132ps ymm0, ymm12, [rsp+4704]
    vfmadd213ps ymm1, ymm8, ymm7
    vblendvps ymm5, ymm3, ymm14, ymm4
    vmovups ymm3, [rsp+4768]
    vfmadd231ps ymm2, ymm5, ymm10
    vandps ymm4, ymm15, [r14+288]
    vfmadd231ps ymm1, ymm0, ymm10
    vcmpps ymm5, ymm3, ymm13, 21
    vorps ymm0, ymm5, [rsp+4736]
    vorps ymm5, ymm0, ymm4
    vfmadd132ps ymm0, ymm12, [rsp+4800]
    vblendvps ymm4, ymm5, ymm14, ymm3
    vmovups ymm5, [rsp+4576]
    vfmadd231ps ymm2, ymm4, ymm9
    vandps ymm3, ymm15, [r14+192]
    vfmadd231ps ymm1, ymm0, ymm9
    vroundps ymm4, ymm2, 8
    vsubps ymm0, ymm2, ymm4
    vcvtps2dq ymm4, ymm2
    vandnps ymm2, ymm15, ymm0
    vaddps ymm0, ymm2, ymm1
    vpaddd ymm2, ymm4, [c_i64]
    vcmpps ymm1, ymm5, ymm13, 21
    vpackusdw ymm4, ymm6, ymm2
    vmovups ymm6, [rsp+4384]
    vcmpps ymm2, ymm0, ymm11, 21
    vorps ymm0, ymm1, [rsp+4544]
    vpminuw ymm1, ymm4, [c_w1023]
    vorps ymm4, ymm0, ymm3
    vfmadd132ps ymm0, ymm12, [rsp+4608]
    vmovmskps r2d, ymm2
    mov [r14+642], r2b
    vpermq ymm3, ymm1, 216
    vblendvps ymm2, ymm4, ymm14, ymm5
    vandps ymm1, ymm15, [r14+128]
    vmovups ymm4, [rsp+4480]
    vmulps ymm5, ymm2, ymm8
    vfmadd213ps ymm0, ymm8, ymm7
    vmovdqu [r11+(W*0)], ymm3
    vcmpps ymm2, ymm6, ymm13, 21
    vorps ymm3, ymm2, [rsp+4352]
    vorps ymm2, ymm3, ymm1
    vfmadd132ps ymm3, ymm12, [rsp+4416]
    vblendvps ymm1, ymm2, ymm14, ymm6
    vcmpps ymm2, ymm4, ymm13, 21
    vfmadd231ps ymm5, ymm1, ymm10
    vorps ymm6, ymm2, [rsp+4448]
    vandps ymm1, ymm15, [r14+160]
    vorps ymm2, ymm6, ymm1
    vfmadd132ps ymm6, ymm12, [rsp+4512]
    vfmadd231ps ymm0, ymm3, ymm10
    vmovups ymm1, [rsp+5152]
    vblendvps ymm3, ymm2, ymm14, ymm4
    vandps ymm2, ymm15, [r14+448]
    vfmadd231ps ymm5, ymm3, ymm9
    vmovups ymm4, [rsp+4960]
    vfmadd231ps ymm0, ymm6, ymm9
    vandps ymm3, ymm15, [r14+384]
    vroundps ymm6, ymm5, 8
    jmp .j4736
    ALIGN 64
.j4736:
    vsubps ymm6, ymm5, ymm6
    vcvtps2dq ymm5, ymm5
    vandnps ymm6, ymm15, ymm6
    vaddps ymm6, ymm6, ymm0
    vpaddd ymm0, ymm5, [c_i64]
    vcmpps ymm5, ymm6, ymm11, 21
    vmovmskps r2d, ymm5
    mov [r14+641], r2b
    vcmpps ymm6, ymm1, ymm13, 21
    vorps ymm5, ymm6, [rsp+5120]
    vorps ymm6, ymm5, ymm2
    vfmadd132ps ymm5, ymm12, [rsp+5184]
    vblendvps ymm2, ymm6, ymm14, ymm1
    vcmpps ymm6, ymm4, ymm13, 21
    vmulps ymm1, ymm2, ymm8
    vorps ymm2, ymm6, [rsp+4928]
    vorps ymm6, ymm2, ymm3
    vfmadd132ps ymm2, ymm12, [rsp+4992]
    vfmadd213ps ymm5, ymm8, ymm7
    vblendvps ymm3, ymm6, ymm14, ymm4
    vmovups ymm8, [rsp+5056]
    vandps ymm6, ymm15, [r14+416]
    vfmadd231ps ymm1, ymm3, ymm10
    vfmadd231ps ymm5, ymm2, ymm10
    vcmpps ymm4, ymm8, ymm13, 21
    vorps ymm3, ymm4, [rsp+5024]
    vorps ymm2, ymm3, ymm6
    vfmadd132ps ymm3, ymm12, [rsp+5088]
    vblendvps ymm10, ymm2, ymm14, ymm8
    vmovups ymm13, [rsp+5248]
    vfmadd231ps ymm1, ymm10, ymm9
    vandps ymm4, ymm15, [r14+512]
    vfmadd231ps ymm5, ymm3, ymm9
    vroundps ymm6, ymm1, 8
    vcvtps2dq ymm2, ymm1
    vmovups ymm8, [rsp+5344]
    vcmpps ymm10, ymm13, [c_onh], 21
    vsubps ymm3, ymm1, ymm6
    vpaddd ymm9, ymm2, [c_i64]
    vpackusdw ymm1, ymm0, ymm9
    vorps ymm6, ymm10, [rsp+5216]
    vandps ymm2, ymm15, [r14+544]
    vandnps ymm0, ymm15, ymm3
    vorps ymm9, ymm6, ymm4
    vfmadd132ps ymm6, ymm12, [rsp+5280]
    vmovups ymm10, [rsp+5440]
    vaddps ymm3, ymm0, ymm5
    vpminuw ymm4, ymm1, [c_w1023]
    vblendvps ymm0, ymm9, ymm14, ymm13
    vandps ymm5, ymm15, [r14+576]
    vpermq ymm1, ymm4, 216
    vmulps ymm9, ymm0, [c_mth1]
    vcmpps ymm13, ymm3, ymm11, 21
    vcmpps ymm4, ymm8, [c_onh], 21
    vmovmskps r2d, ymm13
    mov [r14+643], r2b
    vorps ymm3, ymm4, [rsp+5312]
    vmovdqu [r11+(W*1)], ymm1
    vorps ymm13, ymm3, ymm2
    vfmadd132ps ymm3, ymm12, [rsp+5376]
    vmovaps ymm4, ymm7
    vfmadd231ps ymm4, ymm6, [c_mth1]
    vblendvps ymm1, ymm13, ymm14, ymm8
    vcmpps ymm2, ymm10, [c_onh], 21
    vfmadd231ps ymm9, ymm1, [c_mth2]
    vorps ymm13, ymm2, [rsp+5408]
    jmp .j4800
    ALIGN 64
.j4800:
    vorps ymm8, ymm13, ymm5
    vfmadd231ps ymm12, ymm13, [rsp+5472]
    vfmadd231ps ymm4, ymm3, [c_mth2]
    vblendvps ymm2, ymm8, ymm14, ymm10
    vfmsub231ps ymm9, ymm2, [c_mth0]
    vmulps ymm5, ymm2, [c_mth5]
    vfmadd231ps ymm4, ymm12, [c_mth0]
    vfmadd231ps ymm7, ymm12, [c_mth5]
    vfmadd231ps ymm5, ymm1, [c_mth4]
    vroundps ymm13, ymm9, 8
    vcvtps2dq ymm8, ymm9
    vfmadd231ps ymm7, ymm3, [c_mth4]
    vfmsub231ps ymm5, ymm0, [c_mth3]
    vsubps ymm14, ymm9, ymm13
    vpaddd ymm10, ymm8, [c_i512]
    vmovups ymm2, [c_pd8]
    vandnps ymm12, ymm15, ymm14
    vfmadd231ps ymm7, ymm6, [c_mth3]
    vaddps ymm1, ymm12, ymm4
    vroundps ymm3, ymm5, 8
    vcvtps2dq ymm0, ymm5
    vcmpps ymm9, ymm1, ymm11, 21
    vsubps ymm13, ymm5, ymm3
    vpaddd ymm8, ymm0, [c_i512]
    vpackusdw ymm14, ymm10, ymm8
    vandnps ymm6, ymm15, ymm13
    vaddps ymm12, ymm6, ymm7
    vpminuw ymm4, ymm14, [c_w1023]
    vpermd ymm1, ymm2, ymm4
    vcmpps ymm5, ymm12, ymm11, 21
    vorps ymm3, ymm9, ymm5
    vmovmskps r2d, ymm3
    mov [r14+644], r2b
    vmovdqu [r6], xmm1
    vextracti128 [gs:r6], ymm1, 1
    lea r2d, [r12 + r3*4]
    and r2d, 32767
    prefetcht1 [r2 + .period]
    prefetcht0 [r1 + r3*4 + 8*W + 2*W*0]
    prefetcht0 [r1 + r3*4 + 8*W + 2*W*1]
    prefetcht0 [r1 + r3*4 + 8*W + 2*W*2]
    prefetcht0 [r1 + r3*4 + 8*W + 2*W*3]
    prefetcht0 [r0 + r3*2 + 2*CST + CST*0 + CRD*0]
    prefetcht0 [r0 + r3*2 + 2*CST + CST*0 + CRD*1]
    prefetcht0 [r0 + r3*2 + 2*CST + CST*1 + CRD*0]
    prefetcht0 [r0 + r3*2 + 2*CST + CST*1 + CRD*1]
    add r4, 256
    add r5, 256
    add r7, 256
    add r8, 256
    mov r14, r13
    xor r13, [rsp + 6776]
    mov r11, r9
    add r9, 32
    mov r6, r10
    add r10, 16
    add r3, 16
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
    vmovups ymm15, [c_sign]
    vmovups ymm14, [c_rgl]
    vmovups ymm13, [c_xll]
    vmovups ymm12, [c_nieq]
    vmovups ymm11, [c_eqp]
    vmovups ymm0, [c_anl]
    vmovups ymm1, [c_tbl]
    vmovups ymm2, [c_anl]
    vmovups ymm3, [c_tbl]
    vandnps ymm4, ymm15, [r14]
    vandnps ymm5, ymm15, [r14+32]
    vandnps ymm6, ymm15, [r14+64]
    vfnmadd231ps ymm1, ymm0, [r14+96]
    vfnmadd231ps ymm3, ymm2, [r14+224]
    vmovaps ymm7, ymm1
    vfnmsub231ps ymm7, ymm14, ymm4
    vmovaps ymm8, ymm1
    vfnmsub231ps ymm8, ymm14, ymm5
    vfnmsub231ps ymm1, ymm14, ymm6
    vaddps ymm9, ymm4, ymm7
    vsubps ymm10, ymm7, ymm4
    vaddps ymm0, ymm5, ymm8
    vcmpps ymm2, ymm9, ymm13, 30
    vdivps ymm7, ymm7, ymm9
    vblendvps ymm9, ymm10, ymm4, ymm2
    vcmpps ymm10, ymm0, ymm13, 30
    vdivps ymm4, ymm8, ymm0
    vmovaps [rsp+4096], ymm9
    vsubps ymm0, ymm8, ymm5
    vaddps ymm9, ymm6, ymm1
    jmp .j4864
.j4864:
    vblendvps ymm8, ymm0, ymm5, ymm10
    vcmpps ymm0, ymm9, ymm13, 30
    vdivps ymm5, ymm1, ymm9
    vmovaps [rsp+4192], ymm8
    vsubps ymm9, ymm1, ymm6
    vmovups ymm8, [c_anl]
    vblendvps ymm1, ymm9, ymm6, ymm0
    vmovups ymm9, [c_tbl]
    vmovaps [rsp+4288], ymm1
    vandnps ymm6, ymm15, [r14+128]
    vblendvps ymm1, ymm12, ymm7, ymm2
    vandnps ymm7, ymm15, [r14+160]
    vfnmadd213ps ymm1, ymm11, [c_oml0]
    vblendvps ymm2, ymm12, ymm4, ymm10
    vfnmadd213ps ymm2, ymm11, [c_oml1]
    vmovaps [rsp+4128], ymm1
    vblendvps ymm4, ymm12, ymm5, ymm0
    vfnmadd231ps ymm9, ymm8, [r14+352]
    vfnmadd213ps ymm4, ymm11, [c_oml2]
    vmovaps ymm10, ymm3
    vfnmsub231ps ymm10, ymm14, ymm6
    vandnps ymm1, ymm15, [r14+192]
    vmovaps [rsp+4224], ymm2
    vmovaps ymm5, ymm3
    vfnmsub231ps ymm5, ymm14, ymm7
    vfnmsub231ps ymm3, ymm14, ymm1
    vmovaps [rsp+4320], ymm4
    vaddps ymm0, ymm6, ymm10
    vsubps ymm8, ymm10, ymm6
    vaddps ymm2, ymm7, ymm5
    vcmpps ymm4, ymm0, ymm13, 30
    vdivps ymm10, ymm10, ymm0
    vblendvps ymm0, ymm8, ymm6, ymm4
    vcmpps ymm8, ymm2, ymm13, 30
    vdivps ymm6, ymm5, ymm2
    vmovaps [rsp+4384], ymm0
    vsubps ymm2, ymm5, ymm7
    vaddps ymm0, ymm1, ymm3
    vblendvps ymm5, ymm2, ymm7, ymm8
    vcmpps ymm2, ymm0, ymm13, 30
    vdivps ymm7, ymm3, ymm0
    vmovaps [rsp+4480], ymm5
    vsubps ymm0, ymm3, ymm1
    vmovups ymm5, [c_anl]
    vblendvps ymm3, ymm0, ymm1, ymm2
    vmovups ymm0, [c_tbl]
    vmovaps [rsp+4576], ymm3
    vandnps ymm1, ymm15, [r14+256]
    vblendvps ymm3, ymm12, ymm10, ymm4
    vandnps ymm10, ymm15, [r14+288]
    vfnmadd213ps ymm3, ymm11, [c_oml0]
    vblendvps ymm4, ymm12, ymm6, ymm8
    vfnmadd213ps ymm4, ymm11, [c_oml1]
    vmovaps [rsp+4416], ymm3
    vblendvps ymm6, ymm12, ymm7, ymm2
    vfnmadd231ps ymm0, ymm5, [r14+480]
    vfnmadd213ps ymm6, ymm11, [c_oml2]
    vmovaps ymm8, ymm9
    vfnmsub231ps ymm8, ymm14, ymm1
    vandnps ymm3, ymm15, [r14+320]
    vmovaps [rsp+4512], ymm4
    vmovaps ymm7, ymm9
    vfnmsub231ps ymm7, ymm14, ymm10
    vfnmsub231ps ymm9, ymm14, ymm3
    jmp .j4928
.j4928:
    vmovaps [rsp+4608], ymm6
    vaddps ymm2, ymm1, ymm8
    vsubps ymm5, ymm8, ymm1
    vaddps ymm4, ymm10, ymm7
    vcmpps ymm6, ymm2, ymm13, 30
    vdivps ymm8, ymm8, ymm2
    vblendvps ymm2, ymm5, ymm1, ymm6
    vcmpps ymm5, ymm4, ymm13, 30
    vdivps ymm1, ymm7, ymm4
    vmovaps [rsp+4672], ymm2
    vsubps ymm4, ymm7, ymm10
    vaddps ymm2, ymm3, ymm9
    vblendvps ymm7, ymm4, ymm10, ymm5
    vcmpps ymm4, ymm2, ymm13, 30
    vdivps ymm10, ymm9, ymm2
    vmovaps [rsp+4768], ymm7
    vsubps ymm2, ymm9, ymm3
    vmovups ymm7, [c_anh]
    vblendvps ymm9, ymm2, ymm3, ymm4
    vmovups ymm2, [c_tbh]
    vmovaps [rsp+4864], ymm9
    vandnps ymm3, ymm15, [r14+384]
    vblendvps ymm9, ymm12, ymm8, ymm6
    vandnps ymm8, ymm15, [r14+416]
    vfnmadd213ps ymm9, ymm11, [c_oml0]
    vblendvps ymm6, ymm12, ymm1, ymm5
    vfnmadd213ps ymm6, ymm11, [c_oml1]
    vmovaps [rsp+4704], ymm9
    vblendvps ymm1, ymm12, ymm10, ymm4
    vfnmadd231ps ymm2, ymm7, [r14+608]
    vfnmadd213ps ymm1, ymm11, [c_oml2]
    vmovaps ymm5, ymm0
    vfnmsub231ps ymm5, ymm14, ymm3
    vandnps ymm9, ymm15, [r14+448]
    vmovaps [rsp+4800], ymm6
    vmovaps ymm10, ymm0
    vfnmsub231ps ymm10, ymm14, ymm8
    vfnmsub231ps ymm0, ymm14, ymm9
    vmovaps [rsp+4896], ymm1
    vaddps ymm4, ymm3, ymm5
    vsubps ymm7, ymm5, ymm3
    vaddps ymm6, ymm8, ymm10
    vsubps ymm14, ymm10, ymm8
    vcmpps ymm1, ymm4, ymm13, 30
    vdivps ymm5, ymm5, ymm4
    vdivps ymm4, ymm10, ymm6
    vblendvps ymm10, ymm7, ymm3, ymm1
    vcmpps ymm7, ymm6, ymm13, 30
    vaddps ymm3, ymm9, ymm0
    vmovaps [rsp+4960], ymm10
    vsubps ymm6, ymm0, ymm9
    vblendvps ymm10, ymm14, ymm8, ymm7
    vcmpps ymm14, ymm3, ymm13, 30
    vdivps ymm8, ymm0, ymm3
    vandnps ymm13, ymm15, [r14+512]
    vmovaps [rsp+5056], ymm10
    vmovaps ymm0, ymm2
    vfnmsub231ps ymm0, ymm13, [c_rgh]
    vandnps ymm3, ymm15, [r14+544]
    vblendvps ymm10, ymm6, ymm9, ymm14
    vmovaps [rsp+5152], ymm10
    vmovaps ymm6, ymm2
    vfnmsub231ps ymm6, ymm3, [c_rgh]
    vaddps ymm9, ymm13, ymm0
    jmp .j4992
.j4992:
    vblendvps ymm10, ymm12, ymm5, ymm1
    vsubps ymm5, ymm0, ymm13
    vfnmadd213ps ymm10, ymm11, [c_oml0]
    vblendvps ymm1, ymm12, ymm4, ymm7
    vcmpps ymm4, ymm9, [c_xlh], 30
    vfnmadd213ps ymm1, ymm11, [c_oml1]
    vdivps ymm7, ymm0, ymm9
    vaddps ymm0, ymm3, ymm6
    vandnps ymm9, ymm15, [r14+576]
    vblendvps ymm15, ymm5, ymm13, ymm4
    vsubps ymm5, ymm6, ymm3
    vfnmsub231ps ymm2, ymm9, [c_rgh]
    vblendvps ymm13, ymm12, ymm8, ymm14
    vmovaps [rsp+5248], ymm15
    vcmpps ymm8, ymm0, [c_xlh], 30
    vdivps ymm14, ymm6, ymm0
    vmovaps [rsp+4992], ymm10
    vfnmadd213ps ymm13, ymm11, [c_oml2]
    vmovaps [rsp+5088], ymm1
    vblendvps ymm15, ymm5, ymm3, ymm8
    vmovaps [rsp+5344], ymm15
    vaddps ymm6, ymm9, ymm2
    vsubps ymm0, ymm2, ymm9
    vmovaps [rsp+5184], ymm13
    vcmpps ymm10, ymm6, [c_xlh], 30
    vdivps ymm1, ymm2, ymm6
    vblendvps ymm5, ymm0, ymm9, ymm10
    vblendvps ymm3, ymm12, ymm7, ymm4
    vmovaps [rsp+5440], ymm5
    vfnmadd213ps ymm3, ymm11, [c_omh0]
    vblendvps ymm15, ymm12, ymm14, ymm8
    vfnmadd213ps ymm15, ymm11, [c_omh1]
    vmovaps [rsp+5280], ymm3
    vmovaps [rsp+5376], ymm15
    vblendvps ymm13, ymm12, ymm1, ymm10
    vfnmadd213ps ymm11, ymm13, [c_omh2]
    vmovaps [rsp+5472], ymm11
.e_b1b:
    vmovups ymm15, [c_one]
    vmovups ymm14, [c_sign]
    vmovups ymm13, [c_xll]
    vmovups ymm12, [c_tll]
    vmovups ymm11, [c_thi]
    vmovups ymm10, [c_w1q]
    vmovups ymm0, [rsp+4096]
    vmovups ymm1, [c_q11]
    vandnps ymm2, ymm14, ymm0
    vpsrld ymm3, ymm0, 20
    vandps ymm4, ymm0, [c_mant]
    vpmaxsd ymm5, ymm2, ymm13
    vpermps ymm6, ymm3, ymm10
    vorps ymm7, ymm4, ymm15
    vpermps ymm8, ymm3, [c_r1q]
    vpsrld ymm9, ymm5, 23
    vpsrld ymm0, ymm5, 26
    vmovups ymm2, [c_s1q]
    vpermps ymm4, ymm9, ymm12
    vpermps ymm3, ymm0, ymm11
    vmovups ymm5, [rsp+4192]
    vfmsub213ps ymm7, ymm8, ymm15
    vmulps ymm9, ymm4, ymm3
    vfmadd231ps ymm1, ymm7, [c_q12]
    vmulps ymm0, ymm9, ymm6
    vandnps ymm8, ymm14, ymm5
    vpsrld ymm4, ymm5, 20
    jmp .j5056
.j5056:
    vpmaxsd ymm3, ymm8, ymm13
    vpermps ymm9, ymm4, ymm10
    vandps ymm6, ymm5, [c_mant]
    vpsrld ymm8, ymm3, 23
    vpsrld ymm5, ymm3, 26
    vorps ymm3, ymm6, ymm15
    vpermps ymm6, ymm4, [c_r1q]
    vfmadd213ps ymm1, ymm7, [c_q10]
    vmulps ymm4, ymm0, ymm7
    vpermps ymm7, ymm8, ymm12
    vpermps ymm8, ymm5, ymm11
    vfmsub213ps ymm3, ymm6, ymm15
    vmovups ymm5, [c_q11]
    vfmadd231ps ymm0, ymm4, ymm1
    vmovups ymm6, [c_s1q]
    vmulps ymm4, ymm7, ymm8
    vmovups ymm1, [rsp+4288]
    vsubps ymm7, ymm0, [c_s1q]
    vfnmsub231ps ymm2, ymm0, [c_c3]
    vmulps ymm8, ymm4, ymm9
    vfmadd231ps ymm5, ymm3, [c_q12]
    vmulps ymm0, ymm8, ymm3
    vdivps ymm4, ymm7, ymm2
    vandnps ymm9, ymm14, ymm1
    vpsrld ymm7, ymm1, 20
    vpmaxsd ymm2, ymm9, ymm13
    vandps ymm9, ymm1, [c_mant]
    vfmadd213ps ymm5, ymm3, [c_q10]
    vpsrld ymm1, ymm2, 23
    vpsrld ymm3, ymm2, 26
    vorps ymm2, ymm9, ymm15
    vpermps ymm9, ymm1, ymm12
    vpermps ymm1, ymm3, ymm11
    vfmadd231ps ymm8, ymm0, ymm5
    vpermps ymm3, ymm7, ymm10
    vpermps ymm0, ymm7, [c_r1q]
    vmovups ymm5, [c_q11]
    vmulps ymm7, ymm9, ymm1
    vmovups ymm9, [c_s1q]
    vmovaps [rsp+4064], ymm4
    vsubps ymm1, ymm8, [c_s1q]
    vfnmsub231ps ymm6, ymm8, [c_c3]
    vmulps ymm4, ymm7, ymm3
    vfmsub213ps ymm2, ymm0, ymm15
    vmovups ymm8, [rsp+4384]
    vdivps ymm7, ymm1, ymm6
    vfmadd231ps ymm5, ymm2, [c_q12]
    vmulps ymm3, ymm4, ymm2
    vandnps ymm0, ymm14, ymm8
    vpsrld ymm1, ymm8, 20
    vfmadd213ps ymm5, ymm2, [c_q10]
    vpmaxsd ymm6, ymm0, ymm13
    vpermps ymm2, ymm1, ymm10
    vandps ymm0, ymm8, [c_mant]
    vorps ymm8, ymm0, ymm15
    vpermps ymm0, ymm1, [c_r1q]
    vfmadd231ps ymm4, ymm3, ymm5
    vpsrld ymm1, ymm6, 23
    vpsrld ymm3, ymm6, 26
    vmovups ymm5, [c_q11]
    vmovaps [rsp+4160], ymm7
    vpermps ymm6, ymm1, ymm12
    vpermps ymm7, ymm3, ymm11
    vfmsub213ps ymm8, ymm0, ymm15
    jmp .j5120
.j5120:
    vmovups ymm1, [c_s1q]
    vmovups ymm3, [rsp+4480]
    vsubps ymm0, ymm4, [c_s1q]
    vfnmsub231ps ymm9, ymm4, [c_c3]
    vmulps ymm4, ymm6, ymm7
    vfmadd231ps ymm5, ymm8, [c_q12]
    vdivps ymm6, ymm0, ymm9
    vmulps ymm7, ymm4, ymm2
    vandnps ymm0, ymm14, ymm3
    vpsrld ymm9, ymm3, 20
    vpmaxsd ymm4, ymm0, ymm13
    vpermps ymm2, ymm9, ymm10
    vfmadd213ps ymm5, ymm8, [c_q10]
    vmulps ymm0, ymm7, ymm8
    vandps ymm8, ymm3, [c_mant]
    vorps ymm3, ymm8, ymm15
    vpermps ymm8, ymm9, [c_r1q]
    vfmadd231ps ymm7, ymm0, ymm5
    vpsrld ymm9, ymm4, 23
    vpsrld ymm0, ymm4, 26
    vmovups ymm5, [c_q11]
    vpermps ymm4, ymm9, ymm12
    vpermps ymm9, ymm0, ymm11
    vfmsub213ps ymm3, ymm8, ymm15
    vmovups ymm0, [c_s1q]
    vmovaps [rsp+4256], ymm6
    vmovups ymm8, [rsp+4576]
    vsubps ymm6, ymm7, [c_s1q]
    vfnmsub231ps ymm1, ymm7, [c_c3]
    vmulps ymm7, ymm4, ymm9
    vfmadd231ps ymm5, ymm3, [c_q12]
    vdivps ymm4, ymm6, ymm1
    vmulps ymm9, ymm7, ymm2
    vandnps ymm6, ymm14, ymm8
    vpsrld ymm1, ymm8, 20
    vfmadd213ps ymm5, ymm3, [c_q10]
    vmulps ymm7, ymm9, ymm3
    vpmaxsd ymm2, ymm6, ymm13
    vpermps ymm3, ymm1, ymm10
    vandps ymm6, ymm8, [c_mant]
    vpermps ymm8, ymm1, [c_r1q]
    vorps ymm1, ymm6, ymm15
    vfmadd231ps ymm9, ymm7, ymm5
    vpsrld ymm6, ymm2, 23
    vpsrld ymm7, ymm2, 26
    vmovups ymm5, [c_q11]
    vpermps ymm2, ymm6, ymm12
    vpermps ymm6, ymm7, ymm11
    vfmsub213ps ymm1, ymm8, ymm15
    vmovups ymm7, [c_s1q]
    vmovaps [rsp+4352], ymm4
    vmovups ymm8, [rsp+4672]
    vsubps ymm4, ymm9, [c_s1q]
    vfnmsub231ps ymm0, ymm9, [c_c3]
    vmulps ymm9, ymm2, ymm6
    vfmadd231ps ymm5, ymm1, [c_q12]
    vdivps ymm2, ymm4, ymm0
    vmulps ymm6, ymm9, ymm3
    vandnps ymm4, ymm14, ymm8
    vpsrld ymm0, ymm8, 20
    vfmadd213ps ymm5, ymm1, [c_q10]
    vmulps ymm9, ymm6, ymm1
    vpmaxsd ymm3, ymm4, ymm13
    vpermps ymm1, ymm0, ymm10
    jmp .j5184
.j5184:
    vandps ymm4, ymm8, [c_mant]
    vpermps ymm8, ymm0, [c_r1q]
    vorps ymm0, ymm4, ymm15
    vfmadd231ps ymm6, ymm9, ymm5
    vpsrld ymm4, ymm3, 23
    vpsrld ymm9, ymm3, 26
    vmovups ymm5, [c_q11]
    vpermps ymm3, ymm4, ymm12
    vpermps ymm4, ymm9, ymm11
    vfmsub213ps ymm0, ymm8, ymm15
    vmovups ymm9, [c_s1q]
    vmovaps [rsp+4448], ymm2
    vmovups ymm8, [rsp+4768]
    vsubps ymm2, ymm6, [c_s1q]
    vfnmsub231ps ymm7, ymm6, [c_c3]
    vmulps ymm6, ymm3, ymm4
    vfmadd231ps ymm5, ymm0, [c_q12]
    vdivps ymm3, ymm2, ymm7
    vmulps ymm4, ymm6, ymm1
    vandnps ymm2, ymm14, ymm8
    vpsrld ymm7, ymm8, 20
    vfmadd213ps ymm5, ymm0, [c_q10]
    vmulps ymm6, ymm4, ymm0
    vpmaxsd ymm1, ymm2, ymm13
    vpermps ymm0, ymm7, ymm10
    vandps ymm2, ymm8, [c_mant]
    vpermps ymm8, ymm7, [c_r1q]
    vorps ymm7, ymm2, ymm15
    vfmadd231ps ymm4, ymm6, ymm5
    vpsrld ymm2, ymm1, 23
    vpsrld ymm6, ymm1, 26
    vmovups ymm5, [c_q11]
    vpermps ymm1, ymm2, ymm12
    vpermps ymm2, ymm6, ymm11
    vfmsub213ps ymm7, ymm8, ymm15
    vmovups ymm6, [c_s1q]
    vmovaps [rsp+4544], ymm3
    vmovups ymm8, [rsp+4864]
    vsubps ymm3, ymm4, [c_s1q]
    vfnmsub231ps ymm9, ymm4, [c_c3]
    vmulps ymm4, ymm1, ymm2
    vfmadd231ps ymm5, ymm7, [c_q12]
    vdivps ymm1, ymm3, ymm9
    vmulps ymm2, ymm4, ymm0
    vandnps ymm3, ymm14, ymm8
    vpsrld ymm9, ymm8, 20
    vfmadd213ps ymm5, ymm7, [c_q10]
    vmulps ymm4, ymm2, ymm7
    vpmaxsd ymm0, ymm3, ymm13
    vpermps ymm7, ymm9, ymm10
    vandps ymm3, ymm8, [c_mant]
    vpermps ymm8, ymm9, [c_r1q]
    vorps ymm9, ymm3, ymm15
    vfmadd231ps ymm2, ymm4, ymm5
    vpsrld ymm3, ymm0, 23
    vpsrld ymm4, ymm0, 26
    vmovups ymm5, [c_q11]
    vpermps ymm0, ymm3, ymm12
    vpermps ymm3, ymm4, ymm11
    vfmsub213ps ymm9, ymm8, ymm15
    vmovups ymm4, [c_s1q]
    vmovaps [rsp+4640], ymm1
    vmovups ymm8, [rsp+4960]
    vsubps ymm1, ymm2, [c_s1q]
    jmp .j5248
.j5248:
    vfnmsub231ps ymm6, ymm2, [c_c3]
    vmulps ymm2, ymm0, ymm3
    vfmadd231ps ymm5, ymm9, [c_q12]
    vdivps ymm0, ymm1, ymm6
    vmulps ymm3, ymm2, ymm7
    vandnps ymm1, ymm14, ymm8
    vpsrld ymm6, ymm8, 20
    vfmadd213ps ymm5, ymm9, [c_q10]
    vmulps ymm2, ymm3, ymm9
    vpmaxsd ymm7, ymm1, ymm13
    vpermps ymm9, ymm6, ymm10
    vandps ymm1, ymm8, [c_mant]
    vpermps ymm8, ymm6, [c_r1q]
    vorps ymm6, ymm1, ymm15
    vfmadd231ps ymm3, ymm2, ymm5
    vpsrld ymm1, ymm7, 23
    vpsrld ymm2, ymm7, 26
    vmovups ymm5, [c_q11]
    vpermps ymm7, ymm1, ymm12
    vpermps ymm1, ymm2, ymm11
    vfmsub213ps ymm6, ymm8, ymm15
    vmovups ymm2, [c_s1q]
    vmovaps [rsp+4736], ymm0
    vmovups ymm8, [rsp+5056]
    vsubps ymm0, ymm3, [c_s1q]
    vfnmsub231ps ymm4, ymm3, [c_c3]
    vmulps ymm3, ymm7, ymm1
    vfmadd231ps ymm5, ymm6, [c_q12]
    vdivps ymm7, ymm0, ymm4
    vmulps ymm1, ymm3, ymm9
    vandnps ymm0, ymm14, ymm8
    vpsrld ymm4, ymm8, 20
    vfmadd213ps ymm5, ymm6, [c_q10]
    vmulps ymm3, ymm1, ymm6
    vpmaxsd ymm9, ymm0, ymm13
    vpermps ymm6, ymm4, ymm10
    vandps ymm0, ymm8, [c_mant]
    vpermps ymm8, ymm4, [c_r1q]
    vorps ymm4, ymm0, ymm15
    vfmadd231ps ymm1, ymm3, ymm5
    vpsrld ymm0, ymm9, 23
    vpsrld ymm3, ymm9, 26
    vmovups ymm5, [c_q11]
    vpermps ymm9, ymm0, ymm12
    vpermps ymm0, ymm3, ymm11
    vfmsub213ps ymm4, ymm8, ymm15
    vmovups ymm3, [c_s1q]
    vmovaps [rsp+4832], ymm7
    vmovups ymm8, [rsp+5152]
    vsubps ymm7, ymm1, [c_s1q]
    vfnmsub231ps ymm2, ymm1, [c_c3]
    vmulps ymm1, ymm9, ymm0
    vfmadd231ps ymm5, ymm4, [c_q12]
    vdivps ymm9, ymm7, ymm2
    vmulps ymm0, ymm1, ymm6
    vandnps ymm7, ymm14, ymm8
    vpsrld ymm2, ymm8, 20
    vfmadd213ps ymm5, ymm4, [c_q10]
    vmulps ymm1, ymm0, ymm4
    vpmaxsd ymm6, ymm7, ymm13
    vpermps ymm4, ymm2, ymm10
    vpsrld ymm7, ymm6, 23
    vpsrld ymm13, ymm6, 26
    vandps ymm6, ymm8, [c_mant]
    jmp .j5312
.j5312:
    vpermps ymm8, ymm2, [c_r1q]
    vpermps ymm2, ymm7, ymm12
    vpermps ymm7, ymm13, ymm11
    vorps ymm12, ymm6, ymm15
    vmovups ymm13, [c_q11]
    vfmadd231ps ymm0, ymm1, ymm5
    vmovups ymm6, [c_s1q]
    vfmsub213ps ymm12, ymm8, ymm15
    vmulps ymm1, ymm2, ymm7
    vmovups ymm5, [rsp+5248]
    vmovaps [rsp+4928], ymm9
    vsubps ymm8, ymm0, [c_s1q]
    vfnmsub231ps ymm3, ymm0, [c_c3]
    vmulps ymm2, ymm1, ymm4
    vfmadd231ps ymm13, ymm12, [c_q12]
    vdivps ymm7, ymm8, ymm3
    vmulps ymm9, ymm2, ymm12
    vfmadd213ps ymm13, ymm12, [c_q10]
    vandnps ymm0, ymm14, ymm5
    vpsrld ymm1, ymm5, 20
    vpmaxsd ymm4, ymm0, [c_xlh]
    vpermps ymm8, ymm1, ymm10
    vandps ymm3, ymm5, [c_mant]
    vpsrld ymm12, ymm4, 23
    vpsrld ymm0, ymm4, 26
    vorps ymm5, ymm3, ymm15
    vpermps ymm4, ymm1, [c_r1q]
    vmovups ymm3, [c_q11]
    vpermps ymm1, ymm12, [c_tlh]
    vpermps ymm12, ymm0, ymm11
    vfmadd231ps ymm2, ymm9, ymm13
    vmovups ymm0, [c_s1q]
    vfmsub213ps ymm5, ymm4, ymm15
    vmulps ymm9, ymm1, ymm12
    vmovups ymm13, [rsp+5344]
    vsubps ymm4, ymm2, [c_s1q]
    vfnmsub231ps ymm6, ymm2, [c_c3]
    vmovaps [rsp+5024], ymm7
    vmulps ymm1, ymm9, ymm8
    vfmadd231ps ymm3, ymm5, [c_q12]
    vdivps ymm12, ymm4, ymm6
    vmulps ymm2, ymm1, ymm5
    vfmadd213ps ymm3, ymm5, [c_q10]
    vandnps ymm7, ymm14, ymm13
    vpsrld ymm9, ymm13, 20
    vpmaxsd ymm8, ymm7, [c_xlh]
    vpermps ymm4, ymm9, ymm10
    vandps ymm6, ymm13, [c_mant]
    vpsrld ymm5, ymm8, 23
    vpsrld ymm7, ymm8, 26
    vorps ymm13, ymm6, ymm15
    vpermps ymm8, ymm9, [c_r1q]
    vmovups ymm6, [c_q11]
    vpermps ymm9, ymm5, [c_tlh]
    vpermps ymm5, ymm7, ymm11
    vfmadd231ps ymm1, ymm2, ymm3
    vmovups ymm7, [c_s1q]
    vfmsub213ps ymm13, ymm8, ymm15
    vmulps ymm2, ymm9, ymm5
    vmovups ymm3, [rsp+5440]
    vmovaps [rsp+5120], ymm12
    vsubps ymm8, ymm1, [c_s1q]
    vfnmsub231ps ymm0, ymm1, [c_c3]
    vmulps ymm9, ymm2, ymm4
    jmp .j5376
.j5376:
    vfmadd231ps ymm6, ymm13, [c_q12]
    vdivps ymm5, ymm8, ymm0
    vmulps ymm12, ymm9, ymm13
    vfmadd213ps ymm6, ymm13, [c_q10]
    vandnps ymm1, ymm14, ymm3
    vpsrld ymm2, ymm3, 20
    vpmaxsd ymm4, ymm1, [c_xlh]
    vpermps ymm8, ymm2, ymm10
    vandps ymm0, ymm3, [c_mant]
    vpsrld ymm13, ymm4, 23
    vpsrld ymm14, ymm4, 26
    vorps ymm1, ymm0, ymm15
    vpermps ymm10, ymm2, [c_r1q]
    vmovups ymm3, [c_q11]
    vpermps ymm4, ymm13, [c_tlh]
    vpermps ymm0, ymm14, ymm11
    vfmadd231ps ymm9, ymm12, ymm6
    vmovups ymm2, [c_s1q]
    vfmsub231ps ymm15, ymm1, ymm10
    vmulps ymm13, ymm4, ymm0
    vmovaps [rsp+5216], ymm5
    vsubps ymm14, ymm9, [c_s1q]
    vfnmsub231ps ymm7, ymm9, [c_c3]
    vmulps ymm11, ymm13, ymm8
    vfmadd231ps ymm3, ymm15, [c_q12]
    vdivps ymm12, ymm14, ymm7
    vmulps ymm6, ymm11, ymm15
    vfmadd213ps ymm3, ymm15, [c_q10]
    vfmadd231ps ymm11, ymm6, ymm3
    vmovaps [rsp+5312], ymm12
    vsubps ymm1, ymm11, [c_s1q]
    vfnmsub231ps ymm2, ymm11, [c_c3]
    vdivps ymm10, ymm1, ymm2
    vmovaps [rsp+5408], ymm10
.e_b2:
    vmovups ymm15, [c_hq]
    vmovups ymm14, [c_mag]
    vmovups ymm13, [c_rkq]
    vmovups ymm12, [c_rpq]
    vmovups ymm0, [rsp+4256]
    vmovups ymm1, [c_p24]
    vmovups ymm2, [rsp+4064]
    vmovups ymm3, [c_p24]
    vmovups ymm4, [rsp+4160]
    vmovups ymm5, [c_p24]
    vmovaps ymm6, ymm14
    vfmadd231ps ymm6, ymm0, ymm15
    vmovaps ymm7, ymm14
    vfmadd231ps ymm7, ymm2, ymm15
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm4, ymm15
    vpermps ymm9, ymm6, ymm13
    vpermps ymm10, ymm6, ymm12
    vpermps ymm11, ymm6, [c_t2q]
    vfmsub231ps ymm10, ymm0, ymm9
    vpermps ymm6, ymm7, ymm13
    vpermps ymm0, ymm7, ymm12
    vpermps ymm9, ymm7, [c_t2q]
    vfmadd231ps ymm1, ymm10, [c_p25]
    vfmsub231ps ymm0, ymm2, ymm6
    vpermps ymm7, ymm8, ymm13
    vmovups ymm2, [rsp+4832]
    vfmadd213ps ymm1, ymm10, [c_p23]
    vfmadd231ps ymm3, ymm0, [c_p25]
    vfmadd213ps ymm1, ymm10, [c_p22]
    jmp .j5440
.j5440:
    vfmadd213ps ymm3, ymm0, [c_p23]
    vfmadd213ps ymm1, ymm10, [c_p21]
    vfmadd213ps ymm3, ymm0, [c_p22]
    vfmadd213ps ymm1, ymm10, [c_p20]
    vmulps ymm6, ymm11, ymm10
    vfmadd213ps ymm3, ymm0, [c_p21]
    vfmadd231ps ymm11, ymm6, ymm1
    vmulps ymm10, ymm9, ymm0
    vpermps ymm6, ymm8, ymm12
    vfmadd213ps ymm3, ymm0, [c_p20]
    vpermps ymm1, ymm8, [c_t2q]
    vmovups ymm0, [c_p24]
    vmovaps [rsp+4256], ymm11
    vfmsub231ps ymm6, ymm4, ymm7
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm2, ymm15
    vmovups ymm11, [rsp+4640]
    vmovups ymm4, [c_p24]
    vfmadd231ps ymm9, ymm10, ymm3
    vfmadd231ps ymm5, ymm6, [c_p25]
    vmulps ymm7, ymm1, ymm6
    vpermps ymm10, ymm8, ymm13
    vmovaps [rsp+4064], ymm9
    vpermps ymm3, ymm8, ymm12
    vpermps ymm9, ymm8, [c_t2q]
    vfmadd213ps ymm5, ymm6, [c_p23]
    vfmsub231ps ymm3, ymm2, ymm10
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm11, ymm15
    vmovups ymm2, [rsp+4736]
    vfmadd213ps ymm5, ymm6, [c_p22]
    vfmadd231ps ymm0, ymm3, [c_p25]
    vfmadd213ps ymm5, ymm6, [c_p21]
    vfmadd213ps ymm0, ymm3, [c_p23]
    vfmadd213ps ymm5, ymm6, [c_p20]
    vmulps ymm10, ymm9, ymm3
    vfmadd213ps ymm0, ymm3, [c_p22]
    vfmadd231ps ymm1, ymm7, ymm5
    vpermps ymm6, ymm8, ymm13
    vpermps ymm7, ymm8, ymm12
    vfmadd213ps ymm0, ymm3, [c_p21]
    vpermps ymm5, ymm8, [c_t2q]
    vmovaps [rsp+4160], ymm1
    vfmsub231ps ymm7, ymm11, ymm6
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm2, ymm15
    vmovups ymm1, [c_p24]
    vmovups ymm11, [rsp+4544]
    vfmadd213ps ymm0, ymm3, [c_p20]
    vmovups ymm6, [c_p24]
    vfmadd231ps ymm4, ymm7, [c_p25]
    vfmadd231ps ymm9, ymm10, ymm0
    vmulps ymm3, ymm5, ymm7
    vpermps ymm10, ymm8, ymm13
    vfmadd213ps ymm4, ymm7, [c_p23]
    vmovaps [rsp+4832], ymm9
    vpermps ymm0, ymm8, ymm12
    vpermps ymm9, ymm8, [c_t2q]
    vfmadd213ps ymm4, ymm7, [c_p22]
    vfmsub231ps ymm0, ymm2, ymm10
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm11, ymm15
    vmovups ymm2, [rsp+4352]
    vfmadd213ps ymm4, ymm7, [c_p21]
    jmp .j5504
.j5504:
    vfmadd231ps ymm1, ymm0, [c_p25]
    vfmadd213ps ymm4, ymm7, [c_p20]
    vmulps ymm10, ymm9, ymm0
    vfmadd213ps ymm1, ymm0, [c_p23]
    vfmadd231ps ymm5, ymm3, ymm4
    vpermps ymm7, ymm8, ymm13
    vpermps ymm3, ymm8, ymm12
    vfmadd213ps ymm1, ymm0, [c_p22]
    vpermps ymm4, ymm8, [c_t2q]
    vmovaps [rsp+4640], ymm5
    vfmsub231ps ymm3, ymm11, ymm7
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm2, ymm15
    vmovups ymm5, [c_p24]
    vmovups ymm11, [rsp+4448]
    vfmadd213ps ymm1, ymm0, [c_p21]
    vfmadd231ps ymm6, ymm3, [c_p25]
    vfmadd213ps ymm1, ymm0, [c_p20]
    vmulps ymm7, ymm4, ymm3
    vfmadd213ps ymm6, ymm3, [c_p23]
    vfmadd231ps ymm9, ymm10, ymm1
    vpermps ymm0, ymm8, ymm13
    vpermps ymm10, ymm8, ymm12
    vpermps ymm1, ymm8, [c_t2q]
    vfmadd213ps ymm6, ymm3, [c_p22]
    vmovaps [rsp+4736], ymm9
    vfmsub231ps ymm10, ymm2, ymm0
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm11, ymm15
    vmovups ymm9, [c_p24]
    vmovups ymm2, [rsp+5120]
    vfmadd213ps ymm6, ymm3, [c_p21]
    vfmadd231ps ymm5, ymm10, [c_p25]
    vfmadd213ps ymm6, ymm3, [c_p20]
    vmulps ymm0, ymm1, ymm10
    vfmadd213ps ymm5, ymm10, [c_p23]
    vfmadd231ps ymm4, ymm7, ymm6
    vpermps ymm3, ymm8, ymm13
    vpermps ymm7, ymm8, ymm12
    vfmadd213ps ymm5, ymm10, [c_p22]
    vpermps ymm6, ymm8, [c_t2q]
    vmovaps [rsp+4544], ymm4
    vfmsub231ps ymm7, ymm11, ymm3
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm2, ymm15
    vmovups ymm4, [c_p24]
    vmovups ymm11, [rsp+4928]
    vfmadd213ps ymm5, ymm10, [c_p21]
    vfmadd231ps ymm9, ymm7, [c_p25]
    vfmadd213ps ymm5, ymm10, [c_p20]
    vmulps ymm3, ymm6, ymm7
    vfmadd213ps ymm9, ymm7, [c_p23]
    vfmadd231ps ymm1, ymm0, ymm5
    vpermps ymm10, ymm8, ymm13
    vpermps ymm0, ymm8, ymm12
    vpermps ymm5, ymm8, [c_t2q]
    vfmadd213ps ymm9, ymm7, [c_p22]
    vmovaps [rsp+4352], ymm1
    vfmsub231ps ymm0, ymm2, ymm10
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm11, ymm15
    vmovups ymm1, [c_p24]
    vmovups ymm2, [rsp+5024]
    vfmadd213ps ymm9, ymm7, [c_p21]
    jmp .j5568
.j5568:
    vfmadd231ps ymm4, ymm0, [c_p25]
    vfmadd213ps ymm9, ymm7, [c_p20]
    vmulps ymm10, ymm5, ymm0
    vfmadd213ps ymm4, ymm0, [c_p23]
    vfmadd231ps ymm6, ymm3, ymm9
    vpermps ymm7, ymm8, ymm13
    vpermps ymm3, ymm8, ymm12
    vfmadd213ps ymm4, ymm0, [c_p22]
    vpermps ymm9, ymm8, [c_t2q]
    vmovaps [rsp+4448], ymm6
    vfmsub231ps ymm3, ymm11, ymm7
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm2, ymm15
    vmovups ymm6, [c_p24]
    vmovups ymm11, [rsp+5216]
    vfmadd213ps ymm4, ymm0, [c_p21]
    vfmadd231ps ymm1, ymm3, [c_p25]
    vfmadd213ps ymm4, ymm0, [c_p20]
    vmulps ymm7, ymm9, ymm3
    vfmadd213ps ymm1, ymm3, [c_p23]
    vfmadd231ps ymm5, ymm10, ymm4
    vpermps ymm0, ymm8, ymm13
    vpermps ymm10, ymm8, ymm12
    vpermps ymm4, ymm8, [c_t2q]
    vfmadd213ps ymm1, ymm3, [c_p22]
    vmovaps [rsp+5120], ymm5
    vfmsub231ps ymm10, ymm2, ymm0
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm11, ymm15
    vmovups ymm5, [c_p24]
    vmovups ymm2, [rsp+5312]
    vfmadd213ps ymm1, ymm3, [c_p21]
    vfmadd231ps ymm6, ymm10, [c_p25]
    vfmadd213ps ymm1, ymm3, [c_p20]
    vmulps ymm0, ymm4, ymm10
    vfmadd213ps ymm6, ymm10, [c_p23]
    vfmadd231ps ymm9, ymm7, ymm1
    vpermps ymm3, ymm8, ymm13
    vpermps ymm7, ymm8, ymm12
    vfmadd213ps ymm6, ymm10, [c_p22]
    vpermps ymm1, ymm8, [c_t2q]
    vmovaps [rsp+4928], ymm9
    vfmsub231ps ymm7, ymm11, ymm3
    vmovaps ymm8, ymm14
    vfmadd231ps ymm8, ymm2, ymm15
    vmovups ymm9, [c_p24]
    vmovups ymm11, [rsp+5408]
    vfmadd213ps ymm6, ymm10, [c_p21]
    vfmadd231ps ymm5, ymm7, [c_p25]
    vfmadd213ps ymm6, ymm10, [c_p20]
    vmulps ymm3, ymm1, ymm7
    vfmadd231ps ymm14, ymm11, ymm15
    vmovups ymm10, [c_p24]
    vfmadd213ps ymm5, ymm7, [c_p23]
    vfmadd231ps ymm4, ymm0, ymm6
    vpermps ymm15, ymm8, ymm13
    vpermps ymm0, ymm8, ymm12
    vpermps ymm6, ymm8, [c_t2q]
    vpermps ymm8, ymm14, ymm13
    vpermps ymm13, ymm14, ymm12
    vfmadd213ps ymm5, ymm7, [c_p22]
    vpermps ymm12, ymm14, [c_t2q]
    vmovaps [rsp+5024], ymm4
    vfmsub231ps ymm0, ymm2, ymm15
    jmp .j5632
.j5632:
    vfmsub231ps ymm13, ymm11, ymm8
    vfmadd213ps ymm5, ymm7, [c_p21]
    vfmadd231ps ymm9, ymm0, [c_p25]
    vmulps ymm14, ymm6, ymm0
    vfmadd231ps ymm10, ymm13, [c_p25]
    vmulps ymm4, ymm12, ymm13
    vfmadd213ps ymm5, ymm7, [c_p20]
    vfmadd213ps ymm9, ymm0, [c_p23]
    vfmadd213ps ymm10, ymm13, [c_p23]
    vfmadd231ps ymm1, ymm3, ymm5
    vfmadd213ps ymm9, ymm0, [c_p22]
    vfmadd213ps ymm10, ymm13, [c_p22]
    vmovaps [rsp+5216], ymm1
    vfmadd213ps ymm9, ymm0, [c_p21]
    vfmadd213ps ymm10, ymm13, [c_p21]
    vfmadd213ps ymm9, ymm0, [c_p20]
    vfmadd213ps ymm10, ymm13, [c_p20]
    vfmadd231ps ymm6, ymm14, ymm9
    vfmadd231ps ymm12, ymm4, ymm10
    vmovaps [rsp+5312], ymm6
    vmovaps [rsp+5408], ymm12
.e_b3:
    vmovups ymm15, [c_sign]
    vmovups ymm14, [c_zero]
    vmovups ymm13, [c_onl]
    vmovups ymm12, [c_oa]
    vmovups ymm11, [c_half]
    vmovups ymm10, [c_mtl0]
    vmovups ymm9, [c_mtl1]
    vmovups ymm8, [c_mtl2]
    vmovups ymm7, [c_sl]
    vmovups ymm0, [rsp+4288]
    vandps ymm1, ymm15, [r14+64]
    vmovups ymm2, [rsp+4096]
    vandps ymm3, ymm15, [r14]
    vmovups ymm4, [rsp+4192]
    vandps ymm5, ymm15, [r14+32]
    vcmpps ymm6, ymm0, ymm13, 21
    vorps ymm6, ymm6, [rsp+4256]
    vorps ymm1, ymm6, ymm1
    vfmadd132ps ymm6, ymm12, [rsp+4320]
    vblendvps ymm1, ymm1, ymm14, ymm0
    vcmpps ymm0, ymm2, ymm13, 21
    vmulps ymm1, ymm1, ymm8
    vorps ymm0, ymm0, [rsp+4064]
    vfmadd213ps ymm6, ymm8, ymm7
    vorps ymm3, ymm0, ymm3
    vfmadd132ps ymm0, ymm12, [rsp+4128]
    vblendvps ymm3, ymm3, ymm14, ymm2
    vcmpps ymm2, ymm4, ymm13, 21
    vfmadd231ps ymm1, ymm3, ymm10
    vorps ymm3, ymm2, [rsp+4160]
    vfmadd231ps ymm6, ymm0, ymm10
    vmovups ymm2, [rsp+4864]
    vorps ymm0, ymm3, ymm5
    vfmadd132ps ymm3, ymm12, [rsp+4224]
    vblendvps ymm5, ymm0, ymm14, ymm4
    vandps ymm0, ymm15, [r14+320]
    vfmadd231ps ymm1, ymm5, ymm9
    vmovups ymm4, [rsp+4672]
    vfmadd231ps ymm6, ymm3, ymm9
    vandps ymm5, ymm15, [r14+256]
    vroundps ymm3, ymm1, 8
    vsubps ymm3, ymm1, ymm3
    vcvtps2dq ymm1, ymm1
    jmp .j5696
.j5696:
    vandnps ymm3, ymm15, ymm3
    vaddps ymm3, ymm3, ymm6
    vpaddd ymm6, ymm1, [c_i64]
    vcmpps ymm1, ymm3, ymm11, 21
    vmovmskps r2d, ymm1
    mov [r14+640], r2b
    vcmpps ymm3, ymm2, ymm13, 21
    vorps ymm1, ymm3, [rsp+4832]
    vorps ymm3, ymm1, ymm0
    vfmadd132ps ymm1, ymm12, [rsp+4896]
    vblendvps ymm0, ymm3, ymm14, ymm2
    vcmpps ymm3, ymm4, ymm13, 21
    vmulps ymm2, ymm0, ymm8
    vorps ymm0, ymm3, [rsp+4640]
    vorps ymm3, ymm0, ymm5
    vfmadd132ps ymm0, ymm12, [rsp+4704]
    vfmadd213ps ymm1, ymm8, ymm7
    vblendvps ymm5, ymm3, ymm14, ymm4
    vmovups ymm3, [rsp+4768]
    vfmadd231ps ymm2, ymm5, ymm10
    vandps ymm4, ymm15, [r14+288]
    vfmadd231ps ymm1, ymm0, ymm10
    vcmpps ymm5, ymm3, ymm13, 21
    vorps ymm0, ymm5, [rsp+4736]
    vorps ymm5, ymm0, ymm4
    vfmadd132ps ymm0, ymm12, [rsp+4800]
    vblendvps ymm4, ymm5, ymm14, ymm3
    vmovups ymm5, [rsp+4576]
    vfmadd231ps ymm2, ymm4, ymm9
    vandps ymm3, ymm15, [r14+192]
    vfmadd231ps ymm1, ymm0, ymm9
    vroundps ymm4, ymm2, 8
    vsubps ymm0, ymm2, ymm4
    vcvtps2dq ymm4, ymm2
    vandnps ymm2, ymm15, ymm0
    vaddps ymm0, ymm2, ymm1
    vpaddd ymm2, ymm4, [c_i64]
    vcmpps ymm1, ymm5, ymm13, 21
    vpackusdw ymm4, ymm6, ymm2
    vmovups ymm6, [rsp+4384]
    vcmpps ymm2, ymm0, ymm11, 21
    vorps ymm0, ymm1, [rsp+4544]
    vpminuw ymm1, ymm4, [c_w1023]
    vorps ymm4, ymm0, ymm3
    vfmadd132ps ymm0, ymm12, [rsp+4608]
    vmovmskps r2d, ymm2
    mov [r14+642], r2b
    vpermq ymm3, ymm1, 216
    vblendvps ymm2, ymm4, ymm14, ymm5
    vandps ymm1, ymm15, [r14+128]
    vmovups ymm4, [rsp+4480]
    vmulps ymm5, ymm2, ymm8
    vfmadd213ps ymm0, ymm8, ymm7
    vmovdqu [r11+(W*0)], ymm3
    vcmpps ymm2, ymm6, ymm13, 21
    vorps ymm3, ymm2, [rsp+4352]
    vorps ymm2, ymm3, ymm1
    vfmadd132ps ymm3, ymm12, [rsp+4416]
    vblendvps ymm1, ymm2, ymm14, ymm6
    vcmpps ymm2, ymm4, ymm13, 21
    vfmadd231ps ymm5, ymm1, ymm10
    vorps ymm6, ymm2, [rsp+4448]
    vandps ymm1, ymm15, [r14+160]
    vorps ymm2, ymm6, ymm1
    vfmadd132ps ymm6, ymm12, [rsp+4512]
    vfmadd231ps ymm0, ymm3, ymm10
    jmp .j5760
.j5760:
    vmovups ymm1, [rsp+5152]
    vblendvps ymm3, ymm2, ymm14, ymm4
    vandps ymm2, ymm15, [r14+448]
    vfmadd231ps ymm5, ymm3, ymm9
    vmovups ymm4, [rsp+4960]
    vfmadd231ps ymm0, ymm6, ymm9
    vandps ymm3, ymm15, [r14+384]
    vroundps ymm6, ymm5, 8
    vsubps ymm6, ymm5, ymm6
    vcvtps2dq ymm5, ymm5
    vandnps ymm6, ymm15, ymm6
    vaddps ymm6, ymm6, ymm0
    vpaddd ymm0, ymm5, [c_i64]
    vcmpps ymm5, ymm6, ymm11, 21
    vmovmskps r2d, ymm5
    mov [r14+641], r2b
    vcmpps ymm6, ymm1, ymm13, 21
    vorps ymm5, ymm6, [rsp+5120]
    vorps ymm6, ymm5, ymm2
    vfmadd132ps ymm5, ymm12, [rsp+5184]
    vblendvps ymm2, ymm6, ymm14, ymm1
    vcmpps ymm6, ymm4, ymm13, 21
    vmulps ymm1, ymm2, ymm8
    vorps ymm2, ymm6, [rsp+4928]
    vorps ymm6, ymm2, ymm3
    vfmadd132ps ymm2, ymm12, [rsp+4992]
    vfmadd213ps ymm5, ymm8, ymm7
    vblendvps ymm3, ymm6, ymm14, ymm4
    vmovups ymm8, [rsp+5056]
    vandps ymm6, ymm15, [r14+416]
    vfmadd231ps ymm1, ymm3, ymm10
    vfmadd231ps ymm5, ymm2, ymm10
    vcmpps ymm4, ymm8, ymm13, 21
    vorps ymm3, ymm4, [rsp+5024]
    vorps ymm2, ymm3, ymm6
    vfmadd132ps ymm3, ymm12, [rsp+5088]
    vblendvps ymm10, ymm2, ymm14, ymm8
    vmovups ymm13, [rsp+5248]
    vfmadd231ps ymm1, ymm10, ymm9
    vandps ymm4, ymm15, [r14+512]
    vfmadd231ps ymm5, ymm3, ymm9
    vroundps ymm6, ymm1, 8
    vcvtps2dq ymm2, ymm1
    vmovups ymm8, [rsp+5344]
    vcmpps ymm10, ymm13, [c_onh], 21
    vsubps ymm3, ymm1, ymm6
    vpaddd ymm9, ymm2, [c_i64]
    vpackusdw ymm1, ymm0, ymm9
    vorps ymm6, ymm10, [rsp+5216]
    vandps ymm2, ymm15, [r14+544]
    vandnps ymm0, ymm15, ymm3
    vorps ymm9, ymm6, ymm4
    vfmadd132ps ymm6, ymm12, [rsp+5280]
    vmovups ymm10, [rsp+5440]
    vaddps ymm3, ymm0, ymm5
    vpminuw ymm4, ymm1, [c_w1023]
    vblendvps ymm0, ymm9, ymm14, ymm13
    vandps ymm5, ymm15, [r14+576]
    vpermq ymm1, ymm4, 216
    vmulps ymm9, ymm0, [c_mth1]
    vcmpps ymm13, ymm3, ymm11, 21
    vcmpps ymm4, ymm8, [c_onh], 21
    vmovmskps r2d, ymm13
    mov [r14+643], r2b
    vorps ymm3, ymm4, [rsp+5312]
    vmovdqu [r11+(W*1)], ymm1
    jmp .j5824
.j5824:
    vorps ymm13, ymm3, ymm2
    vfmadd132ps ymm3, ymm12, [rsp+5376]
    vmovaps ymm4, ymm7
    vfmadd231ps ymm4, ymm6, [c_mth1]
    vblendvps ymm1, ymm13, ymm14, ymm8
    vcmpps ymm2, ymm10, [c_onh], 21
    vfmadd231ps ymm9, ymm1, [c_mth2]
    vorps ymm13, ymm2, [rsp+5408]
    vorps ymm8, ymm13, ymm5
    vfmadd231ps ymm12, ymm13, [rsp+5472]
    vfmadd231ps ymm4, ymm3, [c_mth2]
    vblendvps ymm2, ymm8, ymm14, ymm10
    vfmsub231ps ymm9, ymm2, [c_mth0]
    vmulps ymm5, ymm2, [c_mth5]
    vfmadd231ps ymm4, ymm12, [c_mth0]
    vfmadd231ps ymm7, ymm12, [c_mth5]
    vfmadd231ps ymm5, ymm1, [c_mth4]
    vroundps ymm13, ymm9, 8
    vcvtps2dq ymm8, ymm9
    vfmadd231ps ymm7, ymm3, [c_mth4]
    vfmsub231ps ymm5, ymm0, [c_mth3]
    vsubps ymm14, ymm9, ymm13
    vpaddd ymm10, ymm8, [c_i512]
    vmovups ymm2, [c_pd8]
    vandnps ymm12, ymm15, ymm14
    vfmadd231ps ymm7, ymm6, [c_mth3]
    vaddps ymm1, ymm12, ymm4
    vroundps ymm3, ymm5, 8
    vcvtps2dq ymm0, ymm5
    vcmpps ymm9, ymm1, ymm11, 21
    vsubps ymm13, ymm5, ymm3
    vpaddd ymm8, ymm0, [c_i512]
    vpackusdw ymm14, ymm10, ymm8
    vandnps ymm6, ymm15, ymm13
    vaddps ymm12, ymm6, ymm7
    vpminuw ymm4, ymm14, [c_w1023]
    vpermd ymm1, ymm2, ymm4
    vcmpps ymm5, ymm12, ymm11, 21
    vorps ymm3, ymm9, ymm5
    vmovmskps r2d, ymm3
    mov [r14+644], r2b
    vmovdqu [r6], xmm1
    vextracti128 [gs:r6], ymm1, 1
    lea r2, [r11 - 32]
    sub r2, [rsp + 6760]
    vmovd xmm3, r2d
    vpbroadcastd ymm3, xmm3
    mov r5d, [rsp + STX+5120]
    movzx r7d, byte [r13 + 640]
    vpmovzxbd ymm2, [t_cmp + r7*8]
    vpermps ymm0, ymm2, [r13 + 0]
    vmovups [rsp + r5*4 + STX+0], ymm0
    vpermps ymm0, ymm2, [r13 + 32]
    vmovups [rsp + r5*4 + STX+512], ymm0
    vpermps ymm0, ymm2, [r13 + 64]
    vmovups [rsp + r5*4 + STX+1024], ymm0
    vpermps ymm0, ymm2, [r13 + 96]
    vmovups [rsp + r5*4 + STX+1536], ymm0
    vpaddd ymm0, ymm3, [t_lad + 0]
    vpermd ymm0, ymm2, ymm0
    vmovdqu [rsp + r5*4 + STX+2048], ymm0
    popcnt r7d, r7d
    add r5d, r7d
    movzx r7d, byte [r13 + 641]
    vpmovzxbd ymm2, [t_cmp + r7*8]
    vpermps ymm0, ymm2, [r13 + 128]
    vmovups [rsp + r5*4 + STX+0], ymm0
    vpermps ymm0, ymm2, [r13 + 160]
    vmovups [rsp + r5*4 + STX+512], ymm0
    vpermps ymm0, ymm2, [r13 + 192]
    vmovups [rsp + r5*4 + STX+1024], ymm0
    vpermps ymm0, ymm2, [r13 + 224]
    vmovups [rsp + r5*4 + STX+1536], ymm0
    vpaddd ymm0, ymm3, [t_lad + 32]
    vpermd ymm0, ymm2, ymm0
    vmovdqu [rsp + r5*4 + STX+2048], ymm0
    popcnt r7d, r7d
    add r5d, r7d
    movzx r7d, byte [r13 + 642]
    vpmovzxbd ymm2, [t_cmp + r7*8]
    vpermps ymm0, ymm2, [r13 + 256]
    vmovups [rsp + r5*4 + STX+0], ymm0
    vpermps ymm0, ymm2, [r13 + 288]
    vmovups [rsp + r5*4 + STX+512], ymm0
    vpermps ymm0, ymm2, [r13 + 320]
    vmovups [rsp + r5*4 + STX+1024], ymm0
    vpermps ymm0, ymm2, [r13 + 352]
    vmovups [rsp + r5*4 + STX+1536], ymm0
    vpaddd ymm0, ymm3, [t_lad + 64]
    vpermd ymm0, ymm2, ymm0
    vmovdqu [rsp + r5*4 + STX+2048], ymm0
    popcnt r7d, r7d
    add r5d, r7d
    movzx r7d, byte [r13 + 643]
    vpmovzxbd ymm2, [t_cmp + r7*8]
    vpermps ymm0, ymm2, [r13 + 384]
    vmovups [rsp + r5*4 + STX+0], ymm0
    vpermps ymm0, ymm2, [r13 + 416]
    vmovups [rsp + r5*4 + STX+512], ymm0
    vpermps ymm0, ymm2, [r13 + 448]
    vmovups [rsp + r5*4 + STX+1024], ymm0
    vpermps ymm0, ymm2, [r13 + 480]
    vmovups [rsp + r5*4 + STX+1536], ymm0
    vpaddd ymm0, ymm3, [t_lad + 96]
    vpermd ymm0, ymm2, ymm0
    vmovdqu [rsp + r5*4 + STX+2048], ymm0
    popcnt r7d, r7d
    add r5d, r7d
    mov [rsp + STX+5120], r5d
    cmp r5d, 97
    jb .xle0
    call .fll
.xle0:
    lea r2, [r6 - 16]
    sub r2, [rsp + 6760]
    vmovd xmm3, r2d
    vpbroadcastd ymm3, xmm3
    mov r5d, [rsp + STX+5124]
    movzx r7d, byte [r13 + 644]
    vpmovzxbd ymm2, [t_cmp + r7*8]
    vpermps ymm0, ymm2, [r13 + 512]
    vmovups [rsp + r5*4 + STX+2560+0], ymm0
    vpermps ymm0, ymm2, [r13 + 544]
    vmovups [rsp + r5*4 + STX+2560+512], ymm0
    vpermps ymm0, ymm2, [r13 + 576]
    vmovups [rsp + r5*4 + STX+2560+1024], ymm0
    vpermps ymm0, ymm2, [r13 + 608]
    vmovups [rsp + r5*4 + STX+2560+1536], ymm0
    vpaddd ymm0, ymm3, [t_c2d]
    vpermd ymm0, ymm2, ymm0
    vmovdqu [rsp + r5*4 + STX+4608], ymm0
    popcnt r7d, r7d
    add r5d, r7d
    mov [rsp + STX+5124], r5d
    cmp r5d, 121
    jb .xce0
    call .flc
.xce0:
    lea r2, [r11 - 0]
    sub r2, [rsp + 6760]
    vmovd xmm3, r2d
    vpbroadcastd ymm3, xmm3
    mov r5d, [rsp + STX+5120]
    movzx r7d, byte [r14 + 640]
    vpmovzxbd ymm2, [t_cmp + r7*8]
    vpermps ymm0, ymm2, [r14 + 0]
    vmovups [rsp + r5*4 + STX+0], ymm0
    vpermps ymm0, ymm2, [r14 + 32]
    vmovups [rsp + r5*4 + STX+512], ymm0
    vpermps ymm0, ymm2, [r14 + 64]
    vmovups [rsp + r5*4 + STX+1024], ymm0
    vpermps ymm0, ymm2, [r14 + 96]
    vmovups [rsp + r5*4 + STX+1536], ymm0
    vpaddd ymm0, ymm3, [t_lad + 0]
    vpermd ymm0, ymm2, ymm0
    vmovdqu [rsp + r5*4 + STX+2048], ymm0
    popcnt r7d, r7d
    add r5d, r7d
    movzx r7d, byte [r14 + 641]
    vpmovzxbd ymm2, [t_cmp + r7*8]
    vpermps ymm0, ymm2, [r14 + 128]
    vmovups [rsp + r5*4 + STX+0], ymm0
    vpermps ymm0, ymm2, [r14 + 160]
    vmovups [rsp + r5*4 + STX+512], ymm0
    vpermps ymm0, ymm2, [r14 + 192]
    vmovups [rsp + r5*4 + STX+1024], ymm0
    vpermps ymm0, ymm2, [r14 + 224]
    vmovups [rsp + r5*4 + STX+1536], ymm0
    vpaddd ymm0, ymm3, [t_lad + 32]
    vpermd ymm0, ymm2, ymm0
    vmovdqu [rsp + r5*4 + STX+2048], ymm0
    popcnt r7d, r7d
    add r5d, r7d
    movzx r7d, byte [r14 + 642]
    vpmovzxbd ymm2, [t_cmp + r7*8]
    vpermps ymm0, ymm2, [r14 + 256]
    vmovups [rsp + r5*4 + STX+0], ymm0
    vpermps ymm0, ymm2, [r14 + 288]
    vmovups [rsp + r5*4 + STX+512], ymm0
    vpermps ymm0, ymm2, [r14 + 320]
    vmovups [rsp + r5*4 + STX+1024], ymm0
    vpermps ymm0, ymm2, [r14 + 352]
    vmovups [rsp + r5*4 + STX+1536], ymm0
    vpaddd ymm0, ymm3, [t_lad + 64]
    vpermd ymm0, ymm2, ymm0
    vmovdqu [rsp + r5*4 + STX+2048], ymm0
    popcnt r7d, r7d
    add r5d, r7d
    movzx r7d, byte [r14 + 643]
    vpmovzxbd ymm2, [t_cmp + r7*8]
    vpermps ymm0, ymm2, [r14 + 384]
    vmovups [rsp + r5*4 + STX+0], ymm0
    vpermps ymm0, ymm2, [r14 + 416]
    vmovups [rsp + r5*4 + STX+512], ymm0
    vpermps ymm0, ymm2, [r14 + 448]
    vmovups [rsp + r5*4 + STX+1024], ymm0
    vpermps ymm0, ymm2, [r14 + 480]
    vmovups [rsp + r5*4 + STX+1536], ymm0
    vpaddd ymm0, ymm3, [t_lad + 96]
    vpermd ymm0, ymm2, ymm0
    vmovdqu [rsp + r5*4 + STX+2048], ymm0
    popcnt r7d, r7d
    add r5d, r7d
    mov [rsp + STX+5120], r5d
    cmp r5d, 97
    jb .xle1
    call .fll
.xle1:
    lea r2, [r6 - 0]
    sub r2, [rsp + 6760]
    vmovd xmm3, r2d
    vpbroadcastd ymm3, xmm3
    mov r5d, [rsp + STX+5124]
    movzx r7d, byte [r14 + 644]
    vpmovzxbd ymm2, [t_cmp + r7*8]
    vpermps ymm0, ymm2, [r14 + 512]
    vmovups [rsp + r5*4 + STX+2560+0], ymm0
    vpermps ymm0, ymm2, [r14 + 544]
    vmovups [rsp + r5*4 + STX+2560+512], ymm0
    vpermps ymm0, ymm2, [r14 + 576]
    vmovups [rsp + r5*4 + STX+2560+1024], ymm0
    vpermps ymm0, ymm2, [r14 + 608]
    vmovups [rsp + r5*4 + STX+2560+1536], ymm0
    vpaddd ymm0, ymm3, [t_c2d]
    vpermd ymm0, ymm2, ymm0
    vmovdqu [rsp + r5*4 + STX+4608], ymm0
    popcnt r7d, r7d
    add r5d, r7d
    mov [rsp + STX+5124], r5d
    cmp r5d, 121
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
    mov rsp, [rsp + 6752]
    pop r12
    pop r11
    pop r14
    pop r13
    pop r10
    pop r9
    vzeroupper
    ret
.hk:
    mov [rsp + 6688], r5
    mov [rsp + 6696], r7
    lea r5, [r11 - 32 - W]
    lea r2, [r11 - 32]
    cmp r3d, 16 - W/2
    cmove r2, r5
    sub r2, [rsp + 6760]
    vmovd xmm3, r2d
    vpbroadcastd ymm3, xmm3
    mov r5d, [rsp + STX+5120]
    movzx r7d, byte [r13 + 640]
    vpmovzxbd ymm2, [t_cmp + r7*8]
    vpermps ymm0, ymm2, [r13 + 0]
    vmovups [rsp + r5*4 + STX+0], ymm0
    vpermps ymm0, ymm2, [r13 + 32]
    vmovups [rsp + r5*4 + STX+512], ymm0
    vpermps ymm0, ymm2, [r13 + 64]
    vmovups [rsp + r5*4 + STX+1024], ymm0
    vpermps ymm0, ymm2, [r13 + 96]
    vmovups [rsp + r5*4 + STX+1536], ymm0
    vpaddd ymm0, ymm3, [t_lad + 0]
    vpermd ymm0, ymm2, ymm0
    vmovdqu [rsp + r5*4 + STX+2048], ymm0
    popcnt r7d, r7d
    add r5d, r7d
    movzx r7d, byte [r13 + 641]
    vpmovzxbd ymm2, [t_cmp + r7*8]
    vpermps ymm0, ymm2, [r13 + 128]
    vmovups [rsp + r5*4 + STX+0], ymm0
    vpermps ymm0, ymm2, [r13 + 160]
    vmovups [rsp + r5*4 + STX+512], ymm0
    vpermps ymm0, ymm2, [r13 + 192]
    vmovups [rsp + r5*4 + STX+1024], ymm0
    vpermps ymm0, ymm2, [r13 + 224]
    vmovups [rsp + r5*4 + STX+1536], ymm0
    vpaddd ymm0, ymm3, [t_lad + 32]
    vpermd ymm0, ymm2, ymm0
    vmovdqu [rsp + r5*4 + STX+2048], ymm0
    popcnt r7d, r7d
    add r5d, r7d
    movzx r7d, byte [r13 + 642]
    vpmovzxbd ymm2, [t_cmp + r7*8]
    vpermps ymm0, ymm2, [r13 + 256]
    vmovups [rsp + r5*4 + STX+0], ymm0
    vpermps ymm0, ymm2, [r13 + 288]
    vmovups [rsp + r5*4 + STX+512], ymm0
    vpermps ymm0, ymm2, [r13 + 320]
    vmovups [rsp + r5*4 + STX+1024], ymm0
    vpermps ymm0, ymm2, [r13 + 352]
    vmovups [rsp + r5*4 + STX+1536], ymm0
    vpaddd ymm0, ymm3, [t_lad + 64]
    vpermd ymm0, ymm2, ymm0
    vmovdqu [rsp + r5*4 + STX+2048], ymm0
    popcnt r7d, r7d
    add r5d, r7d
    movzx r7d, byte [r13 + 643]
    vpmovzxbd ymm2, [t_cmp + r7*8]
    vpermps ymm0, ymm2, [r13 + 384]
    vmovups [rsp + r5*4 + STX+0], ymm0
    vpermps ymm0, ymm2, [r13 + 416]
    vmovups [rsp + r5*4 + STX+512], ymm0
    vpermps ymm0, ymm2, [r13 + 448]
    vmovups [rsp + r5*4 + STX+1024], ymm0
    vpermps ymm0, ymm2, [r13 + 480]
    vmovups [rsp + r5*4 + STX+1536], ymm0
    vpaddd ymm0, ymm3, [t_lad + 96]
    vpermd ymm0, ymm2, ymm0
    vmovdqu [rsp + r5*4 + STX+2048], ymm0
    popcnt r7d, r7d
    add r5d, r7d
    mov [rsp + STX+5120], r5d
    cmp r5d, 97
    jb .xlh
    call .fll
.xlh:
    lea r2, [r6 - 16]
    sub r2, [rsp + 6760]
    vmovd xmm3, r2d
    vpbroadcastd ymm3, xmm3
    mov r5d, [rsp + STX+5124]
    movzx r7d, byte [r13 + 644]
    vpmovzxbd ymm2, [t_cmp + r7*8]
    vpermps ymm0, ymm2, [r13 + 512]
    vmovups [rsp + r5*4 + STX+2560+0], ymm0
    vpermps ymm0, ymm2, [r13 + 544]
    vmovups [rsp + r5*4 + STX+2560+512], ymm0
    vpermps ymm0, ymm2, [r13 + 576]
    vmovups [rsp + r5*4 + STX+2560+1024], ymm0
    vpermps ymm0, ymm2, [r13 + 608]
    vmovups [rsp + r5*4 + STX+2560+1536], ymm0
    vpaddd ymm0, ymm3, [t_c2d]
    vpermd ymm0, ymm2, ymm0
    vmovdqu [rsp + r5*4 + STX+4608], ymm0
    popcnt r7d, r7d
    add r5d, r7d
    mov [rsp + STX+5124], r5d
    cmp r5d, 121
    jb .xch
    call .flc
.xch:
    mov r5, [rsp + 6688]
    mov r7, [rsp + 6696]
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
    mov r6, [r10 + TS + 8 + 6768]
    mov [r10 + T_SRC], r6
    lea r0, [r10 + TS + 8 + STX+2048]
    mov r4, [r10 + TS + 8 + 6760]
    mov r5d, [r10 + TS + 8 + STX+5120]
    mov dword [r10 + TS + 8 + STX+5120], 0
    xor r9d, r9d
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r10 + T_QF], ymm0
    lea r1, [r10 + TS + 8 + STX]
.fl1:
    vcvtps2pd ymm0, [r1 + 1536]
    vbroadcastsd ymm1, [d_anl]
    vbroadcastsd ymm2, [d_tab]
    vfnmadd231pd ymm2, ymm1, ymm0
    vmovapd [r10 + T_T1], ymm2
    xor r6d, r6d
.cl:
    vcvtps2pd ymm0, [r1 + r6*8]
    vbroadcastsd ymm1, [d_kvl]
    vmulpd ymm0, ymm0, ymm1
    vmovapd ymm1, [r10 + T_T1]
    vbroadcastsd ymm2, [d_rgl]
    call .ivq
    vmovapd [r10 + T_E1 + r6], ymm0
    vmovapd [r10 + T_E1 + r6 + 32], ymm1
    add r6d, 64
    cmp r6d, 192
    jne .cl
    vbroadcastsd ymm0, [d_sll]
    vbroadcastsd ymm1, [d_shl]
    vbroadcastsd ymm2, [d_emc0]
    vfmadd231pd ymm0, ymm2, [r10 + T_E1 + 0]
    vfmadd231pd ymm1, ymm2, [r10 + T_E1 + 32]
    vbroadcastsd ymm2, [d_emc1]
    vfmadd231pd ymm0, ymm2, [r10 + T_E1 + 64]
    vfmadd231pd ymm1, ymm2, [r10 + T_E1 + 96]
    vbroadcastsd ymm2, [d_emc2]
    vfmadd231pd ymm0, ymm2, [r10 + T_E1 + 128]
    vfmadd231pd ymm1, ymm2, [r10 + T_E1 + 160]
    vroundpd ymm2, ymm0, 8
    vroundpd ymm3, ymm1, 8
    vbroadcastsd ymm4, [d_m63]
    vpbroadcastq ymm5, [d_abs]
    vandpd ymm6, ymm2, ymm5
    vandpd ymm5, ymm3, ymm5
    vbroadcastsd ymm7, [d_p63]
    vcmppd ymm6, ymm6, ymm7, 0x11
    vcmppd ymm5, ymm5, ymm7, 0x11
    vblendvpd ymm2, ymm4, ymm2, ymm6
    vblendvpd ymm3, ymm4, ymm3, ymm5
    vcmppd ymm4, ymm0, ymm1, 7
    vcmppd ymm3, ymm2, ymm3, 0
    vandpd ymm3, ymm4, ymm3
    vxorpd xmm4, xmm4, xmm4
    vmaxpd ymm2, ymm2, ymm4
    vbroadcastsd ymm4, [d_1023]
    vminpd ymm2, ymm2, ymm4
    vbroadcastsd ymm4, [d_mone]
    vblendvpd ymm2, ymm4, ymm2, ymm3
    vcvtpd2dq xmm2, ymm2
    vpmovsxdq ymm0, xmm2
    vmovdqa [r10 + T_RQ + r9*8], ymm0
    add r1, 16
    add r9d, 4
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
    mov r6, [r10 + TS + 8 + 6768]
    mov [r10 + T_SRC], r6
    lea r0, [r10 + TS + 8 + STX+4608]
    mov r4, [r10 + TS + 8 + 6760]
    mov r5d, [r10 + TS + 8 + STX+5124]
    mov dword [r10 + TS + 8 + STX+5124], 0
    xor r9d, r9d
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r10 + T_QF], ymm0
    lea r1, [r10 + TS + 8 + STX+2560]
.fc1:
    vcvtps2pd ymm0, [r1 + 1536]
    vbroadcastsd ymm1, [d_anh]
    vbroadcastsd ymm2, [d_tab]
    vfnmadd231pd ymm2, ymm1, ymm0
    vmovapd [r10 + T_T1], ymm2
    xor r6d, r6d
.ch:
    vcvtps2pd ymm0, [r1 + r6*8]
    vbroadcastsd ymm1, [d_kvh]
    vmulpd ymm0, ymm0, ymm1
    vmovapd ymm1, [r10 + T_T1]
    vbroadcastsd ymm2, [d_rgh]
    call .ivq
    vmovapd [r10 + T_E1 + r6], ymm0
    vmovapd [r10 + T_E1 + r6 + 32], ymm1
    add r6d, 64
    cmp r6d, 192
    jne .ch
    vbroadcastsd ymm0, [d_slh]
    vbroadcastsd ymm2, [d_emc8]
    vfnmadd231pd ymm0, ymm2, [r10 + T_E1 + 160]
    vbroadcastsd ymm2, [d_emc7]
    vfnmadd231pd ymm0, ymm2, [r10 + T_E1 + 96]
    vbroadcastsd ymm2, [d_emc6]
    vfmadd231pd ymm0, ymm2, [r10 + T_E1 + 0]
    vbroadcastsd ymm1, [d_shh]
    vbroadcastsd ymm2, [d_emc8]
    vfnmadd231pd ymm1, ymm2, [r10 + T_E1 + 128]
    vbroadcastsd ymm2, [d_emc7]
    vfnmadd231pd ymm1, ymm2, [r10 + T_E1 + 64]
    vbroadcastsd ymm2, [d_emc6]
    vfmadd231pd ymm1, ymm2, [r10 + T_E1 + 32]
    vroundpd ymm2, ymm0, 8
    vroundpd ymm3, ymm1, 8
    vbroadcastsd ymm4, [d_m63]
    vpbroadcastq ymm5, [d_abs]
    vandpd ymm6, ymm2, ymm5
    vandpd ymm5, ymm3, ymm5
    vbroadcastsd ymm7, [d_p63]
    vcmppd ymm6, ymm6, ymm7, 0x11
    vcmppd ymm5, ymm5, ymm7, 0x11
    vblendvpd ymm2, ymm4, ymm2, ymm6
    vblendvpd ymm3, ymm4, ymm3, ymm5
    vcmppd ymm4, ymm0, ymm1, 7
    vcmppd ymm3, ymm2, ymm3, 0
    vandpd ymm3, ymm4, ymm3
    vxorpd xmm4, xmm4, xmm4
    vmaxpd ymm2, ymm2, ymm4
    vbroadcastsd ymm4, [d_1023]
    vminpd ymm2, ymm2, ymm4
    vbroadcastsd ymm4, [d_mone]
    vblendvpd ymm2, ymm4, ymm2, ymm3
    vcvtpd2dq xmm2, ymm2
    vpmovsxdq ymm8, xmm2
    vbroadcastsd ymm0, [d_slh]
    vbroadcastsd ymm2, [d_emc5]
    vfnmadd231pd ymm0, ymm2, [r10 + T_E1 + 96]
    vbroadcastsd ymm2, [d_emc4]
    vfnmadd231pd ymm0, ymm2, [r10 + T_E1 + 32]
    vbroadcastsd ymm2, [d_emc3]
    vfmadd231pd ymm0, ymm2, [r10 + T_E1 + 128]
    vbroadcastsd ymm1, [d_shh]
    vbroadcastsd ymm2, [d_emc5]
    vfnmadd231pd ymm1, ymm2, [r10 + T_E1 + 64]
    vbroadcastsd ymm2, [d_emc4]
    vfnmadd231pd ymm1, ymm2, [r10 + T_E1 + 0]
    vbroadcastsd ymm2, [d_emc3]
    vfmadd231pd ymm1, ymm2, [r10 + T_E1 + 160]
    vroundpd ymm2, ymm0, 8
    vroundpd ymm3, ymm1, 8
    vbroadcastsd ymm4, [d_m63]
    vpbroadcastq ymm5, [d_abs]
    vandpd ymm6, ymm2, ymm5
    vandpd ymm5, ymm3, ymm5
    vbroadcastsd ymm7, [d_p63]
    vcmppd ymm6, ymm6, ymm7, 0x11
    vcmppd ymm5, ymm5, ymm7, 0x11
    vblendvpd ymm2, ymm4, ymm2, ymm6
    vblendvpd ymm3, ymm4, ymm3, ymm5
    vcmppd ymm4, ymm0, ymm1, 7
    vcmppd ymm3, ymm2, ymm3, 0
    vandpd ymm3, ymm4, ymm3
    vxorpd xmm4, xmm4, xmm4
    vmaxpd ymm2, ymm2, ymm4
    vbroadcastsd ymm4, [d_1023]
    vminpd ymm2, ymm2, ymm4
    vbroadcastsd ymm4, [d_mone]
    vblendvpd ymm2, ymm4, ymm2, ymm3
    vcvtpd2dq xmm2, ymm2
    vpmovsxdq ymm0, xmm2
    vpcmpeqd ymm1, ymm1, ymm1
    vpcmpeqq ymm1, ymm8, ymm1
    vpor ymm0, ymm0, ymm1
    vmovdqa [r10 + T_RQ + r9*8], ymm0
    vmovdqa [r10 + T_RQ + 1024 + r9*8], ymm8
    add r1, 16
    add r9d, 4
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
    vpbroadcastq ymm3, [d_abs]
    vandpd ymm3, ymm3, ymm0
    vfmadd213pd ymm2, ymm3, ymm1
    vsubpd ymm4, ymm3, ymm2
    vcmppd ymm5, ymm4, ymm2, 0x1e
    vaddpd ymm6, ymm3, ymm2
    vblendvpd ymm6, ymm6, ymm3, ymm5
    vmovapd [r10 + T_IV], ymm0
    vmovapd [r10 + T_IV + 32], ymm2
    vmovapd [r10 + T_IV + 64], ymm4
    vmovapd [r10 + T_IV + 96], ymm5
    vpsrlq ymm7, ymm6, 48
    vpbroadcastq ymm15, [d_i15]
    vpand ymm7, ymm7, ymm15
    vpsrlq ymm8, ymm6, 52
    vpand ymm8, ymm8, ymm15
    lea r2, [d_qa]
    vpcmpeqd ymm10, ymm10, ymm10
    vgatherqpd ymm9, [r2 + ymm8*8], ymm10
    vpsrlq ymm8, ymm6, 56
    vpbroadcastq ymm10, [d_i7]
    vpand ymm8, ymm8, ymm10
    lea r2, [d_qb]
    vpcmpeqd ymm10, ymm10, ymm10
    vgatherqpd ymm11, [r2 + ymm8*8], ymm10
    vmulpd ymm9, ymm9, ymm11
    lea r2, [d_qw]
    vpcmpeqd ymm10, ymm10, ymm10
    vgatherqpd ymm11, [r2 + ymm7*8], ymm10
    vmulpd ymm9, ymm9, ymm11
    vpbroadcastq ymm11, [d_mant]
    vandpd ymm11, ymm11, ymm6
    vbroadcastsd ymm12, [d_one]
    vorpd ymm11, ymm11, ymm12
    vcmppd ymm13, ymm6, ymm6, 3
    vorpd ymm11, ymm11, ymm13
    lea r2, [d_rx]
    vpcmpeqd ymm10, ymm10, ymm10
    vgatherqpd ymm13, [r2 + ymm7*8], ymm10
    vfmsub213pd ymm11, ymm13, ymm12
    vmulpd ymm13, ymm11, ymm11
    vbroadcastsd ymm14, [d_qp1]
    vbroadcastsd ymm10, [d_qp0]
    vfmadd213pd ymm14, ymm11, ymm10
    vbroadcastsd ymm10, [d_qp3]
    vbroadcastsd ymm8, [d_qp2]
    vfmadd213pd ymm10, ymm11, ymm8
    vbroadcastsd ymm8, [d_qp5]
    vbroadcastsd ymm7, [d_qp4]
    vfmadd213pd ymm8, ymm11, ymm7
    vfmadd213pd ymm8, ymm13, ymm10
    vfmadd213pd ymm8, ymm13, ymm14
    vmulpd ymm9, ymm9, ymm8
    vbroadcastsd ymm10, [d_c2]
    vbroadcastsd ymm7, [d_c1]
    vfmadd213pd ymm10, ymm9, ymm7
    vbroadcastsd ymm11, [d_c3]
    vfmadd213pd ymm11, ymm9, ymm12
    vdivpd ymm7, ymm10, ymm11
    vpsrlq ymm8, ymm7, 47
    vpand ymm8, ymm8, ymm15
    lea r2, [d_qr]
    vpcmpeqd ymm10, ymm10, ymm10
    vgatherqpd ymm9, [r2 + ymm8*8], ymm10
    vfmsub213pd ymm9, ymm7, ymm12
    vmulpd ymm11, ymm9, ymm9
    vbroadcastsd ymm13, [d_ql1]
    vbroadcastsd ymm14, [d_ql0]
    vfmadd213pd ymm13, ymm9, ymm14
    vbroadcastsd ymm14, [d_ql3]
    vbroadcastsd ymm10, [d_ql2]
    vfmadd213pd ymm14, ymm9, ymm10
    vbroadcastsd ymm10, [d_ql4]
    vfmadd213pd ymm10, ymm11, ymm14
    vfmadd213pd ymm10, ymm11, ymm13
    lea r2, [d_qm]
    vpcmpeqd ymm13, ymm13, ymm13
    vgatherqpd ymm14, [r2 + ymm8*8], ymm13
    vfmadd213pd ymm10, ymm9, ymm14
    vbroadcastsd ymm11, [d_16]
    vmulpd ymm11, ymm10, ymm11
    vroundpd ymm11, ymm11, 8
    vbroadcastsd ymm13, [d_q16]
    vmulpd ymm11, ymm11, ymm13
    vbroadcastsd ymm13, [d_qtk]
    vaddpd ymm13, ymm11, ymm13
    vpand ymm13, ymm13, ymm15
    lea r2, [d_qt]
    vpcmpeqd ymm14, ymm14, ymm14
    vgatherqpd ymm8, [r2 + ymm13*8], ymm14
    vsubpd ymm9, ymm10, ymm11
    vmulpd ymm13, ymm9, ymm9
    vbroadcastsd ymm14, [d_qe1]
    vbroadcastsd ymm10, [d_qe0]
    vfmadd213pd ymm14, ymm9, ymm10
    vbroadcastsd ymm10, [d_qe3]
    vbroadcastsd ymm0, [d_qe2]
    vfmadd213pd ymm10, ymm9, ymm0
    vbroadcastsd ymm0, [d_qe4]
    vfmadd213pd ymm0, ymm13, ymm10
    vfmadd213pd ymm0, ymm13, ymm14
    vmulpd ymm8, ymm8, ymm0
    vroundpd ymm0, ymm11, 9
    vcvtpd2dq xmm0, ymm0
    vpmovsxdq ymm0, xmm0
    vpbroadcastq ymm1, [d_q1023]
    vpaddq ymm0, ymm0, ymm1
    vpsllq ymm0, ymm0, 52
    vmulpd ymm8, ymm8, ymm0
    vcmppd ymm1, ymm6, ymm12, 0x1e
    vsubpd ymm2, ymm6, ymm12
    vbroadcastsd ymm3, [d_m12]
    vfmadd213pd ymm2, ymm3, ymm12
    vblendvpd ymm8, ymm8, ymm2, ymm1
    vbroadcastsd ymm0, [d_c1]
    vsubpd ymm0, ymm7, ymm0
    vbroadcastsd ymm1, [d_c2]
    vdivpd ymm1, ymm1, ymm7
    vbroadcastsd ymm2, [d_c3]
    vsubpd ymm1, ymm1, ymm2
    vmulpd ymm0, ymm0, ymm1
    vbroadcastsd ymm1, [d_k7]
    vbroadcastsd ymm2, [d_k7s]
    vfmadd213pd ymm1, ymm6, ymm2
    vdivpd ymm1, ymm6, ymm1
    vcmppd ymm2, ymm6, ymm12, 0x1e
    vblendvpd ymm0, ymm0, ymm1, ymm2
    vbroadcastsd ymm1, [d_k7m]
    vbroadcastsd ymm2, [d_sga]
    vfmadd213pd ymm0, ymm1, ymm2
    vbroadcastsd ymm1, [d_1024]
    vmulpd ymm1, ymm1, [r10 + T_IV + 32]
    vcmppd ymm1, ymm1, [r10 + T_IV + 64], 0x12
    vbroadcastsd ymm2, [d_eq0]
    vblendvpd ymm0, ymm2, ymm0, ymm1
    vmovapd ymm1, [r10 + T_QF]
    vblendvpd ymm0, ymm0, ymm2, ymm1
    vmovapd ymm1, [r10 + T_IV + 32]
    vdivpd ymm1, ymm1, [r10 + T_IV + 64]
    vandpd ymm1, ymm1, [r10 + T_IV + 96]
    vbroadcastsd ymm2, [d_omg]
    vfmadd213pd ymm0, ymm1, ymm2
    vmovapd ymm1, ymm0
    vfmadd213pd ymm1, ymm8, ymm8
    vpbroadcastq ymm3, [d_sgn]
    vxorpd ymm2, ymm1, ymm3
    vmovapd ymm4, ymm0
    vfnmadd213pd ymm4, ymm8, ymm8
    vandpd ymm4, ymm4, [r10 + T_IV + 96]
    vmovapd ymm5, [r10 + T_IV + 64]
    vxorpd xmm6, xmm6, xmm6
    vcmppd ymm5, ymm5, ymm6, 0x1a
    vblendvpd ymm4, ymm4, ymm2, ymm5
    vxorpd ymm5, ymm4, ymm3
    vmovapd ymm6, [r10 + T_IV]
    vblendvpd ymm0, ymm4, ymm2, ymm6
    vblendvpd ymm1, ymm1, ymm5, ymm6
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
    vmovd xmm1, r3d
    vpbroadcastd ymm1, xmm1
    vpaddd ymm1, ymm1, [d_iot]
    vpxor xmm2, xmm2, xmm2
    vpmaxsd ymm1, ymm1, ymm2
    vpbroadcastd ymm2, [d_wcl]
    vpminsd ymm1, ymm1, ymm2
    vmovdqa [r10 + T_IX], ymm1
    imul r8, r2, CST
    lea r8, [r8 + r7 + CB]
    mov r7, -CST
    test r2d, r2d
    cmovz r7, r2
    lea r1, [r10 + T_B]
    call .p2l
    add r8, CRD
    lea r1, [r10 + T_R]
    call .p2l
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r10 + T_LA], ymm0
    vmovapd [r10 + T_AA], ymm0
    xor r2d, r2d
    call .xmv
    vmovapd ymm0, [r10 + T_ZB + 0]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_AA + 0]
    vmovsd [r10 + T_AA + 0], xmm0
    vmovapd ymm0, [r10 + T_ZB + 32]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_LA + 0]
    vmovsd [r10 + T_LA + 0], xmm0
    vmovapd ymm0, [r10 + T_ZB + 64]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_AA + 8]
    vmovsd [r10 + T_AA + 8], xmm0
    vmovapd ymm0, [r10 + T_ZB + 96]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_LA + 8]
    vmovsd [r10 + T_LA + 8], xmm0
    vmovapd ymm0, [r10 + T_ZB + 128]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_AA + 16]
    vmovsd [r10 + T_AA + 16], xmm0
    vmovapd ymm0, [r10 + T_ZB + 160]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_LA + 16]
    vmovsd [r10 + T_LA + 16], xmm0
    vbroadcastsd ymm3, [d_q4]
    vmulpd ymm0, ymm3, [r10 + T_LA]
    vpbroadcastq ymm2, [d_abs]
    vandpd ymm2, ymm2, ymm0
    vmovapd ymm1, [r10 + T_AA]
    vfmsub132pd ymm1, ymm2, ymm3
    vbroadcastsd ymm2, [d_rg2]
    vbroadcastsd ymm3, [d_tab2]
    vfmadd213pd ymm1, ymm2, ymm3
    vpcmpeqd ymm3, ymm3, ymm3
    vmovapd [r10 + T_QF], ymm3
    call .ivq
    vmovapd [r10 + T_LO], ymm0
    vmovapd [r10 + T_HI], ymm1
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
    vmovd xmm0, r3d
    vpbroadcastd ymm0, xmm0
    vmovdqa [r10 + T_VM], ymm0
    xor r3d, r3d
    test r6d, r6d
    setnz r3b
    neg r3d
    vmovd xmm0, r3d
    vpcmpeqd xmm1, xmm1, xmm1
    vpblendd xmm0, xmm0, xmm1, 2
    vmovdqa [r10 + T_HM], ymm0
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
    test r6d, r6d
    jnz .y2c
    vpshufb ymm0, ymm0, [d_yp]
.y2c:
    vpmovzxwd ymm1, xmm0
    vextracti128 xmm2, ymm0, 1
    vpmovzxwd ymm2, xmm2
    vcvtdq2pd ymm3, xmm1
    vmovapd [r10 + T_Y + 0], ymm3
    vextracti128 xmm1, ymm1, 1
    vcvtdq2pd ymm3, xmm1
    vmovapd [r10 + T_Y + 32], ymm3
    vcvtdq2pd ymm3, xmm2
    vmovapd [r10 + T_Y + 64], ymm3
    vextracti128 xmm2, ymm2, 1
    vcvtdq2pd ymm3, xmm2
    vmovapd [r10 + T_Y + 96], ymm3
    lea r3d, [r6*2 - 2]
    vmovd xmm1, r3d
    vpbroadcastd ymm1, xmm1
    vpaddd ymm1, ymm1, [d_iot]
    vpxor xmm2, xmm2, xmm2
    vpmaxsd ymm1, ymm1, ymm2
    vpbroadcastd ymm2, [d_wcl]
    vpminsd ymm1, ymm1, ymm2
    vmovdqa [r10 + T_IX], ymm1
    imul r8, r2, 2*CST
    lea r8, [r8 + r7 + CB]
    mov r7, -2*CST
    mov r3, -CST
    test r2d, r2d
    cmovz r7, r2
    cmovz r3, r2
    lea r1, [r10 + T_B]
    call .p2c
    add r8, CRD
    lea r1, [r10 + T_R]
    call .p2c
    vxorpd xmm0, xmm0, xmm0
    vmovapd [r10 + T_LA], ymm0
    vmovapd [r10 + T_AA], ymm0
    mov r2d, 0
    call .xmv
    mov r2d, 32
    call .xmv
    mov r2d, 64
    call .xmv
    mov r2d, 96
    call .xmv
    vmovapd ymm0, [r10 + T_ZB + 0]
    vaddpd ymm0, ymm0, [r10 + T_ZB + 192]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_AA + 0]
    vmovsd [r10 + T_AA + 0], xmm0
    vmovapd ymm0, [r10 + T_ZB + 32]
    vaddpd ymm0, ymm0, [r10 + T_ZB + 224]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_LA + 0]
    vmovsd [r10 + T_LA + 0], xmm0
    vmovapd ymm0, [r10 + T_ZB + 64]
    vaddpd ymm0, ymm0, [r10 + T_ZB + 256]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_AA + 8]
    vmovsd [r10 + T_AA + 8], xmm0
    vmovapd ymm0, [r10 + T_ZB + 96]
    vaddpd ymm0, ymm0, [r10 + T_ZB + 288]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_LA + 8]
    vmovsd [r10 + T_LA + 8], xmm0
    vmovapd ymm0, [r10 + T_ZB + 128]
    vaddpd ymm0, ymm0, [r10 + T_ZB + 320]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_AA + 16]
    vmovsd [r10 + T_AA + 16], xmm0
    vmovapd ymm0, [r10 + T_ZB + 160]
    vaddpd ymm0, ymm0, [r10 + T_ZB + 352]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_LA + 16]
    vmovsd [r10 + T_LA + 16], xmm0
    vmovapd ymm0, [r10 + T_ZB + 384]
    vaddpd ymm0, ymm0, [r10 + T_ZB + 576]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_AA + 0]
    vmovsd [r10 + T_AA + 0], xmm0
    vmovapd ymm0, [r10 + T_ZB + 416]
    vaddpd ymm0, ymm0, [r10 + T_ZB + 608]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_LA + 0]
    vmovsd [r10 + T_LA + 0], xmm0
    vmovapd ymm0, [r10 + T_ZB + 448]
    vaddpd ymm0, ymm0, [r10 + T_ZB + 640]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_AA + 8]
    vmovsd [r10 + T_AA + 8], xmm0
    vmovapd ymm0, [r10 + T_ZB + 480]
    vaddpd ymm0, ymm0, [r10 + T_ZB + 672]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_LA + 8]
    vmovsd [r10 + T_LA + 8], xmm0
    vmovapd ymm0, [r10 + T_ZB + 512]
    vaddpd ymm0, ymm0, [r10 + T_ZB + 704]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_AA + 16]
    vmovsd [r10 + T_AA + 16], xmm0
    vmovapd ymm0, [r10 + T_ZB + 544]
    vaddpd ymm0, ymm0, [r10 + T_ZB + 736]
    vextractf128 xmm9, ymm0, 1
    vaddpd xmm0, xmm0, xmm9
    vpermilpd xmm9, xmm0, 1
    vaddsd xmm0, xmm0, xmm9
    vaddsd xmm0, xmm0, [r10 + T_LA + 16]
    vmovsd [r10 + T_LA + 16], xmm0
    vbroadcastsd ymm3, [d_q16]
    vmulpd ymm0, ymm3, [r10 + T_LA]
    vpbroadcastq ymm2, [d_abs]
    vandpd ymm2, ymm2, ymm0
    vmovapd ymm1, [r10 + T_AA]
    vfmsub132pd ymm1, ymm2, ymm3
    vbroadcastsd ymm2, [d_rg2]
    vbroadcastsd ymm3, [d_tab2]
    vfmadd213pd ymm1, ymm2, ymm3
    vpcmpeqd ymm3, ymm3, ymm3
    vmovapd [r10 + T_QF], ymm3
    call .ivq
    vmovapd [r10 + T_LO], ymm0
    vmovapd [r10 + T_HI], ymm1
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
.p2l:
    vpxor xmm13, xmm13, xmm13
    vmovdqa xmm14, [r10 + T_IX]
    lea r6, [r8 + r7]
    vpcmpeqd xmm15, xmm15, xmm15
    vpgatherdd xmm0, [r6 + xmm14*2], xmm15
    vpblendw xmm0, xmm0, xmm13, 0xaa
    vcvtdq2ps xmm0, xmm0
    lea r6, [r8]
    vpcmpeqd xmm15, xmm15, xmm15
    vpgatherdd xmm1, [r6 + xmm14*2], xmm15
    vpblendw xmm1, xmm1, xmm13, 0xaa
    vcvtdq2ps xmm1, xmm1
    lea r6, [r8 + CST]
    vpcmpeqd xmm15, xmm15, xmm15
    vpgatherdd xmm2, [r6 + xmm14*2], xmm15
    vpblendw xmm2, xmm2, xmm13, 0xaa
    vcvtdq2ps xmm2, xmm2
    lea r6, [r8 + 2*CST]
    vpcmpeqd xmm15, xmm15, xmm15
    vpgatherdd xmm3, [r6 + xmm14*2], xmm15
    vpblendw xmm3, xmm3, xmm13, 0xaa
    vcvtdq2ps xmm3, xmm3
    vbroadcastss ymm12, [c_h0625]
    vbroadcastss ymm11, [c_h5625]
    vaddps xmm4, xmm1, xmm2
    vaddps xmm10, xmm0, xmm3
    vmulps xmm10, xmm10, xmm12
    vfmsub132ps xmm4, xmm10, xmm11
    vpermilps xmm5, xmm1, 0x39
    vpermilps xmm6, xmm1, 0x4e
    vpermilps xmm7, xmm1, 0x93
    vaddps xmm8, xmm5, xmm6
    vaddps xmm10, xmm1, xmm7
    vmulps xmm10, xmm10, xmm12
    vfmsub132ps xmm8, xmm10, xmm11
    vblendps xmm1, xmm1, xmm8, 1
    vpermilps xmm5, xmm4, 0x39
    vpermilps xmm6, xmm4, 0x4e
    vpermilps xmm7, xmm4, 0x93
    vaddps xmm8, xmm5, xmm6
    vaddps xmm10, xmm4, xmm7
    vmulps xmm10, xmm10, xmm12
    vfmsub132ps xmm8, xmm10, xmm11
    vblendps xmm4, xmm4, xmm8, 1
    vshufps xmm0, xmm1, xmm4, 0x11
    vcvtps2pd ymm0, xmm0
    vbroadcastsd ymm1, [d_512]
    vsubpd ymm0, ymm0, ymm1
    vmovapd [r1], ymm0
    ret
.p2c:
    vpxor xmm13, xmm13, xmm13
    vmovdqa ymm14, [r10 + T_IX]
    lea r6, [r8 + r7]
    vpcmpeqd ymm15, ymm15, ymm15
    vpgatherdd ymm0, [r6 + ymm14*2], ymm15
    vpblendw ymm0, ymm0, ymm13, 0xaa
    vcvtdq2ps ymm0, ymm0
    lea r6, [r8 + r3]
    vpcmpeqd ymm15, ymm15, ymm15
    vpgatherdd ymm1, [r6 + ymm14*2], ymm15
    vpblendw ymm1, ymm1, ymm13, 0xaa
    vcvtdq2ps ymm1, ymm1
    lea r6, [r8]
    vpcmpeqd ymm15, ymm15, ymm15
    vpgatherdd ymm2, [r6 + ymm14*2], ymm15
    vpblendw ymm2, ymm2, ymm13, 0xaa
    vcvtdq2ps ymm2, ymm2
    lea r6, [r8 + CST]
    vpcmpeqd ymm15, ymm15, ymm15
    vpgatherdd ymm3, [r6 + ymm14*2], ymm15
    vpblendw ymm3, ymm3, ymm13, 0xaa
    vcvtdq2ps ymm3, ymm3
    lea r6, [r8 + 2*CST]
    vpcmpeqd ymm15, ymm15, ymm15
    vpgatherdd ymm4, [r6 + ymm14*2], ymm15
    vpblendw ymm4, ymm4, ymm13, 0xaa
    vcvtdq2ps ymm4, ymm4
    vbroadcastss ymm12, [c_h0625]
    vbroadcastss ymm11, [c_h5625]
    vaddps ymm5, ymm1, ymm2
    vaddps ymm10, ymm0, ymm3
    vmulps ymm10, ymm10, ymm12
    vfmsub132ps ymm5, ymm10, ymm11
    vmovaps ymm6, [r10 + T_VM]
    vblendvps ymm5, ymm0, ymm5, ymm6
    vaddps ymm6, ymm2, ymm3
    vaddps ymm10, ymm1, ymm4
    vmulps ymm10, ymm10, ymm12
    vfmsub132ps ymm6, ymm10, ymm11
    vmovdqa ymm7, [d_pi1]
    vmovdqa ymm13, [d_po]
    vmovaps ymm14, [r10 + T_HM]
    vbroadcastsd ymm15, [d_512]
    vpermps ymm8, ymm7, ymm5
    vpermps ymm9, ymm7, ymm8
    vpermps ymm0, ymm7, ymm9
    vaddps ymm1, ymm8, ymm9
    vaddps ymm10, ymm5, ymm0
    vmulps ymm10, ymm10, ymm12
    vfmsub132ps ymm1, ymm10, ymm11
    vblendvps ymm5, ymm5, ymm1, ymm14
    vpermps ymm5, ymm13, ymm5
    vcvtps2pd ymm4, xmm5
    vsubpd ymm4, ymm4, ymm15
    vmovapd [r1 + 0], ymm4
    vpermps ymm8, ymm7, ymm2
    vpermps ymm9, ymm7, ymm8
    vpermps ymm0, ymm7, ymm9
    vaddps ymm1, ymm8, ymm9
    vaddps ymm10, ymm2, ymm0
    vmulps ymm10, ymm10, ymm12
    vfmsub132ps ymm1, ymm10, ymm11
    vblendvps ymm2, ymm2, ymm1, ymm14
    vpermps ymm2, ymm13, ymm2
    vcvtps2pd ymm4, xmm2
    vsubpd ymm4, ymm4, ymm15
    vmovapd [r1 + 32], ymm4
    vpermps ymm8, ymm7, ymm6
    vpermps ymm9, ymm7, ymm8
    vpermps ymm0, ymm7, ymm9
    vaddps ymm1, ymm8, ymm9
    vaddps ymm10, ymm6, ymm0
    vmulps ymm10, ymm10, ymm12
    vfmsub132ps ymm1, ymm10, ymm11
    vblendvps ymm6, ymm6, ymm1, ymm14
    vpermps ymm6, ymm13, ymm6
    vcvtps2pd ymm4, xmm6
    vsubpd ymm4, ymm4, ymm15
    vmovapd [r1 + 64], ymm4
    vpermps ymm8, ymm7, ymm3
    vpermps ymm9, ymm7, ymm8
    vpermps ymm0, ymm7, ymm9
    vaddps ymm1, ymm8, ymm9
    vaddps ymm10, ymm3, ymm0
    vmulps ymm10, ymm10, ymm12
    vfmsub132ps ymm1, ymm10, ymm11
    vblendvps ymm3, ymm3, ymm1, ymm14
    vpermps ymm3, ymm13, ymm3
    vcvtps2pd ymm4, xmm3
    vsubpd ymm4, ymm4, ymm15
    vmovapd [r1 + 96], ymm4
    ret
.xmv:
    vmovapd ymm0, [r10 + T_Y + r2]
    vbroadcastsd ymm1, [d_lzm0]
    vbroadcastsd ymm2, [d_lzm5]
    vfmadd213pd ymm0, ymm1, ymm2
    vmovapd ymm1, [r10 + T_R + r2]
    vmovapd ymm2, [r10 + T_B + r2]
    vbroadcastsd ymm3, [d_lzm1]
    vfmadd213pd ymm3, ymm1, ymm0
    vmovapd [r10 + T_XV], ymm3
    vbroadcastsd ymm3, [d_lzm2]
    vfmadd213pd ymm3, ymm1, ymm0
    vbroadcastsd ymm4, [d_lzm3]
    vfmadd213pd ymm4, ymm2, ymm3
    vmovapd [r10 + T_XV + 32], ymm4
    vbroadcastsd ymm3, [d_lzm4]
    vfmadd213pd ymm3, ymm2, ymm0
    vmovapd [r10 + T_XV + 64], ymm3
    imul r3d, r2d, 6
    lea r1, [r10 + T_ZB + r3]
    xor r3d, r3d
.xmc:
    vmovapd ymm0, [r10 + T_XV + r3]
    vpbroadcastq ymm15, [d_abs]
    vandpd ymm14, ymm0, ymm15
    vbroadcastsd ymm13, [d_one]
    vminpd ymm1, ymm13, ymm14
    vbroadcastsd ymm2, [d_zz]
    vmaxpd ymm1, ymm1, ymm2
    vpsrlq ymm2, ymm1, 52
    vpbroadcastq ymm3, [d_i16]
    vpand ymm3, ymm2, ymm3
    vpxor xmm4, xmm4, xmm4
    vpcmpeqq ymm3, ymm3, ymm4
    vpsrlq ymm4, ymm1, 48
    vpbroadcastq ymm12, [d_i15]
    vpand ymm2, ymm2, ymm12
    vpand ymm4, ymm4, ymm12
    lea r2, [d_t2l]
    vpcmpeqd ymm6, ymm6, ymm6
    vgatherqpd ymm5, [r2 + ymm2*8], ymm6
    vbroadcastsd ymm6, [d_t2k]
    vmulpd ymm6, ymm5, ymm6
    vblendvpd ymm5, ymm5, ymm6, ymm3
    lea r2, [d_w2x]
    vpcmpeqd ymm7, ymm7, ymm7
    vgatherqpd ymm6, [r2 + ymm4*8], ymm7
    vmulpd ymm5, ymm5, ymm6
    vpbroadcastq ymm6, [d_mant]
    vandpd ymm6, ymm6, ymm1
    vbroadcastsd ymm7, [d_one]
    vorpd ymm6, ymm6, ymm7
    vcmppd ymm7, ymm1, ymm1, 3
    vorpd ymm6, ymm6, ymm7
    lea r2, [d_rxl]
    vpcmpeqd ymm8, ymm8, ymm8
    vgatherqpd ymm7, [r2 + ymm4*8], ymm8
    vbroadcastsd ymm8, [d_laq]
    vfmsub213pd ymm6, ymm7, ymm8
    vbroadcastsd ymm7, [d_q2x4]
    vaddpd ymm7, ymm6, ymm7
    vbroadcastsd ymm8, [d_q2x3]
    vfmadd213pd ymm7, ymm6, ymm8
    vbroadcastsd ymm8, [d_q2x2]
    vfmadd213pd ymm7, ymm6, ymm8
    vbroadcastsd ymm8, [d_q2x1]
    vfmadd213pd ymm7, ymm6, ymm8
    vbroadcastsd ymm8, [d_q2x0]
    vfmadd213pd ymm7, ymm6, ymm8
    vmulpd ymm8, ymm5, ymm6
    vbroadcastsd ymm9, [d_c13]
    vsubpd ymm5, ymm5, ymm9
    vfnmadd231pd ymm5, ymm8, ymm7
    vbroadcastsd ymm9, [d_c2c]
    vsubpd ymm9, ymm9, ymm5
    vdivpd ymm5, ymm5, ymm9
    vpsrlq ymm2, ymm5, 52
    vpsrlq ymm4, ymm5, 48
    vpand ymm2, ymm2, ymm12
    vpand ymm4, ymm4, ymm12
    lea r2, [d_t1e]
    vpcmpeqd ymm7, ymm7, ymm7
    vgatherqpd ymm6, [r2 + ymm2*8], ymm7
    lea r2, [d_w1m]
    vpcmpeqd ymm8, ymm8, ymm8
    vgatherqpd ymm7, [r2 + ymm4*8], ymm8
    vmulpd ymm6, ymm6, ymm7
    vbroadcastsd ymm7, [d_flo]
    vcmppd ymm7, ymm5, ymm7, 0x1d
    vandpd ymm6, ymm7, ymm6
    vpbroadcastq ymm7, [d_mant]
    vandpd ymm7, ymm7, ymm5
    vbroadcastsd ymm8, [d_one]
    vorpd ymm7, ymm7, ymm8
    vcmppd ymm8, ymm5, ymm5, 3
    vorpd ymm7, ymm7, ymm8
    lea r2, [d_rx]
    vpcmpeqd ymm9, ymm9, ymm9
    vgatherqpd ymm8, [r2 + ymm4*8], ymm9
    vbroadcastsd ymm9, [d_one]
    vfmsub213pd ymm7, ymm8, ymm9
    vbroadcastsd ymm8, [d_p1m4]
    vaddpd ymm8, ymm7, ymm8
    vbroadcastsd ymm9, [d_p1m3]
    vfmadd213pd ymm8, ymm7, ymm9
    vbroadcastsd ymm9, [d_p1m2]
    vfmadd213pd ymm8, ymm7, ymm9
    vbroadcastsd ymm9, [d_p1m1]
    vfmadd213pd ymm8, ymm7, ymm9
    vbroadcastsd ymm9, [d_p1m0]
    vfmadd213pd ymm8, ymm7, ymm9
    vmaxpd ymm9, ymm13, ymm14
    vbroadcastsd ymm10, [d_pk]
    vfmsub213pd ymm9, ymm10, ymm10
    vfmadd213pd ymm6, ymm8, ymm9
    vandpd ymm1, ymm15, ymm6
    vandnpd ymm2, ymm15, ymm0
    vorpd ymm1, ymm1, ymm2
    vmovapd [r1 + r3*2], ymm6
    vmovapd [r1 + r3*2 + 32], ymm1
    add r3d, 32
    cmp r3d, 96
    jne .xmc
    ret
.t3l:
    xor r2d, r2d
    mov r3d, 32
    call .ecp
    xor r3d, r3d
.xbl:
    vmovapd ymm0, [r10 + T_EH + r3]
    vmovapd ymm1, [r10 + T_EL + r3]
    call .xeo
    vmovapd [r10 + T_EH + r3], ymm0
    vmovapd [r10 + T_EL + r3], ymm1
    add r3d, 32
    cmp r3d, 96
    jne .xbl
    mov r3d, 32
    lea r6, [d_q4]
    call .acc
    vxorpd xmm2, xmm2, xmm2
    vbroadcastsd ymm3, [d_ys]
    vmulpd ymm4, ymm3, ymm0
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm3, ymm0
    vmulpd ymm6, ymm2, ymm0
    vfmadd231pd ymm6, ymm3, ymm1
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm4, ymm5
    vsubpd ymm7, ymm6, ymm4
    vsubpd ymm7, ymm5, ymm7
    vbroadcastsd ymm3, [d_yb]
    vaddpd ymm5, ymm6, ymm3
    vsubpd ymm4, ymm5, ymm6
    vsubpd ymm8, ymm5, ymm4
    vsubpd ymm8, ymm6, ymm8
    vsubpd ymm4, ymm3, ymm4
    vaddpd ymm8, ymm8, ymm4
    vaddpd ymm4, ymm7, ymm2
    vsubpd ymm9, ymm4, ymm7
    vsubpd ymm10, ymm4, ymm9
    vsubpd ymm10, ymm7, ymm10
    vsubpd ymm9, ymm2, ymm9
    vaddpd ymm10, ymm10, ymm9
    vaddpd ymm9, ymm8, ymm4
    vaddpd ymm4, ymm5, ymm9
    vsubpd ymm8, ymm4, ymm5
    vsubpd ymm8, ymm9, ymm8
    vaddpd ymm9, ymm8, ymm10
    vaddpd ymm10, ymm4, ymm9
    vsubpd ymm8, ymm10, ymm4
    vsubpd ymm8, ymm9, ymm8
    vmovapd ymm0, ymm10
    vmovapd ymm1, ymm8
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
    mov r3d, 128
    mov r2d, 0
    call .ecp
    mov r2d, 32
    call .ecp
    mov r2d, 64
    call .ecp
    mov r2d, 96
    call .ecp
    xor r3d, r3d
.xbc:
    vmovapd ymm0, [r10 + T_EH + r3]
    vmovapd ymm1, [r10 + T_EL + r3]
    call .xeo
    vmovapd [r10 + T_EH + r3], ymm0
    vmovapd [r10 + T_EL + r3], ymm1
    add r3d, 32
    cmp r3d, 384
    jne .xbc
    mov r3d, 128
    lea r6, [d_q16]
    call .acc
    vxorpd xmm2, xmm2, xmm2
    vbroadcastsd ymm3, [d_sgn]
    vxorpd ymm3, ymm3, ymm0
    vbroadcastsd ymm4, [d_sgn]
    vxorpd ymm4, ymm4, ymm1
    vbroadcastsd ymm5, [r10 + T_EC + 16]
    vbroadcastsd ymm6, [r10 + T_EC + 32 + 16]
    vaddpd ymm7, ymm5, ymm3
    vsubpd ymm8, ymm7, ymm5
    vsubpd ymm9, ymm7, ymm8
    vsubpd ymm9, ymm5, ymm9
    vsubpd ymm8, ymm3, ymm8
    vaddpd ymm9, ymm9, ymm8
    vaddpd ymm8, ymm6, ymm4
    vsubpd ymm10, ymm8, ymm6
    vsubpd ymm11, ymm8, ymm10
    vsubpd ymm11, ymm6, ymm11
    vsubpd ymm10, ymm4, ymm10
    vaddpd ymm11, ymm11, ymm10
    vaddpd ymm10, ymm9, ymm8
    vaddpd ymm8, ymm7, ymm10
    vsubpd ymm9, ymm8, ymm7
    vsubpd ymm9, ymm10, ymm9
    vaddpd ymm10, ymm9, ymm11
    vaddpd ymm11, ymm8, ymm10
    vsubpd ymm9, ymm11, ymm8
    vsubpd ymm9, ymm10, ymm9
    vbroadcastsd ymm6, [d_cbs]
    vbroadcastsd ymm5, [d_cbs + 8]
    vmulpd ymm10, ymm6, ymm11
    vmovapd ymm8, ymm10
    vfmsub231pd ymm8, ymm6, ymm11
    vmulpd ymm7, ymm5, ymm11
    vfmadd231pd ymm7, ymm6, ymm9
    vaddpd ymm8, ymm8, ymm7
    vaddpd ymm7, ymm10, ymm8
    vsubpd ymm12, ymm7, ymm10
    vsubpd ymm12, ymm8, ymm12
    vbroadcastsd ymm9, [d_512]
    vaddpd ymm11, ymm7, ymm9
    vsubpd ymm5, ymm11, ymm7
    vsubpd ymm6, ymm11, ymm5
    vsubpd ymm6, ymm7, ymm6
    vsubpd ymm5, ymm9, ymm5
    vaddpd ymm6, ymm6, ymm5
    vaddpd ymm5, ymm12, ymm2
    vsubpd ymm8, ymm5, ymm12
    vsubpd ymm10, ymm5, ymm8
    vsubpd ymm10, ymm12, ymm10
    vsubpd ymm8, ymm2, ymm8
    vaddpd ymm10, ymm10, ymm8
    vaddpd ymm8, ymm6, ymm5
    vaddpd ymm5, ymm11, ymm8
    vsubpd ymm6, ymm5, ymm11
    vsubpd ymm6, ymm8, ymm6
    vaddpd ymm8, ymm6, ymm10
    vaddpd ymm10, ymm5, ymm8
    vsubpd ymm6, ymm10, ymm5
    vsubpd ymm6, ymm8, ymm6
    vmovapd [r10 + T_V + 0], ymm10
    vmovapd [r10 + T_V + 32], ymm6
    vbroadcastsd ymm6, [r10 + T_EC + 0]
    vbroadcastsd ymm10, [r10 + T_EC + 32 + 0]
    vaddpd ymm12, ymm6, ymm3
    vsubpd ymm7, ymm12, ymm6
    vsubpd ymm9, ymm12, ymm7
    vsubpd ymm9, ymm6, ymm9
    vsubpd ymm7, ymm3, ymm7
    vaddpd ymm9, ymm9, ymm7
    vaddpd ymm7, ymm10, ymm4
    vsubpd ymm8, ymm7, ymm10
    vsubpd ymm5, ymm7, ymm8
    vsubpd ymm5, ymm10, ymm5
    vsubpd ymm8, ymm4, ymm8
    vaddpd ymm5, ymm5, ymm8
    vaddpd ymm8, ymm9, ymm7
    vaddpd ymm7, ymm12, ymm8
    vsubpd ymm9, ymm7, ymm12
    vsubpd ymm9, ymm8, ymm9
    vaddpd ymm8, ymm9, ymm5
    vaddpd ymm5, ymm7, ymm8
    vsubpd ymm9, ymm5, ymm7
    vsubpd ymm9, ymm8, ymm9
    vbroadcastsd ymm10, [d_crs]
    vbroadcastsd ymm6, [d_crs + 8]
    vmulpd ymm8, ymm10, ymm5
    vmovapd ymm7, ymm8
    vfmsub231pd ymm7, ymm10, ymm5
    vmulpd ymm12, ymm6, ymm5
    vfmadd231pd ymm12, ymm10, ymm9
    vaddpd ymm7, ymm7, ymm12
    vaddpd ymm12, ymm8, ymm7
    vsubpd ymm11, ymm12, ymm8
    vsubpd ymm11, ymm7, ymm11
    vbroadcastsd ymm9, [d_512]
    vaddpd ymm5, ymm12, ymm9
    vsubpd ymm6, ymm5, ymm12
    vsubpd ymm10, ymm5, ymm6
    vsubpd ymm10, ymm12, ymm10
    vsubpd ymm6, ymm9, ymm6
    vaddpd ymm10, ymm10, ymm6
    vaddpd ymm6, ymm11, ymm2
    vsubpd ymm7, ymm6, ymm11
    vsubpd ymm8, ymm6, ymm7
    vsubpd ymm8, ymm11, ymm8
    vsubpd ymm7, ymm2, ymm7
    vaddpd ymm8, ymm8, ymm7
    vaddpd ymm7, ymm10, ymm6
    vaddpd ymm6, ymm5, ymm7
    vsubpd ymm10, ymm6, ymm5
    vsubpd ymm10, ymm7, ymm10
    vaddpd ymm7, ymm10, ymm8
    vaddpd ymm8, ymm6, ymm7
    vsubpd ymm10, ymm8, ymm6
    vsubpd ymm10, ymm7, ymm10
    vmovapd [r10 + T_V + 64], ymm8
    vmovapd [r10 + T_V + 96], ymm10
    vmovapd ymm0, [r10 + T_V + 0]
    vmovapd ymm1, [r10 + T_V + 32]
    call .rn2
    mov [r10 + T_O + 8], r2d
    mov [r10 + T_O + 16], r6d
    vmovapd ymm0, [r10 + T_V + 64]
    vmovapd ymm1, [r10 + T_V + 96]
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
    vxorpd xmm0, xmm0, xmm0
    vmovapd ymm1, [r7 + T_Y]
    vbroadcastsd ymm2, [d_ysc]
    vbroadcastsd ymm3, [d_ysc + 8]
    vmulpd ymm4, ymm1, ymm2
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm1, ymm2
    vmulpd ymm6, ymm0, ymm2
    vfmadd231pd ymm6, ymm1, ymm3
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm4, ymm5
    vsubpd ymm7, ymm6, ymm4
    vsubpd ymm7, ymm5, ymm7
    vbroadcastsd ymm3, [d_yof]
    vbroadcastsd ymm2, [d_yof + 8]
    vaddpd ymm1, ymm6, ymm3
    vsubpd ymm5, ymm1, ymm6
    vsubpd ymm4, ymm1, ymm5
    vsubpd ymm4, ymm6, ymm4
    vsubpd ymm5, ymm3, ymm5
    vaddpd ymm4, ymm4, ymm5
    vaddpd ymm5, ymm7, ymm2
    vsubpd ymm8, ymm5, ymm7
    vsubpd ymm9, ymm5, ymm8
    vsubpd ymm9, ymm7, ymm9
    vsubpd ymm8, ymm2, ymm8
    vaddpd ymm9, ymm9, ymm8
    vaddpd ymm8, ymm4, ymm5
    vaddpd ymm5, ymm1, ymm8
    vsubpd ymm4, ymm5, ymm1
    vsubpd ymm4, ymm8, ymm4
    vaddpd ymm8, ymm4, ymm9
    vaddpd ymm9, ymm5, ymm8
    vsubpd ymm4, ymm9, ymm5
    vsubpd ymm4, ymm8, ymm4
    vmovapd ymm2, [r7 + T_R]
    vmovapd ymm3, [r7 + T_B]
    vbroadcastsd ymm7, [d_rcr]
    vbroadcastsd ymm6, [d_rcr + 8]
    vmulpd ymm8, ymm7, ymm2
    vmovapd ymm5, ymm8
    vfmsub231pd ymm5, ymm7, ymm2
    vmulpd ymm1, ymm6, ymm2
    vfmadd231pd ymm1, ymm7, ymm0
    vaddpd ymm5, ymm5, ymm1
    vaddpd ymm1, ymm8, ymm5
    vsubpd ymm10, ymm1, ymm8
    vsubpd ymm10, ymm5, ymm10
    vaddpd ymm6, ymm9, ymm1
    vsubpd ymm7, ymm6, ymm9
    vsubpd ymm5, ymm6, ymm7
    vsubpd ymm5, ymm9, ymm5
    vsubpd ymm7, ymm1, ymm7
    vaddpd ymm5, ymm5, ymm7
    vaddpd ymm7, ymm4, ymm10
    vsubpd ymm8, ymm7, ymm4
    vsubpd ymm11, ymm7, ymm8
    vsubpd ymm11, ymm4, ymm11
    vsubpd ymm8, ymm10, ymm8
    vaddpd ymm11, ymm11, ymm8
    vaddpd ymm8, ymm5, ymm7
    vaddpd ymm7, ymm6, ymm8
    vsubpd ymm5, ymm7, ymm6
    vsubpd ymm5, ymm8, ymm5
    vaddpd ymm8, ymm5, ymm11
    vaddpd ymm11, ymm7, ymm8
    vsubpd ymm5, ymm11, ymm7
    vsubpd ymm5, ymm8, ymm5
    vmovapd [r7 + T_EH], ymm11
    vmovapd [r7 + T_EL], ymm5
    vbroadcastsd ymm10, [d_gcr]
    vbroadcastsd ymm1, [d_gcr + 8]
    vmulpd ymm5, ymm10, ymm2
    vmovapd ymm11, ymm5
    vfmsub231pd ymm11, ymm10, ymm2
    vmulpd ymm8, ymm1, ymm2
    vfmadd231pd ymm8, ymm10, ymm0
    vaddpd ymm11, ymm11, ymm8
    vaddpd ymm8, ymm5, ymm11
    vsubpd ymm7, ymm8, ymm5
    vsubpd ymm7, ymm11, ymm7
    vaddpd ymm1, ymm9, ymm8
    vsubpd ymm10, ymm1, ymm9
    vsubpd ymm11, ymm1, ymm10
    vsubpd ymm11, ymm9, ymm11
    vsubpd ymm10, ymm8, ymm10
    vaddpd ymm11, ymm11, ymm10
    vaddpd ymm10, ymm4, ymm7
    vsubpd ymm5, ymm10, ymm4
    vsubpd ymm6, ymm10, ymm5
    vsubpd ymm6, ymm4, ymm6
    vsubpd ymm5, ymm7, ymm5
    vaddpd ymm6, ymm6, ymm5
    vaddpd ymm5, ymm11, ymm10
    vaddpd ymm10, ymm1, ymm5
    vsubpd ymm11, ymm10, ymm1
    vsubpd ymm11, ymm5, ymm11
    vaddpd ymm5, ymm11, ymm6
    vaddpd ymm6, ymm10, ymm5
    vsubpd ymm11, ymm6, ymm10
    vsubpd ymm11, ymm5, ymm11
    vbroadcastsd ymm7, [d_gcb]
    vbroadcastsd ymm8, [d_gcb + 8]
    vmulpd ymm5, ymm7, ymm3
    vmovapd ymm10, ymm5
    vfmsub231pd ymm10, ymm7, ymm3
    vmulpd ymm1, ymm8, ymm3
    vfmadd231pd ymm1, ymm7, ymm0
    vaddpd ymm10, ymm10, ymm1
    vaddpd ymm1, ymm5, ymm10
    vsubpd ymm12, ymm1, ymm5
    vsubpd ymm12, ymm10, ymm12
    vaddpd ymm8, ymm6, ymm1
    vsubpd ymm7, ymm8, ymm6
    vsubpd ymm10, ymm8, ymm7
    vsubpd ymm10, ymm6, ymm10
    vsubpd ymm7, ymm1, ymm7
    vaddpd ymm10, ymm10, ymm7
    vaddpd ymm7, ymm11, ymm12
    vsubpd ymm5, ymm7, ymm11
    vsubpd ymm13, ymm7, ymm5
    vsubpd ymm13, ymm11, ymm13
    vsubpd ymm5, ymm12, ymm5
    vaddpd ymm13, ymm13, ymm5
    vaddpd ymm5, ymm10, ymm7
    vaddpd ymm7, ymm8, ymm5
    vsubpd ymm10, ymm7, ymm8
    vsubpd ymm10, ymm5, ymm10
    vaddpd ymm5, ymm10, ymm13
    vaddpd ymm13, ymm7, ymm5
    vsubpd ymm10, ymm13, ymm7
    vsubpd ymm10, ymm5, ymm10
    vmovapd [r7 + r3 + T_EH], ymm13
    vmovapd [r7 + r3 + T_EL], ymm10
    vbroadcastsd ymm11, [d_bcb]
    vbroadcastsd ymm6, [d_bcb + 8]
    vmulpd ymm12, ymm11, ymm3
    vmovapd ymm1, ymm12
    vfmsub231pd ymm1, ymm11, ymm3
    vmulpd ymm10, ymm6, ymm3
    vfmadd231pd ymm10, ymm11, ymm0
    vaddpd ymm1, ymm1, ymm10
    vaddpd ymm10, ymm12, ymm1
    vsubpd ymm13, ymm10, ymm12
    vsubpd ymm13, ymm1, ymm13
    vaddpd ymm6, ymm9, ymm10
    vsubpd ymm11, ymm6, ymm9
    vsubpd ymm1, ymm6, ymm11
    vsubpd ymm1, ymm9, ymm1
    vsubpd ymm11, ymm10, ymm11
    vaddpd ymm1, ymm1, ymm11
    vaddpd ymm11, ymm4, ymm13
    vsubpd ymm12, ymm11, ymm4
    vsubpd ymm5, ymm11, ymm12
    vsubpd ymm5, ymm4, ymm5
    vsubpd ymm12, ymm13, ymm12
    vaddpd ymm5, ymm5, ymm12
    vaddpd ymm12, ymm1, ymm11
    vaddpd ymm11, ymm6, ymm12
    vsubpd ymm1, ymm11, ymm6
    vsubpd ymm1, ymm12, ymm1
    vaddpd ymm12, ymm1, ymm5
    vaddpd ymm5, ymm11, ymm12
    vsubpd ymm1, ymm5, ymm11
    vsubpd ymm1, ymm12, ymm1
    vmovapd [r7 + r3*2 + T_EH], ymm5
    vmovapd [r7 + r3*2 + T_EL], ymm1
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
    vmovsd [r10 + T_AC + 32 + 0], xmm1
    vmovsd [r10 + T_AC + 8], xmm2
    vmovsd [r10 + T_AC + 32 + 8], xmm3
    vmovsd [r10 + T_AC + 16], xmm4
    vmovsd [r10 + T_AC + 32 + 16], xmm5
    vxorpd xmm2, xmm2, xmm2
    vmovapd ymm3, [r10 + T_AC]
    vmovapd ymm4, [r10 + T_AC + 32]
    vbroadcastsd ymm5, [r6]
    vmulpd ymm6, ymm3, ymm5
    vmovapd ymm7, ymm6
    vfmsub231pd ymm7, ymm3, ymm5
    vmulpd ymm8, ymm4, ymm5
    vfmadd231pd ymm8, ymm3, ymm2
    vaddpd ymm7, ymm7, ymm8
    vaddpd ymm8, ymm6, ymm7
    vsubpd ymm9, ymm8, ymm6
    vsubpd ymm9, ymm7, ymm9
    vmovapd ymm0, ymm8
    vmovapd ymm1, ymm9
    call .xoe
    vmovapd [r10 + T_EC], ymm0
    vmovapd [r10 + T_EC + 32], ymm1
    vbroadcastsd ymm2, [r10 + T_EC + 0]
    vbroadcastsd ymm3, [r10 + T_EC + 32 + 0]
    vbroadcastsd ymm4, [d_kr]
    vbroadcastsd ymm5, [d_kr + 8]
    vmulpd ymm6, ymm4, ymm2
    vmovapd ymm7, ymm6
    vfmsub231pd ymm7, ymm4, ymm2
    vmulpd ymm8, ymm5, ymm2
    vfmadd231pd ymm8, ymm4, ymm3
    vaddpd ymm7, ymm7, ymm8
    vaddpd ymm8, ymm6, ymm7
    vsubpd ymm9, ymm8, ymm6
    vsubpd ymm9, ymm7, ymm9
    vbroadcastsd ymm3, [r10 + T_EC + 8]
    vbroadcastsd ymm2, [r10 + T_EC + 32 + 8]
    vbroadcastsd ymm5, [d_kg]
    vbroadcastsd ymm4, [d_kg + 8]
    vmulpd ymm7, ymm5, ymm3
    vmovapd ymm6, ymm7
    vfmsub231pd ymm6, ymm5, ymm3
    vmulpd ymm10, ymm4, ymm3
    vfmadd231pd ymm10, ymm5, ymm2
    vaddpd ymm6, ymm6, ymm10
    vaddpd ymm10, ymm7, ymm6
    vsubpd ymm11, ymm10, ymm7
    vsubpd ymm11, ymm6, ymm11
    vaddpd ymm2, ymm8, ymm10
    vsubpd ymm3, ymm2, ymm8
    vsubpd ymm4, ymm2, ymm3
    vsubpd ymm4, ymm8, ymm4
    vsubpd ymm3, ymm10, ymm3
    vaddpd ymm4, ymm4, ymm3
    vaddpd ymm3, ymm9, ymm11
    vsubpd ymm5, ymm3, ymm9
    vsubpd ymm6, ymm3, ymm5
    vsubpd ymm6, ymm9, ymm6
    vsubpd ymm5, ymm11, ymm5
    vaddpd ymm6, ymm6, ymm5
    vaddpd ymm5, ymm4, ymm3
    vaddpd ymm3, ymm2, ymm5
    vsubpd ymm4, ymm3, ymm2
    vsubpd ymm4, ymm5, ymm4
    vaddpd ymm5, ymm4, ymm6
    vaddpd ymm6, ymm3, ymm5
    vsubpd ymm4, ymm6, ymm3
    vsubpd ymm4, ymm5, ymm4
    vbroadcastsd ymm11, [r10 + T_EC + 16]
    vbroadcastsd ymm10, [r10 + T_EC + 32 + 16]
    vbroadcastsd ymm9, [d_kb]
    vbroadcastsd ymm8, [d_kb + 8]
    vmulpd ymm5, ymm9, ymm11
    vmovapd ymm3, ymm5
    vfmsub231pd ymm3, ymm9, ymm11
    vmulpd ymm2, ymm8, ymm11
    vfmadd231pd ymm2, ymm9, ymm10
    vaddpd ymm3, ymm3, ymm2
    vaddpd ymm2, ymm5, ymm3
    vsubpd ymm7, ymm2, ymm5
    vsubpd ymm7, ymm3, ymm7
    vaddpd ymm10, ymm6, ymm2
    vsubpd ymm11, ymm10, ymm6
    vsubpd ymm8, ymm10, ymm11
    vsubpd ymm8, ymm6, ymm8
    vsubpd ymm11, ymm2, ymm11
    vaddpd ymm8, ymm8, ymm11
    vaddpd ymm11, ymm4, ymm7
    vsubpd ymm9, ymm11, ymm4
    vsubpd ymm3, ymm11, ymm9
    vsubpd ymm3, ymm4, ymm3
    vsubpd ymm9, ymm7, ymm9
    vaddpd ymm3, ymm3, ymm9
    vaddpd ymm9, ymm8, ymm11
    vaddpd ymm11, ymm10, ymm9
    vsubpd ymm8, ymm11, ymm10
    vsubpd ymm8, ymm9, ymm8
    vaddpd ymm9, ymm8, ymm3
    vaddpd ymm3, ymm11, ymm9
    vsubpd ymm8, ymm3, ymm11
    vsubpd ymm8, ymm9, ymm8
    vmovapd ymm0, ymm3
    vmovapd ymm1, ymm8
    ret
.rn2:
    vxorpd xmm2, xmm2, xmm2
    vroundpd ymm3, ymm0, 8
    vsubpd ymm4, ymm0, ymm3
    vaddpd ymm5, ymm4, ymm1
    vsubpd ymm6, ymm5, ymm4
    vsubpd ymm7, ymm5, ymm6
    vsubpd ymm7, ymm4, ymm7
    vsubpd ymm6, ymm1, ymm6
    vaddpd ymm7, ymm7, ymm6
    vaddpd ymm6, ymm2, ymm2
    vsubpd ymm8, ymm6, ymm2
    vsubpd ymm9, ymm6, ymm8
    vsubpd ymm9, ymm2, ymm9
    vsubpd ymm8, ymm2, ymm8
    vaddpd ymm9, ymm9, ymm8
    vaddpd ymm8, ymm7, ymm6
    vaddpd ymm6, ymm5, ymm8
    vsubpd ymm7, ymm6, ymm5
    vsubpd ymm7, ymm8, ymm7
    vaddpd ymm8, ymm7, ymm9
    vaddpd ymm9, ymm6, ymm8
    vsubpd ymm7, ymm9, ymm6
    vsubpd ymm7, ymm8, ymm7
    vbroadcastsd ymm7, [d_half]
    vbroadcastsd ymm8, [d_one]
    vcmppd ymm4, ymm9, ymm7, 0x1e
    vaddpd ymm6, ymm3, ymm8
    vblendvpd ymm3, ymm3, ymm6, ymm4
    vbroadcastsd ymm5, [d_mhalf]
    vcmppd ymm4, ymm9, ymm5, 0x11
    vsubpd ymm6, ymm3, ymm8
    vblendvpd ymm3, ymm3, ymm6, ymm4
    vpbroadcastq ymm5, [d_abs]
    vandpd ymm9, ymm9, ymm5
    vsubpd ymm9, ymm9, ymm7
    vandpd ymm9, ymm9, ymm5
    vbroadcastsd ymm6, [d_epd]
    vcmppd ymm4, ymm9, ymm6, 0x1e
    vmaxpd ymm3, ymm3, ymm2
    vbroadcastsd ymm6, [d_1023]
    vminpd ymm3, ymm3, ymm6
    vcvttpd2dq xmm3, ymm3
    vmovd r2d, xmm3
    vmovmskpd r6d, ymm4
    ret
.xr:
    vpxor xmm0, xmm0, xmm0
    vmovdqa [r10 + T_ZS], ymm0
    vmovdqa [r10 + T_XS], ymm0
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
    vpbroadcastq ymm1, [d_lof]
    vpaddq ymm1, ymm0, ymm1
    vpsrlq ymm2, ymm1, 44
    vpbroadcastq ymm3, [d_lfe]
    vpand ymm2, ymm2, ymm3
    vpsrad ymm3, ymm1, 20
    vextracti128 xmm4, ymm3, 1
    vshufps xmm3, xmm3, xmm4, 0xdd
    vcvtdq2pd ymm3, xmm3
    vpbroadcastq ymm4, [d_lhm]
    vpand ymm1, ymm1, ymm4
    vpsubq ymm1, ymm0, ymm1
    lea r6, [d_lgt]
    vpcmpeqd ymm4, ymm4, ymm4
    vgatherqpd ymm5, [r6 + ymm2*8], ymm4
    vpcmpeqd ymm4, ymm4, ymm4
    vgatherqpd ymm6, [r6 + ymm2*8 + 8], ymm4
    vbroadcastsd ymm7, [d_lg0]
    vfmadd213pd ymm7, ymm3, ymm6
    vbroadcastsd ymm8, [d_mone]
    vfmadd231pd ymm8, ymm1, ymm5
    vbroadcastsd ymm9, [d_lg4]
    vbroadcastsd ymm2, [d_lg3]
    vfmadd213pd ymm9, ymm8, ymm2
    vaddpd ymm10, ymm8, ymm7
    vmulpd ymm11, ymm8, ymm8
    vsubpd ymm7, ymm7, ymm10
    vaddpd ymm7, ymm7, ymm8
    vbroadcastsd ymm2, [d_lg1]
    vfmadd132pd ymm3, ymm7, ymm2
    vmulpd ymm12, ymm8, ymm11
    vbroadcastsd ymm13, [d_lg6]
    vbroadcastsd ymm2, [d_lg5]
    vfmadd213pd ymm13, ymm8, ymm2
    vbroadcastsd ymm2, [d_lg2]
    vfmadd231pd ymm3, ymm11, ymm2
    vfmadd213pd ymm13, ymm11, ymm9
    vfmadd231pd ymm3, ymm12, ymm13
    vaddpd ymm3, ymm3, ymm10
    vbroadcastsd ymm1, [d_one]
    vsubpd ymm1, ymm0, ymm1
    vbroadcastsd ymm2, [d_lg9]
    vbroadcastsd ymm4, [d_lg8]
    vfmadd213pd ymm2, ymm1, ymm4
    vbroadcastsd ymm4, [d_lg15]
    vbroadcastsd ymm5, [d_lg14]
    vfmadd213pd ymm4, ymm1, ymm5
    vbroadcastsd ymm5, [d_lg12]
    vbroadcastsd ymm6, [d_lg11]
    vfmadd213pd ymm5, ymm1, ymm6
    vmulpd ymm6, ymm1, ymm1
    vbroadcastsd ymm7, [d_lg10]
    vfmadd231pd ymm2, ymm6, ymm7
    vbroadcastsd ymm7, [d_lg13]
    vfmadd231pd ymm5, ymm6, ymm7
    vmulpd ymm7, ymm1, ymm6
    vbroadcastsd ymm8, [d_lg16]
    vfmadd231pd ymm4, ymm6, ymm8
    vbroadcastsd ymm8, [d_lg17]
    vfmadd231pd ymm4, ymm7, ymm8
    vfmadd213pd ymm4, ymm7, ymm5
    vfmadd213pd ymm4, ymm7, ymm2
    vbroadcastsd ymm8, [d_2p27]
    vmovapd ymm9, ymm1
    vfmadd132pd ymm9, ymm1, ymm8
    vfnmadd231pd ymm9, ymm1, ymm8
    vmulpd ymm10, ymm9, ymm9
    vsubpd ymm11, ymm1, ymm9
    vbroadcastsd ymm12, [d_lg7]
    vmovapd ymm13, ymm1
    vfmadd231pd ymm13, ymm10, ymm12
    vsubpd ymm14, ymm1, ymm13
    vaddpd ymm15, ymm1, ymm9
    vfmadd132pd ymm10, ymm14, ymm12
    vmulpd ymm11, ymm11, ymm12
    vfmadd213pd ymm11, ymm15, ymm10
    vfmadd213pd ymm4, ymm7, ymm11
    vaddpd ymm13, ymm13, ymm4
    vpbroadcastq ymm1, [d_lmx]
    vpaddq ymm1, ymm0, ymm1
    vpbroadcastq ymm2, [d_lhx]
    vpcmpgtq ymm1, ymm2, ymm1
    vblendvpd ymm0, ymm3, ymm13, ymm1
    ret
.dexp:
    vbroadcastsd ymm2, [d_ln2]
    vdivpd ymm3, ymm0, ymm2
    vbroadcastsd ymm2, [d_sgn]
    vbroadcastsd ymm4, [d_hm]
    vandpd ymm2, ymm2, ymm3
    vorpd ymm2, ymm2, ymm4
    vaddpd ymm2, ymm2, ymm3
    vroundpd ymm2, ymm2, 11
    vxorpd xmm4, xmm4, xmm4
    vbroadcastsd ymm3, [d_ln2]
    vbroadcastsd ymm5, [d_ln2 + 8]
    vmulpd ymm6, ymm3, ymm2
    vmovapd ymm7, ymm6
    vfmsub231pd ymm7, ymm3, ymm2
    vmulpd ymm8, ymm5, ymm2
    vfmadd231pd ymm8, ymm3, ymm4
    vaddpd ymm7, ymm7, ymm8
    vaddpd ymm8, ymm6, ymm7
    vsubpd ymm9, ymm8, ymm6
    vsubpd ymm9, ymm7, ymm9
    vbroadcastsd ymm5, [d_sgn]
    vxorpd ymm5, ymm5, ymm8
    vbroadcastsd ymm3, [d_sgn]
    vxorpd ymm3, ymm3, ymm9
    vaddpd ymm9, ymm0, ymm5
    vsubpd ymm8, ymm9, ymm0
    vsubpd ymm7, ymm9, ymm8
    vsubpd ymm7, ymm0, ymm7
    vsubpd ymm8, ymm5, ymm8
    vaddpd ymm7, ymm7, ymm8
    vaddpd ymm8, ymm1, ymm3
    vsubpd ymm6, ymm8, ymm1
    vsubpd ymm10, ymm8, ymm6
    vsubpd ymm10, ymm1, ymm10
    vsubpd ymm6, ymm3, ymm6
    vaddpd ymm10, ymm10, ymm6
    vaddpd ymm6, ymm7, ymm8
    vaddpd ymm8, ymm9, ymm6
    vsubpd ymm7, ymm8, ymm9
    vsubpd ymm7, ymm6, ymm7
    vaddpd ymm6, ymm7, ymm10
    vaddpd ymm10, ymm8, ymm6
    vsubpd ymm7, ymm10, ymm8
    vsubpd ymm7, ymm6, ymm7
    vbroadcastsd ymm3, [d_i1024]
    vmulpd ymm5, ymm10, ymm3
    vmovapd ymm6, ymm5
    vfmsub231pd ymm6, ymm10, ymm3
    vmulpd ymm8, ymm7, ymm3
    vfmadd231pd ymm8, ymm10, ymm4
    vaddpd ymm6, ymm6, ymm8
    vaddpd ymm8, ymm5, ymm6
    vsubpd ymm9, ymm8, ymm5
    vsubpd ymm9, ymm6, ymm9
    vcvttpd2dq xmm2, ymm2
    vpmovsxdq ymm2, xmm2
    vpbroadcastq ymm7, [d_q1023]
    vpaddq ymm2, ymm2, ymm7
    vpsllq ymm2, ymm2, 52
    vmovapd [r10 + T_EXK], ymm2
    vmovapd [r10 + T_EXR], ymm8
    vmovapd [r10 + T_EXR + 32], ymm9
    vbroadcastsd ymm0, [d_ex + 128]
    vbroadcastsd ymm1, [d_ex + 136]
    mov r6d, 7*16
.dexh:
    vmovapd ymm4, [r10 + T_EXR]
    vmovapd ymm9, [r10 + T_EXR + 32]
    vmulpd ymm8, ymm0, ymm4
    vmovapd ymm2, ymm8
    vfmsub231pd ymm2, ymm0, ymm4
    vmulpd ymm7, ymm1, ymm4
    vfmadd231pd ymm7, ymm0, ymm9
    vaddpd ymm2, ymm2, ymm7
    vaddpd ymm7, ymm8, ymm2
    vsubpd ymm10, ymm7, ymm8
    vsubpd ymm10, ymm2, ymm10
    vbroadcastsd ymm9, [d_ex + r6]
    vbroadcastsd ymm4, [d_ex + r6 + 8]
    vaddpd ymm2, ymm7, ymm9
    vsubpd ymm8, ymm2, ymm7
    vsubpd ymm3, ymm2, ymm8
    vsubpd ymm3, ymm7, ymm3
    vsubpd ymm8, ymm9, ymm8
    vaddpd ymm3, ymm3, ymm8
    vaddpd ymm8, ymm10, ymm4
    vsubpd ymm6, ymm8, ymm10
    vsubpd ymm5, ymm8, ymm6
    vsubpd ymm5, ymm10, ymm5
    vsubpd ymm6, ymm4, ymm6
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm3, ymm8
    vaddpd ymm8, ymm2, ymm6
    vsubpd ymm3, ymm8, ymm2
    vsubpd ymm3, ymm6, ymm3
    vaddpd ymm6, ymm3, ymm5
    vaddpd ymm5, ymm8, ymm6
    vsubpd ymm3, ymm5, ymm8
    vsubpd ymm3, ymm6, ymm3
    vmovapd ymm0, ymm5
    vmovapd ymm1, ymm3
    sub r6d, 16
    jns .dexh
    mov r6d, 10
.dexq:
    vmulpd ymm3, ymm0, ymm0
    vmovapd ymm5, ymm3
    vfmsub231pd ymm5, ymm0, ymm0
    vmulpd ymm4, ymm1, ymm0
    vfmadd231pd ymm4, ymm0, ymm1
    vaddpd ymm5, ymm5, ymm4
    vaddpd ymm4, ymm3, ymm5
    vsubpd ymm9, ymm4, ymm3
    vsubpd ymm9, ymm5, ymm9
    vmovapd ymm0, ymm4
    vmovapd ymm1, ymm9
    dec r6d
    jnz .dexq
    vmulpd ymm0, ymm0, [r10 + T_EXK]
    vmulpd ymm1, ymm1, [r10 + T_EXK]
    ret
.dln:
    vmovapd [r10 + T_LN], ymm0
    vmovapd [r10 + T_LN + 32], ymm1
    call .lgv
    vmovapd [r10 + T_LN + 64], ymm0
    vbroadcastsd ymm1, [d_sgn]
    vxorpd ymm0, ymm0, ymm1
    vxorpd xmm1, xmm1, xmm1
    call .dexp
    vmovapd ymm2, [r10 + T_LN]
    vmovapd ymm3, [r10 + T_LN + 32]
    vmulpd ymm4, ymm2, ymm0
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm2, ymm0
    vmulpd ymm6, ymm3, ymm0
    vfmadd231pd ymm6, ymm2, ymm1
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm4, ymm5
    vsubpd ymm7, ymm6, ymm4
    vsubpd ymm7, ymm5, ymm7
    vbroadcastsd ymm3, [d_mone]
    vbroadcastsd ymm2, [d_mzero]
    vaddpd ymm5, ymm6, ymm3
    vsubpd ymm4, ymm5, ymm6
    vsubpd ymm8, ymm5, ymm4
    vsubpd ymm8, ymm6, ymm8
    vsubpd ymm4, ymm3, ymm4
    vaddpd ymm8, ymm8, ymm4
    vaddpd ymm4, ymm7, ymm2
    vsubpd ymm9, ymm4, ymm7
    vsubpd ymm10, ymm4, ymm9
    vsubpd ymm10, ymm7, ymm10
    vsubpd ymm9, ymm2, ymm9
    vaddpd ymm10, ymm10, ymm9
    vaddpd ymm9, ymm8, ymm4
    vaddpd ymm4, ymm5, ymm9
    vsubpd ymm8, ymm4, ymm5
    vsubpd ymm8, ymm9, ymm8
    vaddpd ymm9, ymm8, ymm10
    vaddpd ymm10, ymm4, ymm9
    vsubpd ymm8, ymm10, ymm4
    vsubpd ymm8, ymm9, ymm8
    vxorpd xmm7, xmm7, xmm7
    vmovapd ymm6, [r10 + T_LN + 64]
    vaddpd ymm2, ymm6, ymm10
    vsubpd ymm3, ymm2, ymm6
    vsubpd ymm9, ymm2, ymm3
    vsubpd ymm9, ymm6, ymm9
    vsubpd ymm3, ymm10, ymm3
    vaddpd ymm9, ymm9, ymm3
    vaddpd ymm3, ymm7, ymm8
    vsubpd ymm4, ymm3, ymm7
    vsubpd ymm5, ymm3, ymm4
    vsubpd ymm5, ymm7, ymm5
    vsubpd ymm4, ymm8, ymm4
    vaddpd ymm5, ymm5, ymm4
    vaddpd ymm4, ymm9, ymm3
    vaddpd ymm3, ymm2, ymm4
    vsubpd ymm9, ymm3, ymm2
    vsubpd ymm9, ymm4, ymm9
    vaddpd ymm4, ymm9, ymm5
    vaddpd ymm5, ymm3, ymm4
    vsubpd ymm9, ymm5, ymm3
    vsubpd ymm9, ymm4, ymm9
    vmovapd ymm0, ymm5
    vmovapd ymm1, ymm9
    ret
.xeo:
    vbroadcastsd ymm2, [d_one]
    vbroadcastsd ymm3, [d_mone]
    vblendvpd ymm3, ymm2, ymm3, ymm0
    vmovapd [r10 + T_XO], ymm3
    vmulpd ymm4, ymm0, ymm3
    vmulpd ymm5, ymm1, ymm3
    vxorpd xmm3, xmm3, xmm3
    vcmppd ymm6, ymm4, ymm3, 0x12
    vmovapd [r10 + T_XO + 32], ymm6
    vcmppd ymm6, ymm4, ymm2, 0x1e
    vblendvpd ymm7, ymm4, ymm2, ymm6
    vblendvpd ymm8, ymm5, ymm3, ymm6
    vbroadcastsd ymm6, [d_sgn]
    vxorpd ymm6, ymm6, ymm7
    vbroadcastsd ymm2, [d_sgn]
    vxorpd ymm2, ymm2, ymm8
    vaddpd ymm9, ymm4, ymm6
    vsubpd ymm10, ymm9, ymm4
    vsubpd ymm11, ymm9, ymm10
    vsubpd ymm11, ymm4, ymm11
    vsubpd ymm10, ymm6, ymm10
    vaddpd ymm11, ymm11, ymm10
    vaddpd ymm10, ymm5, ymm2
    vsubpd ymm12, ymm10, ymm5
    vsubpd ymm13, ymm10, ymm12
    vsubpd ymm13, ymm5, ymm13
    vsubpd ymm12, ymm2, ymm12
    vaddpd ymm13, ymm13, ymm12
    vaddpd ymm12, ymm11, ymm10
    vaddpd ymm10, ymm9, ymm12
    vsubpd ymm11, ymm10, ymm9
    vsubpd ymm11, ymm12, ymm11
    vaddpd ymm12, ymm11, ymm13
    vaddpd ymm13, ymm10, ymm12
    vsubpd ymm11, ymm13, ymm10
    vsubpd ymm11, ymm12, ymm11
    vmovapd [r10 + T_XO + 64], ymm13
    vmovapd [r10 + T_XO + 96], ymm11
    vmovapd ymm0, ymm7
    vmovapd ymm1, ymm8
    call .dln
    vbroadcastsd ymm2, [d_im2]
    vbroadcastsd ymm3, [d_im2 + 8]
    vmulpd ymm4, ymm2, ymm0
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm2, ymm0
    vmulpd ymm6, ymm3, ymm0
    vfmadd231pd ymm6, ymm2, ymm1
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm4, ymm5
    vsubpd ymm7, ymm6, ymm4
    vsubpd ymm7, ymm5, ymm7
    vmovapd ymm0, ymm6
    vmovapd ymm1, ymm7
    call .dexp
    vbroadcastsd ymm2, [d_mc1]
    vbroadcastsd ymm3, [d_mzero]
    vaddpd ymm4, ymm0, ymm2
    vsubpd ymm5, ymm4, ymm0
    vsubpd ymm6, ymm4, ymm5
    vsubpd ymm6, ymm0, ymm6
    vsubpd ymm5, ymm2, ymm5
    vaddpd ymm6, ymm6, ymm5
    vaddpd ymm5, ymm1, ymm3
    vsubpd ymm7, ymm5, ymm1
    vsubpd ymm8, ymm5, ymm7
    vsubpd ymm8, ymm1, ymm8
    vsubpd ymm7, ymm3, ymm7
    vaddpd ymm8, ymm8, ymm7
    vaddpd ymm7, ymm6, ymm5
    vaddpd ymm5, ymm4, ymm7
    vsubpd ymm6, ymm5, ymm4
    vsubpd ymm6, ymm7, ymm6
    vaddpd ymm7, ymm6, ymm8
    vaddpd ymm8, ymm5, ymm7
    vsubpd ymm6, ymm8, ymm5
    vsubpd ymm6, ymm7, ymm6
    vxorpd xmm3, xmm3, xmm3
    vcmppd ymm2, ymm8, ymm3, 0x1e
    vmovapd [r10 + T_XO + 128], ymm2
    vbroadcastsd ymm2, [d_c3]
    vmulpd ymm7, ymm2, ymm0
    vmovapd ymm5, ymm7
    vfmsub231pd ymm5, ymm2, ymm0
    vmulpd ymm4, ymm3, ymm0
    vfmadd231pd ymm4, ymm2, ymm1
    vaddpd ymm5, ymm5, ymm4
    vaddpd ymm4, ymm7, ymm5
    vsubpd ymm9, ymm4, ymm7
    vsubpd ymm9, ymm5, ymm9
    vbroadcastsd ymm2, [d_sgn]
    vxorpd ymm2, ymm2, ymm4
    vbroadcastsd ymm5, [d_sgn]
    vxorpd ymm5, ymm5, ymm9
    vbroadcastsd ymm9, [d_c2]
    vaddpd ymm4, ymm9, ymm2
    vsubpd ymm7, ymm4, ymm9
    vsubpd ymm10, ymm4, ymm7
    vsubpd ymm10, ymm9, ymm10
    vsubpd ymm7, ymm2, ymm7
    vaddpd ymm10, ymm10, ymm7
    vaddpd ymm7, ymm3, ymm5
    vsubpd ymm11, ymm7, ymm3
    vsubpd ymm12, ymm7, ymm11
    vsubpd ymm12, ymm3, ymm12
    vsubpd ymm11, ymm5, ymm11
    vaddpd ymm12, ymm12, ymm11
    vaddpd ymm11, ymm10, ymm7
    vaddpd ymm7, ymm4, ymm11
    vsubpd ymm10, ymm7, ymm4
    vsubpd ymm10, ymm11, ymm10
    vaddpd ymm11, ymm10, ymm12
    vaddpd ymm12, ymm7, ymm11
    vsubpd ymm10, ymm12, ymm7
    vsubpd ymm10, ymm11, ymm10
    vdivpd ymm5, ymm8, ymm12
    vbroadcastsd ymm2, [d_sgn]
    vxorpd ymm2, ymm2, ymm5
    vmulpd ymm9, ymm12, ymm2
    vmovapd ymm11, ymm9
    vfmsub231pd ymm11, ymm12, ymm2
    vmulpd ymm7, ymm10, ymm2
    vfmadd231pd ymm7, ymm12, ymm3
    vaddpd ymm11, ymm11, ymm7
    vaddpd ymm7, ymm9, ymm11
    vsubpd ymm4, ymm7, ymm9
    vsubpd ymm4, ymm11, ymm4
    vaddpd ymm2, ymm8, ymm7
    vsubpd ymm11, ymm2, ymm8
    vsubpd ymm9, ymm2, ymm11
    vsubpd ymm9, ymm8, ymm9
    vsubpd ymm11, ymm7, ymm11
    vaddpd ymm9, ymm9, ymm11
    vaddpd ymm11, ymm6, ymm4
    vsubpd ymm13, ymm11, ymm6
    vsubpd ymm14, ymm11, ymm13
    vsubpd ymm14, ymm6, ymm14
    vsubpd ymm13, ymm4, ymm13
    vaddpd ymm14, ymm14, ymm13
    vaddpd ymm13, ymm9, ymm11
    vaddpd ymm11, ymm2, ymm13
    vsubpd ymm9, ymm11, ymm2
    vsubpd ymm9, ymm13, ymm9
    vaddpd ymm13, ymm9, ymm14
    vaddpd ymm14, ymm11, ymm13
    vsubpd ymm9, ymm14, ymm11
    vsubpd ymm9, ymm13, ymm9
    vdivpd ymm6, ymm14, ymm12
    vbroadcastsd ymm8, [d_sgn]
    vxorpd ymm8, ymm8, ymm6
    vmulpd ymm4, ymm12, ymm8
    vmovapd ymm7, ymm4
    vfmsub231pd ymm7, ymm12, ymm8
    vmulpd ymm13, ymm10, ymm8
    vfmadd231pd ymm13, ymm12, ymm3
    vaddpd ymm7, ymm7, ymm13
    vaddpd ymm13, ymm4, ymm7
    vsubpd ymm11, ymm13, ymm4
    vsubpd ymm11, ymm7, ymm11
    vaddpd ymm8, ymm14, ymm13
    vsubpd ymm7, ymm8, ymm14
    vsubpd ymm4, ymm8, ymm7
    vsubpd ymm4, ymm14, ymm4
    vsubpd ymm7, ymm13, ymm7
    vaddpd ymm4, ymm4, ymm7
    vaddpd ymm7, ymm9, ymm11
    vsubpd ymm2, ymm7, ymm9
    vsubpd ymm15, ymm7, ymm2
    vsubpd ymm15, ymm9, ymm15
    vsubpd ymm2, ymm11, ymm2
    vaddpd ymm15, ymm15, ymm2
    vaddpd ymm2, ymm4, ymm7
    vaddpd ymm7, ymm8, ymm2
    vsubpd ymm4, ymm7, ymm8
    vsubpd ymm4, ymm2, ymm4
    vaddpd ymm2, ymm4, ymm15
    vaddpd ymm15, ymm7, ymm2
    vsubpd ymm4, ymm15, ymm7
    vsubpd ymm4, ymm2, ymm4
    vdivpd ymm9, ymm15, ymm12
    vaddpd ymm4, ymm5, ymm6
    vsubpd ymm15, ymm4, ymm5
    vsubpd ymm15, ymm6, ymm15
    vaddpd ymm6, ymm4, ymm9
    vsubpd ymm5, ymm6, ymm4
    vsubpd ymm14, ymm6, ymm5
    vsubpd ymm14, ymm4, ymm14
    vsubpd ymm5, ymm9, ymm5
    vaddpd ymm14, ymm14, ymm5
    vaddpd ymm5, ymm15, ymm3
    vsubpd ymm11, ymm5, ymm15
    vsubpd ymm13, ymm5, ymm11
    vsubpd ymm13, ymm15, ymm13
    vsubpd ymm11, ymm3, ymm11
    vaddpd ymm13, ymm13, ymm11
    vaddpd ymm11, ymm14, ymm5
    vaddpd ymm5, ymm6, ymm11
    vsubpd ymm14, ymm5, ymm6
    vsubpd ymm14, ymm11, ymm14
    vaddpd ymm11, ymm14, ymm13
    vaddpd ymm13, ymm5, ymm11
    vsubpd ymm14, ymm13, ymm5
    vsubpd ymm14, ymm11, ymm14
    vmovapd ymm0, ymm13
    vmovapd ymm1, ymm14
    call .dln
    vbroadcastsd ymm2, [d_im1]
    vbroadcastsd ymm3, [d_im1 + 8]
    vmulpd ymm4, ymm2, ymm0
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm2, ymm0
    vmulpd ymm6, ymm3, ymm0
    vfmadd231pd ymm6, ymm2, ymm1
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm4, ymm5
    vsubpd ymm7, ymm6, ymm4
    vsubpd ymm7, ymm5, ymm7
    vmovapd ymm0, ymm6
    vmovapd ymm1, ymm7
    call .dexp
    vandpd ymm0, ymm0, [r10 + T_XO + 128]
    vandpd ymm1, ymm1, [r10 + T_XO + 128]
    vbroadcastsd ymm2, [d_k12]
    vbroadcastsd ymm3, [d_k12 + 8]
    vmovapd ymm4, [r10 + T_XO + 64]
    vmovapd ymm5, [r10 + T_XO + 96]
    vmulpd ymm6, ymm2, ymm4
    vmovapd ymm7, ymm6
    vfmsub231pd ymm7, ymm2, ymm4
    vmulpd ymm8, ymm3, ymm4
    vfmadd231pd ymm8, ymm2, ymm5
    vaddpd ymm7, ymm7, ymm8
    vaddpd ymm8, ymm6, ymm7
    vsubpd ymm9, ymm8, ymm6
    vsubpd ymm9, ymm7, ymm9
    vaddpd ymm5, ymm0, ymm8
    vsubpd ymm4, ymm5, ymm0
    vsubpd ymm3, ymm5, ymm4
    vsubpd ymm3, ymm0, ymm3
    vsubpd ymm4, ymm8, ymm4
    vaddpd ymm3, ymm3, ymm4
    vaddpd ymm4, ymm1, ymm9
    vsubpd ymm2, ymm4, ymm1
    vsubpd ymm7, ymm4, ymm2
    vsubpd ymm7, ymm1, ymm7
    vsubpd ymm2, ymm9, ymm2
    vaddpd ymm7, ymm7, ymm2
    vaddpd ymm2, ymm3, ymm4
    vaddpd ymm4, ymm5, ymm2
    vsubpd ymm3, ymm4, ymm5
    vsubpd ymm3, ymm2, ymm3
    vaddpd ymm2, ymm3, ymm7
    vaddpd ymm7, ymm4, ymm2
    vsubpd ymm3, ymm7, ymm4
    vsubpd ymm3, ymm2, ymm3
    vmovapd ymm9, [r10 + T_XO + 32]
    vandnpd ymm7, ymm9, ymm7
    vandnpd ymm3, ymm9, ymm3
    vmulpd ymm0, ymm7, [r10 + T_XO]
    vmulpd ymm1, ymm3, [r10 + T_XO]
    ret
.xoe:
    vbroadcastsd ymm2, [d_one]
    vbroadcastsd ymm3, [d_mone]
    vblendvpd ymm3, ymm2, ymm3, ymm0
    vmovapd [r10 + T_XO], ymm3
    vmulpd ymm4, ymm0, ymm3
    vmulpd ymm5, ymm1, ymm3
    vxorpd xmm3, xmm3, xmm3
    vcmppd ymm6, ymm4, ymm3, 0x12
    vmovapd [r10 + T_XO + 32], ymm6
    vcmppd ymm6, ymm4, ymm2, 0x1e
    vmovapd [r10 + T_XO + 64], ymm6
    vmovapd [r10 + T_XO + 160], ymm4
    vmovapd [r10 + T_XO + 192], ymm5
    vbroadcastsd ymm6, [d_mone]
    vbroadcastsd ymm7, [d_mzero]
    vaddpd ymm8, ymm4, ymm6
    vsubpd ymm9, ymm8, ymm4
    vsubpd ymm10, ymm8, ymm9
    vsubpd ymm10, ymm4, ymm10
    vsubpd ymm9, ymm6, ymm9
    vaddpd ymm10, ymm10, ymm9
    vaddpd ymm9, ymm5, ymm7
    vsubpd ymm11, ymm9, ymm5
    vsubpd ymm12, ymm9, ymm11
    vsubpd ymm12, ymm5, ymm12
    vsubpd ymm11, ymm7, ymm11
    vaddpd ymm12, ymm12, ymm11
    vaddpd ymm11, ymm10, ymm9
    vaddpd ymm9, ymm8, ymm11
    vsubpd ymm10, ymm9, ymm8
    vsubpd ymm10, ymm11, ymm10
    vaddpd ymm11, ymm10, ymm12
    vaddpd ymm12, ymm9, ymm11
    vsubpd ymm10, ymm12, ymm9
    vsubpd ymm10, ymm11, ymm10
    vbroadcastsd ymm5, [d_m12d]
    vbroadcastsd ymm4, [d_m12d + 8]
    vmulpd ymm7, ymm12, ymm5
    vmovapd ymm6, ymm7
    vfmsub231pd ymm6, ymm12, ymm5
    vmulpd ymm11, ymm10, ymm5
    vfmadd231pd ymm11, ymm12, ymm4
    vaddpd ymm6, ymm6, ymm11
    vaddpd ymm11, ymm7, ymm6
    vsubpd ymm9, ymm11, ymm7
    vsubpd ymm9, ymm6, ymm9
    vbroadcastsd ymm2, [d_120]
    vdivpd ymm10, ymm11, ymm2
    vbroadcastsd ymm12, [d_sgn]
    vxorpd ymm12, ymm12, ymm10
    vmulpd ymm4, ymm2, ymm12
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm2, ymm12
    vmulpd ymm6, ymm3, ymm12
    vfmadd231pd ymm6, ymm2, ymm3
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm4, ymm5
    vsubpd ymm7, ymm6, ymm4
    vsubpd ymm7, ymm5, ymm7
    vaddpd ymm12, ymm11, ymm6
    vsubpd ymm5, ymm12, ymm11
    vsubpd ymm4, ymm12, ymm5
    vsubpd ymm4, ymm11, ymm4
    vsubpd ymm5, ymm6, ymm5
    vaddpd ymm4, ymm4, ymm5
    vaddpd ymm5, ymm9, ymm7
    vsubpd ymm8, ymm5, ymm9
    vsubpd ymm13, ymm5, ymm8
    vsubpd ymm13, ymm9, ymm13
    vsubpd ymm8, ymm7, ymm8
    vaddpd ymm13, ymm13, ymm8
    vaddpd ymm8, ymm4, ymm5
    vaddpd ymm5, ymm12, ymm8
    vsubpd ymm4, ymm5, ymm12
    vsubpd ymm4, ymm8, ymm4
    vaddpd ymm8, ymm4, ymm13
    vaddpd ymm13, ymm5, ymm8
    vsubpd ymm4, ymm13, ymm5
    vsubpd ymm4, ymm8, ymm4
    vdivpd ymm9, ymm13, ymm2
    vbroadcastsd ymm11, [d_sgn]
    vxorpd ymm11, ymm11, ymm9
    vmulpd ymm7, ymm2, ymm11
    vmovapd ymm6, ymm7
    vfmsub231pd ymm6, ymm2, ymm11
    vmulpd ymm8, ymm3, ymm11
    vfmadd231pd ymm8, ymm2, ymm3
    vaddpd ymm6, ymm6, ymm8
    vaddpd ymm8, ymm7, ymm6
    vsubpd ymm5, ymm8, ymm7
    vsubpd ymm5, ymm6, ymm5
    vaddpd ymm11, ymm13, ymm8
    vsubpd ymm6, ymm11, ymm13
    vsubpd ymm7, ymm11, ymm6
    vsubpd ymm7, ymm13, ymm7
    vsubpd ymm6, ymm8, ymm6
    vaddpd ymm7, ymm7, ymm6
    vaddpd ymm6, ymm4, ymm5
    vsubpd ymm12, ymm6, ymm4
    vsubpd ymm14, ymm6, ymm12
    vsubpd ymm14, ymm4, ymm14
    vsubpd ymm12, ymm5, ymm12
    vaddpd ymm14, ymm14, ymm12
    vaddpd ymm12, ymm7, ymm6
    vaddpd ymm6, ymm11, ymm12
    vsubpd ymm7, ymm6, ymm11
    vsubpd ymm7, ymm12, ymm7
    vaddpd ymm12, ymm7, ymm14
    vaddpd ymm14, ymm6, ymm12
    vsubpd ymm7, ymm14, ymm6
    vsubpd ymm7, ymm12, ymm7
    vdivpd ymm4, ymm14, ymm2
    vaddpd ymm7, ymm10, ymm9
    vsubpd ymm14, ymm7, ymm10
    vsubpd ymm14, ymm9, ymm14
    vaddpd ymm9, ymm7, ymm4
    vsubpd ymm10, ymm9, ymm7
    vsubpd ymm13, ymm9, ymm10
    vsubpd ymm13, ymm7, ymm13
    vsubpd ymm10, ymm4, ymm10
    vaddpd ymm13, ymm13, ymm10
    vaddpd ymm10, ymm14, ymm3
    vsubpd ymm5, ymm10, ymm14
    vsubpd ymm8, ymm10, ymm5
    vsubpd ymm8, ymm14, ymm8
    vsubpd ymm5, ymm3, ymm5
    vaddpd ymm8, ymm8, ymm5
    vaddpd ymm5, ymm13, ymm10
    vaddpd ymm10, ymm9, ymm5
    vsubpd ymm13, ymm10, ymm9
    vsubpd ymm13, ymm5, ymm13
    vaddpd ymm5, ymm13, ymm8
    vaddpd ymm8, ymm10, ymm5
    vsubpd ymm13, ymm8, ymm10
    vsubpd ymm13, ymm5, ymm13
    vbroadcastsd ymm2, [d_one]
    vaddpd ymm4, ymm2, ymm8
    vsubpd ymm14, ymm4, ymm2
    vsubpd ymm7, ymm4, ymm14
    vsubpd ymm7, ymm2, ymm7
    vsubpd ymm14, ymm8, ymm14
    vaddpd ymm7, ymm7, ymm14
    vaddpd ymm14, ymm3, ymm13
    vsubpd ymm5, ymm14, ymm3
    vsubpd ymm10, ymm14, ymm5
    vsubpd ymm10, ymm3, ymm10
    vsubpd ymm5, ymm13, ymm5
    vaddpd ymm10, ymm10, ymm5
    vaddpd ymm5, ymm7, ymm14
    vaddpd ymm14, ymm4, ymm5
    vsubpd ymm7, ymm14, ymm4
    vsubpd ymm7, ymm5, ymm7
    vaddpd ymm5, ymm7, ymm10
    vaddpd ymm10, ymm14, ymm5
    vsubpd ymm7, ymm10, ymm14
    vsubpd ymm7, ymm5, ymm7
    vmovapd [r10 + T_XO + 96], ymm10
    vmovapd [r10 + T_XO + 128], ymm7
    vmovapd ymm0, [r10 + T_XO + 160]
    vmovapd ymm1, [r10 + T_XO + 192]
    call .dln
    vbroadcastsd ymm2, [d_m1]
    vbroadcastsd ymm3, [d_zero]
    vmulpd ymm4, ymm2, ymm0
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm2, ymm0
    vmulpd ymm6, ymm3, ymm0
    vfmadd231pd ymm6, ymm2, ymm1
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm4, ymm5
    vsubpd ymm7, ymm6, ymm4
    vsubpd ymm7, ymm5, ymm7
    vmovapd ymm0, ymm6
    vmovapd ymm1, ymm7
    call .dexp
    vmovapd ymm2, [r10 + T_XO + 32]
    vandnpd ymm0, ymm2, ymm0
    vandnpd ymm1, ymm2, ymm1
    vxorpd xmm2, xmm2, xmm2
    vbroadcastsd ymm3, [d_c2]
    vmulpd ymm4, ymm3, ymm0
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm3, ymm0
    vmulpd ymm6, ymm2, ymm0
    vfmadd231pd ymm6, ymm3, ymm1
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm4, ymm5
    vsubpd ymm7, ymm6, ymm4
    vsubpd ymm7, ymm5, ymm7
    vbroadcastsd ymm3, [d_c1]
    vaddpd ymm5, ymm3, ymm6
    vsubpd ymm4, ymm5, ymm3
    vsubpd ymm8, ymm5, ymm4
    vsubpd ymm8, ymm3, ymm8
    vsubpd ymm4, ymm6, ymm4
    vaddpd ymm8, ymm8, ymm4
    vaddpd ymm4, ymm2, ymm7
    vsubpd ymm9, ymm4, ymm2
    vsubpd ymm10, ymm4, ymm9
    vsubpd ymm10, ymm2, ymm10
    vsubpd ymm9, ymm7, ymm9
    vaddpd ymm10, ymm10, ymm9
    vaddpd ymm9, ymm8, ymm4
    vaddpd ymm4, ymm5, ymm9
    vsubpd ymm8, ymm4, ymm5
    vsubpd ymm8, ymm9, ymm8
    vaddpd ymm9, ymm8, ymm10
    vaddpd ymm10, ymm4, ymm9
    vsubpd ymm8, ymm10, ymm4
    vsubpd ymm8, ymm9, ymm8
    vbroadcastsd ymm7, [d_c3]
    vmulpd ymm6, ymm7, ymm0
    vmovapd ymm3, ymm6
    vfmsub231pd ymm3, ymm7, ymm0
    vmulpd ymm9, ymm2, ymm0
    vfmadd231pd ymm9, ymm7, ymm1
    vaddpd ymm3, ymm3, ymm9
    vaddpd ymm9, ymm6, ymm3
    vsubpd ymm4, ymm9, ymm6
    vsubpd ymm4, ymm3, ymm4
    vbroadcastsd ymm7, [d_one]
    vaddpd ymm3, ymm7, ymm9
    vsubpd ymm6, ymm3, ymm7
    vsubpd ymm5, ymm3, ymm6
    vsubpd ymm5, ymm7, ymm5
    vsubpd ymm6, ymm9, ymm6
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm2, ymm4
    vsubpd ymm11, ymm6, ymm2
    vsubpd ymm12, ymm6, ymm11
    vsubpd ymm12, ymm2, ymm12
    vsubpd ymm11, ymm4, ymm11
    vaddpd ymm12, ymm12, ymm11
    vaddpd ymm11, ymm5, ymm6
    vaddpd ymm6, ymm3, ymm11
    vsubpd ymm5, ymm6, ymm3
    vsubpd ymm5, ymm11, ymm5
    vaddpd ymm11, ymm5, ymm12
    vaddpd ymm12, ymm6, ymm11
    vsubpd ymm5, ymm12, ymm6
    vsubpd ymm5, ymm11, ymm5
    vdivpd ymm7, ymm10, ymm12
    vbroadcastsd ymm4, [d_sgn]
    vxorpd ymm4, ymm4, ymm7
    vmulpd ymm9, ymm12, ymm4
    vmovapd ymm11, ymm9
    vfmsub231pd ymm11, ymm12, ymm4
    vmulpd ymm6, ymm5, ymm4
    vfmadd231pd ymm6, ymm12, ymm2
    vaddpd ymm11, ymm11, ymm6
    vaddpd ymm6, ymm9, ymm11
    vsubpd ymm3, ymm6, ymm9
    vsubpd ymm3, ymm11, ymm3
    vaddpd ymm4, ymm10, ymm6
    vsubpd ymm11, ymm4, ymm10
    vsubpd ymm9, ymm4, ymm11
    vsubpd ymm9, ymm10, ymm9
    vsubpd ymm11, ymm6, ymm11
    vaddpd ymm9, ymm9, ymm11
    vaddpd ymm11, ymm8, ymm3
    vsubpd ymm13, ymm11, ymm8
    vsubpd ymm14, ymm11, ymm13
    vsubpd ymm14, ymm8, ymm14
    vsubpd ymm13, ymm3, ymm13
    vaddpd ymm14, ymm14, ymm13
    vaddpd ymm13, ymm9, ymm11
    vaddpd ymm11, ymm4, ymm13
    vsubpd ymm9, ymm11, ymm4
    vsubpd ymm9, ymm13, ymm9
    vaddpd ymm13, ymm9, ymm14
    vaddpd ymm14, ymm11, ymm13
    vsubpd ymm9, ymm14, ymm11
    vsubpd ymm9, ymm13, ymm9
    vdivpd ymm8, ymm14, ymm12
    vbroadcastsd ymm10, [d_sgn]
    vxorpd ymm10, ymm10, ymm8
    vmulpd ymm3, ymm12, ymm10
    vmovapd ymm6, ymm3
    vfmsub231pd ymm6, ymm12, ymm10
    vmulpd ymm13, ymm5, ymm10
    vfmadd231pd ymm13, ymm12, ymm2
    vaddpd ymm6, ymm6, ymm13
    vaddpd ymm13, ymm3, ymm6
    vsubpd ymm11, ymm13, ymm3
    vsubpd ymm11, ymm6, ymm11
    vaddpd ymm10, ymm14, ymm13
    vsubpd ymm6, ymm10, ymm14
    vsubpd ymm3, ymm10, ymm6
    vsubpd ymm3, ymm14, ymm3
    vsubpd ymm6, ymm13, ymm6
    vaddpd ymm3, ymm3, ymm6
    vaddpd ymm6, ymm9, ymm11
    vsubpd ymm4, ymm6, ymm9
    vsubpd ymm15, ymm6, ymm4
    vsubpd ymm15, ymm9, ymm15
    vsubpd ymm4, ymm11, ymm4
    vaddpd ymm15, ymm15, ymm4
    vaddpd ymm4, ymm3, ymm6
    vaddpd ymm6, ymm10, ymm4
    vsubpd ymm3, ymm6, ymm10
    vsubpd ymm3, ymm4, ymm3
    vaddpd ymm4, ymm3, ymm15
    vaddpd ymm15, ymm6, ymm4
    vsubpd ymm3, ymm15, ymm6
    vsubpd ymm3, ymm4, ymm3
    vdivpd ymm9, ymm15, ymm12
    vaddpd ymm3, ymm7, ymm8
    vsubpd ymm15, ymm3, ymm7
    vsubpd ymm15, ymm8, ymm15
    vaddpd ymm8, ymm3, ymm9
    vsubpd ymm7, ymm8, ymm3
    vsubpd ymm14, ymm8, ymm7
    vsubpd ymm14, ymm3, ymm14
    vsubpd ymm7, ymm9, ymm7
    vaddpd ymm14, ymm14, ymm7
    vaddpd ymm7, ymm15, ymm2
    vsubpd ymm11, ymm7, ymm15
    vsubpd ymm13, ymm7, ymm11
    vsubpd ymm13, ymm15, ymm13
    vsubpd ymm11, ymm2, ymm11
    vaddpd ymm13, ymm13, ymm11
    vaddpd ymm11, ymm14, ymm7
    vaddpd ymm7, ymm8, ymm11
    vsubpd ymm14, ymm7, ymm8
    vsubpd ymm14, ymm11, ymm14
    vaddpd ymm11, ymm14, ymm13
    vaddpd ymm13, ymm7, ymm11
    vsubpd ymm14, ymm13, ymm7
    vsubpd ymm14, ymm11, ymm14
    vmovapd ymm0, ymm13
    vmovapd ymm1, ymm14
    call .dln
    vbroadcastsd ymm2, [d_m2]
    vbroadcastsd ymm3, [d_zero]
    vmulpd ymm4, ymm2, ymm0
    vmovapd ymm5, ymm4
    vfmsub231pd ymm5, ymm2, ymm0
    vmulpd ymm6, ymm3, ymm0
    vfmadd231pd ymm6, ymm2, ymm1
    vaddpd ymm5, ymm5, ymm6
    vaddpd ymm6, ymm4, ymm5
    vsubpd ymm7, ymm6, ymm4
    vsubpd ymm7, ymm5, ymm7
    vmovapd ymm0, ymm6
    vmovapd ymm1, ymm7
    call .dexp
    vmovapd ymm2, [r10 + T_XO + 64]
    vblendvpd ymm0, ymm0, [r10 + T_XO + 96], ymm2
    vblendvpd ymm1, ymm1, [r10 + T_XO + 128], ymm2
    vmulpd ymm0, ymm0, [r10 + T_XO]
    vmulpd ymm1, ymm1, [r10 + T_XO]
    ret

