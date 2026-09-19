#[cfg(target_os = "linux")]
use alloc::vec::Vec;
use core::hint::cold_path;

use crate::{byte_range::ByteRange, nal_scan::find_start_code};

#[derive(Default)]
pub struct Sets {
    pub vps: Vec<u8>,
    pub sps: Vec<u8>,
    pub pps: Vec<u8>,
}

impl Sets {
    const fn slot(&mut self, kind: Param) -> &mut Vec<u8> {
        match kind {
            Param::Vps => &mut self.vps,
            Param::Sps => &mut self.sps,
            Param::Pps => &mut self.pps,
        }
    }
}

#[derive(Default)]
pub struct ParamSets {
    pub rec: Sets,             // 1st of each kind; what codec_priv record carries
    pub varies: [bool; 3],     // per kind: some chunk differs from rec; VARY only
    pub first: [ByteRange; 3], // chunk's 1st VPS/SPS/PPS, held back; VARY only
}

pub struct NalSink<'a> {
    pub arena: &'a mut Vec<ByteRange>, // offset = NAL count, len = MKV block octets
    pub nal_arena: &'a mut Vec<ByteRange>, // NAL byte extents into chunk map
    pub displays: &'a mut Vec<u32>,    // densified to 0..n display ranks
    pub params: &'a mut ParamSets,     // VPS/SPS/PPS
    pub order: &'a mut Vec<usize>,     // rank scratch
}

// parameter sets may differ between chunks (tq, zones)
// x264 leads a chunk with its SPS; lossless has no B-frames
// x264 picks poc type 2; decode order; no slice is read
pub fn parse_h264<const VARY: bool>(raw: &[u8], out: &mut NalSink) {
    let start = first_nal(raw);
    match H264::from_sps(unsafe { raw.get_unchecked(start..) }) {
        Some(c) => run::<H264, VARY>(c, raw, start, out),
        None => run::<H264Dec, VARY>(H264Dec, raw, start, out),
    }
}

pub fn parse_h265<const VARY: bool>(raw: &[u8], out: &mut NalSink) {
    run::<H265, VARY>(H265::default(), raw, first_nal(raw), out);
}

pub fn parse_h266<const VARY: bool>(raw: &[u8], out: &mut NalSink) {
    run::<H266, VARY>(H266::default(), raw, first_nal(raw), out);
}

// offset of the first NAL; len when there is none
fn first_nal(raw: &[u8]) -> usize {
    find_start_code(raw, 0).map_or(raw.len(), |sc| sc + 3)
}

// strip emulation-prevention bytes into `buf`; zero tail past data backs
// word reader's 8byte loads (every buffer = sized >= header + 8)
pub fn rbsp<'a>(nal: &[u8], buf: &'a mut [u8]) -> &'a [u8] {
    let mut n = 0;
    let mut z = 0u32;
    for &b in nal {
        if n >= buf.len() {
            break;
        }
        if b == 3 && z >= 2 {
            z = 0;
            continue;
        }
        unsafe { *buf.get_unchecked_mut(n) = b }; // n < buf.len()
        n += 1;
        z = if b == 0 { z + 1 } else { 0 };
    }
    buf
}

pub struct Bits<'a> {
    d: &'a [u8],
    pos: usize,
}

impl<'a> Bits<'a> {
    pub const fn new(d: &'a [u8]) -> Self {
        Self { d, pos: 0 }
    }

    pub const fn skip(&mut self, n: u32) {
        self.pos += n as usize;
    }

    // 8 bytes at cursor, MSB-first, with next unread bit at bit 63; every
    // buff is sized >= header + 8, so pos>>3 + 8 <= len auto-holds
    const fn peek(&self) -> u64 {
        let w = u64::from_be(unsafe {
            self.d
                .as_ptr()
                .add(self.pos >> 3)
                .cast::<u64>()
                .read_unaligned()
        });
        w << (self.pos & 7)
    }

    pub const fn u(&mut self, n: u32) -> u32 {
        let v = (self.peek() >> (64 - n)) as u32;
        self.pos += n as usize;
        v
    }

    pub const fn flag(&mut self) -> bool {
        let f = (self.peek() >> 63) != 0;
        self.pos += 1;
        f
    }

