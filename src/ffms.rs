use std::ffi::CString;
use std::path::Path;
use std::sync::Arc;

use ffms2_sys::{
    FFMS_CreateIndexer, FFMS_CreateVideoSource, FFMS_DestroyIndex, FFMS_DestroyVideoSource,
    FFMS_DoIndexing2, FFMS_ErrorInfo, FFMS_Frame, FFMS_GetFirstIndexedTrackOfType, FFMS_GetFrame,
    FFMS_GetVideoProperties, FFMS_Index, FFMS_IndexBelongsToFile, FFMS_Init, FFMS_ReadIndex,
    FFMS_SetProgressCallback, FFMS_TrackTypeIndexSettings, FFMS_VideoSource, FFMS_WriteIndex,
};

use crate::decode::CropCalc;
use crate::progs::ProgsBar;

pub const fn gcd(mut a: u64, mut b: u64) -> u64 {
    while b != 0 {
        let t = b;
        b = a % b;
        a = t;
    }
    a
}

#[derive(Clone)]
pub struct VidInf {
    pub width: u32,
    pub height: u32,
    pub dar: Option<(u32, u32)>,
    pub fps_num: u32,
    pub fps_den: u32,
    pub frames: usize,
    pub color_primaries: Option<i32>,
    pub transfer_characteristics: Option<i32>,
    pub matrix_coefficients: Option<i32>,
    pub is_10bit: bool,
    pub color_range: Option<i32>,
    pub chroma_sample_position: Option<i32>,
    pub mastering_display: Option<String>,
    pub content_light: Option<String>,
}

pub struct VidIdx {
    pub path: String,
    pub track: i32,
    pub idx_handle: *mut FFMS_Index,
}

extern "C" fn idx_progs(
    current: i64,
    total: i64,
    ic_private: *mut ::std::os::raw::c_void,
) -> ::std::os::raw::c_int {
    unsafe {
        let progs = &mut *ic_private.cast::<crate::progs::ProgsBar>();
        progs.up_idx(current as usize, total as usize);
    }
    0
}

impl VidIdx {
    pub fn new(path: &Path, progs: bool) -> Result<Arc<Self>, Box<dyn std::error::Error>> {
        unsafe {
            FFMS_Init(0, 0);

            let source = CString::new(path.to_str().unwrap())?;
            let mut err = std::mem::zeroed::<FFMS_ErrorInfo>();

            let idx_path = format!("{}.ffindex", path.display());
            let idx_cstr = CString::new(idx_path.as_str())?;

            let mut idx = if std::path::Path::new(&idx_path).exists() {
                FFMS_ReadIndex(idx_cstr.as_ptr(), std::ptr::addr_of_mut!(err))
            } else {
                std::ptr::null_mut()
            };

            if !idx.is_null()
                && FFMS_IndexBelongsToFile(idx, source.as_ptr(), std::ptr::addr_of_mut!(err)) != 0
            {
                FFMS_DestroyIndex(idx);
                idx = std::ptr::null_mut();
            }

            let idx = if idx.is_null() {
                let idxer = FFMS_CreateIndexer(source.as_ptr(), std::ptr::addr_of_mut!(err));
                if idxer.is_null() {
                    return Err("Failed to create idxer".into());
                }

                FFMS_TrackTypeIndexSettings(idxer, 1, 0, 0);
                FFMS_TrackTypeIndexSettings(idxer, 2, 0, 0);

                let idx = if progs {
                    let mut progs = crate::progs::ProgsBar::new();
                    FFMS_SetProgressCallback(
                        idxer,
                        Some(idx_progs),
                        std::ptr::addr_of_mut!(progs).cast::<libc::c_void>(),
                    );
                    let idx = FFMS_DoIndexing2(idxer, 0, std::ptr::addr_of_mut!(err));
                    ProgsBar::finish();
                    idx
                } else {
                    FFMS_DoIndexing2(idxer, 0, std::ptr::addr_of_mut!(err))
                };

                if idx.is_null() {
                    return Err("Failed to idx file".into());
                }

                FFMS_WriteIndex(idx_cstr.as_ptr(), idx, std::ptr::addr_of_mut!(err));
                idx
            } else {
                idx
            };

            let track = FFMS_GetFirstIndexedTrackOfType(idx, 0, std::ptr::addr_of_mut!(err));

            Ok(Arc::new(Self { path: path.to_str().unwrap().to_string(), track, idx_handle: idx }))
        }
    }
}

impl Drop for VidIdx {
    fn drop(&mut self) {
        unsafe {
            if !self.idx_handle.is_null() {
                FFMS_DestroyIndex(self.idx_handle);
            }
        }
    }
}

unsafe impl Send for VidIdx {}
unsafe impl Sync for VidIdx {}

