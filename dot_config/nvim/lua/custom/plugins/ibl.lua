return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
        scope = {
            enabled = true,
            show_start = false,
            show_end = false,
            show_exact_scope = true,
            injected_languages = true,
            include = {
                node_type = {
                    ["*"] = { "comment" },
                    rust = {
                        "identifier",
                        "let_declaration",
                    },
                },
            },
        },
    },
}
