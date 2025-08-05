return {
    {
        "folke/snacks.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            bigfile = { enabled = false },
            dashboard = { enabled = false },
            image = { enabled = false },
            indent = {
                enabled = false,
                animate = { enabled = false },
                scope = { enabled = false },
            },
            input = { enabled = false },
            lazygit = { enabled = false },
            notifier = { enabled = false },
            quickfile = { enabled = false },
            scroll = { enabled = false },
            statuscolumn = {
                enabled = true,
                left = { "mark", "sign" }, -- priority of signs on the left (high to low)
                right = { "git", "fold" }, -- priority of signs on the right (high to low)
                git = {
                    -- patterns to match Git signs
                    patterns = { "GitSign", "MiniDiffSign" },
                },
            },
            words = { enabled = false },
        },
    }
}
