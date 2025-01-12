return {
    "stevearc/aerial.nvim",
    enabled = true,
    event = require("utils.lazy").events_presets.LazyFile,
    config = function()
        local bmap = require("utils.vim").set_buffer_keymap
        local c = require("aryon.config").keymaps

        require("aerial").setup({
            -- Priority list of preferred backends for aerial.
            -- This can be a filetype map (see :help aerial-filetype-map)
            backends = { "lsp", "treesitter", "markdown", "man" },
            icons = require("share.icons").lsp_kind,
            filter_kind = {
                -- "Array",
                -- "Boolean",
                "Class",
                -- "Constant",
                -- "Constructor",
                -- "Enum",
                -- "EnumMember",
                -- "Event",
                -- "Field",
                -- "File",
                "Function",
                "Interface",
                -- "Key",
                "Method",
                -- "Module",
                -- "Namespace",
                -- "Null",
                -- "Number",
                -- "Object",
                -- "Operator",
                -- "Package",
                -- "Property",
                -- "String",
                -- "Struct",
                -- "TypeParameter",
                -- "Variable",
            },
            -- -- Call this function when aerial attaches to a buffer.
            -- -- Useful for setting keymaps. Takes a single `bufnr` argument.
            on_attach = function(bufnr)
                bmap({ "<leader>a", "<cmd>AerialToggle!<CR>", desc = "[Aerial] Toggle" }, bufnr)
                bmap({ c.motion.buffer.aerial_prev, "<cmd>AerialPrev<CR>", desc = "[Aerial] Previous" }, bufnr)
                bmap({ c.motion.buffer.aerial_next, "<cmd>AerialNext<CR>", desc = "[Aerial] Next" }, bufnr)
            end,
        })
    end,
}
