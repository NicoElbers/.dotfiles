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

        # Utilities
        killall
        tldr

        # Uni VPN
        eduvpn-client

        # Geeki
        strongswan
        openvpn
        networkmanager-openvpn
        networkmanager-l2tp
        keepassxc
      ];

    };
  };
}
