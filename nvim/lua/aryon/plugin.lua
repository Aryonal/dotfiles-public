---@diagnostic disable: different-requires
local plugins = {
    -- color scheme
    require("aryon.plugins.github-theme"),
    require("aryon.plugins.tokyonight"),
    -- cmp
    require("aryon.plugins.nvim-cmp"),
    require("aryon.plugins.cmp-luasnip"),
    require("aryon.plugins.luasnip"),
    require("aryon.plugins.copilot-cmp"),
    -- git
    require("aryon.plugins.gitlinker"),
    require("aryon.plugins.gitsigns"),
    -- lsp
    require("aryon.plugins.lsp-colors"),
    require("aryon.plugins.lspconfig"),
    require("aryon.plugins.lspkind"),
    require("aryon.plugins.nvim-lsp-file-operation"),
    -- lsp provider
    require("aryon.plugins.mason"),
    require("aryon.plugins.mason-lspconfig"),
    require("aryon.plugins.none-ls"),
    -- treesitter
    require("aryon.plugins.nvim-treesitter"),
    require("aryon.plugins.nvim-treesitter-context"),
    require("aryon.plugins.nvim-treesitter-textobject"),
    require("aryon.plugins.nvim-ts-autotag"),
    -- editor
    require("aryon.plugins.hop"),
    require("aryon.plugins.nvim-autopairs"),
    require("aryon.plugins.nvim-comment"),
    require("aryon.plugins.nvim-surround"),
    require("aryon.plugins.vim-visual-multi"),
    require("aryon.plugins.guess-indent"),
    require("aryon.plugins.mini-splitjoin"),
    require("aryon.plugins.nvim-colorizer"),
    require("aryon.plugins.vim-illuminate"),
    require("aryon.plugins.nvim-ufo"),
    -- ui
    require("aryon.plugins.dressing"),
    require("aryon.plugins.fidget"),
    require("aryon.plugins.indent-blankline"),
    require("aryon.plugins.lualine"),
    -- language - go
    require("aryon.plugins.gotests-vim"),
    -- language - markdown
    require("aryon.plugins.markdown-preview"),

    require("aryon.plugins.aerial"),
    require("aryon.plugins.copilot"),
    require("aryon.plugins.diffview"),
    require("aryon.plugins.harpoon"),
    require("aryon.plugins.neo-tree"),
    require("aryon.plugins.spectre"),
    require("aryon.plugins.telescope"),
    require("aryon.plugins.toggleterm"),
    require("aryon.plugins.which-key"),
    require("aryon.plugins.window-picker"),
}

local opts = require("utils.lazy").default_opts
opts.ui.border = require("aryon.config").ui.float.border
require("utils.lazy").init()
require("utils.lazy").setup(plugins, opts)
