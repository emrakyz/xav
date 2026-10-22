default rel
%include "g5o.inc"
%include "g5img.inc"
%define GDZ 1088
%define SGZ 507904
extern xav_gr
extern xav_amap
extern xav_g5l
extern xav_g5_0_2_1
extern xav_g5_0_3_1
extern xav_g5_0_3_2
extern xav_g5_0_4_2
extern xav_g5_0_5_2
extern xav_g5_0_5_3
extern xav_g5_0_6_3
extern xav_g5_0_7_3
extern xav_g5_0_7_4
extern xav_g5_0_8_4
extern xav_g5_0_9_4
extern xav_g5_0_9_5
extern xav_g5_0_10_5
extern xav_g5_0_11_5
extern xav_g5_0_11_6
extern xav_g5_0_12_6
extern xav_g5_0_13_6
extern xav_g5_0_13_7
extern xav_g5_0_14_7
extern xav_g5_0_15_7
extern xav_g5_0_15_8
extern xav_g5_0_16_8
extern xav_g5_2_2_1
extern xav_g5_2_3_1
global xav_g5i
section .rodata align=64
g5i_rkb: dd -2, -1, 0, 1, 0, 0, 0, 0, -1, 0, 1, 2, 0, 0, 0, 0
g5i_rkv: dd 0, 0, 0, 0, 0xbcc00000, 0x3e680000, 0x3f5e0000, 0xbd900000, 0, 0, 0, 0, 0xbd900000, 0x3f5e0000, 0x3e680000, 0xbcc00000
g5i_iota: dd 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
g5i_rgi: dd 4, 0, 1, 2, 16, 17, 18, 3, 5, 6, 19, 20, 21, 7, 0, 0
g5i_om: dd 0x34a3a5ba, 0x3483a5a5, 0x34c3a5cf, 0x34c3a5cf, 0x34a3a5ba, 0x34c3a5cf, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
g5i_rh: dq 0x3e91d70a580c9f4a, 0x3e9b70a42375da9b, 0x3e91d70a580c9f4a, 0x3e9b70a42375da9b, 0x3e91d70a580c9f4a, 0x3e9b70a42375da9b, 0x3e91d70a580c9f4a, 0x3e9b70a42375da9b
g5i_rn: dq 0x3ff0000000000000, 0x3ff0000000000000, 0x3fd0000000000000, 0x3fd0000000000000, 0, 0, 0, 0
g5i_f2e: dq 0x3ff0000000000000, 0x3ff0000000000000, 0x3ff0000000000000, 0x4000000a7c5ac472, 0x3ff0000000000000, 0x3ff0000000000000, 0x3ff0000000000000, 0x4000000a7c5ac472
g5i_x02: dd 0, 0, 0, 0, 2, 2, 2, 2
g5i_sgn: dd -1, 1, -1, 1
lnc: dq 0x3ff0000000000000, 0x3fd5555555555555, 0x3fc999999999999a, 0x3fc2492492492492, 0x3fbc71c71c71c71c, 0x3fb745d1745d1746, 0x3fb3b13b13b13b14, 0x3fb1111111111111, 0x3fae1e1e1e1e1e1e, 0x3faaf286bca1af28, 0x3fa8618618618618, 0x3fa642c8590b2164, 0x3fa47ae147ae147b, 0x3fa2f684bda12f68, 0x3fa1a7b9611a7b96, 0x3fa0842108421084, 0x3f9f07c1f07c1f08, 0x3f9d41d41d41d41d, 0x3f9bacf914c1bad0, 0x3f9a41a41a41a41a, 0x3f98f9c18f9c18fa
c_lsig: dq 0x3eec46e400000000
c_osig: dq 0x3ff41ac160000000
c_ln2: dq 0x3fe62e42fefa39ef
c_ln2l: dq 0x3c7abc9e3b39803f
c_c32: dq 0x3f34f8b588e368f1
c_e6: dq 0x3ff000010c6f7a0b
c_e5: dq 0x3ff0000a7c5ac472
c_one: dq 0x3ff0000000000000
c_mone: dq 0xbff0000000000000
c_mzr: dq 0x8000000000000000
c_half: dq 0x3fe0000000000000
c_k10: dq 0x3f50000000000000
c_p5h: dq 0x3fdaaaaaaaaaaaab
c_p5l: dq 0xbc75555555555555
c_u24: dq 0x3e70000000000000
c_abs: dq 0x7fffffffffffffff
g5i_rt:
    dq 0x404fffff792922a4, 0x40500000436b6eae, 0x407fffffefd79720, 0x407fffffe90dcfd6, 0x4080000008143470, 0x408000000b791815
    dd 0x3786d510, 0x37814176, 0x37b78fd4, 0
    times 320 db 0
    dq 0xbee93713eba54b1e, 0x3ee93713eba54b1e, 0x407ffffff888817d, 0x407ffffff368ba34, 0x4080000003bbbf41, 0x40800000064ba2e6
    dd 0x3749b4d8, 0x36eee7d6, 0x37497095, 0
    times 320 db 0
    dq 0xbee94a0fcf657fda, 0x3ee94a0fcf657fda, 0x407ffffff882e273, 0x407ffffff35f3f79, 0x4080000003be8ec7, 0x4080000006506044
    dd 0x374a4cb8, 0x36ef9bb8, 0x374a0841, 0
    times 320 db 0
