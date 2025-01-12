-- print("[debug] Loading aryon._")
-- On start

-- disable netrw
require("utils.vim").disable_netrw()
-- require("utils.vim").setup_netrw()

-- For lazy.nvim keys setup
vim.g.mapleader = require("aryon.config").keymaps.leader

-- load plugins first
local plugins = require("utils.loader").load("aryon.plugins", true)

local opts = require("utils.lazy").default_opts
opts.ui.border = require("aryon.config").ui.float.border
require("utils.lazy").init()
require("utils.lazy").setup(plugins, opts)
