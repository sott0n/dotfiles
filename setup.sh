#!/bin/bash
set -e

# Enable Nix Flakes
mkdir -p ~/.config/nix
if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
    echo "Enabled Nix Flakes"
fi

# Determine target configuration
case "${1:-auto}" in
    linux)
        TARGET="kyamaguchi@linux"
        ;;
    darwin|macos)
        TARGET="kyamaguchi@macbook"
        ;;
    darwin-intel|macos-intel)
        TARGET="kyamaguchi@macbook-intel"
        ;;
    auto)
        if [[ "$(uname)" == "Darwin" ]]; then
            if [[ "$(uname -m)" == "arm64" ]]; then
                TARGET="kyamaguchi@macbook"
            else
                TARGET="kyamaguchi@macbook-intel"
            fi
        else
            TARGET="kyamaguchi@linux"
        fi
        ;;
    *)
        echo "Usage: $0 [linux|darwin|darwin-intel|auto]"
        exit 1
        ;;
esac

echo "Applying configuration: $TARGET"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Run home-manager
nix run home-manager -- switch --flake "$SCRIPT_DIR/nix#$TARGET" -b backup
