# Copied from https://github.com/the-nix-way/dev-templates/blob/main/c-cpp/flake.nix
{
  description = "A Nix-flake-based C/C++ development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell.override
          {
            # Override stdenv in order to change compiler:
            stdenv = pkgs.clangStdenv;
          }
          {
            packages = with pkgs; [
              lldb
            ];
          };
      });
    };
}
