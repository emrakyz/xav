# xav with enhanced Target Quality capabilities

This is a **WIP** fork of the [xav tool for video encoding](https://github.com/emrakyz/xav) with additional features related to Target Quality (TQ) encoding. Meant for patient users who might obsess a bit too much over objective quality metric scores and final file sizes.

The planned features are the following:
- [x] Add a new TQ mode `min`, that targets the minimum quality score achieved per scene (i.e., the quality of the worst-looking frame).
- [ ] Allow multiple TQ targets at the same time (`-t` and `-m` parameters). All of them have to be met (if possible with the specified CRF range). The user is responsible of specifying compatible targets. Example use case: "target an average SSIMULACRA2 score of 80, and, at the same time, with 95% of frames above 70".
  - [x] Initial implementation (proof of concept).
  - [ ] Debug + optimize multi-TQ computation / make production ready.
  - [ ] Add support for reporting status, logging, and resuming multi-TQ encodes.
  - [ ] Update guide with multi-TQ usage documentation.
- [ ] Allow not specifying the higher end of TQ ranges, which will be interpreted as the maximum quality score achievable.
- [ ] Allow setting a "default" or "initial" CRF value, instead of using the midpoint in the specified range. Useful if you want to stay closer to one of the extremes not to overuse/underuse bitrate, but also want to allow deviating from the usual CRF values significantly in tricky scenes that cannot reach the target quality near them. Example use case: "allow CRFs ranging from 20 to 40, but stay near 35 as much as possible".

# Original README

## Desc
- Brutally hardcore; obsessive; excessively-optimized
- A complete framework
- Lowest (V)RAM
- Auto & Biased
- **NO** crates/libs & stdlib
- **NO** system-side dependency
- **NO** `VapourSynth`/`FFmpeg`/CLI call

## Feats
- Zones
- Trim/splice
- Scene-detect
- Stop/Resume
- Chunk encode
- Custom muxer
- Parse input data
- CPU/GPU decode
- `AV*` - `H26*` codec
- Multi-AR-safe autocrop
- **Pipe**: `cmd - | xav i.mkv`: **Slower** than native
- Target quality: [CVVDP](https://achapiro.github.io/Man24/man24.pdf) & [Butteraugli](https://github.com/google/butteraugli) & [SSIMU2](https://github.com/cloudinary/ssimulacra2)
- Opus with auto rate calc & downmix & loud-norm ([AC-4 std](https://www.etsi.org/deliver/etsi_ts/103100_103199/10319001/01.03.01_60/ts_10319001v010301p.pdf))

## How
```
./build.sh
xav -h
```
