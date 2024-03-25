local common_opts = {
    lazy = false,
}
local plugins = {
    {
        "gbprod/nord.nvim",
        enabled = true,
        config = function()
            require("nord").setup({
                ---@diagnostic disable-next-line: unused-local
                on_highlights = function(highlights, colors)
                    highlights.NulllsInfoBorder = { link = "FloatBorder" }
                    highlights.LspInfoBorder = { link = "FloatBorder" }
                    highlights.GitSignsCurrentLineBlame = { link = "Comment" }
                end,
            })
            vim.cmd.colorscheme("nord")
        end,
    },
    {
        "projekt0n/github-nvim-theme",
        enabled = false,
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
}

for i, plugin in ipairs(plugins) do
    plugins[i] = require("utils.lua").merge_tbl(plugin, common_opts)
end

return plugins
