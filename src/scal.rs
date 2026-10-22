use alloc::{collections::BTreeSet, vec::Vec};
use core::{
    ffi::c_void,
    mem::offset_of,
    ptr::{from_ref, null, null_mut},
    sync::atomic::AtomicUsize,
};

use crate::{
    chan::{SeqRing, spmc_close},
    chunk::Chunk,
    dec::Bufs,
    error::{Xerr, fatal},
    ffms::{
        DecStrat::{self, B10Fast, B10FastRem, B10Raw, B10RawStride, B10StrideRem},
        VidDecoder, VidInf,
    },
    path::Path,
    thread::available_parallelism,
    util::assume_unreachable,
    worker::WorkPkg,
    y4m::PipeReader,
};

#[repr(C)]
struct Geo {
    w: usize,
    ow: u32,
    oh: u32,
}

#[repr(C)]
struct Ent {
    ch: *const Chunk,
    cnt: AtomicUsize,
    n: usize,
    pkg: *mut WorkPkg,
}

#[repr(C)]
struct Ctx {
    dec: *mut VidDecoder,
    ring: *const SeqRing,
    tab: *mut Ent,
    b: *const Bufs,
    pb: *const u8,
    pn: usize,
}

const _: () = {
    assert!(offset_of!(Ent, cnt) == 8, "asm E_CNT");
    assert!(offset_of!(Ent, n) == 16, "asm E_N");
    assert!(offset_of!(Ent, pkg) == 24, "asm E_PKG");
    assert!(size_of::<Ent>() == 32, "asm E_SZ");
    assert!(offset_of!(Ctx, ring) == 8, "asm C_RING");
    assert!(offset_of!(Ctx, tab) == 16, "asm C_TAB");
    assert!(offset_of!(Ctx, b) == 24, "asm C_BUF");
    assert!(offset_of!(Ctx, pb) == 32, "asm C_PB");
    assert!(offset_of!(Ctx, pn) == 40, "asm C_PN");
};

unsafe extern "C" {
    static xav_ds2f: u8;
    static mut xav_rs: u8;
    fn xav_ds2w(wm: usize) -> usize;
    fn xav_ds2r(c: *const c_void);
    fn xav_ds2q(c: *const c_void);
    static xav_gwo: u32;
    fn xav_sarg(p: *const u8, n: usize) -> bool;
    fn xav_sgk(wc: u32, hc: u32) -> bool;
    fn xav_dsxi(w: u32, h: u32, cv: u32, ch: u32, fl: u32, ls: usize, cs: usize) -> Geo;
    fn xav_dsgw(wm: usize) -> usize;
    fn xav_dsgr(c: *const c_void);
    #[cfg(feature = "vship")]
    fn xav_dsgq(c: *const c_void);
}

#[unsafe(no_mangle)]
extern "C" fn xav_ds2k(b: &Bufs, e: &mut Ent) -> *mut u8 {
    let p = b.take();
    let pkg = unsafe { &mut *p };
    pkg.chnk = unsafe { *e.ch };
    pkg.frame_cnt = *e.cnt.get_mut();
    e.pkg = p;
    pkg.fit(e.n)
}

#[cfg(feature = "vship")]
#[unsafe(no_mangle)]
extern "C" fn xav_ds2kq(b: &Bufs, e: &mut Ent) -> *mut u8 {
    let p = b.take();
    let pkg = unsafe { &mut *p };
    pkg.chnk = unsafe { *e.ch };
    pkg.frame_cnt = *e.cnt.get_mut();
    pkg.probe.clear();
    pkg.armed = false;
    e.pkg = p;
    pkg.fit(e.n)
}

#[unsafe(no_mangle)]
extern "C" fn xav_ds2c(e: &Ent, r: usize, fsz: usize) {
    let ch = unsafe { &*e.ch };
    let pkg = unsafe { &mut *e.pkg };
    pkg.frame_cnt = pkg.truncate(ch.end - ch.start - r, fsz);
}

#[unsafe(no_mangle)]
extern "C" fn xav_ds2g(b: &Bufs, p: *mut WorkPkg) {
    b.give(p);
}

#[unsafe(no_mangle)]
extern "C" fn xav_ds2s(d: &mut VidDecoder, e: &Ent) {
    d.skip_to(unsafe { (*e.ch).start });
}

const SMSG: &str = "--scale: Only BT709/left or BT2020NCL/PQ/topleft";

pub const SARG: &str = "--scale: a 1/8-step factor (1.5, 3.75) or height above 30 giving an exact \
                        output of at least 256x144";

pub fn arg(s: Option<&str>) -> bool {
    s.is_some_and(|s| unsafe { xav_sarg(s.as_ptr(), s.len()) })
}

pub fn chk(inf: &VidInf, crop: (u32, u32)) -> Result<(), Xerr> {
    if !matches!(
        (
            inf.transfer_characteristics,
            inf.matrix_coefficients,
            inf.chroma_sample_position,
            inf.is_10b,
        ),
        (1, 1, 1, _) | (16, 9, 2, true)
    ) {
        return Err(SMSG.into());
    }
    geo(inf, crop)
}

