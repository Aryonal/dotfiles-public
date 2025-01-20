local common_opts = {
    lazy = false,
    priority = 1000,
    init = function()
        vim.cmd([[
            hi! link EndOfBuffer NonText
            hi! link NormalFloat Normal
            hi! link LspCodeLens DiagnosticInfo
        ]])
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
        "projekt0n/github-nvim-theme",
        enabled = true,
        config = function()
            require("github-theme").setup({
                options = {
                    hide_nc_statusline = false,
                },
            })

            vim.cmd("colorscheme github_dark_dimmed")
            -- vim.cmd("colorscheme github_light_default")
        end
    },
    {
        "folke/tokyonight.nvim",
        enabled = false,
        config = function()
            require("tokyonight").setup()
            vim.cmd("colorscheme tokyonight-night")
        end,
    },
}

for i, plugin in ipairs(themes) do
    themes[i] = vim.tbl_deep_extend("force", plugin, common_opts)
end

return themes
