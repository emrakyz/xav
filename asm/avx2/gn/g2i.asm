default rel
%include "g2o.inc"
extern xav_gr
%include "g2img.inc"
extern xav_g2_2_2_1
extern xav_g2_2_2_2
extern xav_g2_2_3_2
extern xav_g2_0_2_1
extern xav_g2_0_2_2
extern xav_g2_0_3_2
extern xav_g2_0_3_3
extern xav_g2_0_4_2
extern xav_g2_0_4_3
extern xav_g2_0_4_4
extern xav_g2_0_5_3
extern xav_g2_0_5_4
extern xav_g2_0_5_5
extern xav_g2_0_6_4
extern xav_g2_0_6_5
extern xav_g2_0_6_6
extern xav_g2_0_7_5
extern xav_g2_0_7_6
extern xav_g2_0_7_7
extern xav_g2_0_8_6
extern xav_g2_0_8_7
extern xav_g2_0_8_8
extern xav_g2_0_9_7
extern xav_g2_0_9_8
extern xav_g2_0_10_8
extern xav_g2_0_10_9
extern xav_g2_0_11_9
extern xav_g2_0_11_10
extern xav_g2_0_12_9
extern xav_g2_0_12_10
extern xav_g2_0_12_11
extern xav_g2_0_13_10
extern xav_g2_0_13_11
extern xav_g2_0_13_12
extern xav_g2_0_14_11
extern xav_g2_0_14_12
extern xav_g2_0_14_13
extern xav_g2_0_15_12
extern xav_g2_0_15_13
extern xav_g2_0_15_14
extern xav_g2_0_16_13
extern xav_g2l
extern xav_amap
section .rodata align=64
g2i_iota: dd 0, 1, 2, 3, 4, 5, 6, 7
g2i_k75h: dd 0, 0, 0, 0, 0xbcc00000, 0x3e680000, 0x3f5e0000, 0xbd900000
g2i_k25h: dd 0, 0, 0, 0, 0xbd900000, 0x3f5e0000, 0x3e680000, 0xbcc00000
g2i_rn: dq 0x3ff0000000000000, 0x3ff0000000000000, 0x3fd0000000000000, 0x3fd0000000000000
g2i_rh: dq 0x3e91d70a580c9f4a, 0x3e91d70a580c9f4a, 0x3e9b70a42375da9b, 0x3e9b70a42375da9b
g2i_sgn: dd -1, 1, -1, 1
g2i_q4: dd 0, 1, 2, 3
g2i_u24p: dq 0x3e70000000000000, 0x3e70000000000000
g2c_absm: dq 0x7fffffffffffffff
g2c_m52: dq 0x4330000000000000
g2c_m52e: dq 0x43300000000003ff
g2c_mnt: dq 0x000fffffffffffff
g2c_mz: dq 0x8000000000000000
g2c_one: dq 0x3ff0000000000000
g2c_half: dq 0x3fe0000000000000
g2c_ln2: dq 0x3fe62e42fefa39ef
g2c_ln2l: dq 0x3c7abc9e3b39803f
g2c_i1024: dq 0x3f50000000000000
g2c_lsig: dq 0x3eec46e400000000
g2c_k32: dq 0x3f34f8b588e368f1
g2c_osig: dq 0x3ff41ac160000000
g2c_c6: dq 0x3ff000010c6f7a0b
g2c_c5: dq 0x3ff0000a7c5ac472
g2c_rsf: dq 0x3ff001401e02d044
g2c_mone: dq 0xbff0000000000000
g2c_c512h: dq 0x3fdaaaaaaaaaaaab
g2c_c512l: dq 0xbc75555555555555
g2c_lnc: dq 0x3ff0000000000000, 0x3fd5555555555555, 0x3fc999999999999a, 0x3fc2492492492492, 0x3fbc71c71c71c71c, 0x3fb745d1745d1746, 0x3fb3b13b13b13b14, 0x3fb1111111111111, 0x3fae1e1e1e1e1e1e, 0x3faaf286bca1af28, 0x3fa8618618618618, 0x3fa642c8590b2164, 0x3fa47ae147ae147b, 0x3fa2f684bda12f68, 0x3fa1a7b9611a7b96, 0x3fa0842108421084, 0x3f9f07c1f07c1f08, 0x3f9d41d41d41d41d, 0x3f9bacf914c1bad0, 0x3f9a41a41a41a41a, 0x3f98f9c18f9c18fa
g2i_f1: dd 0x3f800000
g2i_fq: dd 0x3e800000
g2i_f16: dd 0x41800000
g2i_c7: dd 7
g2i_c15: dd 15
g2i_msb: dd 0x80000000
g2i_one32: dd 1
g2i_two32: dd 2
g2i_three32: dd 3
g2i_om2: dd 0x3483a5a5
g2i_om3: dd 0x34a3a5ba
g2i_om4: dd 0x34c3a5cf
align 64
g2i_rt:
    dd 0x3786d510, 0x3786d510, 0x3786d510, 0x3786d510, 0x3786d510, 0x3786d510, 0x3786d510, 0x3786d510
    dd 0x37814176, 0x37814176, 0x37814176, 0x37814176, 0x37814176, 0x37814176, 0x37814176, 0x37814176
    dd 0x37b78fd4, 0x37b78fd4, 0x37b78fd4, 0x37b78fd4, 0x37b78fd4, 0x37b78fd4, 0x37b78fd4, 0x37b78fd4
    dq 0x404fffff792922a4, 0x404fffff792922a4, 0x404fffff792922a4, 0x404fffff792922a4
    dq 0x40500000436b6eae, 0x40500000436b6eae, 0x40500000436b6eae, 0x40500000436b6eae
    dq 0x407fffffefd79720, 0x407fffffefd79720, 0x407fffffefd79720, 0x407fffffefd79720
    dq 0x407fffffe90dcfd6, 0x407fffffe90dcfd6, 0x407fffffe90dcfd6, 0x407fffffe90dcfd6
    dq 0x4080000008143470, 0x4080000008143470, 0x4080000008143470, 0x4080000008143470
    dq 0x408000000b791815, 0x408000000b791815, 0x408000000b791815, 0x408000000b791815
    times 736 db 0
    dd 0x3749b4d8, 0x3749b4d8, 0x3749b4d8, 0x3749b4d8, 0x3749b4d8, 0x3749b4d8, 0x3749b4d8, 0x3749b4d8
    dd 0x36eee7d6, 0x36eee7d6, 0x36eee7d6, 0x36eee7d6, 0x36eee7d6, 0x36eee7d6, 0x36eee7d6, 0x36eee7d6
    dd 0x37497095, 0x37497095, 0x37497095, 0x37497095, 0x37497095, 0x37497095, 0x37497095, 0x37497095
    dq 0xbee93713eba54b1e, 0xbee93713eba54b1e, 0xbee93713eba54b1e, 0xbee93713eba54b1e
    dq 0x3ee93713eba54b1e, 0x3ee93713eba54b1e, 0x3ee93713eba54b1e, 0x3ee93713eba54b1e
    dq 0x407ffffff888817d, 0x407ffffff888817d, 0x407ffffff888817d, 0x407ffffff888817d
    dq 0x407ffffff368ba34, 0x407ffffff368ba34, 0x407ffffff368ba34, 0x407ffffff368ba34
    dq 0x4080000003bbbf41, 0x4080000003bbbf41, 0x4080000003bbbf41, 0x4080000003bbbf41
    dq 0x40800000064ba2e6, 0x40800000064ba2e6, 0x40800000064ba2e6, 0x40800000064ba2e6
    times 736 db 0
    dd 0x374a4cb8, 0x374a4cb8, 0x374a4cb8, 0x374a4cb8, 0x374a4cb8, 0x374a4cb8, 0x374a4cb8, 0x374a4cb8
    dd 0x36ef9bb8, 0x36ef9bb8, 0x36ef9bb8, 0x36ef9bb8, 0x36ef9bb8, 0x36ef9bb8, 0x36ef9bb8, 0x36ef9bb8
    dd 0x374a0841, 0x374a0841, 0x374a0841, 0x374a0841, 0x374a0841, 0x374a0841, 0x374a0841, 0x374a0841
    dq 0xbee94a0fcf657fda, 0xbee94a0fcf657fda, 0xbee94a0fcf657fda, 0xbee94a0fcf657fda
    dq 0x3ee94a0fcf657fda, 0x3ee94a0fcf657fda, 0x3ee94a0fcf657fda, 0x3ee94a0fcf657fda
    dq 0x407ffffff882e273, 0x407ffffff882e273, 0x407ffffff882e273, 0x407ffffff882e273
    dq 0x407ffffff35f3f79, 0x407ffffff35f3f79, 0x407ffffff35f3f79, 0x407ffffff35f3f79
    dq 0x4080000003be8ec7, 0x4080000003be8ec7, 0x4080000003be8ec7, 0x4080000003be8ec7
    dq 0x4080000006506044, 0x4080000006506044, 0x4080000006506044, 0x4080000006506044
    times 736 db 0
