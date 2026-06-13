use core::str::from_utf8;

const EBML_MAGIC: u32 = 0x1A45_DFA3;
const SEGMENT: u32 = 0x1853_8067;
const CLUSTER: u32 = 0x1F43_B675;
const TRACKS: u32 = 0x1654_AE6B;
const TRACK_ENTRY: u32 = 0xAE;
const LANG_IETF: u32 = 0x0022_B59D;
const CHAPTERS: u32 = 0x1043_A770;
const EDITION_ENTRY: u32 = 0x45B9;
const CHAPTER_ATOM: u32 = 0xB6;
const CHAPTER_DISPLAY: u32 = 0x80;
const CHAP_LANG_IETF: u32 = 0x437D;

#[must_use]
pub fn track_langs(buf: &[u8]) -> Vec<(u64, &str)> {
    let Some(body) = segment_child(buf, TRACKS) else {
        return Vec::new();
    };
    let mut out = Vec::new();
    let mut pos = 0u64;
    let mut p = body;
    while let Some((id, content, next)) = read_element(p) {
        if id == TRACK_ENTRY {
            if let Some(ietf) = subtag(content, LANG_IETF) {
                out.push((pos, ietf));
            }
            pos += 1;
        }
        p = next;
    }
    out
}

#[must_use]
pub fn chapter_langs(buf: &[u8]) -> Vec<(u64, &str)> {
    let Some(body) = segment_child(buf, CHAPTERS) else {
        return Vec::new();
    };
    let mut out = Vec::new();
    let mut pos = 0u64;
    let mut p = body;
    while let Some((id, content, next)) = read_element(p) {
        if id == EDITION_ENTRY {
            walk_atoms(content, &mut out, &mut pos);
        }
        p = next;
    }
    out
}

fn walk_atoms<'a>(body: &'a [u8], out: &mut Vec<(u64, &'a str)>, pos: &mut u64) {
    let mut p = body;
    while let Some((id, content, next)) = read_element(p) {
        if id == CHAPTER_ATOM {
            if let Some(ietf) = atom_lang(content) {
                out.push((*pos, ietf));
            }
            *pos += 1;
        }
        p = next;
    }
}

fn atom_lang(body: &[u8]) -> Option<&str> {
    let mut p = body;
    while let Some((id, content, next)) = read_element(p) {
        if id == CHAPTER_DISPLAY
            && let Some(ietf) = subtag(content, CHAP_LANG_IETF)
        {
            return Some(ietf);
        }
        p = next;
    }
    None
}

fn subtag(body: &[u8], target: u32) -> Option<&str> {
    let mut p = body;
    while let Some((id, content, next)) = read_element(p) {
        if id == target {
            return from_utf8(content).ok().filter(|s| s.contains('-'));
        }
        p = next;
    }
    None
}

fn segment_child(buf: &[u8], target: u32) -> Option<&[u8]> {
    if !matches!(read_id(buf), Some((EBML_MAGIC, _))) {
        return None;
    }
    let mut p = buf;
    let mut seg = None;
    while let Some((id, content, next)) = read_element(p) {
        if id == SEGMENT {
            seg = Some(content);
            break;
        }
        p = next;
    }
    let mut q = seg?;
    while let Some((id, content, next)) = read_element(q) {
        if id == CLUSTER {
            return None;
        }
        if id == target {
            return Some(content);
        }
        q = next;
    }
    None
}

fn read_element(p: &[u8]) -> Option<(u32, &[u8], &[u8])> {
    let (id, il) = read_id(p)?;
    let rest = p.get(il..)?;
    let (size, sl, unknown) = read_size(rest)?;
    let after = rest.get(sl..)?;
    let n = if unknown { after.len() } else { size as usize };
    let (content, next) = after.split_at_checked(n)?;
    Some((id, content, next))
}

fn read_id(p: &[u8]) -> Option<(u32, usize)> {
    let first = *p.first()?;
    let len = first.leading_zeros() as usize + 1;
    if len > 4 {
        return None;
    }
    let id = p
        .get(1..len)?
        .iter()
        .fold(u32::from(first), |a, &b| (a << 8) | u32::from(b));
    Some((id, len))
}

fn read_size(p: &[u8]) -> Option<(u64, usize, bool)> {
    let first = *p.first()?;
    let len = first.leading_zeros() as usize + 1;
    if len > 8 {
        return None;
    }
    let mask = (0xFFu32 >> len) as u8; // strip the vint length marker
    let v = p
        .get(1..len)?
        .iter()
        .fold(u64::from(first & mask), |a, &b| (a << 8) | u64::from(b));
    Some((v, len, v == (1u64 << (7 * len)) - 1))
}
