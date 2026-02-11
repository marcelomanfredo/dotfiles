return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "cmp",
        "mason",
        {
            "mason-org/mason-lspconfig.nvim",
            opts = {
                automatic_enable = {
                    exclude = {
                        "stylua",
                    },
                },
                ensure_installed = {
                    "lua_ls",
                    --"rust_analyzer",
                    "gopls",
                    "clangd",
                },
            },
        },
    },
    config = function()
        -- call on_attach autocmd
        require("plugins.lsp.utils.attach")

        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local servers = {
            lua_ls = { filetypes = { "lua" } },
            gopls = { filetypes = { "go", "gomod", "gowork", "gotmpl" } },
            clangd = { filetypes = { "c", "cpp", "objc", "objcpp" } },
            bashls = { filetypes = { "sh", "bash" } },
            basedpyright = { filetypes = { "python" } },
            emmet_language_server = { filetypes = { "html", "css", "scss" } },
            taplo = { filetypes = { "toml" } },
            ts_ls = { filetypes = { "javascript", "typescript" } },
        }

        for name, cfg in pairs(servers) do
            cfg.capabilities = capabilities
            cfg.root_markers = { ".git" }
            vim.lsp.config(name, cfg)
        end

        -- [[ Server configs ]]
        -- Lua
        vim.lsp.config("lua_ls", {
            cmd = { "lua-language-server" },
            root_markers = {
                ".luarc.json",
                ".luarc.jsonc",
                ".luacheckrc",
                ".stylua.toml",
                "stylua.toml",
                ".git",
            },
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME,
                        },
                    },
                },
            },
        })

        -- Rust: rustaceanvim
    end,
}
