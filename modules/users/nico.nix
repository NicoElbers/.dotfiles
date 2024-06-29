{pkgs, ...}:
{

  imports = [
    ../home-manager/zsh.nix
  ];

  config = {
    users.users.nico = {
      isNormalUser = true;
      description = "Nico";
      extraGroups = [ "networkmanager" "wheel" ];

      shell = pkgs.zsh;

      packages = with pkgs; [
        kdePackages.kate
      ];
      
    };
  };
}
