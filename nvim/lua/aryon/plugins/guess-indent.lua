return {
    "nmac427/guess-indent.nvim",
    config = function()
        local ft = require("share.ft")
        require("guess-indent").setup({
            filetype_exclude = ft.base_exclude,
        })
    end,
}
