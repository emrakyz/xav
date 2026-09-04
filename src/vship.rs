use alloc::string::String;
use core::{
    cell::Cell,
    ffi::{CStr, c_void},
    hint::cold_path,
    mem::MaybeUninit,
    ops::{Deref, DerefMut},
    ptr::{NonNull, null, null_mut},
    slice::{from_raw_parts, from_raw_parts_mut},
    sync::atomic::{
        AtomicPtr,
        Ordering::{Acquire, Relaxed, Release},
    },
};

use crate::{
    error::{Xerr, Xerr::Msg, fatal},
    ffms::VidInf,
    fs::read_to_string,
    vship::{
        VshipChromaLocation::{Left, TopLeft},
        VshipColorFamily::Yuv,
        VshipPrimaries::{
            Bt470Bg as PrimBt470Bg, Bt470M as PrimBt470M, Bt709 as PrimBt709, Bt2020, Internal,
        },
        VshipRange::{Full, Limited},
        VshipSample::{Uint8, Uint10},
        VshipStructType::{
            InitButter, InitCvvdp, InitSsimu2, ScoreButter, ScoreCvvdp, ScoreSsimu2,
        },
        VshipTransferFunction::{
            Bt470Bg as TrBt470Bg, Bt470M as TrBt470M, Bt601, Bt709 as TrBt709, Hlg, Linear, Pq,
            Srgb, St428,
        },
        VshipYuvMatrix::{
            Bt470Bg as YmBt470Bg, Bt709 as YmBt709, Bt2020Cl, Bt2020Ncl, Bt2100Ictcp, Rgb, St170M,
        },
    },
};

#[cold]
#[inline(never)]
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

const DKEYS: [&str; 6] = ["dist", "size", "bright", "illum", "refl", "contrast"];

#[derive(Copy, Clone)]
pub struct Disp {
    v: [f32; 6],
    hdr: bool,
}

impl Disp {
    const fn cs(&self) -> &'static str {
        if self.hdr { "HDR" } else { "SDR" }
    }

    fn json(&self, w: u32, h: u32) -> String {
        let [dist, size, bright, illum, refl, contrast] = self.v;
        format!(
            concat!(
                r#"{{"xav":{{"resolution":[{},{}],"colorspace":"{}","viewing_distance_meters":{},"diagonal_size_inches":{},"max_luminance":{},"E_ambient":{},"k_refl":{},"contrast":{}}}}}"#,
                "\0"
            ),
            w,
            h,
            self.cs(),
            dist,
            size,
            bright,
            illum,
            refl,
            contrast
        )
    }

    #[must_use]
    pub fn tag(&self, w: u32, h: u32) -> String {
        let [dist, size, bright, illum, refl, contrast] = self.v;
        format!(
            "{w}x{h} {} dist={dist} size={size} bright={bright} illum={illum} refl={refl} \
             contrast={contrast}",
            self.cs()
        )
    }
}

pub fn load_disp(conf: Option<&str>, inf: &VidInf) -> Result<Disp, Xerr> {
    let path = conf.ok_or("CVVDP requires -d/--display <file> argument")?;
    let txt = read_to_string(path)?;
    let hdr = matches!(inf.transfer_characteristics, 16 | 18);
    let mut v = [f32::NAN; 6];

    for line in txt.lines() {
        let line = line.trim();
        if line.is_empty() {
            continue;
        }
        let (key, val) = line
            .split_once('=')
            .ok_or_else(|| Msg(format!("display: expected key = value: {line}")))?;
        let (key, val) = (key.trim(), val.trim());
        let i = DKEYS
            .iter()
            .position(|k| *k == key)
            .ok_or_else(|| Msg(format!("display: unknown key: {key}")))?;
        let n = val
            .parse::<f32>()
            .ok()
            .filter(|n| n.is_finite() && *n >= 0.0)
            .ok_or_else(|| Msg(format!("display: bad {key}: {val}")))?;
        unsafe { *v.get_unchecked_mut(i) = n };
    }

    for (key, n) in DKEYS.iter().zip(v) {
        if n.is_nan() {
            return Err(Msg(format!("display: missing {key}")));
        }
    }
    if hdr && v[2] < 500.0 {
        return Err(
            "Brightness is too low for HDR. Lowest grade HDR brightness is considered >=500 \
             minimum"
                .into(),
        );
    }
    if !hdr && v[2] > 500.0 {
        return Err(
            "Brightness is too high for SDR. No consumer TV can reach that brightness level".into(),
        );
    }
    Ok(Disp { v, hdr })
}

