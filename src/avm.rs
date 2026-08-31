#[cfg(target_os = "linux")]
use alloc::vec::Vec;
use core::{
    ffi::{c_char, c_void},
    hint::cold_path,
    mem::{MaybeUninit, size_of},
    ptr::copy_nonoverlapping,
    slice::from_raw_parts,
    str::from_utf8_unchecked,
};

use crate::{error::fatal, ffms::VidInf, sync::OnceLock};

pub const AVM_CODEC_OK: i32 = 0;
pub const AVM_IMG_FMT_I42016: i32 = 0x902;
pub const AVM_CODEC_CX_FRAME_PKT: i32 = 0;

const AVM_ENCODER_ABI_VERSION: i32 = 23;
const AVM_BITS_10: i32 = 10;
const AVM_Q: i32 = 3;
const AVM_KF_DISABLED: i32 = 0;

const AV2E_SET_COLOR_PRIMARIES: i32 = 45;
const AV2E_SET_TRANSFER_CHARACTERISTICS: i32 = 46;
const AV2E_SET_MATRIX_COEFFICIENTS: i32 = 47;
const AV2E_SET_CHROMA_SAMPLE_POSITION: i32 = 48;
const AV2E_SET_COLOR_RANGE: i32 = 52;

const MAX_TILE_WIDTHS: usize = 64;
const MAX_TILE_HEIGHTS: usize = 64;
const FIXED_QP_OFFSET_COUNT: usize = 6;

#[repr(C)]
#[derive(Clone, Copy)]
struct AvmRational {
    num: i32,
    den: i32,
}

#[repr(C)]
#[derive(Clone, Copy)]
struct AvmFixedBuf {
    buf: *mut c_void,
    sz: usize,
}

#[repr(C)]
#[derive(Clone, Copy)]
struct CfgOptions {
    init_by_cfg_file: u32,
    superblock_size: u32,
    max_partition_size: u32,
    min_partition_size: u32,
    enable_rect_partitions: u32,
    enable_uneven_4way_partitions: u32,
    disable_ml_partition_speed_features: u32,
    erp_pruning_level: u32,
    use_ml_erp_pruning: u32,
    enable_ext_partitions: u32,
    enable_tx_partition: u32,
    max_partition_aspect_ratio: u32,
    disable_ml_transform_speed_features: u32,
    enable_sdp: u32,
    enable_extended_sdp: u32,
    enable_mrls: u32,
    enable_tip: u32,
    enable_tip_refinemv: u32,
    enable_mv_traj: u32,
    enable_high_motion: u32,
    enable_bawp: u32,
    enable_cwp: u32,
    enable_imp_msk_bld: u32,
    enable_fsc: u32,
    enable_idtx_intra: u32,
    enable_ist: u32,
    enable_inter_ist: u32,
    enable_chroma_dctonly: u32,
    enable_inter_ddt: u32,
    enable_cctx: u32,
    enable_ibp: u32,
    enable_adaptive_mvd: u32,
    enable_flex_mvres: u32,
    select_cfl_ds_filter: u32,
    enable_joint_mvd: u32,
    enable_refinemv: u32,
    enable_mvd_sign_derive: u32,
    enable_flip_idtx: u32,
    enable_deblocking: u32,
    enable_cdef: u32,
    enable_gdf: u32,
    gdf_unit_matches_sb: u32,
    enable_restoration: u32,
    enable_pc_wiener: u32,
    enable_wiener_nonsep: u32,
    enable_ccso: u32,
    ccso_unit_matches_sb: u32,
    enable_band_metadata: u32,
    enable_lf_sub_pu: u32,
    enable_warped_motion: u32,
    enable_warp_causal: u32,
    enable_warp_delta: u32,
    enable_six_param_warp_delta: u32,
    enable_warp_extend: u32,
    enable_global_motion: u32,
    enable_skip_mode: u32,
    enable_diff_wtd_comp: u32,
    enable_interintra_comp: u32,
    enable_masked_comp: u32,
    enable_onesided_comp: u32,
    enable_palette: u32,
    enable_intrabc: u32,
    enable_intrabc_ext: u32,
    enable_cfl_intra: u32,
    enable_mhccp: u32,
    enable_smooth_intra: u32,
    enable_intra_dip: u32,
    enable_angle_delta: u32,
    enable_opfl_refine: i32,
    enable_intra_edge_filter: u32,
    reduced_tx_part_set: u32,
    enable_smooth_interintra: u32,
    enable_interinter_wedge: u32,
    enable_interintra_wedge: u32,
    enable_paeth_intra: u32,
    enable_trellis_quant: u32,
    enable_ref_frame_mvs: u32,
    reduced_ref_frame_mvs_mode: u32,
    enable_reduced_reference_set: u32,
    explicit_ref_frame_map: u32,
    add_sef_for_hidden_frames: u32,
    monotonic_output_order: u32,
    reduced_tx_type_set: u32,
    max_drl_refmvs: u32,
    max_drl_refbvs: u32,
    enable_refmvbank: u32,
    enable_drl_reorder: u32,
    enable_cdef_on_skip_txfm: u32,
    enable_avg_cdf: u32,
    avg_cdf_type: u32,
    enable_parity_hiding: u32,
    enable_short_refresh_frame_flags: u32,
    enable_ext_seg: u32,
    dpb_size: i32,
    enable_bru: u32,
    disable_loopfilters_across_tiles: u32,
    enable_cropping_window: i32,
    crop_win_left_offset: i32,
    crop_win_right_offset: i32,
    crop_win_top_offset: i32,
    crop_win_bottom_offset: i32,
    icc_data: *mut u8,
    icc_size: usize,
    scan_type_info_present_flag: u32,
    enable_mfh_obu_signaling: u32,
    operating_points_count: i32,
}

