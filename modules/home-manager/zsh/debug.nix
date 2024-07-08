# TODO: Make this module configurable
{ lib, config, ... }:
let
  cfg = config.zsh-cfg;
in
{
  config = lib.mkIf cfg.debug {
    programs.zsh = {
      initExtraFirst = ''
        zmodload zsh/zprof
        '';

      initExtra = ''
        zprof
        '';
    };
  };
}
