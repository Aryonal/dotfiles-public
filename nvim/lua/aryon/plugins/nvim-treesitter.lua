return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        build = ":TSUpdate",
        event = { "BufReadPre", "BufWritePre", "BufNewFile", "VeryLazy" },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup({
                ensure_installed = "all",
                sync_install = false,
                ignore_install = { "phpdoc" },
                indent = { enable = true },
                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,
                    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
                    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
                    -- the name of the parser)
                    -- list of language that will be disabled
                    -- disable = { "go", "lua" }, -- use lsp
                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
                textobjects = {
                    select = {
                        enable = true,
                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = { query = "@function.outer", desc = "[TS] outer function" },
                            ["if"] = { query = "@function.inner", desc = "[TS] inner function" },
                            ["ab"] = { query = "@block.outer", desc = "[TS] outer block" },
                            ["ib"] = { query = "@block.inner", desc = "[TS] inner block" },
                            ["ac"] = { query = "@call.outer", desc = "[TS] outer call" },
                            ["ic"] = { query = "@call.inner", desc = "[TS] inner call" },
                        },
                        include_surrounding_whitespace = false,
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]f"] = { query = "@function.outer", desc = "[TS] Next function start" },
                        },
                        goto_next_end = {},
                        goto_previous_start = {
                            ["[f"] = { query = "@function.outer", desc = "[TS] Previous function start" },
                        },
                        goto_previous_end = {},
                        -- Below will go to either the start or the end, whichever is closer.
                        -- Use if you want more granular movements
                        -- Make it even more gradual by adding multiple queries and regex.
                        goto_next = {
                            ["]]"] = { query = "@block.*", desc = "[TS] Next block" },
                        },
                        goto_previous = {
                            ["[["] = { query = "@block.*", desc = "[TS] Previous block" },
                        },
                    },
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        enabled = false,
        -- REF: https://github.com/LazyVim/LazyVim/blob/50b7f426f287ecfc542dd9c197e430b0aca8af04/lua/lazyvim/plugins/treesitter.lua#L120
        -- event = "LazyFile",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        init = function()
            require("utils.vim").create_autocmd({
                events = { "ColorScheme" },
                group_name = "aryon/nvim-treesitter.lua",
                desc = "Link TreesitterContext to CursorLine",
                callback = function()
                    vim.cmd([[
                        hi! link TreesitterContext CursorLine
                    ]])
                end,
            })
        end,
        config = function()
            require("treesitter-context").setup({
                -- max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
                patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
                    -- For all filetypes
                    -- Note that setting an entry here replaces all other patterns for this entry.
                    -- By setting the 'default' entry below, you can control which nodes you want to
                    -- appear in the context window.
                    default = {
                        "class",
                        "function",
                        "method",
                        "for",
                        "while",
                        "if",
                        -- 'switch', -- this won't be used
                        -- 'case',
                    },
                },
            })
        end,
    },
}
