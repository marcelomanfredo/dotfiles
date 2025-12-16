local width = 120

-- No cursor overlay in Neovim
vim.opt.guicursor = ""

-- Lines
vim.opt.nu = true
vim.opt.rnu = true

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

vim.opt_local.textwidth = width

vim.opt_local.formatoptions:remove "o"

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8

vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = tostring(width)

vim.opt.list = true
vim.opt.listchars = {
    eol = '↲',
    tab = '»·',
    trail = '·',
    lead = '·',
    extends = '⟩',
    precedes = '⟨',
    nbsp = '˔',
    multispace = '␣'
}

-- Spell check - maybe there's a plugin for grammar?
vim.api.nvim_create_autocmd("FileType", {
    desc = "Enable vim's spell check on text files",
    group = vim.api.nvim_create_augroup("SpellCheck", { clear = true }),
    pattern = { "text", "markdown", "tex", "gitcommit" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en"
        vim.opt_local.spelloptions = "camel"
    end,
})

-- Remove trailing spaces
vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Remove trailing spaces at the end of the line before saving file",
    group = vim.api.nvim_create_augroup("PreWrite", { clear = true }),
    pattern = "*",
    command = [[ %s/\s\+$//e ]],
})

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight text when yanking",
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