#[repr(i32)]
#[derive(Copy, Clone)]
enum VshipStructType {
    InitSsimu2 = 1,
    InitButter = 2,
    InitCvvdp = 3,
    ScoreSsimu2 = 4,
    ScoreButter = 5,
    ScoreCvvdp = 6,
}

#[repr(C)]
struct VshipInitSsimu2 {
    struct_type: VshipStructType,
    src: VshipColorspace,
    dis: VshipColorspace,
    gpu_id: i32,
}

#[repr(C)]
struct VshipInitButter {
    struct_type: VshipStructType,
    src: VshipColorspace,
    dis: VshipColorspace,
    qnorm: i32,
    intensity: f32,
    gpu_id: i32,
}

#[repr(C)]
struct VshipInitCvvdp {
    struct_type: VshipStructType,
    src: VshipColorspace,
    dis: VshipColorspace,
    fps: f32,
    resize_to_display: bool,
    model_key: *const i8,
    model_config_json: *const i8,
    gpu_id: i32,
}

#[repr(C)]
struct VshipScoreSsimu2 {
    struct_type: VshipStructType,
    score: f64,
}

#[repr(C)]
struct VshipScoreButter {
    struct_type: VshipStructType,
    norm_q: f64,
    norm3: f64,
    norminf: f64,
    dstp: *const u8,
    dststride: i64,
}

#[repr(C)]
struct VshipScoreCvvdp {
    struct_type: VshipStructType,
    score: f64,
    dstp: *const u8,
    dststride: i64,
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

const GPU: i32 = 0;
const PIN_ALIGN: usize = 64;
const PIN_SLACK: usize = PIN_ALIGN + 7;

unsafe extern "C" {
    fn Vship_GPUFullCheck(gpu_id: i32) -> i32;
    fn Vship_PinnedMalloc2(ptr: *mut *mut c_void, size: u64, gpu_id: i32) -> i32;
    fn Vship_PinnedFree2(ptr: *mut c_void, gpu_id: i32) -> i32;
    fn Vship_InitHandler(handler: *mut *mut c_void, argument: *const c_void) -> i32;
    fn Vship_FreeHandler(handler: *mut c_void) -> i32;
    fn Vship_ComputeHandler(
        handler: *mut c_void,
        score: *mut c_void,
        srcp1: *const *const u8,
        srcp2: *const *const u8,
        line_size: *const i64,
        line_size2: *const i64,
    ) -> i32;
    fn Vship_Reset(handler: *mut c_void) -> i32;
    fn Vship_ResetScore(handler: *mut c_void) -> i32;
    fn Vship_GetDetailedLastError(out_msg: *mut i8, len: i32) -> i32;
    fn Vship_GetDetailedLastErrorHandler(handler: *mut c_void, out_msg: *mut i8, len: i32) -> i32;
}

pub struct PinnedBuf {
    ptr: *mut u8,
    len: usize,
}

impl PinnedBuf {
    pub fn new(len: usize) -> Result<Self, Xerr> {
        if len == 0 {
            return Ok(Self {
                ptr: NonNull::dangling().as_ptr(),
                len: 0,
            });
        }
        Ok(Self {
            ptr: pin_new(len)?,
            len,
        })
    }
}

pub struct PinPool<const N: usize> {
    shared: [AtomicPtr<u8>; N],
    local: [Cell<*mut u8>; N],
}

impl<const N: usize> PinPool<N> {
    pub const fn new() -> Self {
        Self {
            shared: [const { AtomicPtr::new(null_mut()) }; N],
            local: [const { Cell::new(null_mut()) }; N],
        }
    }

    // `sz` reached only when class runs dry; never loads on recycle
    #[inline]
    pub fn get<F: FnOnce() -> usize>(&self, cls: usize, sz: F) -> *mut u8 {
        let l = unsafe { self.local.get_unchecked(cls) };
        let mut h = l.get();
        if h.is_null() {
            h = unsafe { self.shared.get_unchecked(cls) }.swap(null_mut(), Acquire);
            if h.is_null() {
                cold_path();
                return pin_alloc(sz());
            }
        }
        l.set(unsafe { h.cast::<*mut u8>().read() });
        h
    }

