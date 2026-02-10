# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository managed with **Nix + home-manager + Flakes**. Supports both macOS and Linux.

## Setup Commands

```bash
# Apply configuration (Linux)
home-manager switch --flake ./nix#kyamaguchi@linux

# Apply configuration (macOS Apple Silicon)
home-manager switch --flake ./nix#kyamaguchi@macbook

# Apply configuration (macOS Intel)
home-manager switch --flake ./nix#kyamaguchi@macbook-intel

# First time setup (with backup of existing files)
nix run home-manager -- switch --flake ./nix#kyamaguchi@linux -b backup

# Check flake syntax
nix flake check ./nix
```

## Repository Structure

- `nix/` - Nix/home-manager configuration (primary)
  - `flake.nix` - Flakes entry point (defines inputs and outputs)
  - `home.nix` - Common home-manager settings
  - `hosts/darwin.nix` - macOS-specific settings
  - `hosts/linux.nix` - Linux-specific settings
  - `modules/packages.nix` - CLI tools (ripgrep, fd, ghq, uv, etc.)
  - `modules/git.nix` - Git config with delta
  - `modules/zsh.nix` - Zsh config with peco integration
  - `modules/tmux.nix` - Tmux config (prefix: C-a)
  - `modules/neovim.nix` - Neovim config with vim-plug
- `shell/`, `git/`, `tmux/`, `vim/`, `peco/` - Legacy configs (reference only)

## Key Keybindings

**Zsh (peco integration):**
- `Ctrl+r` - Search command history
- `Ctrl+j` - Jump to ghq-managed repo
- `Ctrl+b` - Switch git branch
- `Ctrl+x` - Switch kubernetes context

**Tmux (prefix: C-a):**
- `|` - Split vertical, `-` - Split horizontal
- `h/j/k/l` - Navigate panes (vim-style)
- `r` - Reload config

**Neovim:**
- Leader key: Space
- `Ctrl+]` - LSP go to definition
- `Ctrl+h/j/k/l` - Navigate splits

## Adding Packages

Edit `nix/modules/packages.nix` and run `home-manager switch`.

## Machine-specific Settings

Use `~/.localrc` for settings not tracked in git (e.g., work-specific configs).

## Language Environments

- Python: managed with `uv` (installed via Nix)
- Other languages: configure in `~/.localrc` or add to Nix config
