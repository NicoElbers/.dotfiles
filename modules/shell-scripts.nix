{ lib, pkgs, ... }:
let 
  writers = import ./commons/writer.nix { inherit lib pkgs; };
in
{
  pinit = pkgs.writeShellScriptBin "pinit" ''
    if [ -z "$1" ]; then
        echo "Please provide an argument"
        exit 1
    fi

    nix flake init -t ~/.dotfiles#$1 &> /dev/null

    if [ "$?" -ne 0 ]; then
        echo "Template \"$1\" not found"
        echo "Choose from the following: "
        json=$(nix flake show --json --quiet ~/.dotfiles 2> /dev/null)
        
        if [ $? -ne 0 ]; then
            echo "Failed to retrieve template information from ~/.dotfiles"
            exit 1
        fi

        echo "$json" | ${pkgs.jq}/bin/jq -r '.templates | to_entries[] | "\t\(.key): \(.value.description)"'
        exit 1
    fi

    if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
        # Ignore .direnv 
        if ! git check-ignore -q .direnv; then
            echo "ignoring .direnv"
            echo ".direnv" >> .gitignore
        fi
    fi

    echo "Successfully initialized flake"
  '';

  zello = writers.writeZigBin "zello" { } /*zig*/ ''
    const std = @import("std");

    pub fn main() void {
      std.debug.print("Hello world from zig!", .{});
    }
  '';
}