#[repr(C)]
#[derive(Clone, Copy)]
pub struct AvmCodecEncCfg {
    pub g_usage: u32,
    pub g_threads: u32,
    pub g_profile: u32,
    pub g_w: u32,
    pub g_h: u32,
    pub g_limit: u32,
    pub g_forced_max_frame_width: u32,
    pub g_forced_max_frame_height: u32,
    pub g_bit_depth: i32,
    pub g_input_bit_depth: u32,
    g_timebase: AvmRational,
    pub g_error_resilient: u32,
    pub g_pass: i32,
    pub g_lag_in_frames: u32,
    pub rc_dropframe_thresh: u32,
    pub rc_resize_mode: u32,
    pub rc_resize_denominator: u32,
    pub rc_resize_kf_denominator: u32,
    pub rc_end_usage: i32,
    rc_firstpass_mb_stats_in: AvmFixedBuf,
    pub rc_target_bitrate: u32,
    pub rc_min_quantizer: i32,
    pub rc_max_quantizer: i32,
    pub rc_undershoot_pct: u32,
    pub rc_overshoot_pct: u32,
    pub rc_buf_sz: u32,
    pub rc_buf_initial_sz: u32,
    pub rc_buf_optimal_sz: u32,
    pub rc_2pass_vbr_minsection_pct: u32,
    pub rc_2pass_vbr_maxsection_pct: u32,
    pub fwd_kf_enabled: i32,
    pub kf_mode: i32,
    pub kf_min_dist: u32,
    pub kf_max_dist: u32,
    pub enable_sframe: u32,
    pub sframe_dist: u32,
    pub sframe_mode: u32,
    pub sframe_type: u32,
    pub monochrome: u32,
    pub full_still_picture_hdr: u32,
    pub enable_tcq: u32,
    pub enable_lcr: u32,
    pub enable_ops: u32,
    pub num_ops: u32,
    pub enable_atlas: u32,
    pub tile_width_count: i32,
    pub tile_height_count: i32,
    pub tile_widths: [i32; MAX_TILE_WIDTHS],
    pub tile_heights: [i32; MAX_TILE_HEIGHTS],
    pub use_fixed_qp_offsets: u32,
    pub fixed_qp_offsets: [i32; FIXED_QP_OFFSET_COUNT],
    pub frame_hash_metadata: i32,
    pub frame_hash_per_plane: u32,
    pub use_short_metadata: u32,
    encoder_cfg: CfgOptions,
}

