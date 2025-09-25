-- neovim specific options
local o = vim.o

o.scrolloff = 3
o.colorcolumn = "100"
o.undofile = true

o.list = true
vim.opt.listchars = { tab = "» ", nbsp = "␣", trail = "·", extends = "›", precedes = "‹" }

o.winborder = "rounded"
