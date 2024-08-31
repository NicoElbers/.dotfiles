# TODO: Decide if this is better moved to ./users
{ config, pkgs, inputs, ... }:
{
  imports = [
    ./bluetooth.nix
    ./sddm
  ];

  config = {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    nixpkgs.config = {
      allowUnfree = true;
    };

    # TODO: Add more, like compiler and shit. 
    environment.systemPackages = with pkgs; [
      # Essentials
      vim # Edit files
      git # Pull down config
      wget # Download stuff if required
      inputs.nvim.packages.${system}.default

      # FIXME: Find an alternative to alacritty
      alacritty # Terminal
      kitty

      # Great utilities
      bat
      wl-clipboard
      htop
      tree
      hyperfine
      kalker
      unzip
      zip
      ripgrep

      # Safe to have available
      # FIXME: Either enable polkit here or remove it from here
      # I'm opting to remove it tbh; more minimal
      polkit

      # Useful applications
      # FIXME: move into ./user honestly
      # Maybe add into "./useful applications" or smth
      spotify
      bitwarden-desktop
    ];

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        # Nerdfont
        (nerdfonts.override { fonts = [ "FiraCode" ]; })

        # Asian languages
        noto-fonts-cjk-sans
      ];

      fontconfig = {
        defaultFonts = {
          monospace = [ "FiraCode Nerd Font Mono" ];
          sansSerif = [ "FiraCode Nerd Font Propo" ];
          serif = [ "Liberation Serif" ];
        };
      };
    };

    # TODO: See if I can make this more configurable
    # Set browser
    programs.firefox.enable = true;
    xdg.mime.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
    environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";

    environment.etc."current-system-packages".text =
      let
        packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
        sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
        formatted = builtins.concatStringsSep "\n" sortedUnique;
      in
      formatted;
  };
}
