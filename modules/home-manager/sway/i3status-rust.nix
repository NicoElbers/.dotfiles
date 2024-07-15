{ lib, config, pkgs, ... }:
let
  cfg = config.i3status-rust;
in
{
  options.i3status-rust = {
    enable = lib.mkEnableOption "i3status-rust";

    config-name = lib.mkOption {
      type = lib.types.str;
      default = "main";
    };

    normal.bg = lib.mkOption {
      type = lib.types.str;
      default = "#2f343f";
    };
    normal.text = lib.mkOption {
      type = lib.types.str;
      default = "#f3f4f5";
    };

    inactive.bg = lib.mkOption {
      type = lib.types.str;
      default = "#2f343f";
    };

    inactive.text = lib.mkOption {
      type = lib.types.str;
      default = "#676E7D";
    };

    urgent.bg = lib.mkOption {
      type = lib.types.str;
      default = "#E53935";
    };
    urgent.text = lib.mkOption {
      type = lib.types.str;
      default = "#f3f4f5";
    };


  };

  config = lib.mkIf cfg.enable {
    programs.i3status-rust = {
      enable = lib.mkDefault true;
      bars = {

        "${cfg.config-name}" = {
          blocks = [
            {
              alert = 10.0;
              block = "disk_space";
              info_type = "available";
              interval = 60;
              path = "/";
              warning = 20.0;
            }

            {
              block = "memory";
              format = " $icon $mem_used_percents.eng(w:4) ";
            }

            {
              block = "cpu";
              format = " $icon $utilization.eng(w:4) ";
              interval = 1;
            }

            {
              block = "load";
              format = " $icon $1m.eng(w:3) ";
              interval = 1;
            }

            {
              block = "net";
              format = " $icon {$ssid $speed_up.eng(prefix:K, w:5) ^icon_net_up $speed_down.eng(prefix:K, w:5) ^icon_net_down} ";
              format_alt = " $icon {$ssid $graph_up ^icon_net_up $graph_down ^icon_net_down} ";
            }

            {
              block = "sound";
            }

            {
              block = "battery";
              full_format = " $icon $percentage.eng(w:4) {$time|} ";
              charging_format = " $icon $percentage.eng(w:4) (CHR) {$time|} ";
              not_charging_format = " $icon $percentage.eng(w:4) (DIS) {$time|} ";
              empty_format = " $icon CHARGE YOUR SHIT AAAA $percentage.eng(w:4) {$time|} ";
              interval = 1;
            }

            {
              block = "time";
              format = " $timestamp.datetime(f:'%a %d/%m %R') ";
              interval = 1;
            }

          ];

          settings = {
            theme = {
              theme = "native";
            };
          };

          icons = "material-nf";
        };

      };
    };


    wayland.windowManager.sway.config.bars = [{
      statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs config-${cfg.config-name}.toml";
      position = "top";
      extraConfig = ''
        height 25 
      '';
      colors = {
        background = cfg.normal.bg;
        separator = cfg.urgent.bg;

        focusedWorkspace = with cfg.normal;    { background = bg; border = bg; text = text; };
        inactiveWorkspace = with cfg.inactive;  { background = bg; border = bg; text = text; };
        urgentWorkspace = with cfg.urgent;    { background = bg; border = bg; text = text; };
      };
    }];
  };
}
