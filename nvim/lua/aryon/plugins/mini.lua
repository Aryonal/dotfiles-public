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
    {
        "echasnovski/mini.statusline",
        version = "*",
        enabled = true,
        config = function()
            local stl = require("utils.statusline")
            local cfg = require("aryon.config")

            require("mini.statusline").setup(
            -- No need to copy this inside `setup()`. Will be used automatically.
                {
                    -- Content of statusline as functions which return statusline string. See
                    -- `:h statusline` and code of default contents (used instead of `nil`).
                    content = {
                        -- Content for active window
                        active = stl.config(cfg.ui.statusline).statusline_string,
                        -- Content for inactive window(s)
                        inactive = stl.config(cfg.ui.statusline).inactive_statusline_string,
                    },

                    -- Whether to use icons by default
                    use_icons = false,

                    -- Whether to set Vim's settings for statusline (make it always shown with
                    -- 'laststatus' set to 2).
                    -- To use global statusline, set this to `false` and 'laststatus' to 3.
                    set_vim_settings = true,
                }
            )
        end
    },
}
