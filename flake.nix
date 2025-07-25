{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nvim = {
      url = "github:NicoElbers/nvim-config";
    };


    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      lib = nixpkgs.lib;

      systemSettings = {
        system = "x86_64-linux";
      };
    in
    {
      nixosConfigurations.omen = lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit systemSettings;
        };
        system = systemSettings.system;
        modules = [
          ./hosts/omen-laptop/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
      
      overlays = import ./overlays.nix {inherit inputs;};

      templates = import ./templates;

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
