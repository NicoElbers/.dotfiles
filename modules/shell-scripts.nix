{ lib, pkgs, ... }:
let
  writers = import ./commons/writer.nix { inherit lib pkgs; };
  flake_path = ../.;
in
{
  pinit = pkgs.writeShellScriptBin "pinit" ''
    if [ -z "$1" ]; then
        echo "Please provide an argument"
        exit 1
    fi

    ${pkgs.nix}/bin/nix flake init -t ${flake_path}\#$1 2> /dev/null

    if [ "$?" -ne 0 ]; then
        echo "Template \"$1\" not found in ${flake_path}"
        echo "Choose from the following: "
        json=$(${pkgs.nix}/bin/nix flake show --json --quiet ${flake_path} 2> /dev/null)
        
        if [ $? -ne 0 ]; then
            echo "Failed to retrieve templates information from ${flake_path}"
            exit 1
        fi

        echo "$json" | ${pkgs.jq}/bin/jq -r '.templates | to_entries[] | "  \(.key): \(.value.description)"'
        echo "


        "
        exit 1
    fi

    # Are we in a git repo
    if [ -d .git ] || ${pkgs.git}/bin/git rev-parse --git-dir > /dev/null 2>&1; then
        if ! ${pkgs.git}/bin/git check-ignore -q .direnv; then
            echo ".direnv" >> .gitignore
            echo "ignoring .direnv"
        fi

        if [ -f flake.nix ] & ! ${pkgs.git}/bin/git ls-files --error-unmatch flake.nix &> /dev/null; then
          ${pkgs.git}/bin/git add flake.nix
          echo "Added flake.nix to git"
        fi

        if [ -f .envrc ] & ! ${pkgs.git}/bin/git ls-files --error-unmatch .envrc &> /dev/null; then
          ${pkgs.git}/bin/git add .envrc
          echo "Added .envrc to git"
        fi

        if [ -f shell.nix ] & ! ${pkgs.git}/bin/git ls-files --error-unmatch shell.nix &> /dev/null; then
          ${pkgs.git}/bin/git add shell.nix
          echo "Added shell.nix to git"
        fi
    fi

    echo "Successfully initialized flake"
  '';

  zello =
    writers.writeZigBin "zello" { } # zig
      ''
        const std = @import("std");

        pub fn main() void {
          std.debug.print("Hello world from zig!\n", .{});
        }
      '';
}
