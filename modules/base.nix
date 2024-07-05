{config, pkgs, ...}:
{
  imports = [
    ./bluetooth.nix
  ];

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
        vim 
        wget
        kitty   
        git
        wl-clipboard
        polkit
    ];
  }; 
}
