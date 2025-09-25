local ok, ts_obj = pcall(require, "nvim-treesitter-textobjects")
if ok then
    ts_obj.setup {
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
    vim.keymap.set({ "n", "x", "o" }, "[z", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@fold", "folds")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]z", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
    end)
end

local ok, twalker = pcall(require, "treewalker")
if ok then
    twalker.setup({
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
        select = true,

        -- Whether the plugin adds movements to the jumplist -- true | false | 'left'
        --  true: All movements more than 1 line are added to the jumplist. This is the default,
        --        and is meant to cover most use cases. It's modeled on how { and } natively add
        --        to the jumplist.
        --  false: Treewalker does not add to the jumplist at all
        --  "left": Treewalker only adds :Treewalker Left to the jumplist. This is usually the most
        --          likely one to be confusing, so it has its own mode.
        jumplist = true,
    })

    -- keymaps
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }
    map({ "n", "v" }, "[{", "<cmd>Treewalker Left<cr>", opts)
    map({ "n", "v" }, "]}", "<cmd>Treewalker Right<cr>", opts)
    map({ "n", "v" }, "[[", "<cmd>Treewalker Up<cr>", opts)
    map({ "n", "v" }, "]]", "<cmd>Treewalker Down<cr>", opts)
end
