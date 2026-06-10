// Maximally minimal (barely playable) / not spec-compliant

use std::{
    path::{Path, PathBuf},
    ptr::copy_nonoverlapping,
};

use crate::{
    audio::AuStream, byte_range::ByteRange, error::Xerr, ffms::VidInf, obu_parse::parse,
    ogg::demux, platform::Mmap,
};

const ID_SEGMENT: u32 = 0x1853_8067;
const ID_INFO: u32 = 0x1549_A966;
const ID_DURATION: u32 = 0x4489;
const ID_TRACKS: u32 = 0x1654_AE6B;
const ID_TRACK_ENTRY: u32 = 0xAE;
const ID_TRACK_NUMBER: u32 = 0xD7;
const ID_TRACK_TYPE: u32 = 0x83;
const ID_CODEC_ID: u32 = 0x86;
const ID_CODEC_PRIVATE: u32 = 0x63A2;
const ID_DEFAULT_DURATION: u32 = 0x0023_E383;
const ID_VIDEO: u32 = 0xE0;
const ID_PIXEL_WIDTH: u32 = 0xB0;
const ID_PIXEL_HEIGHT: u32 = 0xBA;
const ID_AUDIO: u32 = 0xE1;
const ID_SAMPLING_FREQ: u32 = 0xB5;
const ID_CHANNELS: u32 = 0x9F;
const ID_CLUSTER: u32 = 0x1F43_B675;
const ID_TIMESTAMP: u32 = 0xE7;
const ID_SIMPLE_BLOCK: u32 = 0xA3;

// 1A45DFA3 [size 7] DocType="webm"; ver/maxid/maxsize defaulted
const EBML_HEADER: &[u8] = &[
    0x1A, 0x45, 0xDF, 0xA3, 0x87, 0x42, 0x82, 0x84, b'w', b'e', b'b', b'm',
];

const CLUSTER_SPAN: u64 = 0x7FFF; // i16 block-rel ceiling (ms @ default 1ms scale)

const fn id_len(id: u32) -> usize {
    4 - (id.leading_zeros() / 8) as usize
}

const fn uint_len(v: u64) -> usize {
    let mut n = 1;
    let mut x = v >> 8;
    while x > 0 {
        n += 1;
        x >>= 8;
    }
    n
}

// EBML vint byte-count; all-ones per width is reserved (unknown-size), hence the -1
const fn vint_len(v: u64) -> usize {
    let mut n = 1;
    while n < 8 && v >= (1u64 << (7 * n)) - 1 {
        n += 1;
    }
    n
}

const fn elem_len(id_bytes: usize, content: usize) -> usize {
    id_bytes + vint_len(content as u64) + content
}

const fn uint_elem(id: u32, v: u64) -> usize {
    id_len(id) + 1 + uint_len(v) // vint_len(uint_len<=8) == 1
}

const fn bytes_elem(id: u32, len: usize) -> usize {
    id_len(id) + vint_len(len as u64) + len
}

const fn f32_elem(id: u32) -> usize {
    id_len(id) + 1 + 4
}

const fn f64_elem(id: u32) -> usize {
    id_len(id) + 1 + 8
}

unsafe fn write_id(id: u32, out: *mut u8) -> usize {
    let n = id_len(id);
    let mut i = 0;
    while i < n {
        unsafe { *out.add(i) = (id >> (8 * (n - 1 - i))) as u8 };
        i += 1;
    }
    n
}

unsafe fn write_vint(v: u64, n: usize, out: *mut u8) {
    let val = (1u64 << (7 * n)) | v;
    let mut i = 0;
    while i < n {
        unsafe { *out.add(i) = (val >> (8 * (n - 1 - i))) as u8 };
        i += 1;
    }
}

unsafe fn put_master(id: u32, content: usize, out: *mut u8) -> usize {
    let n = unsafe { write_id(id, out) };
    let ln = vint_len(content as u64);
    unsafe { write_vint(content as u64, ln, out.add(n)) };
    n + ln
}

unsafe fn put_uint(id: u32, v: u64, out: *mut u8) -> usize {
    let mut n = unsafe { write_id(id, out) };
    let ul = uint_len(v);
    unsafe {
        write_vint(ul as u64, 1, out.add(n));
        n += 1;
        let mut i = 0;
        while i < ul {
            *out.add(n + i) = (v >> (8 * (ul - 1 - i))) as u8;
            i += 1;
        }
    }
    n + ul
}

