use super::{
    crc32::{CRC_ELEMENT_LEN, Crc32, patch_crc, write_crc_placeholder},
    ebml::vint_encode,
    element::{bytes_elem_size, master_size, uint_elem_size, write_bytes, write_id, write_uint},
};

const SEEK_HEAD_ID: u32 = 0x114D_9B74;
const SEEK_MASTER_ID: u32 = 0x4DBB;
const SEEK_ID: u32 = 0x53AB;
const SEEK_POSITION: u32 = 0x53AC;

const INFO_ID: [u8; 4] = [0x15, 0x49, 0xA9, 0x66];
const TRACKS_ID: [u8; 4] = [0x16, 0x54, 0xAE, 0x6B];
const CHAPTERS_ID: [u8; 4] = [0x10, 0x43, 0xA7, 0x70];
const CUES_ID: [u8; 4] = [0x1C, 0x53, 0xBB, 0x6B];
const TAGS_ID: [u8; 4] = [0x12, 0x54, 0xC3, 0x67];

pub struct SeekTable {
    pub info: u64,
    pub tracks: u64,
    pub chapters: Option<u64>, // None = no Chapters element
    pub cues: u64,
    pub tags: u64,
}

#[must_use]
pub const fn seek_head_size(t: &SeekTable) -> usize {
    let mut content = CRC_ELEMENT_LEN + seek_entry_size(t.info) + seek_entry_size(t.tracks);
    if let Some(c) = t.chapters {
        content += seek_entry_size(c);
    }
    content += seek_entry_size(t.cues) + seek_entry_size(t.tags);
    master_size(SEEK_HEAD_ID, content)
}

#[must_use]
pub fn write_seek_head(out: &mut [u8], t: &SeekTable) -> usize {
    let mut content = CRC_ELEMENT_LEN + seek_entry_size(t.info) + seek_entry_size(t.tracks);
    if let Some(c) = t.chapters {
        content += seek_entry_size(c);
    }
    content += seek_entry_size(t.cues) + seek_entry_size(t.tags);

    let mut n = write_id(SEEK_HEAD_ID, out);
    let crc_offset;
    let children_start;
    unsafe {
        n += vint_encode(content as u64, out.get_unchecked_mut(n..));
        crc_offset = n + 2;
        n += write_crc_placeholder(out.get_unchecked_mut(n..));
        children_start = n;
        n += write_seek_entry(out.get_unchecked_mut(n..), INFO_ID, t.info);
        n += write_seek_entry(out.get_unchecked_mut(n..), TRACKS_ID, t.tracks);
        if let Some(c) = t.chapters {
            n += write_seek_entry(out.get_unchecked_mut(n..), CHAPTERS_ID, c);
        }
        n += write_seek_entry(out.get_unchecked_mut(n..), CUES_ID, t.cues);
        n += write_seek_entry(out.get_unchecked_mut(n..), TAGS_ID, t.tags);
        let mut crc = Crc32::new();
        crc.update(out.get_unchecked(children_start..n));
        patch_crc(out, crc_offset, crc.finalize());
    }
    n
}

const fn seek_entry_size(position: u64) -> usize {
    master_size(
        SEEK_MASTER_ID,
        bytes_elem_size(SEEK_ID, 4) + uint_elem_size(SEEK_POSITION, position),
    )
}

fn write_seek_entry(out: &mut [u8], target_id: [u8; 4], position: u64) -> usize {
    let content = bytes_elem_size(SEEK_ID, 4) + uint_elem_size(SEEK_POSITION, position);
    let mut n = write_id(SEEK_MASTER_ID, out);
    unsafe {
        n += vint_encode(content as u64, out.get_unchecked_mut(n..));
        n += write_bytes(SEEK_ID, &target_id, out.get_unchecked_mut(n..));
        n += write_uint(SEEK_POSITION, position, out.get_unchecked_mut(n..));
    }
    n
}
