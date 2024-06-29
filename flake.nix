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

    basePath = ./.;
  in
  {
    nixosConfigurations.omen = lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit systemSettings;
        inherit basePath;
      };
      system = systemSettings.system;
      modules = [
        ./hosts/omen-laptop/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
