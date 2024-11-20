return {
    "nvim-treesitter/nvim-treesitter",
    name = "treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            additional_vim_regex_highlighting = false,
            ensure_installed = {
                "c",
                "lua",
                "vim",
                "vimdoc",
                "sql",
                "rust",
                "go",
                "javascript",
                "css",
                "html",
                "bash",
                "markdown",
                "python",
                "toml",
                "csv",
                "xml",
                "yaml"
            },
        })
    end
}