    // exp-Golomb via CLZ / codeword is `k` zeros, a 1, then `k` value bits
    pub fn ue(&mut self) -> u32 {
        let w = self.peek();
        let k = w.leading_zeros().min(31);
        self.pos += (2 * k + 1) as usize;
        ((w >> (63 - 2 * k)) as u32).wrapping_sub(1)
    }

    pub const fn aligned(&self) -> bool {
        self.pos.trailing_zeros() >= 3
    }

    pub const fn pos(&self) -> usize {
        self.pos
    }
}

// POC msb reconstruction (H.264 8.2.1, H.265/H.266 8.3.1)
#[derive(Default)]
struct Poc {
    prev_msb: i64,
    prev_lsb: i64,
}

impl Poc {
    const fn reset(&mut self, lsb: i64) {
        self.prev_msb = 0;
        self.prev_lsb = lsb;
    }

    const fn full(&mut self, lsb: i64, log2: u32, update: bool) -> i64 {
        let max = 1i64 << log2;
        let half = max >> 1;
        let msb = if lsb < self.prev_lsb && (self.prev_lsb - lsb) >= half {
            self.prev_msb + max
        } else if lsb > self.prev_lsb && (lsb - self.prev_lsb) > half {
            self.prev_msb - max
        } else {
            self.prev_msb
        };
        if update {
            self.prev_msb = msb;
            self.prev_lsb = lsb;
        }
        msb + lsb
    }
}

#[derive(Clone, Copy)]
enum Param {
    Vps = 0,
    Sps = 1,
    Pps = 2,
}

enum Class {
    Drop,             // AUD / SEI / filler / EOS / EOB
    Param(Param),     // VPS / SPS / PPS
    Prefix,           // VVC APS / PH
    Vcl(Option<i64>), // coded slice; POC, or None -> decode order
}

trait Nal {
    fn classify(&mut self, nal: &[u8]) -> Class;
}

// poc type 0 (B-frames): pic_order_cnt_lsb orders the pictures
struct H264 {
    poc: Poc,
    log2_frame_num: u32,
    log2_poc: u32,
}

// 10b 420, prgrssv, scaling lists only in PPS: high profile SPS
// with every branch syntax allows decided; None is poc type 2
impl H264 {
    fn from_sps(nal: &[u8]) -> Option<Self> {
        let mut buf = [0u8; 64];
        let mut b = Bits::new(rbsp(nal, &mut buf));
        b.skip(32); // nal header + profile_idc + constraint flags + level_idc
        b.ue(); // seq_parameter_set_id
        b.ue(); // chroma_format_idc
        b.ue(); // bit_depth_luma_minus8
        b.ue(); // bit_depth_chroma_minus8
        b.skip(2); // qpprime_y_zero_transform_bypass + seq_scaling_matrix_present
        let log2_frame_num = b.ue() + 4;
        if b.ue() != 0 {
            return None; // pic_order_cnt_type
        }
        Some(Self {
            poc: Poc::default(),
            log2_frame_num,
            log2_poc: b.ue() + 4,
        })
    }

    fn slice_poc(&mut self, nal: &[u8], b0: u8) -> i64 {
        let mut buf = [0u8; 32];
        let mut b = Bits::new(rbsp(nal, &mut buf));
        b.skip(8); // nal header
        b.ue(); // first_mb_in_slice
        b.ue(); // slice_type
        b.ue(); // pic_parameter_set_id
        b.skip(self.log2_frame_num); // frame_num
        if (b0 & 0x1F) == 5 {
            self.poc.reset(0); // IDR
            return 0;
        }
        let lsb = i64::from(b.u(self.log2_poc)); // pic_order_cnt_lsb
        let ref_idc = (b0 >> 5) & 3;
        self.poc.full(lsb, self.log2_poc, ref_idc != 0)
    }
}

impl Nal for H264 {
    fn classify(&mut self, nal: &[u8]) -> Class {
        let b0 = unsafe { *nal.get_unchecked(0) }; // nal non-empty (framing)
        match b0 & 0x1F {
            7 => Class::Param(Param::Sps),
            8 => Class::Param(Param::Pps),
            1 | 5 => Class::Vcl(Some(self.slice_poc(nal, b0))),
            _ => Class::Drop,
        }
    }
}

