return {
    -- "catppuccin/nvim",
    dir = "/nix/store/858slzj3dig9v7w390kh4nyhzbspan1y-vimplugin-catppuccin-nvim-2024-06-27",
    name = "catppuccin",
    priority = 1000,
    config = function()
        -- colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
        vim.cmd.colorscheme("catppuccin-mocha")
    end,
}
