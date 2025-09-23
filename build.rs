use std::env;

fn main() {
    let home = env::var("HOME").expect("HOME environment variable not set");

    println!("cargo:rustc-link-search=native={}/.local/src/ffms2/src/core/.libs", home);
    println!("cargo:rustc-link-search=native={}/.local/src/FFmpeg/lib", home);

    unsafe {
        env::set_var("PKG_CONFIG_ALL_STATIC", "1");
        env::set_var("FFMPEG_DIR", format!("{}/.local/src/FFmpeg", home));
    }

    println!("cargo:rustc-link-lib=static=ffms2");
    println!("cargo:rustc-link-lib=static=zimg");
    println!("cargo:rustc-link-lib=static=swscale");
    println!("cargo:rustc-link-lib=static=avformat");
    println!("cargo:rustc-link-lib=static=avcodec");
    println!("cargo:rustc-link-lib=static=avutil");

    println!("cargo:rustc-link-lib=static=c++");
    println!("cargo:rustc-link-lib=static=c++abi");
    println!("cargo:rustc-link-lib=static=unwind");

    println!("cargo:rustc-link-lib=static=z");
}
