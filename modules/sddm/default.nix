{ pkgs, ... }:
let
  catppuccin-sddm = pkgs.callPackage ./catppuccin-sddm.nix {
    flavor = "mocha";
    accent = "mauve";
    font  = "Noto Sans";
    fontSize = "9";
    background = "${./shacks.png}";
    loginBackground = true;
  };
in
{
  environment.systemPackages = [(
    catppuccin-sddm
  )];

  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha-mauve";
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
  };
}
