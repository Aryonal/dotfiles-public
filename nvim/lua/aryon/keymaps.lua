local cfg = require("aryon.config").keymaps

local all_modes = { "n", "i", "v", "t", "c" }

local fixed_bindings = {
    -- { key = "d",         cmd = [["_d]],             desc = "Do Not Cut",           mode = { "n", "v" } },
    -- { key = "<C-h>",     cmd = "<Left>",            desc = "Left",                 mode = all_modes },
    -- { key = "<C-j>",     cmd = "<Down>",            desc = "Down",                 mode = all_modes },
    -- { key = "<C-k>",     cmd = "<Up>",              desc = "Up",                   mode = all_modes },
    -- { key = "<C-l>",     cmd = "<Right>",           desc = "Right",                mode = all_modes },
    { key = "+",         cmd = "<C-a>",             desc = "Increase" },
    { key = "-",         cmd = "<C-x>",             desc = "Decrease" },
    { key = "<C-[>",     cmd = "<Esc>",             desc = "Esc",                  mode = { "i", "n" } },
    { key = "<C-a>",     cmd = "<C-o>I",            desc = "[I] Insert at beg",    mode = "i" },
    { key = "<C-b>",     cmd = "<C-o>b",            desc = "[I] Move prev word",   mode = "i" },
    { key = "<C-e>",     cmd = "3<C-e>",            desc = "Scroll Down (Faster)", mode = { "n", "v" } },
    { key = "<C-e>",     cmd = "<C-o>A",            desc = "[I] Insert end",       mode = "i" },
    { key = "<C-f>",     cmd = "<C-o>w",            desc = "[I] Move next word",   mode = "i" },
    { key = "<C-w>+",    cmd = "5<C-w>+",           desc = "[Win] Height incr" },
    { key = "<C-w>-",    cmd = "5<C-w>-",           desc = "[Win] Height decr" },
    { key = "<C-w><",    cmd = "5<C-w><",           desc = "[Win] Width decr " },
    { key = "<C-w>>",    cmd = "5<C-w>>",           desc = "[Win] Width incr " },
    { key = "<C-y>",     cmd = "3<C-y>",            desc = "Scroll Up (Faster)",   mode = { "n", "v" } },
    { key = "c",         cmd = [["_c]],             desc = "Do Not Cut",           mode = { "n", "v" } },
    { key = "ge",        cmd = "<cmd>tabprev<CR>",  desc = "[Tab] Previous" },
    { key = "gt",        cmd = "<cmd>tabnext<CR>",  desc = "[Tab] Next" },
    { key = "p",         cmd = [["_dP]],            desc = "Do Not Cut",           mode = "v" },
    { key = "te",        cmd = "<C-w>T",            desc = "[Tab] New from buffer" },
    { key = "tn",        cmd = "<cmd>tabnew<CR>",   desc = "[Tab] New" },
    { key = "tq",        cmd = "<cmd>tabclose<CR>", desc = "[Tab] Close" },
    { key = "tt",        cmd = "<cmd>sp +term<CR>", desc = "[Term] New" },
    { key = [[<C-\>n]],  cmd = [[<C-\><C-n>]],      desc = "[Term] Normal mode",   mode = "t" },
    { key = [[<C-\>]],   cmd = [[<C-\><C-n>]],      desc = "[Term] Normal mode",   mode = "t" },
    { key = cfg.ed.fold, cmd = "za",                desc = "Toggle folding" },

    { key = "<BS>",      cmd = "<C-g>u<BS>",        desc = "Keep insert",          mode = "v" },
}

local win_bindings = {
    -- { key = { "<C-w>j", "<C-w><Down>" },  cmd = "<cmd>wincmd j<CR>", desc = "[Term] Navigate down",  mode = "t" },
    -- { key = { "<C-w>k", "<C-w><Up>" },    cmd = "<cmd>wincmd k<CR>", desc = "[Term] Navigate up",    mode = "t" },
    -- { key = { "<C-w>l", "<C-w><Right>" }, cmd = "<cmd>wincmd l<CR>", desc = "[Term] Navigate right", mode = "t" },
    -- { key = { "<C-w>h", "<C-w><Left>" },  cmd = "<cmd>wincmd h<CR>", desc = "[Term] Navigate left",  mode = "t" },
    { key = { "<Down>", "<C-j>" },  cmd = "<C-w>j", desc = "[Window] Navigate down" },
    { key = { "<Left>", "<C-h>" },  cmd = "<C-w>h", desc = "[Window] Navigate left" },
    { key = { "<Right>", "<C-l>" }, cmd = "<C-w>l", desc = "[Window] Navigate right" },
    { key = { "<Up>", "<C-k>" },    cmd = "<C-w>k", desc = "[Window] Navigate up" },
}

local lsp_bindings = {
    { key = "<leader>e",  cmd = vim.diagnostic.open_float, desc = "[LSP] Diagnostics (float)" },
    { key = "]d",         cmd = vim.diagnostic.goto_next,  desc = "[LSP] Next Diagnostic" },
    { key = "[d",         cmd = vim.diagnostic.goto_prev,  desc = "[LSP] Previous Diagnostic" },
    { key = "<leader>cl", cmd = vim.lsp.codelens.run,      desc = "[LSP] Run Codelens" },
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
vim.list_extend(bindings, win_bindings)
vim.list_extend(bindings, lsp_bindings)

local maps = require("utils.vim").batch_set_keymap
maps(bindings)

vim.keymap.del("s", "p")
vim.keymap.del("s", "c")
