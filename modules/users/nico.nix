# TODO: Configure in here
{ pkgs, ... }:
{
  imports = [
    ../zsh.nix
  ];

  config = {
    programs.light.enable = true;

    environment.systemPackages = with pkgs; [
      eduvpn-client
    ];

    users.users.nico = {
      isNormalUser = true;
      description = "Nico";
      extraGroups = [ "video" "networkmanager" "wheel" ];

      shell = pkgs.zsh;

      packages = with pkgs; [
        gimp
        spotify
        bitwarden-desktop
      ];

    };
  };
}