g5i_one: dd 1
g5i_c15: dd 15
g5i_c31: dd 31
g5i_c7: dd 7
g5i_f16: dd 0x41800000
align 16
g5kp:
    dq xav_g5_2_2_1
    dw 288, 320
    db 2, 1, 2, 32
    dq xav_g5_2_2_1
    dw 400, 432
    db 2, 1, 2, 40
    dq xav_g5_2_3_1
    dw 352, 384
    db 2, 1, 3, 32
    dq xav_g5_2_2_1
    dw 384, 416
    db 2, 1, 2, 32
    dq xav_g5_2_3_1
    dw 416, 448
    db 2, 1, 3, 32
    dq xav_g5_2_3_1
    dw 336, 368
    db 2, 1, 3, 24
    dq xav_g5_2_3_1
    dw 480, 512
    db 2, 1, 3, 32
    dq 0, 0
    dq xav_g5_0_2_1
    dw 272, 304
    db 2, 1, 2, 16
    dq xav_g5_0_2_1
    dw 432, 464
    db 2, 1, 2, 24
    dq xav_g5_0_3_1
    dw 304, 336
    db 3, 1, 3, 16
    dq xav_g5_0_2_1
    dw 400, 432
    db 2, 1, 2, 20
    dq xav_g5_0_3_1
    dw 336, 368
    db 3, 1, 3, 16
    dq xav_g5_0_3_1
    dw 352, 384
    db 3, 1, 3, 16
    dq xav_g5_0_3_1
    dw 368, 400
    db 3, 1, 3, 16
    dq xav_g5_0_2_1
    dw 384, 416
    db 2, 1, 2, 16
    dq xav_g5_0_3_1
    dw 400, 432
    db 3, 1, 3, 16
    dq xav_g5_0_3_1
    dw 416, 448
    db 3, 1, 3, 16
    dq xav_g5_0_3_1
    dw 432, 464
    db 3, 1, 3, 16
    dq xav_g5_0_3_1
    dw 336, 368
    db 3, 1, 3, 12
    dq xav_g5_0_3_1
    dw 464, 496
    db 3, 1, 3, 16
    dq xav_g5_0_3_1
    dw 480, 512
    db 3, 1, 3, 16
    dq xav_g5_0_3_1
    dw 496, 528
    db 3, 1, 3, 16
    dq xav_g5_0_2_1
    dw 384, 416
    db 2, 1, 2, 12
    dq xav_g5_0_3_2
    dw 528, 592
    db 3, 2, 3, 16
    dq xav_g5_0_3_2
    dw 272, 336
    db 3, 2, 3, 8
    dq xav_g5_0_4_2
    dw 560, 624
    db 4, 2, 4, 16
    dq xav_g5_0_3_2
    dw 432, 496
    db 3, 2, 3, 12
    dq xav_g5_0_4_2
    dw 592, 656
    db 4, 2, 4, 16
    dq xav_g5_0_4_2
    dw 304, 368
    db 4, 2, 4, 8
    dq xav_g5_0_4_2
    dw 624, 688
    db 4, 2, 4, 16
    dq xav_g5_0_3_2
    dw 320, 384
    db 3, 2, 3, 8
    dq xav_g5_0_4_2
    dw 656, 720
    db 4, 2, 4, 16
    dq xav_g5_0_4_2
    dw 336, 400
    db 4, 2, 4, 8
    dq xav_g5_0_4_2
    dw 688, 752
    db 4, 2, 4, 16
    dq xav_g5_0_4_2
    dw 352, 416
    db 4, 2, 4, 8
    dq xav_g5_0_4_2
    dw 720, 784
    db 4, 2, 4, 16
    dq xav_g5_0_4_2
    dw 368, 432
    db 4, 2, 4, 8
    dq xav_g5_0_4_2
    dw 752, 816
    db 4, 2, 4, 16
    dq xav_g5_0_3_2
    dw 384, 448
    db 3, 2, 3, 8
    dq xav_g5_0_4_2
    dw 784, 848
    db 4, 2, 4, 16
    dq xav_g5_0_4_2
    dw 400, 464
    db 4, 2, 4, 8
    dq xav_g5_0_5_2
    dw 816, 880
    db 5, 2, 5, 16
    dq xav_g5_0_4_2
    dw 416, 480
    db 4, 2, 4, 8
    dq xav_g5_0_5_2
    dw 848, 912
    db 5, 2, 5, 16
    dq xav_g5_0_5_2
    dw 432, 496
    db 5, 2, 5, 8
    dq xav_g5_0_5_2
    dw 880, 944
    db 5, 2, 5, 16
    dq xav_g5_0_4_2
    dw 448, 512
    db 4, 2, 4, 8
    dq xav_g5_0_5_2
    dw 912, 976
    db 5, 2, 5, 16
    dq xav_g5_0_5_2
    dw 464, 528
    db 5, 2, 5, 8
    dq xav_g5_0_5_2
    dw 944, 1008
    db 5, 2, 5, 16
    dq xav_g5_0_5_2
    dw 480, 544
    db 5, 2, 5, 8
    dq xav_g5_0_5_2
    dw 976, 1040
    db 5, 2, 5, 16
    dq xav_g5_0_5_2
    dw 496, 560
    db 5, 2, 5, 8
    dq xav_g5_0_5_2
    dw 1008, 1072
    db 5, 2, 5, 16
    dq xav_g5_0_4_2
    dw 512, 576
    db 4, 2, 4, 8
    dq xav_g5_0_5_3
    dw 1040, 1136
    db 5, 3, 5, 16
    dq xav_g5_0_5_3
    dw 528, 624
    db 5, 3, 5, 8
    dq xav_g5_0_6_3
    dw 1072, 1168
    db 6, 3, 6, 16
    dq xav_g5_0_5_3
    dw 272, 368
    db 5, 3, 5, 4
    dq xav_g5_0_6_3
    dw 1104, 1200
    db 6, 3, 6, 16
    dq xav_g5_0_6_3
    dw 560, 656
    db 6, 3, 6, 8
    dq xav_g5_0_6_3
    dw 1136, 1232
    db 6, 3, 6, 16
    dq xav_g5_0_5_3
    dw 288, 384
    db 5, 3, 5, 4
    dq xav_g5_0_6_3
    dw 1168, 1264
    db 6, 3, 6, 16
    dq xav_g5_0_6_3
    dw 592, 688
    db 6, 3, 6, 8
    dq xav_g5_0_6_3
    dw 1200, 1296
    db 6, 3, 6, 16
    dq xav_g5_0_6_3
    dw 304, 400
    db 6, 3, 6, 4
    dq xav_g5_0_6_3
    dw 1232, 1328
    db 6, 3, 6, 16
    dq xav_g5_0_6_3
    dw 624, 720
    db 6, 3, 6, 8
    dq xav_g5_0_6_3
    dw 1264, 1360
    db 6, 3, 6, 16
    dq xav_g5_0_5_3
    dw 320, 416
    db 5, 3, 5, 4
    dq xav_g5_0_6_3
    dw 1296, 1392
    db 6, 3, 6, 16
    dq xav_g5_0_6_3
    dw 656, 752
    db 6, 3, 6, 8
    dq xav_g5_0_7_3
    dw 1328, 1424
    db 7, 3, 7, 16
    dq xav_g5_0_6_3
    dw 336, 432
    db 6, 3, 6, 4
    dq xav_g5_0_7_3
    dw 1360, 1456
    db 7, 3, 7, 16
    dq xav_g5_0_7_3
    dw 688, 784
    db 7, 3, 7, 8
    dq xav_g5_0_7_3
    dw 1392, 1488
    db 7, 3, 7, 16
    dq xav_g5_0_6_3
    dw 352, 448
    db 6, 3, 6, 4
    dq xav_g5_0_7_3
    dw 1424, 1520
    db 7, 3, 7, 16
    dq xav_g5_0_7_3
    dw 720, 816
    db 7, 3, 7, 8
    dq xav_g5_0_7_3
    dw 1456, 1552
    db 7, 3, 7, 16
    dq xav_g5_0_7_3
    dw 368, 464
    db 7, 3, 7, 4
    dq xav_g5_0_7_3
    dw 1488, 1584
    db 7, 3, 7, 16
    dq xav_g5_0_7_3
    dw 752, 848
    db 7, 3, 7, 8
    dq xav_g5_0_7_3
    dw 1520, 1616
    db 7, 3, 7, 16
    dq xav_g5_0_6_3
    dw 384, 480
    db 6, 3, 6, 4
    dq xav_g5_0_7_4
    dw 1552, 1680
    db 7, 4, 7, 16
    dq xav_g5_0_7_4
    dw 784, 912
    db 7, 4, 7, 8
    dq xav_g5_0_8_4
    dw 1584, 1712
    db 8, 4, 8, 16
    dq xav_g5_0_7_4
    dw 400, 528
    db 7, 4, 7, 4
    dq xav_g5_0_8_4
    dw 1616, 1744
    db 8, 4, 8, 16
    dq xav_g5_0_8_4
    dw 816, 944
    db 8, 4, 8, 8
    dq xav_g5_0_8_4
    dw 1648, 1776
    db 8, 4, 8, 16
    dq xav_g5_0_7_4
    dw 416, 544
    db 7, 4, 7, 4
    dq xav_g5_0_8_4
    dw 1680, 1808
    db 8, 4, 8, 16
    dq xav_g5_0_8_4
    dw 848, 976
    db 8, 4, 8, 8
    dq xav_g5_0_8_4
    dw 1712, 1840
    db 8, 4, 8, 16
    dq xav_g5_0_8_4
    dw 432, 560
    db 8, 4, 8, 4
    dq xav_g5_0_8_4
    dw 1744, 1872
    db 8, 4, 8, 16
    dq xav_g5_0_8_4
    dw 880, 1008
    db 8, 4, 8, 8
    dq xav_g5_0_8_4
    dw 1776, 1904
    db 8, 4, 8, 16
    dq xav_g5_0_7_4
    dw 448, 576
    db 7, 4, 7, 4
    dq xav_g5_0_8_4
    dw 1808, 1936
    db 8, 4, 8, 16
    dq xav_g5_0_8_4
    dw 912, 1040
    db 8, 4, 8, 8
    dq xav_g5_0_9_4
    dw 1840, 1968
    db 9, 4, 9, 16
    dq xav_g5_0_8_4
    dw 464, 592
    db 8, 4, 8, 4
    dq xav_g5_0_9_4
    dw 1872, 2000
    db 9, 4, 9, 16
    dq xav_g5_0_9_4
    dw 944, 1072
    db 9, 4, 9, 8
    dq xav_g5_0_9_4
    dw 1904, 2032
    db 9, 4, 9, 16
    dq xav_g5_0_8_4
    dw 480, 608
    db 8, 4, 8, 4
    dq xav_g5_0_9_4
    dw 1936, 2064
    db 9, 4, 9, 16
    dq xav_g5_0_9_4
    dw 976, 1104
    db 9, 4, 9, 8
    dq xav_g5_0_9_4
    dw 1968, 2096
    db 9, 4, 9, 16
    dq xav_g5_0_9_4
    dw 496, 624
    db 9, 4, 9, 4
    dq xav_g5_0_9_4
    dw 2000, 2128
    db 9, 4, 9, 16
    dq xav_g5_0_9_4
    dw 1008, 1136
    db 9, 4, 9, 8
    dq xav_g5_0_9_4
    dw 2032, 2160
    db 9, 4, 9, 16
    dq xav_g5_0_8_4
    dw 512, 640
    db 8, 4, 8, 4
    dq xav_g5_0_9_5
    dw 2064, 2224
    db 9, 5, 9, 16
    dq xav_g5_0_9_5
    dw 1040, 1200
    db 9, 5, 9, 8
    dq xav_g5_0_10_5
    dw 2096, 2256
    db 10, 5, 10, 16
    dq xav_g5_0_9_5
    dw 528, 688
    db 9, 5, 9, 4
    dq xav_g5_0_10_5
    dw 2128, 2288
    db 10, 5, 10, 16
    dq xav_g5_0_10_5
    dw 1072, 1232
    db 10, 5, 10, 8
    dq xav_g5_0_10_5
    dw 2160, 2320
    db 10, 5, 10, 16
    dq xav_g5_0_9_5
    dw 544, 704
    db 9, 5, 9, 4
    dq xav_g5_0_10_5
    dw 2192, 2352
    db 10, 5, 10, 16
    dq xav_g5_0_10_5
    dw 1104, 1264
    db 10, 5, 10, 8
    dq xav_g5_0_10_5
    dw 2224, 2384
    db 10, 5, 10, 16
    dq xav_g5_0_10_5
    dw 560, 720
    db 10, 5, 10, 4
    dq xav_g5_0_10_5
    dw 2256, 2416
    db 10, 5, 10, 16
    dq xav_g5_0_10_5
    dw 1136, 1296
    db 10, 5, 10, 8
    dq xav_g5_0_10_5
    dw 2288, 2448
    db 10, 5, 10, 16
    dq xav_g5_0_9_5
    dw 576, 736
    db 9, 5, 9, 4
    dq xav_g5_0_10_5
    dw 2320, 2480
    db 10, 5, 10, 16
    dq xav_g5_0_10_5
    dw 1168, 1328
    db 10, 5, 10, 8
    dq xav_g5_0_11_5
    dw 2352, 2512
    db 11, 5, 11, 16
    dq xav_g5_0_10_5
    dw 592, 752
    db 10, 5, 10, 4
    dq xav_g5_0_11_5
    dw 2384, 2544
    db 11, 5, 11, 16
    dq xav_g5_0_11_5
    dw 1200, 1360
    db 11, 5, 11, 8
    dq xav_g5_0_11_5
    dw 2416, 2576
    db 11, 5, 11, 16
    dq xav_g5_0_10_5
    dw 608, 768
    db 10, 5, 10, 4
    dq xav_g5_0_11_5
    dw 2448, 2608
    db 11, 5, 11, 16
    dq xav_g5_0_11_5
    dw 1232, 1392
    db 11, 5, 11, 8
    dq xav_g5_0_11_5
    dw 2480, 2640
    db 11, 5, 11, 16
    dq xav_g5_0_11_5
    dw 624, 784
    db 11, 5, 11, 4
    dq xav_g5_0_11_5
    dw 2512, 2672
    db 11, 5, 11, 16
    dq xav_g5_0_11_5
    dw 1264, 1424
    db 11, 5, 11, 8
    dq xav_g5_0_11_5
    dw 2544, 2704
    db 11, 5, 11, 16
    dq xav_g5_0_10_5
    dw 640, 800
    db 10, 5, 10, 4
    dq xav_g5_0_11_6
    dw 2576, 2768
    db 11, 6, 11, 16
    dq xav_g5_0_11_6
    dw 1296, 1488
    db 11, 6, 11, 8
    dq xav_g5_0_12_6
    dw 2608, 2800
    db 12, 6, 12, 16
    dq xav_g5_0_11_6
    dw 656, 848
    db 11, 6, 11, 4
    dq xav_g5_0_12_6
    dw 2640, 2832
    db 12, 6, 12, 16
    dq xav_g5_0_12_6
    dw 1328, 1520
    db 12, 6, 12, 8
    dq xav_g5_0_12_6
    dw 2672, 2864
    db 12, 6, 12, 16
    dq xav_g5_0_11_6
    dw 672, 864
    db 11, 6, 11, 4
    dq xav_g5_0_12_6
    dw 2704, 2896
    db 12, 6, 12, 16
    dq xav_g5_0_12_6
    dw 1360, 1552
    db 12, 6, 12, 8
    dq xav_g5_0_12_6
    dw 2736, 2928
    db 12, 6, 12, 16
    dq xav_g5_0_12_6
    dw 688, 880
    db 12, 6, 12, 4
    dq xav_g5_0_12_6
    dw 2768, 2960
    db 12, 6, 12, 16
    dq xav_g5_0_12_6
    dw 1392, 1584
    db 12, 6, 12, 8
    dq xav_g5_0_12_6
    dw 2800, 2992
    db 12, 6, 12, 16
    dq xav_g5_0_11_6
    dw 704, 896
    db 11, 6, 11, 4
    dq xav_g5_0_12_6
    dw 2832, 3024
    db 12, 6, 12, 16
    dq xav_g5_0_12_6
    dw 1424, 1616
    db 12, 6, 12, 8
    dq xav_g5_0_13_6
    dw 2864, 3056
    db 13, 6, 13, 16
    dq xav_g5_0_12_6
    dw 720, 912
    db 12, 6, 12, 4
    dq xav_g5_0_13_6
    dw 2896, 3088
    db 13, 6, 13, 16
    dq xav_g5_0_13_6
    dw 1456, 1648
    db 13, 6, 13, 8
    dq xav_g5_0_13_6
    dw 2928, 3120
    db 13, 6, 13, 16
    dq xav_g5_0_12_6
    dw 736, 928
    db 12, 6, 12, 4
    dq xav_g5_0_13_6
    dw 2960, 3152
    db 13, 6, 13, 16
    dq xav_g5_0_13_6
    dw 1488, 1680
    db 13, 6, 13, 8
    dq xav_g5_0_13_6
    dw 2992, 3184
    db 13, 6, 13, 16
    dq xav_g5_0_13_6
    dw 752, 944
    db 13, 6, 13, 4
    dq xav_g5_0_13_6
    dw 3024, 3216
    db 13, 6, 13, 16
    dq xav_g5_0_13_6
    dw 1520, 1712
    db 13, 6, 13, 8
    dq xav_g5_0_13_6
    dw 3056, 3248
    db 13, 6, 13, 16
    dq xav_g5_0_12_6
    dw 768, 960
    db 12, 6, 12, 4
    dq xav_g5_0_13_7
    dw 3088, 3312
    db 13, 7, 13, 16
    dq xav_g5_0_13_7
    dw 1552, 1776
    db 13, 7, 13, 8
    dq xav_g5_0_14_7
    dw 3120, 3344
    db 14, 7, 14, 16
    dq xav_g5_0_13_7
    dw 784, 1008
    db 13, 7, 13, 4
    dq xav_g5_0_14_7
    dw 3152, 3376
    db 14, 7, 14, 16
    dq xav_g5_0_14_7
    dw 1584, 1808
    db 14, 7, 14, 8
    dq xav_g5_0_14_7
    dw 3184, 3408
    db 14, 7, 14, 16
    dq xav_g5_0_13_7
    dw 800, 1024
    db 13, 7, 13, 4
    dq xav_g5_0_14_7
    dw 3216, 3440
    db 14, 7, 14, 16
    dq xav_g5_0_14_7
    dw 1616, 1840
    db 14, 7, 14, 8
    dq xav_g5_0_14_7
    dw 3248, 3472
    db 14, 7, 14, 16
    dq xav_g5_0_14_7
    dw 816, 1040
    db 14, 7, 14, 4
    dq xav_g5_0_14_7
    dw 3280, 3504
    db 14, 7, 14, 16
    dq xav_g5_0_14_7
    dw 1648, 1872
    db 14, 7, 14, 8
    dq xav_g5_0_14_7
    dw 3312, 3536
    db 14, 7, 14, 16
    dq xav_g5_0_13_7
    dw 832, 1056
    db 13, 7, 13, 4
    dq xav_g5_0_14_7
    dw 3344, 3568
    db 14, 7, 14, 16
    dq xav_g5_0_14_7
    dw 1680, 1904
    db 14, 7, 14, 8
    dq xav_g5_0_15_7
    dw 3376, 3600
    db 15, 7, 15, 16
    dq xav_g5_0_14_7
    dw 848, 1072
    db 14, 7, 14, 4
    dq xav_g5_0_15_7
    dw 3408, 3632
    db 15, 7, 15, 16
    dq xav_g5_0_15_7
    dw 1712, 1936
    db 15, 7, 15, 8
    dq xav_g5_0_15_7
    dw 3440, 3664
    db 15, 7, 15, 16
    dq xav_g5_0_14_7
    dw 864, 1088
    db 14, 7, 14, 4
    dq xav_g5_0_15_7
    dw 3472, 3696
    db 15, 7, 15, 16
    dq xav_g5_0_15_7
    dw 1744, 1968
    db 15, 7, 15, 8
    dq xav_g5_0_15_7
    dw 3504, 3728
    db 15, 7, 15, 16
    dq xav_g5_0_15_7
    dw 880, 1104
    db 15, 7, 15, 4
    dq xav_g5_0_15_7
    dw 3536, 3760
    db 15, 7, 15, 16
    dq xav_g5_0_15_7
    dw 1776, 2000
    db 15, 7, 15, 8
    dq xav_g5_0_15_7
    dw 3568, 3792
    db 15, 7, 15, 16
    dq xav_g5_0_14_7
    dw 896, 1120
    db 14, 7, 14, 4
    dq xav_g5_0_15_8
    dw 3600, 3856
    db 15, 8, 15, 16
    dq xav_g5_0_15_8
    dw 1808, 2064
    db 15, 8, 15, 8
    dq xav_g5_0_16_8
    dw 3632, 3888
    db 16, 8, 16, 16
    dq xav_g5_0_15_8
    dw 912, 1168
    db 15, 8, 15, 4
    dq xav_g5_0_16_8
    dw 3664, 3920
    db 16, 8, 16, 16
    dq xav_g5_0_16_8
    dw 1840, 2096
    db 16, 8, 16, 8
    dq xav_g5_0_16_8
    dw 3696, 3952
    db 16, 8, 16, 16
    dq xav_g5_0_15_8
    dw 928, 1184
    db 15, 8, 15, 4
    dq xav_g5_0_16_8
    dw 3728, 3984
    db 16, 8, 16, 16
    dq xav_g5_0_16_8
    dw 1872, 2128
    db 16, 8, 16, 8
    dq xav_g5_0_16_8
    dw 3760, 4016
    db 16, 8, 16, 16
    dq xav_g5_0_16_8
    dw 944, 1200
    db 16, 8, 16, 4
    dq xav_g5_0_16_8
    dw 3792, 4048
    db 16, 8, 16, 16
    dq xav_g5_0_16_8
    dw 1904, 2160
    db 16, 8, 16, 8
    dq xav_g5_0_16_8
    dw 3824, 4080
    db 16, 8, 16, 16
    dq xav_g5_0_15_8
    dw 960, 1216
    db 15, 8, 15, 4
