# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, system, pkgs, inputs, ... }:

let
  base = ../../modules;
  hardware = inputs.nixos-hardware;
in
{
  imports =
    [
      # Hardware specific conifig
      ./hardware-configuration.nix
      hardware.nixosModules.omen-16-n0280nd
      ./bootloader.nix

      # Home manager
      inputs.home-manager.nixosModules.default

      # Base config
      (base + /base.nix)

      # Users
      (base + /users/nico.nix)

      # DE
      (base + /desktop/sway.nix)
      (base + /desktop/hyprland.nix)
    ];

  # Nvidia
  # FIXME: Move into module
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.finegrained = true;
    nvidiaSettings = true;
    # FIXME: 6.12 kernel issues
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # prime = {
    #   offload = {
    #     enable = lib.mkOverride 1000 false;
    #   };
    #   sync.enable = lib.mkOverride 990 true;
    # };
  };

  networking.hostName = "omen"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # FIXME: Move into base
  networking.networkmanager.enable = true;

  # Save 5 seconds booting
  systemd.services."NetworkManager-wait-online".enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;


  # Configure keymap in X11
  # TODO: See if this needs to be removed
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  # FIXME: move into module
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  home-manager = {
    # useGlobalPkgs = true;

    backupFileExtension = "bak";

    extraSpecialArgs = { inherit inputs; };
    users = {
      "nico" = { ... }: { imports = [ ./home.nix ]; };
    };
  };

  #FIXME: put into base
  security.polkit.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # FIXME: Move into base
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
