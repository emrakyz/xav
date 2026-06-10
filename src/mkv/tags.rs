use super::{
    crc32::{CRC_ELEMENT_LEN, Crc32, patch_crc, write_crc_placeholder},
    ebml::vint_encode,
    element::{bytes_elem_size, master_size, uint_elem_size, write_bytes, write_id, write_uint},
};

const TAGS_ID: u32 = 0x1254_C367;
const TAG_ID: u32 = 0x7373;
const TARGETS_ID: u32 = 0x63C0;
const TARGET_TYPE_VALUE: u32 = 0x68CA;
const TARGET_TYPE: u32 = 0x63CA;
const TAG_TRACK_UID: u32 = 0x63C5;
const SIMPLE_TAG: u32 = 0x67C8;
const TAG_NAME: u32 = 0x45A3;
const TAG_LANGUAGE: u32 = 0x447A;
const TAG_STRING: u32 = 0x4487;

const APP: &str = concat!("xav ", env!("CARGO_PKG_VERSION"));
const STATS_TAGS: &str = "BPS DURATION NUMBER_OF_FRAMES NUMBER_OF_BYTES";

pub struct TrackStatistics<'a> {
    pub track_uid: u64,
    pub bps: u64,
    pub duration_ns: u64,
    pub n_frames: u64,
    pub n_bytes: u64,
    pub date_utc_str: &'a str,
    pub encoder: &'a str,
    pub settings: &'a str,
}

const fn dec_len(v: u64) -> usize {
    let mut n = 1;
    let mut x = v;
    while x >= 10 {
        x /= 10;
        n += 1;
    }
    n
}

// `v` decimal into out, left zero-padded to >= width digits
fn write_dec(out: &mut [u8], v: u64, width: usize) -> usize {
    let len = dec_len(v).max(width);
    let mut x = v;
    let mut i = len;
    while i > 0 {
        i -= 1;
        unsafe { *out.get_unchecked_mut(i) = b'0' + (x % 10) as u8 };
        x /= 10;
    }
    len
}

// "HH:MM:SS.fffffffff"; hours field widens past 2 digits past 100h
const fn duration_len(ns: u64) -> usize {
    let h = (ns / 1_000_000_000) / 3600;
    let hl = if dec_len(h) > 2 { dec_len(h) } else { 2 };
    hl + 16
}

fn write_duration(out: &mut [u8], ns: u64) -> usize {
    let secs = ns / 1_000_000_000;
    let nanos = ns % 1_000_000_000;
    let mut n = write_dec(out, secs / 3600, 2);
    unsafe {
        *out.get_unchecked_mut(n) = b':';
        n += 1;
        n += write_dec(out.get_unchecked_mut(n..), (secs / 60) % 60, 2);
        *out.get_unchecked_mut(n) = b':';
        n += 1;
        n += write_dec(out.get_unchecked_mut(n..), secs % 60, 2);
        *out.get_unchecked_mut(n) = b'.';
        n += 1;
        n += write_dec(out.get_unchecked_mut(n..), nanos, 9);
    }
    n
}

