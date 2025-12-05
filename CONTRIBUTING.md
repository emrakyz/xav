# Clippy and Test Requirements

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

cargo test --verbose -- --include-ignored --nocapture
```

Should pass with no warnings / errors on the current Rust Nightly.

And the compilation should be successful using the default flags defined in `.cargo/config.toml`

# Currently Out-of-Scope Features

- Almost everything
