if vim.g.neovide then
    vim.o.guifont = "JetBrainsMono NFM:h12"
    vim.g.neovide_scroll_animation_length = 0.1
    vim.opt.linespace = 2
end

_ = require("utils.loader").load("aryon")
