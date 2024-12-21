---Use conform for Minimal format diffs,
---Use other tools to manage tools.
return {
    "stevearc/conform.nvim",
    init = function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" -- for `gq`
    end,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            require("aryon.config").keymaps.lsp.format,
            function()
                require("conform").format({ lsp_fallback = true, async = true, undojoin = true })
            end,
            mode = { "n", "v" },
            desc = "[Conform] Format",
        },
    },
    config = function()
        require("conform").setup({
            -- Map of filetype to formatters
            formatters_by_ft = {
                kotlin = { "ktlint", lsp_format = "never" },
                python = { "black", "isort", "autoflake", lsp_format = "never" },
                json = { "jq", "fixjson", lsp_format = "never" },
            }
        })
    end
}
