use super::{
    crc32::{CRC_ELEMENT_LEN, Crc32, patch_crc, write_crc_placeholder},
    ebml::vint_encode,
    element::{bytes_elem_size, master_size, uint_elem_size, write_bytes, write_id, write_uint},
};

const TRACKS_ID: u32 = 0x1654_AE6B;
const TRACK_ENTRY_ID: u32 = 0xAE;
const VIDEO_ID: u32 = 0xE0;
const AUDIO_ID: u32 = 0xE1;
const COLOUR_ID: u32 = 0x55B0;
const MASTERING_ID: u32 = 0x55D0;

const TRACK_NUMBER: u32 = 0xD7;
const TRACK_UID: u32 = 0x73C5;
const TRACK_TYPE: u32 = 0x83;
const FLAG_ENABLED: u32 = 0xB9;
const FLAG_DEFAULT: u32 = 0x88;
const FLAG_FORCED: u32 = 0x55AA;
const FLAG_LACING: u32 = 0x9C;
const MAX_BLOCK_ADD: u32 = 0x55EE;
const NAME_ID: u32 = 0x536E;
const LANG_ID: u32 = 0x0022_B59D;
const DEFAULT_DURATION: u32 = 0x0023_E383;
const CODEC_ID: u32 = 0x86;
const CODEC_PRIVATE: u32 = 0x63A2;
const CODEC_NAME: u32 = 0x0025_8688;
const CODEC_DELAY: u32 = 0x56AA;
const SEEK_PREROLL: u32 = 0x56BB;

#[derive(Clone, Copy)]
pub struct Mastering {
    pub r: (f64, f64),
    pub g: (f64, f64),
    pub b: (f64, f64),
    pub wp: (f64, f64),
    pub lum_max: f64,
    pub lum_min: f64,
}

#[derive(Clone, Copy)]
pub struct Colour {
    pub range: u8,
    pub matrix: u8,
    pub transfer: u8,
    pub primaries: u8,
    pub chroma_siting_h: u8,
    pub chroma_siting_v: u8,
    pub mastering: Option<Mastering>,
    pub content_light: Option<(u16, u16)>, // (MaxCLL, MaxFALL)
}

pub struct Track<'a> {
    pub uid: u64,
    pub name: &'a [u8],
    pub codec_id: &'a [u8],
    pub codec_private: &'a [u8],
    pub codec_name: &'a [u8],
    pub width: u32,
    pub height: u32,
    pub default_duration_ns: u64,
    pub display: Option<(u32, u32)>,
    pub colour: Colour,
}

pub struct Audio<'a> {
    pub number: u64,
    pub uid: u64,
    pub default: bool,
    pub name: &'a [u8],
    pub lang: &'a [u8],
    pub codec_id: &'a [u8],
    pub codec_name: &'a [u8],
    pub codec_private: &'a [u8],
    pub default_duration_ns: u64,
    pub channels: u8,
    pub sample_rate: u32,
    pub bit_depth: Option<u8>, // None = omit (lossy); Some for PCM/lossless/Opus
    pub codec_delay_ns: u64,   // 0 = omit
    pub seek_preroll_ns: u64,  // 0 = omit
}

pub struct Subtitle<'a> {
    pub number: u64,
    pub uid: u64,
    pub default: bool,
    pub name: &'a [u8],
    pub lang: &'a [u8],
    pub codec_id: &'a [u8],
    pub codec_name: &'a [u8],
    pub codec_private: &'a [u8],
}

// each *_size mirrors its writer; out is pre-sized so all stores are unchecked

#[must_use]
pub fn tracks_size(video: &Track<'_>, audio: &[Audio<'_>], subs: &[Subtitle<'_>]) -> usize {
    let mut content = CRC_ELEMENT_LEN + master_size(TRACK_ENTRY_ID, video_body_size(video));
    for a in audio {
        content += master_size(TRACK_ENTRY_ID, audio_body_size(a));
    }
    for s in subs {
        content += master_size(TRACK_ENTRY_ID, subtitle_body_size(s));
    }
    master_size(TRACKS_ID, content)
}

