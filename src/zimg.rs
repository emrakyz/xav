use std::ptr;

use crate::ffms::FFMS_Frame;
use crate::vship::PinnedBuffer;

#[derive(Copy, Clone)]
pub struct ColorParams {
    pub matrix: Option<i32>,
    pub transfer: Option<i32>,
    pub primaries: Option<i32>,
    pub color_range: Option<i32>,
}

#[repr(C)]
struct ZimgImageFormat {
    version: u32,
    width: u32,
    height: u32,
    pixel_type: i32,
    subsample_w: u32,
    subsample_h: u32,
    color_family: i32,
    matrix_coefficients: i32,
    transfer_characteristics: i32,
    color_primaries: i32,
    depth: u32,
    pixel_range: i32,
    field_parity: i32,
    chroma_location: i32,
    active_region: [f64; 4],
    alpha: i32,
}

#[repr(C)]
struct ZimgImageBufferConst {
    version: u32,
    plane: [ZimgPlaneConst; 4],
}

#[repr(C)]
struct ZimgImageBuffer {
    version: u32,
    plane: [ZimgPlane; 4],
}

#[repr(C)]
#[derive(Clone, Copy)]
struct ZimgPlaneConst {
    data: *const libc::c_void,
    stride: isize,
    mask: u32,
}

#[repr(C)]
#[derive(Clone, Copy)]
struct ZimgPlane {
    data: *mut libc::c_void,
    stride: isize,
    mask: u32,
}

#[repr(C)]
struct ZimgGraphBuilderParams {
    version: u32,
    resample_filter: i32,
    filter_param_a: f64,
    filter_param_b: f64,
    resample_filter_uv: i32,
    filter_param_a_uv: f64,
    filter_param_b_uv: f64,
    dither_type: i32,
    cpu_type: i32,
    nominal_peak_luminance: f64,
    allow_approximate_gamma: i8,
}

const ZIMG_API_VERSION: u32 = (2 << 8) | 4;
const ZIMG_BUFFER_MAX: u32 = !0u32;
const ZIMG_PIXEL_BYTE: i32 = 0;
const ZIMG_PIXEL_WORD: i32 = 1;
const ZIMG_COLOR_RGB: i32 = 1;
const ZIMG_COLOR_YUV: i32 = 2;
const ZIMG_RANGE_LIMITED: i32 = 0;
const ZIMG_RANGE_FULL: i32 = 1;
const ZIMG_CPU_AUTO: i32 = 1;
const ZIMG_MATRIX_RGB: i32 = 0;
const ZIMG_MATRIX_BT709: i32 = 1;
const ZIMG_TRANSFER_BT709: i32 = 1;
const ZIMG_PRIMARIES_BT709: i32 = 1;

unsafe extern "C" {
    fn zimg_image_format_default(ptr: *mut ZimgImageFormat, version: u32);
    fn zimg_graph_builder_params_default(ptr: *mut ZimgGraphBuilderParams, version: u32);
    fn zimg_filter_graph_build(
        src: *const ZimgImageFormat,
        dst: *const ZimgImageFormat,
        params: *const ZimgGraphBuilderParams,
    ) -> *mut libc::c_void;
    fn zimg_filter_graph_free(graph: *mut libc::c_void);
    fn zimg_filter_graph_get_tmp_size(graph: *const libc::c_void, size: *mut usize) -> i32;
    fn zimg_filter_graph_process(
        graph: *const libc::c_void,
        src: *const ZimgImageBufferConst,
        dst: *const ZimgImageBuffer,
        tmp: *mut libc::c_void,
        unpack_cb: *const libc::c_void,
        unpack_user: *mut libc::c_void,
        pack_cb: *const libc::c_void,
        pack_user: *mut libc::c_void,
    ) -> i32;
    fn zimg_get_last_error(buf: *mut i8, n: usize) -> i32;
}

pub struct ZimgProcessor {
    graph: *mut libc::c_void,
    tmp_buffer: Vec<u8>,
    stride: u32,
}

unsafe impl Send for ZimgProcessor {}
unsafe impl Sync for ZimgProcessor {}

