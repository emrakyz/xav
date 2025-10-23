# What Type of Improvements Needed
Improvements are welcome if:
- The code size gets meaningfully reduced.
- Any inefficiency related to encoding gets identified and fixed/improved.
- Otherwise feature additions are currently out-of-scope.

# Clippy Requirements

```
cargo fmt --all

cargo clippy --all-targets --all-features -- \
  -D warnings \
  -W clippy::pedantic \
  -W clippy::nursery \
  -W clippy::cargo \
  -W clippy::correctness \
  -A clippy::many_single_char_names \
  -A clippy::cast_possible_truncation \
  -A clippy::cast-sign-loss
```

Should pass with no warnings / errors on the current Rust Nightly.

And the compilation should be successful using the default flags defined in `.cargo/config.toml`

# Currently Out-of-Scope Features

- Filtering
- Encoders other than `svt-av1`, except if any usable `AV2` encoder is ready
- Resolution scaling
- Chroma subsampling or YUV422, YUV444 (input or output) support
- Zoning
