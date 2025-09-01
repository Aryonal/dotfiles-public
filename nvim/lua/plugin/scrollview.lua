return {
    "dstein64/nvim-scrollview",
    event = require("x.helper.lazy").events_presets.LazyFileAndVeryLazy,
    config = function()
        require("scrollview").setup({
            excluded_filetypes = require("config").ft.base_exclude,
            current_only = true,
            signs_on_startup = { "cursor", "diagnostics", "search" },
            diagnostics_severities = { vim.diagnostic.severity.ERROR }
        })
    end,
}
