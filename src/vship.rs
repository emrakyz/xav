use std::ptr;

#[repr(C)]
#[derive(Copy, Clone)]
struct VshipSSIMU2Handler {
    id: i32,
}

#[repr(C)]
#[derive(Copy, Clone)]
struct VshipCVVDPHandler {
    id: i32,
}

#[repr(C)]
#[derive(Copy, Clone)]
struct VshipButteraugliHandler {
    id: i32,
}

#[repr(C)]
#[derive(Copy, Clone)]
struct VshipButteraugliScore {
    norm_q: f64,
    norm3: f64,
    norminf: f64,
}

#[repr(i32)]
#[derive(Copy, Clone)]
#[allow(dead_code)]
enum VshipSample {
    Float = 0,
    Half = 1,
    Uint8 = 2,
    Uint9 = 3,
    Uint10 = 5,
    Uint12 = 7,
    Uint14 = 9,
    Uint16 = 11,
}

#[repr(i32)]
#[derive(Copy, Clone)]
enum VshipRange {
    Limited = 0,
    Full = 1,
}

#[repr(C)]
#[derive(Copy, Clone)]
struct VshipChromaSubsample {
    subw: i32,
    subh: i32,
}

#[repr(i32)]
#[derive(Copy, Clone)]
#[allow(dead_code)]
enum VshipChromaLocation {
    Left = 0,
    Center = 1,
    TopLeft = 2,
    Top = 3,
}

#[repr(i32)]
#[derive(Copy, Clone)]
#[allow(dead_code)]
enum VshipColorFamily {
    Yuv = 0,
    Rgb = 1,
}

#[repr(i32)]
#[derive(Copy, Clone)]
enum VshipYuvMatrix {
    Rgb = 0,
    Bt709 = 1,
    Bt470Bg = 5,
    St170M = 6,
    Bt2020Ncl = 9,
    Bt2020Cl = 10,
    Bt2100Ictcp = 14,
}

#[repr(i32)]
#[derive(Copy, Clone)]
enum VshipTransferFunction {
    Bt709 = 1,
    Bt470M = 4,
    Bt470Bg = 5,
    Bt601 = 6,
    Linear = 8,
    Srgb = 13,
    Pq = 16,
    St428 = 17,
    Hlg = 18,
}

#[repr(i32)]
#[derive(Copy, Clone)]
enum VshipPrimaries {
    Internal = -1,
    Bt709 = 1,
    Bt470M = 4,
    Bt470Bg = 5,
    Bt2020 = 9,
}

#[repr(C)]
#[derive(Copy, Clone)]
struct VshipCropRectangle {
    top: i32,
    bottom: i32,
    left: i32,
    right: i32,
}

#[repr(C)]
#[derive(Copy, Clone)]
struct VshipColorspace {
    width: i64,
    height: i64,
    target_width: i64,
    target_height: i64,
    sample: VshipSample,
    range: VshipRange,
    subsampling: VshipChromaSubsample,
    chroma_location: VshipChromaLocation,
    color_family: VshipColorFamily,
    yuv_matrix: VshipYuvMatrix,
    transfer_function: VshipTransferFunction,
    primaries: VshipPrimaries,
    crop: VshipCropRectangle,
}

#[repr(C)]
#[derive(Copy, Clone)]
#[allow(dead_code)]
enum VshipException {
    NoError = 0,
    OutOfVRAM,
    OutOfRAM,
    BadDisplayModel,
    DifferingInputType,
    NonRGBSInput,
    DeviceCountError,
    NoDeviceDetected,
    BadDeviceArgument,
    BadDeviceCode,
    BadHandler,
    BadPointer,
    BadErrorType,
}

