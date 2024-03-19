local o = vim.o -- options
local wo = vim.wo -- window options
-- local bo = vim.bo -- buffer options

local style = require("aryon.config").code_style
local bg = require("aryon.config").colors.background

-- global options
-- default setting for tab and space
o.scrolloff = 8 -- keep cursor vertically centralized
-- o.updatetime = 1000 -- the timeout for CursorHold
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

o.colorcolumn = tostring(style.MAX_LENGTH)

-- o.equalalways = false

vim.opt.wildignore:append({ "*/node_modules/*" })

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
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"
