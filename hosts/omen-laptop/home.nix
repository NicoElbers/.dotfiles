# TODO: Try to remove this file as much as possible
{
  config,
  pkgs,
  inputs,
  ...
}:

let
  base = ../../modules/home-manager;
in
{
  home.username = "nico";
  home.homeDirectory = "/home/nico";

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nico/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nv";
  };

  # TODO: Make a general 'include' file, and configure more
  imports = [
    # (base + /git.nix)
    # (base + /sway)
    # (base + /zsh)
    # (base + /lf)
    # (base + /alacritty.nix)
    # (base + /nixpkgs)
    # (base + /direnv.nix)
    # (base + /kitty.nix)
    # (base + /zathura.nix)
    inputs.wayland-pipewire-idle-inhibit.homeModules.default
    (base + /base.nix)
  ];

  git.userName = "Nico Elbers";
  git.userEmail = "nico.b.elbers@gmail.com";

  sway-cfg = {
    enable = true;
    swayfx.enable = true;
  };

  zsh-cfg = {
    enable = true;
    debug = false;

    ohMyPosh = {
      enable = false;
    };

    starship.enable = true;
  };
  direnv-cfg.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