pub fn get_vidinf(idx: &Arc<VidIdx>) -> Result<VidInf, Box<dyn std::error::Error>> {
    unsafe {
        let source = CString::new(idx.path.as_str())?;
        let mut err = std::mem::zeroed::<FFMS_ErrorInfo>();

        let video = FFMS_CreateVideoSource(
            source.as_ptr(),
            idx.track,
            idx.idx_handle,
            1,
            1,
            std::ptr::addr_of_mut!(err),
        );

        if video.is_null() {
            return Err("Failed to create vid src".into());
        }

        let props = FFMS_GetVideoProperties(video);
        let frame = FFMS_GetFrame(video, 0, std::ptr::addr_of_mut!(err));

        let matrix_coeff = match if (*frame).ColorSpace == 3 {
            (*props).ColorSpace
        } else {
            (*frame).ColorSpace
        } {
            0 => 2,
            x => x,
        };

        let width = (*frame).EncodedWidth as u32;
        let height = (*frame).EncodedHeight as u32;
        let y_linesize = (*frame).Linesize[0] as usize;
        let is_10bit = y_linesize >= (width as usize) * 2;

        let color_range = match (*frame).ColorRange {
            1 => Some(0),
            2 => Some(1),
            _ => None,
        };

        let chroma_sample_position = match (*frame).ChromaLocation {
            1 => Some(1),
            3 => Some(2),
            _ => None,
        };

        let mastering_display = if (*props).HasMasteringDisplayPrimaries != 0
            && (*props).HasMasteringDisplayLuminance != 0
        {
            Some(format!(
                "G({:.4},{:.4})B({:.4},{:.4})R({:.4},{:.4})WP({:.4},{:.4})L({:.4},{:.4})",
                (*props).MasteringDisplayPrimariesX[1],
                (*props).MasteringDisplayPrimariesY[1],
                (*props).MasteringDisplayPrimariesX[2],
                (*props).MasteringDisplayPrimariesY[2],
                (*props).MasteringDisplayPrimariesX[0],
                (*props).MasteringDisplayPrimariesY[0],
                (*props).MasteringDisplayWhitePointX,
                (*props).MasteringDisplayWhitePointY,
                (*props).MasteringDisplayMaxLuminance,
                (*props).MasteringDisplayMinLuminance
            ))
        } else {
            None
        };

        let content_light = if (*props).HasContentLightLevel != 0 {
            Some(format!("{},{}", (*props).ContentLightLevelMax, (*props).ContentLightLevelAverage))
        } else {
            None
        };

        let (sar_n, sar_d) = ((*props).SARNum, (*props).SARDen);
        let dar = if sar_n > 0 && sar_d > 0 && sar_n != sar_d {
            let dw = u64::from(width) * sar_n as u64;
            let dh = u64::from(height) * sar_d as u64;
            let g = gcd(dw, dh);
            Some(((dw / g) as u32, (dh / g) as u32))
        } else {
            None
        };

        let inf = VidInf {
            width,
            height,
            dar,
            fps_num: (*props).FPSNumerator as u32,
            fps_den: (*props).FPSDenominator as u32,
            frames: (*props).NumFrames as usize,
            color_primaries: Some((*frame).ColorPrimaries),
            transfer_characteristics: Some((*frame).TransferCharateristics),
            matrix_coefficients: Some(matrix_coeff),
            is_10bit,
            color_range,
            chroma_sample_position,
            mastering_display,
            content_light,
        };

        FFMS_DestroyVideoSource(video);

        Ok(inf)
    }
}

pub fn thr_vid_src(
    idx: &Arc<VidIdx>,
    threads: i32,
) -> Result<*mut FFMS_VideoSource, Box<dyn std::error::Error>> {
    unsafe {
        let source = CString::new(idx.path.as_str())?;
        let mut err = std::mem::zeroed::<FFMS_ErrorInfo>();

        let video = FFMS_CreateVideoSource(
            source.as_ptr(),
            idx.track,
            idx.idx_handle,
            threads,
            0,
            std::ptr::addr_of_mut!(err),
        );

        Ok(video)
    }
}

#[inline]
const fn packed_row_size(w: usize) -> usize {
    (w * 2 * 5).div_ceil(8).next_multiple_of(5)
}

pub const fn calc_8bit_size(w: u32, h: u32) -> usize {
    (w * h * 3 / 2) as usize
}

pub const fn calc_packed_size(w: u32, h: u32) -> usize {
    let y_row = packed_row_size(w as usize);
    let uv_row = packed_row_size(w as usize / 2);
    y_row * h as usize + uv_row * h as usize
}

