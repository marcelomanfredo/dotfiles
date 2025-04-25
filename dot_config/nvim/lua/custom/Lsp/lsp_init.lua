local fn = require 'custom.Lsp.functions'

local lsp = fn.lsp
local on_attach = fn.on_attach
local capabilities = fn.capabilities

-- Lua
lsp.lua_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "lua" },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                },
            },
        }
    }
}

-- Rust
lsp.rust_analyzer.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "rust" },
    settings = {
        ["rust_analyzer"] = {
            checkOnSave = {
                command = "clippy",
            },
            diagnostics = {
                enable = true,
                experimental = {
                    enable = true,
                },
            },
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                allFeatures = true,
            },
            procMacro = {
                enable = true,
            },
        },
    },
}

-- Go
lsp.gopls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "go" },
}

-- C and C++
lsp.clangd.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "c", "cpp", "objc", "objcpp" },
}

-- Python
lsp.basedpyright.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "python" },
}

-- Emmet
lsp.emmet_language_server.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "html", "css", "scss", "javascript", "typescript" },
}
