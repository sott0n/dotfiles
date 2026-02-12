{
  description = "tt-metal development environment (FHS compatible)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # FHS environment for tt-metal development
        fhsEnv = pkgs.buildFHSEnv {
          name = "tt-metal-dev";

          targetPkgs = pkgs: with pkgs; [
            # Build tools (install_dependencies.sh: build-essential, cmake, ninja-build, pkg-config, g++-14)
            gcc14
            gnumake
            cmake
            ninja
            ccache
            pkg-config
            binutils
            patchelf

            # Clang/LLVM 20 (install_dependencies.sh installs clang-20 via llvm.sh)
            llvmPackages_20.clang
            llvmPackages_20.llvm
            llvmPackages_20.lld
            llvmPackages_20.libclang
            llvmPackages_20.libcxx       # libc++-20-dev (includes libcxxabi)
            clang-tools

            # Version control
            git
            git-lfs

            # Libraries (from install_dependencies.sh)
            hwloc              # libhwloc-dev
            numactl            # libnuma-dev
            tbb                # libtbb-dev
            capstone           # libcapstone-dev
            openssl            # libssl-dev
            libatomic_ops      # libatomic1

            # Additional libraries
            boost
            zlib
            ncurses
            libxml2
            libffi
            yaml-cpp
            gtest

            # Python 3 (install_dependencies.sh: python3-dev, python3-pip, python3-venv)
            python311
            python311Packages.pip
            python311Packages.virtualenv
            python311Packages.setuptools
            python311Packages.pybind11
            python311Packages.pyyaml

            # Utilities (from install_dependencies.sh)
            wget
            curl
            xz              # xz-utils
            xxd             # vim-common (for xxd)
            pandoc

            # General utilities
            jq
            unzip
            which
            file
            coreutils
            bash
            rsync

            # For FHS compatibility
            glibc
            stdenv.cc.cc.lib  # libstdc++6
          ];

          multiPkgs = pkgs: with pkgs; [
            zlib
            glibc
          ];

          profile = ''
            export NIX_SHELL_NAME="tt-metal-dev"

            # Set TT_METAL_HOME if inside tt-metal directory
            if [ -f "build_metal.sh" ]; then
              export TT_METAL_HOME="$(pwd)"
              export PYTHONPATH="$TT_METAL_HOME:''${PYTHONPATH:-}"
            fi

            # Activate Python venv if it exists
            if [ -f "python_env/bin/activate" ]; then
              source python_env/bin/activate
            fi

            echo ""
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║       tt-metal Development Environment (FHS Compatible)      ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "Build steps (no install_dependencies.sh needed):"
            echo "  1. cd tt-metal"
            echo "  2. ./build_metal.sh                # Build tt-metal"
            echo "  3. ./create_venv.sh                # Create Python virtual environment"
            echo "  4. source python_env/bin/activate  # Activate venv"
            echo ""
            echo "Environment variables (set automatically when in tt-metal dir):"
            echo "  TT_METAL_HOME=$TT_METAL_HOME"
            echo "  PYTHONPATH includes TT_METAL_HOME"
            echo ""
            echo "Note: If build fails due to missing dependencies, you may need"
            echo "      to run 'sudo ./install_dependencies.sh' outside this shell"
            echo "      for system-level setup (hugepages, kernel modules, etc.)"
            echo ""
          '';

          runScript = "bash";
        };

      in
      {
        # buildFHSEnv returns derivation directly (no .env attribute)
        devShells.default = fhsEnv;

        # Also provide as a package for `nix run`
        packages.default = fhsEnv;
      }
    );
}
