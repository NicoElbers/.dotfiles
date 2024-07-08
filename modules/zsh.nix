{ ... }:
{
  environment.pathsToLink = [ "/share/zsh" ];

  # Always have zsh as a backup
  programs.zsh = {
    enable = true;
  };
}
