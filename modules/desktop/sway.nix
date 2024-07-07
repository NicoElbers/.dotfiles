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
    networkmanagerapplet
  ];

  security.polkit.enable = lib.mkForce true;
  programs.sway = {
    enable = true;
    package = null;
    extraOptions = [
      "--unsupported-gpu"
    ];
  };

  # Setup session for swayfx
  services.xserver.displayManager.sessionPackages = [ sway-nvidia sway ];
}