section .text
xav_g5i:
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15
    mov rax, rsp
    and rsp, -64
    sub rsp, 320
    mov [rsp + 256], rax
    mov r12, r9
    mov r13d, r8d
    mov r8d, edi
    mov r11d, esi
    mov r10d, edx
    lea eax, [rcx + rcx*2]
    shl eax, 7
    mov [rsp + 276], eax
    vmovdqa64 zmm0, [abs xav_g5l + rax + 0]
    vmovdqa64 zmm1, [abs xav_g5l + rax + 64]
    vmovdqa64 zmm2, [abs xav_g5l + rax + 128]
    vmovdqa64 zmm3, [abs xav_g5l + rax + 192]
    vmovdqa64 zmm4, [abs xav_g5l + rax + 256]
    vmovdqa64 zmm5, [abs xav_g5l + rax + 320]
    vmovdqa64 [xav_gr + 0], zmm0
    vmovdqa64 [xav_gr + 64], zmm1
    vmovdqa64 [xav_gr + 128], zmm2
    vmovdqa64 [xav_gr + 192], zmm3
    vmovdqa64 [xav_gr + 256], zmm4
    vmovdqa64 [xav_gr + 320], zmm5
    vmovdqu xmm0, [r12 + 32]
    vmovdqa [rsp], xmm0
    mov [rsp + G_wi - 64], r8
    mov [rsp + G_hi - 64], r11
    mov [rsp + G_wo - 64], r10
    mov eax, r11d
    imul eax, r10d
    add eax, r8d
    lea ecx, [r8 + r8]
    xor edx, edx
    div ecx
    lea r9d, [rax + rax]
    mov [rsp + G_ho - 64], r9
    mov [r12 + 24], r9d
    mov ecx, r9d
    shr ecx, 1
    mov eax, r11d
    xor edx, edx
    div ecx
    mov esi, eax
    shr esi, 1
    mov [rsp + 264], esi
    lea edi, [rdx + rcx]
    test al, 1
    cmovz edi, edx
    mov [rsp + 268], edi
    test edx, edx
    jnz .rz
    and eax, 1
    lea edi, [rsi + rax*2 - 1]
    lea eax, [rsi + rax + 4]
    jmp .cn