fn copy_with_stride(src: *const u8, stride: usize, width: usize, height: usize, dst: *mut u8) {
    unsafe {
        for row in 0..height {
            std::ptr::copy_nonoverlapping(src.add(row * stride), dst.add(row * width), width);
        }
    }
}

pub fn extr_8bit(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    inf: &VidInf,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let width = inf.width as usize;
        let height = inf.height as usize;
        let y_size = width * height;
        let uv_size = y_size / 4;

        let y_linesize = (*frame).Linesize[0] as usize;
        copy_with_stride((*frame).Data[0], y_linesize, width, height, output.as_mut_ptr());
        copy_with_stride(
            (*frame).Data[1],
            (*frame).Linesize[1] as usize,
            width / 2,
            height / 2,
            output.as_mut_ptr().add(y_size),
        );
        copy_with_stride(
            (*frame).Data[2],
            (*frame).Linesize[2] as usize,
            width / 2,
            height / 2,
            output.as_mut_ptr().add(y_size + uv_size),
        );
    }
}

pub fn extr_8bit_crop_fast(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    cc: &crate::decode::CropCalc,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let y_sz = cc.new_w as usize * cc.new_h as usize;
        let uv_sz = y_sz / 4;

        std::ptr::copy_nonoverlapping((*frame).Data[0].add(cc.y_start), output.as_mut_ptr(), y_sz);
        std::ptr::copy_nonoverlapping(
            (*frame).Data[1].add(cc.uv_off),
            output.as_mut_ptr().add(y_sz),
            uv_sz,
        );
        std::ptr::copy_nonoverlapping(
            (*frame).Data[2].add(cc.uv_off),
            output.as_mut_ptr().add(y_sz + uv_sz),
            uv_sz,
        );
    }
}

pub fn extr_8bit_crop(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    cc: &crate::decode::CropCalc,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let mut pos = 0;

        for row in 0..cc.new_h as usize {
            std::ptr::copy_nonoverlapping(
                (*frame).Data[0].add(cc.y_start + row * cc.y_stride),
                output.as_mut_ptr().add(pos),
                cc.y_len,
            );
            pos += cc.y_len;
        }

        for row in 0..cc.new_h as usize / 2 {
            std::ptr::copy_nonoverlapping(
                (*frame).Data[1].add(cc.uv_off + row * cc.uv_stride),
                output.as_mut_ptr().add(pos),
                cc.uv_len,
            );
            pos += cc.uv_len;
        }

        for row in 0..cc.new_h as usize / 2 {
            std::ptr::copy_nonoverlapping(
                (*frame).Data[2].add(cc.uv_off + row * cc.uv_stride),
                output.as_mut_ptr().add(pos),
                cc.uv_len,
            );
            pos += cc.uv_len;
        }
    }
}

pub fn extr_8bit_fast(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    inf: &VidInf,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let width = inf.width as usize;
        let height = inf.height as usize;
        let y_size = width * height;
        let uv_size = y_size / 4;

        std::ptr::copy_nonoverlapping((*frame).Data[0], output.as_mut_ptr(), y_size);
        std::ptr::copy_nonoverlapping((*frame).Data[1], output.as_mut_ptr().add(y_size), uv_size);
        std::ptr::copy_nonoverlapping(
            (*frame).Data[2],
            output.as_mut_ptr().add(y_size + uv_size),
            uv_size,
        );
    }
}

pub fn conv_to_10bit(input: &[u8], output: &mut [u8]) {
    input.iter().zip(output.chunks_exact_mut(2)).for_each(|(&pixel, out_chunk)| {
        let pixel_10bit = (u16::from(pixel) << 2).to_le_bytes();
        out_chunk.copy_from_slice(&pixel_10bit);
    });
}

#[inline]
pub fn pack_4_pix_10bit(input: [u8; 8], output: &mut [u8; 5]) {
    let p0 = u64::from(u16::from_le_bytes([input[0], input[1]]));
    let p1 = u64::from(u16::from_le_bytes([input[2], input[3]]));
    let p2 = u64::from(u16::from_le_bytes([input[4], input[5]]));
    let p3 = u64::from(u16::from_le_bytes([input[6], input[7]]));
    let packed: u64 = p0 | (p1 << 10) | (p2 << 20) | (p3 << 30);
    let bytes = packed.to_le_bytes();
    output.copy_from_slice(&bytes[..5]);
}

#[inline]
pub fn unpack_4_pix_10bit(input: [u8; 5], output: &mut [u8; 8]) {
    let packed = u64::from(u32::from_le_bytes(input[0..4].try_into().unwrap()))
        | (u64::from(input[4]) << 32);

    let p0 = (packed & 0x3FF) as u16;
    let p1 = ((packed >> 10) & 0x3FF) as u16;
    let p2 = ((packed >> 20) & 0x3FF) as u16;
    let p3 = ((packed >> 30) & 0x3FF) as u16;

    output[0..2].copy_from_slice(&p0.to_le_bytes());
    output[2..4].copy_from_slice(&p1.to_le_bytes());
    output[4..6].copy_from_slice(&p2.to_le_bytes());
    output[6..8].copy_from_slice(&p3.to_le_bytes());
}

