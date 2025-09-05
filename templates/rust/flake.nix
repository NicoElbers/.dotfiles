{
  description = "Rust dev flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      fenix,
      ...
    }:
    let
      forAllSystems =
        f:
        builtins.mapAttrs (
          system: pkgsForSystem:
          let
            # Overlay the Fenix packages onto the nixpkgs set
            pkgs = pkgsForSystem // {
              inherit (fenix.packages.${system}.latest) cargo rustc rust-src;
            };
          in
          f system pkgs
        ) nixpkgs.legacyPackages;
    in
    {
      devShells = forAllSystems (
        system: pkgs: {

          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              rustc
              cargo
            ];
          };
        }
      );
    };
}
