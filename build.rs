use std::env;

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
        println!("cargo:rustc-link-lib=static=stdc++");

        #[cfg(feature = "vship")]
        {
            println!("cargo:rustc-link-search=native={home}/.local/src/Vship");

            println!("cargo:rustc-link-lib=static=vship");

            println!("cargo:rustc-link-lib=static=cudart_static");
            println!("cargo:rustc-link-search=native=/opt/cuda/lib64");

            println!("cargo:rustc-link-lib=dylib=cuda");
        }
    }
}