align 16
g2kp:
    dq xav_g2_2_2_1
    dw 216, 216
    db 24, 2, 1, 0
    dq xav_g2_2_2_2
    dw 240, 248
    db 24, 2, 1, 0
    dq xav_g2_2_3_2
    dw 176, 184
    db 16, 3, 1, 0
    dq xav_g2_2_2_2
    dw 240, 248
    db 20, 2, 1, 0
    dq xav_g2_2_3_2
    dw 208, 216
    db 16, 3, 1, 0
    dq xav_g2_2_3_2
    dw 224, 232
    db 16, 3, 1, 0
    dq xav_g2_2_3_2
    dw 240, 248
    db 16, 3, 1, 0
    dq 0, 0
    dq xav_g2_0_2_1
    dw 136, 136
    db 8, 2, 1, 8
    dq xav_g2_0_2_1
    dw 216, 216
    db 12, 2, 1, 9
    dq xav_g2_0_3_2
    dw 152, 160
    db 8, 3, 1, 9
    dq xav_g2_0_2_2
    dw 240, 248
    db 12, 2, 1, 10
    dq xav_g2_0_3_2
    dw 168, 176
    db 8, 3, 1, 10
    dq xav_g2_0_3_2
    dw 176, 184
    db 8, 3, 1, 11
    dq xav_g2_0_3_2
    dw 184, 192
    db 8, 3, 1, 11
    dq xav_g2_0_2_2
    dw 240, 248
    db 10, 2, 1, 12
    dq xav_g2_0_3_2
    dw 200, 208
    db 8, 3, 1, 12
    dq xav_g2_0_3_2
    dw 208, 216
    db 8, 3, 1, 13
    dq xav_g2_0_3_2
    dw 216, 224
    db 8, 3, 1, 13
    dq xav_g2_0_3_2
    dw 224, 232
    db 8, 3, 1, 14
    dq xav_g2_0_3_2
    dw 232, 240
    db 8, 3, 1, 14
    dq xav_g2_0_3_2
    dw 240, 248
    db 8, 3, 1, 15
    dq xav_g2_0_3_2
    dw 248, 256
    db 8, 3, 1, 15
    dq xav_g2_0_2_2
    dw 256, 264
    db 8, 2, 1, 16
    dq xav_g2_0_3_2
    dw 264, 272
    db 8, 3, 1, 16
    dq xav_g2_0_3_2
    dw 136, 144
    db 4, 3, 1, 17
    dq xav_g2_0_4_2
    dw 280, 288
    db 8, 4, 1, 17
    dq xav_g2_0_3_2
    dw 216, 216
    db 6, 3, 1, 18
    dq xav_g2_0_4_3
    dw 296, 304
    db 8, 4, 2, 18
    dq xav_g2_0_4_3
    dw 152, 160
    db 4, 4, 2, 19
    dq xav_g2_0_4_3
    dw 312, 320
    db 8, 4, 2, 19
    dq xav_g2_0_3_3
    dw 240, 248
    db 6, 3, 2, 20
    dq xav_g2_0_4_3
    dw 328, 336
    db 8, 4, 2, 20
    dq xav_g2_0_4_3
    dw 168, 176
    db 4, 4, 2, 21
    dq xav_g2_0_4_3
    dw 344, 352
    db 8, 4, 2, 21
    dq xav_g2_0_4_3
    dw 176, 184
    db 4, 4, 2, 22
    dq xav_g2_0_4_3
    dw 360, 368
    db 8, 4, 2, 22
    dq xav_g2_0_4_3
    dw 184, 192
    db 4, 4, 2, 23
    dq xav_g2_0_4_3
    dw 376, 384
    db 8, 4, 2, 23
    dq xav_g2_0_3_3
    dw 192, 200
    db 4, 3, 2, 24
    dq xav_g2_0_4_3
    dw 392, 400
    db 8, 4, 2, 24
    dq xav_g2_0_4_3
    dw 200, 208
    db 4, 4, 2, 25
    dq xav_g2_0_5_3
    dw 408, 416
    db 8, 5, 2, 25
    dq xav_g2_0_4_3
    dw 208, 216
    db 4, 4, 2, 26
    dq xav_g2_0_5_3
    dw 424, 432
    db 8, 5, 2, 26
    dq xav_g2_0_5_3
    dw 216, 224
    db 4, 5, 2, 27
    dq xav_g2_0_5_4
    dw 440, 448
    db 8, 5, 3, 27
    dq xav_g2_0_4_4
    dw 224, 232
    db 4, 4, 3, 28
    dq xav_g2_0_5_4
    dw 456, 464
    db 8, 5, 3, 28
    dq xav_g2_0_5_4
    dw 232, 240
    db 4, 5, 3, 29
    dq xav_g2_0_5_4
    dw 472, 480
    db 8, 5, 3, 29
    dq xav_g2_0_5_4
    dw 240, 248
    db 4, 5, 3, 30
    dq xav_g2_0_5_4
    dw 488, 496
    db 8, 5, 3, 30
    dq xav_g2_0_5_4
    dw 248, 256
    db 4, 5, 3, 31
    dq xav_g2_0_5_4
    dw 504, 512
    db 8, 5, 3, 31
    dq xav_g2_0_4_4
    dw 256, 264
    db 4, 4, 3, 32
    dq xav_g2_0_5_4
    dw 520, 528
    db 8, 5, 3, 32
    dq xav_g2_0_5_4
    dw 264, 272
    db 4, 5, 3, 33
    dq xav_g2_0_6_4
    dw 536, 544
    db 8, 6, 3, 33
    dq xav_g2_0_5_4
    dw 136, 144
    db 2, 5, 3, 34
    dq xav_g2_0_6_4
    dw 552, 560
    db 8, 6, 3, 34
    dq xav_g2_0_6_4
    dw 280, 288
    db 4, 6, 3, 35
    dq xav_g2_0_6_4
    dw 568, 576
    db 8, 6, 3, 35
    dq xav_g2_0_5_4
    dw 144, 144
    db 2, 5, 3, 36
    dq xav_g2_0_6_5
    dw 584, 592
    db 8, 6, 4, 36
    dq xav_g2_0_6_5
    dw 296, 304
    db 4, 6, 4, 37
    dq xav_g2_0_6_5
    dw 600, 608
    db 8, 6, 4, 37
    dq xav_g2_0_6_5
    dw 152, 160
    db 2, 6, 4, 38
    dq xav_g2_0_6_5
    dw 616, 624
    db 8, 6, 4, 38
    dq xav_g2_0_6_5
    dw 312, 320
    db 4, 6, 4, 39
    dq xav_g2_0_6_5
    dw 632, 640
    db 8, 6, 4, 39
    dq xav_g2_0_5_5
    dw 160, 168
    db 2, 5, 4, 40
    dq xav_g2_0_6_5
    dw 648, 656
    db 8, 6, 4, 40
    dq xav_g2_0_6_5
    dw 328, 336
    db 4, 6, 4, 41
    dq xav_g2_0_7_5
    dw 664, 672
    db 8, 7, 4, 41
    dq xav_g2_0_6_5
    dw 168, 176
    db 2, 6, 4, 42
    dq xav_g2_0_7_5
    dw 680, 688
    db 8, 7, 4, 42
    dq xav_g2_0_7_5
    dw 344, 352
    db 4, 7, 4, 43
    dq xav_g2_0_7_5
    dw 696, 704
    db 8, 7, 4, 43
    dq xav_g2_0_6_5
    dw 176, 184
    db 2, 6, 4, 44
    dq xav_g2_0_7_5
    dw 712, 720
    db 8, 7, 4, 44
    dq xav_g2_0_7_5
    dw 360, 368
    db 4, 7, 4, 45
    dq xav_g2_0_7_6
    dw 728, 736
    db 8, 7, 5, 45
    dq xav_g2_0_7_6
    dw 184, 192
    db 2, 7, 5, 46
    dq xav_g2_0_7_6
    dw 744, 752
    db 8, 7, 5, 46
    dq xav_g2_0_7_6
    dw 376, 384
    db 4, 7, 5, 47
    dq xav_g2_0_7_6
    dw 760, 768
    db 8, 7, 5, 47
    dq xav_g2_0_6_6
    dw 192, 200
    db 2, 6, 5, 48
    dq xav_g2_0_7_6
    dw 776, 784
    db 8, 7, 5, 48
    dq xav_g2_0_7_6
    dw 392, 400
    db 4, 7, 5, 49
    dq xav_g2_0_8_6
    dw 792, 800
    db 8, 8, 5, 49
    dq xav_g2_0_7_6
    dw 200, 208
    db 2, 7, 5, 50
    dq xav_g2_0_8_6
    dw 808, 816
    db 8, 8, 5, 50
    dq xav_g2_0_8_6
    dw 408, 416
    db 4, 8, 5, 51
    dq xav_g2_0_8_6
    dw 824, 832
    db 8, 8, 5, 51
    dq xav_g2_0_7_6
    dw 208, 216
    db 2, 7, 5, 52
    dq xav_g2_0_8_6
    dw 840, 848
    db 8, 8, 5, 52
    dq xav_g2_0_8_6
    dw 424, 432
    db 4, 8, 5, 53
    dq xav_g2_0_8_6
    dw 856, 864
    db 8, 8, 5, 53
    dq xav_g2_0_8_6
    dw 216, 224
    db 2, 8, 5, 54
    dq xav_g2_0_8_7
    dw 872, 880
    db 8, 8, 6, 54
    dq xav_g2_0_8_7
    dw 440, 448
    db 4, 8, 6, 55
    dq xav_g2_0_8_7
    dw 888, 896
    db 8, 8, 6, 55
    dq xav_g2_0_7_7
    dw 224, 232
    db 2, 7, 6, 56
    dq xav_g2_0_8_7
    dw 904, 912
    db 8, 8, 6, 56
    dq xav_g2_0_8_7
    dw 456, 464
    db 4, 8, 6, 57
    dq xav_g2_0_9_7
    dw 920, 928
    db 8, 9, 6, 57
    dq xav_g2_0_8_7
    dw 232, 240
    db 2, 8, 6, 58
    dq xav_g2_0_9_7
    dw 936, 944
    db 8, 9, 6, 58
    dq xav_g2_0_9_7
    dw 472, 480
    db 4, 9, 6, 59
    dq xav_g2_0_9_7
    dw 952, 960
    db 8, 9, 6, 59
    dq xav_g2_0_8_7
    dw 240, 248
    db 2, 8, 6, 60
    dq xav_g2_0_9_7
    dw 968, 976
    db 8, 9, 6, 60
    dq xav_g2_0_9_7
    dw 488, 496
    db 4, 9, 6, 61
    dq xav_g2_0_9_7
    dw 984, 992
    db 8, 9, 6, 61
    dq xav_g2_0_9_7
    dw 248, 256
    db 2, 9, 6, 62
    dq xav_g2_0_9_7
    dw 1000, 1008
    db 8, 9, 6, 62
    dq xav_g2_0_9_7
    dw 504, 512
    db 4, 9, 6, 63
    dq xav_g2_0_9_8
    dw 1016, 1024
    db 8, 9, 7, 63
    dq xav_g2_0_8_8
    dw 256, 264
    db 2, 8, 7, 64
    dq xav_g2_0_9_8
    dw 1032, 1040
    db 8, 9, 7, 64
    dq xav_g2_0_9_8
    dw 520, 528
    db 4, 9, 7, 65
    dq xav_g2_0_10_8
    dw 1048, 1056
    db 8, 10, 7, 65
    dq xav_g2_0_9_8
    dw 264, 272
    db 2, 9, 7, 66
    dq xav_g2_0_10_8
    dw 1064, 1072
    db 8, 10, 7, 66
    dq xav_g2_0_10_8
    dw 536, 544
    db 4, 10, 7, 67
    dq xav_g2_0_10_8
    dw 1080, 1088
    db 8, 10, 7, 67
    dq xav_g2_0_9_8
    dw 272, 280
    db 2, 9, 7, 68
    dq xav_g2_0_10_8
    dw 1096, 1104
    db 8, 10, 7, 68
    dq xav_g2_0_10_8
    dw 552, 560
    db 4, 10, 7, 69
    dq xav_g2_0_10_8
    dw 1112, 1120
    db 8, 10, 7, 69
    dq xav_g2_0_10_8
    dw 280, 288
    db 2, 10, 7, 70
    dq xav_g2_0_10_8
    dw 1128, 1136
    db 8, 10, 7, 70
    dq xav_g2_0_10_8
    dw 568, 576
    db 4, 10, 7, 71
    dq xav_g2_0_10_8
    dw 1144, 1152
    db 8, 10, 7, 71
    dq xav_g2_0_9_8
    dw 288, 288
    db 2, 9, 7, 72
    dq xav_g2_0_10_8
    dw 1160, 1160
    db 8, 10, 7, 72
    dq xav_g2_0_10_8
    dw 584, 584
    db 4, 10, 7, 73
    dq xav_g2_0_11_9
    dw 1176, 1184
    db 8, 11, 8, 73
    dq xav_g2_0_10_9
    dw 296, 304
    db 2, 10, 8, 74
    dq xav_g2_0_11_9
    dw 1192, 1200
    db 8, 11, 8, 74
    dq xav_g2_0_11_9
    dw 600, 608
    db 4, 11, 8, 75
    dq xav_g2_0_11_9
    dw 1208, 1216
    db 8, 11, 8, 75
    dq xav_g2_0_10_9
    dw 304, 312
    db 2, 10, 8, 76
    dq xav_g2_0_11_9
    dw 1224, 1232
    db 8, 11, 8, 76
    dq xav_g2_0_11_9
    dw 616, 624
    db 4, 11, 8, 77
    dq xav_g2_0_11_9
    dw 1240, 1248
    db 8, 11, 8, 77
    dq xav_g2_0_11_9
    dw 312, 320
    db 2, 11, 8, 78
    dq xav_g2_0_11_9
    dw 1256, 1264
    db 8, 11, 8, 78
    dq xav_g2_0_11_9
    dw 632, 640
    db 4, 11, 8, 79
    dq xav_g2_0_11_9
    dw 1272, 1280
    db 8, 11, 8, 79
    dq xav_g2_0_10_9
    dw 320, 328
    db 2, 10, 8, 80
    dq xav_g2_0_11_9
    dw 1288, 1296
    db 8, 11, 8, 80
    dq xav_g2_0_11_9
    dw 648, 656
    db 4, 11, 8, 81
    dq xav_g2_0_12_9
    dw 1304, 1312
    db 8, 12, 8, 81
    dq xav_g2_0_11_9
    dw 328, 328
    db 2, 11, 8, 82
    dq xav_g2_0_12_10
    dw 1320, 1328
    db 8, 12, 9, 82
    dq xav_g2_0_12_10
    dw 664, 672
    db 4, 12, 9, 83
    dq xav_g2_0_12_10
    dw 1336, 1344
    db 8, 12, 9, 83
    dq xav_g2_0_11_10
    dw 336, 344
    db 2, 11, 9, 84
    dq xav_g2_0_12_10
    dw 1352, 1360
    db 8, 12, 9, 84
    dq xav_g2_0_12_10
    dw 680, 688
    db 4, 12, 9, 85
    dq xav_g2_0_12_10
    dw 1368, 1376
    db 8, 12, 9, 85
    dq xav_g2_0_12_10
    dw 344, 352
    db 2, 12, 9, 86
    dq xav_g2_0_12_10
    dw 1384, 1392
    db 8, 12, 9, 86
    dq xav_g2_0_12_10
    dw 696, 704
    db 4, 12, 9, 87
    dq xav_g2_0_12_10
    dw 1400, 1408
    db 8, 12, 9, 87
    dq xav_g2_0_11_10
    dw 352, 360
    db 2, 11, 9, 88
    dq xav_g2_0_12_10
    dw 1416, 1424
    db 8, 12, 9, 88
    dq xav_g2_0_12_10
    dw 712, 720
    db 4, 12, 9, 89
    dq xav_g2_0_13_10
    dw 1432, 1440
    db 8, 13, 9, 89
    dq xav_g2_0_12_10
    dw 360, 368
    db 2, 12, 9, 90
    dq xav_g2_0_13_10
    dw 1448, 1456
    db 8, 13, 9, 90
    dq xav_g2_0_13_10
    dw 728, 736
    db 4, 13, 9, 91
    dq xav_g2_0_13_11
    dw 1464, 1472
    db 8, 13, 10, 91
    dq xav_g2_0_12_11
    dw 368, 376
    db 2, 12, 10, 92
    dq xav_g2_0_13_11
    dw 1480, 1488
    db 8, 13, 10, 92
    dq xav_g2_0_13_11
    dw 744, 752
    db 4, 13, 10, 93
    dq xav_g2_0_13_11
    dw 1496, 1504
    db 8, 13, 10, 93
    dq xav_g2_0_13_11
    dw 376, 384
    db 2, 13, 10, 94
    dq xav_g2_0_13_11
    dw 1512, 1520
    db 8, 13, 10, 94
    dq xav_g2_0_13_11
    dw 760, 768
    db 4, 13, 10, 95
    dq xav_g2_0_13_11
    dw 1528, 1536
    db 8, 13, 10, 95
    dq xav_g2_0_12_11
    dw 384, 392
    db 2, 12, 10, 96
    dq xav_g2_0_13_11
    dw 1544, 1552
    db 8, 13, 10, 96
    dq xav_g2_0_13_11
    dw 776, 784
    db 4, 13, 10, 97
    dq xav_g2_0_14_11
    dw 1560, 1568
    db 8, 14, 10, 97
    dq xav_g2_0_13_11
    dw 392, 400
    db 2, 13, 10, 98
    dq xav_g2_0_14_11
    dw 1576, 1584
    db 8, 14, 10, 98
    dq xav_g2_0_14_11
    dw 792, 800
    db 4, 14, 10, 99
    dq xav_g2_0_14_11
    dw 1592, 1600
    db 8, 14, 10, 99
    dq xav_g2_0_13_11
    dw 400, 400
    db 2, 13, 10, 100
    dq xav_g2_0_14_12
    dw 1608, 1616
    db 8, 14, 11, 100
    dq xav_g2_0_14_12
    dw 808, 816
    db 4, 14, 11, 101
    dq xav_g2_0_14_12
    dw 1624, 1632
    db 8, 14, 11, 101
    dq xav_g2_0_14_12
    dw 408, 416
    db 2, 14, 11, 102
    dq xav_g2_0_14_12
    dw 1640, 1648
    db 8, 14, 11, 102
    dq xav_g2_0_14_12
    dw 824, 832
    db 4, 14, 11, 103
    dq xav_g2_0_14_12
    dw 1656, 1664
    db 8, 14, 11, 103
    dq xav_g2_0_13_12
    dw 416, 424
    db 2, 13, 11, 104
    dq xav_g2_0_14_12
    dw 1672, 1680
    db 8, 14, 11, 104
    dq xav_g2_0_14_12
    dw 840, 848
    db 4, 14, 11, 105
    dq xav_g2_0_15_12
    dw 1688, 1696
    db 8, 15, 11, 105
    dq xav_g2_0_14_12
    dw 424, 432
    db 2, 14, 11, 106
    dq xav_g2_0_15_12
    dw 1704, 1712
    db 8, 15, 11, 106
    dq xav_g2_0_15_12
    dw 856, 864
    db 4, 15, 11, 107
    dq xav_g2_0_15_12
    dw 1720, 1728
    db 8, 15, 11, 107
    dq xav_g2_0_14_12
    dw 432, 440
    db 2, 14, 11, 108
    dq xav_g2_0_15_12
    dw 1736, 1744
    db 8, 15, 11, 108
    dq xav_g2_0_15_12
    dw 872, 880
    db 4, 15, 11, 109
    dq xav_g2_0_15_13
    dw 1752, 1760
    db 8, 15, 12, 109
    dq xav_g2_0_15_13
    dw 440, 448
    db 2, 15, 12, 110
    dq xav_g2_0_15_13
    dw 1768, 1776
    db 8, 15, 12, 110
    dq xav_g2_0_15_13
    dw 888, 896
    db 4, 15, 12, 111
    dq xav_g2_0_15_13
    dw 1784, 1792
    db 8, 15, 12, 111
    dq xav_g2_0_14_13
    dw 448, 456
    db 2, 14, 12, 112
    dq xav_g2_0_15_13
    dw 1800, 1808
    db 8, 15, 12, 112
    dq xav_g2_0_15_13
    dw 904, 912
    db 4, 15, 12, 113
    dq xav_g2_0_16_13
    dw 1816, 1824
    db 8, 16, 12, 113
    dq xav_g2_0_15_13
    dw 456, 464
    db 2, 15, 12, 114
    dq xav_g2_0_16_13
    dw 1832, 1840
    db 8, 16, 12, 114
    dq xav_g2_0_16_13
    dw 920, 928
    db 4, 16, 12, 115
    dq xav_g2_0_16_13
    dw 1848, 1856
    db 8, 16, 12, 115
    dq xav_g2_0_15_13
    dw 464, 472
    db 2, 15, 12, 116
    dq xav_g2_0_16_13
    dw 1864, 1872
    db 8, 16, 12, 116
    dq xav_g2_0_16_13
    dw 936, 944
    db 4, 16, 12, 117
    dq xav_g2_0_16_13
    dw 1880, 1888
    db 8, 16, 12, 117
    dq xav_g2_0_16_13
    dw 472, 480
    db 2, 16, 12, 118
    dq 0, 0
    dq 0, 0
    dq 0, 0
    dq xav_g2_0_15_14
    dw 480, 488
    db 2, 15, 13, 120