// poc type 2; lossless; no B-frames; output order = decode order
struct H264Dec;

impl Nal for H264Dec {
    fn classify(&mut self, nal: &[u8]) -> Class {
        match unsafe { *nal.get_unchecked(0) } & 0x1F {
            7 => Class::Param(Param::Sps),
            8 => Class::Param(Param::Pps),
            1 | 5 => Class::Vcl(None),
            _ => Class::Drop,
        }
    }
}

#[derive(Default)]
struct H265 {
    poc: Poc,
    log2_poc: u32,
    num_extra: u32,
    output_flag_present: bool,
}

pub fn skip_hevc_ptl(b: &mut Bits, max_sub: u32) {
    b.skip(8); // profile_space + tier + profile_idc
    b.skip(32); // profile_compatibility_flags
    b.skip(48); // constraint flags + inbld
    b.skip(8); // general_level_idc
    let mut prof = [false; 8];
    let mut lvl = [false; 8];
    for (p, l) in prof.iter_mut().zip(&mut lvl).take(max_sub as usize) {
        *p = b.flag();
        *l = b.flag();
    }
    if max_sub > 0 {
        for _ in max_sub..8 {
            b.skip(2); // reserved_zero_2bits
        }
    }
    for (&p, &l) in prof.iter().zip(&lvl).take(max_sub as usize) {
        if p {
            b.skip(88);
        }
        if l {
            b.skip(8);
        }
    }
}

impl H265 {
    fn parse_sps(&mut self, nal: &[u8]) {
        let mut buf = [0u8; 64];
        let mut b = Bits::new(rbsp(nal, &mut buf));
        b.skip(16); // nal header
        b.skip(4); // sps_video_parameter_set_id
        let max_sub = b.u(3);
        b.skip(1); // sps_temporal_id_nesting_flag
        skip_hevc_ptl(&mut b, max_sub);
        b.ue(); // sps_seq_parameter_set_id
        b.ue(); // chroma_format_idc; 4:2:0 only, no separate planes
        b.ue(); // pic_width_in_luma_samples
        b.ue(); // pic_height_in_luma_samples
        if b.flag() {
            b.ue();
            b.ue();
            b.ue();
            b.ue(); // conformance window
        }
        b.ue(); // bit_depth_luma_minus8
        b.ue(); // bit_depth_chroma_minus8
        self.log2_poc = b.ue() + 4;
    }

    fn parse_pps(&mut self, nal: &[u8]) {
        let mut buf = [0u8; 16];
        let mut b = Bits::new(rbsp(nal, &mut buf));
        b.skip(16); // nal header
        b.ue(); // pps_pic_parameter_set_id
        b.ue(); // pps_seq_parameter_set_id
        b.skip(1); // dependent_slice_segments_enabled_flag
        self.output_flag_present = b.flag();
        self.num_extra = b.u(3);
    }

    fn slice_poc(&mut self, nal: &[u8], t: u32, tid: i32) -> Option<i64> {
        let mut buf = [0u8; 32];
        let mut b = Bits::new(rbsp(nal, &mut buf));
        b.skip(16); // nal header
        if !b.flag() {
            return None; // dependent slice (config forces single slice)
        }
        if (16..=23).contains(&t) {
            b.skip(1); // no_output_of_prior_pics_flag
        }
        b.ue(); // slice_pic_parameter_set_id
        if t == 19 || t == 20 {
            self.poc.reset(0); // IDR has no lsb
            return Some(0);
        }
        b.skip(self.num_extra);
        b.ue(); // slice_type
        if self.output_flag_present {
            b.skip(1); // pic_output_flag
        }
        let lsb = i64::from(b.u(self.log2_poc)); // slice_pic_order_cnt_lsb
        if (16..=18).contains(&t) || t == 21 {
            self.poc.reset(lsb); // BLA / CRA
            return Some(lsb);
        }
        let slnr = t <= 15 && (t & 1) == 0;
        let radl_rasl = (6..=9).contains(&t);
        Some(
            self.poc
                .full(lsb, self.log2_poc, tid == 0 && !slnr && !radl_rasl),
        )
    }
}