.rz:
    mov r14d, eax
    mov r15d, edx
    mov eax, ecx
    xor edx, edx
    div r15d
    mov ebp, edx
    mov edi, eax
    tzcnt edx, ecx
    shrx ecx, ecx, edx
    mov eax, r15d
    xor edx, edx
    div ecx
    neg edx
    lea eax, [rsi + 2]
    adc eax, 0
    test r14b, 1
    jnz .qo
    lea edx, [rbp + rbp]
    mov ecx, edx
    sub ecx, r15d
    cmovae edx, ecx
    cmp edx, 1
    sbb eax, 0
    mov edi, eax
    lea eax, [rsi + 5]
    jmp .cn
.qo:
    mov ecx, edi
    mov edi, eax
    lea eax, [rsi + 5]
    cmp r15d, 1
    je .cn
    cmp ebp, 2
    jae .c6
    test cl, 1
    jnz .cn
.c6:
    inc eax
.cn:
    dec eax
    lzcnt ecx, eax
    mov r14d, -1
    shr r14d, cl
    mov [rsp + G_km - 64], r14
    lea eax, [r8*8]
    xor edx, edx
    div r10d
    mov [rsp + G_gp - 64], rax
    add eax, eax
    mov rcx, [abs g5kp - 144 + rax*8]
    mov [r12], rcx
    movzx r15d, word [abs g5kp - 136 + rax*8]
    mov [rsp + G_sp - 64], r15
    movzx ecx, word [abs g5kp - 134 + rax*8]
    mov [rsp + G_spp - 64], rcx
    movzx ebp, word [abs g5kp - 132 + rax*8]
    movzx esi, byte [abs g5kp - 130 + rax*8]
    movzx ebx, byte [abs g5kp - 129 + rax*8]
    mov [rsp + G_su - 64], rbx
    xor edx, edx
    cmp eax, 32
    cmovb edx, esi
    shl edx, 16
    or ebp, edx
    lea esi, [rdi + rsi + 1]
    mov [rsp + 272], esi
    mov edi, r8d
    shr edi, 1
    mov [rsp + G_wc - 64], rdi
    add edi, 15
    shr edi, 4
    shl edi, 5
    lea eax, [r10 + r10 + 15]
    shr eax, 4
    lea eax, [rax + rbx - 1]
    xor edx, edx
    div ebx
    mov [rsp + G_nst - 64], rax
    mov esi, eax
    imul eax, r15d
    xor edx, edx
    cmp eax, r8d
    seta dl
    sub esi, edx
    mov [rsp + G_lq - 64], rsi
    cmp eax, edi
    cmovb eax, edi
    mov [rsp + G_wp - 64], rax
    mov qword [rsp + G_pd - 64], 0
    shl r9d, 5
    mov [rsp + G_rd - 64], r9
    shl r11d, 5
    add r11d, r9d
    mov [rsp + G_hx - 64], r11
    movzx edx, bpl
    movzx edi, bp
    shr edi, 8
    imul edi, edx
    mov esi, edi
    shl esi, 6
    add esi, r11d
    mov [rsp + G_hk - 64], rsi
    lea edi, [rdi*2 + 63]
    and edi, -64
    add esi, edi
    mov [rsp + G_hv - 64], rsi
    shl edx, 6
    add esi, edx
    mov [rsp + G_ax - 64], rsi
    mov edi, ebp
    shr edi, 16
    shl edi, 6
    add esi, edi
    mov [rsp + G_ae - 64], rsi
    add esi, edi
    mov [rsp + G_ao - 64], rsi
    add esi, edi
    mov qword [rsp + G_cr - 64], GDZ
    lea edx, [r14 + 1]
    imul edx, eax
    lea edx, [rdx*8 + GDZ]
    mov [rsp + G_nx - 64], rdx
    shl eax, 4
    add edx, eax
    mov [rsp + G_sb2 - 64], rdx
    shl ecx, 5
    add edx, ecx
    mov [rsp + G_cl - 64], rdx
    shl ebx, 6
    lea edx, [rdx + rbx*4]
    mov [rsp + G_cc - 64], rdx
    lea edx, [rdx + rbx + 256]
    mov [rsp + G_oc - 64], rdx
    add edx, 256
    mov [rsp + G_sg - 64], rdx
    add edx, SGZ + 4095
    and edx, -4096
    mov ebx, edx
    mov [r12 + 16], rbx
    call xav_amap
    mov r14, rax
    mov rsi, rbx
    imul rsi, r13
    call xav_amap
    mov r15, rax
    mov [r12 + 8], r15
    vpbroadcastq zmm16, r14
    vpbroadcastq zmm17, r15
    kxnorb k1, k1, k1
    kshiftrb k2, k1, 7
    kshiftlb k3, k1, 7
    kshiftrb k1, k1, 2
    vmovdqa64 zmm28, [rsp]
    vmovdqa64 zmm29, [rsp + 64]
    vpaddq zmm29{k3}, zmm29, zmm16
    vpblendmq zmm18{k2}, zmm17, zmm16
    vpaddq zmm30, zmm18, [rsp + 128]
    vpaddq zmm31{k1}{z}, zmm16, [rsp + 192]
    vmovdqa64 [r15 + 64], zmm28
    vmovdqa64 [r15 + 128], zmm29
    vmovdqa64 [r15 + 192], zmm30
    vmovdqa64 [r15 + 256], zmm31
    vmovsd xmm26, [c_one]
    vcvtsi2sd xmm1, xmm1, dword [rsp + G_wi - 64]
    vcvtsi2sd xmm2, xmm2, dword [rsp + G_wo - 64]
    vcvtsi2sd xmm3, xmm3, dword [rsp + G_hi - 64]
    mov r10d, [rsp + G_ho - 64]
    vcvtsi2sd xmm4, xmm4, r10d
    vmulsd xmm20, xmm1, xmm3
    vaddsd xmm20, xmm20, xmm20
    vmovsd xmm0, [c_lsig]
    vmulsd xmm0, xmm0, [xav_gr + P_SY24]
    vdivsd xmm1, xmm1, xmm2
    vmulsd xmm0, xmm0, xmm1
    vdivsd xmm3, xmm3, xmm4
    vmulsd xmm0, xmm0, xmm3
    vdivsd xmm0, xmm26, xmm0
    vdivsd xmm15, xmm26, xmm4
    vbroadcastsd ymm15, xmm15
    vdivsd xmm1, xmm0, [c_c32]
    vmovq rdx, xmm1
    dec rdx
    shr rdx, 52
    mov esi, 2045
    sub esi, edx
    shl rsi, 52
    vmovq xmm1, rsi
    vmulsd xmm25, xmm0, xmm1
    sub edx, 902
    shl edx, 23
    vpbroadcastd zmm21, edx
    mov rdi, r14
    mov r8d, [rsp + 264]
    mov r9d, [rsp + 268]
    lea r11d, [r8 - 1]
    vmovd xmm13, r10d
    vpshufd xmm13, xmm13, 0x44
    vmovdqa xmm12, [g5i_sgn]
    xor eax, eax
    xor edx, edx
.pa:
    mov [rdi + Pc_y0], eax
    sub edx, r9d
    setnz byte [rdi + Pc_n + 4]
    mov esi, r8d
    cmova esi, r11d
    mov [rdi + Pc_n], esi
    lea esi, [rdx + r10]
    cmovb edx, esi
    adc eax, r8d
    vmovd xmm0, edx
    sub edx, r9d
    setnz byte [rdi + Pc_n + 12]
    setnz byte [rdi + PCS + Pc_ci]
    mov esi, r8d
    cmova esi, r11d
    mov [rdi + Pc_n + 8], esi
    lea esi, [rdx + r10]
    cmovb edx, esi
    adc eax, r8d
    vpinsrd xmm0, xmm0, edx, 2
    lea esi, [rax + 3]
    shr esi, 1
    mov [rdi + Pc_ch], esi
    vpshufd xmm1, xmm0, 0xa0
    vpsignd xmm2, xmm1, xmm12
    vpaddd xmm3, xmm2, xmm13
    vpminud xmm2, xmm3, xmm2
    vcvtdq2pd ymm2, xmm2
    vmulpd ymm2, ymm2, ymm15
    vcvtpd2ps xmm2, ymm2
    vmovups [rdi + Pc_w], xmm2
    add rdi, PCS
    test edx, edx
    jnz .pa
    test al, 1
    jnz .pa
    mov rsi, r14
    sub rsi, rdi
    cmp rsi, -512
    jle .pl
    mov ecx, esi
    neg ecx
    shr ecx, 6
    lzcnt edx, ecx
    sub edx, 28
    shlx r8d, ecx, edx
    sub r8d, ecx
    mov r9d, eax
    shr r9d, 1
    vmovd xmm9, eax
    vpinsrd xmm9, xmm9, r9d, 1
.ps:
    vpaddd zmm0, zmm9, [rdi + rsi]
    vmovdqa32 [rdi], zmm0
    sub rdi, -64
    dec r8d
    jnz .ps
    shlx eax, eax, edx
    mov rsi, r14
    sub rsi, rdi
.pl:
    mov ecx, r10d
    shl ecx, 5
    add rcx, r14
    sub rcx, rdi
    jz .pf
    vmovd xmm9, eax
    shr eax, 1
    vpinsrd xmm9, xmm9, eax, 1
    cmp rsi, -512
    jne .pm
    vmovdqa32 zmm0, [r14 + 0]
    vmovdqa32 zmm1, [r14 + 64]
    vmovdqa32 zmm2, [r14 + 128]
    vmovdqa32 zmm3, [r14 + 192]
    vmovdqa32 zmm4, [r14 + 256]
    vmovdqa32 zmm5, [r14 + 320]
    vmovdqa32 zmm6, [r14 + 384]
    vmovdqa32 zmm7, [r14 + 448]
    vpsubd zmm10, zmm0, zmm9
    vpsubd zmm11, zmm1, zmm9
    vpsubd zmm12, zmm2, zmm9
    vpsubd zmm13, zmm3, zmm9
    vpsubd zmm14, zmm4, zmm9
    vpsubd zmm15, zmm5, zmm9
    vpsubd zmm16, zmm6, zmm9
    vpsubd zmm17, zmm7, zmm9
    vpaddd zmm18, zmm9, zmm9
    mov rax, rcx
    and rax, -1024
    add rdi, rax
    neg rax
