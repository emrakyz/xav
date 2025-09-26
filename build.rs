use std::{env, fs};

fn main() {
    if cfg!(feature = "static") {
        let home = env::var("HOME").expect("HOME environment variable not set");

        println!("cargo:rustc-link-search=native={home}/.local/src/ffms2/src/core/.libs");
        println!("cargo:rustc-link-search=native={home}/.local/src/FFmpeg/install/lib");
        println!("cargo:rustc-link-search=native={home}/.local/src/dav1d/build/src");
        println!("cargo:rustc-link-search=native={home}/.local/src/zlib/install/lib");

        println!("cargo:rustc-link-lib=static=ffms2");
        println!("cargo:rustc-link-lib=static=swscale");
        println!("cargo:rustc-link-lib=static=avformat");
        println!("cargo:rustc-link-lib=static=avcodec");
        println!("cargo:rustc-link-lib=static=avutil");
        println!("cargo:rustc-link-lib=static=dav1d");
        println!("cargo:rustc-link-lib=static=z");

        let cxx_lib = if fs::read_to_string(".libcxx").unwrap_or_default().trim() == "libc++" {
            "c++"
        } else {
            "stdc++"
        };
        println!("cargo:rustc-link-lib=static={cxx_lib}");
    }
}
