return {
    "stevearc/aerial.nvim",
    dependencies = {
        "onsails/lspkind.nvim",
    },
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
        local bmap = require("utils.keymap").set_buffer
        local c = require("aryon.config").keymaps

        require("aerial").setup({
            -- Priority list of preferred backends for aerial.
            -- This can be a filetype map (see :help aerial-filetype-map)
            backends = { "lsp", "treesitter", "markdown", "man" },
            filter_kind = {
                "Array",
                "Boolean",
                "Class",
                "Constant",
                "Constructor",
                "Enum",
                "EnumMember",
                "Event",
                "Field",
                "File",
                "Function",
                "Interface",
                "Key",
                "Method",
                "Module",
                "Namespace",
                "Null",
                "Number",
                "Object",
                "Operator",
                "Package",
                "Property",
                "String",
                "Struct",
                "TypeParameter",
                "Variable",
            },
            -- -- Call this function when aerial attaches to a buffer.
            -- -- Useful for setting keymaps. Takes a single `bufnr` argument.
            on_attach = function(bufnr)
                -- Toggle the aerial window with <leader>a
                bmap({
                    key = "<leader>a",
                    cmd = "<cmd>AerialToggle!<CR>",
                    desc = "[Aerial] Toggle",
                }, bufnr)
                -- Jump forwards/backwards with '{' and '}'
                bmap({
                    key = c.motion.buffer.aerial_previous,
                    cmd = "<cmd>AerialPrev<CR>",
                    desc = "[Aerial] Previous",
                }, bufnr)
                bmap({
                    key = c.motion.buffer.aerial_next,
                    cmd = "<cmd>AerialNext<CR>",
                    desc = "[Aerial] Next",
                }, bufnr)
                -- -- Jump up the tree with '[[' or ']]'
                -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '[[', '<cmd>AerialPrevUp<CR>', {})
                -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ']]', '<cmd>AerialNextUp<CR>', {})
            end,
        })
    end,
}
