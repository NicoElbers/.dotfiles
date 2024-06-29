# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license

{
  description = "Nico's nixCats config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    nixCats.inputs.nixpkgs.follows = "nixpkgs";

    zls.url = "github:zigtools/zls";
    zls.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
  };

  outputs = { self, nixpkgs, nixCats, ... }@inputs: let
    inherit (nixCats) utils;
    luaPath = "${./.}";
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    # the following extra_pkg_config contains any values
    # which you want to pass to the config set of nixpkgs
    # import nixpkgs { config = extra_pkg_config; inherit system; }
    # will not apply to module imports
    # as that will have your system values
    extra_pkg_config = {
      # allowUnfree = true;
    };
    # sometimes our overlays require a ${system} to access the overlay.
    # management of this variable is one of the harder parts of using flakes.

    # so I have done it here in an interesting way to keep it out of the way.

    # First, we will define just our overlays per system.
    # later we will pass them into the builder, and the resulting pkgs set
    # will get passed to the categoryDefinitions and packageDefinitions
    # which follow this section.

    # this allows you to use ${pkgs.system} whenever you want in those sections
    # without fear.
    system_resolved = forEachSystem (system: let
      # see :help nixCats.flake.outputs.overlays
      standardPluginOverlay = utils.standardPluginOverlay;
      dependencyOverlays = (import ./overlays inputs) ++ [
        # This overlay grabs all the inputs named in the format
        # `plugins-<pluginName>`
        # Once we add this overlay to our nixpkgs, we are able to
        # use `pkgs.neovimPlugins`, which is a set of our plugins.
        (standardPluginOverlay inputs)
        # add any flake overlays here.
      ];
      # these overlays will be wrapped with ${system}
      # and we will call the same utils.eachSystem function
      # later on to access them.
    in { inherit dependencyOverlays; });
    inherit (system_resolved) dependencyOverlays;
    # see :help nixCats.flake.outputs.categories
    # and
    # :help nixCats.flake.outputs.categoryDefinitions.scheme
    categoryDefinitions = { pkgs, settings, categories, name, ... }@packageDef: {
      # to define and use a new category, simply add a new list to a set here, 
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # propagatedBuildInputs:
      # this section is for dependencies that should be available
      # at BUILD TIME for plugins. WILL NOT be available to PATH
      # However, they WILL be available to the shell 
      # and neovim path when using nix develop
      propagatedBuildInputs = {
        generalBuildInputs = with pkgs; [
        ];
      };

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          universal-ctags
          tree-sitter
          ripgrep
          fd
          gcc
          nix-doc

          # lsps
          lua-language-server
          nodePackages_latest.typescript-language-server
          emmet-language-server
          tailwindcss-language-server
          llvmPackages_18.clang-unwrapped
          nil
          marksman
          pyright
          inputs.zls
          rust-analyzer

          # Formatters
          prettierd
          stylua
          black
          rustfmt
          checkstyle
          languagetool-rust

          # Clipboard
          # TODO: Make it so it installs the right clipboard
          wl-clipboard-rs
        ];
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = {
        customPlugins = with pkgs.nixCatsBuilds; [ ];
        lazy = with pkgs.vimPlugins; [
          lazy-nvim
        ];
        general = {
          gitPlugins = with pkgs.neovimPlugins; [
            # hlargs
          ];
          vimPlugins = with pkgs.vimPlugins; [
              # completions
              nvim-cmp
              cmp_luasnip
              luasnip
              friendly-snippets
              cmp-path
              cmp-buffer
              cmp-nvim-lua
              cmp-nvim-lsp
              cmp-nvim-lsp-signature-help

              # telescope
              plenary-nvim
              telescope-nvim
              telescope-undo-nvim
              telescope-ui-select-nvim
              telescope-fzf-native-nvim
              todo-comments-nvim
              trouble-nvim

              # Formatting
              conform-nvim

              # lsp
              nvim-lspconfig
              fidget-nvim
              neodev-nvim
              rustaceanvim
              none-ls-nvim

              # treesitter
              nvim-treesitter-textobjects
              nvim-treesitter.withAllGrammars

              # ui
              lualine-nvim
              nvim-web-devicons
              gitsigns-nvim
              nui-nvim
              neo-tree-nvim
              undotree

              # Color scheme
              onedark-nvim
              catppuccin-nvim
              tokyonight-nvim

              #misc
              vimtex
              comment-nvim
              vim-sleuth
              indent-blankline-nvim
              markdown-preview-nvim
              image-nvim
              autoclose-nvim
            ];
        };

        themer = with pkgs.vimPlugins;
          (builtins.getAttr categories.colorscheme {
              "onedark" = onedark-nvim;
              "catppuccin" = catppuccin-nvim;
              "catppuccin-mocha" = catppuccin-nvim;
              "tokyonight" = tokyonight-nvim;
            }
          );
      };