#[repr(C)]
pub struct AvmCodecCtx {
    name: *const c_char,
    iface: *mut c_void,
    pub err: i32,
    err_detail: *const c_char,
    init_flags: i64,
    config: *const c_void,
    priv_: *mut c_void,
}

#[repr(C)]
pub struct AvmImage {
    pub fmt: i32,
    cp: i32,
    tc: i32,
    mc: i32,
    monochrome: i32,
    csp: i32,
    range: i32,
    pub w: u32,
    pub h: u32,
    pub bit_depth: u32,
    w_conf_win_enabled_flag: i32,
    w_conf_win_left_offset: i32,
    w_conf_win_right_offset: i32,
    w_conf_win_top_offset: i32,
    w_conf_win_bottom_offset: i32,
    max_width: i32,
    max_height: i32,
    crop_width: i32,
    crop_height: i32,
    pub d_w: u32,
    pub d_h: u32,
    r_w: u32,
    r_h: u32,
    pub x_chroma_shift: u32,
    pub y_chroma_shift: u32,
    pub planes: [*mut u8; 3],
    pub stride: [i32; 3],
    sz: usize,
    pub bps: i32,
    tlayer_id: i32,
    mlayer_id: i32,
    xlayer_id: i32,
    stream_id: i32,
    user_priv: *mut c_void,
    img_data: *mut u8,
    img_data_owner: i32,
    self_allocd: i32,
    metadata: *mut c_void,
    fb_priv: *mut c_void,
}

#[repr(C)]
pub struct AvmFramePkt {
    pub buf: *mut c_void,
    pub sz: usize,
    pub pts: i64,
    pub duration: u64,
    pub flags: u32,
    pub partition_id: i32,
    pub vis_frame_size: usize,
}

#[repr(C)]
pub struct AvmCxPkt {
    pub kind: i32,
    pub frame: AvmFramePkt,
}

#[link(name = "avm_full")]
unsafe extern "C" {
    pub fn avm_codec_av2_cx() -> *mut c_void;

    pub fn avm_codec_enc_config_default(
        iface: *mut c_void,
        cfg: *mut AvmCodecEncCfg,
        usage: u32,
    ) -> i32;

    fn avm_codec_enc_init_ver(
        ctx: *mut AvmCodecCtx,
        iface: *mut c_void,
        cfg: *const AvmCodecEncCfg,
        flags: i64,
        ver: i32,
    ) -> i32;

    fn avm_codec_control(ctx: *mut AvmCodecCtx, ctrl_id: i32, ...) -> i32;

    fn avm_codec_set_option(
        ctx: *mut AvmCodecCtx,
        name: *const c_char,
        value: *const c_char,
    ) -> i32;

    pub fn avm_codec_encode(
        ctx: *mut AvmCodecCtx,
        img: *const AvmImage,
        pts: i64,
        duration: u64,
        flags: i64,
    ) -> i32;

    pub fn avm_codec_get_cx_data(
        ctx: *mut AvmCodecCtx,
        iter: *mut *const c_void,
    ) -> *const AvmCxPkt;

    pub fn avm_codec_destroy(ctx: *mut AvmCodecCtx) -> i32;
}

pub const AVM_CFG_SIZE: usize = size_of::<AvmCodecEncCfg>();
pub const AVM_CTRL_CNT: usize = 5;
pub const AVM_TMPL_HDR: usize = AVM_CFG_SIZE + size_of::<AvmTmpl>();

// `encoder_init` derives timestamp_ratio from g_timebase; av2/encoder/encoder.h
const TICKS_PER_SEC: i64 = 10_000_000;

// `avm_codec_alg_priv` is larger
const AVM_SCAN_MAX: usize = 0x4000;

pub const AVM_MAX_LAG: u32 = 35;

static AVM_CTRL_IDS: [i32; AVM_CTRL_CNT] = [
    AV2E_SET_COLOR_PRIMARIES,
    AV2E_SET_TRANSFER_CHARACTERISTICS,
    AV2E_SET_MATRIX_COEFFICIENTS,
    AV2E_SET_CHROMA_SAMPLE_POSITION,
    AV2E_SET_COLOR_RANGE,
];

// color range re-triggers `update_extra_cfg`
#[repr(C)]
#[derive(Clone, Copy)]
pub struct AvmTmpl {
    off: usize,
    len: usize,
    range: i32,
}

