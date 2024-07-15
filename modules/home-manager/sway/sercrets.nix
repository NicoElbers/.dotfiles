{ lib, config, ... }:
let
  cfg = config;
in
{
  config = {
    # Enable secrets, you want this
    services.gnome-keyring.enable = true;

    wayland.windowManager.sway = {
      systemd.enable = true;

      # https://www.reddit.com/r/NixOS/comments/1dvy7ln/networkmanager_forgets_passwords_after_reboot/hare_button
      systemd.xdgAutostart = true;
    };
  };
}