#[must_use]
pub fn tags_size(tracks: &[TrackStatistics<'_>]) -> usize {
    let mut content = CRC_ELEMENT_LEN;
    for s in tracks {
        content += master_size(TAG_ID, tag_body_size(s));
    }
    master_size(TAGS_ID, content)
}

#[must_use]
pub fn write_tags(out: &mut [u8], tracks: &[TrackStatistics<'_>]) -> usize {
    let mut content = CRC_ELEMENT_LEN;
    for s in tracks {
        content += master_size(TAG_ID, tag_body_size(s));
    }
    let mut n = write_id(TAGS_ID, out);
    let crc_offset;
    let children_start;
    unsafe {
        n += vint_encode(content as u64, out.get_unchecked_mut(n..));
        crc_offset = n + 2;
        n += write_crc_placeholder(out.get_unchecked_mut(n..));
        children_start = n;
        for s in tracks {
            n += write_tag(out.get_unchecked_mut(n..), s);
        }
        let mut crc = Crc32::new();
        crc.update(out.get_unchecked(children_start..n));
        patch_crc(out, crc_offset, crc.finalize());
    }
    n
}

const fn entry_size(name: &str, value_len: usize) -> usize {
    master_size(
        SIMPLE_TAG,
        bytes_elem_size(TAG_NAME, name.len())
            + bytes_elem_size(TAG_LANGUAGE, 3)
            + bytes_elem_size(TAG_STRING, value_len),
    )
}

const fn targets_size(track_uid: u64) -> usize {
    master_size(
        TARGETS_ID,
        uint_elem_size(TARGET_TYPE_VALUE, 50)
            + bytes_elem_size(TARGET_TYPE, 5)
            + uint_elem_size(TAG_TRACK_UID, track_uid),
    )
}

const fn tag_body_size(s: &TrackStatistics<'_>) -> usize {
    let mut n = targets_size(s.track_uid);
    if !s.encoder.is_empty() {
        n += entry_size("ENCODER", s.encoder.len());
    }
    if !s.settings.is_empty() {
        n += entry_size("ENCODER_SETTINGS", s.settings.len());
    }
    n += entry_size("BPS", dec_len(s.bps));
    n += entry_size("DURATION", duration_len(s.duration_ns));
    n += entry_size("NUMBER_OF_FRAMES", dec_len(s.n_frames));
    n += entry_size("NUMBER_OF_BYTES", dec_len(s.n_bytes));
    n += entry_size("_STATISTICS_WRITING_APP", APP.len());
    n += entry_size("_STATISTICS_WRITING_DATE_UTC", s.date_utc_str.len());
    n += entry_size("_STATISTICS_TAGS", STATS_TAGS.len());
    n
}

fn write_tag(out: &mut [u8], s: &TrackStatistics<'_>) -> usize {
    let mut n = write_id(TAG_ID, out);
    unsafe {
        n += vint_encode(tag_body_size(s) as u64, out.get_unchecked_mut(n..));
        n += write_targets(out.get_unchecked_mut(n..), s.track_uid);
        if !s.encoder.is_empty() {
            n += write_str(out.get_unchecked_mut(n..), "ENCODER", s.encoder.as_bytes());
        }
        if !s.settings.is_empty() {
            n += write_str(
                out.get_unchecked_mut(n..),
                "ENCODER_SETTINGS",
                s.settings.as_bytes(),
            );
        }
        n += write_num(out.get_unchecked_mut(n..), "BPS", s.bps);
        n += write_dur(out.get_unchecked_mut(n..), "DURATION", s.duration_ns);
        n += write_num(out.get_unchecked_mut(n..), "NUMBER_OF_FRAMES", s.n_frames);
        n += write_num(out.get_unchecked_mut(n..), "NUMBER_OF_BYTES", s.n_bytes);
        n += write_str(
            out.get_unchecked_mut(n..),
            "_STATISTICS_WRITING_APP",
            APP.as_bytes(),
        );
        n += write_str(
            out.get_unchecked_mut(n..),
            "_STATISTICS_WRITING_DATE_UTC",
            s.date_utc_str.as_bytes(),
        );
        n += write_str(
            out.get_unchecked_mut(n..),
            "_STATISTICS_TAGS",
            STATS_TAGS.as_bytes(),
        );
    }
    n
}

fn write_targets(out: &mut [u8], track_uid: u64) -> usize {
    let content = uint_elem_size(TARGET_TYPE_VALUE, 50)
        + bytes_elem_size(TARGET_TYPE, 5)
        + uint_elem_size(TAG_TRACK_UID, track_uid);
    let mut n = write_id(TARGETS_ID, out);
    unsafe {
        n += vint_encode(content as u64, out.get_unchecked_mut(n..));
        n += write_uint(TARGET_TYPE_VALUE, 50, out.get_unchecked_mut(n..)); // MOVIE
        n += write_bytes(TARGET_TYPE, b"MOVIE", out.get_unchecked_mut(n..));
        n += write_uint(TAG_TRACK_UID, track_uid, out.get_unchecked_mut(n..));
    }
    n
}

fn entry_head(out: &mut [u8], name: &str, value_len: usize) -> usize {
    let content = bytes_elem_size(TAG_NAME, name.len())
        + bytes_elem_size(TAG_LANGUAGE, 3)
        + bytes_elem_size(TAG_STRING, value_len);
    let mut n = write_id(SIMPLE_TAG, out);
    unsafe {
        n += vint_encode(content as u64, out.get_unchecked_mut(n..));
        n += write_bytes(TAG_NAME, name.as_bytes(), out.get_unchecked_mut(n..));
        n += write_bytes(TAG_LANGUAGE, b"und", out.get_unchecked_mut(n..));
    }
    n
}

fn write_str(out: &mut [u8], name: &str, value: &[u8]) -> usize {
    let mut n = entry_head(out, name, value.len());
    unsafe { n += write_bytes(TAG_STRING, value, out.get_unchecked_mut(n..)) };
    n
}

fn write_num(out: &mut [u8], name: &str, v: u64) -> usize {
    let len = dec_len(v);
    let mut n = entry_head(out, name, len);
    unsafe {
        n += write_id(TAG_STRING, out.get_unchecked_mut(n..));
        n += vint_encode(len as u64, out.get_unchecked_mut(n..));
        n += write_dec(out.get_unchecked_mut(n..), v, 1);
    }
    n
}

fn write_dur(out: &mut [u8], name: &str, ns: u64) -> usize {
    let len = duration_len(ns);
    let mut n = entry_head(out, name, len);
    unsafe {
        n += write_id(TAG_STRING, out.get_unchecked_mut(n..));
        n += vint_encode(len as u64, out.get_unchecked_mut(n..));
        n += write_duration(out.get_unchecked_mut(n..), ns);
    }
    n
}

pub fn enc_settings(params: &str) -> String {
    let mut iter = params.split_whitespace();
    let mut out = String::with_capacity(params.len());
    while let Some(key) = iter.next() {
        let Some(name) = key.strip_prefix("--") else {
            continue;
        };
        let Some(val) = iter.next() else { break };
        match name {
            "lp" | "crf" | "qp" | "QP" | "t" | "Threads" => continue,
            "scm" if val == "0" => continue,
            _ => {}
        }
        if !out.is_empty() {
            out.push(' ');
        }
        out.push_str(name);
        out.push('=');
        out.push_str(val);
    }
    out
}
