{ lib, pkgs, ... }:
{
  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland.enable = true; # enable Hyprland

  # Optional, hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";
  home.sessionVariables.OZONE_PLATFORM = "wayland ";

  # Ensure that audio doesn't die
  services.wayland-pipewire-idle-inhibit = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = {
      verbosity = "INFO";
      media_minimum_duration = 10;
      idle_inhibitor = "wayland";
      node_blacklist = [
        { app_name = "Spotify"; }
      ];
    };
  };

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
        modules-right = [
          "cpu"
          "memory"
          "disk"
          "network"
          "custom/media"
          "battery"
          "pulseaudio"
          "tray"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
        };

        "clock" = {
          format = "{:%d/%m %a %H:%M:%S}";
          interval = 1;
          max-length = 18;
        };

        "cpu" = {
          format = " {usage}%";
          max-length = 4;
        };

        "memory" = {
          format = " {used:0.1f}G/{total:0.1f}G";
          max-length = 10;
        };

        "disk" = {
          format = " {free}";
          path = "/";
          max-length = 10;
        };

        "network" = {
          format-wifi = " {essid}";
          format-ethernet = " Wired";
          format-disconnected = "⚠ Disconnected";

          tooltip-format = "{ifname} {ipaddr}\n⬆ {bandwidthUpBits}\n⬇ {bandwidthDownBits}\nSignal: {signalStrength}%";
          tooltip-format-wifi = "{essid} ({signalStrength}%)\n⬆ {bandwidthUpBits}\n⬇ {bandwidthDownBits}";
          tooltip-format-ethernet = "{ifname} (Wired)\n⬆ {bandwidthUpBits}\n⬇ {bandwidthDownBits}";
          tooltip-format-disconnected = "⚠ Disconnected";

          max-length = 15;
        };

        "custom/media" = {
          format = "🎵 {}";
          return-type = "text";
          exec = "${pkgs.playerctl}/bin/playerctl metadata --format '{{artist}} - {{title}}'";
          interval = 2;
          on-click = "${pkgs.playerctl}/bin/playerctl play-pause";
          max-length = 25;
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% ";
          format-muted = "";
          format-icons = {
            "headphones" = "";
            "handsfree" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [
              ""
              ""
            ];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          max-length = 4;
        };

        "battery" = {
          states = {
            warning = 15;
            critical = 5;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          max-length = 7;
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

      #workspaces button label {
        padding: 0 10px;
      }

      #clock, #battery, #pulseaudio, #tray, #cpu, #memory,
      #disk, #network, #custom-media {
        padding: 0 8px;
        margin: 0 4px;
        min-height: 20px;
      }

      #pulseaudio {
        color: #A3BE8C;      /* Soft green */
        border-bottom: 3px solid #A3BE8C;
        min-width: 70px;     /* Fixed width */
      }

      #pulseaudio.muted {
        color: #BF616A;      /* Muted red */
        border-bottom: 3px solid #BF616A;
      }

      #battery {
        color: #88C0D0;      /* Arctic blue */
        border-bottom: 3px solid #88C0D0;
        min-width: 50px;     /* Fixed width */
      }

      #clock {
        color: #B48EAD;      /* Lavender */
        border-bottom: 3px solid #B48EAD;
        min-width: 170px;    /* Fixed width */
      }

      #tray {
        color: #D08770;      /* Peach */
        border-bottom: 3px solid #D08770;
        min-width: 40px;     /* Fixed width */
      }

      #cpu {
        color: #EBCB8B;      /* Butter yellow */
        border-bottom: 3px solid #EBCB8B;
        min-width: 60px;     /* Fixed width */
      }

      #memory {
        color: #81A1C1;      /* Polar blue */
        border-bottom: 3px solid #81A1C1;
        min-width: 130px;    /* Fixed width */
      }

      #disk {
        color: #8FBCBB;      /* Teal (replaced white) */
        border-bottom: 3px solid #8FBCBB;
        min-width: 100px;    /* Fixed width */
      }

      #network {
        color: #D3869B;      /* Blush pink */
        border-bottom: 3px solid #D3869B;
        min-width: 120px;    /* Fixed width */
      }

      #custom-media {
        color: #C678DD;      /* Soft purple */
        border-bottom: 3px solid #C678DD;
        min-width: 180px;    /* Fixed width */
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
      "fcitx5 -d"
    ];

    # "$mod" = "SUPER";
    "$mod" = "Alt";
    bind = [
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

      "$mod SHIFT,h, movewindow, l" # Move window Right
      "$mod SHIFT,j, movewindow, d" # Move window Down
      "$mod SHIFT,k, movewindow, u" # Move window Up
      "$mod SHIFT,l, movewindow, r" # Move window Left

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
      builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = i + 1;
          in
          [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
          ]
        ) 9
      )
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