#[must_use]
pub fn write_tracks(
    out: &mut [u8],
    video: &Track<'_>,
    audio: &[Audio<'_>],
    subs: &[Subtitle<'_>],
) -> usize {
    let mut content = CRC_ELEMENT_LEN + master_size(TRACK_ENTRY_ID, video_body_size(video));
    for a in audio {
        content += master_size(TRACK_ENTRY_ID, audio_body_size(a));
    }
    for s in subs {
        content += master_size(TRACK_ENTRY_ID, subtitle_body_size(s));
    }

    let mut n = write_id(TRACKS_ID, out);
    let crc_offset;
    let children_start;
    unsafe {
        n += vint_encode(content as u64, out.get_unchecked_mut(n..));
        crc_offset = n + 2;
        n += write_crc_placeholder(out.get_unchecked_mut(n..));
        children_start = n;
        n += write_id(TRACK_ENTRY_ID, out.get_unchecked_mut(n..));
        n += vint_encode(video_body_size(video) as u64, out.get_unchecked_mut(n..));
        n += video_body(out.get_unchecked_mut(n..), video);
        for a in audio {
            n += write_id(TRACK_ENTRY_ID, out.get_unchecked_mut(n..));
            n += vint_encode(audio_body_size(a) as u64, out.get_unchecked_mut(n..));
            n += audio_body(out.get_unchecked_mut(n..), a);
        }
        for s in subs {
            n += write_id(TRACK_ENTRY_ID, out.get_unchecked_mut(n..));
            n += vint_encode(subtitle_body_size(s) as u64, out.get_unchecked_mut(n..));
            n += subtitle_body(out.get_unchecked_mut(n..), s);
        }
        let mut crc = Crc32::new();
        crc.update(out.get_unchecked(children_start..n));
        patch_crc(out, crc_offset, crc.finalize());
    }
    n
}

fn video_body_size(t: &Track<'_>) -> usize {
    uint_elem_size(TRACK_NUMBER, 1)
        + uint_elem_size(TRACK_UID, t.uid)
        + uint_elem_size(TRACK_TYPE, 1)
        + uint_elem_size(FLAG_ENABLED, 1)
        + uint_elem_size(FLAG_DEFAULT, 1)
        + uint_elem_size(FLAG_FORCED, 0)
        + uint_elem_size(FLAG_LACING, 0)
        + uint_elem_size(MAX_BLOCK_ADD, 0)
        + bytes_elem_size(NAME_ID, t.name.len())
        + bytes_elem_size(LANG_ID, 3)
        + uint_elem_size(DEFAULT_DURATION, t.default_duration_ns)
        + bytes_elem_size(CODEC_ID, t.codec_id.len())
        + bytes_elem_size(CODEC_PRIVATE, t.codec_private.len())
        + bytes_elem_size(CODEC_NAME, t.codec_name.len())
        + master_size(VIDEO_ID, video_content_size(t))
}

fn video_body(out: &mut [u8], t: &Track<'_>) -> usize {
    let mut en = 0;
    unsafe {
        en += write_uint(TRACK_NUMBER, 1, out.get_unchecked_mut(en..));
        en += write_uint(TRACK_UID, t.uid, out.get_unchecked_mut(en..));
        en += write_uint(TRACK_TYPE, 1, out.get_unchecked_mut(en..)); // video
        en += write_uint(FLAG_ENABLED, 1, out.get_unchecked_mut(en..));
        en += write_uint(FLAG_DEFAULT, 1, out.get_unchecked_mut(en..));
        en += write_uint(FLAG_FORCED, 0, out.get_unchecked_mut(en..));
        en += write_uint(FLAG_LACING, 0, out.get_unchecked_mut(en..));
        en += write_uint(MAX_BLOCK_ADD, 0, out.get_unchecked_mut(en..));
        en += write_bytes(NAME_ID, t.name, out.get_unchecked_mut(en..));
        en += write_bytes(LANG_ID, b"und", out.get_unchecked_mut(en..));
        en += write_uint(
            DEFAULT_DURATION,
            t.default_duration_ns,
            out.get_unchecked_mut(en..),
        );
        en += write_bytes(CODEC_ID, t.codec_id, out.get_unchecked_mut(en..));
        en += write_bytes(CODEC_PRIVATE, t.codec_private, out.get_unchecked_mut(en..));
        en += write_bytes(CODEC_NAME, t.codec_name, out.get_unchecked_mut(en..));
        en += write_video(out.get_unchecked_mut(en..), t);
    }
    en
}

fn audio_body_size(a: &Audio<'_>) -> usize {
    let mut n = uint_elem_size(TRACK_NUMBER, a.number)
        + uint_elem_size(TRACK_UID, a.uid)
        + uint_elem_size(TRACK_TYPE, 2)
        + uint_elem_size(FLAG_ENABLED, 1)
        + uint_elem_size(FLAG_DEFAULT, u64::from(a.default))
        + uint_elem_size(FLAG_FORCED, 0)
        + uint_elem_size(FLAG_LACING, 0)
        + uint_elem_size(MAX_BLOCK_ADD, 0)
        + bytes_elem_size(NAME_ID, a.name.len())
        + bytes_elem_size(LANG_ID, a.lang.len());
    if a.default_duration_ns > 0 {
        n += uint_elem_size(DEFAULT_DURATION, a.default_duration_ns);
    }
    n += bytes_elem_size(CODEC_ID, a.codec_id.len())
        + bytes_elem_size(CODEC_PRIVATE, a.codec_private.len())
        + bytes_elem_size(CODEC_NAME, a.codec_name.len());
    if a.codec_delay_ns > 0 {
        n += uint_elem_size(CODEC_DELAY, a.codec_delay_ns);
    }
    if a.seek_preroll_ns > 0 {
        n += uint_elem_size(SEEK_PREROLL, a.seek_preroll_ns);
    }
    n + master_size(AUDIO_ID, audio_content_size(a))
}

fn audio_body(out: &mut [u8], a: &Audio<'_>) -> usize {
    let mut en = 0;
    unsafe {
        en += write_uint(TRACK_NUMBER, a.number, out.get_unchecked_mut(en..));
        en += write_uint(TRACK_UID, a.uid, out.get_unchecked_mut(en..));
        en += write_uint(TRACK_TYPE, 2, out.get_unchecked_mut(en..)); // audio
        en += write_uint(FLAG_ENABLED, 1, out.get_unchecked_mut(en..));
        en += write_uint(
            FLAG_DEFAULT,
            u64::from(a.default),
            out.get_unchecked_mut(en..),
        );
        en += write_uint(FLAG_FORCED, 0, out.get_unchecked_mut(en..));
        en += write_uint(FLAG_LACING, 0, out.get_unchecked_mut(en..));
        en += write_uint(MAX_BLOCK_ADD, 0, out.get_unchecked_mut(en..));
        en += write_bytes(NAME_ID, a.name, out.get_unchecked_mut(en..));
        en += write_bytes(LANG_ID, a.lang, out.get_unchecked_mut(en..));
        if a.default_duration_ns > 0 {
            en += write_uint(
                DEFAULT_DURATION,
                a.default_duration_ns,
                out.get_unchecked_mut(en..),
            );
        }
        en += write_bytes(CODEC_ID, a.codec_id, out.get_unchecked_mut(en..));
        en += write_bytes(CODEC_PRIVATE, a.codec_private, out.get_unchecked_mut(en..));
        en += write_bytes(CODEC_NAME, a.codec_name, out.get_unchecked_mut(en..));
        if a.codec_delay_ns > 0 {
            en += write_uint(CODEC_DELAY, a.codec_delay_ns, out.get_unchecked_mut(en..));
        }
        if a.seek_preroll_ns > 0 {
            en += write_uint(SEEK_PREROLL, a.seek_preroll_ns, out.get_unchecked_mut(en..));
        }
        en += write_audio(out.get_unchecked_mut(en..), a);
    }
    en
}

fn subtitle_body_size(s: &Subtitle<'_>) -> usize {
    uint_elem_size(TRACK_NUMBER, s.number)
        + uint_elem_size(TRACK_UID, s.uid)
        + uint_elem_size(TRACK_TYPE, 17)
        + uint_elem_size(FLAG_ENABLED, 1)
        + uint_elem_size(FLAG_DEFAULT, u64::from(s.default))
        + uint_elem_size(FLAG_FORCED, 0)
        + uint_elem_size(FLAG_LACING, 0)
        + uint_elem_size(MAX_BLOCK_ADD, 0)
        + bytes_elem_size(NAME_ID, s.name.len())
        + bytes_elem_size(LANG_ID, s.lang.len())
        + bytes_elem_size(CODEC_ID, s.codec_id.len())
        + bytes_elem_size(CODEC_PRIVATE, s.codec_private.len())
        + bytes_elem_size(CODEC_NAME, s.codec_name.len())
}

fn subtitle_body(out: &mut [u8], s: &Subtitle<'_>) -> usize {
    let mut en = 0;
    unsafe {
        en += write_uint(TRACK_NUMBER, s.number, out.get_unchecked_mut(en..));
        en += write_uint(TRACK_UID, s.uid, out.get_unchecked_mut(en..));
        en += write_uint(TRACK_TYPE, 17, out.get_unchecked_mut(en..)); // subtitle
        en += write_uint(FLAG_ENABLED, 1, out.get_unchecked_mut(en..));
        en += write_uint(
            FLAG_DEFAULT,
            u64::from(s.default),
            out.get_unchecked_mut(en..),
        );
        en += write_uint(FLAG_FORCED, 0, out.get_unchecked_mut(en..));
        en += write_uint(FLAG_LACING, 0, out.get_unchecked_mut(en..));
        en += write_uint(MAX_BLOCK_ADD, 0, out.get_unchecked_mut(en..));
        en += write_bytes(NAME_ID, s.name, out.get_unchecked_mut(en..));
        en += write_bytes(LANG_ID, s.lang, out.get_unchecked_mut(en..));
        en += write_bytes(CODEC_ID, s.codec_id, out.get_unchecked_mut(en..));
        en += write_bytes(CODEC_PRIVATE, s.codec_private, out.get_unchecked_mut(en..));
        en += write_bytes(CODEC_NAME, s.codec_name, out.get_unchecked_mut(en..));
    }
    en
}

fn audio_content_size(a: &Audio<'_>) -> usize {
    let mut n = bytes_elem_size(0xB5, 8) + uint_elem_size(0x9F, u64::from(a.channels));
    if let Some(bd) = a.bit_depth {
        n += uint_elem_size(0x6264, u64::from(bd));
    }
    n + uint_elem_size(0x52F1, 0)
}

fn write_audio(out: &mut [u8], a: &Audio<'_>) -> usize {
    let mut n = write_id(AUDIO_ID, out);
    unsafe {
        n += vint_encode(audio_content_size(a) as u64, out.get_unchecked_mut(n..));
        n += write_bytes(
            0xB5,
            &f64::from(a.sample_rate).to_be_bytes(),
            out.get_unchecked_mut(n..),
        ); // SamplingFrequency
        n += write_uint(0x9F, u64::from(a.channels), out.get_unchecked_mut(n..)); // Channels
        if let Some(bd) = a.bit_depth {
            n += write_uint(0x6264, u64::from(bd), out.get_unchecked_mut(n..)); // BitDepth
        }
        n += write_uint(0x52F1, 0, out.get_unchecked_mut(n..)); // Emphasis = no emphasis
    }
    n
}

fn video_content_size(t: &Track<'_>) -> usize {
    uint_elem_size(0x9A, 2)
        + uint_elem_size(0x53C0, 0)
        + uint_elem_size(0xB0, u64::from(t.width))
        + uint_elem_size(0xBA, u64::from(t.height))
        + uint_elem_size(0x54AA, 0)
        + uint_elem_size(0x54BB, 0)
        + uint_elem_size(0x54CC, 0)
        + uint_elem_size(0x54DD, 0)
        + uint_elem_size(0x54B0, {
            let (dw, _) = t.display.unwrap_or((t.width, t.height));
            u64::from(dw)
        })
        + uint_elem_size(0x54BA, {
            let (_, dh) = t.display.unwrap_or((t.width, t.height));
            u64::from(dh)
        })
        + uint_elem_size(0x54B2, 0)
        + master_size(COLOUR_ID, colour_content_size(t.colour))
}

fn write_video(out: &mut [u8], t: &Track<'_>) -> usize {
    let (dw, dh) = t.display.unwrap_or((t.width, t.height));
    let mut n = write_id(VIDEO_ID, out);
    unsafe {
        n += vint_encode(video_content_size(t) as u64, out.get_unchecked_mut(n..));
        n += write_uint(0x9A, 2, out.get_unchecked_mut(n..)); // FlagInterlaced = progressive
        n += write_uint(0x53C0, 0, out.get_unchecked_mut(n..)); // AlphaMode
        n += write_uint(0xB0, u64::from(t.width), out.get_unchecked_mut(n..)); // PixelWidth
        n += write_uint(0xBA, u64::from(t.height), out.get_unchecked_mut(n..)); // PixelHeight
        n += write_uint(0x54AA, 0, out.get_unchecked_mut(n..)); // PixelCropBottom
        n += write_uint(0x54BB, 0, out.get_unchecked_mut(n..)); // PixelCropTop
        n += write_uint(0x54CC, 0, out.get_unchecked_mut(n..)); // PixelCropLeft
        n += write_uint(0x54DD, 0, out.get_unchecked_mut(n..)); // PixelCropRight
        n += write_uint(0x54B0, u64::from(dw), out.get_unchecked_mut(n..)); // DisplayWidth
        n += write_uint(0x54BA, u64::from(dh), out.get_unchecked_mut(n..)); // DisplayHeight
        n += write_uint(0x54B2, 0, out.get_unchecked_mut(n..)); // DisplayUnit = pixels
        n += write_colour(out.get_unchecked_mut(n..), t.colour);
    }
    n
}

fn colour_content_size(c: Colour) -> usize {
    let mut n = uint_elem_size(0x55B1, u64::from(c.matrix))
        + uint_elem_size(0x55B2, 10)
        + uint_elem_size(0x55B3, 1)
        + uint_elem_size(0x55B4, 1)
        + uint_elem_size(0x55B7, u64::from(c.chroma_siting_h))
        + uint_elem_size(0x55B8, u64::from(c.chroma_siting_v))
        + uint_elem_size(0x55B9, u64::from(c.range))
        + uint_elem_size(0x55BA, u64::from(c.transfer))
        + uint_elem_size(0x55BB, u64::from(c.primaries));
    if let Some(cll) = c.content_light {
        n += uint_elem_size(0x55BC, u64::from(cll.0)) + uint_elem_size(0x55BD, u64::from(cll.1));
    }
    if c.mastering.is_some() {
        n += master_size(MASTERING_ID, mastering_content_size());
    }
    n
}

fn write_colour(out: &mut [u8], c: Colour) -> usize {
    let mut n = write_id(COLOUR_ID, out);
    unsafe {
        n += vint_encode(colour_content_size(c) as u64, out.get_unchecked_mut(n..));
        n += write_uint(0x55B1, u64::from(c.matrix), out.get_unchecked_mut(n..));
        n += write_uint(0x55B2, 10, out.get_unchecked_mut(n..)); // BitsPerChannel
        n += write_uint(0x55B3, 1, out.get_unchecked_mut(n..)); // ChromaSubsamplingHorz 4:2:0
        n += write_uint(0x55B4, 1, out.get_unchecked_mut(n..)); // ChromaSubsamplingVert 4:2:0
        n += write_uint(
            0x55B7,
            u64::from(c.chroma_siting_h),
            out.get_unchecked_mut(n..),
        );
        n += write_uint(
            0x55B8,
            u64::from(c.chroma_siting_v),
            out.get_unchecked_mut(n..),
        );
        n += write_uint(0x55B9, u64::from(c.range), out.get_unchecked_mut(n..));
        n += write_uint(0x55BA, u64::from(c.transfer), out.get_unchecked_mut(n..));
        n += write_uint(0x55BB, u64::from(c.primaries), out.get_unchecked_mut(n..));
        if let Some(cll) = c.content_light {
            n += write_uint(0x55BC, u64::from(cll.0), out.get_unchecked_mut(n..)); // MaxCLL
            n += write_uint(0x55BD, u64::from(cll.1), out.get_unchecked_mut(n..)); // MaxFALL
        }
        if let Some(m) = c.mastering {
            n += write_mastering(out.get_unchecked_mut(n..), &m);
        }
    }
    n
}

// 10 × f64 elements, ids 0x55D1..=0x55DA, 11 octets each
const fn mastering_content_size() -> usize {
    10 * bytes_elem_size(0x55D1, 8)
}

fn write_mastering(out: &mut [u8], m: &Mastering) -> usize {
    let mut n = write_id(MASTERING_ID, out);
    unsafe {
        n += vint_encode(mastering_content_size() as u64, out.get_unchecked_mut(n..));
        n += write_bytes(0x55D1, &m.r.0.to_be_bytes(), out.get_unchecked_mut(n..)); // PrimaryRChromaticityX
        n += write_bytes(0x55D2, &m.r.1.to_be_bytes(), out.get_unchecked_mut(n..));
        n += write_bytes(0x55D3, &m.g.0.to_be_bytes(), out.get_unchecked_mut(n..)); // PrimaryG
        n += write_bytes(0x55D4, &m.g.1.to_be_bytes(), out.get_unchecked_mut(n..));
        n += write_bytes(0x55D5, &m.b.0.to_be_bytes(), out.get_unchecked_mut(n..)); // PrimaryB
        n += write_bytes(0x55D6, &m.b.1.to_be_bytes(), out.get_unchecked_mut(n..));
        n += write_bytes(0x55D7, &m.wp.0.to_be_bytes(), out.get_unchecked_mut(n..)); // WhitePoint
        n += write_bytes(0x55D8, &m.wp.1.to_be_bytes(), out.get_unchecked_mut(n..));
        n += write_bytes(0x55D9, &m.lum_max.to_be_bytes(), out.get_unchecked_mut(n..)); // LuminanceMax
        n += write_bytes(0x55DA, &m.lum_min.to_be_bytes(), out.get_unchecked_mut(n..)); // LuminanceMin
    }
    n
}
