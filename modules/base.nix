{config, pkgs, ...}:
{
  imports = [
    ./bluetooth.nix
    ./sddm
  ];

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
        vim 
        wget
        kitty   
        git
        wl-clipboard
        polkit
    ];

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        (nerdfonts.override { fonts = [ "FiraCode" ]; })

        # Asian languages
        noto-fonts-cjk-sans
      ];
    };

    

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

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