unsafe fn put_bytes(id: u32, data: &[u8], out: *mut u8) -> usize {
    let mut n = unsafe { write_id(id, out) };
    let ln = vint_len(data.len() as u64);
    unsafe {
        write_vint(data.len() as u64, ln, out.add(n));
        n += ln;
        copy_nonoverlapping(data.as_ptr(), out.add(n), data.len());
    }
    n + data.len()
}

unsafe fn put_f32(id: u32, v: f32, out: *mut u8) -> usize {
    let mut n = unsafe { write_id(id, out) };
    let b = v.to_be_bytes();
    unsafe {
        write_vint(4, 1, out.add(n));
        n += 1;
        let mut i = 0;
        while i < 4 {
            *out.add(n + i) = b[i];
            i += 1;
        }
    }
    n + 4
}

unsafe fn put_f64(id: u32, v: f64, out: *mut u8) -> usize {
    let mut n = unsafe { write_id(id, out) };
    let b = v.to_be_bytes();
    unsafe {
        write_vint(8, 1, out.add(n));
        n += 1;
        let mut i = 0;
        while i < 8 {
            *out.add(n + i) = b[i];
            i += 1;
        }
    }
    n + 8
}

unsafe fn put_info(duration_ms: f64, out: *mut u8) -> usize {
    let content = f64_elem(ID_DURATION);
    let mut n = unsafe { put_master(ID_INFO, content, out) };
    n += unsafe { put_f64(ID_DURATION, duration_ms, out.add(n)) };
    n
}

#[cfg(target_arch = "x86_64")]
unsafe fn copy_nt(src: *const u8, dst: *mut u8, len: usize) {
    use core::arch::x86_64::_mm_stream_si64;
    let mut i = 0;
    unsafe {
        while i + 8 <= len {
            _mm_stream_si64(dst.add(i).cast(), src.add(i).cast::<i64>().read_unaligned());
            i += 8;
        }
        while i < len {
            *dst.add(i) = *src.add(i);
            i += 1;
        }
    }
}

#[cfg(not(target_arch = "x86_64"))]
unsafe fn copy_nt(src: *const u8, dst: *mut u8, len: usize) {
    unsafe { copy_nonoverlapping(src, dst, len) };
}

const fn video_track_len(w: u64, h: u64, frame_dur_ns: u64) -> usize {
    let video = uint_elem(ID_PIXEL_WIDTH, w) + uint_elem(ID_PIXEL_HEIGHT, h);
    let content = uint_elem(ID_TRACK_NUMBER, 1)
        + uint_elem(ID_TRACK_TYPE, 1)
        + bytes_elem(ID_CODEC_ID, 5)
        + uint_elem(ID_DEFAULT_DURATION, frame_dur_ns)
        + elem_len(id_len(ID_VIDEO), video);
    elem_len(id_len(ID_TRACK_ENTRY), content)
}

unsafe fn put_video_track(w: u64, h: u64, frame_dur_ns: u64, out: *mut u8) -> usize {
    let video = uint_elem(ID_PIXEL_WIDTH, w) + uint_elem(ID_PIXEL_HEIGHT, h);
    let content = uint_elem(ID_TRACK_NUMBER, 1)
        + uint_elem(ID_TRACK_TYPE, 1)
        + bytes_elem(ID_CODEC_ID, 5)
        + uint_elem(ID_DEFAULT_DURATION, frame_dur_ns)
        + elem_len(id_len(ID_VIDEO), video);
    let mut n = unsafe { put_master(ID_TRACK_ENTRY, content, out) };
    unsafe {
        n += put_uint(ID_TRACK_NUMBER, 1, out.add(n));
        n += put_uint(ID_TRACK_TYPE, 1, out.add(n));
        n += put_bytes(ID_CODEC_ID, b"V_AV1", out.add(n));
        n += put_uint(ID_DEFAULT_DURATION, frame_dur_ns, out.add(n));
        n += put_master(ID_VIDEO, video, out.add(n));
        n += put_uint(ID_PIXEL_WIDTH, w, out.add(n));
        n += put_uint(ID_PIXEL_HEIGHT, h, out.add(n));
    }
    n
}

const fn audio_track_len(track: u64, head_len: usize, channels: u64) -> usize {
    let audio = f32_elem(ID_SAMPLING_FREQ) + uint_elem(ID_CHANNELS, channels);
    let content = uint_elem(ID_TRACK_NUMBER, track)
        + uint_elem(ID_TRACK_TYPE, 2)
        + bytes_elem(ID_CODEC_ID, 6)
        + bytes_elem(ID_CODEC_PRIVATE, head_len)
        + elem_len(id_len(ID_AUDIO), audio);
    elem_len(id_len(ID_TRACK_ENTRY), content)
}