impl ZimgProcessor {
    pub fn new(
        stride: u32,
        width: u32,
        height: u32,
        is_10bit: bool,
        color_params: ColorParams,
    ) -> Result<Self, Box<dyn std::error::Error>> {
        let mut processor = Self { graph: ptr::null_mut(), tmp_buffer: Vec::new(), stride };

        unsafe {
            let matrix = match color_params.matrix {
                Some(0 | 2) | None => ZIMG_MATRIX_BT709,
                Some(m) => m,
            };
            let transfer = match color_params.transfer {
                Some(2) | None => ZIMG_TRANSFER_BT709,
                Some(t) => t,
            };
            let primaries = match color_params.primaries {
                Some(2) | None => ZIMG_PRIMARIES_BT709,
                Some(p) => p,
            };
            let range = match color_params.color_range {
                Some(2) => ZIMG_RANGE_FULL,
                _ => ZIMG_RANGE_LIMITED,
            };

            let mut src_fmt = std::mem::zeroed::<ZimgImageFormat>();
            zimg_image_format_default(ptr::from_mut(&mut src_fmt), ZIMG_API_VERSION);
            src_fmt.width = width;
            src_fmt.height = height;
            src_fmt.pixel_type = if is_10bit { ZIMG_PIXEL_WORD } else { ZIMG_PIXEL_BYTE };
            src_fmt.subsample_w = 1;
            src_fmt.subsample_h = 1;
            src_fmt.color_family = ZIMG_COLOR_YUV;
            src_fmt.matrix_coefficients = matrix;
            src_fmt.transfer_characteristics = transfer;
            src_fmt.color_primaries = primaries;
            src_fmt.depth = if is_10bit { 10 } else { 8 };
            src_fmt.pixel_range = range;

            let mut dst_fmt = std::mem::zeroed::<ZimgImageFormat>();
            zimg_image_format_default(ptr::from_mut(&mut dst_fmt), ZIMG_API_VERSION);
            dst_fmt.width = width;
            dst_fmt.height = height;
            dst_fmt.pixel_type = ZIMG_PIXEL_WORD;
            dst_fmt.color_family = ZIMG_COLOR_RGB;
            dst_fmt.transfer_characteristics = ZIMG_TRANSFER_BT709;
            dst_fmt.color_primaries = ZIMG_PRIMARIES_BT709;
            dst_fmt.depth = 16;
            dst_fmt.pixel_range = ZIMG_RANGE_FULL;
            dst_fmt.matrix_coefficients = ZIMG_MATRIX_RGB;

            let mut params = std::mem::zeroed::<ZimgGraphBuilderParams>();
            zimg_graph_builder_params_default(ptr::from_mut(&mut params), ZIMG_API_VERSION);
            params.cpu_type = ZIMG_CPU_AUTO;
            params.allow_approximate_gamma = 1;

            processor.graph = zimg_filter_graph_build(
                ptr::from_ref(&src_fmt),
                ptr::from_ref(&dst_fmt),
                ptr::from_ref(&params),
            );

            if processor.graph.is_null() {
                let mut err_msg = vec![0i8; 1024];
                zimg_get_last_error(err_msg.as_mut_ptr(), 1024);
                let err = std::ffi::CStr::from_ptr(err_msg.as_ptr()).to_string_lossy();
                return Err(format!("Failed to build graph: {err}").into());
            }

            let mut tmp_size = 0usize;
            zimg_filter_graph_get_tmp_size(processor.graph, ptr::from_mut(&mut tmp_size));
            processor.tmp_buffer = vec![0u8; tmp_size + 32];
        }

        Ok(processor)
    }

    pub fn conv_yuv_to_rgb(
        &mut self,
        yuv_data: &[u8],
        width: u32,
        height: u32,
        rgb_buffers: &mut [PinnedBuffer; 3],
        is_10bit: bool,
    ) -> Result<(), Box<dyn std::error::Error>> {
        unsafe {
            let pixel_size = if is_10bit { 2 } else { 1 };
            let y_size = (width * height) as usize * pixel_size;
            let uv_size = y_size / 4;
            let y_stride = width * pixel_size as u32;
            let uv_stride = (width / 2) * pixel_size as u32;

            let mut src_buf = std::mem::zeroed::<ZimgImageBufferConst>();
            src_buf.version = ZIMG_API_VERSION;

            src_buf.plane[0].data = yuv_data.as_ptr().cast::<libc::c_void>();
            src_buf.plane[0].stride = isize::try_from(y_stride).unwrap();
            src_buf.plane[0].mask = ZIMG_BUFFER_MAX;

            src_buf.plane[1].data = yuv_data[y_size..].as_ptr().cast::<libc::c_void>();
            src_buf.plane[1].stride = isize::try_from(uv_stride).unwrap();
            src_buf.plane[1].mask = ZIMG_BUFFER_MAX;

            src_buf.plane[2].data = yuv_data[y_size + uv_size..].as_ptr().cast::<libc::c_void>();
            src_buf.plane[2].stride = isize::try_from(uv_stride).unwrap();
            src_buf.plane[2].mask = ZIMG_BUFFER_MAX;

            let mut dst_buf = std::mem::zeroed::<ZimgImageBuffer>();
            dst_buf.version = ZIMG_API_VERSION;

            dst_buf.plane[0].data =
                rgb_buffers[0].as_mut_slice().as_mut_ptr().cast::<libc::c_void>();
            dst_buf.plane[0].stride = isize::try_from(self.stride).unwrap();
            dst_buf.plane[0].mask = ZIMG_BUFFER_MAX;

            dst_buf.plane[1].data =
                rgb_buffers[1].as_mut_slice().as_mut_ptr().cast::<libc::c_void>();
            dst_buf.plane[1].stride = isize::try_from(self.stride).unwrap();
            dst_buf.plane[1].mask = ZIMG_BUFFER_MAX;

            dst_buf.plane[2].data =
                rgb_buffers[2].as_mut_slice().as_mut_ptr().cast::<libc::c_void>();
            dst_buf.plane[2].stride = isize::try_from(self.stride).unwrap();
            dst_buf.plane[2].mask = ZIMG_BUFFER_MAX;

            let tmp_ptr = self.tmp_buffer.as_mut_ptr() as usize;
            let tmp_aligned = ((tmp_ptr + 31) & !31) as *mut libc::c_void;

            let ret = zimg_filter_graph_process(
                self.graph,
                ptr::from_ref(&src_buf),
                ptr::from_ref(&dst_buf),
                tmp_aligned,
                ptr::null(),
                ptr::null_mut(),
                ptr::null(),
                ptr::null_mut(),
            );

            if ret != 0 {
                let mut err_msg = vec![0i8; 1024];
                zimg_get_last_error(err_msg.as_mut_ptr(), 1024);
                let err = std::ffi::CStr::from_ptr(err_msg.as_ptr()).to_string_lossy();
                return Err(format!("ZIMG failed: {err}").into());
            }

            Ok(())
        }
    }

