return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
        scope = {
            show_start = false,
            show_end = false,
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
