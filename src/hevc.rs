use core::{
    ffi::{c_int, c_void},
    hint::cold_path,
    ptr::{null, null_mut},
};

use crate::{
    Xerr,
    error::fatal,
    ffms::{
        AV_CODEC_ID_HEVC, AVPacket, VidFrame, av_frame_alloc, av_frame_free, av_packet_alloc,
        av_packet_free, avcodec_alloc_context3, avcodec_find_decoder_by_name,
        avcodec_flush_buffers, avcodec_free_context, avcodec_open2, avcodec_receive_frame,
        avcodec_send_packet, set_thread_cnt,
    },
};

const AVERROR_EAGAIN: c_int = -11;

// AV_INPUT_BUFFER_PADDING_SIZE: read past an au
pub const PAD: usize = 64;

unsafe extern "C" {
    fn av_parser_init(codec_id: c_int) -> *mut c_void;
    fn av_parser_close(s: *mut c_void);

    fn av_parser_parse2(
        s: *mut c_void,
        avctx: *mut c_void,
        poutbuf: *mut *mut u8,
        poutbuf_size: *mut c_int,
        buf: *const u8,
        buf_size: c_int,
        pts: i64,
        dts: i64,
        pos: i64,
    ) -> c_int;
}

pub struct HevcDec {
    codec_ctx: *mut c_void,
    parser: *mut c_void,
    pkt: *mut AVPacket,
    frame: *mut VidFrame,
    buf: *const u8,
    len: usize,
    pos: usize,
    parsed: bool,
    flushed: bool,
}

impl HevcDec {
    pub fn new(threads: i32) -> Result<Self, Xerr> {
        unsafe {
            let dec = avcodec_find_decoder_by_name(c"hevc".as_ptr());
            if dec.is_null() {
                return Err("hevc: decoder missing".into());
            }
            let mut codec_ctx = avcodec_alloc_context3(dec);
            if codec_ctx.is_null() {
                return Err("hevc: alloc codec failed".into());
            }
            set_thread_cnt(codec_ctx, threads);
            if avcodec_open2(codec_ctx, dec, null_mut()) < 0 {
                avcodec_free_context(&raw mut codec_ctx);
                return Err("hevc: codec open failed".into());
            }
            let parser = av_parser_init(AV_CODEC_ID_HEVC);
            if parser.is_null() {
                avcodec_free_context(&raw mut codec_ctx);
                return Err("hevc: parser missing".into());
            }
            Ok(Self {
                codec_ctx,
                parser,
                pkt: av_packet_alloc(),
                frame: av_frame_alloc(),
                buf: null(),
                len: 0,
                pos: 0,
                parsed: false,
                flushed: false,
            })
        }
    }

    // guaranteed PAD zero byte past annexb; aus read inplace
    pub fn load(&mut self, annexb: &[u8]) {
        unsafe { avcodec_flush_buffers(self.codec_ctx) };
        // no reset; last au needs 0-length call; sets `parsed` first
        self.buf = annexb.as_ptr();
        self.len = annexb.len();
        self.pos = 0;
        self.parsed = false;
        self.flushed = false;
    }

    fn feed(&mut self) -> bool {
        while !self.parsed {
            let mut out: *mut u8 = null_mut();
            let mut out_sz: c_int = 0;
            let left = self.len - self.pos;
            let used = unsafe {
                av_parser_parse2(
                    self.parser,
                    self.codec_ctx,
                    &raw mut out,
                    &raw mut out_sz,
                    self.buf.add(self.pos),
                    left as c_int,
                    0,
                    0,
                    0,
                )
            };
            self.pos += used as usize;
            // 0-length is EOS; emits last au
            self.parsed = left == 0;
            if out_sz > 0 {
                unsafe {
                    (*self.pkt).data = out;
                    (*self.pkt).size = out_sz;
                    avcodec_send_packet(self.codec_ctx, self.pkt);
                }
                return true;
            }
        }
        if self.flushed {
            return false;
        }
        self.flushed = true;
        unsafe { avcodec_send_packet(self.codec_ctx, null()) };
        true
    }

    pub fn dec_next(&mut self) -> ([*const u8; 3], [i64; 3]) {
        loop {
            let ret = unsafe { avcodec_receive_frame(self.codec_ctx, self.frame) };
            if ret == 0 {
                let f = unsafe { &*self.frame };
                return (
                    [
                        f.data[0].cast_const(),
                        f.data[1].cast_const(),
                        f.data[2].cast_const(),
                    ],
                    [
                        i64::from(f.linesize[0]),
                        i64::from(f.linesize[1]),
                        i64::from(f.linesize[2]),
                    ],
                );
            }
            cold_path();
            if ret != AVERROR_EAGAIN {
                fatal(format_args!("hevc: decode error {ret}"));
            }
            if !self.feed() {
                fatal("hevc: probe truncated");
            }
        }
    }
}

unsafe impl Send for HevcDec {}

impl Drop for HevcDec {
    fn drop(&mut self) {
        unsafe {
            av_frame_free(&raw mut self.frame);
            av_packet_free(&raw mut self.pkt);
            av_parser_close(self.parser);
            avcodec_free_context(&raw mut self.codec_ctx);
        }
    }
}
