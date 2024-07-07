# TODO: Configure in here
{pkgs, ...}:
{
  imports = [
    ../zsh.nix
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
