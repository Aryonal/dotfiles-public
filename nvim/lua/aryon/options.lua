local o = vim.o   -- options
local wo = vim.wo -- window options
-- local bo = vim.bo -- buffer options

local style = require("aryon.config").code_style
local bg = require("aryon.config").colors.background

-- global options
-- o.updatetime = 1000 -- the timeout for CursorHold
o.scrolloff = 8 -- keep cursor vertically centralized
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
o.shiftwidth = 4
o.smartcase = true
o.smartindent = true
o.softtabstop = 4
o.swapfile = true
o.tabstop = 4
o.title = true
-- o.spell = true
-- o.spelllang = "en"

-- NonText
vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")
vim.opt.listchars:append("tab:» ")


o.colorcolumn = tostring(style.MAX_LENGTH)

-- o.equalalways = false

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

-- REF: https://www.reddit.com/r/neovim/comments/qoy419/comment/hjr8oev/?utm_source=share&utm_medium=web2x&context=3
o.termguicolors = true
o.bg = bg

-- :h sessionoptions
-- default "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"
-- o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"
