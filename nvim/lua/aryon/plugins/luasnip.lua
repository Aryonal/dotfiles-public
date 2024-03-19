return {
    "L3MON4D3/LuaSnip",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    version = "*",
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    config = function()
        -- REF: https://www.reddit.com/r/neovim/comments/tcyuxk/comment/i0ghrvq/?utm_source=share&utm_medium=web2x&context=3
        require("luasnip.loaders.from_vscode").lazy_load()
    end,
}
