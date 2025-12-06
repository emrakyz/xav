## Table of Contents

1. [Description](#description)
2. [Dependencies](#dependencies)
3. [Usage](#usage)
4. [Building](#building)
5. [Credits](#credits)

## Description
A totally broken, completely experimental and research-only video encoding framework specifically for power users and highest degree encoding enthusiasts.
**DO NOT USE** if you don't know what you are doing and are not extremely experienced in video encoding and its frameworks or if you have production goals.

The tool is extremely opinionated and strict and this will likely not change.
Backwards compatibility is ignored. Anything can break/removed/modified with updates.

I may possibly conflict with my reasonings in the future. I am not entitled with anything. And I have no obligations to continue with my initial reasoning or design goals I declared. Anything can change and you shouldn't care.

Building this tool is extremely complicated. Support should not be expected and releases will not be provided anytime soon. If you are not experienced in software compilation with cross-language dependencies, simply skip.

Intended for Linux-only usage. It technically works on other platforms but I do not care and handle any specific cases for compilation or runtime.

It uses much more RAM/VRAM than other similar tools and is possibly slower.

For normal use; use better, safer, more stable, less opinionated, more featureful and professional tools:
- [Av1an](https://github.com/rust-av/Av1an)
- [HandBrake](https://handbrake.fr)
- [StaxRip](https://github.com/staxrip/staxrip)
- [nmkoder](https://github.com/n00mkrad/nmkoder)
- [alabamaEncoder](https://github.com/kingstefan26/alabamaEncoder)
- [ab-av1](https://github.com/alexheretic/ab-av1)
- [aviator](https://github.com/gianni-rosato/aviator)

## Dependencies

- [SVT-AV1](https://gitlab.com/AOMediaCodec/SVT-AV1) (mainline or a fork)
- [mkvmerge](https://mkvtoolnix.download/source.html) (to concatenate chunks)
- [FFMS2](https://github.com/FFMS/ffms2) (a hard dependency for decoding)
- [VSHIP](https://github.com/Line-fr/Vship) (optional - needed for target quality encoding)
- Rust Nightly, NASM, Clang (building dependencies)

## Usage

Refer to the help page.

## Building

Build script is only for Linux. You are on your own otherwise.

Run the `build.sh` script: Select static or dynamic build.

Building statically requires you to have static libraries: glibc, libstdc++, llvm-libunwind, compiler-rt.

## Credits

Thanks to [Soda](https://github.com/GreatValueCreamSoda) for the help & motivation & support to build this tool, and more importantly, for his friendship along the way.

Thanks [Lumen](https://github.com/Line-fr) for her contributions on GPU based state-of-the-art metric implementations and help around the tooling.
