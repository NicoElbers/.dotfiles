{ lib, pkgs, ... }:
let 
  swayfx-nvidia = pkgs.writeTextFile {
    name = "swayfx-nvidia";
    destination = "/share/wayland-sessions/swayfx-nvidia.desktop";
    text = ''
      [Desktop Entry]
      Comment=SwayFX, but with --unsupported-gpu
      Exec=sway --unsupported-gpu
      Name=Swayfx-nvidia
      Type=Application
    '';
    checkPhase = ''${pkgs.buildPackages.desktop-file-utils}/bin/desktop-file-validate "$target"'';
    derivationArgs = { passthru.providedSessions = [ "swayfx-nvidia" ]; };
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
    package = pkgs.swayfx;
    extraOptions = [
      "--unsupported-gpu"
    ];
  };

  # Setup session for swayfx
  services.xserver.displayManager.sessionPackages = [ swayfx-nvidia ];
}
