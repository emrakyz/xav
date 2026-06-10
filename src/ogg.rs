use crate::{byte_range::ByteRange, error::Xerr};

pub struct OpusPacket {
    pub range: ByteRange,
    pub samples: u32,
}

pub struct OpusStream {
    pub head: Vec<u8>,
    pub pre_skip: u16,
    pub channels: u8,
    pub packets: Vec<OpusPacket>,
}

// OpusHead alone on the BOS page, OpusTags next, then coded packets. packets
// never span a page at frame size/bitrate. a continuation (trailing lace 255) is an error
pub fn demux(buf: &[u8]) -> Result<OpusStream, Xerr> {
    let mut head: Option<Vec<u8>> = None;
    let mut packets = Vec::new();
    let mut idx = 0usize;
    let mut pos = 0;

    while pos + 27 <= buf.len() {
        if &buf[pos..pos + 4] != b"OggS" {
            return Err("Ogg: bad capture pattern".into());
        }
        let nsegs = buf[pos + 26] as usize;
        let tbl = pos + 27;
        let mut data = tbl + nsegs;
        if data > buf.len() {
            return Err("Ogg: truncated segment table".into());
        }

        let mut start = data;
        let mut len = 0;
        for &seg in &buf[tbl..tbl + nsegs] {
            let lace = seg as usize;
            len += lace;
            data += lace;
            if lace == 255 {
                continue;
            }
            if data > buf.len() {
                return Err("Ogg: truncated packet".into());
            }
            let pkt = &buf[start..start + len];
            match idx {
                0 if pkt.starts_with(b"OpusHead") => head = Some(pkt.to_vec()),
                0 => return Err("Opus: first packet not OpusHead".into()),
                1 => {} // OpusTags
                _ => packets.push(OpusPacket {
                    range: ByteRange { offset: start, len },
                    samples: packet_samples(pkt)?,
                }),
            }
            idx += 1;
            start = data;
            len = 0;
        }
        if len != 0 {
            return Err("Opus packet spans Ogg page".into());
        }
        pos = data;
    }

    let head = head.ok_or("Opus: missing OpusHead")?;
    if head.len() < 19 {
        return Err("Opus: short OpusHead".into());
    }
    Ok(OpusStream {
        channels: head[9],
        pre_skip: u16::from_le_bytes([head[10], head[11]]),
        head,
        packets,
    })
}

// RFC 6716 TOC: config picks frame size, code picks frame count
fn packet_samples(pkt: &[u8]) -> Result<u32, Xerr> {
    let &toc = pkt.first().ok_or("Opus: empty packet")?;
    let frames = match toc & 0x3 {
        0 => 1,
        1 | 2 => 2,
        _ => u32::from(pkt.get(1).copied().ok_or("Opus: short code-3 packet")? & 0x3F),
    };
    Ok(frame_48k(toc >> 3) * frames)
}

const fn frame_48k(config: u8) -> u32 {
    match config {
        16 | 20 | 24 | 28 => 120,                       // 2.5 ms
        17 | 21 | 25 | 29 => 240,                       // 5 ms
        0 | 4 | 8 | 12 | 14 | 18 | 22 | 26 | 30 => 480, // 10 ms
        1 | 5 | 9 | 13 | 15 | 19 | 23 | 27 | 31 => 960, // 20 ms
        2 | 6 | 10 => 1920,                             // 40 ms
        _ => 2880,                                      // 3,7,11 -> 60 ms
    }
}
