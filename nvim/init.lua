if vim.g.neovide then
    vim.o.guifont = "JetBrainsMono NFM:h12"
    vim.g.neovide_scroll_animation_length = 0.1
    vim.opt.linespace = 2
end

-- disable netrw
require("x.helper.vim").disable_netrw()

-- For lazy.nvim keys setup
vim.g.mapleader = require("config").keymaps.leader

require("x.helper.lazy").init()

-- load plugins first
local lazy_plugins = require("x.helper.loader").load("lua/plugin/**/*.lua")
local opts = require("x.helper.lazy").default_opts
opts.ui.border = require("config").ui.float.border
require("x.helper.lazy").setup(lazy_plugins, opts)

require("x.helper.loader").load("lua/aryon/**/*.lua")
