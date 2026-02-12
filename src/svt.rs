use std::ffi::c_void;

pub const EB_ERROR_NONE: i32 = 0;
pub const EB_BUFFERFLAG_EOS: u32 = 0x0000_0001;

const MAX_TEMPORAL_LAYERS: usize = 6;
const FRAME_UPDATE_TYPES: usize = 7;

#[repr(C)]
pub struct EbComponentType {
    pub size: u32,
    pub p_component_private: *mut c_void,
    pub p_application_private: *mut c_void,
}

#[repr(C)]
pub struct EbBufferHeaderType {
    pub size: u32,
    pub p_buffer: *mut u8,
    pub n_filled_len: u32,
    pub n_alloc_len: u32,
    pub p_app_private: *mut c_void,
    pub wrapper_ptr: *mut c_void,
    pub n_tick_count: u32,
    pub dts: i64,
    pub pts: i64,
    pub temporal_layer_index: u8,
    pub qp: u32,
    pub avg_qp: u32,
    pub pic_type: u32,
    pub luma_sse: u64,
    pub cr_sse: u64,
    pub cb_sse: u64,
    pub flags: u32,
    pub luma_ssim: f64,
    pub cr_ssim: f64,
    pub cb_ssim: f64,
    pub metadata: *mut c_void,
}

#[repr(C)]
pub struct EbSvtIOFormat {
    pub luma: *mut u8,
    pub cb: *mut u8,
    pub cr: *mut u8,
    pub y_stride: u32,
    pub cr_stride: u32,
    pub cb_stride: u32,
}

#[repr(C)]
struct ChromaPoints {
    x: u16,
    y: u16,
}

#[repr(C)]
struct MasteringDisplayInfo {
    r: ChromaPoints,
    g: ChromaPoints,
    b: ChromaPoints,
    white_point: ChromaPoints,
    max_luma: u32,
    min_luma: u32,
}

#[repr(C)]
struct ContentLightLevel {
    max_cll: u16,
    max_fall: u16,
}

#[repr(C)]
struct FixedBuf {
    buf: *mut c_void,
    sz: u64,
}

#[repr(C)]
struct FrameScaleEvts {
    evt_num: u32,
    start_frame_nums: *mut u64,
    resize_kf_denoms: *mut u32,
    resize_denoms: *mut u32,
}

#[repr(C)]
#[allow(clippy::struct_field_names)]
struct SFramePositions {
    sframe_num: u32,
    sframe_posis: *mut u64,
    sframe_qp_num: u32,
    sframe_qps: *mut u8,
    sframe_qp_offsets: *mut i8,
}