#[cold]
#[inline(never)]
pub fn set_avm_base(c: &mut AvmCodecEncCfg, inf: &VidInf, w: u32, h: u32) -> [i32; AVM_CTRL_CNT] {
    c.g_threads = 1;
    c.g_w = w;
    c.g_h = h;
    c.g_forced_max_frame_width = w;
    c.g_forced_max_frame_height = h;
    c.g_bit_depth = AVM_BITS_10;
    c.g_input_bit_depth = 10;
    c.g_timebase = AvmRational {
        num: inf.fps_den as i32,
        den: inf.fps_num as i32,
    };
    c.rc_end_usage = AVM_Q;
    c.kf_mode = AVM_KF_DISABLED;

    [
        cicp(inf.color_primaries, 0x0040_1FF2),
        cicp(inf.transfer_characteristics, 0x0007_FFF2),
        cicp(inf.matrix_coefficients, 0x0000_7FF3),
        csp(inf.chroma_sample_position),
        i32::from(inf.color_range),
    ]
}

// `known` is bitmask of the CICP codepoints; or UNSPECIFIED (2).
// fold the negative and the oor test into one compare
const fn cicp(v: i8, known: u32) -> i32 {
    let u = v as u8;
    if u < 32 && (known >> u) & 1 != 0 {
        v as i32
    } else {
        2
    }
}

// AVChromaLocation 1..6
const fn csp(v: i8) -> i32 {
    let u = (v as u8).wrapping_sub(1);
    if u < 6 { u as i32 } else { 6 }
}

// cfg-level options own a field of `avm_codec_enc_cfg_t` and land before enc_init
#[cold]
#[inline(never)]
pub fn avm_split(c: &mut AvmCodecEncCfg, params: &str, opts: &mut Vec<u8>) {
    let mut it = params.split_whitespace();
    while let Some(tok) = it.next() {
        let name = unsafe { tok.get_unchecked(2..) };
        let val = unsafe { it.next().unwrap_unchecked() };
        if !set_cfg_arg(c, name, val) {
            opts.extend_from_slice(name.as_bytes());
            opts.push(0);
            opts.extend_from_slice(val.as_bytes());
            opts.push(0);
        }
    }
}

pub fn avm_init(conf: &AvmCodecEncCfg, ec: *mut AvmCodecCtx) {
    // version pins the layout of public structs; avm bumps it for any added, (re)moved fields
    let ret =
        unsafe { avm_codec_enc_init_ver(ec, avm_codec_av2_cx(), conf, 0, AVM_ENCODER_ABI_VERSION) };
    if ret != AVM_CODEC_OK {
        cold_path();
        fatal(format_args!("avm_codec_enc_init failed: {ret}"));
    }
}

// `encoder_init` points the context's config at its internal copy
const fn alg_priv(ec: *const AvmCodecCtx) -> (*const u8, usize) {
    let base = unsafe { (*ec).priv_.cast::<u8>() };
    (base, unsafe {
        (*ec).config.cast::<u8>().offset_from(base) as usize
    })
}

// av2/av2_cx_iface.c reduce_ratio; both terms are positive
const fn reduced(tb: AvmRational) -> (i64, i32) {
    let (num, den) = (tb.num as i64 * TICKS_PER_SEC, tb.den);
    let (mut a, mut b) = (num as u64, den as u64);
    while b > 0 {
        let r = a % b;
        a = b;
        b = r;
    }
    (num / a as i64, den / a as i32)
}

#[cold]
#[inline(never)]
fn extra_len(base: *const u8, off: usize, tb: AvmRational) -> usize {
    let (num, den) = reduced(tb);
    // the last step still reads its full 24 bytes inside the window
    let end = off + AVM_SCAN_MAX - 24;
    let mut found = usize::MAX;
    let mut k = off;
    while k < end {
        let hit = unsafe {
            base.add(k).cast::<i64>().read_unaligned() == num
                && base.add(k + 8).cast::<i32>().read_unaligned() == den
                && base.add(k + 16).cast::<i64>().read_unaligned() == 0
        };
        if hit {
            if found != usize::MAX {
                cold_path();
                fatal("avm: two extra_cfg boundaries in avm_codec_alg_priv");
            }
            found = k - off;
        }
        k += 8;
    }
    if found == usize::MAX {
        cold_path();
        fatal("avm: no extra_cfg boundary in avm_codec_alg_priv");
    }
    found
}

