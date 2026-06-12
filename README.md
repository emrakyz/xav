## Desc
- **TLDR:** Brutally hardcore & passionate & obsessive; excessively-optimized
- A complete framework
- Lowest (V)RAM
- Auto & Biased
- **NO** system-side dependency
- **NO** `VapourSynth`/`FFmpeg`/CLI call

## Feats
- Zones
- Stop/Resume
- Trim/splice
- Scene-detect
- Chunk encode
- Custom muxer
- CPU/GPU decode
- Parse input data
- `AV*` - `H26*` codec
- Output summary & TQ JSON logs
- Instant and multi-AR-safe autocrop
- **Pipe**: `cmd - | xav i.mkv`: **Slower** than native
- Target quality metrics: [CVVDP](https://achapiro.github.io/Man24/man24.pdf) & [Butteraugli](https://github.com/google/butteraugli) & [SSIMU2](https://github.com/cloudinary/ssimulacra2)
- Opus encode with auto rate calc, stereo mix and loud-norm ([AC-4 std](https://www.etsi.org/deliver/etsi_ts/103100_103199/10319001/01.03.01_60/ts_10319001v010301p.pdf))

## How
```
./build.sh
xav -h guide
```