.pv:
    vpaddd zmm10, zmm10, zmm18
    vmovdqa32 [rdi + rax + 0], zmm10
    vpaddd zmm11, zmm11, zmm18
    vmovdqa32 [rdi + rax + 64], zmm11
    vpaddd zmm12, zmm12, zmm18
    vmovdqa32 [rdi + rax + 128], zmm12
    vpaddd zmm13, zmm13, zmm18
    vmovdqa32 [rdi + rax + 192], zmm13
    vpaddd zmm14, zmm14, zmm18
    vmovdqa32 [rdi + rax + 256], zmm14
    vpaddd zmm15, zmm15, zmm18
    vmovdqa32 [rdi + rax + 320], zmm15
    vpaddd zmm16, zmm16, zmm18
    vmovdqa32 [rdi + rax + 384], zmm16
    vpaddd zmm17, zmm17, zmm18
    vmovdqa32 [rdi + rax + 448], zmm17
    vpaddd zmm0, zmm0, zmm18
    vmovdqa32 [rdi + rax + 512], zmm0
    vpaddd zmm1, zmm1, zmm18
    vmovdqa32 [rdi + rax + 576], zmm1
    vpaddd zmm2, zmm2, zmm18
    vmovdqa32 [rdi + rax + 640], zmm2
    vpaddd zmm3, zmm3, zmm18
    vmovdqa32 [rdi + rax + 704], zmm3
    vpaddd zmm4, zmm4, zmm18
    vmovdqa32 [rdi + rax + 768], zmm4
    vpaddd zmm5, zmm5, zmm18
    vmovdqa32 [rdi + rax + 832], zmm5
    vpaddd zmm6, zmm6, zmm18
    vmovdqa32 [rdi + rax + 896], zmm6
    vpaddd zmm7, zmm7, zmm18
    vmovdqa32 [rdi + rax + 960], zmm7
    add rax, 1024
    jnz .pv
    test ecx, 512
    jz .pq
    vpaddd zmm10, zmm10, zmm18
    vmovdqa32 [rdi + 0], zmm10
    vpaddd zmm11, zmm11, zmm18
    vmovdqa32 [rdi + 64], zmm11
    vpaddd zmm12, zmm12, zmm18
    vmovdqa32 [rdi + 128], zmm12
    vpaddd zmm13, zmm13, zmm18
    vmovdqa32 [rdi + 192], zmm13
    vpaddd zmm14, zmm14, zmm18
    vmovdqa32 [rdi + 256], zmm14
    vpaddd zmm15, zmm15, zmm18
    vmovdqa32 [rdi + 320], zmm15
    vpaddd zmm16, zmm16, zmm18
    vmovdqa32 [rdi + 384], zmm16
    vpaddd zmm17, zmm17, zmm18
    vmovdqa32 [rdi + 448], zmm17
    add rdi, 512
.pq:
    and ecx, 511
    jz .pf
.pm:
    add rdi, rcx
    add rsi, rdi
    neg rcx
.pr:
    vpaddd zmm0, zmm9, [rsi + rcx]
    vmovdqa32 [rdi + rcx], zmm0
    sub rcx, -64
    jnz .pr
.pf:
    mov ecx, [rsp + G_hi - 64]
    shr ecx, 1
    dec ecx
    mov [rdi - PCS + Pc_ch], ecx
    mov eax, [rdi - 2 * PCS + Pc_ch]
    cmp eax, ecx
    cmova eax, ecx
    mov [rdi - 2 * PCS + Pc_ch], eax
    mov eax, [rsp + G_wp - 64]
    add eax, eax
    vpbroadcastd zmm0, eax
    vmovdqa32 zmm2, [g5i_rkb]
    vmovdqa32 zmm3, [g5i_rkv]
    mov eax, 0xf0f0
    kmovw k4, eax
    knotw k5, k4
    vpxord xmm4, xmm4, xmm4
    vpbroadcastd zmm5, ecx
    vpbroadcastd zmm6, [rsp + G_km - 64]
    vpbroadcastd zmm8, [g5i_one]
    vpmaxsd zmm7, zmm2, zmm4
    vpmulld zmm7, zmm7, zmm0
    vpblendmd zmm7{k4}, zmm7, zmm3
    vmovdqa32 [rdi], zmm7
    vpaddd zmm9, zmm2, zmm8
    vpmaxsd zmm7, zmm9, zmm4
    vpmulld zmm7, zmm7, zmm0
    vpblendmd zmm7{k4}, zmm7, zmm3
    vmovdqa32 [rdi + 64], zmm7
    vpaddd zmm9, zmm9, zmm8
    vpandd zmm10, zmm9, zmm6
    vpaddd zmm9, zmm9, zmm8
    vpandd zmm11, zmm9, zmm6
    vpmulld zmm10, zmm10, zmm0
    vpmulld zmm11, zmm11, zmm0
    vpblendmd zmm10{k4}, zmm10, zmm3
    vpblendmd zmm11{k4}, zmm11, zmm3
    vpaddd zmm12{k5}{z}, zmm0, zmm0
    vpsubd zmm1, zmm8, zmm6
    vpmulld zmm1{k5}{z}, zmm1, zmm0
    shl ecx, 6
    lea rdx, [rdi + rcx - 64]
    vpaddd zmm9, zmm2, zmm5
    vpminsd zmm7, zmm9, zmm5
    vpandd zmm7, zmm7, zmm6
    vpmulld zmm7, zmm7, zmm0
    vpblendmd zmm7{k4}, zmm7, zmm3
    vmovdqa32 [rdx + 64], zmm7
    vpsubd zmm9, zmm9, zmm8
    vpminsd zmm7, zmm9, zmm5
    vpandd zmm7, zmm7, zmm6
    vpmulld zmm7, zmm7, zmm0
    vpblendmd zmm7{k4}, zmm7, zmm3
    vmovdqa32 [rdx], zmm7
    mov eax, [rsp + G_km - 64]
    lea rsi, [rdi + 128]
    cmp eax, 15
    ja .rf
    vpaddd zmm0, zmm10, zmm12
    vpaddd zmm19, zmm10, zmm1
    vpminud zmm0, zmm0, zmm19
    vpaddd zmm2, zmm11, zmm12
    vpaddd zmm19, zmm11, zmm1
    vpminud zmm2, zmm2, zmm19
    vpaddd zmm3, zmm0, zmm12
    vpaddd zmm19, zmm0, zmm1
    vpminud zmm3, zmm3, zmm19
    vpaddd zmm4, zmm2, zmm12
    vpaddd zmm19, zmm2, zmm1
    vpminud zmm4, zmm4, zmm19
    vpaddd zmm5, zmm3, zmm12
    vpaddd zmm19, zmm3, zmm1
    vpminud zmm5, zmm5, zmm19
    vpaddd zmm6, zmm4, zmm12
    vpaddd zmm19, zmm4, zmm1
    vpminud zmm6, zmm6, zmm19
    mov rcx, rdx
    sub rcx, rsi
    and rcx, -2048
    add rsi, rcx
    neg rcx
    cmp eax, 7
    jbe .ra
    vpaddd zmm7, zmm5, zmm12
    vpaddd zmm19, zmm5, zmm1
    vpminud zmm7, zmm7, zmm19
    vpaddd zmm9, zmm6, zmm12
    vpaddd zmm19, zmm6, zmm1
    vpminud zmm9, zmm9, zmm19
    vpaddd zmm13, zmm7, zmm12
    vpaddd zmm19, zmm7, zmm1
    vpminud zmm13, zmm13, zmm19
    vpaddd zmm14, zmm9, zmm12
    vpaddd zmm19, zmm9, zmm1
    vpminud zmm14, zmm14, zmm19
    vpaddd zmm15, zmm13, zmm12
    vpaddd zmm19, zmm13, zmm1
    vpminud zmm15, zmm15, zmm19
    vpaddd zmm16, zmm14, zmm12
    vpaddd zmm19, zmm14, zmm1
    vpminud zmm16, zmm16, zmm19
    vpaddd zmm17, zmm15, zmm12
    vpaddd zmm19, zmm15, zmm1
    vpminud zmm17, zmm17, zmm19
    vpaddd zmm18, zmm16, zmm12
    vpaddd zmm19, zmm16, zmm1
    vpminud zmm18, zmm18, zmm19
.rb:
    vmovdqa32 [rsi + rcx + 0], zmm10
    vmovdqa32 [rsi + rcx + 64], zmm11
    vmovdqa32 [rsi + rcx + 128], zmm0
    vmovdqa32 [rsi + rcx + 192], zmm2
    vmovdqa32 [rsi + rcx + 256], zmm3
    vmovdqa32 [rsi + rcx + 320], zmm4
    vmovdqa32 [rsi + rcx + 384], zmm5
    vmovdqa32 [rsi + rcx + 448], zmm6
    vmovdqa32 [rsi + rcx + 512], zmm7
    vmovdqa32 [rsi + rcx + 576], zmm9
    vmovdqa32 [rsi + rcx + 640], zmm13
    vmovdqa32 [rsi + rcx + 704], zmm14
    vmovdqa32 [rsi + rcx + 768], zmm15
    vmovdqa32 [rsi + rcx + 832], zmm16
    vmovdqa32 [rsi + rcx + 896], zmm17
    vmovdqa32 [rsi + rcx + 960], zmm18
    vmovdqa32 [rsi + rcx + 1024], zmm10
    vmovdqa32 [rsi + rcx + 1088], zmm11
    vmovdqa32 [rsi + rcx + 1152], zmm0
    vmovdqa32 [rsi + rcx + 1216], zmm2
    vmovdqa32 [rsi + rcx + 1280], zmm3
    vmovdqa32 [rsi + rcx + 1344], zmm4
    vmovdqa32 [rsi + rcx + 1408], zmm5
    vmovdqa32 [rsi + rcx + 1472], zmm6
    vmovdqa32 [rsi + rcx + 1536], zmm7
    vmovdqa32 [rsi + rcx + 1600], zmm9
    vmovdqa32 [rsi + rcx + 1664], zmm13
    vmovdqa32 [rsi + rcx + 1728], zmm14
    vmovdqa32 [rsi + rcx + 1792], zmm15
    vmovdqa32 [rsi + rcx + 1856], zmm16
    vmovdqa32 [rsi + rcx + 1920], zmm17
    vmovdqa32 [rsi + rcx + 1984], zmm18
    add rcx, 2048
    jnz .rb
    mov ecx, edx
    sub ecx, esi
    test ecx, 1024
    jz .rq
    vmovdqa32 [rsi + 0], zmm10
    vmovdqa32 [rsi + 64], zmm11
    vmovdqa32 [rsi + 128], zmm0
    vmovdqa32 [rsi + 192], zmm2
    vmovdqa32 [rsi + 256], zmm3
    vmovdqa32 [rsi + 320], zmm4
    vmovdqa32 [rsi + 384], zmm5
    vmovdqa32 [rsi + 448], zmm6
    vmovdqa32 [rsi + 512], zmm7
    vmovdqa32 [rsi + 576], zmm9
    vmovdqa32 [rsi + 640], zmm13
    vmovdqa32 [rsi + 704], zmm14
    vmovdqa32 [rsi + 768], zmm15
    vmovdqa32 [rsi + 832], zmm16
    vmovdqa32 [rsi + 896], zmm17
    vmovdqa32 [rsi + 960], zmm18
    add rsi, 1024
    jmp .rq
