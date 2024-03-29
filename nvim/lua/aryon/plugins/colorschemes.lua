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
                on_highlights = function(highlights, c)
                    highlights.NulllsInfoBorder = { link = "FloatBorder" }
                    highlights.LspInfoBorder = { link = "FloatBorder" }
                    highlights.GitSignsCurrentLineBlame = { link = "Comment" }
                    -- diff
                    local darken = require("nord.utils").darken
                    local amount = 0.20
                    local green = darken(c.aurora.green, amount, c.default_bg)
                    local yellow = darken(c.aurora.yellow, amount, c.default_bg)
                    local red = darken(c.aurora.red, amount, c.default_bg)
                    local arctic_water = darken(c.frost.artic_water, 0.4, c.default_bg)

                    highlights.DiffAdd = { bg = green }
                    highlights.DiffChange = { bg = yellow }
                    highlights.DiffDelete = { fg = c.snow_storm.origin, bg = red }
                    highlights.DiffText = { fg = c.snow_storm.origin, bg = arctic_water }
                end,
            })
            vim.cmd.colorscheme("nord")
        end,
    },
    {
        "projekt0n/github-nvim-theme",
        enabled = false,
        config = function()
            local theme = "github_dark_dimmed"

            -- local spec = require("github-theme.spec").load(theme)

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

                        -- diff
                        -- DiffAdd = { bg = spec.diff.add },
                        -- DiffChange = { bg = spec.diff.change },
                        -- DiffDelete = { fg = spec.diff.delete, bg = spec.diff.delete },
                        -- DiffText = { bg = spec.diff.text },
                    },
                },
            })
            vim.cmd("colorscheme " .. theme)
        end,
    }
}

for i, plugin in ipairs(plugins) do
    plugins[i] = require("utils.lua").merge_tbl(plugin, common_opts)
end

return plugins