# not loaded automatically at startup.
# use with packadd and an autocommand in config to achieve lazy loading
      optionalPlugins = {
        customPlugins = with pkgs.nixCatsBuilds; [ ];
        gitPlugins = with pkgs.neovimPlugins; [ ];
        general = with pkgs.vimPlugins; [ ];
      };

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
        general = with pkgs; [
          # libgit2
        ];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
        test = {
          CATTESTVAR = "It worked!";
        };
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        test = [
          '' --set CATTESTVAR2 "It worked again!"''
        ];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      extraPython3Packages = {
        test = (_:[]);
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
        test = [ (_:[]) ];
      };
    };



    # And then build a package with specific categories from above here:
    # All categories you wish to include must be marked true,
    # but false may be omitted.
    # This entire set is also passed to nixCats for querying within the lua.

    # see :help nixCats.flake.outputs.packageDefinitions
    packageDefinitions = {
      # These are the names of your packages
      # you can include as many as you wish.
      nixCats = {pkgs , ... }: {
        # they contain a settings set defined above
        # see :help nixCats.flake.outputs.settings
        settings = {
          wrapRc = true;
          # IMPORTANT:
          # you may not alias to nvim
          # your alias may not conflict with your other packages.
          aliases = [ "nv" ];
          # caution: this option must be the same for all packages.
          # or at least, all packages that are to be installed simultaneously.
          neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
        };
        # and a set of categories that you want
        # (and other information to pass to lua)
        categories = {
          lazy = true;
          general = true;
          gitPlugins = true;
          customPlugins = true;
          generalBuildInputs = true;

          # colors
          themer = true;
          colorscheme = "catppuccin";
        };
      };
    };
  # In this section, the main thing you will need to do is change the default package name
  # to the name of the packageDefinitions entry you wish to use as the default.
    defaultPackageName = "nixCats";
  in


  # see :help nixCats.flake.outputs.exports
  forEachSystem (system: let
    inherit (utils) baseBuilder;
    customPackager = baseBuilder luaPath {
      inherit nixpkgs system dependencyOverlays extra_pkg_config;
    } categoryDefinitions;
    nixCatsBuilder = customPackager packageDefinitions;
    # this is just for using utils such as pkgs.mkShell
    # The one used to build neovim is resolved inside the builder
    # and is passed to our categoryDefinitions and packageDefinitions
    pkgs = import nixpkgs { inherit system; };
  in
  {
    # these outputs will be wrapped with ${system} by utils.eachSystem

    # this will make a package out of each of the packageDefinitions defined above
    # and set the default package to the one named here.
    packages = utils.mkPackages nixCatsBuilder packageDefinitions defaultPackageName;

    # choose your package for devShell
    # and add whatever else you want in it.
    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ (nixCatsBuilder defaultPackageName) ];
        inputsFrom = [ ];
        shellHook = ''
        '';
      };
    };

    # To choose settings and categories from the flake that calls this flake.
    # and you export overlays so people dont have to redefine stuff.
    inherit customPackager;
  }) // {

    # these outputs will be NOT wrapped with ${system}

    # this will make an overlay out of each of the packageDefinitions defined above
    # and set the default overlay to the one named here.
    overlays = utils.makeOverlays luaPath {
      # we pass in the things to make a pkgs variable to build nvim with later
      inherit nixpkgs dependencyOverlays extra_pkg_config;
      # and also our categoryDefinitions
    } categoryDefinitions packageDefinitions defaultPackageName;

    # we also export a nixos module to allow configuration from configuration.nix
    nixosModules.default = utils.mkNixosModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions nixpkgs;
    };
    # and the same for home manager
    homeModule = utils.mkHomeModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions nixpkgs;
    };
    # now we can export some things that can be imported in other
    # flakes, WITHOUT needing to use a system variable to do it.
    # and update them into the rest of the outputs returned by the
    # eachDefaultSystem function.
    inherit utils categoryDefinitions packageDefinitions dependencyOverlays;
    inherit (utils) templates baseBuilder;
    keepLuaBuilder = utils.baseBuilder luaPath;
  };

}