pub fn pack_10bit(input: &[u8], output: &mut [u8]) {
    input.chunks_exact(8).zip(output.chunks_exact_mut(5)).for_each(|(i_chunk, o_chunk)| {
        let i_arr: &[u8; 8] = i_chunk.try_into().unwrap();
        let o_arr: &mut [u8; 5] = o_chunk.try_into().unwrap();
        pack_4_pix_10bit(*i_arr, o_arr);
    });
}

pub fn unpack_10bit(input: &[u8], output: &mut [u8], _w: usize, _h: usize) {
    input.chunks_exact(5).zip(output.chunks_exact_mut(8)).for_each(|(i_chunk, o_chunk)| {
        let i_arr: &[u8; 5] = i_chunk.try_into().unwrap();
        let o_arr: &mut [u8; 8] = o_chunk.try_into().unwrap();
        unpack_4_pix_10bit(*i_arr, o_arr);
    });
}

pub fn unpack_10bit_rem(input: &[u8], output: &mut [u8], w: usize, h: usize) {
    let y_packed = packed_row_size(w) * h;
    let uv_packed = packed_row_size(w / 2) * (h / 2);

    unpack_plane_rem(&input[..y_packed], &mut output[..w * h * 2], w, h);
    unpack_plane_rem(
        &input[y_packed..y_packed + uv_packed],
        &mut output[w * h * 2..w * h * 2 + w * h / 2],
        w / 2,
        h / 2,
    );
    unpack_plane_rem(
        &input[y_packed + uv_packed..],
        &mut output[w * h * 2 + w * h / 2..],
        w / 2,
        h / 2,
    );
}

fn unpack_plane_rem(input: &[u8], output: &mut [u8], w: usize, h: usize) {
    let unpacked_row = w * 2;
    let packed_row = packed_row_size(w);

    for row in 0..h {
        let src = &input[row * packed_row..row * packed_row + packed_row];
        let dst = &mut output[row * unpacked_row..row * unpacked_row + unpacked_row];

        src.chunks_exact(5).zip(dst.chunks_exact_mut(8)).for_each(|(i, o)| {
            unpack_4_pix_10bit(i.try_into().unwrap(), o.try_into().unwrap());
        });

        let rem = unpacked_row % 8;
        if rem > 0 {
            let mut tmp = [0u8; 8];
            unpack_4_pix_10bit((&src[packed_row - 5..]).try_into().unwrap(), &mut tmp);
            dst[unpacked_row - rem..].copy_from_slice(&tmp[..rem]);
        }
    }
}

fn pack_stride(src: *const u8, stride: usize, w: usize, h: usize, out: *mut u8) {
    unsafe {
        let w_bytes = w * 2;
        let pack_row = (w_bytes * 5) / 8;
        let mut pos = 0;

        for row in 0..h {
            let src_row = std::slice::from_raw_parts(src.add(row * stride), w_bytes);
            let dst_row = std::slice::from_raw_parts_mut(out.add(pos), pack_row);

            src_row.chunks_exact(8).zip(dst_row.chunks_exact_mut(5)).for_each(|(i, o)| {
                pack_4_pix_10bit(i.try_into().unwrap(), o.try_into().unwrap());
            });

            pos += pack_row;
        }
    }
}

pub fn extr_10bit_crop_fast(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    cc: &crate::decode::CropCalc,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let w = cc.new_w as usize;
        let h = cc.new_h as usize;
        let y_pack = (w * h * 5) / 4;
        let uv_pack = (w * h / 4 * 5) / 4;

        let y_src = std::slice::from_raw_parts((*frame).Data[0].add(cc.y_start), w * h * 2);
        pack_10bit(y_src, &mut output[..y_pack]);

        let u_src = std::slice::from_raw_parts((*frame).Data[1].add(cc.uv_off), w * h / 2);
        pack_10bit(u_src, &mut output[y_pack..y_pack + uv_pack]);

        let v_src = std::slice::from_raw_parts((*frame).Data[2].add(cc.uv_off), w * h / 2);
        pack_10bit(v_src, &mut output[y_pack + uv_pack..]);
    }
}

