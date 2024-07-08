{ pkgs, lib, config, ... }:
let
  cfg = config.direnv-cfg;
in 
{
  options. direnv-cfg = {
    enable = lib.mkEnableOption "Enable direnv";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      zsh.enable = true;
    };
  };
}
