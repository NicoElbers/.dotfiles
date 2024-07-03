{ pkgs, ...}:
{
  config = {
    environment.pathsToLink = [ "/share/zsh" ];

# Prevent new user dialog
    system.userActivationScripts.zshrc = "touch .zshrc";

    programs.zsh = {
      enable = true;
      enableCompletion = true;

      shellInit = ''
        '';
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --impure --flake ~/.dotfiles#omen";
      };

      ohMyZsh = {
        enable = true;
        plugins = [];
        theme = "agnoster";
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
