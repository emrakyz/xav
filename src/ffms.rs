use std::ffi::CString;
use std::path::Path;
use std::sync::Arc;

#[repr(C)]
pub struct FFMS_ErrorInfo {
    error_type: i32,
    sub_type: i32,
    buffer: *mut i8,
    buffer_size: i32,
}

#[repr(C)]
struct FFMS_VideoProperties {
    fps_denominator: i32,
    fps_numerator: i32,
    _rff_denominator: i32,
    _rff_numerator: i32,
    num_frames: i32,
    _sar_num: i32,
    _sar_den: i32,
    _crop_top: i32,
    _crop_bottom: i32,
    _crop_left: i32,
    _crop_right: i32,
    _top_field_first: i32,
    color_space: i32,
    _color_range: i32,
    _first_time: f64,
    _last_time: f64,
    _rotation: i32,
    _stereo3d_type: i32,
    _stereo3d_flags: i32,
    _last_end_time: f64,
    has_mastering_display_primaries: i32,
    mastering_display_primaries_x: [f64; 3],
    mastering_display_primaries_y: [f64; 3],
    mastering_display_white_point_x: f64,
    mastering_display_white_point_y: f64,
    has_mastering_display_luminance: i32,
    mastering_display_min_luminance: f64,
    mastering_display_max_luminance: f64,
    has_content_light_level: i32,
    content_light_level_max: u32,
    content_light_level_average: u32,
    _flip: i32,
}

#[repr(C)]
pub struct FFMS_Frame {
    pub data: [*const u8; 4],
    pub linesize: [i32; 4],
    pub encoded_width: i32,
    pub encoded_height: i32,
    _encoded_pixel_format: i32,
    _scaled_width: i32,
    _scaled_height: i32,
    _converted_pixel_format: i32,
    _key_frame: i32,
    _repeat_pict: i32,
    _interlaced_frame: i32,
    _top_field_first: i32,
    _pict_type: i8,
    _color_space: i32,
    color_range: i32,
    pub color_primaries: i32,
    pub transfer_characteristics: i32,
    pub matrix_coefficients: i32,
    pub chroma_location: i32,
}

type IndexCallback = extern "C" fn(current: i64, tot: i64, ic_private: *mut libc::c_void) -> i32;

unsafe extern "C" {
    fn FFMS_Init(unused: i32, use_utf8: i32);
    fn FFMS_CreateIndexer(source: *const i8, err: *mut FFMS_ErrorInfo) -> *mut libc::c_void;
    fn FFMS_SetProgressCallback(
        idxer: *mut libc::c_void,
        ic: IndexCallback,
        ic_private: *mut libc::c_void,
    );
    fn FFMS_DoIndexing2(
        idxer: *mut libc::c_void,
        error_handling: i32,
        err: *mut FFMS_ErrorInfo,
    ) -> *mut libc::c_void;
    fn FFMS_GetFirstIndexedTrackOfType(
        idx: *mut libc::c_void,
        track_type: i32,
        err: *mut FFMS_ErrorInfo,
    ) -> i32;
    fn FFMS_CreateVideoSource(
        source: *const i8,
        track: i32,
        idx: *mut libc::c_void,
        threads: i32,
        seekmode: i32,
        err: *mut FFMS_ErrorInfo,
    ) -> *mut libc::c_void;
    fn FFMS_GetVideoProperties(v: *mut libc::c_void) -> *const FFMS_VideoProperties;
    fn FFMS_GetFrame(v: *mut libc::c_void, n: i32, err: *mut FFMS_ErrorInfo) -> *const FFMS_Frame;
    fn FFMS_DestroyVideoSource(v: *mut libc::c_void);
    fn FFMS_DestroyIndex(idx: *mut libc::c_void);
    fn FFMS_WriteIndex(
        idx_file: *const i8,
        idx: *mut libc::c_void,
        err: *mut FFMS_ErrorInfo,
    ) -> i32;
    fn FFMS_ReadIndex(idx_file: *const i8, err: *mut FFMS_ErrorInfo) -> *mut libc::c_void;
    fn FFMS_IndexBelongsToFile(
        idx: *mut libc::c_void,
        source: *const i8,
        err: *mut FFMS_ErrorInfo,
    ) -> i32;
}

#[derive(Clone)]
pub struct VidInf {
    pub width: u32,
    pub height: u32,
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
    pub idx_handle: *mut libc::c_void,
}

extern "C" fn idx_progs(current: i64, tot: i64, ic_private: *mut libc::c_void) -> i32 {
    unsafe {
        let progs = &mut *ic_private.cast::<crate::progs::ProgsBar>();
        if current >= 0 && tot > 0 {
            progs.up_idx(current as usize, tot as usize);
        }
    }
    0
}

