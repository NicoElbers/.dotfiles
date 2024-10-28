# TODO: Decide if this is better moved to ./users
{ config, pkgs, inputs, ... }:
{
  imports = [
    ./bluetooth.nix
    ./services.nix
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

    documentation = {
      dev.enable = true;
      man.enable = true;
      nixos.enable = true;
    };

    environment.systemPackages = with pkgs; 
    let
      my-nvim = inputs.nvim.packages.${system}.default;
    in [
      # Essentials
      vim # Edit files
      git # Pull down config
      wget # Download stuff if required
      # inputs.nvim.packages.${system}.default # My neovim config
      my-nvim # neovim <3

      # networking
      networkmanagerapplet

      # FIXME: Find an alternative to alacritty
      # alacritty # Terminal
      kitty # Terminal

      # Great utilities
      bat # cat but colors
      fd # find but simply better
      wl-clipboard # Cliboards are useful
      htop # I like to see why my device is burning
      tree # Easy FSH visualization 

      hyperfine # TODO: move to user

      kalker # MATH
      unzip # unzipping archives is useful
      zip # zipping archives is useful
      ripgrep # grep but better

      # man pages
      man-pages
      man-pages-posix

      # Safe to have available
      polkit
    ];

    # Safe to have available
    security.polkit.enable = true;

    # Fonts :)
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

    # Enable nix-ld, very useful for running blobs
    programs.nix-ld.enable = true;

    # TODO: move to user
    # TODO: See if I can make this more configurable
    # Set browser
  };
}
