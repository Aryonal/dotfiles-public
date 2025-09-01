return {
    "nmac427/guess-indent.nvim",
    event = require("x.helper.lazy").events_presets.LazyFile,
    config = function()
        require("guess-indent").setup {
            filetype_exclude = require("config").ft.extended_exclude,
        }
    end,
}
