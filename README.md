# dotfiles

Personal dotfiles managed with **Nix + home-manager + Flakes**.

## Setup

### 1. Install Nix

```bash
curl -L https://nixos.org/nix/install | sh
```

### 2. Clone & Setup

```bash
git clone git@github.com:sott0n/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./setup.sh  # Auto-detects OS
```

Or specify target manually:

```bash
./setup.sh linux         # Linux
./setup.sh darwin        # macOS (Apple Silicon)
./setup.sh darwin-intel  # macOS (Intel)
```

### 3. After changes

```bash
home-manager switch --flake ./nix#kyamaguchi@linux
```

## Structure

```
nix/
├── flake.nix              # Entry point
├── flake.lock             # Dependency lock
├── home.nix               # Common settings
├── hosts/
│   ├── darwin.nix         # macOS-specific
│   └── linux.nix          # Linux-specific
└── modules/
    ├── packages.nix       # CLI tools (ripgrep, fd, ghq, uv, etc.)
    ├── git.nix            # Git + delta
    ├── zsh.nix            # Zsh + peco integration
    ├── tmux.nix           # Tmux (prefix: C-a)
    └── neovim.nix         # Neovim + vim-plug
```

## Key Bindings

### Zsh (peco)

| Key | Action |
|-----|--------|
| `Ctrl+r` | Search command history |
| `Ctrl+j` | Jump to ghq repo |
| `Ctrl+b` | Switch git branch |
| `Ctrl+x` | Switch kubernetes context |

### Tmux (prefix: C-a)

| Key | Action |
|-----|--------|
| `\|` | Split vertical |
| `-` | Split horizontal |
| `h/j/k/l` | Navigate panes |
| `r` | Reload config |

### Neovim (Leader: Space)

| Key | Action |
|-----|--------|
| `Ctrl+]` | LSP go to definition |
| `Ctrl+h/j/k/l` | Navigate splits |

## Adding Packages

Edit `nix/modules/packages.nix`:

```nix
home.packages = with pkgs; [
  ripgrep
  htop  # add here
];
```

Then apply:

```bash
home-manager switch --flake ./nix#kyamaguchi@linux
```

## Machine-specific Settings

Use `~/.localrc` for settings not tracked in git.

## Author

[Kohei Yamaguchi](https://github.com/sott0n)
