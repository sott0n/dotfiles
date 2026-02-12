{
  description = "tt-mlir development environment (FHS compatible)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # FHS environment for tt-mlir development
        fhsEnv = pkgs.buildFHSUserEnv {
          name = "tt-mlir-dev";

          targetPkgs = pkgs: with pkgs; [
            # Build tools
            gcc12
            gnumake
            cmake
            ninja
            ccache
            pkg-config
            binutils
            patchelf

            # Clang/LLVM
            llvmPackages_17.clang
            llvmPackages_17.llvm
            llvmPackages_17.lld
            clang-tools

            # Version control
            git
            git-lfs

            # Libraries
            gmp
            libmpc
            mpfr
            numactl
            numactl.dev
            hwloc
            hwloc.dev
            tbb_2021_11
            capstone
            yaml-cpp
            boost
            zlib
            ncurses
            libxml2
            libffi
            libevent

            # Protobuf and dependencies (tt-xla)
            protobuf
            abseil-cpp
            gtest

            # C++ standard library for Clang
            llvmPackages_17.libcxx

            # Documentation
            pandoc
            doxygen
            graphviz

            # Python 3.11
            python311
            python311Packages.pip
            python311Packages.virtualenv
            python311Packages.setuptools
            python311Packages.pybind11

            # Utilities
            gnupatch
            wget
            curl
            jq
            lcov
            zstd
            unzip
            which
            file
            coreutils
            bash

            # tt-xla specific
            ffmpeg      # For Whisper/Wav2Vec2 models
            unixtools.xxd
          ];

          multiPkgs = pkgs: with pkgs; [
            zlib
            glibc
          ];

          profile = ''
            export NIX_SHELL_NAME="tt-mlir-dev"
            export TTMLIR_TOOLCHAIN_DIR=''${TTMLIR_TOOLCHAIN_DIR:-$HOME/.ttmlir-toolchain}
            mkdir -p "$TTMLIR_TOOLCHAIN_DIR"

            # Create symlinks for clang-17/clang++-17 (Nix uses clang/clang++)
            mkdir -p $HOME/.local/bin
            ln -sf $(which clang) $HOME/.local/bin/clang-17
            ln -sf $(which clang++) $HOME/.local/bin/clang++-17
            ln -sf $(which ld.lld) $HOME/.local/bin/ld.lld-17
            export PATH="$HOME/.local/bin:$PATH"

            # Setup toolchain's llvm_gtest as GTest for CMake
            GTEST_COMPAT_DIR="$HOME/.local/share/cmake/GTest"
            if [ -f "$TTMLIR_TOOLCHAIN_DIR/lib/libllvm_gtest.a" ] && [ ! -f "$GTEST_COMPAT_DIR/GTestConfig.cmake" ]; then
              mkdir -p "$GTEST_COMPAT_DIR"

              # Create GTestConfig.cmake
              cat > "$GTEST_COMPAT_DIR/GTestConfig.cmake" << 'CMAKECFG'
# GTest compatibility layer for LLVM's gtest
set(GTEST_FOUND TRUE)
set(GTest_FOUND TRUE)

# Get toolchain dir from environment
set(_TOOLCHAIN_DIR "$ENV{TTMLIR_TOOLCHAIN_DIR}")
if(NOT _TOOLCHAIN_DIR)
  set(_TOOLCHAIN_DIR "$ENV{HOME}/.ttmlir-toolchain")
endif()

set(GTEST_INCLUDE_DIRS "''${_TOOLCHAIN_DIR}/include/llvm-gtest")
set(GTEST_LIBRARIES "''${_TOOLCHAIN_DIR}/lib/libllvm_gtest.a")
set(GTEST_MAIN_LIBRARIES "''${_TOOLCHAIN_DIR}/lib/libllvm_gtest_main.a")
set(GTEST_BOTH_LIBRARIES "''${GTEST_LIBRARIES};''${GTEST_MAIN_LIBRARIES}")

# Create imported targets
if(NOT TARGET GTest::gtest)
  add_library(GTest::gtest STATIC IMPORTED)
  set_target_properties(GTest::gtest PROPERTIES
    IMPORTED_LOCATION "''${GTEST_LIBRARIES}"
    INTERFACE_INCLUDE_DIRECTORIES "''${GTEST_INCLUDE_DIRS}"
  )
endif()

if(NOT TARGET GTest::gtest_main)
  add_library(GTest::gtest_main STATIC IMPORTED)
  set_target_properties(GTest::gtest_main PROPERTIES
    IMPORTED_LOCATION "''${GTEST_MAIN_LIBRARIES}"
    INTERFACE_LINK_LIBRARIES GTest::gtest
  )
endif()

if(NOT TARGET GTest::GTest)
  add_library(GTest::GTest ALIAS GTest::gtest)
endif()

if(NOT TARGET GTest::Main)
  add_library(GTest::Main ALIAS GTest::gtest_main)
endif()
CMAKECFG

              # Create GTestConfigVersion.cmake
              cat > "$GTEST_COMPAT_DIR/GTestConfigVersion.cmake" << 'CMAKEVER'
set(PACKAGE_VERSION "1.14.0")
set(PACKAGE_VERSION_EXACT FALSE)
set(PACKAGE_VERSION_COMPATIBLE TRUE)
if("''${PACKAGE_FIND_VERSION}" VERSION_GREATER "''${PACKAGE_VERSION}")
  set(PACKAGE_VERSION_COMPATIBLE FALSE)
endif()
CMAKEVER
            fi

            # Add custom cmake modules to CMAKE_PREFIX_PATH
            export CMAKE_PREFIX_PATH="$HOME/.local/share/cmake:''${CMAKE_PREFIX_PATH:-}"

            # Ensure cmake uses Ninja by default
            export CMAKE_GENERATOR="Ninja"

            echo ""
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║       tt-mlir Development Environment (FHS Compatible)       ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "TTMLIR_TOOLCHAIN_DIR: $TTMLIR_TOOLCHAIN_DIR"
            echo ""
            echo "Setup steps:"
            echo "  1. cd tt-mlir"
            echo "  2. cmake -B env/build env"
            echo "  3. cmake --build env/build"
            echo "  4. source env/activate"
            echo ""
            echo "Build steps:"
            echo "  1. source env/activate"
            echo "  2. cmake -G Ninja -B build [OPTIONS]"
            echo "  3. cmake --build build"
            echo ""
            echo "Build flags:"
            echo "  Runtime:"
            echo "    -DTTMLIR_ENABLE_RUNTIME=ON          Enable TTNN/Metal runtime (requires Clang 17+)"
            echo "    -DTT_RUNTIME_ENABLE_PERF_TRACE=ON   Enable performance tracing"
            echo "    -DTT_RUNTIME_DEBUG=ON               Enable runtime debug mode"
            echo ""
            echo "  Build optimization:"
            echo "    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache   Speed up builds with ccache"
            echo "    -DCMAKE_BUILD_PARALLEL_LEVEL=4         Limit parallel jobs (for OOM issues)"
            echo "    -DTTMLIR_ENABLE_BINDINGS_PYTHON=OFF    Disable Python bindings (faster builds)"
            echo ""
            echo "  Additional features:"
            echo "    -DTTMLIR_ENABLE_OPMODEL=ON          Enable op model optimizer pass"
            echo ""
            echo "Common combinations:"
            echo "  Fast dev build:  -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DTTMLIR_ENABLE_BINDINGS_PYTHON=OFF"
            echo "  tt-explorer:     -DTTMLIR_ENABLE_RUNTIME=ON -DTT_RUNTIME_ENABLE_PERF_TRACE=ON -DTT_RUNTIME_DEBUG=ON"
            echo ""
          '';

          runScript = "bash";
        };

      in
      {
        devShells.default = fhsEnv.env;

        # Also provide as a package for `nix run`
        packages.default = fhsEnv;
      }
    );
}
