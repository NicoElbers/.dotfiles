-- Load the things
require("options")
require("keymaps")
require("autocmds")

require("nixCatsUtils").setup({
    non_nix_value = true,
})

local pluginList = nil
local nixLazyPath = nil
if require("nixCatsUtils").isNixCats then
    local allPlugins = require("nixCats").pawsible.allPlugins
    pluginList = require("nixCatsUtils.lazyCat").mergePluginTables(allPlugins.start, allPlugins.opt)

    nixLazyPath = allPlugins.start[ [[lazy.nvim]] ]

    pluginList[ [[Comment.nvim]] ] = ""
    pluginList[ [[LuaSnip]] ] = ""
    pluginList[ [[catppuccin]] ] = ""
end

local lazyOptions = {
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
}

require("nixCatsUtils.lazyCat").setup(pluginList, nixLazyPath, "plugins", lazyOptions)
-- require("nixCatsUtils.lazyCat").setup(pluginList, nixLazyPath, {}, lazyOptions)
