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
    ./starship.nix
  ];

  options.zsh-cfg = with lib; {
    enable = mkEnableOption "Zsh configuration";
    debug = mkEnableOption "Debug zsh";
    ohMyPosh.enable = mkEnableOption "custom ohMyPosh prompt";
    starship.enable = mkEnableOption "custom starship prompt";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;[
      zsh
    ];

    programs.zsh = {
      enable = true;

      enableCompletion = true;
      enableVteIntegration = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;

      initExtraFirst = ''
          zsh_start_time=$(date +%s%3N)

          log_time() {
            local current_time=$(date +%s%3N)
            local elapsed=$((current_time - zsh_start_time))
            echo "[''${elapsed}ms] $1"
          }
      '';

      initExtra = ''
        log_time "startup time"
      '';

      shellAliases = {
        rebuild = "nixos-rebuild switch --use-remote-sudo --impure --flake ~/.dotfiles#omen";
        pinit = lib.getExe shell-scipts.pinit;
        cat = "${lib.getExe pkgs.bat} -p";
        gl = "${lib.getExe pkgs.git} log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
        gd = "${lib.getExe pkgs.git} diff";
        gdc = "${lib.getExe pkgs.git} diff --cached";
        gp = "${lib.getExe pkgs.git} add -p";
        ssh = "TERM=xterm-256color ${pkgs.openssh}/bin/ssh";

        # Old oh-my-zsh aliases that I care about
        ".." = "./..";
        "..." = "./../..";
        "...." = "./../../..";
        "....." = "./../../../..";
        "......" = "./../../../../..";
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
