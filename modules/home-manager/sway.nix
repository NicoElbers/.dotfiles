{pkgs, lib, config, ...}:

{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    systemd.enable = true;
    extraOptions = [
      "--unsupported-gpu"
    ];
    config = {
      gaps = {
        smartBorders = "on";
      };
      modifier = "Mod4";
      menu = "tofi-drun --drun-launch-true";
      terminal = "kitty";
      keybindings = 
        let 
          mod = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${mod}+Shift+e" = "exit";
          "${mod}+Shift+f" = "exec firefox";
        };
    };
  };
}
