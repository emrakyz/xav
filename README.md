## Description
- **TLDR:** Brutally hardcore & obsessive; excessively-optimized
- XAV is a CLI tool to scene-detect, crop, demux, parse, decode, pixel proc, encode, metric-test, mux,; and a pipeline for chunk encode, with optional quality metric target
- Lowest RAM & VRAM
- Fully automate & be opinionated
- **NO** `VapourSynth`/`FFmpeg` or any external calls

## Features
- Fastest chunk encode
- Target quality with best metrics: [CVVDP](https://achapiro.github.io/Man24/man24.pdf) & [Butteraugli](https://github.com/google/butteraugli) & [SSIMU2](https://github.com/cloudinary/ssimulacra2)
- Fastest, best scene-detect
- CPU/GPU decode
- Parse full input metadata
- Instant and multi-AR-safe autocrop
- Opus encode with auto bitrate calc, stereo downmix and loud norm ([AC-4 std](https://www.etsi.org/deliver/etsi_ts/103100_103199/10319001/01.03.01_60/ts_10319001v010301p.pdf))
- Progs monitor: Encode / metric / mux
- Output summary & TQ JSON logs
- Stop/Resume
- Trim/splice
- Custom, modernized, fully-compliant MKV mux
- `AV*` - `H26*` encode
- **Pipe**: `cmd - | xav i.mkv ...` : **Slower** than the native pipeline
- Zoning

## Build
```
./build.sh
```
