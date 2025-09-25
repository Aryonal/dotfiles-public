local _setup_once = require("helper.lua").once(function()
    if MiniDeps then
        MiniDeps.add({ source = "sindrets/diffview.nvim", depends = { "nvim-lua/plenary.nvim" } })
    end

    local ok, diffview = pcall(require, "diffview")
    if not ok then
        return
    end

    local actions = require("diffview.actions")
    local icons = require("assets.icons")

    diffview.setup({
        -- diff_binaries = false,    -- Show diffs for binaries
        -- enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
        use_icons = false, -- Requires nvim-web-devicons
        icons = {
            folder_closed = icons.arrow_right,
            folder_open = icons.arrow_open,
        },
        signs = {
            fold_closed = icons.arrow_right,
            fold_open = icons.arrow_open,
        },
        default_args = { -- Default args prepended to the arg-list for the listed commands
            DiffviewOpen = { "--imply-local" },
        },
        -- hooks = {},         -- See ':h diffview-config-hooks'
        keymaps = {
            disable_defaults = false, -- Disable the default keymaps
            view = {
                -- The `view` bindings are active in the diff buffers, only when the current
                -- tabpage is a Diffview.
                { "n", "gf",         false },
                { "n", "<up>",       false },
                { "n", "<down>",     false },
                { "n", "<C-w><C-f>", false },
                { "n", "<C-s>",      actions.goto_file_split,           { desc = "Open the file in a new split" } },
                { "n", "<C-x>",      actions.goto_file_split,           { desc = "Open the file in a new split" } },
                { "n", "<C-w>gf",    false },
                { "n", "<C-t>",      actions.goto_file_tab,             { desc = "Open the file in a new tabpage" } },
                { "n", "g?",         actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
            },
            diff1 = {
                -- Mappings in single window diff layouts
                { "n", "g?", actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
            },
            diff2 = {
                -- Mappings in 2-way diff layouts
                { "n", "g?", actions.help({ "view", "diff2" }), { desc = "Open the help panel" } },
            },
            diff3 = {
                -- Mappings in 3-way diff layouts
                -- {
                --     { "n", "x" },
                --     "2do",
                --     actions.diffget("ours"),
                --     { desc = "Obtain the diff hunk from the OURS version of the file" },
                -- },
                -- {
                --     { "n", "x" },
                --     "3do",
                --     actions.diffget("theirs"),
                --     { desc = "Obtain the diff hunk from the THEIRS version of the file" },
                -- },
                { "n", "g?", actions.help({ "view", "diff3" }), { desc = "Open the help panel" } },
            },
            diff4 = {
                -- Mappings in 4-way diff layouts
                -- {
                --     { "n", "x" },
                --     "1do",
                --     actions.diffget("base"),
                --     { desc = "Obtain the diff hunk from the BASE version of the file" },
                -- },
                -- {
                --     { "n", "x" },
                --     "2do",
                --     actions.diffget("ours"),
                --     { desc = "Obtain the diff hunk from the OURS version of the file" },
                -- },
                -- {
                --     { "n", "x" },
                --     "3do",
                --     actions.diffget("theirs"),
                --     { desc = "Obtain the diff hunk from the THEIRS version of the file" },
                -- },
                { "n", "g?", actions.help({ "view", "diff4" }), { desc = "Open the help panel" } },
            },
            file_panel = {
                { "n", "-",          actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry." } },
                { "n", "s",          actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry." } },
                { "n", "gf",         false },
                { "n", "<up>",       false },
                { "n", "<down>",     false },
                { "n", "<C-w><C-f>", false },
                { "n", "<C-s>",      actions.goto_file_split,    { desc = "Open the file in a new split" } },
                { "n", "<C-x>",      actions.goto_file_split,    { desc = "Open the file in a new split" } },
                { "n", "<C-w>gf",    false },
                { "n", "<C-t>",      actions.goto_file_tab,      { desc = "Open the file in a new tabpage" } },
                { "n", "g?",         false },
            },
            file_history_panel = {
                { "n", "g!",         actions.options,                    { desc = "Open the option panel" } },
                { "n", "y",          actions.copy_hash,                  { desc = "Copy the commit hash of the entry under the cursor" } },
                { "n", "gf",         false },
                { "n", "<up>",       false },
                { "n", "<down>",     false },
                { "n", "<C-w><C-f>", false },
                { "n", "<C-s>",      actions.goto_file_split,            { desc = "Open the file in a new split" } },
                { "n", "<C-x>",      actions.goto_file_split,            { desc = "Open the file in a new split" } },
                { "n", "<C-w>gf",    false },
                { "n", "<C-t>",      actions.goto_file_tab,              { desc = "Open the file in a new tabpage" } },
                { "n", "g?",         actions.help("file_history_panel"), { desc = "Open the help panel" } },
            },
            option_panel = {
                { "n", "q",  actions.close,                { desc = "Close the panel" } },
                { "n", "g?", actions.help("option_panel"), { desc = "Open the help panel" } },
            },
            help_panel = {
                { "n", "q",     actions.close, { desc = "Close help menu" } },
                { "n", "<esc>", actions.close, { desc = "Close help menu" } },
            },
        },
    })

    local create_abbr_batch = require("helper.vim").batch_set_abbr
    local abbrs = {
        { name = "df",  cmd = "DiffviewOpen" },
        { name = "dF",  cmd = "DiffviewOpen -- %" },
        { name = "do",  cmd = "DiffviewOpen origin/HEAD...HEAD" },
        { name = "dfc", cmd = "DiffviewClose" },
        { name = "dh",  cmd = "DiffviewFileHistory" },
        { name = "dH",  cmd = "DiffviewFileHistory %" },
    }
    create_abbr_batch(abbrs)
end)

local keys = {
    { "<leader>df", "DiffviewOpen",                    desc = "[Diffview] Open" },
    { "<leader>dF", "DiffviewOpen -- %",               desc = "[Diffview] Open" },
    { "<leader>do", "DiffviewOpen origin/HEAD...HEAD", desc = "[Diffview] Open diff to origin/HEAD" },
    { "<leader>dc", "DiffviewClose",                   desc = "[Diffview] Close" },
    { "<leader>dH", "DiffviewFileHistory %%",          desc = "[Diffview] Current file history" },
    { "<leader>dh", "DiffviewFileHistory",             desc = "[Diffview] History" },
}

for _, key in ipairs(keys) do
    local _rhs = require("helper.lua").prehook(_setup_once, function()
        vim.cmd(key[2])
    end)
    vim.keymap.set("n", key[1], _rhs, { desc = key.desc })
end
