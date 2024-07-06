{ lib, pkgs, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = with pkgs; [
    rofi
    networkmanagerapplet
  ];

  security.polkit.enable = lib.mkForce true;
  programs.sway.enable = true;
}