#[repr(C)]
pub struct EbSvtAv1EncConfiguration {
    enc_mode: i8,
    intra_period_length: i32,
    intra_refresh_type: i32,
    hierarchical_levels: u32,
    pred_structure: u8,
    source_width: u32,
    source_height: u32,
    forced_max_frame_width: u32,
    forced_max_frame_height: u32,
    frame_rate_numerator: u32,
    frame_rate_denominator: u32,
    encoder_bit_depth: u32,
    encoder_color_format: i32,
    profile: i32,
    tier: u32,
    level: u32,
    color_primaries: i32,
    transfer_characteristics: i32,
    matrix_coefficients: i32,
    color_range: i32,
    mastering_display: MasteringDisplayInfo,
    content_light_level: ContentLightLevel,
    chroma_sample_position: i32,
    rate_control_mode: u8,
    qp: u32,
    use_qp_file: bool,
    target_bit_rate: u32,
    max_bit_rate: u32,
    max_qp_allowed: u32,
    min_qp_allowed: u32,
    vbr_min_section_pct: u32,
    vbr_max_section_pct: u32,
    under_shoot_pct: u32,
    over_shoot_pct: u32,
    mbr_over_shoot_pct: u32,
    starting_buffer_level_ms: i64,
    optimal_buffer_level_ms: i64,
    maximum_buffer_size_ms: i64,
    rc_stats_buffer: FixedBuf,
    pass: i32,
    use_fixed_qindex_offsets: u8,
    qindex_offsets: [i32; MAX_TEMPORAL_LAYERS],
    key_frame_chroma_qindex_offset: i32,
    key_frame_qindex_offset: i32,
    chroma_qindex_offsets: [i32; MAX_TEMPORAL_LAYERS],
    luma_y_dc_qindex_offset: i32,
    chroma_u_dc_qindex_offset: i32,
    chroma_u_ac_qindex_offset: i32,
    chroma_v_dc_qindex_offset: i32,
    chroma_v_ac_qindex_offset: i32,
    enable_dlf_flag: u8,
    film_grain_denoise_strength: u32,
    film_grain_denoise_apply: u8,
    cdef_level: i32,
    enable_restoration_filtering: i32,
    enable_mfmv: i32,
    scene_change_detection: u32,
    tile_columns: i32,
    tile_rows: i32,
    look_ahead_distance: u32,
    recode_loop: u32,
    screen_content_mode: u32,
    aq_mode: u8,
    enable_tf: u8,
    enable_overlays: bool,
    tune: u8,
    superres_mode: u8,
    superres_denom: u8,
    superres_kf_denom: u8,
    superres_qthres: u8,
    superres_kf_qthres: u8,
    superres_auto_search_type: u8,
    fast_decode: u8,
    sframe_dist: i32,
    sframe_mode: i32,
    level_of_parallelism: u32,
    use_cpu_flags: u64,
    stat_report: u32,
    recon_enabled: bool,
    force_key_frames: bool,
    multiply_keyint: bool,
    resize_mode: u8,
    resize_denom: u8,
    resize_kf_denom: u8,
    enable_qm: bool,
    min_qm_level: u8,
    max_qm_level: u8,
    gop_constraint_rc: bool,
    lambda_scale_factors: [i32; FRAME_UPDATE_TYPES],
    enable_dg: bool,
    startup_mg_size: u8,
    startup_qp_offset: i8,
    frame_scale_evts: FrameScaleEvts,
    enable_roi_map: bool,
    tf_strength: u8,
    fgs_table: *mut c_void,
    enable_variance_boost: bool,
    variance_boost_strength: u8,
    variance_octile: u8,
    sharpness: i8,
    variance_boost_curve: u8,
    luminance_qp_bias: u8,
    lossless: bool,
    avif: bool,
    min_chroma_qm_level: u8,
    max_chroma_qm_level: u8,
    rtc: bool,
    qp_scale_compress_strength: u8,
    sframe_posi: SFramePositions,
    sframe_qp: u8,
    sframe_qp_offset: i8,
    adaptive_film_grain: bool,
    max_tx_size: u8,
    extended_crf_qindex_offset: u8,
    ac_bias: f64,
    _padding: [u8; 128],
}

#[link(name = "SvtAv1Enc")]
unsafe extern "C" {
    pub fn svt_av1_enc_init_handle(
        p_handle: *mut *mut EbComponentType,
        config_ptr: *mut EbSvtAv1EncConfiguration,
    ) -> i32;

    pub fn svt_av1_enc_set_parameter(
        svt_enc_component: *mut EbComponentType,
        config: *mut EbSvtAv1EncConfiguration,
    ) -> i32;

    pub fn svt_av1_enc_parse_parameter(
        config: *mut EbSvtAv1EncConfiguration,
        name: *const i8,
        value: *const i8,
    ) -> i32;

    pub fn svt_av1_enc_init(svt_enc_component: *mut EbComponentType) -> i32;

    pub fn svt_av1_enc_send_picture(
        svt_enc_component: *mut EbComponentType,
        p_buffer: *mut EbBufferHeaderType,
    ) -> i32;

    pub fn svt_av1_enc_get_packet(
        svt_enc_component: *mut EbComponentType,
        p_buffer: *mut *mut EbBufferHeaderType,
        pic_send_done: u8,
    ) -> i32;

    pub fn svt_av1_enc_release_out_buffer(p_buffer: *mut *mut EbBufferHeaderType);

    pub fn svt_av1_enc_deinit(svt_enc_component: *mut EbComponentType) -> i32;

    pub fn svt_av1_enc_deinit_handle(svt_enc_component: *mut EbComponentType) -> i32;

}
