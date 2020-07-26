#!/bin/bash

# Install wasi-libc into clang
CLANG_PATH=/usr/local/Cellar/llvm/10.0.0_3/lib/clang/10.0.0/lib/
wget -P /tmp/ https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-11/wasi-sdk-11-macos.tar.gz
tar xvf /tmp/wasi-sdk-11-macos.tar.gz

mkdir ${CLANG_PATH}/wasi
mv /tmp/wasi-sdk-11-macos/lib/clang/10.0.0/lib/wasi/libclang_rt.builtins-wasm32.a ${CLANG_PATH}/wasi
rm -rf /tmp/wasi-sdk-11-macos /tmp/wasi-sdk-11-macos.tar.gz

# Install wasmtime
curl https://wasmtime.dev/install.sh -sSf | bash
