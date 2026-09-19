use core::{
    ffi::{c_char, c_int},
    hint::cold_path,
    slice::from_raw_parts,
    str::from_utf8_unchecked,
};

use crate::error::{eprint, fatal};

type ParseFn = unsafe extern "C" fn(*mut u8, *const c_char, *const c_char) -> c_int;

// x26x logs here; no line inside progs frame
#[cold]
#[inline(never)]
pub fn log(msg: *const c_char, len: usize) {
    eprint(format_args!(
        "{}",
        text(unsafe { from_raw_parts(msg.cast::<u8>(), len) }).trim_end()
    ));
}

pub fn nul(b: &[u8]) -> usize {
    unsafe { b.iter().position(|&c| c == 0).unwrap_unchecked() }
}

pub const fn text(b: &[u8]) -> &str {
    unsafe { from_utf8_unchecked(b) }
}

#[cold]
#[inline(never)]
pub fn parse_pairs(dst: *mut u8, arenas: [&[u8]; 2], parse: ParseFn, enc: &str) {
    for mut p in arenas {
        while !p.is_empty() {
            let n = nul(p);
            let (name, rest) = unsafe { (p.get_unchecked(..n), p.get_unchecked(n + 1..)) };
            let m = nul(rest);
            let val = unsafe { rest.get_unchecked(..m) };
            if unsafe { parse(dst, name.as_ptr().cast(), val.as_ptr().cast()) } != 0 {
                cold_path();
                fatal(format_args!(
                    "{enc}: rejected --{} {}",
                    text(name),
                    text(val)
                ));
            }
            p = unsafe { rest.get_unchecked(m + 1..) };
        }
    }
}