    #[inline]
    pub fn put(&self, cls: usize, base: *mut u8) {
        let s = unsafe { self.shared.get_unchecked(cls) };
        let mut h = s.load(Relaxed);
        loop {
            unsafe { base.cast::<*mut u8>().write(h) };
            match s.compare_exchange_weak(h, base, Release, Relaxed) {
                Ok(_) => return,
                Err(cur) => h = cur,
            }
        }
    }
}

#[cold]
#[inline(never)]
fn pin_err() -> Xerr {
    let mut errbuf = MaybeUninit::<[u8; 1024]>::uninit();
    vship_get_err(&mut errbuf);
    vship_err_str(&errbuf)
}

// vulkan gives 16B vma suballocations
// head puts raw one qword under the aligned base; freeHost needs exact ptr
fn pin_new(sz: usize) -> Result<*mut u8, Xerr> {
    let mut ptr = MaybeUninit::<*mut u8>::uninit();
    if unsafe { Vship_PinnedMalloc2(ptr.as_mut_ptr().cast(), (sz + PIN_SLACK) as u64, GPU) } != 0 {
        return Err(pin_err());
    }
    let raw = unsafe { ptr.assume_init() };
    let p = raw.map_addr(|a| (a + PIN_SLACK) & !(PIN_ALIGN - 1));
    unsafe { p.cast::<*mut u8>().sub(1).write(raw) };
    Ok(p)
}

#[cold]
#[inline(never)]
fn pin_alloc(sz: usize) -> *mut u8 {
    pin_new(sz).unwrap_or_else(|e| fatal(e))
}

fn pin_free(p: *mut u8) {
    unsafe { Vship_PinnedFree2(p.cast::<*mut u8>().sub(1).read().cast(), GPU) };
}

impl<const N: usize> Drop for PinPool<N> {
    fn drop(&mut self) {
        for i in 0..N {
            let s = unsafe { self.shared.get_unchecked(i) };
            for mut h in [
                unsafe { self.local.get_unchecked(i) }.get(),
                s.swap(null_mut(), Acquire),
            ] {
                while !h.is_null() {
                    let next = unsafe { h.cast::<*mut u8>().read() };
                    pin_free(h);
                    h = next;
                }
            }
        }
    }
}

impl Deref for PinnedBuf {
    type Target = [u8];

    #[inline]
    fn deref(&self) -> &[u8] {
        unsafe { from_raw_parts(self.ptr, self.len) }
    }
}

impl DerefMut for PinnedBuf {
    #[inline]
    fn deref_mut(&mut self) -> &mut [u8] {
        unsafe { from_raw_parts_mut(self.ptr, self.len) }
    }
}

impl Drop for PinnedBuf {
    fn drop(&mut self) {
        if self.len != 0 {
            pin_free(self.ptr);
        }
    }
}

pub struct VshipProcessor(*mut c_void);

pub fn init_device() -> Result<(), Xerr> {
    if unsafe { Vship_GPUFullCheck(GPU) } != 0 {
        let mut errbuf = MaybeUninit::<[u8; 1024]>::uninit();
        vship_get_err(&mut errbuf);
        return Err(vship_err_str(&errbuf));
    }
    Ok(())
}

impl VshipProcessor {
    pub fn new(
        width: u32,
        height: u32,
        inf: &VidInf,
        use_cvvdp: bool,
        use_butter: bool,
        disp: Option<Disp>,
    ) -> Result<Self, Xerr> {
        let src = create_yuv_colorspace(width, height, inf.is_10b, inf);
        let dis = create_yuv_colorspace(width, height, true, inf);
        let mut handler: *mut c_void = null_mut();

        let ret = if use_cvvdp {
            let config = unsafe { disp.unwrap_unchecked() }.json(width, height);
            let init = VshipInitCvvdp {
                struct_type: InitCvvdp,
                src,
                dis,
                fps: inf.fps_num as f32 / inf.fps_den as f32,
                resize_to_display: true,
                model_key: c"xav".as_ptr(),
                model_config_json: config.as_ptr().cast(),
                gpu_id: GPU,
            };
            unsafe { Vship_InitHandler(&raw mut handler, (&raw const init).cast()) }
        } else if use_butter {
            let init = VshipInitButter {
                struct_type: InitButter,
                src,
                dis,
                qnorm: 5,
                intensity: 203.0,
                gpu_id: GPU,
            };
            unsafe { Vship_InitHandler(&raw mut handler, (&raw const init).cast()) }
        } else {
            let init = VshipInitSsimu2 {
                struct_type: InitSsimu2,
                src,
                dis,
                gpu_id: GPU,
            };
            unsafe { Vship_InitHandler(&raw mut handler, (&raw const init).cast()) }
        };

        if ret != 0 {
            let mut errbuf = MaybeUninit::<[u8; 1024]>::uninit();
            vship_get_err(&mut errbuf);
            return Err(vship_err_str(&errbuf));
        }
        Ok(Self(handler))
    }

