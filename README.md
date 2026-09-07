# xav with enhanced Target Quality capabilities

This is a **WIP** fork of the [xav tool for video encoding](https://github.com/emrakyz/xav) with additional features related to Target Quality (TQ) encoding. Meant for patient users who might obsess a bit too much over objective quality metric scores and final file sizes.

The planned features are the following:
- [x] Add a new TQ mode `min`, that targets the minimum quality score achieved per scene (i.e., the quality of the worst-looking frame).
- [x] Allow multiple TQ targets at the same time (`-t` and `-m` parameters). All of them have to be met (if possible with the specified CRF range). The user is responsible of specifying compatible targets. Example use case: "target an average SSIMULACRA2 score of 80, and, at the same time, with 95% of frames above 70".
  - [x] Initial implementation (proof of concept).
  - [x] Debug + optimize multi-TQ computation / make production ready.
  - [x] Add support for logging multi-TQ encodes. (Sort of: properly integrating the multi-TQ system with the probes system requires many careful considerations, and I consider I do not have yet the necessary knowledge to do it myself).
  - [ ] Update guide with multi-TQ usage documentation.
- [x] Allow not specifying the higher end of TQ ranges, which will be interpreted as the maximum quality score achievable.
  - Currently not supported for butteraugli, as the higher the score, the lower the quality (the higher the distortion), and that is misleading with this mode.
- [x] Allow setting a "default" or "initial" CRF value, instead of using the midpoint in the specified range. Useful if you want to stay closer to one of the extremes not to overuse/underuse bitrate, but also want to allow deviating from the usual CRF values significantly in tricky scenes that cannot reach the target quality near them. Example use case: "allow CRFs ranging from 20 to 40, but stay near 35 as much as possible".
  - [ ] Update guide with initial CRF usage documentation.
- [x] Make mutli-TQ a compilation feature instead of forcing it to all the users.
- [x] Add feature to output final metric scores to a specific JSON file and a summary to stdout, saving an additional execution of VSHip, or additional postprocessing of log files.
  - [ ] Maybe make it toggeable with an argument? (Currently always shown when using TQ).

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
