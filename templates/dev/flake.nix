{
  description = "Empty dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  };

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems = f: builtins.mapAttrs f nixpkgs.legacyPackages;
    in
    {
      devShells = forAllSystems (
        system: pkgs: {
          default =
            with pkgs;
            mkShell {
              packages = [

              ];
            };
        }
      );
    };
}