impl Nal for H265 {
    fn classify(&mut self, nal: &[u8]) -> Class {
        let b0 = unsafe { *nal.get_unchecked(0) }; // nal non-empty (framing)
        let t = u32::from((b0 >> 1) & 0x3F);
        match t {
            32 => Class::Param(Param::Vps),
            33 => {
                self.parse_sps(nal);
                Class::Param(Param::Sps)
            }
            34 => {
                self.parse_pps(nal);
                Class::Param(Param::Pps)
            }
            0..=31 => {
                let tid = i32::from(unsafe { *nal.get_unchecked(1) } & 7) - 1; // 2-byte header
                Class::Vcl(self.slice_poc(nal, t, tid))
            }
            _ => Class::Drop,
        }
    }
}

#[derive(Default)]
struct H266 {
    poc: Poc,
    log2_poc: u32,
}

// false if general_constraints_info present (POC offset then unknown)
pub fn skip_vvc_ptl(b: &mut Bits, max_sub: u32) -> bool {
    b.skip(18); // profile_idc + tier + level_idc + frame_only + multilayer
    if b.flag() {
        return false; // gci_present_flag
    }
    while !b.aligned() {
        b.skip(1);
    }
    let mut present = [false; 8];
    for p in present.iter_mut().take(max_sub as usize) {
        *p = b.flag();
    }
    while !b.aligned() {
        b.skip(1);
    }
    for &p in present.iter().take(max_sub as usize) {
        if p {
            b.skip(8); // sublayer_level_idc
        }
    }
    for _ in 0..b.u(8) {
        b.skip(32); // general_sub_profile_idc
    }
    true
}

impl H266 {
    fn parse_sps(&mut self, nal: &[u8]) {
        let mut buf = [0u8; 128];
        let mut b = Bits::new(rbsp(nal, &mut buf));
        b.skip(16); // nal header
        b.skip(8); // sps_seq_parameter_set_id + sps_video_parameter_set_id
        let max_sub = b.u(3);
        b.skip(4); // sps_chroma_format_idc + sps_log2_ctu_size_minus5
        if b.flag() && !skip_vvc_ptl(&mut b, max_sub) {
            return; // ptl present but unparsed -> decode order
        }
        b.skip(1); // sps_gdr_enabled_flag
        if b.flag() {
            b.skip(1); // sps_res_change_in_clvs_allowed_flag
        }
        b.ue(); // sps_pic_width_max_in_luma_samples
        b.ue(); // sps_pic_height_max_in_luma_samples
        if b.flag() {
            b.ue();
            b.ue();
            b.ue();
            b.ue(); // conformance window
        }
        if b.flag() {
            return; // sps_subpic_info_present_flag unsupported -> decode order
        }
        b.ue(); // sps_bitdepth_minus8
        b.skip(2); // entropy_coding_sync + entry_point_offsets_present
        self.log2_poc = b.u(4) + 4;
    }

    fn slice_poc(&mut self, nal: &[u8], t: u32, tid: i32) -> Option<i64> {
        if self.log2_poc == 0 {
            return None; // SPS PTL/subpic unparsed -> decode order
        }
        let mut buf = [0u8; 32];
        let mut b = Bits::new(rbsp(nal, &mut buf));
        b.skip(16); // nal header
        if !b.flag() {
            return None; // PH not in slice header
        }
        let gdr_or_irap = b.flag();
        let non_ref = b.flag(); // ph_non_ref_pic_flag
        if gdr_or_irap {
            b.skip(1); // ph_gdr_pic_flag
        }
        if b.flag() {
            b.skip(1); // ph_intra_slice_allowed_flag
        }
        b.ue(); // ph_pic_parameter_set_id
        let lsb = i64::from(b.u(self.log2_poc)); // ph_pic_order_cnt_lsb
        if (7..=10).contains(&t) {
            self.poc.reset(lsb); // IRAP / GDR
            return Some(lsb);
        }
        let update = tid == 0 && !non_ref && t != 2 && t != 3;
        Some(self.poc.full(lsb, self.log2_poc, update))
    }
}

