{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nvim = {
      url = "github:NicoElbers/nvim-config";
    };


    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    wayland-pipewire-idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
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
          ({...}: {
            nixpkgs.overlays = import ./overlays.nix {inherit inputs;};
          })
          ./hosts/omen-laptop/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
      
      overlays = import ./overlays.nix {inherit inputs;};

      templates = import ./templates;

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