pub fn extr_10bit_crop(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    cc: &crate::decode::CropCalc,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let w = cc.new_w as usize;
        let h = cc.new_h as usize;
        let y_pack = (w * h * 5) / 4;
        let uv_pack = (w * h / 4 * 5) / 4;

        pack_stride(
            (*frame).Data[0].add(cc.y_start),
            (*frame).Linesize[0] as usize,
            w,
            h,
            output.as_mut_ptr(),
        );
        pack_stride(
            (*frame).Data[1].add(cc.uv_off),
            (*frame).Linesize[1] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack),
        );
        pack_stride(
            (*frame).Data[2].add(cc.uv_off),
            (*frame).Linesize[2] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack + uv_pack),
        );
    }
}

#[derive(Clone, Copy)]
pub enum DecodeStrat {
    B10Fast,
    B10FastRem,
    B10Stride,
    B10StrideRem,
    B10Crop { cc: CropCalc },
    B10CropRem { cc: CropCalc },
    B10CropFast { cc: CropCalc },
    B10CropFastRem { cc: CropCalc },
    B10CropStride { cc: CropCalc },
    B10CropStrideRem { cc: CropCalc },
    B8Fast,
    B8Stride,
    B8Crop { cc: CropCalc },
    B8CropFast { cc: CropCalc },
    B8CropStride { cc: CropCalc },
}

pub fn get_decode_strat(
    idx: &Arc<VidIdx>,
    inf: &VidInf,
    crop: (u32, u32),
) -> Result<DecodeStrat, Box<dyn std::error::Error>> {
    unsafe {
        let source = CString::new(idx.path.as_str())?;
        let mut err = std::mem::zeroed::<FFMS_ErrorInfo>();

        let video = FFMS_CreateVideoSource(
            source.as_ptr(),
            idx.track,
            idx.idx_handle,
            1,
            1,
            std::ptr::addr_of_mut!(err),
        );

        if video.is_null() {
            return Err("Failed to create vid src".into());
        }

        let frame = FFMS_GetFrame(video, 0, std::ptr::addr_of_mut!(err));
        let y_ls = (*frame).Linesize[0] as usize;
        FFMS_DestroyVideoSource(video);

        let pix_sz = if inf.is_10bit { 2 } else { 1 };
        let expected = inf.width as usize * pix_sz;
        let has_pad = y_ls != expected;
        let has_crop = crop != (0, 0);
        let h_crop = crop.1 != 0;

        let final_w = if has_crop { inf.width - crop.1 * 2 } else { inf.width };
        let has_rem = inf.is_10bit && (final_w % 8) != 0;

        let strat = match (inf.is_10bit, has_crop, has_pad, h_crop, has_rem) {
            (true, false, false, _, false) => DecodeStrat::B10Fast,
            (true, false, false, _, true) => DecodeStrat::B10FastRem,
            (true, false, true, _, false) => DecodeStrat::B10Stride,
            (true, false, true, _, true) => DecodeStrat::B10StrideRem,
            (true, true, false, false, false) => {
                DecodeStrat::B10CropFast { cc: CropCalc::new(inf, crop, 2) }
            }
            (true, true, false, false, true) => {
                DecodeStrat::B10CropFastRem { cc: CropCalc::new(inf, crop, 2) }
            }
            (true, true, false, true, false) => {
                DecodeStrat::B10Crop { cc: CropCalc::new(inf, crop, 2) }
            }
            (true, true, false, true, true) => {
                DecodeStrat::B10CropRem { cc: CropCalc::new(inf, crop, 2) }
            }
            (true, true, true, _, false) => {
                DecodeStrat::B10CropStride { cc: CropCalc::new(inf, crop, 2) }
            }
            (true, true, true, _, true) => {
                DecodeStrat::B10CropStrideRem { cc: CropCalc::new(inf, crop, 2) }
            }
            (false, false, false, _, _) => DecodeStrat::B8Fast,
            (false, false, true, _, _) => DecodeStrat::B8Stride,
            (false, true, false, false, _) => {
                DecodeStrat::B8CropFast { cc: CropCalc::new(inf, crop, 1) }
            }
            (false, true, false, true, _) => {
                DecodeStrat::B8Crop { cc: CropCalc::new(inf, crop, 1) }
            }
            (false, true, true, _, _) => {
                DecodeStrat::B8CropStride { cc: CropCalc::new(inf, crop, 1) }
            }
        };

        Ok(strat)
    }
}

pub fn get_raw_frame(vid_src: *mut FFMS_VideoSource, frame_idx: usize) -> *const FFMS_Frame {
    unsafe {
        let mut err = std::mem::zeroed::<FFMS_ErrorInfo>();
        FFMS_GetFrame(vid_src, i32::try_from(frame_idx).unwrap_or(0), std::ptr::addr_of_mut!(err))
    }
}

