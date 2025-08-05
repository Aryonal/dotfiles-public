return {
    {
        "echasnovski/mini.nvim",
        version = "*",
        event = "VeryLazy",
        keys = {
            {
                "<leader>j",
                function()
                    require("mini.splitjoin").toggle()
                end,
                desc = "[SplitJoin] Toggle",
            },
            {
                "gJ",
                function() require("mini.splitjoin").toggle() end,
                desc = "[SplitJoin] Toggle",
            },
        },
        config = function()
            -- trailspace
            require("mini.trailspace").setup()

            -- splitjoin
            require("mini.splitjoin").setup({
                mappings = {
                    toggle = "",
                }
            })

            require("utils.vim").set_cmd({
                cmd = "SplitJoinToggle",
                desc = "[SplitJoin] Toggle",
                abbr = "sj",
                exec = function() require("mini.splitjoin").toggle() end,
            })

            -- pairs
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
        end,
    },
}
