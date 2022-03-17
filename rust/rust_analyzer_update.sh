#!/bin/bash

if [ "$(uname)" == 'Darwin' ]; then # For Arm MacOS
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-aarch64-apple-darwin.gz | gunzip -c - > ~/.cargo/bin/rust-analyzer
else # For Linux
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.cargo/bin/rust-analyzer
fi

chmod +x ~/.cargo/bin/rust-analyzer
