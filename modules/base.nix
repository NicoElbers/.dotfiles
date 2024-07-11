# TODO: Decide if this is better moved to ./users
{config, pkgs, ...}:
{
  imports = [
    ./bluetooth.nix
    ./sddm
  ];

  config = {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };

    nixpkgs.config = {
      allowUnfree = true;
    };

    # TODO: Add more, like compiler and shit. 
    environment.systemPackages = with pkgs; [
        # Essentials
        vim       # Edit files
        git       # Pull down config
        wget      # Download stuff if required
        alacritty # Terminal

        # Great utilities
        bat
        wl-clipboard

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
          serif     = [ "Liberation Serif" ];
        };
      };
    };

    # TODO: See if I can make this more configurable
    # Set browser
    programs.firefox.enable = true;
    xdg.mime.defaultApplications = {
      "text/html"                 = "firefox.desktop";
      "x-scheme-handler/http"     = "firefox.desktop";
      "x-scheme-handler/https"    = "firefox.desktop";
      "x-scheme-handler/about"    = "firefox.desktop";
      "x-scheme-handler/unknown"  = "firefox.desktop";
    };
    environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
  }; 

}