.ra:
    vmovdqa32 [rsi + rcx + 0], zmm10
    vmovdqa32 [rsi + rcx + 64], zmm11
    vmovdqa32 [rsi + rcx + 128], zmm0
    vmovdqa32 [rsi + rcx + 192], zmm2
    vmovdqa32 [rsi + rcx + 256], zmm3
    vmovdqa32 [rsi + rcx + 320], zmm4
    vmovdqa32 [rsi + rcx + 384], zmm5
    vmovdqa32 [rsi + rcx + 448], zmm6
    vmovdqa32 [rsi + rcx + 512], zmm10
    vmovdqa32 [rsi + rcx + 576], zmm11
    vmovdqa32 [rsi + rcx + 640], zmm0
    vmovdqa32 [rsi + rcx + 704], zmm2
    vmovdqa32 [rsi + rcx + 768], zmm3
    vmovdqa32 [rsi + rcx + 832], zmm4
    vmovdqa32 [rsi + rcx + 896], zmm5
    vmovdqa32 [rsi + rcx + 960], zmm6
    vmovdqa32 [rsi + rcx + 1024], zmm10
    vmovdqa32 [rsi + rcx + 1088], zmm11
    vmovdqa32 [rsi + rcx + 1152], zmm0
    vmovdqa32 [rsi + rcx + 1216], zmm2
    vmovdqa32 [rsi + rcx + 1280], zmm3
    vmovdqa32 [rsi + rcx + 1344], zmm4
    vmovdqa32 [rsi + rcx + 1408], zmm5
    vmovdqa32 [rsi + rcx + 1472], zmm6
    vmovdqa32 [rsi + rcx + 1536], zmm10
    vmovdqa32 [rsi + rcx + 1600], zmm11
    vmovdqa32 [rsi + rcx + 1664], zmm0
    vmovdqa32 [rsi + rcx + 1728], zmm2
    vmovdqa32 [rsi + rcx + 1792], zmm3
    vmovdqa32 [rsi + rcx + 1856], zmm4
    vmovdqa32 [rsi + rcx + 1920], zmm5
    vmovdqa32 [rsi + rcx + 1984], zmm6
    add rcx, 2048
    jnz .ra
    mov ecx, edx
    sub ecx, esi
    test ecx, 1024
    jz .rq
    vmovdqa32 [rsi + 0], zmm10
    vmovdqa32 [rsi + 64], zmm11
    vmovdqa32 [rsi + 128], zmm0
    vmovdqa32 [rsi + 192], zmm2
    vmovdqa32 [rsi + 256], zmm3
    vmovdqa32 [rsi + 320], zmm4
    vmovdqa32 [rsi + 384], zmm5
    vmovdqa32 [rsi + 448], zmm6
    vmovdqa32 [rsi + 512], zmm10
    vmovdqa32 [rsi + 576], zmm11
    vmovdqa32 [rsi + 640], zmm0
    vmovdqa32 [rsi + 704], zmm2
    vmovdqa32 [rsi + 768], zmm3
    vmovdqa32 [rsi + 832], zmm4
    vmovdqa32 [rsi + 896], zmm5
    vmovdqa32 [rsi + 960], zmm6
    add rsi, 1024
.rq:
    mov eax, 1024
    jmp .rc
.rf:
    inc eax
    shl eax, 6
    add rsi, rax
    mov r8, rax
    neg r8
.rdl:
    vmovdqa32 [rsi + r8], zmm10
    vmovdqa32 [rsi + r8 + 64], zmm11
    vpaddd zmm13, zmm10, zmm12
    vpaddd zmm10, zmm10, zmm1
    vpminud zmm10, zmm10, zmm13
    vpaddd zmm14, zmm11, zmm12
    vpaddd zmm11, zmm11, zmm1
    vpminud zmm11, zmm11, zmm14
    sub r8, -128
    jnz .rdl
.rc:
    mov rcx, rsi
    sub rcx, rdx
    and rcx, -128
    jz .re
    mov r8, rdx
    sub r8, rax
.rcl:
    vmovdqa32 zmm7, [r8 + rcx]
    vmovdqa32 zmm9, [r8 + rcx + 64]
    vmovdqa32 [rdx + rcx], zmm7
    vmovdqa32 [rdx + rcx + 64], zmm9
    sub rcx, -128
    jnz .rcl
.re:
    lea rdi, [rdx + 128]
    mov eax, [rsp + G_gp - 64]
    vpbroadcastd zmm0, eax
    vpmulld zmm1, zmm0, [g5i_iota]
    vpbroadcastd zmm4, [g5i_c15]
    vcvtdq2ps zmm15, zmm0
    vmulps zmm15, zmm15, zmm21
    vmulps zmm14, zmm21, [g5i_f16]{1to16}
    cmp eax, 16
    ja .hb
    vpsrld zmm2, zmm1, 4
    vpaddd zmm3, zmm1, zmm0
    vpaddd zmm3, zmm3, zmm4
    vpsrld zmm3, zmm3, 4
    vpsubd zmm3, zmm3, zmm8
    vpandd zmm6, zmm1, zmm4
    vcvtdq2ps zmm6, zmm6
    vmulps zmm6, zmm6, zmm21
    vsubps zmm6, zmm14, zmm6
    vmovdqa32 [rdi], zmm2
    vpaddd zmm9, zmm2, zmm8
    vpminud zmm9, zmm9, zmm3
    vmovdqa32 [rdi + 64], zmm9
    mov dword [rdi + 128], -1
    vminps zmm11, zmm6, zmm15
    vmovaps [rdi + 192], zmm11
    vaddps zmm12, zmm6, zmm14
    vminps zmm12, zmm12, zmm15
    vsubps zmm12, zmm12, zmm11
    vmovaps [rdi + 256], zmm12
    vpsrld zmm2, zmm1, 3
    vpaddd zmm3, zmm1, zmm0
    vpaddd zmm3, zmm3, [g5i_c7]{1to16}
    vpsrld zmm3, zmm3, 3
    vpsubd zmm3, zmm3, zmm8
    vpaddd zmm6, zmm1, zmm1
    vpandd zmm6, zmm6, zmm4
    vcvtdq2ps zmm6, zmm6
    vmulps zmm6, zmm6, zmm21
    vsubps zmm6, zmm14, zmm6
    vaddps zmm9, zmm15, zmm15
    mov eax, ebp
    shr eax, 16
    imul esi, eax, 64
    add rdi, 320
    vmovdqa32 [rdi], zmm2
    vminps zmm11, zmm6, zmm15
    vminps zmm12, zmm6, zmm9
    vsubps zmm13, zmm12, zmm11
    vmovaps [rdi + rsi], zmm11
    vmovaps [rdi + rsi*2], zmm13
    vpaddd zmm2, zmm2, zmm8
    vpminud zmm10, zmm2, zmm3
    vmovdqa32 [rdi + 64], zmm10
    vaddps zmm6, zmm6, zmm14
    vminps zmm7, zmm6, zmm15
    vminps zmm13, zmm6, zmm9
    vsubps zmm10, zmm7, zmm11
    vsubps zmm12, zmm13, zmm12
    vsubps zmm12, zmm12, zmm10
    vmovaps [rdi + rsi + 64], zmm10
    vmovaps [rdi + rsi*2 + 64], zmm12
    cmp eax, 2
    je .hz
    vpaddd zmm2, zmm2, zmm8
    vpminud zmm10, zmm2, zmm3
    vmovdqa32 [rdi + 128], zmm10
    vaddps zmm6, zmm6, zmm14
    vminps zmm11, zmm6, zmm15
    vminps zmm12, zmm6, zmm9
    vsubps zmm10, zmm11, zmm7
    vsubps zmm12, zmm12, zmm13
    vsubps zmm12, zmm12, zmm10
    vmovaps [rdi + rsi + 128], zmm10
    vmovaps [rdi + rsi*2 + 128], zmm12
    jmp .hz
.hb:
    vpsrld zmm2, zmm1, 4
    vpaddd zmm3, zmm1, zmm0
    vpaddd zmm3, zmm3, zmm4
    vpsrld zmm3, zmm3, 4
    vpsubd zmm3, zmm3, zmm8
    vpandd zmm6, zmm1, zmm4
    vcvtdq2ps zmm6, zmm6
    vmulps zmm6, zmm6, zmm21
    vsubps zmm6, zmm14, zmm6
    vxorps xmm7, xmm7, xmm7
    movzx r11d, bpl
    mov rcx, [r15 + G_hk]
    mov rdx, [r15 + G_hv]
    cmp eax, 32
    jbe .h1
    vpbroadcastd zmm13, [g5i_c31]
    movzx esi, bp
    shr esi, 8
