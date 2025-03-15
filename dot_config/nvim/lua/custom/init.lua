-- LSP
vim.lsp.set_log_level("error") --Options: "trace", "debug", "info", "warn", "error", "off"
require 'custom.Lsp.lsp_init'

-- Remaps
require 'custom.remap'

-- settings
require 'custom.settings'

--Undotree
if vim.fn.has("persistent_undo") == 1 then
    local target_path = vim.fn.expand("~/.undodir/")

    --Check if dir exists
    if vim.fn.isdirectory(target_path) == 0 then
        vim.fn.mkdir(target_path, "p", 0700)
    end

    vim.opt.undodir = target_path
    vim.opt.undofile = true
end