unsafe fn put_audio_track(track: u64, head: &[u8], channels: u64, out: *mut u8) -> usize {
    let audio = f32_elem(ID_SAMPLING_FREQ) + uint_elem(ID_CHANNELS, channels);
    let content = uint_elem(ID_TRACK_NUMBER, track)
        + uint_elem(ID_TRACK_TYPE, 2)
        + bytes_elem(ID_CODEC_ID, 6)
        + bytes_elem(ID_CODEC_PRIVATE, head.len())
        + elem_len(id_len(ID_AUDIO), audio);
    let mut n = unsafe { put_master(ID_TRACK_ENTRY, content, out) };
    unsafe {
        n += put_uint(ID_TRACK_NUMBER, track, out.add(n));
        n += put_uint(ID_TRACK_TYPE, 2, out.add(n));
        n += put_bytes(ID_CODEC_ID, b"A_OPUS", out.add(n));
        n += put_bytes(ID_CODEC_PRIVATE, head, out.add(n));
        n += put_master(ID_AUDIO, audio, out.add(n));
        n += put_f32(ID_SAMPLING_FREQ, 48000.0, out.add(n));
        n += put_uint(ID_CHANNELS, channels, out.add(n));
    }
    n
}

const fn block_len(track: u64, payload: usize) -> usize {
    let content = vint_len(track) + 3 + payload; // track-vint + i16 rel + flags
    elem_len(id_len(ID_SIMPLE_BLOCK), content)
}

unsafe fn put_block(track: u64, rel: i16, kf: bool, payload: &[u8], out: *mut u8) -> usize {
    let content = vint_len(track) + 3 + payload.len();
    let mut n = unsafe { put_master(ID_SIMPLE_BLOCK, content, out) };
    let tl = vint_len(track);
    let r = rel.to_be_bytes();
    unsafe {
        write_vint(track, tl, out.add(n));
        n += tl;
        *out.add(n) = r[0];
        *out.add(n + 1) = r[1];
        *out.add(n + 2) = if kf { 0x80 } else { 0x00 };
        n += 3;
        copy_nt(payload.as_ptr(), out.add(n), payload.len());
    }
    n + payload.len()
}

struct Blk<'a> {
    track: u64,
    ts: u64,
    kf: bool,
    data: &'a [u8],
    range: ByteRange,
}

struct Cluster {
    base: u64,
    lo: usize,
    hi: usize,
    content: usize,
}

