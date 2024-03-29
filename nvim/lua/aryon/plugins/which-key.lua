return {
    "folke/which-key.nvim",
    lazy = false,
    config = function()
        local wk = require("which-key")
        wk.setup({
            window = {
                -- border = require("aryon.config").ui.float.border,
                border = "none",
            },
        })
    end,
}
