return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "telescope-fzf",
        "plenary",
    },
    config = function()
        require("custom.plugins-config.telescope")
    end,
}