pub fn mux_webm(
    paths: &[PathBuf],
    out: &Path,
    inf: &VidInf,
    dims: (u32, u32),
    au: &[(AuStream, PathBuf)],
) -> Result<(), Xerr> {
    let (w, h) = (u64::from(dims.0), u64::from(dims.1));
    let (fps_num, fps_den) = (u64::from(inf.fps_num), u64::from(inf.fps_den));

    let vmaps = paths
        .iter()
        .map(|p| Mmap::open(p))
        .collect::<Result<Vec<_>, _>>()?;
    let amaps = au
        .iter()
        .map(|e| Mmap::open(&e.1))
        .collect::<Result<Vec<_>, _>>()?;

    let mut blocks: Vec<Blk> = Vec::with_capacity(inf.frames);
    let mut gi = 0u64;
    let mut frames = Vec::new();
    for m in &vmaps {
        let buf = m.slice();
        frames.clear();
        parse(buf, &mut frames);
        for (fj, r) in frames.iter().enumerate() {
            let ts = (gi * 1000 * fps_den + fps_num / 2) / fps_num;
            blocks.push(Blk {
                track: 1,
                ts,
                kf: fj == 0,
                data: buf,
                range: *r,
            });
            gi += 1;
        }
    }

    let mut audio_meta: Vec<(u64, Vec<u8>, u64)> = Vec::new();
    let mut audio_end_ns = 0u64;
    for m in &amaps {
        let os = demux(m.slice())?;
        if os.packets.is_empty() {
            continue;
        }
        let track = 2 + audio_meta.len() as u64;
        let data = m.slice();
        let mut cum = 0u64;
        for p in &os.packets {
            let ts = (cum * 1000 + 24_000) / 48_000; // samples@48k -> ms, rounded
            blocks.push(Blk {
                track,
                ts,
                kf: true,
                data,
                range: p.range,
            });
            cum += u64::from(p.samples);
        }
        audio_end_ns = audio_end_ns.max((u128::from(cum) * 1_000_000_000 / 48_000) as u64);
        audio_meta.push((track, os.head, u64::from(os.channels)));
    }

    if blocks.is_empty() {
        return Err("webm: no frames".into());
    }

    blocks.sort_by_key(|b| b.ts); // stable: video (pushed first) wins ties

    let frame_dur_ns = 1_000_000_000 * fps_den / fps_num;
    let video_end_ns =
        (u128::from(gi) * 1_000_000_000 * u128::from(fps_den) / u128::from(fps_num)) as u64;
    let duration_ms = video_end_ns.max(audio_end_ns) as f64 / 1_000_000.0;

    let mut tracks_content = video_track_len(w, h, frame_dur_ns);
    for a in &audio_meta {
        tracks_content += audio_track_len(a.0, a.1.len(), a.2);
    }

    let mut clusters: Vec<Cluster> = Vec::new();
    let info_total = elem_len(id_len(ID_INFO), f64_elem(ID_DURATION));
    let mut segment_content = info_total + elem_len(id_len(ID_TRACKS), tracks_content);
    let mut i = 0;
    while i < blocks.len() {
        let base = unsafe { blocks.get_unchecked(i) }.ts;
        let lo = i;
        let mut content = uint_elem(ID_TIMESTAMP, base);
        while i < blocks.len() {
            let b = unsafe { blocks.get_unchecked(i) };
            if b.ts - base > CLUSTER_SPAN {
                break;
            }
            content += block_len(b.track, b.range.len);
            i += 1;
        }
        segment_content += elem_len(id_len(ID_CLUSTER), content);
        clusters.push(Cluster {
            base,
            lo,
            hi: i,
            content,
        });
    }

    let file_size = EBML_HEADER.len() + elem_len(id_len(ID_SEGMENT), segment_content);

    write_file(out, file_size, |dst| unsafe {
        let base = dst.as_mut_ptr();
        copy_nonoverlapping(EBML_HEADER.as_ptr(), base, EBML_HEADER.len());
        let mut n = EBML_HEADER.len();
        n += put_master(ID_SEGMENT, segment_content, base.add(n));
        n += put_info(duration_ms, base.add(n));
        n += put_master(ID_TRACKS, tracks_content, base.add(n));
        n += put_video_track(w, h, frame_dur_ns, base.add(n));
        for a in &audio_meta {
            n += put_audio_track(a.0, &a.1, a.2, base.add(n));
        }
        for c in &clusters {
            n += put_master(ID_CLUSTER, c.content, base.add(n));
            n += put_uint(ID_TIMESTAMP, c.base, base.add(n));
            for b in blocks.get_unchecked(c.lo..c.hi) {
                let rel = (b.ts - c.base) as i16;
                n += put_block(b.track, rel, b.kf, b.range.slice(b.data), base.add(n));
            }
        }
    })
}

#[cfg(target_os = "linux")]
fn write_file(out: &Path, size: usize, build: impl FnOnce(&mut [u8])) -> Result<(), Xerr> {
    use core::arch::x86_64::_mm_sfence;
    use std::{
        fs::OpenOptions, os::unix::io::AsRawFd as _, ptr::null_mut, slice::from_raw_parts_mut,
    };

    use libc::{
        MADV_HUGEPAGE, MAP_FAILED, MAP_SHARED, PROT_READ, PROT_WRITE, madvise, mmap, munmap,
    };

    let f = OpenOptions::new()
        .read(true)
        .write(true)
        .create(true)
        .truncate(true)
        .open(out)?;
    f.set_len(size as u64)?;
    let ptr = unsafe {
        mmap(
            null_mut(),
            size,
            PROT_READ | PROT_WRITE,
            MAP_SHARED,
            f.as_raw_fd(),
            0,
        )
    };
    if ptr == MAP_FAILED {
        return Err("webm: output mmap failed".into());
    }
    unsafe { madvise(ptr, size, MADV_HUGEPAGE) };
    build(unsafe { from_raw_parts_mut(ptr.cast::<u8>(), size) });
    unsafe {
        _mm_sfence();
        munmap(ptr, size);
    }
    Ok(())
}

#[cfg(not(target_os = "linux"))]
fn write_file(out: &Path, size: usize, build: impl FnOnce(&mut [u8])) -> Result<(), Xerr> {
    use std::fs::write;
    let mut buf = vec![0u8; size];
    build(&mut buf);
    write(out, &buf)?;
    Ok(())
}
