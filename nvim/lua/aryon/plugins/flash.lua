return {
    "folke/flash.nvim",
    -- REF: https://github.com/LazyVim/LazyVim/blob/97480dc5d2dbb717b45a351e0b04835f138a9094/lua/lazyvim/plugins/editor.lua#L271
    config = function()
        require("flash").setup({})
    end,
}
