#!/bin/bash

WASM_INSTALL_PATH=$HOME/wasm
mkdir -p WASM_INSTALL_PATH
cd ${WASM_INSTALL_PATH}

# Install wasi-libc into clang
CLANG_PATH=/usr/local/Cellar/llvm/10.0.0_3/lib/clang/10.0.0/lib/
wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-11/wasi-sdk-11-macos.tar.gz
tar xvf wasi-sdk-11-macos.tar.gz

mkdir -p ${CLANG_PATH}/wasi
mv wasi-sdk-11-macos/lib/clang/10.0.0/lib/wasi/libclang_rt.builtins-wasm32.a ${CLANG_PATH}/wasi
rm wasi-sdk-11-macos.tar.gz

# Install wasmtime
curl https://wasmtime.dev/install.sh -sSf | bash

# Install wabt
git clone --recursive https://github.com/WebAssembly/wabt; cd wabt
mkdir build; cd build
cmake ..
make -j 8

# Install emscripten
# ref: https://emscripten.org/docs/getting_started/downloads.html
git clone https://github.com/emscripten-core/emsdk.git; cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
