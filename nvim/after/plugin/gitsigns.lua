local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
    return
end

local virtual_text_spaces = ""
for _ = 1, 2 do
    virtual_text_spaces = virtual_text_spaces .. " "
end

local create_abbr_batch = require("helper.vim").batch_set_abbr
local abbrs = {
    {
        name = "gs",
        cmd = "Gitsigns",
    },
}
create_abbr_batch(abbrs)

gitsigns.setup({
    signs = {
        add = { text = "+" },
        untracked = { text = "+" },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = true,      -- Toggle with `:Gitsigns toggle_numhl`
    -- linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    -- word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    -- watch_gitdir = {
    --   interval = 1000,
    --   follow_files = true
    -- },
    -- attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        --   virt_text = true,
        virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
        delay = 200,                   -- TODO: use cfg
        --   ignore_whitespace = false,
    },
    current_line_blame_formatter = virtual_text_spaces .. "<author>, <author_time:%Y-%m-%d> - <summary>",
    -- sign_priority = 6,
    -- update_debounce = 100,
    -- status_formatter = nil, -- Use default
    -- max_file_length = 40000,
    preview_config = {
        -- Options passed to nvim_open_win
        border = vim.o.winborder or "rounded",
        -- style = 'minimal',
        -- relative = 'cursor',
        -- row = 0,
        -- col = 1
    },
    -- yadm = {
    --   enable = false
    -- },
    on_attach = function(bufnr)
        local gs = gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        map("n", "]h", function() gs.nav_hunk("next") end, { desc = "[Gitsigns] Next hunk" })
        map("n", "[h", function() gs.nav_hunk("prev") end, { desc = "[Gitsigns] Previous hunk" })
        map("n", "]c",
            function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    gs.nav_hunk("next")
                end
            end,
            { desc = "[Gitsigns] Next hunk" })

        map("n", "[c",
            function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                else
                    gs.nav_hunk("prev")
                end
            end,
            { desc = "[Gitsigns] Previous hunk" })

        -- Actions
        map("n", "<leader>p", gs.preview_hunk, { desc = "[Gitsigns] Preview hunk" })
        map("n", "<leader>hd", gs.diffthis, { desc = "[Gitsigns] Diff this" })
        map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "[Gitsigns] Diff this" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "[Gitsigns] inner hunk" })
    end,
})
