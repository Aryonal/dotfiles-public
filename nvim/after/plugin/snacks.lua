local ok, snacks = pcall(require, "snacks")
if not ok then
    return
end

snacks.setup({
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    image = { enabled = true },
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
        left = { "mark", "sign" },         -- priority of signs on the left (high to low)
        right = { "git", "fold" },         -- priority of signs on the right (high to low)
        git = {
            -- patterns to match Git signs
            patterns = { "GitSign", "MiniDiffSign" },
        },
    },
    words = { enabled = false },
})
