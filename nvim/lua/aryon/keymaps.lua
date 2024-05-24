local cfg = require("aryon.config").keymaps

-- local all_modes = { "n", "i", "v", "t", "c" }

local fixed_bindings = {
    -- DON'TS
    -- { "d",         [["_d]],             desc = "Do Not Cut",           mode = { "n", "v" } },
    -- { "<C-h>",     "<Left>",            desc = "Left",                 mode = all_modes },
    -- { "<C-j>",     "<Down>",            desc = "Down",                 mode = all_modes },
    -- { "<C-k>",     "<Up>",              desc = "Up",                   mode = all_modes },
    -- { "<C-l>",     "<Right>",           desc = "Right",                mode = all_modes },
    -- { [[<Esc>]],   [[<C-\><C-n>]],      desc = "[Term] Normal mode",   mode = "t" },
    { "+",         "<C-a>",             desc = "Incr" },
    { "-",         "<C-x>",             desc = "Decr" },
    { "<C-[>",     "<Esc>",             desc = "Esc",                  mode = { "i", "n" } },
    { "<C-e>",     "3<C-e>",            desc = "Scroll down (Faster)", mode = { "n", "v" } },
    { "<C-w>+",    "5<C-w>+",           desc = "[Win] Height incr" },
    { "<C-w>-",    "5<C-w>-",           desc = "[Win] Height decr" },
    { "<C-w><",    "5<C-w><",           desc = "[Win] Width decr " },
    { "<C-w>>",    "5<C-w>>",           desc = "[Win] Width incr " },
    { "<C-y>",     "3<C-y>",            desc = "Scroll up (Faster)",   mode = { "n", "v" } },
    { "c",         [["_c]],             desc = "Do Not Cut",           mode = { "n", "v" } },
    { "ge",        "<cmd>tabp<CR>",     desc = "[Tab] Previous" },
    { "gt",        "<cmd>tabnext<CR>",  desc = "[Tab] Next" },
    { "p",         [["_dP]],            desc = "Do Not Cut",           mode = "v" },
    { "sn",        "<cmd>nohl<CR>",     desc = "No search highlight" },
    { "te",        "<C-w>T",            desc = "[Tab] New from buffer" },
    { "tn",        "<cmd>tabnew<CR>",   desc = "[Tab] New" },
    { "tq",        "<cmd>tabclose<CR>", desc = "[Tab] Close" },
    { "tt",        "<cmd>sp +term<CR>", desc = "[Term] New" },
    { [[<C-\>]],   [[<C-\><C-n>]],      desc = "[Term] Normal mode",   mode = "t" },
    { cfg.ed.fold, "za",                desc = "Toggle folding" },

    { "<BS>",      "<C-g>u<BS>",        desc = "Keep insert",          mode = "v" },
}

local ins_bindings = {
    { "<C-a>",   "<C-o>I", desc = "[I] Insert at beg",  mode = "i" },
    { "<C-b>",   "<C-o>b", desc = "[I] Move backward",  mode = "i" },
    { "<C-d>",   "<C-o>x", desc = "[I] Delete forward", mode = "i" },
    { "<C-e>",   "<C-o>A", desc = "[I] Insert end",     mode = "i" },
    { "<C-f>",   "<C-o>w", desc = "[I] Move forward",   mode = "i" },
    { "<C-k>",   "<C-o>D", desc = "[I] Delete til end", mode = "i" },
    -- non-emacs
    { "<Tab>",   "<C-t>",  desc = "[I] >>",             mode = "i" },
    { "<S-Tab>", "<C-d>",  desc = "[I] <<",             mode = "i" },
}

local win_bindings = {
    { { "<Down>", "<C-j>" },  "<C-w>j",       desc = "[Win] Navigate down" },
    { { "<Left>", "<C-h>" },  "<C-w>h",       desc = "[Win] Navigate left" },
    { { "<Right>", "<C-l>" }, "<C-w>l",       desc = "[Win] Navigate right" },
    { { "<Up>", "<C-k>" },    "<C-w>k",       desc = "[Win] Navigate up" },
    { "<C-w>o",               "<C-w>|<C-w>_", desc = "[Win] Expand buffer" },
}

local global_lsp_bindings = {
    { cfg.lsp.show_diagnostics_inline, vim.diagnostic.open_float, desc = "[LSP] Diagnostics (float)" },
    { cfg.motion.buffer.diag_next,     vim.diagnostic.goto_next,  desc = "[LSP] Next Diagnostic" },
    { cfg.motion.buffer.diag_prev,     vim.diagnostic.goto_prev,  desc = "[LSP] Previous Diagnostic" },
}

local typos = {
    { "Wa", "wa", desc = "[Typo] wa", mode = "c" },
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
vim.list_extend(bindings, ins_bindings)
vim.list_extend(bindings, win_bindings)
vim.list_extend(bindings, global_lsp_bindings)
vim.list_extend(bindings, typos)

local maps = require("utils.vim").batch_set_keymap
maps(bindings)

vim.keymap.del("s", "p")
vim.keymap.del("s", "c")
