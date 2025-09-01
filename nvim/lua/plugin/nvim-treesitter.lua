return {
    {
        -- Dependencies
        -- - tree-sitter cli
        -- - cc
        -- - node >= 23.0
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            local ensureInstalled = {
                "all",
            }
            local alreadyInstalled = require("nvim-treesitter.config").get_installed()
            local parsersToInstall = vim.iter(ensureInstalled)
                :filter(function(parser) return not vim.tbl_contains(alreadyInstalled, parser) end)
                :totable()
            require("nvim-treesitter").install(parsersToInstall)

            -- auto-start highlights & indentation
            vim.api.nvim_create_autocmd("FileType", {
                desc = "Enable treesitter highlighting",
                callback = function(ctx)
                    -- highlights
                    local hasStarted = pcall(vim.treesitter.start) -- errors for filetypes with no parser

                    -- indent
                    local noIndent = {}
                    if hasStarted and not vim.list_contains(noIndent, ctx.match) then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = require("x.helper.lazy").events_presets.LazyFile,
        config = function()
            -- configuration
            require("nvim-treesitter-textobjects").setup {
                select = {
                    lookahead = true,
                    selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "V",  -- linewise
                        ["@class.outer"] = "<c-v>", -- blockwise
                    },
                    include_surrounding_whitespace = false,
                },
            }

            -- keymaps
            -- You can use the capture groups defined in `textobjects.scm`
            vim.keymap.set({ "x", "o" }, "af", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "if", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ac", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ic", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
            end)
            -- You can also use captures from other query groups like `locals.scm`
            vim.keymap.set({ "x", "o" }, "as", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
            end)
            vim.keymap.set({ "x", "o" }, "is", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
            end)

            -- move
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        enabled = false,
        event = require("x.helper.lazy").events_presets.LazyFile,
        config = function()
            require("treesitter-context").setup({
                min_window_height = 32,
                separator = "─",
                -- Line used to calculate context.
                -- Choices: 'cursor', 'topline'
                mode = "topline",
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
    {
        "aaronik/treewalker.nvim",
        event = require("x.helper.lazy").events_presets.LazyFile,

        -- The following options are the defaults.
        -- Treewalker aims for sane defaults, so these are each individually optional,
        -- and setup() does not need to be called, so the whole opts block is optional as well.
        opts = {
            -- Whether to briefly highlight the node after jumping to it
            highlight = true,

            -- How long should above highlight last (in ms)
            highlight_duration = 250,

            -- The color of the above highlight. Must be a valid vim highlight group.
            -- (see :h highlight-group for options)
            highlight_group = "CursorLine",

            -- Whether to create a visual selection after a movement to a node.
            -- If true, highlight is disabled and a visual selection is made in
            -- its place.
            select = false,

            -- Whether the plugin adds movements to the jumplist -- true | false | 'left'
            --  true: All movements more than 1 line are added to the jumplist. This is the default,
            --        and is meant to cover most use cases. It's modeled on how { and } natively add
            --        to the jumplist.
            --  false: Treewalker does not add to the jumplist at all
            --  "left": Treewalker only adds :Treewalker Left to the jumplist. This is usually the most
            --          likely one to be confusing, so it has its own mode.
            jumplist = true,
        },
        config = function(_, opts)
            require("treewalker").setup(opts)

            -- keymaps
            local map = vim.keymap.set
            local opts = { noremap = true, silent = true }
            map("n", "[{", "<cmd>Treewalker Left<cr>", opts)
            map("n", "]}", "<cmd>Treewalker Right<cr>", opts)
            map("n", "[[", "<cmd>Treewalker Up<cr>", opts)
            map("n", "]]", "<cmd>Treewalker Down<cr>", opts)
        end,
    },
}
