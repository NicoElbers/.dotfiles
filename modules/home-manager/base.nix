{ pkgs, lib, config, ... }:
{
  imports = [
    ./nixpkgs
    ./sway
    ./zsh

    ./hyprland.nix
    ./direnv.nix
    ./git.nix
    ./kitty.nix
    ./lazygit.nix
    ./zathura.nix
    ./firefox.nix
    ./ghostty.nix
  ];
}
