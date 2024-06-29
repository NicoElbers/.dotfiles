{ pkgs, lib, inputs, ...}: 
{
  security.polkit.enable = true;

    wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty"; 
      startup = [
        # Launch Firefox on start
        {command = "firefox";}
      ];
    };
  };
}
