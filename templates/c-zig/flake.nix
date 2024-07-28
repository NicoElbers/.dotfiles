# Copied from https://github.com/the-nix-way/dev-templates/blob/main/c-cpp/flake.nix
{
  description = "A Nix-flake-based C/C++ development environment with zig as build system";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.zig = {
    url = "github:mitchellh/zig-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.zls = {
    url = "github:zigtools/zls";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, zig, zls }:
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
              clang-tools
              cmake
              codespell
              conan
              cppcheck
              doxygen
              gtest
              lcov
              vcpkg
              vcpkg-tool
              gdb

              zig.packages.${pkgs.system}.master
              zls.packages.${pkgs.system}.zls
            ];
          };
      });
    };
}
