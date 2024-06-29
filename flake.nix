{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
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
  };
}
