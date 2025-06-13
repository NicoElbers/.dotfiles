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

    # Docker
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    users.users.nico = {
      isNormalUser = true;
      description = "Nico";
      extraGroups = [ 
        "video" 
        "networkmanager" 
        "wheel" 
        "libvirtd"
        "dialout"
      ];

      shell = pkgs.zsh;

      packages = with pkgs; [
        gimp3
        spotify
        bitwarden-desktop

        # Games
        prismlauncher

        # Communication
        discord
        signal-desktop

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

    xdg.mime.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };

    environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
  };
}
