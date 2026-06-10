use super::{
    crc32::{CRC_ELEMENT_LEN, Crc32, patch_crc, write_crc_placeholder},
    ebml::vint_encode,
    element::{bytes_elem_size, master_size, uint_elem_size, write_bytes, write_id, write_uint},
};

const CHAPTERS_ID: u32 = 0x1043_A770;
const EDITION_ENTRY: u32 = 0x45B9;
const EDITION_UID: u32 = 0x45BC;
const EDITION_FLAG_HIDDEN: u32 = 0x45BD;
const EDITION_FLAG_DEFAULT: u32 = 0x45DB;
const CHAPTER_ATOM: u32 = 0xB6;
const CHAPTER_UID: u32 = 0x73C4;
const CHAPTER_TIME_START: u32 = 0x91;
const CHAPTER_TIME_END: u32 = 0x92;
const CHAPTER_FLAG_HIDDEN: u32 = 0x98;
const CHAPTER_FLAG_ENABLED: u32 = 0x4598;
const CHAPTER_DISPLAY: u32 = 0x80;
const CHAP_STRING: u32 = 0x85;
const CHAP_LANGUAGE: u32 = 0x437C;

pub struct ChapterEntry<'a> {
    pub uid: u64,
    pub start_ns: u64,
    pub end_ns: u64,
    pub title: &'a [u8],
    pub lang: &'a [u8],
}

#[must_use]
pub fn chapters_size(edition_uid: u64, atoms: &[ChapterEntry<'_>]) -> usize {
    master_size(
        CHAPTERS_ID,
        CRC_ELEMENT_LEN + master_size(EDITION_ENTRY, edition_content_size(edition_uid, atoms)),
    )
}

#[must_use]
pub fn write_chapters(out: &mut [u8], edition_uid: u64, atoms: &[ChapterEntry<'_>]) -> usize {
    let edition = edition_content_size(edition_uid, atoms);
    let content = CRC_ELEMENT_LEN + master_size(EDITION_ENTRY, edition);

    let mut n = write_id(CHAPTERS_ID, out);
    let crc_offset;
    let children_start;
    unsafe {
        n += vint_encode(content as u64, out.get_unchecked_mut(n..));
        crc_offset = n + 2;
        n += write_crc_placeholder(out.get_unchecked_mut(n..));
        children_start = n;
        n += write_id(EDITION_ENTRY, out.get_unchecked_mut(n..));
        n += vint_encode(edition as u64, out.get_unchecked_mut(n..));
        n += write_uint(EDITION_UID, edition_uid, out.get_unchecked_mut(n..));
        n += write_uint(EDITION_FLAG_HIDDEN, 0, out.get_unchecked_mut(n..));
        n += write_uint(EDITION_FLAG_DEFAULT, 0, out.get_unchecked_mut(n..));
        for a in atoms {
            n += write_chapter_atom(out.get_unchecked_mut(n..), a);
        }
        let mut crc = Crc32::new();
        crc.update(out.get_unchecked(children_start..n));
        patch_crc(out, crc_offset, crc.finalize());
    }
    n
}

fn edition_content_size(edition_uid: u64, atoms: &[ChapterEntry<'_>]) -> usize {
    let mut n = uint_elem_size(EDITION_UID, edition_uid)
        + uint_elem_size(EDITION_FLAG_HIDDEN, 0)
        + uint_elem_size(EDITION_FLAG_DEFAULT, 0);
    for a in atoms {
        n += master_size(CHAPTER_ATOM, atom_content_size(a));
    }
    n
}

const fn atom_content_size(a: &ChapterEntry<'_>) -> usize {
    let mut n = uint_elem_size(CHAPTER_UID, a.uid) + uint_elem_size(CHAPTER_TIME_START, a.start_ns);
    if a.end_ns > a.start_ns {
        n += uint_elem_size(CHAPTER_TIME_END, a.end_ns);
    }
    n += uint_elem_size(CHAPTER_FLAG_HIDDEN, 0) + uint_elem_size(CHAPTER_FLAG_ENABLED, 1);
    if !a.title.is_empty() {
        n += master_size(CHAPTER_DISPLAY, display_content_size(a.title, a.lang));
    }
    n
}

fn write_chapter_atom(out: &mut [u8], a: &ChapterEntry<'_>) -> usize {
    let mut n = write_id(CHAPTER_ATOM, out);
    unsafe {
        n += vint_encode(atom_content_size(a) as u64, out.get_unchecked_mut(n..));
        n += write_uint(CHAPTER_UID, a.uid, out.get_unchecked_mut(n..));
        n += write_uint(CHAPTER_TIME_START, a.start_ns, out.get_unchecked_mut(n..));
        if a.end_ns > a.start_ns {
            n += write_uint(CHAPTER_TIME_END, a.end_ns, out.get_unchecked_mut(n..));
        }
        n += write_uint(CHAPTER_FLAG_HIDDEN, 0, out.get_unchecked_mut(n..));
        n += write_uint(CHAPTER_FLAG_ENABLED, 1, out.get_unchecked_mut(n..));
        if !a.title.is_empty() {
            n += write_chapter_display(out.get_unchecked_mut(n..), a.title, a.lang);
        }
    }
    n
}

const fn display_content_size(title: &[u8], lang: &[u8]) -> usize {
    bytes_elem_size(CHAP_STRING, title.len()) + bytes_elem_size(CHAP_LANGUAGE, lang.len())
}

fn write_chapter_display(out: &mut [u8], title: &[u8], lang: &[u8]) -> usize {
    let mut n = write_id(CHAPTER_DISPLAY, out);
    unsafe {
        n += vint_encode(
            display_content_size(title, lang) as u64,
            out.get_unchecked_mut(n..),
        );
        n += write_bytes(CHAP_STRING, title, out.get_unchecked_mut(n..));
        n += write_bytes(CHAP_LANGUAGE, lang, out.get_unchecked_mut(n..));
    }
    n
}
