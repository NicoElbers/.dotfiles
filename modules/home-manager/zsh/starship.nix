{ lib, config, ... }:
let
  cfg = config.zsh-cfg.starship;
in
{
  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {

        format = "$os$all";
        right_format = "$cmd_duration";

        scan_timeout = 10;
        command_timeout = 300;

        os = {
          disabled = false;
          style = "";
        };

        directory = {
          read_only = " ";
          read_only_style = "white";

          repo_root_format = "[git:$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
          before_repo_root_style = "bold cyan";
          repo_root_style = "bold cyan";
        };

        git_branch = {
          format = "[$symbol$branch(:$remote_branch)]($style) ";
        };

        git_metrics = {
          disabled = false;
        };

        git_status = {
          style = "bold purple";
        };

        zig = {
          format = "[$symbol($version)]($style) ";
          version_format = "v($mayor.)$minor.$patch";
        };

        c = {
          format = "[$symbol($version)]($style) ";
          version_format = "v($mayor.)$minor.$patch";
          detect_extensions = [ "c" "h" "cpp" "cxx" "cc" "hpp"];
        };


        rust = {
          format = "[$symbol($version)]($style) ";
          version_format = "v($mayor.)$minor.$patch";
        };

        nix_shell = {
          format = "[$symbol$name]($style) ";
          symbol = "❄️ ";
          heuristic = true;
        };

        cmd_duration = {
          min_time = 100;
          show_milliseconds = true;

          format = "[$duration]($style)";
        };
      };
    };
  };
}
