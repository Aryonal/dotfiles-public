return {
    "folke/which-key.nvim",
    lazy = false,
    -- cmd = {
    --     "WhichKey",
    -- },
    config = function()
        local wk = require("which-key")
        wk.setup({
            window = {
                border = require("aryon.config").ui.float.border,
            },
        })
    end,
}
