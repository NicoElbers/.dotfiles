{ lib, config, pkgs, ... }:
let
  cfg = config.zsh-cfg.ohMyPosh;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;[
      oh-my-posh
    ];

    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;

      settings =
        let
          # Colors form https://catppuccin.com/palette
          # flavor Mocha
          error = "#f38ba8";
          success = "#a6e3a1";
          subtle = "#7f849c";
          background_primary = "#1e1e2e";
          background_secondary = "#181825";

          text = "#cdd6f4";
          text_sub = "#a6adc8";
          text_dark = "#181825";

          base = "#1e1e2e";

          mauve = "#ca9ee6";
          mantle = "#292c3c";
          pink = "#f4b8e4";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          red = "#f38ba8";
          green = "#a6da95";
        in
        {
          "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
          blocks = [
            {
              newline = true;
              alignment = "left";
              segments = [
                {
                  background = "${background_primary}";
                  foreground = "${text}";
                  leading_diamond = "";
                  style = "diamond";
                  template = " {{ if .WSL }}WSL at {{ end }}{{.Icon}} ";
                  type = "os";
                }

                {
                  background = "${blue}";
                  foreground = "${text_dark}";
                  powerline_symbol = "";
                  properties = {
                    home_icon = "~";
                    style = "full";
                  };
                  style = "powerline";
                  template = "   {{ .Path }} ";
                  type = "path";
                }

                {
                  background = "${green}";
                  background_templates = [
                    "{{ if or (.Working.Changed) (.Staging.Changed) }}${mauve}{{ end }}"
                    "{{ if and (gt .Ahead 0) (gt .Behind 0) }}${red}{{ end }}"
                    "{{ if gt .Ahead 0 }}${blue}{{ end }}"
                    "{{ if gt .Behind 0 }}${green}{{ end }}"
                  ];
                  foreground = "${text_dark}";
                  powerline_symbol = "";
                  properties = {
                    "branch_icon" = " ";
                    fetch_stash_count = true;
                    fetch_status = true;
                    fetch_upstream_icon = true;
                  };
                  style = "powerline";
                  template = " {{ .UpstreamIcon }}{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }}  {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }}  {{ .StashCount }}{{ end }} ";
                  type = "git";
                }

              ];
              type = "prompt";
            }

            {
              alignment = "right";
              segments = [
                {
                  background = "#ffff66";
                  foreground = "#111111";
                  invert_powerline = true;
                  powerline_symbol = "";
                  style = "powerline";
                  template = "  ";
                  type = "root";
                }

                {
                  background = "${yellow}";
                  foreground = "${text_dark}";
                  invert_powerline = true;
                  powerline_symbol = "";
                  style = "powerline";
                  template = " {{ .FormattedMs }}  ";
                  type = "executiontime";
                }

                {
                  background = "${success}";
                  background_templates = [
                    "{{ if gt .Code 0 }}${error}{{ end }}"
                  ];
                  foreground = "${mantle}";
                  invert_powerline = true;
                  powerline_symbol = "";
                  properties = {
                    always_enabled = true;
                  };
                  style = "powerline";
                  template = " {{ if gt .Code 0 }}{{ reason .Code }}{{ else }}{{ end }} ";
                  type = "status";
                }

                {
                  background = "${pink}";
                  foreground = "${text_dark}";
                  invert_powerline = true;
                  style = "diamond";
                  template = " {{ .CurrentDate | date .Format }}  ";
                  trailing_diamond = "";
                  type = "time";
                }

              ];
              type = "prompt";
            }

            {
              alignment = "left";
              newline = true;
              segments = [
                {
                  foreground_templates = [
                    "{{if gt .Code 0}}red{{end}}"
                    "{{if eq .Code 0}}magenta{{end}}"
                  ];
                  style = "plain";
                  template = "❯";
                  type = "text";
                }

              ];
              type = "prompt";
            }

          ];
          transient_prompt = {
            background = "tansparent";
            foreground_templates = [
              "{{if gt .Code 0}}red{{end}}"
              "{{if eq .Code 0}}magenta{{end}}"
            ];
            template = "❯ ";
          };
          console_title_template = "{{ .Shell }} in {{ .Folder }}";
          final_space = true;
          version = 2;
        };
    };
  };
}

