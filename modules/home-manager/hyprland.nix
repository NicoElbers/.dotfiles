{lib, pkgs, ...}:
{
  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland.enable = true; # enable Hyprland

  # Optional, hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";
  home.sessionVariables.OZONE_PLATFORM = "wayland ";

  home.packages = with pkgs; [
    hyprpicker
    hyprshot
    swappy
    hyprpaper
    waybar
    hyprpolkitagent
  ];

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "battery" "pulseaudio" "tray" ];

        "hyprland/workspaces" = {
          disable-scroll = true;
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% ";
          format-muted = "";
          format-icons = {
            "headphones" = "";
            "handsfree" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" ""];
          };
          on-click = "pavucontrol";
        };

        "battery" = {
          states = {
            warning = 15;
            critical = 5;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };

        "tray" = {
          icon-size = 14;
          spacing = 1;
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0px;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 14px;
        min-height: 0;
      }


      /* Workspace Buttons */
      #workspaces button label{
        padding: 0 10px;
      }

      #clock, #battery, #pulseaudio, #tray {
        padding: 0 10px;
        margin: 0 10px;
      }

      #pulseaudio {
        margin: 0;
        color: #689d6a;
        border-bottom: 5px solid #689d6a;
      }

      #pulseaudio.muted {
        padding: 0 20px;
        color: #cc241d;
        border-bottom: 5px solid #cc241d;
      }

      #battery {
        margin: 0;
        color: #458588;
        border-bottom: 5px solid #458588;
      }

      #clock {
        margin: 0;
        color: #b16286;
        border-bottom: 5px solid #b16286;
      }

      #tray {
        margin: 0 10px;
        color: #d65d0e;
        border-bottom: 5px solid #d65d0e;
      }
    '';
  };

  services.hyprpaper = {
    enable = true;
  };

  programs.hyprlock = {
    enable = true;
  };

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/Pictures/background/freiren.jpg
    wallpaper = eDP-1,~/Pictures/background/freiren.jpg
  '';

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "systemctl --user start hyprpolkitagent"
      "waybar"
    ];

    "$mod" = "SUPER";
    bind =
      [
        # Common
        "$mod, B, exec, firefox"
        "$mod, RETURN, exec, ghostty"
        "$mod, R, exec, rofi -show drun"

        # Window
        "$mod,SPACE,togglefloating" # Float toggle

        "$mod,h, movefocus, l" # Move focus Right
        "$mod,j, movefocus, d" # Move focus Down
        "$mod,k, movefocus, u" # Move focus Up
        "$mod,l, movefocus, r" # Move focus Left

        "$mod SHIFT,h, swapwindow, l" # Move window Right
        "$mod SHIFT,j, swapwindow, d" # Move window Down
        "$mod SHIFT,k, swapwindow, u" # Move window Up
        "$mod SHIFT,l, swapwindow, r" # Move window Left

        # Util
        "$mod SHIFT, Q, killactive,"
        "$mod, F, fullscreen,"
        "$mod, P, exec, ${pkgs.hyprlock}/bin/hyprlock"

        # Workspaces
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 0, movetoworkspacesilent, 10"
      ]
      ++ (
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
            ]
          )
          9)
      );

    bindm = [
      "$mod,mouse:272, movewindow" # Move Window (mouse)
      "$mod,g, resizewindow" # Resize Window (mouse)
    ];

    bindl = [
      ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause" # Play/Pause Song
      ",XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause" # Play/Pause Song
      ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next" # Next Song
      ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous" # Previous Song
    ];
  
    animations = {
        enabled = true;
        # bezier = "ease, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 4, default"
          "windowsOut, 1, 4, default"
          "border, 1, 5, default"
          "fade, 1, 2.5, default"
          "workspaces, 1, 6, default"
        ];
      };

    bindle = [
      ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t" # Toggle Mute
      ",XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer --allow-boost -i 5"
      ",XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer --allow-boost -d 5"
      ",XF86MonBrightnessDown, exec, ${lib.getExe pkgs.light} -U 10" # Brightness Up
      ",XF86MonBrightnessUp, exec, ${lib.getExe pkgs.light} -A 10" # Brightness Down
    ];
    
    general = {
      gaps_out = 5;
    };

    decoration = {
      rounding = 10;
      rounding_power = 3;
    };

    misc = {
      # disable auto polling for config file changes
      disable_autoreload = true;
      # disable_hyprland_logo = true;

      vrr = 1;
      vfr = true;
    };

    input = {
      touchpad = {
        natural_scroll = true;
        disable_while_typing = true;
        clickfinger_behavior = true;
        tap-to-click = true;
        scroll_factor = 0.5;
      };
    };

    monitor = [
      "eDP-1, preferred, auto, 1.000000"
    ];

    windowrulev2 = [
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
      "idleinhibit focus, class:^(zen)$, title:^(.*YouTube.*)$"
      "idleinhibit fullscreen, class:^(zen)$"
    ];
  };
}
