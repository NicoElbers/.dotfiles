{pkgs, ...}:
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
    hyprpolkitagent
  ];

  services.hyprpaper = {
    enable = true;
  };

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/Pictures/background/freiren.jpg
    wallpaper = eDP-1,~/Pictures/background/freiren.jpg
  '';

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "systemctl --user start hyprpolkitagent"
    ];

    "$mod" = "SUPER";
    bind =
      [
        # Common
        "$mod, B, exec, firefox"
        "$mod, RETURN, exec, ghostty"
        "$mod, R, exec, rofi -show drun"

        # Window
        "$mod,h, movefocus, r" # Move focus Right
        "$mod,j, movefocus, u" # Move focus Up
        "$mod,k, movefocus, d" # Move focus Down
        "$mod,l, movefocus, l" # Move focus left

        # Util
        "$mod SHIFT, Q, killactive,"
        "$mod, F, fullscreen,"
        "$mod, L, exec, ${pkgs.hyprlock}/bin/hyprlock"

        # Workspaces
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 0, movetoworkspace, 10"
      ]
      ++ (
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );

    bindm = [
      "$mod,mouse:272, movewindow" # Move Window (mouse)
      "$mod,R, resizewindow" # Resize Window (mouse)
    ];

    bindl = [
      ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t" # Toggle Mute
      ",XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer --allow-boost -i 5"
      ",XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer --allow-boost -d 5"

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
      ",XF86AudioRaiseVolume, exec, sound-up" # Sound Up
      ",XF86AudioLowerVolume, exec, sound-down" # Sound Down
      ",XF86MonBrightnessUp, exec, brightness-up" # Brightness Up
      ",XF86MonBrightnessDown, exec, brightness-down" # Brightness Down
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