section .text
global xav_g2i
align 64
xav_g2i:
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15
    mov rax, rsp
    and rsp, -32
    sub rsp, 352
    mov [rsp + 288], rax
    mov r12, r9
    mov r13d, r8d
    shl ecx, 10
    lea rbx, [abs xav_g2l + rcx]
    vmovups xmm0, [r12 + 32]
    vmovaps [rsp], xmm0
    mov edi, edi
    mov esi, esi
    mov r10d, edx
    mov [rsp + G_wi - 64], rdi
    mov [rsp + G_hi - 64], rsi
    mov [rsp + G_wo - 64], r10
    mov eax, esi
    imul eax, r10d
    add eax, edi
    lea ecx, [rdi + rdi]
    xor edx, edx
    div ecx
    lea r11d, [rax + rax]
    mov [rsp + G_ho - 64], r11
    mov [r12 + 24], r11d
    mov ecx, r11d
    shr ecx, 1
    mov edx, r11d
    shl edx, 5
    mov [rsp + G_rd - 64], rdx
    mov qword [rsp + G_pd - 64], 0
    add r11d, esi
    shl r11d, 5
    mov [rsp + G_hx - 64], r11
    mov eax, esi
    xor edx, edx
    div ecx
    mov r8d, eax
    shr r8d, 1
    mov [rsp + 304], r8
    lea r9d, [rdx + rcx]
    test al, 1
    cmovz r9d, edx
    mov [rsp + 312], r9
    test edx, edx
    jnz .rz
    and eax, 1
    lea r9d, [r8 + rax*2 - 1]
    lea eax, [r8 + rax + 4]
    jmp .cn
.rz:
    mov r14d, eax
    mov r15d, edx
    mov eax, ecx
    xor edx, edx
    div r15d
    mov ebp, edx
    mov r9d, eax
    tzcnt edx, ecx
    shrx ecx, ecx, edx
    mov eax, r15d
    xor edx, edx
    div ecx
    neg edx
    lea eax, [r8 + 2]
    adc eax, 0
    test r14b, 1
    jnz .qo
    lea edx, [rbp + rbp]
    mov ecx, edx
    sub ecx, r15d
    cmovae edx, ecx
    cmp edx, 1
    sbb eax, 0
    mov r9d, eax
    lea eax, [r8 + 5]
    jmp .cn
