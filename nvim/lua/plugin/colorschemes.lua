local common_opts = {
    lazy = false,
    priority = 1000,
}
local themes = {
    {
        -- Issues
        -- - inactive statusline cannot be distinguished from normal background for lualine statusline
        -- - statusline is linked to Normal, make it difficult to distinguish for lualine
        "projekt0n/github-nvim-theme",
        config = function()
            require("github-theme").setup({
                options = {
                    hide_end_of_buffer = false,
                    hide_nc_statusline = false,
                    dim_inactive = false,
                    darken = {
                        floats = false,
                    },
                    --- Examples:
                    ---     styles = {
                    ---         comments = 'italic',
                    ---         keywords = 'bold',
                    ---         types = 'italic,bold',
                    ---     }
                    styles = {
                        comments = "italic",
                        functions = "italic",
                        -- keywords = "NONE",
                        -- variables = "NONE",
                        -- conditionals = "NONE",
                        constants = "bold",
                        -- numbers = "NONE",
                        -- operators = "NONE",
                        -- strings = "italic",
                        -- types = "NONE",
                    },
                },
                groups = {
                    all = {
                        -- NormalFloat = { link = "Normal", },
                        -- Pmenu = { link = "NormalFloat", },
                        -- PmenuSel = { link = "Visual", },
                        TelescopeBorder = { link = "FloatBorder" },
                        TelescopePromptBorder = { link = "FloatBorder" },
                        TelescopeResultsBorder = { link = "FloatBorder" },
                        TelescopePreviewBorder = { link = "FloatBorder" },
                        TelescopePromptCounter = { link = "NormalFloat" },
                        StatusLineNC = { link = "CursorLine" },
                        BlinkCmpLabelMatch = { style = "bold,underline" },
                        PmenuMatch = { style = "bold,underline" },
                    },
                },
            })

            vim.cmd("colorscheme github_dark_dimmed")

            local cfg = require("config")
            cfg.plugins.blink.custom_ui.enabled = true
	    cfg.ui.float.lsp_float_border = "rounded"
        end
    },
    {
        -- Issues
        -- - too colorful
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup()
            vim.cmd("colorscheme tokyonight-night")
        end,
    },
    {
        -- Issues
        -- - LspReferenceText is not noticeable
        "ellisonleao/gruvbox.nvim",
        config = function()
            -- Default options:
            require("gruvbox").setup()
            vim.cmd("colorscheme gruvbox")
        end,
    },
    {
        -- Issues
        -- - telescope selection line is not highlighted
        -- - too yellow
        "thesimonho/kanagawa-paper.nvim",
        opts = {},
        config = function(opts)
            vim.cmd("colorscheme kanagawa-paper-ink")
        end
    },
    {
        -- Issues
        -- - inactive tabs are more emphasized than active for lualine tabline tabs, but fine for default
        "aryonal/kanagawa.nvim", -- patch origin to fix issue
        config = function(opts)
            ---@diagnostic disable-next-line: missing-fields
            require("kanagawa").setup({
                transparent = false,
                dimInactive = false,
                terminalColors = true,
                theme = "wave",    -- Load "wave" theme
                background = {     -- map the value of 'background' option to a theme
                    dark = "wave", -- try "dragon" !
                    light = "lotus"
                },
                overrides = function(colors)
                    return {
                        -- lualine_b_tabs_active = { link = "lualine_a_normal" },
                        -- lualine_b_tabs_inactive = { gui = "italic" },
                    }
                end,
            })
            vim.cmd("colorscheme kanagawa")
        end
    },
    {
        -- Issues
        -- - inactive tabs are not distinguished from active for lualine tabline tabs
        -- - inactive statusline is not distinguished from active for lualine statusline
        "echasnovski/mini.base16",
        version = "*",
        config = function(opts)
            local nord = {
                base00 = "#2E3440",
                base01 = "#3B4252",
                base02 = "#434C5E",
                base03 = "#4C566A",
                base04 = "#D8DEE9",
                base05 = "#E5E9F0",
                base06 = "#ECEFF4",
                base07 = "#8FBCBB",
                base08 = "#88C0D0",
                base09 = "#81A1C1",
                base0A = "#5E81AC",
                base0B = "#BF616A",
                base0C = "#D08770",
                base0D = "#EBCB8B",
                base0E = "#A3BE8C",
                base0F = "#B48EAD",
            }
            require("mini.base16").setup({
                palette = nord
            })

            -- vim.cmd("colorscheme minischeme") -- minicyan, minischeme
        end
    },
    {
        -- Issues
        -- - statusline hl is ugly for default
        -- - diff hl are too strong
        "gbprod/nord.nvim",
        config = function()
            require("nord").setup({
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = true },
                    keywords = {},
                    functions = { italic = true },
                    variables = {},
                },
            })
            vim.cmd.colorscheme("nord")
        end,
    },
    {
        -- Issues
        -- - Inactive window is more hihghlighted than active window
        -- - statusline hl for default is not distinguishable
        "EdenEast/nightfox.nvim",
        config = function()
            require("nightfox").setup({
                options = {
                    transparent = false,    -- Disable background transparency
                    terminal_colors = true, -- Enable terminal colors
                    dim_inactive = true,
                    styles = {
                        comments = "italic",
                        keywords = "bold",
                        functions = "italic,bold",
                        variables = "NONE",
                        conditionals = "NONE",
                        constants = "bold",
                        numbers = "NONE",
                        operators = "NONE",
                        strings = "italic",
                        types = "NONE",
                    },
                },
            })
            vim.cmd("colorscheme nordfox")
        end,
    },
    {
        "lifepillar/vim-solarized8",
        config = function()
            vim.cmd("colorscheme solarized8")
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("catppuccin").setup({
                show_end_of_buffer = true,
                background = {
                    light = "latte",
                    dark = "mocha",
                },
                custom_highlights = {
                    DiagnosticUnderlineOk = { style = { "undercurl" } },
                    DiagnosticUnderlineHint = { style = { "undercurl" } },
                    DiagnosticUnderlineInfo = { style = { "undercurl" } },
                    DiagnosticUnderlineWarn = { style = { "undercurl" } },
                    DiagnosticUnderlineError = { style = { "undercurl" } },
                },
            })
            vim.cmd("colorscheme catppuccin")

            local cfg = require("config")
            cfg.plugins.status.status_diagnostics = { style = true }
            cfg.plugins.blink.custom_ui.enabled = true
            cfg.ui.float.lsp_float_border = "rounded"
        end
    }
}

-- One of
-- - "projekt0n/github-nvim-theme"
-- - "folke/tokyonight.nvim"
-- - "ellisonleao/gruvbox.nvim"
-- - "thesimonho/kanagawa-paper.nvim"
-- - "aryonal/kanagawa.nvim"
-- - "echasnovski/mini.base16"
-- - "EdenEast/nightfox.nvim"
-- - "gbprod/nord.nvim"
-- - "lifepillar/vim-solarized8"
-- - "catppuccin/nvim"
local colorscheme = "projekt0n/github-nvim-theme"

for i, plugin in ipairs(themes) do
    themes[i] = vim.tbl_deep_extend("force", plugin, common_opts)
    themes[i].enabled = false
    if themes[i][1] == colorscheme then
        themes[i].enabled = true
    end
end

return themes
