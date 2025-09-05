{
  description = "C/C++ flake with zig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    zig = {
      url = "github:silversquirl/zig-flake/compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zls = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.zig-overlay.follows = "zig";
    };
  };

  outputs =
    {
      nixpkgs,
      zig,
      zls,
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
              zig.packages.${system}.nightly
              zls.packages.${system}.zls
            ];
          };
        }
      );
    };
}
