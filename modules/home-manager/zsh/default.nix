# TODO: Make this module configurable
{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
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
    artDir = mkOption {
      type = types.str;
      default = "~/Pictures/animegirls/";
      description = "Directory to joink art from";
    };
    ohMyPosh.enable = mkEnableOption "custom ohMyPosh prompt";
    starship.enable = mkEnableOption "custom starship prompt";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zsh
    ];

    programs.zsh = {
      enable = true;

      enableCompletion = true;
      enableVteIntegration = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;

      initContent = # bash
        ''
          ${inputs.animegirls.packages.${config.nixpkgs.system}.default}/bin/pick ${config.zsh-cfg.artDir}

          # Allow for case insensitive matching
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} m:{a-z}={A-Z} r:|[._-]=* r:|=*'

          # Select from menu
          zstyle ':completion:*' menu select

          setopt auto_menu
          setopt complete_in_word

          # Bind Shift-Tab to go backward in completion menu
          bindkey "^[[Z" reverse-menu-complete

          bindkey "^H" backward-word
          bindkey "^L" forward-word

          autoload -z edit-command-line
          zle -N edit-command-line
          bindkey "^X" edit-command-line

          # Properly expand "..." and the likes
          function expand-dots() {
            local MATCH
            if [[ $LBUFFER =~ '(^| )\.\.\.+' ]]; then
              LBUFFER=$LBUFFER:fs%\.\.\.%../..%
            fi
          }

          function expand-dots-then-expand-or-complete() {
            zle expand-dots
            zle expand-or-complete
          }

          function expand-dots-then-accept-line() {
            zle expand-dots
            zle accept-line
          }

          zle -N expand-dots
          zle -N expand-dots-then-expand-or-complete
          zle -N expand-dots-then-accept-line
          bindkey '^I' expand-dots-then-expand-or-complete
          bindkey '^M' expand-dots-then-accept-line
        '';

      shellAliases = {
        rebuild = "nixos-rebuild switch --sudo --flake ~/.dotfiles#omen -L --show-trace";
        pinit = lib.getExe shell-scipts.pinit;
        cat = "${lib.getExe pkgs.bat} -p";
        gl = "${lib.getExe pkgs.git} log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
        gd = "${lib.getExe pkgs.git} diff";
        gdc = "${lib.getExe pkgs.git} diff --cached";
        gp = "${lib.getExe pkgs.git} add -p";
        ssh = "TERM=xterm-256color ${pkgs.openssh}/bin/ssh";

        # Cat images using the kitty image protocol
        icat = "${lib.getBin pkgs.kitty} +kitten icat";
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
