return {
    "onsails/lspkind.nvim",
    config = function()
        require("lspkind").init({
            -- default symbol map
            -- can be either 'default' (requires nerd-fonts font) or
            -- 'codicons' for codicon preset (requires vscode-codicons font)
            --
            -- default: 'default'
            preset = "codicons",
            symbol_map = {
                Copilot = "",
            },
        })
        vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    end,
}
