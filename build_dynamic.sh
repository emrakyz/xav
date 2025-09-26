#!/bin/sh

cp -f ".cargo/config.toml.dynamic" ".cargo/config.toml"

cargo build --release
