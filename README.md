## Desc
- **TLDR:** Brutally hardcore & obsessive; excessively-optimized
- CLI util to crop, scene-detect, demux, parse, decode, pixel proc, encode, metric-test, mux; with optional quality metric target
- Lowest (V)RAM
- Automated & Biased
- **NO** `VapourSynth`/`FFmpeg` or cli call

## Feats
- Fastest chunk encode
- Target quality with best metrics: [CVVDP](https://achapiro.github.io/Man24/man24.pdf) & [Butteraugli](https://github.com/google/butteraugli) & [SSIMU2](https://github.com/cloudinary/ssimulacra2)
- Fastest scene-detect
- CPU/GPU decode
- Parse input data
- Instant and multi-AR-safe autocrop
- Opus encode with auto rate calc, stereo mix and loud-norm ([AC-4 std](https://www.etsi.org/deliver/etsi_ts/103100_103199/10319001/01.03.01_60/ts_10319001v010301p.pdf))
- Progs monitor: Encode / metric / mux
- Output summary & TQ JSON logs
- Stop/Resume
- Trim/splice
- Custom, modern, compliant `mkv` mux
- `AV*` - `H26*` codec
- **Pipe**: `cmd - | xav i.mkv ...` : **Slower** than native
- Zones

## How
```
./build.sh
```