.hg:
    vpminud zmm9, zmm2, zmm3
    vpandd zmm10, zmm9, zmm13
    vpsrld zmm9, zmm9, 5
    mov eax, esi
.hw:
    vptestnmd k1, zmm9, zmm9
    vmovdqa32 [rdi]{k1}, zmm10
    kmovw [rcx], k1
    vpsubd zmm9, zmm9, zmm8
    add rdi, 64
    add rcx, 2
    dec eax
    jnz .hw
    vminps zmm11, zmm6, zmm15
    vsubps zmm12, zmm11, zmm7
    vmovaps [rdx], zmm12
    vmovaps zmm7, zmm11
    vaddps zmm6, zmm6, zmm14
    vpaddd zmm2, zmm2, zmm8
    add rdx, 64
    dec r11d
    jnz .hg
    jmp .hz
.h1:
    sub rdx, rdi
.hu:
    vpminud zmm9, zmm2, zmm3
    vmovdqa32 [rdi], zmm9
    mov word [rcx], -1
    vminps zmm11, zmm6, zmm15
    vsubps zmm12, zmm11, zmm7
    vmovaps [rdi + rdx], zmm12
    vmovaps zmm7, zmm11
    vaddps zmm6, zmm6, zmm14
    vpaddd zmm2, zmm2, zmm8
    add rdi, 64
    add rcx, 2
    dec r11d
    jnz .hu
.hz:
    vmovsd xmm27, [c_mzr]
    vbroadcastsd ymm1, xmm20
    vmovapd ymm0, [g5i_rn]
    vdivpd ymm2, ymm0, ymm1
    vfnmadd231pd ymm0, ymm1, ymm2
    vdivpd ymm0, ymm0, ymm1
    vblendpd ymm0, ymm2, ymm0, 10
    vmovupd [r15 + G_dnl], ymm0
    vgetexpsd xmm7, xmm7, xmm25
    vgetmantsd xmm0, xmm0, xmm25, 0
    vsubsd xmm1, xmm0, xmm26
    vaddsd xmm2, xmm0, xmm26
    vdivsd xmm1, xmm1, xmm2
    vmulsd xmm2, xmm1, xmm1
    vmovsd xmm3, [lnc + 160]
    vfmadd213sd xmm3, xmm2, [lnc + 152]
    vfmadd213sd xmm3, xmm2, [lnc + 144]
    vfmadd213sd xmm3, xmm2, [lnc + 136]
    vfmadd213sd xmm3, xmm2, [lnc + 128]
    vfmadd213sd xmm3, xmm2, [lnc + 120]
    vfmadd213sd xmm3, xmm2, [lnc + 112]
    vfmadd213sd xmm3, xmm2, [lnc + 104]
    vfmadd213sd xmm3, xmm2, [lnc + 96]
    vfmadd213sd xmm3, xmm2, [lnc + 88]
    vfmadd213sd xmm3, xmm2, [lnc + 80]
    vfmadd213sd xmm3, xmm2, [lnc + 72]
    vfmadd213sd xmm3, xmm2, [lnc + 64]
    vfmadd213sd xmm3, xmm2, [lnc + 56]
    vfmadd213sd xmm3, xmm2, [lnc + 48]
    vfmadd213sd xmm3, xmm2, [lnc + 40]
    vfmadd213sd xmm3, xmm2, [lnc + 32]
    vfmadd213sd xmm3, xmm2, [lnc + 24]
    vfmadd213sd xmm3, xmm2, [lnc + 16]
    vfmadd213sd xmm3, xmm2, [lnc + 8]
    vfmadd213sd xmm3, xmm2, [lnc + 0]
    vaddsd xmm1, xmm1, xmm1
    vmulsd xmm24, xmm1, xmm3
    vfmadd231sd xmm24, xmm7, [c_ln2]
    vxorpd xmm0, xmm24, xmm27
    vxorpd xmm1, xmm1, xmm1
    call dxp
    vmulsd xmm2, xmm0, xmm25
    vmulsd xmm3, xmm1, xmm25
    vfmsub213sd xmm0, xmm25, xmm2
    vaddsd xmm0, xmm0, xmm3
    vaddsd xmm3, xmm2, xmm0
    vsubsd xmm4, xmm3, xmm2
    vsubsd xmm4, xmm0, xmm4
    vmovsd xmm2, [c_mone]
    vaddsd xmm5, xmm3, xmm2
    vsubsd xmm6, xmm5, xmm3
    vsubsd xmm7, xmm5, xmm6
    vsubsd xmm7, xmm3, xmm7
    vsubsd xmm6, xmm2, xmm6
    vaddsd xmm7, xmm7, xmm6
    vaddsd xmm2, xmm7, xmm4
    vaddsd xmm4, xmm5, xmm2
    vsubsd xmm7, xmm4, xmm5
    vsubsd xmm7, xmm2, xmm7
    vsubsd xmm2, xmm7, xmm27
    vaddsd xmm7, xmm4, xmm2
    vsubsd xmm5, xmm7, xmm4
    vsubsd xmm5, xmm2, xmm5
    vaddsd xmm2, xmm24, xmm7
    vsubsd xmm4, xmm2, xmm24
    vsubsd xmm4, xmm7, xmm4
    vsubsd xmm7, xmm5, xmm27
    vaddsd xmm5, xmm4, xmm7
    vaddsd xmm7, xmm2, xmm5
    vsubsd xmm4, xmm7, xmm2
    vsubsd xmm4, xmm5, xmm4
    vsubsd xmm5, xmm4, xmm27
    vaddsd xmm4, xmm7, xmm5
    vsubsd xmm2, xmm4, xmm7
    vsubsd xmm2, xmm5, xmm2
    vmovsd xmm5, [c_p5h]
    vmovsd xmm7, [c_p5l]
    vmulsd xmm3, xmm5, xmm4
    vmulsd xmm6, xmm7, xmm4
    vfmadd231sd xmm6, xmm5, xmm2
    vfmsub213sd xmm5, xmm4, xmm3
    vaddsd xmm5, xmm5, xmm6
    vaddsd xmm0, xmm3, xmm5
    vsubsd xmm1, xmm0, xmm3
    vsubsd xmm1, xmm5, xmm1
    vbroadcastsd zmm6, [c_e5]
    vsqrtsd xmm2, xmm25, xmm25
    vunpcklpd xmm2, xmm2, xmm25
    vmovupd xmm4, [xav_gr + P_TSQR]
    vdivpd xmm4, xmm4, xmm2
    vmovupd [r15 + G_dsn], xmm4
    vmovsd [r15 + G_esn], xmm4
    vmovhpd [r15 + G_eta], xmm4
    vmulpd xmm5, xmm4, xmm6
    vcvtpd2ps xmm5, xmm5
    vmovlps [r15 + G_lsn], xmm5
    vmovlps [r15 + G_csn], xmm5
    vpbroadcastd ymm4, [rsp + 272]
    vpaddd ymm4, ymm4, [g5i_x02]
    vcvtdq2pd zmm4, ymm4
    vmulpd zmm4, zmm4, [c_u24]{1to8}
    vbroadcastsd zmm5, xmm26
    vsubpd zmm5, zmm5, zmm4
    vdivpd zmm4, zmm4, zmm5
    vbroadcastsd zmm7, [c_e6]
    vmulpd zmm4, zmm4, zmm7
    vaddpd zmm4, zmm4, [g5i_rh]
    vmulpd zmm5, zmm4, zmm7
    vmovapd zmm3, [g5i_f2e]
    knotb k7, k2
    kshiftrb k4, k7, 2
    kshiftrb k5, k4, 3
    vmulpd zmm5, zmm5, zmm3
    vmovupd [r15 + G_drg], ymm5
    vextractf64x4 [r15 + G_erg], zmm5, 1
    vmulpd zmm8, zmm4, zmm6
    vmulpd zmm8, zmm8, zmm3
    vcvtpd2ps ymm8, zmm8
    vmovdqa32 zmm9, [g5i_rgi]
    vpermi2ps zmm9, zmm8, [g5i_om]
    vmovss [r15 + G_crg], xmm9
    vmovups [r15 + G_lrg - 4]{k7}, ymm9
    vextractf32x8 ymm9, zmm9, 1
    vmovups [r15 + G_crg + 4]{k4}, ymm9
    mov eax, [rsp + 276]
    vmovupd xmm5, [abs g5i_rt + rax]
    vmovupd [r15 + G_dlo], xmm5
    vmovsd xmm7, [abs g5i_rt + rax + 16]
    vmovsd [r15 + G_elo], xmm7
    vmovupd ymm8, [abs g5i_rt + rax + 24]
    vmovupd [r15 + G_ehi - 8]{k5}, ymm8
    vmovss xmm9, [abs g5i_rt + rax + 48]
    vmovss [r15 + G_lsl], xmm9
    vmovsd xmm10, [abs g5i_rt + rax + 52]
    vmovsd [r15 + G_csb], xmm10
    call dxp
    vmovupd zmm2, [t_emc0]
    vmovsd xmm7, [t_emc8]
    vbroadcastsd zmm4, xmm0
    vmulpd zmm3, zmm2, zmm4
    vmulsd xmm5, xmm7, xmm0
    vdivsd xmm6, xmm0, [c_osig]
    vbroadcastsd zmm8, xmm6
    vmulpd zmm2, zmm2, zmm8
    vmulsd xmm6, xmm7, xmm6
    vmovupd [r15 + G_dmx], xmm3
    vextractf64x2 xmm4, zmm3, 1
    vmovsd [r15 + G_dmx + 16], xmm4
    valignq zmm3, zmm5, zmm3, 2
    kshiftlb k6, k4, 1
    vmovupd [r15 + G_emx - 8]{k6}, zmm3
    vcvtpd2ps ymm2, zmm2
    vcvtsd2ss xmm6, xmm6, xmm6
    vmovups [r15 + G_lmx]{k5}, xmm2
    valignd ymm2, ymm6, ymm2, 3
    vmovups [r15 + G_cmx]{k4}, ymm2
    dec r13d
    jz .tz
    vpbroadcastq zmm16, rbx
    knotb k2, k2
    mov rdx, r15
    vmovdqa64 zmm0, [r15 + 320]
    vmovdqa64 zmm1, [r15 + 384]
    vmovdqa64 zmm2, [r15 + 448]
    vmovdqa64 zmm3, [r15 + 512]
    vmovdqa64 zmm4, [r15 + 576]
    vmovdqa64 zmm5, [r15 + 640]
    vmovdqa64 zmm6, [r15 + 704]
    vmovdqa64 zmm7, [r15 + 768]
    vmovdqa64 zmm8, [r15 + 832]
    vmovdqa64 zmm9, [r15 + 896]
    vmovdqa64 zmm10, [r15 + 960]
    vmovdqa64 zmm11, [r15 + 1024]
