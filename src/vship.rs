use std::{
    ffi::{CStr, CString},
    mem::{MaybeUninit, zeroed},
    ptr::{from_mut, null},
};

use crate::{
    error::{Xerr, Xerr::Msg},
    ffms::VidInf,
    vship::{
        VshipChromaLocation::{Left, TopLeft},
        VshipColorFamily::Yuv,
        VshipPrimaries::{
            Bt470Bg as PrimBt470Bg, Bt470M as PrimBt470M, Bt709 as PrimBt709, Bt2020, Internal,
        },
        VshipRange::{Full, Limited},
        VshipSample::{Uint8, Uint10},
        VshipTransferFunction::{
            Bt470Bg as TrBt470Bg, Bt470M as TrBt470M, Bt601, Bt709 as TrBt709, Hlg, Linear, Pq,
            Srgb, St428,
        },
        VshipYuvMatrix::{
            Bt470Bg as YmBt470Bg, Bt709 as YmBt709, Bt2020Cl, Bt2020Ncl, Bt2100Ictcp, Rgb, St170M,
        },
    },
};

#[inline]
#[cold]
fn vship_err_str(buf: &MaybeUninit<[u8; 1024]>) -> Xerr {
    unsafe {
        Msg(CStr::from_ptr(buf.as_ptr().cast())
            .to_string_lossy()
            .into_owned())
    }
}

#[inline]
fn vship_get_err(buf: &mut MaybeUninit<[u8; 1024]>) {
    unsafe {
        Vship_GetDetailedLastError(buf.as_mut_ptr().cast(), 1024);
    }
}

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

#[repr(i32)]
#[derive(Copy, Clone)]
#[allow(dead_code)]
enum VshipException {
    NoError = 0,
    OutOfVRAM = 1,
    OutOfRAM = 2,
    BadDisplayModel = 3,
    DifferingInputType = 4,
    NonRGBSInput = 5,
    DeviceCountError = 6,
    NoDeviceDetected = 7,
    BadDeviceArgument = 8,
    BadDeviceCode = 9,
    BadHandler = 10,
    BadPointer = 11,
    HIPError = 12,
    BadPath = 13,
    BadJson = 14,
    NotSupported = 15,
    BadErrorType = 16,
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
    fn Vship_CVVDPInit2(
        handler: *mut VshipCVVDPHandler,
        src_colorspace: VshipColorspace,
        dis_colorspace: VshipColorspace,
        fps: f32,
        resize_to_display: bool,
        model_key: *const i8,
        model_config_json: *const i8,
    ) -> VshipException;
    fn Vship_CVVDPFree(handler: VshipCVVDPHandler) -> VshipException;
    fn Vship_ResetCVVDP(handler: VshipCVVDPHandler) -> VshipException;
    fn Vship_ResetScoreCVVDP(handler: VshipCVVDPHandler) -> VshipException;
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
    fn Vship_GetDetailedLastError(out_msg: *mut i8, len: i32) -> i32;
}

pub struct VshipProcessor {
    handler: Option<VshipSSIMU2Handler>,
    cvvdp_handler: Option<VshipCVVDPHandler>,
    butteraugli_handler: Option<VshipButteraugliHandler>,
}

pub fn init_device() -> Result<(), Xerr> {
    unsafe {
        let mut errbuf = MaybeUninit::<[u8; 1024]>::uninit();
        let ret = Vship_SetDevice(0);
        if ret as i32 != 0 {
            vship_get_err(&mut errbuf);
            return Err(vship_err_str(&errbuf));
        }
        Ok(())
    }
}

impl VshipProcessor {
    pub fn new(
        width: u32,
        height: u32,
        inf: &VidInf,
        use_cvvdp: bool,
        use_butteraugli: bool,
        cvvdp_model: Option<&str>,
        cvvdp_config: Option<&str>,
    ) -> Result<Self, Xerr> {
        let fps = inf.fps_num as f32 / inf.fps_den as f32;
        unsafe {
            let src_colorspace = create_yuv_colorspace(width, height, inf.is_10bit, inf);
            let dis_colorspace = create_yuv_colorspace(width, height, true, inf);

            let mut errbuf = MaybeUninit::<[u8; 1024]>::uninit();

            let handler = if !use_cvvdp && !use_butteraugli {
                let mut handler = zeroed::<VshipSSIMU2Handler>();
                let ret = Vship_SSIMU2Init(from_mut(&mut handler), src_colorspace, dis_colorspace);
                if ret as i32 != 0 {
                    vship_get_err(&mut errbuf);
                    return Err(vship_err_str(&errbuf));
                }
                Some(handler)
            } else {
                None
            };

            let cvvdp_handler = if use_cvvdp {
                let mut handler = zeroed::<VshipCVVDPHandler>();
                let model_key = CString::new(cvvdp_model.unwrap_or("xav"))?;
                let config_cstr = CString::new(
                    cvvdp_config.ok_or("CVVDP requires -d/--display <json_file> argument")?,
                )?;
                let ret = Vship_CVVDPInit2(
                    from_mut(&mut handler),
                    src_colorspace,
                    dis_colorspace,
                    fps,
                    true,
                    model_key.as_ptr(),
                    config_cstr.as_ptr(),
                );
                if ret as i32 != 0 {
                    vship_get_err(&mut errbuf);
                    return Err(vship_err_str(&errbuf));
                }
                Some(handler)
            } else {
                None
            };

            let butteraugli_handler = if use_butteraugli {
                let mut handler = zeroed::<VshipButteraugliHandler>();
                let ret = Vship_ButteraugliInit(
                    from_mut(&mut handler),
                    src_colorspace,
                    dis_colorspace,
                    5,
                    203.0,
                );
                if ret as i32 != 0 {
                    vship_get_err(&mut errbuf);
                    return Err(vship_err_str(&errbuf));
                }
                Some(handler)
            } else {
                None
            };

            Ok(Self {
                handler,
                cvvdp_handler,
                butteraugli_handler,
            })
        }
    }