    pub fn convert_ffms_frame_to_rgb(
        &mut self,
        frame: *const FFMS_Frame,
        rgb_buffers: &mut [PinnedBuffer; 3],
    ) -> Result<(), Box<dyn std::error::Error>> {
        unsafe {
            let mut src_buf = std::mem::zeroed::<ZimgImageBufferConst>();
            src_buf.version = ZIMG_API_VERSION;

            src_buf.plane[0].data = (*frame).data[0].cast::<libc::c_void>();
            src_buf.plane[0].stride = isize::try_from((*frame).linesize[0]).unwrap();
            src_buf.plane[0].mask = ZIMG_BUFFER_MAX;

            src_buf.plane[1].data = (*frame).data[1].cast::<libc::c_void>();
            src_buf.plane[1].stride = isize::try_from((*frame).linesize[1]).unwrap();
            src_buf.plane[1].mask = ZIMG_BUFFER_MAX;

            src_buf.plane[2].data = (*frame).data[2].cast::<libc::c_void>();
            src_buf.plane[2].stride = isize::try_from((*frame).linesize[2]).unwrap();
            src_buf.plane[2].mask = ZIMG_BUFFER_MAX;

            let mut dst_buf = std::mem::zeroed::<ZimgImageBuffer>();
            dst_buf.version = ZIMG_API_VERSION;

            dst_buf.plane[0].data =
                rgb_buffers[0].as_mut_slice().as_mut_ptr().cast::<libc::c_void>();
            dst_buf.plane[0].stride = isize::try_from(self.stride).unwrap();
            dst_buf.plane[0].mask = ZIMG_BUFFER_MAX;

            dst_buf.plane[1].data =
                rgb_buffers[1].as_mut_slice().as_mut_ptr().cast::<libc::c_void>();
            dst_buf.plane[1].stride = isize::try_from(self.stride).unwrap();
            dst_buf.plane[1].mask = ZIMG_BUFFER_MAX;

            dst_buf.plane[2].data =
                rgb_buffers[2].as_mut_slice().as_mut_ptr().cast::<libc::c_void>();
            dst_buf.plane[2].stride = isize::try_from(self.stride).unwrap();
            dst_buf.plane[2].mask = ZIMG_BUFFER_MAX;

            let tmp_ptr = self.tmp_buffer.as_mut_ptr() as usize;
            let tmp_aligned = ((tmp_ptr + 31) & !31) as *mut libc::c_void;

            let ret = zimg_filter_graph_process(
                self.graph,
                ptr::from_ref(&src_buf),
                ptr::from_ref(&dst_buf),
                tmp_aligned,
                ptr::null(),
                ptr::null_mut(),
                ptr::null(),
                ptr::null_mut(),
            );

            if ret != 0 {
                let mut err_msg = vec![0i8; 1024];
                zimg_get_last_error(err_msg.as_mut_ptr(), 1024);
                let err = std::ffi::CStr::from_ptr(err_msg.as_ptr()).to_string_lossy();
                return Err(format!("ZIMG failed: {err}").into());
            }

            Ok(())
        }
    }
}

impl Drop for ZimgProcessor {
    fn drop(&mut self) {
        unsafe {
            if !self.graph.is_null() {
                zimg_filter_graph_free(self.graph);
            }
        }
    }
}