unsafe extern "C" {
    fn Vship_SetDevice(gpu_id: i32) -> VshipException;
    fn Vship_SSIMU2Init(
        handler: *mut VshipSSIMU2Handler,
        src_colorspace: VshipColorspace,
        dis_colorspace: VshipColorspace,
    ) -> VshipException;
    fn Vship_SSIMU2Free(handler: VshipSSIMU2Handler) -> VshipException;
    fn Vship_ComputeSSIMU2(
        handler: VshipSSIMU2Handler,
        score: *mut f64,
        srcp1: *const *const u8,
        srcp2: *const *const u8,
        lineSize: *const i64,
        lineSize2: *const i64,
    ) -> VshipException;
    fn Vship_CVVDPInit(
        handler: *mut VshipCVVDPHandler,
        src_colorspace: VshipColorspace,
        dis_colorspace: VshipColorspace,
        fps: f32,
        resize_to_display: bool,
        model_key: *const i8,
    ) -> VshipException;
    fn Vship_CVVDPFree(handler: VshipCVVDPHandler) -> VshipException;
    fn Vship_ResetCVVDP(handler: VshipCVVDPHandler) -> VshipException;
    fn Vship_ComputeCVVDP(
        handler: VshipCVVDPHandler,
        score: *mut f64,
        dstp: *const u8,
        dststride: i64,
        srcp1: *const *const u8,
        srcp2: *const *const u8,
        lineSize: *const i64,
        lineSize2: *const i64,
    ) -> VshipException;
    fn Vship_ButteraugliInit(
        handler: *mut VshipButteraugliHandler,
        src_colorspace: VshipColorspace,
        dis_colorspace: VshipColorspace,
        qnorm: i32,
        intensity_multiplier: f32,
    ) -> VshipException;
    fn Vship_ButteraugliFree(handler: VshipButteraugliHandler) -> VshipException;
    fn Vship_ComputeButteraugli(
        handler: VshipButteraugliHandler,
        score: *mut VshipButteraugliScore,
        dstp: *const u8,
        dststride: i64,
        srcp1: *const *const u8,
        srcp2: *const *const u8,
        lineSize: *const i64,
        lineSize2: *const i64,
    ) -> VshipException;
    fn Vship_GetErrorMessage(exception: VshipException, out_msg: *mut i8, len: i32) -> i32;
}

pub struct VshipProcessor {
    handler: Option<VshipSSIMU2Handler>,
    cvvdp_handler: Option<VshipCVVDPHandler>,
    butteraugli_handler: Option<VshipButteraugliHandler>,
}

pub fn init_device() -> Result<(), Box<dyn std::error::Error>> {
    unsafe {
        let ret = Vship_SetDevice(0);
        if ret as i32 != 0 {
            return Err("Failed to set VSHIP device".into());
        }
        Ok(())
    }
}

impl VshipProcessor {
    pub fn new(
        width: u32,
        height: u32,
        is_10bit: bool,
        matrix: Option<i32>,
        transfer: Option<i32>,
        primaries: Option<i32>,
        color_range: Option<i32>,
        chroma_sample_position: Option<i32>,
        fps: f32,
        use_cvvdp: bool,
        use_butteraugli: bool,
    ) -> Result<Self, Box<dyn std::error::Error>> {
        unsafe {
            let src_colorspace = create_yuv_colorspace(
                width,
                height,
                is_10bit,
                matrix,
                transfer,
                primaries,
                color_range,
                chroma_sample_position,
            );

            let dis_colorspace = create_yuv_colorspace(
                width,
                height,
                true,
                matrix,
                transfer,
                primaries,
                color_range,
                chroma_sample_position,
            );

            let handler = if !use_cvvdp && !use_butteraugli {
                let mut handler = std::mem::zeroed::<VshipSSIMU2Handler>();
                let ret =
                    Vship_SSIMU2Init(ptr::from_mut(&mut handler), src_colorspace, dis_colorspace);
                if ret as i32 != 0 {
                    let mut err_msg = vec![0i8; 1024];
                    Vship_GetErrorMessage(ret, err_msg.as_mut_ptr(), 1024);
                    let err = std::ffi::CStr::from_ptr(err_msg.as_ptr()).to_string_lossy();
                    return Err(format!("Failed to init VSHIP: {err}").into());
                }
                Some(handler)
            } else {
                None
            };

            let cvvdp_handler = if use_cvvdp {
                let mut handler = std::mem::zeroed::<VshipCVVDPHandler>();
                let model_key = std::ffi::CString::new("standard_hdr_pq").unwrap();
                let ret = Vship_CVVDPInit(
                    ptr::from_mut(&mut handler),
                    src_colorspace,
                    dis_colorspace,
                    fps,
                    true,
                    model_key.as_ptr(),
                );
                if ret as i32 != 0 {
                    let mut err_msg = vec![0i8; 1024];
                    Vship_GetErrorMessage(ret, err_msg.as_mut_ptr(), 1024);
                    let err = std::ffi::CStr::from_ptr(err_msg.as_ptr()).to_string_lossy();
                    return Err(format!("Failed to init CVVDP: {err}").into());
                }
                Some(handler)
            } else {
                None
            };

            let butteraugli_handler = if use_butteraugli {
                let mut handler = std::mem::zeroed::<VshipButteraugliHandler>();
                let ret = Vship_ButteraugliInit(
                    ptr::from_mut(&mut handler),
                    src_colorspace,
                    dis_colorspace,
                    5,
                    203.0,
                );
                if ret as i32 != 0 {
                    let mut err_msg = vec![0i8; 1024];
                    Vship_GetErrorMessage(ret, err_msg.as_mut_ptr(), 1024);
                    let err = std::ffi::CStr::from_ptr(err_msg.as_ptr()).to_string_lossy();
                    return Err(format!("Failed to init Butteraugli: {err}").into());
                }
                Some(handler)
            } else {
                None
            };

            Ok(Self { handler, cvvdp_handler, butteraugli_handler })
        }
    }

