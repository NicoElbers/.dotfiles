{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.sway-cfg.swayfx;
in
{
  options.sway-cfg.swayfx = {
    enable = mkEnableOption "swayfx config";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      package = pkgs.swayfx;

      extraConfig = ''
        # swayfx config
        blur_passes 4
        blur_radius 7

        corner_radius 10
      '';
    };
  };
}
