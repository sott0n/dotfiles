{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      mkHomeConfig = { system, username, hostname, extraModules ? [] }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./home.nix
            ./modules/packages.nix
            ./modules/git.nix
            ./modules/zsh.nix
            ./modules/tmux.nix
            ./modules/neovim.nix
          ] ++ extraModules;
          extraSpecialArgs = {
            inherit username hostname;
          };
        };
    in
    {
      homeConfigurations = {
        # macOS (Apple Silicon)
        "kyamaguchi@macbook" = mkHomeConfig {
          system = "aarch64-darwin";
          username = "kyamaguchi";
          hostname = "macbook";
          extraModules = [ ./hosts/darwin.nix ];
        };

        # macOS (Intel)
        "kyamaguchi@macbook-intel" = mkHomeConfig {
          system = "x86_64-darwin";
          username = "kyamaguchi";
          hostname = "macbook-intel";
          extraModules = [ ./hosts/darwin.nix ];
        };

        # Linux (x86_64)
        "kyamaguchi@linux" = mkHomeConfig {
          system = "x86_64-linux";
          username = "kyamaguchi";
          hostname = "linux";
          extraModules = [ ./hosts/linux.nix ];
        };
      };
    };
}
