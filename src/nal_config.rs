use crate::{
    encoder::Encoder::{self, Avm, SvtAv1, Vvenc, X264, X265},
    nal_parse::{Bits, ParamSets, avc_high, rbsp, skip_hevc_ptl, skip_vvc_ptl},
    util::assume_unreachable,
};

#[must_use]
pub fn nal_codec_private(encoder: Encoder, p: &ParamSets) -> Vec<u8> {
    match encoder {
        X264 => build_avcc(p),
        X265 => build_hvcc(p),
        Vvenc => build_vvcc(p),
        SvtAv1 | Avm => assume_unreachable(),
    }
}

// profile/compat/level are SPS bytes 1..4; the high-profile tail carries chroma + bit
// depth (SPS only encodes for the high profiles)
#[must_use]
pub fn build_avcc(p: &ParamSets) -> Vec<u8> {
    let sps = &p.sps;
    let pps = &p.pps;
    let &[_, profile, compat, level, ..] = sps.as_slice() else {
        return Vec::new();
    };
    let mut c = Vec::with_capacity(16 + sps.len() + pps.len());
    // version=1, profile, compat, level, 0xFF=lengthSizeMinusOne 3, 0xE1=numSPS 1
    c.extend_from_slice(&[1, profile, compat, level, 0xFF, 0xE1]);
    c.extend_from_slice(&(sps.len() as u16).to_be_bytes());
    c.extend_from_slice(sps);
    c.push(1); // numPictureParameterSets
    c.extend_from_slice(&(pps.len() as u16).to_be_bytes());
    c.extend_from_slice(pps);
    if avc_high(u32::from(profile)) {
        let (chroma, bd_luma, bd_chroma) = avc_chroma_depth(sps);
        c.extend_from_slice(&[0xFC | chroma, 0xF8 | bd_luma, 0xF8 | bd_chroma, 0]);
    }
    c
}

// chroma_format_idc, bit_depth_luma_minus8, bit_depth_chroma_minus8 from a high-profile SPS
fn avc_chroma_depth(sps: &[u8]) -> (u8, u8, u8) {
    let mut buf = [0u8; 64];
    let mut b = Bits::new(rbsp(sps, &mut buf));
    b.skip(32); // nal header + profile_idc + constraint flags + level_idc
    b.ue(); // seq_parameter_set_id
    let chroma = b.ue();
    if chroma == 3 {
        b.skip(1); // separate_colour_plane_flag
    }
    let bd_luma = b.ue();
    let bd_chroma = b.ue();
    (chroma as u8, bd_luma as u8, bd_chroma as u8)
}

// The 12byte general PTL is the SPS own de-emulated bytes 3..15; chroma + bit depths follow
// the sub-layer-variable PTL. min_spatial_segmentation/parallelism are 0 (single-slice, 0 tiles)
#[must_use]
pub fn build_hvcc(p: &ParamSets) -> Vec<u8> {
    let mut buf = [0u8; 512];
    let sps = rbsp(&p.sps, &mut buf);
    let Some(ptl) = sps.get(3..15) else {
        return Vec::new();
    };
    let mut b = Bits::new(sps);
    b.skip(20); // nal header(16) + sps_video_parameter_set_id(4)
    let max_sub = b.u(3);
    let nesting = b.flag();
    skip_hevc_ptl(&mut b, max_sub);
    b.ue(); // sps_seq_parameter_set_id
    let chroma = b.ue();
    if chroma == 3 {
        b.skip(1); // separate_colour_plane_flag
    }
    b.ue(); // pic_width_in_luma_samples
    b.ue(); // pic_height_in_luma_samples
    if b.flag() {
        b.ue();
        b.ue();
        b.ue();
        b.ue(); // conformance window
    }
    let bd_luma = b.ue();
    let bd_chroma = b.ue();

    let mut c = Vec::with_capacity(32 + p.vps.len() + p.sps.len() + p.pps.len());
    c.push(1); // configurationVersion
    c.extend_from_slice(ptl); // general profile_space .. level_idc
    c.extend_from_slice(&[0xF0, 0x00]); // min_spatial_segmentation_idc = 0
    c.push(0xFC); // parallelismType = 0
    c.push(0xFC | chroma as u8);
    c.push(0xF8 | bd_luma as u8);
    c.push(0xF8 | bd_chroma as u8);
    c.extend_from_slice(&[0x00, 0x00]); // avgFrameRate = 0
    // constantFrameRate=0 | numTemporalLayers | temporalIdNested | lengthSizeMinusOne=3
    c.push((((max_sub + 1) as u8) << 3) | (u8::from(nesting) << 2) | 3);
    push_nal_arrays(
        &mut c,
        &[
            (32, p.vps.as_slice()),
            (33, p.sps.as_slice()),
            (34, p.pps.as_slice()),
        ],
    );
    c
}

