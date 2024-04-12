return {
    "folke/which-key.nvim",
    lazy = false,
    config = function()
        local wk = require("which-key")
        wk.setup({
            icons = {
                breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
                separator = " ", -- symbol used between a key and it's label
                group = "+", -- symbol prepended to a group
            },
            window = {
                -- border = require("aryon.config").ui.float.border,
                border = "none",
            },
        })
    end,
}
