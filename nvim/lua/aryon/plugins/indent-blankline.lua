return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
        vim.opt.list = true
        vim.opt.listchars:append("space:⋅")
        vim.opt.listchars:append("eol:↴")

        require("ibl").setup({
            -- -- show_end_of_line = true,
            -- space_char_blankline = " ", -- char fill between indentlines for blank line, :13 for example
            -- show_current_context = true,
            -- show_current_context_start = true,
            -- char_highlight_list = {
            --     "IndentBlanklineIndent",
            -- },
            -- space_char_highlight_list = {
            --     "IndentBlanklineIndent",
            -- },
        })

        -- Overrides color-schemes
        -- local function f()
        --     vim.cmd([[
        --         hi link IndentBlanklineIndent Whitespace
        --     ]])
        -- end

        -- f()

        -- local au = require("utils.autocmd")

        -- au.create_autocmd({
        --     events = { "ColorScheme" },
        --     group_name = "aryon/plugin/ui/indent-blankline.lua",
        --     desc = "Override highlight groups",
        --     callback = function()
        --         f()
        --     end,
        -- })
    end,
}
