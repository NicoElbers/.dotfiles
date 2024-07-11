# TODO: Make this module configurable
{ lib, config, pkgs, ... }:
let
  cfg = config.zsh-cfg;
  shell-scipts = import ../../shell-scripts.nix { inherit lib pkgs; };
in
{
  imports = [
    ./debug.nix
    ./ohMyPosh.nix
  ];

  options.zsh-cfg = with lib; {
    enable = mkEnableOption "Zsh configuration";
    debug = mkEnableOption "Debug zsh";
    ohMyPosh.enable = mkEnableOption "custom ohMyPosh prompt";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;[
      zsh
    ];

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --impure --flake ~/.dotfiles#omen";
        zello = lib.getExe shell-scipts.zello;
      };
      
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];
    };
  };
}
