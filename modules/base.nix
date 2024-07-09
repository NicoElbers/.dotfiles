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
        vim 
        wget
        git
        wl-clipboard
        polkit

        # Terminal
        alacritty

        # Useful applications
        spotify
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
