-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable mouse. It will be only for highlighting, however it will not change cursor position
vim.opt.mouse = ''

-- Check if lazy.nvim is installed
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end

-- Add lazy to the `runtimepath`.
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Set up lazy, and load my `lua/custom/plugins/` folder
require("lazy").setup({
    import = "custom.plugins",
    change_detection = { notify = false },
    defaults = {
        prompt_prefix = ">> ",
        lazy = false,
    },
    -- Set colorscheme for installation UI
    install = { colorscheme = { "kanagawa-dragon", "tokionight" } },
    -- Enable automatic updates
    checker = { enabled = true, notify = false },
    -- disable LuaRocks
    rocks = {
        hererocks = true,
        enabled = false,
    },
})

require "custom"

-- Set colorscheme
--vim.cmd("colorscheme kanagawa-wave")
--vim.cmd("colorscheme kanagawa-dragon")
--vim.cmd("colorscheme tokyonight-night")
--vim.cmd("colorscheme tokyonight-moon")
--vim.cmd("colorscheme tokyonight-storm")
--vim.cmd("colorscheme catppuccin-frappe")
vim.cmd("colorscheme catppuccin-macchiato")
--vim.cmd("colorscheme catppuccin-mocha")
