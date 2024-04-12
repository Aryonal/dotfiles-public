local common_opts = {
    lazy = false,
    init = function()
        require("utils.vim").create_autocmd({
            events = { "ColorScheme" },
            group_name = "aryon/colorscheme.lua",
            desc = "Link EndOfBuffer to NonText",
            callback = function()
                vim.cmd([[
                    hi! link EndOfBuffer NonText
                    hi! link NormalFloat Normal
                ]])
            end,
        })
    end,
}
local plugins = {
    {
        "gbprod/nord.nvim",
        enabled = false,
        config = function()
            require("nord").setup({
                on_highlights = function(hl, c)
                    hl.WinSeparator = { fg = c.polar_night.brighter }

                    local darken = require("nord.utils").darken
                    local amount = 0.20
                    local green = darken(c.aurora.green, amount, c.default_bg)
                    local yellow = darken(c.aurora.yellow, amount, c.default_bg)
                    local red = darken(c.aurora.red, amount, c.default_bg)
                    local arctic_water = darken(c.frost.artic_water, 0.4, c.default_bg)

                    hl.DiffAdd = { bg = green }
                    hl.DiffChange = { bg = yellow }
                    hl.DiffDelete = { fg = c.snow_storm.origin, bg = red }
                    hl.DiffText = { fg = c.snow_storm.origin, bg = arctic_water }
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
    },
    {
        "ellisonleao/gruvbox.nvim",
        config = function()
            require("gruvbox").setup({})
            vim.cmd("colorscheme gruvbox")
        end,
    },
}

for i, plugin in ipairs(plugins) do
    plugins[i] = require("utils.lua").merge_tbl(plugin, common_opts)
end

return plugins
