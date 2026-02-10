{ config, pkgs, lib, ... }:

{
  # macOS-specific packages
  home.packages = with pkgs; [
    # Trash command (replacement for rm)
    trash-cli
  ];

  # macOS-specific shell aliases
  programs.zsh.shellAliases = {
    ls = "ls --color";
    la = "ls -A --color";
  };

  # macOS-specific environment
  programs.zsh.initContent = lib.mkAfter ''
    # Homebrew path (Apple Silicon)
    export PATH=/opt/homebrew/bin:$PATH
  '';

  # tmux copy/paste for macOS (pbcopy/pbpaste are native)
  programs.tmux.extraConfig = lib.mkAfter ''
    # macOS specific clipboard settings are already in the main config
    # pbcopy/pbpaste work natively on macOS
  '';
}
