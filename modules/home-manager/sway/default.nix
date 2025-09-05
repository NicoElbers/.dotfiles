{
  pkgs,
  lib,
  config,
  ...
}:

let
  sway-cfg = config.sway-cfg;

  # Define workspaces to easily rename in the future (or add config for it)
  ws1 = "1";
  ws2 = "2";
  ws3 = "3";
  ws4 = "4";
  ws5 = "5";
  ws6 = "6";
  ws7 = "7";
  ws8 = "8";
  ws9 = "9";
  ws10 = "10";

  bg-dir = "~/Pictures/background";

  bg-command = ''
    $(pgrep swaybg | xargs kill || true) \
      && ${lib.getExe pkgs.swaybg} -i \
      $( \
        ${lib.getExe pkgs.fd} . ${bg-dir} -t f | \
        ${pkgs.coreutils-full}/bin/shuf -n1 \
      )
  '';
in
{
  imports = [
    ./i3status-rust.nix
    ./sercrets.nix
    ./swayfx.nix
    ./swaync.nix
  ];

  options.sway-cfg = with lib; {
    enable = mkEnableOption "enable sway config";

    terminal = mkOption {
      type = types.str;
      default = "ghostty";
    };

    menu = mkOption {
      type = types.str;
      default = "rofi -show drun";
    };
  };

  config = lib.mkIf sway-cfg.enable {
    home.packages = [ ];

    # Enable statusbar
    i3status-rust.enable = lib.mkDefault true;

    programs.swaylock.enable = lib.mkDefault true;

    wayland.windowManager.sway = {
      enable = true;
      checkConfig = false;
      wrapperFeatures.gtk = true;
      systemd.enable = true;

      # Not needed since I have my own desktop files, but I'll keep it anyway
      extraOptions = [
        "--unsupported-gpu"
      ];

      # Very important https://www.reddit.com/r/NixOS/comments/1dvy7ln/networkmanager_forgets_passwords_after_reboot/hare_button
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

        assigns = {
          ${ws10} = [ { class = "^Spotify$"; } ];
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
            dwt = "disabled";
          };
        };

        modifier = "Mod4";

        menu = sway-cfg.menu;
        terminal = sway-cfg.terminal;

        startup = [
          # Quick and dirty fix to start at the right workspace
          { command = "swaymsg workspace ${ws1}"; }

          # Auto start spotify
          # TODO: See if I can put this in xdgAutostart
          { command = "${pkgs.spotify}/bin/spotify"; }

          # Open up whatsapp on startup, put in scratchpad manually (sadge)
          { command = "${lib.getExe pkgs.firefox} --new-window https://web.whatsapp.com/"; }

          # Startup gammastep
          { command = "${lib.getExe pkgs.gammastep} -O 3500"; }

          # Setup background
          {
            command = bg-command;
            always = true;
          }
        ];

        keybindings =
          let
            cfg = config.wayland.windowManager.sway.config;
            mod = cfg.modifier;

            screenshot_cmd = ''
              exec IMG=$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir PICTURES)/screenshots/$(${pkgs.coreutils}/bin/date +'screenshot_%F-%T.png') && \
                ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - $IMG && \
                ${pkgs.wl-clipboard}/bin/wl-copy -t image/png < $IMG
            '';
          in
          {
            # Operations
            "${mod}+Shift+q" = "kill";
            "${mod}+Shift+e" = "exit";
            "${mod}+f" = "fullscreen toggle";
            "${mod}+Shift+r" = "reload";

            # Layout
            "${mod}+s" = "layout stacking";
            "${mod}+w" = "layout tabbed";
            "${mod}+e" = "layout toggle split";

            # Floating
            "${mod}+Shift+space" = "floating toggle";
            "${mod}+space" = "focus mode_toggle";

            # Scratchpad
            "${mod}+Shift+minus" = "move scratchpad";
            "${mod}+minus" = "scratchpad show";

            # Apps
            "${mod}+Return" = "exec ${cfg.terminal}";
            "${mod}+b" = "exec firefox"; # Mod [B]rowser
            "${mod}+r" = "exec ${cfg.menu}"; # Mod [R]un application

            # Screenshots
            # Taken from https://www.reddit.com/r/swaywm/comments/9q5a5l/comment/e8ahpwl/
            "${mod}+Shift+s" = screenshot_cmd;
            "print" = screenshot_cmd;

            # Move focus
            "${mod}+${cfg.left}" = "focus left";
            "${mod}+${cfg.down}" = "focus down";
            "${mod}+${cfg.up}" = "focus up";
            "${mod}+${cfg.right}" = "focus right";

            # Move window
            "${mod}+Shift+${cfg.left}" = "move left";
            "${mod}+Shift+${cfg.down}" = "move down";
            "${mod}+Shift+${cfg.up}" = "move up";
            "${mod}+Shift+${cfg.right}" = "move right";

            # GOTO workspace
            "${mod}+1" = "workspace number ${ws1}";
            "${mod}+2" = "workspace number ${ws2}";
            "${mod}+3" = "workspace number ${ws3}";
            "${mod}+4" = "workspace number ${ws4}";
            "${mod}+5" = "workspace number ${ws5}";
            "${mod}+6" = "workspace number ${ws6}";
            "${mod}+7" = "workspace number ${ws7}";
            "${mod}+8" = "workspace number ${ws8}";
            "${mod}+9" = "workspace number ${ws9}";
            "${mod}+0" = "workspace number ${ws10}";

            # Window GOTO workspace
            "${mod}+Shift+1" = "move container to workspace number ${ws1}";
            "${mod}+Shift+2" = "move container to workspace number ${ws2}";
            "${mod}+Shift+3" = "move container to workspace number ${ws3}";
            "${mod}+Shift+4" = "move container to workspace number ${ws4}";
            "${mod}+Shift+5" = "move container to workspace number ${ws5}";
            "${mod}+Shift+6" = "move container to workspace number ${ws6}";
            "${mod}+Shift+7" = "move container to workspace number ${ws7}";
            "${mod}+Shift+8" = "move container to workspace number ${ws8}";
            "${mod}+Shift+9" = "move container to workspace number ${ws9}";
            "${mod}+Shift+0" = "move container to workspace number ${ws10}";

            # Brightness
            "XF86MonBrightnessDown" = "exec ${lib.getExe pkgs.light} -U 10";
            "XF86MonBrightnessUp" = "exec ${lib.getExe pkgs.light} -A 10";

            # Volume
            "XF86AudioRaiseVolume" = "exec ${lib.getExe pkgs.pamixer} --allow-boost -i 5";
            "XF86AudioLowerVolume" = "exec ${lib.getExe pkgs.pamixer} --allow-boost -d 5";
            "XF86AudioMute" = "exec ${lib.getExe pkgs.pamixer} -t";

            # Media player
            "XF86AudioPlay" = "exec ${lib.getExe pkgs.playerctl} play-pause";
            "XF86AudioPause" = "exec ${lib.getExe pkgs.playerctl} play-pause";
            "XF86AudioNext" = "exec ${lib.getExe pkgs.playerctl} next";
            "XF86AudioPrev" = "exec ${lib.getExe pkgs.playerctl} previous";
          };
      };
    };
  };
}
