# TODO: Configure in here
{ pkgs, ... }:
{
  imports = [
    ../zsh.nix
  ];

  config = {
    programs.light.enable = true;

    virtualisation.libvirtd.enable = true; 
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      virt-manager
      keepassxc
    ];

    users.users.nico = {
      isNormalUser = true;
      description = "Nico";
      extraGroups = [ 
        "video" 
        "networkmanager" 
        "wheel" 
        "libvirtd"
      ];

      shell = pkgs.zsh;

      packages = with pkgs; [
        gimp
        spotify
        bitwarden-desktop
        # Uni VPN
        eduvpn-client
      ];

    };
  };
}
