return {
    "jay-babu/mason-null-ls.nvim",
    enabled = false,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "nvimtools/none-ls.nvim",
    },
    config = function()
        require("mason-null-ls").setup({
            ensure_installed = {},
            automatic_installation = false,
            handlers = {},
        })

        -- setup null-ls
        local null_ls = require("null-ls")
        local lsp = require("aryon.lsp")

        local sources = {
            -- tools without local executable
            null_ls.builtins.completion.spell,
            null_ls.builtins.code_actions.gitsigns,
        }

        null_ls.setup({
            border = require("aryon.config").ui.float.border,
            -- on_attach = nil,
            on_attach = lsp.on_attach,
            sources = sources,
            diagnostics_format = "#{s}:#{c}: #{m}",
        })

        vim.cmd([[
            hi link NulllsInfoBorder FloatBorder
        ]])
    end,
}
