{pkgs, lib, config, ...}:

let 
  status-cfg = "main";
in
{
  # Enable secrets
  services.gnome-keyring.enable = lib.mkDefault true;

  programs.swaylock.enable = lib.mkDefault true;

  programs.i3status-rust= {
    enable = lib.mkDefault true;
    bars = {

      "${status-cfg}" = {
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
            full_format = " $icon $percentage.eng(w:4) $time.datetime(f:'%H:%M:%S') ";
            charging_format = " $icon $percentage.eng(w:4) $time.datetime(f:'%H:%M:%S') ";
            empty_format = " $icon CHARGE YOUR SHIT AAAA $percentage.eng(w:4) $time.datetime(f:'%H:%M:%S') ";
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
      };

    };
  };


  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false;
    wrapperFeatures.gtk = true;
    systemd.enable = true;
    extraOptions = [
      "--unsupported-gpu"
    ];

    extraConfig = ''
      # swayfx config
      for_window [app_id="kitty"] blur enable
      blur_passes 4
      blur_radius 7

      # shadows enable

      corner_radius 10
    '';

    systemd.xdgAutostart = true;
    
    config = {
      gaps = {
        smartBorders = "no_gaps";
        outer = 10;
        inner = 5;
      };

      window = {
        titlebar = false;
        border = 0;
        hideEdgeBorders = "both";
      };

      floating = {
        titlebar = false;
        border = 0;
      };

      input = {
        "type:touchpad" = {
          natural_scroll = "enabled";
          click_method = "clickfinger";
          tap = "enabled";
          tap_button_map = "lrm";
        };
      };

      modifier = "Mod4";

      menu = "rofi -show drun";
      
      terminal = "kitty";

      keybindings = 
        let 
          cfg = config.wayland.windowManager.sway.config;
          mod = cfg.modifier;
        in
        lib.mkOptionDefault {

          # Disabled
          "${mod}+v" = "";

          # Operations
          "${mod}+Shift+q" = "kill";
          "${mod}+Shift+e" = "exit";

          # Apps
          "${mod}+Return"   = "exec ${cfg.terminal}";
          "${mod}+b"        = "exec firefox";         # Mod [B]rowser
          "${mod}+r"        = "exec ${cfg.menu}";     # Mod [R]un application

          # Move focus
          "${mod}+${cfg.left}"   = "focus left";
          "${mod}+${cfg.down}"   = "focus down";
          "${mod}+${cfg.up}"     = "focus up";
          "${mod}+${cfg.right}"  = "focus right";

          # Move window
          "${mod}+Shift+${cfg.left}"   = "move left";
          "${mod}+Shift+${cfg.down}"   = "move down";
          "${mod}+Shift+${cfg.up}"     = "move up";
          "${mod}+Shift+${cfg.right}"  = "move right";

          # GOTO workspace
          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";

          # Window GOTO workspace
          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";

      };

      bars = let
        normal.bg     = "#2f343f";
        normal.text   = "#f3f4f5";

        inactive.bg   = "#2f343f";
        inactive.text = "#676E7D";

        urgent.bg     = "#E53935";
        urgent.text   = "#f3f4f5";
      in
      [
        {
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs config-${status-cfg}.toml";
          position  = "top";
          extraConfig = ''
            height 25 
          '';
          colors = {
            background = normal.bg;
            separator  = urgent.bg;

            focusedWorkspace  = with normal;    { background = bg; border = bg; text = text; };
            inactiveWorkspace = with inactive;  { background = bg; border = bg; text = text; };
            urgentWorkspace   = with urgent;    { background = bg; border = bg; text = text; };
          };
        }
      ];
    };
  };
}
