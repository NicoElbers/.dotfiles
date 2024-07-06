{ pkgs, ... }:
let 
  tokyonight-night-sddm = pkgs.libsForQt5.callPackage ./tokyo-night-sddm.nix {};
in
{
  environment.systemPackages = [
    tokyonight-night-sddm
  ];

  services.displayManager.sddm = {
    enable = true;
    theme = "tokyo-night-sddm";
  };
}
