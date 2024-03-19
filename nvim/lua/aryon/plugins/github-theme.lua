return {
    "projekt0n/github-nvim-theme",
    enabled = true,
    lazy = false,
    config = function()
        require("github-theme").setup({
            groups = {
                all = {
                    IlluminatedWordText = { link = "CursorLine" },
                    IlluminatedWordRead = { link = "CursorLine" },
                    IlluminatedWordWrite = { link = "CursorLine" },

                    LspInfoBorder = { link = "FloatBorder" },
                    LspCodeLens = { link = "DiagnosticsHint" },

                    NonText = { link = "Whitespace" },
                    GitSignsCurrentLineBlame = { link = "Comment" },
                },
            },
        })
        vim.cmd("colorscheme github_dark_dimmed")
    end,
}
