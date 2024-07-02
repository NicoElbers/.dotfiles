{config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    vim 
    wget
    kitty   
    git
    wl-clipboard
    polkit
  ];
}
