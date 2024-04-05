return {
    {
        "echasnovski/mini.comment",
        version = "*",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        keys = {
            {
                "<C-c>",
                mode = { "n", "v" },
                desc = "[Comment] Toggle"
            },
        },
        config = function()
            local ft = require("share.ft")

            require("mini.comment").setup({
                mappings = {
                    comment = "<C-c>",
                    comment_line = "<C-c>",
                    comment_visual = "<C-c>",
                    textobject = "gc",
                },
                hooks = {
                    pre = function()
                        local buf = vim.api.nvim_win_get_buf(0)
                        if vim.bo[buf].readonly then
                            return false
                        end
                        -- ignore certain ft
                        local buf_ft = vim.bo.filetype

                        for _, t in ipairs(ft.comment_toggle_exclude) do
                            if buf_ft == t then
                                return false
                            end
                        end
                    end,
                },
            })
        end
    },
    {
        "echasnovski/mini.splitjoin",
        version = false,
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        keys = {
            {
                "<leader>j",
                function()
                    require("mini.splitjoin").toggle()
                end,
                desc = "[SplitJoin] Toggle",
            },
        },
        config = function()
            require("mini.splitjoin").setup({
                mappings = {
                    toggle = "",
                }
            })

            local set_cmd = require("utils.command").set_cmd
            local set_abbr = require("utils.command").set_abbr

            set_cmd({
                cmd = "SplitJoinToggle",
                desc = "[SplitJoin] Toggle",
                exec = function()
                    require("mini.splitjoin").toggle()
                end,
            })
            set_abbr("sj", "SplitJoinToggle")
        end,
    },
    {
        "echasnovski/mini.pairs",
        version = false,
        event = "InsertEnter",
        config = function()
            require("mini.pairs").setup({
                modes = { insert = true, command = false, terminal = false },
                mappings = {
                    ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
                    ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
                    ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
                    ["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },

                    [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
                    ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
                    ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
                    [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },

                    ['"'] = { action = "closeopen", pair = '""', neigh_pattern = '[^"%S\\].', register = { cr = false } },
                    ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^'%S\\].", register = { cr = false } },
                    ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^`%S\\].", register = { cr = false } },
                },
            })
        end
    },
}