#[inline(always)]
fn geo(inf: &VidInf, crop: (u32, u32)) -> Result<(), Xerr> {
    if !(1024..=7680).contains(&inf.width) || !(576..=4320).contains(&inf.height) {
        return Err(format!(
            "--scale: source {}x{} is outside 1024x576..7680x4320",
            inf.width, inf.height
        )
        .into());
    }
    let (wc, hc) = (inf.width - crop.1 * 2, inf.height - crop.0 * 2);
    if !wc.is_multiple_of(4) || !hc.is_multiple_of(4) || wc < 641 {
        return Err(format!(
            "--scale: cropped size {wc}x{hc} must be a multiple of 4 and at least 644 wide"
        )
        .into());
    }
    if unsafe { xav_sgk(wc, hc) } {
        return Ok(());
    }
    Err(SARG.into())
}

pub fn virt(
    inf: &mut VidInf,
    crop: (u32, u32),
    hw: &mut bool,
    pipe: bool,
) -> Result<(u32, u32), Xerr> {
    let pq = inf.transfer_characteristics.cast_unsigned() & 16;
    if pipe {
        if pq != 0 && !inf.is_10b {
            return Err(SMSG.into());
        }
        geo(inf, crop)?;
    }
    let g = unsafe {
        xav_rs = (u8::from(inf.color_range != 0) << (5 + u8::from(!inf.is_10b))) | pq;
        xav_dsxi(
            inf.width,
            inf.height,
            crop.0,
            crop.1,
            u32::from(inf.is_10b) | (u32::from(*hw && !pipe) << 1) | (u32::from(pipe) << 2),
            inf.y_linesz,
            inf.uv_linesz,
        )
    };
    inf.width = g.ow;
    inf.height = g.oh;
    inf.is_10b = true;
    inf.y_linesz = g.w;
    inf.uv_linesz = g.w / 2;
    *hw = false;
    Ok((0, 0))
}

const fn ent(ch: *const Chunk, cnt: usize, n: usize) -> Ent {
    Ent {
        ch,
        cnt: AtomicUsize::new(cnt),
        n,
        pkg: null_mut(),
    }
}

fn go<const TQ: bool>(c: &mut Ctx, t: &mut [Ent], gs: bool) {
    c.tab = t.as_mut_ptr();
    unsafe {
        if TQ {
            #[cfg(feature = "vship")]
            if gs {
                xav_dsgq(from_ref(c).cast());
                return;
            }
            xav_ds2q(from_ref(c).cast());
        } else if gs {
            xav_dsgr(from_ref(c).cast());
        } else {
            xav_ds2r(from_ref(c).cast());
        }
    }
}

fn pipe<const TQ: bool>(
    c: &mut Ctx,
    r: &PipeReader,
    chnks: &[Chunk],
    skip: &BTreeSet<u16>,
    fsz: usize,
    gs: bool,
) {
    let mut t = Vec::new();
    let mut d = 0;
    for ch in chnks.get(r.start_idx..).unwrap_or(chnks) {
        let n = ch.end - ch.start;
        if skip.contains(&ch.idx) {
            d += n;
            continue;
        }
        if d != 0 {
            t.push(ent(ch, 0, d));
            d = 0;
        }
        t.push(ent(ch, n, n * fsz));
    }
    t.push(ent(null(), 0, d));
    let pb = r.buf();
    c.pb = pb.as_ptr();
    c.pn = pb.len();
    go::<TQ>(c, &mut t, gs);
}

fn file<const TQ: bool>(
    c: &mut Ctx,
    chnks: &[Chunk],
    skip: &BTreeSet<u16>,
    path: &Path,
    fsz: usize,
    gs: bool,
) {
    let thr = available_parallelism() as i32;
    let dec = if unsafe { xav_ds2f } > 1 {
        VidDecoder::new_hw(path, thr)
    } else {
        VidDecoder::new(path, thr)
    };
    let mut dec = match dec {
        Ok(d) => d,
        Err(e) => fatal(e),
    };
    c.dec = &raw mut dec;
    let mut t = Vec::new();
    let mut pos = 0;
    for ch in chnks.iter().filter(|ch| !skip.contains(&ch.idx)) {
        if ch.start != pos {
            t.push(ent(ch, 0, 0));
        }
        let n = ch.end - ch.start;
        t.push(ent(ch, n, n * fsz));
        pos = ch.end;
    }
    t.push(ent(null(), 0, 0));
    go::<TQ>(c, &mut t, gs);
}

pub struct Dec<'a>(
    pub &'a Bufs,
    pub Option<PipeReader>,
    pub &'a [Chunk],
    pub &'a VidInf,
    pub &'a BTreeSet<u16>,
    pub &'a DecStrat,
    pub &'a Path,
    pub *const SeqRing,
);

impl Dec<'_> {
    #[cfg_attr(not(feature = "avm"), expect(unused_variables))]
    pub fn run<const TQ: bool>(self) {
        let Self(b, reader, chnks, inf, skip, strat, path, ring) = self;
        #[cfg(feature = "avm")]
        b.dims(inf.width, inf.height);
        let gs = unsafe { xav_gwo } != 0;
        let wm = match *strat {
            B10Raw => 0,
            B10RawStride => 1,
            B10Fast => 2,
            B10FastRem => 3,
            B10StrideRem => 4,
            _ => assume_unreachable(),
        };
        let fsz = unsafe { if gs { xav_dsgw(wm) } else { xav_ds2w(wm) } };
        let mut c = Ctx {
            dec: null_mut(),
            ring,
            tab: null_mut(),
            b,
            pb: null(),
            pn: 0,
        };
        match reader {
            Some(r) => pipe::<TQ>(&mut c, &r, chnks, skip, fsz, gs),
            None => file::<TQ>(&mut c, chnks, skip, path, fsz, gs),
        }
        if !TQ {
            unsafe { spmc_close(ring) };
        }
    }
}