.qo:
    mov ecx, r9d
    mov r9d, eax
    lea eax, [r8 + 5]
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
    lea eax, [rdi*8]
    xor edx, edx
    div r10d
    mov [rsp + G_gp - 64], rax
    add eax, eax
    mov rcx, [abs g2kp - 144 + rax*8]
    mov [r12], rcx
    movzx r8d, word [abs g2kp - 136 + rax*8]
    mov [rsp + G_sp - 64], r8
    movzx r15d, byte [abs g2kp - 132 + rax*8]
    mov [rsp + G_su - 64], r15
    movzx ecx, word [abs g2kp - 134 + rax*8]
    mov [rsp + G_spp - 64], rcx
    movzx ebp, word [abs g2kp - 131 + rax*8]
    movzx eax, byte [abs g2kp - 129 + rax*8]
    mov [rsp + G_hb - 64], rax
    movzx eax, bpl
    lea eax, [r9 + rax + 1]
    mov [rsp + 320], rax
    shr edi, 1
    mov [rsp + G_wc - 64], rdi
    lea eax, [rdi + 7]
    mov edx, eax
    shr edx, 3
    mov [rsp + G_nbc - 64], rdx
    and eax, 7
    vmovd xmm0, eax
    vpbroadcastd ymm0, xmm0
    vpminud ymm0, ymm0, [g2i_iota]
    vmovdqa [rsp + G_ri - 64], ymm0
    shl edx, 4
    mov r9d, edx
    lea eax, [r10 + 7]
    shr eax, 3
    lea eax, [rax + r15 - 1]
    xor edx, edx
    div r15d
    mov [rsp + G_nst - 64], rax
    imul eax, r8d
    cmp eax, r9d
    cmovb eax, r9d
    mov [rsp + G_wp - 64], rax
    mov edx, ebp
    shr edx, 8
    shl edx, 6
    add r11d, edx
    mov [rsp + G_hv - 64], r11
    movzx edx, bpl
    shl edx, 6
    add r11d, edx
    lea rdx, [r11 + GDS]
    mov [rsp + G_cr - 64], rdx
    lea r9d, [r14 + 1]
    imul r9d, eax
    lea rdx, [rdx + r9*8]
    mov [rsp + G_ct - 64], rdx
    add edi, 39
    shr edi, 3
    shl edi, 6
    add rdx, rdi
    mov [rsp + G_nx - 64], rdx
    add eax, 3
    shr eax, 2
    shl eax, 6
    add rdx, rax
    mov [rsp + G_sb2 - 64], rdx
    shl ecx, 5
    add rdx, rcx
    mov [rsp + G_zr - 64], rdx
    lea eax, [r8*4 + 63]
    and eax, -64
    add rdx, rax
    mov [rsp + G_eb - 64], rdx
    imul eax, r15d, 224
    add eax, 63
    and eax, -64
    add rdx, rax
    mov [rsp + G_cl - 64], rdx
    shl r15d, 6
    lea rdx, [rdx + r15*4]
    mov [rsp + G_cc - 64], rdx
    add rdx, r15
    mov [rsp + G_oc - 64], rdx
    sub rdx, -128
    mov [rsp + G_sg - 64], rdx
    imul eax, r8d, 36
    add rax, rdx
    mov [rsp + G_xb - 64], rax
    imul eax, r8d, 60
    add eax, 63
    and eax, -64
    add rdx, rax
    mov [rsp + G_fs - 64], rdx
    lea r15, [rdx + 409600]
    sub r15, r11
    mov [r12 + 16], r15
    mov rsi, r15
    imul rsi, r13
    add rsi, r11
    mov r14, r11
    call xav_amap
    add r14, rax
    mov [r12 + 8], r14
    vmovq xmm0, rax
    vpbroadcastq ymm0, xmm0
    vpxor xmm1, xmm1, xmm1
    vpblendd ymm2, ymm0, ymm1, 0x03
    vpblendd ymm3, ymm0, ymm1, 0xfc
    vmovdqa ymm4, [rsp]
    vmovdqa [r14 + 64], ymm4
    vpaddq ymm4, ymm2, [rsp + 32]
    vmovdqa [r14 + 96], ymm4
    vpaddq ymm4, ymm0, [rsp + 64]
    vmovdqa [r14 + 128], ymm4
    vpaddq ymm4, ymm0, [rsp + 96]
    vmovdqa [r14 + 160], ymm4
    vpaddq ymm4, ymm3, [rsp + 128]
    vmovdqa [r14 + 192], ymm4
    vmovdqa ymm4, [rsp + 160]
    vmovdqa [r14 + 224], ymm4
    vmovdqa ymm4, [rsp + 192]
    vmovdqa [r14 + 256], ymm4
    vpaddq ymm4, ymm0, [rsp + 224]
    vmovdqa [r14 + 288], ymm4
    vmovdqa ymm4, [rsp + 256]
    vmovdqa [r14 + 320], ymm4
    mov rdi, rax
    mov eax, [r14 + G_wi]
    mov ecx, [r14 + G_wo]
    mov r12d, [r14 + G_hi]
    mov r10d, [r14 + G_ho]
    vcvtsi2sd xmm1, xmm1, eax
    vcvtsi2sd xmm2, xmm2, ecx
    vcvtsi2sd xmm3, xmm3, r12d
    vcvtsi2sd xmm4, xmm4, r10d
    vmulsd xmm10, xmm1, xmm3
    vaddsd xmm10, xmm10, xmm10
    vmovsd xmm0, [g2c_lsig]
    vmulsd xmm0, xmm0, [rbx + P_SY24]
    vdivsd xmm1, xmm1, xmm2
    vmulsd xmm0, xmm0, xmm1
    vdivsd xmm1, xmm3, xmm4
    vmulsd xmm0, xmm0, xmm1
    vmovsd xmm12, [g2c_one]
    vdivsd xmm0, xmm12, xmm0
    vdivsd xmm15, xmm12, xmm4
    vbroadcastsd ymm15, xmm15
    vdivsd xmm1, xmm0, [g2c_k32]
    vmovq rdx, xmm1
    dec rdx
    shr rdx, 52
    mov esi, 2045
    sub esi, edx
    shl rsi, 52
    vmovq xmm1, rsi
    vmulsd xmm14, xmm0, xmm1
    vmovsd [rsp + 336], xmm14
    sub edx, 902
    shl edx, 23
    mov [rsp + 296], edx
    vbroadcastsd ymm10, xmm10
    vmovapd ymm0, [g2i_rn]
    vdivpd ymm1, ymm0, ymm10
    vfnmadd231pd ymm0, ymm10, ymm1
    vdivpd ymm0, ymm0, ymm10
    vblendpd ymm0, ymm1, ymm0, 10
    vmovapd [r14 + G_dnl], ymm0
    mov r8d, [rsp + 304]
    mov r9d, [rsp + 312]
    lea r11d, [r8 - 1]
    vmovd xmm13, r10d
    vpshufd xmm13, xmm13, 0x44
    vmovdqa xmm12, [g2i_sgn]
    mov rcx, rdi
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
    vmovss [rdi + Pc_w], xmm2
    vpsrldq xmm2, xmm2, 4
    vmovdqa [rdi + Pc_w + 4], xmm2
    add rdi, PCS
    test edx, edx
    jnz .pa
    test al, 1
    jnz .pa
    mov rsi, rcx
    sub rsi, rdi
    cmp rsi, -256
    jle .pl
    mov edx, esi
    neg edx
    shr edx, 6
    lzcnt r8d, edx
    sub r8d, 29
    shlx r9d, edx, r8d
    sub r9d, edx
    mov r11d, eax
    shr r11d, 1
    vmovd xmm9, eax
    vpinsrd xmm9, xmm9, r11d, 1
.ps:
    vpaddd ymm0, ymm9, [rdi + rsi]
    vmovdqa [rdi], ymm0
    vmovdqa ymm0, [rdi + rsi + 32]
    vmovdqa [rdi + 32], ymm0
    sub rdi, -64
    dec r9d
    jnz .ps
    shlx eax, eax, r8d
    mov rsi, rcx
    sub rsi, rdi
.pl:
    mov edx, r10d
    shl edx, 5
    add rdx, rcx
    sub rdx, rdi
    jz .pf
    vmovd xmm9, eax
    shr eax, 1
    vpinsrd xmm9, xmm9, eax, 1
    cmp rsi, -256
    jne .pm
    vmovdqa ymm0, [rcx + 0]
    vmovdqa ymm4, [rcx + 32]
    vmovdqa ymm1, [rcx + 64]
    vmovdqa ymm5, [rcx + 96]
    vmovdqa ymm2, [rcx + 128]
    vmovdqa ymm6, [rcx + 160]
    vmovdqa ymm3, [rcx + 192]
    vmovdqa ymm7, [rcx + 224]
    vpsubd ymm8, ymm0, ymm9
    vpsubd ymm10, ymm1, ymm9
    vpsubd ymm11, ymm2, ymm9
    vpsubd ymm12, ymm3, ymm9
    vpaddd ymm13, ymm9, ymm9
    mov rax, rdx
    and rax, -512
    add rdi, rax
    neg rax
.pv:
    vpaddd ymm8, ymm8, ymm13
    vmovdqa [rdi + rax + 0], ymm8
    vmovdqa [rdi + rax + 32], ymm4
    vpaddd ymm10, ymm10, ymm13
    vmovdqa [rdi + rax + 64], ymm10
    vmovdqa [rdi + rax + 96], ymm5
    vpaddd ymm11, ymm11, ymm13
    vmovdqa [rdi + rax + 128], ymm11
    vmovdqa [rdi + rax + 160], ymm6
    vpaddd ymm12, ymm12, ymm13
    vmovdqa [rdi + rax + 192], ymm12
    vmovdqa [rdi + rax + 224], ymm7
    vpaddd ymm0, ymm0, ymm13
    vmovdqa [rdi + rax + 256], ymm0
    vmovdqa [rdi + rax + 288], ymm4
    vpaddd ymm1, ymm1, ymm13
    vmovdqa [rdi + rax + 320], ymm1
    vmovdqa [rdi + rax + 352], ymm5
    vpaddd ymm2, ymm2, ymm13
    vmovdqa [rdi + rax + 384], ymm2
    vmovdqa [rdi + rax + 416], ymm6
    vpaddd ymm3, ymm3, ymm13
    vmovdqa [rdi + rax + 448], ymm3
    vmovdqa [rdi + rax + 480], ymm7
    add rax, 512
    jnz .pv
    test edx, 256
    jz .pq
    vpaddd ymm8, ymm8, ymm13
    vmovdqa [rdi + 0], ymm8
    vmovdqa [rdi + 32], ymm4
    vpaddd ymm10, ymm10, ymm13
    vmovdqa [rdi + 64], ymm10
    vmovdqa [rdi + 96], ymm5
    vpaddd ymm11, ymm11, ymm13
    vmovdqa [rdi + 128], ymm11
    vmovdqa [rdi + 160], ymm6
    vpaddd ymm12, ymm12, ymm13
    vmovdqa [rdi + 192], ymm12
    vmovdqa [rdi + 224], ymm7
    add rdi, 256
