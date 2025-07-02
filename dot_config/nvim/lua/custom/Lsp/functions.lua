local M = {}

M.lsp = require 'lspconfig'

M.capabilities = require('cmp_nvim_lsp').default_capabilities()

M.on_attach = function(client, bufnr)
    local function buf_set_option(option, value)
        vim.api.nvim_set_option_value(option, value, { buf = bufnr })
    end
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    require 'lsp_signature'.on_attach({
        bind = true,
        hint_enabled = true,
        hi_parameter = "LspSignatureActiveParameter",
        floating_window = true,
        fix_pos = true,
    })

    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client.server_capabilities.document_highlight then
        vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.document_highlight()
                vim.diagnostic.setloclist({ open = false }) -- Update location list
            end
        })
    end

    --Mappings for lsp
    local opts = { buffer = bufnr, noremap = true, silent = true }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
        vim.tbl_extend('force', opts, { desc = "LSP: Jumps to the declaration of the symbol under the cursor" }))

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
        vim.tbl_extend('force', opts, { desc = "LSP: Jumps to the definition of the symbol under the cursor" }))

    vim.keymap.set('n', 'K', vim.lsp.buf.hover,
        vim.tbl_extend('force', opts, { desc = "LSP: Display hove information about the symbol under the cursor" }))

    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
        vim.tbl_extend('force', opts,
            { desc = "LSP: Lists all the implementations for the symbol under the cursor in the quickfix window" }))

    vim.keymap.set('n', '<C-S-K>', vim.lsp.buf.signature_help,
        vim.tbl_extend('force', opts,
            { desc = "LSP: Displays signature information about the symbol under the cursor in a floating window" }))

    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder,
        vim.tbl_extend('force', opts, { desc = "LSP: Add the folder at path to the workspace folders" }))

    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
        vim.tbl_extend('force', opts, { desc = "LSP: Remove the folder at path from the workspace folders" }))

    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, vim.tbl_extend('force', opts, { desc = "LSP: List workspace folders" }))

    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition,
        vim.tbl_extend('force', opts,
            { desc = "LSP: Jumps to the definition of the type of the symbol under the cursor" }))

    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,
        vim.tbl_extend('force', opts, { desc = "LSP: Renames all references to the symbol under the cursor" }))

    vim.keymap.set('n', 'gr', vim.lsp.buf.references,
        vim.tbl_extend('force', opts,
            { desc = "LSP: Lists all the references to the symbol under the cursor in the quickfix window" }))

    vim.keymap.set('n', '<leader>K', vim.diagnostic.open_float,
        vim.tbl_extend('force', opts, { desc = "LSP: Show diagnostics in a floating window" }))

    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,
        vim.tbl_extend('force', opts, { desc = "LSP: Add buffer diagnostics to the location list" }))

    vim.keymap.set('n', '<leader><leader>f', vim.cmd.LspFormat,
        vim.tbl_extend('force', opts, { desc = "Format if LSP supports it" }))

    vim.keymap.set('n', '<leader>dh', function()
        local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
        vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = 0 })
    end, vim.tbl_extend('force', opts, { desc = "Toggle inlay_hints" }))
end

-- Auto format if LSP supports it
vim.api.nvim_create_user_command('LspFormat', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    local should_format = false

    for _, client in ipairs(clients) do
        if client.server_capabilities.documentFormattingProvider or client.server_capabilities.documentRangeFormattingProvider then
            should_format = true
            break
        end
    end

    if should_format then
        vim.lsp.buf.format({ bufnr = bufnr })
    end
end, { force = true, desc = "Save and auto-format if LSP supports it" })

-- Set up diagnostics config
vim.diagnostic.config({
    virtual_text = true,
    --virtual_lines = true,
    float = {
        source = true,
        border = "rounded"
    }
})

-- Auto-Format before save
vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
        vim.cmd.LspFormat()
    end
})

M.load_env = function()
    return function(project_path)
        local env_path = project_path .. "/.env"
        local file = io.open(env_path, "r")
        if not file then
            vim.notify("No \".env\" file found.", vim.log.levels.ERROR)
            return
        end

        for line in file:lines() do
            local k, v = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$") -- Wtf is this regex?
            if k and v and v ~= "" and not v:match("^#") then
                -- Remove surround quotes
                v = v:gsub("^['\"]", ""):gsub("['\"]$", "")
                vim.fn.setenv(k, v)
            end
        end

        file:close()
    end
end

return M
