local common_opts = {
    lazy = false,
    priority = 1000,
    init = function()
        require("utils.vim").create_autocmd({
            events = { "ColorScheme" },
            group_name = "aryon/colorscheme.lua",
            desc = "Link EndOfBuffer to NonText",
            callback = function()
                vim.cmd([[
                    hi! link EndOfBuffer NonText
                    hi! link NormalFloat Normal
                    hi! link LspCodeLens DiagnosticInfo
                ]])
            end,
        })
    end,
}
local themes = {
    {
        "catppuccin/nvim",
        enabled = true,
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                flavour = "frappe",
            })

            vim.cmd.colorscheme "catppuccin"
        end,
    },
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
        "ellisonleao/gruvbox.nvim",
        enabled = false,
        config = function()
            require("gruvbox").setup({})
            vim.cmd("colorscheme gruvbox")
        end,
    },
    {
        "projekt0n/github-nvim-theme",
        enabled = false,
        config = function()
            require("github-theme").setup({})

            vim.cmd("colorscheme github_dark_dimmed")
        end
    },
}

for i, plugin in ipairs(themes) do
    themes[i] = vim.tbl_deep_extend("force", plugin, common_opts)
end

return themes
