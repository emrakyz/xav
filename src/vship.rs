use std::ptr;

#[repr(C)]
#[derive(Copy, Clone)]
pub struct VshipCVVDPHandler {
    id: i32,
}

#[repr(C)]
#[derive(Copy, Clone)]
#[allow(dead_code)]
pub enum VshipException {
    NoError = 0,
    OutOfVRAM,
    OutOfRAM,
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
    fn Vship_CVVDPInit(
        handler: *mut VshipCVVDPHandler,
        width: i32,
        height: i32,
        fps: f32,
        resize_to_display: bool,
        model_key_cstr: *const i8,
    ) -> VshipException;
    fn Vship_CVVDPFree(handler: VshipCVVDPHandler) -> VshipException;
    fn Vship_ResetCVVDP(handler: VshipCVVDPHandler) -> VshipException;
    fn Vship_ComputeCVVDPUint16(
        handler: VshipCVVDPHandler,
        score: *mut f64,
        dstp: *const u8,
        dststride: i64,
        srcp1: *const *const u8,
        srcp2: *const *const u8,
        stride: i64,
        stride2: i64,
    ) -> VshipException;
    fn Vship_GetErrorMessage(exception: VshipException, out_msg: *mut i8, len: i32) -> i32;
    fn Vship_PinnedMalloc(ptr: *mut *mut std::ffi::c_void, size: u64) -> VshipException;
    fn Vship_PinnedFree(ptr: *mut std::ffi::c_void) -> VshipException;
}

pub struct VshipProcessor {
    handler: VshipCVVDPHandler,
}

impl VshipProcessor {
    pub fn new(width: u32, height: u32, fps: f32) -> Result<Self, Box<dyn std::error::Error>> {
        unsafe {
            let ret = Vship_SetDevice(0);
            if ret as i32 != 0 {
                return Err("Failed to set VSHIP device".into());
            }

            let mut handler = std::mem::zeroed::<VshipCVVDPHandler>();
            let model_key = std::ffi::CString::new("standard_4k").unwrap();
            let ret = Vship_CVVDPInit(
                ptr::from_mut(&mut handler),
                i32::try_from(width).unwrap(),
                i32::try_from(height).unwrap(),
                fps,
                true,
                model_key.as_ptr(),
            );
            if ret as i32 != 0 {
                let mut err_msg = vec![0i8; 1024];
                Vship_GetErrorMessage(ret, err_msg.as_mut_ptr(), 1024);
                let err = std::ffi::CStr::from_ptr(err_msg.as_ptr()).to_string_lossy();
                return Err(format!("Failed to init VSHIP: {err}").into());
            }

            Ok(Self { handler })
        }
    }

    pub fn reset(&self) -> Result<(), Box<dyn std::error::Error>> {
        unsafe {
            let ret = Vship_ResetCVVDP(self.handler);
            if ret as i32 != 0 {
                return Err("Failed to reset CVVDP".into());
            }
            Ok(())
        }
    }

    pub fn compute_cvvdp(
        &self,
        planes1: [*const u8; 3],
        planes2: [*const u8; 3],
        stride: i64,
    ) -> Result<f64, Box<dyn std::error::Error>> {
        unsafe {
            let mut score = 0.0;
            let ret = Vship_ComputeCVVDPUint16(
                self.handler,
                ptr::from_mut(&mut score),
                std::ptr::null(),
                0,
                planes1.as_ptr(),
                planes2.as_ptr(),
                stride,
                stride,
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
}

impl Drop for VshipProcessor {
    fn drop(&mut self) {
        unsafe {
            Vship_CVVDPFree(self.handler);
        }
    }
}

pub struct PinnedBuffer {
    ptr: *mut u8,
    size: usize,
}

unsafe impl Send for PinnedBuffer {}
unsafe impl Sync for PinnedBuffer {}

impl PinnedBuffer {
    pub fn new(size: usize) -> Result<Self, Box<dyn std::error::Error>> {
        unsafe {
            let mut ptr: *mut std::ffi::c_void = std::ptr::null_mut();
            let ret = Vship_PinnedMalloc(&raw mut ptr, size as u64);
            if ret as i32 != 0 {
                return Err("Failed to allocate pinned memory".into());
            }
            Ok(Self { ptr: ptr.cast::<u8>(), size })
        }
    }

    pub const fn as_mut_slice(&mut self) -> &mut [u8] {
        unsafe { std::slice::from_raw_parts_mut(self.ptr, self.size) }
    }

    pub const fn as_ptr(&self) -> *const u8 {
        self.ptr
    }
}

impl Drop for PinnedBuffer {
    fn drop(&mut self) {
        unsafe {
            Vship_PinnedFree(self.ptr.cast::<std::ffi::c_void>());
        }
    }
}
