return {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    config = function()
        vim.lsp.config("rust_analyzer", {
            root_markers = {
                ".git",
                ".gitignore",
                "Cargo.toml",
                "Cargo.lock",
            },
        })
    end,
}
