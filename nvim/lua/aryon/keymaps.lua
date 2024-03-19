-- global keymaps
-- REF: https://github.com/brainfucksec/neovim-lua/blob/main/nvim/lua/core/keymaps.lua
-- vim.g.mapleader = consts.LEADER

-- structure of bind
-- ```
-- {
--   mode = "n",
--   key = "<Left>",
--   cmd = "<C-w>h",
--   desc = "Window navigates left",
--   opts = {
--     buffer = nil,
--     silent = true,
--     noremap = true,
--     nowait = false,
--   }
-- }
-- ````

local all_modes = { "n", "i", "v", "t", "c" }

local fixed_bindings = {
    {
        mode = "v",
        key = "p",
        cmd = [["_dP]],
        desc = "Do Not Cut",
    },
    {
        mode = { "n", "v" },
        key = "c",
        cmd = [["_c]],
        desc = "Do Not Cut",
    },
    -- {
    --     mode = { "n", "v" },
    --     key = "d",
    --     cmd = [["_d]],
    --     desc = "Do Not Cut",
    -- },
    {
        mode = { "n", "v" },
        key = "<C-y>",
        cmd = "5<C-y>",
        desc = "Scroll Up (Faster)",
    },
    {
        mode = { "n", "v" },
        key = "<C-e>",
        cmd = "5<C-e>",
        desc = "Scroll Down (Faster)",
    },
    {
        key = "<C-w>>",
        cmd = "5<C-w>>",
        desc = "[Window] Width incr (Faster)",
    },
    {
        key = "<C-w><",
        cmd = "5<C-w><",
        desc = "[Window] Width decr (Faster)",
    },
    {
        key = "<C-w>+",
        cmd = "5<C-w>+",
        desc = "[Window] Height incr (Faster)",
    },
    {
        key = "<C-w>-",
        cmd = "5<C-w>-",
        desc = "[Window] Height decr (Faster)",
    },
    {
        mode = all_modes,
        key = "<C-k>",
        cmd = "<Up>",
        desc = "Up",
    },
    {
        mode = all_modes,
        key = "<C-j>",
        cmd = "<Down>",
        desc = "Down",
    },
    {
        mode = all_modes,
        key = "<C-h>",
        cmd = "<Left>",
        desc = "Left",
    },
    {
        mode = all_modes,
        key = "<C-l>",
        cmd = "<Right>",
        desc = "Right",
    },
    {
        key = "<C-n>",
        cmd = "<Esc>",
        mode = { "i", "n" },
        desc = "Esc",
    },
    {
        key = "<C-n>",
        cmd = [[<C-\><C-n>]],
        mode = "t",
        desc = "[T] Normal mode",
    },
    {
        key = "<C-[>",
        cmd = "<Esc>",
        mode = { "i", "n" },
        desc = "Esc",
    },
    {
        key = "<C-p>",
        cmd = "<Esc>",
        mode = { "i", "n" },
        desc = "Esc",
    },
    {
        key = "te",
        cmd = "<C-w>T",
        desc = "[Tab] New from buffer",
    },
    {
        key = "tn",
        cmd = ":tabnew<CR>",
        desc = "[Tab] New",
    },
    {
        key = "tq",
        cmd = ":tabclose<CR>",
        desc = "[Tab] Close",
    },
    {
        key = "gt",
        cmd = ":tabprev<CR>",
        desc = "[Tab] Previous",
    },
    {
        key = "gT",
        cmd = ":tabnext<CR>",
        desc = "[Tab] Next",
    },
    {
        key = { "<Left>", "<C-h>" },
        cmd = "<C-w>h",
        desc = "[Window] Navigate left",
    },
    {
        key = { "<Right>", "<C-l>" },
        cmd = "<C-w>l",
        desc = "[Window] Navigate right",
    },
    {
        key = { "<Up>", "<C-k>" },
        cmd = "<C-w>k",
        desc = "[Window] Navigate up",
    },
    {
        key = { "<Down>", "<C-j>" },
        cmd = "<C-w>j",
        desc = "[Window] Navigate down",
    },
    {
        key = "+",
        cmd = "<C-a>",
        desc = "Increase",
    },
    {
        key = "-",
        cmd = "<C-x>",
        desc = "Decrease",
    },
    -- emacs keymaps
    {
        key = "<C-e>",
        cmd = "<C-o>A",
        mode = "i",
        desc = "[I] Insert end of line",
    },
    {
        key = "<C-a>",
        cmd = "<C-o>I",
        mode = "i",
        desc = "[I] Insert beg of line",
    },
    {
        key = "<C-f>",
        cmd = "<C-o>w",
        mode = "i",
        desc = "[I] Move to next word",
    },
    {
        key = "<C-b>",
        cmd = "<C-o>b",
        mode = "i",
        desc = "[I] Move to previous word",
    },
    {
        key = "<Space>",
        cmd = "za",
        desc = "Toggle folding",
    },
    -- {
    --     key = "<Space>",
    --     cmd = "<C-w>w",
    --     desc = "[Window] Switch",
    -- },
    -- Mouse
    -- REF: http://vimdoc.sourceforge.net/htmldoc/scroll.html
    -- map("n", "<ScrollWheelUp>", "<C-y>")
    -- map("n", "<ScrollWheelDown>", "<C-e>")
}

local lsp_bindings = {
    {
        key = "<leader>e",
        cmd = "<cmd>lua vim.diagnostic.open_float()<CR>",
        desc = "[LSP] Diagnostics (float)",
    },
    {
        key = "]d",
        cmd = vim.diagnostic.goto_next,
        desc = "[LSP] Next Diagnostic",
    },
    {
        key = "[d",
        cmd = vim.diagnostic.goto_prev,
        desc = "[LSP] Previous Diagnostic",
    },
    {
        key = "<leader>cl",
        cmd = ":lua vim.lsp.codelens.run()<CR>",
        desc = "[LSP] Run Codelens",
    },
}

--<leader> + number to quick jump tab
for i = 1, 9 do
    table.insert(fixed_bindings, {
        mode = "n",
        key = "<leader>" .. tostring(i),
        cmd = tostring(i) .. "gt",
        desc = "[Tab] Jump to tab" .. tostring(i),
    })
end

--<C-w> + number to quick jump window
for i = 1, 9 do
    table.insert(fixed_bindings, {
        mode = "n",
        key = "<C-w>" .. tostring(i),
        cmd = tostring(i) .. "<C-w>w",
        desc = "[Window] Jump to window" .. tostring(i),
    })
end

local bindings = {}

vim.list_extend(bindings, fixed_bindings)
vim.list_extend(bindings, lsp_bindings)

local maps = require("utils.keymap").batch_set
maps(bindings)
