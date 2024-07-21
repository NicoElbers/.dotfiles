{ lib, pkgs, config, inputs, ... }:

{
  config = {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;

      plugins = with pkgs.vimPlugins; [
        # lazy
        lazy-nvim

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

      extraPackages = with pkgs; [
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
        inputs.zls.packages.${pkgs.system}.zls
        rust-analyzer

        # Formatters
        prettierd
        stylua
        black
        rustfmt
        checkstyle
        languagetool-rust

        # latex
        texliveFull

        # Clipboard
        wl-clipboard-rs

      ];
    };

    home.sessionVariables = {
      NIXOS = "true";
    };

    xdg.configFile.nvim = 
    let
      plugins = config.programs.neovim.plugins;

      path_strs = builtins.map (plugin: "${plugin}") plugins;
      paths = builtins.concatStringsSep ";" path_strs;

      pname_strs = builtins.map (plugin: "${plugin.pname}") plugins;
      pname = builtins.concatStringsSep ";" pname_strs;

      version_strs = builtins.map (plugin: "${plugin.version}") plugins;

      paired_strs = lib.zipListsWith (a: b: a + "|" + b) pname_strs version_strs;
      tripple_strs = lib.zipListsWith (a: b: a + "|" + b) paired_strs path_strs;

      tripples = builtins.concatStringsSep ";" tripple_strs;

    in 
    {
      source = ./config;
      recursive = true;
      onChange = ''
        echo "${paths}" > /tmp/nvim.paths
        echo "${pname}" > /tmp/nvim.pnames
        echo "${tripples}" > /tmp/nvim.pairs
      '';
    };
  };
}
