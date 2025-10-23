{ lib, config, ... }:
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

      settings = {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };

        init.defaultBranch = "main";

        pull.rebase = true;
        push.autoSetupRemote = true;

        rerere.enabled = true;

        core.fsmonitor = true;

        alias = {
          wd = "diff --word-diff=color --color";
          bc = "blame -C -C -C";
        };
      };

      signing = {
        signByDefault = true;
        key = null;
      };

      lfs.enable = true;
    };
  };
}
