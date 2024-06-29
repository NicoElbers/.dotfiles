{ lib, config, ...}:
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
    };

  };
}