struct AvmLayout {
    off: usize,
    len: usize,
    defaults: Vec<u8>,
}

#[cold]
#[inline(never)]
fn avm_layout(conf: &AvmCodecEncCfg) -> &'static AvmLayout {
    static LAYOUT: OnceLock<AvmLayout> = OnceLock::new();
    LAYOUT.get_or_init(|| {
        let mut e = MaybeUninit::<AvmCodecCtx>::uninit();
        avm_init(conf, e.as_mut_ptr());
        let (base, off) = alg_priv(e.as_ptr().cast());
        let off = off + AVM_CFG_SIZE;
        let len = extra_len(base, off, conf.g_timebase);
        let defaults = unsafe { from_raw_parts(base.add(off), len) }.to_vec();
        unsafe { avm_codec_destroy(e.as_mut_ptr()) };
        AvmLayout { off, len, defaults }
    })
}

#[cold]
#[inline(never)]
pub fn avm_snapshot(
    conf: &AvmCodecEncCfg,
    ctrls: &[i32; AVM_CTRL_CNT],
    opts: &[u8],
) -> (AvmTmpl, Vec<u8>) {
    let lay = avm_layout(conf);
    let mut e = MaybeUninit::<AvmCodecCtx>::uninit();
    let ep = e.as_mut_ptr();
    avm_init(conf, ep);
    let (base, _) = alg_priv(e.as_ptr().cast());

    if unsafe { from_raw_parts(base.add(lay.off), lay.len) } != lay.defaults {
        cold_path();
        fatal("avm: per-instance state where av2_extracfg is expected");
    }

    for (&id, &v) in AVM_CTRL_IDS.iter().zip(ctrls) {
        unsafe { avm_codec_control(ep, id, v) };
    }
    avm_apply_opts(ep, opts);

    let extra = unsafe { from_raw_parts(base.add(lay.off), lay.len) }.to_vec();
    unsafe { avm_codec_destroy(ep) };

    (
        AvmTmpl {
            off: lay.off,
            len: lay.len,
            range: ctrls[AVM_CTRL_CNT - 1],
        },
        extra,
    )
}

pub fn avm_blit(ec: *mut AvmCodecCtx, t: AvmTmpl, extra: &[u8]) {
    unsafe {
        copy_nonoverlapping(extra.as_ptr(), (*ec).priv_.cast::<u8>().add(t.off), t.len);
        avm_codec_control(ec, AV2E_SET_COLOR_RANGE, t.range);
    }
}

#[cold]
#[inline(never)]
fn avm_apply_opts(ctx: *mut AvmCodecCtx, mut p: &[u8]) {
    while !p.is_empty() {
        let n = nul(p);
        let (name, rest) = unsafe { (p.get_unchecked(..n), p.get_unchecked(n + 1..)) };
        let m = nul(rest);
        let val = unsafe { rest.get_unchecked(..m) };
        let ret = unsafe { avm_codec_set_option(ctx, name.as_ptr().cast(), val.as_ptr().cast()) };
        if ret != AVM_CODEC_OK {
            cold_path();
            fatal(format_args!("avm: rejected --{}={}", text(name), text(val)));
        }
        p = unsafe { rest.get_unchecked(m + 1..) };
    }
}

fn nul(b: &[u8]) -> usize {
    unsafe { b.iter().position(|&c| c == 0).unwrap_unchecked() }
}

const fn text(b: &[u8]) -> &str {
    unsafe { from_utf8_unchecked(b) }
}

fn set_cfg_arg(c: &mut AvmCodecEncCfg, name: &str, val: &str) -> bool {
    match name {
        "enable-tcq" => c.enable_tcq = unsafe { val.parse().unwrap_unchecked() },
        "enable-lcr" => c.enable_lcr = unsafe { val.parse().unwrap_unchecked() },
        _ => return false,
    }
    true
}
