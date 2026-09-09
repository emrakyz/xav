use crate::{
    error::Xerr,
    ffms::{VidDecoder, VidInf},
    path::Path,
};

unsafe extern "C" {
    fn xav_crop_detect(
        dc: *mut VidDecoder,
        frames: usize,
        w: usize,
        h: usize,
        is10b: usize,
        line: usize,
        out: *mut u32,
    );
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct CropResult {
    pub top: u32,
    pub bottom: u32,
    pub left: u32,
    pub right: u32,
}

impl CropResult {
    #[inline(always)]
    pub const fn has_crop(&self) -> bool {
        self.top > 0 || self.bottom > 0 || self.left > 0 || self.right > 0
    }

    #[inline(always)]
    pub const fn to_tuple(self) -> (u32, u32) {
        let v = if self.top < self.bottom {
            self.top
        } else {
            self.bottom
        };
        let h = if self.left < self.right {
            self.left
        } else {
            self.right
        };
        (v & !1, h & !1)
    }
}

pub fn detect_crop(
    path: &Path,
    inf: &VidInf,
    threads: i32,
    line: usize,
) -> Result<CropResult, Xerr> {
    let mut dec = VidDecoder::new(path, threads)?;
    let mut out = [0u32; 4];
    unsafe {
        xav_crop_detect(
            &raw mut dec,
            inf.frames,
            inf.width as usize,
            inf.height as usize,
            usize::from(inf.is_10b),
            line,
            out.as_mut_ptr(),
        );
    }
    Ok(CropResult {
        top: out[0],
        bottom: out[1],
        left: out[2],
        right: out[3],
    })
}
