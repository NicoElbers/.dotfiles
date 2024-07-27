{ lib, config, pkgs, ... }:
{
  options = {

  };

  config = {
    programs.kitty = {
      enable = true;

      font = {
        name = "FiraCode Nerd Font Mono";
      };

      shellIntegration = {
        enableZshIntegration = true;
      };

      theme = "Rosé Pine Moon";

      settings = {
        enable_audio_bell = false;

        background_opacity = 65;
      };
    };
  };
}
