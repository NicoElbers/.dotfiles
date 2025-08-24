{ pkgs, lib, config, ... }:
let
  cfg = config.direnv-cfg;
in
{
  options. direnv-cfg = {
    enable = lib.mkEnableOption "Enable direnv";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;

        stdlib = ''
          : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
          declare -A direnv_layout_dirs
          direnv_layout_dir() {
              local hash path
              echo "''${direnv_layout_dirs[$PWD]:=$(
                  hash="$(sha1sum - <<< "$PWD" | head -c40)"
                  path="''${PWD//[^a-zA-Z0-9]/-}"
                  echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}-''${path}"
              )}"
          }
        '';
      };

      zsh.enable = true;
    };
  };
}
