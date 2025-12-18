return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    opts = {
        options = {
            theme = "pywal",
        },
        sections = {
            lualine_c = {
                {
                    'filename',
                    newfile_status = true,
                    path = 1,
                },
            },
            lualine_x = {
                {
                    'lsp_status',
                    icon = '󰿘 ',
                },
                'encoding',
                'fileformat',
                'filetype',
            },
        },
    },
}
