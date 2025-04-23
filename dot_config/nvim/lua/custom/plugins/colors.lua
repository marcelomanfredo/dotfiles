return {
    {
        --Kanagawa
        "rebelot/kanagawa.nvim",
        lazy = false,
        name = "kanagawa",
        priority = 1000,
        opts = {},
    },
    {
        -- Tokionight
        "folke/tokyonight.nvim",
        name = "tokyonight",
        lazy = false,
        opts = {},
    },
    {
        "catppuccin/nvim", --machiatto
        name = "catppuccin",
        lazy = false,
        opts = {},
        config = function()
            require('catppuccin').setup({
                transparent_background = true,
                show_end_of_buffer = true,
                --term_colors = true,
            })
        end
    },
}