    #[cold]
    #[inline(never)]
    fn err(&self) -> Xerr {
        let mut errbuf = MaybeUninit::<[u8; 1024]>::uninit();
        if unsafe { Vship_GetDetailedLastErrorHandler(self.0, errbuf.as_mut_ptr().cast(), 1024) }
            == 0
        {
            vship_get_err(&mut errbuf);
        }
        vship_err_str(&errbuf)
    }

    #[inline]
    fn compute(
        &self,
        score: *mut c_void,
        planes1: [*const u8; 3],
        planes2: [*const u8; 3],
        line_sizes1: [i64; 3],
        line_sizes2: [i64; 3],
    ) -> Result<(), Xerr> {
        if unsafe {
            Vship_ComputeHandler(
                self.0,
                score,
                planes1.as_ptr(),
                planes2.as_ptr(),
                line_sizes1.as_ptr(),
                line_sizes2.as_ptr(),
            )
        } != 0
        {
            cold_path();
            return Err(self.err());
        }
        Ok(())
    }

    pub fn comp_ssimu2(
        &self,
        planes1: [*const u8; 3],
        planes2: [*const u8; 3],
        line_sizes1: [i64; 3],
        line_sizes2: [i64; 3],
    ) -> Result<f32, Xerr> {
        let mut score = MaybeUninit::<VshipScoreSsimu2>::uninit();
        let p = score.as_mut_ptr();
        unsafe { (*p).struct_type = ScoreSsimu2 };
        self.compute(p.cast(), planes1, planes2, line_sizes1, line_sizes2)?;
        Ok(unsafe { (*p).score } as f32)
    }

    pub fn comp_butter(
        &self,
        planes1: [*const u8; 3],
        planes2: [*const u8; 3],
        line_sizes1: [i64; 3],
        line_sizes2: [i64; 3],
    ) -> Result<f32, Xerr> {
        let mut score = MaybeUninit::<VshipScoreButter>::uninit();
        let p = score.as_mut_ptr();
        unsafe {
            (*p).struct_type = ScoreButter;
            (*p).dstp = null();
            (*p).dststride = 0;
        }
        self.compute(p.cast(), planes1, planes2, line_sizes1, line_sizes2)?;
        Ok(unsafe { (*p).norm_q } as f32)
    }

    pub fn comp_cvvdp(
        &self,
        planes1: [*const u8; 3],
        planes2: [*const u8; 3],
        line_sizes1: [i64; 3],
        line_sizes2: [i64; 3],
    ) -> Result<f32, Xerr> {
        let mut score = MaybeUninit::<VshipScoreCvvdp>::uninit();
        let p = score.as_mut_ptr();
        unsafe {
            (*p).struct_type = ScoreCvvdp;
            (*p).dstp = null();
            (*p).dststride = 0;
        }
        self.compute(p.cast(), planes1, planes2, line_sizes1, line_sizes2)?;
        Ok(unsafe { (*p).score } as f32)
    }

    pub fn reset_cvvdp(&self) {
        unsafe { Vship_Reset(self.0) };
    }

    pub fn reset_cvvdp_score(&self) {
        unsafe { Vship_ResetScore(self.0) };
    }
}

impl Drop for VshipProcessor {
    fn drop(&mut self) {
        unsafe { Vship_FreeHandler(self.0) };
    }
}

fn create_yuv_colorspace(width: u32, height: u32, is_10b: bool, inf: &VidInf) -> VshipColorspace {
    let chroma_loc = match inf.chroma_sample_position {
        2 => TopLeft,
        _ => Left,
    };

    let matrix_val = match inf.matrix_coefficients {
        0 => Rgb,
        5 => YmBt470Bg,
        6 => St170M,
        9 => Bt2020Ncl,
        10 => Bt2020Cl,
        14 => Bt2100Ictcp,
        _ => YmBt709,
    };

    let transfer_val = match inf.transfer_characteristics {
        4 => TrBt470M,
        5 => TrBt470Bg,
        6 => Bt601,
        8 => Linear,
        13 => Srgb,
        16 => Pq,
        17 => St428,
        18 => Hlg,
        _ => TrBt709,
    };

    let primaries_val = match inf.color_primaries {
        -1 => Internal,
        4 => PrimBt470M,
        5 => PrimBt470Bg,
        9 => Bt2020,
        _ => PrimBt709,
    };

    let range_val = match inf.color_range {
        2 => Full,
        _ => Limited,
    };

    let sample_val = if is_10b { Uint10 } else { Uint8 };

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