.pq:
    and edx, 255
    jz .pf
.pm:
    add rdi, rdx
    add rsi, rdi
    neg rdx
.pr:
    vpaddd ymm0, ymm9, [rsi + rdx]
    vmovdqa [rdi + rdx], ymm0
    vmovdqa ymm0, [rsi + rdx + 32]
    vmovdqa [rdi + rdx + 32], ymm0
    sub rdx, -64
    jnz .pr
.pf:
    mov ecx, r12d
    shr ecx, 1
    dec ecx
    mov [rdi - PCS + Pc_ch], ecx
    mov eax, [rdi - 2 * PCS + Pc_ch]
    cmp eax, ecx
    cmova eax, ecx
    mov [rdi - 2 * PCS + Pc_ch], eax
    mov eax, [rsp + G_wp - 64]
    add eax, eax
    vmovd xmm0, eax
    vpbroadcastd xmm0, xmm0
    vmovdqa xmm7, [g2i_q4]
    vpmulld xmm3, xmm0, xmm7
    xor ecx, ecx
    sub ecx, [rsp + G_km - 64]
    imul ecx, eax
    vmovd xmm1, ecx
    vpbroadcastd xmm1, xmm1
    vmovdqa ymm5, [g2i_k75h]
    vmovdqa ymm6, [g2i_k25h]
    vpslldq xmm4, xmm3, 8
    vpor ymm2, ymm4, ymm5
    vmovdqa [rdi], ymm2
    vpslldq xmm4, xmm3, 4
    vpor ymm2, ymm4, ymm6
    vmovdqa [rdi + 32], ymm2
    vpor ymm2, ymm4, ymm5
    vmovdqa [rdi + 64], ymm2
    mov ecx, r12d
    shr ecx, 1
    sub ecx, 3
    vmovd xmm4, ecx
    vpbroadcastd xmm4, xmm4
    vpaddd xmm4, xmm4, xmm7
    vpbroadcastd xmm8, [rsp + G_km - 64]
    vpand xmm4, xmm4, xmm8
    vpmulld xmm4, xmm4, xmm0
    mov eax, r12d
    shl eax, 5
    lea rdx, [rdi + rax - 96]
    vpshufd xmm2, xmm4, 0xa4
    vpor ymm9, ymm2, ymm6
    vmovdqa [rdx], ymm9
    vpor ymm9, ymm2, ymm5
    vmovdqa [rdx + 32], ymm9
    vpshufd xmm2, xmm4, 0xa9
    vpor ymm9, ymm2, ymm6
    vmovdqa [rdx + 64], ymm9
    mov eax, [rsp + G_km - 64]
    or eax, 7
    inc eax
    shl eax, 6
    lea rsi, [rdi + rax + 96]
    mov r8, rax
    neg r8
.rdl:
    vpor ymm2, ymm3, ymm6
    vmovdqa [rsi + r8], ymm2
    vpor ymm2, ymm3, ymm5
    vmovdqa [rsi + r8 + 32], ymm2
    vpaddd xmm4, xmm3, xmm0
    vpaddd xmm3, xmm3, xmm1
    vpminud xmm3, xmm3, xmm4
    sub r8, -64
    jnz .rdl
    cmp eax, 512
    jne .rc
    vmovdqa ymm0, [rdi + 96]
    vmovdqa ymm1, [rdi + 128]
    vmovdqa ymm2, [rdi + 160]
    vmovdqa ymm3, [rdi + 192]
    vmovdqa ymm4, [rdi + 224]
    vmovdqa ymm5, [rdi + 256]
    vmovdqa ymm6, [rdi + 288]
    vmovdqa ymm7, [rdi + 320]
    vmovdqa ymm8, [rdi + 352]
    vmovdqa ymm9, [rdi + 384]
    vmovdqa ymm10, [rdi + 416]
    vmovdqa ymm11, [rdi + 448]
    vmovdqa ymm12, [rdi + 480]
    vmovdqa ymm13, [rdi + 512]
    vmovdqa ymm14, [rdi + 544]
    vmovdqa ymm15, [rdi + 576]
    mov rcx, rdx
    sub rcx, rsi
    and rcx, -1024
    add rsi, rcx
    neg rcx
.rb:
    vmovdqa [rsi + rcx + 0], ymm0
    vmovdqa [rsi + rcx + 32], ymm1
    vmovdqa [rsi + rcx + 64], ymm2
    vmovdqa [rsi + rcx + 96], ymm3
    vmovdqa [rsi + rcx + 128], ymm4
    vmovdqa [rsi + rcx + 160], ymm5
    vmovdqa [rsi + rcx + 192], ymm6
    vmovdqa [rsi + rcx + 224], ymm7
    vmovdqa [rsi + rcx + 256], ymm8
    vmovdqa [rsi + rcx + 288], ymm9
    vmovdqa [rsi + rcx + 320], ymm10
    vmovdqa [rsi + rcx + 352], ymm11
    vmovdqa [rsi + rcx + 384], ymm12
    vmovdqa [rsi + rcx + 416], ymm13
    vmovdqa [rsi + rcx + 448], ymm14
    vmovdqa [rsi + rcx + 480], ymm15
    vmovdqa [rsi + rcx + 512], ymm0
    vmovdqa [rsi + rcx + 544], ymm1
    vmovdqa [rsi + rcx + 576], ymm2
    vmovdqa [rsi + rcx + 608], ymm3
    vmovdqa [rsi + rcx + 640], ymm4
    vmovdqa [rsi + rcx + 672], ymm5
    vmovdqa [rsi + rcx + 704], ymm6
    vmovdqa [rsi + rcx + 736], ymm7
    vmovdqa [rsi + rcx + 768], ymm8
    vmovdqa [rsi + rcx + 800], ymm9
    vmovdqa [rsi + rcx + 832], ymm10
    vmovdqa [rsi + rcx + 864], ymm11
    vmovdqa [rsi + rcx + 896], ymm12
    vmovdqa [rsi + rcx + 928], ymm13
    vmovdqa [rsi + rcx + 960], ymm14
    vmovdqa [rsi + rcx + 992], ymm15
    add rcx, 1024
    jnz .rb
    mov ecx, edx
    sub ecx, esi
    test ecx, 512
    jz .rc
    vmovdqa [rsi + 0], ymm0
    vmovdqa [rsi + 32], ymm1
    vmovdqa [rsi + 64], ymm2
    vmovdqa [rsi + 96], ymm3
    vmovdqa [rsi + 128], ymm4
    vmovdqa [rsi + 160], ymm5
    vmovdqa [rsi + 192], ymm6
    vmovdqa [rsi + 224], ymm7
    vmovdqa [rsi + 256], ymm8
    vmovdqa [rsi + 288], ymm9
    vmovdqa [rsi + 320], ymm10
    vmovdqa [rsi + 352], ymm11
    vmovdqa [rsi + 384], ymm12
    vmovdqa [rsi + 416], ymm13
    vmovdqa [rsi + 448], ymm14
    vmovdqa [rsi + 480], ymm15
    add rsi, 512
.rc:
    mov rcx, rsi
    sub rcx, rdx
    mov r8, rdx
    sub r8, rax
.rcl:
    vmovdqa ymm2, [r8 + rcx]
    vmovdqa ymm9, [r8 + rcx + 32]
    vmovdqa [rdx + rcx], ymm2
    vmovdqa [rdx + rcx + 32], ymm9
    sub rcx, -64
    jnz .rcl
    mov eax, [rsp + G_gp - 64]
    lea rdi, [rdx + 96]
    mov esi, ebp
    shr esi, 8
    shl esi, 6
    add rsi, rdi
    movzx edx, bpl
    vbroadcastss ymm13, [rsp + 296]
    vmovd xmm0, eax
    vpbroadcastd ymm0, xmm0
    vpmulld ymm1, ymm0, [g2i_iota]
    vpbroadcastd ymm11, [g2i_c7]
    vpbroadcastd ymm12, [g2i_msb]
    vpxor xmm10, xmm10, xmm10
    vcvtdq2ps ymm15, ymm0
    vmulps ymm15, ymm15, ymm13
    vbroadcastss ymm9, [g2i_f16]
    vmulps ymm9, ymm9, ymm13
    vpbroadcastd ymm8, [g2i_c15]
    cmp eax, 16
    jb .h2
    vpslld ymm2, ymm0, 3
    vpaddd ymm2, ymm2, ymm1
    vpsrld ymm3, ymm1, 4
    vpsrld ymm4, ymm2, 4
    vpbroadcastd ymm5, xmm4
    vpsubd ymm4, ymm4, ymm5
    vpand ymm5, ymm3, ymm11
    vpand ymm6, ymm4, ymm11
    vpor ymm7, ymm5, ymm12
    vpor ymm11, ymm6, ymm12
    vpsrld ymm3, ymm3, 3
    vpsrld ymm4, ymm4, 3
    vpsubd ymm3, ymm10, ymm3
    vpsubd ymm4, ymm10, ymm4
    vpcmpeqd ymm12, ymm12, ymm12
    mov r8d, ebp
    shr r8d, 8
    shl r8d, 5
    lea r9, [rdi + r8]
    lea r10, [r9 + r8]
    neg r8
.hu:
    vblendvps ymm0, ymm5, ymm7, ymm3
    vmovdqa [r9 + r8], ymm0
    vblendvps ymm0, ymm6, ymm11, ymm4
    vmovdqa [r10 + r8], ymm0
    vpsubd ymm3, ymm3, ymm12
    vpsubd ymm4, ymm4, ymm12
    add r8, 32
    jnz .hu
    vpand ymm1, ymm1, ymm8
    vpand ymm2, ymm2, ymm8
    vcvtdq2ps ymm1, ymm1
    vcvtdq2ps ymm2, ymm2
    vmulps ymm1, ymm1, ymm13
    vmulps ymm2, ymm2, ymm13
    vsubps ymm1, ymm9, ymm1
    vsubps ymm2, ymm9, ymm2
    vxorps xmm3, xmm3, xmm3
    vxorps xmm4, xmm4, xmm4
    mov r8d, edx
    shl r8d, 5
    lea r9, [rsi + r8]
    lea r10, [r9 + r8]
    neg r8
    test dl, 1
    jz .hva
    sub r8, 32
    vxorps xmm5, xmm5, xmm5
    vxorps xmm6, xmm6, xmm6
    jmp .hvb
.hva:
    vminps ymm5, ymm1, ymm15
    vsubps ymm7, ymm5, ymm3
    vmovaps [r9 + r8], ymm7
    vaddps ymm1, ymm1, ymm9
    vminps ymm6, ymm2, ymm15
    vsubps ymm7, ymm6, ymm4
    vmovaps [r10 + r8], ymm7
    vaddps ymm2, ymm2, ymm9
.hvb:
    vminps ymm3, ymm1, ymm15
    vsubps ymm7, ymm3, ymm5
    vmovaps [r9 + r8 + 32], ymm7
    vaddps ymm1, ymm1, ymm9
    vminps ymm4, ymm2, ymm15
    vsubps ymm7, ymm4, ymm6
    vmovaps [r10 + r8 + 32], ymm7
    vaddps ymm2, ymm2, ymm9
    add r8, 64
    jnz .hva
    jmp .hd