impl Nal for H266 {
    fn classify(&mut self, nal: &[u8]) -> Class {
        let b1 = unsafe { *nal.get_unchecked(1) }; // valid VVC NAL: 2-byte header
        let t = u32::from((b1 >> 3) & 0x1F);
        match t {
            14 => Class::Param(Param::Vps),
            15 => {
                self.parse_sps(nal);
                Class::Param(Param::Sps)
            }
            16 => Class::Param(Param::Pps),
            17..=19 => Class::Prefix, // APS / PH
            0..=11 => {
                let tid = i32::from(b1 & 7) - 1;
                Class::Vcl(self.slice_poc(nal, t, tid))
            }
            _ => Class::Drop,
        }
    }
}

struct Emit<'a, C> {
    codec: C,
    arena: &'a mut Vec<ByteRange>,
    nal_arena: &'a mut Vec<ByteRange>,
    displays: &'a mut Vec<u32>,
    params: &'a mut ParamSets,
    order: &'a mut Vec<usize>,
    frame0: usize, // arena idx chunk's frames begin
    nal0: usize,   // nal_arena idx curr access unit begins
    size: usize,   // accumulated block octets for the curr access unit
}

impl<C: Nal> Emit<'_, C> {
    fn add(&mut self, nal: &[u8], off: usize) {
        self.nal_arena.push(ByteRange {
            offset: off,
            len: nal.len(),
        });
        self.size += 4 + nal.len();
    }

    fn push<const VARY: bool>(&mut self, nal: &[u8], off: usize) {
        match self.codec.classify(nal) {
            Class::Drop => {}
            Class::Param(kind) => {
                let rec = self.params.rec.slot(kind);
                if !VARY {
                    if rec.is_empty() {
                        rec.extend_from_slice(nal);
                    }
                    return;
                }
                let k = kind as usize;
                let f = unsafe { self.params.first.get_unchecked_mut(k) };
                if f.len != 0 {
                    cold_path();
                    unsafe { *self.params.varies.get_unchecked_mut(k) = true };
                    self.add(nal, off);
                    return;
                }
                *f = ByteRange {
                    offset: off,
                    len: nal.len(),
                };
                if rec.is_empty() {
                    rec.extend_from_slice(nal);
                } else if rec.as_slice() != nal {
                    unsafe { *self.params.varies.get_unchecked_mut(k) = true };
                }
            }
            Class::Prefix => self.add(nal, off),
            Class::Vcl(poc) => {
                self.add(nal, off);
                // decode-order fb; rank() densifies
                let display = poc.map_or((self.arena.len() - self.frame0) as u32, |p| p as u32);
                self.arena.push(ByteRange {
                    offset: self.nal_arena.len() - self.nal0, // NAL count
                    len: self.size,                           // MKV block octets
                });
                self.displays.push(display);
                self.nal0 = self.nal_arena.len();
                self.size = 0;
            }
        }
    }

    fn rank(&mut self) {
        let disp = unsafe { self.displays.get_unchecked_mut(self.frame0..) };
        let order = &mut *self.order;
        order.clear();
        order.extend(0..disp.len());
        order.sort_unstable_by_key(|&i| unsafe { *disp.get_unchecked(i) });
        for (rank, &i) in order.iter().enumerate() {
            unsafe { *disp.get_unchecked_mut(i) = rank as u32 };
        }
    }
}

fn run<C: Nal, const VARY: bool>(codec: C, raw: &[u8], start: usize, out: &mut NalSink) {
    if VARY {
        out.params.first = [ByteRange::default(); 3];
    }
    let frame0 = out.arena.len();
    let nal0 = out.nal_arena.len();
    let mut e = Emit {
        codec,
        arena: &mut *out.arena,
        nal_arena: &mut *out.nal_arena,
        displays: &mut *out.displays,
        params: &mut *out.params,
        order: &mut *out.order,
        frame0,
        nal0,
        size: 0,
    };

    let len = raw.len();
    let mut pos = start;
    while let Some(sc) = find_start_code(raw, pos) {
        // 4byte start code's leading zero is no NAL byte; sc >= start >= 3
        let end = sc - usize::from(unsafe { *raw.get_unchecked(sc - 1) } == 0);
        if end > pos {
            e.push::<VARY>(unsafe { raw.get_unchecked(pos..end) }, pos); // pos < end <= len
        }
        pos = sc + 3;
    }
    if len > pos {
        e.push::<VARY>(unsafe { raw.get_unchecked(pos..len) }, pos);
    }

    e.rank();
}
