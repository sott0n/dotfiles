{ config, pkgs, lib, username, hostname, ... }:

{
  home.username = username;
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # PATH additions
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
  ];

  # npm global packages directory (avoids permission issues with Nix-managed Node.js)
  home.file.".npm-global/.keep".text = "";
  home.file.".npmrc".text = ''
    prefix=~/.npm-global
  '';

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
  };

  # Source ~/.localrc for machine-specific settings
  home.file.".localrc".text = lib.mkDefault ''
    # Machine-specific settings go here
    # This file is not tracked in git
  '';
}