    pub fn compute_ssimulacra2(
        &self,
        planes1: [*const u8; 3],
        planes2: [*const u8; 3],
        line_sizes1: [i64; 3],
        line_sizes2: [i64; 3],
    ) -> Result<f64, Box<dyn std::error::Error>> {
        unsafe {
            let mut score = 0.0;
            let ret = Vship_ComputeSSIMU2(
                self.handler.ok_or("SSIMULACRA2 handler not initialized")?,
                ptr::from_mut(&mut score),
                planes1.as_ptr(),
                planes2.as_ptr(),
                line_sizes1.as_ptr(),
                line_sizes2.as_ptr(),
            );

            if ret as i32 != 0 {
                let mut err_msg = vec![0i8; 1024];
                Vship_GetErrorMessage(ret, err_msg.as_mut_ptr(), 1024);
                let err = std::ffi::CStr::from_ptr(err_msg.as_ptr()).to_string_lossy();
                return Err(format!("VSHIP compute failed: {err}").into());
            }

            Ok(score)
        }
    }

    pub fn reset_cvvdp(&self) -> Result<(), Box<dyn std::error::Error>> {
        unsafe {
            if let Some(handler) = self.cvvdp_handler {
                let ret = Vship_ResetCVVDP(handler);
                if ret as i32 != 0 {
                    return Err("Failed to reset CVVDP".into());
                }
            }
            Ok(())
        }
    }

    pub fn compute_cvvdp(
        &self,
        planes1: [*const u8; 3],
        planes2: [*const u8; 3],
        line_sizes1: [i64; 3],
        line_sizes2: [i64; 3],
    ) -> Result<f64, Box<dyn std::error::Error>> {
        unsafe {
            let mut score = 0.0;
            let ret = Vship_ComputeCVVDP(
                self.cvvdp_handler.ok_or("CVVDP handler not initialized")?,
                ptr::from_mut(&mut score),
                std::ptr::null(),
                0,
                planes1.as_ptr(),
                planes2.as_ptr(),
                line_sizes1.as_ptr(),
                line_sizes2.as_ptr(),
            );

            if ret as i32 != 0 {
                let mut err_msg = vec![0i8; 1024];
                Vship_GetErrorMessage(ret, err_msg.as_mut_ptr(), 1024);
                let err = std::ffi::CStr::from_ptr(err_msg.as_ptr()).to_string_lossy();
                return Err(format!("CVVDP compute failed: {err}").into());
            }

            Ok(score)
        }
    }

