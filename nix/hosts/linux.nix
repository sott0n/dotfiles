{ config, pkgs, lib, ... }:

{
  # Override tmux to disable libutempter (fixes "not a terminal" error)
  programs.tmux.package = pkgs.tmux.override {
    withUtempter = false;
  };

  # Linux-specific packages
  home.packages = with pkgs; [
    xsel       # Clipboard support
    xdg-utils  # xdg-open
  ];

  # Linux-specific shell aliases
  programs.zsh.shellAliases = {
    ls = "ls --color=auto";
    open = "xdg-open";
    pbcopy = "xsel --clipboard --input";
    pbpaste = "xsel --clipboard --output";
  };

  # tmux copy/paste for Linux (use xsel)
  programs.tmux.extraConfig = lib.mkAfter ''
    # Linux clipboard settings
    bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "xsel --clipboard --input"
    bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel "xsel --clipboard --input"
    bind-key -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "xsel --clipboard --input"
  '';
}
