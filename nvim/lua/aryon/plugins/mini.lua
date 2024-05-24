return {
    {
        "echasnovski/mini.splitjoin",
        version = false,
        event = require("utils.lazy").events.SetB,
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

            local set_cmd = require("utils.vim").set_cmd
            local set_abbr = require("utils.vim").set_abbr

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
        enabled = true,
        version = false,
        event = "InsertEnter",
        config = function()
            require("mini.pairs").setup({
                modes = { insert = true, command = false, terminal = false },
                mappings = {
                    ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][\n), ]" },
                    ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][\n, ]" },
                    ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][\n}, ]" },
                    -- ["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\] " },

                    [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
                    ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
                    ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
                    -- [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\] " },

                    -- or use pattern `[^'%S\\a-zA-Z0-9][^a-zA-Z0-9]`
                    ['"'] = { action = "closeopen", pair = '""', neigh_pattern = " [\n ]", register = { cr = false } },
                    ["'"] = { action = "closeopen", pair = "''", neigh_pattern = " [\n ]", register = { cr = false } },
                    ["`"] = { action = "closeopen", pair = "``", neigh_pattern = " [\n ]", register = { cr = false } },
                },
            })
        end
    },
}