// VvcPTLRecord is the SPS PTL byte-for-byte (num_bytes_constraint_info=1, gci_present=0):
// general_level_idc already byte-aligned identical in both, so a copy lands it
#[must_use]
pub fn build_vvcc(p: &ParamSets) -> Vec<u8> {
    let mut buf = [0u8; 512];
    let sps = rbsp(&p.sps, &mut buf);
    let mut b = Bits::new(sps);
    b.skip(24); // nal header(16) + sps_seq_parameter_set_id(4) + sps_video_parameter_set_id(4)
    let num_sub = b.u(3) + 1;
    let chroma = b.u(2);
    b.skip(2); // sps_log2_ctu_size_minus5
    if !b.flag() {
        return Vec::new(); // sps_ptl_dpb_hrd_params_present_flag
    }
    let ptl_start = b.pos() / 8;
    if !skip_vvc_ptl(&mut b, num_sub - 1) {
        return Vec::new(); // gci present -> minimal record can't carry it
    }
    let Some(ptl) = sps.get(ptl_start..b.pos() / 8) else {
        return Vec::new();
    };
    b.skip(1); // sps_gdr_enabled_flag
    if b.flag() {
        b.skip(1); // sps_res_change_in_clvs_allowed_flag
    }
    let width = b.ue();
    let height = b.ue();
    if b.flag() {
        b.ue();
        b.ue();
        b.ue();
        b.ue(); // conformance window
    }
    if b.flag() {
        return Vec::new(); // sps_subpic_info_present_flag
    }
    let bd = b.ue();

    let mut c = Vec::with_capacity(32 + ptl.len() + p.vps.len() + p.sps.len() + p.pps.len());
    c.push(0xFF); // reserved | LengthSizeMinusOne=3 | ptl_present_flag=1
    // ols_idx=0(9) | num_sublayers(3) | constant_frame_rate=0(2) | chroma_format_idc(2)
    c.extend_from_slice(&(((num_sub as u16) << 4) | chroma as u16).to_be_bytes());
    c.push(((bd as u8) << 5) | 0x1F); // bit_depth_minus8 | reserved
    c.push(0x01); // VvcPTLRecord: num_bytes_constraint_info = 1
    c.extend_from_slice(ptl); // general_profile_idc .. sub_profiles
    c.extend_from_slice(&(width as u16).to_be_bytes()); // max_picture_width
    c.extend_from_slice(&(height as u16).to_be_bytes()); // max_picture_height
    c.extend_from_slice(&[0x00, 0x00]); // avg_frame_rate = 0
    push_nal_arrays(
        &mut c,
        &[
            (14, p.vps.as_slice()),
            (15, p.sps.as_slice()),
            (16, p.pps.as_slice()),
        ],
    );
    c
}

// hvcC/vvcC trailing arrays: one entry per present parameter set, array_completeness=1, 1 NALU each
fn push_nal_arrays(c: &mut Vec<u8>, arrays: &[(u8, &[u8])]) {
    c.push(arrays.iter().filter(|e| !e.1.is_empty()).count() as u8);
    for &(t, nal) in arrays {
        if nal.is_empty() {
            continue;
        }
        c.push(0x80 | t); // array_completeness=1 | NAL_unit_type
        c.extend_from_slice(&1u16.to_be_bytes()); // numNalus
        c.extend_from_slice(&(nal.len() as u16).to_be_bytes());
        c.extend_from_slice(nal);
    }
}