.h2:
    vpsrld ymm3, ymm1, 3
    vpand ymm5, ymm3, ymm11
    vpor ymm7, ymm5, ymm12
    vpsrld ymm3, ymm3, 3
    vpsubd ymm3, ymm10, ymm3
    vblendvps ymm5, ymm5, ymm7, ymm3
    vmovdqa [rdi], ymm5
    vpaddd ymm1, ymm1, ymm1
    vpand ymm1, ymm1, ymm8
    vcvtdq2ps ymm1, ymm1
    vmulps ymm1, ymm1, ymm13
    vsubps ymm1, ymm9, ymm1
    vaddps ymm2, ymm15, ymm15
    vxorps xmm3, xmm3, xmm3
    vxorps xmm4, xmm4, xmm4
    mov r8d, edx
    shl r8d, 6
    add rsi, r8
    neg r8
    test dl, 1
    jz .hwa
    sub r8, 64
    vxorps xmm5, xmm5, xmm5
    vxorps xmm6, xmm6, xmm6
    jmp .hwb
.hwa:
    vminps ymm5, ymm1, ymm15
    vminps ymm6, ymm1, ymm2
    vsubps ymm7, ymm5, ymm3
    vsubps ymm8, ymm6, ymm4
    vsubps ymm8, ymm8, ymm7
    vmovaps [rsi + r8], ymm7
    vmovaps [rsi + r8 + 32], ymm8
    vaddps ymm1, ymm1, ymm9
.hwb:
    vminps ymm3, ymm1, ymm15
    vminps ymm4, ymm1, ymm2
    vsubps ymm7, ymm3, ymm5
    vsubps ymm8, ymm4, ymm6
    vsubps ymm8, ymm8, ymm7
    vmovaps [rsi + r8 + 64], ymm7
    vmovaps [rsi + r8 + 96], ymm8
    vaddps ymm1, ymm1, ymm9
    sub r8, -128
    jnz .hwa
.hd:
    vmovsd xmm14, [rsp + 336]
    vpsrlq xmm7, xmm14, 52
    vpor xmm7, xmm7, [g2c_m52]
    vsubsd xmm7, xmm7, [g2c_m52e]
    vpand xmm0, xmm14, [g2c_mnt]
    vmovsd xmm14, [g2c_one]
    vpor xmm0, xmm0, xmm14
    vsubsd xmm1, xmm0, xmm14
    vaddsd xmm2, xmm0, xmm14
    vdivsd xmm1, xmm1, xmm2
    vmulsd xmm2, xmm1, xmm1
    vmovsd xmm3, [g2c_lnc + 160]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 152]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 144]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 136]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 128]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 120]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 112]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 104]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 96]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 88]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 80]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 72]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 64]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 56]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 48]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 40]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 32]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 24]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 16]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 8]
    vfmadd213sd xmm3, xmm2, [g2c_lnc + 0]
    vaddsd xmm1, xmm1, xmm1
    vmulsd xmm1, xmm1, xmm3
    vfmadd231sd xmm1, xmm7, [g2c_ln2]
    vmovsd [rsp + 344], xmm1
    vmovsd xmm15, [g2c_mz]
    vxorpd xmm0, xmm1, xmm15
    vxorpd xmm1, xmm1, xmm1
    call g2xp
    vmovsd xmm2, [rsp + 336]
    vmulsd xmm3, xmm0, xmm2
    vmulsd xmm4, xmm1, xmm2
    vfmsub213sd xmm0, xmm2, xmm3
    vaddsd xmm0, xmm0, xmm4
    vaddsd xmm4, xmm3, xmm0
    vsubsd xmm5, xmm4, xmm3
    vsubsd xmm5, xmm0, xmm5
    vmovsd xmm3, [g2c_mone]
    vaddsd xmm6, xmm4, xmm3
    vsubsd xmm7, xmm6, xmm4
    vsubsd xmm8, xmm6, xmm7
    vsubsd xmm8, xmm4, xmm8
    vsubsd xmm7, xmm3, xmm7
    vaddsd xmm8, xmm8, xmm7
    vaddsd xmm3, xmm8, xmm5
    vaddsd xmm5, xmm6, xmm3
    vsubsd xmm8, xmm5, xmm6
    vsubsd xmm8, xmm3, xmm8
    vsubsd xmm3, xmm8, xmm15
    vaddsd xmm8, xmm5, xmm3
    vsubsd xmm6, xmm8, xmm5
    vsubsd xmm6, xmm3, xmm6
    vmovsd xmm3, [rsp + 344]
    vaddsd xmm5, xmm3, xmm8
    vsubsd xmm4, xmm5, xmm3
    vsubsd xmm4, xmm8, xmm4
    vsubsd xmm8, xmm6, xmm15
    vaddsd xmm6, xmm4, xmm8
    vaddsd xmm8, xmm5, xmm6
    vsubsd xmm4, xmm8, xmm5
    vsubsd xmm4, xmm6, xmm4
    vsubsd xmm6, xmm4, xmm15
    vaddsd xmm4, xmm8, xmm6
    vsubsd xmm5, xmm4, xmm8
    vsubsd xmm5, xmm6, xmm5
    vmovsd xmm6, [g2c_c512h]
    vmovsd xmm8, [g2c_c512l]
    vmulsd xmm3, xmm6, xmm4
    vmulsd xmm7, xmm8, xmm4
    vfmadd231sd xmm7, xmm6, xmm5
    vfmsub213sd xmm6, xmm4, xmm3
    vaddsd xmm6, xmm6, xmm7
    vaddsd xmm0, xmm3, xmm6
    vsubsd xmm1, xmm0, xmm3
    vsubsd xmm1, xmm6, xmm1
    vsqrtsd xmm3, xmm2, xmm2
    vbroadcastsd ymm4, [g2c_c5]
    vmovupd xmm5, [rbx + P_TSQR]
    vmulsd xmm6, xmm5, [g2c_rsf]
    vinsertf128 ymm5, ymm5, xmm6, 1
    vunpcklpd xmm6, xmm3, xmm2
    vinsertf128 ymm6, ymm6, xmm3, 1
    vdivpd ymm5, ymm5, ymm6
    vpbroadcastd ymm11, [g2i_one32]
    vpbroadcastd ymm12, [g2i_two32]
    vpbroadcastd ymm13, [g2i_three32]
    vbroadcastsd ymm6, xmm5
    vmovapd [r14 + G_dsn], ymm6
    vmovapd [r14 + G_esn], ymm6
    vpermpd ymm6, ymm5, 0x55
    vmovapd [r14 + G_dta], ymm6
    vmovapd [r14 + G_eta], ymm6
    vmulpd ymm5, ymm5, ymm4
    vcvtpd2ps xmm5, ymm5
    vpermps ymm6, ymm12, ymm5
    vmovaps [r14 + G_lsn], ymm6
    vmovaps [r14 + G_csn], ymm6
    vpermps ymm6, ymm11, ymm5
    vmovaps [r14 + G_lta], ymm6
    vmovaps [r14 + G_cta], ymm6
    mov eax, [rsp + 320]
    lea ecx, [rax + 2]
    vmovd xmm5, eax
    vpinsrd xmm5, xmm5, ecx, 1
    vcvtdq2pd xmm5, xmm5
    vmulpd xmm5, xmm5, [g2i_u24p]
    vmovddup xmm6, xmm14
    vsubpd xmm6, xmm6, xmm5
    vdivpd xmm5, xmm5, xmm6
    vbroadcastsd ymm6, [g2c_c6]
    vmulpd xmm5, xmm5, xmm6
    vinsertf128 ymm5, ymm5, xmm5, 1
    vaddpd ymm5, ymm5, [g2i_rh]
    vmulpd ymm7, ymm5, ymm6
    vmulpd ymm8, ymm5, ymm4
    vaddpd ymm9, ymm7, ymm7
    vmulpd ymm9, ymm9, ymm4
    vaddpd ymm10, ymm8, ymm8
    vmulpd ymm10, ymm10, ymm4
    vcvtpd2ps xmm8, ymm8
    vcvtpd2ps xmm10, ymm10
    vbroadcastsd ymm5, xmm7
    vmovapd [r14 + G_drg], ymm5
    vmovapd [r14 + G_drg + 64], ymm5
    vpermpd ymm5, ymm7, 0x55
    vmovapd [r14 + G_erg], ymm5
    vmovapd [r14 + G_erg + 64], ymm5
    vpermpd ymm5, ymm7, 0xaa
    vmovapd [r14 + G_drg + 32], ymm5
    vpermpd ymm5, ymm7, 0xff
    vmovapd [r14 + G_erg + 32], ymm5
    vpermpd ymm5, ymm9, 0xaa
    vmovapd [r14 + G_dan], ymm5
    vpermpd ymm5, ymm9, 0xff
    vmovapd [r14 + G_ean], ymm5
    vbroadcastss ymm5, xmm8
    vmovaps [r14 + G_lrg], ymm5
    vmovaps [r14 + G_lrg + 64], ymm5
    vpermps ymm5, ymm11, ymm8
    vmovaps [r14 + G_crg], ymm5
    vmovaps [r14 + G_crg + 64], ymm5
    vpermps ymm5, ymm12, ymm8
    vmovaps [r14 + G_lrg + 32], ymm5
    vpermps ymm5, ymm13, ymm8
    vmovaps [r14 + G_crg + 32], ymm5
    vpermps ymm5, ymm12, ymm10
    vmovaps [r14 + G_lan], ymm5
    vpermps ymm5, ymm13, ymm10
    vmovaps [r14 + G_can], ymm5
    mov rax, rbx
    sub rax, xav_g2l
    vmovaps ymm5, [abs g2i_rt + rax + 0]
    vmovaps [r14 + G_lsl], ymm5
    vmovaps ymm6, [abs g2i_rt + rax + 32]
    vmovaps [r14 + G_csb], ymm6
    vmovaps ymm7, [abs g2i_rt + rax + 64]
    vmovaps [r14 + G_csr], ymm7
    vmovaps ymm8, [abs g2i_rt + rax + 96]
    vmovaps [r14 + G_dlo], ymm8
    vmovaps ymm5, [abs g2i_rt + rax + 128]
    vmovaps [r14 + G_dhi], ymm5
    vmovaps ymm6, [abs g2i_rt + rax + 160]
    vmovaps [r14 + G_elo], ymm6
    vmovaps ymm7, [abs g2i_rt + rax + 192]
    vmovaps [r14 + G_elo + 32], ymm7
    vmovaps ymm8, [abs g2i_rt + rax + 224]
    vmovaps [r14 + G_ehi], ymm8
    vmovaps ymm5, [abs g2i_rt + rax + 256]
    vmovaps [r14 + G_ehi + 32], ymm5
    vbroadcastss ymm5, [g2i_om3]
    vmovaps [r14 + G_lom], ymm5
    vmovaps [r14 + G_com + 32], ymm5
    vbroadcastss ymm5, [g2i_om2]
    vmovaps [r14 + G_lom + 32], ymm5
    vbroadcastss ymm5, [g2i_om4]
    vmovaps [r14 + G_lom + 64], ymm5
    vmovaps [r14 + G_com], ymm5
    vmovaps [r14 + G_com + 64], ymm5
    vbroadcastss ymm5, [g2i_f1]
    vmovaps [r14 + G_lm], ymm5
    vbroadcastss ymm5, [g2i_fq]
    vmovaps [r14 + G_cm], ymm5
    call g2xp
    vbroadcastsd ymm10, xmm0
    vdivsd xmm9, xmm0, [g2c_osig]
    vbroadcastsd ymm9, xmm9
    vmovapd ymm1, [rbx + u_emc0 - xav_gr]
    vmulpd ymm2, ymm1, ymm10
    vmovapd [r14 + G_dmx + 0], ymm2
    vmulpd ymm1, ymm1, ymm9
    vcvtpd2ps xmm1, ymm1
    vinsertf128 ymm1, ymm1, xmm1, 1
    vmovaps [r14 + G_lmx + 0], ymm1
    vmovapd ymm1, [rbx + u_emc1 - xav_gr]
    vmulpd ymm2, ymm1, ymm10
    vmovapd [r14 + G_dmx + 32], ymm2
    vmulpd ymm1, ymm1, ymm9
    vcvtpd2ps xmm1, ymm1
    vinsertf128 ymm1, ymm1, xmm1, 1
    vmovaps [r14 + G_lmx + 32], ymm1
    vmovapd ymm1, [rbx + u_emc2 - xav_gr]
    vmulpd ymm2, ymm1, ymm10
    vmovapd [r14 + G_dmx + 64], ymm2
    vmulpd ymm1, ymm1, ymm9
    vcvtpd2ps xmm1, ymm1
    vinsertf128 ymm1, ymm1, xmm1, 1
    vmovaps [r14 + G_lmx + 64], ymm1
    vmovapd ymm1, [rbx + u_emc3 - xav_gr]
    vmulpd ymm2, ymm1, ymm10
    vmovapd [r14 + G_emx + 0], ymm2
    vmulpd ymm1, ymm1, ymm9
    vcvtpd2ps xmm1, ymm1
    vinsertf128 ymm1, ymm1, xmm1, 1
    vmovaps [r14 + G_cmx + 0], ymm1
    vmovapd ymm1, [rbx + u_emc4 - xav_gr]
    vmulpd ymm2, ymm1, ymm10
    vmovapd [r14 + G_emx + 32], ymm2
    vmulpd ymm1, ymm1, ymm9
    vcvtpd2ps xmm1, ymm1
    vinsertf128 ymm1, ymm1, xmm1, 1
    vmovaps [r14 + G_cmx + 32], ymm1
    vmovapd ymm1, [rbx + u_emc5 - xav_gr]
    vmulpd ymm2, ymm1, ymm10
    vmovapd [r14 + G_emx + 64], ymm2
    vmulpd ymm1, ymm1, ymm9
    vcvtpd2ps xmm1, ymm1
    vinsertf128 ymm1, ymm1, xmm1, 1
    vmovaps [r14 + G_cmx + 64], ymm1
    vmovapd ymm1, [rbx + u_emc6 - xav_gr]
    vmulpd ymm2, ymm1, ymm10
    vmovapd [r14 + G_emx + 96], ymm2
    vmulpd ymm1, ymm1, ymm9
    vcvtpd2ps xmm1, ymm1
    vinsertf128 ymm1, ymm1, xmm1, 1
    vmovaps [r14 + G_cmx + 96], ymm1
    vmovapd ymm1, [rbx + u_emc7 - xav_gr]
    vmulpd ymm2, ymm1, ymm10
    vmovapd [r14 + G_emx + 128], ymm2
    vmulpd ymm1, ymm1, ymm9
    vcvtpd2ps xmm1, ymm1
    vinsertf128 ymm1, ymm1, xmm1, 1
    vmovaps [r14 + G_cmx + 128], ymm1
    vmovapd ymm1, [rbx + u_emc8 - xav_gr]
    vmulpd ymm2, ymm1, ymm10
    vmovapd [r14 + G_emx + 160], ymm2
    vmulpd ymm1, ymm1, ymm9
    vcvtpd2ps xmm1, ymm1
    vinsertf128 ymm1, ymm1, xmm1, 1
    vmovaps [r14 + G_cmx + 160], ymm1
    dec r13d
    jz .tz
    vmovdqa ymm7, [r14 + 64]
    vmovdqa ymm8, [r14 + 96]
    vmovdqa ymm9, [r14 + 128]
    vmovdqa ymm10, [r14 + 160]
    vmovdqa ymm11, [r14 + 192]
    vmovq xmm0, r15
    vpbroadcastq ymm0, xmm0
    vpxor xmm1, xmm1, xmm1
    vpblendd ymm2, ymm0, ymm1, 0x03
    vpblendd ymm3, ymm0, ymm1, 0xfc
    vmovdqa ymm1, [r14 + 224]
    vmovdqa ymm4, [r14 + 256]
    vmovdqa ymm5, [r14 + 288]
    vmovdqa ymm6, [r14 + 320]
    vmovdqa ymm12, [r14 + 352]
    vmovdqa ymm13, [r14 + 384]
    vmovdqa ymm14, [r14 + 416]
    vmovdqa ymm15, [r14 + 448]
    mov rdi, r14
    mov ecx, r13d