pub fn extr_10bit_pack(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    inf: &VidInf,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let w = inf.width as usize;
        let h = inf.height as usize;
        let y_pack = (w * h * 5) / 4;
        let uv_pack = (w * h / 4 * 5) / 4;

        let y_src = std::slice::from_raw_parts((*frame).Data[0], w * h * 2);
        pack_10bit(y_src, &mut output[..y_pack]);

        let u_src = std::slice::from_raw_parts((*frame).Data[1], w * h / 2);
        pack_10bit(u_src, &mut output[y_pack..y_pack + uv_pack]);

        let v_src = std::slice::from_raw_parts((*frame).Data[2], w * h / 2);
        pack_10bit(v_src, &mut output[y_pack + uv_pack..]);
    }
}

pub fn extr_10bit_pack_stride(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    inf: &VidInf,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let w = inf.width as usize;
        let h = inf.height as usize;
        let y_pack = (w * h * 5) / 4;
        let uv_pack = (w * h / 4 * 5) / 4;

        pack_stride((*frame).Data[0], (*frame).Linesize[0] as usize, w, h, output.as_mut_ptr());

        pack_stride(
            (*frame).Data[1],
            (*frame).Linesize[1] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack),
        );

        pack_stride(
            (*frame).Data[2],
            (*frame).Linesize[2] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack + uv_pack),
        );
    }
}

pub fn extr_8bit_stride(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    inf: &VidInf,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let width = inf.width as usize;
        let height = inf.height as usize;

        let y_linesize = (*frame).Linesize[0] as usize;
        let uv_linesize = (*frame).Linesize[1] as usize;

        let mut pos = 0;

        for row in 0..height {
            std::ptr::copy_nonoverlapping(
                (*frame).Data[0].add(row * y_linesize),
                output.as_mut_ptr().add(pos),
                width,
            );
            pos += width;
        }

        for row in 0..height / 2 {
            std::ptr::copy_nonoverlapping(
                (*frame).Data[1].add(row * uv_linesize),
                output.as_mut_ptr().add(pos),
                width / 2,
            );
            pos += width / 2;
        }

        for row in 0..height / 2 {
            std::ptr::copy_nonoverlapping(
                (*frame).Data[2].add(row * uv_linesize),
                output.as_mut_ptr().add(pos),
                width / 2,
            );
            pos += width / 2;
        }
    }
}

pub fn extr_10bit_crop_pack_stride(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    crop_calc: &CropCalc,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let w = crop_calc.new_w as usize;
        let h = crop_calc.new_h as usize;
        let pix_sz = 2;

        let y_linesize = (*frame).Linesize[0] as usize;
        let uv_linesize = (*frame).Linesize[1] as usize;

        let mut dst_pos = 0;
        let pack_row_y = (w * 2 * 5) / 8;

        for row in 0..h {
            let src_off = (crop_calc.crop_h as usize * pix_sz)
                + (row + crop_calc.crop_v as usize) * y_linesize;
            let src_row =
                std::slice::from_raw_parts((*frame).Data[0].add(src_off), crop_calc.y_len);
            let dst_row =
                std::slice::from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), pack_row_y);

            src_row.chunks_exact(8).zip(dst_row.chunks_exact_mut(5)).for_each(|(i, o)| {
                pack_4_pix_10bit(i.try_into().unwrap(), o.try_into().unwrap());
            });

            dst_pos += pack_row_y;
        }

        let pack_row_uv = (w / 2 * 2 * 5) / 8;

        for row in 0..h / 2 {
            let src_off = (crop_calc.crop_h as usize / 2 * pix_sz)
                + (row + crop_calc.crop_v as usize / 2) * uv_linesize;
            let src_row =
                std::slice::from_raw_parts((*frame).Data[1].add(src_off), crop_calc.uv_len);
            let dst_row =
                std::slice::from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), pack_row_uv);

            src_row.chunks_exact(8).zip(dst_row.chunks_exact_mut(5)).for_each(|(i, o)| {
                pack_4_pix_10bit(i.try_into().unwrap(), o.try_into().unwrap());
            });

            dst_pos += pack_row_uv;
        }

        for row in 0..h / 2 {
            let src_off = (crop_calc.crop_h as usize / 2 * pix_sz)
                + (row + crop_calc.crop_v as usize / 2) * uv_linesize;
            let src_row =
                std::slice::from_raw_parts((*frame).Data[2].add(src_off), crop_calc.uv_len);
            let dst_row =
                std::slice::from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), pack_row_uv);

            src_row.chunks_exact(8).zip(dst_row.chunks_exact_mut(5)).for_each(|(i, o)| {
                pack_4_pix_10bit(i.try_into().unwrap(), o.try_into().unwrap());
            });

            dst_pos += pack_row_uv;
        }
    }
}

