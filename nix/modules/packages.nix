{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Search and navigation
    ripgrep
    fd
    peco
    ghq
    tig

    # JSON/YAML processing
    jq
    yq

    # Git tools
    delta
    git-lfs

    # Development tools
    ctags

    # Python
    uv  # Fast Python package/project manager (replaces pyenv, pip, venv)

    # Archive tools
    unzip
    zip

    # Misc
    curl
    wget
    tree
  ];
}
