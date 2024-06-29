local o = vim.o   -- options
local wo = vim.wo -- window options
-- local bo = vim.bo -- buffer options

local style = require("aryon.config").code_style
local bg = require("aryon.config").colors.background

-- global options
-- o.updatetime = 1000 -- the timeout for CursorHold
o.scrolloff = 3 -- keep cursor vertically centralized
o.autoindent = true
o.autoread = true
o.dir = "/tmp"
o.expandtab = true
o.hidden = true
o.hlsearch = true
o.ignorecase = true
o.incsearch = true
o.infercase = true
o.laststatus = 2
o.mouse = "a"
o.smartcase = true
o.swapfile = true
o.title = true
-- o.spell = true
-- o.spelllang = "en"

-- Indentation
o.smartindent = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

-- NonText
vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")
vim.opt.listchars:append("tab:» ") -- ⇥

o.colorcolumn = tostring(style.MAX_LENGTH)
o.termguicolors = true
-- o.bg = bg

o.equalalways = true

vim.opt.wildignore:append({ "*/node_modules/*", "*/vendor/*" })
vim.opt.shortmess:append({ I = true }) -- disable :intro

-- window-local options
-- wo.cursorcolumn = true
wo.cursorline = true
wo.number = true
wo.relativenumber = false
wo.wrap = true

-- window split
o.splitright = true
o.splitbelow = true

-- :h sessionoptions
-- default "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"
-- o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"
