{ lib, config, ...}:
let
  cfg = config.git;
in 
{
  imports = [
    ./lazygit.nix
  ];

  options = {
    git.userName = lib.mkOption {
      description = "Git user name";
    };
    git.userEmail = lib.mkOption {
      description = "Git email address";
    };
  };

  config = {
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;

      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
}
