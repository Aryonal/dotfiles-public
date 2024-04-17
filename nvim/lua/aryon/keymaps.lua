local cfg = require("aryon.config").keymaps

local all_modes = { "n", "i", "v", "t", "c" }

local fixed_bindings = {
    -- { "d",         [["_d]],             desc = "Do Not Cut",           mode = { "n", "v" } },
    -- { "<C-h>",     "<Left>",            desc = "Left",                 mode = all_modes },
    -- { "<C-j>",     "<Down>",            desc = "Down",                 mode = all_modes },
    -- { "<C-k>",     "<Up>",              desc = "Up",                   mode = all_modes },
    -- { "<C-l>",     "<Right>",           desc = "Right",                mode = all_modes },
    { "+",         "<C-a>",             desc = "Increase" },
    { "-",         "<C-x>",             desc = "Decrease" },
    { "<C-[>",     "<Esc>",             desc = "Esc",                  mode = { "i", "n" } },
    { "<C-a>",     "<C-o>I",            desc = "[I] Insert at beg",    mode = "i" },
    { "<C-b>",     "<C-o>b",            desc = "[I] Move prev word",   mode = "i" },
    { "<C-e>",     "3<C-e>",            desc = "Scroll Down (Faster)", mode = { "n", "v" } },
    { "<C-e>",     "<C-o>A",            desc = "[I] Insert end",       mode = "i" },
    { "<C-f>",     "<C-o>w",            desc = "[I] Move next word",   mode = "i" },
    { "<C-w>+",    "5<C-w>+",           desc = "[Win] Height incr" },
    { "<C-w>-",    "5<C-w>-",           desc = "[Win] Height decr" },
    { "<C-w><",    "5<C-w><",           desc = "[Win] Width decr " },
    { "<C-w>>",    "5<C-w>>",           desc = "[Win] Width incr " },
    { "<C-y>",     "3<C-y>",            desc = "Scroll Up (Faster)",   mode = { "n", "v" } },
    { "c",         [["_c]],             desc = "Do Not Cut",           mode = { "n", "v" } },
    { "ge",        "<cmd>tabp<CR>",     desc = "[Tab] Previous" },
    { "gt",        "<cmd>tabnext<CR>",  desc = "[Tab] Next" },
    { "p",         [["_dP]],            desc = "Do Not Cut",           mode = "v" },
    { "te",        "<C-w>T",            desc = "[Tab] New from buffer" },
    { "tn",        "<cmd>tabnew<CR>",   desc = "[Tab] New" },
    { "tq",        "<cmd>tabclose<CR>", desc = "[Tab] Close" },
    { "tt",        "<cmd>sp +term<CR>", desc = "[Term] New" },
    { [[<C-\>n]],  [[<C-\><C-n>]],      desc = "[Term] Normal mode",   mode = "t" },
    { [[<C-\>]],   [[<C-\><C-n>]],      desc = "[Term] Normal mode",   mode = "t" },
    { cfg.ed.fold, "za",                desc = "Toggle folding" },

    { "<BS>",      "<C-g>u<BS>",        desc = "Keep insert",          mode = "v" },
}

local win_bindings = {
    -- { { "<C-w>j", "<C-w><Down>" },  "<cmd>wincmd j<CR>", desc = "[Term] Navigate down",  mode = "t" },
    -- { { "<C-w>k", "<C-w><Up>" },    "<cmd>wincmd k<CR>", desc = "[Term] Navigate up",    mode = "t" },
    -- { { "<C-w>l", "<C-w><Right>" }, "<cmd>wincmd l<CR>", desc = "[Term] Navigate right", mode = "t" },
    -- { { "<C-w>h", "<C-w><Left>" },  "<cmd>wincmd h<CR>", desc = "[Term] Navigate left",  mode = "t" },
    { { "<Down>", "<C-j>" },  "<C-w>j",       desc = "[Win] Navigate down" },
    { { "<Left>", "<C-h>" },  "<C-w>h",       desc = "[Win] Navigate left" },
    { { "<Right>", "<C-l>" }, "<C-w>l",       desc = "[Win] Navigate right" },
    { { "<Up>", "<C-k>" },    "<C-w>k",       desc = "[Win] Navigate up" },
    { "<C-w>o",               "<C-w>|<C-w>_", desc = "[Win] Expand buffer" },
}

local lsp_bindings = {
    { "<leader>e",  vim.diagnostic.open_float, desc = "[LSP] Diagnostics (float)" },
    { "]d",         vim.diagnostic.goto_next,  desc = "[LSP] Next Diagnostic" },
    { "[d",         vim.diagnostic.goto_prev,  desc = "[LSP] Previous Diagnostic" },
    { "<leader>cl", vim.lsp.codelens.run,      desc = "[LSP] Run Codelens" },
}

--<leader> + number to quick jump tab
for i = 1, 9 do
    table.insert(fixed_bindings, {
        "<leader>" .. tostring(i),
        tostring(i) .. "gt",
        desc = "[Tab] Jump to tab" .. tostring(i),
        mode = { "n" },
    })
end

--<C-w> + number to quick jump window
for i = 1, 9 do
    table.insert(fixed_bindings, {
        "<C-w>" .. tostring(i),
        tostring(i) .. "<C-w>w",
        desc = "[Win] Jump to window" .. tostring(i),
        mode = { "n" },
    })
end

local bindings = {}

vim.list_extend(bindings, fixed_bindings)
vim.list_extend(bindings, win_bindings)
vim.list_extend(bindings, lsp_bindings)

local maps = require("utils.vim").batch_set_keymap
maps(bindings)

vim.keymap.del("s", "p")
vim.keymap.del("s", "c")
