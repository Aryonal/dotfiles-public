local keymaps = {
    open = "<leader>df",
    diff_head = "<leader>do",
    close = "<leader>dc",
    history_current_file = "<leader>dh",
    history = "<leader>dH",
}

return {
    "sindrets/diffview.nvim", -- tool for git diff view
    enabled = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    cmd = {
        "DiffviewOpen",
        "DiffviewFileHistory",
    },
    keys = {
        {
            keymaps.open,
            "<cmd>DiffviewOpen<CR>",
            desc = "[Diffview] Open",
        },
        {
            keymaps.diff_head,
            "<cmd>DiffviewOpen origin/HEAD<CR>",
            desc = "[Diffview] Open diff to origin/HEAD",
        },
        {
            keymaps.close,
            "<cmd>DiffviewClose<CR>",
            desc = "[Diffview] Close",
        },
        {
            keymaps.history_current_file,
            "<cmd>DiffviewFileHistory %%<CR>",
            desc = "[Diffview] Current file history",
        },
        {
            keymaps.history,
            "<cmd>DiffviewFileHistory<CR>",
            desc = "[Diffview] History",
        },
    },
    config = function()
        local actions = require("diffview.actions")
        local icons = require("assets.icons")

        require("diffview").setup({
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
                    { "n", "<C-x>",      actions.goto_file_split,           { desc = "Open the file in a new split" } },
                    { "n", "<C-w>gf",    false },
                    { "n", "<C-t>",      actions.goto_file_tab,             { desc = "Open the file in a new tabpage" } },
                    { "n", "g?",         actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
                    { "n", "?",          actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
                },
                diff1 = {
                    -- Mappings in single window diff layouts
                    { "n", "g?", actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
                    { "n", "?",  actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
                },
                diff2 = {
                    -- Mappings in 2-way diff layouts
                    { "n", "g?", actions.help({ "view", "diff2" }), { desc = "Open the help panel" } },
                    { "n", "?",  actions.help({ "view", "diff2" }), { desc = "Open the help panel" } },
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
                    { "n", "?",  actions.help({ "view", "diff3" }), { desc = "Open the help panel" } },
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
                    { "n", "?",  actions.help({ "view", "diff4" }), { desc = "Open the help panel" } },
                },
                file_panel = {
                    { "n", "-",          actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry." } },
                    { "n", "s",          actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry." } },
                    { "n", "gf",         false },
                    { "n", "<up>",       false },
                    { "n", "<down>",     false },
                    { "n", "<C-w><C-f>", false },
                    { "n", "<C-x>",      actions.goto_file_split,    { desc = "Open the file in a new split" } },
                    { "n", "<C-w>gf",    false },
                    { "n", "<C-t>",      actions.goto_file_tab,      { desc = "Open the file in a new tabpage" } },
                    { "n", "g?",         false },
                    { "n", "?",          actions.help("file_panel"), { desc = "Open the help panel" } },
                },
                file_history_panel = {
                    { "n", "g!",         actions.options,                    { desc = "Open the option panel" } },
                    {
                        "n",
                        "y",
                        actions.copy_hash,
                        { desc = "Copy the commit hash of the entry under the cursor" },
                    },
                    { "n", "gf",         false },
                    { "n", "<up>",       false },
                    { "n", "<down>",     false },
                    { "n", "<C-w><C-f>", false },
                    { "n", "<C-x>",      actions.goto_file_split,            { desc = "Open the file in a new split" } },
                    { "n", "<C-w>gf",    false },
                    { "n", "<C-t>",      actions.goto_file_tab,              { desc = "Open the file in a new tabpage" } },
                    { "n", "g?",         actions.help("file_history_panel"), { desc = "Open the help panel" } },
                    { "n", "?",          actions.help("file_history_panel"), { desc = "Open the help panel" } },
                },
                option_panel = {
                    { "n", "q",  actions.close,                { desc = "Close the panel" } },
                    { "n", "g?", actions.help("option_panel"), { desc = "Open the help panel" } },
                    { "n", "?",  actions.help("option_panel"), { desc = "Open the help panel" } },
                },
                help_panel = {
                    { "n", "q",     actions.close, { desc = "Close help menu" } },
                    { "n", "<esc>", actions.close, { desc = "Close help menu" } },
                },
            },
        })

        local create_abbr_batch = require("utils.vim").batch_set_abbr
        local abbrs = {
            {
                name = "df",
                cmd = "DiffviewOpen",
                desc = "Diffview open",
            },
            {
                name = "dm",
                cmd = "DiffviewOpen origin/HEAD",
                desc = "Diffview open diff to origin/HEAD",
            },
            {
                name = "dfc",
                cmd = "DiffviewClose",
                desc = "Diffview close",
            },
            {
                name = "dh",
                cmd = "DiffviewFileHistory",
                desc = "Diffview file history",
            },
            {
                name = "dhc",
                cmd = "DiffviewFileHistory %%",
                desc = "Diffview current file history",
            },
        }
        create_abbr_batch(abbrs)
    end,
}