fn pack_stride_rem(src: *const u8, stride: usize, w: usize, h: usize, out: *mut u8) {
    let w_bytes = w * 2;
    let y_row = packed_row_size(w);

    unsafe {
        for row in 0..h {
            let src_row = std::slice::from_raw_parts(src.add(row * stride), w_bytes);
            let dst_row = std::slice::from_raw_parts_mut(out.add(row * y_row), y_row);

            src_row.chunks_exact(8).zip(dst_row.chunks_exact_mut(5)).for_each(|(i, o)| {
                pack_4_pix_10bit(i.try_into().unwrap(), o.try_into().unwrap());
            });

            let rem = w_bytes % 8;
            if rem > 0 {
                let mut tmp = [0u8; 8];
                tmp[..rem].copy_from_slice(&src_row[w_bytes - rem..]);
                pack_4_pix_10bit(tmp, (&mut dst_row[y_row - 5..]).try_into().unwrap());
            }
        }
    }
}

pub fn pack_10bit_rem(input: &[u8], output: &mut [u8], w: usize, h: usize) {
    let unpacked_row = w * 2;
    let y_row = packed_row_size(w);

    for row in 0..h {
        let src = &input[row * unpacked_row..][..unpacked_row];
        let dst = &mut output[row * y_row..][..y_row];

        src.chunks_exact(8).zip(dst.chunks_exact_mut(5)).for_each(|(i, o)| {
            pack_4_pix_10bit(i.try_into().unwrap(), o.try_into().unwrap());
        });

        let rem = unpacked_row % 8;
        if rem > 0 {
            let mut tmp = [0u8; 8];
            tmp[..rem].copy_from_slice(&src[unpacked_row - rem..]);
            pack_4_pix_10bit(tmp, (&mut dst[y_row - 5..]).try_into().unwrap());
        }
    }
}

pub fn extr_10bit_pack_rem(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    inf: &VidInf,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let w = inf.width as usize;
        let h = inf.height as usize;

        let y_row = packed_row_size(w);
        let uv_row = packed_row_size(w / 2);
        let y_pack = y_row * h;
        let uv_pack = uv_row * h / 2;

        let y_src = std::slice::from_raw_parts((*frame).Data[0], w * h * 2);
        pack_10bit_rem(y_src, &mut output[..y_pack], w, h);

        let u_src = std::slice::from_raw_parts((*frame).Data[1], w * h / 2);
        pack_10bit_rem(u_src, &mut output[y_pack..y_pack + uv_pack], w / 2, h / 2);

        let v_src = std::slice::from_raw_parts((*frame).Data[2], w * h / 2);
        pack_10bit_rem(v_src, &mut output[y_pack + uv_pack..], w / 2, h / 2);
    }
}

pub fn extr_10bit_pack_stride_rem(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    inf: &VidInf,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let w = inf.width as usize;
        let h = inf.height as usize;

        let y_row = packed_row_size(w);
        let uv_row = packed_row_size(w / 2);
        let y_pack = y_row * h;
        let uv_pack = uv_row * h / 2;

        pack_stride_rem((*frame).Data[0], (*frame).Linesize[0] as usize, w, h, output.as_mut_ptr());
        pack_stride_rem(
            (*frame).Data[1],
            (*frame).Linesize[1] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack),
        );
        pack_stride_rem(
            (*frame).Data[2],
            (*frame).Linesize[2] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack + uv_pack),
        );
    }
}

pub fn extr_10bit_crop_fast_rem(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    cc: &crate::decode::CropCalc,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let w = cc.new_w as usize;
        let h = cc.new_h as usize;

        let y_row = packed_row_size(w);
        let uv_row = packed_row_size(w / 2);
        let y_pack = y_row * h;
        let uv_pack = uv_row * h / 2;

        let y_src = std::slice::from_raw_parts((*frame).Data[0].add(cc.y_start), w * h * 2);
        pack_10bit_rem(y_src, &mut output[..y_pack], w, h);

        let u_src = std::slice::from_raw_parts((*frame).Data[1].add(cc.uv_off), w * h / 2);
        pack_10bit_rem(u_src, &mut output[y_pack..y_pack + uv_pack], w / 2, h / 2);

        let v_src = std::slice::from_raw_parts((*frame).Data[2].add(cc.uv_off), w * h / 2);
        pack_10bit_rem(v_src, &mut output[y_pack + uv_pack..], w / 2, h / 2);
    }
}