.ta:
    add rdi, r15
    vmovdqa [rdi + 64], ymm7
    vpaddq ymm8, ymm8, ymm2
    vmovdqa [rdi + 96], ymm8
    vpaddq ymm9, ymm9, ymm0
    vmovdqa [rdi + 128], ymm9
    vpaddq ymm10, ymm10, ymm0
    vmovdqa [rdi + 160], ymm10
    vpaddq ymm11, ymm11, ymm3
    vmovdqa [rdi + 192], ymm11
    vmovdqa [rdi + 224], ymm1
    vmovdqa [rdi + 256], ymm4
    vmovdqa [rdi + 288], ymm5
    vmovdqa [rdi + 320], ymm6
    vmovdqa [rdi + 352], ymm12
    vmovdqa [rdi + 384], ymm13
    vmovdqa [rdi + 416], ymm14
    vmovdqa [rdi + 448], ymm15
    dec ecx
    jnz .ta
    vmovdqa ymm0, [r14 + 480]
    vmovdqa ymm1, [r14 + 512]
    vmovdqa ymm2, [r14 + 544]
    vmovdqa ymm3, [r14 + 576]
    vmovdqa ymm4, [r14 + 608]
    vmovdqa ymm5, [r14 + 640]
    vmovdqa ymm6, [r14 + 672]
    vmovdqa ymm7, [r14 + 704]
    vmovdqa ymm8, [r14 + 736]
    vmovdqa ymm9, [r14 + 768]
    vmovdqa ymm10, [r14 + 800]
    vmovdqa ymm11, [r14 + 832]
    vmovdqa ymm12, [r14 + 864]
    vmovdqa ymm13, [r14 + 896]
    vmovdqa ymm14, [r14 + 928]
    vmovdqa ymm15, [r14 + 960]
    mov rdi, r14
    mov ecx, r13d
.tb0:
    add rdi, r15
    vmovdqa [rdi + 480], ymm0
    vmovdqa [rdi + 512], ymm1
    vmovdqa [rdi + 544], ymm2
    vmovdqa [rdi + 576], ymm3
    vmovdqa [rdi + 608], ymm4
    vmovdqa [rdi + 640], ymm5
    vmovdqa [rdi + 672], ymm6
    vmovdqa [rdi + 704], ymm7
    vmovdqa [rdi + 736], ymm8
    vmovdqa [rdi + 768], ymm9
    vmovdqa [rdi + 800], ymm10
    vmovdqa [rdi + 832], ymm11
    vmovdqa [rdi + 864], ymm12
    vmovdqa [rdi + 896], ymm13
    vmovdqa [rdi + 928], ymm14
    vmovdqa [rdi + 960], ymm15
    dec ecx
    jnz .tb0
    vmovdqa ymm0, [r14 + 992]
    vmovdqa ymm1, [r14 + 1024]
    vmovdqa ymm2, [r14 + 1056]
    vmovdqa ymm3, [r14 + 1088]
    vmovdqa ymm4, [r14 + 1120]
    vmovdqa ymm5, [r14 + 1152]
    vmovdqa ymm6, [r14 + 1184]
    vmovdqa ymm7, [r14 + 1216]
    vmovdqa ymm8, [r14 + 1248]
    vmovdqa ymm9, [r14 + 1280]
    vmovdqa ymm10, [r14 + 1312]
    vmovdqa ymm11, [r14 + 1344]
    vmovdqa ymm12, [r14 + 1376]
    vmovdqa ymm13, [r14 + 1408]
    vmovdqa ymm14, [r14 + 1440]
    vmovdqa ymm15, [r14 + 1472]
    mov rdi, r14
    mov ecx, r13d
.tb1:
    add rdi, r15
    vmovdqa [rdi + 992], ymm0
    vmovdqa [rdi + 1024], ymm1
    vmovdqa [rdi + 1056], ymm2
    vmovdqa [rdi + 1088], ymm3
    vmovdqa [rdi + 1120], ymm4
    vmovdqa [rdi + 1152], ymm5
    vmovdqa [rdi + 1184], ymm6
    vmovdqa [rdi + 1216], ymm7
    vmovdqa [rdi + 1248], ymm8
    vmovdqa [rdi + 1280], ymm9
    vmovdqa [rdi + 1312], ymm10
    vmovdqa [rdi + 1344], ymm11
    vmovdqa [rdi + 1376], ymm12
    vmovdqa [rdi + 1408], ymm13
    vmovdqa [rdi + 1440], ymm14
    vmovdqa [rdi + 1472], ymm15
    dec ecx
    jnz .tb1
    vmovdqa ymm0, [r14 + 1504]
    vmovdqa ymm1, [r14 + 1536]
    vmovdqa ymm2, [r14 + 1568]
    vmovdqa ymm3, [r14 + 1600]
    vmovdqa ymm4, [r14 + 1632]
    vmovdqa ymm5, [r14 + 1664]
    vmovdqa ymm6, [r14 + 1696]
    vmovdqa ymm7, [r14 + 1728]
    vmovdqa ymm8, [r14 + 1760]
    vmovdqa ymm9, [r14 + 1792]
    vmovdqa ymm10, [r14 + 1824]
    vmovdqa ymm11, [r14 + 1856]
    vmovdqa ymm12, [r14 + 1888]
    vmovdqa ymm13, [r14 + 1920]
    vmovdqa ymm14, [r14 + 1952]
    vmovdqa ymm15, [r14 + 1984]
    mov rdi, r14
    mov ecx, r13d
