## Description
- **TLDR:** Nothing but brutally hardcore; obsessive amounts of excessive optimizations
- XAV is a command-line tool all of micro-optimizations and automations for scene change detection, cropping, demuxing, parsing, decoding, pixel/frame processing, encoding, metric testing, muxing, memory flows and the complete pipeline required for efficient chunked video encoding, with the option of quality metric testing/targeting
- Lowest RAM and VRAM usage
- Designed for full automation being opinionated
- Optimizes internals **without** relying on `VapourSynth` and/or `FFmpeg` or any external calls

## Features
- Fastest chunked video & audio encoding
- Target quality encoding with state-of-the-art metrics such as [CVVDP](https://achapiro.github.io/Man24/man24.pdf) and [Butteraugli](https://github.com/google/butteraugli) & [SSIMU2](https://github.com/cloudinary/ssimulacra2)
- Fastest, state-of-the-art scene change detection. Other SCD as [TransNetv2](https://github.com/soCzech/TransNetV2) can be used too
- CPU or GPU decode
- Auto color & HDR metadata and frame/container metadata parsing
- Auto, instant and multi-AR safe crop
- Opus audio encode with automated bitrate calc, stereo downmix and loudness normalization (AC-4 standards): [ETSI TS 103 190-1, Section 6.2.17](https://www.etsi.org/deliver/etsi_ts/103100_103199/10319001/01.03.01_60/ts_10319001v010301p.pdf)
- Progs monitor for encoders and metric testing
- Video output summary and JSON logs for TQ
- Resumes for safety if left unfinished
- Native trim & splice
- Custom, modernized, fully-compliant MKV muxing
- `AV*` - `H26*` encoding support
- Commands that send frames can be **piped**: `command - | xav i.mkv ...` **NOTE:** Slower than the native pipeline
- **Zoning:** Add flags next to keyframes in the scene file to encode each scene with different params

## Build
```
./build.sh
```
