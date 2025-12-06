## Table of Contents

1. [Description](#description)
2. [Dependencies](#dependencies)
3. [Building](#building)

## Description
- A totally broken, completely experimental and research-only video encoding framework with a user-last design
- **DO NOT USE** if you don't know what you are doing and are not extremely experienced in video encoding and its frameworks or if you have production goals
- The tool is extremely opinionated and strict that this will likely not change
- Backward compatibility is completely ignored. Anything can break/removed/modified with updates
- I may conflict with my reasoning in the future. I am not entitled with anything or anyone and I have no obligation to continue with my initial reasoning or design goals I declared. Anything can change and you shouldn't care
- Building is extremely complicated. If you have 0 experience in software compilation, simply skip
- Linux only: You are on your own otherwise. I do not care and handle any specific cases for compilation or runtime
- It uses **MUCH MORE** RAM, VRAM than other similar tools and is **SLOWER**

For normal use; use better, safer, stable, not opinionated, feature-rich and professional tools:
- [Av1an](https://github.com/rust-av/Av1an)
- [HandBrake](https://handbrake.fr)
- [StaxRip](https://github.com/staxrip/staxrip)
- [nmkoder](https://github.com/n00mkrad/nmkoder)
- [alabamaEncoder](https://github.com/kingstefan26/alabamaEncoder)
- [ab-av1](https://github.com/alexheretic/ab-av1)
- [aviator](https://github.com/gianni-rosato/aviator)

## Dependencies

- [SVT-AV1](https://gitlab.com/AOMediaCodec/SVT-AV1)
- [mkvmerge](https://mkvtoolnix.download/source.html)
- [FFMS2](https://github.com/FFMS/ffms2)
- [VSHIP](https://github.com/Line-fr/Vship) (optional)
- Rust Nightly, NASM, Clang (build-time)

## Building

Build script is only for Linux. You are on your own otherwise

Run the `build.sh` script: Select static or dynamic build

Building statically requires you to have static libraries: glibc, libstdc++, llvm-libunwind, compiler-rt
