## Table of Contents

1. [Description](#description)
2. [Features](#features)
3. [Dependencies](#dependencies)
4. [Build](#build)
5. [Guide](#guide)

## Description
- XAV is a command-line tool full of micro-optimizations and automations for scene change detection, cropping, decoding, encoding, metric testing, and memory flows and the complete pipeline required for efficient chunked video encoding, with the option of quality metric testing/targeting
- Aims for the lowest RAM and VRAM usage with the fastest possible operation.
- Designed for a more automated & opinionated approach for ease of use; using shorter commands on the command line and memorizing less flags/parameters
- Implements and optimizes its own internals without relying on VapourSynth and/or FFmpeg or any other external calls

## Features
- Fastest and most efficient chunked video encoding (now optionally with even faster library interface)
- Fastest and most efficient target quality encoding with state-of-the-art metrics such as [CVVDP](https://achapiro.github.io/Man24/man24.pdf) and Butteraugli 5p-norm & SSIMULACRA2 from JPEG XL (Google/Cloudinary)
- Very fast, state-of-the-art scene change detection with pre-configured sane defaults. Optionally, other SCD methods such as TransNetv2 can be used externally
- Automated color & HDR metadata and frame/container metadata parsing
- Fully automated, very fast and safe cropping, by also accounting for multi AR videos
- Optional FGS tables (photon noise)
- Convenient optional Opus audio encoding: With optional automated bitrate calculation, stereo downmixing and loudness normalization based on AC-4 standards: [ETSI TS 103 190-1, Section 6.2.17](https://www.etsi.org/deliver/etsi_ts/103100_103199/10319001/01.03.01_60/ts_10319001v010301p.pdf)
- Detailed progress monitoring for encoders and quality metric testing
- Detailed video output summary, TQ output summary and TQ related JSON log file
- Always resumes where you left off for safety
- Native trim and splice support
- **Piping:** You can pipe any command that produces frames: `command - | xav ...` **NOTE:** This is of course slower than the native, highly optimized pipeline but it can be preferable in some workflows
- Complex flags/parameters are abstracted for convenience. The user can still override them. `xav` builds the encoder command and lets the user only deal with parameters that actually matter such as the `preset`
- **Zoning:** Parameters can be added next to keyframe positions in the scenes file to encode different scenes with different parameters

## Dependencies
**Build Time:**
- Rust Nightly, NASM, Clang, lld, compiler-rt,

**Runtime:**
- One encoder binary (or SVT-AV1 library): [SVT-AV1](https://gitlab.com/AOMediaCodec/SVT-AV1) | [AVM](https://gitlab.com/AOMediaCodec/avm) | [VVENC](https://github.com/fraunhoferhhi/vvenc) | [X265](https://bitbucket.org/multicoreware/x265_git/wiki/Home) | [X264](https://www.videolan.org/developers/x264.html)
- [FFMS2](https://github.com/FFMS/ffms2) (used to access decoders and provides frame accuracy)

**Runtime (Optional):**
- [VSHIP](https://codeberg.org/Line-fr/Vship) (for GPU based target quality encoding)
- [MP4Box](https://gpac.io/downloads/gpac-nightly-builds) (the only reliable muxer for `VVC` and it's also used as the first option for concatting x264/x265 videos before the final mux)
- [mkvmerge](https://mkvtoolnix.download) (used as a secondary option for concatting x264/x265 videos if `MP4Box` is not present)

## Build

Run the `build.sh` script: Select static or dynamic build

Building everything statically with the script requires you to have static libraries for: `glibc`, `libstdc++`, `llvm-libunwind`, `compiler-rt`

## Guide
- Refer to `user_doc.pdf` (work in progress)
