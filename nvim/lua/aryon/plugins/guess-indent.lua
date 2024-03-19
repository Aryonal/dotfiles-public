return {
    "nmac427/guess-indent.nvim",
    config = function()
        local ft = require("share.filetypes")
        require("guess-indent").setup({
            filetype_exclude = ft.base_exclude,
        })
    end,
}
