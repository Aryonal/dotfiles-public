return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        -- border for LspInfo window
        -- REF: https://neovim.discourse.group/t/lspinfo-window-border/1566/2
        local win = require("lspconfig.ui.windows")
        win.default_options = {
            border = require("aryon.config").ui.float.border,
        }

        vim.cmd([[
            hi link LspInfoBorder FloatBorder
        ]])
    end,
}
