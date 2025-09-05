{
  description = "C/C++ flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      forAllSystems = f: builtins.mapAttrs f nixpkgs.legacyPackages;
    in
    {
      devShells = forAllSystems (
        system: pkgs: {

          default = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
            packages = with pkgs; [
              lldb
              cmake
              python3
              clang-tools
            ];
          };
        }
      );
    };
}