.tb2:
    add rdi, r15
    vmovdqa [rdi + 1504], ymm0
    vmovdqa [rdi + 1536], ymm1
    vmovdqa [rdi + 1568], ymm2
    vmovdqa [rdi + 1600], ymm3
    vmovdqa [rdi + 1632], ymm4
    vmovdqa [rdi + 1664], ymm5
    vmovdqa [rdi + 1696], ymm6
    vmovdqa [rdi + 1728], ymm7
    vmovdqa [rdi + 1760], ymm8
    vmovdqa [rdi + 1792], ymm9
    vmovdqa [rdi + 1824], ymm10
    vmovdqa [rdi + 1856], ymm11
    vmovdqa [rdi + 1888], ymm12
    vmovdqa [rdi + 1920], ymm13
    vmovdqa [rdi + 1952], ymm14
    vmovdqa [rdi + 1984], ymm15
    dec ecx
    jnz .tb2
    vmovdqa ymm0, [r14 + 2016]
    vmovdqa ymm1, [r14 + 2048]
    vmovdqa ymm2, [r14 + 2080]
    vmovdqa ymm3, [r14 + 2112]
    vmovdqa ymm4, [r14 + 2144]
    vmovdqa ymm5, [r14 + 2176]
    vmovdqa ymm6, [r14 + 2208]
    vmovdqa ymm7, [r14 + 2240]
    mov rdi, r14
    mov ecx, r13d
.tb3:
    add rdi, r15
    vmovdqa [rdi + 2016], ymm0
    vmovdqa [rdi + 2048], ymm1
    vmovdqa [rdi + 2080], ymm2
    vmovdqa [rdi + 2112], ymm3
    vmovdqa [rdi + 2144], ymm4
    vmovdqa [rdi + 2176], ymm5
    vmovdqa [rdi + 2208], ymm6
    vmovdqa [rdi + 2240], ymm7
    dec ecx
    jnz .tb3
.tz:
    vmovdqa ymm0, [rbx + 0]
    vmovdqa ymm1, [rbx + 32]
    vmovdqa ymm2, [rbx + 64]
    vmovdqa ymm3, [rbx + 96]
    vmovdqa ymm4, [rbx + 128]
    vmovdqa ymm5, [rbx + 160]
    vmovdqa ymm6, [rbx + 192]
    vmovdqa ymm7, [rbx + 224]
    vmovdqa ymm8, [rbx + 256]
    vmovdqa ymm9, [rbx + 288]
    vmovdqa ymm10, [rbx + 320]
    vmovdqa ymm11, [rbx + 352]
    vmovdqa ymm12, [rbx + 384]
    vmovdqa ymm13, [rbx + 416]
    vmovdqa ymm14, [rbx + 448]
    vmovdqa ymm15, [rbx + 480]
    vmovdqa [xav_gr + 0], ymm0
    vmovdqa [xav_gr + 32], ymm1
    vmovdqa [xav_gr + 64], ymm2
    vmovdqa [xav_gr + 96], ymm3
    vmovdqa [xav_gr + 128], ymm4
    vmovdqa [xav_gr + 160], ymm5
    vmovdqa [xav_gr + 192], ymm6
    vmovdqa [xav_gr + 224], ymm7
    vmovdqa [xav_gr + 256], ymm8
    vmovdqa [xav_gr + 288], ymm9
    vmovdqa [xav_gr + 320], ymm10
    vmovdqa [xav_gr + 352], ymm11
    vmovdqa [xav_gr + 384], ymm12
    vmovdqa [xav_gr + 416], ymm13
    vmovdqa [xav_gr + 448], ymm14
    vmovdqa [xav_gr + 480], ymm15
    vmovdqa ymm0, [rbx + 512]
    vmovdqa ymm1, [rbx + 544]
    vmovdqa ymm2, [rbx + 576]
    vmovdqa ymm3, [rbx + 608]
    vmovdqa ymm4, [rbx + 640]
    vmovdqa ymm5, [rbx + 672]
    vmovdqa ymm6, [rbx + 704]
    vmovdqa ymm7, [rbx + 736]
    vmovdqa ymm8, [rbx + 768]
    vmovdqa ymm9, [rbx + 800]
    vmovdqa ymm10, [rbx + 832]
    vmovdqa ymm11, [rbx + 864]
    vmovdqa ymm12, [rbx + 896]
    vmovdqa ymm13, [rbx + 928]
    vmovdqa ymm14, [rbx + 960]
    vmovdqa ymm15, [rbx + 992]
    vmovdqa [xav_gr + 512], ymm0
    vmovdqa [xav_gr + 544], ymm1
    vmovdqa [xav_gr + 576], ymm2
    vmovdqa [xav_gr + 608], ymm3
    vmovdqa [xav_gr + 640], ymm4
    vmovdqa [xav_gr + 672], ymm5
    vmovdqa [xav_gr + 704], ymm6
    vmovdqa [xav_gr + 736], ymm7
    vmovdqa [xav_gr + 768], ymm8
    vmovdqa [xav_gr + 800], ymm9
    vmovdqa [xav_gr + 832], ymm10
    vmovdqa [xav_gr + 864], ymm11
    vmovdqa [xav_gr + 896], ymm12
    vmovdqa [xav_gr + 928], ymm13
    vmovdqa [xav_gr + 960], ymm14
    vmovdqa [xav_gr + 992], ymm15
    mov rsp, [rsp + 288]
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    ret
g2xp:
    vmovsd xmm12, [g2c_ln2]
    vdivsd xmm8, xmm0, xmm12
    vroundsd xmm9, xmm8, xmm8, 11
    vsubsd xmm10, xmm8, xmm9
    vandpd xmm10, xmm10, [g2c_absm]
    vcmpsd xmm10, xmm10, [g2c_half], 13
    vandpd xmm11, xmm8, xmm15
    vorpd xmm11, xmm11, xmm14
    vandpd xmm11, xmm11, xmm10
    vaddsd xmm9, xmm9, xmm11
    vcvttsd2si rax, xmm9
    add rax, 1023
    shl rax, 52
    vmovsd xmm10, [g2c_ln2l]
    vmulsd xmm8, xmm12, xmm9
    vmulsd xmm11, xmm10, xmm9
    vfmsub213sd xmm12, xmm9, xmm8
    vaddsd xmm12, xmm12, xmm11
    vaddsd xmm11, xmm8, xmm12
    vsubsd xmm2, xmm11, xmm8
    vsubsd xmm2, xmm12, xmm2
    vxorpd xmm8, xmm11, xmm15
    vxorpd xmm3, xmm2, xmm15
    vaddsd xmm12, xmm0, xmm8
    vaddsd xmm8, xmm1, xmm3
    vsubsd xmm10, xmm8, xmm1
    vsubsd xmm9, xmm8, xmm10
    vsubsd xmm9, xmm1, xmm9
    vsubsd xmm10, xmm3, xmm10
    vaddsd xmm9, xmm9, xmm10
    vsubsd xmm3, xmm8, xmm15
    vaddsd xmm8, xmm12, xmm3
    vsubsd xmm10, xmm8, xmm12
    vsubsd xmm10, xmm3, xmm10
    vaddsd xmm3, xmm10, xmm9
    vaddsd xmm9, xmm8, xmm3
    vsubsd xmm10, xmm9, xmm8
    vsubsd xmm10, xmm3, xmm10
    vmovsd xmm3, [g2c_i1024]
    vmulsd xmm8, xmm9, xmm3
    vmulsd xmm12, xmm10, xmm3
    vfmsub213sd xmm9, xmm3, xmm8
    vaddsd xmm9, xmm9, xmm12
    vaddsd xmm6, xmm8, xmm9
    vsubsd xmm7, xmm6, xmm8
    vsubsd xmm7, xmm9, xmm7
    vaddsd xmm0, xmm14, xmm6
    vsubsd xmm1, xmm0, xmm14
    vsubsd xmm1, xmm6, xmm1
    vsubsd xmm8, xmm7, xmm15
    vaddsd xmm9, xmm1, xmm8
    vaddsd xmm8, xmm0, xmm9
    vsubsd xmm1, xmm8, xmm0
    vsubsd xmm1, xmm9, xmm1
    vsubsd xmm9, xmm1, xmm15
    vaddsd xmm2, xmm8, xmm9
    vsubsd xmm3, xmm2, xmm8
    vsubsd xmm3, xmm9, xmm3
    vmovapd xmm4, xmm6
    vmovapd xmm5, xmm7
    vaddsd xmm13, xmm14, xmm14
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
    vxorpd xmm9, xmm0, xmm15
    vmulsd xmm10, xmm13, xmm9
    vfmsub213sd xmm9, xmm13, xmm10
    vaddsd xmm11, xmm1, xmm10
    vaddsd xmm10, xmm8, xmm9
    vsubsd xmm1, xmm10, xmm8
    vsubsd xmm9, xmm9, xmm1
    vsubsd xmm1, xmm10, xmm1
    vsubsd xmm8, xmm8, xmm1
    vaddsd xmm8, xmm8, xmm9
    vaddsd xmm9, xmm11, xmm10
    vsubsd xmm1, xmm9, xmm11
    vsubsd xmm1, xmm10, xmm1
    vaddsd xmm10, xmm1, xmm8
    vaddsd xmm8, xmm9, xmm10
    vsubsd xmm1, xmm8, xmm9
    vsubsd xmm1, xmm10, xmm1
    vdivsd xmm10, xmm8, xmm13
    vaddsd xmm9, xmm0, xmm10
    vsubsd xmm11, xmm9, xmm0
    vsubsd xmm11, xmm10, xmm11
    vxorpd xmm0, xmm10, xmm15
    vmulsd xmm10, xmm13, xmm0
    vfmsub213sd xmm0, xmm13, xmm10
    vaddsd xmm12, xmm8, xmm10
    vaddsd xmm10, xmm1, xmm0
    vsubsd xmm8, xmm10, xmm1
    vsubsd xmm0, xmm0, xmm8
    vsubsd xmm8, xmm10, xmm8
    vsubsd xmm1, xmm1, xmm8
    vaddsd xmm1, xmm1, xmm0
    vaddsd xmm0, xmm12, xmm10
    vsubsd xmm8, xmm0, xmm12
    vsubsd xmm8, xmm10, xmm8
    vaddsd xmm10, xmm8, xmm1
    vaddsd xmm1, xmm0, xmm10
    vdivsd xmm10, xmm1, xmm13
    vaddsd xmm1, xmm9, xmm10
    vsubsd xmm0, xmm1, xmm9
    vsubsd xmm0, xmm10, xmm0
    vsubsd xmm10, xmm11, xmm15
    vaddsd xmm11, xmm0, xmm10
    vaddsd xmm10, xmm1, xmm11
    vsubsd xmm0, xmm10, xmm1
    vsubsd xmm0, xmm11, xmm0
    vsubsd xmm11, xmm0, xmm15
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
    vaddsd xmm13, xmm13, xmm14
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
    vmovq xmm8, rax
    vmulsd xmm0, xmm2, xmm8
    vmulsd xmm1, xmm3, xmm8
    ret
section .note.GNU-stack noalloc noexec nowrite progbits
