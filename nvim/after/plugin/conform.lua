local ok, conform = pcall(require, "conform")
if not ok then
    return
end

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" -- for `gq`

vim.keymap.set(
    { "n", "v" },
    "<leader>f",
    function()
        require("conform").format({ lsp_format = "prefer", async = true, undojoin = true })
    end,
    {
        desc = "[Conform] Format",
    }
)

conform.setup({
    -- Map of filetype to formatters
    formatters_by_ft = {
        kotlin = { "ktlint", lsp_format = "never" },
        python = { "black", "isort", "autoflake", "ruff_fix", "ruff_format", "ruff_organize_imports", lsp_format = "never" },
        json   = { "jq", "fixjson", lsp_format = "never" },
        go     = { "gofumpt", "goimports-reviser", lsp_format = "never" },
        zsh    = { "beautysh", lsp_format = "never" },
        sh     = { "shfmt", lsp_format = "never" },
        yaml   = { "yamlfmt", lsp_format = "never" },
    }
})
