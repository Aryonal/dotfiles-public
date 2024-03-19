return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
        require("nvim-treesitter.configs").setup({
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
                    -- You can choose the select mode (default is charwise 'v')
                    -- selection_modes = {
                    --     ["@parameter.outer"] = "v", -- charwise
                    --     ["@function.outer"] = "V", -- linewise
                    --     ["@class.outer"] = "<c-v>", -- blockwise
                    -- },
                    -- If you set this to `true` (default is `false`) then any textobject is
                    -- extended to include preceding xor succeeding whitespace. Succeeding
                    -- whitespace has priority in order to act similarly to eg the built-in
                    -- `ap`.
                    include_surrounding_whitespace = false,
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]f"] = { query = "@function.outer", desc = "[TS] Next function start" },
                        -- ["]o"] = { query = "@loop.*", desc = "[TS] Next loop start" },
                        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
                        --
                        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                        -- ["]s"] = { query = "@scope", query_group = "locals", desc = "[TS] Next scope" },
                        -- ["]z"] = { query = "@fold", query_group = "folds", desc = "[TS] Next fold" },
                    },
                    goto_next_end = {
                        -- ["]M"] = { query = "@function.outer", desc = "[TS] Next function end" },
                        -- ["]["] = { query = "@class.outer", desc = "[TS] Next class end" },
                    },
                    goto_previous_start = {
                        ["[f"] = { query = "@function.outer", desc = "[TS] Previous function start" },
                    },
                    goto_previous_end = {
                        -- ["[M"] = { query = "@function.outer", desc = "[TS] Prev function end]" },
                        -- ["[]"] = { query = "@class.outer", desc = "[TS] Prev class end" },
                    },
                    -- Below will go to either the start or the end, whichever is closer.
                    -- Use if you want more granular movements
                    -- Make it even more gradual by adding multiple queries and regex.
                    goto_next = {
                        -- ["]d"] = { query = "@conditional.outer", desc = "[TS] Next condition outer" },
                        -- ["]f"] = { query = "@function.outer", desc = "[TS] Next function outer" },
                        ["]]"] = { query = "@block.*", desc = "[TS] Next block" },
                    },
                    goto_previous = {
                        -- ["[d"] = { query = "@conditional.outer", desc = "[TS] Prev condition outer] " },
                        -- ["[f"] = { query = "@function.outer", desc = "[TS] Previous function outer" },
                        ["[["] = { query = "@block.*", desc = "[TS] Previous block" },
                    },
                },
            },
        })
    end,
}
