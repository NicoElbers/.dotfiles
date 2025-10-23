{
  description = "Nixos config flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/502d59f04a067e754a687a7daa83e85a093e1f88";

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

    animegirls.url = "git+ssh://git@github.com/NicoElbers/animegirls";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      lib = nixpkgs.lib;

      systemSettings = {
        system = "x86_64-linux";
      };

      forAllSystems = f: builtins.mapAttrs f nixpkgs.legacyPackages;
    in
    {
      nixosConfigurations.omen = lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit systemSettings;
        };
        system = systemSettings.system;
        modules = [
          (
            { ... }:
            {
              nixpkgs.overlays = import ./overlays.nix { inherit inputs; };
            }
          )
          ./hosts/omen-laptop/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      overlays = import ./overlays.nix { inherit inputs; };

      templates = import ./templates;

      formatter = forAllSystems (system: pkgs: pkgs.nixfmt-rfc-style);
      format = self.formatter.${systemSettings.system};
    };
}
