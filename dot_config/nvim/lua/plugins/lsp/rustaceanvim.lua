return {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    config = function()
        vim.g.rustaceanvim = {
            tools = {
                float_win_config = {
                    source = "if_many",
                    border = "rounded",
                },
            },
            server = {
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                        },
                        workspace = {
                            symbol = {
                                search = {
                                    kind = "all_symbols",
                                    scope = "workspace_and_dependencies",
                                },
                            },
                        },
                    },
                },
            },
        }
        vim.lsp.config("rust-analyzer", {
            root_markers = {
                ".git/",
                ".gitignore",
                "Cargo.toml",
                "Cargo.lock",
            },
        })
    end,
}