impl VidIdx {
    pub fn new(path: &Path, quiet: bool) -> Result<Arc<Self>, Box<dyn std::error::Error>> {
        unsafe {
            FFMS_Init(0, 0);

            let source = CString::new(path.to_str().unwrap())?;
            let mut err = std::mem::zeroed::<FFMS_ErrorInfo>();

            let idx_path = format!("{}.ffidx", path.display());
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

                let mut progs = crate::progs::ProgsBar::new(quiet);
                FFMS_SetProgressCallback(
                    idxer,
                    idx_progs,
                    std::ptr::addr_of_mut!(progs).cast::<libc::c_void>(),
                );

                let idx = FFMS_DoIndexing2(idxer, 0, std::ptr::addr_of_mut!(err));

                progs.finish();

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

fn get_chroma_loc(path: &str, frame_chroma: i32) -> Option<i32> {
    let ffmpeg_value = std::process::Command::new("ffprobe")
        .args([
            "-v",
            "quiet",
            "-select_streams",
            "v:0",
            "-show_entries",
            "stream=chroma_location",
            "-of",
            "default=noprint_wrappers=1",
            path,
        ])
        .output()
        .ok()
        .and_then(|out| {
            let text = String::from_utf8_lossy(&out.stdout);
            if text.starts_with("chroma_location=left") {
                Some(1)
            } else if text.starts_with("chroma_location=topleft") {
                Some(3)
            } else {
                None
            }
        })
        .or_else(|| (frame_chroma != 0).then_some(frame_chroma));

    match ffmpeg_value? {
        1 => Some(1),
        3 => Some(2),
        _ => None,
    }
}

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

        let matrix_coeff = match if (*frame).matrix_coefficients == 3 {
            (*props).color_space
        } else {
            (*frame).matrix_coefficients
        } {
            0 => 2,
            x => x,
        };

        let width = (*frame).encoded_width as u32;
        let height = (*frame).encoded_height as u32;
        let y_linesize = (*frame).linesize[0] as usize;
        let is_10bit = y_linesize >= (width as usize) * 2;

        let color_range = match (*frame).color_range {
            1 => Some(0),
            2 => Some(1),
            _ => None,
        };

        let chroma_sample_position = get_chroma_loc(&idx.path, (*frame).chroma_location);

        let mastering_display = if (*props).has_mastering_display_primaries != 0
            && (*props).has_mastering_display_luminance != 0
        {
            Some(format!(
                "G({:.4},{:.4})B({:.4},{:.4})R({:.4},{:.4})WP({:.4},{:.4})L({:.4},{:.4})",
                (*props).mastering_display_primaries_x[1],
                (*props).mastering_display_primaries_y[1],
                (*props).mastering_display_primaries_x[2],
                (*props).mastering_display_primaries_y[2],
                (*props).mastering_display_primaries_x[0],
                (*props).mastering_display_primaries_y[0],
                (*props).mastering_display_white_point_x,
                (*props).mastering_display_white_point_y,
                (*props).mastering_display_max_luminance,
                (*props).mastering_display_min_luminance
            ))
        } else {
            None
        };

        let content_light = if (*props).has_content_light_level != 0 {
            Some(format!(
                "{},{}",
                (*props).content_light_level_max,
                (*props).content_light_level_average
            ))
        } else {
            None
        };

        let inf = VidInf {
            width,
            height,
            fps_num: (*props).fps_numerator as u32,
            fps_den: (*props).fps_denominator as u32,
            frames: (*props).num_frames as usize,
            color_primaries: Some((*frame).color_primaries),
            transfer_characteristics: Some((*frame).transfer_characteristics),
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
) -> Result<*mut libc::c_void, Box<dyn std::error::Error>> {
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

        if video.is_null() {
            return Err("Failed to create vid src".into());
        }

        Ok(video)
    }
}

pub const fn calc_8bit_size(inf: &VidInf) -> usize {
    (inf.width * inf.height * 3 / 2) as usize
}

pub const fn calc_packed_size(inf: &VidInf) -> usize {
    let tot_pixels = (inf.width * inf.height * 3 / 2) as usize;
    (tot_pixels * 5) / 4
}

pub fn extr_8bit(
    vid_src: *mut libc::c_void,
    frame_idx: usize,
    output: &mut [u8],
) -> Result<(), Box<dyn std::error::Error>> {
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

        let width = (*frame).encoded_width as usize;
        let height = (*frame).encoded_height as usize;
        let y_linesize = (*frame).linesize[0] as usize;
        let mut pos = 0;

        for row in 0..height {
            let src = std::slice::from_raw_parts((*frame).data[0].add(row * y_linesize), width);
            output[pos..pos + width].copy_from_slice(src);
            pos += width;
        }

        let uv_width = width / 2;
        let uv_height = height / 2;
        for plane in 1..=2 {
            let linesize = (*frame).linesize[plane] as usize;
            for row in 0..uv_height {
                let src =
                    std::slice::from_raw_parts((*frame).data[plane].add(row * linesize), uv_width);
                output[pos..pos + uv_width].copy_from_slice(src);
                pos += uv_width;
            }
        }

        Ok(())
    }
}

pub const fn calc_10bit_size(inf: &VidInf) -> usize {
    let y_size = (inf.width * inf.height) as usize * 2;
    let uv_size = y_size / 4;
    y_size + uv_size * 2
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

    let remaining_in = input.len() % 8;
    if remaining_in > 0 {
        let processed_in = (input.len() / 8) * 8;
        let processed_out = (output.len() / 5) * 5;
        let mut temp = [0u8; 8];
        temp[..remaining_in].copy_from_slice(&input[processed_in..]);

        let output_chunk: &mut [u8; 5] =
            unsafe { &mut *output.as_mut_ptr().add(processed_out).cast::<[u8; 5]>() };

        pack_4_pix_10bit(temp, output_chunk);
    }
}

pub fn unpack_10bit(input: &[u8], output: &mut [u8]) {
    input.chunks_exact(5).zip(output.chunks_exact_mut(8)).for_each(|(i_chunk, o_chunk)| {
        let i_arr: &[u8; 5] = i_chunk.try_into().unwrap();
        let o_arr: &mut [u8; 8] = o_chunk.try_into().unwrap();

        unpack_4_pix_10bit(*i_arr, o_arr);
    });
}

fn copy_plane_8to10(
    src: *const u8,
    src_linesize: usize,
    width: usize,
    height: usize,
    output: &mut [u8],
    out_pos: &mut usize,
) {
    unsafe {
        for row in 0..height {
            let src_row = std::slice::from_raw_parts(src.add(row * src_linesize), width);
            let out_start = *out_pos;
            let out_end = out_start + width * 2;

            src_row.iter().zip(output[out_start..out_end].chunks_exact_mut(2)).for_each(
                |(&pixel, out_chunk)| {
                    let pixel_10bit = (u16::from(pixel) << 2).to_le_bytes();
                    out_chunk.copy_from_slice(&pixel_10bit);
                },
            );

            *out_pos = out_end;
        }
    }
}

fn copy_plane_10to10(
    src: *const u8,
    src_linesize: usize,
    width: usize,
    height: usize,
    output: &mut [u8],
    out_pos: &mut usize,
) {
    unsafe {
        for row in 0..height {
            let row_offset = row * src_linesize;
            let src_row = std::slice::from_raw_parts(src.add(row_offset), width * 2);
            output[*out_pos..*out_pos + width * 2].copy_from_slice(src_row);
            *out_pos += width * 2;
        }
    }
}

pub fn extr_10bit(
    vid_src: *mut libc::c_void,
    frame_idx: usize,
    output: &mut [u8],
) -> Result<(), Box<dyn std::error::Error>> {
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

        let width = (*frame).encoded_width as usize;
        let height = (*frame).encoded_height as usize;

        if width == 0 || height == 0 {
            return Err("Invalid frame dimensions".into());
        }

        let y_linesize = (*frame).linesize[0] as usize;
        let is_10bit = y_linesize >= width * 2;
        let mut out_pos = 0;

        let y_ptr = (*frame).data[0];
        if y_ptr.is_null() {
            return Err("Null Y plane pointer".into());
        }

        if is_10bit {
            copy_plane_10to10(y_ptr, y_linesize, width, height, output, &mut out_pos);
        } else {
            copy_plane_8to10(y_ptr, y_linesize, width, height, output, &mut out_pos);
        }

        let uv_width = width / 2;
        let uv_height = height / 2;

        let u_ptr = (*frame).data[1];
        let u_linesize = (*frame).linesize[1] as usize;

        if !u_ptr.is_null() {
            if is_10bit {
                copy_plane_10to10(u_ptr, u_linesize, uv_width, uv_height, output, &mut out_pos);
            } else {
                copy_plane_8to10(u_ptr, u_linesize, uv_width, uv_height, output, &mut out_pos);
            }
        }

        let v_ptr = (*frame).data[2];
        let v_linesize = (*frame).linesize[2] as usize;

        if !v_ptr.is_null() {
            if is_10bit {
                copy_plane_10to10(v_ptr, v_linesize, uv_width, uv_height, output, &mut out_pos);
            } else {
                copy_plane_8to10(v_ptr, v_linesize, uv_width, uv_height, output, &mut out_pos);
            }
        }

        Ok(())
    }
}

pub fn get_frame(
    vid_src: *mut libc::c_void,
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

pub fn destroy_vid_src(vid_src: *mut libc::c_void) {
    unsafe {
        FFMS_DestroyVideoSource(vid_src);
    }
}
