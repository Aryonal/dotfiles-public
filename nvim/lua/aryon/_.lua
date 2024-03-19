-- On start

-- disable netrw
require("utils.behavior").disable_netrw()

-- For lazy.nvim keys setup
vim.g.mapleader = require("aryon.config").keymaps.leader

-- load plugins first
local plugins = require("utils.loader").load_as_list("aryon.plugins")

local opts = require("utils.lazy").default_opts
opts.ui.border = require("aryon.config").ui.float.border
require("utils.lazy").init()
require("utils.lazy").setup(plugins, opts)
