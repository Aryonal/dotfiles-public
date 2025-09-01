return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
    opts = {
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = " ",  -- symbol used between a key and it's label
            group = "+",      -- symbol prepended to a group
        },
        win = {
            -- border = require("config").ui.float.border,
            border = require("config").ui.float.border,
        },
    },
}
