return {
    "nvim-telescope/telescope.nvim",
    name = "telescope",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-tree/nvim-web-devicons",
            opts = {},
            lazy = true,
        },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            name = "telescope-fzf",
            build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install",
            lazy = true,
        },
    },
    opts = {
        extensions = {
            fzf = {},
        },
        defaults = {
            prompt_prefix = " ",
            path_display = {
                shorten = 2,
                truncate = 3,
            },
            file_ignore_patterns = {
                "node_modules",
                ".git",
                ".venv",
            },
        },
    },
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("fzf")
        local builtin = require("telescope.builtin")
        local theme = require("telescope.themes")
        local cwd = vim.fn.expand("%:p:h")

        local function is_git_dir(cwd)
            local p = vim.fn.finddir(".git", cwd .. ";/home")
            if p ~= "" then
                return true
            end
            vim.notify(cwd .. " is not a git directory", vim.log.levels.ERROR)
            return false
        end

        -- [[ KEYMAPS ]]
        vim.keymap.set("n", "<leader>/", function()
            builtin.current_buffer_fuzzy_find({
                sorting_strategy = "ascending",
                previewer = false,
                layout_config = {
                    prompt_position = "top",
                },
            })
        end, { desc = "Telescope -> Search in current buffer" })

        vim.keymap.set("n", "<leader>fw", builtin.find_files, { desc = "Telescope -> Find files" })
        vim.keymap.set("n", "<leader>fW", function()
            builtin.find_files({ cwd = cwd })
        end, { desc = "Telescope -> Find files in the buffer directory" })

        vim.keymap.set("n", "<leader>ff", function()
            builtin.find_files({ hidden = true, no_ignore = true })
        end, { desc = "Telescope -> Find hidden and ignored (git) files" })
        vim.keymap.set("n", "<leader>fF", function()
            builtin.find_files({ cwd = cwd, hidden = true, no_ignore = true })
        end, { desc = "Telescope -> Find hidden and ignored (git) files in the buffer directory" })

        vim.keymap.set("n", "<leader>fg", function()
            local b = is_git_dir(cwd)
            if b then
                builtin.git_files()
            end
        end, { desc = "Telescope -> Find files in the current git repository" })
        vim.keymap.set("n", "<leader>gpc", function()
            local b = is_git_dir(cwd)
            if b then
                builtin.git_commits()
            end
        end, {
            desc = "Telescope -> Find project commits [`<C-r>` checkout | `<C-r>m` mixed | `<C-r>s` soft | `<C-r>h` hard]",
        })
        vim.keymap.set("n", "<leader>gbc", function()
            local b = is_git_dir(cwd)
            if b then
                builtin.git_bcommits()
            end
        end, {
            desc = "Telescope -> Find buffer commits [`<C-r>` checkout | <C-v>` vsplit diff | <C-x>` hsplit diff | <C-t>` tab diff]",
        })

        vim.keymap.set("n", "<leader>rg", function()
            builtin.live_grep({ cwd = cwd })
        end, { desc = "Telescope -> Grep a string in the buffer directory" })
        vim.keymap.set("n", "<leader>rG", builtin.live_grep, { desc = "Telescope -> Grep string" })

        vim.keymap.set("n", "<leader>gr", function()
            local w = vim.fn.expand("<cword>")
            builtin.grep_string({ search = vim.fn.input("Grep>> ", w) })
        end, { desc = "Telescope -> Search word under the cursor/selection" })
        vim.keymap.set("n", "<leader>gR", function()
            local w = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = vim.fn.input("Grep>> ", w) })
        end, { desc = "Telescope -> Search WORD under the cursor/selection" })

        vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope -> Search keymaps" })

        vim.keymap.set("n", "<leader>fc", function()
            local config_dir = vim.fn.expand("~/.local/share/chezmoi/dot_config")
            builtin.find_files({ cwd = config_dir })
        end, { desc = "Telescope -> Find dotfiles [chezmoi]" })

        vim.keymap.set("n", "<leader>st", function()
            builtin.help_tags({
                layout_config = {
                    preview_width = 0.7,
                },
            })
        end, { desc = "Telescope -> Search help tags" })

        vim.keymap.set("n", "<leader>sm", function()
            builtin.man_pages({
                layout_config = {
                    preview_width = 0.7,
                },
            })
        end, { desc = "Telescope -> Search man pages" })

        vim.keymap.set("n", "<leader>sh", function()
            builtin.search_history(theme.get_dropdown())
        end, { desc = "Telescope -> list recent searches and re-execute them" })

        vim.keymap.set("n", "<leader>z", function()
            builtin.spell_suggest(theme.get_cursor())
        end, { desc = "Display spell suggestion for word under the cursor" })
    end, -- end config
}