    pub fn compute_butteraugli(
        &self,
        planes1: [*const u8; 3],
        planes2: [*const u8; 3],
        line_sizes1: [i64; 3],
        line_sizes2: [i64; 3],
    ) -> Result<f64, Box<dyn std::error::Error>> {
        unsafe {
            let mut score = VshipButteraugliScore { norm_q: 0.0, norm3: 0.0, norminf: 0.0 };
            let ret = Vship_ComputeButteraugli(
                self.butteraugli_handler.ok_or("Butteraugli handler not initialized")?,
                ptr::from_mut(&mut score),
                std::ptr::null(),
                0,
                planes1.as_ptr(),
                planes2.as_ptr(),
                line_sizes1.as_ptr(),
                line_sizes2.as_ptr(),
            );

            if ret as i32 != 0 {
                let mut err_msg = vec![0i8; 1024];
                Vship_GetErrorMessage(ret, err_msg.as_mut_ptr(), 1024);
                let err = std::ffi::CStr::from_ptr(err_msg.as_ptr()).to_string_lossy();
                return Err(format!("Butteraugli compute failed: {err}").into());
            }

            Ok(score.norm_q)
        }
    }
}

impl Drop for VshipProcessor {
    fn drop(&mut self) {
        unsafe {
            if let Some(h) = self.handler {
                Vship_SSIMU2Free(h);
            }
            if let Some(h) = self.cvvdp_handler {
                Vship_CVVDPFree(h);
            }
            if let Some(h) = self.butteraugli_handler {
                Vship_ButteraugliFree(h);
            }
        }
    }
}

fn create_yuv_colorspace(
    width: u32,
    height: u32,
    is_10bit: bool,
    matrix: Option<i32>,
    transfer: Option<i32>,
    primaries: Option<i32>,
    color_range: Option<i32>,
    chroma_sample_position: Option<i32>,
) -> VshipColorspace {
    let chroma_loc = match chroma_sample_position {
        Some(2) => VshipChromaLocation::TopLeft,
        _ => VshipChromaLocation::Left,
    };

    let matrix_val = match matrix {
        Some(0) => VshipYuvMatrix::Rgb,
        Some(5) => VshipYuvMatrix::Bt470Bg,
        Some(6) => VshipYuvMatrix::St170M,
        Some(9) => VshipYuvMatrix::Bt2020Ncl,
        Some(10) => VshipYuvMatrix::Bt2020Cl,
        Some(14) => VshipYuvMatrix::Bt2100Ictcp,
        _ => VshipYuvMatrix::Bt709,
    };

    let transfer_val = match transfer {
        Some(4) => VshipTransferFunction::Bt470M,
        Some(5) => VshipTransferFunction::Bt470Bg,
        Some(6) => VshipTransferFunction::Bt601,
        Some(8) => VshipTransferFunction::Linear,
        Some(13) => VshipTransferFunction::Srgb,
        Some(16) => VshipTransferFunction::Pq,
        Some(17) => VshipTransferFunction::St428,
        Some(18) => VshipTransferFunction::Hlg,
        _ => VshipTransferFunction::Bt709,
    };

    let primaries_val = match primaries {
        Some(-1) => VshipPrimaries::Internal,
        Some(4) => VshipPrimaries::Bt470M,
        Some(5) => VshipPrimaries::Bt470Bg,
        Some(9) => VshipPrimaries::Bt2020,
        _ => VshipPrimaries::Bt709,
    };

    let range_val = match color_range {
        Some(2) => VshipRange::Full,
        _ => VshipRange::Limited,
    };

    let sample_val = if is_10bit { VshipSample::Uint10 } else { VshipSample::Uint8 };

    VshipColorspace {
        width: i64::from(width),
        height: i64::from(height),
        target_width: -1,
        target_height: -1,
        sample: sample_val,
        range: range_val,
        subsampling: VshipChromaSubsample { subw: 1, subh: 1 },
        chroma_location: chroma_loc,
        color_family: VshipColorFamily::Yuv,
        yuv_matrix: matrix_val,
        transfer_function: transfer_val,
        primaries: primaries_val,
        crop: VshipCropRectangle { top: 0, bottom: 0, left: 0, right: 0 },
    }
}