    pub fn compute_ssimulacra2(
        &self,
        planes1: [*const u8; 3],
        planes2: [*const u8; 3],
        line_sizes1: [i64; 3],
        line_sizes2: [i64; 3],
    ) -> Result<f64, Xerr> {
        unsafe {
            let mut errbuf = MaybeUninit::<[u8; 1024]>::uninit();
            let mut score = 0.0;
            let ret = Vship_ComputeSSIMU2(
                self.handler.ok_or("SSIMULACRA2 handler not initialized")?,
                from_mut(&mut score),
                planes1.as_ptr(),
                planes2.as_ptr(),
                line_sizes1.as_ptr(),
                line_sizes2.as_ptr(),
            );

            if ret as i32 != 0 {
                vship_get_err(&mut errbuf);
                return Err(vship_err_str(&errbuf));
            }

            Ok(score)
        }
    }

    pub fn reset_cvvdp(&self) {
        unsafe {
            Vship_ResetCVVDP(self.cvvdp_handler.unwrap_unchecked());
        }
    }

    pub fn reset_cvvdp_score(&self) {
        unsafe {
            Vship_ResetScoreCVVDP(self.cvvdp_handler.unwrap_unchecked());
        }
    }

    pub fn compute_cvvdp(
        &self,
        planes1: [*const u8; 3],
        planes2: [*const u8; 3],
        line_sizes1: [i64; 3],
        line_sizes2: [i64; 3],
    ) -> Result<f64, Xerr> {
        unsafe {
            let mut errbuf = MaybeUninit::<[u8; 1024]>::uninit();
            let mut score = 0.0;
            let ret = Vship_ComputeCVVDP(
                self.cvvdp_handler.ok_or("CVVDP handler not initialized")?,
                from_mut(&mut score),
                null(),
                0,
                planes1.as_ptr(),
                planes2.as_ptr(),
                line_sizes1.as_ptr(),
                line_sizes2.as_ptr(),
            );

            if ret as i32 != 0 {
                vship_get_err(&mut errbuf);
                return Err(vship_err_str(&errbuf));
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
    ) -> Result<f64, Xerr> {
        unsafe {
            let mut errbuf = MaybeUninit::<[u8; 1024]>::uninit();
            let mut score = VshipButteraugliScore {
                norm_q: 0.0,
                norm3: 0.0,
                norminf: 0.0,
            };
            let ret = Vship_ComputeButteraugli(
                self.butteraugli_handler
                    .ok_or("Butteraugli handler not initialized")?,
                from_mut(&mut score),
                null(),
                0,
                planes1.as_ptr(),
                planes2.as_ptr(),
                line_sizes1.as_ptr(),
                line_sizes2.as_ptr(),
            );

            if ret as i32 != 0 {
                vship_get_err(&mut errbuf);
                return Err(vship_err_str(&errbuf));
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

fn create_yuv_colorspace(width: u32, height: u32, is_10bit: bool, inf: &VidInf) -> VshipColorspace {
    let chroma_loc = match inf.chroma_sample_position {
        Some(2) => TopLeft,
        _ => Left,
    };

    let matrix_val = match inf.matrix_coefficients {
        Some(0) => Rgb,
        Some(5) => YmBt470Bg,
        Some(6) => St170M,
        Some(9) => Bt2020Ncl,
        Some(10) => Bt2020Cl,
        Some(14) => Bt2100Ictcp,
        _ => YmBt709,
    };

    let transfer_val = match inf.transfer_characteristics {
        Some(4) => TrBt470M,
        Some(5) => TrBt470Bg,
        Some(6) => Bt601,
        Some(8) => Linear,
        Some(13) => Srgb,
        Some(16) => Pq,
        Some(17) => St428,
        Some(18) => Hlg,
        _ => TrBt709,
    };

    let primaries_val = match inf.color_primaries {
        Some(-1) => Internal,
        Some(4) => PrimBt470M,
        Some(5) => PrimBt470Bg,
        Some(9) => Bt2020,
        _ => PrimBt709,
    };

    let range_val = match inf.color_range {
        Some(2) => Full,
        _ => Limited,
    };

    let sample_val = if is_10bit { Uint10 } else { Uint8 };

    VshipColorspace {
        width: i64::from(width),
        height: i64::from(height),
        target_width: -1,
        target_height: -1,
        sample: sample_val,
        range: range_val,
        subsampling: VshipChromaSubsample { subw: 1, subh: 1 },
        chroma_location: chroma_loc,
        color_family: Yuv,
        yuv_matrix: matrix_val,
        transfer_function: transfer_val,
        primaries: primaries_val,
        crop: VshipCropRectangle {
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
        },
    }
}
