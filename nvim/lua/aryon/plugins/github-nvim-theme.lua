return {
    "projekt0n/github-nvim-theme",
    enabled = false,
    lazy = false,
    config = function()
        require("github-theme").setup({
            groups = {
                all = {
                    -- trsnaparent float
                    NormalFloat = { link = "Normal" },
                    FloatBorder = { fg = "palette.fg.subtle" },
                    LspInfoBorder = { link = "FloatBorder" },
                    NulllsInfoBorder = { link = "FloatBorder" },
                    TelescopeBorder = { link = "FloatBorder" },

                    -- illuminate
                    IlluminatedWordText = { link = "CursorLine" },
                    IlluminatedWordRead = { link = "CursorLine" },
                    IlluminatedWordWrite = { link = "CursorLine" },

                    -- telescope
                    TelescopeTitle = { fg = "palette.fg.muted" },
                    TelescopePromptCounter = { fg = "palette.fg.muted" },

                    LspCodeLens = { link = "DiagnosticsHint" },

                    NonText = { link = "Whitespace" },
                    GitSignsCurrentLineBlame = { link = "Comment" },
                },
            },
        })
        vim.cmd("colorscheme github_dark_dimmed")
    end,
}
