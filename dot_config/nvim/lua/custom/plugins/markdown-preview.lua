return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
        init = function()
            vim.g.mkdp_auto_start = 0      -- Automatically open preview when entering a Markdown buffer
            vim.g.mkdp_auto_close = 1      -- Automatically closes the preview window
            vim.g.mkdp_refresh_slow = 1    -- Sets refresh to occur only when leaving insert mode or saving buffer
            vim.g.mkdp_theme = 'dark'      -- Defaults the theme to dark, despite system configs
            vim.g.mkdp_browser = 'firefox' -- Sets firefox as the goto browser
        end,
    },
}
