{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      shell = {
        program = "${pkgs.zsh}/bin/zsh";
      };
      window = {
        opacity = 0.75;
        blur = true;
      };
    };
  };
}
