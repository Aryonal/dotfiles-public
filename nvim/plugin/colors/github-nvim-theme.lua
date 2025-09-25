local ok, github_theme = pcall(require, "github-theme")
if not ok then
    return
end

github_theme.setup({
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
            PmenuKind = { link = "NormalFloat" },
        },
    },
})

vim.cmd("colorscheme github_dark_dimmed")

Config.plugin_blink_cfg = {
    custom_ui = {
        enabled = true,
        border = "rounded",
        winhighlight = "NormalFloat:NormalFloat,Normal:Normal,FloatBorder:FloatBorder",
    }
}