pub fn extr_10bit_crop_rem(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    cc: &crate::decode::CropCalc,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let w = cc.new_w as usize;
        let h = cc.new_h as usize;

        let y_row = packed_row_size(w);
        let uv_row = packed_row_size(w / 2);
        let y_pack = y_row * h;
        let uv_pack = uv_row * h / 2;

        pack_stride_rem(
            (*frame).Data[0].add(cc.y_start),
            (*frame).Linesize[0] as usize,
            w,
            h,
            output.as_mut_ptr(),
        );
        pack_stride_rem(
            (*frame).Data[1].add(cc.uv_off),
            (*frame).Linesize[1] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack),
        );
        pack_stride_rem(
            (*frame).Data[2].add(cc.uv_off),
            (*frame).Linesize[2] as usize,
            w / 2,
            h / 2,
            output.as_mut_ptr().add(y_pack + uv_pack),
        );
    }
}

pub fn extr_10bit_crop_pack_stride_rem(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
    output: &mut [u8],
    crop_calc: &CropCalc,
) {
    unsafe {
        let frame = get_raw_frame(vid_src, frame_idx);

        let w = crop_calc.new_w as usize;
        let h = crop_calc.new_h as usize;
        let pix_sz = 2;

        let y_linesize = (*frame).Linesize[0] as usize;
        let uv_linesize = (*frame).Linesize[1] as usize;

        let y_row = packed_row_size(w);
        let uv_row = packed_row_size(w / 2);

        let mut dst_pos = 0;

        for row in 0..h {
            let src_off = (crop_calc.crop_h as usize * pix_sz)
                + (row + crop_calc.crop_v as usize) * y_linesize;
            let src_row =
                std::slice::from_raw_parts((*frame).Data[0].add(src_off), crop_calc.y_len);
            let dst_row = std::slice::from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), y_row);

            src_row.chunks_exact(8).zip(dst_row.chunks_exact_mut(5)).for_each(|(i, o)| {
                pack_4_pix_10bit(i.try_into().unwrap(), o.try_into().unwrap());
            });

            let rem = crop_calc.y_len % 8;
            if rem > 0 {
                let mut tmp = [0u8; 8];
                tmp[..rem].copy_from_slice(&src_row[crop_calc.y_len - rem..]);
                pack_4_pix_10bit(tmp, (&mut dst_row[y_row - 5..]).try_into().unwrap());
            }

            dst_pos += y_row;
        }

        for row in 0..h / 2 {
            let src_off = (crop_calc.crop_h as usize / 2 * pix_sz)
                + (row + crop_calc.crop_v as usize / 2) * uv_linesize;
            let src_row =
                std::slice::from_raw_parts((*frame).Data[1].add(src_off), crop_calc.uv_len);
            let dst_row = std::slice::from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), uv_row);

            src_row.chunks_exact(8).zip(dst_row.chunks_exact_mut(5)).for_each(|(i, o)| {
                pack_4_pix_10bit(i.try_into().unwrap(), o.try_into().unwrap());
            });

            let rem = crop_calc.uv_len % 8;
            if rem > 0 {
                let mut tmp = [0u8; 8];
                tmp[..rem].copy_from_slice(&src_row[crop_calc.uv_len - rem..]);
                pack_4_pix_10bit(tmp, (&mut dst_row[uv_row - 5..]).try_into().unwrap());
            }

            dst_pos += uv_row;
        }

        for row in 0..h / 2 {
            let src_off = (crop_calc.crop_h as usize / 2 * pix_sz)
                + (row + crop_calc.crop_v as usize / 2) * uv_linesize;
            let src_row =
                std::slice::from_raw_parts((*frame).Data[2].add(src_off), crop_calc.uv_len);
            let dst_row = std::slice::from_raw_parts_mut(output.as_mut_ptr().add(dst_pos), uv_row);

            src_row.chunks_exact(8).zip(dst_row.chunks_exact_mut(5)).for_each(|(i, o)| {
                pack_4_pix_10bit(i.try_into().unwrap(), o.try_into().unwrap());
            });

            let rem = crop_calc.uv_len % 8;
            if rem > 0 {
                let mut tmp = [0u8; 8];
                tmp[..rem].copy_from_slice(&src_row[crop_calc.uv_len - rem..]);
                pack_4_pix_10bit(tmp, (&mut dst_row[uv_row - 5..]).try_into().unwrap());
            }

            dst_pos += uv_row;
        }
    }
}

pub fn get_frame(
    vid_src: *mut FFMS_VideoSource,
    frame_idx: usize,
) -> Result<*const FFMS_Frame, Box<dyn std::error::Error>> {
    unsafe {
        let mut err = std::mem::zeroed::<FFMS_ErrorInfo>();
        let frame = FFMS_GetFrame(
            vid_src,
            i32::try_from(frame_idx).unwrap_or(0),
            std::ptr::addr_of_mut!(err),
        );

        if frame.is_null() {
            return Err("Failed to get frame".into());
        }

        Ok(frame)
    }
}

pub fn destroy_vid_src(vid_src: *mut FFMS_VideoSource) {
    unsafe {
        FFMS_DestroyVideoSource(vid_src);
    }
}
