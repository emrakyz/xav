## Description
- **TLDR:** Nothing but brutally hardcore; obsessive amounts of excessive optimizations
- XAV is a CLI tool to scene change detect, crop, demux, parse, decode, pixel/frame process, encode, metric-test, mux, handle-memory; and a pipeline required for efficient chunked encoding, with optional quality metric targeting
- Lowest RAM & VRAM
- Fully automate being opinionated
- Optimize internals **without** `VapourSynth`/`FFmpeg` or any syscalls

## Features
- Fastest chunked encoding
- Target quality with state-of-the-art metrics: [CVVDP](https://achapiro.github.io/Man24/man24.pdf) & [Butteraugli](https://github.com/google/butteraugli) & [SSIMU2](https://github.com/cloudinary/ssimulacra2)
- Fastest, state-of-the-art scene change detection
- CPU/GPU decode
- Color/HDR metadata & frame/container metadata parse
- Instant and multi-AR-safe autocrop
- Opus encode with auto bitrate calc, stereo downmix and loud norm (AC-4 std): [ETSI TS 103 190-1, Section 6.2.17](https://www.etsi.org/deliver/etsi_ts/103100_103199/10319001/01.03.01_60/ts_10319001v010301p.pdf)
- Progs monitor: Encode / metric / mux
- Output summary & TQ JSON logs
- Resumable encodes
- Trim & splice
- Custom, modernized, fully-compliant MKV muxing
- `AV*` - `H26*` encode
- Frames can be **piped**: `cmd - | xav i.mkv ...` : **Slower** than the native pipeline
- Encode each scene with different params (zone)

## Build
```
./build.sh
```
