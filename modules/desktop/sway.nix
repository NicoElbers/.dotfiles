#TODO: See how much of this I can remove
{ lib, pkgs, ... }:
let
  sway-nvidia = pkgs.writeTextFile {
    name = "sway-nvidia";
    destination = "/share/wayland-sessions/sway-nvidia.desktop";
    text = ''
      [Desktop Entry]
      Comment=Sway, but with --unsupported-gpu
      Exec=sway --unsupported-gpu
      Name=Sway-nvidia
      Type=Application
    '';
    checkPhase = ''${pkgs.buildPackages.desktop-file-utils}/bin/desktop-file-validate "$target"'';
    derivationArgs = { passthru.providedSessions = [ "sway-nvidia" ]; };
  };

  sway = pkgs.writeTextFile {
    name = "swayfx-nvidia";
    destination = "/share/wayland-sessions/sway.desktop";
    text = ''
      [Desktop Entry]
      Comment=Sway, but with --unsupported-gpu
      Exec=sway 
      Name=Sway
      Type=Application
    '';
    checkPhase = ''${pkgs.buildPackages.desktop-file-utils}/bin/desktop-file-validate "$target"'';
    derivationArgs = { passthru.providedSessions = [ "sway" ]; };
  };
in
{
  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = with pkgs; [
    rofi
    polkit
  ];

  security.polkit.enable = lib.mkForce true;
  programs.sway = {
    enable = true;
    package = null;
    extraOptions = [
      "--unsupported-gpu"
    ];
    extraPackages = with pkgs; [ swaylock swayidle kitty dmenu ];
  };

  # Setup session for swayfx
  services.displayManager.sessionPackages = [ sway-nvidia sway ];
}
