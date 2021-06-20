#/bin/bash

# Install Rust.
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Check each rust programs version.
cargo --version
rustc --version
rustdoc --version
rustup --version

# Install lsp for Rust.
rustup component add rust-analysis rust-src

if [ "$(uname)" == 'Darwin' ]; then # For Arm MacOS
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-aarch64-apple-darwin.gz | gunzip -c - > ~/.cargo/bin/rust-analyzer
    chmod +x ~/.cargo/bin/rust-analyzer
else # For Linux
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
    chmod +x ~/.local/bin/rust-analyzer
fi