.th:
    add rdx, rbx
    vpaddq zmm30{k2}, zmm30, zmm16
    vmovdqa64 [rdx + 64], zmm28
    vmovdqa64 [rdx + 128], zmm29
    vmovdqa64 [rdx + 192], zmm30
    vmovdqa64 [rdx + 256], zmm31
    vmovdqa64 [rdx + 320], zmm0
    vmovdqa64 [rdx + 384], zmm1
    vmovdqa64 [rdx + 448], zmm2
    vmovdqa64 [rdx + 512], zmm3
    vmovdqa64 [rdx + 576], zmm4
    vmovdqa64 [rdx + 640], zmm5
    vmovdqa64 [rdx + 704], zmm6
    vmovdqa64 [rdx + 768], zmm7
    vmovdqa64 [rdx + 832], zmm8
    vmovdqa64 [rdx + 896], zmm9
    vmovdqa64 [rdx + 960], zmm10
    vmovdqa64 [rdx + 1024], zmm11
    dec r13d
    jnz .th
.tz:
    mov rsp, [rsp + 256]
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    ret
dxp:
    vmovsd xmm12, [c_ln2]
    vdivsd xmm8, xmm0, xmm12
    vroundsd xmm9, xmm8, xmm8, 11
    vsubsd xmm10, xmm8, xmm9
    vandpd xmm10, xmm10, [c_abs]
    vcmpsd xmm10, xmm10, [c_half], 13
    vandpd xmm11, xmm8, xmm27
    vorpd xmm11, xmm11, xmm26
    vandpd xmm11, xmm11, xmm10
    vaddsd xmm23, xmm9, xmm11
    vmovsd xmm10, [c_ln2l]
    vmulsd xmm8, xmm12, xmm23
    vmulsd xmm11, xmm10, xmm23
    vfmsub213sd xmm12, xmm23, xmm8
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm11, xmm8, xmm12
    vsubsd xmm14, xmm11, xmm8
    vsubsd xmm14, xmm12, xmm14
    vxorpd xmm8, xmm11, xmm27
    vxorpd xmm15, xmm14, xmm27
    vaddsd xmm12, xmm0, xmm8
    vaddsd xmm8, xmm1, xmm15
    vsubsd xmm10, xmm8, xmm1
    vsubsd xmm9, xmm8, xmm10
    vsubsd xmm9, xmm1, xmm9
    vsubsd xmm10, xmm15, xmm10
    vaddsd xmm9, xmm9, xmm10
    vsubsd xmm15, xmm8, xmm27
    vaddsd xmm8, xmm12, xmm15
    vsubsd xmm10, xmm8, xmm12
    vsubsd xmm10, xmm15, xmm10
    vaddsd xmm15, xmm10, xmm9
    vaddsd xmm9, xmm8, xmm15
    vsubsd xmm10, xmm9, xmm8
    vsubsd xmm10, xmm15, xmm10
    vmovsd xmm15, [c_k10]
    vmulsd xmm8, xmm9, xmm15
    vmulsd xmm12, xmm10, xmm15
    vfmsub213sd xmm9, xmm15, xmm8
    vaddsd xmm9, xmm9, xmm12
    vaddsd xmm6, xmm8, xmm9
    vsubsd xmm7, xmm6, xmm8
    vsubsd xmm7, xmm9, xmm7
    vaddsd xmm0, xmm26, xmm6
    vsubsd xmm1, xmm0, xmm26
    vsubsd xmm1, xmm6, xmm1
    vsubsd xmm8, xmm7, xmm27
    vaddsd xmm9, xmm1, xmm8
    vaddsd xmm8, xmm0, xmm9
    vsubsd xmm1, xmm8, xmm0
    vsubsd xmm1, xmm9, xmm1
    vsubsd xmm9, xmm1, xmm27
    vaddsd xmm2, xmm8, xmm9
    vsubsd xmm3, xmm2, xmm8
    vsubsd xmm3, xmm9, xmm3
    vmovapd xmm4, xmm6
    vmovapd xmm5, xmm7
    vaddsd xmm13, xmm26, xmm26
    mov ecx, 12
.xt:
    vmulsd xmm0, xmm4, xmm6
    vmulsd xmm1, xmm5, xmm6
    vfmadd231sd xmm1, xmm4, xmm7
    vfmsub213sd xmm4, xmm6, xmm0
    vaddsd xmm4, xmm4, xmm1
    vaddsd xmm1, xmm0, xmm4
    vsubsd xmm8, xmm1, xmm0
    vsubsd xmm8, xmm4, xmm8
    vdivsd xmm0, xmm1, xmm13
    vxorpd xmm9, xmm0, xmm27
    vmulsd xmm10, xmm13, xmm9
    vfmsub213sd xmm9, xmm13, xmm10
    vaddsd xmm11, xmm1, xmm10
    vaddsd xmm10, xmm8, xmm9
    vsubsd xmm1, xmm10, xmm8
    vsubsd xmm12, xmm10, xmm1
    vsubsd xmm12, xmm8, xmm12
    vsubsd xmm1, xmm9, xmm1
    vaddsd xmm12, xmm12, xmm1
    vaddsd xmm9, xmm11, xmm10
    vsubsd xmm8, xmm9, xmm11
    vsubsd xmm8, xmm10, xmm8
    vaddsd xmm10, xmm8, xmm12
    vaddsd xmm12, xmm9, xmm10
    vsubsd xmm8, xmm12, xmm9
    vsubsd xmm8, xmm10, xmm8
    vdivsd xmm10, xmm12, xmm13
    vaddsd xmm9, xmm0, xmm10
    vsubsd xmm11, xmm9, xmm0
    vsubsd xmm11, xmm10, xmm11
    vxorpd xmm0, xmm10, xmm27
    vmulsd xmm10, xmm13, xmm0
    vfmsub213sd xmm0, xmm13, xmm10
    vaddsd xmm1, xmm12, xmm10
    vaddsd xmm10, xmm8, xmm0
    vsubsd xmm12, xmm10, xmm8
    vsubsd xmm14, xmm10, xmm12
    vsubsd xmm14, xmm8, xmm14
    vsubsd xmm12, xmm0, xmm12
    vaddsd xmm14, xmm14, xmm12
    vaddsd xmm0, xmm1, xmm10
    vsubsd xmm8, xmm0, xmm1
    vsubsd xmm8, xmm10, xmm8
    vaddsd xmm10, xmm8, xmm14
    vaddsd xmm14, xmm0, xmm10
    vdivsd xmm10, xmm14, xmm13
    vaddsd xmm14, xmm9, xmm10
    vsubsd xmm0, xmm14, xmm9
    vsubsd xmm0, xmm10, xmm0
    vsubsd xmm10, xmm11, xmm27
    vaddsd xmm11, xmm0, xmm10
    vaddsd xmm10, xmm14, xmm11
    vsubsd xmm0, xmm10, xmm14
    vsubsd xmm0, xmm11, xmm0
    vsubsd xmm11, xmm0, xmm27
    vaddsd xmm4, xmm10, xmm11
    vsubsd xmm5, xmm4, xmm10
    vsubsd xmm5, xmm11, xmm5
    vaddsd xmm0, xmm2, xmm4
    vsubsd xmm1, xmm0, xmm2
    vsubsd xmm1, xmm4, xmm1
    vaddsd xmm8, xmm3, xmm5
    vsubsd xmm9, xmm8, xmm3
    vsubsd xmm10, xmm8, xmm9
    vsubsd xmm10, xmm3, xmm10
    vsubsd xmm9, xmm5, xmm9
    vaddsd xmm10, xmm10, xmm9
    vaddsd xmm9, xmm1, xmm8
    vaddsd xmm8, xmm0, xmm9
    vsubsd xmm1, xmm8, xmm0
    vsubsd xmm1, xmm9, xmm1
    vaddsd xmm9, xmm1, xmm10
    vaddsd xmm2, xmm8, xmm9
    vsubsd xmm3, xmm2, xmm8
    vsubsd xmm3, xmm9, xmm3
    vaddsd xmm13, xmm13, xmm26
    dec ecx
    jnz .xt
    mov ecx, 5
.xq:
    vmulsd xmm8, xmm2, xmm2
    vmulsd xmm9, xmm3, xmm2
    vfmadd231sd xmm9, xmm2, xmm3
    vfmsub213sd xmm2, xmm2, xmm8
    vaddsd xmm2, xmm2, xmm9
    vaddsd xmm3, xmm8, xmm2
    vsubsd xmm8, xmm3, xmm8
    vsubsd xmm2, xmm2, xmm8
    vmulsd xmm8, xmm3, xmm3
    vmulsd xmm9, xmm2, xmm3
    vfmadd231sd xmm9, xmm3, xmm2
    vfmsub213sd xmm3, xmm3, xmm8
    vaddsd xmm3, xmm3, xmm9
    vaddsd xmm2, xmm8, xmm3
    vsubsd xmm8, xmm2, xmm8
    vsubsd xmm3, xmm3, xmm8
    dec ecx
    jnz .xq
    vscalefsd xmm0, xmm2, xmm23
    vscalefsd xmm1, xmm3, xmm23
    ret
section .note.GNU-stack noalloc noexec nowrite progbits
